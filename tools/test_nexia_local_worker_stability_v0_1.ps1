$ErrorActionPreference='Stop'

$repoRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$runner=Join-Path $repoRoot 'tools/run_nexia_local_worker_stability_v0_1.ps1'
$root=Join-Path ([IO.Path]::GetTempPath()) ('nexia-stability-test-'+[guid]::NewGuid().ToString('N'))
$bin=Join-Path $root 'bin'
$fakeBin=Join-Path $root 'fakebin'
New-Item -ItemType Directory -Force -Path $bin,$fakeBin | Out-Null

try {
  $watchdog=Join-Path $bin 'run_nexia_local_worker_watchdog_v0_1.ps1'
@'
param([string]$Repo,[string]$Branch,[string]$BaseDir,[int]$MaxAttempts,[int]$DelaySeconds)
$countPath=Join-Path $BaseDir 'fake-watchdog-count.txt'
$n=0
if(Test-Path $countPath){ $n=[int](Get-Content -Raw $countPath) }
$n++
Set-Content -NoNewline -Encoding ascii $countPath $n
exit 0
'@ | Set-Content -Encoding utf8 $watchdog

  $controlRun='{"desired_state":"RUN","deployment_authorized":false,"external_effects_authorized":false}'
  $queueEmpty='{"tasks":[]}'
  $queueReady='{"tasks":[{"task_id":"X","action":"HEALTH_CHECK","authority":"GREEN_INTERNAL","external_effects":false,"status":"READY"}]}'
  $controlB64=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($controlRun))
  $queueEmptyB64=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($queueEmpty))
  $queueReadyB64=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($queueReady))

  $fakeGh=Join-Path $fakeBin 'gh'
  $script=@"
#!/usr/bin/env bash
if [[ \"\$NEXIA_FAKE_GH_MODE\" == \"fail\" ]]; then exit 1; fi
if [[ \"\$*\" == *\"NEXIA_LOCAL_WORKER_CONTROL.json\"* ]]; then
  printf '%s\\n' '{\"content\":\"$controlB64\"}'
  exit 0
fi
if [[ \"\$*\" == *\"NEXIA_LOCAL_WORKER_QUEUE.json\"* ]]; then
  if [[ \"\$NEXIA_FAKE_GH_MODE\" == \"queue_ready\" ]]; then
    printf '%s\\n' '{\"content\":\"$queueReadyB64\"}'
  else
    printf '%s\\n' '{\"content\":\"$queueEmptyB64\"}'
  fi
  exit 0
fi
exit 2
"@
  [IO.File]::WriteAllText($fakeGh,$script,[Text.UTF8Encoding]::new($false))
  & chmod +x $fakeGh
  $oldPath=$env:PATH
  $env:PATH="$fakeBin$([IO.Path]::PathSeparator)$oldPath"

  $future=[DateTimeOffset]::Now.AddHours(1).ToString('o')
  $past=[DateTimeOffset]::Now.AddMinutes(-1).ToString('o')

  $env:NEXIA_FAKE_GH_MODE='normal'
  & pwsh -NoProfile -File $runner -Repo test/repo -Branch main -BaseDir $root -EndAtIso $future -MaxAttempts 2 -DelaySeconds 0
  if($LASTEXITCODE -ne 0){ throw "normal case exit=$LASTEXITCODE" }
  $status=Get-Content -Raw (Join-Path $root 'stability-status.json') | ConvertFrom-Json
  if($status.result -ne 'PASS'){ throw "normal result=$($status.result)" }
  if([int](Get-Content -Raw (Join-Path $root 'fake-watchdog-count.txt')) -ne 1){ throw 'watchdog should run exactly once in normal case' }
  Write-Host 'PASS normal no-task cycle invokes watchdog once'

  $env:NEXIA_FAKE_GH_MODE='fail'
  & pwsh -NoProfile -File $runner -Repo test/repo -Branch main -BaseDir $root -EndAtIso $future -MaxAttempts 2 -DelaySeconds 0
  if($LASTEXITCODE -ne 71){ throw "gh failure expected 71 got $LASTEXITCODE" }
  if([int](Get-Content -Raw (Join-Path $root 'fake-watchdog-count.txt')) -ne 1){ throw 'watchdog must not run on GitHub fetch failure' }
  Write-Host 'PASS GitHub failure fails closed before watchdog'

  $env:NEXIA_FAKE_GH_MODE='queue_ready'
  & pwsh -NoProfile -File $runner -Repo test/repo -Branch main -BaseDir $root -EndAtIso $future -MaxAttempts 2 -DelaySeconds 0
  if($LASTEXITCODE -ne 75){ throw "queue safety expected 75 got $LASTEXITCODE" }
  if([int](Get-Content -Raw (Join-Path $root 'fake-watchdog-count.txt')) -ne 1){ throw 'watchdog must not run when queue is non-empty' }
  Write-Host 'PASS READY queue triggers safety stop before watchdog'

  $env:NEXIA_FAKE_GH_MODE='fail'
  & pwsh -NoProfile -File $runner -Repo test/repo -Branch main -BaseDir $root -EndAtIso $past -MaxAttempts 2 -DelaySeconds 0
  if($LASTEXITCODE -ne 0){ throw "expired window expected 0 got $LASTEXITCODE" }
  $expired=Get-Content -Raw (Join-Path $root 'stability-status.json') | ConvertFrom-Json
  if($expired.result -ne 'WINDOW_COMPLETE_AUTO_DISABLED'){ throw "expired result=$($expired.result)" }
  if([int](Get-Content -Raw (Join-Path $root 'fake-watchdog-count.txt')) -ne 1){ throw 'watchdog must not run after end time' }
  Write-Host 'PASS expired window stops before network or watchdog'

  Write-Host '4/4 stability safety checks passed'
} finally {
  $env:PATH=$oldPath
  Remove-Item Env:NEXIA_FAKE_GH_MODE -ErrorAction SilentlyContinue
  Remove-Item $root -Recurse -Force -ErrorAction SilentlyContinue
}
