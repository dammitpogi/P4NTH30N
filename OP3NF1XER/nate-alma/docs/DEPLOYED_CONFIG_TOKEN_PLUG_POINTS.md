# Deployed Config Token Plug Points

This note documents where to place values after the deployed install exists.
No base-code edits and no Railway template changes are required.

## Canonical Config Path

- Wrapper default path: `OPENCLAW_STATE_DIR/openclaw.json`.
- Wrapper override path: `OPENCLAW_CONFIG_PATH`.
- In this Nate-Alma lane, the expected deployed state root is `/data/.openclaw`,
  so canonical config is usually `/data/.openclaw/openclaw.json`.

## Claude Setup Token (Anthropic)

### Setup UI path

1. Open `/setup`.
2. Auth choice: `Anthropic token (paste setup-token)`.
3. Paste token in `Key / Token (if required)`.
4. Run setup.

### Config/auth storage path

- Stored as an auth profile in `auth-profiles.json`.
- Default main-agent location on deployed state dir:
  - `/data/.openclaw/agents/main/agent/auth-profiles.json`

## Telegram Bot Token

### Setup UI path

1. Open `/setup`.
2. Paste value in `Telegram bot token (optional)`.
3. Run setup.

### Config key path

- Main key: `channels.telegram.botToken`
- File path: `/data/.openclaw/openclaw.json` (or `OPENCLAW_CONFIG_PATH` override)

## Verification (Read-Only)

- Setup health:
  - `GET /setup/api/status`
- Wrapper/OpenClaw debug snapshot:
  - `GET /setup/api/debug`
- Config read via CLI (inside deployment runtime):
  - `openclaw config get channels.telegram`

## Security Handling

- Do not commit raw tokens into git-tracked files.
- Use `/setup` for secret entry whenever possible.
- If you inspect config in logs or screenshots, redact token values.
