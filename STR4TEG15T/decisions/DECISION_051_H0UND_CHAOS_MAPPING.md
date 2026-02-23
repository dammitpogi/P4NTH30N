# DECISION_051: H0UND Entity Chaos Mapping & Debug Telemetry

**Status**: DRAFT  
**Created**: 2026-02-23  
**Authority**: STRATEGIST_DIRECTIVE  
**Owner**: @forgewright (implementation)  
**Previous**: DECISION_050 (Lazarus Protocol)

---

## 1. Purpose

Map five critical entities within H0UND (the analytics/polling engine) to identify **chaos points** — locations where system instability, data corruption, or cascading failures are most likely. Establish **sanity test insertion points** at specific line numbers and create an automated debug telemetry system that logs all H4ND automation workflows to MongoDB.

---

## 2. Entity Workflow Analysis

### Entity 1: ServiceOrchestrator (Service Lifecycle Management)

**Entry Point**: `H0UND/Services/Orchestration/ServiceOrchestrator.cs:22` (constructor)

**Call Chain**:
```
ServiceOrchestrator..ctor() [line 22]
  → StartAllAsync() [line 43]
    → OnHealthCheckTick() [line 116] (timer callback every 30s)
      → RestartServiceAsync() [line 173]
```

**Chaos Points**:
| Line | Risk | Sanity Test |
|------|------|-------------|
| 116 | `async void OnHealthCheckTick` — fire-and-forget async void can crash process if unhandled exception | Insert: `try/catch` around entire method body with process-level logging |
| 144 | `_restartInProgress.TryAdd` race condition — multiple threads can trigger simultaneous restarts | Insert: `Interlocked.CompareExchange` pattern for atomic flag check |
| 181 | Exponential backoff calculation `2 * (1 << (cappedFailures - 1))` — potential overflow if failures > 31 | Insert: `Math.Min` cap on shift operations |
| 217 | `_restartInProgress.TryRemove` in finally — if restart fails permanently, flag remains forever | Insert: TTL/expiration on restart locks |

**Dependencies**: ConcurrentDictionary, Timer, CancellationTokenSource

---

### Entity 2: PollingWorker (Balance Retrieval)

**Entry Point**: `H0UND/Application/Polling/PollingWorker.cs:12` (constructor)

**Call Chain**:
```
PollingWorker.GetBalancesWithRetry() [line 17]
  → ExecuteQuery() [line 19] (local function)
    → QueryBalances() [line 75]
      → BalanceProviderFactory.GetProvider() → [FireKirin\|OrionStars]BalanceProvider.GetBalances()
```

**Chaos Points**:
| Line | Risk | Sanity Test |
|------|------|-------------|
| 22 | `while (true)` infinite retry loop — no circuit breaker | Insert: `maxAttempts` counter with circuit breaker integration |
| 28 | `InvalidOperationException` special handling — uses string.Contains which is locale-sensitive | Insert: Exact exception type check or error code matching |
| 52-70 | Grand=0 retry loop — hardcoded 8 attempts with 250ms sleep, no exponential backoff | Insert: Configurable retry policy with jitter |
| 75 | `Random` instance created per call — not thread-safe, poor entropy | Insert: `Random.Shared` or `ThreadLocal<Random>` |
| 84 | Dynamic casting of `dynamic balances` — no compile-time safety, runtime exceptions likely | Insert: Strongly-typed DTOs with validation |

**Dependencies**: BalanceProviderFactory, FireKirin/OrionStars providers, Thread.Sleep

---

### Entity 3: Balance Providers (Data Validation)

**Entry Point**: `H0UND/Infrastructure/Polling/OrionStarsBalanceProvider.cs:9`

**Call Chain**:
```
OrionStarsBalanceProvider.GetBalances() [line 9]
  → ValidateBalances() [line 15]
```

**Chaos Points**:
| Line | Risk | Sanity Test |
|------|------|-------------|
| 11 | `dynamic` return from `OrionStars.QueryBalances()` — runtime binding failures | Insert: JSON schema validation before casting |
| 17-21 | Individual double casts without try/catch — single failure kills entire batch | Insert: Per-field validation with partial failure handling |
| 23-32 | NaN/Infinity/negative checks — validates but silently corrects to 0 (data loss) | Insert: Warning log when corrections applied |
| 26 | `Grand < 0` check passes 0 values — downstream code expects > 0 | Insert: Strict positive validation for jackpot values |

