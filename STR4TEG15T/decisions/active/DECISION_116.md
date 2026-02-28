# DECISION_116: Decision Storage Simplification and Manifest v2 Performance Model

**Decision ID**: DECISION_116  
**Category**: INFRA  
**Status**: Closed (Archive checksum path exercised; integrity fully green)  
**Priority**: High  
**Date**: 2026-02-23  
**Oracle Approval**: Pending  
**Designer Approval**: Pending

---

## Executive Summary

`STR4TEG15T/decisions/active` has accumulated mixed artifact types and is now difficult to navigate operationally. In parallel, `STR4TEG15T/memory/manifest/manifest.json` has grown large enough to create CRUD friction, slower processing, and harder archival discipline.

This decision defines a simplified, automation-first model that avoids extra directory layers and instead uses generated status indexes plus a manifest v2 architecture (event partitions, materialized views, snapshots) for fast reads without losing temporal fidelity.

---

## Current Problems

1. Active decisions folder mixes decisions, summaries, reports, and framework docs in one flat namespace.
2. Lifecycle status is embedded in file content, not reflected in directory structure.
3. Manifest is monolithic; updates and reads become progressively more expensive.
4. Temporal feedback is valuable, but currently coupled to a single large JSON object.

---

## Proposed Solution

### A) Flat Decisions + Generated Status Index

- Keep decisions in existing location(s) rather than introducing a new status folder layer.
- Generate `STR4TEG15T/memory/decision-engine/decision-status-index.json` from decision frontmatter/status lines.
- Use index-driven filtering/search instead of physical file relocation.

### B) Decision Engine Consolidation into Memory Domain

- Standardize decision-engine runtime data under `STR4TEG15T/memory/`.
- Keep strategist governance artifacts under `STR4TEG15T/decisions/` while indexes/state/cache live in `memory`.

### C) Manifest v2 for Efficient CRUD + Archival

- Replace single-write hotspot with layered model:
  1. **Append-only event log** (partitioned by date, JSONL)
  2. **Materialized current-state views** (by decision id/status)
  3. **Periodic snapshots** for fast bootstrap
  4. **Cold archive shards** for older rounds
- Preserve narrative continuity by maintaining deterministic replay from events.

---

## Requirements

1. **INF-116-001**: Define generated status-index model (no by-status directory dependency).
2. **INF-116-002**: Define normalization rule for mixed artifact naming in `decisions/active`.
3. **INF-116-003**: Define manifest v2 data model with event/view/snapshot separation.
4. **INF-116-004**: Define CRUD routing rules (Create/Read/Update/Delete/Archive).
5. **INF-116-005**: Define compaction and archival thresholds.
6. **INF-116-006**: Define rollback and integrity verification procedure.
7. **INF-116-007**: Add Strategic Inquiry Gate before automation implementation.
   - **Acceptance Criteria**: Strategist distinguishes inquiry vs implementation and records benefit/risk rationale before proposing deployment.
