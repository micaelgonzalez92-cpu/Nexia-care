$ErrorActionPreference = 'Stop'

Write-Host '=== NEXIA LOCAL-BRIDGE-INTEGRATED-002 ==='

$repo = 'micaelgonzalez92-cpu/Nexia-care'
$challengePath = 'NEXIA_LOCAL_BRIDGE_INTEGRATED_CHALLENGE.json'
$challengeEndpoint = "repos/$repo/contents/$challengePath"
$expectedNonce = 'NEXIA-INT-002-20261013-C4E8'
$bridgeUrl = 'https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/main/tools/nexia_local_execution_bridge_v0_1.ps1'
$taskUrl = 'https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/main/NEXIA_LOCAL_EXECUTION_TASK.json'
$bridgeFile = Join-Path $env:TEMP 'nexia_local_execution_bridge_v0_1.ps1'
$tempBody = Join-Path $env:TEMP 'nexia_local_bridge_integrated_002_body.json'

try {
    $gh = Get-Command gh -ErrorAction Stop
    Write-Host "GH_FOUND: PASS | $($gh.Source)"

    & gh auth status --hostname github.com 1>$null 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'GitHub CLI is not authenticated.' }
    Write-Host 'GH_AUTH: PASS'

    $challengeRaw = & gh api $challengeEndpoint 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'Cannot fetch integrated challenge via gh api.' }
    $challengeResponse = $challengeRaw | ConvertFrom-Json
    $challengeDecoded = [System.Text.Encoding]::UTF8.GetString(
        [Convert]::FromBase64String(($challengeResponse.content -replace '\s',''))
    )
    $challenge = $challengeDecoded | ConvertFrom-Json

    if ($challenge.challenge_id -ne 'LOCAL-BRIDGE-INTEGRATED-002') { throw 'Unexpected challenge_id.' }
    if ($challenge.nonce -ne $expectedNonce) { throw 'Integrated challenge nonce mismatch.' }
    if ($challenge.status -ne 'READY') { throw "Challenge is not READY; current status=$($challenge.status)" }
    Write-Host 'CHALLENGE_READ: PASS'

    Invoke-WebRequest -Uri $bridgeUrl -OutFile $bridgeFile -UseBasicParsing

    $bridgeOutput = (
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $bridgeFile -TaskUrl $taskUrl 2>&1 |
        Out-String
    )

    if ($bridgeOutput -notmatch 'LOCAL_EXECUTION_BRIDGE_RESULT:\s*PASS') {
        throw 'Local browser bridge did not pass.'
    }

    $pattern = '(?s)SANITIZED_RESULT_JSON_BEGIN\s*(\{.*?\})\s*SANITIZED_RESULT_JSON_END'
    if ($bridgeOutput -notmatch $pattern) {
        throw 'Sanitized bridge result JSON was not found.'
    }

    $browserResult = $Matches[1] | ConvertFrom-Json

    if ($browserResult.task_id -ne 'LOCAL-EXECUTION-BRIDGE-001') { throw 'Unexpected browser task_id.' }
    if ($browserResult.status -ne 'PASS') { throw 'Browser result status is not PASS.' }
    if ($browserResult.authenticated_read_only -ne $true) { throw 'Authenticated read-only check did not pass.' }
    if ($browserResult.has_password_field -ne $false) { throw 'Password field was observed; auth policy failed.' }
    if (-not ([string]$browserResult.final_url).StartsWith('https://www.workana.com/dashboard',[System.StringComparison]::OrdinalIgnoreCase)) { throw 'Unexpected final URL.' }

    Write-Host 'LOCAL_BROWSER_EXECUTION: PASS'

    $result = [ordered]@{
        schema_version = 1
        challenge_id = 'LOCAL-BRIDGE-INTEGRATED-002'
        nonce = $expectedNonce
        status = 'LOCAL_PC_INTEGRATED_PASS'
        task_id = [string]$browserResult.task_id
        source = 'NEXIA_LOCAL_PC'
        transport = 'GH_API'
        final_url = [string]$browserResult.final_url
        title = [string]$browserResult.title
        has_password_field = [bool]$browserResult.has_password_field
        body_length = [int]$browserResult.body_length
        authenticated_read_only = [bool]$browserResult.authenticated_read_only
        browser = [string]$browserResult.browser
        timestamp_utc = [DateTime]::UtcNow.ToString('o')
        sanitized = $true
        contains_secrets = $false
        external_side_effects = @()
        cash_spend_eur = 0
    }

    $resultJson = $result | ConvertTo-Json -Depth 6
    $contentB64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($resultJson))

    $requestBody = [ordered]@{
        message = 'nexia: integrated local browser gh api challenge pass'
        content = $contentB64
        sha = [string]$challengeResponse.sha
        branch = 'main'
    } | ConvertTo-Json -Compress -Depth 6

    [System.IO.File]::WriteAllText($tempBody, $requestBody, [System.Text.UTF8Encoding]::new($false))

    $writeRaw = & gh api --method PUT $challengeEndpoint --input $tempBody 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'GitHub API integrated challenge PUT failed.' }
    $write = $writeRaw | ConvertFrom-Json
    Write-Host "GH_WRITEBACK: PASS | commit=$($write.commit.sha)"

    Start-Sleep -Seconds 2

    $verifyRaw = & gh api $challengeEndpoint 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'Cannot re-read integrated challenge after write.' }
    $verify = $verifyRaw | ConvertFrom-Json
    $verifyDecoded = [System.Text.Encoding]::UTF8.GetString(
        [Convert]::FromBase64String(($verify.content -replace '\s',''))
    )
    $remote = $verifyDecoded | ConvertFrom-Json

    if (($remote.challenge_id -eq 'LOCAL-BRIDGE-INTEGRATED-002') -and
        ($remote.nonce -eq $expectedNonce) -and
        ($remote.status -eq 'LOCAL_PC_INTEGRATED_PASS') -and
        ($remote.task_id -eq 'LOCAL-EXECUTION-BRIDGE-001') -and
        ($remote.authenticated_read_only -eq $true) -and
        ($remote.sanitized -eq $true) -and
        ($remote.contains_secrets -eq $false) -and
        (@($remote.external_side_effects).Count -eq 0)) {
        Write-Host 'REMOTE_READBACK: PASS'
        Write-Host 'LOCAL_BRIDGE_INTEGRATED_002_RESULT: PASS'
    }
    else {
        throw 'Remote integrated result did not match expected contract.'
    }
}
catch {
    Write-Host 'LOCAL_BRIDGE_INTEGRATED_002_RESULT: FAIL'
    Write-Host "ERROR: $($_.Exception.Message)"
}
finally {
    Remove-Item $bridgeFile,$tempBody -Force -ErrorAction SilentlyContinue
}

Write-Host '=== END NEXIA LOCAL-BRIDGE-INTEGRATED-002 ==='
