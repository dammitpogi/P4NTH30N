---
type: decision
id: DECISION_136
category: FORGE
status: blocked
version: 1.0.1
created_at: '2026-02-24T21:26:00Z'
last_reviewed: '2026-02-26T22:00:00Z'
blocked_reason: Superseded by deployment focus (DECISION_164/165/168)
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md
---
# DECISION_136: OpenClaw External Codebase Audit Kickoff (Alma Peer Maintainer) - BLOCKED

**Decision ID**: DECISION_136  
**Mode**: Decision  
**Mission Shape**: External Codebase Audit  
**Lifecycle**: **BLOCKED**  
**Blocked Reason**: Deployment focus (DECISION_164/165/168) takes priority  
**Date**: 2026-02-24  
**Last Reviewed**: 2026-02-26

## Workflow Enforcement Delta

- Nexus directive integrated: strategist continues autonomously and does not pause for confirmation when scope is actionable and non-destructive.
- This decision is now the active execution contract for OpenClaw inspection prep and will be expanded in-place with actionable items each pass.
- OpenCode continuation hardening integrated: provide concise updates while continuing autonomous execution in the same pass.

## Intake

- Nexus requested External Codebase Audit mode for OpenClaw maintained by Alma.
- Hard gate enforced: synthesis completion before any new OpenClaw inspection planning.
- Prior Nate/OpenClaw memory assimilation completed across decisions, journals, and deployment artifacts.

## Frame (Bounded Scope)

1. **Objective**: Produce a two-lens OpenClaw inspection package (`System Correctness` + `Change Governance`) with peer-respect posture toward Alma, including a usability expansion lane for "stock stuff" so Alma can operate it faster and Nate can use a broader capability surface.
2. **Constraints**: No destructive actions, no implementation edits, no deployment actions, no subagent delegation in this pass.
3. **Evidence Targets**: Decision/journal/deployment artifacts from the 2026-02-23 to 2026-02-24 Nate/OpenClaw incident chain plus current OpenClaw codebase state when inspection begins, with explicit stock-flow discoverability and operator UX friction evidence.
4. **Risk Ceiling**: Medium - advisory recommendations only until boundary map is explicit and validated.
5. **Finish Criteria**: Boundary map complete, fact/assumption/question separation complete, staged reversible remediation plan drafted, and a usability expansion matrix for Alma/Nate stock workflows defined.

## Scope Delta (Nexus Addendum)

- New requirement captured: "look at stock stuff," "make it easier for Alma to use," and "more expansive for Nate to utilize."
- Strategist interpretation for audit mode:
  - `Alma Ease`: reduce cognitive/operator friction in stock-related paths (discoverability, runbook clarity, safer defaults, error transparency).
  - `Nate Expansion`: widen usable operational surface for stock workflows (clear extension points, non-destructive capability tiers, staged unlock roadmap).
- Delivery shape in inspection outputs:
  - `Lens A` must include stock runtime correctness and failure-boundary checks.
  - `Lens B` must include stock workflow governance, release/rollback posture, and ownership clarity.
  - Recommendations must be staged and reversible before any implementation handoff.

## Alma Interop Notes

### Confirmed Facts

- OpenClaw outage sequence and constrained recovery were journaled with ordered evidence.
- Rollback succeeded at control plane but did not recover runtime in that pass.
- Dependency ladder was observed (`OPENAI_API_KEY` blocker, then `GEMINI_API_KEY` blocker), and gateway reached healthy state after sequential dependency removal.

### Inferred Assumptions

- Save-time config validation likely allows unresolved env interpolation to persist into runtime-critical paths.
- Residual transient `502` under rapid probing may be warm-up or remaining instability, not conclusively classified yet.

### Open Questions for Alma/Human Maintainer

1. What is the intended authoritative runtime config path and state-dir contract (`/data/.clawdbot` vs `/data/.openclaw`)?
2. Should provider blocks permit missing `apiKey` interpolation at save-time when provider is not active in selected model route?
3. What restart semantics are expected from setup config saves, and how should restart idempotency be observed?

## Consultation Status

- Oracle: Deferred in this pass per Nexus directive (no subagent delegation).
- Designer: Deferred in this pass per Nexus directive (no subagent delegation).
- Risk posture while deferred: use stricter guardrails and advisory-only planning.

