<#
.SYNOPSIS
	Provisions a Hyper-V VM for H4NDv2 automation, wired to H4ND-Switch.

.DESCRIPTION
	Creates a lightweight Windows VM optimized for H4NDv2 execution:
	  - 2 vCPUs, 4GB RAM (H4ND is I/O-bound, not CPU-bound)
	  - 40GB dynamic VHDX
	  - Connected to H4ND-Switch (internal, from Setup-CDPNetwork.ps1)
	  - Gen2 VM with Secure Boot

	Assumes Setup-CDPNetwork.ps1 has already run (H4ND-Switch exists).
	Reads network config from config/vm-network.json.

	After VM creation, you must:
	  1. Mount a Windows ISO and install Windows
	  2. Inside the VM, set static IP (printed in summary)
	  3. Install .NET 10 runtime
	  4. Copy H4ND build artifacts to the VM
	  5. Run H4ND

.PARAMETER VMName
	Name for the VM. Default: H4NDv2-Production

.PARAMETER VHDXPath
	Path for the virtual disk. Default: C:\VMs\H4NDv2-Production.vhdx

.PARAMETER ISOPath
	Path to Windows ISO. If provided, VM boots from it.

.PARAMETER CPUCount
	Virtual processors. Default: 2.

.PARAMETER MemoryGB
	RAM in GB. Default: 4.

.PARAMETER DiskGB
	Dynamic VHDX max size in GB. Default: 40.

.PARAMETER ConfigPath
	Path to vm-network.json. Default: <repo>\config\vm-network.json

.EXAMPLE
	.\Provision-H4NDv2.ps1 -ISOPath "C:\ISOs\Win10Pro.iso"
	.\Provision-H4NDv2.ps1 -VMName "H4ND-Test" -CPUCount 4 -MemoryGB 8

.NOTES
	Part of INFRA-VM-001. Run on HOST as Administrator.
	Prerequisite: Setup-CDPNetwork.ps1 must have run (creates H4ND-Switch).
#>

[CmdletBinding()]
param(
	[string]$VMName = "H4NDv2-Production",
	[string]$VHDXPath,
	[string]$ISOPath,
	[int]$CPUCount = 2,
	[int]$MemoryGB = 4,
	[int]$DiskGB = 40,
	[string]$ConfigPath
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

# ── Prerequisites ────────────────────────────────────────────────────────
Write-Host ""
Write-Host "P4NTH30N H4NDv2 VM Provisioning (INFRA-VM-001)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
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
	Write-Status "Hyper-V is not enabled. Run:" "ERROR"
	Write-Status "  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All" "INFO"
	Write-Status "  Then reboot and re-run this script." "INFO"
	exit 1
}
Write-Status "Hyper-V is enabled." "SUCCESS"

# ── Load config ──────────────────────────────────────────────────────────
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = (Resolve-Path "$scriptDir\..\..").Path

if (-not $ConfigPath) {
	$ConfigPath = Join-Path $repoRoot "config\vm-network.json"
}

$switchName = "H4ND-Switch"
$vmStaticIP = "192.168.56.10"
$prefixLength = 24
$defaultGateway = "192.168.56.1"
$dnsServer = "8.8.8.8"

if (Test-Path $ConfigPath) {
	$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
	if ($config.Switch.Name)       { $switchName = $config.Switch.Name }
	if ($config.VM.StaticIP)       { $vmStaticIP = $config.VM.StaticIP }
	if ($config.VM.PrefixLength)   { $prefixLength = $config.VM.PrefixLength }
	if ($config.VM.DefaultGateway) { $defaultGateway = $config.VM.DefaultGateway }
	if ($config.VM.DnsServer)      { $dnsServer = $config.VM.DnsServer }
	Write-Status "Loaded config from $ConfigPath"
} else {
	Write-Status "Config not found at $ConfigPath, using defaults." "WARN"
}

# ── Check H4ND-Switch exists ────────────────────────────────────────────
$existingSwitch = Get-VMSwitch -Name $switchName -ErrorAction SilentlyContinue
if (-not $existingSwitch) {
	Write-Status "vSwitch '$switchName' not found. Run Setup-CDPNetwork.ps1 first." "ERROR"
	exit 1
}
Write-Status "vSwitch '$switchName' exists (Type: $($existingSwitch.SwitchType))." "SUCCESS"

# ── Check if VM already exists ──────────────────────────────────────────
$existingVM = Get-VM -Name $VMName -ErrorAction SilentlyContinue
if ($existingVM) {
	Write-Status "VM '$VMName' already exists (State: $($existingVM.State))." "WARN"
	Write-Status "To recreate: Stop-VM '$VMName' -TurnOff; Remove-VM '$VMName' -Force" "INFO"
	exit 0
}

# ── Resolve VHDX path ───────────────────────────────────────────────────
if (-not $VHDXPath) {
	$VHDXPath = "C:\VMs\$VMName.vhdx"
}

