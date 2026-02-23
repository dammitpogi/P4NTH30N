#!/usr/bin/env pwsh
# Build script for P4NTH30N Recorder TUI
# Generates standalone executable using Bun's compile feature

$ErrorActionPreference = "Stop"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  P4NTH30N Recorder TUI - Build Script" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# Check if bun is installed
Write-Host "Checking for Bun..." -ForegroundColor Yellow
try {
    $bunVersion = bun --version
    Write-Host "✓ Bun found: v$bunVersion" -ForegroundColor Green
}
catch {
    Write-Host "✗ Bun not found. Please install Bun from https://bun.sh" -ForegroundColor Red
    exit 1
}

# Build the TUI executable
Write-Host ""
Write-Host "Building recorder-tui.exe..." -ForegroundColor Yellow
Write-Host "  Entry point: recorder-tui.ts" -ForegroundColor Gray
Write-Host "  Output: recorder-tui.exe" -ForegroundColor Gray
Write-Host ""

try {
    bun build recorder-tui.ts --compile --outfile recorder-tui.exe
    
    if (Test-Path "recorder-tui.exe") {
        $fileInfo = Get-Item "recorder-tui.exe"
        $sizeInMB = [math]::Round($fileInfo.Length / 1MB, 2)
        
        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "  ✓ Build successful!" -ForegroundColor Green
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host ""
        Write-Host "  Executable: recorder-tui.exe" -ForegroundColor Cyan
        Write-Host "  Size: $sizeInMB MB" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Usage:" -ForegroundColor Yellow
        Write-Host "  .\recorder-tui.exe" -ForegroundColor White
        Write-Host "  .\recorder-tui.exe --config=path\to\config.json" -ForegroundColor White
        Write-Host ""
    }
    else {
        Write-Host "✗ Build failed - executable not found" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host ""
    Write-Host "✗ Build failed: $_" -ForegroundColor Red
    exit 1
}
