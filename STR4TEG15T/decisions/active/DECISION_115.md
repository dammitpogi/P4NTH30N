# DECISION_115: Deployment-Phase Decision Governance and Self-Improvement Gate

**Decision ID**: DECISION_115  
**Category**: FORGE  
**Status**: Closed (No FAIL governance lint checks; parity clean; non-blocking PARTIAL tracked)  
**Priority**: High  
**Date**: 2026-02-23  
**Oracle Approval**: Pending  
**Designer Approval**: Pending

---

## Executive Summary

This decision formalizes how strategist decisions are handled during deployment phases and introduces a self-improvement gate so critical refinement questions and closure criteria are generated before handoff, not after.

The immediate trigger is DECISION_114, where a post-handoff improvement request exposed a sequencing gap: pre-deployment hardening questions and close-checklist drafting should have been mandatory before OpenFixer activation.

**Current Problem**:
- Deployment handoff can occur before refinement questions are fully surfaced.
- Closure checklist drafting is currently discretionary instead of mandatory pre-handoff output.
- Ongoing deployment deltas are not consistently normalized into versioned decision artifacts.

**Proposed Solution**:
- Add a pre-handoff governance gate requiring harden/expand/narrow questions and explicit answers or deferrals.
- Require a closure checklist artifact before any handoff is marked `HandoffReady`.
- Standardize deployment-phase status transitions and delta-handling rules.
- Add self-improvement rule: strategist auto-generates these artifacts each pass.
- Add a Nexus-initiated deployment gate: strategist may draft handoff materials, but must not initiate deployment without explicit Nexus instruction.

---

## Background

### Current State

DECISION_114 established strong strategist workflow controls, but this pass identified a timing issue: governance improvements were added after handoff packaging rather than as a blocking pre-handoff gate.

### Desired State

Before any deployment handoff is activated, strategist must produce:
1) pre-handoff scope-hardening question set,
2) closure checklist draft,
3) deployment-phase delta policy.

Handoff proceeds only when these artifacts are present and linked.

---

## Specification

### Requirements

1. **DEP-115-001**: Pre-Handoff Question Gate
   - **Priority**: Must
   - **Acceptance Criteria**: Decision includes at least one harden, one expand, and one narrow question before `HandoffReady`.

2. **DEP-115-002**: Pre-Handoff Closure Checklist Draft
   - **Priority**: Must
   - **Acceptance Criteria**: A closure checklist section exists in active decision or linked companion doc before handoff activation.

3. **DEP-115-003**: Deployment-Phase Status Model
   - **Priority**: Must
   - **Acceptance Criteria**: Decision lifecycle supports `Proposed -> Approved -> HandoffReady -> Deploying -> Validating -> Closed` with evidence gates.

4. **DEP-115-004**: Deployment Delta Handling Rule
   - **Priority**: Must
   - **Acceptance Criteria**: Mid-deployment scope changes require versioned companion decision files and explicit linkage to parent decision.

5. **DEP-115-005**: Self-Improvement Automation Rule
   - **Priority**: Must
   - **Acceptance Criteria**: Strategist process text requires automatic generation of gate questions + closure checklist for each new deployment handoff.

6. **DEP-115-006**: OpenFixer Reporting Contract for Decision Governance
   - **Priority**: Must
   - **Acceptance Criteria**: OpenFixer reports include policy parity checks, unresolved governance gaps, and closure readiness recommendation.

7. **DEP-115-007**: Nexus-Initiated Deployment Trigger
   - **Priority**: Must
   - **Acceptance Criteria**: Strategist does not proceed with handoff/deployment procedures automatically; strategist requests Nexus initiation after presenting rationale and readiness state.

8. **DEP-115-008**: OpenFixer Prompt Standard Upgrade
   - **Priority**: Must
   - **Acceptance Criteria**: `C:\Users\paulc\.config\opencode\agents\openfixer.md` includes required governance report sections (decision parity matrix, file-level diffs, deployment usage guidance, triage/repair runbook, closure recommendation).

9. **DEP-115-009**: One-Pass Audit Interrogation Contract
   - **Priority**: Must
   - **Acceptance Criteria**: Strategist provides a consolidated single-prompt audit request that minimizes handoffs while extracting implementation deltas, operational playbook, and future-decision adoption guidance.