$vhdxDir = Split-Path $VHDXPath -Parent
if (-not (Test-Path $vhdxDir)) {
	New-Item -ItemType Directory -Path $vhdxDir -Force | Out-Null
	Write-Status "Created VM directory: $vhdxDir"
}

# ── Create VHDX ─────────────────────────────────────────────────────────
if (Test-Path $VHDXPath) {
	Write-Status "VHDX already exists at $VHDXPath - reusing." "WARN"
} else {
	Write-Status "Creating ${DiskGB}GB dynamic VHDX..."
	New-VHD -Path $VHDXPath -SizeBytes ($DiskGB * 1GB) -Dynamic | Out-Null
	Write-Status "VHDX created: $VHDXPath" "SUCCESS"
}

# ── Create VM ────────────────────────────────────────────────────────────
Write-Status "Creating VM: $VMName - ${CPUCount} vCPU, ${MemoryGB}GB RAM, switch: $switchName..."

New-VM -Name $VMName `
	-MemoryStartupBytes ($MemoryGB * 1GB) `
	-Generation 2 `
	-VHDPath $VHDXPath `
	-SwitchName $switchName | Out-Null

Set-VM -Name $VMName `
	-ProcessorCount $CPUCount `
	-DynamicMemory `
	-MemoryMinimumBytes (1GB) `
	-MemoryMaximumBytes ($MemoryGB * 1GB) `
	-AutomaticStartAction Nothing `
	-AutomaticStopAction ShutDown `
	-CheckpointType Standard

# Enable Secure Boot
Set-VMFirmware -VMName $VMName -EnableSecureBoot On

# Enable Enhanced Session Mode
Set-VM -Name $VMName -EnhancedSessionTransportType HvSocket

Write-Status "VM created and configured." "SUCCESS"

# ── Mount ISO ────────────────────────────────────────────────────────────
if ($ISOPath -and (Test-Path $ISOPath)) {
	Add-VMDvdDrive -VMName $VMName -Path $ISOPath
	$dvd = Get-VMDvdDrive -VMName $VMName
	Set-VMFirmware -VMName $VMName -FirstBootDevice $dvd
	Write-Status "ISO mounted: $ISOPath (boot priority set)" "SUCCESS"
} elseif ($ISOPath) {
	Write-Status "ISO not found at '$ISOPath'. Mount manually before first boot." "WARN"
} else {
	Write-Status "No ISO provided. Mount one before first boot." "WARN"
}

# ── Summary ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Status "VM '$VMName' provisioned for H4NDv2." "SUCCESS"
Write-Host ""
Write-Host "Specs:" -ForegroundColor White
Write-Host "  CPUs:    $CPUCount vCPU"
Write-Host "  RAM:     ${MemoryGB}GB (dynamic 1GB-${MemoryGB}GB)"
Write-Host "  Disk:    ${DiskGB}GB dynamic VHDX"
Write-Host "  Network: $switchName (Internal)"
Write-Host "  VHDX:    $VHDXPath"
Write-Host ""
Write-Host "Post-Install Steps (inside the VM):" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Start and install Windows:" -ForegroundColor White
Write-Host "     Start-VM -Name '$VMName'"
Write-Host ""
Write-Host "  2. Set static IP (run in VM as admin):" -ForegroundColor White
Write-Host "     New-NetIPAddress -InterfaceAlias 'Ethernet' -IPAddress '$vmStaticIP' -PrefixLength $prefixLength -DefaultGateway '$defaultGateway'"
Write-Host "     Set-DnsClientServerAddress -InterfaceAlias 'Ethernet' -ServerAddresses '$dnsServer'"
Write-Host ""
Write-Host "  3. Install .NET 10 runtime:" -ForegroundColor White
Write-Host "     winget install Microsoft.DotNet.Runtime.10"
Write-Host "     # Or download from https://dotnet.microsoft.com/download/dotnet/10.0"
Write-Host ""
Write-Host "  4. Copy H4ND build to VM:" -ForegroundColor White
Write-Host "     # From host (after building):"
Write-Host "     dotnet publish H4ND/H4ND.csproj -c Release -o C:\Publish\H4ND"
Write-Host "     # Copy C:\Publish\H4ND to VM via Enhanced Session (clipboard/drag)"
Write-Host ""
Write-Host "  5. Launch Chrome CDP on host:" -ForegroundColor White
Write-Host "     .\Start-Chrome-CDP.ps1"
Write-Host ""
Write-Host "  6. Validate CDP from VM:" -ForegroundColor White
Write-Host "     Invoke-WebRequest -Uri 'http://${defaultGateway}:9222/json/version'"
Write-Host ""
Write-Host "  7. Run H4ND in VM:" -ForegroundColor White
Write-Host "     cd C:\H4ND"
Write-Host "     dotnet H4ND.dll"
Write-Host ""