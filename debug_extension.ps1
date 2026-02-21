Invoke-Command -VMName "H4NDv2-Production" -Credential (New-Object PSCredential("h4ndv2.01", (ConvertTo-SecureString "MB@^@%mb" -AsPlainText -Force))) -ScriptBlock {
    Write-Host "=== Chrome Extension Status ===" -ForegroundColor Green
    
    # Get Chrome processes
    $chrome = Get-Process | Where-Object {$_.ProcessName -like "*chrome*"}
    Write-Host "Chrome Processes: $($chrome.Count)" -ForegroundColor Yellow
    $chrome | Select-Object ProcessName, Id, StartTime | Format-Table -AutoSize
    
    # Check if Chrome has debugging enabled
    $chromeCmd = Get-WmiObject Win32_Process | Where-Object {$_.Name -like "*chrome*"} | Select-Object CommandLine
    Write-Host "`n=== Chrome Command Lines ===" -ForegroundColor Green
    $chromeCmd | ForEach-Object { Write-Host $_.CommandLine }
    
    # Check extension directory
    Write-Host "`n=== Extension Check ===" -ForegroundColor Green
    $extPaths = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Extensions\*",
        "C:\RUL3S\*"
    )
    
    foreach ($path in $extPaths) {
        if (Test-Path $path) {
            Write-Host "Found: $path" -ForegroundColor Yellow
            Get-ChildItem $path -ErrorAction SilentlyContinue | Select-Object Name, LastWriteTime | Format-Table -AutoSize
        }
    }
    
    # Check for more detailed H4ND logs
    Write-Host "`n=== Full H4ND Log Analysis ===" -ForegroundColor Green
    if (Test-Path "C:\H4ND\h4nd-output.log") {
        $logContent = Get-Content "C:\H4ND\h4nd-output.log" -Raw
        
        # Count extension failures
        $extFailures = ($logContent | Select-String "Extension Failure" -AllMatches).Matches.Count
        Write-Host "Extension Failure Count: $extFailures" -ForegroundColor Red
        
        # Find first occurrence of extension failure with context
        $firstFailure = $logContent | Select-String "Extension Failure" -Context 5, 5 | Select-Object -First 1
        if ($firstFailure) {
            Write-Host "`nFirst Extension Failure Context:" -ForegroundColor Yellow
            Write-Host $firstFailure.Context.PreContext
            Write-Host $firstFailure.Line -ForegroundColor Red
            Write-Host $firstFailure.Context.PostContext
        }
        
        # Find CDP connection successes
        $cdpSuccess = ($logContent | Select-String "Connected to Chrome" -AllMatches).Matches.Count
        Write-Host "`nCDP Connection Success Count: $cdpSuccess" -ForegroundColor Green
    }
}
