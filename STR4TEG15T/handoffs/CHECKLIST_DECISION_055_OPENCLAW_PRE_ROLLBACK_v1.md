# CHECKLIST_DECISION_055_OPENCLAW_PRE_ROLLBACK_v1

Mode: Deployment  
Decision IDs: `DECISION_052`, `DECISION_054`, `DECISION_055`

## 1) Target Deployment ID + Reason

- Current active deployment id: `f578fd88-5994-4527-8797-9b1c57e2e725`
- Proposed rollback target id: `b7d30dd4-d5b7-4135-90e5-9074ddeafb34`
- Selection reason:
  - Most recent prior deployment in history with `canRollback=true`, immediately before current active deployment.
  - This is the least-distance rollback candidate under minimal-blast-radius policy.

Pre-execution confirm (required):
- [ ] Re-query target metadata and confirm `canRollback=true` at execution time.
- [ ] Confirm target id is still available to rollback API mutation path.

## 2) Expected Impact If Persisted /data Config Remains

- Because Railway env vars and `/data` state can persist across deployment rollbacks, rollback may restore app code but still inherit config/state drift.
- If runtime still resolves `/data/.clawdbot/openclaw.json` and missing `OPENAI_API_KEY` dependency remains, expected result is continued gateway startup failure.
- Expected failure signature if drift persists:
  - `MissingEnvVarError: Missing env var "OPENAI_API_KEY"`
  - `/healthz=200` with `gateway.reachable=false`
  - `/setup=401`
  - `/openclaw=503` or timeout

## 3) Validation Matrix

Pre-rollback baseline:
- [ ] Probe `/healthz`
- [ ] Probe `/setup`
- [ ] Probe `/openclaw`

Post-rollback rounds (x3):
- [ ] Round 1: `/healthz`, `/setup`, `/openclaw`
- [ ] Round 2: `/healthz`, `/setup`, `/openclaw`
- [ ] Round 3: `/healthz`, `/setup`, `/openclaw`

Post-rollback spot check:
- [ ] `/openclaw` 10 requests (record codes and `5xx_count`)

Logs (before/after):
- [ ] Check for `MissingEnvVarError OPENAI_API_KEY`
- [ ] Check config file path marker:
  - `/data/.clawdbot/openclaw.json`
  - `/data/.openclaw/openclaw.json`

## 4) Explicit Stop Gate

- **Do not execute rollback without explicit Nexus approval.**
- If approval is missing, return: `BLOCKED: Nexus approval required before rollback execution.`
