---
type: decision
id: DECISION_056
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.691Z'
last_reviewed: '2026-02-23T01:31:15.691Z'
keywords:
  - decision056
  - automatic
  - chrome
  - cdp
  - lifecycle
  - management
  - executive
  - summary
  - background
  - current
  - state
  - desired
  - specification
  - requirements
  - technical
  - details
  - action
  - items
  - dependencies
  - risks
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: AUTO-056 **Category**: AUTO (Automation) **Status**:
  Completed **Priority**: Critical **Date**: 2026-02-21 **Oracle Approval**: 95%
  (Assimilated) **Designer Approval**: 96% (Assimilated)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_056.md
---
# DECISION_056: Automatic Chrome CDP Lifecycle Management

**Decision ID**: AUTO-056  
**Category**: AUTO (Automation)  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-21  
**Oracle Approval**: 95% (Assimilated)  
**Designer Approval**: 96% (Assimilated)

---

## Executive Summary

The 24-hour burn-in failed immediately because Chrome CDP was not running. Manual Chrome startup is a operational bottleneck that prevents autonomous operation. This decision implements automatic Chrome CDP lifecycle management - the system detects missing CDP, starts Chrome automatically with correct flags, monitors health, and restarts on failure.

**Current Problem**:
- Burn-in requires Chrome CDP on port 9222
- Chrome must be started manually with --remote-debugging-port=9222
- No automatic detection of CDP availability
- No automatic recovery when Chrome crashes or is closed
- Operational friction: human must remember to start Chrome before running H4ND

**Proposed Solution**:
- CdpLifecycleManager service that auto-starts Chrome with correct flags
- Pre-flight CDP probe before burn-in/parallel execution
- Automatic Chrome startup if CDP unavailable
- Health monitoring with automatic restart on failure
- Graceful Chrome shutdown on H4ND exit

---

## Background

### Current State

**Burn-in execution flow:**
1. H4ND.exe burn-in starts
2. Pre-flight checks: CDP, MongoDB, platforms
3. CDP check at 192.168.56.1:9222 fails immediately
4. Burn-in halts with error: "CDP connectivity is required"
5. User must manually start Chrome with debugging flags
6. User must restart burn-in

**Manual Chrome startup required:**
```bash
"C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --remote-debugging-address=0.0.0.0
```

### Desired State

**Automatic execution flow:**
1. H4ND.exe burn-in starts
2. Pre-flight checks: CDP, MongoDB, platforms
3. CDP check fails - CdpLifecycleManager detects missing Chrome
4. Auto-start Chrome with correct debugging flags
5. Wait for CDP to become available (retry with backoff)
6. Continue with burn-in
7. Monitor CDP health during execution
8. Auto-restart Chrome if it crashes
9. Graceful shutdown on completion

---

## Specification

### Requirements

1. **AUTO-056-001**: CDP Availability Detection
   - **Priority**: Must
   - **Acceptance Criteria**: Probe CDP at configured host:port; return healthy/unhealthy within 5 seconds; distinguish between "not running" vs "wrong address"
   - **Implementation**: HTTP GET to /json/version endpoint, WebSocket handshake test

2. **AUTO-056-002**: Automatic Chrome Startup
   - **Priority**: Must
   - **Acceptance Criteria**: If CDP unavailable, auto-start Chrome with --remote-debugging-port, --remote-debugging-address=0.0.0.0, --headless (configurable); use Process.Start with correct executable path; verify Chrome process started successfully
   - **Implementation**: CdpLifecycleManager.StartChromeAsync()

3. **AUTO-056-003**: Chrome Process Monitoring
   - **Priority**: Must
   - **Acceptance Criteria**: Monitor Chrome process health every 30 seconds; detect process exit/crash; auto-restart with exponential backoff (max 3 attempts); log all lifecycle events
   - **Implementation**: Process.Exited event handler, health check loop

4. **AUTO-056-004**: Graceful Shutdown
   - **Priority**: Must
   - **Acceptance Criteria**: On H4ND exit (Ctrl+C, normal completion), gracefully close Chrome; send SIGTERM before SIGKILL; wait up to 10 seconds for clean exit; force kill if necessary
   - **Implementation**: AppDomain.ProcessExit handler, CancellationToken propagation

5. **AUTO-056-005**: Configuration Integration
   - **Priority**: Must
   - **Acceptance Criteria**: Read Chrome path from appsettings.json; support headless vs headed mode; configurable port and host; enable/disable auto-start
   - **Implementation**: CdpLifecycleConfig POCO, appsettings.json section

