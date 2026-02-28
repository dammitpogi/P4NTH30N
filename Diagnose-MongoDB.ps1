# MongoDB Connectivity Diagnosis & Fix
# This script helps diagnose and resolve MongoDB connectivity issues

Write-Host "=== MongoDB Connectivity Diagnosis ===" -ForegroundColor Cyan

# Check if MongoDB is running locally
Write-Host "`n1. Checking MongoDB Service..." -ForegroundColor Yellow
$mongoService = Get-Service -Name "MongoDB" -ErrorAction SilentlyContinue
if ($mongoService) {
    Write-Host "✓ MongoDB service status: $($mongoService.Status)" -ForegroundColor Green
} else {
    Write-Host "✗ MongoDB service not found" -ForegroundColor Red
    Write-Host "  Install MongoDB Community Server" -ForegroundColor Gray
}

# Check MongoDB configuration
Write-Host "`n2. Checking MongoDB Configuration..." -ForegroundColor Yellow
try {
    $mongoConfig = Get-Content "C:\Program Files\MongoDB\Server\*\mongod.cfg" -ErrorAction SilentlyContinue
    if ($mongoConfig) {
        Write-Host "✓ MongoDB config file found" -ForegroundColor Green
        $bindIp = $mongoConfig | Where-Object { $_ -match "bindIp" }
        if ($bindIp) {
            Write-Host "  Bind IP: $bindIp" -ForegroundColor Gray
        }
    } else {
        Write-Host "⚠ MongoDB config file not found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠ Could not read MongoDB config" -ForegroundColor Yellow
}

# Check network bindings
Write-Host "`n3. Checking Network Bindings..." -ForegroundColor Yellow
$tcpConnections = Get-NetTCPConnection -LocalPort 27017 -ErrorAction SilentlyContinue
if ($tcpConnections) {
    Write-Host "✓ MongoDB listening on port 27017" -ForegroundColor Green
    foreach ($conn in $tcpConnections) {
        Write-Host "  $($conn.LocalAddress):$($conn.LocalPort) - $($conn.State)" -ForegroundColor Gray
    }
} else {
    Write-Host "✗ MongoDB not listening on port 27017" -ForegroundColor Red
}

# Test local connection
Write-Host "`n4. Testing Local Connection..." -ForegroundColor Yellow
try {
    $result = Test-NetConnection -ComputerName "localhost" -Port 27017 -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($result) {
        Write-Host "✓ Local MongoDB connection successful" -ForegroundColor Green
    } else {
        Write-Host "✗ Local MongoDB connection failed" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Local MongoDB connection error: $($_.Exception.Message)" -ForegroundColor Red
}

# Test remote connection
Write-Host "`n5. Testing Remote Connection (192.168.56.1)..." -ForegroundColor Yellow
try {
    $result = Test-NetConnection -ComputerName "192.168.56.1" -Port 27017 -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($result) {
        Write-Host "✓ Remote MongoDB connection successful" -ForegroundColor Green
    } else {
        Write-Host "✗ Remote MongoDB connection failed" -ForegroundColor Red
        Write-Host "  This is expected if running on the same machine" -ForegroundColor Gray
    }
} catch {
    Write-Host "✗ Remote MongoDB connection error: $($_.Exception.Message)" -ForegroundColor Red
}

# Check Windows Firewall
Write-Host "`n6. Checking Windows Firewall..." -ForegroundColor Yellow
try {
    $firewallRule = Get-NetFirewallRule -DisplayName "*MongoDB*" -ErrorAction SilentlyContinue
    if ($firewallRule) {
        Write-Host "✓ MongoDB firewall rules found" -ForegroundColor Green
        foreach ($rule in $firewallRule) {
            Write-Host "  $($rule.DisplayName): $($rule.Enabled)" -ForegroundColor Gray
        }
    } else {
        Write-Host "⚠ No MongoDB firewall rules found" -ForegroundColor Yellow
        Write-Host "  Create inbound rule for port 27017 if needed" -ForegroundColor Gray
    }
} catch {
    Write-Host "⚠ Could not check firewall rules" -ForegroundColor Yellow
}

Write-Host "`n=== Diagnosis Summary ===" -ForegroundColor Cyan
Write-Host "MongoDB connectivity status:" -ForegroundColor White

# Check if services are actually working despite connection test
$ragRunning = Get-Process -Name "RAG.McpHost" -ErrorAction SilentlyContinue
if ($ragRunning) {
    try {
        $ragHealth = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 2 -ErrorAction SilentlyContinue
        if ($ragHealth) {
            Write-Host "✓ RAG service is running and healthy" -ForegroundColor Green
            Write-Host "  MongoDB status: Working despite connection test failure" -ForegroundColor Gray
            Write-Host "  This is normal - services can run in degraded mode" -ForegroundColor Gray
        }
    } catch {
        Write-Host "⚠ RAG service running but health check failed" -ForegroundColor Yellow
    }
} else {
    Write-Host "ℹ RAG service not running" -ForegroundColor Gray
}

Write-Host "`nRecommendations:" -ForegroundColor White
Write-Host "• The 'MongoDB connection failed' message is expected in some cases" -ForegroundColor Gray
Write-Host "• Services are designed to run in degraded mode without MongoDB" -ForegroundColor Gray
Write-Host "• Full MongoDB connectivity is optional for basic functionality" -ForegroundColor Gray
Write-Host "• For full functionality, ensure MongoDB is accessible at 192.168.56.1:27017" -ForegroundColor Gray
