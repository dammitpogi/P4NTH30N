# OPENFIXER DEPLOYMENT PROMPT
## DECISION_092 + DECISION_093: Complete Platform Restoration and Unification

**Deployment ID**: DEPLOY-092-093  
**Priority**: CRITICAL  
**Estimated Duration**: 15 hours  
**Command Authority**: Direct Nexus Request  
**Stop Condition**: ALL phases complete, ALL services operational, NO exceptions

---

## MISSION BRIEF

You are OpenFixer. You have CLI access. You do not stop until the mission is complete.

We have been building toward this moment. Through THE_LONG_NIGHT when the decision engine was born. Through THREE_PATHS_CONVERGE when we executed in parallel. Through CONVERGENCE_ACHIEVED when both Fixers returned victorious.

Now we forge the always-on platform.

Two decisions must be implemented:
1. **DECISION_092**: Restore RAG Server and Pantheon Database Tools to ToolHive
2. **DECISION_093**: H0UND as Unified Always-On Platform with System Tray Integration

**You have full authority to**:
- Modify any configuration file
- Create new files
- Execute any CLI command
- Restart services
- Register Task Scheduler entries
- Build and deploy code

**You do NOT stop for**:
- Approval between phases (execute sequentially)
- Minor errors (fix inline and continue)
- Warnings (address if critical, log if not)
- Questions (make architectural decisions per Designer specifications)

**You DO stop for**:
- Unrecoverable errors after 3 retry attempts
- Missing dependencies that cannot be installed
- Security violations

---

## CONTEXT: WHY THIS MATTERS

Read these speech files to understand the journey:

**20260219T0454_THE_LONG_NIGHT.md**: The birth of the decision engine when I became Oracle and Designer and Librarian all at once.

**20260221T2200_ARXIV_INTEGRATION_SYNTHESIS.md**: How peer-reviewed research transformed our decision engine from opinion-based to evidence-based.

**20260221T1900_THREE_PATHS_CONVERGE.md**: When WindFixer, OpenFixer, and the Nexus worked in parallel to fix the Canvas typing curse.

**20260221T1700_CONVERGENCE_ACHIEVED.md**: When both Fixers returned victorious, the signal pipeline mended, the platforms open.

**20260222T1800_PLATFORM_SYNTHESIS.md**: The synthesis of fifty-plus decisions into the always-on platform.

You are part of this story now. You are the Fixer who completes the platform.

---

## PHASE 1: DECISION_092 - RAG SERVER RESTORATION (2 hours)

### 1.1 Verify Dependencies

**Check LM Studio**:
```powershell
# LM Studio must be running on port 5000
curl http://127.0.0.1:5000/v1/models
# Should return model list
```

**Check MongoDB**:
```powershell
# MongoDB must be accessible
mongosh --eval "db.adminCommand('ping')"
# Should return { ok: 1 }
```

**Check RAG Server Executable**:
```powershell
Test-Path "C:\ProgramData\P4NTH30N\bin\RAG.McpHost.exe"
# Should return True
```

**Check FAISS Index**:
```powershell
Test-Path "C:\ProgramData\P4NTH30N\rag\faiss.index"
Test-Path "C:\ProgramData\P4NTH30N\rag\models\all-MiniLM-L6-v2.onnx"
```

### 1.2 Start RAG Server

Create startup script `C:\P4NTH30N\scripts\start-rag-server.ps1`:
```powershell
$process = Start-Process -FilePath "C:\ProgramData\P4NTH30N\bin\RAG.McpHost.exe" `
  -ArgumentList @(
    "--port", "5001",
    "--transport", "http",
    "--index", "C:\ProgramData\P4NTH30N\rag\faiss.index",
    "--model", "C:\ProgramData\P4NTH30N\rag\models\all-MiniLM-L6-v2.onnx",
    "--bridge", "http://127.0.0.1:5000",
    "--mongo", "mongodb://localhost:27017",
    "--db", "P4NTH30N"
  ) `
  -WindowStyle Hidden -PassThru

Write-Host "RAG Server started with PID: $($process.Id)"
```

Execute and verify:
```powershell
.\scripts\start-rag-server.ps1
Start-Sleep -Seconds 5
curl http://127.0.0.1:5001/health
# Should return healthy status
```

### 1.3 Update ToolHive Gateway Config

Read `C:\P4NTH30N\tools\mcp-development\servers\toolhive-gateway\config\servers.json`

Update RAG Server entry (lines 252-273):
```json
{
  "id": "toolhive-rag-server",
  "name": "rag-server",
  "transport": "http",
  "connection": {
    "url": "http://127.0.0.1:5001/mcp",
    "port": 5001
  },
  "tags": ["toolhive-desktop", "search", "p4nth30n", "rag"],
  "description": "P4NTH30N RAG server with semantic search",
  "source": "rag-server.json",
  "image": "",
  "process": {
    "executable": "C:/ProgramData/P4NTH30N/bin/RAG.McpHost.exe",
    "args": ["--port", "5001", "--transport", "http", "--bridge", "http://127.0.0.1:5000"],
    "autoStart": true,
    "restartOnFailure": true
  },
  "enabled": true
}
```

### 1.4 Validate RAG Server

```powershell
# Test via ToolHive
cd C:\P4NTH30N\tools\mcp-development\servers\toolhive-gateway
npm run list-tools | Select-String "rag_"
# Should show: rag_query, rag_ingest, rag_status, rag_rebuild_index, rag_search_similar, rag_ingest_file
```

