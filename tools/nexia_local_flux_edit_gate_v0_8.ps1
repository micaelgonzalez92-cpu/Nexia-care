# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 repair wrapper v0.8
# Builds on pinned v0.7 repairs and fixes BASE route selection inside the official dual FLUX.2 Klein text-to-image template.
# It selects the existing 4B Distilled subgraph (node 77 / SaveImage 78) instead of the non-distilled path (node 75 / SaveImage 9).
# Frozen prereg, prompts, seed, models, workflow commit, 4-step/CFG1/Euler precheck, max generations and QA remain unchanged.
# Prior raw results _001/_002/_003/_004 are preserved; this attempt writes _005.

param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$PinnedV07Commit = '4ab1656351efc254ef57734201aca0b47db88954'
$V07Url = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$PinnedV07Commit/tools/nexia_local_flux_edit_gate_v0_7.ps1"
$V07Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_7_pinned.ps1'
$V08Path = Join-Path $env:TEMP 'nexia_local_flux_edit_gate_v0_8_runtime.ps1'

$oldRawTarget = '$newRawPath = ''$RawResultRepoPath = ''''runtime/NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_004.json'''''''
$newRawTarget = '$newRawPath = ''$RawResultRepoPath = ''''runtime/NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_005.json'''''''

$oldPatchSequence = @'
    $patched = $patched.Replace($oldInvokeJs, $newInvokeJs)
    $patched = $patched.Replace($oldRawPath, $newRawPath)
'@