## Actionable Work Contract (Immediate)

1. Build explicit boundary map for OpenClaw inspection (`inspectable`, `changeable`, `advisory-only`).
2. Produce `Lens A` checklist for stock/runtime correctness focused on operator outcomes for Alma.
3. Produce `Lens B` checklist for stock/change governance focused on utilization expansion for Nate.
4. Draft reversible recommendation tiers (`Tier 0 doc/ops`, `Tier 1 config-safe`, `Tier 2 staged code-change advisory`).
5. Publish stock usability expansion matrix (`Alma Ease`, `Nate Expansion`) with measurable acceptance checks.

## Boundary Map v1 (External Audit Guardrail)

- `Inspectable`:
  - OpenClaw repository structure, config contracts, startup/runtime paths, health endpoints, logs, docs, release notes, and operational runbooks.
  - Prior incident evidence chain across strategist memory and deployment journals.
- `Changeable` (strategy artifacts only in this phase):
  - Decision files, audit checklists, governance recommendations, staged remediation plans, handoff contracts.
- `Advisory-only` (no direct mutation by strategist in this phase):
  - External OpenClaw runtime state, production configuration, deployment operations, Alma-owned source implementation.

## Lens A: System Correctness Checklist (Stock + Runtime)

1. Runtime bootstrap path is deterministic (state dir + config path + startup dependencies).
2. Health endpoint truth aligns with gateway truth (no wrapper-only false positives).
3. Stock workflow entry points are discoverable and failure-transparent for Alma operators.
4. Stock data paths and fallback behavior are documented and probeable.
5. Residual transient failure profile (`502`/timeouts) is classified (warm-up vs instability).

## Lens B: Change Governance Checklist (Stock + Expansion)

1. Save-time config validation policy blocks unresolved env interpolation for active dependencies.
2. Release discipline includes one-provider-at-a-time rollout with preflight contracts.
3. Rollback semantics and limits are explicit (control-plane rollback vs runtime recovery expectations).
4. Ownership map is explicit (Alma-maintained zones vs advisory zones).
5. Nate expansion path is tiered, reversible, and auditable.

## Usability Expansion Matrix v1

- `Alma Ease`:
  - Goal: lower operator friction on stock-related execution.
  - Acceptance checks: single-runbook flow, explicit error decoding, safe defaults, one-command observability checks.
- `Nate Expansion`:
  - Goal: broaden usable stock capabilities without destabilizing runtime.
  - Acceptance checks: extension points cataloged, tiered capability unlocks, rollback-ready change packets, usage guidance per tier.

## Routes (Primary + Fallback)

- Primary route: evidence-led inspection package from boundary map -> Lens A/B audit -> staged advisory recommendations.
  - Validation commands:
    - `python -c "import json; json.load(open(r'C:\\P4NTH30N\\STR4TEG15T\\memory\\manifest\\manifest.json', encoding='utf-8')); print('manifest ok')"`
    - `grep -R "OpenClaw|stock|stateDir|configPath|gateway.reachable" STR4TEG15T/memory OP3NF1XER/deployments`
- Fallback route: governance-first pass if codebase visibility is incomplete; produce risk-rated advisory backlog and explicit evidence gaps.
  - Validation commands:
    - `grep -R "MissingEnvVarError|OPENAI_API_KEY|GEMINI_API_KEY|rollback" OP3NF1XER/deployments`
    - `grep -R "Alma Ease|Nate Expansion|Boundary Map" STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md`

## Audit Matrix (Current Pass)

- Requirement: External audit mode activated with peer-maintainer posture -> `PASS`
  - Evidence: `STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md`
- Requirement: Stock usability/expansion scope integrated -> `PASS`
  - Evidence: `STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md`
- Requirement: Boundary map completed before recommendations -> `PASS`
  - Evidence: `STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md`
- Requirement: Consultation round executed (Oracle+Designer parallel) -> `PARTIAL`
  - Evidence: deferred by Nexus no-delegation directive in current pass.
- Requirement: Actionable contract and validation commands present -> `PASS`
  - Evidence: `STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md`

## Parity Matrix v1 (Autonomous Step Executed)

