# FireKirin Smoke Test Runner
# DECISION_099 - Execute smoke test with proper credentials

param(
    [string]$Username = "",
    [string]$Password = ""
)

Write-Host "=== FireKirin Smoke Test ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Query MongoDB for credentials
Write-Host "[1/5] Querying MongoDB for FireKirin credentials..." -ForegroundColor Yellow

$mongoScript = @"
use P4NTHE0N
db.CRED3N7IAL.find({Game: 'FireKirin'}).sort({Balance: -1}).limit(10).forEach(function(doc) {
    print('Username: ' + doc.Username + ' | Balance: ' + doc.Balance + ' | Enabled: ' + doc.Enabled + ' | Locked: ' + doc.Locked);
});
"@

$queryFile = "C:\P4NTHE0N\temp-mongo-query.js"
$mongoScript | Out-File -FilePath $queryFile -Encoding UTF8 -NoNewline

Write-Host "Executing MongoDB query..." -ForegroundColor Gray
$mongoOutput = & mongosh mongodb://localhost:27017/ --quiet --file $queryFile 2>&1 | Out-String
Remove-Item $queryFile -ErrorAction SilentlyContinue

Write-Host $mongoOutput

# Use step-config.json credentials as fallback
if ([string]::IsNullOrEmpty($Username)) {
    Write-Host "Using credentials from step-config.json" -ForegroundColor Yellow
    $stepConfig = Get-Content "C:\P4NTHE0N\H4ND\tools\recorder\step-config.json" | ConvertFrom-Json
    $Username = $stepConfig.metadata.credentials.firekirin.username
    $Password = $stepConfig.metadata.credentials.firekirin.password
    Write-Host "Credential: $Username" -ForegroundColor Cyan
}

# Step 2: Check Chrome CDP
Write-Host ""
Write-Host "[2/5] Checking Chrome CDP..." -ForegroundColor Yellow
try {
    $cdpVersion = Invoke-RestMethod -Uri "http://127.0.0.1:9222/json/version" -TimeoutSec 2
    Write-Host "Chrome CDP: $($cdpVersion.'Browser')" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Chrome CDP not running on port 9222" -ForegroundColor Red
    Write-Host "Start Chrome with: chrome.exe --remote-debugging-port=9222 --incognito" -ForegroundColor Yellow
    exit 1
}

# Step 3: Create screenshot directory
Write-Host ""
Write-Host "[3/5] Creating screenshot directory..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$screenshotDir = "C:\P4NTHE0N\SMOKE_TEST_SCREENSHOTS\$timestamp"
New-Item -ItemType Directory -Path $screenshotDir -Force | Out-Null
Write-Host "Directory: $screenshotDir" -ForegroundColor Green

# Step 4: Run smoke test
Write-Host ""
Write-Host "[4/5] Executing smoke test..." -ForegroundColor Yellow
Write-Host "Credential: $Username" -ForegroundColor Gray
Write-Host "Note: Expecting failure at balance verification" -ForegroundColor Yellow
Write-Host ""

$smokeTestPath = "C:\P4NTHE0N\H4ND\SmokeTest\bin\Release\net10.0-windows7.0\H4ND.SmokeTest.exe"

if (-not (Test-Path $smokeTestPath)) {
    Write-Host "ERROR: Smoke test not found at: $smokeTestPath" -ForegroundColor Red
    exit 1
}

$smokeTestProcess = Start-Process -FilePath $smokeTestPath -ArgumentList "--username", $Username, "--password", $Password -NoNewWindow -PassThru -Wait

$exitCode = $smokeTestProcess.ExitCode

# Step 5: Results
Write-Host ""
Write-Host "[5/5] Results" -ForegroundColor Yellow
Write-Host "Exit Code: $exitCode" -ForegroundColor $(if ($exitCode -eq 0) { "Green" } else { "Red" })
Write-Host "Screenshots: $screenshotDir" -ForegroundColor Cyan
Write-Host "Credential: $Username" -ForegroundColor Cyan

if ($exitCode -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS: Smoke test passed" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "EXPECTED: Smoke test failed (balance = 0)" -ForegroundColor Yellow
    Write-Host "Next: Find credential with balance > 0 in MongoDB" -ForegroundColor Yellow
}

exit $exitCode
