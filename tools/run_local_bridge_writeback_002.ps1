$ErrorActionPreference = 'Stop'

Write-Host '=== NEXIA LOCAL-BRIDGE-WRITEBACK-002 ==='

$repo = 'micaelgonzalez92-cpu/Nexia-care'
$path = 'NEXIA_LOCAL_BRIDGE_WRITEBACK_CHALLENGE.json'
$endpoint = "repos/$repo/contents/$path"
$expectedNonce = 'NEXIA-WB-002-20261013-A7F2'
$tempBody = Join-Path $env:TEMP 'nexia_local_bridge_writeback_002_body.json'

try {
    $gh = Get-Command gh -ErrorAction Stop
    Write-Host "GH_FOUND: PASS | $($gh.Source)"

    & gh auth status --hostname github.com 1>$null 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'GitHub CLI is not authenticated.' }
    Write-Host 'GH_AUTH: PASS'

    $repoInfoRaw = & gh repo view $repo --json nameWithOwner,viewerPermission,isPrivate 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'Cannot read repository through gh.' }
    $repoInfo = $repoInfoRaw | ConvertFrom-Json
    if ($repoInfo.nameWithOwner -ne $repo) { throw 'Unexpected repository identity.' }
    Write-Host "REPO_ACCESS: PASS | permission=$($repoInfo.viewerPermission)"

    $currentRaw = & gh api $endpoint 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'Cannot fetch challenge file via gh api.' }
    $current = $currentRaw | ConvertFrom-Json

    $decoded = [System.Text.Encoding]::UTF8.GetString(
        [Convert]::FromBase64String(($current.content -replace '\s',''))
    )
    $challenge = $decoded | ConvertFrom-Json

    if ($challenge.challenge_id -ne 'LOCAL-BRIDGE-WRITEBACK-002') { throw 'Unexpected challenge_id.' }
    if ($challenge.nonce -ne $expectedNonce) { throw 'Challenge nonce mismatch.' }
    Write-Host 'CHALLENGE_READ: PASS'

    $result = [ordered]@{
        schema_version = 1
        challenge_id = 'LOCAL-BRIDGE-WRITEBACK-002'
        nonce = $expectedNonce
        status = 'LOCAL_PC_WRITEBACK_PASS'
        source = 'NEXIA_LOCAL_PC'
        transport = 'GH_API'
        timestamp_utc = [DateTime]::UtcNow.ToString('o')
        sanitized = $true
        contains_secrets = $false
        cash_spend_eur = 0
    }

    $resultJson = $result | ConvertTo-Json -Depth 5
    $contentB64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($resultJson))

    $requestBody = [ordered]@{
        message = 'nexia: local pc gh api writeback challenge pass'
        content = $contentB64
        sha = [string]$current.sha
        branch = 'main'
    } | ConvertTo-Json -Compress -Depth 5

    [System.IO.File]::WriteAllText($tempBody, $requestBody, [System.Text.UTF8Encoding]::new($false))

    $writeRaw = & gh api --method PUT $endpoint --input $tempBody 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'GitHub API PUT failed.' }
    $write = $writeRaw | ConvertFrom-Json
    Write-Host "WRITEBACK: PASS | commit=$($write.commit.sha)"

    Start-Sleep -Seconds 2
    $verifyRaw = & gh api $endpoint 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'Cannot re-read challenge after write.' }
    $verify = $verifyRaw | ConvertFrom-Json
    $verifyDecoded = [System.Text.Encoding]::UTF8.GetString(
        [Convert]::FromBase64String(($verify.content -replace '\s',''))
    )
    $verifyObj = $verifyDecoded | ConvertFrom-Json

    if (($verifyObj.challenge_id -eq 'LOCAL-BRIDGE-WRITEBACK-002') -and
        ($verifyObj.nonce -eq $expectedNonce) -and
        ($verifyObj.status -eq 'LOCAL_PC_WRITEBACK_PASS') -and
        ($verifyObj.sanitized -eq $true) -and
        ($verifyObj.contains_secrets -eq $false)) {
        Write-Host 'READBACK_VERIFY: PASS'
        Write-Host 'LOCAL_BRIDGE_WRITEBACK_002_RESULT: PASS'
    }
    else {
        throw 'Remote challenge content did not match expected result.'
    }
}
catch {
    Write-Host 'LOCAL_BRIDGE_WRITEBACK_002_RESULT: FAIL'
    Write-Host "ERROR: $($_.Exception.Message)"
}
finally {
    if (Test-Path $tempBody) {
        Remove-Item -Force $tempBody -ErrorAction SilentlyContinue
    }
}

Write-Host '=== END NEXIA LOCAL-BRIDGE-WRITEBACK-002 ==='
