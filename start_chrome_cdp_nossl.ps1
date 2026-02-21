$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$userDataDir = Join-Path $env.TEMP "chrome_debug_9222"
New-Item -ItemType Directory -Path $userDataDir -Force | Out-Null

$args = @(
    "--remote-debugging-port=9222",
    "--remote-debugging-address=127.0.0.1",
    "--incognito",
    "--no-first-run",
    "--ignore-certificate-errors",
    "--user-data-dir=`"$userDataDir`""
)

$p = Start-Process -FilePath $chrome -ArgumentList $args -PassThru
Start-Sleep 5

Write-Host "Chrome PID: $($p.Id)"
Write-Host "Chrome Running: $(-not $p.HasExited)"

# Check CDP
$connections = netstat -ano | Select-String "9222"
Write-Host "Port 9222:"
$connections
