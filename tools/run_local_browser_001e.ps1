$ErrorActionPreference = 'Stop'

Write-Host '=== NEXIA LOCAL-BROWSER-001E AUTH SESSION PERSISTENCE TEST ==='

$base = 'http://127.0.0.1:9222'
$chrome = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
$profile = "$env:LOCALAPPDATA\NEXIA\browser-profile"
$dashboard = 'https://www.workana.com/dashboard'
$target = $null
$ws = $null

function Invoke-Cdp {
    param(
        [Parameter(Mandatory=$true)] [System.Net.WebSockets.ClientWebSocket] $WebSocket,
        [Parameter(Mandatory=$true)] [int] $Id,
        [Parameter(Mandatory=$true)] [string] $Method,
        [hashtable] $Params
    )

    $payload = [ordered]@{ id = $Id; method = $Method }
    if ($null -ne $Params) { $payload['params'] = $Params }
    $json = $payload | ConvertTo-Json -Compress -Depth 20
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $segment = [System.ArraySegment[byte]]::new($bytes)
    $null = $WebSocket.SendAsync($segment,[System.Net.WebSockets.WebSocketMessageType]::Text,$true,[System.Threading.CancellationToken]::None).GetAwaiter().GetResult()

    while ($true) {
        $stream = New-Object System.IO.MemoryStream
        try {
            do {
                $buffer = New-Object byte[] 65536
                $receiveSegment = [System.ArraySegment[byte]]::new($buffer)
                $receive = $WebSocket.ReceiveAsync($receiveSegment,[System.Threading.CancellationToken]::None).GetAwaiter().GetResult()
                if ($receive.MessageType -eq [System.Net.WebSockets.WebSocketMessageType]::Close) { throw 'CDP WebSocket closed unexpectedly.' }
                $stream.Write($buffer,0,$receive.Count)
            } until ($receive.EndOfMessage)
            $text = [System.Text.Encoding]::UTF8.GetString($stream.ToArray())
            $message = $text | ConvertFrom-Json
            if (($null -ne $message.id) -and ([int]$message.id -eq $Id)) { return $message }
        }
        finally { $stream.Dispose() }
    }
}

try {
    try {
        $null = Invoke-RestMethod -Uri "$base/json/version" -TimeoutSec 2
        Write-Host 'PRECONDITION: FAIL - CDP browser is still running.'
        Write-Host 'Close the isolated NEXIA Chrome completely, wait a few seconds, then rerun this script.'
        Write-Host 'LOCAL_BROWSER_001E_RESULT: PRECONDITION_FAIL'
        exit 2
    }
    catch {
        Write-Host 'PRECONDITION_BROWSER_STOPPED: PASS'
    }

    if (-not (Test-Path $chrome)) { throw "Chrome not found at $chrome" }
    if (-not (Test-Path $profile)) { throw "NEXIA browser profile not found at $profile" }

    Start-Process -FilePath $chrome -ArgumentList @(
        '--remote-debugging-port=9222',
        '--remote-debugging-address=127.0.0.1',
        "--user-data-dir=$profile",
        '--no-first-run',
        '--no-default-browser-check',
        'about:blank'
    )

    $ready = $false
    for ($i = 0; $i -lt 20; $i++) {
        Start-Sleep -Milliseconds 750
        try {
            $version = Invoke-RestMethod -Uri "$base/json/version" -TimeoutSec 2
            $ready = $true
            break
        } catch {}
    }
    if (-not $ready) { throw 'Chrome CDP did not become ready after restart.' }

    Write-Host 'BROWSER_RESTART_WITH_SAME_PROFILE: PASS'
    Write-Host "Browser: $($version.Browser)"

    $encoded = [System.Uri]::EscapeDataString($dashboard)
    $target = Invoke-RestMethod -Method Put -Uri "$base/json/new?$encoded" -TimeoutSec 10
    if (-not $target.webSocketDebuggerUrl) { throw 'Dashboard target did not expose webSocketDebuggerUrl.' }
    Write-Host 'DASHBOARD_TARGET_CREATE: PASS'

    $ws = [System.Net.WebSockets.ClientWebSocket]::new()
    $ws.ConnectAsync([System.Uri]$target.webSocketDebuggerUrl,[System.Threading.CancellationToken]::None).GetAwaiter().GetResult()
    Write-Host 'WEBSOCKET_CONNECT: PASS'

    $state = $null
    for ($i = 0; $i -lt 20; $i++) {
        Start-Sleep -Milliseconds 750
        $r = Invoke-Cdp -WebSocket $ws -Id (100 + $i) -Method 'Runtime.evaluate' -Params @{
            expression = "({ready:document.readyState,url:location.href,title:document.title,hasPassword:!!document.querySelector('input[type=password]'),bodyLen:(document.body&&document.body.innerText?document.body.innerText.length:0)})"
            returnByValue = $true
        }
        $state = $r.result.result.value
        if (($state.ready -eq 'complete') -and ($state.bodyLen -gt 50)) { break }
    }

    Write-Host "FinalURL: $($state.url)"
    Write-Host "Title: $($state.title)"
    Write-Host "HasPasswordField: $($state.hasPassword)"
    Write-Host "BodyLength: $($state.bodyLen)"

    $isDashboard = ($state.url -like 'https://www.workana.com/dashboard*')
    $looksLogin = ($state.hasPassword -eq $true) -or ($state.url -match '(?i)(login|signin|sign-in|auth)')

    if ($isDashboard -and -not $looksLogin -and ($state.bodyLen -gt 50)) {
        Write-Host 'AUTH_SESSION_PERSISTENCE: PASS'
        Write-Host 'LOCAL_BROWSER_001E_RESULT: PASS'
    }
    else {
        Write-Host 'AUTH_SESSION_PERSISTENCE: FAIL'
        Write-Host 'LOCAL_BROWSER_001E_RESULT: FAIL'
    }
}
catch {
    Write-Host 'LOCAL_BROWSER_001E_RESULT: FAIL'
    Write-Host "ERROR: $($_.Exception.Message)"
}
finally {
    if ($null -ne $ws) { try { $ws.Dispose() } catch {} }
    if (($null -ne $target) -and $target.id) {
        try {
            $null = Invoke-WebRequest -Uri "$base/json/close/$($target.id)" -UseBasicParsing -TimeoutSec 5
            Write-Host 'TARGET_CLOSE: PASS'
        }
        catch {
            Write-Host 'TARGET_CLOSE: WARNING'
            Write-Host "CLOSE_ERROR: $($_.Exception.Message)"
        }
    }
}

Write-Host '=== END NEXIA LOCAL-BROWSER-001E AUTH SESSION PERSISTENCE TEST ==='
