# MCP Services Audit and Fix Script
# Comprehensive audit of all P4NTHE0N MCP services with automatic fixes

Write-Host "=== P4NTHE0N MCP Services Audit ===" -ForegroundColor Cyan

$issues = @()
$fixes = @()

# Audit 1: RAG MCP Host Background Job
Write-Host "`n1. Auditing RAG MCP Host Background Job..." -ForegroundColor Yellow
try {
    $ragJob = Get-Job -Name "P4NTHE0N-RAG-MCP-Host" -ErrorAction SilentlyContinue
    if ($ragJob -and $ragJob.State -eq "Running") {
        try {
            $ragHealth = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 3
            Write-Host "✓ RAG MCP Host: Running and healthy" -ForegroundColor Green
        } catch {
            Write-Host "⚠ RAG MCP Host: Job running but health check failed" -ForegroundColor Yellow
            $issues += "RAG health check failed"
            $fixes += "Restart RAG background job"
        }
    } else {
        Write-Host "✗ RAG MCP Host: Not running" -ForegroundColor Red
        $issues += "RAG MCP Host not running"
        $fixes += "Start RAG background job"
    }
} catch {
    Write-Host "✗ RAG MCP Host: Error checking status" -ForegroundColor Red
    $issues += "RAG MCP Host status error"
    $fixes += "Start RAG background job"
}

# Audit 2: Chrome DevTools MCP Server
Write-Host "`n2. Auditing Chrome DevTools MCP Server..." -ForegroundColor Yellow
$cdpProcess = Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*chrome-devtools-mcp*"}
if ($cdpProcess) {
    try {
        $cdpHealth = Invoke-RestMethod -Uri "http://localhost:5301/mcp" -Method GET -TimeoutSec 3
        if ($cdpHealth.status -eq "ready") {
            Write-Host "✓ Chrome DevTools MCP: Running and ready" -ForegroundColor Green
        } else {
            Write-Host "⚠ Chrome DevTools MCP: Running but not ready" -ForegroundColor Yellow
            $issues += "Chrome DevTools not ready"
            $fixes += "Restart Chrome DevTools MCP"
        }
    } catch {
        Write-Host "✗ Chrome DevTools MCP: Running but health check failed" -ForegroundColor Red
        $issues += "Chrome DevTools health check failed"
        $fixes += "Restart Chrome DevTools MCP"
    }
} else {
    Write-Host "✗ Chrome DevTools MCP: Not running" -ForegroundColor Red
    $issues += "Chrome DevTools MCP not running"
    $fixes += "Start Chrome DevTools MCP"
}

# Audit 3: P4NTHE0N Tools Service
Write-Host "`n3. Auditing P4NTHE0N Tools Service..." -ForegroundColor Yellow
$toolsProcess = Get-Process -Name "T00L5ET" -ErrorAction SilentlyContinue
if ($toolsProcess) {
    Write-Host "✓ P4NTHE0N Tools: Running (PID: $($toolsProcess.Id))" -ForegroundColor Green
} else {
    Write-Host "✗ P4NTHE0N Tools: Not running" -ForegroundColor Red
    $issues += "P4NTHE0N Tools not running"
    $fixes += "Start P4NTHE0N Tools"
}

# Audit 4: MongoDB Connectivity
Write-Host "`n4. Auditing MongoDB Connectivity..." -ForegroundColor Yellow
try {
    $mongoResult = Test-NetConnection -ComputerName "localhost" -Port 27017 -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($mongoResult) {
        Write-Host "✓ MongoDB: Connected (localhost:27017)" -ForegroundColor Green
    } else {
        Write-Host "✗ MongoDB: Not connected" -ForegroundColor Red
        $issues += "MongoDB not connected"
        $fixes += "Check MongoDB service"
    }
} catch {
    Write-Host "✗ MongoDB: Connection test failed" -ForegroundColor Red
    $issues += "MongoDB connection test failed"
    $fixes += "Check MongoDB service"
}

# Audit 5: Configuration Files
Write-Host "`n5. Auditing Configuration Files..." -ForegroundColor Yellow
$configFiles = @(
    @{Path = "c:\P4NTH30N\.mcp\mcp.json"; Name = "Visual Studio MCP"},
    @{Path = "c:\P4NTH30N\.windsurf\mcp_config.json"; Name = "WindSurf MCP"}
)

foreach ($config in $configFiles) {
    if (Test-Path $config.Path) {
        $content = Get-Content $config.Path -Raw
        if ($content -match "localhost:27017") {
            Write-Host "✓ $($config.Name): Configured for localhost:27017" -ForegroundColor Green
        } else {
            Write-Host "⚠ $($config.Name): Not configured for localhost:27017" -ForegroundColor Yellow
            $issues += "$($config.Name) configuration issue"
            $fixes += "Update $($config.Name) configuration"
        }
    } else {
        Write-Host "✗ $($config.Name): Configuration file missing" -ForegroundColor Red
        $issues += "$($config.Name) config missing"
        $fixes += "Create $($config.Name) configuration"
    }
}

# Audit 6: Binary Files
Write-Host "`n6. Auditing Binary Files..." -ForegroundColor Yellow
$binaries = @(
    @{Path = "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe"; Name = "RAG.McpHost.exe"},
    @{Path = "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe"; Name = "T00L5ET.exe"}
)

