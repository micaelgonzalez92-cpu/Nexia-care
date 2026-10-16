# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 repair wrapper v0.8.2
# Builds directly on pinned v0.7 with two bounded repairs already justified by prior zero-generation evidence:
# 1) select the official distilled BASE route (node77 / SaveImage78),
# 2) make BASE width/height discovery safe under StrictMode without relaxing the 1024x1024 requirement.
# Frozen prereg, prompts, seed, models, workflow commit, 4-step/CFG1/Euler precheck, generation cap and QA remain unchanged.
# Prior raw results _001-_005 are preserved; this attempt writes _006.

param()
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$PinnedV07Commit = '4ab1656351efc254ef57734201aca0b47db88954'
$V07Url = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$PinnedV07Commit/tools/nexia_local_flux_edit_gate_v0_7.ps1"
$V07Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_7_pinned.ps1'
$V082Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_8_2_runtime.ps1'

function Decode-B64([string]$s) { [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($s)) }
function Assert-UniqueLiteral {
    param([string]$Source,[string]$Needle,[string]$Label)
    $first=$Source.IndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -lt 0){throw "$Label signature not found; refusing patch."}
    $last=$Source.LastIndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -ne $last){throw "$Label signature is not unique; refusing patch."}
}

$oldRaw = Decode-B64 'JG5ld1Jhd1BhdGggPSAnJFJhd1Jlc3VsdFJlcG9QYXRoID0gJydydW50aW1lL05FWElBX0ZMVVhfSU1BR0VfRURJVF9CUklER0VfUkFXX1JFU1VMVF8wMDQuanNvbicnJw=='
$newRaw = Decode-B64 'JG5ld1Jhd1BhdGggPSAnJFJhd1Jlc3VsdFJlcG9QYXRoID0gJydydW50aW1lL05FWElBX0ZMVVhfSU1BR0VfRURJVF9CUklER0VfUkFXX1JFU1VMVF8wMDYuanNvbicnJw=='
$marker = Decode-B64 'ICAgICRwYXRjaGVkID0gJHBhdGNoZWQuUmVwbGFjZSgkb2xkSW52b2tlSnMsICRuZXdJbnZva2VKcyk='
$extra = Decode-B64 'ICAgICRvbGRCYXNlTm9kZSA9ICIgICBjb25zdCBwPWcuZ2V0Tm9kZUJ5SWQoNzYpOyBzZXR2KHAsJ3RleHQnLDAsYy5wcm9tcHQpO2BuICAgY29uc3Qgbj1nLmdldE5vZGVCeUlkKDc1KTsiCiAgICAkbmV3QmFzZU5vZGUgPSAiICAgY29uc3QgcD1nLmdldE5vZGVCeUlkKDc2KTsgc2V0dihwLCd0ZXh0JywwLGMucHJvbXB0KTtgbiAgIGNvbnN0IGxlZ2FjeT1nLmdldE5vZGVCeUlkKDc1KTsgaWYobGVnYWN5KSBsZWdhY3kubW9kZT00O2BuICAgY29uc3Qgbj1nLmdldE5vZGVCeUlkKDc3KTsgaWYoIW4pIHRocm93IG5ldyBFcnJvcignbWlzc2luZyBkaXN0aWxsZWQgQkFTRSBub2RlIDc3Jyk7IG4ubW9kZT0wOyIKICAgIEFzc2VydC1VbmlxdWVMaXRlcmFsIC1Tb3VyY2UgJHBhdGNoZWQgLU5lZWRsZSAkb2xkQmFzZU5vZGUgLUxhYmVsICdCQVNFIG5vZGUgcm91dGUnCiAgICAkcGF0Y2hlZCA9ICRwYXRjaGVkLlJlcGxhY2UoJG9sZEJhc2VOb2RlLCAkbmV3QmFzZU5vZGUpCiAgICAkb2xkQmFzZVNhdmUgPSAiICAgY29uc3Qgcz1nLmdldE5vZGVCeUlkKDkpOyBzZXR2KHMsJ2ZpbGVuYW1lX3ByZWZpeCcsMCwnTkVYSUFfRkxVWF9CQVNFX0dBVEUnKTsiCiAgICAkbmV3QmFzZVNhdmUgPSAiICAgY29uc3QgbGVnYWN5U2F2ZT1nLmdldE5vZGVCeUlkKDkpOyBpZihsZWdhY3lTYXZlKSBsZWdhY3lTYXZlLm1vZGU9NDtgbiAgIGNvbnN0IHM9Zy5nZXROb2RlQnlJZCg3OCk7IGlmKCFzKSB0aHJvdyBuZXcgRXJyb3IoJ21pc3NpbmcgZGlzdGlsbGVkIEJBU0UgU2F2ZUltYWdlIG5vZGUgNzgnKTsgcy5tb2RlPTA7IHNldHYocywnZmlsZW5hbWVfcHJlZml4JywwLCdORVhJQV9GTFVYX0JBU0VfR0FURScpOyIKICAgIEFzc2VydC1VbmlxdWVMaXRlcmFsIC1Tb3VyY2UgJHBhdGNoZWQgLU5lZWRsZSAkb2xkQmFzZVNhdmUgLUxhYmVsICdCQVNFIFNhdmVJbWFnZSByb3V0ZScKICAgICRwYXRjaGVkID0gJHBhdGNoZWQuUmVwbGFjZSgkb2xkQmFzZVNhdmUsICRuZXdCYXNlU2F2ZSkKICAgIGlmICgkcGF0Y2hlZC5JbmRleE9mKCRvbGRCYXNlTm9kZSwgW1N5c3RlbS5TdHJpbmdDb21wYXJpc29uXTo6T3JkaW5hbCkgLWdlIDApIHsgdGhyb3cgJ09sZCBCQVNFIG5vZGUgcm91dGUgcmVtYWlucyBhZnRlciBwYXRjaC4nIH0KICAgIGlmICgkcGF0Y2hlZC5JbmRleE9mKCRvbGRCYXNlU2F2ZSwgW1N5c3RlbS5TdHJpbmdDb21wYXJpc29uXTo6T3JkaW5hbCkgLWdlIDApIHsgdGhyb3cgJ09sZCBCQVNFIFNhdmVJbWFnZSByb3V0ZSByZW1haW5zIGFmdGVyIHBhdGNoLicgfQogICAgaWYgKCRwYXRjaGVkLkluZGV4T2YoJ21pc3NpbmcgZGlzdGlsbGVkIEJBU0Ugbm9kZSA3NycsIFtTeXN0ZW0uU3RyaW5nQ29tcGFyaXNvbl06Ok9yZGluYWwpIC1sdCAwKSB7IHRocm93ICdEaXN0aWxsZWQgQkFTRSBub2RlIHJlcGFpciBtaXNzaW5nLicgfQogICAgaWYgKCRwYXRjaGVkLkluZGV4T2YoJ21pc3NpbmcgZGlzdGlsbGVkIEJBU0UgU2F2ZUltYWdlIG5vZGUgNzgnLCBbU3lzdGVtLlN0cmluZ0NvbXBhcmlzb25dOjpPcmRpbmFsKSAtbHQgMCkgeyB0aHJvdyAnRGlzdGlsbGVkIEJBU0UgU2F2ZUltYWdlIHJlcGFpciBtaXNzaW5nLicgfQoKICAgICRvbGREaW1MaW5lID0gJyAgICAgICAgJGRpbU5vZGVzID0gQCgkbm9kZXMgfCBXaGVyZS1PYmplY3QgeyAoJG51bGwgLW5lICRfLmlucHV0cy53aWR0aCkgLWFuZCAoJG51bGwgLW5lICRfLmlucHV0cy5oZWlnaHQpIH0pJwogICAgJG5ld0RpbUxpbmUgPSAnICAgICAgICAkZGltTm9kZXMgPSBAKCRub2RlcyB8IFdoZXJlLU9iamVjdCB7ICRpcCA9ICRfLlBTT2JqZWN0LlByb3BlcnRpZXNbJydpbnB1dHMnJ107IGlmICgkbnVsbCAtZXEgJGlwIC1vciAkbnVsbCAtZXEgJGlwLlZhbHVlKSB7ICRmYWxzZSB9IGVsc2UgeyAoJG51bGwgLW5lICRpcC5WYWx1ZS5QU09iamVjdC5Qcm9wZXJ0aWVzWycnd2lkdGgnJ10pIC1hbmQgKCRudWxsIC1uZSAkaXAuVmFsdWUuUFNPYmplY3QuUHJvcGVydGllc1snJ2hlaWdodCcnXSkgfSB9KScKICAgIEFzc2VydC1VbmlxdWVMaXRlcmFsIC1Tb3VyY2UgJHBhdGNoZWQgLU5lZWRsZSAkb2xkRGltTGluZSAtTGFiZWwgJ0JBU0UgZGltZW5zaW9uIGRpc2NvdmVyeScKICAgICRwYXRjaGVkID0gJHBhdGNoZWQuUmVwbGFjZSgkb2xkRGltTGluZSwgJG5ld0RpbUxpbmUpCiAgICBpZiAoJHBhdGNoZWQuSW5kZXhPZigkb2xkRGltTGluZSwgW1N5c3RlbS5TdHJpbmdDb21wYXJpc29uXTo6T3JkaW5hbCkgLWdlIDApIHsgdGhyb3cgJ09sZCBTdHJpY3RNb2RlLXVuc2FmZSBkaW1lbnNpb24gZGlzY292ZXJ5IHJlbWFpbnMgYWZ0ZXIgcGF0Y2guJyB9CiAgICBpZiAoJHBhdGNoZWQuSW5kZXhPZigiUFNPYmplY3QuUHJvcGVydGllc1snd2lkdGgnXSIsIFtTeXN0ZW0uU3RyaW5nQ29tcGFyaXNvbl06Ok9yZGluYWwpIC1sdCAwKSB7IHRocm93ICdTdHJpY3Qtc2FmZSB3aWR0aCBkaXNjb3ZlcnkgbWlzc2luZy4nIH0='

