---
type: decision
id: DECISION_096
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.843Z'
last_reviewed: '2026-02-23T01:31:15.843Z'
keywords:
  - oracle
  - assimilation
  - report
  - decision096
  - rag
  - consultation
  - status
  - prime
  - directive
  - approval
  - analysis
  - weighted
  - detail
  - scoring
  - guardrail
  - check
  - applicable
  - subset
  - level
  - risks
roles:
  - librarian
  - oracle
summary: >-
  # Oracle Assimilation Report: DECISION_096 This report is produced by
  Strategist (Pyxis) while assimilating Oracle (Orion) behavior per
  `c:\Users\paulc\.config\opencode\agents\oracle.md`. ## RAG Consultation Status
  (Prime Directive) - Required: query `rag-server.rag_query` for similar
  decisions and risk patterns before approval. - Limitation: this session does
  not have ToolHive gateway call access to execute `rag_query`/`rag_ingest`. -
  Compensating controls used: - Reviewed local instituti
source:
  type: decision
  original_path: ../../../STR4TEG15T/consultations/oracle\DECISION_096_oracle.md
---

# Oracle Assimilation Report: DECISION_096

This report is produced by Strategist (Pyxis) while assimilating Oracle (Orion) behavior per `c:\Users\paulc\.config\opencode\agents\oracle.md`.

## RAG Consultation Status (Prime Directive)

- Required: query `rag-server.rag_query` for similar decisions and risk patterns before approval.
- Limitation: this session does not have ToolHive gateway call access to execute `rag_query`/`rag_ingest`.
- Compensating controls used:
  - Reviewed local institutional artifacts: `STR4TEG15T/decisions/active/DECISION_096.md`, ToolHive gateway docs/implementation in repo (ToolHive-native patterns, transports, and health).
  - Anchored risks/mitigations to already-documented incidents and to MCP spec constraints (HTTP/SSE origin validation, localhost binding).

Action to restore compliance: once ToolHive tool calling is available, run `rag_query` for: "DECISION_096 rebuild mcp framework docker sse" and ingest this report as `type=approval`.

---

## APPROVAL ANALYSIS

- Overall Approval Percentage: 85% (Conditional Approval)
- Feasibility Score: 7/10 (30% weight)
- Risk Score: 8/10 (30% weight)
- Implementation Complexity: 8/10 (20% weight)
- Resource Requirements: 8/10 (20% weight)

Calculation (per Oracle rubric):

`50 + (7×3) + ((10-8)×3) + ((10-8)×2) + ((10-8)×2) = 85`

### WEIGHTED DETAIL SCORING

Positive Factors:
- + Circuit breaker pattern explicitly planned: reduces cascading failures.
- + Structured health/readiness endpoints (`/health`, `/ready`) in design: supports ToolHive gateway stability.
- + Clear separation of concerns (framework vs servers) reduces long-term maintenance.
- + Explicit migration (blue/green) reduces operational blast radius.

Negative Factors:
- - Framework-first introduces a single shared failure surface across 3 critical services.
- - Rebuild scope is large (3 servers + shared framework + caching layer): schedule slip risk.
- - SSE transport introduces security requirements (Origin validation, bind to 127.0.0.1) that are easy to get subtly wrong.
- - Advanced caching (two-stage semantic cache + grouping/prefetch) increases correctness and observability burden.

### GUARDRAIL CHECK (Applicable Subset)

- [✓] Fallback strategy exists (blue/green + rollback to v1)
- [✓] Circuit breaker requirement captured in plan
- [~] Benchmarking requirement: load tests specified, but hard metrics per tool should be pinned early (p95, error budget) and enforced as gates
- [~] DLQ/manual intervention: implied in rollback/runbooks; must be explicit for failed ingests and failed cache validations
- [N/A] Model ≤1B params: not a core dimension of this decision (server rebuild)

### APPROVAL LEVEL

Conditional Approval (70-89%). Proceed only with the iteration guidance below implemented as non-negotiable gates.

---

## RISKS IDENTIFIED

HIGH SEVERITY:

1) Shared framework regression
- Impact: all three servers become unhealthy simultaneously; ToolHive gateway loses major tool surfaces.
- Probability: Medium
- Mitigation:
  - Contract tests at framework boundary (MCP initialize/tools/list/tools/call + SSE endpoints)
  - Per-server integration tests pinned to known tool schemas
  - Server pinning to a framework commit/tag for deployment

2) HTTP/SSE security misconfiguration
- Impact: DNS rebinding exposure or unwanted remote access.
- Probability: Medium
- Mitigation:
  - Enforce localhost bind (127.0.0.1)
  - Strict Origin validation
  - Explicit CORS policy (deny by default)
  - Optional auth token for POST endpoint

3) Migration/cutover instability
- Impact: downtime, partial tool availability, corrupt state.
- Probability: Medium
- Mitigation:
  - Blue/green with staged traffic increase and auto-rollback threshold
  - Data compatibility tests (read/write parity against v1)
  - Backups before switching ToolHive gateway routing

MEDIUM SEVERITY:

4) Two-stage semantic cache correctness drift
- Impact: stale/incorrect retrieval results, misleading agent behavior.
- Probability: Medium
- Mitigation:
  - Category-aware TTLs; explicit cache-bypass flag
  - Cache hit auditing (log hit/miss, similarity score, category)
  - Deterministic fallback to fresh retrieval on any validation uncertainty

5) Query grouping/prefetch bugs
- Impact: tail latency improvements offset by correctness issues or memory spikes.
- Probability: Medium
- Mitigation:
  - Feature flag defaults off
  - Tight batching windows and hard memory limits
  - Observability for queue depth, batch sizes, eviction rates

LOW SEVERITY:

6) Tool ergonomics regressions
- Impact: agents fail tool selection; increased token burn.
- Probability: Medium
- Mitigation:
  - Tool naming conventions + schemas + examples
  - Maintain old tool aliases for one deprecation window where feasible

---

## VALIDATION RECOMMENDATIONS (Gates)

1) Framework Gate (before any server rebuild work):
- Prove MCP compliance over HTTP/SSE (initialize + tools/list + tools/call) and transport invariants (no non-JSON-RPC on message channel).

2) Server Gate (per server):
- Readiness requires dependency check: MongoDB connectivity for decisions/mongodb server; vector store + embedding model availability for RAG.

3) Cutover Gate:
- Blue/green: 10% → 50% → 100% with rollback on error-rate >1% (or more strict if baseline is better).

4) Observability Gate:
- Correlation ID required on every request log.
- Metrics: request count, latency, errors; plus cache hit ratio (RAG).

---

## ITERATION GUIDANCE (What Must Change for Full Approval)

1) Add explicit "framework regression containment" plan: version pinning + compatibility tests + rollback path.
2) Make HTTP/SSE security requirements concrete in acceptance criteria (localhost bind, Origin validation, auth story).
3) Make DLQ/manual intervention explicit for:
   - failed document ingests (RAG)
   - failed cache validations
   - failed schema validations
4) Reduce initial v2 scope by defaulting the following behind feature flags:
   - query grouping/prefetch
   - cross-encoder reranking
   - vector-store multi-backend migration tooling

Predicted approval after these changes (and after RAG validation pass): 90-93%.

---

## Notes

- This approval is issued under Oracle assimilation and is not RAG-backed due to tool access limits.
- Designer Round 1 and Round 2 architecture guidance is aligned with this risk posture (framework local module, phased rollout, feature flags).
