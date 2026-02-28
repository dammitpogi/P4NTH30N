# JOURNAL_2026-02-24_DECISION_055_OPENCLAW_REMOVE_OPENAI_DEP

Date: 2026-02-24
Mode: Deployment
Decision IDs: `DECISION_052`, `DECISION_054`, `DECISION_055`
Handoff: `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_055_OPENCLAW_REMOVE_OPENAI_DEP_v1.txt`

## Ordered Actions

1. Confirmed Nexus approval for branch `b` and loaded the exact handoff.
2. Captured pre-change endpoint state:
   - `/healthz=200`, `/setup=401`, `/openclaw=503`
3. Pulled pre-change deployment logs window (`2026-02-24T07:50:00Z` to `2026-02-24T08:12:00Z`) and captured active failure signature:
   - `MissingEnvVarError: Missing env var "OPENAI_API_KEY"`
   - `configPath: models.providers.openai.apiKey`
   - file path `/data/.clawdbot/openclaw.json`
4. Loaded active config from `/setup/api/config/raw` (path `/data/.clawdbot/openclaw.json`).
5. Applied minimal dependency-removal edit in config content (remove only OpenAI env interpolation line).
6. Saved config via `/setup/api/config/raw` POST (setup API reports restart-on-save).
   - Response: `HTTP 500 {"ok":false,"error":"Error: Gateway did not become ready in time"}`
7. Re-issued one verification save call to capture full error body consistently after ambiguous failure signal.
   - Response: same `HTTP 500` payload above.
8. Verified persisted config no longer contains `"apiKey": "${OPENAI_API_KEY}"`.
9. Ran 3 validation rounds for `/healthz`, `/setup`, `/openclaw`.
10. Ran 10-request `/openclaw` spot check.
11. Pulled post-change deployment logs and checked missing-env/config-path signatures.

## Exact Config Delta Summary

Edited file path (active setup API path):
- `/data/.clawdbot/openclaw.json`

Single logical delta applied:
- Removed line from `models.providers.openai` block:
  - `"apiKey": "${OPENAI_API_KEY}",`

No other intentional config keys were changed.

## Validation Matrix

Pre-change:
- `/healthz=200`
- `/setup=401`
- `/openclaw=503`

Post-change probes (3 rounds):
- Round 1: `/healthz=200`, `/setup=401`, `/openclaw=000`
- Round 2: `/healthz=200`, `/setup=401`, `/openclaw=000`
- Round 3: `/healthz=200`, `/setup=401`, `/openclaw=000`

Spot check (`/openclaw`, 10 requests):
- Codes: `000,000,503,000,000,000,503,000,000,000`
- `5xx_count=2`

Post-change `/healthz` signal:
- `gateway.reachable=false`
- `wrapper.stateDir=/data/.clawdbot`

## Key Log Deltas

Before change:
- Present: `MissingEnvVarError ... OPENAI_API_KEY`
- Present: `configPath: models.providers.openai.apiKey`
- Present: `File: /data/.clawdbot/openclaw.json`

After change:
- `OPENAI_API_KEY` missing-env signature: **not observed** in current post-change log window.
- New blocker observed:
  - `MissingEnvVarError: Missing env var "GEMINI_API_KEY" referenced at config path: models.providers.google.apiKey`
- File path remains:
  - `/data/.clawdbot/openclaw.json`
- `/data/.openclaw/openclaw.json` not observed in post-change logs.

## Constraint Compliance

- Minimal config edit only: satisfied.
- No rollback/reset in this pass: satisfied.
- No secret persistence in repo artifacts: satisfied.
- One controlled restart only: **at risk / not strictly provable**.
  - Setup `config/raw` save endpoint performs restart implicitly.
  - Two POST save calls were made due `HTTP 500` error response ambiguity; this may have triggered restart twice.

## Final State

- Final state: **Not recovered**.
- Outcome summary:
  - Requested branch `b` objective (remove hard `OPENAI_API_KEY` dependency) was achieved.
  - Gateway remains down with a new missing-env dependency on `GEMINI_API_KEY`.
