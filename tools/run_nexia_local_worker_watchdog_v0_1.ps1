param(
  [string]$Repo = 'micaelgonzalez92-cpu/Nexia-care',
  [string]$Branch = 'main',
  [string]$BaseDir = "$env:LOCALAPPDATA\NEXIA\worker",
  [ValidateRange(1,3)][int]$MaxAttempts = 2,
  [ValidateRange(0,30)][int]$DelaySeconds = 2
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$binDir = Join-Path $BaseDir 'bin'
$cycle = Join-Path $binDir 'run_nexia_local_worker_cycle_v0_1.ps1'
$statusPath = Join-Path $BaseDir 'watchdog-status.json'
if(-not (Test-Path $cycle)){ throw "Worker cycle missing: $cycle" }

$hostExe = $null
if(Get-Command powershell.exe -ErrorAction SilentlyContinue){
  $hostExe = 'powershell.exe'
} elseif(Get-Command pwsh -ErrorAction SilentlyContinue){
  $hostExe = 'pwsh'
} else {
  throw 'No PowerShell child host available.'
}

function Write-WatchdogStatus([string]$Result,[int]$Attempts,[int]$ExitCode) {
  $obj = [ordered]@{
    schema_version = 1
    updated_at = [DateTimeOffset]::Now.ToString('o')
    watchdog_version = '0.1.0'
    result = $Result
    attempts = $Attempts
    max_attempts = $MaxAttempts
    last_exit_code = $ExitCode
    recurring_runtime_enabled = $false
    external_effects_authorized = $false
  }
  $json = $obj | ConvertTo-Json -Depth 5
  [IO.File]::WriteAllText($statusPath,$json + "`n",[Text.UTF8Encoding]::new($false))
}

$lastExit = 1
for($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
  Write-Host "WATCHDOG_ATTEMPT: $attempt/$MaxAttempts"

  if($hostExe -eq 'powershell.exe') {
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $cycle -Repo $Repo -Branch $Branch -BaseDir $BaseDir
  } else {
    & pwsh -NoProfile -File $cycle -Repo $Repo -Branch $Branch -BaseDir $BaseDir
  }
  $lastExit = $LASTEXITCODE

  if($lastExit -eq 0) {
    Write-WatchdogStatus 'PASS' $attempt 0
    if($attempt -gt 1){ Write-Host "WATCHDOG_RECOVERED: PASS attempts=$attempt" }
    else { Write-Host 'WATCHDOG_PASS: PASS attempts=1' }
    exit 0
  }

  Write-Host "WATCHDOG_ATTEMPT_FAILED: attempt=$attempt exit=$lastExit"
  if($attempt -lt $MaxAttempts -and $DelaySeconds -gt 0){ Start-Sleep -Seconds $DelaySeconds }
}

Write-WatchdogStatus 'FAIL_RETRY_EXHAUSTED' $MaxAttempts $lastExit
Write-Host "WATCHDOG_RETRY_EXHAUSTED: attempts=$MaxAttempts exit=$lastExit"
if($lastExit -eq 0){ exit 1 }
exit $lastExit
