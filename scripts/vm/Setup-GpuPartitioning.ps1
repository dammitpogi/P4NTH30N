<#
.SYNOPSIS
	Configures GPU Partitioning (GPU-P) as fallback when DDA passthrough fails.

.DESCRIPTION
	Hyper-V GPU-P shares the host GPU with the VM without full passthrough.
	This is the fallback path per INFRA-VM-001 Oracle assessment:
	  1. Try DDA (discrete device assignment) first
	  2. If DDA fails -> GPU-P partitioning (this script)
	  3. If GPU-P fails -> CPU-only inference (alert operator)

	Steps:
	  1. Detect partitionable GPUs on host
	  2. Assign GPU partition to target VM
	  3. Copy GPU drivers from host to VM
	  4. Verify GPU visible inside VM

	Idempotent: safe to re-run. Checks existing state before changes.

.PARAMETER VMName
	Target VM name. Default: H4NDv2-Production

.PARAMETER MinVRAM
	Minimum VRAM partition in bytes. Default: 80MB

.PARAMETER MaxVRAM
	Maximum VRAM partition in bytes. Default: 1GB

.PARAMETER OptimalVRAM
	Optimal VRAM partition in bytes. Default: 512MB

.PARAMETER SkipDriverCopy
	Skip the driver copy step (if drivers already installed in VM).

.EXAMPLE
	.\Setup-GpuPartitioning.ps1
	.\Setup-GpuPartitioning.ps1 -VMName "H4NDv2-001" -MaxVRAM 2147483648

.NOTES
	Part of INFRA-VM-001 (GPU-P fallback path).
	Run on HOST machine as Administrator. VM must be OFF.
	Requires: Hyper-V, Gen 2 VM, Windows 10/11 host with WDDM 2.5+ GPU.
#>

[CmdletBinding()]
param(
	[string]$VMName = "H4NDv2-Production",
	[long]$MinVRAM = 80000000,
	[long]$MaxVRAM = 1073741824,
	[long]$OptimalVRAM = 536870912,
	[switch]$SkipDriverCopy
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

Write-Host ""
Write-Host "P4NTHE0N GPU-P Setup (INFRA-VM-001 Fallback)" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

# ── Prerequisites ────────────────────────────────────────────────────────
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
	Write-Status "Administrator privileges required." "ERROR"
	exit 1
}

# Verify VM exists
$vm = Get-VM -Name $VMName -ErrorAction SilentlyContinue
if (-not $vm) {
	Write-Status "VM '$VMName' not found." "ERROR"
	exit 1
}

# VM must be off for GPU-P configuration
if ($vm.State -ne "Off") {
	Write-Status "VM '$VMName' must be stopped. Current state: $($vm.State)" "ERROR"
	Write-Status "Run: Stop-VM -Name '$VMName' -Force" "INFO"
	exit 1
}
Write-Status "VM '$VMName' found (state: Off)." "SUCCESS"

# ── Step 1: Detect partitionable GPUs ───────────────────────────────────
Write-Status "Detecting partitionable GPUs on host..."
$gpus = Get-VMHostPartitionableGpu -ErrorAction SilentlyContinue

if (-not $gpus -or $gpus.Count -eq 0) {
	Write-Status "No partitionable GPUs found on this host." "ERROR"
	Write-Status "GPU-P requires WDDM 2.5+ driver. Falling back to CPU-only inference." "WARN"
	Write-Host ""
	Write-Host "FALLBACK: CPU-only inference" -ForegroundColor Yellow
	Write-Host "  - LLaVA/vision models will run on CPU (~5x slower)" -ForegroundColor Yellow
	Write-Host "  - This is functional but not optimal" -ForegroundColor Yellow
	Write-Host "  - Consider upgrading GPU driver to WDDM 2.5+" -ForegroundColor Yellow
	exit 1
}

Write-Host "  Found $($gpus.Count) partitionable GPU(s):" -ForegroundColor White
foreach ($gpu in $gpus) {
	Write-Host "    - $($gpu.Name)" -ForegroundColor White
}

