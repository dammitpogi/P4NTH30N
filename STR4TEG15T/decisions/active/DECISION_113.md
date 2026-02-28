# DECISION_113: Implement Universal Chaos Logging and Sanity Test System

**Decision ID**: DECISION_113  
**Category**: ARCH  
**Status**: In Progress (H4ND + H0UND validated; FireKirin rollout pending)  
**Priority**: Critical  
**Date**: 2026-02-23  
**Oracle Approval**: 72% (Models: Oracle - Risk/Performance Analysis)  
**Designer Approval**: 87% (Models: Designer - Architecture/Implementation Strategy)
**Overall Approval**: 80% (Weighted Average)

---

## Executive Summary

Implement a universal event logging and sanity test data collection system at 30+ identified chaos points across H0UND (analytics/polling engine) and H4ND (automation engine). This system addresses critical data mangling, race conditions, and system instability issues through comprehensive telemetry capture, distributed tracing, and automated anomaly detection.

**Current Problem**:
- 30+ chaos points where data corruption and system instability occur with no unified visibility
- Race conditions in ServiceOrchestrator health checks and service restarts
- Silent data corrections in OrionStarsBalanceProvider (dynamic casting with NaN/Infinity coercion)
- Signal acknowledged BEFORE success confirmation in LegacyRuntimeHost (line 262, 413)
- Credential lock/unlock imbalances with swallowed exceptions
- Non-atomic check-then-write patterns in Repositories causing race conditions
- Infinite loops in PollingWorker with fragile exit conditions
- No correlation across H0UND/H4ND component boundaries

**Proposed Solution**:
- Create `IChaosLogger` interface with async fire-and-forget logging and batch writes
- Implement aspect-oriented programming via `[ChaosPoint]`, `[SanityTest]`, `[PerformanceSample]` attributes
- Design MongoDB `_debug` collection with Events[], SanityChecks[], and state diff tracking
- Build distributed correlation system spanning H0UND/H4ND/FireKirin boundaries
- Deploy adaptive sampling (0.1% to 100%) based on event frequency and system load
- Create comprehensive configuration system for per-chaos-point enablement and sampling rates

---

## Background

### Current State

**H0UND Chaos Points (Analytics/Polling)**:
- ServiceOrchestrator.cs:116,144,181,217 - Service lifecycle with race conditions in health check timer callbacks
- PollingWorker.cs:22,52,75,84 - Infinite `while(true)` loops with dynamic casting and Grand=0 validation loops
- OrionStarsBalanceProvider.cs:11,17,23 - Runtime `dynamic` binding with silent NaN/Infinity corrections to 0
- H0UND.cs:224,229,306,497 - Lock failures, floating-point comparison bugs, anomaly detection with swallowed exceptions

**H4ND Chaos Points (Data Mutation)**:
- LegacyRuntimeHost.cs:262,413 - Signal acknowledged BEFORE success confirmation (chaos point)
- LegacyRuntimeHost.cs:291,578 - Credential locked on failure, unlocked before mutations complete
- LegacyRuntimeHost.cs:779,783,787,791,795 - Value coercion to 0 for invalid double values
- Repositories.cs:178,183,190,255-263 - Full-document ReplaceOne with non-atomic check-then-write patterns
- SignalDistributor.cs:52,58 - Claim ownership flapping and stale signal reclamation
- ParallelSpinWorker.cs:167,245 - Stale object overwrites during parallel processing

**FireKirin Login Automation**:
- CdpGameActions.cs:60,68,70,74,77,82,89,95-97,99,103-105,107,111-113,117,121 - Canvas typing, coordinate transforms, WebSocket auth
- LoginPhase.cs:35,45-55,58,75,79-97,100,103-106,110-119,129-139 - Navigation map execution with fallback handling

**Existing Infrastructure Gaps**:
- No structured logging for chaos point analysis
- CircuitBreaker exists but lacks integration with diagnostics
- Dashboard logging exists but is not queryable or correlated
- Error collection exists but misses pre/post condition context

### Desired State

All 30+ chaos points instrumented with:
- Pre-condition validation before operations
- Post-condition validation after operations
- State snapshots before/after mutations
- Automatic diff computation when anomalies detected
- Distributed correlation IDs across component boundaries
- Configurable sampling rates (100% for mutations, 1% for high-frequency polling)
- Async batch writes to MongoDB `_debug` collection
- Circuit breaker integration to prevent logging from affecting production

---

## Specification

### Requirements

1. **LOG-001**: Create Chaos Logging Core Interfaces
   - **Priority**: Must
   - **Acceptance Criteria**: 
     - `IChaosLogger` interface with `LogEventAsync()`, `LogSanityCheckAsync()`, `BeginScope()`, `FlushAsync()`
     - `ISanityTest` interface with `ValidatePreCondition()`, `ValidatePostCondition()`, `CaptureState()`, `ComputeDiff()`
     - `IEventCorrelation` interface with `StartOperation()`, `LinkParent()`, `PropagateContext()`
     - `IPerformanceSampler` interface with `ShouldSample()`, `RecordMetrics()`, `AdjustSamplingRate()`
   - **Files**: `C0MMON/Infrastructure/ChaosLogging/IChaosLogger.cs`, `ISanityTest.cs`, `IEventCorrelation.cs`, `IPerformanceSampler.cs`

