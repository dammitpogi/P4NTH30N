---
type: decision
id: DECISION_165
version: 2.0.0
category: INFRA
status: superseded
created_at: '2026-02-27T01:18:00Z'
last_reviewed: '2026-02-28T14:00:00Z'
superseded_by: DECISION_172
priority: Critical
keywords:
  - alma
  - nate
  - openclaw
  - railway
  - mongodb
  - ollama
  - secrets
  - sftpgo
  - deployment-success
roles:
  - strategist
  - oracle
  - designer
  - openfixer
summary: >-
  [SUPERSEDED by DECISION_172] Deployment success criteria and admin secrets
  vault for ALMA Railway environment. All services must be online and reachable.
  Ollama provides free local LLM. OpenClaw's built-in memory/retrieval is the RAG
  implementation. Secrets stored encrypted at OP3NF1XER/nate-alma/secrets.
  
  Historical value: Defined success criteria for OpenClaw-first deployment.
  Superseded by Book-First MVP architecture with Next.js as public entry point.
---

# DECISION_165: ALMA Deployment Success + Admin Secrets Vault (v2.0.0) - SUPERSEDED

**Decision ID**: DECISION_165  
**Version**: 2.0.0 (Corrected)  
**Category**: INFRA  
**Status**: **SUPERSEDED** by DECISION_172  
**Priority**: Critical (Historical)  
**Date**: 2026-02-27  
**Superseded**: 2026-02-28

## Supersession Notice

**This decision has been superseded by DECISION_172: Book-First MVP Architecture.**

The success criteria defined here (OpenClaw public health checks, Ollama integration) were designed for an OpenClaw-first deployment. The new architecture has:
- Next.js as the public entry point (not OpenClaw)
- QMD as the retrieval engine (not OpenClaw memory)
- OpenClaw as optional internal service (client choice)

**Historical Value**: This decision established the admin secrets vault pattern and deployment validation criteria. The secrets vault location (`OP3NF1XER/nate-alma/secrets`) remains valid for the new architecture.

**Reason for Supersession**: Product pivot to Book-First MVP changes the definition of "deployment success" - now centered on Next.js + QMD + MongoDB, not OpenClaw + Ollama.

---

## Original Content (Historical)

### Correction Notice

This v2.0.0 corrects v1.0.0 errors:
- **Removed**: External RAG services (LightRAG, AnythingLLM)
- **Removed**: "LM Anywhere" references
- **Clarified**: RAG = OpenClaw's built-in memory/retrieval
- **Specified**: Ollama as the model runtime

## Success Criteria (Non-Negotiable)

Deployment is "successful" only if ALL checks pass.

### 1. OpenClaw (Public HTTPS)

| Check | Command | Expected |
|-------|---------|----------|
| Health | `curl https://$DOMAIN/healthz` | HTTP 200 |
| Setup Gate | `curl https://$DOMAIN/setup` | HTTP 401/403 without token |
| Control UI | `curl https://$DOMAIN/` | Returns HTML |

### 2. Ollama (Private, Localhost)

| Check | Command | Expected |
|-------|---------|----------|
| API Ready | `curl http://localhost:11434/api/tags` | JSON model list |
| Model Pulled | `ollama list` | Shows ≥1 model |
| Inference | Chat completion works | Valid response |

### 3. SFTPGo (TCP Proxy)

| Check | Method | Expected |
|-------|--------|----------|
| TCP Endpoint | Railway dashboard | Host:Port assigned |
| Key Auth | SFTP client | Accepts configured key |
| File Write | Upload test | File appears in `/data/workspace` |
| Host Key | Fingerprint check | Stable across redeploys |

### 4. MongoDB (Private)

| Check | Command | Expected |
|-------|---------|----------|
| Ping | `mongosh "$MONGO_URL" --eval 'db.runCommand({ ping: 1 })'` | `{ ok: 1 }` |
| Connectivity | From OpenClaw container | Connection succeeds |

### 5. OpenClaw Memory/Retrieval (RAG)

| Check | Command | Expected |
|-------|---------|----------|
| Status | `openclaw memory status --deep` | Shows provider, index size |
| Search | `openclaw memory search "deployment"` | Returns snippets |
| Index | Write to `memory/YYYY-MM-DD.md` | Appears in search results |

### 6. Persistence

| Check | Method | Expected |
|-------|--------|----------|
| Volume Mount | `ls /data` | Shows directories |
| Survives Restart | Create file → redeploy → check | File still exists |

## Configuration Requirements

### OpenClaw

**Required Variables:**
- `SETUP_PASSWORD` - Gate setup wizard
- `OPENCLAW_GATEWAY_TOKEN` - Control UI authentication
- `OLLAMA_API_KEY` - Enable Ollama (any non-empty value)
- `MONGO_URL` - MongoDB connection string

