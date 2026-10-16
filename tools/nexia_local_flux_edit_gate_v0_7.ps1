# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 repair wrapper v0.7
# Repairs GitHub 404 probes, Windows PowerShell 5.1 UTF-8 BOM in gh --input JSON,
# suppresses ClientWebSocket ConnectAsync VoidTaskResult, waits specifically for the ComfyUI CDP target,
# and makes CDP optional-property parsing safe under Set-StrictMode -Version 2.0.
# Experimental contract, prompts, seed, workflows, generation cap and QA remain unchanged.
# Prior failed remote results _001/_002/_003 are preserved; this attempt writes _004.

param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$PinnedBaseCommit = '4599388285e4f523c7f00a7e4ef016449901f65e'
$BaseUrl = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$PinnedBaseCommit/tools/nexia_local_flux_edit_gate_v0_1.ps1"
$BasePath = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_1_pinned.ps1'
$PatchedPath = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_7_runtime.ps1'

$helper = @'
function Test-GhRemoteResultExists {
    param($GhCommand)
    $probeOut = Join-Path $OutputDir 'gh-result-probe.stdout.tmp'
    $probeErr = Join-Path $OutputDir 'gh-result-probe.stderr.tmp'
    Remove-Item $probeOut,$probeErr -Force -ErrorAction SilentlyContinue
    try {
        $p = Start-Process -FilePath $GhCommand.Source `
            -ArgumentList @('api', "repos/$Repo/contents/$RawResultRepoPath") `
            -RedirectStandardOutput $probeOut `
            -RedirectStandardError $probeErr `
            -NoNewWindow -Wait -PassThru
        if ($p.ExitCode -eq 0) { return $true }
        $err = if (Test-Path $probeErr) { Get-Content $probeErr -Raw } else { '' }
        if (($p.ExitCode -ne 0) -and ($err -match '(?i)HTTP\s+404|Not Found')) { return $false }
        throw "GitHub remote result probe failed unexpectedly (exit=$($p.ExitCode)): $err"
    }
    finally {
        Remove-Item $probeOut,$probeErr -Force -ErrorAction SilentlyContinue
    }
}
'@

$oldPublishProbe = @'
    $existing = & $gh.Source api "repos/$Repo/contents/$RawResultRepoPath" 2>$null
    if ($LASTEXITCODE -eq 0) { $Result.writeback = 'FAIL_REMOTE_RESULT_ALREADY_EXISTS_NO_OVERWRITE'; return }
'@
$newPublishProbe = @'
    if (Test-GhRemoteResultExists $gh) { $Result.writeback = 'FAIL_REMOTE_RESULT_ALREADY_EXISTS_NO_OVERWRITE'; return }
'@

$oldPrecheckProbe = @'
    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if ($gh) {
        $null = & $gh.Source api "repos/$Repo/contents/$RawResultRepoPath" 2>$null
        if ($LASTEXITCODE -eq 0) { throw "STOP: remote raw result already exists at $RawResultRepoPath; one-shot will not rerun." }
    }
'@
$newPrecheckProbe = @'
    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if ($gh) {
        if (Test-GhRemoteResultExists $gh) { throw "STOP: remote raw result already exists at $RawResultRepoPath; one-shot will not rerun." }
    }
'@

$oldPayloadWrite = @'
    Write-JsonFile $payload $payloadPath
'@
$newPayloadWrite = @'
    $payloadJson = $payload | ConvertTo-Json -Depth 100
    [System.IO.File]::WriteAllText($payloadPath, $payloadJson, [System.Text.UTF8Encoding]::new($false))
    $payloadBytes = [System.IO.File]::ReadAllBytes($payloadPath)
    if ($payloadBytes.Length -ge 3 -and $payloadBytes[0] -eq 239 -and $payloadBytes[1] -eq 187 -and $payloadBytes[2] -eq 191) {
        $Result.writeback = 'FAIL_GH_PAYLOAD_BOM_SELFTEST'
        return
    }
'@

$oldCdpConnect = @'
    $script:CdpSocket.ConnectAsync([System.Uri]$target[0].webSocketDebuggerUrl, [System.Threading.CancellationToken]::None).GetAwaiter().GetResult()
'@
$newCdpConnect = @'
    $null = $script:CdpSocket.ConnectAsync([System.Uri]$target[0].webSocketDebuggerUrl, [System.Threading.CancellationToken]::None).GetAwaiter().GetResult()
'@

