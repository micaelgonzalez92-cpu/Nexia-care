# NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001
# Bounded local runner for the preregistered Base/B1/B2 FLUX image-edit gate.
# No installs, model downloads, runtime updates, paid APIs, recurring services, publication or external business effects.

param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$Repo = 'micaelgonzalez92-cpu/Nexia-care'
$TaskId = 'FLUX-EDIT-BRIDGE-ONESHOT-001'
$PreregPath = 'research/NEXIA_FLUX_IMAGE_EDIT_BASE_B1_B2_PREREG_V1_2026-10-16.md'
$PreregBlob = '8276613aff9ba9aca0eec840fc8e0c2f36bca622'
$RawResultRepoPath = 'runtime/NEXIA_FLUX_IMAGE_EDIT_BRIDGE_RAW_RESULT_001.json'
$Seed = 20261016
$ComfyBase = 'http://127.0.0.1:8188'
$CdpBase = 'http://127.0.0.1:9224'
$PinnedWorkflowCommit = '04a508b31bec1818e48122ca0761c1de4140a234'
$T2IWorkflowUrl = "https://raw.githubusercontent.com/Comfy-Org/workflow_templates/$PinnedWorkflowCommit/templates/image_flux2_klein_text_to_image.json"
$EditWorkflowUrl = "https://raw.githubusercontent.com/Comfy-Org/workflow_templates/$PinnedWorkflowCommit/templates/image_flux2_klein_image_edit_4b_distilled.json"

$ProjectRoot = 'C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\creative-benchmark-2026-10-12\ComfyUI_windows_portable'
$ComfyRoot = Join-Path $ProjectRoot 'ComfyUI'
$PythonExe = Join-Path $ProjectRoot 'python_embeded\python.exe'
$ComfyMain = Join-Path $ComfyRoot 'main.py'
$OutputDir = 'C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\flux-edit-base-b1-b2-2026-10-16'
$InputReferenceName = 'NEXIA_FLUX_BASE_REFERENCE_20261016.png'
$InputReferencePath = Join-Path (Join-Path $ComfyRoot 'input') $InputReferenceName
$BrowserProfile = Join-Path $env:LOCALAPPDATA 'NEXIA\flux-edit-bridge-profile-001'

$Model = 'flux-2-klein-4b-fp8.safetensors'
$Clip = 'qwen_3_4b.safetensors'
$Vae = 'flux2-vae.safetensors'
$BasePrompt = 'A single matte dark-blue storage box with a black lid, centered on a light gray tabletop, neutral gray studio background, soft even lighting, realistic product photo, front three-quarter view, clean composition, no hands, no people, no extra objects, no text.'
$B1Prompt = 'Change the background to a warm beige interior with a light oak tabletop.'
$B2Prompt = 'Edit the image while preserving the main product exactly: keep one single matte dark-blue storage box with a black lid, preserve its shape, color, size, position, orientation, and proportions. Do not add or remove objects. Do not duplicate the box. Do not change the lid. Only change the environment: replace the neutral gray studio background with a warm beige interior background and a light oak tabletop. Keep the image realistic, clean, and commercially usable.'

$script:ComfyStarted = $false
$script:ComfyProcess = $null
$script:BrowserStarted = $false
$script:BrowserProcess = $null
$script:CdpSocket = $null
$script:CdpId = 100
$script:RemoteResultAlreadyExists = $false
$script:GenerationCount = 0

$Result = [ordered]@{
    task_id = $TaskId
    status = 'STARTED_NOT_COMPLETE'
    prereg_path = $PreregPath
    prereg_blob_sha = $PreregBlob
    authorization = 'EXPLICIT_KAEL_ONE_SHOT'
    started_at = (Get-Date).ToString('o')
    finished_at = $null
    generation_count = 0
    max_generations = 3
    no_retries = $true
    seed = $Seed
    base_resolution = '1024x1024'
    comfyui_version = $null
    comfyui_started_by_runner = $false
    browser_started_by_runner = $false
    workflow_commit = $PinnedWorkflowCommit
    variants = [ordered]@{}
    base_human_gate = 'NOT_REACHED'
    b1_b2_settings_equivalent_except_prompt = 'NOT_VERIFIED'
    visual_qa_b1_b2 = 'NOT_VERIFIED_PENDING_CHAT_REVIEW'
    local_flux_image_editing = 'NOT_VERIFIED'
    prompt_engineering_effect = 'NOT_VERIFIED'
    writeback = 'NOT_ATTEMPTED'
    error_stage = $null
    error = $null
    cost_eur = 0
}

