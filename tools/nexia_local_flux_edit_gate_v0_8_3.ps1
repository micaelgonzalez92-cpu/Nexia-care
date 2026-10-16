# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 repair wrapper v0.8.3
# Builds directly on pinned v0.7 with verified bounded repairs:
# 1) select official distilled BASE route (node77 / SaveImage78),
# 2) resolve compiled width/height links through PrimitiveInt source nodes before enforcing 1024x1024.
# Frozen prereg, prompts, seed, models, workflow commit, 4-step/CFG1/Euler precheck, generation cap and QA remain unchanged.
# Prior raw results _001-_006 are preserved; this attempt writes _007.

param()
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$PinnedV07Commit = '4ab1656351efc254ef57734201aca0b47db88954'
$V07Url = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$PinnedV07Commit/tools/nexia_local_flux_edit_gate_v0_7.ps1"
$V07Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_7_pinned.ps1'
$V083Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_8_3_runtime.ps1'

function Decode-B64([string]$s) { [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($s)) }
function Assert-UniqueLiteral {
    param([string]$Source,[string]$Needle,[string]$Label)
    $first=$Source.IndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -lt 0){throw "$Label signature not found; refusing patch."}
    $last=$Source.LastIndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -ne $last){throw "$Label signature is not unique; refusing patch."}
}

