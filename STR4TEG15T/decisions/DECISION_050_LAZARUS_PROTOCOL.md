# DECISION_050: Lazarus Protocol — Self-Healing System

**Status**: DRAFT  
**Created**: 2026-02-23  
**Authority**: STRATEGIST_DIRECTIVE  
**Owner**: @forgewright (implementation), @oracle (validation)  
**Previous**: DECISION_038 (Agent Architecture), DECISION_045 (CDP Session Management)

---

## 1. Purpose

Build a **Lazarus Protocol** — an automatic self-healing system that ingests error logs from P4NTH30N, the plugin, and decision workflows; detects "contextually insane or chaotic" situations; and executes safe healing actions without manual intervention.

The system must heal itself when broken, not make things worse when confused, and always maintain an audit trail.

---

## 2. The Problem

Current state: When things break, we manually:
1. Notice something is wrong (often late)
2. Read logs across multiple systems
3. Decide what to do
4. Execute fix (usually via Forgewright delegation)

This has unacceptable latency and depends on human attention. We need autonomous healing for:
- **Runtime errors**: CDP disconnects, Chrome crashes, session expiration
- **Decision bugs**: Wrong files edited, broken implementations, test failures
- **Agent failures**: Model context length errors, rate limits, repeated failures
- **Chaos states**: Contradictory outputs, cascade failures, impossible system states

---

## 3. The Solution

### 3.1 Architecture Overview

Five-layer architecture with safety gates at every transition:

```
┌─────────────────────────────────────────────────────────────┐
│  ERROR INGESTION LAYER (EIL)                                 │
│  • Log parsers for all sources                               │
│  • Normalization into common schema                          │
│  • Deduplication & aggregation                               │
└────────────────────────┬────────────────────────────────────┘
                         │ Normalized Error
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  ANOMALY DETECTION ENGINE (ADE)                              │
│  • Pattern matching for known signatures                     │
│  • Statistical anomaly detection                             │
│  • "Insanity" heuristics (contradictions, impossibilities)   │
└────────────────────────┬────────────────────────────────────┘
                         │ Anomaly Score (0.0-1.0)
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  HEALING DECISION MATRIX (HDM)                               │
│  • Error classification → Safety level                       │
│  • AUTO / GUARDED / MANUAL / EMERGENCY                       │
│  • Action queue with priority                                │
└────────────────────────┬────────────────────────────────────┘
                         │ Healing Action
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  HEALING EXECUTION ENGINE (HEE)                              │
│  • Plugin healer (model fallbacks, context compaction)       │
│  • P4NTH30N healer (CDP reconnect, session restore)          │
│  • Decision healer (bug reports to Forgewright)              │
└────────────────────────┬────────────────────────────────────┘
                         │ Result
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  STATE TRACKING LAYER (STL)                                  │
│  • MongoDB: Healing history & outcomes                       │
│  • Redis: Circuit breaker states                             │
│  • Metrics: Success rates, MTTR                              │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Safety Architecture

Per @oracle validation, four safety levels with strict boundaries:

| Level | Description | Examples | Approval |
|-------|-------------|----------|----------|
| **AUTO** | Safe, reversible, well-understood | CDP reconnect, model retry, context compaction | None |
| **GUARDED** | Generally safe but limited blast radius | Agent restart, decision rollback to previous | Log + notify |
| **MANUAL** | Destructive or high-risk | Credential rotation, config changes, code edits | Human required |
| **EMERGENCY** | Stop everything, collect diagnostics | Unclassified error spike, potential data corruption | Quarantine mode |

**Circuit Breakers**:
- Per-error-type cooldowns (exponential backoff, max 5 attempts)
- Per-component rate limiting (max 3 healing actions/minute)
- Global emergency stop (quarantine mode on cascade detection)

### 3.3 Error Classification Taxonomy

Every error gets classified across five dimensions:

1. **Source**: `runtime` | `decision` | `agent` | `infra` | `config`
2. **Severity**: `info` | `degraded` | `critical` | `fatal`
3. **Recoverability**: `transient` | `persistent` | `unknown`
4. **State Integrity**: `consistent` | `unknown` | `corrupted`
5. **Pattern**: `known` | `novel` | `cascade`

**Insanity Detection** (chaos triggers):
- **Contradiction**: Agent reports success but error log shows failure
- **Cascade**: 3+ different subsystems fail within 60 seconds
- **Impossible State**: Chrome process exists but CDP reports "dead"
- **Zombie**: Healing action executed 5+ times with no resolution

---

## 4. Implementation Plan

### Phase 1: Foundation (MVP) — Target: Week 1

**Goal**: Read-only ingestion + safe auto-heals only

**Components**:
1. **EIL**: Basic log parsers for:
   - oh-my-opencode plugin logs
   - P4NTH30N C# runtime logs
   - Decision execution logs

2. **ADE**: Pattern matching for 10 known error signatures:
   - CDP disconnect
   - Context length exceeded
   - Model rate limit
   - Chrome crash
   - Session expired
   - MongoDB connection lost
   - File not found (decision bug)
   - Test assertion failed
   - Agent timeout
   - Circuit breaker open

3. **HEE**: AUTO-level healing only:
   - CDP reconnect on disconnect
   - Model retry with backoff (max 3)
   - Context compaction + single retry

4. **STL**: MongoDB collection for healing history

**Safety**: All other errors → diagnostic mode only (log and alert, no action)

### Phase 2: Intelligence — Target: Week 2

**Goal**: Statistical anomaly detection + GUARDED actions

**Additions**:
- Statistical baseline for error rates per component
- Anomaly scoring (0.0-1.0)
- Insanity detection heuristics
- GUARDED-level healing:
  - Agent restart
  - Decision rollback
  - Auto-generated bug reports for novel errors

### Phase 3: Full Autonomy — Target: Week 3

**Goal**: Complete self-healing with monitoring integration

**Additions**:
- MANUAL-level workflow with human approval queue
- EMERGENCY quarantine mode
- REST API for monitoring layer
- Dashboard integration (future monitoring UI)

---

## 5. File Structure

```
STR4TEG15T/
└── lazarus/                        # Self-healing system
    ├── src/
    │   ├── ingestion/              # EIL - Error Ingestion Layer
    │   │   ├── parsers/
    │   │   │   ├── plugin-logs.ts
    │   │   │   ├── p4nth30n-logs.ts
    │   │   │   └── decision-logs.ts
    │   │   ├── normalizer.ts
    │   │   └── deduplicator.ts
    │   ├── detection/              # ADE - Anomaly Detection Engine
    │   │   ├── pattern-matcher.ts
    │   │   ├── statistical-analyzer.ts
    │   │   ├── insanity-detector.ts
    │   │   └── anomaly-scorer.ts
    │   ├── decision/               # HDM - Healing Decision Matrix
    │   │   ├── classifier.ts
    │   │   ├── safety-evaluator.ts
    │   │   ├── action-queue.ts
    │   │   └── escalation-router.ts
    │   ├── execution/              # HEE - Healing Execution Engine
    │   │   ├── plugin-healer.ts
    │   │   ├── p4nth30n-healer.ts
    │   │   ├── decision-healer.ts
    │   │   └── circuit-breaker.ts
    │   ├── state/                  # STL - State Tracking Layer
    │   │   ├── history-store.ts
    │   │   ├── metrics-tracker.ts
    │   │   └── state-manager.ts
    │   ├── types/
    │   │   └── index.ts
    │   └── index.ts                # Main entry point
    ├── tests/
    ├── package.json
    ├── build.ps1
    └── ARCHITECTURE.md             # Detailed architecture reference