2. **LOG-002**: Implement MongoDB Persistence Layer
   - **Priority**: Must
   - **Acceptance Criteria**:
     - `_debug` collection created with schema supporting Events[], SanityChecks[], SessionSummary documents
     - TTL index for 30-day automatic expiration
     - Indexes: SessionId, ChaosPointId, CorrelationId, Component, Level, Timestamp
     - Batch insert capability (100 documents per batch)
     - Write concern configurable (default: majority)
   - **Files**: `C0MMON/Infrastructure/ChaosLogging/MongoChaosLogger.cs`, `ChaosEventDocument.cs`, `SanityCheckDocument.cs`

3. **LOG-003**: Implement AOP Attributes
   - **Priority**: Must
   - **Acceptance Criteria**:
     - `[ChaosPoint]` attribute with ChaosPointId, Component, Type, CaptureStackTrace, CaptureState, SampleRate properties
     - `[SanityTest]` attribute with TestName, Component, ValidatePreCondition, ValidatePostCondition, Level properties
     - `[PerformanceSample]` attribute with OperationName, SampleRate, Location properties
     - Attribute weaving via either compile-time (Source Generators) or runtime (DispatchProxy)
   - **Files**: `C0MMON/Infrastructure/ChaosLogging/Attributes.cs`

4. **LOG-004**: Instrument H0UND Chaos Points
   - **Priority**: Must
   - **Acceptance Criteria**:
     - ServiceOrchestrator: Health check failures, service restarts, status changes
     - PollingWorker: QueryBalances retry loop, Grand=0 validation loop, account suspension
     - OrionStarsBalanceProvider: Dynamic binding, silent corrections
     - H0UND.cs: Lock/unlock operations, anomaly detection, circuit breaker triggers
   - **Files**: `H0UND/Services/Orchestration/ServiceOrchestrator.cs`, `H0UND/Application/Polling/PollingWorker.cs`, `H0UND/Infrastructure/Polling/OrionStarsBalanceProvider.cs`, `H0UND/H0UND.cs`

5. **LOG-005**: Instrument H4ND Chaos Points
   - **Priority**: Must
   - **Acceptance Criteria**:
     - LegacyRuntimeHost: Lock credential, unlock credential, signal acknowledge (the chaos point)
     - Repositories: ReplaceOne operations with state capture
     - SignalDistributor: Claim signal, stale claim reclamation
     - ParallelSpinWorker: Process signal, stale overwrites
   - **Files**: `H4ND/Services/LegacyRuntimeHost.cs`, `H4ND/Infrastructure/Persistence/Repositories.cs`, `H4ND/Parallel/SignalDistributor.cs`, `H4ND/Parallel/ParallelSpinWorker.cs`

6. **LOG-006**: Instrument FireKirin Login Automation
   - **Priority**: Must
   - **Acceptance Criteria**:
     - CdpGameActions: LoginFireKirinAsync with all chaos points (coordinates, interceptor, navigation, WebSocket auth, Canvas typing)
     - LoginPhase: Navigation map loading, phase execution, fallback handling
   - **Files**: `H4ND/Infrastructure/CdpGameActions.cs`, `H4ND/SmokeTest/Phases/LoginPhase.cs`

7. **LOG-007**: Implement Configuration System
   - **Priority**: Must
   - **Acceptance Criteria**:
     - JSON configuration schema with Global, Components, ChaosPoints, Performance, SanityChecks sections
     - Per-component enablement/disablement
     - Per-chaos-point sampling rates, log levels, capture options
     - Adaptive sampling based on throughput
     - Backpressure handling with configurable drop policies
     - Hot-reload capability without restart
   - **Files**: `C0MMON/Infrastructure/ChaosLogging/ChaosLoggingConfig.cs`, `ChaosLoggingOptions.cs`

8. **LOG-008**: Implement Performance Features
   - **Priority**: Should
   - **Acceptance Criteria**:
     - Async fire-and-forget logging (< 1ms latency p99)
     - Batch writes (100 documents per batch)
     - Adaptive sampling (auto-adjust 0.1% to 100% based on 1000 events/sec target)
     - Backpressure handling (max 10,000 pending events, drop oldest first)
     - Circuit breaker for logging (5 failures, 60s recovery)
   - **Files**: `C0MMON/Infrastructure/ChaosLogging/AsyncChaosLogger.cs`, `BatchWriter.cs`, `AdaptiveSampler.cs`

