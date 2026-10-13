$ErrorActionPreference = 'Stop'

Write-Host '=== NEXIA LOCAL-BRIDGE-TRANSPORT-002 PROBE ==='

try {
    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    if ($null -eq $winget) {
        Write-Host 'WINGET_FOUND: FAIL'
        Write-Host 'GH_PACKAGE_AVAILABLE: UNKNOWN'
        Write-Host 'LOCAL_BRIDGE_TRANSPORT_002_RESULT: COMPLETE_NO_INSTALL_PATH_VERIFIED'
        Write-Host '=== END NEXIA LOCAL-BRIDGE-TRANSPORT-002 PROBE ==='
        exit 0
    }

    Write-Host "WINGET_FOUND: PASS | $($winget.Source)"

    try {
        $version = & winget.exe --version 2>$null
        Write-Host "WINGET_VERSION: $version"
    }
    catch {
        Write-Host 'WINGET_VERSION: UNKNOWN'
    }

    try {
        $output = & winget.exe show --id GitHub.cli --exact --accept-source-agreements --disable-interactivity 2>&1
        $text = ($output | Out-String)
        if ($LASTEXITCODE -eq 0 -and $text -match '(?i)GitHub CLI|GitHub\.cli') {
            Write-Host 'GH_PACKAGE_AVAILABLE: PASS'
            $versionLine = ($output | Where-Object { $_ -match '^Version:' } | Select-Object -First 1)
            if ($versionLine) { Write-Host "GH_PACKAGE_$versionLine" }
        }
        else {
            Write-Host 'GH_PACKAGE_AVAILABLE: FAIL'
        }
    }
    catch {
        Write-Host 'GH_PACKAGE_AVAILABLE: FAIL'
        Write-Host "GH_PACKAGE_ERROR: $($_.Exception.Message)"
    }

    $curl = Get-Command curl.exe -ErrorAction SilentlyContinue
    if ($null -ne $curl) {
        Write-Host "CURL_FOUND: PASS | $($curl.Source)"
    }
    else {
        Write-Host 'CURL_FOUND: FAIL'
    }

    Write-Host 'LOCAL_BRIDGE_TRANSPORT_002_RESULT: COMPLETE'
}
catch {
    Write-Host 'LOCAL_BRIDGE_TRANSPORT_002_RESULT: FAIL'
    Write-Host "ERROR: $($_.Exception.Message)"
}

Write-Host '=== END NEXIA LOCAL-BRIDGE-TRANSPORT-002 PROBE ==='
