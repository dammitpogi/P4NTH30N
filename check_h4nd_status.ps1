Invoke-Command -VMName "H4NDv2-Production" -Credential (New-Object PSCredential("h4ndv2.01", (ConvertTo-SecureString "MB@^@%mb" -AsPlainText -Force))) -ScriptBlock {
    Write-Host "=== H4ND Process Status ===" -ForegroundColor Green
    $processes = Get-Process | Where-Object {$_.ProcessName -like "*dotnet*" -or $_.ProcessName -like "*h4nd*"}
    if ($processes) {
        $processes | Select-Object ProcessName, Id, StartTime, @{N='WorkingSetMB';E={[math]::Round($_.WorkingSet / 1MB, 2)}} | Format-Table -AutoSize
    } else {
        Write-Host "No H4ND/dotnet processes found" -ForegroundColor Red
    }
    
    Write-Host "`n=== Recent Log Output (Last 30 lines) ===" -ForegroundColor Green
    if (Test-Path "C:\H4ND\h4nd-output.log") {
        Get-Content "C:\H4ND\h4nd-output.log" -Tail 30
    } else {
        Write-Host "Log file not found" -ForegroundColor Red
    }
    
    Write-Host "`n=== Service Status ===" -ForegroundColor Green
    Get-Service | Where-Object {$_.Name -like "*h4nd*"} | Select-Object Name, Status, StartType | Format-Table -AutoSize
}
