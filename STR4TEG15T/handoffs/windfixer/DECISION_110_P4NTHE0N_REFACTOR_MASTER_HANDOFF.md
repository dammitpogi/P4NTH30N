---
agent: strategist
type: windfixer-handoff
decision: DECISION_110
created: 2026-02-22
status: ready-for-implementation
tags: [p4nthe0n, refactor, solid, ddd, fail-fast, structured-logging, mongodb, map, prompts]
---

# DECISION_110 Master Handoff for WindFixer

This is the implementation map and direct execution package for the DECISION_110 refactor of H4ND into P4NTHE0N architecture.

This handoff assimilates:
- Decision spec: `STR4TEG15T/decisions/active/DECISION_110.md`
- Designer consultation: `STR4TEG15T/consultations/designer/DECISION_110_designer.md`
- ArXiv synthesis: `STR4TEG15T/research/DECISION_110_arxiv_research.md`
- Current runtime codemap: `H4ND/codemap.md`
- Designer operating doctrine: `C:\Users\paulc\.config\opencode\agents\designer.md`

## Strategic Intent

Refactor the current monolithic entrypoint and mixed concerns into a domain-shaped architecture that:
1. fails fast at all boundaries,
2. logs with schema-first structured telemetry,
3. preserves runtime behavior during migration,
4. keeps current Navigation and Parallel behavior stable while extracting domain logic.

## Current-State Assimilation Map (What Exists Now)

### Root map
- `H4ND/H4ND.cs` - monolithic process and mode orchestration
- `H4ND/Navigation/` - step strategy + retry + verification pipeline (must preserve)
- `H4ND/Infrastructure/` - CDP health/actions, command pipeline, session + spin infra
- `H4ND/Services/` - lifecycle/session/jackpot/signal services with mixed concerns
- `H4ND/Parallel/` - parallel workers/distributor/metrics (minimal behavior changes)
- `H4ND/Monitoring/` - burn-in and alerting runtime monitor layer
- `H4ND/EntryPoint/UnifiedEntryPoint.cs` - newer mode parsing entry path
- `H4ND/Vision/` + `H4ND/VisionCommandListener.cs` - FourEyes-related signaling

### Monolith responsibilities currently collapsed in `H4ND/H4ND.cs`
- mode routing
- signal loop
- credential lock/validate/process/unlock
- login/logout orchestration
- jackpot value read + DPD pop detection
- retry/backoff and balance validation
- periodic health reporting and operational summaries

### Existing MongoDB data surface
- `CR3D3N7IAL`
- `EV3NT`
- `ERR0R`

### Target logging/event data surface (new)
- `L0G_0P3R4T10NAL`
- `L0G_4UD1T`
- `L0G_P3RF0RM4NC3`
- `L0G_D0M41N`

## Target-State Refactor Topology (What Must Exist After)

Use `H4ND/` as implementation root now; logical architecture name is P4NTHE0N.

### Domain topology
- `Domains/Common`
  - `Guard`, `DomainException`, `AggregateRoot`, `ValueObject`, `IDomainEvent`
- `Domains/Automation`
  - Aggregates: Credential, SignalQueue
  - ValueObjects: CredentialId, Username, GamePlatform, Money, Threshold, DpdToggleState, JackpotBalance
  - Events: SignalReceived, CredentialLocked/Unlocked, BalanceUpdated
  - Services: SignalProcessor, CredentialLifecycleManager
  - Repositories interfaces
- `Domains/Execution`
  - Aggregate: SpinSession
  - ValueObjects: SpinId, SpinResult, JackpotTier, SpinMetrics
  - Events: SpinExecuted, JackpotPopped, ThresholdReset
  - Services: SpinExecutor, DpdJackpotDetector
- `Domains/Monitoring`
  - Aggregate: HealthCheck
  - ValueObjects: HealthStatus, HealthMetric, ComponentName
  - Events: HealthDegraded/Recovered
  - Services: HealthMonitor, MetricsCollector

### Infrastructure topology
- `Infrastructure/Logging`
  - `IStructuredLogger`, Mongo logger provider/impl
  - schema-first entries + `schemaVersion`
  - `CorrelationContext`
  - `DomainEventEnvelope` (EventId/EventVersion/AggregateVersion)
  - `BufferedLogWriter`, `TelemetryLossCounters`, optional `DeltaPayloadEncoder`
- `Infrastructure/Persistence`
  - repo implementations + context
- `Infrastructure/Messaging`
  - domain event publish/subscribe path
- `Infrastructure/Resilience`
  - circuit breaker contracts and implementation

### Composition topology
- `EntryPoint/Program.cs` (or composition adapter) must end as pure composition root
- domain/application orchestration moved out of entrypoint

