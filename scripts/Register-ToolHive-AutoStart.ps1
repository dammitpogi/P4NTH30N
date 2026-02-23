#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Registers ToolHive Desktop to start on system boot.
    
.DESCRIPTION
    Creates a scheduled task that starts ToolHive Desktop after system boot.
    This ensures all ToolHive-managed MCP workloads are available.
    
    DECISION_094: MCP Server Boot-Time Integration
#>

param(
    [string]$TaskName = "ToolHive-AutoStart",
    [int]$DelaySeconds = 60
)

$toolHivePath = "$env:LOCALAPPDATA\ToolHive\ToolHive.exe"

if (-not (Test-Path $toolHivePath)) {
    Write-Error "ToolHive not found at: $toolHivePath"
    Write-Host "Please install ToolHive first from https://github.com/stacklok/toolhive"
    exit 1
}

# Create action to start ToolHive
$action = New-ScheduledTaskAction -Execute $toolHivePath

# Create trigger at startup with delay
$trigger = New-ScheduledTaskTrigger -AtStartup
$trigger.Delay = "PT${DelaySeconds}S"

# Run as current user (ToolHive Desktop needs UI)
$principal = New-ScheduledTaskPrincipal `
    -UserId $env:USERNAME `
    -LogonType Interactive `
    -RunLevel Highest

# Settings: don't stop on battery, start when available
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable:$false

try {
    Register-ScheduledTask `
        -TaskName $TaskName `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Settings $settings `
        -Force

    Write-Host "✅ Task '$TaskName' registered successfully" -ForegroundColor Green
    Write-Host "   ToolHive will start $DelaySeconds seconds after system boot"
    Write-Host "   Run 'Get-ScheduledTask -TaskName $TaskName' to verify"
}
catch {
    Write-Error "Failed to register task: $_"
    exit 1
}
