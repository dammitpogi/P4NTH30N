---
type: decision
id: DECISION_101
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.760Z'
last_reviewed: '2026-02-23T01:31:15.760Z'
keywords:
  - decision101
  - complete
  - h4nd
  - multiprofile
  - implementation
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
  - files
  - modify
  - code
  - changes
  - action
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: ARCH-101 **Category**: ARCH (Architecture) **Status**:
  Approved **Priority**: Critical **Date**: 2026-02-22 **Oracle Approval**: 82%
  (Models: Kimi K2.5 - risk assessment) **Designer Approval**: 95% (Models:
  Claude 3.5 Sonnet - implementation strategy)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_101.md
---
# DECISION_101: Complete H4ND Multiprofile Implementation

**Decision ID**: ARCH-101  
**Category**: ARCH (Architecture)  
**Status**: Approved  
**Priority**: Critical  
**Date**: 2026-02-22  
**Oracle Approval**: 82% (Models: Kimi K2.5 - risk assessment)  
**Designer Approval**: 95% (Models: Claude 3.5 Sonnet - implementation strategy)

---

## Executive Summary

DECISION_081 (Chrome Profile Isolation) created the `ChromeProfileManager` for isolated Chrome profiles per worker, but the integration is incomplete. The `WorkerPool` creates workers without injecting the `ChromeProfileManager`, meaning all workers share the same Chrome instance instead of having isolated profiles. This decision completes the multiprofile implementation by wiring the profile manager through the worker pool to each worker.

**Current Problem**:
- `ChromeProfileManager` exists but is not used by `WorkerPool`
- `ParallelSpinWorker` accepts `ChromeProfileManager` but receives null from `WorkerPool`
- All workers share the same Chrome CDP connection (port 9222)
- No cookie/session isolation between parallel workers
- Risk of credential cross-contamination and session conflicts

**Proposed Solution**:
- Wire `ChromeProfileManager` through `ParallelH4NDEngine` → `WorkerPool` → `ParallelSpinWorker`
- Launch isolated Chrome instances per worker (ports 9222-9231)
- Enable profile isolation for true parallel credential execution

---

## Background

### Current State

The architecture has the components but lacks the connections:

```
┌─────────────────────────────────────────────────────────────┐
│                    Current (Broken)                         │
├─────────────────────────────────────────────────────────────┤
│  ParallelH4NDEngine                                         │
│       │                                                     │
│       ▼                                                     │
│  WorkerPool ──▶ ParallelSpinWorker (cdpConfig only)         │
│       │                    │                                │
│       │                    ▼                                │
│       │            All workers → Chrome:9222 (shared)       │
│       │                                                     │
│  ChromeProfileManager (created but NOT injected)            │
└─────────────────────────────────────────────────────────────┘
```

**Evidence from Code Review**:

1. **WorkerPool.cs** (lines 34-53, 61-84): Creates workers with only `cdpConfig`, no `profileManager`:
```csharp
var worker = new ParallelSpinWorker(
    workerId: $"W{i:D2}",
    reader: _reader,
    uow: _uow,
    spinExecution: _spinExecution,
    cdpConfig: _cdpConfig,
    metrics: _metrics,
    sessionRenewal: _sessionRenewal,
    selectorConfig: _selectorConfig,  // <- No profileManager!
    maxSignalsBeforeRestart: _maxSignalsPerWorker);
```

2. **ParallelSpinWorker.cs** (lines 41-68): Accepts `ChromeProfileManager` but it's always null:
```csharp
public ParallelSpinWorker(
    ...
    ChromeProfileManager? profileManager = null,  // <- Always null from WorkerPool
    ...)
```

3. **ChromeProfileManager.cs**: Fully implemented but unused

### Desired State

