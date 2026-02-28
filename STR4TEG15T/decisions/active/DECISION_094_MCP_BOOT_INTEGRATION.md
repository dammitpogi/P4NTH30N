# DECISION_094: MCP Server Boot-Time Integration

**Status**: ✅ Implemented  
**Category**: Infrastructure / Boot-Time Architecture  
**Priority**: High  
**Dependencies**: DECISION_092, DECISION_093  

## Summary

Ensure all critical MCP servers (FourEyes, Honeybelt, RAG) and ToolHive workloads (MongoDB, decisions-server) are automatically started on system boot via H0UND's autostart infrastructure.

## Background

During DECISION_092/093 implementation, we identified that several MCP servers are running as standalone Node.js/C# processes that are NOT automatically started on boot:

- **FourEyes MCP** (port 5302) - CDP + LMStudio vision analysis
- **Honeybelt MCP** (port 5303) - Operations and reporting  
- **RAG Server** (port 5001) - Knowledge base queries

Additionally, ToolHive manages 15 Docker-based MCP workloads that need the ToolHive daemon running.

The existing `config/autostart.json` references the OLD MongoDB MCP (Node.js version) which has been replaced by the Docker-based `mongodb-p4nth30n`.

## Decision

### 1. Update config/autostart.json

Replace the contents with the following structure:

```json
{
  "services": [
    {
      "name": "RAG Server",
      "type": "http",
      "executable": "C:\\ProgramData\\P4NTHE0N\\bin\\RAG.McpHost.exe",
      "arguments": "--port 5001 --transport http --bridge http://127.0.0.1:5000 --mongo mongodb://localhost:27017 --db P4NTHE0N",
      "healthCheckUrl": "http://127.0.0.1:5001/health",
      "dependsOn": ["MongoDB"]
    },
    {
      "name": "FourEyes MCP",
      "type": "http",
      "executable": "node",
      "workingDirectory": "C:\\P4NTHE0N\\tools\\mcp-foureyes",
      "arguments": "server.js --http",
      "environment": {
        "CDP_HOST": "127.0.0.1",
        "CDP_PORT": "9222",
        "LMSTUDIO_URL": "http://localhost:1234",
        "MCP_PORT": "5302"
      },
      "healthCheckUrl": "http://127.0.0.1:5302/mcp",
      "startupDelay": 5
    },
    {
      "name": "Honeybelt MCP",
      "type": "http",
      "executable": "node",
      "workingDirectory": "C:\\P4NTHE0N\\tools\\mcp-development\\servers\\honeybelt-server",
      "arguments": "dist/index.js --http",
      "environment": {
        "MCP_PORT": "5303"
      },
      "healthCheckUrl": "http://127.0.0.1:5303/mcp",
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
      "rag-server",
      "arxiv-mcp-server",
      "brightdata-mcp",
      "chrome-devtools-mcp",
      "fetch",
      "firecrawl",
      "memory",
      "playwright",
      "sequentialthinking",
      "tavily-mcp",
      "toolhive-doc-mcp"
    ]
  },
  "startup": {
    "delaySeconds": 30,
    "serviceStartInterval": 5
  }
}
```

### 2. ToolHive Autostart Registration

ToolHive Desktop should be configured to start on boot:

```powershell
# Add to Register-AutoStart.ps1 or create separate script
$toolhivePath = "$env:LOCALAPPDATA\ToolHive\ToolHive.exe"
if (Test-Path $toolhivePath) {
    $toolhiveAction = New-ScheduledTaskAction -Execute $toolhivePath
    $toolhiveTrigger = New-ScheduledTaskTrigger -AtStartup
    $toolhiveTrigger.Delay = "PT60S"  # Start 60s after boot
    $toolhivePrincipal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
    $toolhiveSettings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable
    
    Register-ScheduledTask `
        -TaskName "ToolHive-AutoStart" `
        -Action $toolhiveAction `
        -Trigger $toolhiveTrigger `
        -Principal $toolhivePrincipal `
        -Settings $toolhiveSettings `
        -Force
}
```

