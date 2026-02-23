---
type: decision
id: DECISION_093
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.745Z'
last_reviewed: '2026-02-23T01:31:15.745Z'
keywords:
  - decision093
  - unified
  - architecture
  - synthesis
  - h0und
  - alwayson
  - platform
  - complete
  - implementation
  - strategy
  - executive
  - summary
  - service
  - inventory
  - critical
  - services
  - must
  - running
  - toolhive
  - managed
roles:
  - librarian
  - oracle
summary: >-
  # DECISION_093: Unified Architecture Synthesis ## H0UND as Always-On Platform
  - Complete Implementation Strategy **Decision ID**: ARCH-093 **Synthesis
  Date**: 2026-02-22 **Status**: Ready for Implementation --- ## Executive
  Summary This document synthesizes outputs from 3 parallel Designer
  consultations and comprehensive Explorer research into a unified
  implementation strategy for DECISION_093. H0UND will become `P4NTH30N.exe` -
  an always-on platform that manages 15+ services through sys
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_093_SYNTHESIS.md
---
# DECISION_093: Unified Architecture Synthesis
## H0UND as Always-On Platform - Complete Implementation Strategy

**Decision ID**: ARCH-093  
**Synthesis Date**: 2026-02-22  
**Status**: Ready for Implementation

---

## Executive Summary

This document synthesizes outputs from 3 parallel Designer consultations and comprehensive Explorer research into a unified implementation strategy for DECISION_093. H0UND will become `P4NTH30N.exe` - an always-on platform that manages 15+ services through system tray integration, service orchestration, and boot-time auto-start.

**Key Deliverables**:
1. System Tray Architecture (Designer 1)
2. Service Orchestration & Health Monitoring (Designer 2)
3. Boot-time Auto-start & Service Lifecycle (Designer 3)
4. Complete Service Inventory (Explorer)

---

## 1. Complete Service Inventory

Based on Explorer investigation, P4NTH30N must manage the following services:

### Critical Services (Must Be Running)

| Priority | Service | Type | Purpose | Dependencies | Port/Endpoint |
|----------|---------|------|---------|--------------|---------------|
| 1 | MongoDB | Database | Stores decisions, RAG metadata, credentials, signals | None | localhost:27017 |
| 2 | LM Studio | AI/ML | Embeddings and vision model inference | None | localhost:1234 |
| 3 | Qdrant | Vector DB | FAISS-style vectors for RAG | Rancher Desktop | localhost:6333 |
| 4 | RAG Server | MCP Host | RAG tools (rag_query, rag_ingest, etc.) | MongoDB, LM Studio, Qdrant | localhost:5001 |
| 5 | MongoDB MCP | MCP Server | Decision CRUD operations | MongoDB | stdio via ToolHive |
| 6 | decisions-server | MCP Server | Decision persistence Docker | MongoDB | ToolHive managed |
| 7 | ToolHive Gateway | Registry | Aggregates 15+ MCP servers | Node runtime | Multiple ports |
| 8 | **P4NTH30N.exe** | Orchestrator | **Main platform manager (H0UND)** | All above | System tray |

### ToolHive Managed MCPs (15+ Servers)

| Category | Services |
|----------|----------|
| **Research** | brightdata-mcp, fetch, firecrawl, tavily-mcp |
| **Browser** | chrome-devtools-mcp, playwright |
| **Data** | arxiv-mcp-server, memory, json-query-mcp |
| **RAG** | rag-server (critical), mongodb-p4nth30n (critical) |
| **Utility** | sequentialthinking, toolhive-mcp-optimizer, context7-remote |

### Optional Services

| Service | Purpose | When Needed |
|---------|---------|-------------|
| Research MCPs | Web scraping/search | During research tasks |
| Browser MCPs | CDP automation | When H4ND needs browser control |
| Context/JSON tools | Documentation, memory | Advanced analytics |

### External Dependencies

| Service | Purpose | Verification |
|---------|---------|--------------|
| Google Chrome + ChromeDriver | CDP for H4ND | chrome.exe, port 9222 |
| OBS Studio | Vision capture | ws://localhost:4455 |
| Rancher Desktop + K8s | Infrastructure | kubectl, docker |

### Scheduled Tasks

