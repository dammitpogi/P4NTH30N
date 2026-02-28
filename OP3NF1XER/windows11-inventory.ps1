$ErrorActionPreference = 'Stop'

$root = Join-Path $PSScriptRoot 'knowledge'
$timestamp = Get-Date -Format 'yyyy-MM-ddTHH-mm-ss'

if (-not (Test-Path $root)) {
  New-Item -ItemType Directory -Path $root -Force | Out-Null
}

$os = Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsBuildNumber, OsHardwareAbstractionLayer
$cpu = Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors
$memory = Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, Size, FreeSpace

$managedPackages = @(
  [PSCustomObject]@{
    Id = 'SUSE.RancherDesktop'
    Output = @(winget list --id SUSE.RancherDesktop --accept-source-agreements 2>$null)
  },
  [PSCustomObject]@{
    Id = 'ElementLabs.LMStudio'
    Output = @(winget list --id ElementLabs.LMStudio --accept-source-agreements 2>$null)
  },
  [PSCustomObject]@{
    Id = 'ToolHive'
    Output = @(winget list ToolHive --accept-source-agreements 2>$null)
  },
  [PSCustomObject]@{
    Id = 'SST.OpenCodeDesktop'
    Output = @(winget list --id SST.OpenCodeDesktop --accept-source-agreements 2>$null)
  }
)

$report = [PSCustomObject]@{
  generatedAt = (Get-Date).ToString('o')
  machine = $env:COMPUTERNAME
  os = $os
  cpu = $cpu
  memory = $memory
  disk = $disk
  managedPackages = $managedPackages
}

$jsonPath = Join-Path $root "windows11-inventory-$timestamp.json"
$report | ConvertTo-Json -Depth 6 | Set-Content -Path $jsonPath

Write-Host "[windows11] inventory exported: $jsonPath"
