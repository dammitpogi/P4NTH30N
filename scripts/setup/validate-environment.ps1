<#
.SYNOPSIS
    Validates the P4NTH30N environment is fully configured and operational.

.DESCRIPTION
    Performs end-to-end validation of all P4NTH30N dependencies and services:
    - .NET SDK version and build capability
    - MongoDB connectivity and database existence
    - Chrome and ChromeDriver availability and version matching
    - Configuration files present and parseable
    - Master encryption key (optional, for production)
    - Environment variables

.PARAMETER Environment
    Target environment to validate. Default: Development.

.PARAMETER Strict
    Fail on warnings (not just errors). Useful for CI/CD gating.

.EXAMPLE
    .\validate-environment.ps1
    .\validate-environment.ps1 -Environment Production -Strict

.NOTES
    Part of INFRA-001: Environment Setup & Installation Procedures.
    Exit code 0 = all checks passed. Exit code 1 = failures detected.
#>

[CmdletBinding()]
param(
    [ValidateSet("Development", "Staging", "Production")]
    [string]$Environment = "Development",

    [switch]$Strict
)

$ErrorActionPreference = "Continue"
$script:Errors = @()
$script:Warnings = @()
$script:Passes = @()

function Write-Check {
    param($Message, $Type = "INFO")
    $symbol = switch ($Type) {
        "PASS" { "[OK]"; $color = "Green"; $script:Passes += $Message }
        "FAIL" { "[!!]"; $color = "Red"; $script:Errors += $Message }
        "WARN" { "[??]"; $color = "Yellow"; $script:Warnings += $Message }
        default { "[..]"; $color = "Cyan" }
    }
    Write-Host "$symbol $Message" -ForegroundColor $color
}

# ── .NET SDK ──────────────────────────────────────────────────────────────
function Test-DotNetBuild {
    Write-Host "`n--- .NET SDK ---" -ForegroundColor White
    try {
        $version = dotnet --version 2>$null
        if ($version) {
            $major = [int]($version -split '\.')[0]
            if ($major -ge 8) {
                Write-Check ".NET SDK $version" "PASS"
            } else {
                Write-Check ".NET SDK $version found but need 8.0+" "FAIL"
                return
            }
        } else {
            Write-Check ".NET SDK not found in PATH" "FAIL"
            return
        }
    } catch {
        Write-Check ".NET SDK check failed: $_" "FAIL"
        return
    }

    # Test build
    $slnPath = Join-Path $PSScriptRoot "..\..\P4NTH30N.slnx"
    if (Test-Path $slnPath) {
        try {
            $buildOutput = dotnet build $slnPath --no-restore --verbosity quiet 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Check "Solution builds successfully" "PASS"
            } else {
                Write-Check "Solution build failed" "FAIL"
            }
        } catch {
            Write-Check "Build check failed: $_" "WARN"
        }
    } else {
        Write-Check "P4NTH30N.slnx not found at expected path" "WARN"
    }
}

# ── MongoDB ───────────────────────────────────────────────────────────────
function Test-MongoDBConnection {
    Write-Host "`n--- MongoDB ---" -ForegroundColor White
    try {
        $mongo = Get-Command mongod -ErrorAction SilentlyContinue
        if ($mongo) {
            Write-Check "MongoDB binary found" "PASS"
        } else {
            Write-Check "MongoDB binary not found in PATH" "FAIL"
            return
        }
    } catch {
        Write-Check "MongoDB check failed: $_" "FAIL"
        return
    }

    # Test connection
    try {
        $testResult = mongosh --eval "db.version()" --quiet 2>$null
        if ($testResult) {
            Write-Check "MongoDB connection successful (v$testResult)" "PASS"
        } else {
            Write-Check "MongoDB not responding on default port" "FAIL"
            return
        }
    } catch {
        Write-Check "MongoDB connection failed: $_" "FAIL"
        return
    }

    # Check P4NTH30N database exists
    try {
        $dbList = mongosh --eval "db.adminCommand('listDatabases').databases.map(d=>d.name)" --quiet 2>$null
        if ($dbList -match "P4NTH30N") {
            Write-Check "P4NTH30N database exists" "PASS"
        } else {
            Write-Check "P4NTH30N database not found (will be created on first use)" "WARN"
        }
    } catch {
        Write-Check "Database listing failed: $_" "WARN"
    }
}