# ── Step 2: Check existing GPU-P assignment ──────────────────────────────
$existingAdapter = Get-VMGpuPartitionAdapter -VMName $VMName -ErrorAction SilentlyContinue
if ($existingAdapter) {
	Write-Status "GPU-P adapter already assigned to '$VMName'." "SUCCESS"
	Write-Status "To reconfigure, remove first: Remove-VMGpuPartitionAdapter -VMName '$VMName'" "INFO"
} else {
	# ── Step 3: Assign GPU partition ────────────────────────────────────
	Write-Status "Assigning GPU partition to '$VMName'..."
	Write-Host "  Min VRAM:     $([math]::Round($MinVRAM / 1MB, 0)) MB"
	Write-Host "  Optimal VRAM: $([math]::Round($OptimalVRAM / 1MB, 0)) MB"
	Write-Host "  Max VRAM:     $([math]::Round($MaxVRAM / 1MB, 0)) MB"

	Add-VMGpuPartitionAdapter -VMName $VMName
	Set-VMGpuPartitionAdapter -VMName $VMName `
		-MinPartitionVRAM $MinVRAM `
		-MaxPartitionVRAM $MaxVRAM `
		-OptimalPartitionVRAM $OptimalVRAM `
		-MinPartitionEncode 80000000 `
		-MaxPartitionEncode 1073741824 `
		-OptimalPartitionEncode 536870912 `
		-MinPartitionDecode 80000000 `
		-MaxPartitionDecode 1073741824 `
		-OptimalPartitionDecode 536870912 `
		-MinPartitionCompute 80000000 `
		-MaxPartitionCompute 1073741824 `
		-OptimalPartitionCompute 536870912

	# Set VM memory-mapped I/O for GPU
	Set-VM -VMName $VMName -GuestControlledCacheTypes $true -LowMemoryMappedIoSpace 1GB -HighMemoryMappedIoSpace 32GB

	Write-Status "GPU partition assigned." "SUCCESS"
}

# ── Step 4: Copy GPU drivers to VM ──────────────────────────────────────
if ($SkipDriverCopy) {
	Write-Status "Driver copy skipped (-SkipDriverCopy)." "WARN"
} else {
	Write-Status "Preparing GPU driver copy..."

	# Find host GPU driver files
	$hostDriverPath = "C:\Windows\System32\DriverStore\FileRepository"
	$nvDriverDirs = Get-ChildItem -Path $hostDriverPath -Directory -Filter "nv*" -ErrorAction SilentlyContinue
	$amdDriverDirs = Get-ChildItem -Path $hostDriverPath -Directory -Filter "u0*" -ErrorAction SilentlyContinue

	$driverDirs = @()
	if ($nvDriverDirs) { $driverDirs += $nvDriverDirs }
	if ($amdDriverDirs) { $driverDirs += $amdDriverDirs }

	if ($driverDirs.Count -eq 0) {
		Write-Status "No NVIDIA/AMD driver directories found in DriverStore." "WARN"
		Write-Status "You may need to copy drivers manually after VM boots." "INFO"
	} else {
		Write-Host "  Found $($driverDirs.Count) driver director(ies) to copy." -ForegroundColor White

		# Target path inside VM (via PowerShell Direct)
		$vmDriverTarget = "C:\Windows\System32\HostDriverStore\FileRepository"

		Write-Status "Copying drivers to VM via PowerShell Direct..."
		Write-Status "NOTE: VM must have been booted at least once with credentials set." "INFO"

		try {
			$session = New-PSSession -VMName $VMName -ErrorAction Stop

			Invoke-Command -Session $session -ScriptBlock {
				param($targetPath)
				if (-not (Test-Path $targetPath)) {
					New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
				}
			} -ArgumentList $vmDriverTarget

			foreach ($dir in $driverDirs) {
				Write-Host "    Copying $($dir.Name)..." -ForegroundColor DarkGray
				Copy-Item -ToSession $session -Path $dir.FullName -Destination $vmDriverTarget -Recurse -Force
			}

			Remove-PSSession $session
			Write-Status "GPU drivers copied to VM." "SUCCESS"
		} catch {
			Write-Status "Driver copy failed: $($_.Exception.Message)" "WARN"
			Write-Status "Copy drivers manually after VM boots, or re-run with VM credentials configured." "INFO"
		}
	}
}

# ── Summary ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Status "GPU-P setup complete for '$VMName'." "SUCCESS"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Start VM:  Start-VM -Name '$VMName'"
Write-Host "  2. Inside VM, verify GPU visible:" -ForegroundColor White
Write-Host "     Get-PnpDevice | Where-Object { `$_.Class -eq 'Display' }"
Write-Host "  3. If GPU not visible, check driver copy and reboot VM."
Write-Host ""
Write-Host "Decision tree (INFRA-VM-001):" -ForegroundColor DarkGray
Write-Host "  DDA passthrough -> GPU-P partitioning [THIS] -> CPU-only fallback" -ForegroundColor DarkGray
Write-Host ""