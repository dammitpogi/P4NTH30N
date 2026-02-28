# JOURNAL_2026-02-24_DECISION_113_H4ND_ERROR_EVIDENCE

## Decision Context

- Decision: `DECISION_113`
- Deployment Pass: H4ND Error Evidence System (P0/P1 execution window)
- Mode: Deployment evidence capture and governance trace
- Date: 2026-02-24

## Rationale

H4ND has high-risk mutation and concurrency chaos points where failures were historically hard to reproduce. This pass focused on durable evidence capture so every critical failure can be traced with `when/where/what` context and exception copy in MongoDB `_debug`.

## Scope Executed

Primary completion items reported in this pass:

1. SignalGenerator instrumentation (`P1 hotspot`)
   - `H4ND-SIGGEN-001`: warning capture when no eligible credentials found
   - `H4ND-SIGGEN-002`: per-signal insert failure capture (username hashed)
   - `H4ND-SIGGEN-003`: pipeline-level exception capture

2. Runtime wiring in entry point
   - `H4ND/EntryPoint/UnifiedEntryPoint.cs`
   - Wired `IErrorEvidence` for:
     - SignalGenerator (GENERATE-SIGNALS mode)
     - SessionRenewalService (HEALTH mode)
     - SessionRenewalService (BURN-IN mode)
     - SessionRenewalService (PARALLEL mode)

3. Type disambiguation remediation
   - Fully-qualified `Infrastructure.Logging.ErrorEvidence.ErrorSeverity`
   - Files:
     - `H4ND/Services/SignalGenerator.cs`
     - `H4ND/Services/SessionRenewalService.cs`

## Files Modified (Reported)

- `H4ND/Services/SignalGenerator.cs`
- `H4ND/Services/SessionRenewalService.cs`
- `H4ND/EntryPoint/UnifiedEntryPoint.cs`

## Validation Evidence (Reported)

- Build:
  - `H4ND`: 0 errors, 0 warnings
  - `UNI7T35T`: 0 errors, 0 warnings
- Tests:
  - Passed: `508/516`
  - Failures: `8 pre-existing`
  - Regressions: `0`

## Governance Delta and Status

- Decision status tracking updated in `STR4TEG15T/decisions/active/DECISION_113.md`.
- H4ND execution actions marked complete for this pass:
  - `ACT-113-009` Completed (Phase H4ND)
  - `ACT-113-012` Completed (Phase H4ND)
  - `ACT-113-021` Completed
  - `ACT-113-022` Completed

## Risk Notes

Remaining operational risks requiring ongoing validation:

1. Ack ownership drift across runtime/spin layers if future changes reintroduce duplicate semantics.
2. Evidence payload growth in hot loops if snapshot size controls are bypassed.
3. `_debug` write-path resilience under Mongo outages must continue to be verified in fault tests.

## Next Deployment Gate

Before closure of DECISION_113 deployment lifecycle:

1. Verify `_debug` indexes + TTL are present in target environment.
2. Run focused fault-injection for top-5 concurrency hotspots and confirm reproducible evidence chain by `sessionId` and `correlationId`.
3. Publish final closure checklist evidence snapshot in decision artifact.

## Closure Validation Execution (One-Pass)

### Gate 1 — Fault-Injection Validation (Top 5 Hotspots)

Executed targeted fault-injection scenarios and verified `_debug` chain reconstruction by `sessionId` and `correlationId`.

| Test Name | Hotspot | Scenario | Expected Failure | `_debug` Docs | Sample Chain | Result |
|---|---|---|---|---:|---|---|
| `FI-HS1-ACK-EARLY` | `LegacyRuntimeHost.cs:260-263` | `HS1_EARLY_ACK_PATH` | Early ack observed before authoritative path | 3 | `scope_start -> ack_observed_preprocess -> fault_injected_expected` | PASS |
| `FI-HS2-UNLOCK-PERSIST` | `LegacyRuntimeHost.cs:578-601` | `HS2_UNLOCK_BEFORE_PERSIST` | Unlock-before-persist race window | 3 | `scope_start -> unlock_called -> persist_failed_window` | PASS |
| `FI-HS3-ACK-OVERLAP` | `SpinExecution.cs:53` | `HS3_ACK_OWNERSHIP_OVERLAP` | Ack ownership overlap | 3 | `scope_start -> ack_observed_before_authoritative_ack -> spin_failed_expected` | PASS |
| `FI-HS4-DELETEALL` | `LegacyRuntimeHost.cs:482,507,532,557` | `HS4_DELETEALL_BRANCH` | `DeleteAll` branch anomaly | 3 | `scope_start -> deleteall_branch_entered -> branch_fault_injected` | PASS |
| `FI-HS5-CLAIM-RELEASE` | `ParallelSpinWorker.cs:218-220,235-237` | `HS5_RETRY_CLAIM_RELEASE` | Retry + claim release failure | 3 | `scope_start -> retry_path_entered -> claim_release_failed_expected` | PASS |