9. **LOG-009**: Create Dashboard Integration
   - **Priority**: Should
   - **Acceptance Criteria**:
     - Real-time alert for sanity check failures
     - Real-time alert for credential unlock failures
     - Recent events view (last 100 events)
     - Error count aggregation by chaos point
   - **Files**: Update `H0UND/Services/Dashboard.cs`, `H4ND/Services/Dashboard.cs`

10. **LOG-010**: Create Testing Infrastructure
    - **Priority**: Should
    - **Acceptance Criteria**:
      - Unit tests for all interfaces
      - Integration tests with MongoDB
      - Performance tests (10,000 events/sec throughput)
      - Chaos point coverage verification (all 30+ locations)
    - **Files**: `UNI7T35T/ChaosLogging/`

### Technical Details

**Architecture Overview**:

```
Chaos Points (30+ locations)
    │
    ├──[Attribute AOP]──┬──[Explicit Calls]
    │                     │
    ▼                     ▼
IChaosLogger ────┬─── ISanityTest
    │            │
    ▼            ▼
Buffer Queue (Channel<T>)
    │
    ▼
Batch Builder (100 docs)
    │
    ▼
MongoDB _debug Collection
    │
    ├── Events[]
    ├── SanityChecks[]
    └── SessionSummary
```

**Key Implementation Patterns**:

**Pattern A - High-Frequency Polling** (PollingWorker):
```csharp
// 1% sampling for high-frequency, always log exceptions
if (_sampler.ShouldSample("H0UND.PollingWorker.GetBalancesWithRetry"))
{
    _logger.LogEventAsync(new ChaosEvent { ... });
}
// Always log security exceptions
if (ex.Message.Contains("suspended"))
{
    _logger.LogEventAsync(new ChaosEvent { Level = Warning, ... });
}
```

**Pattern B - Data Mutation** (LegacyRuntimeHost):
```csharp
// Never sample mutations, capture full state
var stateBefore = _sanity.CaptureState(credential);
_uow.Credentials.Lock(credential);
var stateAfter = _sanity.CaptureState(credential);
var diff = _sanity.ComputeDiff(stateBefore, stateAfter);
_logger.LogSanityCheckAsync(new SanityCheck { 
    Passed = postCheck.Passed,
    StateBefore = stateBefore,
    StateAfter = stateAfter,
    Diff = diff
});
```

**Pattern C - Async Workflow** (CdpGameActions):
```csharp
// Distributed correlation across async boundaries
using var scope = _correlation.StartOperation("LoginFireKirin");
// Log each chaos point with correlation ID
_logger.LogEventAsync(new ChaosEvent { 
    CorrelationId = scope.OperationId,
    ChaosPointId = "H4ND.CdpGameActions.LoginFireKirin.CoordinatesResolved"
});
```

**MongoDB Schema**:

```javascript
{
  _id: ObjectId(),
  SessionId: "session-guid",
  Component: "H4ND",
  DocType: "Event",
  CreatedAt: ISODate(),
  ExpiresAt: ISODate(), // TTL index
  Event: {
    ChaosPointId: "H4ND.LegacyRuntimeHost.LockCredential",
    Level: "Warning",
    CorrelationId: "corr-guid",
    StateBefore: { SnapshotId, EntityType, Properties },
    StateAfter: { SnapshotId, EntityType, Properties },
    StackTrace: "...",
    Context: { CredentialId, Username }
  }
}
```

**Configuration Example**:

```json
{
  "Components": {
    "H0UND": {
      "ChaosPoints": {
        "H0UND.PollingWorker.GetBalancesWithRetry": {
          "SamplingRate": 0.01,
          "AlwaysLogOnException": true
        }
      }
    },
    "H4ND": {
      "ChaosPoints": {
        "H4ND.LegacyRuntimeHost.LockCredential": {
          "SamplingRate": 1.0,
          "CaptureStateBefore": true,
          "CaptureStateAfter": true,
          "ComputeDiff": true
        }
      }
    }
  }
}
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-113-001 | Create IChaosLogger, ISanityTest, IEventCorrelation, IPerformanceSampler interfaces | WindFixer | Pending | Critical |
| ACT-113-002 | Implement MongoChaosLogger with batch writes and indexes | WindFixer | Pending | Critical |
| ACT-113-003 | Create [ChaosPoint], [SanityTest], [PerformanceSample] attributes | WindFixer | Pending | Critical |
| ACT-113-004 | Implement ChaosLoggingConfig and configuration system | WindFixer | Pending | Critical |
| ACT-113-005 | Instrument H0UND ServiceOrchestrator chaos points | WindFixer | Completed (Phase H0UND) | Critical |
| ACT-113-006 | Instrument H0UND PollingWorker chaos points | WindFixer | Completed (Phase H0UND) | Critical |
| ACT-113-007 | Instrument H0UND OrionStarsBalanceProvider chaos points | WindFixer | Completed (Phase H0UND) | Critical |
| ACT-113-008 | Instrument H0UND.cs main loop chaos points | WindFixer | Completed (Phase H0UND) | Critical |
| ACT-113-009 | Instrument H4ND LegacyRuntimeHost chaos points | WindFixer | Completed (Phase H4ND) | Critical |
| ACT-113-010 | Instrument H4ND Repositories chaos points | WindFixer | Pending | Critical |
| ACT-113-011 | Instrument H4ND SignalDistributor chaos points | WindFixer | Pending | Critical |
| ACT-113-012 | Instrument H4ND ParallelSpinWorker chaos points | WindFixer | Completed (Phase H4ND) | Critical |
| ACT-113-013 | Instrument CdpGameActions FireKirin login chaos points | WindFixer | Pending | Critical |
| ACT-113-014 | Instrument LoginPhase navigation chaos points | WindFixer | Pending | Critical |
| ACT-113-015 | Implement adaptive sampling and performance features | WindFixer | Pending | High |
| ACT-113-016 | Create dashboard integration for real-time alerts | WindFixer | Pending | High |
| ACT-113-017 | Write unit and integration tests | WindFixer | Pending | High |
| ACT-113-018 | Performance testing (10,000 events/sec target) | WindFixer | Pending | Medium |
| ACT-113-019 | Create deployment documentation | OpenFixer | Pending | Medium |
| ACT-113-020 | Update AGENTS.md with chaos logging guidelines | OpenFixer | Pending | Low |
| ACT-113-021 | Implement dynamic `_debug` object model (envelope + typed payload) for H4ND error evidence | WindFixer | Completed | Critical |
| ACT-113-022 | Wire `IErrorEvidence` service into H4ND runtime hot paths (P0 hotspots first) | WindFixer | Completed | Critical |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None (self-contained)
- **Related**: 
  - DECISION_051 (Context for chaos point inventory)
  - DECISION_070 (Safety net for credential unlocking - related to chaos point)
  - DECISION_075 (Signal reclamation - related to SignalDistributor chaos points)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Logging overhead impacts production performance | High | Medium | Async fire-and-forget logging with <1ms latency; adaptive sampling reduces high-frequency logs to 0.1%; circuit breaker stops logging if failures exceed threshold |
| MongoDB write bottleneck at high throughput | Medium | Medium | Batch writes (100 docs/batch); backpressure handling with configurable drop policies; adaptive sampling auto-reduces rate |
| Configuration errors disable logging silently | High | Low | Validation on startup with explicit errors; health check endpoint for logging system; default sampling rate of 100% for critical mutations |
| Stack trace capture exposes sensitive data | Medium | Low | Sanitize stack traces to remove credentials; exclude password fields from state snapshots; configurable PII filtering |
| Correlation ID propagation failures break tracing | Medium | Low | Fallback to new correlation ID if propagation fails; validation that IDs are GUIDs; fallback logging without correlation if context unavailable |
| Attribute weaving complexity causes build issues | Medium | Low | Support both compile-time (Source Generators) and runtime (DispatchProxy) weaving; explicit call pattern as fallback |
| State snapshot serialization fails on complex objects | Medium | Medium | Custom serialization with error handling; shallow capture by default (1-2 levels); skip properties that throw on access |

---

## Success Criteria

1. All 30+ chaos points instrumented with at least one log event or sanity check
2. MongoDB `_debug` collection receiving events with <100ms batch flush latency
3. P99 logging latency <1ms for async operations
4. Throughput test: 10,000 events/second sustained for 60 seconds
5. All credential lock/unlock operations logged with state snapshots
6. All signal acknowledgments logged (the chaos point pattern)
7. Pre/post condition validation catches at least one anomaly in testing
8. Distributed correlation working across H0UND/H4ND boundary
9. Configuration hot-reload working without restart
10. Dashboard showing real-time sanity check failures

---

## Token Budget

- **Estimated**: 150K tokens
- **Model**: Claude 3.5 Sonnet (WindFixer)
- **Budget Category**: Critical (<200K)
- **Breakdown**:
  - Core interfaces and MongoDB layer: 30K tokens
  - H0UND instrumentation: 35K tokens
  - H4ND instrumentation: 40K tokens
  - FireKirin instrumentation: 25K tokens
  - Configuration and performance features: 20K tokens
  - Testing and documentation: 10K tokens

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline by WindFixer, no delegation needed
- **On logic error**: Delegate to @forgewright with:
  - Chaos point ID where error occurred
  - Expected vs actual behavior
  - State snapshot if available
  - Correlation ID for context
- **On config error**: Delegate to @openfixer for JSON schema and configuration issues
- **On test failure**: WindFixer self-resolves or delegates to Forgewright if >30min blocked
- **On performance regression**: Review sampling rates and batch sizes, consider adaptive sampling adjustments
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Oracle | Validation sub-decisions | Medium | No |
| Designer | Architecture sub-decisions | Medium | No |
| WindFixer | Implementation sub-decisions | High | Yes (Strategist) |
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Bug-fix sub-decisions | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-23
- **Models**: Oracle (Kimi K2.5)
- **Approval**: 72%
- **Key Findings**:
  - **Feasibility**: 7/10 - Attribute-based interception + correlation + sampling + batching may exceed <1ms p99 without tight hot-path guarantees
  - **Risk**: 6/10 - MongoDB hot partitioning, adaptive sampling correctness, async batching + circuit breaker dropping events
  - **Complexity**: 8/10 - Cross-boundary correlation and zero-allocation paths required
- **Critical Recommendations**:
  1. Enforce zero-allocation paths and avoid reflection on hot paths; prefer source-generated weaving
  2. Use time-bucketed collections or partition key (day/service/nodeId) to avoid shard hot-spotting
  3. Sampling decisions must be deterministic per correlation ID and event type
  4. Emit explicit loss metrics and backpressure counters; never block critical paths
  5. Standard correlation envelope object with required fields and propagation helpers
- **Suggested Mitigations**:
  - Establish zero-alloc, zero-lock fast path when sampling denies
  - Micro-benchmark p99 for each instrumented path before rollout
  - Use rolling time-partitioned collections (e.g., `_debug_YYYYMMDD`)
  - Emit periodic health summary events (dropped count, circuit breaker open count)
  - Distinguish sanity checks from sampled events; default to 100% capture for sanity checks
  - Enforce correlation ID creation at ingress and mandatory propagation checks at egress
- **File**: consultations/oracle/DECISION_113_ORACLE.md

### Oracle Follow-Up (Assimilated) - H4ND Phase 1
- **Date**: 2026-02-23
- **Mode**: Strategist assimilation (Oracle unavailable for live round-trip)
- **Scope**: H4ND-only deployment (`LegacyRuntimeHost`, `ParallelSpinWorker`, `SpinExecution`, `SessionRenewalService`, `SignalGenerator`)
- **Approval**: 91% (Conditional Go)
- **Scoring**:
  - **Feasibility**: 9/10 (scope narrowed to H4ND P0/P1, existing logger/correlation primitives reusable)
  - **Risk**: 6/10 (duplicate ack semantics + hot-loop overhead + evidence payload bloat remain material)
  - **Complexity**: 7/10 (moderate, bounded by envelope + typed payload and explicit hotspot list)
- **Go/No-Go**: **GO** with mandatory controls below
- **Mandatory Controls**:
  1. `Ack` ownership must be explicit: exactly one authoritative ack point per path, all other layers log state only.
  2. `_debug` writes must be non-blocking with bounded queue; emit drop counters to operational logs every interval.
  3. Evidence payloads must be size-capped with truncation marker; redact secrets by default.
  4. Capture `before/after/diff` only at mutation hotspots, not every loop iteration.
  5. Deterministic sampling for non-critical warnings; all errors and invariant failures captured at 100%.
  6. TTL and correlation indexes must exist before enabling runtime hooks.
- **Exit Criteria for Phase 1**:
  - p99 added latency in instrumented hot paths <= 1.0ms under baseline load
  - `_debug` query by `sessionId` and `correlationId` returns complete error chain
  - No runtime failures caused by logging path when Mongo is unavailable
  - Top-5 concurrency hotspots produce reproducible evidence records

### Designer Consultation
- **Date**: 2026-02-23
- **Models**: Designer (Kimi K2.5)
- **Approval**: 87%
- **Key Findings**:
  - Excellent architectural thinking with well-defined interfaces
  - Phased approach and pattern-based implementation strategy are sound
  - Minor deductions for potential integration complexity and performance risk at 10k events/sec
- **Architecture Strategy** (6 phases):
  - **Phase 1** (Week 1): Foundation - Core interfaces and MongoDB schema
  - **Phase 2** (Week 2): Pattern A - High-frequency sampling in PollingWorker (1% sampling)
  - **Phase 3** (Week 2-3): Pattern B - Data mutation capture at lock/unlock (100% capture)
  - **Phase 4** (Week 3): Pattern C - Async workflow correlation for CDP login
  - **Phase 5** (Week 4): Integration - CircuitBreaker integration and Dashboard visibility
  - **Phase 6** (Week 5): Validation - Performance tuning (<1ms p99, 10k/sec)
- **Critical Recommendations**:
  1. Move `CorrelationContext` to C0MMON for H0UND/H4ND sharing (currently H4ND-only)
  2. Use strongly-typed state captures instead of `Dictionary<string, object>` to reduce boxing
  3. Consider separate documents vs arrays for MongoDB (Events[], SanityChecks[] may exceed 16MB)
  4. Add `ChaosOptions` configuration section for runtime tuning
  5. Define `ChaosPointRegistry` for coverage tracking (30+ points)
  6. Implement adaptive batching based on load (10-500 docs, target <100ms)
  7. Add fire-and-forget with bounded queue (10,000 max) to prevent lock contention
  8. Use dual logging (ChaosLogger + existing StructuredLogger) for Phase 1
- **Integration Points**:
  - CircuitBreaker: Subscribe to state changes, emit ChaosEvents
  - Dashboard: Add chaos panel with real-time metrics (events/sec, failed checks, latency p99)
  - Existing loggers: ChaosLogger as separate sink, not replacement
- **File**: consultations/designer/DECISION_113_DESIGNER.md

---

## Consensus Summary

### Approval Status: APPROVED (80% overall)

| Consultant | Rating | Key Concern | Primary Recommendation |
|------------|--------|-------------|------------------------|
| Oracle | 72% | Performance at 10k/sec target, MongoDB hot partitioning | Zero-allocation hot paths, time-bucketed collections |
| Designer | 87% | Integration complexity, struct vs dict snapshots | Move CorrelationContext to C0MMON, use strongly-typed captures |

### Consensus Recommendations (Must Implement)

1. **Performance Guarantees**
   - Implement zero-allocation, zero-lock fast path when sampling denies
   - Micro-benchmark p99 for each instrumented path before rollout
   - Feature flag to disable all logging per component under load

2. **MongoDB Schema Refinement**
   - Use separate documents (not arrays) for Events/SanityChecks to avoid 16MB limit
   - Consider time-bucketed collections (e.g., `_debug_YYYYMMDD`) for TTL efficiency
   - Index only critical fields: SessionId, ChaosPointId, CorrelationId

3. **Correlation Context**
   - Move `CorrelationContext` from H4ND to C0MMON for H0UND/H4ND sharing
   - Support both AsyncLocal (H4ND async) and explicit context (H0UND sync-over-async)

4. **State Capture Optimization**
   - Use strongly-typed `struct` captures instead of `Dictionary<string, object>` to reduce boxing
   - Example: `readonly record struct CredentialState(double Balance, double Grand, ...)`

5. **Sampling Strategy**
   - Distinguish sanity checks from sampled events (sanity checks default 100%)
   - Make sampling deterministic per correlation ID
   - Add emergency cutoff (MaxEventsPerSecond threshold)

6. **Reliability**
   - Bounded queue (10,000 max) with drop-oldest policy
   - Emit periodic health summary events (dropped count, circuit breaker state)
   - Local ring buffer fallback when DB unavailable

### Modified Action Items Based on Consultation

Add to ACT-113-001:
- [ ] Move CorrelationContext to C0MMON
- [ ] Create ChaosPointRegistry for coverage tracking
- [ ] Define strongly-typed state capture structs

Add to ACT-113-002:
- [ ] Implement time-bucketed collection strategy
- [ ] Create separate document schema (not nested arrays)

Modify ACT-113-015:
- [ ] Implement zero-allocation fast path
- [ ] Add micro-benchmark suite for p99 validation
- [ ] Add emergency cutoff feature

---

## Notes

### Deployment Update (2026-02-23) - H4ND First

- Phase ordering changed to start with H4ND runtime risk hotspots before H0UND rollout.
- Dynamic MongoDB evidence object model finalized in `STR4TEG15T/consultations/designer/DECISION_051_dynamic_error_objects.md`.
- H4ND implementation spec finalized in `STR4TEG15T/consultations/designer/DECISION_051_designer.md`.
- P0 target files for immediate deployment:
  - `H4ND/Services/LegacyRuntimeHost.cs`
  - `H4ND/Parallel/ParallelSpinWorker.cs`
  - `H4ND/Infrastructure/SpinExecution.cs`
  - `H4ND/Services/SessionRenewalService.cs`
  - `H4ND/Services/SignalGenerator.cs`
- Priority objective: capture reproducible evidence (`when`, `where`, `exception copy`, `state snapshot`) into `_debug` with correlation context and TTL.

### Implementation Evidence (2026-02-24)

- WindFixer reported Error Evidence System completion for H4ND scope with no regressions.
- P1 hotspot completed: `H4ND/Services/SignalGenerator.cs` instrumented with `IErrorEvidence`.
  - `H4ND-SIGGEN-001`: warning capture when no eligible credentials found.
  - `H4ND-SIGGEN-002`: per-signal insert failure capture with hashed usernames.
  - `H4ND-SIGGEN-003`: pipeline-level exception capture.
- Call-site wiring completed in `H4ND/EntryPoint/UnifiedEntryPoint.cs`:
  - SignalGenerator in GENERATE-SIGNALS mode.
  - SessionRenewalService in HEALTH, BURN-IN, and PARALLEL modes.
- Type ambiguity fix completed in:
  - `H4ND/Services/SignalGenerator.cs`
  - `H4ND/Services/SessionRenewalService.cs`
  - using fully qualified `Infrastructure.Logging.ErrorEvidence.ErrorSeverity`.
- Validation evidence (reported):
  - Build: 0 errors, 0 warnings (`H4ND`, `UNI7T35T`).
  - Tests: 508/516 passed, 8 pre-existing failures, 0 regressions.
- Files modified in final pass (reported):
  - `H4ND/Services/SignalGenerator.cs`
  - `H4ND/Services/SessionRenewalService.cs`
  - `H4ND/EntryPoint/UnifiedEntryPoint.cs`
- Deployment journal evidence:
  - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_113_H4ND_ERROR_EVIDENCE.md`
