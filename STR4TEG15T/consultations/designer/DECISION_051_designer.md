---
agent: designer
type: architecture
decision: DECISION_051
created: 2026-02-23T12:00:00Z
status: final
tags: [h4nd, error-logging, evidence, mongodb, observability]
---

# DECISION_051 Designer Consultation: H4ND Error Evidence System

## Scope

Design a clean, readable, production-grade system for H4ND that captures:
- when an error happened,
- where it happened,
- what failed,
- and evidence snapshots needed for investigation.

This plan starts with H4ND runtime paths only, then expands after validation.

## Institutional Memory Inputs

- `STR4TEG15T/decisions/DECISION_051_H0UND_CHAOS_MAPPING.md`
- `STR4TEG15T/decisions/active/DECISION_113.md`
- `STR4TEG15T/decisions/active/DECISION_055.md`
- `STR4TEG15T/decisions/active/DECISION_047.md`
- `STR4TEG15T/decisions/active/DECISION_098.md`

Key carry-forward patterns:
- Reuse existing H4ND structured logging pipeline (`StructuredLogger`, `BufferedLogWriter`, `CorrelationContext`).
- Add `_debug` evidence storage for error-first diagnostics with TTL and correlation indexes.
- Avoid noisy inline logging; prefer short explicit helper calls and scope wrappers.

## Architecture Proposal

### Design Goals

1. Keep runtime code readable (one-line instrumentation at call sites).
2. Ensure every captured error contains reproducible evidence.
3. Prevent logging path from destabilizing runtime (non-blocking, bounded, backpressure-aware).
4. Correlate evidence across LegacyRuntimeHost, ParallelSpinWorker, SpinExecution, SessionRenewalService, and SignalGenerator.

### Component Model

```text
H4ND Runtime Code
   -> ErrorEvidence API (small, explicit call surface)
      -> EvidenceBuilder (state snapshots + redaction)
         -> EvidenceDispatcher (channel/batch)
            -> MongoDebugRepository (_debug)
               + Existing StructuredLogger (operational/audit/perf/domain)
```

### Interface Surface (Readable by Default)

```csharp
public interface IErrorEvidence
{
    ErrorScope BeginScope(string component, string operation, Dictionary<string, object>? tags = null);

    void Capture(
        Exception ex,
        string code,
        string message,
        Dictionary<string, object>? context = null,
        object? evidence = null);

    void CaptureWarning(
        string code,
        string message,
        Dictionary<string, object>? context = null,
        object? evidence = null);

    void CaptureInvariantFailure(
        string code,
        string message,
        object? expected,
        object? actual,
        Dictionary<string, object>? context = null);
}

public readonly struct ErrorScope : IDisposable
{
    public string CorrelationId { get; }
    public string SessionId { get; }
    public string Component { get; }
    public string Operation { get; }
}
```

Usage pattern in runtime code:

```csharp
using var scope = _errors.BeginScope("LegacyRuntimeHost", "ProcessSignal", new()
{
    ["CredentialId"] = credential._id,
    ["SignalId"] = signal?._id,
});

try
{
    // business logic
}
catch (Exception ex)
{
    _errors.Capture(ex, "H4ND-RT-001", "Signal pipeline failed", evidence: new
    {
        credential.Balance,
        credential.Banned,
        SignalPriority = signal?.Priority,
    });
    throw;
}
```

This keeps call sites small and consistent.

## Evidence Document Model (`_debug`)

Collection: `_debug`

