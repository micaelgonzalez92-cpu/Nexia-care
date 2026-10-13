param(
  [ValidateSet('InstallDisabled','Enable','Disable','Uninstall','Rearm','Status')]
  [string]$Action='Status',
  [string]$Repo='micaelgonzalez92-cpu/Nexia-care',
  [string]$Branch='main',
  [string]$BaseDir="$env:LOCALAPPDATA\NEXIA\worker"
)
$ErrorActionPreference='Stop'
$TaskName='NEXIA Local Worker v0.1'
$bin=Join-Path $BaseDir 'bin'; $worker=Join-Path $bin 'nexia_local_worker_v0_1.py'; $cycle=Join-Path $bin 'run_nexia_local_worker_cycle_v0_1.ps1'
function Raw([string]$Path){ "https://raw.githubusercontent.com/$Repo/$Branch/$Path" }
function Require-Base {
  if(-not (Get-Command gh -ErrorAction SilentlyContinue)){ throw 'GitHub CLI (gh) is required and was previously verified by Nexia.' }
  if(-not (Get-Command python -ErrorAction SilentlyContinue)){ throw 'Python is required.' }
}
function Remote-Control {
  return Invoke-RestMethod -Uri (Raw 'NEXIA_LOCAL_WORKER_CONTROL.json') -TimeoutSec 15
}

switch($Action){
  'InstallDisabled' {
    Require-Base
    New-Item -ItemType Directory -Force -Path $bin | Out-Null
    Invoke-WebRequest -UseBasicParsing -Uri (Raw 'tools/nexia_local_worker_v0_1.py') -OutFile $worker
    Invoke-WebRequest -UseBasicParsing -Uri (Raw 'tools/run_nexia_local_worker_cycle_v0_1.ps1') -OutFile $cycle
    & python -m py_compile $worker
    $tokens=$null;$errors=$null;[System.Management.Automation.Language.Parser]::ParseFile($cycle,[ref]$tokens,[ref]$errors)|Out-Null
    if($errors.Count){ throw ($errors | ForEach-Object {$_.Message} | Out-String) }
    $ps="`"$PSHOME\powershell.exe`" -NoProfile -ExecutionPolicy Bypass -File `"$cycle`" -Repo `"$Repo`" -Branch `"$Branch`" -BaseDir `"$BaseDir`""
    $action=New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$cycle`" -Repo `"$Repo`" -Branch `"$Branch`" -BaseDir `"$BaseDir`""
    $trigger=New-ScheduledTaskTrigger -Once -At ((Get-Date).AddMinutes(2)) -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration (New-TimeSpan -Days 3650)
    $settings=New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 10)
    $principal=New-ScheduledTaskPrincipal -UserId ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) -LogonType Interactive -RunLevel Limited
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force | Out-Null
    Disable-ScheduledTask -TaskName $TaskName | Out-Null
    Write-Host 'INSTALL_DISABLED: PASS'
    Write-Host 'The task exists but cannot run until separately enabled.'
  }
  'Enable' {
    Require-Base
    $c=Remote-Control
    if(([string]$c.desired_state).ToUpper() -ne 'RUN'){ throw 'Remote control is not RUN. Refusing enable.' }
    if(-not [bool]$c.deployment_authorized){ throw 'deployment_authorized is not true. Refusing enable.' }
    Enable-ScheduledTask -TaskName $TaskName | Out-Null
    Write-Host 'ENABLE: PASS'
  }
  'Disable' { Disable-ScheduledTask -TaskName $TaskName | Out-Null; Write-Host 'DISABLE: PASS' }
  'Uninstall' {
    $t=Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if($t){ Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false }
    Write-Host 'UNINSTALL: PASS'
  }
  'Rearm' {
    Require-Base
    $c=Remote-Control
    if(([string]$c.desired_state).ToUpper() -ne 'RUN'){ throw 'Remote control is not RUN. Refusing local re-arm.' }
    if(-not [bool]$c.deployment_authorized){ throw 'deployment_authorized is not true. Refusing local re-arm.' }
    & python $worker --rearm-local --state-dir (Join-Path $BaseDir 'state') --status-file (Join-Path $BaseDir 'status.json')
    if($LASTEXITCODE -ne 0){ throw 'Local re-arm failed.' }
  }
  'Status' {
    $t=Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if(-not $t){ Write-Host 'TASK: NOT_INSTALLED'; exit 0 }
    $i=Get-ScheduledTaskInfo -TaskName $TaskName
    Write-Host "TASK: $($t.State) | Last=$($i.LastRunTime) | Result=$($i.LastTaskResult) | Next=$($i.NextRunTime)"
  }
}