### Gate 2 — MongoDB `_debug` TTL/Index Verification

Initial state: `_debug` collection absent in runtime DB.

Remediation applied:
- Created `_debug` collection.
- Created required indexes:
  - `idx_debug_expiresAt_ttl`
  - `idx_debug_session_capturedAt`
  - `idx_debug_correlation_capturedAt`
  - `idx_debug_component_operation_capturedAt`
  - `idx_debug_errorCode_capturedAt`

Verification matrix:

| Required Index | Expected | Observed | Result |
|---|---|---|---|
| TTL | `{ expiresAt: 1 }`, `expireAfterSeconds: 0` | `idx_debug_expiresAt_ttl`, `expireAfterSeconds: 0` | PASS |
| Session | `{ sessionId: 1, capturedAt: -1 }` | `idx_debug_session_capturedAt` | PASS |
| Correlation | `{ correlationId: 1, capturedAt: -1 }` | `idx_debug_correlation_capturedAt` (`sparse`) | PASS |
| Component/Operation | `{ component: 1, operation: 1, capturedAt: -1 }` | `idx_debug_component_operation_capturedAt` | PASS |
| ErrorCode | `{ errorCode: 1, capturedAt: -1 }` | `idx_debug_errorCode_capturedAt` (`sparse`) | PASS |

### Gate 3 — Closure Checklist Draft

- [x] Gate 1 complete for all 5 hotspots with evidence counts + chains.
- [x] Gate 2 complete with remediation and explicit index PASS matrix.
- [x] Decision artifact updated with closure snapshot and residual risks.
- [x] Deployment journal updated with closure-ready matrices.

### Residual Risks and Owners

