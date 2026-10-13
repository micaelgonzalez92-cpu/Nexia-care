param(
  [string]$Repo = 'micaelgonzalez92-cpu/Nexia-care',
  [string]$Branch = 'main',
  [string]$BaseDir = "$env:LOCALAPPDATA\NEXIA\worker"
)
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function Get-GhJsonFile([string]$Path) {
  $raw = gh api "repos/$Repo/contents/$Path`?ref=$Branch" | ConvertFrom-Json
  $bytes = [Convert]::FromBase64String(([string]$raw.content -replace '\s',''))
  $text = [Text.Encoding]::UTF8.GetString($bytes)
  return [pscustomobject]@{ Sha=[string]$raw.sha; Object=($text | ConvertFrom-Json); Text=$text }
}
function Put-GhJsonFile([string]$Path,$Object,[string]$Sha,[string]$Message) {
  $json = $Object | ConvertTo-Json -Depth 30
  $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($json + "`n"))
  gh api --method PUT "repos/$Repo/contents/$Path" -f message="$Message" -f content="$b64" -f sha="$Sha" -f branch="$Branch" | Out-Null
}
function MaterialStatus($s) {
  return [ordered]@{
    worker_version=[string]$s.worker_version
    state=[string]$s.state
    task_id=$(if($null -eq $s.task_id){$null}else{[string]$s.task_id})
    result=$(if($null -eq $s.result){$null}else{[string]$s.result})
    reason=$(if($null -eq $s.reason){$null}else{[string]$s.reason})
  }
}

New-Item -ItemType Directory -Force -Path $BaseDir | Out-Null
$bin = Join-Path $BaseDir 'bin'
New-Item -ItemType Directory -Force -Path $bin | Out-Null
$worker = Join-Path $bin 'nexia_local_worker_v0_1.py'
if(-not (Test-Path $worker)){ throw "Worker missing: $worker" }
if(-not (Get-Command gh -ErrorAction SilentlyContinue)){ throw 'gh CLI not available' }
if(-not (Get-Command python -ErrorAction SilentlyContinue)){ throw 'python not available' }

# Fail closed: no cached queue execution if GitHub/control cannot be fetched.
$controlRemote = Get-GhJsonFile 'NEXIA_LOCAL_WORKER_CONTROL.json'
$queueRemote = Get-GhJsonFile 'NEXIA_LOCAL_WORKER_QUEUE.json'
$controlLocal = Join-Path $BaseDir 'control.remote.json'
$queueLocal = Join-Path $BaseDir 'queue.remote.json'
$statusLocal = Join-Path $BaseDir 'status.json'
$controlRemote.Text | Set-Content -Encoding utf8 $controlLocal
$queueRemote.Text | Set-Content -Encoding utf8 $queueLocal

& python $worker --once --state-dir (Join-Path $BaseDir 'state') --queue-file $queueLocal --control-file $controlLocal --status-file $statusLocal
$workerExit=$LASTEXITCODE
if(-not (Test-Path $statusLocal)){ throw 'Worker produced no status file' }
$status = Get-Content -Raw $statusLocal | ConvertFrom-Json

# Mark only the matching remote task. STOP never consumes or changes queued work.
if($status.task_id -and $status.state -ne 'STOPPED') {
  $queueLatest = Get-GhJsonFile 'NEXIA_LOCAL_WORKER_QUEUE.json'
  if($queueLatest.Sha -ne $queueRemote.Sha){ throw 'Queue changed during cycle; fail closed and retry later' }
  $changed=$false
  foreach($t in @($queueLatest.Object.tasks)) {
    if([string]$t.task_id -eq [string]$status.task_id) {
      switch([string]$status.result) {
        'PASS' { $t.status='DONE'; $changed=$true }
        'SKIPPED_DUPLICATE' { $t.status='DONE'; $changed=$true }
        'FAIL' { $t.status='FAILED'; $changed=$true }
        'NOT_EXECUTED' { if($status.state -eq 'HUMAN_GATE'){ $t.status='HUMAN_GATE'; $changed=$true } }
      }
      if($changed){
        $t.last_result=[string]$status.result
        $t.worker_version=[string]$status.worker_version
        $t.completed_at=[string]$status.updated_at
      }
      break
    }
  }
  if($changed){ Put-GhJsonFile 'NEXIA_LOCAL_WORKER_QUEUE.json' $queueLatest.Object $queueLatest.Sha "Worker result $($status.task_id): $($status.result)" }
}

# Remote status is sanitized: never upload task output, cookies, page bodies or credentials.
$statusRemote = Get-GhJsonFile 'NEXIA_LOCAL_WORKER_STATUS.json'
$oldMaterial = [ordered]@{ worker_version=[string]$statusRemote.Object.worker_version; state=[string]$statusRemote.Object.execution_status; task_id=$statusRemote.Object.last_task_id; result=$statusRemote.Object.last_result; reason=$statusRemote.Object.reason }
$newMaterial = MaterialStatus $status
$oldJson=$oldMaterial|ConvertTo-Json -Compress; $newJson=$newMaterial|ConvertTo-Json -Compress
$stale=$true
try { $stale=((Get-Date) - [DateTimeOffset]::Parse([string]$statusRemote.Object.updated_at).LocalDateTime).TotalHours -ge 6 } catch {}
if(($oldJson -ne $newJson) -or $stale) {
  $remote=[ordered]@{
    schema_version=1
    updated_at=[DateTimeOffset]::Now.ToString('o')
    worker_version=[string]$status.worker_version
    deployment_status='DEPLOYED_CODE_PATH_ACTIVE'
    execution_status=[string]$status.state
    last_task_id=$status.task_id
    last_result=$status.result
    reason=$status.reason
    heartbeat='REMOTE_TRANSITION_OR_6H_HEARTBEAT'
    cash_spend_eur=0
    truth_limit='Status proves only the last sanitized worker cycle; it does not authorize external effects.'
  }
  Put-GhJsonFile 'NEXIA_LOCAL_WORKER_STATUS.json' $remote $statusRemote.Sha "Worker status: $($status.state) $($status.result)"
}
if($workerExit -ne 0){ exit $workerExit }
