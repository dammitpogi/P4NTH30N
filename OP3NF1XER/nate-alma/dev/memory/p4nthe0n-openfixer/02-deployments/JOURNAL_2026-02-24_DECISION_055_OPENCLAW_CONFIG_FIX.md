# JOURNAL_2026-02-24_DECISION_055_OPENCLAW_CONFIG_FIX

Date: 2026-02-24
Mode: Deployment
Decision IDs: `DECISION_052`, `DECISION_054`, `DECISION_055`
Service: `clawdbot-railway-template` (`projectId=1256dcd2-0929-417a-8f32-39137ffa523b`)

## Ordered Action Log

1. Pulled current deployment snapshot (latest deployment id and status).
2. Pulled current variable snapshot for target service/environment (secret-bearing values redacted in this journal).
3. Captured pre-fix route probes for `/healthz`, `/setup`, `/openclaw`.
4. Applied one minimal mutation: updated `CLAWDBOT_STATE_DIR` only.
5. Triggered one controlled restart (`deploymentRestart`) on latest deployment.
6. Ran post-fix validation probes (3 rounds) for `/healthz`, `/setup`, `/openclaw`.
7. Ran 10-request `/openclaw` spot check.
8. Pulled post-change deployment logs for before/after comparison.
9. Stopped after one remediation pass per handoff stop condition.

## Exact Mutations Applied

- GraphQL mutation: `variableUpsert`
  - `name`: `CLAWDBOT_STATE_DIR`
  - `value`: `/data/.openclaw`
  - `skipDeploys`: `true`
  - `result`: `true`
- GraphQL mutation: `deploymentRestart`
  - `id`: `f578fd88-5994-4527-8797-9b1c57e2e725`
  - `result`: `true`

No broad config rewrites, no rollback/reset, and no new secrets written to repository artifacts.

## Validation Status Codes

Pre-fix snapshot:
- `/healthz`: `200`
- `/setup`: `401`
- `/openclaw`: `0` (timeout/no response)

Post-fix probe rounds (x3):
- Round 1: `/healthz=200`, `/setup=401`, `/openclaw=503`
- Round 2: `/healthz=200`, `/setup=401`, `/openclaw=503`
- Round 3: `/healthz=200`, `/setup=401`, `/openclaw=503`

Spot check (`/openclaw`, 10 requests):
- Codes: `0,0,503,0,0,503,0,0,503,0`
- `5xx_count=3`

## Before/After Log Evidence

Before mutation/restart:
- `MissingEnvVarError: Missing env var "OPENAI_API_KEY" referenced at config path: models.providers.openai.apiKey`
- Config file path in logs: `/data/.clawdbot/openclaw.json`

After mutation/restart:
- Same `MissingEnvVarError` persists at same config path.
- Log file path remains `/data/.clawdbot/openclaw.json`.
- Gateway remains non-ready; `/openclaw` continues returning `503`/timeouts.

## Next Safest Option

Because first minimal fix did not recover service, next safest non-destructive step is:
1. Upsert `OPENCLAW_STATE_DIR=/data/.openclaw` (single-variable change).
2. Perform one controlled restart.
3. Re-run same validation matrix.

If still unhealthy, escalate to rollback gate with full evidence.

## Final State

**Not recovered**.
