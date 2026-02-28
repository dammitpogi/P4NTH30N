---
type: decision
id: DECISION_138
category: FORGE
status: completed
version: 1.0.0
created_at: '2026-02-25T03:05:00Z'
last_reviewed: '2026-02-25T03:05:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_138_OPENCLAW_RESTORE_MODE_AGENT_SOUL_AND_GATEWAY_TOKEN.md
---
# DECISION_138: OpenClaw Restore Mode Agent Soul Merge and Gateway Token Recovery

**Decision ID**: DECISION_138  
**Category**: FORGE  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-25

## Context

Nexus directed restore-mode execution with explicit protection of the deployment backup path and requested restoration of agent soul continuity by merging workspace and deployment AGENTS doctrine. Runtime symptom reported: Control UI disconnected with `1008 unauthorized: gateway token missing`.

## Decision

1. Keep `_tmpbuild/clawdbot-railway-template` as read-only restore anchor during this pass.
2. Merge deployment runtime governance into workspace `AGENTS.md` without removing soul/voice rules.
3. Verify OpenClaw runtime health and token path through authenticated setup APIs and Railway status.
4. Harden restore pattern with explicit Control UI token recovery steps.
5. Publish deployment audit and parity matrix with PASS/PARTIAL/FAIL evidence.

## Implementation Evidence

- Workspace soul merge target updated:
  - `STR4TEG15T/tools/workspace/AGENTS.md`
- Restore pattern hardened:
  - `OP3NF1XER/patterns/OPENCLAW_PRE_DEPLOY_BACKUP_AND_RESTORE_GUARD.md`
- Runtime status checks executed against:
  - `https://clawdbot-railway-template-production-461f.up.railway.app`

## Runtime Findings

- Railway latest deployment `3206cdc5-b7ba-4d19-a77a-c686a3530c5c`: `SUCCESS`.
- Public probe: `/healthz` returns `200`; `/openclaw` and `/setup/export` are auth-gated when unauthenticated.
- Authenticated setup probe: `configured:true` and OpenClaw UI reachable.
- Console checks:
  - `openclaw.health`: `Telegram: ok (@Almastockbot)`
  - `openclaw.config.get gateway.auth.mode`: `token`
  - `openclaw.config.get gateway.remote.token`: present

## Audit Matrix

- Requirement: keep backup deployment path untouched in restore mode -> **PASS**
- Requirement: merge workspace and deployment AGENTS doctrine -> **PASS**
- Requirement: verify runtime is actually up (not narrative claim) -> **PASS**
- Requirement: address gateway-token disconnect class with deterministic runbook -> **PASS**
- Requirement: update workflow for future souls -> **PASS**

## Completion Criteria

- [x] Decision created and executed in same pass.
- [x] Soul merge completed in workspace AGENTS.
- [x] Runtime/token path verified with live evidence.
- [x] Pattern hardening applied.
- [x] Governance audit published in companion journal.