10. **DEP-115-010**: Structured Conversation Contract
   - **Priority**: Must
   - **Acceptance Criteria**: Strategist requests to Nexus use numbered questions with lettered choices and recommended defaults, including mode + decision id + status context for compaction resilience.

11. **DEP-115-011**: Copy-Paste Prompt Delivery Contract
   - **Priority**: Must
   - **Acceptance Criteria**: Any strategist request for Nexus to run a prompt includes a full copy-paste prompt block in-message and corresponding prompt file reference in decision artifacts.

12. **DEP-115-012**: Developmental Learning Capture Contract
   - **Priority**: Must
   - **Acceptance Criteria**: Decision updates treat all execution as developmental; learning deltas and workflow improvements are captured in decision artifacts as system egress.

13. **DEP-115-013**: OpenFixer Prompt Parity Across Runtime and Repository
   - **Priority**: Must
   - **Acceptance Criteria**: `C:\Users\paulc\.config\opencode\agents\openfixer.md` and `C:\P4NTHE0N\agents\openfixer.md` stay aligned on governance standards, Nexus-initiation gate, and report contract requirements.

14. **DEP-115-014**: Automatic OpenFixer Prompt Parity Check
   - **Priority**: Must
   - **Acceptance Criteria**: Governance lint automatically checks prompt parity each pass and reports drift without requiring explicit Nexus request.

15. **DEP-115-015**: Canonical Pre-Handoff Question Tokens
   - **Priority**: Must
   - **Acceptance Criteria**: Decision artifacts use exact marker tokens `Harden:`, `Expand:`, and `Narrow:` for lint-compatible pre-handoff question detection.

16. **DEP-115-016**: Permission Provenance Requirement
   - **Priority**: Must
   - **Acceptance Criteria**: Destructive-action audit passes require OpenCode-originated ask-permission evidence, not strategist-only confirmation text.

### Technical Details

**Decisions in Scope**:
- `STR4TEG15T/decisions/active/DECISION_114.md`
- `STR4TEG15T/decisions/active/DECISION_115.md`

**Policy Targets**:
- `C:\Users\paulc\.config\opencode\agents\strategist.md`

**Companion Governance Artifact**:
- `STR4TEG15T/decisions/active/DECISION_115_DEPLOYMENT_GOVERNANCE_v1.md`

**OpenFixer Activation Prompt**:
- `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_115_v1.txt`

**OpenFixer Audit Prompt**:
- `STR4TEG15T/handoffs/AUDIT_OPENFIXER_DECISION_114_115_v1.txt`

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-115-001 | Add deployment-phase status model and gating rules to strategist prompt | OpenFixer | Completed | High |
| ACT-115-002 | Add mandatory pre-handoff questions + closure checklist generation rule | OpenFixer | Completed | High |
| ACT-115-003 | Add deployment delta handling policy (versioned companion decision rule) | OpenFixer | Completed | High |
| ACT-115-004 | Add OpenFixer governance reporting contract template | OpenFixer | Completed | Medium |
| ACT-115-005 | Update DECISION_114 with closure checklist block once OpenFixer returns | Strategist | Completed | High |
| ACT-115-006 | Add explicit manual Nexus deployment-initiation gate to strategist workflow policy | Strategist | Completed | High |
| ACT-115-007 | Create consolidated OpenFixer audit prompt for cache-window interrogation | Strategist | Completed | Critical |
| ACT-115-008 | Update OpenFixer agent prompt standard to require governance-grade completion reports | OpenFixer | Completed | High |
| ACT-115-009 | Implement runtime pre-handoff governance lint/check automation (enforce checklist/question completeness) | OpenFixer | Completed | High |
| ACT-115-010 | Add structured conversation protocol to strategist workflow policy | Strategist | Completed | High |
| ACT-115-011 | Extend governance lint to validate structured ask format (numbered questions + lettered choices + default) | OpenFixer | Completed | High |
| ACT-115-012 | Add copy-paste prompt delivery standard to strategist policy and decision governance | Strategist | Completed | High |
| ACT-115-013 | Add developmental learning-capture language to strategist policy and decision governance | Strategist | Completed | High |
| ACT-115-014 | Align repository OpenFixer agent prompt with runtime OpenFixer governance standard | Strategist | Completed | High |
| ACT-115-015 | Add automatic parity-check rule to governance lint scope (no request-needed trigger) | Strategist | Completed | High |
| ACT-115-016 | Implement automatic parity-check execution in governance lint toolchain | OpenFixer | Completed | High |
| ACT-115-017 | Remediate governance lint failures (structured ask prompt artifacts + runtime OpenFixer parity drift) | Strategist/OpenFixer | Completed | High |
| ACT-115-018 | Normalize pre-handoff question markers to canonical lint tokens (`Harden:`, `Expand:`, `Narrow:`) | Strategist | Completed | High |
| ACT-115-019 | Re-run governance lint after token normalization and record final closure recommendation | OpenFixer | Completed | High |
| ACT-115-020 | Align `structured_recommended_default_per_question` heuristic with structured ask style (or formalize PARTIAL as non-blocking) | Strategist/OpenFixer | Pending (Non-blocking follow-up) | Medium |
| ACT-115-021 | Execute closure-validation evidence consolidation pass and issue final recommendation | OpenFixer | Completed | High |

