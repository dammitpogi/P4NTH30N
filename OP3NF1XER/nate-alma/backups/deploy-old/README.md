# OpenClaw-Alma-v2 Railway Template

**OpenFixer Control**: This deployment is managed under OP3NF1XER governance.  
**SSH Preconfigured**: OpenSSH client included for remote management capabilities.

This repo packages **OpenClaw** for Railway with a small **/setup** web wizard so users can deploy and onboard **without running any commands**.

## What you get

- **OpenClaw Gateway + Control UI** (served at `/` and `/openclaw`)
- A friendly **Setup Wizard** at `/setup` (protected by a password)
- **SSH Client Preinstalled** - OpenSSH client ready for remote connections
- Persistent state via **Railway Volume** (so config/credentials/memory survive redeploys)
- One-click **Export backup** (so users can migrate off Railway later)
- **Import backup** from `/setup` (advanced recovery)

## How it works (high level)

- The container runs a wrapper web server.
- The wrapper protects `/setup` (and the Control UI at `/openclaw`) with `SETUP_PASSWORD` using HTTP Basic auth.
- During setup, the wrapper runs `openclaw onboard --non-interactive ...` inside the container, writes state to the volume, and then starts the gateway.
- After setup, **`/` is OpenClaw**. The wrapper reverse-proxies all traffic (including WebSockets) to the local gateway process.
- **SSH Access**: The container includes OpenSSH client for remote management and tunneling.

## Railway deploy instructions

In Railway Template Composer:

1) Create a new template from this repository.
2) Add a **Volume** mounted at `/data`.
3) Set the following variables:

Required:
- `SETUP_PASSWORD` — user-provided password to access `/setup` and the Control UI (`/openclaw`) via HTTP Basic auth

Recommended:
- `OPENCLAW_STATE_DIR=/data/.openclaw`
- `OPENCLAW_WORKSPACE_DIR=/data/workspace`

Optional:
- `OPENCLAW_GATEWAY_TOKEN` — if not set, the wrapper generates one (not ideal). In a template, set it using a generated secret.
- `SSH_KNOWN_HOSTS` — Base64-encoded known_hosts file for SSH connections
- `SSH_PRIVATE_KEY` — Private key for SSH authentication (stored securely)

Notes:
- This template pins OpenClaw to a released version by default via Docker build arg `OPENCLAW_GIT_REF` (override if you want `main`).
- SSH client is preinstalled at `/usr/bin/ssh` for remote management.

4) Enable **Public Networking** (HTTP). Railway will assign a domain.
   - This service listens on Railway's injected `PORT` at runtime (recommended).
5) Deploy.

Then:
- Visit `https://<your-app>.up.railway.app/setup`
  - Your browser will prompt for **HTTP Basic auth**. Use any username; the password is `SETUP_PASSWORD`.
- Complete setup
- Visit `https://<your-app>.up.railway.app/` and `/openclaw` (same Basic auth)

## SSH Configuration

The Docker image includes OpenSSH client for remote management:

```bash
# SSH is available inside the container
ssh -V

# Example: Create tunnel to remote service
ssh -N -L 8080:localhost:8080 user@remote-host

# SSH keys can be mounted via volume or environment variables
```

### Preconfigured SSH

To preconfigure SSH connections:

1. Set `SSH_KNOWN_HOSTS` environment variable with base64-encoded known_hosts
2. Set `SSH_PRIVATE_KEY` environment variable for authentication
3. The container will configure SSH on startup

## Getting chat tokens

### Telegram bot token
1) Open Telegram and message **@BotFather**
2) Run `/newbot` and follow the prompts
3) BotFather will give you a token that looks like: `123456789:AA...`
4) Paste that token into `/setup`

### Discord bot token
1) Go to the Discord Developer Portal: https://discord.com/developers/applications
2) **New Application** → pick a name
3) Open the **Bot** tab → **Add Bot**
4) Copy the **Bot Token** and paste it into `/setup`
5) Invite the bot to your server (OAuth2 URL Generator → scopes: `bot`, `applications.commands`; then choose permissions)

## Persistence (Railway volume)

Railway containers have an ephemeral filesystem. Only the mounted volume at `/data` persists across restarts/redeploys.