# ── Chrome & ChromeDriver ────────────────────────────────────────────────
function Test-ChromeStack {
    Write-Host "`n--- Chrome & ChromeDriver ---" -ForegroundColor White
    $chromeVersion = $null
    $chromePaths = @(
        "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "${env:LocalAppData}\Google\Chrome\Application\chrome.exe"
    )

    foreach ($path in $chromePaths) {
        if (Test-Path $path) {
            $chromeVersion = (Get-Item $path).VersionInfo.FileVersion
            Write-Check "Chrome $chromeVersion" "PASS"
            break
        }
    }

    if (-not $chromeVersion) {
        Write-Check "Google Chrome not found" "FAIL"
        return
    }

    # ChromeDriver
    try {
        $cd = Get-Command chromedriver -ErrorAction SilentlyContinue
        if ($cd) {
            $cdVersionOutput = & chromedriver --version 2>&1
            if ($cdVersionOutput -match "([\d\.]+)") {
                $cdVersion = $matches[1]
                $chromeMajor = ($chromeVersion -split '\.')[0]
                $cdMajor = ($cdVersion -split '\.')[0]

                if ($chromeMajor -eq $cdMajor) {
                    Write-Check "ChromeDriver $cdVersion (matches Chrome $chromeMajor)" "PASS"
                } else {
                    Write-Check "ChromeDriver $cdVersion does NOT match Chrome $chromeMajor" "FAIL"
                }
            }
        } else {
            Write-Check "ChromeDriver not found in PATH" "WARN"
        }
    } catch {
        Write-Check "ChromeDriver check failed: $_" "WARN"
    }
}

# ── Configuration Files ──────────────────────────────────────────────────
function Test-ConfigurationFiles {
    Write-Host "`n--- Configuration ---" -ForegroundColor White
    $repoRoot = Join-Path $PSScriptRoot "..\.."

    # Base config
    $baseConfig = Join-Path $repoRoot "appsettings.json"
    if (Test-Path $baseConfig) {
        try {
            $null = Get-Content $baseConfig | ConvertFrom-Json
            Write-Check "appsettings.json present and valid JSON" "PASS"
        } catch {
            Write-Check "appsettings.json has invalid JSON: $_" "FAIL"
        }
    } else {
        Write-Check "appsettings.json missing" "FAIL"
    }

    # Environment-specific config
    $envConfig = Join-Path $repoRoot "appsettings.$Environment.json"
    if (Test-Path $envConfig) {
        try {
            $null = Get-Content $envConfig | ConvertFrom-Json
            Write-Check "appsettings.$Environment.json present and valid" "PASS"
        } catch {
            Write-Check "appsettings.$Environment.json has invalid JSON" "FAIL"
        }
    } else {
        if ($Environment -eq "Development") {
            Write-Check "appsettings.Development.json missing" "FAIL"
        } else {
            Write-Check "appsettings.$Environment.json not found (create from template)" "WARN"
        }
    }
}

# ── Security / Master Key ────────────────────────────────────────────────
function Test-SecuritySetup {
    Write-Host "`n--- Security ---" -ForegroundColor White

    $keyPath = "C:\ProgramData\P4NTH30N\master.key"
    if (Test-Path $keyPath) {
        $keySize = (Get-Item $keyPath).Length
        if ($keySize -eq 32) {
            Write-Check "Master encryption key present (32 bytes)" "PASS"
        } else {
            Write-Check "Master key has unexpected size: $keySize bytes (expected 32)" "FAIL"
        }
    } else {
        if ($Environment -eq "Production") {
            Write-Check "Master encryption key not found at $keyPath" "FAIL"
        } else {
            Write-Check "Master key not found (optional for $Environment)" "WARN"
        }
    }
}

# ── Environment Variables ────────────────────────────────────────────────
function Test-EnvironmentVariables {
    Write-Host "`n--- Environment Variables ---" -ForegroundColor White

    $envName = [Environment]::GetEnvironmentVariable("P4NTH30N_ENVIRONMENT")
    if ($envName) {
        Write-Check "P4NTH30N_ENVIRONMENT = $envName" "PASS"
    } else {
        Write-Check "P4NTH30N_ENVIRONMENT not set (defaults to Development)" "WARN"
    }

    $mongoUri = [Environment]::GetEnvironmentVariable("P4NTH30N_MONGODB_URI")
    if ($mongoUri) {
        Write-Check "P4NTH30N_MONGODB_URI is set" "PASS"
    } else {
        Write-Check "P4NTH30N_MONGODB_URI not set (using appsettings.json default)" "WARN"
    }
}

# ── Execute All Checks ───────────────────────────────────────────────────
Write-Host ""
Write-Host "P4NTH30N Environment Validation" -ForegroundColor Cyan
Write-Host "Environment: $Environment" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

Test-DotNetBuild
Test-MongoDBConnection
Test-ChromeStack
Test-ConfigurationFiles
Test-SecuritySetup
Test-EnvironmentVariables

# ── Summary ──────────────────────────────────────────────────────────────
Write-Host "`n================================" -ForegroundColor Cyan
Write-Host "RESULTS:" -ForegroundColor Cyan
Write-Host "  Passed:   $($script:Passes.Count)" -ForegroundColor Green
Write-Host "  Warnings: $($script:Warnings.Count)" -ForegroundColor Yellow
Write-Host "  Errors:   $($script:Errors.Count)" -ForegroundColor Red

if ($script:Errors.Count -gt 0) {
    Write-Host "`nFailed checks:" -ForegroundColor Red
    foreach ($err in $script:Errors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
    exit 1
}

if ($Strict -and $script:Warnings.Count -gt 0) {
    Write-Host "`nStrict mode: warnings treated as failures." -ForegroundColor Yellow
    exit 1
}

Write-Host "`nEnvironment validation passed!" -ForegroundColor Green
exit 0
