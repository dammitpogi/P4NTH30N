# Check if H4ND process is running
$processes = Get-Process | Where-Object { $_.ProcessName -like '*H4ND*' }
if ($processes) {
    Write-Host "H4ND processes found:"
    $processes | Format-Table ProcessName, Id, StartTime, WorkingSet -AutoSize
} else {
    Write-Host "No H4ND processes found"
}

# Also check for dotnet processes that might be H4ND
$dotnetProcs = Get-Process -Name dotnet -ErrorAction SilentlyContinue
if ($dotnetProcs) {
    Write-Host "`ndotnet processes (possible H4ND hosting):"
    $dotnetProcs | Format-Table ProcessName, Id, StartTime, WorkingSet -AutoSize
}
