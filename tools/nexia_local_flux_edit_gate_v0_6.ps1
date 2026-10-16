# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 repair wrapper v0.6
# Repairs GitHub 404 probes, Windows PowerShell 5.1 UTF-8 BOM in gh --input JSON,
# suppresses ClientWebSocket ConnectAsync VoidTaskResult, and waits specifically for the ComfyUI CDP page target.
# Experimental contract, prompts, seed, workflows, generation cap and QA remain unchanged.
# Prior failed remote results _001/_002 are preserved; this attempt writes a new _003 artifact.

param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$PinnedBaseCommit = '4599388285e4f523c7f00a7e4ef016449901f65e'
$BaseUrl = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$PinnedBaseCommit/tools/nexia_local_flux_edit_gate_v0_1.ps1"
$BasePath = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_1_pinned.ps1'
$PatchedPath = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_6_runtime.ps1'

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

$oldRawPath = '$RawResultRepoPath = ''runtime/NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_001.json'''
$newRawPath = '$RawResultRepoPath = ''runtime/NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_003.json'''

function Assert-UniqueLiteral {
    param([string]$Source, [string]$Needle, [string]$Label)
    $first = $Source.IndexOf($Needle, [System.StringComparison]::Ordinal)
    if ($first -lt 0) { throw "$Label signature not found; refusing patch." }
    $last = $Source.LastIndexOf($Needle, [System.StringComparison]::Ordinal)
    if ($first -ne $last) { throw "$Label signature is not unique; refusing patch." }
}

try {
    Write-Host '=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.6 ==='
    Invoke-WebRequest -Uri $BaseUrl -UseBasicParsing -OutFile $BasePath
    $src = Get-Content -Path $BasePath -Raw

    Assert-UniqueLiteral -Source $src -Needle $oldPublishProbe -Label 'Publish probe'
    Assert-UniqueLiteral -Source $src -Needle $oldPrecheckProbe -Label 'Precheck probe'
    Assert-UniqueLiteral -Source $src -Needle $oldPayloadWrite -Label 'Payload write'
    Assert-UniqueLiteral -Source $src -Needle $oldCdpConnect -Label 'CDP ConnectAsync'
    Assert-UniqueLiteral -Source $src -Needle $oldTargetBlock -Label 'CDP target selection block'
    Assert-UniqueLiteral -Source $src -Needle $oldRawPath -Label 'Raw result path'
    Assert-UniqueLiteral -Source $src -Needle 'function Publish-RawResult {' -Label 'Publish function insertion point'

    $patched = $src.Replace('function Publish-RawResult {', $helper + "`r`nfunction Publish-RawResult {")
    $patched = $patched.Replace($oldPublishProbe, $newPublishProbe)
    $patched = $patched.Replace($oldPrecheckProbe, $newPrecheckProbe)
    $patched = $patched.Replace($oldPayloadWrite, $newPayloadWrite)
    $patched = $patched.Replace($oldCdpConnect, $newCdpConnect)
    $patched = $patched.Replace($oldTargetBlock, $newTargetBlock)
    $patched = $patched.Replace($oldRawPath, $newRawPath)

    if ($patched.IndexOf($oldPublishProbe, [System.StringComparison]::Ordinal) -ge 0) { throw 'Old publish 404-sensitive probe remains after patch.' }
    if ($patched.IndexOf($oldPrecheckProbe, [System.StringComparison]::Ordinal) -ge 0) { throw 'Old precheck 404-sensitive probe remains after patch.' }
    if ($patched.IndexOf($oldPayloadWrite, [System.StringComparison]::Ordinal) -ge 0) { throw 'Old BOM-producing payload write remains after patch.' }
    if ($patched.IndexOf($oldCdpConnect, [System.StringComparison]::Ordinal) -ge 0) { throw 'Old CDP ConnectAsync output-leaking call remains after patch.' }
    if ($patched.IndexOf($oldTargetBlock, [System.StringComparison]::Ordinal) -ge 0) { throw 'Old CDP target-selection fallback remains after patch.' }
    if ($patched.IndexOf($oldRawPath, [System.StringComparison]::Ordinal) -ge 0) { throw 'Old raw-result path remains after patch.' }
    if ($patched.IndexOf('function Test-GhRemoteResultExists', [System.StringComparison]::Ordinal) -lt 0) { throw '404-safe helper missing after patch.' }
    if ($patched.IndexOf('[System.Text.UTF8Encoding]::new($false)', [System.StringComparison]::Ordinal) -lt 0) { throw 'UTF-8 no-BOM payload writer missing after patch.' }
    if ($patched.IndexOf('FAIL_GH_PAYLOAD_BOM_SELFTEST', [System.StringComparison]::Ordinal) -lt 0) { throw 'Payload BOM self-test missing after patch.' }
    if ($patched.IndexOf('COMFY_CDP_TARGET_URL:', [System.StringComparison]::Ordinal) -lt 0) { throw 'Comfy-specific CDP target instrumentation missing after patch.' }
    if ($patched.IndexOf($newRawPath, [System.StringComparison]::Ordinal) -lt 0) { throw 'New raw-result path missing after patch.' }

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
    Write-Host 'PATCH_VERIFY: PASS | 404/no-BOM/CDP-output repairs present; Comfy-specific CDP target enforced; prior raw results preserved; frozen experiment invariants present'

    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $PatchedPath
    $exitCode = $LASTEXITCODE
    Write-Host "INNER_RUNNER_EXIT: $exitCode"
    exit $exitCode
}
finally {
    Remove-Item $BasePath,$PatchedPath -Force -ErrorAction SilentlyContinue
    Write-Host '=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.6 ==='
}
