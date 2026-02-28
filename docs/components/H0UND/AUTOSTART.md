# H0UND Autostart System

**Status**: DECISION_085 + DECISION_094 Implementation Complete

## Overview

H0UND can automatically start on Windows boot, running as a background service. This eliminates the need to manually start H0UND after system restarts.

## Architecture

```
Windows Boot
    ↓
Task Scheduler (30s delay)
    ↓
P4NTHE0N.exe --background
    ↓
ServiceOrchestrator loads config/autostart.json
    ↓
Services start with configured delays:
      ├─ RAG Server (immediate, depends on MongoDB)
      ├─ FourEyes MCP (5s delay)
      └─ Honeybelt MCP (5s delay)
    ↓
(60s later) ToolHive Desktop starts
    ↓
ToolHive auto-starts all MCP workloads
```

## Components

### NodeManagedService

New service wrapper for Node.js MCP servers with:

- **WorkingDirectory** - Sets process CWD for `node server.js`
- **Environment** - Injects env vars (MCP_PORT, CDP_HOST, etc.)
- **StartupDelay** - Waits N seconds for dependency ordering
- **Health checks** - HTTP endpoint monitoring with 30s retry

### ServiceOrchestrator

Auto-detects service configuration:
```csharp
bool hasNodeConfig = !string.IsNullOrWhiteSpace(service.WorkingDirectory)
    || service.Environment.Count > 0
    || service.StartupDelay > 0
    || service.Type.Equals("node", StringComparison.OrdinalIgnoreCase);

if (hasNodeConfig)
{
    s_serviceOrchestrator.RegisterService(new NodeManagedService(...));
}
```

## Configuration

### config/autostart.json

```json
{
  "services": [
    {
      "name": "RAG Server",
      "type": "http",
      "executable": "C:\\ProgramData\\P4NTHE0N\\bin\\RAG.McpHost.exe",
      "arguments": "--port 5001 --transport http --bridge http://127.0.0.1:5000",
      "healthCheckUrl": "http://127.0.0.1:5001/health",
      "dependsOn": ["MongoDB"]
    },
    {
      "name": "FourEyes MCP",
      "type": "node",
      "executable": "node",
      "workingDirectory": "C:\\P4NTHE0N\\tools\\mcp-foureyes",
      "arguments": "server.js --http",
      "environment": {
        "CDP_HOST": "127.0.0.1",
        "CDP_PORT": "9222",
        "MCP_PORT": "5302"
      },
      "healthCheckUrl": "http://127.0.0.1:5302/mcp",
      "startupDelay": 5
    }
  ],
  "toolhive": {
    "enabled": true,
    "autoStartWorkloads": [
      "mongodb-p4nth30n",
      "decisions-server",
      "foureyes-mcp",
      "honeybelt-server",
      "rag-server"
    ]
  },
  "startup": {
    "delaySeconds": 30,
    "serviceStartInterval": 5
  }
}
```

## Setup

### Prerequisites

- Administrator privileges required
- H0UND must be built: `dotnet build H0UND\H0UND.csproj -c Release`
- PowerShell execution policy allows scripts

### 1. Register H0UND Autostart (Admin PowerShell)

**CORRECT WAY** (Run as Administrator):

```powershell
# Option A: Direct execution (if .ps1 associated with PowerShell)
.\scripts\Register-AutoStart.ps1

# Option B: Explicit PowerShell invocation (RECOMMENDED - always works)
powershell -File .\scripts\Register-AutoStart.ps1

# Option C: With execution policy bypass (if scripts are blocked)
powershell -ExecutionPolicy Bypass -File .\scripts\Register-AutoStart.ps1
```

**NOT THIS WAY**:
```powershell
# DON'T USE sudo on Windows
sudo .\scripts\Register-AutoStart.ps1  # ❌ WRONG - causes "not valid Win32 application"

# DON'T double-click the .ps1 file
# ❌ WRONG - opens "Select an app" dialog
```

