# NEXIA bounded ComfyUI startup diagnostic v0.1
# Starts the existing ComfyUI server only long enough to verify localhost readiness.
# No browser, no workflow submission, no model generation, no installs, no downloads.

param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$ProjectRoot = 'C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\creative-benchmark-2026-10-12\ComfyUI_windows_portable'
$ComfyRoot = Join-Path $ProjectRoot 'ComfyUI'
$PythonExe = Join-Path $ProjectRoot 'python_embeded\python.exe'
$ComfyMain = Join-Path $ComfyRoot 'main.py'
$OutputDir = 'C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\flux-edit-base-b1-b2-2026-10-16'
$Stdout = Join-Path $OutputDir 'comfyui.startup-diag.stdout.log'
$Stderr = Join-Path $OutputDir 'comfyui.startup-diag.stderr.log'
$ComfyBase = 'http://127.0.0.1:8188'

function Test-ComfyReady {
    try {
        $null = Invoke-RestMethod -Uri "$ComfyBase/system_stats" -Method Get -TimeoutSec 3
        return $true
    } catch { return $false }
}

Write-Host '=== NEXIA COMFY STARTUP DIAG v0.1 ==='
Write-Host 'SCOPE: existing ComfyUI only; no browser; no prompt submission; no generation.'

if (-not (Test-Path $PythonExe)) { throw "Embedded Python missing: $PythonExe" }
if (-not (Test-Path $ComfyMain)) { throw "ComfyUI main.py missing: $ComfyMain" }
New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null
Remove-Item $Stdout,$Stderr -Force -ErrorAction SilentlyContinue

if (Test-ComfyReady) {
    Write-Host 'COMFY_PREEXISTING_READY: TRUE'
    Write-Host 'STARTED_BY_DIAG: FALSE'
    Write-Host 'GENERATIONS_EXECUTED_BY_DIAG: 0'
    Write-Host '=== END NEXIA COMFY STARTUP DIAG v0.1 ==='
    exit 0
}

$p = $null
$started = $false
$ready = $false
$sw = [System.Diagnostics.Stopwatch]::StartNew()
try {
    $args = @('-s', $ComfyMain, '--windows-standalone-build', '--listen', '127.0.0.1', '--port', '8188', '--disable-auto-launch')
    $p = Start-Process -FilePath $PythonExe -ArgumentList $args -WorkingDirectory $ComfyRoot -RedirectStandardOutput $Stdout -RedirectStandardError $Stderr -PassThru
    $started = $true
    Write-Host ("COMFY_PID: {0}" -f $p.Id)

    for ($i = 0; $i -lt 180; $i++) {
        Start-Sleep -Seconds 1
        if (Test-ComfyReady) { $ready = $true; break }
        if ($p.HasExited) { break }
    }
    $sw.Stop()

    if ($ready) {
        Write-Host ("COMFY_STARTUP_READY: TRUE")
        Write-Host ("COMFY_STARTUP_READY_SECONDS: {0}" -f ([math]::Round($sw.Elapsed.TotalSeconds,3)))
        try {
            $stats = Invoke-RestMethod -Uri "$ComfyBase/system_stats" -Method Get -TimeoutSec 5
            if ($stats.system) {
                if ($stats.system.comfyui_version) { Write-Host ("COMFY_SYSTEM_VERSION: {0}" -f $stats.system.comfyui_version) }
                if ($stats.system.python_version) { Write-Host ("COMFY_PYTHON_VERSION: {0}" -f $stats.system.python_version) }
            }
        } catch {
            Write-Host ("SYSTEM_STATS_READ_WARNING: {0}" -f $_.Exception.Message)
        }
    } elseif ($p.HasExited) {
        Write-Host 'COMFY_STARTUP_READY: FALSE'
        Write-Host 'COMFY_PROCESS_EXITED: TRUE'
        Write-Host ("COMFY_EXIT_CODE: {0}" -f $p.ExitCode)
        Write-Host ("COMFY_EXIT_AFTER_SECONDS: {0}" -f ([math]::Round($sw.Elapsed.TotalSeconds,3)))
    } else {
        Write-Host 'COMFY_STARTUP_READY: FALSE'
        Write-Host 'COMFY_PROCESS_EXITED: FALSE'
        Write-Host 'COMFY_STARTUP_TIMEOUT_SECONDS: 180'
    }
}
finally {
    if ($started -and $null -ne $p) {
        try { if (-not $p.HasExited) { Stop-Process -Id $p.Id -Force -ErrorAction Stop; Write-Host 'COMFY_DIAG_CLEANUP_STOPPED_PROCESS: TRUE' } } catch { Write-Host ("COMFY_DIAG_CLEANUP_WARNING: {0}" -f $_.Exception.Message) }
    }
    Write-Host '--- STARTUP STDERR TAIL ---'
    if (Test-Path $Stderr) { Get-Content $Stderr -Tail 120 } else { Write-Host 'MISSING' }
    Write-Host '--- STARTUP STDOUT TAIL ---'
    if (Test-Path $Stdout) { Get-Content $Stdout -Tail 80 } else { Write-Host 'MISSING' }
    Write-Host 'NO_BROWSER_STARTED: TRUE'
    Write-Host 'NO_PROMPT_SUBMITTED: TRUE'
    Write-Host 'GENERATIONS_EXECUTED_BY_DIAG: 0'
    Write-Host '=== END NEXIA COMFY STARTUP DIAG v0.1 ==='
}

if (-not $ready) { exit 2 }
exit 0
