param(
  [ValidateSet('InstallStart','Status','Stop','Finalize')][string]$Action='Status',
  [string]$Repo='micaelgonzalez92-cpu/Nexia-care',
  [string]$Branch='main',
  [string]$BaseDir="$env:LOCALAPPDATA\NEXIA\worker"
)

$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'
$MainTask='NEXIA Local Worker v0.1'
$StabilityTask='NEXIA Local Worker Stability 24H'
$CleanupTask='NEXIA Local Worker Stability 24H Cleanup'
$bin=Join-Path $BaseDir 'bin'
$runner=Join-Path $bin 'run_nexia_local_worker_stability_v0_1.ps1'
$watchdog=Join-Path $bin 'run_nexia_local_worker_watchdog_v0_1.ps1'
$windowPath=Join-Path $BaseDir 'stability-window.json'
$statusPath=Join-Path $BaseDir 'stability-status.json'
$eventsPath=Join-Path $BaseDir 'stability-events.jsonl'
$managerLocal=Join-Path $bin 'manage_nexia_local_worker_stability_24h_v0_1.ps1'

function Get-GhText([string]$Path){
  $apiOutput=& gh api "repos/$Repo/contents/$Path`?ref=$Branch" 2>&1
  if($LASTEXITCODE -ne 0){ throw "GITHUB_FETCH_FAILED: $Path" }
  $raw=(($apiOutput|Out-String).Trim())|ConvertFrom-Json -ErrorAction Stop
  if(-not $raw.content){ throw "GITHUB_RESPONSE_INCOMPLETE: $Path" }
  return [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(([string]$raw.content -replace '\s','')))
}
function Get-GhJson([string]$Path){ return ((Get-GhText $Path)|ConvertFrom-Json -ErrorAction Stop) }
function Write-Window($start,$end){
  $o=[ordered]@{
    schema_version=1
    test_id='LOCALWORKER-STABILITY-24H-001'
    authorized_scope='GREEN_INTERNAL_ONLY_NO_EXTERNAL_EFFECTS'
    started_at=$start.ToString('o')
    end_at=$end.ToString('o')
    interval_minutes=5
    auto_shutdown_required=$true
    persistent_24x7_authorized=$false
  }
  [IO.File]::WriteAllText($windowPath,($o|ConvertTo-Json -Depth 5)+"`n",[Text.UTF8Encoding]::new($false))
}
function Require-SafeRemoteState {
  if(-not (Get-Command gh -ErrorAction SilentlyContinue)){ throw 'GitHub CLI (gh) required.' }
  $c=Get-GhJson 'NEXIA_LOCAL_WORKER_CONTROL.json'
  if(([string]$c.desired_state).ToUpper() -ne 'RUN'){ throw 'Remote control must be RUN.' }
  if([bool]$c.deployment_authorized){ throw 'deployment_authorized must remain false for bounded stability test.' }
  if([bool]$c.external_effects_authorized){ throw 'external_effects_authorized must remain false.' }
  $q=Get-GhJson 'NEXIA_LOCAL_WORKER_QUEUE.json'
  $pending=@($q.tasks|Where-Object { ([string]$_.status).ToUpper() -in @('READY','PENDING') })
  if($pending.Count -gt 0){ throw "Queue must contain no READY/PENDING tasks. Found $($pending.Count)." }
}
function Require-MainTaskDisabled {
  $t=Get-ScheduledTask -TaskName $MainTask -ErrorAction SilentlyContinue
  if(-not $t){ throw 'Main worker Scheduled Task is not installed.' }
  if($t.State -ne 'Disabled'){ throw "Main worker task must remain Disabled, got $($t.State)." }
}
function Install-Script([string]$Remote,[string]$Local){
  $text=Get-GhText $Remote
  [IO.File]::WriteAllText($Local,$text,[Text.UTF8Encoding]::new($false))
  $tokens=$null;$errors=$null
  [System.Management.Automation.Language.Parser]::ParseFile($Local,[ref]$tokens,[ref]$errors)|Out-Null
  if($errors.Count){ throw (($errors|ForEach-Object {$_.Message}) -join '; ') }
}
function Finalize-Stability {
  $s=Get-ScheduledTask -TaskName $StabilityTask -ErrorAction SilentlyContinue
  if($s){ Disable-ScheduledTask -TaskName $StabilityTask | Out-Null }
  $c=Get-ScheduledTask -TaskName $CleanupTask -ErrorAction SilentlyContinue
  if($c){ Disable-ScheduledTask -TaskName $CleanupTask | Out-Null }
  $obj=[ordered]@{
    schema_version=1
    updated_at=[DateTimeOffset]::Now.ToString('o')
    test_id='LOCALWORKER-STABILITY-24H-001'
    finalizer='AUTO_SHUTDOWN'
    stability_task_state=if($s){(Get-ScheduledTask -TaskName $StabilityTask).State}else{'NOT_INSTALLED'}
    cleanup_task_state=if($c){(Get-ScheduledTask -TaskName $CleanupTask).State}else{'NOT_INSTALLED'}
    persistent_24x7_authorized=$false
    external_effects_authorized=$false
  }
  $finalPath=Join-Path $BaseDir 'stability-final.json'
  [IO.File]::WriteAllText($finalPath,($obj|ConvertTo-Json -Depth 5)+"`n",[Text.UTF8Encoding]::new($false))
  Write-Host 'STABILITY_AUTO_SHUTDOWN: PASS'
}