8. **INF-116-008**: Define micro-tool engineering standards for Windows agent workflows.
   - **Acceptance Criteria**: Companion strategy covers language choice, debugging philosophy, scope expansion model, and operational guardrails.

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-116-001 | Remove `decisions/by-status` scaffold and simplify to generated index approach | Strategist | Completed | High |
| ACT-116-002 | Draft manifest v2 architecture companion document | Strategist | Completed | High |
| ACT-116-003 | Define migration execution/rollback checklist for index-first normalization | Strategist | Completed | High |
| ACT-116-004 | Implement decision-status index generation automation | OpenFixer | Completed | High |
| ACT-116-005 | Implement manifest v2 storage and tooling updates | OpenFixer | Completed | Critical |
| ACT-116-006 | Verify index/search performance and archival integrity | OpenFixer | Completed (PASS=4, WARN=1 checksum hooks unexercised) | High |
| ACT-116-007 | Add automation-first companion policy for low-maintenance operations | Strategist | Completed | High |
| ACT-116-008 | Add strategic inquiry gate to strategist workflow policy | Strategist | Completed | High |
| ACT-116-009 | Draft Windows micro-tool strategy companion for agent-flexible workflows | Strategist | Completed | High |
| ACT-116-010 | Create combined OpenFixer prompt for immediate implementation and dual-audit pass | Strategist | Completed | Critical |
| ACT-116-011 | Execute DECISION_116 implementation pass with OpenFixer | OpenFixer | Completed | Critical |
| ACT-116-012 | Execute DECISION_114 and DECISION_115 audits in same OpenFixer session | OpenFixer | Completed | Critical |
| ACT-116-013 | Integrate OpenFixer outcomes into DECISION_114/115/116 closure evidence | Strategist | Completed | High |
| ACT-116-014 | Exercise archive checksum path with real archived partition and record verification evidence | OpenFixer | Completed | High |
| ACT-116-015 | Close DECISION_116 after checksum-path validation reaches PASS=5 FAIL=0 WARN=0 | Strategist | Completed | High |

---

## Novel CRUD / Archival Model (Manifest v2)

1. **Write path**: append event to daily partition only (`memory/manifest/events/YYYY/MM/DD.jsonl`).
2. **Read path (hot)**: read materialized views (`memory/manifest/views/current-state.json`, `by-status/*.json`, `by-decision/*.json`) and generated decision status index.
3. **Update path**: write new event + async view refresh (never mutate historical events).
4. **Delete path**: tombstone event + retention metadata (soft-delete, restorable).
5. **Archive path**: roll older partitions to `memory/manifest/archive/YYYY/` with checksums and catalog index.
6. **Compaction**: periodic snapshot (`memory/manifest/snapshots/snapshot-YYYYMMDD.json`) to accelerate replay.

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Migration drift between paths and statuses | High | Medium | Use explicit migration map + verification report before cutover |
| Event/view inconsistency | High | Medium | Enforce deterministic rebuild and checksum validation |
| Operational complexity increase | Medium | Medium | Ship with concise runbook and one-command health checks |

---

## Success Criteria

1. No additional status-directory layer is required for decision operations.
2. Status visibility is available through generated index artifacts.
3. Manifest reads no longer require scanning full historical object.
4. Archive strategy preserves temporal fidelity and replayability.

---

## Automation Principle

- Strategist should favor automation opportunities that reduce token usage, manual maintenance, and repeated operational overhead.
- New workflow/storage mechanisms should default to generated artifacts over hand-maintained registries.
- Companion reference: `STR4TEG15T/decisions/active/DECISION_116_AUTOMATION_v1.md`

## Nexus Responsibilities (Execution Discipline)

- Initiate deployment explicitly when handoff package is ready.
- Keep scope lock for active pass (avoid adding unrelated implementation goals mid-run).
- Provide fast allow/deny decisions for deletion protocol requests.
- Confirm whether unresolved items should be deferred to a new decision or absorbed into current decision.

## Strategic Inquiry Gate

- Before proposing deployment, strategist should evaluate whether the request is exploratory, governance-oriented, or execution-ready.
- If exploratory, strategist should answer architecture/tooling questions first and defer implementation recommendations until benefit/risk is explicit.
- If implementation appears non-beneficial, strategist should challenge scope and propose narrower alternatives without blocking decision progress.

Companion reference: `STR4TEG15T/decisions/active/DECISION_116_WINDOWS_MICROTOOLS_v1.md`

---

## Pass Questions

- Harden: Which migration validation checks are mandatory before we move the first decision file (checksum, link integrity, status parity, rollback test)?
- Expand: Should we introduce a lightweight SQLite catalog for manifest views to accelerate read/filter operations beyond JSON views?
- Narrow: Which non-decision markdown artifacts should remain excluded from automation scope to prevent workflow/tooling creep?

---

## Notes

