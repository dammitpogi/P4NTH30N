# Visual Studio Startup Script for P4NTHE0N MCP Servers
# Automatically starts RAG.McpHost.exe if not already running

param(
    [switch]$Force,
    [int]$TimeoutSeconds = 30
)

Write-Host "=== P4NTHE0N MCP Server Startup ===" -ForegroundColor Cyan

# Check if RAG.McpHost.exe is already running
$ragProcess = Get-Process -Name "RAG.McpHost" -ErrorAction SilentlyContinue

if ($ragProcess -and -not $Force) {
    Write-Host "✓ RAG.McpHost.exe already running (PID: $($ragProcess.Id))" -ForegroundColor Green
    
    # Test if it's responding
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 5
        Write-Host "✓ RAG MCP Host responding: $($response.status)" -ForegroundColor Green
        exit 0
    } catch {
        Write-Host "⚠ RAG MCP Host not responding, restarting..." -ForegroundColor Yellow
        Stop-Process -Name "RAG.McpHost" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
} elseif ($Force) {
    Write-Host "🔄 Force restart requested..." -ForegroundColor Yellow
    if ($ragProcess) {
        Stop-Process -Name "RAG.McpHost" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
}

# Check prerequisites
$ragExe = "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe"
$modelPath = "C:\ProgramData\P4NTH30N\rag\models\all-MiniLM-L6-v2.onnx"

if (-not (Test-Path $ragExe)) {
    Write-Host "✗ RAG.McpHost.exe not found at $ragExe" -ForegroundColor Red
    Write-Host "Please build the project first:" -ForegroundColor Yellow
    Write-Host "dotnet publish `"c:\P4NTH30N\src\RAG.McpHost\RAG.McpHost.csproj`" -c Release -r win-x64 --self-contained" -ForegroundColor Gray
    exit 1
}

if (-not (Test-Path $modelPath)) {
    Write-Host "⚠ ONNX model not found at $modelPath" -ForegroundColor Yellow
    Write-Host "RAG will still start but embeddings will be disabled" -ForegroundColor Gray
}

# Check MongoDB connectivity
Write-Host "Checking MongoDB connectivity..." -ForegroundColor Yellow
try {
    $result = Test-NetConnection -ComputerName "192.168.56.1" -Port 27017 -WarningAction SilentlyContinue -TimeoutSec 5
    if ($result.TcpTestSucceeded) {
        Write-Host "✓ MongoDB accessible" -ForegroundColor Green
    } else {
        Write-Host "⚠ MongoDB not accessible - RAG will run in degraded mode" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠ MongoDB connection failed - RAG will run in degraded mode" -ForegroundColor Yellow
}

# Start RAG.McpHost.exe
Write-Host "Starting RAG.McpHost.exe..." -ForegroundColor Cyan

$env:RAG_PORT = "5100"
$env:RAG_INDEX = "p4ntheon"
$env:RAG_MODEL = $modelPath
$env:RAG_MONGO = "192.168.56.1:27017"
$env:RAG_WORKSPACE = "C:\P4NTH30N"

try {
    $process = Start-Process -FilePath $ragExe -ArgumentList @(
        "--port", "5100",
        "--index", "p4ntheon", 
        "--model", $modelPath,
        "--mongo", "192.168.56.1:27017",
        "--workspace", "C:\P4NTH30N"
    ) -PassThru -WindowStyle Minimized
    
    Write-Host "✓ RAG.McpHost.exe started (PID: $($process.Id))" -ForegroundColor Green
    
    # Wait for startup and verify
    Write-Host "Waiting for RAG MCP Host to initialize..." -ForegroundColor Yellow
    $elapsed = 0
    while ($elapsed -lt $TimeoutSeconds) {
        try {
            $response = Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET -TimeoutSec 2
            Write-Host "✓ RAG MCP Host ready: $($response.status)" -ForegroundColor Green
            Write-Host "  - Vectors: $($response.vectors)" -ForegroundColor Gray
            Write-Host "  - Dimension: $($response.dimension)" -ForegroundColor Gray
            Write-Host "  - Avg query time: $($response.avgQueryTime)ms" -ForegroundColor Gray
            exit 0
        } catch {
            Start-Sleep -Seconds 1
            $elapsed++
        }
    }
    
    Write-Host "⚠ RAG MCP Host started but not responding after $TimeoutSeconds seconds" -ForegroundColor Yellow
    Write-Host "Check the process logs for errors" -ForegroundColor Gray
    exit 1
    
} catch {
    Write-Host "✗ Failed to start RAG.McpHost.exe: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
