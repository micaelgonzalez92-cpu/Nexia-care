$ErrorActionPreference = 'Stop'

Write-Host '=== NEXIA LOCAL-BROWSER-001D DOM CONTROL TEST ==='

$base = 'http://127.0.0.1:9222'
$target = $null
$ws = $null

function Invoke-Cdp {
    param(
        [Parameter(Mandatory=$true)] [System.Net.WebSockets.ClientWebSocket] $WebSocket,
        [Parameter(Mandatory=$true)] [int] $Id,
        [Parameter(Mandatory=$true)] [string] $Method,
        [hashtable] $Params
    )

    $payload = [ordered]@{
        id = $Id
        method = $Method
    }
    if ($null -ne $Params) {
        $payload['params'] = $Params
    }

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

try {
    $version = Invoke-RestMethod -Uri "$base/json/version" -TimeoutSec 5
    Write-Host 'CDP_REACHABLE: PASS'
    Write-Host "Browser: $($version.Browser)"

    $target = Invoke-RestMethod -Method Put -Uri "$base/json/new?about:blank" -TimeoutSec 10
    if (-not $target.webSocketDebuggerUrl) {
        throw 'Target did not expose webSocketDebuggerUrl.'
    }
    Write-Host 'TARGET_CREATE: PASS'

    $ws = [System.Net.WebSockets.ClientWebSocket]::new()
    $ws.ConnectAsync(
        [System.Uri]$target.webSocketDebuggerUrl,
        [System.Threading.CancellationToken]::None
    ).GetAwaiter().GetResult()
    Write-Host 'WEBSOCKET_CONNECT: PASS'

    $inject = @"
document.body.innerHTML = '<label for="name">Name</label><input id="name"><button id="go">Go</button><div id="result"></div>';
document.getElementById('go').addEventListener('click', function () {
    document.getElementById('result').textContent = 'clicked:' + document.getElementById('name').value;
    document.title = 'NEXIA_CLICKED';
});
'INJECTED';
"@

    $injectResult = Invoke-Cdp -WebSocket $ws -Id 1 -Method 'Runtime.evaluate' -Params @{
        expression = $inject
        returnByValue = $true
    }

    if ($injectResult.result.result.value -ne 'INJECTED') {
        throw 'Synthetic DOM injection did not return expected marker.'
    }
    Write-Host 'DOM_INJECT: PASS'

    $readResult = Invoke-Cdp -WebSocket $ws -Id 2 -Method 'Runtime.evaluate' -Params @{
        expression = "({hasInput: !!document.querySelector('#name'), hasButton: !!document.querySelector('#go'), title: document.title})"
        returnByValue = $true
    }

    $initial = $readResult.result.result.value
    if (-not $initial.hasInput -or -not $initial.hasButton) {
        throw 'Expected synthetic DOM controls were not readable.'
    }
    Write-Host 'DOM_READ: PASS'

    $action = @"
document.querySelector('#name').value = 'Kael';
document.querySelector('#name').dispatchEvent(new Event('input', {bubbles:true}));
document.querySelector('#go').click();
({
    title: document.title,
    inputValue: document.querySelector('#name').value,
    resultText: document.querySelector('#result').textContent
});
"@

    $actionResult = Invoke-Cdp -WebSocket $ws -Id 3 -Method 'Runtime.evaluate' -Params @{
        expression = $action
        returnByValue = $true
    }

    $state = $actionResult.result.result.value
    Write-Host "Title: $($state.title)"
    Write-Host "InputValue: $($state.inputValue)"
    Write-Host "ResultText: $($state.resultText)"

    if (($state.title -eq 'NEXIA_CLICKED') -and
        ($state.inputValue -eq 'Kael') -and
        ($state.resultText -eq 'clicked:Kael')) {
        Write-Host 'DOM_FILL_CLICK_RESULT: PASS'
    }
    else {
        throw 'DOM interaction result did not match expected state.'
    }

    Write-Host 'LOCAL_BROWSER_001D_RESULT: PASS'
}
catch {
    Write-Host 'LOCAL_BROWSER_001D_RESULT: FAIL'
    Write-Host "ERROR: $($_.Exception.Message)"
}
finally {
    if ($null -ne $ws) {
        try { $ws.Dispose() } catch {}
    }

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

Write-Host '=== END NEXIA LOCAL-BROWSER-001D DOM CONTROL TEST ==='
