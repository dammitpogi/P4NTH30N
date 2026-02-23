Write-Host "=== P4NTH30N Platform Status Check ===" -ForegroundColor Cyan

$p4nth30n = Get-Process -Name "P4NTH30N" -ErrorAction SilentlyContinue
if ($p4nth30n) {
    Write-Host "[OK] P4NTH30N.exe running (PID: $($p4nth30n.Id))" -ForegroundColor Green
} else {
    Write-Host "[MISSING] P4NTH30N.exe not running" -ForegroundColor Red
}

$rag = Get-Process -Name "RAG.McpHost" -ErrorAction SilentlyContinue
if ($rag) {
    Write-Host "[OK] RAG Server running (PID: $($rag.Id))" -ForegroundColor Green
} else {
    Write-Host "[MISSING] RAG Server not running" -ForegroundColor Red
}

$mongo = Get-Process -Name "mongod" -ErrorAction SilentlyContinue
if ($mongo) {
    Write-Host "[OK] MongoDB running (PID: $($mongo.Id))" -ForegroundColor Green
} else {
    Write-Host "[MISSING] MongoDB not running" -ForegroundColor Red
}

$task = Get-ScheduledTask -TaskName "P4NTH30N-AutoStart" -ErrorAction SilentlyContinue
if ($task) {
    Write-Host "[OK] Auto-start task registered" -ForegroundColor Green
} else {
    Write-Host "[MISSING] Auto-start task not registered" -ForegroundColor Red
}

try {
    $health = Invoke-RestMethod -Uri "http://127.0.0.1:5001/health" -TimeoutSec 3
    if ($health.status -eq "healthy") {
        Write-Host "[OK] RAG health endpoint responding" -ForegroundColor Green
    } else {
        Write-Host "[WARN] RAG health endpoint responded with unexpected payload" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "[MISSING] RAG health endpoint unavailable" -ForegroundColor Red
}

$gatewayConfig = "C:\P4NTH30N\tools\mcp-development\servers\toolhive-gateway\config\servers.json"
if (Test-Path $gatewayConfig) {
    $gatewayRaw = Get-Content $gatewayConfig -Raw
    if ($gatewayRaw -match '"name"\s*:\s*"rag-server"' -and $gatewayRaw -match '"name"\s*:\s*"mongodb-p4nth30n"') {
        Write-Host "[OK] Gateway config includes rag-server and mongodb-p4nth30n" -ForegroundColor Green
    } else {
        Write-Host "[MISSING] Gateway config missing rag-server or mongodb-p4nth30n" -ForegroundColor Red
    }
} else {
    Write-Host "[MISSING] Gateway config not found" -ForegroundColor Red
}

$mongoMcpFile = "C:\P4NTH30N\tools\mcp-p4nthon\src\index.ts"
if (Test-Path $mongoMcpFile) {
    $mongoMcpRaw = Get-Content $mongoMcpFile -Raw
    $requiredTools = @("mongo_insertOne", "mongo_find", "mongo_updateOne", "mongo_insertMany", "mongo_updateMany")
    $missing = @($requiredTools | Where-Object { $mongoMcpRaw -notmatch $_ })
    if ($missing.Count -eq 0) {
        Write-Host "[OK] MongoDB MCP CRUD tools present in source" -ForegroundColor Green
    } else {
        Write-Host "[MISSING] MongoDB MCP tools missing: $($missing -join ', ')" -ForegroundColor Red
    }
}

Write-Host "`nStatus check complete." -ForegroundColor Cyan
