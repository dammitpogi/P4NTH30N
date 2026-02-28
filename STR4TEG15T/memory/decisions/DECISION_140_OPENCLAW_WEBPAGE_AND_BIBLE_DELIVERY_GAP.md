---
type: decision
id: DECISION_140
category: FORGE
status: handoff_ready
version: 1.0.0
created_at: '2026-02-25T02:55:11Z'
last_reviewed: '2026-02-25T02:55:11Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_140_OPENCLAW_WEBPAGE_AND_BIBLE_DELIVERY_GAP.md
---
# DECISION_140: OpenClaw Webpage and Bible Delivery Gap Closure

**Decision ID**: DECISION_140  
**Mode**: Decision  
**Mission Shape**: External Codebase Audit  
**Lifecycle**: HandoffReady  
**Date**: 2026-02-25

## Intake

- Nexus requested an immediate audit and an OpenFixer deployment prompt because two critical components are not visible: webpage and bible.
- Runtime symptom reported by Nexus: `disconnected (1008): unauthorized: gateway token missing (open the dashboard URL and paste the token in Control UI settings)`.
- Nexus hard constraint for this pass: `NO SUBAGENTS`, `NO background task`.

## Frame (Bounded Scope)

1. Objective: verify whether webpage + bible artifacts exist and define exact deployment remediation contract.
2. Constraints: strategist is advisory-only, no product implementation, no subagent consultation.
3. Evidence targets: decision chain `136-139`, packet path under `memory/p4nthe0n-openfixer`, runtime wrapper route definitions, doctrine artifact paths.
4. Risk ceiling: high for operator confidence if runtime shows token disconnect and assets are not discoverable.
5. Finish criteria: auditable gap matrix and copy-paste OpenFixer prompt with deterministic validations.

## Evidence Spine

### Assumption Register

- A1: User-visible failure is runtime access/auth continuity, not only missing files.
- A2: Deliverables exist in artifacts but discoverability and route exposure are inconsistent.
- A3: Webpage must be verifiable by body content, not status code only.

### Fact Evidence

- Prompt packet folder exists and contains bible/textbook markdown assets:
  - `STR4TEG15T/tools/workspace/memory/p4nthe0n-openfixer/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md`
  - `STR4TEG15T/tools/workspace/memory/p4nthe0n-openfixer/NATE_SUBSTACK_TEXTBOOK_v2.md`
- Deployed backup runtime tree contains textbook site and server route wiring:
  - `C:/P4NTH30N/_tmpbuild/clawdbot-railway-template/src/server.js`
  - `C:/P4NTH30N/_tmpbuild/clawdbot-railway-template/memory/doctrine-bible/site/index.html`
- Route protection and token injection logic are present in wrapper:
  - `/textbook` uses `requireDashboardAuth`
  - gateway authorization header injected via `attachGatewayAuthHeader`
- OpenClaw decision chain confirms prior delivery claims:
  - `STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md`
  - `STR4TEG15T/memory/decisions/DECISION_137_NATE_SUBSTACK_TEACHINGS_CAPTURE_AND_SEARCH.md`
  - `STR4TEG15T/memory/decisions/DECISION_138_OPENCLAW_RESTORE_MODE_AGENT_SOUL_AND_GATEWAY_TOKEN.md`
  - `STR4TEG15T/memory/decisions/DECISION_139_OPENCLAW_DELIVERABLE_COMPLETENESS_AUDIT.md`

### Gap Findings

1. Webpage discoverability gap: webpage asset exists in doctrine site path, but user-facing route validation is blocked by runtime auth/token disconnect event.
2. Bible discoverability gap: bible file exists in doctrine and packet paths, but there is no guaranteed explicit `/bible` route and no enforced landing-page link validation in deployment gate.
3. Continuity gap: runtime currently reports websocket token issue (`1008 unauthorized`) from user observation; this supersedes stale "healthy" claims until re-verified live.

## Consultation Status

- Oracle: `Unavailable` (explicit Nexus instruction: no subagents/background tasks this pass).
- Designer: `Unavailable` (explicit Nexus instruction: no subagents/background tasks this pass).
- Conflict handling posture: strictest risk guardrails applied with provisional strategy.

## Synthesis

### Primary Route

- OpenFixer executes a focused deployment patch that guarantees:
  1. textbook webpage route is accessible after dashboard auth,
  2. bible artifact is explicitly discoverable from webpage and API metadata,
  3. gateway token continuity is re-established and proven by live websocket-ready checks.

Validation commands:

- `railway status --json`
- `curl -i https://clawdbot-railway-template-production-461f.up.railway.app/healthz`
- `curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/textbook/ | grep -i "Nate Doctrine Textbook Portal"`
- `curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/textbook/ | grep -i "AI_BIBLE"`
- `curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/setup/api/debug`

### Fallback Route

- If Railway auth/deploy is blocked, OpenFixer must still produce a closure packet with:
  - committed file-level changes,
  - local route probe output proving webpage+bible linkage,
  - exact external blocker evidence (`railway whoami`, auth errors),
  - restart/token recovery runbook for operator.

Validation commands:

- `railway whoami`
- `git show --name-only --oneline -1`
- `node src/server.js` (local smoke) plus authenticated `/textbook/` probe.

## Contract (OpenFixer Ownership)

- Owner: `OpenFixer`
- File-level targets (deployment repo):
  - `src/server.js`
  - `memory/doctrine-bible/site/index.html`
  - `memory/doctrine-bible/README.md`
  - `memory/p4nthe0n-openfixer/OPENCLAW_DELIVERY_MANIFEST_2026-02-25.md`
  - `memory/p4nthe0n-openfixer/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md`
- Required outputs:
  - Route evidence for webpage (`/textbook/`) and bible discoverability.
  - Gateway token continuity evidence resolving `1008 unauthorized` class.
  - Railway deployment id and post-deploy endpoint probes.

## Requirement Audit (PASS|PARTIAL|FAIL)

- Requirement: audit deliverables against decisions `136-139` -> `PASS`
- Requirement: verify two critical components (webpage + bible) in artifact set -> `PASS`
- Requirement: prove user-facing visibility at runtime now -> `FAIL`
  - Reason: current user-reported runtime disconnect (`1008 unauthorized`) not yet remediated in this pass.
- Requirement: produce exact OpenFixer deployment prompt -> `PASS`

## Pass Questions (Harden/Expand/Narrow)

- Harden: What single gate prevents false closure?  
  - Answer: authenticated body-level check for `/textbook/` plus gateway-token-ready websocket continuity check.
- Expand: What expansion adds immediate user value?  
  - Answer: explicit bible entrypoint from textbook portal and manifest-level reference consistency.
- Narrow: What is explicitly out-of-scope for strategist?  
  - Answer: direct runtime mutation and direct deployment execution.

## Closure Checklist Draft

- [x] Decision created under canonical memory path.
- [x] Decision chain audited with evidence paths.
- [x] Handoff contract drafted with exact file targets.
- [x] Validation commands defined for success and fallback.
- [ ] OpenFixer execution evidence attached (pending implementation pass).
- [ ] Runtime websocket/token continuity verified live (pending implementation pass).

## Handoff Artifact

- `STR4TEG15T/memory/handoffs/HANDOFF_2026-02-25_DECISION_140_OPENFIXER_WEBPAGE_BIBLE_GATEWAY.md`

## Current State

- Lifecycle: `HandoffReady`
- Sync state: `SyncQueued` (Mongo sync deferred this pass)
- Next autonomous step started: handoff prompt prepared for immediate OpenFixer execution.