```json
{
  "_id": "ObjectId",
  "name": "H4ND Error Evidence",
  "sessionId": "string",
  "correlationId": "string",
  "component": "LegacyRuntimeHost",
  "operation": "ProcessSignal",
  "errorCode": "H4ND-RT-001",
  "severity": "Error",
  "occurredAtUtc": "ISODate",
  "message": "Signal pipeline failed",
  "exception": {
    "type": "System.InvalidOperationException",
    "message": "...",
    "stackTrace": "...",
    "inner": {
      "type": "...",
      "message": "..."
    }
  },
  "location": {
    "file": "LegacyRuntimeHost.cs",
    "line": 413,
    "member": "ProcessSignal"
  },
  "context": {
    "credentialId": "...",
    "signalId": "...",
    "workerId": "...",
    "house": "...",
    "game": "..."
  },
  "evidence": {
    "before": { "balance": 123.45, "isLocked": true },
    "after": { "balance": 0.0, "isLocked": false },
    "diff": ["balance", "isLocked"],
    "metrics": { "durationMs": 88.3 }
  },
  "tags": ["chaos-point", "runtime-loop"],
  "schemaVersion": 1,
  "expiresAtUtc": "ISODate"
}
```

### Indexes

- `{ sessionId: 1, occurredAtUtc: -1 }`
- `{ correlationId: 1 }`
- `{ component: 1, operation: 1, occurredAtUtc: -1 }`
- `{ errorCode: 1, occurredAtUtc: -1 }`
- TTL index `{ expiresAtUtc: 1 }`

## Evidence Capture Rules

### Required on Every Capture

- UTC timestamp
- component + operation
- correlationId + sessionId
- file/member/line (best effort)
- exception type/message/stack
- stable error code

### Required at Mutation Hotspots

- state-before snapshot
- state-after snapshot (if execution reached mutation)
- minimal diff array

### Redaction Rules

- never store plain credentials, tokens, passwords, cookies.
- include masked aliases only (`usernameHash`, `credentialId`, `signalId`).
- cap payload size (`maxEvidenceBytes`) and truncate with `isTruncated = true`.

## H4ND First-Phase Hook Plan

### P0 (Top 5 Concurrency-Risk Hotspots)

1. `H4ND/Services/LegacyRuntimeHost.cs:260-263`
2. `H4ND/Services/LegacyRuntimeHost.cs:578-601`
3. `H4ND/Infrastructure/SpinExecution.cs:53`
4. `H4ND/Services/LegacyRuntimeHost.cs:482`, `H4ND/Services/LegacyRuntimeHost.cs:507`, `H4ND/Services/LegacyRuntimeHost.cs:532`, `H4ND/Services/LegacyRuntimeHost.cs:557`
5. `H4ND/Parallel/ParallelSpinWorker.cs:218-220`, `H4ND/Parallel/ParallelSpinWorker.cs:235-237`

### P1 (Remaining Hotspots in Runtime/Parallel/Auth)

- `H4ND/Services/LegacyRuntimeHost.cs:250-263`, `H4ND/Services/LegacyRuntimeHost.cs:413-428`, `H4ND/Services/LegacyRuntimeHost.cs:469-567`, `H4ND/Services/LegacyRuntimeHost.cs:600`, `H4ND/Services/LegacyRuntimeHost.cs:854-855`, `H4ND/Services/LegacyRuntimeHost.cs:910`
- `H4ND/Parallel/ParallelSpinWorker.cs:167`, `H4ND/Parallel/ParallelSpinWorker.cs:183`, `H4ND/Parallel/ParallelSpinWorker.cs:245`
- `H4ND/Infrastructure/SpinExecution.cs:66-68`, `H4ND/Infrastructure/SpinExecution.cs:77-90`
- `H4ND/Services/SessionRenewalService.cs:57-64`, `H4ND/Services/SessionRenewalService.cs:73-79`, `H4ND/Services/SessionRenewalService.cs:181-186`, `H4ND/Services/SessionRenewalService.cs:200-201`, `H4ND/Services/SessionRenewalService.cs:247-249`
- `H4ND/Services/SignalGenerator.cs:64-69`, `H4ND/Services/SignalGenerator.cs:79`, `H4ND/Services/SignalGenerator.cs:88`, `H4ND/Services/SignalGenerator.cs:117-119`, `H4ND/Services/SignalGenerator.cs:124`, `H4ND/Services/SignalGenerator.cs:132`

