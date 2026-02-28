# P4NTHE0N MCP Services - Complete Startup Solution

## Overview
This solution provides comprehensive management of all three P4NTHE0N MCP services with automatic startup, health checking, and duplicate prevention.

## Services Managed

### 1. p4ntheon-rag (RAG Server)
- **Binary**: `RAG.McpHost.exe`
- **Port**: 5100
- **Purpose**: Retrieval-Augmented Generation for P4NTHE0N documentation and decisions
- **Health**: `http://localhost:5100/health`

### 2. chrome-devtools (Chrome DevTools MCP)
- **Binary**: Node.js server
- **Port**: 5301
- **Purpose**: Chrome DevTools Protocol integration for browser automation
- **Health**: `http://localhost:5301/mcp`
- **Tools**: evaluate_script, list_targets, navigate, get_version

### 3. p4ntheon-tools (P4NTHE0N Tools)
- **Binary**: `T00L5ET.exe`
- **Purpose**: P4NTHE0N specific tools (credential management, signal processing, game interaction)
- **Mode**: MCP mode (no HTTP endpoint)

## Startup Methods

### Method 1: Manual Startup
```powershell
# Start all services
.\Start-All-MCP-Servers.ps1

# Force restart all services
.\Start-All-MCP-Servers.ps1 -Force

# Stop all services
.\Start-All-MCP-Servers.ps1 -Stop
```

### Method 2: Visual Studio Launch Script
```batch
# Double-click this file to start services and launch Visual Studio
Launch-P4NTHE0N-VS.bat
```

### Method 3: Windows Startup Task (Automatic)
```powershell
# Create Windows scheduled task for automatic startup
.\Create-MCP-StartupTask.ps1

# Remove the scheduled task
.\Create-MCP-StartupTask.ps1 -Remove

# Recreate the task
.\Create-MCP-StartupTask.ps1 -Force
```

### Method 4: Visual Studio Task Runner
The `.vs/tasks.json` file is configured to automatically run the startup script when the P4NTHE0N workspace is opened in Visual Studio.

## Features

### ✅ Duplicate Prevention
- Checks if services are already running before starting
- Uses process name and command line pattern matching
- Prevents multiple instances of the same service

### ✅ Health Checking
- RAG server: HTTP health endpoint with vector count and query metrics
- Chrome DevTools: MCP server status endpoint
- Tools service: Process existence check

### ✅ Prerequisites Validation
- Verifies all binaries exist before starting
- Checks Node.js availability for Chrome DevTools server
- Tests MongoDB connectivity (with graceful degradation)

### ✅ Graceful Error Handling
- Services continue starting even if others fail
- Clear error messages and troubleshooting guidance
- Non-zero exit codes for automation scenarios

### ✅ Flexible Configuration
- `-Force` flag to restart running services
- `-Stop` flag to shutdown all services
- Configurable timeout values
- Environment variable management

## File Structure

```
c:\P4NTH30N\
├── Start-All-MCP-Servers.ps1          # Main startup script
├── Create-MCP-StartupTask.ps1        # Windows scheduled task creator
├── Launch-P4NTHE0N-VS.bat             # Visual Studio launch script
├── .vs\tasks.json                     # Visual Studio task configuration
├── .mcp\mcp.json                     # Visual Studio MCP config
├── .windsurf\mcp_config.json          # WindSurf MCP config
└── Verify-MCP-Setup.ps1               # Verification script
```

## Usage Examples

### Development Workflow
```powershell
# Start services for development session
.\Start-All-MCP-Servers.ps1

# Work in Visual Studio with full MCP support
# Services automatically available in AI chat

# Stop services when done
.\Start-All-MCP-Servers.ps1 -Stop
```

### Production/Automation
```powershell
# Create automatic startup on Windows login
.\Create-MCP-StartupTask.ps1

# Services start automatically when you log in
# No manual intervention required
```

### Troubleshooting
```powershell
# Force restart all services
.\Start-All-MCP-Servers.ps1 -Force

# Verify configuration
.\Verify-MCP-Setup.ps1

# Check individual service status
Get-Process -Name "RAG.McpHost"
Get-Process -Name "node" | Where-Object {$_.CommandLine -like "*chrome-devtools-mcp*"}
Get-Process -Name "T00L5ET"
```

## Integration with IDEs

### Visual Studio Community
- MCP configuration automatically detected from `.mcp/mcp.json`
- Services available in AI chat (Ctrl+I)
- Automatic startup via task runner or launch script

### WindSurf
- MCP configuration automatically detected from `.windsurf/mcp_config.json`
- Services available in AI chat features
- Same startup scripts work for both IDEs

## Environment Variables

The startup script automatically sets these environment variables:

```powershell
$env:RAG_PORT = "5100"
$env:RAG_INDEX = "p4ntheon"
$env:RAG_MONGO = "192.168.56.1:27017"
$env:RAG_WORKSPACE = "C:\P4NTH30N"
```

## Troubleshooting Guide

### Service Won't Start
1. Check if binary exists: `Test-Path "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe"`
2. Build missing projects with `dotnet publish` commands
3. Check MongoDB connectivity: `Test-NetConnection -ComputerName "192.168.56.1" -Port 27017`

### Health Check Failures
1. Service may still be starting - wait longer with `-TimeoutSeconds 60`
2. Check service logs for startup errors
3. Verify port availability: `Get-NetTCPConnection -LocalPort 5100`

### Multiple Instances Running
1. Use `-Force` flag to clean restart: `.\Start-All-MCP-Servers.ps1 -Force`
2. Manually stop processes: `Stop-Process -Name "RAG.McpHost" -Force`

### Windows Task Scheduler Issues
1. Run PowerShell as Administrator when creating tasks
2. Check Task Scheduler for task status and history
3. Verify script execution policy: `Get-ExecutionPolicy`

## Security Considerations

- Services run with current user privileges
- No external network access required (localhost only)
- MongoDB connection uses existing credentials
- Chrome DevTools server requires Chrome with remote debugging

## Performance Impact

- RAG server: ~100MB RAM (with ONNX model loaded)
- Chrome DevTools: ~50MB RAM
- P4NTHE0N Tools: ~30MB RAM
- Total: ~180MB RAM when all services running

This comprehensive solution ensures reliable, automatic startup of all P4NTHE0N MCP services with proper error handling and duplicate prevention.