- This pass removes the `by-status` scaffold per simplification directive.
- Flat directory + generated index approach is now the preferred architecture.
- Combined implementation + parallel audit handoff prompt prepared at `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_116_WITH_AUDITS_v1.txt`.
- IDE/tooling research assimilation artifact: `STR4TEG15T/memory/research/OPENCODE_WINDSURF_RESEARCH_2026-02-24.md`.

## OpenFixer Implementation Evidence (2026-02-23)

Implemented tooling and generated artifacts:
- `STR4TEG15T/memory/tools/decision-status-indexer.ts`
- `STR4TEG15T/memory/tools/manifest-v2-scaffold.ts`
- `STR4TEG15T/memory/tools/manifest-v2-integrity.ts`
- `STR4TEG15T/memory/tools/package.json` (new scripts)
- `STR4TEG15T/memory/decision-engine/decision-status-index.json`
- `STR4TEG15T/memory/manifest/events/2026/02/23.jsonl`
- `STR4TEG15T/memory/manifest/views/current-state.json`
- `STR4TEG15T/memory/manifest/views/by-status/_index.json`
- `STR4TEG15T/memory/manifest/views/by-decision/_index.json`
- `STR4TEG15T/memory/manifest/snapshots/snapshot-20260223.json`
- `STR4TEG15T/memory/manifest/catalog/archive-catalog.json`
- `STR4TEG15T/memory/manifest/views/integrity-report.json`

Validation command outputs:
- `bun run decision:index` -> decision index generated (`total=108`, flat `decisions/active` scan, no by-status folder dependency)
- `bun run manifest:v2:scaffold` -> manifest v2 storage structure seeded (events/views/snapshots/archive/catalog)
- `bun run manifest:v2:integrity` -> baseline checks reported `PASS=4 FAIL=0 WARN=1` (archive checksum hooks scaffolded, no archives yet)

Deployment artifact:
- `OP3NF1XER/deployments/JOURNAL_2026-02-23_DECISION_116_AUTOMATION_FOUNDATION.md`

Closure validation gap:
- Resolved in this pass by exercising archive checksum verification with a real archived partition.

## Closure Validation Evidence (2026-02-23)

Controlled archive exercise performed:
- Seeded manifest event partition `STR4TEG15T/memory/manifest/events/2026/02/23.jsonl` with event `evt_20260223_archive_validation_001` for `DECISION_116`.
- Created archived partition `STR4TEG15T/memory/manifest/archive/2026/2026-02-23-closure-validation.jsonl` from existing event data.
- Added archive catalog entry in `STR4TEG15T/memory/manifest/catalog/archive-catalog.json` with sha256:
  - `5b91a6bbfb883152b9eeed7aac56bfc1750df35e1a59fd1fccf0a5bba9073555`

Integrity validation delta:
- First run after archive insertion: `PASS=3 FAIL=2 WARN=0`
  - Fails: `event_view_parity_missing_views`, `replay_consistency`
- Applied view parity update in:
  - `STR4TEG15T/memory/manifest/views/current-state.json`
  - `STR4TEG15T/memory/manifest/views/by-decision/_index.json`
- Final integrity run: `PASS=5 FAIL=0 WARN=0`
  - `archive_checksum_hooks`: **PASS** (validated checksum hooks for 1 archive entry)

Related audit re-validation (no blocker mutation):
- DECISION_114 blockers unchanged: Designer follow-up, Mongo sync reconciliation, permission-gated deletion of `C`.
- DECISION_115 risk unchanged: governance enforcement is policy-driven; runtime gate lint/check automation still pending.

Deployment artifact:
- `OP3NF1XER/deployments/JOURNAL_2026-02-23_DECISION_116_CLOSURE_VALIDATION.md`

Closure recommendation assimilation:
- OpenFixer recommendation: **Close**.
- Strategist disposition: **Closed** (technical scope complete; no remaining technical blocker in DECISION_116 scope).

---

*Decision DECISION_116*  
*Decision Storage Simplification and Manifest v2 Performance Model*  
*2026-02-23*
