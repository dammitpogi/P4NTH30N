# RAG Scheduled Task Registration
# Creates Windows Scheduled Tasks for RAG index maintenance
# - RAG-Incremental-Rebuild: Every 4 hours
# - RAG-Nightly-Rebuild: Daily at 3:00 AM
#
# REQUIREMENTS: Run as Administrator (elevated PowerShell)
# Run: Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\register-scheduled-tasks.ps1`""

param(
    [string]$TaskUser = $env:USERNAME,
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

Write-Host "=== RAG Scheduled Task Registration ===" -ForegroundColor Cyan
Write-Host "User: $TaskUser"
Write-Host "Force: $Force"
Write-Host "Dry Run: $DryRun"

$exePath = "C:\ProgramData\P4NTH30N\bin\RAG.McpHost.exe"
$rebuildScript = "C:\P4NTH30N\scripts\rag\rebuild-index.ps1"

# Verify executable exists
if (-not (Test-Path $exePath)) {
    Write-Host "ERROR: RAG.McpHost.exe not found at $exePath" -ForegroundColor Red
    Write-Host "Run 'dotnet publish' first." -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] Executable found: $exePath" -ForegroundColor Green

# Common task settings
$taskSettings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable:$false `
    -ExecutionTimeLimit (New-TimeSpan -Hours 2)

# =========================================
# Task 1: RAG-Incremental-Rebuild (4 hours)
# =========================================
$incrementalTaskName = "RAG-Incremental-Rebuild"

# Check if task exists
$existingIncremental = Get-ScheduledTask -TaskName $incrementalTaskName -ErrorAction SilentlyContinue
if ($existingIncremental -and -not $Force) {
    Write-Host "[SKIP] $incrementalTaskName already exists (use -Force to recreate)" -ForegroundColor Yellow
} else {
    if ($existingIncremental) {
        Unregister-ScheduledTask -TaskName $incrementalTaskName -Confirm:$false
        Write-Host "[REMOVED] Existing $incrementalTaskName" -ForegroundColor Yellow
    }

    $incrementalAction = New-ScheduledTaskAction `
        -Execute "powershell.exe" `
        -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$rebuildScript`""

    # Create trigger: every 4 hours, repeat for 365 days (effectively indefinite)
    $incrementalTrigger = New-ScheduledTaskTrigger `
        -Once -At (Get-Date) `
        -RepetitionInterval (New-TimeSpan -Hours 4) `
        -RepetitionDuration (New-TimeSpan -Days 365)

    if (-not $DryRun) {
        Register-ScheduledTask `
            -TaskName $incrementalTaskName `
            -Action $incrementalAction `
            -Trigger $incrementalTrigger `
            -Settings $taskSettings `
            -Description "RAG incremental index rebuild - runs every 4 hours" `
            -RunLevel Highest | Out-Null
        
        Write-Host "[CREATED] $incrementalTaskName - runs every 4 hours" -ForegroundColor Green
    } else {
        Write-Host "[DRY-RUN] Would create $incrementalTaskName" -ForegroundColor Cyan
    }
}

# =========================================
# Task 2: RAG-Nightly-Rebuild (3:00 AM)
# =========================================
$nightlyTaskName = "RAG-Nightly-Rebuild"

$existingNightly = Get-ScheduledTask -TaskName $nightlyTaskName -ErrorAction SilentlyContinue
if ($existingNightly -and -not $Force) {
    Write-Host "[SKIP] $nightlyTaskName already exists (use -Force to recreate)" -ForegroundColor Yellow
} else {
    if ($existingNightly) {
        Unregister-ScheduledTask -TaskName $nightlyTaskName -Confirm:$false
        Write-Host "[REMOVED] Existing $nightlyTaskName" -ForegroundColor Yellow
    }

    $nightlyAction = New-ScheduledTaskAction `
        -Execute "powershell.exe" `
        -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$rebuildScript`" -Full"

    $nightlyTrigger = New-ScheduledTaskTrigger -Daily -At "03:00"

    if (-not $DryRun) {
        Register-ScheduledTask `
            -TaskName $nightlyTaskName `
            -Action $nightlyAction `
            -Trigger $nightlyTrigger `
            -Settings $taskSettings `
            -Description "RAG full index rebuild - runs daily at 3:00 AM" `
            -RunLevel Highest | Out-Null
        
        Write-Host "[CREATED] $nightlyTaskName - runs daily at 3:00 AM" -ForegroundColor Green
    } else {
        Write-Host "[DRY-RUN] Would create $nightlyTaskName" -ForegroundColor Cyan
    }
}

# =========================================
# Verification
# =========================================
Write-Host ""
Write-Host "=== Verification ===" -ForegroundColor Cyan

$ragTasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "RAG-*" }
foreach ($task in $ragTasks) {
    $nextRun = $task.NextRunTime
    Write-Host "  $($task.TaskName): Next run at $nextRun" -ForegroundColor Green
}

Write-Host ""
Write-Host "Scheduled task registration complete." -ForegroundColor Green