### 2. Register ToolHive Autostart (Admin PowerShell)

```powershell
# Run in Administrator PowerShell:
.\scripts\Register-ToolHive-AutoStart.ps1
```

### 3. Verify Registration

```powershell
# Check H0UND task
Get-ScheduledTask -TaskName "P4NTHE0N-AutoStart"

# Check ToolHive task
Get-ScheduledTask -TaskName "ToolHive-AutoStart"

# View all P4NTHE0N tasks
Get-ScheduledTask | Where-Object { $_.TaskName -like "*P4NTHE0N*" -or $_.TaskName -like "*ToolHive*" }
```

### 4. Test Without Reboot

```powershell
# Start H0UND task manually
Start-ScheduledTask -TaskName "P4NTHE0N-AutoStart"

# Check if running
Get-Process P4NTHE0N

# View task history
Get-ScheduledTaskInfo -TaskName "P4NTHE0N-AutoStart"
```

## Troubleshooting

### "%1 is not a valid Win32 application"

**Cause**: Using `sudo` on Windows or calling script directly

**Fix**:
```powershell
# Run PowerShell as Administrator (right-click → Run as Administrator)
# Then execute:
.\scripts\Register-AutoStart.ps1
```

### "Select an app to open this ps1 file"

**Cause**: Windows doesn't know how to execute .ps1 files (file association missing)

**Fix**:
```powershell
# Option 1: Explicit PowerShell invocation (RECOMMENDED)
powershell -File .\scripts\Register-AutoStart.ps1

# Option 2: With execution policy bypass
powershell -ExecutionPolicy Bypass -File .\scripts\Register-AutoStart.ps1

# Option 3: Full path to PowerShell
& "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -File .\scripts\Register-AutoStart.ps1
```

### "Execution of scripts is disabled"

**Cause**: PowerShell execution policy blocks scripts

**Fix**:
```powershell
# Check current policy
Get-ExecutionPolicy

# Temporarily allow scripts (for this session)
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Then run the script
.\scripts\Register-AutoStart.ps1
```

### Task Registered But Not Running

**Check Event Logs**:
```powershell
# View recent task failures
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-TaskScheduler/Operational'; StartTime=(Get-Date).AddHours(-1)} | Where-Object { $_.Message -like "*P4NTHE0N*" }
```

**Common Causes**:
1. Executable path doesn't exist
2. MongoDB not running
3. Wrong .NET version

**Verify Executable**:
```powershell
Test-Path "C:\P4NTHE0N\H0UND\bin\Release\net10.0-windows7.0\P4NTHE0N.exe"
```

### Service Health Check Failures

**Check service logs**:
```powershell
# H0UND logs in background mode
tail -f "$env:LOCALAPPDATA\P4NTHE0N\logs\h0und.log"
```

**Manual service test**:
```powershell
# Test FourEyes manually
cd C:\P4NTHE0N\tools\mcp-foureyes
$env:CDP_HOST="127.0.0.1"
$env:CDP_PORT="9222"
$env:MCP_PORT="5302"
node server.js --http
```

## Uninstall Autostart

```powershell
# Remove H0UND task (Admin PowerShell)
Unregister-ScheduledTask -TaskName "P4NTHE0N-AutoStart" -Confirm:$false

# Remove ToolHive task
Unregister-ScheduledTask -TaskName "ToolHive-AutoStart" -Confirm:$false
```

## Files

| File | Purpose |
|------|---------|
| `config/autostart.json` | Service configuration |
| `H0UND/Infrastructure/BootTime/AutostartConfig.cs` | Configuration model |
| `H0UND/Services/Orchestration/NodeManagedService.cs` | Node.js service wrapper |
| `scripts/Register-AutoStart.ps1` | H0UND task registration |
| `scripts/Register-ToolHive-AutoStart.ps1` | ToolHive task registration |

## Decision References

- **DECISION_085**: Autostart infrastructure
- **DECISION_094**: MCP Server Boot-Time Integration
