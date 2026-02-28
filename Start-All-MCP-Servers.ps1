# P4NTHE0N MCP Services Startup Script
# Manages all three MCP servers: RAG, Chrome DevTools, and P4NTHE0N Tools

param(
    [switch]$Force,
    [switch]$Stop,
    [int]$TimeoutSeconds = 30
)

Write-Host "=== P4NTHE0N MCP Services Manager ===" -ForegroundColor Cyan

if ($Stop) {
    Write-Host "Stopping all P4NTHE0N MCP services..." -ForegroundColor Yellow
    
    # Stop RAG background job
    Write-Host "Stopping RAG MCP Host background job..." -ForegroundColor Yellow
    & "c:\P4NTH30N\Manage-RAG-Background.ps1" -Stop
    
    # Stop Chrome DevTools MCP server
    $cdpProcess = Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*chrome-devtools-mcp*"}
    if ($cdpProcess) {
        Write-Host "Stopping Chrome DevTools MCP server (PID: $($cdpProcess.Id))..." -ForegroundColor Yellow
        Stop-Process -Id $cdpProcess.Id -Force -ErrorAction SilentlyContinue
        Write-Host "✓ Chrome DevTools MCP server stopped" -ForegroundColor Green
    } else {
        Write-Host "ℹ Chrome DevTools MCP server not running" -ForegroundColor Gray
    }
    
    # Stop T00L5ET.exe
    $toolsProcess = Get-Process -Name "T00L5ET" -ErrorAction SilentlyContinue
    if ($toolsProcess) {
        Write-Host "Stopping T00L5ET.exe (PID: $($toolsProcess.Id))..." -ForegroundColor Yellow
        Stop-Process -Name "T00L5ET" -Force -ErrorAction SilentlyContinue
        Write-Host "✓ T00L5ET.exe stopped" -ForegroundColor Green
    } else {
        Write-Host "ℹ T00L5ET.exe not running" -ForegroundColor Gray
    }
    
    Write-Host "`nAll P4NTHE0N MCP services stopped." -ForegroundColor Green
    exit 0
}

# Service definitions
$services = @(
    @{
        Name = "p4ntheon-rag"
        ProcessName = "RAG.McpHost"
        Binary = "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe"
        Port = 5100
        HealthUrl = "http://localhost:5100/health"
        Args = @("--port", "5100", "--index", "p4ntheon", "--model", "C:\ProgramData\P4NTH30N\rag\models\all-MiniLM-L6-v2.onnx", "--mongo", "localhost:27017", "--workspace", "C:\P4NTH30N", "--transport", "http")
        Description = "RAG (Retrieval-Augmented Generation) server"
        WindowStyle = "Minimized"
        UseBackgroundJob = $true
    },
    @{
        Name = "chrome-devtools"
        ProcessName = "node"
        Binary = "node"
        Port = 5301
        HealthUrl = "http://localhost:5301/mcp"
        Args = @("c:\P4NTH30N\chrome-devtools-mcp\server.js", "http")
        Description = "Chrome DevTools Protocol integration"
        WindowStyle = "Hidden"
        MatchCommandLine = $true
        CommandPattern = "*chrome-devtools-mcp*"
    },
    @{
        Name = "p4ntheon-tools"
        ProcessName = "T00L5ET"
        Binary = "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe"
        Port = $null
        HealthUrl = $null
        Args = @("--mcp", "--workspace", "C:\P4NTH30N")
        Description = "P4NTHE0N specific tools"
        WindowStyle = "Minimized"
    }
)

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

$missingBinaries = @()
foreach ($service in $services) {
    if ($service.Binary -eq "node") {
        # Check for Node.js
        try {
            $nodeVersion = node --version 2>$null
            Write-Host " Node.js available: $nodeVersion" -ForegroundColor Green
        } catch {
            Write-Host " Node.js not found - Chrome DevTools MCP will not start" -ForegroundColor Red
            $missingBinaries += $service.Name
        }
    } else {
        if (Test-Path $service.Binary) {
            Write-Host " $($service.Name) binary exists" -ForegroundColor Green
        } else {
            Write-Host " $($service.Name) binary not found: $($service.Binary)" -ForegroundColor Red
            $missingBinaries += $service.Name
        }
    }
}

