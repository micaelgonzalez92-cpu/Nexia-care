$ErrorActionPreference = 'Stop'

Write-Host 'NEXIA UGC-VIDEO-001'
Write-Host 'Scope: existing ComfyUI + LTX-Video 2B v0.9.5 + t5xxl_fp16 only; EUR0; max 3 attempts.'

$runnerCommit = 'e9b4a9f4a54fc25e995da65622da7e5200016972'
$runnerUrl = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$runnerCommit/tools/run_ugc_video_001.py"
$workDir = Join-Path $env:USERPROFILE 'NEXIA_UGC_VIDEO_001'
$runnerPath = Join-Path $workDir 'run_ugc_video_001.py'
New-Item -ItemType Directory -Force -Path $workDir | Out-Null

$python = $null
try {
    $out = & py -3 -c "import sys; print(sys.executable)" 2>$null
    if ($LASTEXITCODE -eq 0 -and $out) { $python = @('py','-3') }
} catch {}
if (-not $python) {
    try {
        $out = & python -c "import sys; print(sys.executable)" 2>$null
        if ($LASTEXITCODE -eq 0 -and $out) { $python = @('python') }
    } catch {}
}
if (-not $python) {
    throw 'Python 3 real runtime not found. This launcher will not install any additional software.'
}

Write-Host 'Downloading commit-pinned Nexia runner...'
Invoke-WebRequest -Uri $runnerUrl -OutFile $runnerPath -UseBasicParsing

Write-Host 'Running bounded benchmark. The runner performs a core-node preflight before any large model download.'
if ($python.Count -eq 2) {
    & $python[0] $python[1] $runnerPath --attempts 3
} else {
    & $python[0] $runnerPath --attempts 3
}
$code = $LASTEXITCODE

Write-Host "Runner exit code: $code"
Write-Host "Local report: $(Join-Path $workDir 'ugc-video-001-results.json')"
exit $code
