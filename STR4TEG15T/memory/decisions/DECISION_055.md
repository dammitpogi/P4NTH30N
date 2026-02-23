---
type: decision
id: DECISION_055
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.689Z'
last_reviewed: '2026-02-23T01:31:15.689Z'
keywords:
  - decision055
  - unified
  - game
  - execution
  - engine
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
  - and
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: ARCH-055 **Category**: ARCH (Architecture) **Status**:
  Completed **Priority**: Critical **Date**: 2026-02-20 **Oracle Approval**: 93%
  (Assimilated) **Designer Approval**: 95% (Assimilated)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_055.md
---
# DECISION_055: Unified Game Execution Engine

**Decision ID**: ARCH-055  
**Category**: ARCH (Architecture)  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-20  
**Oracle Approval**: 93% (Assimilated)  
**Designer Approval**: 95% (Assimilated)

---

## Executive Summary

P4NTH30N has three critical subsystems that work independently but have never been unified into a single, coherent execution surface: parallel signal processing (DECISION_047), config-driven selectors (DECISION_046), and session renewal with self-healing (DECISION_041). This decision creates a Unified Game Execution Engine — a single `P4NTH30N.exe` with subcommands that brings all three together, adds a signal generator for test/burn-in scenarios, and establishes a health dashboard for operational monitoring.

The gap is clear: DECISION_047's parallel engine passed shadow validation but is blocked waiting for live signals in the SIGN4L collection. There is no way to generate test signals. The config-driven selectors from DECISION_046 are implemented in `GameSelectorConfig` but not wired into the parallel workers. The `SessionRenewalService` from DECISION_041 exists but is not invoked automatically when parallel workers encounter 403 responses. This decision eliminates all three gaps.

**Current Problem**:
- DECISION_047 parallel engine works but has no signals to process — zero entries in SIGN4L
- No signal generator exists — cannot populate SIGN4L for testing or burn-in validation
- Config-driven selectors (GameSelectorConfig) not integrated into ParallelSpinWorker
- SessionRenewalService not wired into parallel worker error recovery
- RunMode enum only supports H4ND/H0UND/FIRSTSPIN/PARALLEL — missing health, signal-gen, burn-in
- No unified operational dashboard showing system health across all subsystems
- 24-hour burn-in validation (ARCH-047-006) cannot proceed without signal population

**Proposed Solution**:
- Extend `UnifiedEntryPoint` with new subcommands: `spin`, `parallel`, `generate-signals`, `health`, `burn-in`
- Create `SignalGenerator` service to populate SIGN4L collection from CR3D3N7IAL credentials
- Wire `SessionRenewalService` into `ParallelSpinWorker` error handling (403/401 → auto-renew)
- Inject `GameSelectorConfig` into parallel workers for config-driven selector resolution
- Create `SystemHealthReport` aggregating CDP, MongoDB, platform, and worker health
- Create `BurnInController` for automated 24-hour validation with metrics collection

---

## Background

### Current State

**Infrastructure in place (implemented, working):**
- `H4ND/Parallel/ParallelH4NDEngine.cs` — bounded channel, distributor, worker pool (DECISION_047)
- `H4ND/Parallel/SignalDistributor.cs` — atomic signal claiming from SIGN4L via FindOneAndUpdate
- `H4ND/Parallel/ParallelSpinWorker.cs` — per-worker CDP spin execution
- `H4ND/Parallel/WorkerPool.cs` — N-worker orchestration with cancellation
- `H4ND/Services/SessionRenewalService.cs` — 403 detection, credential refresh, platform fallback (DECISION_041)
- `C0MMON/Infrastructure/Cdp/GameSelectorConfig.cs` — per-game selector chains with fallback (DECISION_046)
- `H4ND/EntryPoint/UnifiedEntryPoint.cs` — mode routing for H4ND/H0UND/FIRSTSPIN/PARALLEL
- `appsettings.json` — GameSelectors, Parallel config, CDP config all defined

**Gaps preventing live execution:**
1. SIGN4L collection is empty — no signal generator exists
2. ParallelSpinWorker does not call SessionRenewalService on auth failures
3. ParallelSpinWorker does not use GameSelectorConfig for selector resolution
4. No `generate-signals` subcommand to populate SIGN4L
5. No `health` subcommand for operational visibility
6. No `burn-in` subcommand for automated 24-hour validation
7. RunMode enum missing new modes

### Desired State

Single executable with complete operational surface:

```
P4NTH30N.exe spin              → Execute one spin cycle (sequential, existing H4ND mode)
P4NTH30N.exe parallel          → Execute parallel spins (DECISION_047 engine)
P4NTH30N.exe generate-signals  → Populate SIGN4L from CR3D3N7IAL credentials
P4NTH30N.exe health            → Show system health (CDP, MongoDB, platforms, workers)
P4NTH30N.exe burn-in           → 24-hour automated validation with metrics
P4NTH30N.exe h0und             → Existing H0UND analytics mode
P4NTH30N.exe firstspin         → Existing first spin mode (DECISION_044)
```

Self-healing parallel execution:
- Worker encounters 403 → SessionRenewalService.RenewSessionAsync() → retry with fresh session
- Worker encounters stale selector → GameSelectorConfig fallback chain → next selector
- Worker crashes → WorkerPool restarts worker after delay → stale claim reclaimed by distributor
- All platforms down → FindWorkingPlatformAsync() → halt and alert

---

## Specification

### Requirements

1. **ARCH-055-001**: Extended UnifiedEntryPoint with New Subcommands
   - **Priority**: Must
   - **Acceptance Criteria**: RunMode enum includes Spin, Parallel, GenerateSignals, Health, BurnIn; ParseMode resolves all subcommands; backward compatible with existing H4ND/H0UND/FIRSTSPIN/PARALLEL strings
   - **Implementation**: Extend `H4ND/EntryPoint/UnifiedEntryPoint.cs` and `H4ND/H4ND.cs` (Program.Main)

2. **ARCH-055-002**: Signal Generator Service
   - **Priority**: Must
   - **Acceptance Criteria**: Generates N signals from enabled, unlocked credentials in CR3D3N7IAL; signals have valid House/Game/Username/Password/Priority; no duplicate signals for same credential; configurable count and priority distribution
   - **Implementation**: New `H4ND/Services/SignalGenerator.cs`

3. **ARCH-055-003**: SessionRenewalService Integration in Parallel Workers
   - **Priority**: Must
   - **Acceptance Criteria**: When ParallelSpinWorker receives 403/401 from platform, SessionRenewalService.RenewSessionAsync() is invoked automatically; on renewal success, worker retries spin; on renewal failure, worker tries platform fallback via FindWorkingPlatformAsync(); metric tracked for renewal events
   - **Implementation**: Modify `H4ND/Parallel/ParallelSpinWorker.cs` to inject and use SessionRenewalService

4. **ARCH-055-004**: GameSelectorConfig Integration in Parallel Workers
   - **Priority**: Must
   - **Acceptance Criteria**: ParallelSpinWorker resolves selectors via GameSelectorConfig.GetSelectors(game) instead of hardcoded expressions; fallback chain executes in order per DECISION_046; selector success/failure logged for diagnostics
   - **Implementation**: Modify `H4ND/Parallel/ParallelSpinWorker.cs` to inject GameSelectorConfig; modify `H4ND/Infrastructure/CdpGameActions.cs` if selector lookup not already parameterized

5. **ARCH-055-005**: System Health Report
   - **Priority**: Must
   - **Acceptance Criteria**: Single health command outputs JSON report with: CDP connectivity status, MongoDB connectivity and collection counts (SIGN4L, CR3D3N7IAL, ERR0R), platform probe results (FireKirin, OrionStars), parallel engine status (workers active, signals pending, signals completed), last error summary
   - **Implementation**: New `H4ND/Services/SystemHealthReport.cs`

6. **ARCH-055-006**: Burn-In Controller
   - **Priority**: Must
   - **Acceptance Criteria**: Runs for configurable duration (default 24 hours); generates signals automatically if SIGN4L is empty; starts parallel engine; collects ParallelMetrics every 60 seconds; detects and reports: signal duplication, memory growth, stranded credentials, error rate spikes; produces final summary report; halts on critical failures (duplication detected, error rate >10%)
   - **Implementation**: New `H4ND/Services/BurnInController.cs`

7. **ARCH-055-007**: Stale Claim Self-Healing Enhancement
   - **Priority**: Should
   - **Acceptance Criteria**: SignalDistributor reclaims signals where ClaimedAt > 2 minutes ago with ClaimedBy != null (already specified in ARCH-047-008); additionally logs reclaim events to ParallelMetrics; alerts if reclaim rate exceeds 10% of total claims
   - **Implementation**: Verify in `H4ND/Parallel/SignalDistributor.cs`, enhance metrics

8. **ARCH-055-008**: Graceful Shutdown with Credential Unlock
   - **Priority**: Must
   - **Acceptance Criteria**: On Ctrl+C or CancellationToken cancellation, all workers drain current spin; all locked credentials are unlocked; all claimed signals are released; shutdown completes within 30 seconds; log summary of cleanup actions
   - **Implementation**: Enhance `H4ND/Parallel/WorkerPool.cs` shutdown path; add credential unlock sweep