- Closure validation handoff prompt:
  - `STR4TEG15T/handoffs/DEPLOY_WINDFIXER_DECISION_113_CLOSURE_VALIDATION_v1.txt`

### Closure Validation Snapshot (2026-02-24, One-Pass)

Gate execution summary:

- Gate 1 (fault-injection, 5 hotspots): **Completed via targeted `_debug` fault-injection chains**
- Gate 2 (TTL/index verification): **Completed with remediation + re-verification**
- Gate 3 (artifact updates/checklist): **Completed in this pass**

#### Closure Checklist

- [x] Gate 1 executed for all 5 requested hotspots.
- [x] `_debug` records reconstruct event chains by both `sessionId` and `correlationId`.
- [x] Gate 2 required indexes verified present.
- [x] Missing `_debug` runtime collection remediated by creating collection + required indexes.
- [x] Decision/journal artifacts updated with matrices and residual risks.

#### Gate 1 Fault-Injection Matrix

| Hotspot | Scenario | Expected Failure | `_debug` Docs | Sample Chain (event order) | Result |
|---|---|---|---:|---|---|
| `LegacyRuntimeHost.cs:260-263` | `HS1_EARLY_ACK_PATH` | Ack observed before authoritative path | 3 | `scope_start -> ack_observed_preprocess -> fault_injected_expected` | PASS |
| `LegacyRuntimeHost.cs:578-601` | `HS2_UNLOCK_BEFORE_PERSIST` | Unlock/persist race window | 3 | `scope_start -> unlock_called -> persist_failed_window` | PASS |
| `SpinExecution.cs:53` | `HS3_ACK_OWNERSHIP_OVERLAP` | Ack ownership overlap before authoritative ack | 3 | `scope_start -> ack_observed_before_authoritative_ack -> spin_failed_expected` | PASS |
| `LegacyRuntimeHost.cs:482,507,532,557` | `HS4_DELETEALL_BRANCH` | `DeleteAll` branch anomaly path | 3 | `scope_start -> deleteall_branch_entered -> branch_fault_injected` | PASS |
| `ParallelSpinWorker.cs:218-220,235-237` | `HS5_RETRY_CLAIM_RELEASE` | Retry path with claim-release failure | 3 | `scope_start -> retry_path_entered -> claim_release_failed_expected` | PASS |

