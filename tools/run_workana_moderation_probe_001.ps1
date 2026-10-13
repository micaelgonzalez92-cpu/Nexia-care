$ErrorActionPreference = 'Stop'

Write-Host '=== NEXIA WORKANA-MODERATION-PROBE-001 ==='

$repo = 'micaelgonzalez92-cpu/Nexia-care'
$challengePath = 'NEXIA_WORKANA_MODERATION_CHALLENGE.json'
$endpoint = "repos/$repo/contents/$challengePath"
$nonce = 'NEXIA-WORKANA-MOD-001-20261013-A91D'
$base = 'http://127.0.0.1:9222'
$chrome = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
$profile = "$env:LOCALAPPDATA\NEXIA\browser-profile"
$tempBody = Join-Path $env:TEMP 'nexia_workana_moderation_probe_001_body.json'
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

            $message = ([System.Text.Encoding]::UTF8.GetString($stream.ToArray())) | ConvertFrom-Json
            if (($null -ne $message.id) -and ([int]$message.id -eq $Id)) { return $message }
        }
        finally { $stream.Dispose() }
    }
}

function Start-NexiaChromeIfNeeded {
    try { return Invoke-RestMethod -Uri "$base/json/version" -TimeoutSec 2 }
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
        for ($i=0; $i -lt 20; $i++) {
            Start-Sleep -Milliseconds 750
            try { return Invoke-RestMethod -Uri "$base/json/version" -TimeoutSec 2 } catch {}
        }
        throw 'Chrome CDP did not become ready.'
    }
}

try {
    $gh = (Get-Command gh -ErrorAction Stop).Source
    & $gh auth status --hostname github.com 1>$null 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'GitHub CLI is not authenticated.' }
    Write-Host 'GH_AUTH: PASS'

    $challengeRaw = & $gh api $endpoint 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'Cannot fetch challenge.' }
    $challengeResponse = $challengeRaw | ConvertFrom-Json
    $challengeDecoded = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(($challengeResponse.content -replace '\s',''))) | ConvertFrom-Json
    if ($challengeDecoded.challenge_id -ne 'WORKANA-MODERATION-PROBE-001' -or $challengeDecoded.nonce -ne $nonce -or $challengeDecoded.status -ne 'READY') {
        throw 'Challenge contract is not READY.'
    }
    Write-Host 'CHALLENGE_READY: PASS'

    $version = Start-NexiaChromeIfNeeded
    Write-Host "BROWSER_READY: PASS | $($version.Browser)"

    $url = [System.Uri]::EscapeDataString('https://www.workana.com/dashboard')
    $target = Invoke-RestMethod -Method Put -Uri "$base/json/new?$url" -TimeoutSec 10
    if (-not $target.webSocketDebuggerUrl) { throw 'Target WebSocket unavailable.' }

    $ws = [System.Net.WebSockets.ClientWebSocket]::new()
    $ws.ConnectAsync([System.Uri]$target.webSocketDebuggerUrl,[System.Threading.CancellationToken]::None).GetAwaiter().GetResult()

    $state = $null
    for ($i=0; $i -lt 24; $i++) {
        Start-Sleep -Milliseconds 750
        $expr = @'
(() => {
  const raw = (document.body && document.body.innerText ? document.body.innerText : '');
  const norm = raw.normalize('NFD').replace(/[\u0300-\u036f]/g,'').toLowerCase();
  const has = (arr) => arr.some(x => norm.includes(x));
  const rejected = [
    'tu perfil ha sido rechazado','perfil rechazado','perfil no aprobado','your profile has been rejected','profile rejected'
  ];
  const approved = [
    'tu perfil ha sido aprobado','perfil aprobado','your profile has been approved','profile approved'
  ];
  const pending = [
    'tu perfil esta siendo analizado','perfil en analisis','perfil esta en revision','perfil bajo revision','profile under review','profile is under review'
  ];
  let classification = 'UNKNOWN';
  if (has(rejected)) classification = 'REJECTED_EXPLICIT';
  else if (has(approved)) classification = 'APPROVED_EXPLICIT';
  else if (has(pending)) classification = 'PENDING_SIGNAL';
  return {
    ready: document.readyState,
    url: location.href,
    title: document.title,
    bodyLen: raw.length,
    hasPassword: !!document.querySelector('input[type=password]'),
    classification,
    rejectedMarker: has(rejected),
    approvedMarker: has(approved),
    pendingMarker: has(pending)
  };
})()
'@
        $r = Invoke-Cdp -WebSocket $ws -Id (700+$i) -Method 'Runtime.evaluate' -Params @{ expression=$expr; returnByValue=$true }
        $state = $r.result.result.value
        if (($state.ready -eq 'complete') -and ([int]$state.bodyLen -ge 50)) { break }
    }

    if ($null -eq $state) { throw 'No page state returned.' }
    if (-not ([string]$state.url).StartsWith('https://www.workana.com/dashboard',[System.StringComparison]::OrdinalIgnoreCase)) { throw 'Unexpected final URL.' }
    if ([bool]$state.hasPassword) { throw 'Password field present; authenticated read-only contract failed.' }

    $result = [ordered]@{
        schema_version = 1
        challenge_id = 'WORKANA-MODERATION-PROBE-001'
        nonce = $nonce
        status = 'PASS'
        source = 'NEXIA_LOCAL_PC'
        transport = 'GH_API'
        final_url = [string]$state.url
        title = [string]$state.title
        body_length = [int]$state.bodyLen
        authenticated_read_only = $true
        moderation_classification = [string]$state.classification
        explicit_approved_marker = [bool]$state.approvedMarker
        explicit_rejected_marker = [bool]$state.rejectedMarker
        pending_marker = [bool]$state.pendingMarker
        sanitized = $true
        contains_secrets = $false
        external_side_effects = @()
        cash_spend_eur = 0
        timestamp_utc = [DateTime]::UtcNow.ToString('o')
        truth_limit = 'APPROVED_EXPLICIT is valid only if the explicit approval marker is true. UNKNOWN is not approval or rejection.'
    }

    $json = $result | ConvertTo-Json -Depth 7
    $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($json))
    $request = [ordered]@{
        message = 'nexia: Workana moderation read-only probe result'
        content = $b64
        sha = [string]$challengeResponse.sha
        branch = 'main'
    } | ConvertTo-Json -Compress -Depth 7
    [IO.File]::WriteAllText($tempBody,$request,[Text.UTF8Encoding]::new($false))

    $null = & $gh api --method PUT $endpoint --input $tempBody
    if ($LASTEXITCODE -ne 0) { throw 'GitHub result writeback failed.' }

    Write-Host "MODERATION_CLASSIFICATION: $($state.classification)"
    Write-Host 'GH_WRITEBACK: PASS'
    Write-Host 'WORKANA_MODERATION_PROBE_001_RESULT: PASS'
}
catch {
    Write-Host 'WORKANA_MODERATION_PROBE_001_RESULT: FAIL'
    Write-Host "ERROR: $($_.Exception.Message)"
}
finally {
    if ($null -ne $ws) { try { $ws.Dispose() } catch {} }
    if (($null -ne $target) -and $target.id) {
        try { $null = Invoke-WebRequest -Uri "$base/json/close/$($target.id)" -UseBasicParsing -TimeoutSec 5 } catch {}
    }
    Remove-Item $tempBody -Force -ErrorAction SilentlyContinue
}

Write-Host '=== END NEXIA WORKANA-MODERATION-PROBE-001 ==='