switch($Action){
  'InstallStart' {
    Require-MainTaskDisabled
    Require-SafeRemoteState
    New-Item -ItemType Directory -Force -Path $bin | Out-Null
    Install-Script 'tools/run_nexia_local_worker_watchdog_v0_1.ps1' $watchdog
    Install-Script 'tools/run_nexia_local_worker_stability_v0_1.ps1' $runner
    Install-Script 'tools/manage_nexia_local_worker_stability_24h_v0_1.ps1' $managerLocal

    Remove-Item $statusPath,$eventsPath,(Join-Path $BaseDir 'stability-final.json') -Force -ErrorAction SilentlyContinue
    $start=[DateTimeOffset]::Now
    $end=$start.AddHours(24)
    Write-Window $start $end

    # One immediate bounded integration cycle before scheduling recurrence.
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $runner -Repo $Repo -Branch $Branch -BaseDir $BaseDir -EndAtIso $end.ToString('o') -StabilityTaskName $StabilityTask -MaxAttempts 2 -DelaySeconds 1
    if($LASTEXITCODE -ne 0){ throw "Preflight stability cycle failed: $LASTEXITCODE" }

    $runAt=(Get-Date).AddMinutes(5)
    $trigger=New-ScheduledTaskTrigger -Once -At $runAt -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration (New-TimeSpan -Hours 25)
    $args="-NoProfile -ExecutionPolicy Bypass -File `"$runner`" -Repo `"$Repo`" -Branch `"$Branch`" -BaseDir `"$BaseDir`" -EndAtIso `"$($end.ToString('o'))`" -StabilityTaskName `"$StabilityTask`" -MaxAttempts 2 -DelaySeconds 1"
    $taskAction=New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $args
    $settings=New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 4)
    $principal=New-ScheduledTaskPrincipal -UserId ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) -LogonType Interactive -RunLevel Limited
    Register-ScheduledTask -TaskName $StabilityTask -Action $taskAction -Trigger $trigger -Settings $settings -Principal $principal -Force | Out-Null

    $cleanupAt=$end.LocalDateTime.AddMinutes(1)
    $cleanupTrigger=New-ScheduledTaskTrigger -Once -At $cleanupAt
    $cleanupArgs="-NoProfile -ExecutionPolicy Bypass -File `"$managerLocal`" -Action Finalize -Repo `"$Repo`" -Branch `"$Branch`" -BaseDir `"$BaseDir`""
    $cleanupAction=New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $cleanupArgs
    $cleanupSettings=New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 2)
    Register-ScheduledTask -TaskName $CleanupTask -Action $cleanupAction -Trigger $cleanupTrigger -Settings $cleanupSettings -Principal $principal -Force | Out-Null

    Write-Host 'STABILITY_24H_START: PASS'
    Write-Host "START_AT: $($start.ToString('o'))"
    Write-Host "END_AT: $($end.ToString('o'))"
    Write-Host "STABILITY_TASK_STATE: $((Get-ScheduledTask -TaskName $StabilityTask).State)"
    Write-Host "CLEANUP_TASK_STATE: $((Get-ScheduledTask -TaskName $CleanupTask).State)"
    Write-Host "MAIN_TASK_STATE: $((Get-ScheduledTask -TaskName $MainTask).State)"
  }
  'Status' {
    $s=Get-ScheduledTask -TaskName $StabilityTask -ErrorAction SilentlyContinue
    $c=Get-ScheduledTask -TaskName $CleanupTask -ErrorAction SilentlyContinue
    $m=Get-ScheduledTask -TaskName $MainTask -ErrorAction SilentlyContinue
    Write-Host "STABILITY_TASK: $(if($s){$s.State}else{'NOT_INSTALLED'})"
    Write-Host "CLEANUP_TASK: $(if($c){$c.State}else{'NOT_INSTALLED'})"
    Write-Host "MAIN_TASK: $(if($m){$m.State}else{'NOT_INSTALLED'})"
    if(Test-Path $windowPath){ Write-Host '--- WINDOW ---'; Get-Content -Raw $windowPath }
    if(Test-Path $statusPath){ Write-Host '--- STATUS ---'; Get-Content -Raw $statusPath }
    if(Test-Path (Join-Path $BaseDir 'stability-final.json')){ Write-Host '--- FINAL ---'; Get-Content -Raw (Join-Path $BaseDir 'stability-final.json') }
  }
  'Stop' {
    Finalize-Stability
    Write-Host 'STABILITY_MANUAL_STOP: PASS'
  }
  'Finalize' {
    Finalize-Stability
  }
}
