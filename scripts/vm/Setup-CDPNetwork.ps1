<#
.SYNOPSIS
	Configures Hyper-V internal vSwitch, static host IP, NAT, and firewall for CDP.

.DESCRIPTION
	Creates the network infrastructure for host<->VM communication:
	  1. Internal vSwitch (not Default Switch — deterministic IP control)
	  2. Static IP on the host-side vEthernet adapter
	  3. NAT rule so VM can reach the internet via host
	  4. Firewall rule allowing CDP traffic from VM subnet only

	Idempotent: safe to re-run. Skips resources that already exist.
	All values read from config/vm-network.json (or overridable via params).

.PARAMETER ConfigPath
	Path to vm-network.json. Default: <repo>\config\vm-network.json

.PARAMETER SwitchName
	Override vSwitch name (default from config).

.PARAMETER HostGatewayIP
	Override host gateway IP (default from config).

.PARAMETER PrefixLength
	Override subnet prefix length (default from config).

.PARAMETER SubnetPrefix
	Override subnet CIDR (default from config).

.PARAMETER CdpPort
	Override CDP port (default from config).

.EXAMPLE
	.\Setup-CDPNetwork.ps1
	.\Setup-CDPNetwork.ps1 -SwitchName "MySwitch" -HostGatewayIP "10.0.0.1" -PrefixLength 24

.NOTES
	Part of INFRA-VM-001. Run on HOST machine as Administrator.
	Requires: Hyper-V role enabled.
#>

[CmdletBinding()]
param(
	[string]$ConfigPath,
	[string]$SwitchName,
	[string]$HostGatewayIP,
	[int]$PrefixLength = 0,
	[string]$SubnetPrefix,
	[int]$CdpPort = 0
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
Write-Host "P4NTH30N CDP Network Setup (INFRA-VM-001)" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
	Write-Status "Administrator privileges required." "ERROR"
	exit 1
}

$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -ErrorAction SilentlyContinue
if (-not $hyperv -or $hyperv.State -ne "Enabled") {
	Write-Status "Hyper-V is not enabled. Enable it first." "ERROR"
	exit 1
}
Write-Status "Hyper-V is enabled." "SUCCESS"

# ── Load config ──────────────────────────────────────────────────────────
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = (Resolve-Path "$scriptDir\..\..").Path

if (-not $ConfigPath) {
	$ConfigPath = Join-Path $repoRoot "config\vm-network.json"
}

$natName = "H4ND-NAT"

if (Test-Path $ConfigPath) {
	$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
	if (-not $SwitchName)    { $SwitchName = $config.Switch.Name }
	if (-not $HostGatewayIP) { $HostGatewayIP = $config.Host.GatewayIP }
	if ($PrefixLength -eq 0) { $PrefixLength = $config.Host.PrefixLength }
	if (-not $SubnetPrefix)  { $SubnetPrefix = $config.Subnet }
	if ($CdpPort -eq 0)     { $CdpPort = $config.CDP.Port }
	if ($config.NAT.Name)    { $natName = $config.NAT.Name }
	Write-Status "Loaded config from $ConfigPath"
} else {
	Write-Status "Config not found at $ConfigPath, using parameter defaults." "WARN"
}

# Apply final defaults for anything still unset
if (-not $SwitchName)    { $SwitchName = "H4ND-Switch" }
if (-not $HostGatewayIP) { $HostGatewayIP = "192.168.56.1" }
if ($PrefixLength -eq 0) { $PrefixLength = 24 }
if (-not $SubnetPrefix)  { $SubnetPrefix = "192.168.56.0/24" }
if ($CdpPort -eq 0)      { $CdpPort = 9222 }

$firewallRuleName = "P4NTH30N-CDP-VM"

Write-Host "  Switch:    $SwitchName"
Write-Host "  Host IP:   $HostGatewayIP/$PrefixLength"
Write-Host "  Subnet:    $SubnetPrefix"
Write-Host "  CDP Port:  $CdpPort"
Write-Host "  NAT:       $natName"
Write-Host "  Firewall:  $firewallRuleName"
Write-Host ""

# ── Step 1: Internal vSwitch ────────────────────────────────────────────
$existingSwitch = Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue
if ($existingSwitch) {
	Write-Status "vSwitch '$SwitchName' already exists (Type: $($existingSwitch.SwitchType))." "SUCCESS"
} else {
	Write-Status "Creating internal vSwitch '$SwitchName'..."
	New-VMSwitch -Name $SwitchName -SwitchType Internal | Out-Null
	Write-Status "vSwitch '$SwitchName' created." "SUCCESS"
}

# ── Step 2: Static IP on host adapter ───────────────────────────────────
$adapterAlias = "vEthernet ($SwitchName)"