```
┌─────────────────────────────────────────────────────────────┐
│                    Target (Fixed)                           │
├─────────────────────────────────────────────────────────────┤
│  ParallelH4NDEngine                                         │
│       │                                                     │
│       ├──▶ ChromeProfileManager (creates profiles)          │
│       │                                                     │
│       ▼                                                     │
│  WorkerPool ──▶ ParallelSpinWorker (with profileManager)    │
│       │                    │                                │
│       │                    ▼                                │
│       │            Worker-0 → Chrome:9222 (Profile-W0)      │
│       │            Worker-1 → Chrome:9223 (Profile-W1)      │
│       │            Worker-2 → Chrome:9224 (Profile-W2)      │
│       │                    ...                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Specification

### Requirements

1. **ARCH-101-001**: Wire ChromeProfileManager through ParallelH4NDEngine
   - **Priority**: Must
   - **Acceptance Criteria**: `ParallelH4NDEngine` creates and owns `ChromeProfileManager`
   - **Implementation**: Add `ChromeProfileManager` parameter to constructor, dispose in `Dispose()`

2. **ARCH-101-002**: Pass ChromeProfileManager to WorkerPool
   - **Priority**: Must
   - **Acceptance Criteria**: `WorkerPool` receives `ChromeProfileManager` and passes to workers
   - **Implementation**: Add parameter to `WorkerPool` constructor, store as field

3. **ARCH-101-003**: Inject ChromeProfileManager into each ParallelSpinWorker
   - **Priority**: Must
   - **Acceptance Criteria**: Each worker receives non-null `ChromeProfileManager`
   - **Implementation**: Pass `profileManager` to worker constructor in `StartAsync()`

4. **ARCH-101-004**: Ensure proper cleanup on shutdown
   - **Priority**: Must
   - **Acceptance Criteria**: All Chrome processes terminated on engine stop
   - **Implementation**: Call `_profileManager.Dispose()` in `ParallelH4NDEngine.Dispose()`

5. **ARCH-101-005**: Validate multiprofile operation
   - **Priority**: Must
   - **Acceptance Criteria**: Each worker uses different port (9222-9231) and profile directory
   - **Implementation**: Log port and profile directory on worker start

---

## Technical Details

### Files to Modify

1. **ParallelH4NDEngine.cs**:
   - Add `ChromeProfileManager? _profileManager` field
   - Add `ChromeProfileManager? profileManager = null` parameter to constructor
   - Pass `_profileManager` to `WorkerPool` constructor
   - Dispose `_profileManager` in `Dispose()` method

2. **WorkerPool.cs**:
   - Add `ChromeProfileManager? _profileManager` field
   - Add `ChromeProfileManager? profileManager = null` parameter to constructor
   - Pass `_profileManager` to `ParallelSpinWorker` constructor in `StartAsync()`

3. **ParallelSpinWorker.cs**:
   - Already accepts `ChromeProfileManager` (no changes needed)
   - Verify `_profileManager` is not null before use in `InitializeCdpWithProfileAsync()`

### Code Changes

**ParallelH4NDEngine.cs**:
```csharp
public sealed class ParallelH4NDEngine : IDisposable
{
    private readonly ChromeProfileManager? _profileManager;  // NEW
    
    public ParallelH4NDEngine(
        IUnitOfWork uow,
        CdpConfig cdpConfig,
        ParallelConfig config,
        SessionRenewalService? sessionRenewal = null,
        GameSelectorConfig? selectorConfig = null,
        ICdpLifecycleManager? cdpLifecycle = null,
        ChromeProfileManager? profileManager = null)  // NEW PARAMETER
    {
        _uow = uow;
        _cdpConfig = cdpConfig;
        _config = config;
        _sessionRenewal = sessionRenewal;
        _selectorConfig = selectorConfig;
        _cdpLifecycle = cdpLifecycle;
        _profileManager = profileManager;  // NEW
        _metrics = new ParallelMetrics();
        _spinMetrics = new SpinMetrics();
    }
    
