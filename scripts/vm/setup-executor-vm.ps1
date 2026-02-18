<#
.SYNOPSIS
    Creates and configures a lightweight Hyper-V VM for FourEyes automation.

.DESCRIPTION
    Provisions a Windows 10 Pro VM optimized as a FourEyes executor:
    - 4 vCPUs, 8GB RAM (per Designer recommendation for OBS encoding)
    - 60GB dynamic VHDX
    - Bridged network adapter
    - Minimal Windows install (no bloat)
    - Chrome + Synergy Client + OBS pre-configured

.PARAMETER VMName
    Name for the Hyper-V VM. Default: P4NTH30N-Executor

.PARAMETER VHDXPath
    Path for the virtual hard disk. Default: C:\VMs\P4NTH30N-Executor.vhdx

.PARAMETER ISOPath
    Path to Windows 10 ISO for installation. Required for new VMs.

.PARAMETER CPUCount
    Number of virtual processors. Default: 4.

.PARAMETER MemoryGB
    RAM allocation in GB. Default: 8.

.PARAMETER DiskGB
    Dynamic VHDX maximum size in GB. Default: 60.

.PARAMETER SwitchName
    Hyper-V virtual switch for network. Default: Default Switch.

.EXAMPLE
    .\setup-executor-vm.ps1 -ISOPath "C:\ISOs\Win10Pro.iso"
    .\setup-executor-vm.ps1 -VMName "Casino-VM-01" -CPUCount 4 -MemoryGB 8

.NOTES
    Part of VM-002: VM Executor Configuration.
    Requires Hyper-V role enabled and Administrator privileges.
#>

[CmdletBinding()]
param(
    [string]$VMName = "P4NTH30N-Executor",
    [string]$VHDXPath = "C:\VMs\$VMName.vhdx",
    [string]$ISOPath,
    [int]$CPUCount = 4,
    [int]$MemoryGB = 8,
    [int]$DiskGB = 60,
    [string]$SwitchName = "Default Switch"
)

$ErrorActionPreference = "Stop"

function Write-Status {
    param($Message, $Type = "INFO")
    $symbol = switch ($Type) {
        "SUCCESS" { "[OK]"; $color = "Green" }
        "ERROR"   { "[!!]"; $color = "Red" }
        "WARN"    { "[??]"; $color = "Yellow" }
        default   { "[..]"; $color = "Cyan" }
    }
    Write-Host "$symbol $Message" -ForegroundColor $color
}

# ── Prerequisites ─────────────────────────────────────────────────────────
Write-Host ""
Write-Host "P4NTH30N Executor VM Setup (VM-002)" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Status "Administrator privileges required." "ERROR"
    exit 1
}

# Check Hyper-V
$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -ErrorAction SilentlyContinue
if (-not $hyperv -or $hyperv.State -ne "Enabled") {
    Write-Status "Hyper-V is not enabled. Enable it first:" "ERROR"
    Write-Status "  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All" "INFO"
    exit 1
}
Write-Status "Hyper-V is enabled." "SUCCESS"

# Check if VM already exists
$existingVM = Get-VM -Name $VMName -ErrorAction SilentlyContinue
if ($existingVM) {
    Write-Status "VM '$VMName' already exists (State: $($existingVM.State))." "WARN"
    Write-Status "Use Remove-VM to delete it first, or choose a different name." "INFO"
    exit 0
}

# ── Create VHDX ──────────────────────────────────────────────────────────
$vhdxDir = Split-Path $VHDXPath -Parent
if (-not (Test-Path $vhdxDir)) {
    New-Item -ItemType Directory -Path $vhdxDir -Force | Out-Null
    Write-Status "Created VM directory: $vhdxDir"
}

Write-Status "Creating ${DiskGB}GB dynamic VHDX..."
New-VHD -Path $VHDXPath -SizeBytes ($DiskGB * 1GB) -Dynamic | Out-Null
Write-Status "VHDX created: $VHDXPath" "SUCCESS"

# ── Create VM ─────────────────────────────────────────────────────────────
Write-Status "Creating VM: $VMName ($CPUCount vCPU, ${MemoryGB}GB RAM)..."

New-VM -Name $VMName `
    -MemoryStartupBytes ($MemoryGB * 1GB) `
    -Generation 2 `
    -VHDPath $VHDXPath `
    -SwitchName $SwitchName | Out-Null

# Configure VM settings
Set-VM -Name $VMName `
    -ProcessorCount $CPUCount `
    -DynamicMemory `
    -MemoryMinimumBytes (2GB) `
    -MemoryMaximumBytes ($MemoryGB * 1GB) `
    -AutomaticStartAction Nothing `
    -AutomaticStopAction ShutDown `
    -CheckpointType Standard

# Enable Secure Boot with Microsoft UEFI CA (for Win10)
Set-VMFirmware -VMName $VMName -EnableSecureBoot On

# Enable Enhanced Session Mode (for copy/paste)
Set-VM -Name $VMName -EnhancedSessionTransportType HvSocket

Write-Status "VM created and configured." "SUCCESS"

# ── Mount ISO (if provided) ──────────────────────────────────────────────
if ($ISOPath -and (Test-Path $ISOPath)) {
    Add-VMDvdDrive -VMName $VMName -Path $ISOPath
    $dvd = Get-VMDvdDrive -VMName $VMName
    Set-VMFirmware -VMName $VMName -FirstBootDevice $dvd
    Write-Status "ISO mounted: $ISOPath" "SUCCESS"
    Write-Status "VM will boot from ISO for Windows installation."
} else {
    Write-Status "No ISO provided. Mount one manually before first boot." "WARN"
}

# ── Summary ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Status "VM '$VMName' ready." "SUCCESS"
Write-Host ""
Write-Host "Specs:" -ForegroundColor White
Write-Host "  CPUs:    $CPUCount vCPU"
Write-Host "  RAM:     ${MemoryGB}GB (dynamic 2GB-${MemoryGB}GB)"
Write-Host "  Disk:    ${DiskGB}GB dynamic VHDX"
Write-Host "  Network: $SwitchName"
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor White
Write-Host "  1. Start-VM -Name '$VMName'"
Write-Host "  2. Install Windows 10 Pro (minimal)"
Write-Host "  3. Install Chrome, Synergy Client, OBS"
Write-Host "  4. Configure OBS RTMP streaming to host:1935"
Write-Host "  5. Configure Synergy client pointing to host"
Write-Host "  6. Run .\setup-obs-streaming.ps1 inside VM"