- Claim: Rollback can succeed at control plane while runtime remains unhealthy -> `PASS`
  - Evidence: `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_ROLLBACK.md`
- Claim: Missing env interpolation blocked startup in dependency ladder sequence -> `PASS`
  - Evidence: `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_OPENAI_DEP.md`
  - Evidence: `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_GEMINI_DEP.md`
- Claim: Gateway recovery occurred only after sequential dependency removal -> `PASS`
  - Evidence: `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_GEMINI_DEP.md`
- Claim: State-dir/config-path authority remains unresolved and requires maintainer confirmation -> `PARTIAL`
  - Evidence: `STR4TEG15T/memory/journal/2026-02-24T14-18-00_NATE_OPENCLAW_SYNTHESIS_BEAST_MODE.md`
  - Evidence: `STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md`
- Claim: Stock usability + Nate expansion goals are now contractually encoded for audit outputs -> `PASS`
  - Evidence: `STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md`
  - Evidence: `STR4TEG15T/memory/decision-engine/OPENCLAW_EXTERNAL_AUDIT_PLAYBOOK_v1.md`

## Next Autonomous Step (Started)

- Begin Lens A evidence sweep using playbook checklist, starting with runtime bootstrap determinism and endpoint truth alignment evidence extraction from current artifacts.

## Lens A Evidence Sweep v1 (In Progress)

- Check: Runtime bootstrap determinism (`stateDir`, `configPath`, dependency interpolation)
  - Status: `PARTIAL`
  - Evidence:
    - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_CONFIG_FIX_PASS2.md`
    - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_ROLLBACK.md`
  - Note: state-dir mutation attempts did not show path shift in observed logs; maintainer confirmation required.
- Check: Endpoint truth alignment (`/healthz`, `/setup`, `/openclaw`)
  - Status: `PASS`
  - Evidence:
    - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_CONFIG_FIX.md`
    - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_GEMINI_DEP.md`
  - Note: wrapper stayed responsive while gateway signal identified true failure and later recovery.
- Check: Failure profile classification (`000`/`503`/`502` behavior)
  - Status: `PARTIAL`
  - Evidence:
    - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_CONFIG_FIX.md`
    - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_GEMINI_DEP.md`
  - Note: transient `502` after recovery observed; root classification pending maintainer/runtime context.

## Lens B Evidence Sweep v1 (Started)

- Check: Save-time validation policy for unresolved env interpolation
  - Status: `PARTIAL`
  - Evidence:
    - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_OPENAI_DEP.md`
    - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_GEMINI_DEP.md`
  - Note: behavior suggests missing hard guard at save-time; policy requirement documented but maintainer-side implementation unverified.
- Check: Rollout and rollback governance clarity
  - Status: `PASS`
  - Evidence:
    - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_CONFIG_FIX.md`
    - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_ROLLBACK.md`
  - Note: constrained pass sequence and rollback outcomes are clearly journaled and auditable.
- Check: Ownership and advisory boundary clarity for Alma/Nate expansion
  - Status: `PASS`
  - Evidence:
    - `STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md`
    - `STR4TEG15T/memory/decision-engine/OPENCLAW_EXTERNAL_AUDIT_PLAYBOOK_v1.md`
  - Note: maintainer ownership and strategist advisory boundaries are explicit in current contract.

## External Server Code Inspection v1 (Executed)

Inspection basis:
- Live-server workspace snapshot from `STR4TEG15T/tools/openclaw-backup-latest.tar.gz`
- Active config/workspace mirror under `STR4TEG15T/tools/.clawdbot` and `STR4TEG15T/tools/workspace`

Evidence files inspected:
- `STR4TEG15T/tools/workspace/trading/convert.py`
- `STR4TEG15T/tools/workspace/skills/tradingview/fetch.js`
- `STR4TEG15T/tools/workspace/skills/tradingview/spx-to-spy.js`
- `STR4TEG15T/tools/workspace/tools/substack-scraper/scrape-posts.js`
- `STR4TEG15T/tools/workspace/tools/substack-scraper/scraper.js`
- `STR4TEG15T/tools/workspace/trading/watchlist.md`
- `STR4TEG15T/tools/workspace/trading/alma-parser.md`