    // In RunAsync(), pass to WorkerPool:
    _workerPool = new WorkerPool(
        _config.WorkerCount,
        channel.Reader,
        _uow,
        spinExecution,
        _cdpConfig,
        _metrics,
        _sessionRenewal,
        _selectorConfig,
        _config.MaxSignalsPerWorker,
        _profileManager);  // NEW
    
    public void Dispose()
    {
        if (_disposed) return;
        _disposed = true;
        _cts?.Cancel();
        _workerPool?.Dispose();
        _profileManager?.Dispose();  // NEW
        _cts?.Dispose();
    }
}
```

**WorkerPool.cs**:
```csharp
public sealed class WorkerPool : IDisposable
{
    private readonly ChromeProfileManager? _profileManager;  // NEW
    
    public WorkerPool(
        int workerCount,
        ChannelReader<SignalWorkItem> reader,
        IUnitOfWork uow,
        SpinExecution spinExecution,
        CdpConfig cdpConfig,
        ParallelMetrics metrics,
        SessionRenewalService? sessionRenewal = null,
        GameSelectorConfig? selectorConfig = null,
        int maxSignalsPerWorker = 100,
        ChromeProfileManager? profileManager = null)  // NEW PARAMETER
    {
        _workerCount = Math.Max(1, workerCount);
        _reader = reader;
        _uow = uow;
        _spinExecution = spinExecution;
        _cdpConfig = cdpConfig;
        _metrics = metrics;
        _sessionRenewal = sessionRenewal;
        _selectorConfig = selectorConfig;
        _maxSignalsPerWorker = maxSignalsPerWorker;
        _profileManager = profileManager;  // NEW
    }
    
