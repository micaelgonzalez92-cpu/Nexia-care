# NEXIA bounded ComfyUI import + GitHub payload encoding diagnostic v0.1
# Read-only with respect to Nexia/ComfyUI configuration. Starts no ComfyUI server and performs no generations.

param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$ProjectRoot = 'C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\creative-benchmark-2026-10-12\ComfyUI_windows_portable'
$ComfyRoot = Join-Path $ProjectRoot 'ComfyUI'
$PythonExe = Join-Path $ProjectRoot 'python_embeded\python.exe'
$OutputDir = 'C:\Users\User\.codex\.chatgpt-projects\g-p-6ac02e5d5b84819190b29f630d0ff0e5\outputs\flux-edit-base-b1-b2-2026-10-16'
$PayloadPath = Join-Path $OutputDir 'github-writeback-payload.json'

Write-Host '=== NEXIA COMFY IMPORT DIAG v0.1 ==='
Write-Host ("POWERSHELL_VERSION: {0}" -f $PSVersionTable.PSVersion.ToString())

if (-not (Test-Path $PythonExe)) { throw "Embedded Python missing: $PythonExe" }
if (-not (Test-Path $ComfyRoot)) { throw "ComfyUI root missing: $ComfyRoot" }

if (Test-Path $PayloadPath) {
    $bytes = [System.IO.File]::ReadAllBytes($PayloadPath)
    if ($bytes.Length -gt 0) {
        $take = [Math]::Min(4, $bytes.Length)
        $head = @($bytes[0..($take-1)]) -join ','
        Write-Host "GH_PAYLOAD_FIRST_BYTES_DEC: $head"
        if ($bytes.Length -ge 3 -and $bytes[0] -eq 239 -and $bytes[1] -eq 187 -and $bytes[2] -eq 191) {
            Write-Host 'GH_PAYLOAD_UTF8_BOM: PRESENT'
        } else {
            Write-Host 'GH_PAYLOAD_UTF8_BOM: ABSENT'
        }
    } else {
        Write-Host 'GH_PAYLOAD: EMPTY'
    }
} else {
    Write-Host 'GH_PAYLOAD: MISSING'
}

Write-Host '--- SQLALCHEMY SQLITE IMPORT ---'
& $PythonExe -B -s -c "import time,sqlalchemy; t=time.perf_counter(); import sqlalchemy.dialects.sqlite.json; print('SQLALCHEMY_VERSION='+sqlalchemy.__version__); print('SQLITE_IMPORT_PASS_SECONDS='+str(round(time.perf_counter()-t,3)))"
Write-Host ("SQLITE_IMPORT_EXIT: {0}" -f $LASTEXITCODE)

Write-Host '--- COMFY DB IMPORT CHAIN ---'
Push-Location $ComfyRoot
try {
    & $PythonExe -B -s -c "import time; t=time.perf_counter(); import app.database.db; print('COMFY_DB_IMPORT_PASS_SECONDS='+str(round(time.perf_counter()-t,3)))"
    Write-Host ("COMFY_DB_IMPORT_EXIT: {0}" -f $LASTEXITCODE)
}
finally {
    Pop-Location
}

Write-Host 'NO_SERVER_STARTED: TRUE'
Write-Host 'GENERATIONS_EXECUTED_BY_DIAG: 0'
Write-Host '=== END NEXIA COMFY IMPORT DIAG v0.1 ==='
