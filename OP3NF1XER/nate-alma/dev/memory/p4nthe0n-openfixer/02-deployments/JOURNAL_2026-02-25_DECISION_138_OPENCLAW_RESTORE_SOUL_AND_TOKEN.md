# Deployment Journal: DECISION_138 OpenClaw Restore Soul + Gateway Token Path

Date: 2026-02-25
Decision: `DECISION_138`
Related Decisions: `DECISION_117`, `DECISION_118`, `DECISION_126`, `DECISION_137`

## Source-Check Order Evidence

1. Decisions first: `DECISION_117`, `DECISION_118`, `DECISION_126`, `DECISION_137` and created `DECISION_138`.
2. Knowledgebase second: `OP3NF1XER/knowledge/QUICK_QUERY_INDEX.md`, `.../NATE_CHATLOG_REQUEST_TO_TOOL_MAPPING_2026_02_25.md`.
3. Local discovery third: workspace and deployment AGENTS, server/setup code, runtime status endpoints.
4. Web/docs fourth: OpenClaw docs (`/start/hubs`, `/web/control-ui`, `/gateway/configuration`) for token-handshake behavior.

## File-Level Diff Summary

- Merged runtime restore governance into workspace soul doc:
  - `STR4TEG15T/tools/workspace/AGENTS.md`
- Hardened restore pattern with `1008` token recovery steps:
  - `OP3NF1XER/patterns/OPENCLAW_PRE_DEPLOY_BACKUP_AND_RESTORE_GUARD.md`
- Added decision for this pass:
  - `STR4TEG15T/memory/decisions/DECISION_138_OPENCLAW_RESTORE_MODE_AGENT_SOUL_AND_GATEWAY_TOKEN.md`
- Added knowledge write-back:
  - `OP3NF1XER/knowledge/DECISION_138_OPENCLAW_RESTORE_MODE_SOUL_AND_TOKEN_2026_02_25.md`

## Commands Run

- `railway status --json`
- `railway logs --deployment 3206cdc5-b7ba-4d19-a77a-c686a3530c5c --lines 200`
- public endpoint probe via Python urllib (`/healthz`, `/openclaw`, `/setup/export`)
- authenticated setup checks:
  - `/setup/api/status`
  - `/setup/api/console/run` with:
    - `openclaw.status`
    - `openclaw.health`
    - `openclaw.config.get gateway.auth.mode`
    - `openclaw.config.get gateway.remote.token`

## Verification Results

- Latest deployment status: `PASS` (`SUCCESS`, `3206cdc5-b7ba-4d19-a77a-c686a3530c5c`).
- Runtime liveness: `PASS` (`/healthz` 200 with `configured:true`).
- Auth gate behavior: `PASS` (`/openclaw` and `/setup/export` return 401 unauthenticated; 200 with setup auth).
- Gateway service health: `PASS` (`openclaw.health` reports Telegram OK).
- Token path health: `PASS` (`gateway.auth.mode=token`, `gateway.remote.token` present).

## Decision Parity Matrix

- Preserve backup deployment path as read-only restore anchor: **PASS**
- Restore agent soul via AGENTS merge while adding runtime guardrails: **PASS**
- Validate gateway-down claim with direct evidence: **PASS**
- Address token-missing disconnect class with deterministic recovery guidance: **PASS**
- Update reusable workflow docs in same pass: **PASS**

## Triage and Repair Runbook

- Detect: dashboard disconnect shows `1008 unauthorized: gateway token missing`.
- Diagnose:
  1. confirm runtime up (`/healthz`, `openclaw.health`),
  2. confirm token mode and token presence (`gateway.auth.mode`, `gateway.remote.token`).
- Recover:
  1. paste `gateway.remote.token` in Control UI settings for remote browser,
  2. if missing, set token fields and restart gateway.
- Verify: reconnect dashboard and re-run `openclaw.health` + `openclaw.status`.

## Audit Results

- Requested soul restoration and AGENTS merge: **PASS**
- Requested restore-mode posture with learning capture: **PASS**
- Requested gateway outage triage: **PASS** (runtime up; issue class = client token state)

## Re-Audit Results

- No PARTIAL/FAIL items remained after implementation; re-audit not required.

## Closure Recommendation

- `Close` for DECISION_138.
