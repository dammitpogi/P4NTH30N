#Requires -RunAsAdministrator

param(
    [string]$ExecutablePath = "C:\P4NTHE0N\H0UND\bin\Release\net10.0-windows7.0\P4NTHE0N.exe",
    [string]$TaskName = "P4NTHE0N-AutoStart",
    [int]$DelaySeconds = 30
)

if (-not (Test-Path $ExecutablePath)) {
    Write-Error "Executable not found: $ExecutablePath"
    exit 1
}

$action = New-ScheduledTaskAction -Execute $ExecutablePath -Argument "--background"
$trigger = New-ScheduledTaskTrigger -AtStartup
$trigger.Delay = "PT${DelaySeconds}S"
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable:$false `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 5)

try {
    Register-ScheduledTask `
        -TaskName $TaskName `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Settings $settings `
        -Force

    Write-Host "Task '$TaskName' registered successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to register task: $_"
    exit 1
}