# Wait briefly for the adapter to appear (new switches can be slow)
$retries = 0
while ($retries -lt 5) {
	$adapter = Get-NetAdapter -Name $adapterAlias -ErrorAction SilentlyContinue
	if ($adapter) { break }
	Start-Sleep -Seconds 1
	$retries++
}

if (-not $adapter) {
	Write-Status "Network adapter '$adapterAlias' not found. vSwitch creation may have failed." "ERROR"
	exit 1
}

$existingIP = Get-NetIPAddress -InterfaceAlias $adapterAlias -AddressFamily IPv4 -ErrorAction SilentlyContinue |
	Where-Object { $_.IPAddress -eq $HostGatewayIP }

if ($existingIP) {
	Write-Status "Host IP $HostGatewayIP already assigned to '$adapterAlias'." "SUCCESS"
} else {
	# Remove any APIPA or stale IPs first
	Get-NetIPAddress -InterfaceAlias $adapterAlias -AddressFamily IPv4 -ErrorAction SilentlyContinue |
		Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue

	Write-Status "Assigning $HostGatewayIP/$PrefixLength to '$adapterAlias'..."
	New-NetIPAddress -InterfaceAlias $adapterAlias -IPAddress $HostGatewayIP -PrefixLength $PrefixLength | Out-Null
	Write-Status "Host IP assigned." "SUCCESS"
}

# ── Step 3: NAT for VM internet access ──────────────────────────────────
$existingNat = Get-NetNat -Name $natName -ErrorAction SilentlyContinue
if ($existingNat) {
	Write-Status "NAT '$natName' already exists." "SUCCESS"
} else {
	Write-Status "Creating NAT '$natName' for subnet $SubnetPrefix..."
	New-NetNat -Name $natName -InternalIPInterfaceAddressPrefix $SubnetPrefix | Out-Null
	Write-Status "NAT created." "SUCCESS"
}

# ── Step 4: Firewall rule for CDP ────────────────────────────────────────
$existingRule = Get-NetFirewallRule -DisplayName $firewallRuleName -ErrorAction SilentlyContinue
if ($existingRule) {
	Write-Status "Firewall rule '$firewallRuleName' already exists." "SUCCESS"
	# Update port if changed
	$portFilter = $existingRule | Get-NetFirewallPortFilter
	if ($portFilter.LocalPort -ne $CdpPort.ToString()) {
		Write-Status "Updating firewall port from $($portFilter.LocalPort) to $CdpPort..." "WARN"
		Set-NetFirewallRule -DisplayName $firewallRuleName -LocalPort $CdpPort
	}
} else {
	Write-Status "Creating firewall rule '$firewallRuleName' (TCP $CdpPort from $SubnetPrefix)..."
	New-NetFirewallRule `
		-DisplayName $firewallRuleName `
		-Description "Allow Chrome CDP from H4NDv2 VM subnet (INFRA-VM-001)" `
		-Direction Inbound `
		-LocalPort $CdpPort `
		-Protocol TCP `
		-RemoteAddress $SubnetPrefix `
		-Action Allow `
		-Profile Any | Out-Null
	Write-Status "Firewall rule created." "SUCCESS"
}

# ── Summary ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Status "CDP network setup complete." "SUCCESS"
Write-Host ""
Write-Host "Host side ready. Next steps:" -ForegroundColor White
Write-Host "  1. Connect VM to vSwitch '$SwitchName'"
Write-Host "     Connect-VMNetworkAdapter -VMName 'H4NDv2-Production' -SwitchName '$SwitchName'"
Write-Host ""
Write-Host "  2. Inside VM, set static IP:" -ForegroundColor White
$vmStaticIP = if ($config.VM -and $config.VM.StaticIP) { $config.VM.StaticIP } else { "192.168.56.10" }
$vmDnsServer = if ($config.VM -and $config.VM.DnsServer) { $config.VM.DnsServer } else { "8.8.8.8" }
Write-Host "     New-NetIPAddress -InterfaceAlias 'Ethernet' -IPAddress '$vmStaticIP' -PrefixLength $PrefixLength -DefaultGateway '$HostGatewayIP'"
Write-Host "     Set-DnsClientServerAddress -InterfaceAlias 'Ethernet' -ServerAddresses '$vmDnsServer'"
Write-Host ""
Write-Host "  3. Launch Chrome CDP on host:" -ForegroundColor White
Write-Host "     .\Start-Chrome-CDP.ps1"
Write-Host ""
Write-Host "  4. Validate from VM:" -ForegroundColor White
Write-Host "     .\Validate-CDPConnectivity.ps1 -HostIP '$HostGatewayIP' -Port $CdpPort"
Write-Host ""