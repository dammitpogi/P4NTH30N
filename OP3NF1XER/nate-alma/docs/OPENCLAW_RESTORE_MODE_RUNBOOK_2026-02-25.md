# OpenClaw Restore Mode Runbook (2026-02-25)

## Incident Class

Runtime reachable but OpenClaw shows `configured:false` and channels are unbound.

## Guardrails

1. Capture `/setup/export` before any remediation mutation.
2. Confirm deployment/runtime health (`railway status`, `/healthz`).
3. Use setup API with explicit auth choices to avoid non-interactive hang.
4. Re-verify `/setup/api/status` and `/setup/api/debug` after each mutation.

## Recovery Sequence

1. Acquire required secrets from operator:
   - Telegram bot token
   - Anthropic auth path (setup-token, API key, or Claude CLI OAuth)
2. Run `/setup/api/run` with explicit payload.
3. Confirm `configured:true`.
4. Verify `channels.telegram.enabled:true` in debug/config output.
5. Restart gateway and check `/openclaw` auth-gated UI.

## Post-Recovery Hardening

1. Run `/setup/export` immediately after successful restore.
2. Persist restore evidence in deployment journal.
3. Keep prompt packet synced under `memory/prompt-packet-openclaw-2026-02-25`.
