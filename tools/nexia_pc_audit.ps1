# NEXIA PC AUDIT — read-only Windows hardware/software inventory
# No installs, no configuration changes, no cleanup, no network calls.
# Output stays local unless Kael explicitly shares it.

param(
    [string]$OutputPath = "$env:USERPROFILE\NEXIA_PC_AUDIT.json"
)

$ErrorActionPreference = "SilentlyContinue"

function Convert-BytesToGB([double]$Bytes) {
    if ($null -eq $Bytes -or $Bytes -le 0) { return 0 }
    return [math]::Round($Bytes / 1GB, 2)
}

function Get-ToolVersion {
    param(
        [string]$Name,
        [string[]]$Arguments
    )
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if (-not $cmd) { return $null }
    try {
        $line = (& $cmd.Source @Arguments 2>&1 | Select-Object -First 1)
        if ($null -eq $line) { return "installed_version_unknown" }
        return ("$line").Trim()
    } catch {
        return "installed_version_unknown"
    }
}

$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1

$adapters = @(
    Get-CimInstance Win32_VideoController | ForEach-Object {
        [ordered]@{
            name = $_.Name
            vendor_compatibility = $_.AdapterCompatibility
            driver_version = $_.DriverVersion
            adapter_ram_gb = Convert-BytesToGB ([double]$_.AdapterRAM)
            note = "Win32_VideoController.AdapterRAM is best-effort; NVIDIA nvidia-smi data is preferred when available."
        }
    }
)

$nvidiaRows = @()
$cudaVersion = $null
$nvidia = Get-Command nvidia-smi -ErrorAction SilentlyContinue
if ($nvidia) {
    try {
        $rawRows = & $nvidia.Source --query-gpu=name,memory.total,driver_version --format=csv,noheader,nounits 2>$null
        foreach ($row in $rawRows) {
            $parts = "$row" -split ','
            if ($parts.Count -ge 3) {
                $nvidiaRows += [ordered]@{
                    name = $parts[0].Trim()
                    memory_total_gb = [math]::Round(([double]$parts[1].Trim()) / 1024, 2)
                    driver_version = $parts[2].Trim()
                }
            }
        }
        $header = ((& $nvidia.Source 2>&1 | Select-Object -First 8) -join " ")
        if ($header -match 'CUDA Version:\s*([0-9\.]+)') {
            $cudaVersion = $Matches[1]
        }
    } catch {}
}

$volumes = @(
    Get-Volume | Where-Object { $_.DriveLetter } | ForEach-Object {
        [ordered]@{
            drive = "$($_.DriveLetter):"
            file_system = $_.FileSystem
            size_gb = Convert-BytesToGB ([double]$_.Size)
            free_gb = Convert-BytesToGB ([double]$_.SizeRemaining)
        }
    }
)

$topMemory = @(
    Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 15 | ForEach-Object {
        [ordered]@{
            name = $_.ProcessName
            pid = $_.Id
            working_set_mb = [math]::Round($_.WorkingSet64 / 1MB, 1)
            cpu_seconds = if ($null -ne $_.CPU) { [math]::Round($_.CPU, 1) } else { $null }
        }
    }
)

$startup = @(
    Get-CimInstance Win32_StartupCommand | ForEach-Object {
        [ordered]@{
            name = $_.Name
            location = $_.Location
        }
    }
)

$defender = $null
try {
    $mp = Get-MpComputerStatus
    if ($mp) {
        $defender = [ordered]@{
            antivirus_enabled = $mp.AntivirusEnabled
            realtime_protection_enabled = $mp.RealTimeProtectionEnabled
            antispyware_enabled = $mp.AntispywareEnabled
            signatures_last_updated = $mp.AntivirusSignatureLastUpdated
        }
    }
} catch {}

$powerPlan = $null
try {
    $powerPlan = ((powercfg /GETACTIVESCHEME 2>$null) -join " ").Trim()
} catch {}

$tools = [ordered]@{
    git = Get-ToolVersion "git" @("--version")
    node = Get-ToolVersion "node" @("--version")
    npm = Get-ToolVersion "npm" @("--version")
    python = Get-ToolVersion "python" @("--version")
    py = Get-ToolVersion "py" @("--version")
    ffmpeg = Get-ToolVersion "ffmpeg" @("-version")
    docker = Get-ToolVersion "docker" @("--version")
    ollama = Get-ToolVersion "ollama" @("--version")
    nvidia_smi = Get-ToolVersion "nvidia-smi" @("--version")
}

$audit = [ordered]@{
    schema_version = 1
    generated_at = (Get-Date).ToString("o")
    classification = "LOCAL_READ_ONLY_AUDIT"
    safety = [ordered]@{
        system_changes_performed = $false
        software_installed = $false
        files_deleted_or_moved = $false
        network_calls_intentionally_performed = $false
        secrets_collected = $false
    }
    os = [ordered]@{
        caption = $os.Caption
        version = $os.Version
        build_number = $os.BuildNumber
        architecture = $os.OSArchitecture
        last_boot = $os.LastBootUpTime
    }
    cpu = [ordered]@{
        name = $cpu.Name
        physical_cores = $cpu.NumberOfCores
        logical_processors = $cpu.NumberOfLogicalProcessors
        max_clock_mhz = $cpu.MaxClockSpeed
    }
    memory = [ordered]@{
        total_gb = Convert-BytesToGB ([double]$cs.TotalPhysicalMemory)
        free_gb = [math]::Round((([double]$os.FreePhysicalMemory * 1KB) / 1GB), 2)
    }
    graphics = [ordered]@{
        adapters = $adapters
        nvidia_smi = $nvidiaRows
        cuda_version_reported_by_nvidia_smi = $cudaVersion
    }
    storage = $volumes
    power_plan = $powerPlan
    developer_tools = $tools
    security = [ordered]@{
        microsoft_defender = $defender
    }
    startup_items = $startup
    top_processes_by_memory = $topMemory
    notes = @(
        "Temperature/thermal health is not reported because Windows exposes it inconsistently; use vendor telemetry later if needed.",
        "GPU VRAM from nvidia-smi is preferred over WMI AdapterRAM when NVIDIA is present.",
        "This audit does not prove that any AI model can run; benchmark evidence is required."
    )
}

$audit | ConvertTo-Json -Depth 8 | Set-Content -Path $OutputPath -Encoding UTF8
Write-Output "NEXIA_PC_AUDIT_WRITTEN=$OutputPath"
