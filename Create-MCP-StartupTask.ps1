# Create Windows Scheduled Task for P4NTHE0N MCP Services
# This script creates a scheduled task that starts all MCP services on Windows startup

param(
    [switch]$Remove,
    [switch]$Force
)

$taskName = "P4NTHE0N-MCP-Services"
$scriptPath = "C:\P4NTH30N\Start-All-MCP-Servers.ps1"
$description = "Starts P4NTHE0N MCP services (RAG, Chrome DevTools, P4NTHE0N Tools)"

Write-Host "=== P4NTHE0N MCP Services Scheduled Task ===" -ForegroundColor Cyan

if ($Remove) {
    Write-Host "Removing scheduled task..." -ForegroundColor Yellow
    try {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Stop
        Write-Host " Scheduled task removed" -ForegroundColor Green
    } catch {
        Write-Host " Task not found or removal failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    exit 0
}

# Check if script exists
if (-not (Test-Path $scriptPath)) {
    Write-Host " Startup script not found: $scriptPath" -ForegroundColor Red
    exit 1
}

# Check if task already exists
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask -and -not $Force) {
    Write-Host " Scheduled task already exists" -ForegroundColor Yellow
    Write-Host "Use -Force to recreate or -Remove to delete" -ForegroundColor Gray
    exit 0
}

if ($existingTask -and $Force) {
    Write-Host " Removing existing task..." -ForegroundColor Yellow
    try {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Stop
    } catch {
        Write-Host " Failed to remove existing task: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Create the scheduled task
Write-Host "Creating scheduled task..." -ForegroundColor Yellow

try {
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -AtLogon -User $env:USERNAME
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest

    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description $description -Force
    
    Write-Host " Scheduled task created successfully" -ForegroundColor Green
    Write-Host "Task will start all MCP services when you log in to Windows" -ForegroundColor Gray
    
    # Test the task
    Write-Host "`nTesting scheduled task..." -ForegroundColor Yellow
    try {
        Start-ScheduledTask -TaskName $taskName
        Write-Host " Task started successfully" -ForegroundColor Green
        Write-Host "Check the output above for service status" -ForegroundColor Gray
    } catch {
        Write-Host " Task test failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host " Failed to create scheduled task: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`nTo manage the scheduled task:" -ForegroundColor White
Write-Host " View in Task Scheduler: '$taskName'" -ForegroundColor Gray
Write-Host " Remove: .\Create-MCP-StartupTask.ps1 -Remove" -ForegroundColor Gray
Write-Host " Recreate: .\Create-MCP-StartupTask.ps1 -Force" -ForegroundColor Gray