What persists cleanly today:
- **Custom skills / code:** anything under `OPENCLAW_WORKSPACE_DIR` (default: `/data/workspace`)
- **Node global tools (npm/pnpm):** this template configures defaults so global installs land under `/data`:
  - npm globals: `/data/npm` (binaries in `/data/npm/bin`)
  - pnpm globals: `/data/pnpm` (binaries) + `/data/pnpm-store` (store)
- **Python packages:** create a venv under `/data` (example below). The runtime image includes Python + venv support.
- **SSH configuration:** `/data/.ssh` persists for key management

What does *not* persist cleanly:
- `apt-get install ...` (installs into `/usr/*`)
- Homebrew installs (typically `/opt/homebrew` or similar)

### Optional bootstrap hook

If `/data/workspace/bootstrap.sh` exists, the wrapper will run it on startup (best-effort) before starting the gateway.
Use this to initialize persistent install prefixes or create a venv.

Example `bootstrap.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Example: create a persistent python venv
python3 -m venv /data/venv || true

# Example: ensure npm/pnpm dirs exist
mkdir -p /data/npm /data/npm-cache /data/pnpm /data/pnpm-store

# Example: configure SSH
mkdir -p /data/.ssh
chmod 700 /data/.ssh
```

## Troubleshooting

### "disconnected (1008): pairing required" / dashboard health offline

This is not a crash — it means the gateway is running, but no device has been approved yet.

Fix:
- Open `/setup`
- Use the **Debug Console**:
  - `openclaw devices list`
  - `openclaw devices approve <requestId>`

If `openclaw devices list` shows no pending request IDs:
- Make sure you're visiting the Control UI at `/openclaw` (or your native app) and letting it attempt to connect
  - Note: the Railway wrapper now proxies the gateway and injects the auth token automatically, so you should not need to paste the gateway token into the Control UI when using `/openclaw`.
- Ensure your state dir is the Railway volume (recommended): `OPENCLAW_STATE_DIR=/data/.openclaw`
- Check `/setup/api/debug` for the active state/workspace dirs + gateway readiness

### "unauthorized: gateway token mismatch"

The Control UI connects using `gateway.remote.token` and the gateway validates `gateway.auth.token`.

Fix:
- Re-run `/setup` so the wrapper writes both tokens.
- Or set both values to the same token in config.

### "Application failed to respond" / 502 Bad Gateway

Most often this means the wrapper is up, but the gateway can't start or can't bind.

Checklist:
- Ensure you mounted a **Volume** at `/data` and set:
  - `OPENCLAW_STATE_DIR=/data/.openclaw`
  - `OPENCLAW_WORKSPACE_DIR=/data/workspace`
- Ensure **Public Networking** is enabled (Railway will inject `PORT`).
- Check Railway logs for the wrapper error: it will show `Gateway not ready:` with the reason.

### Legacy CLAWDBOT_* env vars / multiple state directories

If you see warnings about deprecated `CLAWDBOT_*` variables or state dir split-brain (e.g. `~/.openclaw` vs `/data/...`):
- Use `OPENCLAW_*` variables only
- Ensure `OPENCLAW_STATE_DIR=/data/.openclaw` and `OPENCLAW_WORKSPACE_DIR=/data/workspace`
- Redeploy after fixing Railway Variables

### Build OOM (out of memory) on Railway

Building OpenClaw from source can exceed small memory tiers.

Recommendations:
- Use a plan with **2GB+ memory**.
- If you see `Reached heap limit Allocation failed - JavaScript heap out of memory`, upgrade memory and redeploy.

## Local smoke test

```bash
docker build -t openclaw-alma-v2 .

docker run --rm -p 8080:8080 \
  -e PORT=8080 \
  -e SETUP_PASSWORD=test \
  -e OPENCLAW_STATE_DIR=/data/.openclaw \
  -e OPENCLAW_WORKSPACE_DIR=/data/workspace \
  -v $(pwd)/.tmpdata:/data \
  openclaw-alma-v2

# open http://localhost:8080/setup (password: test)
```

---

## Governance

**Deployment**: OpenClaw-Alma-v2  
**Authority**: OP3NF1XER / P4NTHE0N  
**SSH Stack**: OpenSSH portable (github.com/openssh)  
**Template Base**: OpenClaw Railway Template

---

*OpenFixer Deployment - OP3NF1XER Governance*