---

## Deployment-Phase Governance Rules

1. A decision cannot move to `HandoffReady` unless pre-handoff question gate is present.
2. A closure checklist draft must exist before handoff activation.
3. Any deployment-phase scope expansion must create a versioned companion decision file.
4. Strategic governance deltas discovered during deployment are logged as decision updates, not hidden in deployment journals only.
5. Closure requires explicit `Closed` recommendation from deployment report evidence.
6. Strategist may prepare handoff artifacts, but deployment activation occurs only when Nexus explicitly initiates.
7. Audit interrogation should prioritize one comprehensive prompt before session cache cools.
8. Governance prompts to Nexus should be structured with numbered questions and lettered options.
9. Handoff/deployment prompts requested from Nexus should always be delivered as direct copy-paste blocks and recorded by path.
10. Governance updates should capture developmental learning and system-improvement deltas in decisions as primary egress.
11. OpenFixer prompt parity drift must be checked automatically during governance lint passes.
12. Pre-handoff question markers should use canonical tokens (`Harden:`, `Expand:`, `Narrow:`) for lint determinism.

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Added governance steps slow urgent deployments | Medium | Medium | Use concise gate templates and keep questions to minimum viable set |
| Checklist quality drifts across decisions | Medium | Medium | Standardize checklist skeleton in companion governance file |
| OpenFixer reports focus on execution but miss governance parity | High | Medium | Add required governance parity section to completion report contract |

---

## Success Criteria

1. New deployment handoffs include pre-handoff scope questions by default.
2. Closure checklist exists before each handoff activation.
3. Deployment-phase deltas are captured in versioned decision companions.
4. OpenFixer reports contain closure readiness recommendation and governance parity evidence.
5. No automatic deployment initiation occurs without explicit Nexus trigger.
6. OpenFixer prompt standard is upgraded to support repeatable audit-quality reporting.
7. Strategist conversational requests are structured and compaction-resilient.
8. OpenFixer prompt parity is auto-checked each governance lint pass without explicit request.

---

## Token Budget

- **Estimated**: 14K tokens
- **Model**: Claude 3.5 Sonnet (OpenFixer)
- **Budget Category**: Routine (<50K)

---

## Handoff Contract (Fixer)

**Target Agent**: OpenFixer  
**Scope**: Governance/process updates only

**Files To Modify**:
- `C:\Users\paulc\.config\opencode\agents\strategist.md`
- `STR4TEG15T/decisions/active/DECISION_114.md` (closure checklist block update after governance pass)

**Files To Create/Update**:
- `STR4TEG15T/decisions/active/DECISION_115_DEPLOYMENT_GOVERNANCE_v1.md`
- `OP3NF1XER/deployments/JOURNAL_YYYY-MM-DD_DECISION_115_DEPLOYMENT_GOVERNANCE.md`

**Validation Specs**:
1. Strategist prompt includes automatic pre-handoff gate generation rule.
2. Decision governance model includes deployment-phase statuses.
3. Delta handling rule enforces versioned companion decision files.
4. OpenFixer report includes closure readiness recommendation.

---

## Notes

