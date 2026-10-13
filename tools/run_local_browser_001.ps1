$ErrorActionPreference = 'Stop'

Write-Host 'NEXIA LOCAL-BROWSER-001'
Write-Host 'Scope: detect existing Edge/Chrome + public read-only headless probe; EUR0; no install/login/form submission.'

$candidates = @(
  "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe",
  "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
)

$browser = $null
foreach ($c in $candidates) {
  if ($c -and (Test-Path -LiteralPath $c)) { $browser = $c; break }
}

$outDir = Join-Path $env:USERPROFILE 'NEXIA_LOCAL_BROWSER_001'
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
$domPath = Join-Path $outDir 'example-domain.html'
$resultPath = Join-Path $outDir 'local-browser-001-result.json'

$result = [ordered]@{
  experiment = 'LOCAL-BROWSER-001'
  browser_found = $false
  browser_path = $browser
  target = 'https://example.com'
  exit_code = $null
  expected_marker_found = $false
  status = 'BLOCKED_OR_FAILED'
  cash_spend_eur = 0
  work_codex_used = $false
  error = $null
}

try {
  if (-not $browser) { throw 'No existing Microsoft Edge or Google Chrome executable found in standard Windows locations.' }
  $result.browser_found = $true

  $args = @(
    '--headless=new',
    '--disable-gpu',
    '--no-first-run',
    '--no-default-browser-check',
    '--dump-dom',
    'https://example.com'
  )

  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = $browser
  $psi.Arguments = ($args -join ' ')
  $psi.UseShellExecute = $false
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError = $true
  $psi.CreateNoWindow = $true

  $p = New-Object System.Diagnostics.Process
  $p.StartInfo = $psi
  [void]$p.Start()
  $stdout = $p.StandardOutput.ReadToEnd()
  $stderr = $p.StandardError.ReadToEnd()
  $p.WaitForExit()

  $result.exit_code = $p.ExitCode
  Set-Content -LiteralPath $domPath -Value $stdout -Encoding UTF8
  $result.expected_marker_found = ($stdout -match 'Example Domain')

  if ($p.ExitCode -eq 0 -and $result.expected_marker_found) {
    $result.status = 'PASS_PUBLIC_READONLY'
  } else {
    $result.error = "Browser exited $($p.ExitCode). stderr=$stderr"
  }
} catch {
  $result.error = $_.Exception.Message
}

$result | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $resultPath -Encoding UTF8

Write-Host ''
Write-Host '=== NEXIA LOCAL-BROWSER-001 RESULT ==='
Write-Host "Status: $($result.status)"
Write-Host "Browser: $($result.browser_path)"
Write-Host "Exit code: $($result.exit_code)"
Write-Host "Expected marker found: $($result.expected_marker_found)"
Write-Host 'Cash spend: EUR0'
Write-Host 'Work/Codex used: false'
Write-Host "Report: $resultPath"
if ($result.error) { Write-Host "Error: $($result.error)" }

if ($result.status -eq 'PASS_PUBLIC_READONLY') { exit 0 } else { exit 2 }