function Get-Sha256([string]$Path) {
    return (Get-FileHash -Path $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Get-StringSha256([string]$Text) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
        return ([System.BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-', '').ToLowerInvariant()
    }
    finally { $sha.Dispose() }
}

function Write-JsonFile($Object, [string]$Path) {
    $Object | ConvertTo-Json -Depth 100 | Set-Content -Path $Path -Encoding UTF8
}

function Test-ComfyReady {
    try {
        $null = Invoke-RestMethod -Uri "$ComfyBase/system_stats" -Method Get -TimeoutSec 3
        return $true
    } catch { return $false }
}

function Start-ComfyIfNeeded {
    if (Test-ComfyReady) { return }
    if (-not (Test-Path $PythonExe)) { throw "Embedded Python not found: $PythonExe" }
    if (-not (Test-Path $ComfyMain)) { throw "ComfyUI main.py not found: $ComfyMain" }
    $stdout = Join-Path $OutputDir 'comfyui.stdout.log'
    $stderr = Join-Path $OutputDir 'comfyui.stderr.log'
    $args = @('-s', $ComfyMain, '--windows-standalone-build', '--listen', '127.0.0.1', '--port', '8188', '--disable-auto-launch')
    $script:ComfyProcess = Start-Process -FilePath $PythonExe -ArgumentList $args -WorkingDirectory $ComfyRoot -RedirectStandardOutput $stdout -RedirectStandardError $stderr -PassThru
    $script:ComfyStarted = $true
    $Result.comfyui_started_by_runner = $true
    for ($i = 0; $i -lt 120; $i++) {
        Start-Sleep -Seconds 1
        if (Test-ComfyReady) { return }
        if ($script:ComfyProcess.HasExited) { throw "ComfyUI exited during startup. See $stderr" }
    }
    throw 'ComfyUI localhost did not become ready within 120 seconds.'
}

function Find-BrowserExe {
    $candidates = @(
        'C:\Program Files\Google\Chrome\Application\chrome.exe',
        'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe',
        'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
        'C:\Program Files\Microsoft\Edge\Application\msedge.exe'
    )
    foreach ($p in $candidates) { if (Test-Path $p) { return $p } }
    throw 'No existing Chrome/Edge executable found. No browser installation is authorized.'
}

function Invoke-Cdp {
    param([string]$Method, [hashtable]$Params)
    $script:CdpId++
    $payload = [ordered]@{ id = $script:CdpId; method = $Method }
    if ($null -ne $Params) { $payload.params = $Params }
    $json = $payload | ConvertTo-Json -Compress -Depth 50
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $segment = [System.ArraySegment[byte]]::new($bytes)
    $null = $script:CdpSocket.SendAsync($segment, [System.Net.WebSockets.WebSocketMessageType]::Text, $true, [System.Threading.CancellationToken]::None).GetAwaiter().GetResult()
    while ($true) {
        $stream = New-Object System.IO.MemoryStream
        try {
            do {
                $buffer = New-Object byte[] 65536
                $recvSegment = [System.ArraySegment[byte]]::new($buffer)
                $recv = $script:CdpSocket.ReceiveAsync($recvSegment, [System.Threading.CancellationToken]::None).GetAwaiter().GetResult()
                if ($recv.MessageType -eq [System.Net.WebSockets.WebSocketMessageType]::Close) { throw 'CDP socket closed unexpectedly.' }
                $stream.Write($buffer, 0, $recv.Count)
            } until ($recv.EndOfMessage)
            $msg = ([System.Text.Encoding]::UTF8.GetString($stream.ToArray())) | ConvertFrom-Json
            if (($null -ne $msg.id) -and ([int]$msg.id -eq $script:CdpId)) { return $msg }
        }
        finally { $stream.Dispose() }
    }
}

function Invoke-Js([string]$Expression) {
    $r = Invoke-Cdp -Method 'Runtime.evaluate' -Params @{
        expression = $Expression
        returnByValue = $true
        awaitPromise = $true
    }
    if ($null -ne $r.result.exceptionDetails) {
        throw "Browser JS exception: $($r.result.exceptionDetails.text)"
    }
    return $r.result.result.value
}

function Start-ComfyBrowser {
    $exe = Find-BrowserExe
    if (Test-Path $BrowserProfile) { Remove-Item -Path $BrowserProfile -Recurse -Force -ErrorAction SilentlyContinue }
    New-Item -Path $BrowserProfile -ItemType Directory -Force | Out-Null
    $args = @(
        '--remote-debugging-port=9224',
        '--remote-debugging-address=127.0.0.1',
        "--user-data-dir=$BrowserProfile",
        '--no-first-run',
        '--no-default-browser-check',
        $ComfyBase
    )
    $script:BrowserProcess = Start-Process -FilePath $exe -ArgumentList $args -PassThru
    $script:BrowserStarted = $true
    $Result.browser_started_by_runner = $true
    $targets = $null
    for ($i = 0; $i -lt 60; $i++) {
        Start-Sleep -Milliseconds 500
        try {
            $targets = Invoke-RestMethod -Uri "$CdpBase/json/list" -TimeoutSec 2
            if ($targets) { break }
        } catch {}
    }
    if (-not $targets) { throw 'Browser CDP did not become ready.' }
    $target = @($targets | Where-Object { $_.type -eq 'page' -and ([string]$_.url).StartsWith($ComfyBase) } | Select-Object -First 1)
    if ($target.Count -eq 0) { $target = @($targets | Where-Object { $_.type -eq 'page' } | Select-Object -First 1) }
    if ($target.Count -eq 0 -or -not $target[0].webSocketDebuggerUrl) { throw 'No CDP page target found.' }
    $script:CdpSocket = [System.Net.WebSockets.ClientWebSocket]::new()
    $script:CdpSocket.ConnectAsync([System.Uri]$target[0].webSocketDebuggerUrl, [System.Threading.CancellationToken]::None).GetAwaiter().GetResult()
    for ($i = 0; $i -lt 80; $i++) {
        Start-Sleep -Milliseconds 500
        try {
            $ready = Invoke-Js "JSON.stringify({ready:document.readyState,app:!!window.app,load:!!(window.app&&window.app.loadGraphData),compile:!!(window.app&&window.app.graphToPrompt)})"
            $o = $ready | ConvertFrom-Json
            if ($o.ready -eq 'complete' -and $o.app -and $o.load -and $o.compile) { return }
        } catch {}
    }
    throw 'ComfyUI frontend loaded but window.app/loadGraphData/graphToPrompt did not become ready.'
}

function Get-TemplateText([string]$Url, [string]$Name) {
    $path = Join-Path $OutputDir $Name
    Invoke-WebRequest -Uri $Url -UseBasicParsing -OutFile $path
    $txt = Get-Content -Path $path -Raw
    $null = $txt | ConvertFrom-Json
    return $txt
}

function Compile-Workflow {
    param(
        [string]$TemplateText,
        [ValidateSet('BASE','EDIT')] [string]$Mode,
        [string]$Prompt,
        [string]$InputImageName
    )
    $wf64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($TemplateText))
    $cfg = [ordered]@{
        mode = $Mode
        prompt = $Prompt
        input = $InputImageName
        seed = $Seed
        width = 1024
        height = 1024
        unet = $Model
        clip = $Clip
        vae = $Vae
    } | ConvertTo-Json -Compress
    $cfg64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($cfg))
    $js = @"
(async()=>{
 const dec=b=>new TextDecoder().decode(Uint8Array.from(atob(b),c=>c.charCodeAt(0)));
 const wf=JSON.parse(dec('$wf64'));
 const c=JSON.parse(dec('$cfg64'));
 await window.app.loadGraphData(wf,true,true,null,{openSource:'template'});
 await new Promise(r=>setTimeout(r,400));
 const g=window.app.graph;
 const setv=(n,name,idx,v)=>{ if(!n) throw new Error('missing node'); let w=(n.widgets||[]).find(x=>x.name===name); if(!w && Number.isInteger(idx)) w=(n.widgets||[])[idx]; if(!w) throw new Error('missing widget '+name); w.value=v; };
 if(c.mode==='BASE'){
   const p=g.getNodeById(76); setv(p,'text',0,c.prompt);
   const n=g.getNodeById(75);
   setv(n,'value',null,c.width); setv(n,'value_1',null,c.height); setv(n,'unet_name',null,c.unet); setv(n,'clip_name',null,c.clip); setv(n,'vae_name',null,c.vae); setv(n,'noise_seed',null,c.seed);
   const f=(n.widgets||[]).find(x=>x.name==='control_after_generate'); if(f) f.value='fixed';
   const s=g.getNodeById(9); setv(s,'filename_prefix',0,'NEXIA_FLUX_BASE_GATE');
 } else {
   const l=g.getNodeById(76); setv(l,'image',0,c.input);
   const n=g.getNodeById(75);
   setv(n,'unet_name',0,c.unet); setv(n,'clip_name',1,c.clip); setv(n,'vae_name',2,c.vae); setv(n,'text',3,c.prompt); setv(n,'noise_seed',4,c.seed);
   const f=(n.widgets||[]).find(x=>x.name==='control_after_generate'); if(f) f.value='fixed';
   const s=g.getNodeById(9); setv(s,'filename_prefix',0,'NEXIA_FLUX_EDIT_GATE');
 }
 const p=await window.app.graphToPrompt();
 return JSON.stringify({output:p.output,workflow:p.workflow,widgets:g._nodes.map(n=>({id:n.id,type:n.type,mode:n.mode,widgets:(n.widgets||[]).map(w=>({name:w.name,value:w.value}))}))});
})()
"@
    $raw = Invoke-Js $js
    return ($raw | ConvertFrom-Json)
}