## Clean Integration Strategy (No Readability Damage)

### Rule 1: One-line calls only

No giant inline object construction at mutation points. Build evidence using helper methods:

- `Evidence.OfCredential(credential)`
- `Evidence.OfSignal(signal)`
- `Evidence.OfMutation(before, after)`

### Rule 2: Use scopes, not repetitive metadata plumbing

`BeginScope` sets component, operation, correlation, and session once.

### Rule 3: Keep business flow primary

Instrumentation appears in these locations only:
- operation start,
- exception boundary,
- invariant failure boundary,
- critical state transition checkpoints.

### Rule 4: Logging failures never break runtime

- dispatcher uses bounded channel and drop counters
- mongo write exceptions are isolated and surfaced in structured operational logs
- circuit-breaker around `_debug` writes

## Configuration Schema

```json
{
  "ErrorEvidence": {
    "Enabled": true,
    "Collection": "_debug",
    "RetentionDays": 14,
    "MaxEvidenceBytes": 32768,
    "CaptureStack": true,
    "CaptureBeforeAfter": true,
    "Sampling": {
      "Default": 1.0,
      "ParallelSpinWorker": 0.3,
      "SignalGenerator": 0.2
    },
    "Components": {
      "LegacyRuntimeHost": true,
      "ParallelSpinWorker": true,
      "SpinExecution": true,
      "SessionRenewalService": true,
      "SignalGenerator": true
    }
  }
}
```

## Implementation File Plan (H4ND Start)

New files:
- `H4ND/Infrastructure/Logging/ErrorEvidence/IErrorEvidence.cs`
- `H4ND/Infrastructure/Logging/ErrorEvidence/ErrorEvidenceService.cs`
- `H4ND/Infrastructure/Logging/ErrorEvidence/ErrorScope.cs`
- `H4ND/Infrastructure/Logging/ErrorEvidence/ErrorEvidenceDocument.cs`
- `H4ND/Infrastructure/Logging/ErrorEvidence/EvidenceBuilder.cs`
- `H4ND/Infrastructure/Logging/ErrorEvidence/MongoDebugEvidenceRepository.cs`
- `H4ND/Infrastructure/Logging/ErrorEvidence/ErrorEvidenceOptions.cs`

Files to modify:
- `H4ND/Composition/ServiceCollectionExtensions.cs` (DI wiring)
- `H4ND/Services/LegacyRuntimeHost.cs`
- `H4ND/Parallel/ParallelSpinWorker.cs`
- `H4ND/Infrastructure/SpinExecution.cs`
- `H4ND/Services/SessionRenewalService.cs`
- `H4ND/Services/SignalGenerator.cs`
- `H4ND/Infrastructure/Persistence/MongoDbContext.cs` (collection/index bootstrap)

## Validation Plan

1. Unit tests
   - evidence includes where/when fields
   - exception copy is complete and redacted
   - before/after diff generation is deterministic
2. Integration tests
   - forced exceptions at each P0 hotspot produce `_debug` records
   - correlation ties runtime logs and evidence docs
3. Load test
   - 1000 errors/sec synthetic burst with bounded memory
   - verify backpressure counters and no runtime crash
4. Query tests
   - fetch by `sessionId`, `correlationId`, `errorCode`

## Oracle Considerations

- Primary risk: over-capturing mutable entity snapshots in hot loops.
- Mitigation: helper snapshots + size caps + component-level sampling.
- Secondary risk: duplicate evidence for same error path.
- Mitigation: optional dedupe key (`errorCode + correlationId + fingerprint(stack top 8 frames)`).

## Recommended Build Order

1. Build shared error-evidence infrastructure and `_debug` repository.
2. Instrument P0 hotspots only.
3. Validate performance and forensic quality.
4. Expand to P1 hooks.
5. Tune sampling thresholds from production telemetry.

This plan preserves readability while making H4ND failures fully reviewable and evidence-backed.