```

---

## 6. Integration Points

### 6.1 Plugin Integration (oh-my-opencode)

Hook into existing error recovery in `background-manager.ts`:

```typescript
// After error detection, emit to Lazarus
lazarus.ingest({
  source: 'plugin',
  type: 'model_failure',
  agent: 'explorer',
  error: error.message,
  context: sessionContext,
  timestamp: Date.now()
});
```

### 6.2 P4NTH30N Integration (C#)

Bridge component in `W4TCHD0G/`:

```csharp
// Forward runtime errors to Lazarus via HTTP/gRPC
public class LazarusBridge {
    public void ReportError(RuntimeError error) {
        // POST to Lazarus ingestion endpoint
    }
}
```

### 6.3 Decision System Integration

Auto-generate bug reports for decision bugs:

```typescript
// In decision-healer.ts
if (error.source === 'decision' && error.recoverability === 'persistent') {
  await forgewright.createBugFixDecision({
    originalDecision: error.decisionId,
    error: error.message,
    context: error.context
  });
}
```

---

## 7. Safety Requirements

Per @oracle risk assessment:

1. **Infinite Loop Prevention**: Max 5 healing attempts per error signature, then escalate to MANUAL
2. **Cascading Failure Protection**: Global rate limit (3 healing actions/minute), quarantine on cascade detection
3. **Data Corruption Guards**: Pre/post condition validation for all healing actions, rollback capability
4. **Audit Trail**: Immutable log of trigger → classification → action → result
5. **Human Override**: Emergency stop API, manual approval queue for MANUAL level
6. **Blast Radius Limits**: Default to single-subsystem actions, explicit escalation for cross-system ops

---

## 8. Success Criteria

**Phase 1**:
- [ ] 100% of known error signatures are ingested
- [ ] AUTO-level healing achieves >80% success rate
- [ ] Zero healing attempts exceed safety limits
- [ ] All healing actions logged with full audit trail

**Phase 2**:
- [ ] Novel error detection within 60 seconds
- [ ] Statistical anomaly detection operational
- [ ] GUARDED-level healing achieves >70% success rate
- [ ] Auto-generated bug reports are actionable

**Phase 3**:
- [ ] Full four-level safety system operational
- [ ] Mean time to recovery (MTTR) < 2 minutes for AUTO-level
- [ ] Human approval queue functional for MANUAL level
- [ ] REST API exposes all state for monitoring

---

## 9. Bug-Fix Workflow

When bugs are found in this decision:

1. **Classification**: Use ErrorClassifier to categorize bug type
2. **Delegation**: Auto-delegate to @forgewright with:
   - Original decision context (DECISION_050)
   - Error message and stack trace
   - Component (EIL/ADE/HDM/HEE/STL)
   - Safety level impact (does this affect healing safety?)
3. **Fix + Test**: Forgewright fixes and tests
4. **Integration**: Fix merged, bug logged in Consultation Log
5. **Retrospective**: If bug indicates systemic issue, escalate to @oracle

---

## 10. Token Budget

| Phase | Estimated Tokens | Primary Model |
|-------|------------------|---------------|
| Phase 1 (MVP) | ~150K | Claude 3.5 Sonnet |
| Phase 2 (Intelligence) | ~100K | Claude 3.5 Sonnet |
| Phase 3 (Full) | ~100K | Claude 3.5 Sonnet |
| **Total** | **~350K** | — |

---

## 11. Sub-Decision Authority

| Agent | Can Create Sub-Decisions | Max Complexity |
|-------|-------------------------|----------------|
| @forgewright | Yes | High — Implementation details per component |
| @oracle | Yes | Medium — Safety mechanism validation |
| @designer | Yes | Medium — Component interface design |
| @windfixer | No | — Execute only, no architecture changes |

---

## 12. Dependencies

- **MongoDB**: For healing history persistence (already used in P4NTH30N)
- **Redis** (optional): For circuit breaker state (can use in-memory initially)
- **oh-my-opencode plugin**: Error hook integration points (DECISION_038 modifications)
- **P4TCHD0G**: C# bridge for runtime error forwarding

---

## 13. Open Questions

1. Should we implement a "dry run" mode where healing actions are logged but not executed? (Useful for tuning)
2. What's the SLA for human response to MANUAL-level healing requests?
3. Should we integrate with external alerting (Slack, email) or keep internal?
4. How do we handle healing actions that themselves fail?

---

## 14. Changelog

| Date | Version | Changes |
|------|---------|---------|
| 2026-02-23 | 0.1 | Initial draft based on @oracle validation and @designer architecture |

---

## Consultation Log

| Date | Consultant | Topic | Outcome |
|------|------------|-------|---------|
| 2026-02-23 | @oracle | Risk assessment, safety requirements | Safety levels defined, circuit breakers mandated |
| 2026-02-23 | @designer | Architecture design | Five-layer architecture specified, file structure defined |

