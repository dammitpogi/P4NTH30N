# MCP Configuration Verification Script
# Tests all configured MCP servers for P4NTHE0N

Write-Host "=== P4NTHE0N MCP Configuration Verification ===" -ForegroundColor Cyan

# Test 1: Chrome DevTools MCP Server
Write-Host "`n1. Testing Chrome DevTools MCP Server..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:5301/mcp" -Method GET
    Write-Host " Chrome DevTools MCP: $($response.name) v$($response.version) - $($response.status)" -ForegroundColor Green
    
    # Test tools list
    $toolsBody = '{"jsonrpc": "2.0", "method": "tools/list", "id": 1}'
    $toolsResponse = Invoke-RestMethod -Uri "http://localhost:5301/mcp" -Method POST -ContentType "application/json" -Body $toolsBody
    Write-Host " Available tools: $($toolsResponse.result.tools.Count)" -ForegroundColor Green
    $toolsResponse.result.tools | ForEach-Object { Write-Host "  - $($_.name)" -ForegroundColor Gray }
} catch {
    Write-Host " Chrome DevTools MCP failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: RAG MCP Host (if running)
Write-Host "`n2. Testing RAG MCP Host..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -ErrorAction SilentlyContinue
    if ($response) {
        Write-Host " RAG MCP Host: Status $($response.status)" -ForegroundColor Green
    } else {
        Write-Host " RAG MCP Host: Not running (start with RAG.McpHost.exe)" -ForegroundColor Yellow
    }
} catch {
    Write-Host " RAG MCP Host: Not running (start with RAG.McpHost.exe)" -ForegroundColor Yellow
}

# Test 3: Binary Files Exist
Write-Host "`n3. Checking MCP Binaries..." -ForegroundColor Yellow

$ragExe = "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe"
$toolsExe = "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe"

if (Test-Path $ragExe) {
    Write-Host " RAG.McpHost.exe exists" -ForegroundColor Green
} else {
    Write-Host " RAG.McpHost.exe missing - rebuild required" -ForegroundColor Red
}

if (Test-Path $toolsExe) {
    Write-Host " T00L5ET.exe exists" -ForegroundColor Green
} else {
    Write-Host " T00L5ET.exe missing - rebuild required" -ForegroundColor Red
}

# Test 4: Configuration Files
Write-Host "`n4. Checking Configuration Files..." -ForegroundColor Yellow

$vsConfig = "C:\P4NTH30N\.mcp\mcp.json"
$wsConfig = "C:\P4NTH30N\.windsurf\mcp_config.json"

if (Test-Path $vsConfig) {
    Write-Host " Visual Studio MCP config exists" -ForegroundColor Green
    $config = Get-Content $vsConfig | ConvertFrom-Json
    Write-Host "  - Servers configured: $($config.servers.PSObject.Properties.Count)" -ForegroundColor Gray
} else {
    Write-Host " Visual Studio MCP config missing" -ForegroundColor Red
}

if (Test-Path $wsConfig) {
    Write-Host " WindSurf MCP config exists" -ForegroundColor Green
    $config = Get-Content $wsConfig | ConvertFrom-Json
    Write-Host "  - Servers configured: $($config.mcpServers.PSObject.Properties.Count)" -ForegroundColor Gray
} else {
    Write-Host " WindSurf MCP config missing" -ForegroundColor Red
}

# Test 5: MongoDB Connection
Write-Host "`n5. Testing MongoDB Connection..." -ForegroundColor Yellow
try {
    $result = Test-NetConnection -ComputerName "192.168.56.1" -Port 27017 -WarningAction SilentlyContinue
    if ($result.TcpTestSucceeded) {
        Write-Host " MongoDB accessible at 192.168.56.1:27017" -ForegroundColor Green
    } else {
        Write-Host " MongoDB not accessible" -ForegroundColor Red
    }
} catch {
    Write-Host " MongoDB connection failed" -ForegroundColor Red
}

# Test 6: Chrome CDP Connection
Write-Host "`n6. Testing Chrome CDP..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:9222/json/version" -Method GET -ErrorAction SilentlyContinue
    if ($response) {
        Write-Host " Chrome CDP accessible: $($response.Browser)" -ForegroundColor Green
    } else {
        Write-Host " Chrome CDP not accessible - start Chrome with --remote-debugging-port=9222" -ForegroundColor Yellow
    }
} catch {
    Write-Host " Chrome CDP not accessible - start Chrome with --remote-debugging-port=9222" -ForegroundColor Yellow
}

Write-Host "`n=== Verification Complete ===" -ForegroundColor Cyan
Write-Host "Next steps:" -ForegroundColor White
Write-Host "1. Start Visual Studio Community and load P4NTHE0N.slnx" -ForegroundColor Gray
Write-Host "2. Use Ctrl+I to open AI chat and test MCP functionality" -ForegroundColor Gray
Write-Host "3. For WindSurf, open workspace and use AI chat features" -ForegroundColor Gray