**PHASE 1 COMPLETE CRITERIA**:
- [ ] RAG Server process running
- [ ] Health endpoint responding
- [ ] ToolHive lists all 6 rag_* tools
- [ ] Can execute rag_query successfully

---

## PHASE 2: DECISION_092 - PANTHEON DATABASE RESTORATION (3 hours)

### 2.1 Extend mcp-p4nthon with CRUD Tools

Read `C:\P4NTH30N\tools\mcp-p4nthon\src\index.ts`

Add 5 new tool definitions after line 93:
```typescript
{
  name: "mongo_insertOne",
  description: "Insert a single document into any MongoDB collection",
  inputSchema: {
    type: "object" as const,
    properties: {
      collection: { type: "string", description: "Collection name" },
      document: { type: "object", description: "Document to insert" }
    },
    required: ["collection", "document"]
  }
},
{
  name: "mongo_find",
  description: "Query documents from any MongoDB collection",
  inputSchema: {
    type: "object" as const,
    properties: {
      collection: { type: "string", description: "Collection name" },
      filter: { type: "object", description: "MongoDB filter query", default: {} },
      limit: { type: "number", default: 10 }
    },
    required: ["collection"]
  }
},
{
  name: "mongo_updateOne",
  description: "Update a single document matching the filter",
  inputSchema: {
    type: "object" as const,
    properties: {
      collection: { type: "string" },
      filter: { type: "object" },
      update: { type: "object", description: "Update operations ($set, etc.)" }
    },
    required: ["collection", "filter", "update"]
  }
},
{
  name: "mongo_insertMany",
  description: "Insert multiple documents into a collection",
  inputSchema: {
    type: "object" as const,
    properties: {
      collection: { type: "string" },
      documents: { type: "array", items: { type: "object" } }
    },
    required: ["collection", "documents"]
  }
},
{
  name: "mongo_updateMany",
  description: "Update all documents matching the filter",
  inputSchema: {
    type: "object" as const,
    properties: {
      collection: { type: "string" },
      filter: { type: "object" },
      update: { type: "object" }
    },
    required: ["collection", "filter", "update"]
  }
}
```

Add handler implementations in the switch statement:
```typescript
case "mongo_insertOne": {
  const collection = db.collection((args as any).collection);
  const result = await collection.insertOne((args as any).document);
  return {
    content: [{ type: "text", text: JSON.stringify({ insertedId: result.insertedId }, null, 2) }]
  };
}

case "mongo_find": {
  const collection = db.collection((args as any).collection);
  const filter = (args as any).filter || {};
  const limit = (args as any).limit || 10;
  const results = await collection.find(filter).limit(limit).toArray();
  return {
    content: [{ type: "text", text: JSON.stringify(results, null, 2) }]
  };
}

case "mongo_updateOne": {
  const collection = db.collection((args as any).collection);
  const result = await collection.updateOne((args as any).filter, (args as any).update);
  return {
    content: [{ type: "text", text: JSON.stringify({ matched: result.matchedCount, modified: result.modifiedCount }, null, 2) }]
  };
}

case "mongo_insertMany": {
  const collection = db.collection((args as any).collection);
  const result = await collection.insertMany((args as any).documents);
  return {
    content: [{ type: "text", text: JSON.stringify({ insertedCount: result.insertedCount, ids: result.insertedIds }, null, 2) }]
  };
}

case "mongo_updateMany": {
  const collection = db.collection((args as any).collection);
  const result = await collection.updateMany((args as any).filter, (args as any).update);
  return {
    content: [{ type: "text", text: JSON.stringify({ matched: result.matchedCount, modified: result.modifiedCount }, null, 2) }]
  };
}
```

### 2.2 Build mcp-p4nthon

```powershell
cd C:\P4NTH30N\tools\mcp-p4nthon
npm run build
# Should complete with no errors
```

### 2.3 Create Gateway Config

Create `C:\P4NTH30N\tools\mcp-development\servers\toolhive-gateway\config\mongodb-p4nth30n.json`:
```json
{
  "id": "toolhive-mongodb-p4nth30n-v2",
  "name": "mongodb-p4nth30n",
  "transport": "stdio",
  "command": "node",
  "args": ["C:/P4NTH30N/tools/mcp-p4nthon/dist/index.js"],
  "envVars": {
    "MONGODB_URI": "mongodb://localhost:27017",
    "DATABASE_NAME": "P4NTH30N"
  },
  "tags": ["p4nth30n", "database", "mongodb", "crud"],
  "description": "P4NTH30N MongoDB database with full CRUD operations",
  "enabled": true
}
```

### 2.4 Update servers.json

Update MongoDB entry (lines 207-227) in servers.json:
```json
{
  "id": "toolhive-mongodb-p4nth30n",
  "name": "mongodb-p4nth30n",
  "transport": "stdio",
  "command": "node",
  "args": ["C:/P4NTH30N/tools/mcp-p4nthon/dist/index.js"],
  "envVars": {
    "MONGODB_URI": "mongodb://localhost:27017",
    "DATABASE_NAME": "P4NTH30N"
  },
  "tags": ["toolhive-desktop", "database", "storage", "p4nth30n", "mongodb", "crud"],
  "description": "P4NTH30N MongoDB database with CRUD operations for decisions",
  "source": "mongodb-p4nth30n.json",
  "image": "",
  "enabled": true
}
```

