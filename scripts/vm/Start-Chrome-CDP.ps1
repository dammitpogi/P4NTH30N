<#
.SYNOPSIS
	Launches Chrome on the HOST with Chrome DevTools Protocol enabled.

.DESCRIPTION
	Starts Chrome with --remote-debugging-port so that H4NDv2 in the VM can
	connect via CdpClient. Also applies anti-detection flags:
	  - Incognito mode (clean profile per launch)
	  - Disables background networking / timer throttling
	  - Disables component updates and translate prompts

	Idempotent: if Chrome is already listening on the CDP port, exits cleanly.

.PARAMETER ChromePath
	Full path to chrome.exe. Auto-detected from Program Files if omitted.

.PARAMETER Port
	CDP remote debugging port. Default read from config/vm-network.json.

.PARAMETER UserDataDir
	Chrome user-data-dir for session isolation. Default: $env:TEMP\chrome-cdp

.PARAMETER ConfigPath
	Path to vm-network.json. Default: <repo>\config\vm-network.json

.EXAMPLE
	.\Start-Chrome-CDP.ps1
	.\Start-Chrome-CDP.ps1 -Port 9222 -ChromePath "C:\Program Files\Google\Chrome\Application\chrome.exe"

.NOTES
	Part of INFRA-VM-001. Run on HOST machine, not inside VM.
	Requires: Google Chrome installed.
#>

[CmdletBinding()]
param(
	[string]$ChromePath,
	[int]$Port = 0,
	[string]$UserDataDir,
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

# ── Load config ──────────────────────────────────────────────────────────
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = (Resolve-Path "$scriptDir\..\..").Path

if (-not $ConfigPath) {
	$ConfigPath = Join-Path $repoRoot "config\vm-network.json"
}

if (Test-Path $ConfigPath) {
	$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
	if ($Port -eq 0) { $Port = $config.CDP.Port }
	Write-Status "Loaded config from $ConfigPath"
} else {
	Write-Status "Config not found at $ConfigPath, using defaults." "WARN"
}

if ($Port -eq 0) { $Port = 9222 }

# ── Auto-detect Chrome path ─────────────────────────────────────────────
if (-not $ChromePath) {
	$candidates = @(
		"${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
		"${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
		"${env:LOCALAPPDATA}\Google\Chrome\Application\chrome.exe"
	)
	foreach ($c in $candidates) {
		if (Test-Path $c) {
			$ChromePath = $c
			break
		}
	}
	if (-not $ChromePath) {
		Write-Status "Chrome not found. Install Chrome or pass -ChromePath." "ERROR"
		exit 1
	}
}
Write-Status "Chrome: $ChromePath"

# ── Check if CDP already listening ───────────────────────────────────────
try {
	$tcp = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue |
		Where-Object { $_.State -eq "Listen" }
	if ($tcp) {
		Write-Status "Port $Port already in use (PID $($tcp.OwningProcess)). Chrome CDP may already be running." "WARN"
		# Verify it's actually CDP
		try {
			$response = Invoke-WebRequest -Uri "http://localhost:$Port/json/version" -TimeoutSec 3 -ErrorAction Stop
			if ($response.StatusCode -eq 200) {
				Write-Status "Chrome CDP is already active on port $Port. Nothing to do." "SUCCESS"
				exit 0
			}
		} catch {
			Write-Status "Port $Port is in use but not responding to CDP. Kill the process or choose another port." "ERROR"
			exit 1
		}
	}
} catch {
	# Get-NetTCPConnection may fail on older systems — proceed with launch
}

# ── Prepare user data dir ────────────────────────────────────────────────
if (-not $UserDataDir) {
	$UserDataDir = Join-Path $env:TEMP "chrome-cdp-$Port"
}
if (-not (Test-Path $UserDataDir)) {
	New-Item -ItemType Directory -Path $UserDataDir -Force | Out-Null
}
Write-Status "User data dir: $UserDataDir"

# ── Build Chrome arguments ───────────────────────────────────────────────
$chromeArgs = @(
	"--remote-debugging-port=$Port",
	"--remote-debugging-address=0.0.0.0",
	"--incognito",
	"--new-window",
	"--user-data-dir=`"$UserDataDir`"",
	# Anti-detection / anti-fingerprint flags
	"--disable-background-networking",
	"--disable-background-timer-throttling",
	"--disable-backgrounding-occluded-windows",
	"--disable-renderer-backgrounding",
	"--disable-component-update",
	"--disable-translate",
	"--disable-sync",
	"--disable-default-apps",
	"--disable-extensions-except=",
	"--no-first-run",
	"--no-default-browser-check",
	# Reduce noise
	"--silent-debugger-extension-api",
	"--disable-hang-monitor",
	"--disable-popup-blocking"
)

Write-Status "Launching Chrome with CDP on port $Port..."
Write-Host "  Args: $($chromeArgs -join ' ')" -ForegroundColor DarkGray

# ── Launch ───────────────────────────────────────────────────────────────
Start-Process -FilePath $ChromePath -ArgumentList $chromeArgs

# ── Wait for CDP to become available ─────────────────────────────────────
$maxWaitSec = 15
$waited = 0
while ($waited -lt $maxWaitSec) {
	Start-Sleep -Seconds 1
	$waited++
	try {
		$response = Invoke-WebRequest -Uri "http://localhost:$Port/json/version" -TimeoutSec 2 -ErrorAction Stop
		if ($response.StatusCode -eq 200) {
			$version = ($response.Content | ConvertFrom-Json)."Browser"
			Write-Status "Chrome CDP active: $version (port $Port)" "SUCCESS"
			exit 0
		}
	} catch {
		# Not ready yet
	}
}

Write-Status "Chrome launched but CDP did not respond within ${maxWaitSec}s. Check manually." "WARN"
exit 0