| Task | Schedule | Purpose |
|------|----------|---------|
| P4NTH30N-AutoStart | Boot + 30s delay | Platform auto-start |
| RAG-Incremental-Rebuild | Every 4 hours | Index maintenance |
| RAG-Nightly-Rebuild | 03:00 daily | Full index rebuild |

---

## 2. Unified Architecture

### 2.1 System Tray Integration (Designer 1)

**Architecture**: Dual-thread with WinForms on background thread

```
┌─────────────────────────────────────────────────────────────┐
│                    P4NTH30N.exe Process                     │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────────────┐    ┌───────────────────────────┐ │
│  │    Main Thread       │    │   WinForms Thread         │ │
│  │  Spectre.Console     │    │   NotifyIcon Host         │ │
│  │  Dashboard           │    │   ApplicationContext      │ │
│  └──────────────────────┘    └───────────────────────────┘ │
│           ▲                              │                 │
│           │    ITrayCallback Events      │                 │
│           └──────────────────────────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

**Key Components**:
- `TrayHost.cs` - ApplicationContext with NotifyIcon
- `ConsoleWindowManager.cs` - Native window show/hide
- `ITrayCallback` - Cross-thread communication interface
- `NativeMethods.cs` - P/Invoke for console window

**Behavior**:
- Close button (X) → minimizes to tray (not exit)
- Double-click tray → toggle dashboard visibility
- Context menu: Show Dashboard, Exit

### 2.2 Service Orchestration (Designer 2)

**Architecture**: Hierarchical orchestrator with health monitoring

```
┌─────────────────────────────────────────┐
│     ServiceOrchestrator                 │
│  ┌─────────────────────────────────┐    │
│  │  Managed Service Registry       │    │
│  │  ┌─────────┐ ┌───────────────┐ │    │
│  │  │ RAG Svc │ │ MongoDB MCP   │ │    │
│  │  │ (HTTP)  │ │ (Stdio)       │ │    │
│  │  └────┬────┘ └───────┬───────┘ │    │
│  │       │              │         │    │
│  │  Health Check    Health Check  │    │
│  │  (30s interval)  (30s interval)│    │
│  └───────┼──────────────┼─────────┘    │
│          └──────────────┘              │
│              Auto-Restart              │
│         (Exponential Backoff)          │
└─────────────────────────────────────────┘
```

**Key Components**:
- `IServiceOrchestrator` / `ServiceOrchestrator` - Central management
- `IManagedService` / `ManagedService` - Base service interface
- `HttpManagedService` - For RAG Server (HTTP health checks)
- `StdioManagedService` - For MCP Server (JSON-RPC health checks)
- `ExponentialBackoffRetryPolicy` - 5s → 10s → 20s → 40s → 60s
- `ServiceCircuitBreaker` - Opens after 5 failures, 2min recovery

**Health Monitoring**:
| Service | Method | Endpoint | Interval |
|---------|--------|----------|----------|
| RAG Server | HTTP GET | /health | 30s |
| MongoDB MCP | JSON-RPC | tools/list | 30s |

### 2.3 Boot-time Auto-start (Designer 3)

**Architecture**: Task Scheduler + Service Lifecycle State Machine

```
┌─────────────────────────────────────────┐
│      Service Lifecycle States           │
│                                         │
│  Initializing → Starting → Running      │
│       ↑                        ↓        │
│   Stopped ←── Stopping ←── Degraded     │
│       ↑                                 │
│     Error                               │
└─────────────────────────────────────────┘
```

**Key Components**:
- `Register-AutoStart.ps1` - Task Scheduler registration
- `ServiceLifecycleManager` - State machine implementation
- `DependencyChainResolver` - MongoDB → RAG → MCP order
- `GracefulShutdownHandler` - Windows shutdown event handling

**Startup Order**:
1. MongoDB (foundation)
2. LM Studio (embeddings)
3. Qdrant (vector store)
4. RAG Server (needs 1-3)
5. MongoDB MCP + decisions-server
6. ToolHive Gateway (aggregates all)
7. **P4NTH30N.exe** (orchestrator)
8. Scheduled tasks

---

## 3. Implementation Plan

### Phase 1: Build Output Change (30 minutes)

**Files to Modify**:
```xml
<!-- H0UND/H0UND.csproj -->
<PropertyGroup>
  <OutputType>Exe</OutputType>
  <AssemblyName>P4NTH30N</AssemblyName>
  <UseWindowsForms>true</UseWindowsForms>
  <ApplicationManifest>app.manifest</ApplicationManifest>
