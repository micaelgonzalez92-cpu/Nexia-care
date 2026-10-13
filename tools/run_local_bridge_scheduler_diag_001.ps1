$ErrorActionPreference = 'Continue'

Write-Host '=== NEXIA LOCAL-BRIDGE-SCHEDULER-DIAG-001 ==='

$taskName = 'NEXIA_LOCAL_BRIDGE_SCHEDULER_001'
$localDir = Join-Path $env:LOCALAPPDATA 'NEXIA\bridge'
$workerPath = Join-Path $localDir 'scheduler_001_worker.ps1'
$workerLog = Join-Path $localDir 'scheduler_001_worker.log'

$task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($null -eq $task) {
    Write-Host 'SCHEDULED_TASK_PRESENT: NO'
}
else {
    Write-Host 'SCHEDULED_TASK_PRESENT: YES'
    Write-Host ("SCHEDULED_TASK_STATE: " + [string]$task.State)
    try {
        $info = Get-ScheduledTaskInfo -TaskName $taskName -ErrorAction Stop
        Write-Host ("SCHEDULED_TASK_LAST_RESULT: " + [string]$info.LastTaskResult)
        Write-Host ("SCHEDULED_TASK_LAST_RUN: " + $info.LastRunTime.ToString('o'))
    }
    catch {
        Write-Host 'SCHEDULED_TASK_INFO: UNAVAILABLE'
    }
}

Write-Host ("WORKER_FILE_PRESENT: " + $(if (Test-Path $workerPath) { 'YES' } else { 'NO' }))
Write-Host ("WORKER_LOG_PRESENT: " + $(if (Test-Path $workerLog) { 'YES' } else { 'NO' }))

if (Test-Path $workerLog) {
    Write-Host 'WORKER_LOG_TAIL_BEGIN'
    Get-Content -Path $workerLog -Tail 20 | ForEach-Object {
        $line = [string]$_
        $line = $line -replace '(?i)(gho_|github_pat_|token=|authorization:).*', '[REDACTED]'
        Write-Host $line
    }
    Write-Host 'WORKER_LOG_TAIL_END'
}

$gh = Get-Command gh -ErrorAction SilentlyContinue
if ($null -eq $gh) {
    Write-Host 'GH_FOUND: NO'
    Write-Host 'GH_AUTH: UNKNOWN'
}
else {
    Write-Host 'GH_FOUND: YES'
    & gh auth status --hostname github.com 1>$null 2>$null
    if ($LASTEXITCODE -eq 0) { Write-Host 'GH_AUTH: PASS' } else { Write-Host 'GH_AUTH: FAIL' }
}

Write-Host 'DIAGNOSTIC_SIDE_EFFECTS: NONE'
Write-Host 'LOCAL_BRIDGE_SCHEDULER_DIAG_001_RESULT: COMPLETE'
Write-Host '=== END NEXIA LOCAL-BRIDGE-SCHEDULER-DIAG-001 ==='
