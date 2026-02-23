---
type: decision
id: DECISION_098
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.757Z'
last_reviewed: '2026-02-23T01:31:15.757Z'
keywords:
  - decision098
  - implement
  - recorder
  - navigation
  - map
  - h4nd
  - parallel
  - workers
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
  - create
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: DECISION_098 **Category**: ARCH (Architecture) **Status**:
  Completed **Priority**: Critical **Date**: 2026-02-22 **Oracle Approval**: 88%
  (Models: Kimi K2.5 - risk assessment, Claude 3.5 Sonnet - CDP patterns)
  **Designer Approval**: 95% (Models: Claude 3.5 Sonnet - architecture, Kimi
  K2.5 - implementation strategy)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_098.md
---
# DECISION_098: Implement Recorder Navigation Map to H4ND Parallel Workers

**Decision ID**: DECISION_098  
**Category**: ARCH (Architecture)  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-22  
**Oracle Approval**: 88% (Models: Kimi K2.5 - risk assessment, Claude 3.5 Sonnet - CDP patterns)  
**Designer Approval**: 95% (Models: Claude 3.5 Sonnet - architecture, Kimi K2.5 - implementation strategy)

---

## Executive Summary

The recorder at `C:\P4NTH30N\H4ND\tools\recorder` contains a complete navigation map in step-config.json, documenting verified FireKirin coordinates, timing, and verification gates. This decision implements that map into H4ND's ParallelSpinWorker, transforming manual recorder workflows into automated parallel execution.

**Current Problem**:
- Recorder has mapped FireKirin navigation (step-config.json ready)
- H4ND ParallelSpinWorker has Chrome profile isolation (DECISION_081 complete)
- Canvas typing has 6-strategy fallback (DECISION_081 complete)
- The bridge between recorder maps and H4ND automation does not exist
- Workers cannot yet execute the verified navigation paths

**Proposed Solution**:
- Create NavigationMapLoader to parse step-config.json
- Implement StepExecutor to execute recorder steps via CDP
- Wire ParallelSpinWorker to use navigation maps
- Enable automated parallel execution of verified paths

---

## Background

### Current State

**Recorder (DECISION_078 + DECISION_077)**:
- step-config.json contains verified FireKirin navigation
- Relative coordinates (rx/ry) with canvas bounds
- 6-strategy Canvas typing fallback
- Screenshot verification at each step
- Phase-based workflow: Login → Game Selection → Spin

**H4ND (DECISION_081)**:
- ChromeProfileManager with port isolation (9222-9231)
- Coordinate relativity via GetCanvasBoundsAsync
- JavaScript injection via Runtime.evaluate
- 6-strategy typing: Interceptor → EditBox → Canvas → DOM → KeyEvent → InsertText
- Login verification via balance query

**The Gap**:
No integration exists between recorder maps and H4ND workers. The verified coordinates sit in JSON while workers run blind.

### Desired State

ParallelSpinWorker loads navigation maps and executes them:
```csharp
// Worker loads map
var map = await NavigationMapLoader.LoadAsync("firekirin");

// Worker executes map
var executor = new StepExecutor(cdpClient, map);
var result = await executor.ExecuteAsync();
```

---

## Specification

### Requirements

1. **ARCH-098-001**: NavigationMapLoader
   - **Priority**: Must
   - **Acceptance Criteria**: Parse step-config.json into executable navigation map
   - **Implementation**: Load JSON, validate schema, convert to NavigationMap object

2. **ARCH-098-002**: StepExecutor
   - **Priority**: Must
   - **Acceptance Criteria**: Execute recorder steps via CDP with verification
   - **Implementation**: Execute click, type, wait, navigate actions with retry logic

3. **ARCH-098-003**: ParallelSpinWorker Integration
   - **Priority**: Must
   - **Acceptance Criteria**: Workers load and execute navigation maps
   - **Implementation**: Wire NavigationMapLoader and StepExecutor into worker loop

4. **ARCH-098-004**: Phase-Based Execution
   - **Priority**: Must
   - **Acceptance Criteria**: Login → Game Selection → Spin phases execute sequentially
   - **Implementation**: Phase gate verification before proceeding

5. **ARCH-098-005**: Screenshot Verification
   - **Priority**: Should
   - **Acceptance Criteria**: Capture screenshots at verification points
   - **Implementation**: CDP screenshot API at step completion

---

## Technical Details

### Files to Create

1. `H4ND/Navigation/NavigationMapLoader.cs`
   - Load step-config.json
   - Parse into NavigationMap object
   - Validate schema version

2. `H4ND/Navigation/StepExecutor.cs`
   - ExecuteStep(StepConfig step)
   - Handle click, type, wait, navigate
   - Verification gates
   - Retry logic

3. `H4ND/Navigation/NavigationMap.cs`
   - NavigationMap data model
   - Step collection
   - Phase tracking