**Note**: FireKirinBalanceProvider has identical chaos points at same line numbers.

**Dependencies**: P4NTH30N.Services.OrionStars/FireKirin (WebSocket APIs)

---

### Entity 4: H0UND Main Loop (Credential Processing)

**Entry Point**: `H0UND/H0UND.cs:92` (Main method)

**Call Chain**:
```
Program.Main() [line 92]
  → Outer while(!s_exitRequested) [line 178]
    → Inner credential processing loop [line 187]
      → GetNext() → Lock() → GetBalancesWithRetry() → UpdateJackpots() → Unlock()
```

**Chaos Points**:
| Line | Risk | Sanity Test |
|------|------|-------------|
| 224 | `uow.Credentials.Lock(credential)` — distributed lock failure not checked | Insert: `Lock()` result validation with timeout |
| 229-235 | Circuit breaker execution with `.GetAwaiter().GetResult()` — blocks thread, potential deadlock | Insert: Async/await throughout or dedicated thread pool |
| 238-277 | Raw value validation block — duplicate logic across all balance fields | Insert: Loop-based validation with field metadata |
| 306-309 | Grand equality check with floating-point — `Equals()` unreliable for doubles | Insert: Epsilon comparison `Math.Abs(a - b) < 0.01` |
| 497 | `finally { Unlock() }` — catch-all exception suppression hides real errors | Insert: Log suppressed exceptions to ERR0R collection |

**Dependencies**: MongoUnitOfWork, CircuitBreaker, AnomalyDetector, SystemDegradationManager

---

### Entity 5: AnomalyDetector (Data Integrity)

**Entry Point**: `H0UND/Services/AnomalyDetector.cs` (instantiated at H0UND.cs:66)

**Call Chain**:
```
AnomalyDetector.Process() [called at H0UND.cs:300-303]
  → Update window statistics
    → Check z-score and compression ratio
      → Invoke onAnomaly callback [H0UND.cs:70-90]
```

**Chaos Points** (inferred from H0UND.cs instantiation):
| Line (H0UND.cs) | Risk | Sanity Test |
|-----------------|------|-------------|
| 70-90 | onAnomaly lambda captures `s_uow` — potential race if MongoDB operation fails | Insert: Try/catch with fallback to local log file |
| 78-88 | `uow.Errors.Insert()` inside try/catch with empty catch — silent data loss | Insert: At minimum, Console.WriteLine on failure |
| 79 | `ErrorLog.Create()` allocates new object — memory pressure under high anomaly rate | Insert: Object pooling for ErrorLog instances |

**Dependencies**: MongoUnitOfWork.Errors collection, Dashboard logging

---

## 3. Automation Workflow: Login → Reel Spin

Based on H4ND infrastructure analysis, the complete workflow is:

### Phase 1: Bootstrap & Health Check
**File**: `H4ND/Infrastructure/CdpHealthCheck.cs` (implied from AGENTS.md)

1. HTTP GET `/json/version` — verify Chrome CDP endpoint
2. WebSocket handshake validation
3. Round-trip latency test (`evaluate 1+1`)
4. Login flow simulation (optional)

### Phase 2: Login Sequence
**File**: `H4ND/Infrastructure/CdpGameActions.cs`

**OrionStars Path**:
```
LoginOrionStarsAsync() [line 347]
  → InjectCanvasInputInterceptorAsync() [line 352] — ARCH-081 MutationObserver
  → NavigateAsync() [line 354] — load http://web.orionstars.org/hot_play/orionstars/
  → GetCanvasBoundsAsync() [line 357] — resolve coordinate system
  → Click ACCOUNT → Click KEYBOARD_INPUT → TypeIntoCanvasAsync() [line 368]
  → Click KEYBOARD_CONFIRM → Click PASSWORD → Type password
  → Click LOGIN → Dismiss 3 notification dialogs [lines 396-405]
  → VerifyLoginSuccessAsync() [line 408] — validate via balance query
```