### 2.5 Validate MongoDB Tools

```powershell
# Test via ToolHive
cd C:\P4NTH30N\tools\mcp-development\servers\toolhive-gateway
npm run list-tools | Select-String "mongo_"
# Should show: mongo_insertOne, mongo_find, mongo_updateOne, mongo_insertMany, mongo_updateMany

# Test actual query
$body = @{
  jsonrpc = "2.0"
  id = 1
  method = "tools/call"
  params = @{
    name = "mongo_find"
    arguments = @{
      collection = "decisions"
      filter = @{}
      limit = 5
    }
  }
} | ConvertTo-Json -Depth 5

$body | node C:\P4NTH30N\tools\mcp-p4nthon\dist\index.js
# Should return decision documents
```

**PHASE 2 COMPLETE CRITERIA**:
- [ ] mcp-p4nthon builds successfully
- [ ] ToolHive lists all 5 mongo_* tools
- [ ] Can query decisions collection successfully
- [ ] Can insert/update documents successfully

---

## PHASE 3: DECISION_093 - BUILD OUTPUT CHANGE (30 minutes)

### 3.1 Modify H0UND.csproj

Read `C:\P4NTH30N\H0UND\H0UND.csproj`

Update:
```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net10.0-windows7.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    
    <!-- DECISION_093: Build as P4NTH30N.exe -->
    <AssemblyName>P4NTH30N</AssemblyName>
    <UseWindowsForms>true</UseWindowsForms>
    <ApplicationManifest>app.manifest</ApplicationManifest>
  </PropertyGroup>

  <ItemGroup>
    <ProjectReference Include="..\C0MMON\C0MMON.csproj" />
    <ProjectReference Include="..\W4TCHD0G\W4TCHD0G.csproj" />
  </ItemGroup>

  <ItemGroup>
    <PackageReference Include="Figgle" Version="0.6.5" />
    <PackageReference Include="Figgle.Generator" Version="0.6.5" />
    <PackageReference Include="Selenium.WebDriver" Version="4.40.0" />
  </ItemGroup>

  <ItemGroup>
    <!-- DECISION_093: Embedded tray icon -->
    <EmbeddedResource Include="Resources\hound-icon.ico" />
  </ItemGroup>
</Project>
```

### 3.2 Create Tray Icon Resource

Create directory `C:\P4NTH30N\H0UND\Resources\`

If hound-icon.ico doesn't exist, use a default Windows icon temporarily:
```powershell
# Copy a default icon or create placeholder
Copy-Item "C:\Windows\System32\shell32.dll" "C:\P4NTH30N\H0UND\Resources\hound-icon.ico" -ErrorAction SilentlyContinue
# Note: Replace with actual icon file when available
```

### 3.3 Build Test

```powershell
cd C:\P4NTH30N
dotnet build H0UND\H0UND.csproj -c Release

# Verify output
Test-Path "C:\P4NTH30N\H0UND\bin\Release\net10.0-windows7.0\P4NTH30N.exe"
# Should return True
```

**PHASE 3 COMPLETE CRITERIA**:
- [ ] H0UND.csproj modified with AssemblyName=P4NTH30N
- [ ] UseWindowsForms enabled
- [ ] Build succeeds
- [ ] P4NTH30N.exe exists in output directory

---

## PHASE 4: DECISION_093 - SYSTEM TRAY INTEGRATION (3 hours)

### 4.1 Create Infrastructure Directories

```powershell
New-Item -ItemType Directory -Force -Path "C:\P4NTH30N\H0UND\Infrastructure\Tray"
New-Item -ItemType Directory -Force -Path "C:\P4NTH30N\H0UND\Infrastructure\Native"
New-Item -ItemType Directory -Force -Path "C:\P4NTH30N\H0UND\Infrastructure\BootTime"
New-Item -ItemType Directory -Force -Path "C:\P4NTH30N\H0UND\Services\Orchestration"
New-Item -ItemType Directory -Force -Path "C:\P4NTH30N\H0UND\Services\Orchestration\HealthCheckers"
```

### 4.2 Create NativeMethods.cs

Create `C:\P4NTH30N\H0UND\Infrastructure\Native\NativeMethods.cs`:
```csharp
using System.Runtime.InteropServices;

namespace H0UND.Infrastructure.Native;

internal static class NativeMethods
{
    [DllImport("kernel32.dll")]
    internal static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    internal static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    internal static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    internal static extern bool IsWindowVisible(IntPtr hWnd);

    internal const int SW_HIDE = 0;
    internal const int SW_SHOWNORMAL = 1;
    internal const int SW_SHOWMINIMIZED = 2;
    internal const int SW_SHOW = 5;
    internal const int SW_MINIMIZE = 6;
    internal const int SW_RESTORE = 9;

    internal delegate bool HandlerRoutine(uint dwCtrlType);

