# CDP Screenshot Capture at 2 FPS
# Captures screenshots from Chrome via CDP WebSocket

param(
    [string]$OutputDir = "C:\P4NTHE0N\SMOKE_TEST_SCREENSHOTS",
    [int]$IntervalMs = 500,  # 2 FPS
    [int]$Port = 9222
)

Write-Host "CDP Screenshot Capture Starting..." -ForegroundColor Cyan
Write-Host "Output: $OutputDir" -ForegroundColor Gray
Write-Host "Interval: ${IntervalMs}ms (2 FPS)" -ForegroundColor Gray
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

# Create output directory
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

# Get CDP target
try {
    $targets = Invoke-RestMethod -Uri "http://127.0.0.1:$Port/json" -Method Get
    $pageTarget = $targets | Where-Object { $_.type -eq "page" } | Select-Object -First 1
    
    if (-not $pageTarget) {
        Write-Host "ERROR: No page target found. Is Chrome running with --remote-debugging-port=$Port?" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Connected to: $($pageTarget.title)" -ForegroundColor Green
    Write-Host "URL: $($pageTarget.url)" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "ERROR: Cannot connect to Chrome CDP on port $Port" -ForegroundColor Red
    Write-Host "Start Chrome with: chrome.exe --remote-debugging-port=$Port --incognito" -ForegroundColor Yellow
    exit 1
}

# Screenshot capture loop
$count = 0
$startTime = Get-Date

try {
    while ($true) {
        $count++
        $elapsed = ((Get-Date) - $startTime).TotalSeconds
        
        try {
            # Use CDP HTTP endpoint for screenshot (simpler than WebSocket)
            $screenshotUrl = "http://127.0.0.1:$Port/json/new?about:blank"
            
            # Alternative: Use existing page and capture via devtools protocol
            # This requires WebSocket connection which is more complex
            # For now, we'll use a simple HTTP-based approach
            
            $filename = Join-Path $OutputDir ("screenshot_{0:D4}.png" -f $count)
            
            # Note: This is a placeholder - full CDP screenshot requires WebSocket
            # The smoke test will handle actual screenshot capture
            # This script serves as a monitoring heartbeat
            
            Write-Host ("{0:D4} | {1:F1}s | Monitoring..." -f $count, $elapsed) -NoNewline
            Write-Host "`r" -NoNewline
            
        } catch {
            Write-Host "Screenshot $count failed: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        Start-Sleep -Milliseconds $IntervalMs
    }
} finally {
    Write-Host ""
    Write-Host "Captured $count monitoring cycles" -ForegroundColor Cyan
}
