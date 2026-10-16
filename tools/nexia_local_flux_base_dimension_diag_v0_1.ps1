# NEXIA FLUX BASE DIMENSION DIAG v0.1
# Compile-only diagnostic for the frozen BASE workflow. No queue submission and no image generation.
param()
$ErrorActionPreference='Stop'
Set-StrictMode -Version 2.0

$Seed=20261016
$ComfyBase='http://127.0.0.1:8188'
$CdpBase='http://127.0.0.1:9224'
$PinnedWorkflowCommit='04a508b31bec1818e48122ca0761c1de4140a234'
$T2IWorkflowUrl="https://raw.githubusercontent.com/Comfy-Org/workflow_templates/$PinnedWorkflowCommit/templates/image_flux2_klein_text_to_image.json"
$ProjectRoot='C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\creative-benchmark-2026-10-12\ComfyUI_windows_portable'
$ComfyRoot=Join-Path $ProjectRoot 'ComfyUI'
$PythonExe=Join-Path $ProjectRoot 'python_embeded\python.exe'
$ComfyMain=Join-Path $ComfyRoot 'main.py'
$OutputDir='C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\flux-edit-base-b1-b2-2026-10-16'
$BrowserProfile=Join-Path $env:LOCALAPPDATA 'NEXIA\flux-base-dimension-diag-001'
$Model='flux-2-klein-4b-fp8.safetensors'
$Clip='qwen_3_4b.safetensors'
$Vae='flux2-vae.safetensors'
$BasePrompt='A single matte dark-blue storage box with a black lid, centered on a light gray tabletop, neutral gray studio background, soft even lighting, realistic product photo, front three-quarter view, clean composition, no hands, no people, no extra objects, no text.'

$script:ComfyStarted=$false
$script:ComfyProcess=$null
$script:BrowserStarted=$false
$script:BrowserProcess=$null
$script:CdpSocket=$null
$script:CdpId=100

