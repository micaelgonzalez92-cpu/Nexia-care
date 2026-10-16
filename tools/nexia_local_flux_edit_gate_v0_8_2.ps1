# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 repair wrapper v0.8.2
# Builds on pinned v0.8.1 and repairs only StrictMode-safe BASE width/height discovery.
# The 1024x1024 requirement itself remains unchanged.
# Prior raw results _001-_005 are preserved; this attempt writes _006.

param()
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$PinnedV081Commit = 'e42841c1dd735fa4f45a8651125b80f4b5c302f6'
$V081Url = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$PinnedV081Commit/tools/nexia_local_flux_edit_gate_v0_8_1.ps1"
$V081Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_8_1_pinned.ps1'
$V082Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_8_2_runtime.ps1'

$oldRaw = '$newRaw = ''$newRawPath = ''''$RawResultRepoPath = ''''''''runtime/NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_005.json'''''''''''''''
$newRaw = '$newRaw = ''$newRawPath = ''''$RawResultRepoPath = ''''''''runtime/NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_006.json'''''''''''''''
$anchor = '''    if ($patched.IndexOf(''''missing distilled BASE SaveImage node 78'''', [System.StringComparison]::Ordinal) -lt 0) { throw ''''Distilled BASE SaveImage repair missing.'''' }'''

$replacement = @(
'''    if ($patched.IndexOf(''''missing distilled BASE SaveImage node 78'''', [System.StringComparison]::Ordinal) -lt 0) { throw ''''Distilled BASE SaveImage repair missing.'''' }''',
'''    $oldDimLine = ''''        $dimNodes = @($nodes | Where-Object { ($null -ne $_.inputs.width) -and ($null -ne $_.inputs.height) })''''''',
'''    $newDimLine = ''''        $dimNodes = @($nodes | Where-Object { $ip = $_.PSObject.Properties[''''"''''"''''inputs''''"''''"'''']; if ($null -eq $ip -or $null -eq $ip.Value) { $false } else { ($null -ne $ip.Value.PSObject.Properties[''''"''''"''''width''''"''''"'''']) -and ($null -ne $ip.Value.PSObject.Properties[''''"''''"''''height''''"''''"'''']) } })''''''',
'''    Assert-UniqueLiteral -Source $patched -Needle $oldDimLine -Label ''''BASE dimension discovery''''''',
'''    $patched = $patched.Replace($oldDimLine, $newDimLine)''',
'''    if ($patched.IndexOf($oldDimLine, [System.StringComparison]::Ordinal) -ge 0) { throw ''''Old StrictMode-unsafe dimension discovery remains after patch.'''' }''',
'''    if ($patched.IndexOf(''''PSObject.Properties[''''"''''"''''width''''"''''"'''']'''', [System.StringComparison]::Ordinal) -lt 0) { throw ''''Strict-safe width discovery missing.'''' }'''
) -join "`r`n"

function Assert-UniqueLiteral {
    param([string]$Source,[string]$Needle,[string]$Label)
    $first=$Source.IndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -lt 0){throw "$Label signature not found; refusing patch."}
    $last=$Source.LastIndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -ne $last){throw "$Label signature is not unique; refusing patch."}
}

try {
    Write-Host '=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.2 ==='
    Invoke-WebRequest -Uri $V081Url -UseBasicParsing -OutFile $V081Path
    $src = Get-Content -Path $V081Path -Raw
    Assert-UniqueLiteral -Source $src -Needle $oldRaw -Label 'v0.8.1 raw target'
    Assert-UniqueLiteral -Source $src -Needle $anchor -Label 'v0.8.1 extra-array anchor'

    $patched = $src.Replace($oldRaw,$newRaw)
    $patched = $patched.Replace($anchor,$replacement)
    $patched = $patched.Replace('repair wrapper v0.8.1','repair wrapper v0.8.2')
    $patched = $patched.Replace('nexia_local_flux_edit_gate_v0_8_1_runtime.ps1','nexia_local_flux_edit_gate_v0_8_2_inner_runtime.ps1')
    $patched = $patched.Replace('=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.1 ===','=== NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.2 ===')
    $patched = $patched.Replace('=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.1 ===','=== END NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.2 ===')

    if($patched.IndexOf($oldRaw,[System.StringComparison]::Ordinal) -ge 0){throw 'Old _005 target remains.'}
    if($patched.IndexOf('NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_006.json',[System.StringComparison]::Ordinal) -lt 0){throw 'New _006 target missing.'}
    if($patched.IndexOf('BASE dimension discovery',[System.StringComparison]::Ordinal) -lt 0){throw 'Dimension repair injection missing.'}

    [System.IO.File]::WriteAllText($V082Path,$patched,[System.Text.UTF8Encoding]::new($false))
    Write-Host 'OUTER_PATCH_VERIFY: PASS | pinned v0.8.1 + strict-safe dimension discovery + _006 target'
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $V082Path
    $exitCode=$LASTEXITCODE
    Write-Host "INNER_WRAPPER_EXIT: $exitCode"
    exit $exitCode
}
finally {
    Remove-Item $V081Path,$V082Path -Force -ErrorAction SilentlyContinue
    Write-Host '=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.2 ==='
}
