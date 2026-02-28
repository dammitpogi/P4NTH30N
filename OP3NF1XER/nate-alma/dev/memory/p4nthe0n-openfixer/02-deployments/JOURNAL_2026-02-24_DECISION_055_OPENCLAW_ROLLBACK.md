# JOURNAL_2026-02-24_DECISION_055_OPENCLAW_ROLLBACK

Date: 2026-02-24
Mode: Deployment
Action: Rollback
Decision IDs: `DECISION_052`, `DECISION_054`, `DECISION_055`
Status: Executed

## Approval Gate

- Nexus rollback approval in current pass: `yes`
- Gate result: `open`

## Ordered Actions

1. Re-read execution handoff and confirmed explicit Nexus approval in current pass.
2. Re-validated current and target deployment metadata before mutation.
3. Captured pre-rollback probes for `/healthz`, `/setup`, `/openclaw`.
4. Captured pre-rollback `/healthz` payload signal (`gateway.reachable=false`, `stateDir=/data/.clawdbot`).
5. Pulled pre-rollback deployment logs for missing-env/config-path signatures.
6. Executed one rollback mutation to target deployment id.
7. Ran 3 post-rollback validation rounds for `/healthz`, `/setup`, `/openclaw`.
8. Ran 10-request `/openclaw` spot check.
9. Queried latest deployment list to identify post-rollback active deployment id.
10. Pulled post-rollback deployment logs for the new active deployment.
11. Captured post-rollback `/healthz` payload signal.

## Target and Pre-Mutation Metadata

- projectId: `1256dcd2-0929-417a-8f32-39137ffa523b`
- environmentId: `3ba89542-4d69-44cf-9a98-92f0058c30aa`
- serviceId: `2224d9e4-80a7-49d5-b2d4-cf37385fc843`
- current deployment before rollback: `f578fd88-5994-4527-8797-9b1c57e2e725` (`status=SUCCESS`, `canRollback=true`)
- rollback target deployment: `b7d30dd4-d5b7-4135-90e5-9074ddeafb34` (`status=REMOVED`, `canRollback=true`)

## Pre-Rollback Snapshot

- `/healthz`: `200`
- `/setup`: `401`
- `/openclaw`: `503`
- `/healthz` payload: `gateway.reachable=false`, `wrapper.stateDir=/data/.clawdbot`

## Exact Rollback Mutation Result

- GraphQL mutation: `deploymentRollback`
- target deployment id: `b7d30dd4-d5b7-4135-90e5-9074ddeafb34`
- result: `true`

## Post-Rollback Deployment Snapshot

- latest active deployment after rollback: `6a12e752-1e07-44f7-bf77-91dad2a97dc9`
- deployment status: `SUCCESS`

## Validation Matrix

Post-rollback probes (3 rounds):
- Round 1: `/healthz=200`, `/setup=401`, `/openclaw=502`
- Round 2: `/healthz=200`, `/setup=401`, `/openclaw=502`
- Round 3: `/healthz=200`, `/setup=401`, `/openclaw=502`

Spot check (`/openclaw`, 10 requests):
- Codes: `000,503,000,503,000,503,000,503,000,000`
- `5xx_count=4`

Post-rollback health signal:
- `/healthz` payload remains `gateway.reachable=false`
- `wrapper.stateDir` remains `/data/.clawdbot`

## Key Log Deltas

Before rollback (`f578fd88-5994-4527-8797-9b1c57e2e725`):
- `MissingEnvVarError: Missing env var "OPENAI_API_KEY" referenced at config path: models.providers.openai.apiKey` present.
- Config file path present: `/data/.clawdbot/openclaw.json`.

After rollback (`6a12e752-1e07-44f7-bf77-91dad2a97dc9`):
- Same missing-env error for `OPENAI_API_KEY` remains present.
- Config file path remains `/data/.clawdbot/openclaw.json`.

## Final State

- Outcome: `Not recovered`
- Notes: Rollback executed successfully at deployment control plane level, but runtime gateway remains unhealthy with unchanged missing-env/config-path failure signature.