try {
    Write-Host '=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.2 ==='
    Invoke-WebRequest -Uri $V07Url -UseBasicParsing -OutFile $V07Path
    $src = Get-Content -Path $V07Path -Raw
    Assert-UniqueLiteral -Source $src -Needle $oldRaw -Label 'v0.7 raw target'
    Assert-UniqueLiteral -Source $src -Needle $marker -Label 'v0.7 Invoke-Js patch marker'

    $patchedWrapper = $src.Replace($oldRaw,$newRaw)
    $patchedWrapper = $patchedWrapper.Replace($marker,($marker + "`r`n" + $extra))
    $patchedWrapper = $patchedWrapper.Replace('repair wrapper v0.7','repair wrapper v0.8.2')
    $patchedWrapper = $patchedWrapper.Replace('nexia_local_flux_edit_gate_v0_7_runtime.ps1','nexia_local_flux_edit_gate_v0_8_2_inner_runtime.ps1')
    $patchedWrapper = $patchedWrapper.Replace('=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.7 ===','=== NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.2 ===')
    $patchedWrapper = $patchedWrapper.Replace('=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.7 ===','=== END NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.2 ===')

    if($patchedWrapper.IndexOf($oldRaw,[System.StringComparison]::Ordinal) -ge 0){throw 'Old _004 target remains.'}
    if($patchedWrapper.IndexOf('NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_006.json',[System.StringComparison]::Ordinal) -lt 0){throw 'New _006 target missing.'}
    if($patchedWrapper.IndexOf('BASE dimension discovery',[System.StringComparison]::Ordinal) -lt 0){throw 'Dimension repair injection missing.'}
    if($patchedWrapper.IndexOf('missing distilled BASE node 77',[System.StringComparison]::Ordinal) -lt 0){throw 'Distilled BASE route injection missing.'}

    [System.IO.File]::WriteAllText($V082Path,$patchedWrapper,[System.Text.UTF8Encoding]::new($false))
    Write-Host 'OUTER_PATCH_VERIFY: PASS | pinned v0.7 + distilled BASE route + strict-safe dimensions + _006 target'
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $V082Path
    $exitCode=$LASTEXITCODE
    Write-Host "INNER_WRAPPER_EXIT: $exitCode"
    exit $exitCode
}
finally {
    Remove-Item $V07Path,$V082Path -Force -ErrorAction SilentlyContinue
    Write-Host '=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.2 ==='
}