$newPatchSequence = @'
    $patched = $patched.Replace($oldInvokeJs, $newInvokeJs)

    $oldBaseRoute = @'
 if(c.mode==='BASE'){
   const p=g.getNodeById(76); setv(p,'text',0,c.prompt);
   const n=g.getNodeById(75);
   setv(n,'value',null,c.width); setv(n,'value_1',null,c.height); setv(n,'unet_name',null,c.unet); setv(n,'clip_name',null,c.clip); setv(n,'vae_name',null,c.vae); setv(n,'noise_seed',null,c.seed);
   const f=(n.widgets||[]).find(x=>x.name==='control_after_generate'); if(f) f.value='fixed';
   const s=g.getNodeById(9); setv(s,'filename_prefix',0,'NEXIA_FLUX_BASE_GATE');
 } else {
'@
    $newBaseRoute = @'
 if(c.mode==='BASE'){
   const p=g.getNodeById(76); setv(p,'text',0,c.prompt);
   const legacy=g.getNodeById(75); if(legacy) legacy.mode=4;
   const legacySave=g.getNodeById(9); if(legacySave) legacySave.mode=4;
   const n=g.getNodeById(77); if(!n) throw new Error('missing distilled BASE node 77'); n.mode=0;
   setv(n,'value',null,c.width); setv(n,'value_1',null,c.height); setv(n,'unet_name',null,c.unet); setv(n,'clip_name',null,c.clip); setv(n,'vae_name',null,c.vae); setv(n,'noise_seed',null,c.seed);
   const f=(n.widgets||[]).find(x=>x.name==='control_after_generate'); if(f) f.value='fixed';
   const s=g.getNodeById(78); if(!s) throw new Error('missing distilled BASE SaveImage node 78'); s.mode=0; setv(s,'filename_prefix',0,'NEXIA_FLUX_BASE_GATE');
 } else {
'@
    Assert-UniqueLiteral -Source $patched -Needle $oldBaseRoute -Label 'BASE non-distilled route block'
    $patched = $patched.Replace($oldBaseRoute, $newBaseRoute)
    if ($patched.IndexOf($oldBaseRoute, [System.StringComparison]::Ordinal) -ge 0) { throw 'Old non-distilled BASE route remains after patch.' }
    if ($patched.IndexOf("const n=g.getNodeById(77); if(!n) throw new Error('missing distilled BASE node 77'); n.mode=0;", [System.StringComparison]::Ordinal) -lt 0) { throw 'Distilled BASE node selection missing after patch.' }
    if ($patched.IndexOf("const s=g.getNodeById(78); if(!s) throw new Error('missing distilled BASE SaveImage node 78'); s.mode=0;", [System.StringComparison]::Ordinal) -lt 0) { throw 'Distilled BASE SaveImage selection missing after patch.' }

    $patched = $patched.Replace($oldRawPath, $newRawPath)
'@

function Assert-UniqueLiteral {
    param([string]$Source, [string]$Needle, [string]$Label)
    $first = $Source.IndexOf($Needle, [System.StringComparison]::Ordinal)
    if ($first -lt 0) { throw "$Label signature not found; refusing patch." }
    $last = $Source.LastIndexOf($Needle, [System.StringComparison]::Ordinal)
    if ($first -ne $last) { throw "$Label signature is not unique; refusing patch." }
}

try {
    Write-Host '=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8 ==='
    Invoke-WebRequest -Uri $V07Url -UseBasicParsing -OutFile $V07Path
    $src = Get-Content -Path $V07Path -Raw

    Assert-UniqueLiteral -Source $src -Needle $oldRawTarget -Label 'v0.7 new raw-result target'
    Assert-UniqueLiteral -Source $src -Needle $oldPatchSequence -Label 'v0.7 patch sequence'

    $patchedWrapper = $src.Replace($oldRawTarget, $newRawTarget)
    $patchedWrapper = $patchedWrapper.Replace($oldPatchSequence, $newPatchSequence)
    $patchedWrapper = $patchedWrapper.Replace('repair wrapper v0.7', 'repair wrapper v0.8')
    $patchedWrapper = $patchedWrapper.Replace('nexia_local_flux_edit_gate_v0_7_runtime.ps1', 'nexia_local_flux_edit_gate_v0_8_inner_runtime.ps1')
    $patchedWrapper = $patchedWrapper.Replace('=== NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.7 ===', '=== NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8 ===')
    $patchedWrapper = $patchedWrapper.Replace('=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.7 ===', '=== END NEXIA FLUX-EDIT BRIDGE REPAIR INNER v0.8 ===')
    $patchedWrapper = $patchedWrapper.Replace('PATCH_VERIFY: PASS | 404/no-BOM/CDP-output/target/strict-property repairs present; prior raw results preserved; frozen experiment invariants present', 'PATCH_VERIFY: PASS | prior transport/CDP repairs present; distilled BASE route enforced; prior raw results preserved; frozen experiment invariants present')

    if ($patchedWrapper.IndexOf($oldRawTarget, [System.StringComparison]::Ordinal) -ge 0) { throw 'Old _004 target remains in v0.8 wrapper.' }
    if ($patchedWrapper.IndexOf($oldPatchSequence, [System.StringComparison]::Ordinal) -ge 0) { throw 'Old v0.7 patch sequence remains in v0.8 wrapper.' }
    if ($patchedWrapper.IndexOf('NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_005.json', [System.StringComparison]::Ordinal) -lt 0) { throw 'New _005 raw-result target missing.' }
    if ($patchedWrapper.IndexOf('missing distilled BASE node 77', [System.StringComparison]::Ordinal) -lt 0) { throw 'Distilled BASE route repair missing.' }

    [System.IO.File]::WriteAllText($V08Path, $patchedWrapper, [System.Text.UTF8Encoding]::new($false))
    Write-Host 'OUTER_PATCH_VERIFY: PASS | v0.7 pinned; BASE route repair injected; _001-_004 preserved; _005 target present'

    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $V08Path
    $exitCode = $LASTEXITCODE
    Write-Host "INNER_WRAPPER_EXIT: $exitCode"
    exit $exitCode
}
finally {
    Remove-Item $V07Path,$V08Path -Force -ErrorAction SilentlyContinue
    Write-Host '=== END NEXIA FLUX-EDIT BRIDGE REPAIR WRAPPER v0.8 ==='
}