## Non-Negotiable Constraints for WindFixer

1. Preserve all existing run modes and behavioral contracts.
2. Preserve `Navigation/` behavior.
3. Preserve `Parallel/` behavior first; optimize second.
4. No silent catches; all failures are explicit and contextual.
5. No `Console.WriteLine` in production path after migration completion.
6. Entry point must end under 100 lines, composition only.
7. Changes must be staged with feature flags and rollback route.

## Implementation Workstreams (Parallelizable Map)

## Stream A - Domain Foundation
- Build common domain primitives and value objects with invariants.
- Build domain event contracts and aggregate event recording mechanics.

## Stream B - Structured Logging + Telemetry
- Create all 4 collections and indexes.
- Implement logger provider + schema-first documents.
- Implement correlation, buffering, and loss counters.

## Stream C - Service Extraction
- Move signal + jackpot + credential logic from monolith into services.
- Keep behavior parity with existing flows.

## Stream D - Composition + Migration
- Wire DI and feature flags.
- Replace monolithic execution path with delegated services.
- Keep legacy path behind a fallback flag until confidence threshold is met.

## Stream E - Validation + Hardening
- Unit + integration + soak + perf checks.
- Correlation drilldowns across log collections.

## Phase Plan With Exit Gates

### Phase 1 - Domain Foundation
Exit gate:
- value objects immutable + invariant-safe
- guard utilities used at service boundaries
- domain events emitted from aggregate transitions

### Phase 2 - Structured Logging and Event Telemetry
Exit gate:
- all 4 log collections live
- `L0G_D0M41N.eventId` unique index enforced
- correlation path proven across operational + perf + domain logs
- sink outage test proves queueing/backpressure/loss counters

### Phase 3 - Domain Aggregates and Event Flow
Exit gate:
- jackpot pop transitions moved into aggregate/event model
- event versioning does not break readers

### Phase 4 - Repository Layer
Exit gate:
- repositories async + cancellable
- schemaVersion included on persisted log docs
- read/write performance within target bands

### Phase 5 - Service Layer Refactor
Exit gate:
- signal/credential/jackpot/health orchestration no longer in monolith
- parity tests pass vs legacy behavior

### Phase 6 - Composition Root Conversion
Exit gate:
- entrypoint is composition-only and under 100 lines
- run modes still pass smoke tests

### Phase 7 - Parallel Execution and Stability
Exit gate:
- no race conditions in shared resources
- CDP shared access serialized where required

### Phase 8 - Performance and Production Hardening
Exit gate:
- p95 latency and throughput thresholds met
- 24h burn-in passes
- rollback plan tested

## MongoDB Implementation Spec (Runbook)

Use this as migration DDL reference:

```javascript
db.createCollection('L0G_0P3R4T10NAL', {
  timeseries: { timeField: 'timestamp', metaField: 'component', granularity: 'seconds' }
});
db.L0G_0P3R4T10NAL.createIndex({ timestamp: -1, level: 1 });
db.L0G_0P3R4T10NAL.createIndex({ correlationId: 1 });

db.createCollection('L0G_4UD1T');
db.L0G_4UD1T.createIndex({ timestamp: -1 });
db.L0G_4UD1T.createIndex({ userId: 1, timestamp: -1 });
db.L0G_4UD1T.createIndex({ eventType: 1 });

db.createCollection('L0G_P3RF0RM4NC3', {
  timeseries: { timeField: 'timestamp', metaField: 'metricName', granularity: 'seconds' }
});
db.L0G_P3RF0RM4NC3.createIndex({ timestamp: -1, metricName: 1 });

db.createCollection('L0G_D0M41N');
db.L0G_D0M41N.createIndex({ timestamp: -1 });
db.L0G_D0M41N.createIndex({ eventId: 1 }, { unique: true });
db.L0G_D0M41N.createIndex({ correlationId: 1 });
db.L0G_D0M41N.createIndex({ aggregateId: 1 });
db.L0G_D0M41N.createIndex({ eventType: 1, timestamp: -1 });
```

## Fail-Fast Contract (Must Enforce Everywhere)

- validate inputs before side effects
- throw contextual exceptions (operation, identifiers, state snippet)
- never swallow exceptions silently
- use circuit breakers for CDP/Mongo boundaries
- record all failures to structured logs with correlation id

## Definition of Done for DECISION_110

- entrypoint reduced to composition (<100 LOC)
- no production `Console.WriteLine`
- all four log collections active and populated
- correlation drilldown works end-to-end for one run id
- domain boundaries enforced and tested
- benchmark delta acceptable against baseline
- rollback switch tested

