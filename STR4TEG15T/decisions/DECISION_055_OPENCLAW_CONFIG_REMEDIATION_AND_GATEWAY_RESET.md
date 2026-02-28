# DECISION_055: OpenClaw Config Remediation and Gateway Reset Protocol

**Decision ID**: DECISION_055  
**Category**: RISK  
**Status**: Closed  
**Priority**: High  
**Date**: 2026-02-24  
**Oracle Approval**: Pending  
**Designer Approval**: Pending

---

## Executive Summary

This decision defines a controlled path for recovering from suspected config corruption in Railway-hosted OpenClaw, prioritizing minimally destructive actions before rollback or reset.

---

## Trigger Condition

- Incident signals suggest partial availability (`/setup` reachable with auth gate) while core routes fail (`/openclaw` 503, `/health` 502).
- Nexus indicates likely model-induced config drift.
- Discovery gate: remediation remains blocked until DECISION_054 deep discovery pass captures deployment/log/variable evidence.
- New discovery evidence: `/healthz` reports gateway readiness timeout (`Gateway did not become ready in time`) with non-zero exit.

## Discovery Dependency

- Upstream decision: `STR4TEG15T/decisions/DECISION_054_OPENCLAW_INCIDENT_DISCOVERY_PLAN.md`
- Required before approval:
  1. deployment history evidence,
  2. log evidence,
  3. variable diff evidence,
  4. outage bucket classification.

Current dependency status:
- Outage bucket classification: provisional complete (`RuntimeCrash` primary, `EnvDrift` secondary)
- Deployment history evidence: complete
- Railway-side variable diff evidence: complete
- Railway deployment log evidence: complete
- Confirmed write/edit authority on Railway resources: complete (reversible mutation smoke test passed)

Tooling update:
- Strategist created `STR4TEG15T/tools/railway_graphql_client.py` to execute authenticated Railway GraphQL queries/mutations.
- Edit authority is verified via reversible write smoke test evidence.
- Prior runtime policy conflict blocked execution earlier; now resolved after config correction + reset.

Latest access verification:
- Runtime execution path is now available.
- Access ambiguity resolved by validated first key against target project/service scope.
- Remediation gate is open from an access perspective (reversible mutation smoke test passed).

Updated verification:
- First Railway token (`0986495a-81b7-4306-9ead-34ece8529049`) confirmed target project scope.
- Reversible write test succeeded (`PYXIS_ACCESS_TEST` upsert/delete).
- Runtime logs identify concrete failure: missing `OPENAI_API_KEY` env var required by configured provider path.

Candidate mismatch set (from discovery + docs):
- Potential strict-schema invalid config after model edits (gateway startup refusal condition in docs)
- State dir divergence (`/data/.clawdbot` observed vs `/data/.openclaw` recommended for Railway OpenClaw baseline)
- Possible missing or altered baseline variables (`PORT`, `OPENCLAW_*`, setup credentials)

---

## Remediation Ladder (Least to Most Disruptive)

1. **Read-only verification**
   - Confirm template baseline (`PORT=8080`, HTTP proxy 8080, `/data` volume, setup password, recommended state/workspace vars).
2. **Targeted config correction**
   - Correct only mismatched variables.
3. **Gateway/service restart**
   - Restart deployment/service after config corrections.
4. **Redeploy same build**
   - Redeploy current deployment if runtime state appears stale.
5. **Rollback to prior successful deployment**
   - Use when config correction path does not restore core routes.
6. **Reset-like action (last resort)**
   - Equivalent to OpenClaw state reset only with explicit Nexus approval and risk acceptance.

---

## Safety Gates

- No secret persistence in repo artifacts.
- No reset-like action without explicit Nexus allow.
- Before rollback or reset-like action, capture logs and deployment IDs.
- Every mutation step requires post-step probe of `/`, `/setup`, `/openclaw`, `/health`.

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-055-01 | Run config integrity diff against template baseline | OpenFixer | Completed | High |
| ACT-055-02 | Apply minimal variable corrections only | OpenFixer | Completed (single-variable state-dir correction) | High |
| ACT-055-03 | Execute restart and verify route matrix | OpenFixer | Completed (gateway still unhealthy) | High |
| ACT-055-04 | Escalate to rollback only if correction+restart fails | OpenFixer | Completed (executed, not recovered) | High |
| ACT-055-05 | Execute OpenFixer manually via Nexus private tool (no strategist subagent launch) | Nexus | Completed | Critical |
| ACT-055-06 | Execute second minimal config-path fix (`OPENCLAW_STATE_DIR` upsert) before rollback/reset | OpenFixer | Completed (not recovered) | High |
| ACT-055-07 | Enforce prompt-parity workflow: whenever strategist recommends a next action, include immediate copy-paste deployment prompt and client synthesis prompt in same response | Strategist | Completed | High |
| ACT-055-08 | Select post-rollback recovery branch (provider key supply vs config dependency removal) | Nexus | Completed (`b` selected) | Critical |
| ACT-055-09 | Execute dependency-removal pass: remove hard OPENAI_API_KEY dependency, one restart, full validation | OpenFixer | Completed (not recovered; new dependency surfaced) | Critical |
| ACT-055-10 | Execute dependency-removal pass: remove hard GEMINI_API_KEY dependency, one restart, full validation | OpenFixer | Completed (recovered; transient 502 observed) | Critical |
| ACT-055-11 | Implement prevention guardrail: enforce env-presence validation before provider apiKey config save | OpenFixer | Pending | High |