$oldTargetBlock = @'
    $targets = $null
    for ($i = 0; $i -lt 60; $i++) {
        Start-Sleep -Milliseconds 500
        try {
            $targets = Invoke-RestMethod -Uri "$CdpBase/json/list" -TimeoutSec 2
            if ($targets) { break }
        } catch {}
    }
    if (-not $targets) { throw 'Browser CDP did not become ready.' }
    $target = @($targets | Where-Object { $_.type -eq 'page' -and ([string]$_.url).StartsWith($ComfyBase) } | Select-Object -First 1)
    if ($target.Count -eq 0) { $target = @($targets | Where-Object { $_.type -eq 'page' } | Select-Object -First 1) }
    if ($target.Count -eq 0 -or -not $target[0].webSocketDebuggerUrl) { throw 'No CDP page target found.' }
'@
$newTargetBlock = @'
    $target = $null
    for ($i = 0; $i -lt 120; $i++) {
        Start-Sleep -Milliseconds 500
        try {
            $targets = Invoke-RestMethod -Uri "$CdpBase/json/list" -TimeoutSec 2
            $candidate = @($targets | Where-Object { $_.type -eq 'page' -and ([string]$_.url).StartsWith($ComfyBase) } | Select-Object -First 1)
            if ($candidate.Count -gt 0 -and $candidate[0].webSocketDebuggerUrl) {
                $target = $candidate
                break
            }
        } catch {}
    }
    if (-not $target -or $target.Count -eq 0 -or -not $target[0].webSocketDebuggerUrl) { throw 'No ComfyUI CDP page target found.' }
    Write-Host ("COMFY_CDP_TARGET_URL: {0}" -f $target[0].url)
'@

$oldMessageIdBlock = @'
            $msg = ([System.Text.Encoding]::UTF8.GetString($stream.ToArray())) | ConvertFrom-Json
            if (($null -ne $msg.id) -and ([int]$msg.id -eq $script:CdpId)) { return $msg }
'@
$newMessageIdBlock = @'
            $msg = ([System.Text.Encoding]::UTF8.GetString($stream.ToArray())) | ConvertFrom-Json
            $idProp = $msg.PSObject.Properties['id']
            if (($null -ne $idProp) -and ([int]$idProp.Value -eq $script:CdpId)) { return $msg }
'@

$oldInvokeJs = @'
function Invoke-Js([string]$Expression) {
    $r = Invoke-Cdp -Method 'Runtime.evaluate' -Params @{
        expression = $Expression
        returnByValue = $true
        awaitPromise = $true
    }
    if ($null -ne $r.result.exceptionDetails) {
        throw "Browser JS exception: $($r.result.exceptionDetails.text)"
    }
    return $r.result.result.value
}
'@
$newInvokeJs = @'
function Invoke-Js([string]$Expression) {
    $r = Invoke-Cdp -Method 'Runtime.evaluate' -Params @{
        expression = $Expression
        returnByValue = $true
        awaitPromise = $true
    }
    $topResultProp = $r.PSObject.Properties['result']
    if ($null -eq $topResultProp -or $null -eq $topResultProp.Value) { throw 'CDP Runtime.evaluate response missing result container.' }
    $evalResult = $topResultProp.Value
    $exceptionProp = $evalResult.PSObject.Properties['exceptionDetails']
    if ($null -ne $exceptionProp -and $null -ne $exceptionProp.Value) {
        $textProp = $exceptionProp.Value.PSObject.Properties['text']
        $detailText = if ($null -ne $textProp) { [string]$textProp.Value } else { 'exceptionDetails present' }
        throw "Browser JS exception: $detailText"
    }
    $remoteProp = $evalResult.PSObject.Properties['result']
    if ($null -eq $remoteProp -or $null -eq $remoteProp.Value) { throw 'CDP Runtime.evaluate response missing remote result.' }
    $valueProp = $remoteProp.Value.PSObject.Properties['value']
    if ($null -eq $valueProp) { return $null }
    return $valueProp.Value
}
'@

$oldRawPath = '$RawResultRepoPath = ''runtime/NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_001.json'''
$newRawPath = '$RawResultRepoPath = ''runtime/NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_004.json'''

function Assert-UniqueLiteral {
    param([string]$Source, [string]$Needle, [string]$Label)
    $first = $Source.IndexOf($Needle, [System.StringComparison]::Ordinal)
    if ($first -lt 0) { throw "$Label signature not found; refusing patch." }
    $last = $Source.LastIndexOf($Needle, [System.StringComparison]::Ordinal)
    if ($first -ne $last) { throw "$Label signature is not unique; refusing patch." }
}

