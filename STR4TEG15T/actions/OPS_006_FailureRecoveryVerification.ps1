# OPS_006: Failure Recovery Verification Script
# Tests each failure mode documented in OPS_016 disaster recovery runbook.
# Run from host machine.

param(
	[string]$CdpHost = "192.168.56.1",
	[int]$CdpPort = 9222,
	[string]$MongoHost = "localhost",
	[int]$MongoPort = 27017,
	[string]$VmName = "H4NDv2-Production"
)

$script:pass = 0; $script:fail = 0; $script:skip = 0

function Test-Check {
	param([string]$Name, [bool]$Result, [string]$Detail = "")
	if ($Result) { $script:pass++; Write-Host "  PASS  $Name" -ForegroundColor Green }
	else { $script:fail++; Write-Host "  FAIL  $Name" -ForegroundColor Red }
	if ($Detail) { Write-Host "         $Detail" -ForegroundColor Gray }
}

function Skip-Check {
	param([string]$Name, [string]$Reason = "")
	$script:skip++
	Write-Host "  SKIP  $Name" -ForegroundColor Yellow
	if ($Reason) { Write-Host "         $Reason" -ForegroundColor Gray }
}

Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "OPS_006: Failure Recovery Verification" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""

# --- 1. MongoDB Recovery ---
Write-Host "1. MongoDB Recovery" -ForegroundColor Yellow
Write-Host ("-" * 40) -ForegroundColor DarkGray

# 1a. MongoDB is running
$mongoSvc = Get-Service MongoDB -ErrorAction SilentlyContinue
if ($null -ne $mongoSvc) {
	Test-Check "MongoDB service exists" $true $mongoSvc.Status
	Test-Check "MongoDB service running" ($mongoSvc.Status -eq "Running")

	# 1b. TCP reachable
	try {
		$tc = New-Object System.Net.Sockets.TcpClient($MongoHost, $MongoPort)
		$tc.Close()
		Test-Check "MongoDB TCP reachable" $true "${MongoHost}:${MongoPort}"
	} catch {
		Test-Check "MongoDB TCP reachable" $false $_.Exception.Message
	}
} else {
	Skip-Check "MongoDB service" "Service not found (may be running as process)"
	try {
		$tc = New-Object System.Net.Sockets.TcpClient($MongoHost, $MongoPort)
		$tc.Close()
		Test-Check "MongoDB TCP reachable" $true "${MongoHost}:${MongoPort}"
	} catch {
		Test-Check "MongoDB TCP reachable" $false $_.Exception.Message
	}
}

# 1c. Backup script exists
$backupScript = "C:\P4NTH30N\scripts\backup\mongodb-backup.ps1"
Test-Check "MongoDB backup script exists" (Test-Path $backupScript)

# 1d. Restore script exists
$restoreScript = "C:\P4NTH30N\scripts\restore\mongodb-restore.ps1"
Test-Check "MongoDB restore script exists" (Test-Path $restoreScript)

Write-Host ""

# --- 2. Chrome CDP Recovery ---
Write-Host "2. Chrome CDP Recovery" -ForegroundColor Yellow
Write-Host ("-" * 40) -ForegroundColor DarkGray

try {
	$v = Invoke-RestMethod -Uri "http://${CdpHost}:${CdpPort}/json/version" -TimeoutSec 3
	Test-Check "Chrome CDP reachable" $true $v.Browser
} catch {
	Test-Check "Chrome CDP reachable" $false "CDP offline — verify Chrome is running with --remote-debugging-port=9222"
}

# Port proxy check
$portProxy = netsh interface portproxy show v4tov4 2>&1
$hasProxy = $portProxy -match "192.168.56.1.*9222"
Test-Check "CDP port proxy configured" $hasProxy

Write-Host ""

# --- 3. VM Recovery ---
Write-Host "3. VM Recovery" -ForegroundColor Yellow
Write-Host ("-" * 40) -ForegroundColor DarkGray

$vm = Get-VM -Name $VmName -ErrorAction SilentlyContinue
if ($null -ne $vm) {
	Test-Check "VM exists" $true "$VmName ($($vm.State))"
	Test-Check "VM is running" ($vm.State -eq "Running")

	# Network adapter
	$adapter = Get-VMNetworkAdapter -VMName $VmName -ErrorAction SilentlyContinue
	Test-Check "VM has network adapter" ($null -ne $adapter) ($adapter.SwitchName)

	# Hyper-V switch
	$switch = Get-VMSwitch -Name "H4ND-Switch" -ErrorAction SilentlyContinue
	Test-Check "H4ND-Switch exists" ($null -ne $switch)
} else {
	Skip-Check "VM checks" "VM '$VmName' not found on this host"
}

Write-Host ""

# --- 4. Documentation Completeness ---
Write-Host "4. Documentation" -ForegroundColor Yellow
Write-Host ("-" * 40) -ForegroundColor DarkGray

$docs = @(
	"C:\P4NTH30N\docs\vm-deployment\architecture.md",
	"C:\P4NTH30N\docs\vm-deployment\network-setup.md",
	"C:\P4NTH30N\docs\vm-deployment\chrome-cdp-config.md",
	"C:\P4NTH30N\docs\vm-deployment\troubleshooting.md",
	"C:\P4NTH30N\docs\disaster-recovery\runbook.md",
	"C:\P4NTH30N\docs\jackpot_selectors.md"
)
foreach ($doc in $docs) {
	$name = Split-Path $doc -Leaf
	Test-Check "Doc: $name" (Test-Path $doc)
}

Write-Host ""

# --- 5. Code Health ---
Write-Host "5. Code Health" -ForegroundColor Yellow
Write-Host ("-" * 40) -ForegroundColor DarkGray

# No more extension failure
$h4ndContent = Get-Content "C:\P4NTH30N\H4ND\H4ND.cs" -Raw
Test-Check "No 'Extension failure' in H4ND.cs" (-not ($h4ndContent -match '"Extension failure\."'))
Test-Check "VerifyGamePageLoadedAsync in H4ND.cs" ($h4ndContent -match "VerifyGamePageLoadedAsync")

# Config-driven selectors
$actionsContent = Get-Content "C:\P4NTH30N\H4ND\Infrastructure\CdpGameActions.cs" -Raw
Test-Check "GameSelectors config support" ($actionsContent -match "GameSelectors")

# Session manager
Test-Check "ChromeSessionManager exists" (Test-Path "C:\P4NTH30N\H4ND\Infrastructure\ChromeSessionManager.cs")
Test-Check "VmHealthMonitor exists" (Test-Path "C:\P4NTH30N\H4ND\Infrastructure\VmHealthMonitor.cs")

# No temp scripts
$tempCount = (Get-ChildItem "C:\P4NTH30N\temp_*" -File -ErrorAction SilentlyContinue | Measure-Object).Count
Test-Check "No temp scripts remaining" ($tempCount -eq 0) "$tempCount found"

Write-Host ""

# --- Summary ---
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "RECOVERY VERIFICATION SUMMARY" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "  Passed : $($script:pass)" -ForegroundColor Green
Write-Host "  Failed : $($script:fail)" -ForegroundColor $(if ($script:fail -gt 0) { "Red" } else { "Green" })
Write-Host "  Skipped: $($script:skip)" -ForegroundColor Yellow
