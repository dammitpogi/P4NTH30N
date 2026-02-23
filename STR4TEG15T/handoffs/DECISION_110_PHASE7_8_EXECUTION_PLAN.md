---
agent: strategist
type: handoff
decision: DECISION_110
created: 2026-02-22
status: ready
tags:
  - h4nd
  - phase7
  - phase8
  - parallel-hardening
  - burn-in
---

# DECISION_110 Phase 7-8 Execution Plan

## Objective
Harden parallel execution and verify production readiness without behavior regressions in Navigation and Parallel flows.

## Institutional Memory Applied
- DECISION_081: Canvas credential interaction requires explicit browser/runtime handling and profile isolation.
- DECISION_102: Navigation JSON must tolerate schema drift to avoid fallback to legacy hardcoded actions.
- DECISION_106: Config discovery must verify content, not only directory existence.
- DECISION_109: Recorder-defined navigation must remain first-class with controlled fallback.

## Current Increment Confirmed
- `clip` action strategy added and registered in default step strategy chain.
- Navigation tests include `clip` behavior coverage.
- Build completed for H4ND and UNI7T35T after transient lock retry.

## Phase 7 - Parallel Hardening Scope

### Work Package P7-A: Shared CDP/Session Coordination
1. Enforce single-writer semantics per CDP session and per credential lock scope.
2. Add explicit ownership metadata for worker/session bindings.
3. Introduce contention telemetry: queue wait, lock wait, retries, forced reconnect count.

### Work Package P7-B: Reconnect and Backoff Stability
1. Tune `CdpLifecycleManager` reconnect windows to avoid synchronized retry storms.
2. Add bounded jittered retry profiles for worker cohorts.
3. Persist reconnect decisions in structured logs with correlation IDs.

### Work Package P7-C: Race Detection and Guardrails
1. Add fail-fast guards around shared mutable state transitions.
2. Add assertions and structured error events for invalid ownership transitions.
3. Extend parallel tests with contention simulations and deterministic seeds.

### Phase 7 Exit Criteria
- No unowned session use observed in telemetry.
- No deadlock or starvation under stress scenarios.
- Parallel throughput does not regress more than 5 percent from baseline.

## Phase 8 - Production Readiness Scope

### Work Package P8-A: 24h Burn-In and Failure Matrix
1. Run 24-hour burn-in with production-like worker count.
2. Capture failure matrix by category: CDP, auth, navigation, persistence, telemetry sink.
3. Verify all failures include operation context and correlation chain.

### Work Package P8-B: Performance and SLO Validation
1. Measure p50/p95/p99 latency per spin path and per navigation phase.
2. Measure throughput per worker and aggregate throughput.
3. Validate budget compliance against agreed targets.

### Work Package P8-C: Operations Readiness
1. Validate alerting paths from threshold breach to operator-visible signal.
2. Validate dashboard usability for incident drilldown.
3. Execute rollback switch test and confirm safe legacy re-entry.

### Phase 8 Exit Criteria
- 24h burn-in completes without critical unresolved incidents.
- p95 latency and throughput remain in budget.
- Rollback validated and documented as runnable procedure.

## Evidence Package Required
1. Soak metrics summary (hourly + aggregate)
2. Failure matrix with root cause and containment
3. Correlation drilldown example across:
   - `L0G_0P3R4T10NAL`
   - `L0G_P3RF0RM4NC3`
   - `L0G_D0M41N`
   - `L0G_4UD1T`
4. Go/No-Go recommendation with explicit risk acceptance list

## Non-Negotiable Checks
- Preserve all run modes and behavior contracts.
- Preserve Navigation and Parallel semantics.
- No silent catches.
- No production-path `Console.WriteLine` in final migration state.
- Entry point remains composition-only target (<100 LOC) after conversion phase.

## Immediate Next Actions
1. Re-run burn-in path that previously failed on unknown `clip` action.
2. Inspect CDP disconnect churn and tune reconnect profile where dominant.
3. Generate new readiness snapshot from `ProductionReadinessEvaluator` after burn-in.
