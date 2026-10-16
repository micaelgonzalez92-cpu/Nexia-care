# Offline contract verification: load only named helper definitions from AST.
# Never invoke the runner, CDP, gh, ComfyUI or generation.
$ErrorActionPreference='Stop'
Set-StrictMode -Version 2.0
$p=Join-Path $PSScriptRoot '..\..\tools\nexia_flux_base_b1_b2_one_shot_v1.ps1'
$t=$null; $e=$null
$ast=[Management.Automation.Language.Parser]::ParseFile([IO.Path]::GetFullPath($p),[ref]$t,[ref]$e)
if ($e.Count) { throw 'Parse failure' }
$allowed=@('Get-Prop','Write-JsonFile','Get-Sha256','Resolve-Scalar','Resolve-Dimension','Assert-CompiledPrompt','Normalize-Edit','Get-PngResolution')
$functions=$ast.FindAll({param($n) $n -is [Management.Automation.Language.FunctionDefinitionAst]},$true)
foreach ($fn in $functions) { if ($allowed -contains $fn.Name) { Invoke-Expression $fn.Extent.Text } }
$checks=[Collections.Generic.List[string]]::new()
function Check([bool]$Ok,[string]$Name) { if (-not $Ok) { throw $Name }; $checks.Add($Name) }
function Must-Reject([scriptblock]$Action,[string]$Name) {
 $rejected=$false; try { & $Action } catch { $rejected=$true }
 Check $rejected $Name
}
$Utf8=[Text.UTF8Encoding]::new($false,$true)
$Model='flux-2-klein-4b-fp8.safetensors'; $Clip='qwen_3_4b.safetensors'; $Vae='flux2-vae.safetensors'; $Seed=20261016
$InputReferenceName='fixture.png'; $InputReferencePath=Join-Path $PSScriptRoot 'fixture.png'
$fixtureJson=Join-Path $PSScriptRoot 'utf8-fixture.json'
# Minimal PNG header only: exercises header parser, not an image-generation artifact.
$header=New-Object byte[] 24
[byte[]]$signature=137,80,78,71,13,10,26,10
[Array]::Copy($signature,$header,8); $header[18]=4; $header[22]=4
[IO.File]::WriteAllBytes($InputReferencePath,$header)
function Node([string]$Class,[hashtable]$Inputs) { [pscustomobject]@{class_type=$Class;inputs=[pscustomobject]$Inputs} }
$g=[pscustomobject]@{
 u=(Node 'UNETLoader' @{unet_name=$Model}); c=(Node 'CLIPLoader' @{clip_name=$Clip}); v=(Node 'VAELoader' @{vae_name=$Vae})
 s=(Node 'KSamplerSelect' @{sampler_name='euler'}); cfg=(Node 'CFGGuider' @{cfg=1}); noise=(Node 'RandomNoise' @{noise_seed=$Seed})
 sched=(Node 'Flux2Scheduler' @{steps=4;width=@('width',0);height=@('height',0)})
 latent=(Node 'EmptyFlux2LatentImage' @{width=@('width',0);height=@('height',0);batch_size=1})
 width=(Node 'PrimitiveInt' @{value=1024}); height=(Node 'PrimitiveInt' @{value=1024})
 text=(Node 'CLIPTextEncode' @{text='literal'})
 sampler=(Node 'SamplerCustomAdvanced' @{}); save=(Node 'SaveImage' @{})
}
try {
 Check ($null -eq (Get-Prop ([pscustomobject]@{}) 'id')) 'StrictMode missing optional id safe'
 Check ($null -eq (Get-Prop $null 'exceptionDetails')) 'StrictMode null parent safe'
 Check (@(Get-Prop ([pscustomobject]@{queue_running=@()}) 'queue_running').Count -eq 0) 'Empty queue array remains empty'
 Assert-CompiledPrompt $g BASE 'literal'; $checks.Add('BASE PrimitiveInt dimensions accepted')
 $g.width.inputs.value=512; Must-Reject { Assert-CompiledPrompt $g BASE 'literal' } 'Wrong linked width rejected'; $g.width.inputs.value=1024
 $g.cfg.inputs.cfg=5; Must-Reject { Assert-CompiledPrompt $g BASE 'literal' } 'Non-distilled CFG rejected'; $g.cfg.inputs.cfg=1
 $g.sched.inputs.steps=20; Must-Reject { Assert-CompiledPrompt $g BASE 'literal' } 'Non-distilled steps rejected'; $g.sched.inputs.steps=4
 $g.noise.inputs.noise_seed=1; Must-Reject { Assert-CompiledPrompt $g BASE 'literal' } 'Changed seed rejected'; $g.noise.inputs.noise_seed=$Seed
 $g.latent.inputs.batch_size=2; Must-Reject { Assert-CompiledPrompt $g BASE 'literal' } 'Multiple images rejected'; $g.latent.inputs.batch_size=1
 $g | Add-Member NoteProperty load (Node 'LoadImage' @{image=$InputReferenceName})
 $g | Add-Member NoteProperty scale (Node 'ImageScaleToTotalPixels' @{image=@('load',0);upscale_method='nearest-exact';megapixels=1;resolution_steps=1})
 $g | Add-Member NoteProperty size (Node 'GetImageSize' @{image=@('scale',0)})
 $g.sched.inputs.width=@('size',0); $g.sched.inputs.height=@('size',1)
 $g.latent.inputs.width=@('size',0); $g.latent.inputs.height=@('size',1)
 Assert-CompiledPrompt $g EDIT 'literal'; $checks.Add('EDIT reference-derived dimensions accepted')
 $g.sched.inputs.height=@('size',0); Must-Reject { Assert-CompiledPrompt $g EDIT 'literal' } 'Wrong dimension output slot rejected'; $g.sched.inputs.height=@('size',1)
 $g.load.inputs.image='other.png'; Must-Reject { Assert-CompiledPrompt $g EDIT 'literal' } 'Different BASE reference rejected'; $g.load.inputs.image=$InputReferenceName
 $n1=Normalize-Edit $g 'literal'; $g.text.inputs.text='second'; $n2=Normalize-Edit $g 'second'
 Check ($n1 -ceq $n2) 'Only prompt text normalizes to identical graph'
 $g.cfg.inputs.cfg=2; Check ($n1 -cne (Normalize-Edit $g 'second')) 'Settings mutation remains visible'
 $g.text.inputs | Add-Member NoteProperty duplicate 'second'
 Must-Reject { Normalize-Edit $g 'second' } 'Multiple matching prompt fields rejected'
 $accent= -join @([char]225,[char]233,[char]237,[char]243,[char]250,' ',[char]8364)
 Write-JsonFile @{text=$accent} $fixtureJson
 $b=[IO.File]::ReadAllBytes($fixtureJson)
 Check (-not ($b[0] -eq 239 -and $b[1] -eq 187 -and $b[2] -eq 191)) 'JSON file UTF8 no BOM'
 $decoded=$Utf8.GetString($b) | ConvertFrom-Json
 Check ($decoded.text -ceq $accent) 'Accented text UTF8 byte roundtrip'
 Check ((Get-PngResolution $InputReferencePath) -ceq '1024x1024') 'PNG resolution 1024 verified'
 $header[18]=2; [IO.File]::WriteAllBytes($InputReferencePath,$header)
 Must-Reject { Get-PngResolution $InputReferencePath } 'PNG 512 width rejected'
 $source=[IO.File]::ReadAllText([IO.Path]::GetFullPath($p))
 Check (-not ($source -match 'powershell\.exe|Invoke-Expression|\.Replace\(|Invoke-WebRequest.+\.ps1')) 'No nested runner or source patching'
 Check ($source.Contains("application/json; charset=utf-8") -and $source.Contains('[byte[]]$bytes=$Utf8.GetBytes($body)')) 'Explicit UTF8 prompt transport'
 $post=$source.IndexOf('$queue=Invoke-RestMethod')
 Check ($source.IndexOf('$script:Attempts++') -lt $post -and $source.IndexOf('Write-JsonFile $Result $LocalResult',$source.IndexOf('$script:Attempts++')) -lt $post) 'Durable attempt consumption before POST'
 Check ($source.IndexOf('BASE_HUMAN_GATE') -lt $source.IndexOf('$null=Execute-Prompt B1')) 'Human gate precedes edits'
 Check ($source.Contains('[IO.FileMode]::CreateNew')) 'One-shot lock create-only'
 Check ($source.Contains('if (-not $Execute) { throw')) 'Default invocation cannot generate'
 $checks | ForEach-Object { Write-Output "PASS $_" }
 [ordered]@{status='PASS_OFFLINE_CONTRACT';checks=$checks.Count;generation_calls=0;runner_executed=$false;sha256=(Get-Sha256 ([IO.Path]::GetFullPath($p)))} | ConvertTo-Json | Set-Content (Join-Path $PSScriptRoot 'offline-verification.json') -Encoding ASCII
} finally {
 Remove-Item -LiteralPath $InputReferencePath,$fixtureJson -Force -ErrorAction SilentlyContinue
}