</PropertyGroup>

<ItemGroup>
  <EmbeddedResource Include="Resources\hound-icon.ico" />
</ItemGroup>
```

### Phase 2: System Tray Integration (3 hours)

**Files to Create**:
1. `H0UND/Infrastructure/Tray/TrayHost.cs` - NotifyIcon host
2. `H0UND/Infrastructure/Tray/ConsoleWindowManager.cs` - Window management
3. `H0UND/Infrastructure/Tray/ITrayCallback.cs` - Communication interface
4. `H0UND/Infrastructure/Native/NativeMethods.cs` - P/Invoke
5. `H0UND/app.manifest` - Windows 10 styling
6. `H0UND/Resources/hound-icon.ico` - Tray icon

**Integration Points**:
- Modify `H0UND/Program.cs` to implement `ITrayCallback`
- Start TrayHost on background thread
- Wire up Show/Hide/Exit events

### Phase 3: Service Orchestration (4 hours)

**Files to Create**:
1. `H0UND/Services/Orchestration/IServiceOrchestrator.cs`
2. `H0UND/Services/Orchestration/ServiceOrchestrator.cs`
3. `H0UND/Services/Orchestration/IManagedService.cs`
4. `H0UND/Services/Orchestration/ManagedService.cs`
5. `H0UND/Services/Orchestration/HttpManagedService.cs`
6. `H0UND/Services/Orchestration/StdioManagedService.cs`
7. `H0UND/Services/Orchestration/ExponentialBackoffRetryPolicy.cs`
8. `H0UND/Services/Orchestration/ServiceCircuitBreaker.cs`
9. `H0UND/Services/Orchestration/HealthCheckers/HttpHealthChecker.cs`
10. `H0UND/Services/Orchestration/HealthCheckers/StdioHealthChecker.cs`

**Integration Points**:
- Initialize in `H0UND/Program.cs` after DisplayEventBus
- Configure services based on inventory above
- Add "MANAGED SERVICES" panel to dashboard

### Phase 4: Boot-time Auto-start (2 hours)

**Files to Create**:
1. `scripts/Register-AutoStart.ps1` - Task Scheduler registration
2. `scripts/Unregister-AutoStart.ps1` - Removal script
3. `scripts/Check-PlatformStatus.ps1` - Health verification
4. `config/autostart.json` - Service configuration
5. `H0UND/Infrastructure/BootTime/ServiceLifecycleManager.cs`
6. `H0UND/Infrastructure/BootTime/DependencyChainResolver.cs`
7. `H0UND/Infrastructure/BootTime/GracefulShutdownHandler.cs`

**Integration Points**:
- Handle `--background` flag in `Program.cs`
- Register shutdown handlers
- Check dependencies on startup

### Phase 5: Integration & Testing (2 hours)

**Tasks**:
1. End-to-end startup test
2. Service restart verification
3. Tray minimize/restore test
4. Boot-time auto-start test
5. Graceful shutdown test

---

## 4. File Inventory

### New Files (22 total)

**Tray Integration (6)**:
- `H0UND/Infrastructure/Tray/TrayHost.cs`
- `H0UND/Infrastructure/Tray/ConsoleWindowManager.cs`
- `H0UND/Infrastructure/Tray/ITrayCallback.cs`
- `H0UND/Infrastructure/Native/NativeMethods.cs`
- `H0UND/app.manifest`
- `H0UND/Resources/hound-icon.ico`

**Service Orchestration (10)**:
- `H0UND/Services/Orchestration/IServiceOrchestrator.cs`
- `H0UND/Services/Orchestration/ServiceOrchestrator.cs`
- `H0UND/Services/Orchestration/IManagedService.cs`
- `H0UND/Services/Orchestration/ManagedService.cs`
- `H0UND/Services/Orchestration/HttpManagedService.cs`
- `H0UND/Services/Orchestration/StdioManagedService.cs`
- `H0UND/Services/Orchestration/ExponentialBackoffRetryPolicy.cs`
- `H0UND/Services/Orchestration/ServiceCircuitBreaker.cs`
- `H0UND/Services/Orchestration/HealthCheckers/HttpHealthChecker.cs`
- `H0UND/Services/Orchestration/HealthCheckers/StdioHealthChecker.cs`

**Boot-time (6)**:
- `scripts/Register-AutoStart.ps1`
- `scripts/Unregister-AutoStart.ps1`
- `scripts/Check-PlatformStatus.ps1`
- `config/autostart.json`
- `H0UND/Infrastructure/BootTime/ServiceLifecycleManager.cs`
- `H0UND/Infrastructure/BootTime/DependencyChainResolver.cs`
- `H0UND/Infrastructure/BootTime/GracefulShutdownHandler.cs`

### Modified Files (2)

1. `H0UND/H0UND.csproj` - AssemblyName, UseWindowsForms
2. `H0UND/Program.cs` - Tray integration, orchestration startup

---

## 5. Configuration Schema

### autostart.json
```json
{
  "services": [
    {
      "name": "RAG Server",
      "type": "http",
      "executable": "C:\\ProgramData\\P4NTH30N\\bin\\RAG.McpHost.exe",
      "arguments": "--port 5001 --transport http --bridge http://127.0.0.1:5000",
      "healthCheck": {
        "type": "http",
        "url": "http://127.0.0.1:5001/health",
        "intervalSeconds": 30,
        "timeoutSeconds": 5
      },
      "autoRestart": {
        "enabled": true,
        "maxRetries": 5,
        "backoffBaseSeconds": 5
      }
    },
    {
      "name": "MongoDB MCP",
      "type": "stdio",
      "executable": "node",
      "arguments": "C:\\P4NTH30N\\tools\\mcp-p4nthon\\dist\\index.js",
      "healthCheck": {
        "type": "stdio",
        "method": "tools/list",
        "intervalSeconds": 30,
        "timeoutSeconds": 5
      },
      "autoRestart": {
        "enabled": true,
        "maxRetries": 5,
        "backoffBaseSeconds": 5
      }
    }
  ],
  "dependencies": [
    {
      "name": "MongoDB",
      "type": "tcp",
      "host": "localhost",
      "port": 27017,
      "required": true
    },
    {
      "name": "LM Studio",
      "type": "http",
      "url": "http://localhost:1234/v1/health",
      "required": true
    }
  ],
  "startup": {
    "delaySeconds": 30,
    "dependencyCheckTimeoutSeconds": 60,
    "parallelServiceStart": false
  }
}
```

---

## 6. Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Spectre.Console + WinForms threading conflicts | Run Spectre on main thread, WinForms on background thread |
| Service startup order failures | Dependency chain resolver with retry logic |
| Zombie subprocesses | PID tracking, Process.Dispose(), kill on parent exit |
| Boot-time race conditions | 30s delay, dependency health checks before starting services |
| Tray icon not visible | Test on Windows 10/11, handle DPI scaling |
| Circuit breaker thrashing | Exponential backoff, 2min recovery period |

---

## 7. Success Criteria

1. ✅ Build produces `P4NTH30N.exe`
2. ✅ System tray icon visible when running
3. ✅ Close button minimizes to tray (not exit)
4. ✅ Double-click tray shows/hides dashboard
5. ✅ H0UND starts RAG Server and MongoDB MCP automatically
6. ✅ Services restart on failure with backoff
7. ✅ Task Scheduler entry created for boot-time start
8. ✅ All 8 critical services managed by orchestrator
9. ✅ Graceful shutdown on system restart

---

## 8. Dependencies

- **Blocked By**: DECISION_092 (RAG Server + MongoDB MCP restoration)
- **Blocks**: None
- **Related**: DECISION_051 (MCP infrastructure), DECISION_079 (RAG registration)

---

## 9. Next Steps

1. **Implement DECISION_092 first** (unblocks service orchestration testing)
2. **Deploy WindFixer** for Phases 1-3 (C# implementation)
3. **Deploy OpenFixer** for Phase 4 (PowerShell scripts)
4. **Integration testing** after all phases complete

---

*Synthesis of 3 Designer consultations + Explorer research*  
*DECISION_093 - H0UND as Unified Always-On Platform*  
*2026-02-22*