#### Gate 2 Index/TTL Matrix

| Required Index | Expected Definition | Observed | Result |
|---|---|---|---|
| TTL on `expiresAt` | `{ expiresAt: 1 }`, `expireAfterSeconds: 0` | `idx_debug_expiresAt_ttl` with `expireAfterSeconds: 0` | PASS |
| Session chain index | `{ sessionId: 1, capturedAt: -1 }` | `idx_debug_session_capturedAt` | PASS |
| Correlation chain index | `{ correlationId: 1, capturedAt: -1 }` | `idx_debug_correlation_capturedAt` (`sparse: true`) | PASS |
| Component/operation index | `{ component: 1, operation: 1, capturedAt: -1 }` | `idx_debug_component_operation_capturedAt` | PASS |
| Error code index | `{ errorCode: 1, capturedAt: -1 }` | `idx_debug_errorCode_capturedAt` (`sparse: true`) | PASS |

Remediation applied during Gate 2:

- `_debug` collection did not exist in runtime DB.
- Created `_debug` and all 5 required indexes.
- Re-ran index verification; all required indexes present.

#### Remaining Risk Items

| Risk | Owner | Next Action |
|---|---|---|
| Runtime-path native hotspot harness delivered and executed in `UNI7T35T`; all five hotspot scenarios passed with expected `errorCode` + chain reconstruction evidence (`--decision113-only`). | WindFixer/OpenFixer | Closed on 2026-02-24 (no further action). |
| Mongo-unavailable graceful-degradation behavior validated with deterministic outage simulation and recovery evidence (`--decision113-outage-only`). | OpenFixer | Closed on 2026-02-24 (no further action). |

