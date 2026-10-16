# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 repair wrapper v0.3
# Fixes wrapper v0.2 signature-count bug only.
# Experimental contract, prompts, seed, workflows, generation cap and QA remain unchanged.

param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$PinnedBaseCommit = '4599388285e4f523c7f00a7e4ef016449901f65e'
$BaseUrl = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$PinnedBaseCommit/tools/nexia_local_flux_edit_gate_v0_1.ps1"
$BasePath = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_1_pinned.ps1'
$PatchedPath = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_3_runtime.ps1'

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

function Assert-UniqueLiteral {
    param([string]$Source, [string]$Needle, [string]$Label)
    $first = $Source.IndexOf($Needle, [System.StringComparison]::Ordinal)
    if ($first -lt 0) { throw "$Label signature not found; refusing patch." }
    $last = $Source.LastIndexOf($Needle, [System.StringComparison]::Ordinal)
    if ($first -ne $last) { throw "$Label signature is not unique; refusing patch." }
}

try {
    Write-Host '=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.3 ==='
    Invoke-WebRequest -Uri $BaseUrl -UseBasicParsing -OutFile $BasePath
    $src = Get-Content -Path $BasePath -Raw

    Assert-UniqueLiteral -Source $src -Needle $oldPublishProbe -Label 'Publish probe'
    Assert-UniqueLiteral -Source $src -Needle $oldPrecheckProbe -Label 'Precheck probe'
    Assert-UniqueLiteral -Source $src -Needle 'function Publish-RawResult {' -Label 'Publish function insertion point'

    $patched = $src.Replace('function Publish-RawResult {', $helper + "`r`nfunction Publish-RawResult {")
    $patched = $patched.Replace($oldPublishProbe, $newPublishProbe)
    $patched = $patched.Replace($oldPrecheckProbe, $newPrecheckProbe)

    if ($patched.IndexOf($oldPublishProbe, [System.StringComparison]::Ordinal) -ge 0) { throw 'Old publish 404-sensitive probe remains after patch.' }
    if ($patched.IndexOf($oldPrecheckProbe, [System.StringComparison]::Ordinal) -ge 0) { throw 'Old precheck 404-sensitive probe remains after patch.' }
    if ($patched.IndexOf('function Test-GhRemoteResultExists', [System.StringComparison]::Ordinal) -lt 0) { throw '404-safe helper missing after patch.' }

    # Frozen experimental-contract invariants must still be present before execution.
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
    Write-Host 'PATCH_VERIFY: PASS | GitHub 404 probes repaired; frozen experiment invariants present'

    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $PatchedPath
    $exitCode = $LASTEXITCODE
    Write-Host "INNER_RUNNER_EXIT: $exitCode"
    exit $exitCode
}
finally {
    Remove-Item $BasePath,$PatchedPath -Force -ErrorAction SilentlyContinue
    Write-Host '=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.3 ==='
}