function Test-ComfyReady { try { $null=Invoke-RestMethod -Uri "$ComfyBase/system_stats" -TimeoutSec 3; $true } catch { $false } }
function Start-ComfyIfNeeded {
    if(Test-ComfyReady){return}
    $stdout=Join-Path $OutputDir 'comfyui.dimension-diag.stdout.log'
    $stderr=Join-Path $OutputDir 'comfyui.dimension-diag.stderr.log'
    $args=@('-s',$ComfyMain,'--windows-standalone-build','--listen','127.0.0.1','--port','8188','--disable-auto-launch')
    $script:ComfyProcess=Start-Process -FilePath $PythonExe -ArgumentList $args -WorkingDirectory $ComfyRoot -RedirectStandardOutput $stdout -RedirectStandardError $stderr -PassThru
    $script:ComfyStarted=$true
    for($i=0;$i -lt 180;$i++){ Start-Sleep -Seconds 1; if(Test-ComfyReady){return}; if($script:ComfyProcess.HasExited){throw "ComfyUI exited during startup. See $stderr"} }
    throw 'ComfyUI did not become ready.'
}
function Find-BrowserExe {
    foreach($p in @('C:\Program Files\Google\Chrome\Application\chrome.exe','C:\Program Files (x86)\Google\Chrome\Application\chrome.exe','C:\Program Files\Microsoft\Edge\Application\msedge.exe','C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe')){ if(Test-Path $p){return $p} }
    throw 'No existing Chrome/Edge executable found.'
}
function Invoke-Cdp {
    param([string]$Method,[hashtable]$Params)
    $script:CdpId++
    $payload=[ordered]@{id=$script:CdpId;method=$Method}; if($null-ne $Params){$payload.params=$Params}
    $bytes=[Text.Encoding]::UTF8.GetBytes(($payload|ConvertTo-Json -Compress -Depth 50))
    $null=$script:CdpSocket.SendAsync([ArraySegment[byte]]::new($bytes),[Net.WebSockets.WebSocketMessageType]::Text,$true,[Threading.CancellationToken]::None).GetAwaiter().GetResult()
    while($true){
        $stream=New-Object IO.MemoryStream
        try{
            do{
                $buffer=New-Object byte[] 65536
                $recv=$script:CdpSocket.ReceiveAsync([ArraySegment[byte]]::new($buffer),[Threading.CancellationToken]::None).GetAwaiter().GetResult()
                if($recv.MessageType -eq [Net.WebSockets.WebSocketMessageType]::Close){throw 'CDP socket closed.'}
                $stream.Write($buffer,0,$recv.Count)
            }until($recv.EndOfMessage)
            $msg=([Text.Encoding]::UTF8.GetString($stream.ToArray()))|ConvertFrom-Json
            $idProp=$msg.PSObject.Properties['id']
            if($null-ne $idProp -and [int]$idProp.Value -eq $script:CdpId){return $msg}
        }finally{$stream.Dispose()}
    }
}
function Invoke-Js([string]$Expression){
    $r=Invoke-Cdp -Method 'Runtime.evaluate' -Params @{expression=$Expression;returnByValue=$true;awaitPromise=$true}
    $top=$r.PSObject.Properties['result']; if($null-eq $top -or $null-eq $top.Value){throw 'CDP response missing result.'}
    $eval=$top.Value
    $exc=$eval.PSObject.Properties['exceptionDetails']; if($null-ne $exc -and $null-ne $exc.Value){throw 'Browser JS exception.'}
    $remote=$eval.PSObject.Properties['result']; if($null-eq $remote -or $null-eq $remote.Value){throw 'CDP response missing remote result.'}
    $value=$remote.Value.PSObject.Properties['value']; if($null-eq $value){return $null}; return $value.Value
}
function Start-ComfyBrowser {
    $exe=Find-BrowserExe
    if(Test-Path $BrowserProfile){Remove-Item $BrowserProfile -Recurse -Force -ErrorAction SilentlyContinue}
    New-Item $BrowserProfile -ItemType Directory -Force|Out-Null
    $script:BrowserProcess=Start-Process -FilePath $exe -ArgumentList @('--remote-debugging-port=9224','--remote-debugging-address=127.0.0.1',"--user-data-dir=$BrowserProfile",'--no-first-run','--no-default-browser-check',$ComfyBase) -PassThru
    $script:BrowserStarted=$true
    $target=$null
    for($i=0;$i -lt 120;$i++){ Start-Sleep -Milliseconds 500; try{ $targets=Invoke-RestMethod -Uri "$CdpBase/json/list" -TimeoutSec 2; $candidate=@($targets|Where-Object{$_.type -eq 'page' -and ([string]$_.url).StartsWith($ComfyBase)}|Select-Object -First 1); if($candidate.Count -gt 0 -and $candidate[0].webSocketDebuggerUrl){$target=$candidate;break} }catch{} }
    if(-not $target){throw 'No ComfyUI CDP target found.'}
    Write-Host ("CDP_TARGET_URL: {0}" -f $target[0].url)
    $script:CdpSocket=[Net.WebSockets.ClientWebSocket]::new()
    $null=$script:CdpSocket.ConnectAsync([Uri]$target[0].webSocketDebuggerUrl,[Threading.CancellationToken]::None).GetAwaiter().GetResult()
    for($i=0;$i -lt 120;$i++){ Start-Sleep -Milliseconds 250; try{ $raw=Invoke-Js "JSON.stringify({ready:document.readyState,app:!!window.app,load:!!(window.app&&window.app.loadGraphData),compile:!!(window.app&&window.app.graphToPrompt)})"; $o=$raw|ConvertFrom-Json; if($o.ready -eq 'complete' -and $o.app -and $o.load -and $o.compile){return} }catch{} }
    throw 'Frontend did not become ready.'
}
function Cleanup {
    if($null-ne $script:CdpSocket){try{$script:CdpSocket.Dispose()}catch{}}
    if($script:BrowserStarted){try{Get-CimInstance Win32_Process|Where-Object{$_.CommandLine -and $_.CommandLine.Contains($BrowserProfile)}|ForEach-Object{Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue}}catch{}}
    if($script:ComfyStarted -and $null-ne $script:ComfyProcess -and -not $script:ComfyProcess.HasExited){try{Stop-Process -Id $script:ComfyProcess.Id -Force -ErrorAction SilentlyContinue}catch{}}
}
try{
    Write-Host '=== NEXIA FLUX BASE DIMENSION DIAG v0.1 ==='
    Write-Host 'SCOPE: compile BASE only; no queue; no prompt submission to Comfy backend; no generation.'
    New-Item $OutputDir -ItemType Directory -Force|Out-Null
    Start-ComfyIfNeeded
    Write-Host 'COMFY_READY: TRUE'
    Start-ComfyBrowser
    $wfPath=Join-Path $OutputDir 'dimension-diag.t2i-template.json'
    Invoke-WebRequest -Uri $T2IWorkflowUrl -UseBasicParsing -OutFile $wfPath
    $template=Get-Content $wfPath -Raw
    $null=$template|ConvertFrom-Json
    $wf64=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($template))
    $cfg=[ordered]@{prompt=$BasePrompt;seed=$Seed;width=1024;height=1024;unet=$Model;clip=$Clip;vae=$Vae}|ConvertTo-Json -Compress
    $cfg64=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($cfg))
    $js=@"
