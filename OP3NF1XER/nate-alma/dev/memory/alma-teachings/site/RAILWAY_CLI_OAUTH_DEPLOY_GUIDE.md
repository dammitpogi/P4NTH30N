# Railway CLI OAuth/Token Deployment Guide

Source reference: `https://docs.railway.com/cli`

## Authentication modes

### Interactive OAuth login

```bash
railway login
```

Use this when a browser is available.

### Browserless login

```bash
railway login --browserless
```

Use this in remote shells where you can manually complete device auth flow.

### Token-based auth (CI/CD and non-interactive)

- Project token: `RAILWAY_TOKEN`
- Account/workspace token: `RAILWAY_API_TOKEN`

Example:

```bash
RAILWAY_TOKEN=xxx railway up
```

## OpenClaw deployment sequence

```bash
railway whoami
railway link --project 1256dcd2-0929-417a-8f32-39137ffa523b --service 2224d9e4-80a7-49d5-b2d4-cf37385fc843
railway status
railway up --detach
railway logs -n 200
```

## Post-deploy checks

```bash
python skills/openclaw-endpoint-kit/scripts/endpoint_probe.py --base "https://clawdbot-railway-template-production-461f.up.railway.app"
```
