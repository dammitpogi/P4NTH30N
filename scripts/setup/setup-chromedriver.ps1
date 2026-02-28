<#
.SYNOPSIS
    Automated ChromeDriver setup with Chrome version detection and auto-matching.

.DESCRIPTION
    Detects installed Chrome version, downloads the matching ChromeDriver binary,
    and installs it to a system-accessible location. Supports auto-update and
    version pinning.

.PARAMETER InstallPath
    Directory to install ChromeDriver. Default: C:\Tools\chromedriver

.PARAMETER AddToPath
    Add the install directory to the system PATH. Default: true.

.PARAMETER Force
    Re-download even if a matching version already exists.

.EXAMPLE
    .\setup-chromedriver.ps1
    .\setup-chromedriver.ps1 -InstallPath "D:\Drivers" -Force

.NOTES
    Part of INFRA-001: Environment Setup & Installation Procedures.
    ChromeDriver versions must match the installed Chrome major version.
    Uses Chrome for Testing (CfT) endpoints for Chrome 115+.
#>

[CmdletBinding()]
param(
    [string]$InstallPath = "C:\Tools\chromedriver",
    [switch]$AddToPath,
    [switch]$Force
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

function Get-ChromeVersion {
    $chromePaths = @(
        "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "${env:LocalAppData}\Google\Chrome\Application\chrome.exe"
    )

    foreach ($path in $chromePaths) {
        if (Test-Path $path) {
            $version = (Get-Item $path).VersionInfo.FileVersion
            Write-Status "Chrome found: $version at $path"
            return $version
        }
    }

    Write-Status "Google Chrome not found. Install Chrome first." "ERROR"
    return $null
}

function Get-InstalledChromeDriverVersion {
    $cdPath = Join-Path $InstallPath "chromedriver.exe"
    if (Test-Path $cdPath) {
        try {
            $output = & $cdPath --version 2>&1
            if ($output -match "ChromeDriver\s+([\d\.]+)") {
                return $matches[1]
            }
        } catch {}
    }
    return $null
}

function Get-ChromeDriverDownloadUrl {
    param([string]$ChromeVersion)

    $majorVersion = [int]($ChromeVersion -split '\.')[0]

    if ($majorVersion -ge 115) {
        # Chrome for Testing (CfT) endpoint - Chrome 115+
        Write-Status "Using Chrome for Testing endpoint (Chrome $majorVersion)..."
        $apiUrl = "https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json"

        try {
            $response = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
            $chromeMajor = ($ChromeVersion -split '\.')[0..2] -join '.'

            # Find the best matching version
            $matching = $response.versions | Where-Object {
                $_.version -like "$chromeMajor*"
            } | Select-Object -Last 1

            if (-not $matching) {
                # Fall back to matching just the major version
                $matching = $response.versions | Where-Object {
                    $_.version -like "$majorVersion.*"
                } | Select-Object -Last 1
            }

            if ($matching -and $matching.downloads.chromedriver) {
                $win64 = $matching.downloads.chromedriver | Where-Object { $_.platform -eq "win64" }
                if ($win64) {
                    Write-Status "Matched ChromeDriver version: $($matching.version)"
                    return @{ Url = $win64.url; Version = $matching.version }
                }
            }
        } catch {
            Write-Status "CfT API request failed: $($_.Exception.Message)" "WARN"
        }
    }

    # Fallback for older Chrome versions (<115)
    Write-Status "Using legacy ChromeDriver endpoint..."
    $versionUrl = "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$majorVersion"
    try {
        $cdVersion = (Invoke-WebRequest -Uri $versionUrl -UseBasicParsing).Content.Trim()
        $downloadUrl = "https://chromedriver.storage.googleapis.com/$cdVersion/chromedriver_win32.zip"
        return @{ Url = $downloadUrl; Version = $cdVersion }
    } catch {
        Write-Status "Failed to find ChromeDriver for Chrome $majorVersion" "ERROR"
        return $null
    }
}

function Install-ChromeDriver {
    param($DownloadInfo)

    # Ensure install directory exists
    if (-not (Test-Path $InstallPath)) {
        New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
        Write-Status "Created directory: $InstallPath"
    }

    $zipPath = Join-Path $env:TEMP "chromedriver-download.zip"
    $extractPath = Join-Path $env:TEMP "chromedriver-extract"

    try {
        # Download
        Write-Status "Downloading ChromeDriver $($DownloadInfo.Version)..."
        Invoke-WebRequest -Uri $DownloadInfo.Url -OutFile $zipPath -UseBasicParsing

        # Extract
        if (Test-Path $extractPath) { Remove-Item $extractPath -Recurse -Force }
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

        # Find chromedriver.exe in extracted files (may be in a subdirectory)
        $cdExe = Get-ChildItem -Path $extractPath -Filter "chromedriver.exe" -Recurse | Select-Object -First 1
        if (-not $cdExe) {
            Write-Status "chromedriver.exe not found in download" "ERROR"
            return $false
        }

        # Copy to install path
        Copy-Item -Path $cdExe.FullName -Destination (Join-Path $InstallPath "chromedriver.exe") -Force
        Write-Status "ChromeDriver installed to: $InstallPath\chromedriver.exe" "SUCCESS"

        # Write version file for tracking
        $DownloadInfo.Version | Out-File -FilePath (Join-Path $InstallPath "version.txt") -Encoding UTF8 -Force

        return $true
    } catch {
        Write-Status "Installation failed: $($_.Exception.Message)" "ERROR"
        return $false
    } finally {
        # Cleanup temp files
        Remove-Item $zipPath -ErrorAction SilentlyContinue
        Remove-Item $extractPath -Recurse -ErrorAction SilentlyContinue
    }
}

function Add-ToSystemPath {
    param([string]$Directory)

    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    if ($currentPath -split ";" | Where-Object { $_ -eq $Directory }) {
        Write-Status "Directory already in system PATH"
        return
    }

    try {
        [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$Directory", "Machine")
        $env:PATH = "$env:PATH;$Directory"
        Write-Status "Added $Directory to system PATH" "SUCCESS"
    } catch {
        Write-Status "Failed to update PATH (run as Administrator): $($_.Exception.Message)" "WARN"
    }
}

# ── Main Execution ────────────────────────────────────────────────────────
Write-Host ""
Write-Host "P4NTHE0N ChromeDriver Setup (INFRA-001)" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Detect Chrome version
$chromeVersion = Get-ChromeVersion
if (-not $chromeVersion) { exit 1 }

$chromeMajor = ($chromeVersion -split '\.')[0]

# Step 2: Check existing ChromeDriver
$existingVersion = Get-InstalledChromeDriverVersion
if ($existingVersion -and -not $Force) {
    $existingMajor = ($existingVersion -split '\.')[0]
    if ($existingMajor -eq $chromeMajor) {
        Write-Status "ChromeDriver $existingVersion already matches Chrome $chromeMajor" "SUCCESS"
        Write-Host ""
        Write-Status "Use -Force to re-download." "INFO"
        exit 0
    } else {
        Write-Status "ChromeDriver $existingVersion does NOT match Chrome $chromeMajor - updating..." "WARN"
    }
}

# Step 3: Find matching ChromeDriver download
$downloadInfo = Get-ChromeDriverDownloadUrl -ChromeVersion $chromeVersion
if (-not $downloadInfo) {
    Write-Status "Cannot find a matching ChromeDriver. Manual installation required." "ERROR"
    exit 1
}

# Step 4: Download and install
if (-not (Install-ChromeDriver -DownloadInfo $downloadInfo)) {
    exit 1
}

# Step 5: Optionally add to PATH
if ($AddToPath) {
    Add-ToSystemPath -Directory $InstallPath
}

# Step 6: Verify installation
$finalVersion = Get-InstalledChromeDriverVersion
if ($finalVersion) {
    Write-Host ""
    Write-Status "ChromeDriver $finalVersion ready (Chrome $chromeVersion)" "SUCCESS"
} else {
    Write-Status "Installation verification failed" "ERROR"
    exit 1
}
