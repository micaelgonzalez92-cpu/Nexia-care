# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 repair wrapper v0.8.1
# Builds on pinned v0.7 and fixes only the BASE route inside the official dual FLUX.2 Klein text-to-image template.
# BASE uses official 4B Distilled node 77 / SaveImage 78 instead of non-distilled node 75 / SaveImage 9.
# Frozen prereg, prompts, seed, models, workflow commit, 4-step/CFG1/Euler precheck, max generations and QA remain unchanged.
# Prior raw results _001-_004 are preserved; this attempt writes _005.

param()
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$PinnedV07Commit = '4ab1656351efc254ef57734201aca0b47db88954'
$V07Url = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$PinnedV07Commit/tools/nexia_local_flux_edit_gate_v0_7.ps1"
$V07Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_7_pinned.ps1'
$V081Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_8_1_runtime.ps1'

$oldRaw = '$newRawPath = ''$RawResultRepoPath = ''''runtime/NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_004.json'''''''
$newRaw = '$newRawPath = ''$RawResultRepoPath = ''''runtime/NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_005.json'''''''
$marker = '    $patched = $patched.Replace($oldInvokeJs, $newInvokeJs)'

$extra = @(
'    $oldBaseNode = "   const p=g.getNodeById(76); setv(p,''text'',0,c.prompt);`n   const n=g.getNodeById(75);"',
'    $newBaseNode = "   const p=g.getNodeById(76); setv(p,''text'',0,c.prompt);`n   const legacy=g.getNodeById(75); if(legacy) legacy.mode=4;`n   const n=g.getNodeById(77); if(!n) throw new Error(''missing distilled BASE node 77''); n.mode=0;"',
'    Assert-UniqueLiteral -Source $patched -Needle $oldBaseNode -Label ''BASE node route''',
'    $patched = $patched.Replace($oldBaseNode, $newBaseNode)',
'    $oldBaseSave = "   const s=g.getNodeById(9); setv(s,''filename_prefix'',0,''NEXIA_FLUX_BASE_GATE'');"',
'    $newBaseSave = "   const legacySave=g.getNodeById(9); if(legacySave) legacySave.mode=4;`n   const s=g.getNodeById(78); if(!s) throw new Error(''missing distilled BASE SaveImage node 78''); s.mode=0; setv(s,''filename_prefix'',0,''NEXIA_FLUX_BASE_GATE'');"',
'    Assert-UniqueLiteral -Source $patched -Needle $oldBaseSave -Label ''BASE SaveImage route''',
'    $patched = $patched.Replace($oldBaseSave, $newBaseSave)',
'    if ($patched.IndexOf($oldBaseNode, [System.StringComparison]::Ordinal) -ge 0) { throw ''Old BASE node route remains after patch.'' }',
'    if ($patched.IndexOf($oldBaseSave, [System.StringComparison]::Ordinal) -ge 0) { throw ''Old BASE SaveImage route remains after patch.'' }',
'    if ($patched.IndexOf(''missing distilled BASE node 77'', [System.StringComparison]::Ordinal) -lt 0) { throw ''Distilled BASE node repair missing.'' }',
'    if ($patched.IndexOf(''missing distilled BASE SaveImage node 78'', [System.StringComparison]::Ordinal) -lt 0) { throw ''Distilled BASE SaveImage repair missing.'' }'
) -join "`r`n"

function Assert-UniqueLiteral {
    param([string]$Source,[string]$Needle,[string]$Label)
    $first=$Source.IndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -lt 0){throw "$Label signature not found; refusing patch."}
    $last=$Source.LastIndexOf($Needle,[System.StringComparison]::Ordinal)
    if($first -ne $last){throw "$Label signature is not unique; refusing patch."}
}

try {
    Write-Host '=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.1 ==='
    Invoke-WebRequest -Uri $V07Url -UseBasicParsing -OutFile $V07Path
    $src = Get-Content -Path $V07Path -Raw
    Assert-UniqueLiteral -Source $src -Needle $oldRaw -Label 'v0.7 raw target'
    Assert-UniqueLiteral -Source $src -Needle $marker -Label 'v0.7 Invoke-Js patch marker'

    $patchedWrapper = $src.Replace($oldRaw,$newRaw)
    $patchedWrapper = $patchedWrapper.Replace($marker,($marker + "`r`n" + $extra))
    $patchedWrapper = $patchedWrapper.Replace('repair wrapper v0.7','repair wrapper v0.8.1')
    $patchedWrapper = $patchedWrapper.Replace('nexia_local_flux_edit_gate_v0_7_runtime.ps1','nexia_local_flux_edit_gate_v0_8_1_inner_runtime.ps1')
    $patchedWrapper = $patchedWrapper.Replace('=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.7 ===','=== NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.1 ===')
    $patchedWrapper = $patchedWrapper.Replace('=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.7 ===','=== END NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8.1 ===')

    if($patchedWrapper.IndexOf($oldRaw,[System.StringComparison]::Ordinal) -ge 0){throw 'Old _004 target remains.'}
    if($patchedWrapper.IndexOf('NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_005.json',[System.StringComparison]::Ordinal) -lt 0){throw 'New _005 target missing.'}
    if($patchedWrapper.IndexOf('BASE node route',[System.StringComparison]::Ordinal) -lt 0){throw 'BASE route patch injection missing.'}

    [System.IO.File]::WriteAllText($V081Path,$patchedWrapper,[System.Text.UTF8Encoding]::new($false))
    Write-Host 'OUTER_PATCH_VERIFY: PASS | pinned v0.7 + distilled BASE route repair + _005 target'
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $V081Path
    $exitCode=$LASTEXITCODE
    Write-Host "INNER_WRAPPER_EXIT: $exitCode"
    exit $exitCode
}
finally {
    Remove-Item $V07Path,$V081Path -Force -ErrorAction SilentlyContinue
    Write-Host '=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8.1 ==='
}
