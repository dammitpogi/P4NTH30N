Invoke-Command -VMName "H4NDv2-Production" -Credential (New-Object PSCredential("h4ndv2.01", (ConvertTo-SecureString "MB@^@%mb" -AsPlainText -Force))) -ScriptBlock {
    Write-Host "=== Installing Google Chrome ===" -ForegroundColor Green
    
    $chromeInstaller = "C:\temp\chrome_installer.exe"
    $chromeUrl = "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi"
    
    # Create temp directory
    if (-not (Test-Path "C:\temp")) {
        New-Item -ItemType Directory -Path "C:\temp" -Force | Out-Null
    }
    
    # Download Chrome installer
    Write-Host "Downloading Chrome installer..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $chromeUrl -OutFile $chromeInstaller -UseBasicParsing -TimeoutSec 120
        Write-Host "Download complete" -ForegroundColor Green
    } catch {
        Write-Host "Download failed: $_" -ForegroundColor Red
        # Try alternative URL
        $chromeUrl = "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise.msi"
        Write-Host "Trying alternative URL..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $chromeUrl -OutFile $chromeInstaller -UseBasicParsing -TimeoutSec 120
    }
    
    # Install Chrome silently
    Write-Host "Installing Chrome (this may take a few minutes)..." -ForegroundColor Yellow
    $process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", $chromeInstaller, "/qn", "/norestart" -Wait -PassThru
    
    if ($process.ExitCode -eq 0) {
        Write-Host "Chrome installed successfully!" -ForegroundColor Green
    } else {
        Write-Host "Installation exit code: $($process.ExitCode)" -ForegroundColor Red
    }
    
    # Verify installation
    $chromePath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
    if (Test-Path $chromePath) {
        Write-Host "Chrome verified at: $chromePath" -ForegroundColor Green
        
        # Get Chrome version
        $versionInfo = (Get-Item $chromePath).VersionInfo
        Write-Host "Chrome version: $($versionInfo.ProductVersion)" -ForegroundColor Green
    } else {
        Write-Host "Chrome not found after installation" -ForegroundColor Red
    }
    
    # Cleanup
    Remove-Item $chromeInstaller -Force -ErrorAction SilentlyContinue
    Write-Host "`nInstallation complete" -ForegroundColor Green
}