function Assert-CompiledPrompt {
    param($PromptObject, [ValidateSet('BASE','EDIT')] [string]$Mode)
    $serialized = $PromptObject | ConvertTo-Json -Compress -Depth 100
    foreach ($required in @($Model,$Clip,$Vae)) {
        if (-not $serialized.Contains($required)) { throw "Compiled prompt does not reference required model: $required" }
    }
    if (-not $serialized.Contains([string]$Seed)) { throw "Compiled prompt does not contain frozen seed $Seed" }
    $nodes = @($PromptObject.PSObject.Properties | ForEach-Object { $_.Value })
    $samplers = @($nodes | Where-Object { $_.class_type -eq 'KSamplerSelect' })
    if ($samplers.Count -lt 1) { throw 'No KSamplerSelect found in compiled prompt.' }
    foreach ($n in $samplers) { if ([string]$n.inputs.sampler_name -ne 'euler') { throw "Unexpected sampler: $($n.inputs.sampler_name)" } }
    $schedulers = @($nodes | Where-Object { $_.class_type -eq 'Flux2Scheduler' })
    if ($schedulers.Count -lt 1) { throw 'No Flux2Scheduler found in compiled prompt.' }
    foreach ($n in $schedulers) { if ([int]$n.inputs.steps -ne 4) { throw "Unexpected Flux2Scheduler steps: $($n.inputs.steps)" } }
    $guiders = @($nodes | Where-Object { $_.class_type -eq 'CFGGuider' })
    if ($guiders.Count -lt 1) { throw 'No CFGGuider found in compiled prompt.' }
    foreach ($n in $guiders) { if ([math]::Abs(([double]$n.inputs.cfg) - 1.0) -gt 0.0001) { throw "Unexpected CFG: $($n.inputs.cfg)" } }
    if ($Mode -eq 'BASE') {
        $dimNodes = @($nodes | Where-Object { ($null -ne $_.inputs.width) -and ($null -ne $_.inputs.height) })
        if ($dimNodes.Count -lt 1) { throw 'No width/height latent node found in BASE compiled prompt.' }
        $ok = $false
        foreach ($n in $dimNodes) { if ([int]$n.inputs.width -eq 1024 -and [int]$n.inputs.height -eq 1024) { $ok = $true } }
        if (-not $ok) { throw 'BASE compiled prompt is not 1024x1024.' }
    }
}