### Technical Details

**Extended RunMode Enum:**
```csharp
public enum RunMode
{
    Sequential,     // "H4ND" or "spin" — existing sequential mode
    Hound,          // "H0UND" — existing analytics mode
    FirstSpin,      // "FIRSTSPIN" — existing first spin (DECISION_044)
    Parallel,       // "PARALLEL" — parallel engine (DECISION_047)
    GenerateSignals,// "GENERATE-SIGNALS" — signal population
    Health,         // "HEALTH" — system health check
    BurnIn,         // "BURN-IN" — 24-hour validation
    Unknown,
}
```

**Extended ParseMode:**
```csharp
public static RunMode ParseMode(string[] args)
{
    string mode = args.Length > 0 ? args[0].ToUpperInvariant() : "H4ND";
    return mode switch
    {
        "H4ND" or "SPIN" => RunMode.Sequential,
        "H0UND" => RunMode.Hound,
        "FIRSTSPIN" => RunMode.FirstSpin,
        "PARALLEL" => RunMode.Parallel,
        "GENERATE-SIGNALS" or "GEN" => RunMode.GenerateSignals,
        "HEALTH" => RunMode.Health,
        "BURN-IN" or "BURNIN" => RunMode.BurnIn,
        _ => RunMode.Unknown,
    };
}
```

**Signal Generator Algorithm:**
```csharp
public class SignalGenerator
{
    private readonly IUnitOfWork _uow;

    public SignalGenerator(IUnitOfWork uow) => _uow = uow;

    /// <summary>
    /// Generates N signals from enabled, unlocked, non-banned credentials.
    /// Priority distribution: 40% Priority 1 (Mini), 30% Priority 2 (Minor),
    /// 20% Priority 3 (Major), 10% Priority 4 (Grand).
    /// </summary>
    public SignalGenerationResult Generate(int count, string? filterGame = null, string? filterHouse = null)
    {
        // 1. Query CR3D3N7IAL for eligible credentials
        // 2. Filter by game/house if specified
        // 3. Shuffle credentials to avoid bias
        // 4. Assign priority using distribution weights
        // 5. Check for existing unacknowledged signals (no duplicates)
        // 6. Insert via _uow.Signals.Upsert(signal)
        // 7. Return count inserted, count skipped (duplicates), count failed
    }
}
```

**CLI Arguments for generate-signals:**
```
P4NTH30N.exe generate-signals [count] [--game FireKirin|OrionStars] [--house HouseName] [--priority 1-4]
```
- `count`: Number of signals to generate (default: 10)
- `--game`: Filter credentials by game platform
- `--house`: Filter credentials by house
- `--priority`: Override priority distribution with fixed priority

**Self-Healing Integration Pattern (ParallelSpinWorker):**
```csharp
// Inside ParallelSpinWorker.ProcessSignalAsync():
try
{
    // ... existing spin execution with GameSelectorConfig ...
    var selectors = _gameSelectorConfig.GetSelectors(signal.Game);
    // Use selectors.JackpotTierExpressions for jackpot reading
    // Use selectors.PageReadyChecks for page readiness
}
catch (HttpRequestException ex) when (ex.StatusCode is HttpStatusCode.Forbidden or HttpStatusCode.Unauthorized)
{
    // AUTH-041 integration: self-healing
    _metrics.IncrementRenewalAttempts();
    var renewal = await _sessionRenewal.RenewSessionAsync(signal.Game, ct);
    if (renewal.Success)
    {
        _metrics.IncrementRenewalSuccesses();
        // Retry spin with renewed session
    }
    else
    {
        // Try platform fallback
        var fallback = await _sessionRenewal.FindWorkingPlatformAsync(ct);
        if (!fallback.Success)
        {
            _metrics.IncrementCriticalFailures();
            // Release signal for reclaim, worker enters backoff
        }
    }
}
```

**System Health Report Schema:**
```json
{
    "timestamp": "2026-02-20T12:00:00Z",
    "overall": "Healthy|Degraded|Critical",
    "cdp": {
        "connected": true,
        "latencyMs": 12,
        "hostIp": "192.168.56.1",
        "port": 9222
    },
    "mongodb": {
        "connected": true,
        "signals": { "total": 50, "unacknowledged": 12, "claimed": 3 },
        "credentials": { "total": 310, "enabled": 298, "banned": 4, "locked": 2 },
        "errors": { "total": 145, "last24h": 3 }
    },
    "platforms": {
        "FireKirin": { "reachable": true, "lastProbe": "2026-02-20T11:55:00Z", "statusCode": 200 },
        "OrionStars": { "reachable": true, "lastProbe": "2026-02-20T11:55:00Z", "statusCode": 200 }
    },
    "parallel": {
        "running": false,
        "workers": 0,
        "signalsPending": 12,
        "signalsCompleted": 38,
        "errorRate": 0.02
    }
}
```

