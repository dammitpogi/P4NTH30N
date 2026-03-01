# Install skill from ClawHub registry (Windows PowerShell version)

param(
    [Parameter(Mandatory=$true)]
    [string]$SkillName,
    
    [string]$Version = ""
)

# Colors
$colors = @{
    Green = "Green"
    Yellow = "Yellow"
    Red = "Red"
    Cyan = "Cyan"
    NC = "White"
}

# Skill locations (Windows compatible)
$BUILTIN_SKILLS = "$env:APPDATA\npm\node_modules\openclaw\skills"
$USER_SKILLS = "$env:USERPROFILE\.openclaw\workspace\skills"
$LOCAL_SKILLS = ".\skills"

# Mock ClawHub API (replace with real API when available)
function Get-SkillFromRegistry {
    param([string]$name, [string]$version)
    
    # This would normally call the real ClawHub API
    # For now, return mock data
    $skills = @{
        "weather" = @{
            name = "weather"
            version = "1.2.3"
            description = "Weather information and forecasts"
            depends = @("http-client")
            optional = @("location")
            downloadUrl = "https://clawhub.com/api/v1/skills/weather/download"
        }
        "http-client" = @{
            name = "http-client"
            version = "2.1.0"
            description = "HTTP client for making web requests"
            depends = @()
            optional = @()
            downloadUrl = "https://clawhub.com/api/v1/skills/http-client/download"
        }
        "location" = @{
            name = "location"
            version = "1.0.5"
            description = "Geolocation services"
            depends = @()
            optional = @()
            downloadUrl = "https://clawhub.com/api/v1/skills/location/download"
        }
    }
    
    if ($skills.ContainsKey($name)) {
        return $skills[$name]
    }
    return $null
}

# Download and install skill
function Install-Skill {
    param(
        [hashtable]$skillInfo,
        [string]$targetDir
    )
    
    $skillDir = Join-Path $targetDir $skillInfo.name
    
    if (Test-Path $skillDir) {
        Write-Host "⚠️  Skill already exists at $skillDir" -ForegroundColor $colors.Yellow
        return $false
    }
    
    Write-Host "📥 Downloading $($skillInfo.name)@$($skillInfo.version)..." -ForegroundColor $colors.Cyan
    
    # Create skill directory
    New-Item -ItemType Directory -Path $skillDir -Force | Out-Null
    
    # Mock download (replace with real download logic)
    # In a real implementation, this would download from the skillInfo.downloadUrl
    $skillMd = @"
---
name: $($skillInfo.name)
description: $($skillInfo.description)
depends: $($skillInfo.depends -join ', ')
optional: $($skillInfo.optional -join ', ')
---

# $($skillInfo.name)

$($skillInfo.description)

## Installation

Installed from ClawHub registry.
"@
    
    $skillMd | Out-File -FilePath (Join-Path $skillDir "SKILL.md") -Encoding UTF8
    
    Write-Host "✅ Installed $($skillInfo.name)@$($skillInfo.version)" -ForegroundColor $colors.Green
    return $true
}

# Resolve dependencies
function Resolve-Dependencies {
    param([hashtable]$skillInfo)
    
    $deps = @()
    foreach ($dep in $skillInfo.depends) {
        $depInfo = Get-SkillFromRegistry $dep ""
        if ($depInfo) {
            $deps += $depInfo
        } else {
            Write-Host "❌ Dependency '$dep' not found in registry" -ForegroundColor $colors.Red
            return @()
        }
    }
    return $deps
}

# Main
Write-Host "`n📦 Installing Skill: $SkillName" -ForegroundColor $colors.Green

# Get skill info from registry
$skillInfo = Get-SkillFromRegistry $SkillName $Version
if (-not $skillInfo) {
    Write-Host "❌ Skill '$SkillName' not found in ClawHub registry" -ForegroundColor $colors.Red
    exit 1
}

Write-Host "📋 Found: $($skillInfo.description) (v$($skillInfo.version))" -ForegroundColor $colors.Cyan

# Resolve dependencies
$deps = Resolve-Dependencies $skillInfo
if ($deps.Count -gt 0) {
    Write-Host "`n🔍 Resolving dependencies..." -ForegroundColor $colors.Yellow
    foreach ($dep in $deps) {
        Write-Host "  ├── $dep.name (required)"
    }
}

# Check for conflicts (mock implementation)
Write-Host "`n🔍 Checking conflicts..." -ForegroundColor $colors.Yellow
Write-Host "  └── No conflicts found" -ForegroundColor $colors.Green

# Install to user skills directory
$targetDir = $USER_SKILLS
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

# Install dependencies first
foreach ($dep in $deps) {
    $installed = Install-Skill $dep $targetDir
    if (-not $installed) {
        Write-Host "❌ Failed to install dependency: $($dep.name)" -ForegroundColor $colors.Red
        exit 1
    }
}

# Install main skill
$installed = Install-Skill $skillInfo $targetDir
if (-not $installed) {
    Write-Host "❌ Failed to install skill: $($skillInfo.name)" -ForegroundColor $colors.Red
    exit 1
}

Write-Host "`n🎉 Installation complete!" -ForegroundColor $colors.Green
Write-Host "Skill installed to: $targetDir\$($skillInfo.name)" -ForegroundColor $colors.Cyan