foreach ($binary in $binaries) {
    if (Test-Path $binary.Path) {
        Write-Host "✓ $($binary.Name): Binary exists" -ForegroundColor Green
    } else {
        Write-Host "✗ $($binary.Name): Binary missing" -ForegroundColor Red
        $issues += "$($binary.Name) binary missing"
        $fixes += "Build $($binary.Name) project"
    }
}

# Summary and Fixes
Write-Host "`n=== Audit Summary ===" -ForegroundColor Cyan

if ($issues.Count -eq 0) {
    Write-Host "✅ ALL SYSTEMS OPERATIONAL - No issues found" -ForegroundColor Green
    exit 0
} else {
    Write-Host "⚠ ISSUES FOUND: $($issues.Count)" -ForegroundColor Yellow
    Write-Host "`nIssues:" -ForegroundColor Red
    for ($i = 0; $i -lt $issues.Count; $i++) {
        Write-Host "  $($i + 1). $($issues[$i])" -ForegroundColor Red
    }
    
    Write-Host "`nRecommended Fixes:" -ForegroundColor Green
    for ($i = 0; $i -lt $fixes.Count; $i++) {
        Write-Host "  $($i + 1). $($fixes[$i])" -ForegroundColor Gray
    }
    
    # Ask if user wants to apply fixes
    Write-Host "`nApply automatic fixes? (y/n): " -ForegroundColor Yellow -NoNewline
    $response = Read-Host
    if ($response -eq "y" -or $response -eq "Y") {
        Write-Host "`nApplying fixes..." -ForegroundColor Yellow
        
        # Fix 1: Start RAG if needed
        if ($issues -contains "RAG MCP Host not running") {
            Write-Host "Starting RAG MCP Host..." -ForegroundColor Gray
            & "c:\P4NTH30N\Manage-RAG-Background.ps1" -Start
        }
        
        # Fix 2: Start Chrome DevTools if needed
        if ($issues -contains "Chrome DevTools MCP not running") {
            Write-Host "Starting Chrome DevTools MCP..." -ForegroundColor Gray
            Start-Process -FilePath "node" -ArgumentList @("c:\P4NTH30N\chrome-devtools-mcp\server.js", "http") -WindowStyle Hidden
            Start-Sleep -Seconds 3
        }
        
        # Fix 3: Start P4NTHE0N Tools if needed
        if ($issues -contains "P4NTHE0N Tools not running") {
            Write-Host "Starting P4NTHE0N Tools..." -ForegroundColor Gray
            $env:MONGODB_HOST = "localhost:27017"
            $env:CHROME_CDP_PORT = "9222"
            Start-Process -FilePath "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe" -ArgumentList @("--mcp", "--workspace", "C:\P4NTH30N") -WindowStyle Minimized
            Start-Sleep -Seconds 2
        }
        
        # Fix 4: Restart problematic services
        if ($issues -contains "RAG health check failed") {
            Write-Host "Restarting RAG MCP Host..." -ForegroundColor Gray
            & "c:\P4NTH30N\Manage-RAG-Background.ps1" -Restart
        }
        
        if ($issues -contains "Chrome DevTools health check failed" -or $issues -contains "Chrome DevTools not ready") {
            Write-Host "Restarting Chrome DevTools MCP..." -ForegroundColor Gray
            $cdpProcess = Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*chrome-devtools-mcp*"}
            if ($cdpProcess) { Stop-Process -Id $cdpProcess.Id -Force }
            Start-Sleep -Seconds 2
            Start-Process -FilePath "node" -ArgumentList @("c:\P4NTH30N\chrome-devtools-mcp\server.js", "http") -WindowStyle Hidden
            Start-Sleep -Seconds 3
        }
        
        Write-Host "`n✅ Fixes applied. Running verification..." -ForegroundColor Green
        Start-Sleep -Seconds 5
        
        # Re-run verification
        Write-Host "`n=== Post-Fix Verification ===" -ForegroundColor Cyan
        
        # Check RAG
        $ragJob = Get-Job -Name "P4NTHE0N-RAG-MCP-Host" -ErrorAction SilentlyContinue
        if ($ragJob -and $ragJob.State -eq "Running") {
            try {
                $ragHealth = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 3
                Write-Host "✓ RAG MCP Host: Fixed and healthy" -ForegroundColor Green
            } catch {
                Write-Host "⚠ RAG MCP Host: Still has issues" -ForegroundColor Yellow
            }
        }
        
        # Check Chrome DevTools
        $cdpProcess = Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*chrome-devtools-mcp*"}
        if ($cdpProcess) {
            try {
                $cdpHealth = Invoke-RestMethod -Uri "http://localhost:5301/mcp" -Method GET -TimeoutSec 3
                Write-Host "✓ Chrome DevTools MCP: Fixed and ready" -ForegroundColor Green
            } catch {
                Write-Host "⚠ Chrome DevTools MCP: Still has issues" -ForegroundColor Yellow
            }
        }
        
        # Check P4NTHE0N Tools
        $toolsProcess = Get-Process -Name "T00L5ET" -ErrorAction SilentlyContinue
        if ($toolsProcess) {
            Write-Host "✓ P4NTHE0N Tools: Fixed and running" -ForegroundColor Green
        }
        
    } else {
        Write-Host "`nManual fixes required. See recommendations above." -ForegroundColor Yellow
    }
    
    exit 1
}