function Get-NvidiaSmi {
    $cmd = Get-Command nvidia-smi -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $p = 'C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe'
    if (Test-Path $p) { return $p }
    return $null
}

function Find-ComfyPid {
    try {
        $p = Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -and $_.CommandLine -match 'ComfyUI.*main\.py' } | Select-Object -First 1
        if ($p) { return [int]$p.ProcessId }
    } catch {}
    return $null
}

function Execute-Prompt {
    param([string]$Label, $PromptObject, [string]$WorkflowPath, [string]$PromptPath)
    if ($script:GenerationCount -ge 3) { throw 'Generation cap reached; refusing additional prompt.' }
    Write-JsonFile $PromptObject $PromptPath
    $body = @{ prompt = $PromptObject; client_id = "nexia-$TaskId" } | ConvertTo-Json -Depth 100
    $queue = Invoke-RestMethod -Uri "$ComfyBase/prompt" -Method Post -ContentType 'application/json' -Body $body -TimeoutSec 30
    if (-not $queue.prompt_id) { throw "ComfyUI did not return prompt_id for $Label" }
    if ($queue.node_errors -and @($queue.node_errors.PSObject.Properties).Count -gt 0) { throw "ComfyUI node validation error before $Label execution." }
    $script:GenerationCount++
    $Result.generation_count = $script:GenerationCount
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $peakGpu = $null
    $peakSystemRam = $null
    $peakProcessRam = $null
    $nvsmi = Get-NvidiaSmi
    $comfyPid = Find-ComfyPid
    $image = $null
    while ($sw.Elapsed.TotalSeconds -lt 900) {
        if ($nvsmi) {
            try {
                $v = (& $nvsmi --query-gpu=memory.used --format=csv,noheader,nounits 2>$null | Select-Object -First 1)
                if ($v -match '^\s*(\d+)') { $m=[int]$matches[1]; if ($null -eq $peakGpu -or $m -gt $peakGpu) { $peakGpu=$m } }
            } catch {}
        }
        try {
            $os = Get-CimInstance Win32_OperatingSystem
            $used = [math]::Round(([double]($os.TotalVisibleMemorySize-$os.FreePhysicalMemory))/1024,0)
            if ($null -eq $peakSystemRam -or $used -gt $peakSystemRam) { $peakSystemRam=$used }
        } catch {}
        if ($comfyPid) {
            try {
                $gp=Get-Process -Id $comfyPid -ErrorAction Stop
                $m=[math]::Round($gp.WorkingSet64/1MB,0)
                if ($null -eq $peakProcessRam -or $m -gt $peakProcessRam) { $peakProcessRam=$m }
            } catch {}
        }
        try {
            $h = Invoke-RestMethod -Uri "$ComfyBase/history/$($queue.prompt_id)" -TimeoutSec 5
            $prop = $h.PSObject.Properties[$queue.prompt_id]
            if ($null -ne $prop) {
                $entry = $prop.Value
                if ($entry.status -and $entry.status.status_str -eq 'error') { throw "ComfyUI reports runtime error for $Label" }
                foreach ($op in @($entry.outputs.PSObject.Properties)) {
                    if ($op.Value.images) { $image = @($op.Value.images)[0]; break }
                }
                if ($image) { break }
            }
        } catch {
            if ($_.Exception.Message -like 'ComfyUI reports runtime error*') { throw }
        }
        Start-Sleep -Seconds 1
    }
    $sw.Stop()
    if (-not $image) { throw "No saved image observed for $Label within 900 seconds." }
    $sourceRoot = Join-Path $ComfyRoot ([string]$image.type)
    if ([string]$image.type -eq 'output') { $sourceRoot = Join-Path $ComfyRoot 'output' }
    $source = Join-Path $sourceRoot ([string]$image.subfolder)
    $source = Join-Path $source ([string]$image.filename)
    $ext = [System.IO.Path]::GetExtension([string]$image.filename)
    if (-not $ext) { $ext = '.png' }
    $dest = Join-Path $OutputDir ($Label + $ext)
    if (Test-Path $source) { Copy-Item -Path $source -Destination $dest -Force }
    else {
        $q = "filename=$([uri]::EscapeDataString([string]$image.filename))&subfolder=$([uri]::EscapeDataString([string]$image.subfolder))&type=$([uri]::EscapeDataString([string]$image.type))"
        Invoke-WebRequest -Uri "$ComfyBase/view?$q" -UseBasicParsing -OutFile $dest
    }
    return [ordered]@{
        label = $Label
        prompt_id = [string]$queue.prompt_id
        output_local_copy = $dest
        output_sha256 = Get-Sha256 $dest
        resolution = 'NOT_INSTRUMENTED_FROM_FILE_HEADER'
        seed = $Seed
        generation_wall_seconds = [math]::Round($sw.Elapsed.TotalSeconds,3)
        peak_gpu_vram_mib_whole_gpu_sampled = $peakGpu
        peak_system_ram_mib_sampled = $peakSystemRam
        peak_comfy_process_ram_mib_sampled = $peakProcessRam
        workflow_path = $WorkflowPath
        workflow_sha256 = Get-Sha256 $WorkflowPath
        api_prompt_path = $PromptPath
        api_prompt_sha256 = Get-Sha256 $PromptPath
        oom_recorded = $false
        runtime_error_recorded = $false
    }
}