try {
    Write-Host '=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.7 ==='
    Invoke-WebRequest -Uri $BaseUrl -UseBasicParsing -OutFile $BasePath
    $src = Get-Content -Path $BasePath -Raw

    Assert-UniqueLiteral -Source $src -Needle $oldPublishProbe -Label 'Publish probe'
    Assert-UniqueLiteral -Source $src -Needle $oldPrecheckProbe -Label 'Precheck probe'
    Assert-UniqueLiteral -Source $src -Needle $oldPayloadWrite -Label 'Payload write'
    Assert-UniqueLiteral -Source $src -Needle $oldCdpConnect -Label 'CDP ConnectAsync'
    Assert-UniqueLiteral -Source $src -Needle $oldTargetBlock -Label 'CDP target selection block'
    Assert-UniqueLiteral -Source $src -Needle $oldMessageIdBlock -Label 'CDP message id block'
    Assert-UniqueLiteral -Source $src -Needle $oldInvokeJs -Label 'Invoke-Js block'
    Assert-UniqueLiteral -Source $src -Needle $oldRawPath -Label 'Raw result path'
    Assert-UniqueLiteral -Source $src -Needle 'function Publish-RawResult {' -Label 'Publish function insertion point'

    $patched = $src.Replace('function Publish-RawResult {', $helper + "`r`nfunction Publish-RawResult {")
    $patched = $patched.Replace($oldPublishProbe, $newPublishProbe)
    $patched = $patched.Replace($oldPrecheckProbe, $newPrecheckProbe)
    $patched = $patched.Replace($oldPayloadWrite, $newPayloadWrite)
    $patched = $patched.Replace($oldCdpConnect, $newCdpConnect)
    $patched = $patched.Replace($oldTargetBlock, $newTargetBlock)
    $patched = $patched.Replace($oldMessageIdBlock, $newMessageIdBlock)
    $patched = $patched.Replace($oldInvokeJs, $newInvokeJs)
    $patched = $patched.Replace($oldRawPath, $newRawPath)

    foreach ($old in @($oldPublishProbe,$oldPrecheckProbe,$oldPayloadWrite,$oldCdpConnect,$oldTargetBlock,$oldMessageIdBlock,$oldInvokeJs,$oldRawPath)) {
        if ($patched.IndexOf($old, [System.StringComparison]::Ordinal) -ge 0) { throw 'An old unsafe signature remains after patch.' }
    }
    foreach ($required in @(
        'function Test-GhRemoteResultExists',
        '[System.Text.UTF8Encoding]::new($false)',
        'FAIL_GH_PAYLOAD_BOM_SELFTEST',
        'COMFY_CDP_TARGET_URL:',
        $newRawPath,
        '$idProp = $msg.PSObject.Properties[''id'']',
        '$exceptionProp = $evalResult.PSObject.Properties[''exceptionDetails'']'
    )) {
        if ($patched.IndexOf($required, [System.StringComparison]::Ordinal) -lt 0) { throw "Required repair missing after patch: $required" }
    }

    foreach ($invariant in @(
        '$Seed = 20261016',
        '$Model = ''flux-2-klein-4b-fp8.safetensors''',
        '$Clip = ''qwen_3_4b.safetensors''',
        '$Vae = ''flux2-vae.safetensors''',
        'if ($script:GenerationCount -ge 3)',
        '$BasePrompt = ''A single matte dark-blue storage box with a black lid',
        '$B1Prompt = ''Change the background to a warm beige interior with a light oak tabletop.''',
        '$B2Prompt = ''Edit the image while preserving the main product exactly:'
    )) {
        if ($patched.IndexOf($invariant, [System.StringComparison]::Ordinal) -lt 0) { throw "Frozen invariant missing after patch: $invariant" }
    }

    [System.IO.File]::WriteAllText($PatchedPath, $patched, [System.Text.UTF8Encoding]::new($false))
    Write-Host 'PATCH_VERIFY: PASS | 404/no-BOM/CDP-output/target/strict-property repairs present; prior raw results preserved; frozen experiment invariants present'

    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $PatchedPath
    $exitCode = $LASTEXITCODE
    Write-Host "INNER_RUNNER_EXIT: $exitCode"
    exit $exitCode
}
finally {
    Remove-Item $BasePath,$PatchedPath -Force -ErrorAction SilentlyContinue
    Write-Host '=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.7 ==='
}
