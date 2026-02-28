---
name: openclaw-endpoint-kit
description: Probe and package OpenClaw Railway endpoint surfaces (health, app route, setup route, textbook URL) for deployment and operator handoff.
---

# OpenClaw Endpoint Kit

Use this skill when validating or handing off deployment endpoints.

## Probe command

```bash
scripts/endpoint_probe.py --base "https://clawdbot-railway-template-production-461f.up.railway.app"
```

## Output

- HTTP status for `/`, `/healthz`, `/openclaw`, `/setup/export`
- Textbook route classification via `textbookCheck.routeKind`:
  - `textbook-static` -> textbook page is exposed
  - `openclaw-spa-shell` -> `/textbook/` still serves control UI shell
- Suggested textbook URL
- Endpoint bundle for operator handoff
