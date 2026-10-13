param(
  [string]$Repo = 'micaelgonzalez92-cpu/Nexia-care',
  [string]$Branch = 'main',
  [string]$BaseDir = "$env:LOCALAPPDATA\NEXIA\worker",
  [Parameter(Mandatory=$true)][string]$EndAtIso,
  [string]$StabilityTaskName = 'NEXIA Local Worker Stability 24H',
  [ValidateRange(1,3)][int]$MaxAttempts = 2,
  [ValidateRange(0,30)][int]$DelaySeconds = 2
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$bin = Join-Path $BaseDir 'bin'
$watchdog = Join-Path $bin 'run_nexia_local_worker_watchdog_v0_1.ps1'
$statusPath = Join-Path $BaseDir 'stability-status.json'
$eventsPath = Join-Path $BaseDir 'stability-events.jsonl'
if(-not (Test-Path $watchdog)){ throw "Watchdog missing: $watchdog" }
if(-not (Get-Command gh -ErrorAction SilentlyContinue)){ throw 'GitHub CLI (gh) is required.' }

try { $endAt = [DateTimeOffset]::Parse($EndAtIso) }
catch { throw "Invalid EndAtIso: $EndAtIso" }

function Read-PreviousStatus {
  if(-not (Test-Path $statusPath)){ return $null }
  try { return (Get-Content -Raw $statusPath | ConvertFrom-Json -ErrorAction Stop) }
  catch { return $null }
}

function Write-StabilityRecord(
  [string]$Result,
  [string]$Reason,
  [int]$ExitCode,
  [bool]$AutoDisabled,
  [bool]$ExternalEffectsAuthorized
) {
  $prev = Read-PreviousStatus
  $cycles = 0
  $passes = 0
  $failures = 0
  if($null -ne $prev){
    $cycles = [int]$prev.cycles_total
    $passes = [int]$prev.cycles_pass
    $failures = [int]$prev.cycles_fail
  }
  $cycles++
  if($Result -eq 'PASS' -or $Result -eq 'WINDOW_COMPLETE_AUTO_DISABLED'){ $passes++ } else { $failures++ }

  $obj = [ordered]@{
    schema_version = 1
    updated_at = [DateTimeOffset]::Now.ToString('o')
    stability_version = '0.1.0'
    result = $Result
    reason = $Reason
    last_exit_code = $ExitCode
    cycles_total = $cycles
    cycles_pass = $passes
    cycles_fail = $failures
    window_end_at = $endAt.ToString('o')
    recurring_runtime_scope = 'TEMPORARY_24H_TEST_ONLY'
    queue_policy = 'NO_READY_OR_PENDING_TASKS_DURING_STABILITY_TEST'
    green_internal_only = $true
    external_effects_authorized = $ExternalEffectsAuthorized
    auto_disabled = $AutoDisabled
  }
  $json = $obj | ConvertTo-Json -Depth 6
  [IO.File]::WriteAllText($statusPath,$json + "`n",[Text.UTF8Encoding]::new($false))
  $line = $obj | ConvertTo-Json -Compress -Depth 6
  [IO.File]::AppendAllText($eventsPath,$line + "`n",[Text.UTF8Encoding]::new($false))
}

function Disable-StabilityTask {
  if(Get-Command Disable-ScheduledTask -ErrorAction SilentlyContinue){
    $t = Get-ScheduledTask -TaskName $StabilityTaskName -ErrorAction SilentlyContinue
    if($t){ Disable-ScheduledTask -TaskName $StabilityTaskName | Out-Null; return $true }
  }
  return $false
}

function Get-GhJsonFile([string]$Path) {
  $apiOutput = & gh api "repos/$Repo/contents/$Path`?ref=$Branch" 2>&1
  $ghExit = $LASTEXITCODE
  if($ghExit -ne 0){ throw "GITHUB_FETCH_FAILED: $Path" }
  try { $raw = (($apiOutput | Out-String).Trim()) | ConvertFrom-Json -ErrorAction Stop }
  catch { throw "GITHUB_RESPONSE_INVALID_JSON: $Path" }
  if(-not $raw.content){ throw "GITHUB_RESPONSE_INCOMPLETE: $Path" }
  try { $bytes = [Convert]::FromBase64String(([string]$raw.content -replace '\s','')) }
  catch { throw "GITHUB_CONTENT_BASE64_INVALID: $Path" }
  $text = [Text.Encoding]::UTF8.GetString($bytes)
  try { return ($text | ConvertFrom-Json -ErrorAction Stop) }
  catch { throw "GITHUB_CONTENT_INVALID_JSON: $Path" }
}

$now = [DateTimeOffset]::Now
if($now -ge $endAt){
  $disabled = Disable-StabilityTask
  Write-StabilityRecord 'WINDOW_COMPLETE_AUTO_DISABLED' 'END_TIME_REACHED' 0 $disabled $false
  Write-Host "STABILITY_WINDOW_COMPLETE: auto_disabled=$disabled"
  exit 0
}

try {
  $control = Get-GhJsonFile 'NEXIA_LOCAL_WORKER_CONTROL.json'
  $queue = Get-GhJsonFile 'NEXIA_LOCAL_WORKER_QUEUE.json'
} catch {
  Write-StabilityRecord 'FAIL_CLOSED_TRANSIENT' $_.Exception.Message 71 $false $false
  Write-Host "STABILITY_FAIL_CLOSED_TRANSIENT: $($_.Exception.Message)"
  exit 71
}

if(([string]$control.desired_state).ToUpper() -ne 'RUN'){
  $disabled = Disable-StabilityTask
  Write-StabilityRecord 'SAFETY_STOP' 'REMOTE_CONTROL_NOT_RUN' 72 $disabled ([bool]$control.external_effects_authorized)
  Write-Host "STABILITY_SAFETY_STOP: REMOTE_CONTROL_NOT_RUN auto_disabled=$disabled"
  exit 72
}
if([bool]$control.deployment_authorized){
  $disabled = Disable-StabilityTask
  Write-StabilityRecord 'SAFETY_STOP' 'DEPLOYMENT_AUTHORIZED_UNEXPECTEDLY_TRUE' 73 $disabled ([bool]$control.external_effects_authorized)
  Write-Host "STABILITY_SAFETY_STOP: DEPLOYMENT_AUTHORIZED_UNEXPECTEDLY_TRUE auto_disabled=$disabled"
  exit 73
}
if([bool]$control.external_effects_authorized){
  $disabled = Disable-StabilityTask
  Write-StabilityRecord 'SAFETY_STOP' 'EXTERNAL_EFFECTS_AUTHORIZED_TRUE' 74 $disabled $true
  Write-Host "STABILITY_SAFETY_STOP: EXTERNAL_EFFECTS_AUTHORIZED_TRUE auto_disabled=$disabled"
  exit 74
}

$pending = @($queue.tasks | Where-Object { ([string]$_.status).ToUpper() -in @('READY','PENDING') })
if($pending.Count -gt 0){
  $disabled = Disable-StabilityTask
  Write-StabilityRecord 'SAFETY_STOP' 'QUEUE_NOT_EMPTY' 75 $disabled $false
  Write-Host "STABILITY_SAFETY_STOP: QUEUE_NOT_EMPTY count=$($pending.Count) auto_disabled=$disabled"
  exit 75
}

& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $watchdog -Repo $Repo -Branch $Branch -BaseDir $BaseDir -MaxAttempts $MaxAttempts -DelaySeconds $DelaySeconds
$watchdogExit = $LASTEXITCODE
if($watchdogExit -ne 0){
  Write-StabilityRecord 'WATCHDOG_FAIL' 'WATCHDOG_NONZERO_EXIT' $watchdogExit $false $false
  Write-Host "STABILITY_WATCHDOG_FAIL: exit=$watchdogExit"
  exit $watchdogExit
}

Write-StabilityRecord 'PASS' 'NO_TASK_CYCLE_OK' 0 $false $false
Write-Host 'STABILITY_CYCLE: PASS'
exit 0