**FireKirin Path**:
```
LoginFireKirinAsync() [line 60]
  → TryWebSocketAuthAsync() [line 74] — bypass Canvas entirely via WebSocket
  → VerifyLoginSuccessAsync() [line 82]
  → Fallback to Canvas typing [line 89-117] (if WebSocket fails)
```

### Phase 3: Game Navigation (FireKirin only)
**File**: `H4ND/Infrastructure/CdpGameActions.cs:275`

```
NavigateToTargetGameAsync()
  → Close SHARE dialog
  → Click SLOT category
  → Page left 5 times (reset to page 1)
  → Page right once (to page 2)
  → Click Fortune Piggy game icon
```

### Phase 4: Spin Execution
**File**: `H4ND/Infrastructure/CdpGameActions.cs`

```
SpinOrionStarsAsync() [line 441] OR SpinFireKirinAsync() [line 252]
  → GetCanvasBoundsAsync() — get current canvas dimensions
  → TransformRelativeCoordinates() — convert Rx/Ry to absolute X/Y
  → LongPressAsync() [line 258] — hold SPIN button for 2000ms
  → Return success/failure
```

**Key Line Numbers for Sanity Tests in H4ND**:

| File | Line | Action Needed |
|------|------|---------------|
| CdpGameActions.cs | 354 | Verify navigation completed before proceeding |
| CdpGameActions.cs | 408 | Verify balance query > 0 after login |
| CdpGameActions.cs | 258 | Verify spin button press registered (check balance change) |
| CdpGameActions.cs | 475-484 | WebSocket connection timeout handling |
| CdpGameActions.cs | 697-699 | MutationObserver fallback if interceptor not armed |

### FireKirin Login Automation Event Logging Points

**Primary Location**: `H4ND/Infrastructure/CdpGameActions.cs`

| Line | Method | Event to Log |
|------|--------|--------------|
| 60 | `LoginFireKirinAsync` start | Session start, username, target URL |
| 68 | `InjectCanvasInputInterceptorAsync` | MutationObserver injection attempt |
| 70 | `NavigateAsync` | Navigation initiated to FireKirin URL |
| 74 | `TryWebSocketAuthAsync` | WebSocket auth attempt started |
| 77 | WebSocket success | WebSocket auth succeeded, bypassing Canvas |
| 82 | `VerifyLoginSuccessAsync` | Login verification check |
| 89 | Canvas fallback | WebSocket failed, falling back to Canvas typing |
| 95-97 | ACCOUNT field click | Coordinate transformation result, click executed |
| 99 | `TypeIntoCanvasAsync` | Username typing initiated |
| 103-105 | PASSWORD field click | Password field focused |
| 107 | `TypeIntoCanvasAsync` | Password typing initiated |
| 111-113 | LOGIN button click | Login submission |
| 117 | `VerifyLoginSuccessAsync` | Final login verification |
| 121 | Exception catch | Login failure with exception details |
| 126-156 | `ResolveFireKirinLoginTargets` | Coordinate resolution source (map vs fallback) |

**Secondary Location**: `H4ND/SmokeTest/Phases/LoginPhase.cs`

| Line | Event to Log |
|------|--------------|
| 35 | Login phase execution started |
| 45-55 | Credential validation failure |
| 58 | NavigationMap load attempt |
| 75 | NavigationMap Login phase execution |
| 79-97 | NavigationMap success/failure |
| 100 | Fallback to CdpGameActions |
| 103-106 | Platform-specific login dispatch |
| 110-119 | CdpGameActions success/failure |
| 129-139 | Exception handling |

**Navigation Map Configuration**:
- Source files: `H4ND/tools/recorder/step-config-firekirin.json`, `step-config-orionstars.json`
- Event: Log when map loaded successfully vs using hardcoded coordinates

---

## 4. Debug Telemetry System

### MongoDB Collection: `_debug`

