<#
.SYNOPSIS
	Smoke test: validates Chrome CDP is reachable from the current machine.

.DESCRIPTION
	Performs a quick connectivity check against the Chrome DevTools Protocol
	endpoint on the host. Intended to run FROM the VM to verify the full
	network path (vSwitch + firewall + Chrome) is working before H4NDv2 starts.

	Can also run on the host itself as a local sanity check.

	Checks:
	  1. TCP connectivity to host:port
	  2. HTTP GET /json/version returns 200
	  3. Response contains valid CDP version info
	  4. HTTP GET /json/list returns debuggable pages

.PARAMETER HostIP
	IP of the host running Chrome. Default read from config/vm-network.json.

.PARAMETER Port
	CDP port. Default read from config/vm-network.json.

.PARAMETER ConfigPath
	Path to vm-network.json. Default: <repo>\config\vm-network.json

.PARAMETER TimeoutSec
	HTTP request timeout in seconds. Default: 5

.EXAMPLE
	.\Validate-CDPConnectivity.ps1 -HostIP 192.168.56.1 -Port 9222
	.\Validate-CDPConnectivity.ps1

.NOTES
	Part of INFRA-VM-001 pre-validation gate.
	Exit code 0 = all checks passed. Exit code 1 = one or more checks failed.
#>

[CmdletBinding()]
param(
	[string]$HostIP,
	[int]$Port = 0,
	[string]$ConfigPath,
	[int]$TimeoutSec = 5
)

$ErrorActionPreference = "Continue"
$script:failures = 0

function Write-Status {
	param($Message, $Type = "INFO")
	$symbol = switch ($Type) {
		"PASS" { "[OK]"; $color = "Green" }
		"FAIL" { "[!!]"; $color = "Red" }
		"WARN" { "[??]"; $color = "Yellow" }
		default { "[..]"; $color = "Cyan" }
	}
	Write-Host "$symbol $Message" -ForegroundColor $color
}

function Assert-Check {
	param($Name, [scriptblock]$Test)
	try {
		$result = & $Test
		if ($result) {
			Write-Status "$Name" "PASS"
			return $true
		} else {
			Write-Status "$Name" "FAIL"
			$script:failures++
			return $false
		}
	} catch {
		Write-Status "$Name - $($_.Exception.Message)" "FAIL"
		$script:failures++
		return $false
	}
}

# ── Load config ──────────────────────────────────────────────────────────
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = (Resolve-Path "$scriptDir\..\..").Path

if (-not $ConfigPath) {
	$ConfigPath = Join-Path $repoRoot "config\vm-network.json"
}

if (Test-Path $ConfigPath) {
	$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
	if (-not $HostIP) { $HostIP = $config.Host.GatewayIP }
	if ($Port -eq 0)  { $Port = $config.CDP.Port }
}

# Final defaults
if (-not $HostIP) { $HostIP = "192.168.56.1" }
if ($Port -eq 0)  { $Port = 9222 }

Write-Host ""
Write-Host "P4NTH30N CDP Connectivity Smoke Test" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Target: $HostIP`:$Port"
Write-Host "  Timeout: ${TimeoutSec}s"
Write-Host ""

# ── Check 1: TCP connectivity ────────────────────────────────────────────
$tcpOk = Assert-Check "TCP connection to ${HostIP}:${Port}" {
	$tcp = New-Object System.Net.Sockets.TcpClient
	try {
		$asyncResult = $tcp.BeginConnect($HostIP, $Port, $null, $null)
		$waitResult = $asyncResult.AsyncWaitHandle.WaitOne([TimeSpan]::FromSeconds($TimeoutSec))
		if ($waitResult -and $tcp.Connected) {
			$tcp.EndConnect($asyncResult)
			return $true
		}
		return $false
	} finally {
		$tcp.Dispose()
	}
}

if (-not $tcpOk) {
	Write-Host ""
	Write-Status "TCP failed. Remaining checks skipped." "WARN"
	Write-Host ""
	Write-Host "Troubleshooting:" -ForegroundColor Yellow
	Write-Host "  1. Is Chrome running with --remote-debugging-port=$Port on host?"
	Write-Host "     Run: .\Start-Chrome-CDP.ps1"
	Write-Host "  2. Is the firewall rule created?"
	Write-Host "     Run: .\Setup-CDPNetwork.ps1"
	Write-Host "  3. Can you ping the host? Test-Connection $HostIP"
	Write-Host "  4. Is the VM connected to the correct vSwitch?"
	Write-Host ""
	exit 1
}

# ── Check 2: /json/version returns 200 ──────────────────────────────────
$versionUrl = "http://${HostIP}:${Port}/json/version"
$versionResponse = $null

Assert-Check "HTTP GET $versionUrl returns 200" {
	$script:versionResponse = Invoke-WebRequest -Uri $versionUrl -TimeoutSec $TimeoutSec -ErrorAction Stop
	return $versionResponse.StatusCode -eq 200
} | Out-Null

# ── Check 3: Version response has Browser field ─────────────────────────
if ($versionResponse) {
	Assert-Check "Response contains CDP version info" {
		$versionJson = $versionResponse.Content | ConvertFrom-Json
		$browser = $versionJson."Browser"
		if ($browser) {
			Write-Host "       Browser: $browser" -ForegroundColor DarkGray
			Write-Host "       Protocol: $($versionJson.'Protocol-Version')" -ForegroundColor DarkGray
			return $true
		}
		return $false
	} | Out-Null
}

# ── Check 4: /json/list returns debuggable pages ────────────────────────
$listUrl = "http://${HostIP}:${Port}/json/list"

Assert-Check "HTTP GET $listUrl returns page list" {
	$listResponse = Invoke-WebRequest -Uri $listUrl -TimeoutSec $TimeoutSec -ErrorAction Stop
	$pages = $listResponse.Content | ConvertFrom-Json
	$pageCount = ($pages | Measure-Object).Count
	Write-Host "       Debuggable pages: $pageCount" -ForegroundColor DarkGray
	return $pageCount -ge 0  # 0 pages is valid (Chrome just opened)
} | Out-Null

# ── Results ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan

if ($script:failures -eq 0) {
	Write-Status "All checks passed. CDP is ready for H4NDv2." "PASS"
	Write-Host ""
	exit 0
} else {
	Write-Status "$($script:failures) check(s) failed. See above for details." "FAIL"
	Write-Host ""
	exit 1
}