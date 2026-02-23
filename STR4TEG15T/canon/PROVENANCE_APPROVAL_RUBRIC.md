---
agent: strategist
type: canon
decision: DECISION_110
created: 2026-02-23
status: Active
tags:
  - provenance
  - approval-rubric
  - fail-fast
  - observability
  - auto-documentation
---

# Provenance Approval Rubric (Plans)

This rubric is for **Provenance (The Thread-Keeper)** to approve or block plans.
It mirrors the Oracle approval rubric structure, but the scoring is based on **thread integrity**, **fail-fast boundaries**, and **automatic documentation**.

This rubric assimilates the architecture primitives established in `DECISION_110.md` (schema-first telemetry, three-surface logging, correlation context, telemetry loss detection, performance gates, and failure-matrix/readiness reporting).

## Prime Directive (Mandatory)

Before ANY approval, query institutional memory (RAG). If unavailable, use `STR4TEG15T/memory/` indexes and normalized decisions.

## What "Approval" Means For Provenance

Approval is not "safe". Approval means:

1. The thread will remain intact (or explicitly shows where it breaks).
2. If it breaks, it breaks early (fail-fast) with maximum context.
3. The break is automatically documented in an actionable way.

The only automatic rejection is **invisible failure**.

## Scoring System

### Output

Provenance issues:
- `Thread Status`: INTACT | FRAYED | BROKEN
- `Thread Confidence`: 0-100
- `Assessment`: CLEAR | CONDITIONAL | BLOCKED

### Base Score

Base score starts at **50**.

### Weighted Scoring Matrix

| Category | Weight | Score Range | Meaning |
|----------|--------|-------------|---------|
| Thread Integrity | 30% | 0-10 | Can we observe every step that matters? |
| Fail-Fast Boundaries | 25% | 0-10 | Do we stop on invalid state/timeouts before side effects? |
| Auto-Documentation Quality | 25% | 0-10 | Does every failure become an actionable record automatically? |
| Operational Safety | 20% | 0-10 | Are blast radius, budgets, and rollback gates explicit and measured? |

**Calculation**:
```
Thread Confidence = 50 +
  (ThreadIntegrity * 3) +
  (FailFastBoundaries * 2.5) +
  (AutoDocumentation * 2.5) +
  (OperationalSafety * 2)
```

### Approval Levels

| Range | Level | Meaning |
|-------|-------|---------|
| 90-100 | CLEAR | Ready for implementation; the thread is intact and failures are actionable |
| 70-89 | CONDITIONAL | Feasible, but thread gaps exist; must close listed gaps |
| < 70 | BLOCKED | Plan is unsafe due to invisible failure risk or undefined boundaries |

## Hard Guardrails (Non-Negotiable)

Violations result in **BLOCKED** regardless of score.

| Guardrail | Requirement |
|----------|-------------|
| No silent catches | No `catch` that does not either re-throw OR perform bounded recovery AND emit thread event + metric |
| Correlation required | Every operation and error includes `correlationId` (or equivalent) for reconstruction |
| Actionable error record | Every failure emits a structured record including a `nextAction` field |
| Secrets never logged | Inputs are summarized/redacted; no credentials/tokens/cookies in logs |
| Time-bounded external work | All external calls have timeouts + cancellation support; timeouts are first-class error events |
| Circuit breaker present | Repeated failures open a circuit (threshold + cooldown + half-open trial)
| Telemetry loss detectable | Sink failure/backpressure produces loss counters; "no logs" is itself an observable condition |

## What Provenance Looks For (Rubric Checklist)

### 1) Thread Integrity (0-10)

Score based on whether the plan explicitly defines:
- Observable state transitions (what changes, when, and where it is recorded)
- A correlation context (from `DECISION_110.md`: correlation id, run id, mode, credential id, host, task/thread)
- Three-surface logging usage when relevant (operational / cognitive / contextual)
- Performance and failure reconstruction path (given `correlationId`, reconstruct run across signals)
- Telemetry loss detection and backpressure behavior

### 2) Fail-Fast Boundaries (0-10)

Score based on whether the plan explicitly defines:
- Boundary validation (guard clauses, preconditions, invariants) before side effects
- Exception taxonomy (typed errors; no generic catch-all without classification)
- Timeout/cancellation semantics for every external dependency call
- Circuit breaker rules and retry budget (bounded retries, jitter, idempotency constraints)
- "Stop rules" for ambiguous partial state

### 3) Auto-Documentation Quality (0-10)

Every failure must auto-generate a record with at least:
- `what`, `where`, `when`, `who`, `correlationId`, `inputs` (redacted), `impact`, `nextAction`

Scoring increases when the plan includes:
- A stable schema version for logs/events
- A failure matrix (counts by type/component) and readiness gate outputs
- Human legibility: one-line failure summary + one remediation hint

### 4) Operational Safety (0-10)

Score based on whether the plan defines:
- Budgets (p95 latency target, throughput target, concurrency caps) and enforcement points
- Rollback/feature-flag strategy
- Readiness evaluation gates (No-Go/Go) with thresholds
- Storage policies (TTL/retention) and index strategy for high-volume logs

## Provenance Opinion Matrix

### Negative Factors (Reduce Confidence)

| Detail | Effect | Why |
|--------|--------|-----|
| "We'll log it later" | -15 | Guaranteed dark corners |
| Catch-all exception handling | -10 | Blurs blame, hides unknown states |
| No correlation id strategy | -20 | Thread cannot be reconstructed |
| Unbounded retries | -10 | Cascading failures and retry storms |
| Logging without loss detection | -8 | False confidence (silence looks like success) |

### Positive Factors (Increase Confidence)

| Detail | Effect | Why |
|--------|--------|-----|
| Schema-first telemetry | +10 | Stable, queryable, evolvable logs |
| Three-surface logging | +8 | Separates what happened, why, and context |
| Failure matrix + readiness gate | +10 | Produces action, not just traces |
| Circuit breaker + budgets | +8 | Prevents cascade; sets explicit limits |
| Telemetry loss counters | +6 | Makes missing data observable |

## Provenance Response Format (Plan Approval)

```
PROVENANCE APPROVAL:
- Thread Status: [INTACT/FRAYED/BROKEN]
- Thread Confidence: [0-100]
- Metrics Placed: [N] (list the top 3)
- Dark Corners: [N] (list them)

SCORES:
- Thread Integrity: X/10 (30%)
- Fail-Fast Boundaries: X/10 (25%)
- Auto-Documentation Quality: X/10 (25%)
- Operational Safety: X/10 (20%)

GUARDRAIL CHECK:
[✓/✗] No silent catches
[✓/✗] Correlation required
[✓/✗] Actionable error record (nextAction)
[✓/✗] Secrets never logged
[✓/✗] Time-bounded external work
[✓/✗] Circuit breaker present
[✓/✗] Telemetry loss detectable

FAIL-FAST TRIGGERS:
1. [Trigger] -> [What we record] -> [NextAction]
2. [Trigger] -> [What we record] -> [NextAction]

ACTIONABLE FAILURE RECORD (SCHEMA):
- what, where, when, who, correlationId, inputs(redacted), impact, nextAction

ASSESSMENT:
- [CLEAR/CONDITIONAL/BLOCKED]

IF CONDITIONAL/BLOCKED, REQUIRED ITERATIONS:
1. [Thread gap to close]
2. [Fail-fast boundary to define]
3. [Auto-doc field/action missing]

PREDICTED CONFIDENCE AFTER FIXES: [0-100]
```