**Document Schema**:
```json
{
  "Name": "H4ND Automation",
  "Events": [
    {
      "Time": "20260223T143022",
      "Log": "LoginOrionStarsAsync started for user: testuser"
    },
    {
      "Time": "20260223T143035", 
      "Log": "Login succeeded, balance: $125.50"
    },
    {
      "Time": "20260223T143040",
      "Log": "Spin executed, new balance: $123.25"
    }
  ]
}
```

### Implementation Requirements

**Collection**: `_debug` (top-level, not prefixed)

**Write Pattern**: 
- Insert new document per automation session
- Append to `Events` array throughout session
- TTL index recommended: expire after 7 days

**Insertion Points** (H4ND):
1. Start of `LoginOrionStarsAsync` / `LoginFireKirinAsync`
2. After successful login verification
3. Before and after spin execution
4. On any exception/catch block
5. Session cleanup/logout

**C# Integration** (add to `CdpGameActions.cs`):
```csharp
// At method entry
await DebugLogger.LogEventAsync($"LoginOrionStarsAsync started for user: {username}");

// At key milestones
await DebugLogger.LogEventAsync($"Canvas bounds resolved: {bounds.Width}x{bounds.Height}");

// On exception
await DebugLogger.LogEventAsync($"ERROR: {ex.Message}", LogLevel.Error);
```

---

## 5. H4ND Entity Mutation Chaos Points (Data Mangling Risks)

Traced from H4ND entrypoint through entity mutation/persistence — **highest risk for data corruption**.

### Entry Flow Architecture
```
H4ND/H4ND.cs:8 (Main)
  → RuntimeCompositionRoot.cs:19 (BuildRuntimeHost)
    → LegacyRuntimeHost.cs:53 (mode parse)
      → Sequential loop: LegacyRuntimeHost.cs:233
      → Parallel path: UnifiedEntryPoint.cs:257 → ParallelH4NDEngine.cs:64
```

### Signal Lifecycle Chaos

**File**: `H4ND/Services/LegacyRuntimeHost.cs`

| Line | Risk | Impact |
|------|------|--------|
| 262 | Signal acknowledged **before** login/spin succeeds | Signal marked consumed without outcome if later steps fail |
| 413 | Signal acknowledged **again** (duplicate) | Multiple lifecycle transitions, masks earlier failures |

**Sanity Test**: Transactional signal state — only acknowledge after full workflow completion with idempotency key.

### Credential Lock State Chaos

**File**: `H4ND/Services/LegacyRuntimeHost.cs`

| Line | Risk | Impact |
|------|------|--------|
| 291 | Locks credential on **login failure path** (instead of unlock) | Stale lock state persists in DB, blocks future processing |
| 578 | Unlocks (persists) **before** post-processing mutations at :580-581 | Intermediate persisted state vulnerable to race overwrites |

**Sanity Test**: Lock/unlock pairing verification with automatic deadlock detection.

### Value Coercion Chaos

**File**: `H4ND/Services/LegacyRuntimeHost.cs`

| Lines | Risk | Impact |
|-------|------|--------|
| 779, 783, 787, 791, 795 | Clamps invalid numeric values to 0 | Corruption becomes plausible but wrong business value |

**File**: `C0MMON/Entities/Credential.cs:45`

| Line | Risk | Impact |
|------|------|--------|
| 45 | Silently rejects invalid/negative balance, keeps prior value | Downstream persists stale data while assuming freshness |

**Sanity Test**: Reject-and-alert instead of coerce; validate at ingestion boundary.

### Repository Persistence Chaos

**File**: `C0MMON/Infrastructure/Persistence/Repositories.cs`

| Line | Risk | Impact |
|------|------|--------|
| 178 | Full-document `ReplaceOne` for credentials | Last-write-wins overwrites with mutable in-memory objects |
| 183, 190 | Lock/unlock mutate + immediate full upsert | Race/overwrite amplified under concurrency |
| 255 → 263 | Signal upsert is **check-then-write** (non-atomic) | Concurrent writers duplicate or stomp signal state |

**Sanity Test**: Atomic operations with optimistic concurrency (ETag/version field).

### Parallel Processing Chaos

**File**: `H4ND/Parallel/SignalDistributor.cs`