6. **AUTO-056-006**: Pre-Flight Integration
   - **Priority**: Must
   - **Acceptance Criteria**: BurnInController calls CdpLifecycleManager.EnsureAvailable() before starting; ParallelH4NDEngine calls EnsureAvailable() before worker pool; returns only when CDP confirmed healthy or auto-start failed after retries
   - **Implementation**: Modify BurnInController.PreFlightChecks(), ParallelH4NDEngine.StartAsync()

### Technical Details

**CdpLifecycleConfig (appsettings.json):**
```json
{
  "P4NTH30N": {
    "H4ND": {
      "CdpLifecycle": {
        "AutoStart": true,
        "ChromePath": "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
        "Headless": false,
        "DebugPort": 9222,
        "DebugHost": "0.0.0.0",
        "StartupTimeoutSeconds": 30,
        "HealthCheckIntervalSeconds": 30,
        "MaxAutoRestarts": 3,
        "RestartBackoffSeconds": [5, 10, 30],
        "GracefulShutdownTimeoutSeconds": 10,
        "AdditionalArgs": ["--no-sandbox", "--disable-gpu"]
      }
    }
  }
}
```

**CdpLifecycleManager Interface:**
```csharp
public interface ICdpLifecycleManager
{
    Task<bool> IsAvailableAsync(CancellationToken ct = default);
    Task<bool> EnsureAvailableAsync(CancellationToken ct = default);
    Task StartChromeAsync(CancellationToken ct = default);
    Task StopChromeAsync(CancellationToken ct = default);
    Task RestartChromeAsync(CancellationToken ct = default);
    CdpHealthStatus GetHealthStatus();
}

public class CdpLifecycleManager : ICdpLifecycleManager
{
    private readonly CdpLifecycleConfig _config;
    private readonly ILogger<CdpLifecycleManager> _logger;
    private Process? _chromeProcess;
    private int _restartAttempts = 0;
    private Timer? _healthCheckTimer;
    
    public async Task<bool> EnsureAvailableAsync(CancellationToken ct)
    {
        // 1. Check if CDP already available
        if (await IsAvailableAsync(ct))
            return true;
            
        // 2. Auto-start Chrome if configured
        if (!_config.AutoStart)
            return false;
            
        await StartChromeAsync(ct);
        
        // 3. Wait for CDP with timeout
        return await WaitForCdpAsync(_config.StartupTimeoutSeconds, ct);
    }
    
    public async Task StartChromeAsync(CancellationToken ct)
    {
        var args = BuildChromeArgs();
        _chromeProcess = Process.Start(new ProcessStartInfo
        {
            FileName = _config.ChromePath,
            Arguments = args,
            UseShellExecute = false,
            CreateNoWindow = _config.Headless
        });
        
        _chromeProcess.EnableRaisingEvents = true;
        _chromeProcess.Exited += OnChromeExited;
        
        StartHealthMonitoring();
    }
    
    private void OnChromeExited(object? sender, EventArgs e)
    {
        _logger.LogWarning("Chrome process exited unexpectedly");
        if (_restartAttempts < _config.MaxAutoRestarts)
        {
            var backoff = _config.RestartBackoffSeconds[_restartAttempts];
            _logger.LogInfo($"Restarting Chrome in {backoff}s (attempt {_restartAttempts + 1}/{_config.MaxAutoRestarts})");
            Task.Delay(TimeSpan.FromSeconds(backoff)).ContinueWith(_ => RestartChromeAsync());
            _restartAttempts++;
        }
    }
}
```

**Pre-Flight Integration in BurnInController:**
```csharp
public async Task RunAsync(CancellationToken ct)
{
    // Pre-flight checks
    _logger.LogInfo("Pre-flight checks...");
    
    // CDP - auto-start if needed
    if (!await _cdpLifecycle.EnsureAvailableAsync(ct))
    {
        _logger.LogError("CDP unavailable and auto-start failed");
        return;
    }
    
    // Continue with burn-in...
}
```

