# FireKirin Smoke Test with Screenshot Capture
# DECISION_099 - Blocking DECISION_047 burn-in

param(
    [string]$Username = "",
    [string]$Password = "",
    [int]$ScreenshotIntervalMs = 500  # 2 FPS
)

Write-Host "=== FireKirin Smoke Test with Screenshot Capture ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Query MongoDB for best credential
Write-Host "[1/6] Querying MongoDB for FireKirin credentials..." -ForegroundColor Yellow

$mongoQuery = @"
use P4NTH30N
db.CRED3N7IAL.find({Game: 'FireKirin'}).sort({Balance: -1}).limit(10).toArray()
"@

$queryFile = "C:\P4NTH30N\temp-query.js"
$mongoQuery | Out-File -FilePath $queryFile -Encoding UTF8

$mongoResult = & mongosh mongodb://localhost:27017/ --quiet --file $queryFile 2>&1 | Out-String
Remove-Item $queryFile -ErrorAction SilentlyContinue

Write-Host "MongoDB query result:" -ForegroundColor Gray
Write-Host $mongoResult

# Parse credentials from MongoDB result
if ($mongoResult -match '"Username"\s*:\s*"([^"]+)".*"Password"\s*:\s*"([^"]+)".*"Balance"\s*:\s*([0-9.]+)') {
    if ([string]::IsNullOrEmpty($Username)) {
        $Username = $matches[1]
        $Password = $matches[2]
        $Balance = $matches[3]
        Write-Host "Found credential: $Username (Balance: $Balance)" -ForegroundColor Green
    }
}

# Fallback to step-config.json credentials if MongoDB query failed
if ([string]::IsNullOrEmpty($Username)) {
    Write-Host "MongoDB query failed - using step-config.json credentials" -ForegroundColor Yellow
    $stepConfig = Get-Content "C:\P4NTH30N\H4ND\tools\recorder\step-config.json" | ConvertFrom-Json
    $Username = $stepConfig.metadata.credentials.firekirin.username
    $Password = $stepConfig.metadata.credentials.firekirin.password
    Write-Host "Using: $Username" -ForegroundColor Cyan
}

# Step 2: Check Chrome CDP
Write-Host ""
Write-Host "[2/6] Checking Chrome CDP on port 9222..." -ForegroundColor Yellow
try {
    $cdpVersion = Invoke-RestMethod -Uri "http://127.0.0.1:9222/json/version" -TimeoutSec 2
    Write-Host "Chrome CDP connected: $($cdpVersion.'Browser')" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Chrome CDP not running on port 9222" -ForegroundColor Red
    Write-Host "Start Chrome with: chrome.exe --remote-debugging-port=9222 --incognito" -ForegroundColor Yellow
    exit 1
}

# Step 3: Create screenshot directory
Write-Host ""
Write-Host "[3/6] Creating screenshot directory..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$screenshotDir = "C:\P4NTH30N\SMOKE_TEST_SCREENSHOTS\$timestamp"
New-Item -ItemType Directory -Path $screenshotDir -Force | Out-Null
Write-Host "Screenshots will be saved to: $screenshotDir" -ForegroundColor Green

# Step 4: Note about screenshot capture
Write-Host ""
Write-Host "[4/6] Screenshot capture will be handled by smoke test..." -ForegroundColor Yellow
Write-Host "Screenshots will be saved to: $screenshotDir" -ForegroundColor Cyan
Write-Host "Note: Expecting test to fail - we'll capture the failure point" -ForegroundColor Yellow

# Step 5: Run smoke test
Write-Host ""
Write-Host "[5/6] Executing smoke test..." -ForegroundColor Yellow
Write-Host "Command: H4ND.SmokeTest.exe --username $Username --password [REDACTED]" -ForegroundColor Gray
Write-Host ""

$smokeTestPath = "C:\P4NTH30N\H4ND\SmokeTest\bin\Release\net10.0-windows7.0\H4ND.SmokeTest.exe"

if (-not (Test-Path $smokeTestPath)) {
    Write-Host "ERROR: Smoke test executable not found at: $smokeTestPath" -ForegroundColor Red
    exit 1
}

$smokeTestProcess = Start-Process -FilePath $smokeTestPath `
    -ArgumentList "--username", $Username, "--password", $Password `
    -NoNewWindow -PassThru -Wait

$exitCode = $smokeTestProcess.ExitCode

# Step 6: Analyze results
Write-Host ""
Write-Host "[6/6] Analyzing results..." -ForegroundColor Yellow

$screenshotCount = (Get-ChildItem -Path $screenshotDir -Filter "*.png" -ErrorAction SilentlyContinue).Count
Write-Host "Screenshots captured: $screenshotCount" -ForegroundColor Cyan

# Results
Write-Host ""
Write-Host "=== SMOKE TEST RESULTS ===" -ForegroundColor Cyan
Write-Host "Exit Code: $exitCode" -ForegroundColor $(if ($exitCode -eq 0) { "Green" } else { "Red" })
Write-Host "Screenshots: $screenshotDir" -ForegroundColor Cyan
Write-Host "Credential Used: $Username" -ForegroundColor Cyan

if ($exitCode -eq 0) {
    Write-Host ""
    Write-Host "✓ SMOKE TEST PASSED" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "✗ SMOKE TEST FAILED" -ForegroundColor Red
    Write-Host "Review screenshots to identify failure point" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next: Review screenshots in $screenshotDir" -ForegroundColor Yellow
Write-Host "Then: Map navigation path using step-config.json" -ForegroundColor Yellow

exit $exitCode