| Line | Risk | Impact |
|------|------|--------|
| 52 | Scans all signals, reclaims stale claims in-process | Race condition on claim ownership |
| 58 | Timing-based reclaim | Claim ownership flaps under load, work reordering |

**File**: `H4ND/Parallel/ParallelSpinWorker.cs`

| Lines | Risk | Impact |
|-------|------|--------|
| 167 (lock) → 245 (unlock) | Repository full-replace semantics | Worker-local stale objects overwrite fresher fields |

**Sanity Test**: Distributed locking with TTL; compare-and-swap updates.

---

## 6. Chaos Point Summary Table

### H0UND Entities
| Entity | File | Critical Lines | Risk Level |
|--------|------|----------------|------------|
| ServiceOrchestrator | ServiceOrchestrator.cs | 116, 144, 181, 217 | HIGH |
| PollingWorker | PollingWorker.cs | 22, 52, 75, 84 | HIGH |
| Balance Providers | *BalanceProvider.cs | 11, 17, 23 | MEDIUM |
| H0UND Main Loop | H0UND.cs | 224, 229, 306, 497 | CRITICAL |
| AnomalyDetector | H0UND.cs (instantiation) | 70-90 | MEDIUM |

### H4ND Entities (Data Mutation)
| Entity | File | Critical Lines | Risk Level |
|--------|------|----------------|------------|
| Signal Lifecycle | LegacyRuntimeHost.cs | 262, 413 | CRITICAL |
| Credential Lock State | LegacyRuntimeHost.cs | 291, 578 | CRITICAL |
| Value Coercion | LegacyRuntimeHost.cs | 779, 783, 787, 791, 795 | HIGH |
| Entity Validation | Credential.cs | 45 | HIGH |
| Repository Persistence | Repositories.cs | 178, 183, 190, 255-263 | CRITICAL |
| Signal Distribution | SignalDistributor.cs | 52, 58 | HIGH |
| Parallel Worker | ParallelSpinWorker.cs | 167, 245 | HIGH |

**Total Chaos Points Identified**: 30+ specific line locations

**Immediate Action Required**:
1. Add sanity tests at lines marked CRITICAL
2. Implement `_debug` collection logging
3. Add circuit breaker to PollingWorker infinite loop
4. Fix floating-point comparison at H0UND.cs:306

---

## 7. Bug-Fix Workflow

Per DECISION_050 standards:

1. **Classification**: Map to component (EIL/ADE/HDM/HEE/STL equivalent for H0UND)
2. **Delegation**: @forgewright for C# implementation fixes
3. **Testing**: Verify each fix against chaos point scenario
4. **Integration**: Update this decision's Consultation Log

---

## 8. Token Budget

| Task | Tokens | Model |
|------|--------|-------|
| Sanity test implementations (5 entities) | ~80K | Claude 3.5 Sonnet |
| Debug telemetry integration | ~40K | Claude 3.5 Sonnet |
| Testing & validation | ~30K | Claude 3.5 Sonnet |
| **Total** | **~150K** | — |

---

## 8. Sub-Decision Authority

| Agent | Scope | Authority |
|-------|-------|-----------|
| @forgewright | Implement sanity tests at identified lines | High — direct implementation |
| @windfixer | H0UND/H4ND C# modifications | High — P4NTH30N specialist |
| @oracle | Validate chaos point analysis | Medium — risk assessment |

---

## 9. Dependencies

- MongoDB `_debug` collection (requires TTL index setup)
- C# MongoDB driver (already in C0MMON)
- DebugLogger utility class (to be created)

---

## 10. Open Questions

1. Should we add a `SessionId` field to the `_debug` schema for correlation?
2. Do we need screenshots stored alongside debug logs?
3. What's the retention policy for _debug collection? (Proposed: 7 days)
4. Should we auto-escalate to Lazarus Protocol if chaos points trigger?

---

## 11. Changelog

| Date | Version | Changes |
|------|---------|---------|
| 2026-02-23 | 0.1 | Initial entity mapping and chaos point identification |

---

## Consultation Log

| Date | Consultant | Topic | Outcome |
|------|------------|-------|---------|
| 2026-02-23 | Strategist | Entity tracing, line number extraction | 5 entities mapped, 17 chaos points identified |