$oldRaw = Decode-B64 'JG5ld1Jhd1BhdGggPSAnJFJhd1Jlc3VsdFJlcG9QYXRoID0gJydydW50aW1lL05FWElBX0ZMVVhfSU1BR0VfRURJVF9CUklER0VfUkFXX1JFU1VMVF8wMDQuanNvbicnJw=='
$newRaw = Decode-B64 'JG5ld1Jhd1BhdGggPSAnJFJhd1Jlc3VsdFJlcG9QYXRoID0gJydydW50aW1lL05FWElBX0ZMVVhfSU1BR0VfRURJVF9CUklER0VfUkFXX1JFU1VMVF8wMDcuanNvbicnJw=='
$marker = Decode-B64 'ICAgICRwYXRjaGVkID0gJHBhdGNoZWQuUmVwbGFjZSgkb2xkSW52b2tlSnMsICRuZXdJbnZva2VKcyk='
$oldBaseNode = Decode-B64 'ICAgY29uc3QgcD1nLmdldE5vZGVCeUlkKDc2KTsgc2V0dihwLCd0ZXh0JywwLGMucHJvbXB0KTsKICAgY29uc3Qgbj1nLmdldE5vZGVCeUlkKDc1KTs='
$newBaseNode = Decode-B64 'ICAgY29uc3QgcD1nLmdldE5vZGVCeUlkKDc2KTsgc2V0dihwLCd0ZXh0JywwLGMucHJvbXB0KTsKICAgY29uc3QgbGVnYWN5PWcuZ2V0Tm9kZUJ5SWQoNzUpOyBpZihsZWdhY3kpIGxlZ2FjeS5tb2RlPTQ7CiAgIGNvbnN0IG49Zy5nZXROb2RlQnlJZCg3Nyk7IGlmKCFuKSB0aHJvdyBuZXcgRXJyb3IoJ21pc3NpbmcgZGlzdGlsbGVkIEJBU0Ugbm9kZSA3NycpOyBuLm1vZGU9MDs='
$oldBaseSave = Decode-B64 'ICAgY29uc3Qgcz1nLmdldE5vZGVCeUlkKDkpOyBzZXR2KHMsJ2ZpbGVuYW1lX3ByZWZpeCcsMCwnTkVYSUFfRkxVWF9CQVNFX0dBVEUnKTs='
$newBaseSave = Decode-B64 'ICAgY29uc3QgbGVnYWN5U2F2ZT1nLmdldE5vZGVCeUlkKDkpOyBpZihsZWdhY3lTYXZlKSBsZWdhY3lTYXZlLm1vZGU9NDsKICAgY29uc3Qgcz1nLmdldE5vZGVCeUlkKDc4KTsgaWYoIXMpIHRocm93IG5ldyBFcnJvcignbWlzc2luZyBkaXN0aWxsZWQgQkFTRSBTYXZlSW1hZ2Ugbm9kZSA3OCcpOyBzLm1vZGU9MDsgc2V0dihzLCdmaWxlbmFtZV9wcmVmaXgnLDAsJ05FWElBX0ZMVVhfQkFTRV9HQVRFJyk7'
$oldDimBlock = Decode-B64 'ICAgIGlmICgkTW9kZSAtZXEgJ0JBU0UnKSB7CiAgICAgICAgJGRpbU5vZGVzID0gQCgkbm9kZXMgfCBXaGVyZS1PYmplY3QgeyAoJG51bGwgLW5lICRfLmlucHV0cy53aWR0aCkgLWFuZCAoJG51bGwgLW5lICRfLmlucHV0cy5oZWlnaHQpIH0pCiAgICAgICAgaWYgKCRkaW1Ob2Rlcy5Db3VudCAtbHQgMSkgeyB0aHJvdyAnTm8gd2lkdGgvaGVpZ2h0IGxhdGVudCBub2RlIGZvdW5kIGluIEJBU0UgY29tcGlsZWQgcHJvbXB0LicgfQogICAgICAgICRvayA9ICRmYWxzZQogICAgICAgIGZvcmVhY2ggKCRuIGluICRkaW1Ob2RlcykgeyBpZiAoW2ludF0kbi5pbnB1dHMud2lkdGggLWVxIDEwMjQgLWFuZCBbaW50XSRuLmlucHV0cy5oZWlnaHQgLWVxIDEwMjQpIHsgJG9rID0gJHRydWUgfSB9CiAgICAgICAgaWYgKC1ub3QgJG9rKSB7IHRocm93ICdCQVNFIGNvbXBpbGVkIHByb21wdCBpcyBub3QgMTAyNHgxMDI0LicgfQogICAgfQ=='
$newDimBlock = Decode-B64 'ICAgIGlmICgkTW9kZSAtZXEgJ0JBU0UnKSB7CiAgICAgICAgJG91dHB1dFByb3BzID0gJFByb21wdE9iamVjdC5QU09iamVjdC5Qcm9wZXJ0aWVzCiAgICAgICAgJGRpbU5vZGVzID0gQCgpCiAgICAgICAgZm9yZWFjaCAoJHByb3AgaW4gJG91dHB1dFByb3BzKSB7CiAgICAgICAgICAgICRub2RlID0gJHByb3AuVmFsdWUKICAgICAgICAgICAgJGlucHV0c1Byb3AgPSAkbm9kZS5QU09iamVjdC5Qcm9wZXJ0aWVzWydpbnB1dHMnXQogICAgICAgICAgICBpZiAoJG51bGwgLWVxICRpbnB1dHNQcm9wIC1vciAkbnVsbCAtZXEgJGlucHV0c1Byb3AuVmFsdWUpIHsgY29udGludWUgfQogICAgICAgICAgICAkaW5wdXRzID0gJGlucHV0c1Byb3AuVmFsdWUKICAgICAgICAgICAgJHdwID0gJGlucHV0cy5QU09iamVjdC5Qcm9wZXJ0aWVzWyd3aWR0aCddCiAgICAgICAgICAgICRocCA9ICRpbnB1dHMuUFNPYmplY3QuUHJvcGVydGllc1snaGVpZ2h0J10KICAgICAgICAgICAgaWYgKCRudWxsIC1uZSAkd3AgLWFuZCAkbnVsbCAtbmUgJGhwKSB7CiAgICAgICAgICAgICAgICAkZGltTm9kZXMgKz0gW3BzY3VzdG9tb2JqZWN0XUB7IG5vZGVfaWQgPSBbc3RyaW5nXSRwcm9wLk5hbWU7IHdpZHRoID0gJHdwLlZhbHVlOyBoZWlnaHQgPSAkaHAuVmFsdWUgfQogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIGlmICgkZGltTm9kZXMuQ291bnQgLWx0IDEpIHsgdGhyb3cgJ05vIHdpZHRoL2hlaWdodCBub2RlIGZvdW5kIGluIEJBU0UgY29tcGlsZWQgcHJvbXB0LicgfQoKICAgICAgICBmdW5jdGlvbiBSZXNvbHZlLUNvbXBpbGVkU2NhbGFyKCRWYWx1ZSwgW3N0cmluZ10kTGFiZWwpIHsKICAgICAgICAgICAgaWYgKCRWYWx1ZSAtaXMgW1N5c3RlbS5BcnJheV0pIHsKICAgICAgICAgICAgICAgIGlmICgkVmFsdWUuQ291bnQgLWx0IDEpIHsgdGhyb3cgIiRMYWJlbCBsaW5rIGFycmF5IGlzIGVtcHR5LiIgfQogICAgICAgICAgICAgICAgJHNyY0lkID0gW3N0cmluZ10kVmFsdWVbMF0KICAgICAgICAgICAgICAgICRzcmNQcm9wID0gJFByb21wdE9iamVjdC5QU09iamVjdC5Qcm9wZXJ0aWVzWyRzcmNJZF0KICAgICAgICAgICAgICAgIGlmICgkbnVsbCAtZXEgJHNyY1Byb3AgLW9yICRudWxsIC1lcSAkc3JjUHJvcC5WYWx1ZSkgeyB0aHJvdyAiJExhYmVsIHNvdXJjZSBub2RlIG5vdCBmb3VuZDogJHNyY0lkIiB9CiAgICAgICAgICAgICAgICAkc3JjSW5wdXRzUHJvcCA9ICRzcmNQcm9wLlZhbHVlLlBTT2JqZWN0LlByb3BlcnRpZXNbJ2lucHV0cyddCiAgICAgICAgICAgICAgICBpZiAoJG51bGwgLWVxICRzcmNJbnB1dHNQcm9wIC1vciAkbnVsbCAtZXEgJHNyY0lucHV0c1Byb3AuVmFsdWUpIHsgdGhyb3cgIiRMYWJlbCBzb3VyY2Ugbm9kZSBsYWNrcyBpbnB1dHM6ICRzcmNJZCIgfQogICAgICAgICAgICAgICAgJHZhbHVlUHJvcCA9ICRzcmNJbnB1dHNQcm9wLlZhbHVlLlBTT2JqZWN0LlByb3BlcnRpZXNbJ3ZhbHVlJ10KICAgICAgICAgICAgICAgIGlmICgkbnVsbCAtZXEgJHZhbHVlUHJvcCkgeyB0aHJvdyAiJExhYmVsIHNvdXJjZSBub2RlIGxhY2tzIHNjYWxhciB2YWx1ZTogJHNyY0lkIiB9CiAgICAgICAgICAgICAgICByZXR1cm4gW2ludF0kdmFsdWVQcm9wLlZhbHVlCiAgICAgICAgICAgIH0KICAgICAgICAgICAgcmV0dXJuIFtpbnRdJFZhbHVlCiAgICAgICAgfQoKICAgICAgICAkb2sgPSAkZmFsc2UKICAgICAgICBmb3JlYWNoICgkbiBpbiAkZGltTm9kZXMpIHsKICAgICAgICAgICAgJHcgPSBSZXNvbHZlLUNvbXBpbGVkU2NhbGFyICRuLndpZHRoICJ3aWR0aCBmb3Igbm9kZSAkKCRuLm5vZGVfaWQpIgogICAgICAgICAgICAkaCA9IFJlc29sdmUtQ29tcGlsZWRTY2FsYXIgJG4uaGVpZ2h0ICJoZWlnaHQgZm9yIG5vZGUgJCgkbi5ub2RlX2lkKSIKICAgICAgICAgICAgaWYgKCR3IC1lcSAxMDI0IC1hbmQgJGggLWVxIDEwMjQpIHsgJG9rID0gJHRydWUgfQogICAgICAgIH0KICAgICAgICBpZiAoLW5vdCAkb2spIHsgdGhyb3cgJ0JBU0UgY29tcGlsZWQgcHJvbXB0IGlzIG5vdCBlZmZlY3RpdmVseSAxMDI0eDEwMjQuJyB9CiAgICB9'