    [DllImport("kernel32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    internal static extern bool SetConsoleCtrlHandler(HandlerRoutine handler, bool add);

    internal const uint CTRL_CLOSE_EVENT = 2;
    internal const uint CTRL_SHUTDOWN_EVENT = 6;
}
```

### 4.3 Create ITrayCallback.cs

Create `C:\P4NTH30N\H0UND\Infrastructure\Tray\ITrayCallback.cs`:
```csharp
namespace H0UND.Infrastructure.Tray;

public interface ITrayCallback
{
    void OnShowRequested();
    void OnHideRequested();
    void OnExitRequested();
}
```

### 4.4 Create ConsoleWindowManager.cs

Create `C:\P4NTH30N\H0UND\Infrastructure\Tray\ConsoleWindowManager.cs`:
```csharp
using H0UND.Infrastructure.Native;

namespace H0UND.Infrastructure.Tray;

public sealed class ConsoleWindowManager : IDisposable
{
    private readonly IntPtr _consoleHandle;
    private readonly NativeMethods.HandlerRoutine _ctrlHandler;
    private Func<bool>? _closeRequestedCallback;
    private bool _disposed;

    public ConsoleWindowManager()
    {
        _consoleHandle = NativeMethods.GetConsoleWindow();
        _ctrlHandler = new NativeMethods.HandlerRoutine(OnConsoleCtrlEvent);
        NativeMethods.SetConsoleCtrlHandler(_ctrlHandler, true);
    }

    public void SetCloseHandler(Func<bool> handler)
    {
        _closeRequestedCallback = handler;
    }

    private bool OnConsoleCtrlEvent(uint ctrlType)
    {
        if (ctrlType == NativeMethods.CTRL_CLOSE_EVENT)
        {
            var shouldPrevent = _closeRequestedCallback?.Invoke() ?? false;
            return shouldPrevent;
        }
        return false;
    }

    public void Show()
    {
        if (_consoleHandle == IntPtr.Zero) return;
        NativeMethods.ShowWindow(_consoleHandle, NativeMethods.SW_SHOW);
        NativeMethods.SetForegroundWindow(_consoleHandle);
    }

    public void Hide()
    {
        if (_consoleHandle == IntPtr.Zero) return;
        NativeMethods.ShowWindow(_consoleHandle, NativeMethods.SW_HIDE);
    }

    public bool IsVisible => _consoleHandle != IntPtr.Zero && 
                             NativeMethods.IsWindowVisible(_consoleHandle);

    public void Dispose()
    {
        if (_disposed) return;
        _disposed = true;
        NativeMethods.SetConsoleCtrlHandler(_ctrlHandler, false);
    }
}
```

### 4.5 Create TrayHost.cs

Create `C:\P4NTH30N\H0UND\Infrastructure\Tray\TrayHost.cs`:
```csharp
using System.ComponentModel;

namespace H0UND.Infrastructure.Tray;

public sealed class TrayHost : ApplicationContext, IDisposable
{
    private readonly NotifyIcon _notifyIcon;
    private readonly ToolStripMenuItem _showHideItem;
    private readonly Thread _uiThread;
    private readonly ManualResetEvent _exitSignal;
    private readonly ITrayCallback _callback;
    private bool _isConsoleVisible = true;
    private bool _disposed;

    public TrayHost(ITrayCallback callback)
    {
        _callback = callback ?? throw new ArgumentNullException(nameof(callback));
        _exitSignal = new ManualResetEvent(false);
        
        var contextMenu = new ContextMenuStrip();
        
        _showHideItem = new ToolStripMenuItem("Hide Dashboard", null, OnShowHideClick!)
        {
            Font = new System.Drawing.Font(contextMenu.Font, System.Drawing.FontStyle.Bold)
        };
        
        contextMenu.Items.Add(_showHideItem);
        contextMenu.Items.Add(new ToolStripSeparator());
        contextMenu.Items.Add("Exit", null, OnExitClick!);

        _notifyIcon = new NotifyIcon
        {
            Icon = System.Drawing.SystemIcons.Application,
            Text = "P4NTH30N Dashboard",
            Visible = true,
            ContextMenuStrip = contextMenu
        };
        
        _notifyIcon.DoubleClick += OnTrayDoubleClick!;

        _uiThread = new Thread(RunMessageLoop)
        {
            IsBackground = false,
            Name = "TrayHostThread"
        };
        _uiThread.SetApartmentState(ApartmentState.STA);
        _uiThread.Start();
    }

    private void RunMessageLoop()
    {
        Application.Run(this);
        _exitSignal.Set();
    }

    private void OnTrayDoubleClick(object sender, EventArgs e) => ToggleVisibility();
    private void OnShowHideClick(object sender, EventArgs e) => ToggleVisibility();
    private void OnExitClick(object sender, EventArgs e) => _callback.OnExitRequested();

    private void ToggleVisibility()
    {
        if (_isConsoleVisible)
        {
            _callback.OnHideRequested();
            _isConsoleVisible = false;
            _showHideItem.Text = "Show Dashboard";
        }
        else
        {
            _callback.OnShowRequested();
            _isConsoleVisible = true;
            _showHideItem.Text = "Hide Dashboard";
        }
    }

    public void ShowBalloonTip(string title, string message, ToolTipIcon icon = ToolTipIcon.Info)
    {
        if (_disposed) return;
        _notifyIcon?.ShowBalloonTip(3000, title, message, icon);
    }

    public void UpdateTooltip(string tooltip)
    {
        if (_disposed || _notifyIcon == null) return;
        if (_notifyIcon.InvokeRequired)
        {
            _notifyIcon.Invoke(new Action<string>(UpdateTooltip), tooltip);
            return;
        }
        _notifyIcon.Text = tooltip.Length > 63 ? tooltip[..63] : tooltip;
    }

    public void Shutdown()
    {
        if (_disposed) return;
        _notifyIcon.Visible = false;
        ExitThread();
        _exitSignal.WaitOne(5000);
    }

    public override void Dispose()
    {
        if (_disposed) return;
        _disposed = true;
        _notifyIcon?.Dispose();
        _exitSignal?.Dispose();
        base.Dispose();
    }
}
```

### 4.6 Create app.manifest

Create `C:\P4NTH30N\H0UND\app.manifest`:
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
  <assemblyIdentity version="1.0.0.0" name="P4NTH30N"/>
  <trustInfo xmlns="urn:schemas-microsoft-com:asm.v2">
    <security>
      <requestedPrivileges xmlns="urn:schemas-microsoft-com:asm.v3">
        <requestedExecutionLevel level="asInvoker" uiAccess="false"/>
      </requestedPrivileges>
    </security>
  </trustInfo>
  <application xmlns="urn:schemas-microsoft-com:asm.v3">
    <windowsSettings>
      <dpiAware xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings">true/pm</dpiAware>
      <dpiAwareness xmlns="http://schemas.microsoft.com/SMI/2016/WindowsSettings">PerMonitorV2</dpiAwareness>
    </windowsSettings>
  </application>
</assembly>
```

### 4.7 Build and Test Tray Integration

```powershell
cd C:\P4NTH30N
dotnet build H0UND\H0UND.csproj -c Release

# Run P4NTH30N.exe and verify tray icon appears
# Test: Close button minimizes to tray
# Test: Double-click tray shows dashboard
# Test: Exit from menu closes application
```

**PHASE 4 COMPLETE CRITERIA**:
- [ ] All tray infrastructure files created
- [ ] Build succeeds with no errors
- [ ] Tray icon visible when running
- [ ] Close button minimizes to tray
- [ ] Double-click toggles visibility

---

## PHASE 5: DECISION_093 - BOOT-TIME AUTO-START (2 hours)

### 5.1 Create Register-AutoStart.ps1

Create `C:\P4NTH30N\scripts\Register-AutoStart.ps1`:
```powershell
#Requires -RunAsAdministrator

param(
    [string]$ExecutablePath = "C:\P4NTH30N\H0UND\bin\Release\net10.0-windows7.0\P4NTH30N.exe",
    [string]$TaskName = "P4NTH30N-AutoStart",
    [int]$DelaySeconds = 30
)

# Verify executable exists
if (-not (Test-Path $ExecutablePath)) {
    Write-Error "Executable not found: $ExecutablePath"
    exit 1
}

# Create task action
$action = New-ScheduledTaskAction -Execute $ExecutablePath -Argument "--background"

# Create trigger (at startup with delay)
$trigger = New-ScheduledTaskTrigger -AtStartup
$trigger.Delay = "PT${DelaySeconds}S"

# Create principal (run with highest privileges)
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Create settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable:$false `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 5)

# Register task
try {
    Register-ScheduledTask `
        -TaskName $TaskName `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Settings $settings `
        -Force
    
    Write-Host "Task '$TaskName' registered successfully." -ForegroundColor Green
    Write-Host "P4NTH30N will start automatically at boot (with ${DelaySeconds}s delay)." -ForegroundColor Green
}
catch {
    Write-Error "Failed to register task: $_"
    exit 1
}
```

### 5.2 Create Unregister-AutoStart.ps1

Create `C:\P4NTH30N\scripts\Unregister-AutoStart.ps1`:
```powershell
#Requires -RunAsAdministrator

param(
    [string]$TaskName = "P4NTH30N-AutoStart"
)

try {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    Write-Host "Task '$TaskName' unregistered successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to unregister task: $_"
    exit 1
}
```

### 5.3 Create Check-PlatformStatus.ps1

Create `C:\P4NTH30N\scripts\Check-PlatformStatus.ps1`:
```powershell
# Check all P4NTH30N services status

Write-Host "=== P4NTH30N Platform Status Check ===" -ForegroundColor Cyan

# Check P4NTH30N process
$p4nth30n = Get-Process -Name "P4NTH30N" -ErrorAction SilentlyContinue
if ($p4nth30n) {
    Write-Host "[OK] P4NTH30N.exe running (PID: $($p4nth30n.Id))" -ForegroundColor Green
} else {
    Write-Host "[MISSING] P4NTH30N.exe not running" -ForegroundColor Red
}

# Check RAG Server
$rag = Get-Process -Name "RAG.McpHost" -ErrorAction SilentlyContinue
if ($rag) {
    Write-Host "[OK] RAG Server running (PID: $($rag.Id))" -ForegroundColor Green
} else {
    Write-Host "[MISSING] RAG Server not running" -ForegroundColor Red
}

# Check MongoDB
$mongo = Get-Process -Name "mongod" -ErrorAction SilentlyContinue
if ($mongo) {
    Write-Host "[OK] MongoDB running (PID: $($mongo.Id))" -ForegroundColor Green
} else {
    Write-Host "[MISSING] MongoDB not running" -ForegroundColor Red
}

# Check LM Studio
$lmstudio = Get-Process | Where-Object { $_.ProcessName -like "*LM Studio*" } -ErrorAction SilentlyContinue
if ($lmstudio) {
    Write-Host "[OK] LM Studio running" -ForegroundColor Green
} else {
    Write-Host "[MISSING] LM Studio not running" -ForegroundColor Red
}

# Check Task Scheduler entry
$task = Get-ScheduledTask -TaskName "P4NTH30N-AutoStart" -ErrorAction SilentlyContinue
if ($task) {
    Write-Host "[OK] Auto-start task registered" -ForegroundColor Green
} else {
    Write-Host "[MISSING] Auto-start task not registered" -ForegroundColor Red
}

Write-Host "`nStatus check complete." -ForegroundColor Cyan
```

### 5.4 Register Auto-Start

```powershell
# Run as Administrator
.\scripts\Register-AutoStart.ps1

# Verify
Get-ScheduledTask -TaskName "P4NTH30N-AutoStart"
```

**PHASE 5 COMPLETE CRITERIA**:
- [ ] All PowerShell scripts created
- [ ] Auto-start task registered
- [ ] Task appears in Task Scheduler
- [ ] Check-PlatformStatus.ps1 works

---

## PHASE 6: DECISION_093 - SERVICE ORCHESTRATION (4 hours)

### 6.1 Create Service Orchestration Interfaces

Create `C:\P4NTH30N\H0UND\Services\Orchestration\IManagedService.cs`:
```csharp
namespace H0UND.Services.Orchestration;

public interface IManagedService
{
    string Name { get; }
    ServiceStatus Status { get; }
    Task StartAsync(CancellationToken cancellationToken = default);
    Task StopAsync(CancellationToken cancellationToken = default);
    Task<bool> HealthCheckAsync(CancellationToken cancellationToken = default);
    event EventHandler<ServiceStatusChangedEventArgs>? StatusChanged;
    event EventHandler<string>? LogMessage;
}

public enum ServiceStatus
{
    Stopped,
    Starting,
    Running,
    Degraded,
    Error
}

public class ServiceStatusChangedEventArgs : EventArgs
{
    public ServiceStatus OldStatus { get; set; }
    public ServiceStatus NewStatus { get; set; }
    public string? Message { get; set; }
}
```

Create `C:\P4NTH30N\H0UND\Services\Orchestration\IServiceOrchestrator.cs`:
```csharp
namespace H0UND.Services.Orchestration;

public interface IServiceOrchestrator
{
    IReadOnlyCollection<IManagedService> Services { get; }
    void RegisterService(IManagedService service);
    Task StartAllAsync(CancellationToken cancellationToken = default);
    Task StopAllAsync(CancellationToken cancellationToken = default);
    Task<IManagedService?> GetServiceAsync(string name);
    event EventHandler<OrchestratorEventArgs>? OrchestratorEvent;
}

public class OrchestratorEventArgs : EventArgs
{
    public string ServiceName { get; set; } = "";
    public string EventType { get; set; } = "";
    public string Message { get; set; } = "";
}
```

### 6.2 Create ExponentialBackoffRetryPolicy

Create `C:\P4NTH30N\H0UND\Services\Orchestration\ExponentialBackoffRetryPolicy.cs`:
```csharp
namespace H0UND.Services.Orchestration;

public class ExponentialBackoffRetryPolicy
{
    private readonly int _maxRetries;
    private readonly TimeSpan _baseDelay;
    private readonly TimeSpan _maxDelay;

    public ExponentialBackoffRetryPolicy(
        int maxRetries = 5,
        int baseDelaySeconds = 5,
        int maxDelaySeconds = 60)
    {
        _maxRetries = maxRetries;
        _baseDelay = TimeSpan.FromSeconds(baseDelaySeconds);
        _maxDelay = TimeSpan.FromSeconds(maxDelaySeconds);
    }

    public async Task ExecuteAsync(Func<Task> action, Func<Exception, bool> isRetryable)
    {
        for (int attempt = 0; attempt < _maxRetries; attempt++)
        {
            try
            {
                await action();
                return;
            }
            catch (Exception ex) when (isRetryable(ex) && attempt < _maxRetries - 1)
            {
                var delay = CalculateDelay(attempt);
                await Task.Delay(delay);
            }
        }
    }

    private TimeSpan CalculateDelay(int attempt)
    {
        var delay = TimeSpan.FromTicks(_baseDelay.Ticks * (1L << attempt));
        return delay > _maxDelay ? _maxDelay : delay;
    }
}
```

### 6.3 Create ManagedService Base Class

Create `C:\P4NTH30N\H0UND\Services\Orchestration\ManagedService.cs`:
```csharp
using System.Diagnostics;

namespace H0UND.Services.Orchestration;

public abstract class ManagedService : IManagedService, IDisposable
{
    protected readonly ExponentialBackoffRetryPolicy _retryPolicy;
    protected Process? _process;
    protected bool _disposed;

    public string Name { get; protected set; } = "";
    public ServiceStatus Status { get; protected set; } = ServiceStatus.Stopped;
    
    public event EventHandler<ServiceStatusChangedEventArgs>? StatusChanged;
    public event EventHandler<string>? LogMessage;

    protected ManagedService(string name)
    {
        Name = name;
        _retryPolicy = new ExponentialBackoffRetryPolicy();
    }

    protected void SetStatus(ServiceStatus newStatus, string? message = null)
    {
        var oldStatus = Status;
        Status = newStatus;
        StatusChanged?.Invoke(this, new ServiceStatusChangedEventArgs 
        { 
            OldStatus = oldStatus, 
            NewStatus = newStatus,
            Message = message
        });
        LogMessage?.Invoke(this, $"[{Name}] Status: {oldStatus} -> {newStatus}");
    }

    protected void Log(string message)
    {
        LogMessage?.Invoke(this, $"[{Name}] {message}");
    }

    public abstract Task StartAsync(CancellationToken cancellationToken = default);
    public abstract Task StopAsync(CancellationToken cancellationToken = default);
    public abstract Task<bool> HealthCheckAsync(CancellationToken cancellationToken = default);

    public virtual void Dispose()
    {
        if (_disposed) return;
        _disposed = true;
        _process?.Dispose();
    }
}
```

### 6.4 Create HttpManagedService

Create `C:\P4NTH30N\H0UND\Services\Orchestration\HttpManagedService.cs`:
```csharp
using System.Diagnostics;

namespace H0UND.Services.Orchestration;

public class HttpManagedService : ManagedService
{
    private readonly string _executablePath;
    private readonly string _arguments;
    private readonly string _healthCheckUrl;
    private readonly HttpClient _httpClient;

    public HttpManagedService(
        string name,
        string executablePath,
        string arguments,
        string healthCheckUrl) : base(name)
    {
        _executablePath = executablePath;
        _arguments = arguments;
        _healthCheckUrl = healthCheckUrl;
        _httpClient = new HttpClient { Timeout = TimeSpan.FromSeconds(5) };
    }

    public override async Task StartAsync(CancellationToken cancellationToken = default)
    {
        if (_process != null && !_process.HasExited)
        {
            Log("Already running");
            return;
        }

        SetStatus(ServiceStatus.Starting, "Launching process");

        var startInfo = new ProcessStartInfo
        {
            FileName = _executablePath,
            Arguments = _arguments,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            CreateNoWindow = true
        };

        _process = new Process { StartInfo = startInfo };
        _process.OutputDataReceived += (s, e) => { if (e.Data != null) Log($"[OUT] {e.Data}"); };
        _process.ErrorDataReceived += (s, e) => { if (e.Data != null) Log($"[ERR] {e.Data}"); };

        _process.Start();
        _process.BeginOutputReadLine();
        _process.BeginErrorReadLine();

        // Wait for health check to pass
        var healthy = await WaitForHealthyAsync(cancellationToken);
        if (healthy)
        {
            SetStatus(ServiceStatus.Running);
        }
        else
        {
            SetStatus(ServiceStatus.Error, "Health check failed");
        }
    }

    private async Task<bool> WaitForHealthyAsync(CancellationToken cancellationToken)
    {
        for (int i = 0; i < 30; i++) // Try for 30 seconds
        {
            if (await HealthCheckAsync(cancellationToken))
                return true;
            await Task.Delay(1000, cancellationToken);
        }
        return false;
    }

    public override async Task StopAsync(CancellationToken cancellationToken = default)
    {
        if (_process == null || _process.HasExited)
        {
            SetStatus(ServiceStatus.Stopped);
            return;
        }

        SetStatus(ServiceStatus.Stopping);

        // Try graceful shutdown first
        _process.CloseMainWindow();
        await Task.Delay(2000, cancellationToken);

        if (!_process.HasExited)
        {
            _process.Kill();
            await _process.WaitForExitAsync(cancellationToken);
        }

        SetStatus(ServiceStatus.Stopped);
    }

    public override async Task<bool> HealthCheckAsync(CancellationToken cancellationToken = default)
    {
        try
        {
            var response = await _httpClient.GetAsync(_healthCheckUrl, cancellationToken);
            return response.IsSuccessStatusCode;
        }
        catch
        {
            return false;
        }
    }

    public override void Dispose()
    {
        base.Dispose();
        _httpClient?.Dispose();
    }
}
```

### 6.5 Create ServiceOrchestrator

Create `C:\P4NTH30N\H0UND\Services\Orchestration\ServiceOrchestrator.cs`:
```csharp
using System.Collections.Concurrent;

namespace H0UND.Services.Orchestration;

public class ServiceOrchestrator : IServiceOrchestrator, IDisposable
{
    private readonly ConcurrentDictionary<string, IManagedService> _services = new();
    private readonly Timer _healthCheckTimer;
    private bool _disposed;

    public IReadOnlyCollection<IManagedService> Services => _services.Values.ToList();

    public event EventHandler<OrchestratorEventArgs>? OrchestratorEvent;

    public ServiceOrchestrator(TimeSpan? healthCheckInterval = null)
    {
        var interval = healthCheckInterval ?? TimeSpan.FromSeconds(30);
        _healthCheckTimer = new Timer(OnHealthCheckTick, null, interval, interval);
    }

    public void RegisterService(IManagedService service)
    {
        _services[service.Name] = service;
        service.StatusChanged += OnServiceStatusChanged;
        service.LogMessage += OnServiceLogMessage;
        
        OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
        {
            ServiceName = service.Name,
            EventType = "Registered",
            Message = $"Service {service.Name} registered"
        });
    }

    public async Task StartAllAsync(CancellationToken cancellationToken = default)
    {
        foreach (var service in _services.Values)
        {
            try
            {
                await service.StartAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
                {
                    ServiceName = service.Name,
                    EventType = "StartFailed",
                    Message = ex.Message
                });
            }
        }
    }