if ($missingBinaries.Count -gt 0) {
    Write-Host "`n Some binaries are missing. Please build missing projects:" -ForegroundColor Yellow
    Write-Host "dotnet publish `"c:\P4NTH30N\src\RAG.McpHost\RAG.McpHost.csproj`" -c Release -r win-x64 --self-contained" -ForegroundColor Gray
    Write-Host "dotnet publish `"c:\P4NTH30N\T00L5ET\T00L5ET.csproj`" -c Release -r win-x64 --self-contained" -ForegroundColor Gray
    Write-Host "`nContinuing with available services..." -ForegroundColor Yellow
}

# Check MongoDB connectivity
Write-Host "`nChecking MongoDB connectivity..." -ForegroundColor Yellow
$mongoConnected = $false
$mongoHost = "localhost"
$mongoPort = 27017

try {
    # Try localhost connection first (preferred)
    Write-Host "Testing MongoDB at $mongoHost`:$mongoPort..." -ForegroundColor Gray
    $result = Test-NetConnection -ComputerName $mongoHost -Port $mongoPort -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($result -eq $true) {
        Write-Host "✓ MongoDB accessible at $mongoHost`:$mongoPort" -ForegroundColor Green
        $mongoConnected = $true
    } else {
        # Fallback to TCP client test
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        try {
            $connect = $tcpClient.BeginConnect($mongoHost, $mongoPort, $null, $null)
            $wait = $connect.AsyncWaitHandle.WaitOne(3000, $false)
            if ($wait) {
                $tcpClient.EndConnect($connect)
                Write-Host "✓ MongoDB accessible at $mongoHost`:$mongoPort (TCP test)" -ForegroundColor Green
                $mongoConnected = $true
                $tcpClient.Close()
            } else {
                Write-Host "✗ MongoDB not accessible at $mongoHost`:$mongoPort - services will run in degraded mode" -ForegroundColor Red
                $tcpClient.Close()
            }
        } catch {
            Write-Host "✗ MongoDB connection failed at $mongoHost`:$mongoPort - services will run in degraded mode" -ForegroundColor Red
        }
    }
} catch {
    Write-Host "✗ MongoDB connection test failed at $mongoHost`:$mongoPort - services will run in degraded mode" -ForegroundColor Red
}

# Update environment variables with correct MongoDB host
if ($mongoConnected) {
    $env:MONGODB_HOST = "$mongoHost`:$mongoPort"
    Write-Host "✓ MongoDB environment variable set to: $env:MONGODB_HOST" -ForegroundColor Green
} else {
    $env:MONGODB_HOST = "$mongoHost`:$mongoPort"
    Write-Host "⚠ MongoDB environment variable set but connection failed: $env:MONGODB_HOST" -ForegroundColor Yellow
}

# Start services
Write-Host "`nStarting P4NTHE0N MCP services..." -ForegroundColor Cyan

$startedServices = @()
$failedServices = @()

