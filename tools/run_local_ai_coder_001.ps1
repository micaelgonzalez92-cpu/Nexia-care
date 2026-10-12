# LOCAL-AI-CODER-001 — authorized bounded local runner
# Scope: Ollama + qwen2.5-coder:7b-instruct + preregistered five-task benchmark only.
# No other model, browser agent, paid/cloud API, external contact, publication or repo mutation.

param(
    [string]$OutputDir = "$env:USERPROFILE\NEXIA_LOCAL_AI_CODER_001"
)

$ErrorActionPreference = "Stop"
$Model = "qwen2.5-coder:7b-instruct"
$HarnessUrl = "https://raw.githubusercontent.com/micaelgonzalez92-cpu/Nexia-care/e6d25f3988f8d8a8c7c58b87a456844a920ab0c9/tools/nexia_local_ai_coder_001_benchmark.py"

function Get-OllamaExe {
    $cmd = Get-Command ollama -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $candidate = Join-Path $env:LOCALAPPDATA "Programs\Ollama\ollama.exe"
    if (Test-Path $candidate) { return $candidate }
    return $null
}

function Test-OllamaApi {
    try {
        $null = Invoke-RestMethod -Uri "http://127.0.0.1:11434/api/tags" -Method Get -TimeoutSec 3
        return $true
    } catch {
        return $false
    }
}

Write-Host "NEXIA LOCAL-AI-CODER-001"
Write-Host "Scope: Ollama + $Model only; cash spend EUR0."

# Capacity gate: model package is ~4.7 GB; keep conservative local headroom.
$systemDrive = Get-PSDrive -Name $env:SystemDrive.TrimEnd(':')
$freeGiB = [math]::Round($systemDrive.Free / 1GB, 2)
Write-Host "System drive free space: $freeGiB GiB"
if ($freeGiB -lt 10) {
    throw "STOP: less than 10 GiB free on system drive; benchmark not started."
}

$ollamaExe = Get-OllamaExe
if (-not $ollamaExe) {
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) {
        throw "STOP: Ollama is not installed and winget is unavailable. No fallback installer was used."
    }
    Write-Host "Installing only Ollama via Microsoft winget package Ollama.Ollama..."
    & $winget.Source install --id Ollama.Ollama --exact --source winget --accept-package-agreements --accept-source-agreements --silent
    if ($LASTEXITCODE -ne 0) { throw "Ollama installation failed with exit code $LASTEXITCODE" }
    Start-Sleep -Seconds 3
    $ollamaExe = Get-OllamaExe
    if (-not $ollamaExe) { throw "Ollama installation completed but ollama.exe was not found." }
} else {
    Write-Host "Ollama already installed; no reinstall."
}

Write-Host (& $ollamaExe --version)

if (-not (Test-OllamaApi)) {
    Write-Host "Starting local Ollama server..."
    Start-Process -FilePath $ollamaExe -ArgumentList "serve" -WindowStyle Hidden | Out-Null
    $ready = $false
    for ($i = 0; $i -lt 30; $i++) {
        Start-Sleep -Seconds 1
        if (Test-OllamaApi) { $ready = $true; break }
    }
    if (-not $ready) { throw "Ollama local API did not become ready within 30 seconds." }
}

Write-Host "Downloading/verifying exact authorized model: $Model"
& $ollamaExe pull $Model
if ($LASTEXITCODE -ne 0) { throw "Model pull failed with exit code $LASTEXITCODE" }

$modelList = (& $ollamaExe list | Out-String)
if ($modelList -notmatch [regex]::Escape("qwen2.5-coder:7b-instruct")) {
    throw "Authorized model is not visible in ollama list after pull."
}

New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
$harnessPath = Join-Path $OutputDir "nexia_local_ai_coder_001_benchmark.py"
Write-Host "Downloading commit-pinned Nexia benchmark harness..."
Invoke-WebRequest -Uri $HarnessUrl -OutFile $harnessPath -UseBasicParsing

$pythonCmd = $null
$pythonArgs = @()
if (Get-Command py -ErrorAction SilentlyContinue) {
    $pythonCmd = (Get-Command py).Source
    $pythonArgs = @("-3", $harnessPath)
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonCmd = (Get-Command python).Source
    $pythonArgs = @($harnessPath)
} else {
    throw "STOP: Python 3 was not found. No additional runtime was installed because it is outside this authorization."
}

$env:NEXIA_LOCAL_AI_CODER_OUTPUT = $OutputDir
Write-Host "Running five-task local benchmark. Scored inference endpoint: 127.0.0.1 only."
& $pythonCmd @pythonArgs
$benchmarkExit = $LASTEXITCODE

$resultPath = Join-Path $OutputDir "benchmark-results.json"
if (-not (Test-Path $resultPath)) {
    throw "Benchmark ended without creating benchmark-results.json"
}

$result = Get-Content $resultPath -Raw | ConvertFrom-Json
Write-Host ""
Write-Host "=== NEXIA LOCAL-AI-CODER-001 RESULT ==="
Write-Host "Result: $($result.result)"
Write-Host "Tasks: $($result.tasks_passed)/$($result.tasks_total)"
Write-Host "Median model response: $([math]::Round([double]$result.median_model_response_seconds,2)) s"
Write-Host "Approx peak GPU memory (whole GPU): $($result.approx_peak_gpu_memory_mib_whole_gpu) MiB"
Write-Host "Approx peak Ollama process RAM: $($result.approx_peak_ollama_process_ram_mib) MiB"
Write-Host "Results: $resultPath"

if ($benchmarkExit -eq 0 -and $result.result -eq "PASS") {
    Write-Host "LOCAL-AI-CODER-001=PASS"
    exit 0
}
Write-Host "LOCAL-AI-CODER-001=FAIL"
exit 2
