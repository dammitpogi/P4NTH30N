---
type: handoff
decision: DECISION_146
owner: OpenFixer
status: ready
created_at: '2026-02-27T00:57:23Z'
---

# HANDOFF: DECISION_146 (OpenFixer)

Use `STR4TEG15T/memory/decisions/DECISION_146_ALMA_RAILWAY_MERGED_ENVIRONMENT.md` as the single source of truth.

## Mission

Deploy ALMA's Railway environment using a single merged container service:

- OpenClaw Railway template + SFTPGo inside same container
- Single Railway Volume mounted at `/data`
- Public HTTPS for OpenClaw (bind `$PORT`)
- Public SFTP via Railway TCP Proxy (internal `2022`, external host:port assigned)
- Railway MongoDB template as persistence (private networking)

Constraints:

- No paid LLM API dependency required for core operation
- Default prohibition: do not set `OPENAI_API_KEY` / `OPENROUTER_API_KEY` / `ANTHROPIC_API_KEY` in Railway Variables
- Do not install or expose OpenSSH (use `railway ssh` + SFTPGo)

## File Targets

- Deployment scaffold root: `OP3NF1XER/nate-alma/deploy`
  - Nexus will clear/populate this with the OpenClaw Railway template; scaffold from that state.
- Secrets scaffolding (inventory only): `OP3NF1XER/nate-alma/secrets`
- Operator endpoints: `OP3NF1XER/nate-alma/dev/TOOLS.md` (update with real host:port + fingerprints post-deploy)

## Required Railway Services

- `openclaw` (public HTTP + public TCP proxy for SFTP; volume mounted at `/data`)
- `mongodb` (Railway template; private networking; disable TCP proxy unless explicitly needed)

Optional (only if they can use LM Anywhere with no paid-provider keys):

- `lightrag` (LightRAG template)
- `anythingllm` (AnythingLLM template: `https://railway.com/deploy/HNSCS1`)

## Validation Evidence (must capture)

- `railway status` and `railway logs` showing clean boot
- HTTP:
  - `curl -i https://<domain>/healthz`
  - `curl -i https://<domain>/setup` (auth gated)
- In-container (via `railway ssh`):
  - `echo "$RAILWAY_VOLUME_MOUNT_PATH"` equals `/data`
  - `test -w /data`
  - `ss -lntp` shows OpenClaw on `$PORT` and SFTPGo on `0.0.0.0:2022`
- SFTP:
  - Connect to Railway-assigned TCP proxy endpoint (record `host:port`)
  - Record SSH host key fingerprint; verify persistence across redeploy
- MongoDB:
  - From inside `openclaw` service: `mongosh "$MONGO_URL" --eval 'db.runCommand({ ping: 1 })'`
- Persistence sentinel:
  - Create `/data/workspace/_sentinel.txt`, restart/redeploy, verify it persists

## Copy/Paste Prompt (for OpenFixer execution)

```
OpenFixer, execute DECISION_146 using `OP3NF1XER/nate-alma/deploy` as the scaffold (OpenClaw Railway template will be placed there by Nexus).

Implement a single Railway service container that runs OpenClaw + SFTPGo sharing a Railway Volume mounted at /data.

Non-negotiables:
1) Bind HTTP to $PORT (do not hardcode).
2) SFTPGo binds internal 2022; expose via Railway TCP Proxy; record assigned external host:port + hostkey fingerprint.
3) No OpenSSH daemon.
4) Add Railway MongoDB template and connect using MONGO_URL over private networking.
5) No paid-provider API keys in Railway Variables by default.
6) Provide validation evidence per DECISION_146.

Update `OP3NF1XER/nate-alma/dev/TOOLS.md` with:
- OpenClaw domain
- SFTP TCP proxy host:port
- SFTP host key fingerprint
- MongoDB internal connection reference (MONGO_URL)

Report back with the validation outputs and exact Railway service configuration.
```