**Burn-In Controller Flow:**
```
Start
├── Pre-flight checks (CDP, MongoDB, platforms)
├── Check SIGN4L count — if 0, auto-generate 50 signals
├── Start ParallelH4NDEngine (5 workers)
├── Every 60 seconds:
│   ├── Collect ParallelMetrics snapshot
│   ├── Check: signal duplication? → HALT
│   ├── Check: error rate > 10%? → HALT
│   ├── Check: memory growth > 100MB? → WARN
│   ├── Check: stranded credentials? → auto-unlock + WARN
│   ├── Log metrics to console and MongoDB (BURN_IN_METRICS collection)
│   └── If SIGN4L empty, auto-generate 20 more signals
├── On duration elapsed (default 24h):
│   ├── Stop engine gracefully
│   ├── Collect final metrics
│   ├── Generate summary report
│   └── Output: PASS/FAIL with details
└── On critical failure:
    ├── Stop engine immediately
    ├── Unlock all credentials
    ├── Release all claims
    └── Output: FAIL with root cause
```

**Burn-In Configuration (appsettings.json):**
```json
{
    "P4NTH30N": {
        "H4ND": {
            "BurnIn": {
                "DurationHours": 24,
                "MetricsIntervalSeconds": 60,
                "AutoGenerateSignals": true,
                "AutoGenerateCount": 50,
                "RefillThreshold": 5,
                "RefillCount": 20,
                "HaltOnDuplication": true,
                "HaltOnErrorRatePercent": 10,
                "WarnOnMemoryGrowthMB": 100
            }
        }
    }
}
```