Code findings for `Alma Ease`:
1. Path rigidity: hardcoded `/data/workspace/...` paths in trading scripts increase operator friction across environments.
2. Error opacity: broad catch/pass patterns hide root causes in conversion/data scripts.
3. Runbook gap: parser/watchlist docs exist but are not connected to one deterministic "single command" flow.

Code findings for `Nate Expansion`:
1. Expansion surface exists (trading data fetch + conversion + scraper) but is fragmented across scripts.
2. Symbol coverage is split across source-specific maps; extension of new instruments is manual and error-prone.
3. Conversion logic has brittle heuristics (regex/range assumptions) that can constrain future market regimes.

Advisory recommendation stack (non-destructive):
- `Tier 0 (Docs/Ops)`:
  - Publish one stock workflow runbook chaining fetch -> convert -> level summary output for daily use.
  - Add explicit failure decoding table for common scrape/fetch/conversion errors.
- `Tier 1 (Config-Safe)`:
  - Centralize workspace path resolution via env/default helper instead of hardcoded `/data/workspace` literals.
  - Standardize structured error handling with actionable messages in trading scripts.
- `Tier 2 (Code Advisory)`:
  - Unify symbol registry and conversion utilities into a single shared module with testable extension points.
  - Replace heuristic-only parsing with schema-validated level extraction contract for Alma-driven input.

## Pass Questions (Captured, Answered/Deferred)

- Harden question: Which stock-path invariants must never regress?  
  - Current answer: state-dir/config-path determinism, gateway truth parity, and save-time env resolution guard.
- Expand question: Which additional stock capabilities are safest to unlock first for Nate?  
  - Current answer: documentation-led operator controls and non-destructive observability endpoints (Tier 0/Tier 1).
- Narrow question: What is out of scope this pass?  
  - Current answer: direct runtime mutation and production deployment execution.

## Strategist Retrospective

- What worked: autonomous conversion of Nexus directives into concrete decision deltas.
- What drifted: consultation step remains deferred due no-delegation constraint.
- What to automate: generate Lens A/B checklist skeletons from mission shape automatically.
- What to deprecate: passive framing without immediate validation commands.
- What to enforce next: requirement-by-requirement audit status on every pass.

## Validation Commands (Strategy Audit)

- `python -c "import json; json.load(open(r'C:\\P4NTH30N\\STR4TEG15T\\memory\\manifest\\manifest.json', encoding='utf-8')); print('manifest ok')"`
- `grep -R "OpenClaw|Alma|Nate|stock" STR4TEG15T/memory/decisions STR4TEG15T/memory/journal OP3NF1XER/deployments`
- `grep -R "Boundary map|Lens A|Lens B|Alma Ease|Nate Expansion" STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md`

## Companion Artifact

- Execution playbook: `STR4TEG15T/memory/decision-engine/OPENCLAW_EXTERNAL_AUDIT_PLAYBOOK_v1.md`

## Current State

- **Lifecycle state**: `BLOCKED` 
- **Blocked by**: Deployment priority (DECISION_164/165/168)
- **Mongo sync state**: N/A (blocked)
- **Inspection execution state**: Partially completed (server code sweep v1), then paused

## Blockage Rationale

This decision was iterating on OpenClaw external audit when deployment priorities emerged:
1. DECISION_164 (workspace rename) became critical path
2. DECISION_165 (deployment success criteria) needed completion
3. DECISION_168 (QMD Railway deployment) is now active

**Audit work completed before blockage**:
- Boundary map v1 created
- Lens A/Lens B checklists defined
- Server code inspection v1 (7 files)
- Stock usability matrix v1

**To resume**: Create new decision companion when deployment phase completes and OpenClaw audit becomes priority again.

## Historical: OpenFixer Assimilation Delta (2026-02-25)

1. DECISION_136 advisory requirement for operator ease and deterministic governance was converted into a concrete model-switch control path for OpenClaw agents.
2. New workspace skill `skills/openclaw-model-switch-kit/` now performs pre-audit preview, config mutation, gateway restart, and post-audit output for Anthropic model tiers.
3. This closes a recurrent audit gap where agents reported model switching without hard evidence.
4. Governance pattern captured in `OP3NF1XER/patterns/OPENCLAW_MODEL_SWITCH_AUDIT_LOOP.md`.