(async()=>{
 const dec=b=>new TextDecoder().decode(Uint8Array.from(atob(b),c=>c.charCodeAt(0)));
 const wf=JSON.parse(dec('$wf64')); const c=JSON.parse(dec('$cfg64'));
 await window.app.loadGraphData(wf,true,true,null,{openSource:'template'}); await new Promise(r=>setTimeout(r,400));
 const g=window.app.graph; const setv=(n,name,idx,v)=>{if(!n)throw new Error('missing node');let w=(n.widgets||[]).find(x=>x.name===name);if(!w&&Number.isInteger(idx))w=(n.widgets||[])[idx];if(!w)throw new Error('missing widget '+name);w.value=v;};
 const p=g.getNodeById(76); setv(p,'text',0,c.prompt);
 const legacy=g.getNodeById(75); if(legacy)legacy.mode=4; const legacySave=g.getNodeById(9); if(legacySave)legacySave.mode=4;
 const n=g.getNodeById(77); if(!n)throw new Error('missing distilled BASE node 77'); n.mode=0;
 setv(n,'value',null,c.width); setv(n,'value_1',null,c.height); setv(n,'unet_name',null,c.unet); setv(n,'clip_name',null,c.clip); setv(n,'vae_name',null,c.vae); setv(n,'noise_seed',null,c.seed);
 const f=(n.widgets||[]).find(x=>x.name==='control_after_generate'); if(f)f.value='fixed'; const s=g.getNodeById(78); if(!s)throw new Error('missing SaveImage 78'); s.mode=0;
 const compiled=await window.app.graphToPrompt(); return JSON.stringify({output:compiled.output});
})()
"@
    $raw=Invoke-Js $js
    $obj=$raw|ConvertFrom-Json
    $nodes=@($obj.output.PSObject.Properties|ForEach-Object{$_.Value})
    $candidates=@()
    foreach($nodeProp in $obj.output.PSObject.Properties){
        $node=$nodeProp.Value; $inputsProp=$node.PSObject.Properties['inputs']; if($null-eq $inputsProp -or $null-eq $inputsProp.Value){continue}
        $inputs=$inputsProp.Value; $wp=$inputs.PSObject.Properties['width']; $hp=$inputs.PSObject.Properties['height']; if($null-eq $wp -or $null-eq $hp){continue}
        $w=$wp.Value; $h=$hp.Value
        $wType=if($null-eq $w){'NULL'}else{$w.GetType().FullName}; $hType=if($null-eq $h){'NULL'}else{$h.GetType().FullName}
        $wJson=$w|ConvertTo-Json -Compress -Depth 20; $hJson=$h|ConvertTo-Json -Compress -Depth 20
        $entry=[ordered]@{node_id=$nodeProp.Name;class_type=$node.class_type;width_type=$wType;width_json=$wJson;height_type=$hType;height_json=$hJson}
        if($w -is [System.Array] -and $w.Count -ge 1){ $srcId=[string]$w[0]; $srcProp=$obj.output.PSObject.Properties[$srcId]; if($null-ne $srcProp){$entry.width_source_node=$srcProp.Value} }
        if($h -is [System.Array] -and $h.Count -ge 1){ $srcId=[string]$h[0]; $srcProp=$obj.output.PSObject.Properties[$srcId]; if($null-ne $srcProp){$entry.height_source_node=$srcProp.Value} }
        $candidates += [pscustomobject]$entry
    }
    Write-Host ("DIMENSION_CANDIDATE_COUNT: {0}" -f $candidates.Count)
    Write-Host 'DIMENSION_CANDIDATES_JSON:'
    Write-Host ($candidates|ConvertTo-Json -Compress -Depth 30)
    Write-Host 'NO_QUEUE_SUBMITTED: TRUE'
    Write-Host 'GENERATIONS_EXECUTED_BY_DIAG: 0'
    Write-Host '=== END NEXIA FLUX BASE DIMENSION DIAG v0.1 ==='
}
finally{Cleanup}
