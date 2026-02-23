# ToolHive-AutoStart Scheduled Task Creation Script
$ErrorActionPreference = "Stop"

try {
    Write-Host "Creating ToolHive-AutoStart scheduled task..." -ForegroundColor Cyan
    
    # Create the action
    $Action = New-ScheduledTaskAction -Execute 'C:\Users\paulc\AppData\Local\ToolHive\ToolHive.exe' -Argument 'server'
    Write-Host "✓ Action created: Start ToolHive.exe with 'server' argument" -ForegroundColor Green
    
    # Create the trigger (AtStartup with 60-second delay)
    $Trigger = New-ScheduledTaskTrigger -AtStartup
    $Trigger.Delay = 'PT60S'  # 60 seconds in ISO 8601 duration format
    Write-Host "✓ Trigger created: AtStartup with 60-second delay" -ForegroundColor Green
    
    # Create the principal (current user, interactive)
    $Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
    Write-Host "✓ Principal created: Current user ($env:USERNAME), interactive logon" -ForegroundColor Green
    
    # Create settings (allow on batteries, don't stop on batteries)
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
    Write-Host "✓ Settings created: Allow on batteries, don't stop on batteries" -ForegroundColor Green
    
    # Create the task
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
    Write-Host "✓ Task object created" -ForegroundColor Green
    
    # Register the task
    Register-ScheduledTask -TaskName 'ToolHive-AutoStart' -InputObject $Task -Force
    Write-Host "✓ Task 'ToolHive-AutoStart' registered successfully!" -ForegroundColor Green
    
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    exit 1
}