## Activation Note

- Nexus constraint enforced: strategist will not launch subagents directly for this pass.
- Execution must be initiated by Nexus using private OpenFixer tooling with handoff file:
  - `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_055_OPENCLAW_CONFIG_FIX_v1.txt`

## Rollback Authorization (Current Pass)

- Nexus selected `1a` and explicitly approved rollback execution in this pass.
- Authorized execution artifact:
  - `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_055_OPENCLAW_ROLLBACK_EXECUTE_v1.txt`
- Expected post-run artifact:
  - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_ROLLBACK.md`

## Rollback Execution Evidence (2026-02-24)

Journal artifact:
- `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_ROLLBACK.md`

Execution result:
- Control-plane rollback mutation succeeded (`deploymentRollback -> true`).
- New active deployment after rollback: `6a12e752-1e07-44f7-bf77-91dad2a97dc9` (`SUCCESS`).

Validation result:
- `/healthz=200`, `/setup=401`, `/openclaw=502` across 3 rounds.
- `/openclaw` spot check includes persistent timeouts and `5xx_count=4`.

Log evidence:
- `MissingEnvVarError` for `OPENAI_API_KEY` persists after rollback.
- Config path in logs remains `/data/.clawdbot/openclaw.json`.

Outcome:
- **Not recovered**.
- Rollback did not clear persistent `/data`-anchored config/env dependency.

## Branch Selection (Current Pass)

- Nexus selected branch `b`: remove dependency.
- Approved direction: remove hard runtime dependency on `OPENAI_API_KEY` in active OpenClaw config path, then perform one controlled restart and full validation matrix.

## Branch-b Execution Evidence (2026-02-24)

Journal artifact:
- `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_OPENAI_DEP.md`

Execution result:
- Minimal config edit applied at active path `/data/.clawdbot/openclaw.json`.
- Removed only `models.providers.openai.apiKey` env interpolation.

Validation result:
- `/healthz=200`, `/setup=401`, `/openclaw` remained timeout/5xx.
- Spot check result: `5xx_count=2` (not recovered).

Log delta:
- `MissingEnvVarError OPENAI_API_KEY` no longer observed.
- New blocker: `MissingEnvVarError GEMINI_API_KEY` at `models.providers.google.apiKey`.

Outcome:
- **Not recovered**.
- Next safest branch-b continuation: remove/neutralize hard `GEMINI_API_KEY` dependency with one constrained pass.

## Branch-b Continuation Evidence (Gemini Dependency Removal)

Journal artifact:
- `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_GEMINI_DEP.md`

Execution result:
- Minimal config edit applied at active path `/data/.clawdbot/openclaw.json`.
- Removed only `models.providers.google.apiKey` env interpolation.

Validation result:
- 3 rounds: `/healthz=200`, `/setup=401`, `/openclaw=000|200|200`.
- 10-request `/openclaw` spot check: mostly `200`, single transient `502` (`5xx_count=1`).
- Final `/healthz` truth: `gateway.reachable=true`.

Log delta:
- `MissingEnvVarError GEMINI_API_KEY` no longer observed.
- `MissingEnvVarError OPENAI_API_KEY` no longer observed.
- No new missing-env dependency surfaced in captured window.

Outcome:
- **Recovered** (with transient error under rapid probe load).

## Root Source of Failure (Chat Trace)

- Primary source file:
  - `STR4TEG15T/tools/.clawdbot/agents/main/sessions/86a82de1-b44f-4261-aa99-5391cbe94248.jsonl`
- Causal messages:
  - User `message_id: 1404` (`2026-02-24T02:32:20Z`): requests fallback cascade and multi-agent setup.
  - User `message_id: 1406` (`2026-02-24T02:41:07Z`): requests OpenAI + Gemini addition with Railway-stored keys.
  - `GatewayRestart` config-apply event (`2026-02-24T08:25:26Z`) confirms patch at `/data/.clawdbot/openclaw.json`.
- Failure mode derived from trace:
  - Config introduced hard provider env dependencies before runtime env completeness was ensured, causing sequential `MissingEnvVarError` failures.

---

## Pass Questions (Harden / Expand / Narrow)

- Harden: Do we formalize a protected set of baseline vars that cannot be modified by automation without approval?
- Expand: Should we add an automated config drift detector for template deployments?
- Narrow: For this incident, do we cap scope to one production service and avoid workspace-wide changes?

---

## Closure Checklist Draft

- [ ] Config diff recorded against template baseline
- [ ] Restart attempt evidence captured
- [ ] Route probe matrix captured pre/post mutation
- [ ] If rollback used, deployment IDs and reasons recorded
- [ ] DECISION_052 updated with chosen recovery path and evidence

## OpenFixer Deployment Pass Evidence (2026-02-24)

Executed handoff: `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_055_OPENCLAW_CONFIG_FIX_v1.txt`.

Minimal mutation applied:
- `CLAWDBOT_STATE_DIR` changed from `/data/.clawdbot` to `/data/.openclaw` (`skipDeploys=true`).

Controlled restart:
- One restart triggered via `deploymentRestart` on deployment `f578fd88-5994-4527-8797-9b1c57e2e725`.

Validation snapshot:
- Pre-fix: `/healthz=200`, `/setup=401`, `/openclaw=0` (timeout).
- Post-fix probes (3 rounds): `/healthz=200`, `/setup=401`, `/openclaw=503`.
- `/openclaw` 10-request spot-check: `0,0,503,0,0,503,0,0,503,0` (`5xx_count=3`).

Before/after log evidence:
- Before: `MissingEnvVarError` for `OPENAI_API_KEY` at `models.providers.openai.apiKey`; file `/data/.clawdbot/openclaw.json`.
- After: same error persisted; log still references `/data/.clawdbot/openclaw.json`.

Result:
- One-pass stop condition reached: **Not recovered**.
- Next safest option: apply second minimal config-path correction `OPENCLAW_STATE_DIR=/data/.openclaw` with one controlled restart. If still failing, escalate to rollback gate with full evidence.

## Rollback Prep Verification (Strategist)

- Verified rollback-prep artifacts exist and are internally consistent:
  - `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_055_OPENCLAW_ROLLBACK_EXECUTE_v1.txt`
  - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_ROLLBACK.md`
  - `STR4TEG15T/handoffs/CHECKLIST_DECISION_055_OPENCLAW_PRE_ROLLBACK_v1.md`