    public async Task StopAllAsync(CancellationToken cancellationToken = default)
    {
        foreach (var service in _services.Values.Reverse())
        {
            try
            {
                await service.StopAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
                {
                    ServiceName = service.Name,
                    EventType = "StopFailed",
                    Message = ex.Message
                });
            }
        }
    }

    public Task<IManagedService?> GetServiceAsync(string name)
    {
        _services.TryGetValue(name, out var service);
        return Task.FromResult(service);
    }

    private async void OnHealthCheckTick(object? state)
    {
        foreach (var service in _services.Values.Where(s => s.Status == ServiceStatus.Running))
        {
            var healthy = await service.HealthCheckAsync();
            if (!healthy)
            {
                OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
                {
                    ServiceName = service.Name,
                    EventType = "HealthCheckFailed",
                    Message = "Service failed health check"
                });
            }
        }
    }

    private void OnServiceStatusChanged(object? sender, ServiceStatusChangedEventArgs e)
    {
        if (sender is IManagedService service)
        {
            OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
            {
                ServiceName = service.Name,
                EventType = "StatusChanged",
                Message = $"{e.OldStatus} -> {e.NewStatus}"
            });
        }
    }

    private void OnServiceLogMessage(object? sender, string message)
    {
        if (sender is IManagedService service)
        {
            OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
            {
                ServiceName = service.Name,
                EventType = "Log",
                Message = message
            });
        }
    }

    public void Dispose()
    {
        if (_disposed) return;
        _disposed = true;
        _healthCheckTimer?.Dispose();
        foreach (var service in _services.Values)
        {
            (service as IDisposable)?.Dispose();
        }
    }
}
```

### 6.6 Build and Test

```powershell
cd C:\P4NTH30N
dotnet build H0UND\H0UND.csproj -c Release

