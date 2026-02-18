#!/usr/bin/env pwsh
#requires -Version 5.1

param(
    [switch]$Fix,
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"
$script:PrereqsPassed = $true
$script:PrereqsFixed = @()

function Write-Status {
    param($Message, $Status, $Color = "White")
    if (-not $Quiet) {
        $symbol = switch ($Status) {
            "PASS" { "✓"; $Color = "Green" }
            "FAIL" { "✗"; $Color = "Red" }
            "WARN" { "!"; $Color = "Yellow" }
            "INFO" { "ℹ"; $Color = "Cyan" }
            default { "•"; $Color = "White" }
        }
        Write-Host "[$symbol] $Message" -ForegroundColor $Color
    }
}

function Test-DotNetSDK {
    Write-Status "Checking .NET SDK..." "INFO"
    try {
        $version = dotnet --version 2>$null
        if ($version) {
            $major = [int]($version -split '\.')[0]
            if ($major -ge 8) {
                Write-Status ".NET SDK $version detected" "PASS"
                return $true
            } else {
                Write-Status ".NET SDK $version found, need 8.0+" "FAIL"
                $script:PrereqsPassed = $false
                return $false
            }
        }
    } catch {}
    Write-Status ".NET SDK not found" "FAIL"
    $script:PrereqsPassed = $false
    return $false
}

function Test-MongoDB {
    Write-Status "Checking MongoDB..." "INFO"
    try {
        $mongo = Get-Command mongod -ErrorAction SilentlyContinue
        if ($mongo) {
            Write-Status "MongoDB found at $($mongo.Source)" "PASS"
            
            # Test connection
            try {
                $test = mongosh --eval "db.version()" --quiet 2>$null
                if ($test) {
                    Write-Status "MongoDB connection successful" "PASS"
                    return $true
                }
            } catch {
                Write-Status "MongoDB installed but not running" "WARN"
                return $true
            }
        }
    } catch {}
    Write-Status "MongoDB not found" "FAIL"
    $script:PrereqsPassed = $false
    return $false
}

function Test-Chrome {
    Write-Status "Checking Google Chrome..." "INFO"
    $chromePaths = @(
        "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "${env:LocalAppData}\Google\Chrome\Application\chrome.exe"
    )
    
    foreach ($path in $chromePaths) {
        if (Test-Path $path) {
            $version = (Get-Item $path).VersionInfo.FileVersion
            Write-Status "Chrome $version found" "PASS"
            return $true
        }
    }
    Write-Status "Google Chrome not found" "FAIL"
    $script:PrereqsPassed = $false
    return $false
}

function Test-ChromeDriver {
    Write-Status "Checking ChromeDriver..." "INFO"
    try {
        $chromedriver = Get-Command chromedriver -ErrorAction SilentlyContinue
        if ($chromedriver) {
            $version = & chromedriver --version 2>&1
            Write-Status "ChromeDriver found: $version" "PASS"
            return $true
        }
    } catch {}
    Write-Status "ChromeDriver not found in PATH" "WARN"
    return $true
}

function Test-PowerShell {
    Write-Status "Checking PowerShell..." "INFO"
    $version = $PSVersionTable.PSVersion
    if ($version.Major -ge 5) {
        Write-Status "PowerShell $($version.ToString()) detected" "PASS"
        return $true
    }
    Write-Status "PowerShell $($version.ToString()) found, need 5.1+" "FAIL"
    $script:PrereqsPassed = $false
    return $false
}

function Test-Git {
    Write-Status "Checking Git..." "INFO"
    try {
        $version = git --version 2>$null
        if ($version) {
            Write-Status "$version detected" "PASS"
            return $true
        }
    } catch {}
    Write-Status "Git not found" "FAIL"
    $script:PrereqsPassed = $false
    return $false
}

function Test-EnvironmentVariables {
    Write-Status "Checking environment variables..." "INFO"
    $required = @(
        "P4NTH30N_MONGODB_URI"
    )
    $missing = @()
    foreach ($var in $required) {
        if (-not [Environment]::GetEnvironmentVariable($var)) {
            $missing += $var
        }
    }
    if ($missing.Count -eq 0) {
        Write-Status "All required environment variables set" "PASS"
        return $true
    } else {
        Write-Status "Missing environment variables: $($missing -join ', ')" "WARN"
        return $true
    }
}

Write-Host "`nP4NTH30N Prerequisites Check" -ForegroundColor Cyan
Write-Host "============================`n" -ForegroundColor Cyan

Test-DotNetSDK
Test-MongoDB
Test-Chrome
Test-ChromeDriver
Test-PowerShell
Test-Git
Test-EnvironmentVariables

Write-Host "`n============================" -ForegroundColor Cyan

if ($script:PrereqsPassed) {
    Write-Host "All prerequisites satisfied!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "Prerequisites missing. Run with -Fix flag to auto-install where possible." -ForegroundColor Red
    exit 1
}