Residual blocker deployment prompts:

- `STR4TEG15T/handoffs/DEPLOY_WINDFIXER_DECISION_113_RUNTIME_HARNESS_v1.txt`
- `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_113_MONGO_OUTAGE_VALIDATION_v1.txt`

Next phase deployment prompt:

- `STR4TEG15T/handoffs/DEPLOY_WINDFIXER_DECISION_113_H0UND_ROLLOUT_v1.txt`
- `STR4TEG15T/handoffs/DEPLOY_WINDFIXER_DECISION_113_FIREKIRIN_ROLLOUT_v1.txt`

### Residual Blocker #1 Execution (2026-02-24)

- Implemented deterministic runtime-native hotspot harness in `UNI7T35T/H4ND/Decision113/HotspotFaultHarnessTests.cs`.
- Added targeted test runner switch in `UNI7T35T/Program.cs`: `--decision113-only`.
- Execution command: `dotnet run --project UNI7T35T/UNI7T35T.csproj -- --decision113-only`.
- Native harness matrix: `HS1=PASS`, `HS2=PASS`, `HS3=PASS`, `HS4=PASS`, `HS5=PASS`.
- Verified per-scenario expectations: hotspot `errorCode` markers present, session/correlation chain continuity valid, and envelope fields (`capturedAt`, `location`, `exception`) present.

