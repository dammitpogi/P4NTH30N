# Check Chrome on HOST (not VM)
Write-Host "=== Checking Chrome on HOST Machine ===" -ForegroundColor Green

# Check Chrome processes on host
$chromeProcs = Get-Process | Where-Object {$_.ProcessName -like "*chrome*"}
Write-Host "Chrome Processes: $($chromeProcs.Count)" -ForegroundColor Yellow
$chromeProcs | Select-Object ProcessName, Id, StartTime | Format-Table -AutoSize

# Get Chrome command lines
Write-Host "`n=== Chrome Command Lines ===" -ForegroundColor Green
Get-WmiObject Win32_Process | Where-Object {$_.Name -like "*chrome*"} | ForEach-Object {
    Write-Host "PID: $($_.ProcessId) - $($_.CommandLine)" -ForegroundColor Yellow
}

# Check if remote debugging is enabled
Write-Host "`n=== Remote Debugging Check ===" -ForegroundColor Green
$debuggingEnabled = Get-NetTCPConnection -LocalPort 9222 -ErrorAction SilentlyContinue
if ($debuggingEnabled) {
    Write-Host "Port 9222 is LISTENING" -ForegroundColor Green
    $debuggingEnabled | Select-Object LocalAddress, LocalPort, State, OwningProcess | Format-Table -AutoSize
} else {
    Write-Host "Port 9222 is NOT listening" -ForegroundColor Red
}

# Check RUL3S extension
Write-Host "`n=== RUL3S Extension Check ===" -ForegroundColor Green
$extPaths = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Extensions",
    "C:\RUL3S"
)

foreach ($path in $extPaths) {
    if (Test-Path $path) {
        Write-Host "Found: $path" -ForegroundColor Yellow
        Get-ChildItem $path -ErrorAction SilentlyContinue | Select-Object Name, LastWriteTime | Format-Table -AutoSize
    }
}

# Test CDP endpoint
Write-Host "`n=== CDP Endpoint Test ===" -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9222/json/version" -UseBasicParsing -TimeoutSec 5
    Write-Host "CDP Version Endpoint: OK" -ForegroundColor Green
    Write-Host $response.Content -ForegroundColor Yellow
} catch {
    Write-Host "CDP Version Endpoint: FAILED - $_" -ForegroundColor Red
}

try {
    $response = Invoke-WebRequest -Uri "http://localhost:9222/json/list" -UseBasicParsing -TimeoutSec 5
    Write-Host "`nCDP List Endpoint: OK" -ForegroundColor Green
    $pages = $response.Content | ConvertFrom-Json
    Write-Host "Open pages: $($pages.Count)" -ForegroundColor Yellow
    $pages | Select-Object title, url | Format-Table -AutoSize
} catch {
    Write-Host "CDP List Endpoint: FAILED - $_" -ForegroundColor Red
}