- Verified explicit stop gate is present: rollback execution requires explicit Nexus approval in current pass.
- Decision state: rollback is `Ready` but not executed.

## Immediate Deployment Package

- OpenFixer deployment prompt path:
  - `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_055_OPENCLAW_CONFIG_FIX_PASS2_v1.txt`
- Nate/client update prompt path:
  - `STR4TEG15T/handoffs/NATE_UPDATE_DECISION_055_PASS2_v1.txt`

## OpenFixer Deployment Pass2 Evidence (2026-02-24)

Executed handoff: `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_055_OPENCLAW_CONFIG_FIX_PASS2_v1.txt`.

Minimal mutation applied:
- `OPENCLAW_STATE_DIR` upserted to `/data/.openclaw` (`skipDeploys=true`), with no other variable changes.

Controlled restart:
- One restart triggered via `deploymentRestart` on deployment `f578fd88-5994-4527-8797-9b1c57e2e725`.

Validation snapshot:
- Pre-pass: `/healthz=200`, `/setup=401`, `/openclaw=0` (timeout).
- Post-pass probes (3 rounds): `/healthz=200`, `/setup=401`, `/openclaw=503|0|0`.
- `/openclaw` 10-request spot-check: `0,0,503,0,0,503,0,0,503,0` (`5xx_count=3`).

Before/after log evidence:
- Before pass2: `MissingEnvVarError` for `OPENAI_API_KEY` at `models.providers.openai.apiKey`; file `/data/.clawdbot/openclaw.json`.
- After pass2: same missing-env error persisted; log path still `/data/.clawdbot/openclaw.json`.

Result:
- Second constrained pass stop condition reached: **Not recovered**.
- Next gate: rollback recommendation is now eligible, but requires explicit Nexus approval before execution.

Pass2 journal artifact:
- `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_CONFIG_FIX_PASS2.md`

---

*Decision DECISION_055*  
*OpenClaw Config Remediation and Gateway Reset Protocol*  
*2026-02-24*

## Closure Evidence

- Deployment journals captured:
  - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_CONFIG_FIX.md`
  - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_CONFIG_FIX_PASS2.md`
  - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_ROLLBACK.md`
  - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_OPENAI_DEP.md`
  - `OP3NF1XER/deployments/JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_GEMINI_DEP.md`
- Root-source and prevention brief:
  - `STR4TEG15T/handoffs/ROOT_SOURCE_AND_PREVENTION_DECISION_055_v1.md`
- Final outcome for this decision scope:
  - Runtime recovered after constrained dependency-removal ladder.
  - Root source isolated to cascading provider env dependencies in active config path.
  - Residual note: one transient `502` observed under rapid spot-check sequence.
