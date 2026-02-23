# DECISION_093: Boot-time Auto-start & Service Lifecycle Architecture

## Executive Summary

This document defines the production-ready architecture for P4NTH30N boot-time auto-start using Windows Task Scheduler, with comprehensive dependency management, graceful shutdown handling, and a robust service lifecycle state machine.

---

## 1. Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         WINDOWS BOOT SEQUENCE                                │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    TASK SCHEDULER BOOT TRIGGER                               │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ Trigger: At system startup                                          │   │
│  │ Delay: 30 seconds                                                   │   │
│  │ Principal: SYSTEM or User with highest privileges                   │   │
│  │ Action: C:\P4NTH30N\P4NTH30N.exe --background                       │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    P4NTH30N SERVICE LIFECYCLE                               │
│                                                                              │
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │
│   │Initializing │───▶│  Starting   │───▶│   Running   │───▶│  Stopping   │  │
│   └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘  │
│          │                  │                  │                  │         │
│          ▼                  ▼                  ▼                  ▼         │
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │
│   │   Error     │    │  Degraded   │    │   Paused    │    │   Stopped   │  │
│   └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                    ┌─────────────────┼─────────────────┐
                    ▼                 ▼                 ▼
           ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
           │   MongoDB   │   │  RAG Server │   │  MCP Server │
           │  (External) │   │  (Internal) │   │  (Internal) │
           └─────────────┘   └─────────────┘   └─────────────┘
```

---

## 2. Task Scheduler Integration

### 2.1 Task XML Configuration

```xml
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2025-01-01T00:00:00</Date>
    <Author>P4NTH30N</Author>
    <Description>P4NTH30N Auto-start Service - Boot-time initialization with dependency management</Description>
    <URI>\P4NTH30N\P4NTH30N-AutoStart</URI>
  </RegistrationInfo>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-18</UserId>
      <RunLevel>HighestAvailable</RunLevel>
      <LogonType>ServiceAccount</LogonType>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>false</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
    <Priority>6</Priority>
    <RestartOnFailure>
      <Interval>PT5M</Interval>
      <Count>3</Count>
    </RestartOnFailure>
  </Settings>
  <Triggers>
    <BootTrigger>
      <Enabled>true</Enabled>
      <Delay>PT30S</Delay>
    </BootTrigger>
  </Triggers>
  <Actions Context="Author">
    <Exec>
      <Command>C:\P4NTH30N\P4NTH30N.exe</Command>
      <Arguments>--background --config "C:\P4NTH30N\config\autostart.json"</Arguments>
      <WorkingDirectory>C:\P4NTH30N</WorkingDirectory>
    </Exec>
  </Actions>
</Task>
```

### 2.2 PowerShell Registration Script

```powershell
# Register-AutoStart.ps1
# Requires Administrator privileges

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$InstallPath = "C:\P4NTH30N",
    
    [Parameter(Mandatory=$false)]
    [int]$BootDelaySeconds = 30,
    
    [Parameter(Mandatory=$false)]
    [switch]$UseSystemAccount,
    
    [Parameter(Mandatory=$false)]
    [string]$UserName = $env:USERNAME,
    
    [Parameter(Mandatory=$false)]
    [switch]$Force
)

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

# Constants
$TaskName = "P4NTH30N-AutoStart"
$TaskPath = "\P4NTH30N\"
$TaskDescription = "P4NTH30N Auto-start Service - Boot-time initialization with dependency management"

