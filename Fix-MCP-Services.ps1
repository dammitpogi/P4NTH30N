# MCP Services Fix Script
# Fixes all identified issues with P4NTHE0N MCP services

Write-Host "=== P4NTHE0N MCP Services Fix ===" -ForegroundColor Cyan

# Fix 1: Ensure RAG is running properly
Write-Host "`n1. Fixing RAG MCP Host..." -ForegroundColor Yellow
try {
    $ragJob = Get-Job -Name "P4NTHE0N-RAG-MCP-Host" -ErrorAction SilentlyContinue
    if ($ragJob -and $ragJob.State -eq "Running") {
        try {
            $ragHealth = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 3
            Write-Host "✓ RAG MCP Host: Running and healthy" -ForegroundColor Green
        } catch {
            Write-Host "⚠ RAG health check failed, restarting..." -ForegroundColor Yellow
            & "c:\P4NTH30N\Manage-RAG-Background.ps1" -Restart
            Start-Sleep -Seconds 3
            $ragHealth = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 3
            Write-Host "✓ RAG MCP Host: Restarted and healthy" -ForegroundColor Green
        }
    } else {
        Write-Host "Starting RAG MCP Host..." -ForegroundColor Gray
        & "c:\P4NTH30N\Manage-RAG-Background.ps1" -Start
        Start-Sleep -Seconds 3
        Write-Host "✓ RAG MCP Host: Started" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ RAG MCP Host: Failed to fix" -ForegroundColor Red
}

# Fix 2: Ensure Chrome DevTools is running
Write-Host "`n2. Fixing Chrome DevTools MCP..." -ForegroundColor Yellow
try {
    $cdpHealth = Invoke-RestMethod -Uri "http://localhost:5301/mcp" -Method GET -TimeoutSec 3
    if ($cdpHealth.status -eq "ready") {
        Write-Host "✓ Chrome DevTools MCP: Running and ready" -ForegroundColor Green
    } else {
        Write-Host "⚠ Chrome DevTools MCP: Not ready, restarting..." -ForegroundColor Yellow
        $cdpProcess = Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*chrome-devtools-mcp*"}
        if ($cdpProcess) { 
            Stop-Process -Id $cdpProcess.Id -Force 
            Write-Host "Stopped existing process" -ForegroundColor Gray
        }
        Start-Sleep -Seconds 2
        Start-Process -FilePath "node" -ArgumentList @("c:\P4NTH30N\chrome-devtools-mcp\server.js", "http") -WindowStyle Hidden
        Start-Sleep -Seconds 3
        $cdpHealth = Invoke-RestMethod -Uri "http://localhost:5301/mcp" -Method GET -TimeoutSec 3
        Write-Host "✓ Chrome DevTools MCP: Restarted and ready" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ Chrome DevTools MCP: Not running, starting..." -ForegroundColor Yellow
    Start-Process -FilePath "node" -ArgumentList @("c:\P4NTH30N\chrome-devtools-mcp\server.js", "http") -WindowStyle Hidden
    Start-Sleep -Seconds 3
    try {
        $cdpHealth = Invoke-RestMethod -Uri "http://localhost:5301/mcp" -Method GET -TimeoutSec 3
        Write-Host "✓ Chrome DevTools MCP: Started and ready" -ForegroundColor Green
    } catch {
        Write-Host "✗ Chrome DevTools MCP: Failed to start" -ForegroundColor Red
    }
}

# Fix 3: Ensure P4NTHE0N Tools is running
Write-Host "`n3. Fixing P4NTHE0N Tools..." -ForegroundColor Yellow
$toolsBinary = "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe"
if (Test-Path $toolsBinary) {
    $toolsProcess = Get-Process -Name "T00L5ET" -ErrorAction SilentlyContinue
    if ($toolsProcess) {
        Write-Host "✓ P4NTHE0N Tools: Already running (PID: $($toolsProcess.Id))" -ForegroundColor Green
    } else {
        Write-Host "Starting P4NTHE0N Tools..." -ForegroundColor Gray
        $env:MONGODB_HOST = "localhost:27017"
        $env:CHROME_CDP_PORT = "9222"
        
        # Start in a new window to see output
        Start-Process -FilePath $toolsBinary -ArgumentList @("--mcp", "--workspace", "C:\P4NTH30N")
        Start-Sleep -Seconds 3
        
        $toolsProcess = Get-Process -Name "T00L5ET" -ErrorAction SilentlyContinue
        if ($toolsProcess) {
            Write-Host "✓ P4NTHE0N Tools: Started (PID: $($toolsProcess.Id))" -ForegroundColor Green
        } else {
            Write-Host "⚠ P4NTHE0N Tools: Started but process not found" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "✗ P4NTHE0N Tools: Binary not found at $toolsBinary" -ForegroundColor Red
    Write-Host "Please build the project:" -ForegroundColor Yellow
    Write-Host "dotnet publish `"c:\P4NTH30N\T00L5ET\T00L5ET.csproj`" -c Release -r win-x64 --self-contained" -ForegroundColor Gray
}

# Fix 4: Verify MongoDB connectivity
Write-Host "`n4. Verifying MongoDB connectivity..." -ForegroundColor Yellow
try {
    $mongoResult = Test-NetConnection -ComputerName "localhost" -Port 27017 -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($mongoResult) {
        Write-Host "✓ MongoDB: Connected (localhost:27017)" -ForegroundColor Green
    } else {
        Write-Host "✗ MongoDB: Not connected" -ForegroundColor Red
        $mongoService = Get-Service -Name "MongoDB" -ErrorAction SilentlyContinue
        if ($mongoService) {
            Write-Host "MongoDB service status: $($mongoService.Status)" -ForegroundColor Gray
            if ($mongoService.Status -ne "Running") {
                Write-Host "Starting MongoDB service..." -ForegroundColor Yellow
                Start-Service -Name "MongoDB" -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 3
                $mongoService = Get-Service -Name "MongoDB" -ErrorAction SilentlyContinue
                Write-Host "MongoDB service status: $($mongoService.Status)" -ForegroundColor Gray
            }
        }
    }
} catch {
    Write-Host "✗ MongoDB: Connection test failed" -ForegroundColor Red
}

# Final verification
Write-Host "`n=== Final Verification ===" -ForegroundColor Cyan

$allGood = $true

# Check RAG
try {
    $ragHealth = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 3
    Write-Host "✓ RAG MCP Host: $($ragHealth.status) (Port $($ragHealth.port))" -ForegroundColor Green
} catch {
    Write-Host "✗ RAG MCP Host: Failed health check" -ForegroundColor Red
    $allGood = $false
}

# Check Chrome DevTools
try {
    $cdpHealth = Invoke-RestMethod -Uri "http://localhost:5301/mcp" -Method GET -TimeoutSec 3
    Write-Host "✓ Chrome DevTools MCP: $($cdpHealth.status) (Port 5301)" -ForegroundColor Green
} catch {
    Write-Host "✗ Chrome DevTools MCP: Failed health check" -ForegroundColor Red
    $allGood = $false
}

# Check P4NTHE0N Tools
$toolsProcess = Get-Process -Name "T00L5ET" -ErrorAction SilentlyContinue
if ($toolsProcess) {
    Write-Host "✓ P4NTHE0N Tools: Running (PID: $($toolsProcess.Id))" -ForegroundColor Green
} else {
    Write-Host "✗ P4NTHE0N Tools: Not running" -ForegroundColor Red
    $allGood = $false
}

# Check MongoDB
try {
    $mongoResult = Test-NetConnection -ComputerName "localhost" -Port 27017 -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($mongoResult) {
        Write-Host "✓ MongoDB: Connected (localhost:27017)" -ForegroundColor Green
    } else {
        Write-Host "✗ MongoDB: Not connected" -ForegroundColor Red
        $allGood = $false
    }
} catch {
    Write-Host "✗ MongoDB: Connection test failed" -ForegroundColor Red
    $allGood = $false
}

Write-Host "`n=== Fix Summary ===" -ForegroundColor Cyan
if ($allGood) {
    Write-Host "🎉 ALL SYSTEMS OPERATIONAL" -ForegroundColor Green
    Write-Host "Your P4NTHE0N MCP services are fully functional!" -ForegroundColor White
} else {
    Write-Host "⚠ SOME ISSUES REMAIN" -ForegroundColor Yellow
    Write-Host "Check the output above for details." -ForegroundColor Gray
}

Write-Host "`nNext steps:" -ForegroundColor White
Write-Host "1. Open Visual Studio Community with P4NTHE0N.slnx" -ForegroundColor Gray
Write-Host "2. Use Ctrl+I to open AI chat" -ForegroundColor Gray
Write-Host "3. Test with: 'What MCP servers are available?'" -ForegroundColor Gray