    // In StartAsync(), pass to worker:
    var worker = new ParallelSpinWorker(
        workerId: $"W{i:D2}",
        reader: _reader,
        uow: _uow,
        spinExecution: _spinExecution,
        cdpConfig: _cdpConfig,
        metrics: _metrics,
        sessionRenewal: _sessionRenewal,
        selectorConfig: _selectorConfig,
        profileManager: _profileManager,  // NEW - NOW WIRED!
        maxSignalsBeforeRestart: _maxSignalsPerWorker);
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-101-001 | Add ChromeProfileManager to ParallelH4NDEngine | @windfixer | Completed | Critical |
| ACT-101-002 | Add ChromeProfileManager to WorkerPool | @windfixer | Completed | Critical |
| ACT-101-003 | Wire profileManager to ParallelSpinWorker | @windfixer | Completed | Critical |
| ACT-101-004 | Add disposal logic | @windfixer | Completed | Critical |
| ACT-101-005 | Verify build succeeds | @windfixer | Completed | Critical |

---

## Dependencies

- **Blocks**: DECISION_047 (Burn-in validation - needs isolated profiles)
- **Blocked By**: DECISION_081 (Chrome Profile Isolation - provides ChromeProfileManager)
- **Related**: DECISION_055 (Parallel execution), DECISION_098 (Navigation map)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Chrome port conflicts | High | Low | Use fixed port range (9222-9231), check before launch |
| Profile directory permissions | Medium | Low | Ensure `C:\ProgramData\P4NTH30N\chrome-profiles` exists and is writable |
| Memory usage with multiple Chrome instances | Medium | Medium | Monitor with 5 workers, scale down if needed |
| Profile cleanup failures | Low | Low | Set `CleanupProfilesOnDispose = false` to preserve sessions |

---

## Success Criteria

1. ✅ `ParallelH4NDEngine` accepts and stores `ChromeProfileManager`
2. ✅ `WorkerPool` passes `ChromeProfileManager` to each worker
3. ✅ Each worker will launch Chrome on unique port (9222-9231) when profileManager is provided
4. ✅ Each worker will use isolated profile directory (Profile-W0, Profile-W1, etc.) when profileManager is provided
5. ✅ Chrome processes will be cleaned up on engine shutdown via `_profileManager?.Dispose()`
6. ⬜ 3 workers run simultaneously with separate Chrome instances (pending live test)
7. ⬜ Burn-in can proceed with true parallel credential isolation (pending live test)

---

## Token Budget

- **Estimated**: 15K tokens
- **Model**: Claude 3.5 Sonnet (WindFixer)
- **Budget Category**: Routine (<50K)

---

## Bug-Fix Section

- **On port conflict**: Check if port in use, increment to next available
- **On profile launch failure**: Fall back to shared Chrome mode (current behavior)
- **On cleanup failure**: Log warning, continue shutdown
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-22
- **Models**: Kimi K2.5 (reasoning)
- **Approval**: 82%
- **Feasibility**: 8/10
- **Risk**: 4/10 (Low-Medium)
- **Complexity**: 4/10 (Low)
- **Key Findings**:
  - Port allocation conflicts possible with stale Chrome processes
  - Lifetime/ownership ambiguity risk for ChromeProfileManager
  - Partial wiring could lead to mixed shared/isolated sessions (hard to detect)
  - Profile directory permissions may cause cleanup issues
- **Recommendations**:
  1. Enforce single owner for ChromeProfileManager, document disposal order
  2. Add guardrail log per worker with port + profile path at start
  3. Add startup health check to confirm CDP reachable on assigned port
  4. Define clear fallback path when profileManager is null
- **Concerns**:
  - Static port range (9222-9231) is brittle if ports occupied
  - Disposal order matters: workers must shut down before profile manager

### Designer Consultation
- **Date**: 2026-02-22
- **Models**: Claude 3.5 Sonnet (implementation strategy)
- **Approval**: 95%
- **Key Findings**:
  - Purely additive changes - only optional parameters, no breaking changes
  - Follows established patterns (mirrors SessionRenewalService wiring)
  - Strong fallback: null profileManager maintains current behavior
  - Minimal surface area: only 2 files need modification (~15 lines)
- **Implementation Phases**:
  1. **ParallelH4NDEngine.cs**: Add field, constructor param, pass to WorkerPool, dispose
  2. **WorkerPool.cs**: Add field, constructor param, pass to ParallelSpinWorker
  3. **ParallelSpinWorker.cs**: No changes needed (already supports it)
- **Validation Steps**:
  1. Compilation check (dotnet build)
  2. Null safety verification (run with null profileManager)
  3. Multiprofile smoke test (3 workers, verify ports 9222-9224)
  4. Isolation test (verify Chrome processes and profile directories)
  5. Cleanup verification (stop engine, verify processes terminated)
- **Fallback Strategy**:
  - Port conflict: ChromeProfileManager auto-increments port
  - Permission denied: Fall back to null profileManager (shared Chrome)
  - Chrome launch failure: Worker restart with exponential backoff
  - Emergency revert: Set profileManager: null to restore pre-DECISION-101 behavior
- **Files to Modify**:
  - `H4ND/Parallel/ParallelH4NDEngine.cs` (~6 lines)
  - `H4ND/Parallel/WorkerPool.cs` (~5 lines)
  - `H4ND/Parallel/ParallelSpinWorker.cs` (0 lines - already supports)
  - `H4ND/Parallel/ChromeProfileManager.cs` (0 lines - already implemented)

---

## Notes

This is a **wiring decision** - the heavy lifting was done in DECISION_081. We just need to connect the existing `ChromeProfileManager` to the worker pipeline. The risk is low because:

1. `ChromeProfileManager` is already implemented and tested
2. `ParallelSpinWorker` already accepts and uses `ChromeProfileManager`
3. Changes are purely additive (new optional parameters)
4. Fallback to current behavior if `profileManager` is null

**Why this matters**: Without profile isolation, parallel workers share cookies and sessions. When Worker A logs into FireKirin, Worker B might see Worker A's session instead of its own credential. This causes authentication failures and false positives during burn-in.

---

*Decision ARCH-101*  
*Complete H4ND Multiprofile Implementation*  
*2026-02-22*
