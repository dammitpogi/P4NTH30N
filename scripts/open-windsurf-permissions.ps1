# Apply WindSurf Maximum Permissions
# Run this PowerShell script as Administrator

$ErrorActionPreference = "Stop"

Write-Host "=== OPENING WINDSURF PERMISSIONS ===" -ForegroundColor Green
Write-Host ""

# Paths
$vscodeSettingsPath = "$env:APPDATA\Code\User\settings.json"
$windsurfSettingsPath = "$env:APPDATA\Windsurf\User\settings.json"
$projectSettingsPath = "C:\P4NTHE0N\.windsurf\settings.json"

Write-Host "Step 1: Creating WindSurf configuration..." -ForegroundColor Yellow

# Read project settings
$projectSettings = Get-Content $projectSettingsPath | ConvertFrom-Json

# Function to merge settings
function Merge-Settings {
    param($targetPath, $sourceSettings)
    
    if (Test-Path $targetPath) {
        $existing = Get-Content $targetPath -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($existing) {
            # Merge source into existing
            foreach ($prop in $sourceSettings.PSObject.Properties) {
                $existing | Add-Member -NotePropertyName $prop.Name -NotePropertyValue $prop.Value -Force
            }
            $existing | ConvertTo-Json -Depth 10 | Set-Content $targetPath
            Write-Host "  Updated: $targetPath" -ForegroundColor Green
        } else {
            $sourceSettings | ConvertTo-Json -Depth 10 | Set-Content $targetPath
            Write-Host "  Created: $targetPath" -ForegroundColor Green
        }
    } else {
        # Create directory if needed
        $dir = Split-Path $targetPath -Parent
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        $sourceSettings | ConvertTo-Json -Depth 10 | Set-Content $targetPath
        Write-Host "  Created: $targetPath" -ForegroundColor Green
    }
}

# Apply to all locations
Merge-Settings $vscodeSettingsPath $projectSettings
Merge-Settings $windsurfSettingsPath $projectSettings

Write-Host ""
Write-Host "Step 2: Verifying .codeiumignore..." -ForegroundColor Yellow
$codeiumIgnorePath = "C:\P4NTHE0N\.codeiumignore"
if (Test-Path $codeiumIgnorePath) {
    Write-Host "  OK: $codeiumIgnorePath" -ForegroundColor Green
} else {
    Write-Host "  WARNING: .codeiumignore not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "Step 3: Testing write permissions..." -ForegroundColor Yellow

try {
    $testFile = "C:\P4NTHE0N\.windsurf\permission_test.tmp"
    "test" | Set-Content $testFile
    Remove-Item $testFile
    Write-Host "  OK: Write permissions working" -ForegroundColor Green
} catch {
    Write-Host "  FAILED: Write permissions" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== CONFIGURATION COMPLETE ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart WindSurf if running"
Write-Host "2. Load Fixer prompt from FIXER_PROMPT.md"
Write-Host "3. Begin autonomous implementation"
Write-Host ""
Write-Host "Permissions now open:" -ForegroundColor White
Write-Host "  - Terminal commands: AUTO-EXECUTE (Turbo)"
Write-Host "  - Gitignored files: ACCESSIBLE"
Write-Host "  - File editing: UNRESTRICTED"
Write-Host ""
