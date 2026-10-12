$ErrorActionPreference = 'Stop'

Write-Host 'NEXIA UGC-VIDEO-001'
Write-Host 'Scope: existing ComfyUI + LTX-Video 2B v0.9.5 + t5xxl_fp16 only; EUR0; max 3 attempts.'

$runnerCommit = 'e9b4a9f4a54fc25e995da65622da7e5200016972'
$runnerUrl = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/$runnerCommit/tools/run_ugc_video_001.py"
$workDir = Join-Path $env:USERPROFILE 'NEXIA_UGC_VIDEO_001'
$runnerPath = Join-Path $workDir 'run_ugc_video_001.py'
New-Item -ItemType Directory -Force -Path $workDir | Out-Null

function Test-PythonCandidate {
    param(
        [string]$Exe,
        [string[]]$PrefixArgs = @()
    )
    if (-not $Exe) { return $null }
    if ($Exe -match '\\WindowsApps\\') { return $null }
    try {
        $probeArgs = @($PrefixArgs) + @('-c', 'import sys; print(sys.executable); print(sys.version_info.major)')
        $output = @(& $Exe @probeArgs 2>$null)
        if ($LASTEXITCODE -eq 0 -and $output.Count -ge 2 -and $output[-1].Trim() -eq '3') {
            return [pscustomobject]@{
                Exe = $Exe
                PrefixArgs = @($PrefixArgs)
                Runtime = $output[0].Trim()
            }
        }
    } catch { }
    return $null
}

function Get-UsablePython {
    $py = Get-Command py -ErrorAction SilentlyContinue
    if ($py) {
        $hit = Test-PythonCandidate -Exe $py.Source -PrefixArgs @('-3')
        if ($hit) { return $hit }
    }

    foreach ($name in @('python3', 'python')) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) {
            $hit = Test-PythonCandidate -Exe $cmd.Source
            if ($hit) { return $hit }
        }
    }

    $patterns = @(
        (Join-Path $env:LOCALAPPDATA 'Programs\Python\Python*\python.exe'),
        (Join-Path $env:ProgramFiles 'Python*\python.exe')
    )
    if (${env:ProgramFiles(x86)}) {
        $patterns += (Join-Path ${env:ProgramFiles(x86)} 'Python*\python.exe')
    }

    foreach ($pattern in $patterns) {
        foreach ($candidate in (Get-ChildItem -Path $pattern -File -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)) {
            $hit = Test-PythonCandidate -Exe $candidate
            if ($hit) { return $hit }
        }
    }
    return $null
}

$python = Get-UsablePython
if (-not $python) {
    throw 'Python 3 real runtime not found. This launcher will not install any additional software.'
}
Write-Host "Usable Python runtime found: $($python.Runtime)"

Write-Host 'Downloading commit-pinned Nexia runner...'
Invoke-WebRequest -Uri $runnerUrl -OutFile $runnerPath -UseBasicParsing

Write-Host 'Running bounded benchmark. The runner performs a core-node preflight before any large model download.'
$pythonArgs = @($python.PrefixArgs) + @($runnerPath, '--attempts', '3')
& $python.Exe @pythonArgs
$code = $LASTEXITCODE

Write-Host "Runner exit code: $code"
Write-Host "Local report: $(Join-Path $workDir 'ugc-video-001-results.json')"
exit $code
