Invoke-Command -VMName "H4NDv2-Production" -Credential (New-Object PSCredential("h4ndv2.01", (ConvertTo-SecureString "MB@^@%mb" -AsPlainText -Force))) -ScriptBlock {
    Write-Host "=== Chrome Installation Check ===" -ForegroundColor Green
    
    # Check if Chrome is installed
    $chromePaths = @(
        "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "${env:LOCALAPPDATA}\Google\Chrome\Application\chrome.exe"
    )
    
    $chromeFound = $false
    foreach ($path in $chromePaths) {
        if (Test-Path $path) {
            Write-Host "Chrome found: $path" -ForegroundColor Green
            $chromeFound = $true
            $chromeExe = $path
            break
        }
    }
    
    if (-not $chromeFound) {
        Write-Host "Chrome NOT installed on VM!" -ForegroundColor Red
        
        # Check for Edge as alternative
        $edgePaths = @(
            "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
            "${env:ProgramFiles}\Microsoft\Edge\Application\msedge.exe"
        )
        
        foreach ($path in $edgePaths) {
            if (Test-Path $path) {
                Write-Host "Edge found as alternative: $path" -ForegroundColor Yellow
            }
        }
    }
    
    Write-Host "`n=== Current Chrome Processes ===" -ForegroundColor Green
    Get-Process | Where-Object {$_.ProcessName -like "*chrome*"} | Select-Object ProcessName, Id, StartTime | Format-Table -AutoSize
    
    Write-Host "`n=== Chrome Registry Check ===" -ForegroundColor Green
    $chromeReg = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" -ErrorAction SilentlyContinue
    if ($chromeReg) {
        Write-Host "Chrome registry entry: $($chromeReg.'(Default)')"
    } else {
        Write-Host "No Chrome registry entry found"
    }
    
    Write-Host "`n=== Program Files Check ===" -ForegroundColor Green
    Get-ChildItem "${env:ProgramFiles}" -ErrorAction SilentlyContinue | Where-Object {$_.Name -like "*Google*" -or $_.Name -like "*Chrome*"} | Select-Object Name
    Get-ChildItem "${env:ProgramFiles(x86)}" -ErrorAction SilentlyContinue | Where-Object {$_.Name -like "*Google*" -or $_.Name -like "*Chrome*"} | Select-Object Name
}