try {
    Write-Host '=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.3 ==='
    Invoke-WebRequest -Uri $V07Url -UseBasicParsing -OutFile $V07Path
    $src = Get-Content -Path $V07Path -Raw
    Assert-UniqueLiteral -Source $src -Needle $oldRaw -Label 'v0.7 raw target'
    Assert-UniqueLiteral -Source $src -Needle $marker -Label 'v0.7 patch marker'

    $extra = @(
        '    Assert-UniqueLiteral -Source $patched -Needle $oldBaseNode -Label ''BASE node route''',
        '    $patched = $patched.Replace($oldBaseNode, $newBaseNode)',
        '    Assert-UniqueLiteral -Source $patched -Needle $oldBaseSave -Label ''BASE SaveImage route''',
        '    $patched = $patched.Replace($oldBaseSave, $newBaseSave)',
        '    Assert-UniqueLiteral -Source $patched -Needle $oldDimBlock -Label ''BASE dimension precheck block''',
        '    $patched = $patched.Replace($oldDimBlock, $newDimBlock)',
        '    if ($patched.IndexOf($oldBaseNode,[System.StringComparison]::Ordinal) -ge 0) { throw ''Old BASE node route remains.'' }',
        '    if ($patched.IndexOf($oldBaseSave,[System.StringComparison]::Ordinal) -ge 0) { throw ''Old BASE SaveImage route remains.'' }',
        '    if ($patched.IndexOf($oldDimBlock,[System.StringComparison]::Ordinal) -ge 0) { throw ''Old dimension block remains.'' }',
        '    if ($patched.IndexOf(''Resolve-CompiledScalar'',[System.StringComparison]::Ordinal) -lt 0) { throw ''Compiled scalar resolver missing.'' }'
    ) -join "`r`n"

    $patchedWrapper = $src.Replace($oldRaw,$newRaw)
    $patchedWrapper = $patchedWrapper.Replace($marker,($marker + "`r`n" +
        "    `$oldBaseNode = Decode-B64 '$([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($oldBaseNode)))'`r`n" +
        "    `$newBaseNode = Decode-B64 '$([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($newBaseNode)))'`r`n" +
        "    `$oldBaseSave = Decode-B64 '$([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($oldBaseSave)))'`r`n" +
        "    `$newBaseSave = Decode-B64 '$([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($newBaseSave)))'`r`n" +
        "    `$oldDimBlock = Decode-B64 '$([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($oldDimBlock)))'`r`n" +
        "    `$newDimBlock = Decode-B64 '$([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($newDimBlock)))'`r`n" +
        $extra))
    $patchedWrapper = $patchedWrapper.Replace('repair wrapper v0.7','repair wrapper v0.8.3')
    $patchedWrapper = $patchedWrapper.Replace('nexia_local_flux_edit_gate_v0_7_runtime.ps1','nexia_local_flux_edit_gate_v0_8_3_inner_runtime.ps1')
    $patchedWrapper = $patchedWrapper.Replace('=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.7 ===','=== NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.3 ===')
    $patchedWrapper = $patchedWrapper.Replace('=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.7 ===','=== END NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.3 ===')

    if($patchedWrapper.IndexOf($oldRaw,[System.StringComparison]::Ordinal) -ge 0){throw 'Old _004 target remains.'}
    if($patchedWrapper.IndexOf('NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_007.json',[System.StringComparison]::Ordinal) -lt 0){throw 'New _007 target missing.'}
    if($patchedWrapper.IndexOf('Resolve-CompiledScalar',[System.StringComparison]::Ordinal) -lt 0){throw 'Resolver patch injection missing.'}

    [System.IO.File]::WriteAllText($V083Path,$patchedWrapper,[System.Text.UTF8Encoding]::new($false))
    Write-Host 'OUTER_PATCH_VERIFY: PASS | pinned v0.7 + distilled BASE route + linked-dimension resolver + _007 target'
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $V083Path
    $exitCode=$LASTEXITCODE
    Write-Host "INNER_WRAPPER_EXIT: $exitCode"
    exit $exitCode
}
finally {
    Remove-Item $V07Path,$V083Path -Force -ErrorAction SilentlyContinue
    Write-Host '=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.3 ==='
}