**Config File (`/data/.openclaw/openclaw.json`):**
```json5
{
  agents: {
    defaults: {
      model: {
        primary: "ollama/llama3.3",
        fallbacks: ["ollama/qwen2.5-coder:32b"]
      },
      memorySearch: {
        enabled: true,
        provider: "local",
        local: {
          modelPath: "hf:openai/text-embedding-3-small-gguf"
        },
        fallback: "none"
      }
    }
  }
}
```

### Ollama

**Models to Pre-pull:**
```bash
ollama pull llama3.3
ollama pull qwen2.5-coder:32b
```

**Environment:**
- `OLLAMA_HOST=127.0.0.1:11434` (bind localhost only)
- `OLLAMA_ORIGINS=*` (if needed for WebChat)

### SFTPGo

**Key Requirements:**
- Password authentication: DISABLED
- Public key authentication: REQUIRED
- Admin UI: DISABLED (or localhost-only)
- REST API: DISABLED (or localhost-only)

**Host Key Persistence:**
- Store in `/data/.sftpgo/hostkeys/`
- Record fingerprint after first deploy

### MongoDB

**Railway Template:**
- Use official Railway MongoDB template
- TCP Proxy: DISABLED by default
- Connection: Private networking only

## Secrets Vault

### Location

`C:\P4NTH30N\OP3NF1XER\nate-alma\secrets\`

### Structure

```
secrets/
├── store.json.enc          # Encrypted secrets store
├── alma-secrets.ps1        # PowerShell CLI
├── inventory.json          # Non-secret key listing
└── README.md               # Usage documentation
```

### CLI Commands

```powershell
# Initialize
$env:ALMA_SECRETS_KEY_B64 = "base64-of-32-random-bytes"
alma-secrets init

# Set secret
alma-secrets set railway.openclaw.setup_password --value "..."

# Get secret
alma-secrets get railway.openclaw.setup_password

# List keys
alma-secrets list
```

### Encryption

- **Algorithm**: AES-256-GCM (or XChaCha20-Poly1305)
- **Key**: 32 bytes from `ALMA_SECRETS_KEY_B64` env var
- **Storage**: Single file `store.json.enc`
- **Writes**: Atomic (temp file + rename)

### Credential Inventory

| Key | Service | Generated By |
|-----|---------|--------------|
| `railway.openclaw.setup_password` | OpenClaw | You / alma-secrets |
| `railway.openclaw.gateway_token` | OpenClaw | You / alma-secrets |
| `railway.mongodb.mongo_url` | MongoDB | Railway (copy for break-glass) |
| `sftpgo.hostkey.fingerprint_sha256` | SFTPGo | First deploy capture |
| `sftpgo.operator.public_key` | SFTPGo | You provide |

## Validation Evidence Required

Capture these outputs as deployment proof:

1. **OpenClaw Health**
   ```bash
   curl -i https://$DOMAIN/healthz
   ```

2. **Ollama Models**
   ```bash
   curl http://localhost:11434/api/tags | jq '.models[].name'
   ```

3. **Memory Search**
   ```bash
   openclaw memory search "test" --json
   ```

4. **MongoDB Ping**
   ```bash
   mongosh "$MONGO_URL" --quiet --eval 'db.runCommand({ ping: 1 })'
   ```

5. **SFTP Fingerprint**
   ```bash
   ssh-keyscan -p $TCP_PORT $TCP_HOST 2>/dev/null | ssh-keygen -lf -
   ```

## Policy Gates

**BLOCK deployment if:**
- Paid LLM API keys present in Railway vars (OpenAI, Anthropic, etc.)
- MongoDB TCP proxy enabled without explicit exception
- SFTPGo password auth enabled
- SFTPGo admin UI exposed publicly
- Secrets committed to git

**REQUIRE before mark successful:**
- All 6 success criteria pass
- Evidence captured for each
- Secrets stored in vault
- Fingerprints recorded

## Handoff

**Owner**: OpenFixer

**Deliverables:**
1. Implement secrets vault at `OP3NF1XER/nate-alma/secrets/`
2. Populate with required credentials
3. Deploy to Railway with corrected configuration
4. Capture validation evidence
5. Update `OP3NF1XER/nate-alma/dev/TOOLS.md` with endpoints

**Return:**
- Evidence bundle (screenshots/logs)
- List of secrets keys created
- TCP proxy endpoint + fingerprint
- Railway variable names (not values)

## Questions

1. **Harden**: Should we require 2+ Ollama models for fallback?
   - *Default*: Yes (primary + fallback)

2. **Expand**: Enable QMD backend for Phase 2?
   - *Default*: Defer to post-deployment

3. **Narrow**: Which model as primary?
   - *Awaiting Nexus input*
