# NEXIA bounded ComfyUI frontend CDP readiness diagnostic v0.2
# Fixes v0.1 diagnostic output contamination by suppressing ClientWebSocket ConnectAsync VoidTaskResult.
# Starts existing ComfyUI and isolated existing Chrome/Edge only to observe frontend readiness.
# No workflow load, no prompt submission, no generation, no installs, no downloads.

param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$ProjectRoot = 'C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\creative-benchmark-2026-10-12\ComfyUI_windows_portable'
$ComfyRoot = Join-Path $ProjectRoot 'ComfyUI'
$PythonExe = Join-Path $ProjectRoot 'python_embeded\python.exe'
$ComfyMain = Join-Path $ComfyRoot 'main.py'
$OutputDir = 'C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\flux-edit-base-b1-b2-2026-10-16'
$ComfyBase = 'http://127.0.0.1:8188'
$CdpBase = 'http://127.0.0.1:9224'
$BrowserProfile = Join-Path $env:LOCALAPPDATA 'NEXIA\flux-frontend-diag-profile-002'
$Stdout = Join-Path $OutputDir 'comfyui.frontend-diag-v02.stdout.log'
$Stderr = Join-Path $OutputDir 'comfyui.frontend-diag-v02.stderr.log'

function Test-ComfyReady {
    try { $null = Invoke-RestMethod -Uri "$ComfyBase/system_stats" -Method Get -TimeoutSec 3; return $true } catch { return $false }
}
function Find-BrowserExe {
    foreach ($p in @(
        'C:\Program Files\Google\Chrome\Application\chrome.exe',
        'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe',
        'C:\Program Files\Microsoft\Edge\Application\msedge.exe',
        'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
    )) { if (Test-Path $p) { return $p } }
    throw 'No existing Chrome/Edge executable found.'
}
function Invoke-CdpEval {
    param([string]$WsUrl,[string]$Expression)
    $ws = [System.Net.WebSockets.ClientWebSocket]::new()
    try {
        $null = $ws.ConnectAsync([Uri]$WsUrl,[Threading.CancellationToken]::None).GetAwaiter().GetResult()
        $id = 1
        $payload = @{id=$id;method='Runtime.evaluate';params=@{expression=$Expression;returnByValue=$true;awaitPromise=$true}} | ConvertTo-Json -Compress -Depth 20
        $bytes=[Text.Encoding]::UTF8.GetBytes($payload)
        $seg=[ArraySegment[byte]]::new($bytes)
        $null = $ws.SendAsync($seg,[Net.WebSockets.WebSocketMessageType]::Text,$true,[Threading.CancellationToken]::None).GetAwaiter().GetResult()
        while($true){
            $ms=New-Object IO.MemoryStream
            try {
                do {
                    $buf=New-Object byte[] 65536
                    $r=$ws.ReceiveAsync([ArraySegment[byte]]::new($buf),[Threading.CancellationToken]::None).GetAwaiter().GetResult()
                    if($r.MessageType -eq [Net.WebSockets.WebSocketMessageType]::Close){throw 'CDP socket closed'}
                    $ms.Write($buf,0,$r.Count)
                } until($r.EndOfMessage)
                $msg=([Text.Encoding]::UTF8.GetString($ms.ToArray())) | ConvertFrom-Json
                if($msg.id -eq $id){ return [string]$msg.result.result.value }
            } finally { $ms.Dispose() }
        }
    } finally { $ws.Dispose() }
}

Write-Host '=== NEXIA COMFY FRONTEND CDP DIAG v0.2 ==='
Write-Host 'SCOPE: readiness observation only; no workflow load; no prompt; no generation.'
New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null

