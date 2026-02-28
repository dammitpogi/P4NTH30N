# ROOT_SOURCE_AND_PREVENTION_DECISION_055_v1

## Root Source (Evidence)

- Session log file:
  - `STR4TEG15T/tools/.clawdbot/agents/main/sessions/86a82de1-b44f-4261-aa99-5391cbe94248.jsonl`

- Causal sequence:
  1. `2026-02-24T02:32:20Z` (`message_id: 1404`)
     - User requests fallback cascade + full multi-agent setup.
  2. `2026-02-24T02:41:07Z` (`message_id: 1406`)
     - User requests OpenAI + Gemini added with keys stored in Railway.
  3. `2026-02-24T08:25:26Z` (`GatewayRestart` config-apply)
     - Config patch applied at `/data/.clawdbot/openclaw.json`.

- Runtime impact observed in deployment logs:
  - `MissingEnvVarError OPENAI_API_KEY` at `models.providers.openai.apiKey`.
  - After OpenAI dependency removal, new `MissingEnvVarError GEMINI_API_KEY` at `models.providers.google.apiKey`.

## Root Cause Statement

Provider dependencies were enabled in active config before corresponding provider env vars were confirmed present/valid in runtime, creating a cascading missing-env startup failure.

## Prevention Instructions (Operational)

1. Enforce two-phase provider onboarding:
   - Phase A: upsert env var(s) in Railway and verify visibility.
   - Phase B: apply config provider dependency and restart once.

2. Add config-save preflight guard:
   - Reject config writes that introduce `models.providers.*.apiKey` interpolation when env var is unset.

3. Add post-save verification gate:
   - Run `healthz/openclaw` probes and log scan for `MissingEnvVarError` before considering change successful.

4. Keep provider adds atomic:
   - Add one provider at a time to isolate failures and simplify rollback.