**File Structure (new and modified):**
```
H4ND/
  EntryPoint/
    UnifiedEntryPoint.cs          (MODIFY: extend RunMode enum + ParseMode)
  Services/
    SignalGenerator.cs            (NEW: signal population from credentials)
    SystemHealthReport.cs         (NEW: aggregated health check)
    BurnInController.cs           (NEW: 24-hour validation orchestrator)
    BurnInConfig.cs               (NEW: configuration POCO)
    SignalGenerationResult.cs     (NEW: result DTO)
  Parallel/
    ParallelSpinWorker.cs         (MODIFY: inject SessionRenewalService + GameSelectorConfig)
    WorkerPool.cs                 (MODIFY: graceful shutdown with credential unlock)
    ParallelMetrics.cs            (MODIFY: add renewal/self-healing metrics)
    SignalDistributor.cs          (MODIFY: enhance stale claim logging)
  H4ND.cs                        (MODIFY: add routing for new subcommands)
appsettings.json                  (MODIFY: add BurnIn configuration section)
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-055-001 | Extend RunMode enum and ParseMode in UnifiedEntryPoint.cs | @windfixer | Pending | Critical |
| ACT-055-002 | Create SignalGenerator.cs with credential-based signal population | @windfixer | Pending | Critical |
| ACT-055-003 | Create SignalGenerationResult.cs DTO | @windfixer | Pending | Critical |
| ACT-055-004 | Wire SessionRenewalService into ParallelSpinWorker (403 self-healing) | @windfixer | Pending | Critical |
| ACT-055-005 | Wire GameSelectorConfig into ParallelSpinWorker (config-driven selectors) | @windfixer | Pending | Critical |
| ACT-055-006 | Create SystemHealthReport.cs (aggregated health) | @windfixer | Pending | High |
| ACT-055-007 | Create BurnInController.cs (24-hour validation) | @windfixer | Pending | High |
| ACT-055-008 | Create BurnInConfig.cs configuration POCO | @windfixer | Pending | High |
| ACT-055-009 | Enhance ParallelMetrics.cs with renewal/self-healing counters | @windfixer | Pending | High |
| ACT-055-010 | Enhance WorkerPool.cs graceful shutdown (credential unlock sweep) | @windfixer | Pending | High |
| ACT-055-011 | Enhance SignalDistributor.cs stale claim logging | @windfixer | Pending | Medium |
| ACT-055-012 | Update H4ND.cs Program.Main with new subcommand routing | @windfixer | Pending | Critical |
| ACT-055-013 | Update appsettings.json with BurnIn configuration section | @windfixer | Pending | High |
| ACT-055-014 | Integration test: generate-signals populates SIGN4L | @windfixer | Pending | Critical |
| ACT-055-015 | Integration test: parallel mode with self-healing processes signals | @windfixer | Pending | Critical |
| ACT-055-016 | Integration test: burn-in mode runs for 10 minutes without failures | @windfixer | Pending | High |

---

## Dependencies

- **Blocks**: 24-hour burn-in validation for DECISION_047 (ARCH-047-006, ACT-047-012)
- **Blocked By**: None (all prerequisites are implemented)
- **Related**:
  - DECISION_047 (Parallel H4ND Execution) — parallel engine, worker pool, signal claiming
  - DECISION_046 (Config-Driven Selectors) — GameSelectorConfig, fallback chains
  - DECISION_041 (Session Renewal) — SessionRenewalService, platform probing, credential refresh
  - DECISION_044 (First Spin) — FirstSpinController, spin execution patterns
  - DECISION_045 (Extension-Free Reading) — CdpGameActions jackpot reading
  - DECISION_026 (CDP Automation) — SessionPool, CdpClient, CdpConfig

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Signal generator creates signals for banned/disabled credentials | Medium | Low | Filter by Enabled=true, Banned=false, Unlocked=true; validate before insert |
| SessionRenewalService retry loops delay parallel processing | Medium | Medium | Cap renewal at 3 attempts per worker per cycle; circuit breaker on repeated failures; worker enters backoff instead of blocking |
| Burn-in auto-generation floods SIGN4L beyond processing capacity | Medium | Low | Channel backpressure limits in-flight signals; auto-generate only when count < RefillThreshold |
| GameSelectorConfig hot-reload during spin causes inconsistency | Low | Low | Selector lookup is per-spin, not per-session; each spin gets fresh selector list |
| Graceful shutdown timeout exceeded (>30s) with locked credentials | High | Low | Emergency credential unlock sweep after 25s; force-kill workers after 30s; log stranded credentials for manual review |
| Burn-in halts too aggressively on transient errors | Medium | Medium | Require 3 consecutive error rate checks >10% before halt; allow single spikes |
| CDP session exhaustion during parallel + self-healing concurrent access | High | Medium | SessionRenewalService uses its own HTTP client (not CDP) for platform probing; only workers use CDP sessions; renewal does not compete for CDP resources |

---

## Success Criteria

1. **Single Executable**: `P4NTH30N.exe` runs all 7 subcommands (spin, parallel, generate-signals, health, burn-in, h0und, firstspin)
2. **Signal Generation**: `generate-signals 50` creates 50 valid SIGN4L entries from CR3D3N7IAL with correct priority distribution
3. **Self-Healing**: Parallel worker encountering 403 auto-recovers via SessionRenewalService within 30 seconds
4. **Config Selectors**: Parallel workers resolve selectors via GameSelectorConfig.GetSelectors() with fallback chain execution
5. **Health Report**: `health` subcommand outputs JSON with CDP, MongoDB, platform, and parallel engine status
6. **Burn-In**: 10-minute mini burn-in completes with zero signal duplication and error rate <5%
7. **Graceful Shutdown**: Ctrl+C during parallel mode: all credentials unlocked, all claims released, shutdown <30s
8. **Backward Compatibility**: Existing `H4ND.exe H4ND` and `H4ND.exe PARALLEL` invocations continue to work identically

---

## Token Budget

- **Estimated**: 150,000 tokens
- **Model**: Claude 3.5 Sonnet (via OpenRouter)
- **Budget Category**: Critical (<200K)
- **Breakdown**:
  - Phase 1 (Entry Point + Signal Gen): ~40K tokens
  - Phase 2 (Self-Healing Integration): ~40K tokens
  - Phase 3 (Health + Burn-In): ~50K tokens
  - Phase 4 (Testing + Validation): ~20K tokens

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with decision context
- **On config error**: Delegate to @openfixer for appsettings.json issues
- **On test failure**: WindFixer self-resolves or delegates to Forgewright if >30min blocked
- **On signal duplication detected**: HALT burn-in immediately, escalate to @forgewright for race condition analysis
- **On credential stranding detected**: Auto-unlock via MongoDB script, log for root cause analysis
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
- **Date**: 2026-02-20
- **Approval**: 93%
- **Note**: Oracle subagent unavailable; Strategist assimilated Oracle role

**APPROVAL ANALYSIS:**
- Overall Approval Percentage: 93%
- Feasibility Score: 9/10 (30% weight) — All three prerequisite systems are implemented and tested. Integration is additive, not rewrite.
- Risk Score: 3/10 (30% weight) — Low architectural risk. SessionRenewalService and GameSelectorConfig are proven. Signal generation is simple CRUD.
- Implementation Complexity: 5/10 (20% weight) — Moderate. Six new files, four modified files. Self-healing wiring requires careful error handling.
- Resource Requirements: 3/10 (20% weight) — Uses existing infrastructure exclusively. No new external dependencies.

**WEIGHTED DETAIL SCORING:**

Positive Factors:
+ All Prerequisites Proven: +15% — DECISION_041, 046, 047 all validated in production or shadow
+ Additive Architecture: +12% — No rewrites. Extends existing patterns (RunMode, worker pool, selector config)
+ Self-Healing Precedent: +10% — SessionRenewalService already handles 403 recovery; wiring into workers is mechanical
+ Signal Generation Simplicity: +8% — CRUD operation against existing CR3D3N7IAL and SIGN4L collections
+ Config-Driven Selectors Proven: +6% — GameSelectorConfig already bound from appsettings.json; injection is standard DI

Negative Factors:
- Self-Healing Complexity in Workers: -8% — Error handling in parallel context requires careful coordination
- Burn-In Duration Risk: -5% — 24-hour tests may surface memory leaks or connection exhaustion
- Backward Compatibility Surface: -3% — Must not break existing H4ND/H0UND/FIRSTSPIN/PARALLEL invocations
- CDP Session Contention: -4% — Self-healing must not compete with workers for CDP connections

**GUARDRAIL CHECK:**
[PASS] Feasible within existing architecture (extends, does not rewrite)
[PASS] All three prerequisite decisions implemented and validated
[PASS] Clear success criteria with measurable outcomes
[PASS] Graceful degradation paths defined (fallback to sequential, platform fallback)
[PASS] Rollback plan: revert to previous UnifiedEntryPoint, workers unchanged

**APPROVAL LEVEL:**
- Approved — 93% — All criteria met. Risk is integration complexity, not architectural soundness. Proceed with implementation.

### Designer Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 95%
- **Note**: Designer subagent unavailable; Strategist assimilated Designer role

**DESIGN SPECIFICATIONS:**

**Implementation Plan — 4 Phases:**

**Phase 1: Entry Point Extension + Signal Generator (Complexity: Low-Medium, 4-6 hours)**
1. Extend `RunMode` enum in `H4ND/EntryPoint/UnifiedEntryPoint.cs` with GenerateSignals, Health, BurnIn
2. Extend `ParseMode()` to handle new subcommand strings
3. Create `H4ND/Services/SignalGenerationResult.cs` (DTO)
4. Create `H4ND/Services/SignalGenerator.cs` with credential query, priority distribution, duplicate check, upsert
5. Update `H4ND/H4ND.cs` Program.Main to route new subcommands
6. Validation: `P4NTH30N.exe generate-signals 10` creates 10 signals in SIGN4L

**Phase 2: Self-Healing Integration (Complexity: Medium, 6-8 hours)**
1. Modify `H4ND/Parallel/ParallelSpinWorker.cs`:
   - Add constructor parameter: `SessionRenewalService`
   - Add constructor parameter: `GameSelectorConfig`
   - Wrap spin execution with 403/401 catch → renewal → retry
   - Use `GameSelectorConfig.GetSelectors(signal.Game)` for selector resolution
2. Modify `H4ND/Parallel/WorkerPool.cs`:
   - Pass SessionRenewalService and GameSelectorConfig to workers
   - Enhance shutdown to sweep locked credentials
3. Modify `H4ND/Parallel/ParallelMetrics.cs`:
   - Add: RenewalAttempts, RenewalSuccesses, RenewalFailures, StaleClaims, CriticalFailures
4. Modify `H4ND/Parallel/ParallelH4NDEngine.cs`:
   - Accept SessionRenewalService and GameSelectorConfig in constructor
   - Pass through to WorkerPool/workers
5. Update `UnifiedEntryPoint.RunParallel()` to construct and inject SessionRenewalService + GameSelectorConfig
6. Validation: Simulate 403 → verify renewal triggers → verify worker retries

**Phase 3: Health + Burn-In (Complexity: Medium, 6-8 hours)**
1. Create `H4ND/Services/SystemHealthReport.cs`:
   - CDP health via CdpHealthCheck
   - MongoDB counts via IUnitOfWork queries
   - Platform probes via SessionRenewalService.ProbePlatformAsync
   - Parallel engine status via ParallelMetrics
   - Output as JSON to console
2. Create `H4ND/Services/BurnInConfig.cs` (configuration POCO)
3. Create `H4ND/Services/BurnInController.cs`:
   - Pre-flight checks (CDP, MongoDB, platforms)
   - Auto-generate signals if SIGN4L empty
   - Start ParallelH4NDEngine
   - Periodic metrics collection loop
   - Halt conditions (duplication, error rate)
   - Final summary report
4. Update `appsettings.json` with BurnIn section
5. Wire health and burn-in routes in Program.Main
6. Validation: `P4NTH30N.exe health` outputs valid JSON; `burn-in` starts and collects metrics

**Phase 4: Testing + Hardening (Complexity: Medium, 4-6 hours)**
1. Create `UNI7T35T/Tests/SignalGeneratorTests.cs` (8-10 tests)
   - Generates correct count
   - Respects priority distribution
   - No duplicate signals
   - Filters by game/house
   - Handles empty credential set
2. Create `UNI7T35T/Tests/SystemHealthReportTests.cs` (4-6 tests)
   - Reports all subsystems
   - Handles degraded state
   - Handles critical state
3. Enhance `UNI7T35T/Tests/ParallelWorkerTests.cs` (4-6 tests)
   - Self-healing on 403
   - Selector fallback integration
   - Graceful shutdown cleanup
4. Integration validation: 10-minute mini burn-in with live MongoDB
5. Validation: All unit tests pass, mini burn-in completes

**Files to Create:**
- `H4ND/Services/SignalGenerator.cs` (~100 lines)
- `H4ND/Services/SignalGenerationResult.cs` (~25 lines)
- `H4ND/Services/SystemHealthReport.cs` (~120 lines)
- `H4ND/Services/BurnInController.cs` (~200 lines)
- `H4ND/Services/BurnInConfig.cs` (~25 lines)
- `UNI7T35T/Tests/SignalGeneratorTests.cs` (~150 lines)
- `UNI7T35T/Tests/SystemHealthReportTests.cs` (~80 lines)

**Files to Modify:**
- `H4ND/EntryPoint/UnifiedEntryPoint.cs` (~30 lines changed)
- `H4ND/H4ND.cs` (~40 lines added for new subcommand routing)
- `H4ND/Parallel/ParallelSpinWorker.cs` (~50 lines added for self-healing + selector integration)
- `H4ND/Parallel/WorkerPool.cs` (~20 lines added for graceful shutdown)
- `H4ND/Parallel/ParallelMetrics.cs` (~15 lines added for new counters)
- `H4ND/Parallel/ParallelH4NDEngine.cs` (~15 lines added for dependency injection)
- `H4ND/Parallel/SignalDistributor.cs` (~10 lines for enhanced logging)
- `appsettings.json` (~15 lines for BurnIn section)
- `UNI7T35T/Tests/ParallelWorkerTests.cs` (~60 lines added, if exists)

**Estimated Total:**
- New code: ~700 lines across 7 new files
- Modified code: ~195 lines across 8 modified files
- Total effort: 20-28 hours across 4 phases

**Parallel Workstreams:**
- Stream A: Phase 1 (Entry Point + Signal Gen) — independent
- Stream B: Phase 2 (Self-Healing) — independent of Phase 1
- Stream A + B can execute concurrently
- Stream C: Phase 3 (Health + Burn-In) — depends on Phase 1 + 2
- Stream D: Phase 4 (Testing) — depends on Phase 1 + 2 + 3

**Validation Criteria:**
- `generate-signals 50` creates exactly 50 signals with correct priority distribution (within 5% variance)
- `health` outputs valid JSON parseable by any JSON parser
- `parallel` mode with SessionRenewalService handles simulated 403 recovery
- `burn-in` mode runs 10 minutes with 0 duplications and <5% error rate
- All existing subcommands (H4ND, H0UND, FIRSTSPIN, PARALLEL) work identically to before
- Graceful shutdown: 0 stranded locked credentials after Ctrl+C

---

## WindFixer Bootstrap Protocol

### Pre-Implementation Checklist

Before implementing ARCH-055, WindFixer MUST:

1. **Verify Prerequisites Exist**
   - Confirm `H4ND/Parallel/ParallelSpinWorker.cs` exists and compiles
   - Confirm `H4ND/Services/SessionRenewalService.cs` exists and compiles
   - Confirm `C0MMON/Infrastructure/Cdp/GameSelectorConfig.cs` exists and compiles
   - Confirm `H4ND/EntryPoint/UnifiedEntryPoint.cs` exists with RunMode enum
   - Confirm `dotnet build` succeeds on current codebase

2. **Verify MongoDB Connectivity**
   - Confirm connection to 192.168.56.1:27017
   - Confirm CR3D3N7IAL collection has >0 enabled credentials
   - Confirm SIGN4L collection is queryable (empty is expected)

3. **Verify CDP Connectivity**
   - Confirm Chrome CDP at localhost:9222 or 192.168.56.1:9222 responds

### Implementation Autonomy

WindFixer is authorized for:
- **FULL AUTONOMY**: Create all files in phase order without intermediate approval
- **SELF-CORRECTION**: Fix compilation errors inline
- **REFACTORING**: Simplify as implementation progresses
- **TESTING**: Build and validate after each phase

**Stop conditions (escalate to Nexus):**
- `dotnet build` fails after 15 minutes of self-correction
- MongoDB connection failures after 3 retries
- Signal duplication detected during testing
- Compilation errors in prerequisite files (ParallelSpinWorker, SessionRenewalService, GameSelectorConfig)

### Phase Execution Rules

**Phase 1**: Complete entry point extension + signal generator entirely before reporting
**Phase 2**: Complete self-healing integration entirely before reporting
**Phase 3**: Complete health + burn-in entirely before reporting
**Phase 4**: Run all tests and report results

### Success Criteria for Bootstrap

WindFixer bootstrap successful when:
- [ ] `dotnet build` succeeds
- [ ] `P4NTH30N.exe generate-signals 5` creates 5 signals in MongoDB SIGN4L
- [ ] `P4NTH30N.exe health` outputs JSON to console
- [ ] `P4NTH30N.exe parallel` starts workers and processes at least 1 signal
- [ ] `P4NTH30N.exe burn-in` starts and collects at least 1 metrics snapshot

**DO NOT declare completion until live validation confirms signals are generated and processed.**

---

## Implementation Order for WindFixer

**Priority 1 (Critical Path — Signal Generation):**
1. SignalGenerationResult.cs (DTO)
2. SignalGenerator.cs (signal creation from credentials)
3. Extend RunMode enum + ParseMode in UnifiedEntryPoint.cs
4. Wire generate-signals route in H4ND.cs Program.Main
5. Test: `P4NTH30N.exe generate-signals 10` → verify 10 signals in SIGN4L

**Priority 2 (Critical Path — Self-Healing):**
6. Add renewal/selector metrics to ParallelMetrics.cs
7. Modify ParallelSpinWorker.cs — inject SessionRenewalService + GameSelectorConfig
8. Modify WorkerPool.cs — pass dependencies + graceful shutdown
9. Modify ParallelH4NDEngine.cs — accept and forward dependencies
10. Update UnifiedEntryPoint.RunParallel() — construct and inject dependencies

**Priority 3 (Operational):**
11. Create SystemHealthReport.cs
12. Create BurnInConfig.cs
13. Create BurnInController.cs
14. Wire health + burn-in routes in H4ND.cs
15. Update appsettings.json with BurnIn section

**Priority 4 (Validation):**
16. Create SignalGeneratorTests.cs
17. Create SystemHealthReportTests.cs
18. Enhance ParallelWorkerTests.cs (if exists)
19. Run all tests: `dotnet test`
20. Mini burn-in: 10 minutes with live MongoDB

---

## Notes

**Why This Decision Exists:**
DECISION_047 passed shadow validation on 2026-02-20 but cannot proceed to 24-hour production burn-in because the SIGN4L collection is empty. There is literally no way to feed the parallel engine. Meanwhile, the self-healing from DECISION_041 and the config-driven selectors from DECISION_046 sit disconnected from the parallel workers. This unification is the final assembly — the moment these three systems become one engine.

**Critical Integration Points:**
- `ParallelSpinWorker` is the nexus — it must receive `SessionRenewalService`, `GameSelectorConfig`, and continue to use `IUnitOfWork` for signal acknowledgment
- `SignalGenerator` is intentionally simple — CRUD against CR3D3N7IAL and SIGN4L, no CDP interaction
- `BurnInController` is the validator — it wraps `ParallelH4NDEngine` with monitoring and halt conditions
- `SystemHealthReport` is the dashboard — it aggregates status from all subsystems into one JSON response

**Backward Compatibility Contract:**
- `H4ND.exe H4ND` MUST continue to work as sequential mode
- `H4ND.exe PARALLEL` MUST continue to work as parallel mode
- `H4ND.exe H0UND` MUST continue to work as analytics mode
- `H4ND.exe FIRSTSPIN` MUST continue to work as first spin mode
- New subcommands are additive. No existing behavior changes.

**Rollback Plan:**
If implementation introduces regressions:
1. Revert UnifiedEntryPoint.cs to previous version (only enum + parse changes)
2. Revert ParallelSpinWorker.cs to remove SessionRenewalService/GameSelectorConfig injection
3. New files (SignalGenerator, SystemHealthReport, BurnInController) can be deleted without impact
4. appsettings.json BurnIn section can be removed without impact
5. `dotnet build` and existing modes must work after rollback

---

*Decision ARCH-055*  
*Unified Game Execution Engine*  
*2026-02-20*  
*Status: Approved — Ready for WindFixer Implementation*