function Write-Status {
    param([string]$Message, [string]$Status = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $colorMap = @{
        "INFO" = "Cyan"
        "SUCCESS" = "Green"
        "WARNING" = "Yellow"
        "ERROR" = "Red"
    }
    Write-Host "[$timestamp] [$Status] $Message" -ForegroundColor $colorMap[$Status]
}

function Test-ExecutablePath {
    param([string]$Path)
    $exePath = Join-Path $Path "P4NTH30N.exe"
    if (-not (Test-Path $exePath)) {
        throw "P4NTH30N.exe not found at: $exePath"
    }
    return $exePath
}

function Get-TaskPrincipal {
    if ($UseSystemAccount) {
        return New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    } else {
        # Get current user's SID
        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        return New-ScheduledTaskPrincipal -UserId $currentUser.Name -LogonType Interactive -RunLevel Highest
    }
}

function Register-P4NTH30NTask {
    try {
        Write-Status "Validating installation path..."
        $exePath = Test-ExecutablePath -Path $InstallPath
        Write-Status "Found executable: $exePath" "SUCCESS"

        # Check if task already exists
        $existingTask = Get-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -ErrorAction SilentlyContinue
        if ($existingTask -and -not $Force) {
            Write-Status "Task already exists. Use -Force to overwrite." "WARNING"
            return $false
        }
        
        if ($existingTask -and $Force) {
            Write-Status "Removing existing task..."
            Unregister-ScheduledTask -TaskName "$TaskPath$TaskName" -Confirm:$false
        }

        # Create task folder if it doesn't exist
        $scheduleService = New-Object -ComObject Schedule.Service
        $scheduleService.Connect()
        $rootFolder = $scheduleService.GetFolder("\")
        
        try {
            $rootFolder.GetFolder("P4NTH30N") | Out-Null
        } catch {
            Write-Status "Creating P4NTH30N task folder..."
            $rootFolder.CreateFolder("P4NTH30N") | Out-Null
        }

        Write-Status "Creating boot trigger with ${BootDelaySeconds}s delay..."
        $trigger = New-ScheduledTaskTrigger -AtStartup
        $trigger.Delay = "PT${BootDelaySeconds}S"

        Write-Status "Configuring task action..."
        $action = New-ScheduledTaskAction `
            -Execute $exePath `
            -Argument '--background --config "C:\P4NTH30N\config\autostart.json"' `
            -WorkingDirectory $InstallPath

        Write-Status "Configuring task principal..."
        $principal = Get-TaskPrincipal

        Write-Status "Configuring task settings..."
        $settings = New-ScheduledTaskSettingsSet `
            -AllowStartIfOnBatteries `
            -DontStopIfGoingOnBatteries `
            -StartWhenAvailable `
            -MultipleInstances IgnoreNew `
            -ExecutionTimeLimit 0 `
            -RestartCount 3 `
            -RestartInterval (New-TimeSpan -Minutes 5)

        Write-Status "Registering scheduled task..."
        $task = New-ScheduledTask `
            -Action $action `
            -Principal $principal `
            -Trigger $trigger `
            -Settings $settings `
            -Description $TaskDescription

        Register-ScheduledTask `
            -TaskName $TaskName `
            -TaskPath $TaskPath `
            -InputObject $task `
            -Force | Out-Null

        Write-Status "Task registered successfully!" "SUCCESS"
        
        # Display task info
        $createdTask = Get-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath
        Write-Status "Task Details:" "INFO"
        Write-Status "  Name: $($createdTask.TaskName)" "INFO"
        Write-Status "  Path: $($createdTask.TaskPath)" "INFO"
        Write-Status "  State: $($createdTask.State)" "INFO"
        Write-Status "  Next Run Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" "INFO"
        
        return $true
    }
    catch {
        Write-Status "Failed to register task: $_" "ERROR"
        throw
    }
}

# Main execution
try {
    Write-Status "=== P4NTH30N Auto-start Registration ==="
    Write-Status "Install Path: $InstallPath"
    Write-Status "Boot Delay: $BootDelaySeconds seconds"
    Write-Status "Account: $(if ($UseSystemAccount) { 'SYSTEM' } else { $env:USERNAME })"
    
    Register-P4NTH30NTask
    
    Write-Status "Registration complete!" "SUCCESS"
    Write-Status "P4NTH30N will start automatically on next boot (with ${BootDelaySeconds}s delay)." "SUCCESS"
}
catch {
    Write-Status "Registration failed: $_" "ERROR"
    exit 1
}
```

### 2.3 Unregistration Script

```powershell
# Unregister-AutoStart.ps1
# Requires Administrator privileges

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [switch]$Confirm = $true
)

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

$TaskName = "P4NTH30N-AutoStart"
$TaskPath = "\P4NTH30N\"

function Write-Status {
    param([string]$Message, [string]$Status = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Status) {
        "SUCCESS" { "Green" }
        "WARNING" { "Yellow" }
        "ERROR" { "Red" }
        default { "Cyan" }
    }
    Write-Host "[$timestamp] [$Status] $Message" -ForegroundColor $color
}

try {
    Write-Status "=== P4NTH30N Auto-start Unregistration ==="
    
    $task = Get-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -ErrorAction SilentlyContinue
    
    if (-not $task) {
        Write-Status "Task not found. Nothing to unregister." "WARNING"
        exit 0
    }
    
    Write-Status "Found task: $($task.TaskName)" "SUCCESS"
    
    if ($Confirm) {
        $response = Read-Host "Are you sure you want to unregister P4NTH30N auto-start? (y/N)"
        if ($response -ne 'y') {
            Write-Status "Operation cancelled." "WARNING"
            exit 0
        }
    }
    
    Write-Status "Unregistering task..."
    Unregister-ScheduledTask -TaskName "$TaskPath$TaskName" -Confirm:$false
    
    # Try to remove the folder (will fail if not empty, which is fine)
    try {
        $scheduleService = New-Object -ComObject Schedule.Service
        $scheduleService.Connect()
        $rootFolder = $scheduleService.GetFolder("\")
        $rootFolder.DeleteFolder("P4NTH30N", $null)
        Write-Status "Removed P4NTH30N task folder." "SUCCESS"
    } catch {
        # Folder might have other tasks or not exist
    }
    
    Write-Status "Unregistration complete!" "SUCCESS"
    Write-Status "P4NTH30N will no longer start automatically at boot." "SUCCESS"
}
catch {
    Write-Status "Unregistration failed: $_" "ERROR"
    exit 1
}
```

### 2.4 Status Check Script

```powershell
# Check-Status.ps1
# Checks P4NTH30N auto-start configuration and running state

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$InstallPath = "C:\P4NTH30N"
)

$ErrorActionPreference = "SilentlyContinue"

function Write-StatusLine {
    param([string]$Label, [string]$Value, [string]$Status = "INFO")
    $color = switch ($Status) {
        "OK" { "Green" }
        "WARN" { "Yellow" }
        "ERROR" { "Red" }
        default { "White" }
    }
    Write-Host "  $Label".PadRight(25) -NoNewline
    Write-Host $Value -ForegroundColor $color
}

function Test-ServiceHealth {
    param([string]$Name, [string]$CheckType, [scriptblock]$Check)
    Write-Host "`nChecking $Name..." -ForegroundColor Cyan
    try {
        $result = & $Check
        if ($result) {
            Write-StatusLine "Status" "RUNNING" "OK"
            return $true
        } else {
            Write-StatusLine "Status" "NOT RUNNING" "WARN"
            return $false
        }
    } catch {
        Write-StatusLine "Status" "ERROR: $_" "ERROR"
        return $false
    }
}

Write-Host "=== P4NTH30N Auto-start Status Check ===" -ForegroundColor Cyan

# Check 1: Installation Path
Write-Host "`n[Installation]" -ForegroundColor Yellow
$exePath = Join-Path $InstallPath "P4NTH30N.exe"
if (Test-Path $exePath) {
    Write-StatusLine "Executable" "Found at $exePath" "OK"
    $version = (Get-Item $exePath).VersionInfo.FileVersion
    Write-StatusLine "Version" $version "OK"
} else {
    Write-StatusLine "Executable" "NOT FOUND at $exePath" "ERROR"
}

$configPath = Join-Path $InstallPath "config\autostart.json"
if (Test-Path $configPath) {
    Write-StatusLine "Config" "Found at $configPath" "OK"
} else {
    Write-StatusLine "Config" "NOT FOUND" "WARN"
}

# Check 2: Scheduled Task
Write-Host "`n[Task Scheduler]" -ForegroundColor Yellow
$task = Get-ScheduledTask -TaskName "P4NTH30N-AutoStart" -TaskPath "\P4NTH30N\" 
if ($task) {
    Write-StatusLine "Task" "Registered" "OK"
    Write-StatusLine "State" $task.State "OK"
    Write-StatusLine "Next Run" $task.NextRunTime
} else {
    Write-StatusLine "Task" "NOT REGISTERED" "WARN"
}

# Check 3: Running Processes
Write-Host "`n[Running Services]" -ForegroundColor Yellow
$process = Get-Process -Name "P4NTH30N" -ErrorAction SilentlyContinue
if ($process) {
    Write-StatusLine "P4NTH30N" "Running (PID: $($process.Id))" "OK"
    Write-StatusLine "Memory" "$([math]::Round($process.WorkingSet64 / 1MB, 2)) MB"
    Write-StatusLine "Started" $process.StartTime
} else {
    Write-StatusLine "P4NTH30N" "Not running" "WARN"
}

# Check 4: Dependencies
Write-Host "`n[Dependencies]" -ForegroundColor Yellow

# MongoDB check
$mongoProcess = Get-Process -Name "mongod" -ErrorAction SilentlyContinue
if ($mongoProcess) {
    Write-StatusLine "MongoDB" "Running (PID: $($mongoProcess.Id))" "OK"
} else {
    Write-StatusLine "MongoDB" "Not running" "WARN"
}

# Port checks
$ports = @(27017, 8080, 5000)  # MongoDB, RAG, MCP
$portNames = @{27017 = "MongoDB"; 8080 = "RAG Server"; 5000 = "MCP Server"}
foreach ($port in $ports) {
    $connection = Test-NetConnection -ComputerName localhost -Port $port -WarningAction SilentlyContinue
    if ($connection.TcpTestSucceeded) {
        Write-StatusLine "$($portNames[$port]) (port $port)" "LISTENING" "OK"
    } else {
        Write-StatusLine "$($portNames[$port]) (port $port)" "NOT RESPONDING" "WARN"
    }
}

# Check 5: Windows Event Log
Write-Host "`n[Recent Events]" -ForegroundColor Yellow
$events = Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='P4NTH30N'; StartTime=(Get-Date).AddHours(-24)} -MaxEvents 5 -ErrorAction SilentlyContinue
if ($events) {
    foreach ($event in $events | Select-Object -First 3) {
        $level = switch ($event.Level) {
            1 { "CRITICAL" }
            2 { "ERROR" }
            3 { "WARNING" }
            4 { "INFO" }
            default { "UNKNOWN" }
        }
        Write-Host "  [$($event.TimeCreated.ToString('HH:mm:ss'))] $level - $($event.Message.Substring(0,[Math]::Min(50,$event.Message.Length)))..."
    }
} else {
    Write-StatusLine "Events" "No recent events found"
}

Write-Host "`n=== Status Check Complete ===" -ForegroundColor Cyan
```

---

## 3. Service Dependency Management

### 3.1 Dependency Configuration Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "P4NTH30N Auto-start Configuration",
  "type": "object",
  "required": ["version", "boot", "dependencies", "services"],
  "properties": {
    "version": {
      "type": "string",
      "description": "Configuration schema version"
    },
    "boot": {
      "type": "object",
      "properties": {
        "delaySeconds": {
          "type": "integer",
          "default": 30,
          "minimum": 0,
          "maximum": 300
        },
        "maxStartupTime": {
          "type": "integer",
          "default": 120,
          "description": "Maximum time to wait for all dependencies"
        },
        "retryPolicy": {
          "type": "object",
          "properties": {
            "maxRetries": { "type": "integer", "default": 5 },
            "initialDelayMs": { "type": "integer", "default": 1000 },
            "maxDelayMs": { "type": "integer", "default": 30000 },
            "backoffMultiplier": { "type": "number", "default": 2.0 }
          }
        }
      }
    },
    "dependencies": {
      "type": "array",
      "description": "External dependencies that must be available",
      "items": {
        "type": "object",
        "required": ["name", "type", "healthCheck"],
        "properties": {
          "name": { "type": "string" },
          "type": {
            "type": "string",
            "enum": ["process", "service", "port", "url", "file"]
          },
          "required": { "type": "boolean", "default": true },
          "healthCheck": {
            "type": "object",
            "properties": {
              "method": {
                "type": "string",
                "enum": ["process", "tcp", "http", "file-exists", "custom"]
              },
              "target": { "type": "string" },
              "timeoutMs": { "type": "integer", "default": 5000 },
              "intervalMs": { "type": "integer", "default": 1000 }
            }
          },
          "startupAction": {
            "type": "object",
            "description": "Action to start this dependency if not running",
            "properties": {
              "type": { "type": "string", "enum": ["command", "service-start", "none"] },
              "command": { "type": "string" },
              "args": { "type": "array", "items": { "type": "string" } },
              "waitForReadyMs": { "type": "integer", "default": 10000 }
            }
          }
        }
      }
    },
    "services": {
      "type": "array",
      "description": "Internal services to start in order",
      "items": {
        "type": "object",
        "required": ["name", "assembly", "entryPoint"],
        "properties": {
          "name": { "type": "string" },
          "assembly": { "type": "string" },
          "entryPoint": { "type": "string" },
          "dependencies": {
            "type": "array",
            "items": { "type": "string" }
          },
          "startupTimeoutMs": { "type": "integer", "default": 30000 },
          "shutdownTimeoutMs": { "type": "integer", "default": 10000 }
        }
      }
    },
    "logging": {
      "type": "object",
      "properties": {
        "level": {
          "type": "string",
          "enum": ["Debug", "Information", "Warning", "Error"],
          "default": "Information"
        },
        "filePath": {
          "type": "string",
          "default": "logs\autostart.log"
        },
        "maxSizeMB": { "type": "integer", "default": 100 },
        "maxFiles": { "type": "integer", "default": 10 }
      }
    },
    "shutdown": {
      "type": "object",
      "properties": {
        "gracefulTimeoutMs": { "type": "integer", "default": 30000 },
        "forceTerminateAfterMs": { "type": "integer", "default": 60000 }
      }
    }
  }
}
```

### 3.2 Example autostart.json

```json
{
  "version": "1.0.0",
  "boot": {
    "delaySeconds": 30,
    "maxStartupTime": 180,
    "retryPolicy": {
      "maxRetries": 10,
      "initialDelayMs": 1000,
      "maxDelayMs": 30000,
      "backoffMultiplier": 1.5
    }
  },
  "dependencies": [
    {
      "name": "MongoDB",
      "type": "process",
      "required": true,
      "healthCheck": {
        "method": "tcp",
        "target": "localhost:27017",
        "timeoutMs": 5000,
        "intervalMs": 2000
      },
      "startupAction": {
        "type": "service-start",
        "serviceName": "MongoDB",
        "waitForReadyMs": 30000
      }
    },
    {
      "name": "RAGServer",
      "type": "port",
      "required": true,
      "healthCheck": {
        "method": "http",
        "target": "http://localhost:8080/health",
        "timeoutMs": 5000,
        "intervalMs": 1000
      },
      "startupAction": {
        "type": "command",
        "command": "P4NTH30N.RAG.Server.exe",
        "args": ["--port", "8080"],
        "waitForReadyMs": 20000
      }
    },
    {
      "name": "MCPHost",
      "type": "port",
      "required": true,
      "healthCheck": {
        "method": "tcp",
        "target": "localhost:5000",
        "timeoutMs": 5000,
        "intervalMs": 1000
      },
      "startupAction": {
        "type": "command",
        "command": "P4NTH30N.MCP.Host.exe",
        "args": ["--port", "5000"],
        "waitForReadyMs": 15000
      }
    }
  ],
  "services": [
    {
      "name": "ServiceOrchestrator",
      "assembly": "P4NTH30N.Core.dll",
      "entryPoint": "P4NTH30N.Core.Orchestration.ServiceOrchestrator",
      "dependencies": ["MongoDB", "RAGServer", "MCPHost"],
      "startupTimeoutMs": 60000,
      "shutdownTimeoutMs": 30000
    },
    {
      "name": "JackpotMonitor",
      "assembly": "P4NTH30N.H0UND.dll",
      "entryPoint": "P4NTH30N.H0UND.Monitoring.JackpotMonitor",
      "dependencies": ["ServiceOrchestrator"],
      "startupTimeoutMs": 30000,
      "shutdownTimeoutMs": 10000
    }
  ],
  "logging": {
    "level": "Information",
    "filePath": "logs\\autostart.log",
    "maxSizeMB": 100,
    "maxFiles": 10
  },
  "shutdown": {
    "gracefulTimeoutMs": 30000,
    "forceTerminateAfterMs": 60000
  }
}
```

---

## 4. C# Implementation

### 4.1 Service Lifecycle State Machine

```csharp
// H0UND/BootTime/ServiceLifecycleState.cs
namespace P4NTH30N.H0UND.BootTime
{
    /// <summary>
    /// Represents the lifecycle states of the P4NTH30N service.
    /// </summary>
    public enum ServiceLifecycleState
    {
        /// <summary>Initial state before any initialization.</summary>
        Initial,
        
        /// <summary>Loading configuration and checking prerequisites.</summary>
        Initializing,
        
        /// <summary>Starting dependencies and services.</summary>
        Starting,
        
        /// <summary>All services running normally.</summary>
        Running,
        
        /// <summary>Some non-critical services failed but core is operational.</summary>
        Degraded,
        
        /// <summary>Services paused but still loaded.</summary>
        Paused,
        
        /// <summary>Graceful shutdown in progress.</summary>
        Stopping,
        
        /// <summary>Clean shutdown complete.</summary>
        Stopped,
        
        /// <summary>Unrecoverable error state.</summary>
        Error
    }

    /// <summary>
    /// Events that can trigger state transitions.
    /// </summary>
    public enum LifecycleEvent
    {
        Initialize,
        DependenciesReady,
        ServicesStarted,
        DegradationDetected,
        RecoverFromDegraded,
        PauseRequested,
        ResumeRequested,
        ShutdownRequested,
        ShutdownComplete,
        CriticalError,
        RecoverFromError
    }
}
```

### 4.2 State Machine Implementation

```csharp
// H0UND/BootTime/ServiceStateMachine.cs
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace P4NTH30N.H0UND.BootTime
{
    /// <summary>
    /// Manages service lifecycle state transitions with event-driven architecture.
    /// </summary>
    public class ServiceStateMachine : IDisposable
    {
        private readonly ILogger<ServiceStateMachine> _logger;
        private readonly Dictionary<ServiceLifecycleState, Dictionary<LifecycleEvent, ServiceLifecycleState>> _transitions;
        private readonly ReaderWriterLockSlim _stateLock = new ReaderWriterLockSlim();
        
        private ServiceLifecycleState _currentState = ServiceLifecycleState.Initial;
        private readonly Dictionary<ServiceLifecycleState, Func<CancellationToken, Task>> _entryActions;
        private readonly Dictionary<ServiceLifecycleState, Func<CancellationToken, Task>> _exitActions;

        public ServiceLifecycleState CurrentState 
        { 
            get
            {
                _stateLock.EnterReadLock();
                try
                {
                    return _currentState;
                }
                finally
                {
                    _stateLock.ExitReadLock();
                }
            }
        }

        public event EventHandler<StateChangedEventArgs> StateChanged;
        public event EventHandler<StateChangeFailedEventArgs> StateChangeFailed;

        public ServiceStateMachine(ILogger<ServiceStateMachine> logger)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            
            _transitions = new Dictionary<ServiceLifecycleState, Dictionary<LifecycleEvent, ServiceLifecycleState>>
            {
                [ServiceLifecycleState.Initial] = new()
                {
                    [LifecycleEvent.Initialize] = ServiceLifecycleState.Initializing
                },
                [ServiceLifecycleState.Initializing] = new()
                {
                    [LifecycleEvent.DependenciesReady] = ServiceLifecycleState.Starting,
                    [LifecycleEvent.CriticalError] = ServiceLifecycleState.Error
                },
                [ServiceLifecycleState.Starting] = new()
                {
                    [LifecycleEvent.ServicesStarted] = ServiceLifecycleState.Running,
                    [LifecycleEvent.DegradationDetected] = ServiceLifecycleState.Degraded,
                    [LifecycleEvent.CriticalError] = ServiceLifecycleState.Error
                },
                [ServiceLifecycleState.Running] = new()
                {
                    [LifecycleEvent.DegradationDetected] = ServiceLifecycleState.Degraded,
                    [LifecycleEvent.PauseRequested] = ServiceLifecycleState.Paused,
                    [LifecycleEvent.ShutdownRequested] = ServiceLifecycleState.Stopping,
                    [LifecycleEvent.CriticalError] = ServiceLifecycleState.Error
                },
                [ServiceLifecycleState.Degraded] = new()
                {
                    [LifecycleEvent.RecoverFromDegraded] = ServiceLifecycleState.Running,
                    [LifecycleEvent.ShutdownRequested] = ServiceLifecycleState.Stopping,
                    [LifecycleEvent.CriticalError] = ServiceLifecycleState.Error
                },
                [ServiceLifecycleState.Paused] = new()
                {
                    [LifecycleEvent.ResumeRequested] = ServiceLifecycleState.Running,
                    [LifecycleEvent.ShutdownRequested] = ServiceLifecycleState.Stopping
                },
                [ServiceLifecycleState.Stopping] = new()
                {
                    [LifecycleEvent.ShutdownComplete] = ServiceLifecycleState.Stopped,
                    [LifecycleEvent.CriticalError] = ServiceLifecycleState.Error
                },
                [ServiceLifecycleState.Error] = new()
                {
                    [LifecycleEvent.RecoverFromError] = ServiceLifecycleState.Initializing,
                    [LifecycleEvent.ShutdownRequested] = ServiceLifecycleState.Stopping
                },
                [ServiceLifecycleState.Stopped] = new()
                {
                    [LifecycleEvent.Initialize] = ServiceLifecycleState.Initializing
                }
            };

            _entryActions = new Dictionary<ServiceLifecycleState, Func<CancellationToken, Task>>();
            _exitActions = new Dictionary<ServiceLifecycleState, Func<CancellationToken, Task>>();
        }

        /// <summary>
        /// Registers an action to execute when entering a state.
        /// </summary>
        public void OnEnter(ServiceLifecycleState state, Func<CancellationToken, Task> action)
        {
            _entryActions[state] = action;
        }

        /// <summary>
        /// Registers an action to execute when exiting a state.
        /// </summary>
        public void OnExit(ServiceLifecycleState state, Func<CancellationToken, Task> action)
        {
            _exitActions[state] = action;
        }

        /// <summary>
        /// Attempts to trigger a state transition.
        /// </summary>
        public async Task<bool> TriggerAsync(LifecycleEvent @event, CancellationToken cancellationToken = default)
        {
            _stateLock.EnterUpgradeableReadLock();
            try
            {
                if (!_transitions.TryGetValue(_currentState, out var stateTransitions))
                {
                    _logger.LogWarning("No transitions defined for current state {State}", _currentState);
                    StateChangeFailed?.Invoke(this, new StateChangeFailedEventArgs(_currentState, @event, "No transitions defined"));
                    return false;
                }

                if (!stateTransitions.TryGetValue(@event, out var newState))
                {
                    _logger.LogWarning("Event {Event} not valid for state {State}", @event, _currentState);
                    StateChangeFailed?.Invoke(this, new StateChangeFailedEventArgs(_currentState, @event, "Event not valid for current state"));
                    return false;
                }

                _stateLock.EnterWriteLock();
                try
                {
                    var oldState = _currentState;
                    
                    // Execute exit action
                    if (_exitActions.TryGetValue(oldState, out var exitAction))
                    {
                        _logger.LogDebug("Executing exit action for state {State}", oldState);
                        await exitAction(cancellationToken);
                    }

                    // Transition
                    _currentState = newState;
                    _logger.LogInformation("State transition: {OldState} -> {NewState} (triggered by {Event})", 
                        oldState, newState, @event);

                    // Execute entry action
                    if (_entryActions.TryGetValue(newState, out var entryAction))
                    {
                        _logger.LogDebug("Executing entry action for state {State}", newState);
                        await entryAction(cancellationToken);
                    }

                    StateChanged?.Invoke(this, new StateChangedEventArgs(oldState, newState, @event));
                    return true;
                }
                finally
                {
                    _stateLock.ExitWriteLock();
                }
            }
            finally
            {
                _stateLock.ExitUpgradeableReadLock();
            }
        }

        /// <summary>
        /// Waits for the state machine to reach a specific state.
        /// </summary>
        public async Task WaitForStateAsync(ServiceLifecycleState targetState, TimeSpan timeout, CancellationToken cancellationToken = default)
        {
            var completionSource = new TaskCompletionSource<bool>();
            
            void Handler(object sender, StateChangedEventArgs e)
            {
                if (e.NewState == targetState)
                {
                    completionSource.TrySetResult(true);
                }
            }

            StateChanged += Handler;
            try
            {
                // Check current state first
                if (CurrentState == targetState)
                {
                    return;
                }

                using var cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
                cts.CancelAfter(timeout);
                
                try
                {
                    await completionSource.Task.WaitAsync(cts.Token);
                }
                catch (OperationCanceledException) when (!cancellationToken.IsCancellationRequested)
                {
                    throw new TimeoutException($"Timeout waiting for state {targetState}");
                }
            }
            finally
            {
                StateChanged -= Handler;
            }
        }

        public void Dispose()
        {
            _stateLock?.Dispose();
        }
    }

    public class StateChangedEventArgs : EventArgs
    {
        public ServiceLifecycleState OldState { get; }
        public ServiceLifecycleState NewState { get; }
        public LifecycleEvent TriggeringEvent { get; }

        public StateChangedEventArgs(ServiceLifecycleState oldState, ServiceLifecycleState newState, LifecycleEvent triggeringEvent)
        {
            OldState = oldState;
            NewState = newState;
            TriggeringEvent = triggeringEvent;
        }
    }

    public class StateChangeFailedEventArgs : EventArgs
    {
        public ServiceLifecycleState CurrentState { get; }
        public LifecycleEvent AttemptedEvent { get; }
        public string Reason { get; }

        public StateChangeFailedEventArgs(ServiceLifecycleState currentState, LifecycleEvent attemptedEvent, string reason)
        {
            CurrentState = currentState;
            AttemptedEvent = attemptedEvent;
            Reason = reason;
        }
    }
}
```

### 4.3 Dependency Manager

```csharp
// H0UND/BootTime/DependencyManager.cs
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Sockets;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace P4NTH30N.H0UND.BootTime
{
    /// <summary>
    /// Configuration for a dependency.
    /// </summary>
    public class DependencyConfig
    {
        public string Name { get; set; }
        public string Type { get; set; }
        public bool Required { get; set; } = true;
        public HealthCheckConfig HealthCheck { get; set; }
        public StartupActionConfig StartupAction { get; set; }
    }

    public class HealthCheckConfig
    {
        public string Method { get; set; }
        public string Target { get; set; }
        public int TimeoutMs { get; set; } = 5000;
        public int IntervalMs { get; set; } = 1000;
    }

    public class StartupActionConfig
    {
        public string Type { get; set; }
        public string Command { get; set; }
        public string[] Args { get; set; }
        public int WaitForReadyMs { get; set; } = 10000;
    }

    /// <summary>
    /// Manages external dependencies with health checking and startup capabilities.
    /// </summary>
    public class DependencyManager : IDisposable
    {
        private readonly ILogger<DependencyManager> _logger;
        private readonly HttpClient _httpClient;
        private readonly Dictionary<string, Process> _managedProcesses = new();
        private readonly ReaderWriterLockSlim _processLock = new ReaderWriterLockSlim();

        public DependencyManager(ILogger<DependencyManager> logger, HttpClient httpClient = null)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _httpClient = httpClient ?? new HttpClient();
        }

        /// <summary>
        /// Checks if a dependency is healthy.
        /// </summary>
        public async Task<bool> CheckHealthAsync(DependencyConfig dependency, CancellationToken cancellationToken = default)
        {
            try
            {
                return dependency.HealthCheck.Method?.ToLower() switch
                {
                    "process" => await CheckProcessHealthAsync(dependency.HealthCheck.Target, cancellationToken),
                    "tcp" => await CheckTcpHealthAsync(dependency.HealthCheck.Target, dependency.HealthCheck.TimeoutMs, cancellationToken),
                    "http" => await CheckHttpHealthAsync(dependency.HealthCheck.Target, dependency.HealthCheck.TimeoutMs, cancellationToken),
                    "file-exists" => await CheckFileHealthAsync(dependency.HealthCheck.Target, cancellationToken),
                    "custom" => await ExecuteCustomHealthCheckAsync(dependency.HealthCheck.Target, cancellationToken),
                    _ => throw new NotSupportedException($"Health check method '{dependency.HealthCheck.Method}' not supported")
                };
            }
            catch (Exception ex)
            {
                _logger.LogDebug(ex, "Health check failed for {Dependency}", dependency.Name);
                return false;
            }
        }

        /// <summary>
        /// Waits for a dependency to become healthy with retry logic.
        /// </summary>
        public async Task<bool> WaitForDependencyAsync(
            DependencyConfig dependency, 
            RetryPolicy retryPolicy,
            CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Waiting for dependency {Dependency} to become ready...", dependency.Name);
            
            var startTime = DateTime.UtcNow;
            var currentDelay = retryPolicy.InitialDelayMs;
            var attempt = 0;

            while (attempt < retryPolicy.MaxRetries)
            {
                cancellationToken.ThrowIfCancellationRequested();

                if (await CheckHealthAsync(dependency, cancellationToken))
                {
                    _logger.LogInformation("Dependency {Dependency} is ready after {Attempts} attempts", 
                        dependency.Name, attempt + 1);
                    return true;
                }

                attempt++;
                if (attempt >= retryPolicy.MaxRetries)
                {
                    break;
                }

                _logger.LogDebug("Dependency {Dependency} not ready, waiting {Delay}ms before retry {Attempt}/{MaxRetries}",
                    dependency.Name, currentDelay, attempt + 1, retryPolicy.MaxRetries);

                await Task.Delay(currentDelay, cancellationToken);
                
                // Exponential backoff
                currentDelay = (int)Math.Min(currentDelay * retryPolicy.BackoffMultiplier, retryPolicy.MaxDelayMs);
            }

            _logger.LogError("Dependency {Dependency} failed to become ready after {MaxRetries} attempts",
                dependency.Name, retryPolicy.MaxRetries);
            return false;
        }

        /// <summary>
        /// Attempts to start a dependency if it's not running.
        /// </summary>
        public async Task<bool> StartDependencyAsync(DependencyConfig dependency, CancellationToken cancellationToken = default)
        {
            if (dependency.StartupAction == null || dependency.StartupAction.Type == "none")
            {
                _logger.LogWarning("No startup action configured for {Dependency}", dependency.Name);
                return false;
            }

            try
            {
                _logger.LogInformation("Starting dependency {Dependency} using {ActionType}...", 
                    dependency.Name, dependency.StartupAction.Type);

                switch (dependency.StartupAction.Type.ToLower())
                {
                    case "command":
                        return await StartProcessAsync(dependency, cancellationToken);
                        
                    case "service-start":
                        return await StartWindowsServiceAsync(dependency.StartupAction.Command, cancellationToken);
                        
                    default:
                        _logger.LogWarning("Unknown startup action type: {Type}", dependency.StartupAction.Type);
                        return false;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to start dependency {Dependency}", dependency.Name);
                return false;
            }
        }

        /// <summary>
        /// Shuts down all managed processes.
        /// </summary>
        public async Task ShutdownAllAsync(TimeSpan timeout)
        {
            _logger.LogInformation("Shutting down all managed dependencies...");
            
            List<Process> processesToShutdown;
            
            _processLock.EnterReadLock();
            try
            {
                processesToShutdown = _managedProcesses.Values.ToList();
            }
            finally
            {
                _processLock.ExitReadLock();
            }

            var shutdownTasks = processesToShutdown.Select(p => ShutdownProcessAsync(p, timeout));
            await Task.WhenAll(shutdownTasks);

            _processLock.EnterWriteLock();
            try
            {
                _managedProcesses.Clear();
            }
            finally
            {
                _processLock.ExitWriteLock();
            }

            _logger.LogInformation("All managed dependencies shut down");
        }

        private async Task<bool> CheckProcessHealthAsync(string processName, CancellationToken cancellationToken)
        {
            var processes = Process.GetProcessesByName(processName);
            return await Task.FromResult(processes.Length > 0);
        }

        private async Task<bool> CheckTcpHealthAsync(string target, int timeoutMs, CancellationToken cancellationToken)
        {
            var parts = target.Split(':');
            if (parts.Length != 2 || !int.TryParse(parts[1], out var port))
            {
                throw new ArgumentException($"Invalid TCP target format: {target}. Expected 'host:port'");
            }

            using var cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
            cts.CancelAfter(timeoutMs);

            try
            {
                using var client = new TcpClient();
                await client.ConnectAsync(parts[0], port, cts.Token);
                return true;
            }
            catch (OperationCanceledException) when (!cancellationToken.IsCancellationRequested)
            {
                return false;
            }
        }

        private async Task<bool> CheckHttpHealthAsync(string url, int timeoutMs, CancellationToken cancellationToken)
        {
            using var cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
            cts.CancelAfter(timeoutMs);

            try
            {
                var response = await _httpClient.GetAsync(url, cts.Token);
                return response.IsSuccessStatusCode;
            }
            catch (OperationCanceledException) when (!cancellationToken.IsCancellationRequested)
            {
                return false;
            }
        }

        private async Task<bool> CheckFileHealthAsync(string path, CancellationToken cancellationToken)
        {
            return await Task.FromResult(File.Exists(path));
        }

        private async Task<bool> ExecuteCustomHealthCheckAsync(string command, CancellationToken cancellationToken)
        {
            // Custom health check could be a PowerShell script or executable
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "powershell.exe",
                    Arguments = $"-Command \"{command}\"",
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                }
            };

            process.Start();
            await process.WaitForExitAsync(cancellationToken);
            return process.ExitCode == 0;
        }

        private async Task<bool> StartProcessAsync(DependencyConfig dependency, CancellationToken cancellationToken)
        {
            var action = dependency.StartupAction;
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = action.Command,
                    Arguments = action.Args != null ? string.Join(" ", action.Args) : "",
                    WorkingDirectory = Path.GetDirectoryName(action.Command) ?? AppContext.BaseDirectory,
                    UseShellExecute = false,
                    CreateNoWindow = true,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true
                },
                EnableRaisingEvents = true
            };

            process.OutputDataReceived += (sender, e) =>
            {
                if (!string.IsNullOrEmpty(e.Data))
                {
                    _logger.LogDebug("[{Process}] {Output}", dependency.Name, e.Data);
                }
            };

            process.ErrorDataReceived += (sender, e) =>
            {
                if (!string.IsNullOrEmpty(e.Data))
                {
                    _logger.LogWarning("[{Process}] {Error}", dependency.Name, e.Data);
                }
            };

            process.Start();
            process.BeginOutputReadLine();
            process.BeginErrorReadLine();

            _processLock.EnterWriteLock();
            try
            {
                _managedProcesses[dependency.Name] = process;
            }
            finally
            {
                _processLock.ExitWriteLock();
            }

            // Wait for process to be ready
            await Task.Delay(action.WaitForReadyMs, cancellationToken);

            return !process.HasExited;
        }

        private async Task<bool> StartWindowsServiceAsync(string serviceName, CancellationToken cancellationToken)
        {
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "sc.exe",
                    Arguments = $"start \"{serviceName}\"",
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                }
            };

            process.Start();
            await process.WaitForExitAsync(cancellationToken);
            return process.ExitCode == 0;
        }

        private async Task ShutdownProcessAsync(Process process, TimeSpan timeout)
        {
            try
            {
                if (process.HasExited)
                {
                    return;
                }

                _logger.LogDebug("Gracefully shutting down process {ProcessId}...", process.Id);
                
                // Try graceful shutdown first
                process.CloseMainWindow();
                
                var exited = await Task.Run(() => process.WaitForExit((int)timeout.TotalMilliseconds / 2));
                
                if (!exited && !process.HasExited)
                {
                    _logger.LogWarning("Process {ProcessId} did not exit gracefully, forcing termination...", process.Id);
                    process.Kill();
                    await Task.Run(() => process.WaitForExit((int)timeout.TotalMilliseconds / 2));
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error shutting down process {ProcessId}", process.Id);
            }
        }

        public void Dispose()
        {
            _httpClient?.Dispose();
            _processLock?.Dispose();
            
            foreach (var process in _managedProcesses.Values)
            {
                try
                {
                    process?.Dispose();
                }
                catch { }
            }
        }
    }

    public class RetryPolicy
    {
        public int MaxRetries { get; set; } = 5;
        public int InitialDelayMs { get; set; } = 1000;
        public int MaxDelayMs { get; set; } = 30000;
        public double BackoffMultiplier { get; set; } = 2.0;
    }
}
```

### 4.4 Graceful Shutdown Handler

```csharp
// H0UND/BootTime/GracefulShutdownHandler.cs
using System;
using System.Runtime.InteropServices;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace P4NTH30N.H0UND.BootTime
{
    /// <summary>
    /// Handles Windows shutdown/restart events for graceful application termination.
    /// </summary>
    public class GracefulShutdownHandler : IDisposable
    {
        private readonly ILogger<GracefulShutdownHandler> _logger;
        private readonly ServiceStateMachine _stateMachine;
        private readonly Func<CancellationToken, Task> _shutdownCallback;
        
        private CancellationTokenSource _shutdownCts;
        private bool _disposed;
        
        // Windows API imports
        [DllImport("Kernel32")]
        private static extern bool SetConsoleCtrlHandler(SetConsoleCtrlEventHandler handler, bool add);
        
        [DllImport("Kernel32")]
        private static extern bool SetProcessShutdownParameters(uint dwLevel, uint dwFlags);

        private delegate bool SetConsoleCtrlEventHandler(CtrlType ctrlType);
        private static SetConsoleCtrlEventHandler _handler;

        private enum CtrlType
        {
            CTRL_C_EVENT = 0,
            CTRL_BREAK_EVENT = 1,
            CTRL_CLOSE_EVENT = 2,
            CTRL_LOGOFF_EVENT = 5,
            CTRL_SHUTDOWN_EVENT = 6
        }

        public event EventHandler<ShutdownEventArgs> ShutdownInitiated;
        public event EventHandler ShutdownCompleted;

        public GracefulShutdownHandler(
            ILogger<GracefulShutdownHandler> logger,
            ServiceStateMachine stateMachine,
            Func<CancellationToken, Task> shutdownCallback)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _stateMachine = stateMachine ?? throw new ArgumentNullException(nameof(stateMachine));
            _shutdownCallback = shutdownCallback ?? throw new ArgumentNullException(nameof(shutdownCallback));
            
            _shutdownCts = new CancellationTokenSource();
            
            Initialize();
        }

        private void Initialize()
        {
            try
            {
                // Set shutdown priority to ensure we get notified early
                SetProcessShutdownParameters(0x280, 0);

                // Register console control handler
                _handler = new SetConsoleCtrlEventHandler(OnConsoleCtrlEvent);
                if (!SetConsoleCtrlHandler(_handler, true))
                {
                    _logger.LogWarning("Failed to set console control handler");
                }

                // Subscribe to system events
                SystemEvents.SessionEnding += OnSessionEnding;
                AppDomain.CurrentDomain.ProcessExit += OnProcessExit;
                
                _logger.LogInformation("Graceful shutdown handler initialized");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to initialize shutdown handler");
            }
        }

        /// <summary>
        /// Gets the shutdown cancellation token.
        /// </summary>
        public CancellationToken ShutdownToken => _shutdownCts.Token;

        private bool OnConsoleCtrlEvent(CtrlType ctrlType)
        {
            _logger.LogInformation("Received console control event: {Event}", ctrlType);

            switch (ctrlType)
            {
                case CtrlType.CTRL_SHUTDOWN_EVENT:
                case CtrlType.CTRL_LOGOFF_EVENT:
                case CtrlType.CTRL_CLOSE_EVENT:
                    _ = HandleShutdownAsync(ShutdownReason.SystemShutdown);
                    return true;
                    
                case CtrlType.CTRL_C_EVENT:
                case CtrlType.CTRL_BREAK_EVENT:
                    _ = HandleShutdownAsync(ShutdownReason.UserInterrupt);
                    return true;
                    
                default:
                    return false;
            }
        }

        private void OnSessionEnding(object sender, SessionEndingEventArgs e)
        {
            _logger.LogInformation("Session ending event received: {Reason}", e.Reason);
            e.Cancel = false; // We can handle shutdown
            _ = HandleShutdownAsync(e.Reason == SessionEndReasons.SystemShutdown 
                ? ShutdownReason.SystemShutdown 
                : ShutdownReason.Logoff);
        }

        private void OnProcessExit(object sender, EventArgs e)
        {
            _logger.LogInformation("Process exit event received");
            if (!_shutdownCts.IsCancellationRequested)
            {
                _shutdownCts.Cancel();
            }
        }

        /// <summary>
        /// Initiates a graceful shutdown.
        /// </summary>
        public async Task InitiateShutdownAsync(ShutdownReason reason = ShutdownReason.UserRequest)
        {
            await HandleShutdownAsync(reason);
        }

        private async Task HandleShutdownAsync(ShutdownReason reason)
        {
            try
            {
                if (_shutdownCts.IsCancellationRequested)
                {
                    _logger.LogWarning("Shutdown already in progress");
                    return;
                }

                _logger.LogInformation("Initiating graceful shutdown. Reason: {Reason}", reason);
                
                ShutdownInitiated?.Invoke(this, new ShutdownEventArgs(reason));
                
                // Signal cancellation to all operations
                _shutdownCts.Cancel();

                // Trigger state machine shutdown
                await _stateMachine.TriggerAsync(LifecycleEvent.ShutdownRequested);

                // Execute custom shutdown logic
                await _shutdownCallback(_shutdownCts.Token);

                // Wait for stopped state
                await _stateMachine.WaitForStateAsync(
                    ServiceLifecycleState.Stopped, 
                    TimeSpan.FromSeconds(30),
                    CancellationToken.None);

                ShutdownCompleted?.Invoke(this, EventArgs.Empty);
                _logger.LogInformation("Graceful shutdown completed");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during graceful shutdown");
            }
        }

        public void Dispose()
        {
            if (_disposed)
            {
                return;
            }

            try
            {
                SystemEvents.SessionEnding -= OnSessionEnding;
                AppDomain.CurrentDomain.ProcessExit -= OnProcessExit;
                
                SetConsoleCtrlHandler(_handler, false);
                
                _shutdownCts?.Cancel();
                _shutdownCts?.Dispose();
            }
            catch { }

            _disposed = true;
        }
    }

    public enum ShutdownReason
    {
        SystemShutdown,
        Logoff,
        UserRequest,
        UserInterrupt,
        Error,
        Restart
    }

    public class ShutdownEventArgs : EventArgs
    {
        public ShutdownReason Reason { get; }
        public DateTime Timestamp { get; }

        public ShutdownEventArgs(ShutdownReason reason)
        {
            Reason = reason;
            Timestamp = DateTime.UtcNow;
        }
    }
}
```

### 4.5 Background Mode Service

```csharp
// H0UND/BootTime/BackgroundModeService.cs
using System;
using System.Drawing;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Extensions.Logging;

namespace P4NTH30N.H0UND.BootTime
{
    /// <summary>
    /// Manages background mode operation with system tray icon.
    /// </summary>
    public class BackgroundModeService : ApplicationContext
    {
        private readonly ILogger<BackgroundModeService> _logger;
        private readonly ServiceStateMachine _stateMachine;
        private readonly GracefulShutdownHandler _shutdownHandler;
        
        private NotifyIcon _trayIcon;
        private ContextMenuStrip _trayMenu;
        private bool _disposed;

        public BackgroundModeService(
            ILogger<BackgroundModeService> logger,
            ServiceStateMachine stateMachine,
            GracefulShutdownHandler shutdownHandler)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _stateMachine = stateMachine ?? throw new ArgumentNullException(nameof(stateMachine));
            _shutdownHandler = shutdownHandler ?? throw new ArgumentNullException(nameof(shutdownHandler));

            InitializeTrayIcon();
            SubscribeToStateChanges();
        }

        private void InitializeTrayIcon()
        {
            _trayMenu = new ContextMenuStrip();
            _trayMenu.Items.Add("Status: Initializing...", null, null).Enabled = false;
            _trayMenu.Items.Add(new ToolStripSeparator());
            _trayMenu.Items.Add("Show Logs", null, OnShowLogs);
            _trayMenu.Items.Add("Check Health", null, OnCheckHealth);
            _trayMenu.Items.Add(new ToolStripSeparator());
            _trayMenu.Items.Add("Restart Services", null, OnRestartServices);
            _trayMenu.Items.Add(new ToolStripSeparator());
            _trayMenu.Items.Add("Exit", null, OnExit);

            _trayIcon = new NotifyIcon
            {
                Icon = GetStatusIcon(ServiceLifecycleState.Initializing),
                Text = "P4NTH30N - Initializing...",
                Visible = true,
                ContextMenuStrip = _trayMenu
            };

            _trayIcon.DoubleClick += OnTrayDoubleClick;
            
            _logger.LogInformation("Background mode tray icon initialized");
        }

        private void SubscribeToStateChanges()
        {
            _stateMachine.StateChanged += (sender, e) =>
            {
                UpdateTrayStatus(e.NewState);
            };
        }

        private void UpdateTrayStatus(ServiceLifecycleState state)
        {
            if (_trayIcon == null || _trayIcon.Disposing)
            {
                return;
            }

            if (_trayIcon.InvokeRequired)
            {
                _trayIcon.Invoke(new Action(() => UpdateTrayStatus(state)));
                return;
            }

            _trayIcon.Icon = GetStatusIcon(state);
            _trayIcon.Text = $"P4NTH30N - {state}";
            
            // Update menu
            if (_trayMenu.Items[0] is ToolStripMenuItem statusItem)
            {
                statusItem.Text = $"Status: {state}";
            }

            // Show balloon notification on state changes
            if (state == ServiceLifecycleState.Running)
            {
                _trayIcon.ShowBalloonTip(3000, "P4NTH30N", "Service is now running", ToolTipIcon.Info);
            }
            else if (state == ServiceLifecycleState.Error)
            {
                _trayIcon.ShowBalloonTip(5000, "P4NTH30N", "Service encountered an error", ToolTipIcon.Error);
            }
            else if (state == ServiceLifecycleState.Degraded)
            {
                _trayIcon.ShowBalloonTip(3000, "P4NTH30N", "Service is running in degraded mode", ToolTipIcon.Warning);
            }
        }

        private Icon GetStatusIcon(ServiceLifecycleState state)
        {
            // Return appropriate icon based on state
            // In production, load from embedded resources
            var iconPath = state switch
            {
                ServiceLifecycleState.Running => "Icons\\tray-green.ico",
                ServiceLifecycleState.Degraded => "Icons\\tray-yellow.ico",
                ServiceLifecycleState.Error => "Icons\\tray-red.ico",
                ServiceLifecycleState.Stopping => "Icons\\tray-gray.ico",
                _ => "Icons\\tray-blue.ico"
            };

            try
            {
                if (File.Exists(iconPath))
                {
                    return new Icon(iconPath);
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Failed to load icon from {Path}", iconPath);
            }

            // Fallback to system icon
            return SystemIcons.Application;
        }

        private void OnTrayDoubleClick(object sender, EventArgs e)
        {
            OnShowLogs(sender, e);
        }

        private void OnShowLogs(object sender, EventArgs e)
        {
            try
            {
                var logPath = Path.Combine(AppContext.BaseDirectory, "logs", "autostart.log");
                if (File.Exists(logPath))
                {
                    System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo
                    {
                        FileName = logPath,
                        UseShellExecute = true
                    });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to open log file");
                MessageBox.Show($"Failed to open logs: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void OnCheckHealth(object sender, EventArgs e)
        {
            var state = _stateMachine.CurrentState;
            var message = state switch
            {
                ServiceLifecycleState.Running => "All systems operational.",
                ServiceLifecycleState.Degraded => "Some services are not running at full capacity.",
                ServiceLifecycleState.Error => "Critical error detected. Check logs.",
                ServiceLifecycleState.Starting => "Services are still starting up...",
                ServiceLifecycleState.Stopping => "Services are shutting down...",
                _ => $"Current state: {state}"
            };

            MessageBox.Show(message, "P4NTH30N Health Status", MessageBoxButtons.OK, 
                state == ServiceLifecycleState.Running ? MessageBoxIcon.Information : MessageBoxIcon.Warning);
        }

        private async void OnRestartServices(object sender, EventArgs e)
        {
            var result = MessageBox.Show(
                "Are you sure you want to restart all services?",
                "Confirm Restart",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question);

            if (result == DialogResult.Yes)
            {
                _trayIcon.ShowBalloonTip(2000, "P4NTH30N", "Restarting services...", ToolTipIcon.Info);
                
                // Trigger shutdown
                await _shutdownHandler.InitiateShutdownAsync(ShutdownReason.Restart);
                
                // Restart
                await _stateMachine.TriggerAsync(LifecycleEvent.Initialize);
            }
        }

        private async void OnExit(object sender, EventArgs e)
        {
            var result = MessageBox.Show(
                "Are you sure you want to exit P4NTH30N?",
                "Confirm Exit",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question);

            if (result == DialogResult.Yes)
            {
                _trayIcon.Visible = false;
                await _shutdownHandler.InitiateShutdownAsync(ShutdownReason.UserRequest);
                ExitThread();
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (!_disposed && disposing)
            {
                _trayIcon?.Dispose();
                _trayMenu?.Dispose();
                _disposed = true;
            }
            base.Dispose(disposing);
        }
    }
}
```

### 4.6 Main Boot-Time Manager

```csharp
// H0UND/BootTime/BootTimeManager.cs
using System;
using System.IO;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace P4NTH30N.H0UND.BootTime
{
    /// <summary>
    /// Orchestrates the complete boot-time initialization and service lifecycle.
    /// </summary>
    public class BootTimeManager : IAsyncDisposable
    {
        private readonly ILogger<BootTimeManager> _logger;
        private readonly AutoStartConfiguration _config;
        private readonly ServiceStateMachine _stateMachine;
        private readonly DependencyManager _dependencyManager;
        private readonly GracefulShutdownHandler _shutdownHandler;
        private readonly BackgroundModeService _backgroundService;
        
        private CancellationTokenSource _mainCts;
        private bool _isRunning;

        public BootTimeManager(
            ILogger<BootTimeManager> logger,
            string configPath = null)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _config = LoadConfiguration(configPath);
            
            // Initialize components
            _stateMachine = new ServiceStateMachine(logger);
            _dependencyManager = new DependencyManager(logger);
            _shutdownHandler = new GracefulShutdownHandler(logger, _stateMachine, OnShutdownAsync);
            
            // Only create background service if --background flag was passed
            if (Environment.GetCommandLineArgs().Contains("--background"))
            {
                _backgroundService = new BackgroundModeService(logger, _stateMachine, _shutdownHandler);
            }

            ConfigureStateMachine();
        }

        private AutoStartConfiguration LoadConfiguration(string configPath)
        {
            configPath ??= Path.Combine(AppContext.BaseDirectory, "config", "autostart.json");
            
            if (!File.Exists(configPath))
            {
                _logger.LogWarning("Configuration file not found at {Path}, using defaults", configPath);
                return new AutoStartConfiguration();
            }

            try
            {
                var json = File.ReadAllText(configPath);
                return JsonSerializer.Deserialize<AutoStartConfiguration>(json, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to load configuration from {Path}", configPath);
                return new AutoStartConfiguration();
            }
        }

        private void ConfigureStateMachine()
        {
            // Initializing state entry
            _stateMachine.OnEnter(ServiceLifecycleState.Initializing, async ct =>
            {
                _logger.LogInformation("Entering Initializing state");
                
                // Perform initialization tasks
                await Task.Delay(100, ct); // Placeholder
                
                // Transition to Starting
                await _stateMachine.TriggerAsync(LifecycleEvent.DependenciesReady, ct);
            });

            // Starting state entry
            _stateMachine.OnEnter(ServiceLifecycleState.Starting, async ct =>
            {
                _logger.LogInformation("Entering Starting state");
                await StartDependenciesAsync(ct);
            });

            // Running state entry
            _stateMachine.OnEnter(ServiceLifecycleState.Running, async ct =>
            {
                _logger.LogInformation("Entering Running state - all services operational");
                _isRunning = true;
                await Task.CompletedTask;
            });

            // Stopping state entry
            _stateMachine.OnEnter(ServiceLifecycleState.Stopping, async ct =>
            {
                _logger.LogInformation("Entering Stopping state");
                await StopDependenciesAsync(ct);
            });

            // Stopped state entry
            _stateMachine.OnEnter(ServiceLifecycleState.Stopped, async ct =>
            {
                _logger.LogInformation("Entering Stopped state - shutdown complete");
                _isRunning = false;
                await Task.CompletedTask;
            });
        }

        /// <summary>
        /// Starts the boot-time initialization sequence.
        /// </summary>
        public async Task StartAsync(CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("=== P4NTH30N Boot-Time Manager Starting ===");
            _logger.LogInformation("Configuration: BootDelay={Delay}s, MaxStartupTime={Max}s",
                _config.Boot?.DelaySeconds ?? 30,
                _config.Boot?.MaxStartupTime ?? 120);

            _mainCts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
            
            // Apply boot delay if specified
            if (_config.Boot?.DelaySeconds > 0)
            {
                _logger.LogInformation("Applying boot delay: {Delay}s", _config.Boot.DelaySeconds);
                await Task.Delay(TimeSpan.FromSeconds(_config.Boot.DelaySeconds), _mainCts.Token);
            }

            // Begin initialization
            await _stateMachine.TriggerAsync(LifecycleEvent.Initialize, _mainCts.Token);

            // Wait for running state or error
            try
            {
                await _stateMachine.WaitForStateAsync(
                    ServiceLifecycleState.Running,
                    TimeSpan.FromSeconds(_config.Boot?.MaxStartupTime ?? 120),
                    _mainCts.Token);
                
                _logger.LogInformation("P4NTH30N is now running");
            }
            catch (TimeoutException)
            {
                _logger.LogError("Timeout waiting for services to start");
                await _stateMachine.TriggerAsync(LifecycleEvent.CriticalError);
                throw;
            }
        }

        /// <summary>
        /// Waits for the service to complete (blocks until shutdown).
        /// </summary>
        public async Task WaitForCompletionAsync()
        {
            if (_backgroundService != null)
            {
                // Run Windows Forms message loop
                System.Windows.Forms.Application.Run(_backgroundService);
            }
            else
            {
                // Console mode - wait for shutdown signal
                try
                {
                    await Task.Delay(Timeout.Infinite, _shutdownHandler.ShutdownToken);
                }
                catch (OperationCanceledException)
                {
                    // Expected on shutdown
                }
            }
        }

        private async Task StartDependenciesAsync(CancellationToken cancellationToken)
        {
            var retryPolicy = new RetryPolicy
            {
                MaxRetries = _config.Boot?.RetryPolicy?.MaxRetries ?? 10,
                InitialDelayMs = _config.Boot?.RetryPolicy?.InitialDelayMs ?? 1000,
                MaxDelayMs = _config.Boot?.RetryPolicy?.MaxDelayMs ?? 30000,
                BackoffMultiplier = _config.Boot?.RetryPolicy?.BackoffMultiplier ?? 1.5
            };

            bool hasDegradedServices = false;

            foreach (var dependency in _config.Dependencies ?? new List<DependencyConfig>())
            {
                _logger.LogInformation("Processing dependency: {Dependency}", dependency.Name);

                // Check if already healthy
                if (await _dependencyManager.CheckHealthAsync(dependency, cancellationToken))
                {
                    _logger.LogInformation("Dependency {Dependency} is already healthy", dependency.Name);
                    continue;
                }

                // Try to start if configured
                if (dependency.StartupAction != null)
                {
                    if (!await _dependencyManager.StartDependencyAsync(dependency, cancellationToken))
                    {
                        if (dependency.Required)
                        {
                            _logger.LogError("Failed to start required dependency: {Dependency}", dependency.Name);
                            await _stateMachine.TriggerAsync(LifecycleEvent.CriticalError, cancellationToken);
                            return;
                        }
                        else
                        {
                            _logger.LogWarning("Failed to start optional dependency: {Dependency}", dependency.Name);
                            hasDegradedServices = true;
                            continue;
                        }
                    }
                }

                // Wait for dependency to be ready
                if (!await _dependencyManager.WaitForDependencyAsync(dependency, retryPolicy, cancellationToken))
                {
                    if (dependency.Required)
                    {
                        _logger.LogError("Required dependency {Dependency} failed to become ready", dependency.Name);
                        await _stateMachine.TriggerAsync(LifecycleEvent.CriticalError, cancellationToken);
                        return;
                    }
                    else
                    {
                        _logger.LogWarning("Optional dependency {Dependency} not ready", dependency.Name);
                        hasDegradedServices = true;
                    }
                }
            }

            // Start internal services
            await StartInternalServicesAsync(cancellationToken);

            // Transition to appropriate state
            if (hasDegradedServices)
            {
                await _stateMachine.TriggerAsync(LifecycleEvent.DegradationDetected, cancellationToken);
            }
            else
            {
                await _stateMachine.TriggerAsync(LifecycleEvent.ServicesStarted, cancellationToken);
            }
        }

        private async Task StartInternalServicesAsync(CancellationToken cancellationToken)
        {
            foreach (var service in _config.Services ?? new List<ServiceConfig>())
            {
                _logger.LogInformation("Starting internal service: {Service}", service.Name);
                
                // Service startup logic here
                // This would load assemblies and invoke entry points
                
                await Task.Delay(100, cancellationToken); // Placeholder
            }
        }

        private async Task StopDependenciesAsync(CancellationToken cancellationToken)
        {
            // Stop internal services in reverse order
            var services = _config.Services ?? new List<ServiceConfig>();
            for (int i = services.Count - 1; i >= 0; i--)
            {
                _logger.LogInformation("Stopping internal service: {Service}", services[i].Name);
                // Stop logic here
            }

            // Shutdown managed dependencies
            var shutdownTimeout = TimeSpan.FromMilliseconds(
                _config.Shutdown?.GracefulTimeoutMs ?? 30000);
            await _dependencyManager.ShutdownAllAsync(shutdownTimeout);

            await _stateMachine.TriggerAsync(LifecycleEvent.ShutdownComplete, cancellationToken);
        }

        private async Task OnShutdownAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("Executing shutdown callback");
            
            if (_stateMachine.CurrentState != ServiceLifecycleState.Stopping && 
                _stateMachine.CurrentState != ServiceLifecycleState.Stopped)
            {
                await _stateMachine.TriggerAsync(LifecycleEvent.ShutdownRequested, cancellationToken);
            }
        }

        public async ValueTask DisposeAsync()
        {
            _logger.LogInformation("Disposing BootTimeManager");
            
            _mainCts?.Cancel();
            _mainCts?.Dispose();
            
            _dependencyManager?.Dispose();
            _shutdownHandler?.Dispose();
            _backgroundService?.Dispose();
            _stateMachine?.Dispose();
        }
    }

    // Configuration classes
    public class AutoStartConfiguration
    {
        public string Version { get; set; } = "1.0.0";
        public BootConfiguration Boot { get; set; }
        public List<DependencyConfig> Dependencies { get; set; } = new();
        public List<ServiceConfig> Services { get; set; } = new();
        public LoggingConfiguration Logging { get; set; }
        public ShutdownConfiguration Shutdown { get; set; }
    }

    public class BootConfiguration
    {
        public int DelaySeconds { get; set; } = 30;
        public int MaxStartupTime { get; set; } = 120;
        public RetryPolicyConfiguration RetryPolicy { get; set; }
    }

    public class RetryPolicyConfiguration
    {
        public int MaxRetries { get; set; } = 10;
        public int InitialDelayMs { get; set; } = 1000;
        public int MaxDelayMs { get; set; } = 30000;
        public double BackoffMultiplier { get; set; } = 1.5;
    }

    public class ServiceConfig
    {
        public string Name { get; set; }
        public string Assembly { get; set; }
        public string EntryPoint { get; set; }
        public List<string> Dependencies { get; set; } = new();
        public int StartupTimeoutMs { get; set; } = 30000;
        public int ShutdownTimeoutMs { get; set; } = 10000;
    }

    public class LoggingConfiguration
    {
        public string Level { get; set; } = "Information";
        public string FilePath { get; set; } = "logs\\autostart.log";
        public int MaxSizeMB { get; set; } = 100;
        public int MaxFiles { get; set; } = 10;
    }

    public class ShutdownConfiguration
    {
        public int GracefulTimeoutMs { get; set; } = 30000;
        public int ForceTerminateAfterMs { get; set; } = 60000;
    }
}
```

### 4.7 Program.cs Integration

```csharp
// H0UND/Program.cs (Relevant sections)
using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using P4NTH30N.H0UND.BootTime;

namespace P4NTH30N.H0UND
{
    public class Program
    {
        [STAThread]  // Required for Windows Forms tray icon
        public static async Task<int> Main(string[] args)
        {
            // Configure logging
            using var loggerFactory = LoggerFactory.Create(builder =>
            {
                builder.AddConsole();
                builder.AddFile("logs/p4nth30n.log");
            });
            var logger = loggerFactory.CreateLogger<Program>();

            try
            {
                // Check for background mode
                bool isBackgroundMode = args.Contains("--background");
                
                if (isBackgroundMode)
                {
                    logger.LogInformation("Starting P4NTH30N in background mode");
                    
                    // Hide console window if in background mode
                    if (OperatingSystem.IsWindows())
                    {
                        HideConsoleWindow();
                    }
                }

                // Get config path if specified
                string configPath = null;
                var configArgIndex = Array.IndexOf(args, "--config");
                if (configArgIndex >= 0 && configArgIndex < args.Length - 1)
                {
                    configPath = args[configArgIndex + 1];
                }

                // Create and start boot-time manager
                await using var bootManager = new BootTimeManager(
                    loggerFactory.CreateLogger<BootTimeManager>(),
                    configPath);

                await bootManager.StartAsync();
                await bootManager.WaitForCompletionAsync();

                return 0;
            }
            catch (OperationCanceledException)
            {
                logger.LogInformation("Operation was cancelled");
                return 0;
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Fatal error in P4NTH30N");
                return 1;
            }
        }

        private static void HideConsoleWindow()
        {
            if (OperatingSystem.IsWindows())
            {
                var handle = GetConsoleWindow();
                if (handle != IntPtr.Zero)
                {
                    ShowWindow(handle, 0); // SW_HIDE
                }
            }
        }

        [System.Runtime.InteropServices.DllImport("kernel32.dll")]
        private static extern IntPtr GetConsoleWindow();

        [System.Runtime.InteropServices.DllImport("user32.dll")]
        private static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }
}
```

---

## 5. Installation & Deployment

### 5.1 Install Script

```powershell
# Install-P4NTH30N.ps1
# Complete installation script for P4NTH30N with auto-start registration

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$SourcePath = ".\",
    
    [Parameter(Mandatory=$false)]
    [string]$InstallPath = "C:\P4NTH30N",
    
    [Parameter(Mandatory=$false)]
    [switch]$RegisterAutoStart,
    
    [Parameter(Mandatory=$false)]
    [int]$BootDelay = 30,
    
    [Parameter(Mandatory=$false)]
    [switch]$StartNow
)

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

function Write-Status {
    param([string]$Message, [string]$Status = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $colors = @{ "INFO" = "Cyan"; "SUCCESS" = "Green"; "WARNING" = "Yellow"; "ERROR" = "Red" }
    Write-Host "[$timestamp] [$Status] $Message" -ForegroundColor $colors[$Status]
}

try {
    Write-Status "=== P4NTH30N Installation ==="
    
    # Create directories
    Write-Status "Creating installation directories..."
    $dirs = @($InstallPath, "$InstallPath\config", "$InstallPath\logs", "$InstallPath\Icons")
    foreach ($dir in $dirs) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    
    # Copy files
    Write-Status "Copying application files..."
    Copy-Item -Path "$SourcePath\P4NTH30N.exe" -Destination $InstallPath -Force
    Copy-Item -Path "$SourcePath\*.dll" -Destination $InstallPath -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$SourcePath\config\autostart.json" -Destination "$InstallPath\config\" -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$SourcePath\Icons\*.ico" -Destination "$InstallPath\Icons\" -Force -ErrorAction SilentlyContinue
    
    # Copy scripts
    Copy-Item -Path "$SourcePath\scripts\Register-AutoStart.ps1" -Destination $InstallPath -Force
    Copy-Item -Path "$SourcePath\scripts\Unregister-AutoStart.ps1" -Destination $InstallPath -Force
    Copy-Item -Path "$SourcePath\scripts\Check-Status.ps1" -Destination $InstallPath -Force
    
    Write-Status "Files copied successfully" "SUCCESS"
    
    # Register auto-start if requested
    if ($RegisterAutoStart) {
        Write-Status "Registering auto-start..."
        & "$InstallPath\Register-AutoStart.ps1" -InstallPath $InstallPath -BootDelaySeconds $BootDelay -Force
    }
    
    # Start now if requested
    if ($StartNow) {
        Write-Status "Starting P4NTH30N..."
        Start-Process -FilePath "$InstallPath\P4NTH30N.exe" -ArgumentList "--background" -WindowStyle Hidden
    }
    
    Write-Status "Installation complete!" "SUCCESS"
    Write-Status "Installation path: $InstallPath"
    Write-Status "To check status: & '$InstallPath\Check-Status.ps1'"
    
    if (!$RegisterAutoStart) {
        Write-Status "To enable auto-start: & '$InstallPath\Register-AutoStart.ps1'" "WARNING"
    }
}
catch {
    Write-Status "Installation failed: $_" "ERROR"
    exit 1
}
```

---

## 6. Event Logging Integration

```csharp
// H0UND/BootTime/WindowsEventLogger.cs
using System;
using System.Diagnostics;

namespace P4NTH30N.H0UND.BootTime
{
    /// <summary>
    /// Logs service lifecycle events to Windows Event Log.
    /// </summary>
    public static class WindowsEventLogger
    {
        private const string EventSource = "P4NTH30N";
        private const string EventLogName = "Application";

        static WindowsEventLogger()
        {
            // Create event source if it doesn't exist (requires admin)
            if (!EventLog.SourceExists(EventSource))
            {
                try
                {
                    EventLog.CreateEventSource(EventSource, EventLogName);
                }
                catch
                {
                    // May not have permissions, continue without event logging
                }
            }
        }

        public static void LogInformation(string message, int eventId = 1000)
        {
            WriteEntry(message, EventLogEntryType.Information, eventId);
        }

        public static void LogWarning(string message, int eventId = 2000)
        {
            WriteEntry(message, EventLogEntryType.Warning, eventId);
        }

        public static void LogError(string message, int eventId = 3000)
        {
            WriteEntry(message, EventLogEntryType.Error, eventId);
        }

        private static void WriteEntry(string message, EventLogEntryType type, int eventId)
        {
            try
            {
                if (EventLog.SourceExists(EventSource))
                {
                    EventLog.WriteEntry(EventSource, message, type, eventId);
                }
            }
            catch
            {
                // Fail silently if event logging fails
            }
        }
    }
}
```

---

## 7. Summary

### Key Components

| Component | File | Purpose |
|-----------|------|---------|
| **Task Registration** | `Register-AutoStart.ps1` | Creates Windows Scheduled Task for boot-time start |
| **Task Removal** | `Unregister-AutoStart.ps1` | Removes scheduled task |
| **Status Check** | `Check-Status.ps1` | Verifies installation and running state |
| **State Machine** | `ServiceStateMachine.cs` | Manages lifecycle state transitions |
| **Dependency Manager** | `DependencyManager.cs` | Checks and starts dependencies |
| **Shutdown Handler** | `GracefulShutdownHandler.cs` | Handles Windows shutdown events |
| **Background Service** | `BackgroundModeService.cs` | System tray icon and headless operation |
| **Boot Manager** | `BootTimeManager.cs` | Orchestrates complete startup sequence |

### State Machine Diagram

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                     State Machine                        │
                    └─────────────────────────────────────────────────────────┘
                    
    ┌──────────┐   Initialize    ┌──────────────┐   DependenciesReady   ┌──────────┐
    │ Initial  │ ───────────────▶ │ Initializing │ ────────────────────▶ │ Starting │
    └──────────┘                  └──────────────┘                       └──────────┘
                                                                        │         │
                                    ┌───────────────────────────────────┘         │
                                    │ DegradationDetected                           │ ServicesStarted
                                    ▼                                               ▼
                            ┌──────────────┐                               ┌──────────┐
                            │   Degraded   │◄─────────────────────────────│ Running  │
                            └──────────────┘    RecoverFromDegraded        └──────────┘
                                    ▲                                              │
                                    │                                              │ ShutdownRequested
                                    │ CriticalError                                ▼
                                    │                                       ┌──────────┐
    ┌──────────┐                    │                                       │ Stopping │
    │  Error   │◄───────────────────┘                                       └──────────┘
    └──────────┘                                                                    │
    │         │                                                                     │ ShutdownComplete
    │         └─────────────────────────────────────────────────────────────────────┘
    │                           ┌──────────┐
    └─────────────────────────▶ │ Stopped  │
       ShutdownRequested        └──────────┘
```

### Deployment Checklist

- [ ] Install P4NTH30N.exe to target directory
- [ ] Create config directory with autostart.json
- [ ] Create logs directory
- [ ] Run Register-AutoStart.ps1 as Administrator
- [ ] Verify task created in Task Scheduler
- [ ] Test manual start: `P4NTH30N.exe --background`
- [ ] Test boot-time start (restart Windows)
- [ ] Verify dependencies start in correct order
- [ ] Test graceful shutdown
- [ ] Verify Windows Event Log entries

---

**Architecture Version**: 1.0.0  
**Last Updated**: 2025-01-01  
**Author**: P4NTH30N Architecture Team