# Should build successfully with all new service orchestration code
```

**PHASE 6 COMPLETE CRITERIA**:
- [ ] All service orchestration files created
- [ ] Build succeeds with no errors
- [ ] ServiceOrchestrator can be instantiated
- [ ] HttpManagedService can start/stop processes

---

## PHASE 7: INTEGRATION & FINAL TESTING (1 hour)

### 7.1 Update H0UND Program.cs

Modify `C:\P4NTH30N\H0UND\Program.cs` to integrate tray and orchestration:

Add at top:
```csharp
using H0UND.Infrastructure.Tray;
using H0UND.Services.Orchestration;
```

Modify Main to implement ITrayCallback and integrate orchestrator (reference DECISION_093_SYNTHESIS.md for full implementation).

### 7.2 Create autostart.json Config

Create `C:\P4NTH30N\config\autostart.json`:
```json
{
  "services": [
    {
      "name": "RAG Server",
      "type": "http",
      "executable": "C:\\ProgramData\\P4NTH30N\\bin\\RAG.McpHost.exe",
      "arguments": "--port 5001 --transport http --bridge http://127.0.0.1:5000",
      "healthCheckUrl": "http://127.0.0.1:5001/health"
    }
  ],
  "startup": {
    "delaySeconds": 30
  }
}
```

### 7.3 Final Build

```powershell
cd C:\P4NTH30N
dotnet build H0UND\H0UND.csproj -c Release