### 3. H0UND ServiceOrchestrator Updates

The `ServiceOrchestrator` needs to handle:

1. **Working Directory** - For Node.js services that need specific CWD
2. **Environment Variables** - Port configuration, API endpoints
3. **Startup Delay** - Stagger service starts to avoid port conflicts
4. **Health Check Retry** - Remote MCPs may take time to initialize

```csharp
// Add to HttpManagedService or create new NodeManagedService
public class NodeManagedService : IManagedService
{
    public string WorkingDirectory { get; set; }
    public Dictionary<string, string> Environment { get; set; }
    public int StartupDelaySeconds { get; set; }
    
    public async Task StartAsync()
    {
        if (StartupDelaySeconds > 0)
            await Task.Delay(TimeSpan.FromSeconds(StartupDelaySeconds));
            
        var psi = new ProcessStartInfo
        {
            FileName = Executable,
            Arguments = Arguments,
            WorkingDirectory = WorkingDirectory,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true
        };
        
        foreach (var env in Environment)
            psi.Environment[env.Key] = env.Value;
            
        Process = Process.Start(psi);
    }
}
```

### 4. Service Dependencies

Startup order must respect dependencies:

1. **MongoDB** (host) - Must be running first
2. **RAG Server** - Depends on MongoDB
3. **FourEyes/Honeybelt** - Can start in parallel after RAG
4. **ToolHive workloads** - Started after ToolHive Desktop initializes

## Implementation Checklist

- [x] Update `config/autostart.json` with new service definitions
- [x] Implement `NodeManagedService` class in H0UND
- [x] Add working directory support to service configuration
- [x] Add environment variable support
- [x] Add startup delay support for dependency ordering
- [x] Create ToolHive boot registration script
- [ ] Test boot sequence in VM
- [ ] Verify all MCPs respond after cold boot
- [ ] Document port assignments in AGENTS.md

## Verification

After reboot, all services should be accessible:

```powershell
# Test all MCP endpoints
$endpoints = @(
    "http://localhost:5001/mcp",    # RAG
    "http://localhost:5302/mcp",    # FourEyes
    "http://localhost:5303/mcp",    # Honeybelt
    "http://localhost:11167/mcp"    # MongoDB (ToolHive - port may vary)
)

foreach ($url in $endpoints) {
    try {
        $response = Invoke-RestMethod -Uri $url -Method POST `
            -Body '{"jsonrpc":"2.0","method":"tools/list","id":1}' `
            -ContentType "application/json" -TimeoutSec 5
        Write-Host "✅ $url" -ForegroundColor Green
    } catch {
        Write-Host "❌ $url - $_" -ForegroundColor Red
    }
}
```

## Rollback

If issues occur:
1. Disable autostart task: `Disable-ScheduledTask -TaskName "P4NTHE0N-AutoStart"`
2. Restore original `config/autostart.json`
3. Manual start: `thv start mongodb-p4nth30n decisions-server`

## References

- `DECISION_092` - MongoDB ToolHive integration
- `DECISION_093` - RAG server deployment
- `config/autostart.json` - Current autostart configuration
- `scripts/Register-AutoStart.ps1` - Task registration script
- `H0UND/Services/Orchestration/ServiceOrchestrator.cs` - Service management

---
**Decision ID**: DECISION_094  
**Created**: 2026-02-22  
**Author**: OpenFixer  
**Implemented**: 2026-02-22  
**Files Modified**: 
- `config/autostart.json` - Updated with MCP service definitions
- `H0UND/Infrastructure/BootTime/AutostartConfig.cs` - Added NodeManagedService support fields
- `H0UND/Services/Orchestration/NodeManagedService.cs` - NEW: Node.js service wrapper
- `H0UND/H0UND.cs` - Updated InitializeServiceOrchestrator to use NodeManagedService
- `scripts/Register-ToolHive-AutoStart.ps1` - NEW: ToolHive Desktop autostart registration