1. Runtime-native hotspot trigger harness executed successfully (residual blocker #1 closed).
   - Owner: WindFixer/OpenFixer
   - Evidence: `dotnet run --project UNI7T35T/UNI7T35T.csproj -- --decision113-only`
   - Result matrix: `HS1=PASS`, `HS2=PASS`, `HS3=PASS`, `HS4=PASS`, `HS5=PASS`
   - Coverage assertions: expected `errorCode`, `sessionId/correlationId` chain continuity, and envelope fields (`capturedAt`, `location`, `exception`) verified per scenario.

2. Mongo-unavailable graceful-degradation evidence captured (residual blocker #2 closed).
   - Owner: OpenFixer
   - Evidence command: `dotnet run --project UNI7T35T/UNI7T35T.csproj -- --decision113-outage-only`
   - Outcome: PASS (bounded outage simulation + counter capture + recovery verification)

## Residual Blocker #2 Validation (Mongo-unavailable `_debug` Sink)

### Outage Method Used

- Controlled, bounded sink outage simulation in `UNI7T35T/H4ND/Decision113/MongoOutageDegradationTests.cs`.
- `IErrorEvidenceRepository` wrapper forces timeout failures on `_debug` writes during outage window while runtime evidence emission continues.
- No destructive data operations; reversible in-process gate toggles outage off for recovery phase.

### Commands Executed

- `dotnet build UNI7T35T/UNI7T35T.csproj`
- `dotnet run --project UNI7T35T/UNI7T35T.csproj -- --decision113-outage-only`

### Timeline (UTC)

- baseline: `2026-02-24T11:14:41.3205764Z -> 2026-02-24T11:14:43.4152155Z`
- outage: `2026-02-24T11:14:43.4152155Z -> 2026-02-24T11:14:46.8343395Z`
- recovery: `2026-02-24T11:14:46.8343396Z -> 2026-02-24T11:14:48.8389924Z`

### Counter Evidence Summary

- `enqueued=300`
- `written=0` (during forced outage window)
- `droppedQueue=0`
- `droppedSink=128`
- `enabled=True`
- operational logs captured:
  - sink-failure lines (`"sink failure dropped"`): `26`
  - summary lines (`"summary enqueued"`): `3`
- circuit/open-state indicators: `n/a` (not implemented in `ErrorEvidenceService`)

### PASS/FAIL Outcomes

- Stability outcome: **PASS**
  - runtime remained live/non-blocking (`stable=True`, `nonBlocking=True`)
  - no crash/no hard block during outage emission loop
- Recovery outcome: **PASS**
  - post-outage `_debug` writes resumed and were observed (`recovery writes=24`)

## Residual Blocker #1 Implementation Notes

- Added runtime-native hotspot harness: `UNI7T35T/H4ND/Decision113/HotspotFaultHarnessTests.cs`
- Added isolated harness execution mode: `UNI7T35T/Program.cs` (`--decision113-only`)
- Added harness runtime dependency staging: `UNI7T35T/UNI7T35T.csproj` (`CopyLocalLockFileAssemblies=true`)
- Added minimal deterministic helper seams:
  - `H4ND/Services/LegacyRuntimeHost.cs`
  - `H4ND/Parallel/ParallelSpinWorker.cs`
- Corrected `DeleteAll` branch scoping in `LegacyRuntimeHost` to preserve intended conditional behavior while instrumenting branch markers.

## Artifact Links

- Decision: `STR4TEG15T/decisions/active/DECISION_113.md`
- H4ND architecture consultation: `STR4TEG15T/consultations/designer/DECISION_051_designer.md`
- Dynamic object model: `STR4TEG15T/consultations/designer/DECISION_051_dynamic_error_objects.md`
- System design: `STR4TEG15T/designs/DESIGN_051_CHAOS_LOGGING_ARCHITECTURE.md`

## H0UND Rollout Phase (DECISION_113)

### Commands Executed

- `dotnet build H0UND/H0UND.csproj`
- `dotnet build UNI7T35T/UNI7T35T.csproj`
- `dotnet run --project UNI7T35T/UNI7T35T.csproj -- --decision113-h0und-only`

### Hotspot Coverage Matrix

| Group | Target Coverage | Result |
|---|---|---|
| ServiceOrchestrator | `H0UND/Services/Orchestration/ServiceOrchestrator.cs` (health-loop, restart scheduling/coalescing, restart release invariant) | PASS |
| PollingWorker | `H0UND/Application/Polling/PollingWorker.cs` (retry guardrails, sampled retry warnings, grand-zero guardrail, suspended account boundary) | PASS |
| OrionStarsBalanceProvider | `H0UND/Infrastructure/Polling/OrionStarsBalanceProvider.cs` (NaN/Infinity/negative coercion with evidence) | PASS |
| H0UND main/anomaly paths | `H0UND/H0UND.cs` (lock acquire/release invariants, analytics boundary, anomaly callback boundary, circuit-open/main-loop evidence) | PASS |

### Sampling + Sanity Behavior

- Deterministic sampling added for non-critical warnings (`ShouldSample` stable key modulus) in high-frequency polling/orchestrator paths.
- Errors and invariant failures remain 100% capture.
- Sanity checks enforced for:
  - lock acquire/release balance invariants (`H0UND-LOCK-INV-001`, `H0UND-LOCK-INV-002`)
  - retry exhaustion guardrails (`H0UND-POLL-RETRY-ERR-001`)
  - coercion on invalid numeric provider values (`H0UND-ORION-COERCE-001`)
  - anomaly callback silent-failure boundary (`H0UND-ANOM-LOG-ERR-001`)

### `_debug` Query Proof (session/correlation continuity)

Validated by test harness output:

- `H0UND_ORCH`: `docs=3`, `sessionId=d113h0-c300c8203ecb4152aca0d88fc`, `correlationId=ff3cb70b-a2ed-4081-8423-c4e28e22531f`
- `H0UND_POLL`: `docs=3`, `sessionId=d113h0-d8c6b200a658410ca2c8d796d`, `correlationId=9535ec89-614d-4d8a-8c12-da48cac88ee2`
- `H0UND_ORION`: `docs=3`, `sessionId=d113h0-64534f3b329c41789681a24ad`, `correlationId=cb01d598-6dfb-446d-b988-44b6e02081b`
- `H0UND_MAIN`: `docs=4`, `sessionId=d113h0-4db5df306bda4ca299849589d`, `correlationId=fa90031b-ab27-412c-a133-51f6091c492e`
