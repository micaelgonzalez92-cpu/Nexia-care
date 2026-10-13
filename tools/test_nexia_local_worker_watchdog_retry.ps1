$ErrorActionPreference = 'Stop'
$watchdog = Resolve-Path 'tools/run_nexia_local_worker_watchdog_v0_1.ps1'

function New-TestRoot([string]$Mode) {
  $root = Join-Path $env:RUNNER_TEMP ("nexia-watchdog-" + $Mode + '-' + [guid]::NewGuid().ToString('N'))
  $bin = Join-Path $root 'bin'
  New-Item -ItemType Directory -Force -Path $bin | Out-Null
  $cycle = Join-Path $bin 'run_nexia_local_worker_cycle_v0_1.ps1'
  @'
param(
  [string]$Repo,
  [string]$Branch,
  [string]$BaseDir
)
$counter = Join-Path $BaseDir 'attempt-count.txt'
$n = 0
if(Test-Path $counter){ $n = [int](Get-Content -Raw $counter) }
$n++
Set-Content -NoNewline -Encoding ascii $counter $n
if($env:NEXIA_WATCHDOG_TEST_MODE -eq 'transient') {
  if($n -eq 1){ exit 23 }
  exit 0
}
if($env:NEXIA_WATCHDOG_TEST_MODE -eq 'persistent') { exit 24 }
exit 25
'@ | Set-Content -Encoding utf8 $cycle
  return $root
}

$transient = New-TestRoot 'transient'
$env:NEXIA_WATCHDOG_TEST_MODE = 'transient'
& pwsh -NoProfile -File $watchdog -Repo 'test/repo' -Branch main -BaseDir $transient -MaxAttempts 3 -DelaySeconds 0
$transientCode = $LASTEXITCODE
if($transientCode -ne 0){ throw "Transient case expected exit 0, got $transientCode" }
$transientCount = [int](Get-Content -Raw (Join-Path $transient 'attempt-count.txt'))
if($transientCount -ne 2){ throw "Transient case expected exactly 2 attempts, got $transientCount" }
$transientStatus = Get-Content -Raw (Join-Path $transient 'watchdog-status.json') | ConvertFrom-Json
if($transientStatus.result -ne 'PASS' -or [int]$transientStatus.attempts -ne 2){ throw 'Transient watchdog status mismatch.' }
if([bool]$transientStatus.recurring_runtime_enabled){ throw 'Watchdog must not claim recurring runtime enabled.' }
if([bool]$transientStatus.external_effects_authorized){ throw 'Watchdog must not authorize external effects.' }
Write-Host 'WATCHDOG_TRANSIENT_RECOVERY: PASS'

$persistent = New-TestRoot 'persistent'
$env:NEXIA_WATCHDOG_TEST_MODE = 'persistent'
& pwsh -NoProfile -File $watchdog -Repo 'test/repo' -Branch main -BaseDir $persistent -MaxAttempts 2 -DelaySeconds 0
$persistentCode = $LASTEXITCODE
if($persistentCode -eq 0){ throw 'Persistent failure case unexpectedly returned exit 0.' }
$persistentCount = [int](Get-Content -Raw (Join-Path $persistent 'attempt-count.txt'))
if($persistentCount -ne 2){ throw "Persistent case expected exactly 2 attempts, got $persistentCount" }
$persistentStatus = Get-Content -Raw (Join-Path $persistent 'watchdog-status.json') | ConvertFrom-Json
if($persistentStatus.result -ne 'FAIL_RETRY_EXHAUSTED' -or [int]$persistentStatus.attempts -ne 2){ throw 'Persistent watchdog status mismatch.' }
if([int]$persistentStatus.max_attempts -ne 2){ throw 'Persistent case max_attempts mismatch.' }
Write-Host 'WATCHDOG_RETRY_CAP_FAIL_CLOSED: PASS'

Remove-Item Env:NEXIA_WATCHDOG_TEST_MODE -ErrorAction SilentlyContinue
Write-Host 'WATCHDOG_RETRY_SUITE: PASS'
exit 0