**File Structure:**
```
H4ND/
  Services/
    CdpLifecycleManager.cs        (NEW: Chrome lifecycle management)
    CdpLifecycleConfig.cs         (NEW: Configuration POCO)
    CdpHealthStatus.cs            (NEW: Health status enum/DTO)
  Infrastructure/
    Cdp/CdpHealthChecker.cs       (MODIFY: integrate with lifecycle manager)
  BurnIn/
    BurnInController.cs           (MODIFY: call EnsureAvailableAsync)
  Parallel/
    ParallelH4NDEngine.cs         (MODIFY: call EnsureAvailableAsync)
appsettings.json                  (MODIFY: add CdpLifecycle section)
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-056-001 | Create CdpLifecycleConfig.cs configuration POCO | @windfixer | Pending | Critical |
| ACT-056-002 | Create CdpHealthStatus.cs enum/DTO | @windfixer | Pending | Critical |
| ACT-056-003 | Create CdpLifecycleManager.cs with auto-start logic | @windfixer | Pending | Critical |
| ACT-056-004 | Modify BurnInController.cs to call EnsureAvailableAsync | @windfixer | Pending | Critical |
| ACT-056-005 | Modify ParallelH4NDEngine.cs to call EnsureAvailableAsync | @windfixer | Pending | Critical |
| ACT-056-006 | Update appsettings.json with CdpLifecycle section | @windfixer | Pending | Critical |
| ACT-056-007 | Add graceful shutdown handler (ProcessExit) | @windfixer | Pending | High |
| ACT-056-008 | Create CdpLifecycleManagerTests.cs (unit tests) | @windfixer | Pending | High |
| ACT-056-009 | Integration test: burn-in auto-starts Chrome | @windfixer | Pending | Critical |
| ACT-056-010 | Integration test: Chrome crash auto-recovery | @windfixer | Pending | High |

---

## Dependencies

- **Blocks**: 24-hour burn-in execution (DECISION_047 final validation)
- **Blocked By**: None (can be implemented immediately)
- **Related**: 
  - DECISION_047 (Parallel H4ND) - uses CDP
  - DECISION_055 (Unified Engine) - burn-in requires CDP
  - DECISION_026 (CDP Automation) - SessionPool, CdpClient

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Chrome not installed at expected path | High | Medium | Configurable ChromePath; auto-detect common locations; clear error message if not found |
| Chrome startup timeout (slow machine) | Medium | Medium | Configurable StartupTimeoutSeconds; retry logic; clear logging |
| Chrome crashes repeatedly | High | Low | Max 3 auto-restarts with backoff; halt after max attempts; alert operator |
| Multiple H4ND instances conflict | Medium | Low | Check if Chrome already running before starting; use process locking |
| Graceful shutdown fails (zombie Chrome) | Low | Medium | Force kill after timeout; log warning; manual cleanup documented |

---

## Success Criteria

1. **Auto-Start**: Burn-in starts successfully without manually starting Chrome first
2. **Detection**: CDP availability detected within 5 seconds
3. **Startup**: Chrome starts with correct flags (--remote-debugging-port=9222, --remote-debugging-address=0.0.0.0)
4. **Recovery**: Chrome crash auto-restarts within 30 seconds (with backoff)
5. **Graceful Shutdown**: Chrome closes cleanly on H4ND exit
6. **Configurability**: All settings configurable via appsettings.json
7. **Backward Compatible**: Existing CDP usage unaffected when AutoStart=false

---

## Token Budget

- **Estimated**: 45,000 tokens
- **Model**: Claude 3.5 Sonnet (via OpenRouter)
- **Budget Category**: Critical (<200K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On config error**: Delegate to @openfixer for appsettings.json issues
- **On test failure**: WindFixer self-resolves or delegates to Forgewright if >30min blocked
- **On Chrome startup failure**: Log detailed error with path/args; escalate to @openfixer if config issue
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Oracle | Validation sub-decisions | Medium | No (Assimilated) |
| Designer | Architecture sub-decisions | Medium | No (Assimilated) |
| WindFixer | Implementation sub-decisions | High | Yes (Strategist) |
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Bug-fix sub-decisions | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-21
- **Approval**: 95%
- **Key Findings**:
  - Feasibility: 9/10 - Standard process management, well-understood patterns
  - Risk: 3/10 - Low risk, Chrome startup is reliable on Windows
  - Implementation Complexity: 4/10 - Process.Start, event handlers, config binding
  - Resource Requirements: 2/10 - No external dependencies

**APPROVAL ANALYSIS:**
- Overall Approval Percentage: 95%
- Feasibility Score: 9/10 (30% weight) - Process management is standard .NET
- Risk Score: 3/10 (30% weight) - Chrome is stable, auto-restart handles edge cases
- Implementation Complexity: 4/10 (20% weight) - Straightforward lifecycle management
- Resource Requirements: 2/10 (20% weight) - Uses built-in .NET APIs

**Positive Factors:**
+ Eliminates operational friction: +20% - No more manual Chrome startup
+ Enables true automation: +15% - Burn-in can run unattended
+ Proven patterns: +10% - Process.Start, Exited events are standard
+ Configurable: +8% - Works with different Chrome installations

**Negative Factors:**
- Process management edge cases: -8% - Zombie processes, permission issues
- Platform differences: -5% - Windows vs Linux Chrome paths
- Shutdown timing: -5% - Graceful vs force kill tradeoffs

**GUARDRAIL CHECK:**
[PASS] Standard .NET patterns (Process.Start, Timer, events)
[PASS] Clear success criteria (auto-start, recovery, shutdown)
[PASS] Backward compatible (AutoStart=false preserves existing behavior)
[PASS] Error handling specified (max restarts, backoff, logging)

**APPROVAL LEVEL:**
- Approved - 95% - Critical automation improvement, low risk, high value

### Designer Consultation (Strategist Assimilated)
- **Date**: 2026-02-21
- **Approval**: 96%
- **Key Findings**:
  - Clean separation of concerns: CdpLifecycleManager handles Chrome, existing code unchanged
  - Interface-based design enables testing and mocking
  - Configuration-driven for flexibility across environments

**DESIGN SPECIFICATIONS:**

**Implementation Plan (4-6 hours):**

**Phase 1: Configuration + DTOs (1 hour)**
1. Create CdpLifecycleConfig.cs with all settings
2. Create CdpHealthStatus.cs enum
3. Update appsettings.json with CdpLifecycle section
4. Validation: Config binds correctly

**Phase 2: Core Lifecycle Manager (2-3 hours)**
1. Create CdpLifecycleManager.cs implementing ICdpLifecycleManager
2. Implement IsAvailableAsync() - HTTP probe to /json/version
3. Implement StartChromeAsync() - Process.Start with args
4. Implement StopChromeAsync() - graceful then force kill
5. Implement health monitoring - Timer with 30s interval
6. Implement auto-restart - Exited event handler with backoff
7. Validation: Chrome starts, stops, restarts correctly

**Phase 3: Integration (1-2 hours)**
1. Modify BurnInController.PreFlightChecks() to call EnsureAvailableAsync()
2. Modify ParallelH4NDEngine.StartAsync() to call EnsureAvailableAsync()
3. Add graceful shutdown handler in H4ND.cs Program.Main
4. Validation: Burn-in auto-starts Chrome

**Phase 4: Testing (1 hour)**
1. Create CdpLifecycleManagerTests.cs
2. Test: Chrome not installed → clear error
3. Test: Chrome starts with correct args
4. Test: Graceful shutdown works
5. Validation: All tests pass

**Files to Create:**
- H4ND/Services/CdpLifecycleConfig.cs (~40 lines)
- H4ND/Services/CdpHealthStatus.cs (~15 lines)
- H4ND/Services/CdpLifecycleManager.cs (~250 lines)
- UNI7T35T/Tests/CdpLifecycleManagerTests.cs (~100 lines)

**Files to Modify:**
- H4ND/BurnIn/BurnInController.cs (~10 lines - add EnsureAvailable call)
- H4ND/Parallel/ParallelH4NDEngine.cs (~10 lines - add EnsureAvailable call)
- H4ND/H4ND.cs (~15 lines - add shutdown handler)
- appsettings.json (~20 lines - add CdpLifecycle section)

**Total:** ~460 lines across 8 files

**Parallel Workstreams:**
- Phase 1 + 2 can be done together (config + core manager)
- Phase 3 depends on Phase 2
- Phase 4 depends on Phase 3

**Validation Criteria:**
- Chrome auto-starts when running `P4NTH30N.exe burn-in` without manual Chrome startup
- Chrome process visible in Task Manager with correct command line
- Burn-in proceeds after Chrome becomes available
- Chrome closes when H4ND exits
- Auto-restart works if Chrome killed during burn-in

---

## Notes

**Why This Decision Exists:**
The 24-hour burn-in is the final validation for DECISION_047. It cannot proceed without Chrome CDP. Manual Chrome startup is a operational bottleneck that prevents true automation. This decision removes the human from the loop.

**Integration Points:**
- CdpLifecycleManager is a service injected where CDP is needed
- BurnInController and ParallelH4NDEngine both depend on ICdpLifecycleManager
- Existing CdpClient and SessionPool unchanged - they use CDP after it's available

**Backward Compatibility:**
- Setting AutoStart=false preserves existing behavior
- Manual Chrome startup still works
- No changes to CdpConfig (host, port) - only adds lifecycle management

**Future Enhancements:**
- Docker Chrome support (run Chrome in container)
- Remote Chrome support (connect to Chrome on different machine)
- Chrome profile management (preserve cookies/cache between runs)

---

*Decision AUTO-056*  
*Automatic Chrome CDP Lifecycle Management*  
*2026-02-21*  
*Status: Approved - Ready for WindFixer Implementation*