## Direct Deployment Prompts for WindFixer

Use these prompts as-is.

### Prompt 1 - Phase 1/2 Foundation + Logging

```text
WindFixer, execute DECISION_110 Phase 1 and Phase 2 now.

Mission:
1) Create domain foundation primitives and value objects with fail-fast invariants.
2) Implement structured logging + event telemetry infrastructure with 4 Mongo collections.

Critical requirements:
- No business logic changes yet.
- Add CorrelationContext, schemaVersion on log documents, DomainEventEnvelope.
- Implement buffered log writer with backpressure and telemetry loss counters.
- Add unique eventId index in L0G_D0M41N.
- Preserve existing runtime behavior.

Target folders:
- H4ND/Domains/Common/
- H4ND/Domains/Automation/ValueObjects/
- H4ND/Infrastructure/Logging/
- H4ND/Infrastructure/Persistence/

Validation:
- unit tests for Guard and value objects
- integration test proving writes to L0G_0P3R4T10NAL, L0G_4UD1T, L0G_P3RF0RM4NC3, L0G_D0M41N
- sink outage simulation: queue/backpressure/loss counters verified

Report back:
- files created/modified
- collection/index status
- test outputs
- risks found
```

### Prompt 2 - Phase 3/4 Domain + Repositories

```text
WindFixer, execute DECISION_110 Phase 3 and Phase 4.

Mission:
1) Extract jackpot/signal/credential logic into domain aggregates + events.
2) Implement repository interfaces and Mongo implementations with async/cancellation support.

Critical requirements:
- Domain event idempotency via eventId.
- EventVersion support for safe evolution.
- No regression in DPD jackpot pop behavior.
- Add schemaVersion for persisted log docs.

Target folders:
- H4ND/Domains/Automation/
- H4ND/Domains/Execution/
- H4ND/Domains/Monitoring/
- H4ND/Infrastructure/Persistence/

Validation:
- property tests for DPD toggle transitions
- idempotency tests for event persistence
- index/query performance checks

Report back:
- parity checks vs old behavior
- performance observations
- unresolved blockers
```

### Prompt 3 - Phase 5/6 Composition Refactor

```text
WindFixer, execute DECISION_110 Phase 5 and Phase 6.

Mission:
1) Move orchestration out of H4ND.cs into services.
2) Convert entrypoint to pure composition root under 100 lines.

Critical requirements:
- Preserve all run modes.
- Keep feature-flag fallback to legacy path until validation is complete.
- No silent error handling.

Target files:
- H4ND/H4ND.cs
- H4ND/EntryPoint/UnifiedEntryPoint.cs
- H4ND/Composition/*
- H4ND/Services/*

Validation:
- smoke tests for H4ND, PARALLEL, BURN-IN, MONITOR, FIRSTSPIN, GENERATE-SIGNALS
- integration checks for CDP login/spin/logout

Report back:
- final line count of H4ND.cs
- feature flag matrix
- behavior parity evidence
```

### Prompt 4 - Phase 7/8 Parallel + Hardening

```text
WindFixer, execute DECISION_110 Phase 7 and Phase 8.

Mission:
1) Harden parallel execution with safe shared resource coordination.
2) Validate production readiness with burn-in and performance targets.

Critical requirements:
- no race conditions around shared CDP/session resources
- p95 latency and throughput targets within agreed budgets
- rollback tested and documented

Validation:
- 24h burn-in
- correlation drilldown from one run across all telemetry collections
- alerting + dashboards usable for ops

Report back:
- soak/perf metrics
- failure matrix
- go/no-go recommendation
```

## Risk Register for WindFixer Attention

- DPD behavior drift during aggregate extraction
- hidden coupling in legacy services
- structured logging overhead on hot paths
- CDP shared resource contention under parallel load
- partial migration state if feature flags are not granular

## Immediate Deliverables Requested from WindFixer

1. Phase 1 and 2 implementation PR-sized change set.
2. Validation evidence for new telemetry stack and fail-fast guards.
3. Explicit list of behavior diffs (if any) from baseline.

## Final Strategic Narrative to Accompany This Handoff

We are not rewriting for aesthetics. We are extracting control from a monolith so failures become explicit, traceable, and recoverable. The refactor is successful only if runtime confidence increases while preserving the current mission profile. The architecture is a means to operational reliability: domain boundaries for clarity, fail-fast contracts for safety, and structured telemetry for truth. Every phase must leave the system runnable. Every migration step must be reversible. Every service must report what it did, why it did it, and what failed with a correlation trail. This is not optional engineering polish. This is how P4NTHE0N survives load, incidents, and iteration velocity.
