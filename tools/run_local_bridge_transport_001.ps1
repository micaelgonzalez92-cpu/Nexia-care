$ErrorActionPreference = 'Continue'

Write-Host '=== NEXIA LOCAL-BRIDGE-TRANSPORT-001 PROBE ==='

$repoName = 'micaelgonzalez92-cpu/Nexia-care'

function Has-Command([string]$Name) {
    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

# Git
if (Has-Command 'git') {
    $gitVersion = (& git --version 2>$null)
    Write-Host "GIT_FOUND: PASS | $gitVersion"
} else {
    Write-Host 'GIT_FOUND: FAIL'
}

# GitHub CLI - never print auth output, token, scopes, or account details.
$ghFound = Has-Command 'gh'
$ghAuth = $false
$ghRepoRead = $false
if ($ghFound) {
    $ghVersion = (& gh --version 2>$null | Select-Object -First 1)
    Write-Host "GH_FOUND: PASS | $ghVersion"

    & gh auth status --hostname github.com *> $null
    if ($LASTEXITCODE -eq 0) {
        $ghAuth = $true
        Write-Host 'GH_AUTHENTICATED: PASS'

        & gh api "repos/$repoName" --silent *> $null
        if ($LASTEXITCODE -eq 0) {
            $ghRepoRead = $true
            Write-Host 'GH_REPO_READ: PASS'
        } else {
            Write-Host 'GH_REPO_READ: FAIL'
        }
    } else {
        Write-Host 'GH_AUTHENTICATED: FAIL'
    }
} else {
    Write-Host 'GH_FOUND: FAIL'
}

# Look only in bounded common locations; do not recursively scan the PC.
$candidates = @(
    "$env:USERPROFILE\Nexia-care",
    "$env:USERPROFILE\Desktop\Nexia-care",
    "$env:USERPROFILE\Documents\Nexia-care",
    'C:\Nexia-care'
)

$repoPath = $null
foreach ($p in $candidates) {
    if (Test-Path (Join-Path $p '.git')) {
        $repoPath = $p
        break
    }
}

$gitRemoteRead = $false
$gitPushDryRun = $false
if ($null -ne $repoPath -and (Has-Command 'git')) {
    Write-Host 'LOCAL_REPO_FOUND: PASS'

    & git -C $repoPath rev-parse --is-inside-work-tree *> $null
    if ($LASTEXITCODE -eq 0) {
        Write-Host 'LOCAL_REPO_VALID: PASS'
    } else {
        Write-Host 'LOCAL_REPO_VALID: FAIL'
    }

    & git -C $repoPath ls-remote --exit-code origin HEAD *> $null
    if ($LASTEXITCODE -eq 0) {
        $gitRemoteRead = $true
        Write-Host 'GIT_REMOTE_READ: PASS'
    } else {
        Write-Host 'GIT_REMOTE_READ: FAIL'
    }

    # Dry-run only: validates the local push path without creating a remote change.
    & git -C $repoPath push --dry-run origin HEAD:main *> $null
    if ($LASTEXITCODE -eq 0) {
        $gitPushDryRun = $true
        Write-Host 'GIT_PUSH_DRY_RUN: PASS'
    } else {
        Write-Host 'GIT_PUSH_DRY_RUN: FAIL'
    }
} else {
    Write-Host 'LOCAL_REPO_FOUND: FAIL'
}

if (Test-Path "$env:SystemRoot\System32\schtasks.exe") {
    Write-Host 'WINDOWS_TASK_SCHEDULER_AVAILABLE: PASS'
} else {
    Write-Host 'WINDOWS_TASK_SCHEDULER_AVAILABLE: FAIL'
}

if ($ghAuth -and $ghRepoRead) {
    Write-Host 'RETURN_CHANNEL_CANDIDATE: GH_CLI_AUTHENTICATED'
} elseif ($gitRemoteRead -and $gitPushDryRun) {
    Write-Host 'RETURN_CHANNEL_CANDIDATE: GIT_LOCAL_REPO'
} else {
    Write-Host 'RETURN_CHANNEL_CANDIDATE: NONE_VERIFIED'
}

Write-Host 'LOCAL_BRIDGE_TRANSPORT_001_RESULT: COMPLETE'
Write-Host '=== END NEXIA LOCAL-BRIDGE-TRANSPORT-001 PROBE ==='
