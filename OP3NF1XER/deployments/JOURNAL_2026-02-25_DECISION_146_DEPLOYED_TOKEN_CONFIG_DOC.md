# Deployment Journal - DECISION_146 Deployed Token Config Documentation

Date: 2026-02-25  
Decision: `DECISION_146`

## Objective

Document where to plug Claude setup-token and Telegram bot token in a deployed OpenClaw install, with no base-code or Railway deployment modifications.

## Actions Executed

1. Confirmed deployed wrapper and core config/auth path behavior from local Nate-Alma mirrors.
2. Wrote documentation at `OP3NF1XER/nate-alma/docs/DEPLOYED_CONFIG_TOKEN_PLUG_POINTS.md`.
3. Linked new doc in `OP3NF1XER/nate-alma/docs/INDEX.md`.

## Verification Snapshot

- Documentation includes:
  - canonical config path (`/data/.openclaw/openclaw.json` under default state dir),
  - Claude setup-token UI/auth-profile placement,
  - Telegram token config key placement (`channels.telegram.botToken`),
  - read-only verification endpoints and commands.
- No implementation code files changed under OpenClaw runtime source.

## Recommendation

Use this doc as the standard operator reference when deployed credentials are available.