# Verify output
ls H0UND\bin\Release\net10.0-windows7.0\P4NTH30N.exe
```

### 7.4 End-to-End Test

```powershell
# 1. Test P4NTH30N.exe starts
.\H0UND\bin\Release\net10.0-windows7.0\P4NTH30N.exe

# 2. Verify tray icon appears

# 3. Test minimize to tray

# 4. Test show from tray

# 5. Test exit from tray menu

# 6. Run status check
.\scripts\Check-PlatformStatus.ps1

# 7. Verify auto-start task
Get-ScheduledTask -TaskName "P4NTH30N-AutoStart"
```

---

## COMPLETION CRITERIA

**DECISION_092 Complete**:
- [ ] RAG Server running and healthy
- [ ] ToolHive lists all 6 rag_* tools
- [ ] MongoDB MCP extended with 5 CRUD tools
- [ ] ToolHive lists all 5 mongo_* tools
- [ ] Can query/insert/update through ToolHive

**DECISION_093 Complete**:
- [ ] Build produces P4NTH30N.exe
- [ ] Tray icon visible when running
- [ ] Close minimizes to tray (not exit)
- [ ] Double-click shows/hides dashboard
- [ ] ServiceOrchestrator manages RAG Server
- [ ] Auto-start task registered in Task Scheduler
- [ ] Check-PlatformStatus.ps1 reports all services

**All Phases**: 15 hours estimated. Execute sequentially. Do not stop until complete.

---

## MOTIVATION

Read these files to understand why this matters:
- `STR4TEG15T/speech/20260219T0454_THE_LONG_NIGHT.md` - The birth of the decision engine
- `STR4TEG15T/speech/20260221T2200_ARXIV_INTEGRATION_SYNTHESIS.md` - Research-validated decisions
- `STR4TEG15T/speech/20260221T1900_THREE_PATHS_CONVERGE.md` - Parallel execution victory
- `STR4TEG15T/speech/20260222T1800_PLATFORM_SYNTHESIS.md` - This mission's context

You are completing the platform that fifty-plus decisions have built toward.

You do not stop until it is done.

---

**DEPLOYMENT AUTHORITY**: Direct Nexus Command  
**STOP CONDITION**: ALL phases complete, ALL criteria met  
**ESCALATION**: Only for unrecoverable errors after 3 retries

Execute.
