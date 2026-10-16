# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 repair wrapper v0.8.5
# Builds on pinned v0.8.4 and fixes only the stale inner self-test/checkpoint that still expected raw result _007.
# UTF-8 /prompt transport repair and all frozen experiment invariants remain unchanged.
# Prior raw results _001-_007 are preserved; this attempt still targets _008.

param()
$ErrorActionPreference='Stop'
Set-StrictMode -Version 2.0

$PinnedV084Commit='711c2c7c7af92fd0b7b62d0b4f66425bafd1664a'
$V084Url="https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$PinnedV084Commit/tools/nexia_local_flux_edit_gate_v0_8_4.ps1"
$V084Path=Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_8_4_pinned.ps1'
$V085Path=Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_8_5_runtime.ps1'

function Assert-UniqueLiteral {
    param([string]$Source,[string]$Needle,[string]$Label)
    $first=$Source.IndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -lt 0){throw "$Label signature not found; refusing patch."}
    $last=$Source.LastIndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -ne $last){throw "$Label signature is not unique; refusing patch."}
}

$oldCheck="    if(`$patchedWrapper.IndexOf('NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_007.json',[System.StringComparison]::Ordinal) -lt 0){throw 'New _007 target missing.'}"
$newCheck="    if(`$patchedWrapper.IndexOf('NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_008.json',[System.StringComparison]::Ordinal) -lt 0){throw 'New _008 target missing.'}"
$oldCheckpoint="    Write-Host 'OUTER_PATCH_VERIFY: PASS | pinned v0.7 + distilled BASE route + linked-dimension resolver + _007 target'"
$newCheckpoint="    Write-Host 'OUTER_PATCH_VERIFY: PASS | pinned v0.7 + distilled BASE route + linked-dimension resolver + _008 target'"

try {
    Write-Host '=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.5 ==='
    Invoke-WebRequest -Uri $V084Url -UseBasicParsing -OutFile $V084Path
    $src=Get-Content -Path $V084Path -Raw

    Assert-UniqueLiteral -Source $src -Needle $oldCheck -Label 'stale _007 inner self-test'
    Assert-UniqueLiteral -Source $src -Needle $oldCheckpoint -Label 'stale _007 inner checkpoint'

    $patched=$src.Replace($oldCheck,$newCheck)
    $patched=$patched.Replace($oldCheckpoint,$newCheckpoint)
    $patched=$patched.Replace('repair wrapper v0.8.4','repair wrapper v0.8.5')
    $patched=$patched.Replace('nexia_local_flux_edit_gate_v0_8_4_runtime.ps1','nexia_local_flux_edit_gate_v0_8_5_inner_runtime.ps1')
    $patched=$patched.Replace('=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.4 ===','=== NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.5 ===')
    $patched=$patched.Replace('=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.4 ===','=== END NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.5 ===')

    if($patched.IndexOf($oldCheck,[System.StringComparison]::Ordinal) -ge 0){throw 'Stale _007 self-test remains.'}
    if($patched.IndexOf('New _008 target missing.',[System.StringComparison]::Ordinal) -lt 0){throw 'Updated _008 self-test missing.'}
    if($patched.IndexOf('explicit UTF-8 /prompt bytes',[System.StringComparison]::Ordinal) -lt 0){throw 'UTF-8 transport repair marker missing.'}

    [System.IO.File]::WriteAllText($V085Path,$patched,[System.Text.UTF8Encoding]::new($false))
    Write-Host 'OUTER_PATCH_VERIFY: PASS | pinned v0.8.4 + stale _007 self-test corrected to _008; UTF-8 transport preserved'
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $V085Path
    $exitCode=$LASTEXITCODE
    Write-Host "INNER_WRAPPER_EXIT: $exitCode"
    exit $exitCode
}
finally {
    Remove-Item $V084Path,$V085Path -Force -ErrorAction SilentlyContinue
    Write-Host '=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.5 ==='
}
