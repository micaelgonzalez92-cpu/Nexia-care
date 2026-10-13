param(
    [string]$TaskUrl = 'https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/main/NEXIA_LOCAL_EXECUTION_TASK.json'
)

$ErrorActionPreference = 'Stop'

Write-Host '=== NEXIA LOCAL-EXECUTION-BRIDGE-001 ==='

$base = 'http://127.0.0.1:9222'
$chrome = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
$profile = "$env:LOCALAPPDATA\NEXIA\browser-profile"
$target = $null
$ws = $null
$startedChrome = $false

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
    $null = $WebSocket.SendAsync(
        $segment,
        [System.Net.WebSockets.WebSocketMessageType]::Text,
        $true,
        [System.Threading.CancellationToken]::None
    ).GetAwaiter().GetResult()

    while ($true) {
        $stream = New-Object System.IO.MemoryStream
        try {
            do {
                $buffer = New-Object byte[] 65536
                $receiveSegment = [System.ArraySegment[byte]]::new($buffer)
                $receive = $WebSocket.ReceiveAsync(
                    $receiveSegment,
                    [System.Threading.CancellationToken]::None
                ).GetAwaiter().GetResult()
                if ($receive.MessageType -eq [System.Net.WebSockets.WebSocketMessageType]::Close) {
                    throw 'CDP WebSocket closed unexpectedly.'
                }
                $stream.Write($buffer, 0, $receive.Count)
            } until ($receive.EndOfMessage)

            $text = [System.Text.Encoding]::UTF8.GetString($stream.ToArray())
            $message = $text | ConvertFrom-Json
            if (($null -ne $message.id) -and ([int]$message.id -eq $Id)) {
                return $message
            }
        }
        finally {
            $stream.Dispose()
        }
    }
}

function Start-NexiaChromeIfNeeded {
    try {
        return Invoke-RestMethod -Uri "$base/json/version" -TimeoutSec 2
    }
    catch {
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
        $script:startedChrome = $true

        for ($i = 0; $i -lt 20; $i++) {
            Start-Sleep -Milliseconds 750
            try {
                return Invoke-RestMethod -Uri "$base/json/version" -TimeoutSec 2
            }
            catch {}
        }
        throw 'Chrome CDP did not become ready.'
    }
}

try {
    Write-Host 'TASK_FETCH: START'
    $task = Invoke-RestMethod -Uri $TaskUrl -TimeoutSec 15
    Write-Host "TASK_FETCH: PASS | id=$($task.task_id)"

    if ($task.action -ne 'AUTHENTICATED_READ_ONLY_PAGE_PROBE') {
        throw "Unsupported task action: $($task.action)"
    }
    if ($task.read_only -ne $true) {
        throw 'Task is not explicitly read-only.'
    }
    if (($null -ne $task.effects) -and @($task.effects).Count -gt 0) {
        throw 'Task effects must be empty for bridge v0.1.'
    }

    $uri = [System.Uri]$task.url
    if ($uri.Scheme -ne 'https') { throw 'Only HTTPS targets are allowed.' }
    if ($uri.Host -ne $task.allowed_host) { throw 'Target host does not match allowed_host.' }
    if ($task.allowed_host -ne 'www.workana.com') { throw 'Bridge v0.1 allowlist only permits www.workana.com.' }

    Write-Host 'TASK_POLICY: PASS'

    $version = Start-NexiaChromeIfNeeded
    Write-Host "BROWSER_READY: PASS | $($version.Browser)"

    $encoded = [System.Uri]::EscapeDataString([string]$task.url)
    $target = Invoke-RestMethod -Method Put -Uri "$base/json/new?$encoded" -TimeoutSec 10
    if (-not $target.webSocketDebuggerUrl) { throw 'Target did not expose webSocketDebuggerUrl.' }
    Write-Host 'TARGET_CREATE: PASS'

    $ws = [System.Net.WebSockets.ClientWebSocket]::new()
    $ws.ConnectAsync(
        [System.Uri]$target.webSocketDebuggerUrl,
        [System.Threading.CancellationToken]::None
    ).GetAwaiter().GetResult()
    Write-Host 'WEBSOCKET_CONNECT: PASS'

    $state = $null
    for ($i = 0; $i -lt 24; $i++) {
        Start-Sleep -Milliseconds 750
        $r = Invoke-Cdp -WebSocket $ws -Id (200 + $i) -Method 'Runtime.evaluate' -Params @{
            expression = "({ready:document.readyState,url:location.href,title:document.title,hasPassword:!!document.querySelector('input[type=password]'),bodyLen:(document.body&&document.body.innerText?document.body.innerText.length:0)})"
            returnByValue = $true
        }
        $state = $r.result.result.value
        if (($state.ready -eq 'complete') -and ($state.bodyLen -ge [int]$task.min_body_length)) { break }
    }

    if ($null -eq $state) { throw 'No page state returned.' }

    $prefixOk = ([string]$state.url).StartsWith([string]$task.expected_url_prefix, [System.StringComparison]::OrdinalIgnoreCase)
    $passwordOk = (-not [bool]$task.forbid_password_field) -or (-not [bool]$state.hasPassword)
    $bodyOk = ([int]$state.bodyLen -ge [int]$task.min_body_length)
    $authOk = $prefixOk -and $passwordOk -and $bodyOk

    $result = [ordered]@{
        task_id = [string]$task.task_id
        status = $(if ($authOk) { 'PASS' } else { 'FAIL' })
        final_url = [string]$state.url
        title = [string]$state.title
        has_password_field = [bool]$state.hasPassword
        body_length = [int]$state.bodyLen
        authenticated_read_only = [bool]$authOk
        browser = [string]$version.Browser
    }

    Write-Host 'SANITIZED_RESULT_JSON_BEGIN'
    $result | ConvertTo-Json -Depth 5
    Write-Host 'SANITIZED_RESULT_JSON_END'

    if ($authOk) {
        Write-Host 'LOCAL_EXECUTION_BRIDGE_RESULT: PASS'
    }
    else {
        Write-Host 'LOCAL_EXECUTION_BRIDGE_RESULT: FAIL'
    }
}
catch {
    Write-Host 'LOCAL_EXECUTION_BRIDGE_RESULT: FAIL'
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

Write-Host '=== END NEXIA LOCAL-EXECUTION-BRIDGE-001 ==='