- This decision is a direct governance follow-on to DECISION_114.
- It resolves sequencing debt: pre-handoff refinement and closure drafting must occur before deployment activation.
- Deployment prompts are preparation artifacts; strategist must request Nexus initiation before any active handoff execution.
- This pass extends scope to include OpenFixer prompt-standard hardening for audit completeness.
- Decision storage/manifest scaling concerns are delegated to `STR4TEG15T/decisions/active/DECISION_116.md`.
- Nexus routing preference for discovered gaps: keep additions in `DECISION_115` unless explicitly re-scoped.

## OpenFixer Audit Evidence (2026-02-23)

Policy hardening completed in:
- `C:\Users\paulc\.config\opencode\agents\strategist.md`
  - Added deployment-phase lifecycle gate (`Proposed -> Approved -> HandoffReady -> Deploying -> Validating -> Closed`).
  - Added explicit pre-handoff gate requirements (harden/expand/narrow with answer/deferral + closure checklist draft).
  - Added decision-writeback requirement for governance deltas discovered during deployment.
- `C:\Users\paulc\.config\opencode\agents\openfixer.md`
  - Added manual Nexus-initiation execution rule for deployment packages.
  - Added governance report standard sections (parity matrix, file-level diffs, usage guidance, triage/repair runbook, closure recommendation).

Audit follow-up artifact:
- `OP3NF1XER/deployments/JOURNAL_2026-02-23_DECISION_115_AUDIT_FOLLOWUP.md`

Audit recommendation assimilation:
- Recommendation: keep DECISION_115 in `Iterate` until final closure pass confirms integration evidence across DECISION_114/115/116.
- Remaining gap: enforcement now has runtime lint/check automation, but policy/content remediation is still required for failing lint checks (ACT-115-017).

## Governance Lint Automation Evidence (2026-02-24)

Implemented runtime lint utility:
- `STR4TEG15T/memory/tools/governance-lint.ts`
- `STR4TEG15T/memory/tools/package.json` (`governance:lint` script)

Automatic parity artifact (generated each lint run):
- `STR4TEG15T/memory/decision-engine/openfixer-prompt-parity.json`

Governance lint report artifact:
- `STR4TEG15T/memory/decision-engine/governance-lint-report.json`

Deployment report artifact:
- `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_115_GOVERNANCE_LINT.md`

Latest lint summary (`bun run governance:lint`):
- `PASS=3 PARTIAL=1 FAIL=6 OVERALL=FAIL`

Observed failing categories:
- Pre-handoff governance completeness checks for harden/expand/narrow question presence.
- Structured ask enforcement checks for lettered choices and explicit mode/decision/status header in the checked strategist-facing prompt artifact.
- Runtime/repository OpenFixer parity drift in `Developmental Learning Capture` section.

Decision recommendation after lint deployment:
- Keep DECISION_115 in `Iterate` until ACT-115-017 remediation clears lint failures.

## Lint Remediation Pass (2026-02-24)

Mode: Decision  
Decision: DECISION_115  
Status: Iterating

Harden:
- How do we prevent regressions where governance checks pass in policy but fail in runtime artifacts?
  - a) enforce lint in CI and block `HandoffReady` on FAIL
  - b) run lint manually each pass
  - Recommended default: a

Expand:
- Should governance lint include cross-file policy coherence checks (strategist/openfixer prompts + decision artifact schema)?
  - a) yes, include coherence checks in next lint increment
  - b) no, keep current lint scope
  - Recommended default: a

Narrow:
- Should DECISION_115 closure depend only on governance lint and parity checks, deferring broader workflow ergonomics?
  - a) yes, narrow to lint/parity closure gates
  - b) no, include additional ergonomics improvements before close
  - Recommended default: a

Closure checklist draft:
- [x] Runtime governance lint utility implemented.
- [x] Automatic OpenFixer prompt parity check implemented.
- [x] Runtime OpenFixer `Developmental Learning Capture` section restored for parity.
- [ ] Re-run `bun run governance:lint` and confirm PASS/PARTIAL/FAIL target meets closure threshold.
- [ ] Record updated lint artifact and deployment journal evidence.

## Governance Lint Verification Pass (2026-02-24)

Execution command:
- `bun run governance:lint` (from `STR4TEG15T/memory/tools`)

