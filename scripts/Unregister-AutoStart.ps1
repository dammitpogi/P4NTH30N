#Requires -RunAsAdministrator

param(
    [string]$TaskName = "P4NTH30N-AutoStart"
)

try {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    Write-Host "Task '$TaskName' unregistered successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to unregister task: $_"
    exit 1
}