function Publish-RawResult {
    param([string]$LocalResultPath)
    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if (-not $gh) { $Result.writeback = 'FAIL_GH_NOT_FOUND_LOCAL_RESULT_ONLY'; return }
    $existing = & $gh.Source api "repos/$Repo/contents/$RawResultRepoPath" 2>$null
    if ($LASTEXITCODE -eq 0) { $Result.writeback = 'FAIL_REMOTE_RESULT_ALREADY_EXISTS_NO_OVERWRITE'; return }
    $json = Get-Content -Path $LocalResultPath -Raw
    $payload = [ordered]@{
        message = 'Record bounded FLUX image-edit bridge raw result'
        content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($json))
    }
    $payloadPath = Join-Path $OutputDir 'github-writeback-payload.json'
    Write-JsonFile $payload $payloadPath
    $null = & $gh.Source api --method PUT "repos/$Repo/contents/$RawResultRepoPath" --input $payloadPath
    if ($LASTEXITCODE -ne 0) { $Result.writeback = 'FAIL_GH_API_PUT'; return }
    $remoteRaw = & $gh.Source api "repos/$Repo/contents/$RawResultRepoPath"
    if ($LASTEXITCODE -ne 0) { $Result.writeback = 'FAIL_GH_API_READBACK'; return }
    $remote = $remoteRaw | ConvertFrom-Json
    $decoded = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(([string]$remote.content).Replace("`n",'')))
    if ((Get-StringSha256 $decoded) -ne (Get-StringSha256 $json)) { $Result.writeback = 'FAIL_READBACK_HASH_MISMATCH'; return }
    $Result.writeback = 'PASS_GH_API_READBACK_MATCH'
}

