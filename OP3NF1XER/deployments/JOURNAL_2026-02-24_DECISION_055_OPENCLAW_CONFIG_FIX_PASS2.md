# JOURNAL_2026-02-24_DECISION_055_OPENCLAW_CONFIG_FIX_PASS2

Date: 2026-02-24
Mode: Deployment
Decision IDs: `DECISION_052`, `DECISION_054`, `DECISION_055`
Handoff: `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_055_OPENCLAW_CONFIG_FIX_PASS2_v1.txt`

## Ordered Actions

1. Captured pre-pass endpoint probes for `/healthz`, `/setup`, `/openclaw`.
2. Captured latest deployment id snapshot (`f578fd88-5994-4527-8797-9b1c57e2e725`).
3. Captured current variable snapshot (redacted in journal; non-secret fields only).
4. Applied exactly one mutation: `OPENCLAW_STATE_DIR=/data/.openclaw` (`skipDeploys=true`).
5. Triggered exactly one controlled restart on latest deployment.
6. Ran 3 validation rounds on `/healthz`, `/setup`, `/openclaw`.
7. Ran 10-request `/openclaw` spot check.
8. Pulled deployment logs and checked required signatures (`OPENAI_API_KEY` missing-env + config file path).
9. Stopped per stop condition after one pass (no rollback/reset).

## Exact Mutation Applied

- GraphQL mutation: `variableUpsert`
  - name: `OPENCLAW_STATE_DIR`
  - value: `/data/.openclaw`
  - skipDeploys: `true`
  - result: `true`

No additional variable changes were applied.

## Validation Matrix

Pre-pass:
- `/healthz`: `200`
- `/setup`: `401`
- `/openclaw`: `0` (timeout)

Post-pass probes (3 rounds):
- Round 1: `/healthz=200`, `/setup=401`, `/openclaw=503`
- Round 2: `/healthz=200`, `/setup=401`, `/openclaw=0`
- Round 3: `/healthz=200`, `/setup=401`, `/openclaw=0`

Spot check (`/openclaw`, 10 requests):
- Codes: `0,0,503,0,0,503,0,0,503,0`
- `5xx_count=3`

Gateway status signal:
- `/healthz` reports `gateway.reachable=false` in all 3 rounds.
- `/healthz` wrapper state dir remains `/data/.clawdbot`.

## Key Log Deltas (Before/After)

Before pass2:
- `MissingEnvVarError: Missing env var "OPENAI_API_KEY" referenced at config path: models.providers.openai.apiKey`
- Config path in logs: `/data/.clawdbot/openclaw.json`

After pass2:
- Same missing env error persists for `OPENAI_API_KEY`.
- Config path in logs still `/data/.clawdbot/openclaw.json`.
- No observed shift to `/data/.openclaw/openclaw.json` in deployment logs.

## Constraint Compliance

- One mutation only: satisfied.
- One restart only: satisfied.
- No rollback/reset: satisfied.
- No secret persistence in repo artifacts: satisfied.

## Final State

**Not recovered**.

Rollback recommendation gate:
- Eligible for next-pass rollback decision gate because one constrained pass was executed with full evidence and no recovery.