foreach ($service in $services) {
    if ($missingBinaries -contains $service.Name) {
        Write-Host " Skipping $($service.Name) - binary missing" -ForegroundColor Yellow
        $failedServices += $service.Name
        continue
    }
    
    Write-Host "`n--- $($service.Description) ---" -ForegroundColor Cyan
    
    # Check if already running
    $runningProcess = $null
    if ($service.MatchCommandLine) {
        $runningProcess = Get-Process -Name $service.ProcessName -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like $service.CommandPattern}
    } else {
        $runningProcess = Get-Process -Name $service.ProcessName -ErrorAction SilentlyContinue
    }
    
    if ($runningProcess -and -not $Force) {
        Write-Host " $($service.Name) already running (PID: $($runningProcess.Id))" -ForegroundColor Green
        
        # Test health if available
        if ($service.HealthUrl) {
            try {
                $response = Invoke-RestMethod -Uri $service.HealthUrl -Method GET -TimeoutSec 3
                Write-Host "   Health check passed: $($response.status)" -ForegroundColor Green
                $startedServices += $service.Name
            } catch {
                Write-Host "   Health check failed, restarting..." -ForegroundColor Yellow
                Stop-Process -Id $runningProcess.Id -Force -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 2
                $runningProcess = $null
            }
        } else {
            $startedServices += $service.Name
        }
    }
    
    if ($Force -and $runningProcess) {
        Write-Host " Force restart requested..." -ForegroundColor Yellow
        Stop-Process -Id $runningProcess.Id -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        $runningProcess = $null
    }
    
    if (-not $runningProcess) {
        Write-Host "Starting $($service.Name)..." -ForegroundColor Yellow
        
        try {
            # Check if this service should use background job
            if ($service.UseBackgroundJob) {
                Write-Host "  Using background job mode..." -ForegroundColor Gray
                
                # Start as background job using the dedicated manager
                $jobResult = & "c:\P4NTH30N\Manage-RAG-Background.ps1" -Start
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "✓ $($service.Name) started as background job" -ForegroundColor Green
                    $startedServices += $service.Name
                } else {
                    Write-Host "✗ Failed to start $($service.Name) as background job" -ForegroundColor Red
                    $failedServices += $service.Name
                }
            } else {
                # Set environment variables
                $env:RAG_PORT = "5100"
                $env:RAG_INDEX = "p4ntheon"
                $env:RAG_MONGO = "localhost:27017"
                $env:RAG_WORKSPACE = "C:\P4NTH30N"
                
                $process = Start-Process -FilePath $service.Binary -ArgumentList $service.Args -PassThru -WindowStyle $service.WindowStyle
                
                Write-Host "✓ $($service.Name) started (PID: $($process.Id))" -ForegroundColor Green
                
                # Wait for startup and verify health if available
                if ($service.HealthUrl) {
                    Write-Host "  Waiting for service to initialize..." -ForegroundColor Yellow
                    $elapsed = 0
                    while ($elapsed -lt $TimeoutSeconds) {
                        try {
                            $response = Invoke-RestMethod -Uri $service.HealthUrl -Method GET -TimeoutSec 2
                            Write-Host "  ✓ Service ready: $($response.status)" -ForegroundColor Green
                            if ($response.vectors) { Write-Host "    Vectors: $($response.vectors)" -ForegroundColor Gray }
                            if ($response.dimension) { Write-Host "    Dimension: $($response.dimension)" -ForegroundColor Gray }
                            if ($response.avgQueryTime) { Write-Host "    Avg query time: $($response.avgQueryTime)ms" -ForegroundColor Gray }
                            $startedServices += $service.Name
                            break
                        } catch {
                            Start-Sleep -Seconds 1
                            $elapsed++
                        }
                    }
                    
                    if ($elapsed -ge $TimeoutSeconds) {
                        Write-Host "  ⚠ Service started but not responding after $TimeoutSeconds seconds" -ForegroundColor Yellow
                        $failedServices += $service.Name
                    }
                } else {
                    # No health check available, assume it started successfully
                    $startedServices += $service.Name
                    Start-Sleep -Seconds 2
                }
            }
            
        } catch {
            Write-Host "  ✗ Failed to start $($service.Name): $($_.Exception.Message)" -ForegroundColor Red
            $failedServices += $service.Name
        }
    }
}

# Summary
Write-Host "`n=== Startup Summary ===" -ForegroundColor Cyan

if ($startedServices.Count -gt 0) {
    Write-Host " Successfully started: $($startedServices -join ', ')" -ForegroundColor Green
} else {
    Write-Host "ℹ No services started" -ForegroundColor Gray
}

if ($failedServices.Count -gt 0) {
    Write-Host " Failed to start: $($failedServices -join ', ')" -ForegroundColor Red
    Write-Host "Check individual service logs for errors" -ForegroundColor Yellow
}

Write-Host "`nServices running on:" -ForegroundColor White
foreach ($service in $startedServices) {
    $serviceInfo = $services | Where-Object {$_.Name -eq $service}
    if ($serviceInfo.Port) {
        Write-Host "  - $($service.Name): port $($serviceInfo.Port)" -ForegroundColor Gray
    } else {
        Write-Host "  - $($service.Name): running" -ForegroundColor Gray
    }
}

Write-Host "`nNext steps:" -ForegroundColor White
Write-Host "1. Open Visual Studio Community and load P4NTHE0N.slnx" -ForegroundColor Gray
Write-Host "2. Use Ctrl+I to open AI chat and test MCP functionality" -ForegroundColor Gray
Write-Host "3. Run 'Start-All-MCP-Servers.ps1 -Stop' to stop all services" -ForegroundColor Gray

exit ($failedServices.Count)