function Cleanup-Runner {
    if (Test-Path $InputReferencePath) { Remove-Item $InputReferencePath -Force -ErrorAction SilentlyContinue }
    if ($null -ne $script:CdpSocket) { try { $script:CdpSocket.Dispose() } catch {} }
    if ($script:BrowserStarted) {
        try {
            Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -and $_.CommandLine.Contains($BrowserProfile) } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
        } catch {}
        Start-Sleep -Milliseconds 500
        Remove-Item $BrowserProfile -Recurse -Force -ErrorAction SilentlyContinue
    }
    if ($script:ComfyStarted -and $null -ne $script:ComfyProcess) {
        try { if (-not $script:ComfyProcess.HasExited) { Stop-Process -Id $script:ComfyProcess.Id -Force } } catch {}
    }
}

New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null
$localResultPath = Join-Path $OutputDir 'RAW_RESULT.json'
$stage = 'PRECHECK'

try {
    Write-Host '=== NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 ==='
    Write-Host 'Scope: existing ComfyUI + FLUX only; max 3 generations; no retries; EUR0.'

    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if ($gh) {
        $null = & $gh.Source api "repos/$Repo/contents/$RawResultRepoPath" 2>$null
        if ($LASTEXITCODE -eq 0) { throw "STOP: remote raw result already exists at $RawResultRepoPath; one-shot will not rerun." }
    }

    foreach ($p in @(
        (Join-Path $ComfyRoot "models\diffusion_models\$Model"),
        (Join-Path $ComfyRoot "models\text_encoders\$Clip"),
        (Join-Path $ComfyRoot "models\vae\$Vae")
    )) { if (-not (Test-Path $p)) { throw "Required existing component missing: $p" } }

    $versionFile = Join-Path $ComfyRoot 'comfyui_version.py'
    if (-not (Test-Path $versionFile)) { throw 'comfyui_version.py missing.' }
    $versionLine = (Get-Content $versionFile | Select-String '__version__' | Select-Object -First 1).Line
    if ($versionLine -notmatch '0\.39\.0') { throw "Unexpected ComfyUI version; expected 0.39.0, observed: $versionLine" }
    $Result.comfyui_version = '0.39.0'

    $stage = 'START_COMFYUI'
    Start-ComfyIfNeeded

    $stage = 'FETCH_PINNED_WORKFLOW_REFERENCE_DATA'
    $t2iText = Get-TemplateText $T2IWorkflowUrl 'official_t2i_workflow.json'
    $editText = Get-TemplateText $EditWorkflowUrl 'official_edit_workflow.json'

    $stage = 'START_COMFYUI_FRONTEND_CDP'
    Start-ComfyBrowser

    $stage = 'COMPILE_BASE_PRECHECK'
    $baseCompiled = Compile-Workflow -TemplateText $t2iText -Mode BASE -Prompt $BasePrompt -InputImageName ''
    Assert-CompiledPrompt -PromptObject $baseCompiled.output -Mode BASE
    $baseWorkflowPath = Join-Path $OutputDir 'BASE.workflow.json'
    $basePromptPath = Join-Path $OutputDir 'BASE.api_prompt.json'
    Write-JsonFile $baseCompiled.workflow $baseWorkflowPath

    $stage = 'GENERATE_BASE'
    $baseMetrics = Execute-Prompt -Label 'BASE' -PromptObject $baseCompiled.output -WorkflowPath $baseWorkflowPath -PromptPath $basePromptPath
    $Result.variants.BASE = $baseMetrics

    $stage = 'BASE_HUMAN_PRECONDITION'
    Start-Process $baseMetrics.output_local_copy | Out-Null
    Write-Host ''
    Write-Host 'BASE visual gate. Answer SI only if ALL are true:'
    Write-Host '- exactly one identifiable storage box'
    Write-Host '- matte dark-blue body'
    Write-Host '- black lid'
    Write-Host '- no person or hands'
    Write-Host '- no extra product-like object'
    Write-Host '- no prominent text'
    $gate = (Read-Host 'Escribe SI para continuar; cualquier otra respuesta detiene B1/B2').Trim().ToUpperInvariant()
    if ($gate -ne 'SI') {
        $Result.base_human_gate = 'FAIL_BASE_PRECONDITION'
        $Result.status = 'BASE_PRECONDITION_FAIL_STOPPED_AFTER_1_GENERATION'
        throw 'BASE_PRECONDITION_FAIL'
    }
    $Result.base_human_gate = 'PASS_KAEL_CONFIRMED'

    Copy-Item -Path $baseMetrics.output_local_copy -Destination $InputReferencePath -Force
    if ((Get-Sha256 $baseMetrics.output_local_copy) -ne (Get-Sha256 $InputReferencePath)) { throw 'BASE reference copy hash mismatch.' }

    $stage = 'COMPILE_B1_PRECHECK'
    $b1Compiled = Compile-Workflow -TemplateText $editText -Mode EDIT -Prompt $B1Prompt -InputImageName $InputReferenceName
    Assert-CompiledPrompt -PromptObject $b1Compiled.output -Mode EDIT
    $b1WorkflowPath = Join-Path $OutputDir 'B1.workflow.json'
    $b1PromptPath = Join-Path $OutputDir 'B1.api_prompt.json'
    Write-JsonFile $b1Compiled.workflow $b1WorkflowPath

    $stage = 'COMPILE_B2_PRECHECK'
    $b2Compiled = Compile-Workflow -TemplateText $editText -Mode EDIT -Prompt $B2Prompt -InputImageName $InputReferenceName
    Assert-CompiledPrompt -PromptObject $b2Compiled.output -Mode EDIT
    $b2WorkflowPath = Join-Path $OutputDir 'B2.workflow.json'
    $b2PromptPath = Join-Path $OutputDir 'B2.api_prompt.json'
    Write-JsonFile $b2Compiled.workflow $b2WorkflowPath

    $b1Norm = ($b1Compiled.output | ConvertTo-Json -Compress -Depth 100).Replace($B1Prompt,'<PROMPT>')
    $b2Norm = ($b2Compiled.output | ConvertTo-Json -Compress -Depth 100).Replace($B2Prompt,'<PROMPT>')
    if ((Get-StringSha256 $b1Norm) -ne (Get-StringSha256 $b2Norm)) { throw 'B1/B2 compiled settings differ beyond prompt text; refusing generation.' }
    $Result.b1_b2_settings_equivalent_except_prompt = 'PASS_COMPILED_PROMPT_NORMALIZED_HASH_MATCH'

    $stage = 'GENERATE_B1'
    $b1Metrics = Execute-Prompt -Label 'B1' -PromptObject $b1Compiled.output -WorkflowPath $b1WorkflowPath -PromptPath $b1PromptPath
    $Result.variants.B1 = $b1Metrics

    $stage = 'GENERATE_B2'
    $b2Metrics = Execute-Prompt -Label 'B2' -PromptObject $b2Compiled.output -WorkflowPath $b2WorkflowPath -PromptPath $b2PromptPath
    $Result.variants.B2 = $b2Metrics

    $Result.status = 'EXECUTION_COMPLETE_VISUAL_QA_PENDING'
    $Result.local_flux_image_editing = 'TECHNICAL_PASS_B1_B2_COMPLETED_NO_RECORDED_RUNTIME_ERROR'
    $Result.visual_qa_b1_b2 = 'NOT_VERIFIED_PENDING_CHAT_REVIEW'
    $Result.prompt_engineering_effect = 'NOT_VERIFIED_PENDING_DIMENSION_QA'
    Start-Process explorer.exe $OutputDir | Out-Null
}
catch {
    if ($Result.status -eq 'STARTED_NOT_COMPLETE') { $Result.status = 'STOPPED_FAIL_CLOSED' }
    $Result.error_stage = $stage
    $Result.error = $_.Exception.Message
    if ($_.Exception.Message -match 'OOM|out of memory|CUDA out of memory') {
        foreach ($k in @($Result.variants.Keys)) { $Result.variants[$k].oom_recorded = $true }
    }
    Write-Host "STOP: $stage | $($_.Exception.Message)"
}
finally {
    $Result.generation_count = $script:GenerationCount
    $Result.finished_at = (Get-Date).ToString('o')
    Write-JsonFile $Result $localResultPath
    try {
        Publish-RawResult $localResultPath
        Write-JsonFile $Result $localResultPath
        if ($Result.writeback -eq 'PASS_GH_API_READBACK_MATCH') {
            # Rewrite once so the local copy records successful writeback; remote copy truth remains the pre-rewrite payload plus verified transport status emitted to console.
            Write-Host 'RAW_RESULT_WRITEBACK: PASS_GH_API_READBACK_MATCH'
        } else {
            Write-Host "RAW_RESULT_WRITEBACK: $($Result.writeback)"
        }
    } catch {
        $Result.writeback = "FAIL_EXCEPTION: $($_.Exception.Message)"
        Write-JsonFile $Result $localResultPath
        Write-Host "RAW_RESULT_WRITEBACK: $($Result.writeback)"
    }
    Cleanup-Runner
    Write-Host "LOCAL_RESULT: $localResultPath"
    Write-Host "GENERATIONS_EXECUTED: $script:GenerationCount"
    Write-Host "FINAL_STATUS: $($Result.status)"
    Write-Host '=== END NEXIA FLUX-EDIT-BRIDGE-ONESHOT-001 ==='
}
