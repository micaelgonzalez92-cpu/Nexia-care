# NEXIA FLUX GENERATE_BASE HTTP500 DIAG v0.1
# Read-only postmortem for v0.8.3. No ComfyUI start, no POST /prompt, no queue mutation, no generation.
param()
$ErrorActionPreference='Stop'
Set-StrictMode -Version 2.0

$ProjectRoot='C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\creative-benchmark-2026-10-12\ComfyUI_windows_portable'
$ComfyRoot=Join-Path $ProjectRoot 'ComfyUI'
$OutputDir='C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\flux-edit-base-b1-b2-2026-10-16'
$ComfyOutput=Join-Path $ComfyRoot 'output'
$BasePromptPath=Join-Path $OutputDir 'BASE.api_prompt.json'
$BaseWorkflowPath=Join-Path $OutputDir 'BASE.workflow.json'
$StdoutPath=Join-Path $OutputDir 'comfyui.stdout.log'
$StderrPath=Join-Path $OutputDir 'comfyui.stderr.log'
$RunStart=[DateTimeOffset]::Parse('2026-10-17T00:10:44.1269614+02:00').LocalDateTime

function Sha256([string]$p){ if(Test-Path $p){(Get-FileHash $p -Algorithm SHA256).Hash.ToLowerInvariant()}else{$null} }
function Tail([string]$p,[int]$n){ if(Test-Path $p){ @(Get-Content $p -Tail $n -ErrorAction Stop) } else { @() } }

Write-Host '=== NEXIA FLUX GENERATE_BASE HTTP500 DIAG v0.1 ==='
Write-Host 'SCOPE: read-only postmortem; no server start; no POST /prompt; no generation.'

$promptExists=Test-Path $BasePromptPath
$workflowExists=Test-Path $BaseWorkflowPath
Write-Host ("BASE_API_PROMPT_EXISTS: {0}" -f $promptExists)
Write-Host ("BASE_API_PROMPT_SHA256: {0}" -f (Sha256 $BasePromptPath))
Write-Host ("BASE_WORKFLOW_EXISTS: {0}" -f $workflowExists)
Write-Host ("BASE_WORKFLOW_SHA256: {0}" -f (Sha256 $BaseWorkflowPath))

if($promptExists){
    $p=Get-Content $BasePromptPath -Raw | ConvertFrom-Json
    $props=@($p.PSObject.Properties)
    Write-Host ("BASE_PROMPT_NODE_COUNT: {0}" -f $props.Count)
    $classes=@($props | ForEach-Object { $ct=$_.Value.PSObject.Properties['class_type']; if($null-ne $ct){[string]$ct.Value} } | Where-Object { $_ } | Sort-Object -Unique)
    Write-Host ('BASE_PROMPT_CLASS_TYPES: '+($classes -join ','))

    foreach($prop in $props){
        $node=$prop.Value
        $ctProp=$node.PSObject.Properties['class_type']; if($null-eq $ctProp){continue}
        $ct=[string]$ctProp.Value
        if($ct -in @('Flux2Scheduler','KSamplerSelect','CFGGuider','UNETLoader','CLIPLoader','VAELoader','DualCLIPLoader','EmptyFlux2LatentImage','PrimitiveInt')){
            $inputsProp=$node.PSObject.Properties['inputs']
            $inputs=if($null-ne $inputsProp){$inputsProp.Value}else{$null}
            $entry=[ordered]@{node_id=[string]$prop.Name;class_type=$ct;inputs=$inputs}
            Write-Host ('BASE_NODE_JSON: '+($entry|ConvertTo-Json -Compress -Depth 20))
        }
    }
}

$files=@()
if(Test-Path $ComfyOutput){
    $files=@(Get-ChildItem $ComfyOutput -File -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'NEXIA_FLUX_BASE_GATE*' -and $_.LastWriteTime -ge $RunStart.AddSeconds(-5) } | Sort-Object LastWriteTime)
}
Write-Host ("BASE_OUTPUT_FILE_COUNT_SINCE_RUN: {0}" -f $files.Count)
foreach($f in $files){
    $entry=[ordered]@{path=$f.FullName;length=$f.Length;last_write=$f.LastWriteTime.ToString('o');sha256=(Sha256 $f.FullName)}
    Write-Host ('BASE_OUTPUT_FILE_JSON: '+($entry|ConvertTo-Json -Compress))
}

Write-Host ("COMFY_STDOUT_EXISTS: {0}" -f (Test-Path $StdoutPath))
Write-Host 'COMFY_STDOUT_TAIL_BEGIN'
Tail $StdoutPath 160 | ForEach-Object { Write-Host $_ }
Write-Host 'COMFY_STDOUT_TAIL_END'
Write-Host ("COMFY_STDERR_EXISTS: {0}" -f (Test-Path $StderrPath))
Write-Host 'COMFY_STDERR_TAIL_BEGIN'
Tail $StderrPath 160 | ForEach-Object { Write-Host $_ }
Write-Host 'COMFY_STDERR_TAIL_END'

Write-Host 'NO_PROMPT_POSTED_BY_DIAG: TRUE'
Write-Host 'GENERATIONS_EXECUTED_BY_DIAG: 0'
Write-Host '=== END NEXIA FLUX GENERATE_BASE HTTP500 DIAG v0.1 ==='