### Files to Modify

1. `H4ND/Parallel/ParallelSpinWorker.cs`
   - Add NavigationMapLoader initialization
   - Add StepExecutor in ProcessSignalAsync
   - Remove hardcoded coordinates, use map

2. `C0MMON/Infrastructure/Cdp/CdpGameActions.cs`
   - Add ExecuteNavigationMapAsync method
   - Integrate with existing coordinate relativity

### Data Flow

```
Signal Received
    ↓
Load NavigationMap (platform from signal)
    ↓
Initialize ChromeProfile (worker-specific port)
    ↓
Execute Phase: Login
    - Navigate to URL
    - Click account field (rx/ry → absolute)
    - Type username (6-strategy fallback)
    - Click password field
    - Type password
    - Click login
    - Verify: Balance > 0
    ↓
Execute Phase: Game Selection
    - Navigate to game
    - Click game icon
    - Verify: Game loaded
    ↓
Execute Phase: Spin
    - Click spin button
    - Verify: Spin executed
    ↓
Report Success
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-098-001 | Create NavigationMapLoader.cs | @windfixer | ✅ Complete | Critical |
| ACT-098-002 | Create StepExecutor.cs | @windfixer | ✅ Complete | Critical |
| ACT-098-003 | Create NavigationMap.cs model | @windfixer | ✅ Complete | Critical |
| ACT-098-004 | Modify ParallelSpinWorker.cs | @windfixer | ✅ Complete | Critical |
| ACT-098-005 | Add ExecuteNavigationMapAsync | @windfixer | ✅ Complete | Critical |
| ACT-098-006 | Test with FireKirin map | @windfixer | ✅ Complete | Critical |
| ACT-098-007 | Verify parallel execution (5 workers) | @windfixer | ✅ Complete | High |

---

## Dependencies

- **Blocks**: DECISION_047 (Burn-in validation)
- **Blocked By**: DECISION_081 (Canvas typing - COMPLETE), DECISION_077 (Navigation - COMPLETE)
- **Related**: DECISION_078 (Recorder - COMPLETE)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| step-config.json format changes | High | Low | Version schema, validation on load |
| Canvas bounds change mid-execution | High | Medium | Re-query bounds each phase |
| Step execution timeout | Medium | Medium | Configurable timeout per step |
| Parallel worker collision | Medium | Low | Profile isolation already proven |

---

## Success Criteria

1. ✅ NavigationMapLoader parses step-config.json without errors
2. ✅ StepExecutor executes all step types (click, type, wait, navigate)
3. ✅ ParallelSpinWorker loads maps dynamically by platform
4. ✅ FireKirin navigation executes end-to-end automatically
5. ✅ 5 parallel workers execute simultaneously without collision
6. ✅ Screenshot verification captures at designated steps
7. ✅ Burn-in validation can proceed with automated navigation

---

## Token Budget

- **Estimated**: 35K tokens
- **Model**: Claude 3.5 Sonnet (WindFixer)
- **Budget Category**: Critical (<200K)

---

## Bug-Fix Section

- **On JSON parse error**: Validate schema version, report specific field error
- **On step execution failure**: Retry with exponential backoff, screenshot on failure
- **On verification gate failure**: Halt phase, capture state, report diagnostic
- **On test failure**: WindFixer self-resolves or delegates to Forgewright if >30min blocked

---

## Research Findings

### Web Research - CDP Automation Patterns

**CDP Best Practices** (from Tavily search):
- CDP uses WebSocket for bidirectional real-time communication
- Event-driven architecture: subscribe to lifecycle, DOM, network events  
- Commands follow JSON-RPC pattern with method/params structure
- Page.enable, DOM.enable required before operations
- Auto-wait strategies critical for stability (Playwright pattern)

**Playwright/Puppeteer Patterns**:
- Playwright uses "contexts" for isolation (similar to Chrome profiles)
- Auto-wait built into actions (element visible, stable, clickable)
- Locator API abstracts selector strategies
- Tracing captures DOM snapshots, network, timelines
- Route API for network interception

**Step Execution Patterns**:
- Step-by-step workflow with verification gates
- Retry logic with exponential backoff
- Screenshot capture on failure
- Phase-based execution (Login → Navigation → Action)

## Consultation Log

### Oracle Consultation (Assimilated)
- **Date**: 2026-02-22
- **Models**: Kimi K2.5 (risk assessment), Claude 3.5 Sonnet (CDP patterns)
- **Approval**: 88%
- **Key Findings**:
  - Strategy pattern reduces coupling, enables testing
  - Decorator pattern for retry is clean cross-cutting approach
  - Thread safety verified: per-worker CdpClient + shared readonly NavigationMap
  - Fallback to hardcoded methods maintains backward compatibility
- **Risks**:
  - Medium: JSON schema changes require code updates
  - Low: Performance impact negligible (~50KB per map)
  - Low: Cache invalidation needed on config updates

### Designer Consultation
- **Date**: 2026-02-22
- **Models**: Claude 3.5 Sonnet (architecture), Kimi K2.5 (implementation strategy)
- **Approval**: 95%
- **Implementation Strategy**:
  - **Architecture**: Strategy pattern (IStepStrategy) + Decorator (RetryStepDecorator)
  - **Loading**: Lazy + Cached via ConcurrentDictionary
  - **Thread Safety**: Per-worker CdpClient, shared readonly NavigationMap
  - **Error Handling**: Structured with recovery paths (Retry, Goto, Abort)
  - **Verification**: JavaScript expression evaluation for entry/exit gates
  - **Backward Compatibility**: Falls back to hardcoded CdpGameActions if map unavailable

### Implementation Details

**Files to Create**:
- `H4ND/Navigation/NavigationMapLoader.cs` - JSON parsing + caching
- `H4ND/Navigation/NavigationMap.cs` - Domain model
- `H4ND/Navigation/StepExecutor.cs` - Core executor
- `H4ND/Navigation/StepExecutionContext.cs` - Per-execution state
- `H4ND/Navigation/Strategies/IStepStrategy.cs` - Strategy interface
- `H4ND/Navigation/Strategies/ClickStepStrategy.cs` - Click action
- `H4ND/Navigation/Strategies/TypeStepStrategy.cs` - Type action (uses 6-strategy fallback)
- `H4ND/Navigation/Strategies/WaitStepStrategy.cs` - Wait action
- `H4ND/Navigation/Strategies/NavigateStepStrategy.cs` - Navigate action
- `H4ND/Navigation/Strategies/LongPressStepStrategy.cs` - Long press action
- `H4ND/Navigation/Retry/RetryStepDecorator.cs` - Retry decorator
- `H4ND/Navigation/Retry/ExponentialBackoffPolicy.cs` - Backoff calculation

**Files to Modify**:
- `H4ND/Parallel/ParallelSpinWorker.cs` - Use NavigationMap for login/logout
- `C0MMON/Infrastructure/Cdp/CdpGameActions.cs` - Expose helper methods

**Key Design Patterns**:
1. **Strategy Pattern**: IStepStrategy implementations for each action type
2. **Decorator Pattern**: RetryStepDecorator adds retry without modifying core
3. **Lazy Loading**: NavigationMapLoader caches maps, parses on first use
4. **Immutable Objects**: NavigationMap is readonly after construction

**Thread Safety**:
- ConcurrentDictionary for map cache
- Per-worker StepExecutionContext (not shared)
- Per-worker ICdpClient (isolated Chrome profiles)
- Shared readonly NavigationMap (safe for concurrent access)

**Retry Policy**:
- Max 3 retries
- Exponential backoff: 1s → 2s → 4s
- Jitter: ±10% to prevent thundering herd
- Screenshot capture on each failure

**Verification Gates**:
- Entry gate: Pre-condition check before step
- Exit gate: Post-condition verification after step
- JavaScript expressions evaluated via CDP Runtime.evaluate
- Special handling for "Balance > 0" verification

**Error Recovery**:
1. Capture screenshot on failure
2. Log diagnostics (duration, error, stack trace)
3. Consult error handler chain
4. Options: Retry, Goto recovery step, Abort

**Integration with Existing Code**:
```csharp
// In ParallelSpinWorker
var map = await _mapLoader.LoadAsync(credential.Game);
var context = new StepExecutionContext 
{ 
    CdpClient = cdp,
    Platform = credential.Game,
    Username = credential.Username,
    Variables = new() { ["username"] = credential.Username }
};
var result = await _stepExecutor.ExecutePhaseAsync(map, "Login", context);
```

**Fallback Behavior**:
- If step-config-{platform}.json not found, try step-config.json
- If map loading fails, fall back to hardcoded CdpGameActions methods
- Maintains backward compatibility during transition

---

## Comprehensive Specifications

Full implementation specifications including class diagrams, code examples, and integration details are available in:

**`STR4TEG15T/handoffs/DECISION_098_IMPLEMENTATION_SPECIFICATIONS.md`**

This document contains:
- Complete class specifications with code examples
- File structure and organization
- Dependency injection setup
- Thread safety analysis
- Integration checklist
- Testing strategy

---

## Notes

The step-config.json at `C:\P4NTH30N\H4ND\tools\recorder\step-config.json` is the source of truth. It contains:
- Verified FireKirin coordinates (rx/ry + x/y fallback)
- Phase-based workflow structure
- Verification gates for each step
- Screenshot triggers
- Timing and delay specifications

This decision bridges the gap between manual recorder workflows and automated H4ND execution.

---

*Decision DECISION_098*  
*Implement Recorder Navigation Map to H4ND*  
*2026-02-22*
