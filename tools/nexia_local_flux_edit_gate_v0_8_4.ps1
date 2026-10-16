# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 repair wrapper v0.8.4
# Builds on pinned v0.8.3 and repairs only POST /prompt transport encoding.
# Root cause from read-only postmortem: ComfyUI request.json() failed decoding byte 0xF3 as UTF-8 before prompt validation/execution.
# This version sends the already-serialized JSON as explicit UTF-8 bytes with charset=utf-8.
# Frozen prereg, BASE route, prompts, seed, models, workflow commit, 4-step/CFG1/Euler/1024x1024 prechecks, generation cap and QA remain unchanged.
# Prior raw results _001-_007 are preserved; this attempt writes _008.

param()
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$PinnedV083Commit = 'c948b15b0fc41faaf9d6a11d8e79d1f70ce09bee'
$V083Url = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$PinnedV083Commit/tools/nexia_local_flux_edit_gate_v0_8_3.ps1"
$V083Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_8_3_pinned.ps1'
$V084Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_8_4_runtime.ps1'

function Assert-UniqueLiteral {
    param([string]$Source,[string]$Needle,[string]$Label)
    $first=$Source.IndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -lt 0){throw "$Label signature not found; refusing patch."}
    $last=$Source.LastIndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -ne $last){throw "$Label signature is not unique; refusing patch."}
}

$oldRawLine = "$newRaw = Decode-B64 'JG5ld1Jhd1BhdGggPSAnJFJhd1Jlc3VsdFJlcG9QYXRoID0gJydydW50aW1lL05FWElBX0ZMVVhfSU1BR0VfRURJVF9CUklER0VfUkFXX1JFU1VMVF8wMDcuanNvbicnJw=='"
$newRawLine = "$newRaw = Decode-B64 'JG5ld1Jhd1BhdGggPSAnJFJhd1Jlc3VsdFJlcG9QYXRoID0gJydydW50aW1lL05FWElBX0ZMVVhfSU1BR0VfRURJVF9CUklER0VfUkFXX1JFU1VMVF8wMDguanNvbicnJw=='"

$oldTail = @'
    '    if ($patched.IndexOf(''Resolve-CompiledScalar'',[System.StringComparison]::Ordinal) -lt 0) { throw ''Compiled scalar resolver missing.'' }'
) -join "`r`n"
'@

$newTail = @'
    '    if ($patched.IndexOf(''Resolve-CompiledScalar'',[System.StringComparison]::Ordinal) -lt 0) { throw ''Compiled scalar resolver missing.'' }',
    '    $oldPromptPost = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(''ICAgICRib2R5ID0gQHsgcHJvbXB0ID0gJFByb21wdE9iamVjdDsgY2xpZW50X2lkID0gIm5leGlhLSRUYXNrSWQiIH0gfCBDb252ZXJ0VG8tSnNvbiAtRGVwdGggMTAwCiAgICAkcXVldWUgPSBJbnZva2UtUmVzdE1ldGhvZCAtVXJpICIkQ29tZnlCYXNlL3Byb21wdCIgLU1ldGhvZCBQb3N0IC1Db250ZW50VHlwZSAnYXBwbGljYXRpb24vanNvbicgLUJvZHkgJGJvZHkgLVRpbWVvdXRTZWMgMzA=''))',
    '    $newPromptPost = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(''ICAgICRib2R5ID0gQHsgcHJvbXB0ID0gJFByb21wdE9iamVjdDsgY2xpZW50X2lkID0gIm5leGlhLSRUYXNrSWQiIH0gfCBDb252ZXJ0VG8tSnNvbiAtRGVwdGggMTAwCiAgICAkYm9keUJ5dGVzID0gW1N5c3RlbS5UZXh0LlVURjhFbmNvZGluZ106Om5ldygkZmFsc2UpLkdldEJ5dGVzKCRib2R5KQogICAgJHF1ZXVlID0gSW52b2tlLVJlc3RNZXRob2QgLVVyaSAiJENvbWZ5QmFzZS9wcm9tcHQiIC1NZXRob2QgUG9zdCAtQ29udGVudFR5cGUgJ2FwcGxpY2F0aW9uL2pzb247IGNoYXJzZXQ9dXRmLTgnIC1Cb2R5ICRib2R5Qnl0ZXMgLVRpbWVvdXRTZWMgMzA=''))',
    '    Assert-UniqueLiteral -Source $patched -Needle $oldPromptPost -Label ''POST /prompt string-body transport''',
    '    $patched = $patched.Replace($oldPromptPost,$newPromptPost)',
    '    if ($patched.IndexOf($oldPromptPost,[System.StringComparison]::Ordinal) -ge 0) { throw ''Old string-body /prompt transport remains.'' }',
    '    if ($patched.IndexOf(''UTF8Encoding]::new($false).GetBytes($body)'',[System.StringComparison]::Ordinal) -lt 0) { throw ''Explicit UTF-8 prompt bytes missing.'' }',
    '    if ($patched.IndexOf(''application/json; charset=utf-8'',[System.StringComparison]::Ordinal) -lt 0) { throw ''UTF-8 prompt content type missing.'' }'
) -join "`r`n"
'@

try {
    Write-Host '=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.4 ==='
    Invoke-WebRequest -Uri $V083Url -UseBasicParsing -OutFile $V083Path
    $src = Get-Content -Path $V083Path -Raw

    Assert-UniqueLiteral -Source $src -Needle $oldRawLine -Label 'v0.8.3 _007 raw target line'
    Assert-UniqueLiteral -Source $src -Needle $oldTail -Label 'v0.8.3 inject tail'

    $patched = $src.Replace($oldRawLine,$newRawLine)
    $patched = $patched.Replace($oldTail,$newTail)
    $patched = $patched.Replace('repair wrapper v0.8.3','repair wrapper v0.8.4')
    $patched = $patched.Replace('nexia_local_flux_edit_gate_v0_8_3_runtime.ps1','nexia_local_flux_edit_gate_v0_8_4_inner_runtime.ps1')
    $patched = $patched.Replace('=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.3 ===','=== NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.4 ===')
    $patched = $patched.Replace('=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.3 ===','=== END NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.4 ===')

    if($patched.IndexOf($oldRawLine,[System.StringComparison]::Ordinal) -ge 0){throw 'Old _007 target line remains.'}
    if($patched.IndexOf('NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_008.json',[System.StringComparison]::Ordinal) -lt 0){throw 'New _008 target missing.'}
    if($patched.IndexOf('Explicit UTF-8 prompt bytes missing.',[System.StringComparison]::Ordinal) -lt 0){throw 'UTF-8 transport patch injection missing.'}

    [System.IO.File]::WriteAllText($V084Path,$patched,[System.Text.UTF8Encoding]::new($false))
    Write-Host 'OUTER_PATCH_VERIFY: PASS | pinned v0.8.3 + explicit UTF-8 /prompt bytes + _008 target'
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $V084Path
    $exitCode=$LASTEXITCODE
    Write-Host "INNER_WRAPPER_EXIT: $exitCode"
    exit $exitCode
}
finally {
    Remove-Item $V083Path,$V084Path -Force -ErrorAction SilentlyContinue
    Write-Host '=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.4 ==='
}