$comfyProc=$null; $startedComfy=$false; $startedBrowser=$false
try {
    if(-not (Test-ComfyReady)){
        $args=@('-s',$ComfyMain,'--windows-standalone-build','--listen','127.0.0.1','--port','8188','--disable-auto-launch')
        $comfyProc=Start-Process -FilePath $PythonExe -ArgumentList $args -WorkingDirectory $ComfyRoot -RedirectStandardOutput $Stdout -RedirectStandardError $Stderr -PassThru
        $startedComfy=$true
        for($i=0;$i -lt 180;$i++){ Start-Sleep 1; if(Test-ComfyReady){break}; if($comfyProc.HasExited){throw "ComfyUI exited before readiness; exit=$($comfyProc.ExitCode)"} }
        if(-not (Test-ComfyReady)){throw 'ComfyUI did not become ready within 180 seconds'}
    }
    Write-Host 'COMFY_READY: TRUE'

    if(Test-Path $BrowserProfile){Remove-Item $BrowserProfile -Recurse -Force -ErrorAction SilentlyContinue}
    New-Item $BrowserProfile -ItemType Directory -Force | Out-Null
    $exe=Find-BrowserExe
    $null=Start-Process -FilePath $exe -ArgumentList @('--remote-debugging-port=9224','--remote-debugging-address=127.0.0.1',"--user-data-dir=$BrowserProfile",'--no-first-run','--no-default-browser-check',$ComfyBase) -PassThru
    $startedBrowser=$true

    $target=$null
    for($i=0;$i -lt 120;$i++){
        Start-Sleep -Milliseconds 500
        try {
            $targets=Invoke-RestMethod -Uri "$CdpBase/json/list" -TimeoutSec 2
            $target=@($targets | Where-Object {$_.type -eq 'page' -and ([string]$_.url).StartsWith($ComfyBase)} | Select-Object -First 1)
            if($target.Count -gt 0 -and $target[0].webSocketDebuggerUrl){break}
        } catch {}
    }
    if(-not $target -or $target.Count -eq 0){throw 'No ComfyUI CDP page target found'}
    Write-Host ("CDP_TARGET_URL: {0}" -f $target[0].url)

    $sw=[Diagnostics.Stopwatch]::StartNew(); $last=$null; $ready=$false; $firstApp=$null; $firstMethods=$null
    for($i=0;$i -lt 240;$i++){
        Start-Sleep -Milliseconds 500
        try {
            $expr="JSON.stringify({ready:document.readyState,title:document.title,href:location.href,app:!!window.app,appType:typeof window.app,load:!!(window.app&&window.app.loadGraphData),compile:!!(window.app&&window.app.graphToPrompt),graph:!!(window.app&&window.app.graph),rootGraph:!!(window.app&&window.app.rootGraph),isGraphReady:(window.app&&'isGraphReady' in window.app)?window.app.isGraphReady:null,keys:window.app?Object.keys(window.app).slice(0,40):[]})"
            $last=Invoke-CdpEval -WsUrl $target[0].webSocketDebuggerUrl -Expression $expr
            $o=$last | ConvertFrom-Json
            if($null -eq $firstApp -and $o.app){$firstApp=[math]::Round($sw.Elapsed.TotalSeconds,3)}
            if($o.app -and $o.load -and $o.compile){$firstMethods=[math]::Round($sw.Elapsed.TotalSeconds,3);$ready=$true;break}
        } catch {
            $last = "PROBE_ERROR: $($_.Exception.Message)"
        }
    }
    $sw.Stop()
    Write-Host ("FRONTEND_READY_METHODS: {0}" -f $ready.ToString().ToUpperInvariant())
    if($null -ne $firstApp){Write-Host ("FRONTEND_FIRST_APP_SECONDS: {0}" -f $firstApp)}
    if($null -ne $firstMethods){Write-Host ("FRONTEND_FIRST_METHODS_SECONDS: {0}" -f $firstMethods)}
    Write-Host ("FRONTEND_OBSERVE_SECONDS: {0}" -f ([math]::Round($sw.Elapsed.TotalSeconds,3)))
    Write-Host 'FRONTEND_LAST_STATE:'
    if($last){Write-Host $last}else{Write-Host 'NO_STATE_CAPTURED'}
    Write-Host 'NO_WORKFLOW_LOADED_BY_DIAG: TRUE'
    Write-Host 'NO_PROMPT_SUBMITTED: TRUE'
    Write-Host 'GENERATIONS_EXECUTED_BY_DIAG: 0'
    if(-not $ready){exit 2}
}
finally {
    if($startedBrowser){ try { Get-CimInstance Win32_Process | Where-Object {$_.CommandLine -and $_.CommandLine.Contains($BrowserProfile)} | ForEach-Object {Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue} } catch {}; Start-Sleep -Milliseconds 500; Remove-Item $BrowserProfile -Recurse -Force -ErrorAction SilentlyContinue }
    if($startedComfy -and $comfyProc){ try {if(-not $comfyProc.HasExited){Stop-Process -Id $comfyProc.Id -Force -ErrorAction SilentlyContinue}} catch {} }
    Write-Host '=== END NEXIA COMFY FRONTEND CDP DIAG v0.2 ==='
}