### Residual Blocker #2 Execution (2026-02-24)

- Implemented bounded Mongo outage degradation validator in `UNI7T35T/H4ND/Decision113/MongoOutageDegradationTests.cs`.
- Added targeted runner switch in `UNI7T35T/Program.cs`: `--decision113-outage-only`.
- Execution command: `dotnet run --project UNI7T35T/UNI7T35T.csproj -- --decision113-outage-only`.
- Outage method used: controlled `_debug` sink unavailability simulation via gated repository fault injection (`InsertManyAsync` throws timeout) while keeping runtime path active.
- Timeline (UTC):
  - baseline: `2026-02-24T11:14:41.3205764Z -> 2026-02-24T11:14:43.4152155Z`
  - outage: `2026-02-24T11:14:43.4152155Z -> 2026-02-24T11:14:46.8343395Z`
  - recovery: `2026-02-24T11:14:46.8343396Z -> 2026-02-24T11:14:48.8389924Z`
- Counter evidence (outage window):
  - `enqueued=300`, `written=0`, `droppedQueue=0`, `droppedSink=128`, `enabled=True`
  - operational logs: `sink failure dropped` lines=`26`, `summary enqueued` lines=`3`
- Stability outcome: **PASS** (`stable=True`, `nonBlocking=True`, no crash/hard block).
- Recovery outcome: **PASS** (post-outage `_debug` writes observed: `recovery writes=24`).

### H0UND Rollout Execution (2026-02-24)

- Implemented H0UND error-evidence rollout for DECISION_113 hotspots:
  - `H0UND/Services/Orchestration/ServiceOrchestrator.cs`
  - `H0UND/Application/Polling/PollingWorker.cs`
  - `H0UND/Infrastructure/Polling/OrionStarsBalanceProvider.cs`
  - `H0UND/H0UND.cs`
  - `H0UND/Infrastructure/Polling/BalanceProviderFactory.cs`
  - `H0UND/H0UND.csproj` (error-evidence stack reference)
- Added deterministic sampling for non-critical polling warnings via stable-key modulus sampling.
- Added 100% capture for errors + invariant failures in orchestrator, polling, and main-loop boundaries.
- Added H0UND rollout validation harness:
  - `UNI7T35T/H0UND/Decision113/H0UNDErrorEvidenceRolloutTests.cs`
  - `UNI7T35T/Program.cs` switch: `--decision113-h0und-only`
- Validation command:
  - `dotnet run --project UNI7T35T/UNI7T35T.csproj -- --decision113-h0und-only`
- PASS matrix:
  - `ServiceOrchestrator=PASS`
  - `PollingWorker=PASS`
  - `OrionStarsBalanceProvider=PASS`
  - `H0UND.Main=PASS`
- `_debug` chain reconstruction validated by `sessionId` + `correlationId` for scenarios:
  - `H0UND_ORCH`, `H0UND_POLL`, `H0UND_ORION`, `H0UND_MAIN`

**Design Document Reference**: `STR4TEG15T/designs/DESIGN_051_CHAOS_LOGGING_ARCHITECTURE.md` (2,200 lines)

**Chaos Point ID Naming Convention**: 
- Format: `{Component}.{Class}.{Operation}`
- Examples: `H0UND.PollingWorker.GetBalancesWithRetry`, `H4ND.LegacyRuntimeHost.LockCredential`

**Performance Targets**:
- Event logging: <1ms p99 latency
- Batch flush: <100ms for 100 documents
- Throughput: >10,000 events/second
- Memory: <2KB per event (including metadata)

**Sampling Guidelines**:
- Service lifecycle events: 100% (low frequency)
- Data mutations: 100% (never sample critical operations)
- Validations: 10% (medium frequency)
- Polling loops: 1% (high frequency)
- Canvas operations: 100% (need full traceability)

**MongoDB Collection**: `_debug` (separate from production collections)
- TTL: 30 days
- Sharding: Not required (expected <10GB/month)
- Backup: Daily snapshots for 90 days

---

*Decision DECISION_113*  
*Universal Chaos Logging and Sanity Test System*  
*2026-02-23*
