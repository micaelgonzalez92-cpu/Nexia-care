# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 repair wrapper v0.2
# Fixes one bug only: expected GitHub Contents API 404 during remote-result existence probes
# must mean ABSENT, not terminate the bounded runner under ErrorActionPreference=Stop.
# The experimental contract, prompts, seed, workflows, generation cap and QA are unchanged.

param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$PinnedBaseCommit = '4599388285e4f523c7f00a7e4ef016449901f65e'
$BaseUrl = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$PinnedBaseCommit/tools/nexia_local_flux_edit_gate_v0_1.ps1"
$BasePath = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_1_pinned.ps1'
$PatchedPath = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_2_runtime.ps1'

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

try {
    Write-Host '=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.2 ==='
    Invoke-WebRequest -Uri $BaseUrl -UseBasicParsing -OutFile $BasePath
    $src = Get-Content -Path $BasePath -Raw

    if (-not $src.Contains($oldPublishProbe)) { throw 'Pinned v0.1 publish probe signature not found; refusing patch.' }
    if (-not $src.Contains($oldPrecheckProbe)) { throw 'Pinned v0.1 precheck probe signature not found; refusing patch.' }
    if (($src.Split($oldPublishProbe).Count - 1) -ne 1) { throw 'Publish probe signature is not unique; refusing patch.' }
    if (($src.Split($oldPrecheckProbe).Count - 1) -ne 1) { throw 'Precheck probe signature is not unique; refusing patch.' }

    $patched = $src.Replace('function Publish-RawResult {', $helper + "`r`nfunction Publish-RawResult {")
    $patched = $patched.Replace($oldPublishProbe, $newPublishProbe)
    $patched = $patched.Replace($oldPrecheckProbe, $newPrecheckProbe)

    if ($patched.Contains($oldPublishProbe) -or $patched.Contains($oldPrecheckProbe)) { throw 'Old 404-sensitive probes remain after patch; refusing execution.' }
    if (-not $patched.Contains('function Test-GhRemoteResultExists')) { throw '404-safe helper missing after patch; refusing execution.' }

    [System.IO.File]::WriteAllText($PatchedPath, $patched, [System.Text.UTF8Encoding]::new($false))
    Write-Host 'PATCH_VERIFY: PASS | only GitHub existence-probe logic replaced'

    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $PatchedPath
    $exitCode = $LASTEXITCODE
    Write-Host "INNER_RUNNER_EXIT: $exitCode"
    exit $exitCode
}
finally {
    Remove-Item $BasePath,$PatchedPath -Force -ErrorAction SilentlyContinue
    Write-Host '=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.2 ==='
}
