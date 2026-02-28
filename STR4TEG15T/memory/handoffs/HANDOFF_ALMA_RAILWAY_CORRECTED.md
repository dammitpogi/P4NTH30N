# HANDOFF: ALMA Railway Deployment (Corrected)

**Owner**: OpenFixer  
**Decision**: DECISION_146 v2.0.0 + DECISION_165 v2.0.0  
**Date**: 2026-02-27

## Scope

Deploy ALMA (Nate's OpenClaw agent) to Railway with:
- ✅ OpenClaw + SFTPGo + Ollama in merged container
- ✅ Railway Volume at `/data` for persistence
- ✅ MongoDB via Railway template
- ✅ Free local LLM (Ollama) - no paid APIs
- ✅ Built-in memory/retrieval (RAG) - no external services

## What Changed (From GPT-5.2 Errors)

| Incorrect (v1.x) | Correct (v2.0.0) |
|-----------------|------------------|
| LightRAG service | Removed - unnecessary |
| AnythingLLM service | Removed - unnecessary |
| "LM Anywhere" runtime | Ollama (documented, working) |
| External RAG | OpenClaw built-in memory_search/memory_get |
| Paid API dependency | Free local models only |

## File Targets

### 1. Dockerfile (`OP3NF1XER/nate-alma/deploy/Dockerfile`)

**Current state**: Builds OpenClaw from source, includes SFTPGo  
**Required changes**:
- Add Ollama installation
- Pre-pull recommended models (or document runtime pull)
- Ensure all services run under supervisord

**Add to Dockerfile:**
```dockerfile
# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Create Ollama directories in /data
RUN mkdir -p /data/ollama
ENV OLLAMA_HOME=/data/ollama

# Note: Models pulled at runtime to keep image size reasonable
# Alternative: Pre-pull during build if size acceptable
```

### 2. Supervisord (`OP3NF1XER/nate-alma/deploy/supervisord.conf`)

**Add Ollama program:**
```ini
[program:ollama]
command=/usr/local/bin/ollama serve
autorestart=true
priority=1
environment=OLLAMA_HOME=/data/ollama,OLLAMA_HOST=127.0.0.1:11434
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr
```

**Update OpenClaw program:**
```ini
[program:openclaw]
command=node /app/openclaw/dist/entry.js gateway run --bind 0.0.0.0 --port 8080 --data-dir /data --workspace /data/workspace
autorestart=true
priority=2
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr
```

### 3. OpenClaw Config (`OP3NF1XER/nate-alma/deploy/openclaw.json`)

**Create this file:**
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

### 4. Railway Config (`OP3NF1XER/nate-alma/deploy/railway.toml`)

**Current state**: Ports 8080 and 2022 defined  
**No changes required** - Ollama runs on localhost only (port 11434, not exposed)

### 5. Secrets Vault (`OP3NF1XER/nate-alma/secrets/`)

**Create:**
- `alma-secrets.ps1` - PowerShell CLI for encrypted store
- `store.json.enc` - Encrypted secrets (created at runtime)
- `inventory.json` - Key listing (non-secret)
- `README.md` - Usage docs

**Implement CLI:**
```powershell
# Commands needed:
alma-secrets init                    # Initialize store
alma-secrets set <key> --value <v>   # Set secret
alma-secrets get <key>               # Get secret
alma-secrets list                    # List keys
```

## Railway Variables

Set these in Railway dashboard:

| Variable | Value | Source |
|----------|-------|--------|
| `SETUP_PASSWORD` | (generate) | alma-secrets |
| `OPENCLAW_GATEWAY_TOKEN` | (generate) | alma-secrets |
| `OLLAMA_API_KEY` | `ollama-local` | Static |
| `MONGO_URL` | (Railway provides) | Railway MongoDB template |

## Deployment Steps

1. **Build and push**
   ```bash
   cd OP3NF1XER/nate-alma/deploy
   # Railway CLI deploy
   railway up
   ```

2. **Pull Ollama models** (first deploy)
   ```bash
   railway ssh
   ollama pull llama3.3
   ollama pull qwen2.5-coder:32b
   ```

3. **Configure SFTPGo user**
   ```bash
   # Generate host keys
   sftpgo gen-host-keys -d /data/.sftpgo/hostkeys
   
   # Add operator user (key-only)
   sftpgo user add username --public-key "ssh-ed25519 AAA..."
   ```

4. **Verify all services**
   ```bash
   # From inside container
   curl http://localhost:11434/api/tags  # Ollama
   curl http://localhost:8080/healthz    # OpenClaw
   mongosh "$MONGO_URL" --eval 'db.runCommand({ ping: 1 })'  # MongoDB
   ```

## Validation Checklist

Capture evidence for each:

- [ ] OpenClaw HTTPS health check passes
- [ ] Setup wizard requires password
- [ ] Ollama API responds with model list
- [ ] Chat completion via Ollama works
- [ ] Memory search returns results
- [ ] SFTP key authentication works
- [ ] File upload persists to `/data/workspace`
- [ ] MongoDB ping succeeds
- [ ] Host key fingerprint recorded
- [ ] Secrets stored in vault

## Success Evidence to Return

1. **Screenshots/logs** of all validation checks
2. **Railway domain** (e.g., `alma-production.up.railway.app`)
3. **SFTP endpoint** (TCP proxy host:port)
4. **Host key fingerprint** (SHA256)
5. **Secrets inventory** (list of keys, not values)
6. **Updated TOOLS.md** with endpoints and fingerprints

## Policy Compliance

**BLOCK if:**
- Paid LLM keys in Railway vars
- MongoDB TCP proxy enabled
- SFTPGo password auth enabled
- Secrets in git

**REQUIRE:**
- All validation checks pass
- Evidence captured
- Fingerprints recorded

## Questions for Nexus

1. **Primary Ollama model**: `llama3.3` (70B), `qwen2.5-coder:32b`, or other?
2. **Pre-pull models**: At build time (larger image) or runtime (first deploy)?
3. **SFTP operator key**: Provide public key for initial user setup?

## Reference

- DECISION_146 v2.0.0: Architecture specification
- DECISION_165 v2.0.0: Success criteria and secrets
- DECISION_166: Model selection governance (GPT-5.2 audit)
- OpenClaw docs: `OP3NF1XER/nate-alma/openclaw/docs/`