Latest lint summary:
- `PASS=6 PARTIAL=1 FAIL=3 OVERALL=FAIL`

Remediation confirmation for prior FAIL categories:
- Structured lettered choices: **PASS**
- Mode/Decision/Status header: **PASS**
- OpenFixer parity (`Developmental Learning Capture`): **PASS**
- Harden/Expand/Narrow question presence checks: **FAIL** (tool requires exact `Harden:`, `Expand:`, `Narrow:` tokens; current section uses `Harden question:`, `Expand question:`, `Narrow question:`)

Updated artifacts:
- `STR4TEG15T/memory/decision-engine/governance-lint-report.json`
- `STR4TEG15T/memory/decision-engine/openfixer-prompt-parity.json`
- `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_115_GOVERNANCE_LINT_REMEDIATION.md`

Closure readiness recommendation:
- Keep `DECISION_115` in `Iterate` until ACT-115-017 resolves remaining three pre-handoff question-token failures.

Token normalization applied in this pass:
- Pre-handoff markers updated to canonical lint tokens: `Harden:`, `Expand:`, `Narrow:`.
- Next gate: re-run governance lint to confirm FAIL count reaches zero before closure transition.

Updated checklist status:
- [x] Re-run `bun run governance:lint` and capture updated PASS/PARTIAL/FAIL evidence.
- [x] Record updated lint artifacts and remediation deployment journal.
- [ ] Resolve exact harden/expand/narrow lint token requirements or adjust lint rule semantics by approved governance change.

## Governance Lint Final Verification (2026-02-24)

Execution command:
- `bun run governance:lint` (from `STR4TEG15T/memory/tools`)

Final lint summary:
- `PASS=9 PARTIAL=1 FAIL=0 OVERALL=PARTIAL`

Canonical marker check results:
- `Harden:` -> **PASS**
- `Expand:` -> **PASS**
- `Narrow:` -> **PASS**

Parity check result:
- OpenFixer runtime/repository parity -> **PASS** (including `Developmental Learning Capture`)

Remaining partial item:
- `structured_recommended_default_per_question` remains `PARTIAL` because heuristic count uses numbered-question lines ending with `?`; current pre-handoff prompt style records defaults but not numbered `?` decision-point lines.

Artifacts updated:
- `STR4TEG15T/memory/decision-engine/governance-lint-report.json`
- `STR4TEG15T/memory/decision-engine/openfixer-prompt-parity.json`
- `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_115_GOVERNANCE_LINT_FINAL.md`

Recommendation:
- Move DECISION_115 to `HandoffReady`; closure can proceed after Strategist accepts PARTIAL as non-blocking or refines heuristic/prompt format for full PASS.

Strategist disposition:
- Accepted current `PARTIAL` as non-blocking for handoff readiness.
- Decision remains `HandoffReady`.
- Heuristic alignment follow-up tracked as ACT-115-020.

## Closure Validation Consolidation (2026-02-24)

Verification against final artifacts:
- `STR4TEG15T/memory/decision-engine/governance-lint-report.json`
- `STR4TEG15T/memory/decision-engine/openfixer-prompt-parity.json`
- `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_115_GOVERNANCE_LINT.md`
- `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_115_GOVERNANCE_LINT_REMEDIATION.md`
- `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_115_GOVERNANCE_LINT_FINAL.md`

Consolidated results:
- Governance lint contains **no FAIL checks** (`PASS=9 PARTIAL=1 FAIL=0 OVERALL=PARTIAL`).
- OpenFixer prompt parity remains **PASS** with empty diff summary.
- PARTIAL handling is documented as **non-blocking** and explicitly tracked by `ACT-115-020`.

Closure readiness disposition:
- Decision is closure-ready from governance enforcement perspective.
- Remaining `ACT-115-020` item is an optimization/improvement follow-up, not a closure blocker.
- Final recommendation from this pass: **Close DECISION_115**.

Strategist closure decision:
- DECISION_115 is now set to `Closed`.
- `ACT-115-020` remains as a non-blocking optimization follow-up for future governance lint refinement.

---

*Decision DECISION_115*  
*Deployment-Phase Decision Governance and Self-Improvement Gate*  
*2026-02-23*
