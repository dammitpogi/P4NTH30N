---
type: systems-documentation-list
date: 2026-02-26
for: Nexus
---

# Systems Documentation List - ALMA Railway Deployment

## Systems Requiring Documentation

### 1. OpenClaw
**Purpose**: Agent runtime and gateway
**Docs to Gather**:
- [ ] Agent workspace specification
- [ ] Configuration reference (openclaw.json)
- [ ] Memory/retrieval system (QMD integration)
- [ ] Channel configuration (Telegram)
- [ ] Provider setup (Anthropic/Claude)

**Source**: https://docs.openclaw.ai/

---

### 2. QMD (Retrieval Backend)
**Purpose**: Advanced retrieval (BM25 + vectors + reranking)
**Docs to Gather**:
- [ ] QMD installation guide
- [ ] Configuration options
- [ ] SQLite extensions requirements
- [ ] Bun runtime setup

**Source**: https://github.com/tobi/qmd

---

### 3. SFTPGo
**Purpose**: File transfer with Admin UI
**Docs to Gather**:
- [ ] Configuration reference (sftpgo.json)
- [ ] Admin UI setup
- [ ] Public key authentication
- [ ] Volume mount requirements

**Source**: https://github.com/drakkan/sftpgo

---

### 4. MongoDB
**Purpose**: Persistence via Railway template
**Docs to Gather**:
- [ ] Railway MongoDB template setup
- [ ] Connection string format
- [ ] Private networking configuration

**Source**: Railway documentation

---

### 5. Railway Platform
**Purpose**: Deployment infrastructure
**Docs to Gather**:
- [ ] Volume mount configuration
- [ ] Environment variables
- [ ] Health check setup
- [ ] TCP proxy configuration

**Source**: https://docs.railway.app/

---

## Credentials List (Updated - No Ollama)

### Pre-Deploy (Required Before Deployment)

| Credential | Service | How to Obtain | Vault Key |
|------------|---------|---------------|-----------|
| **Vault Encryption Key** | Secrets Vault | Generate 32 random bytes | `ALMA_SECRETS_KEY_B64` (env var) |
| **OpenClaw Setup Password** | OpenClaw | Generate 24+ chars | `railway.openclaw.setup_password` |
| **OpenClaw Gateway Token** | OpenClaw | Generate 32+ chars | `railway.openclaw.gateway_token` |
| **Claude Setup Key** | Anthropic | Run `claude setup` | `claude.setup_key` |
| **Telegram Bot Token** | Telegram | @BotFather | `telegram.bot.token` |
| **Telegram Webhook Secret** | Telegram | Generate 32+ chars | `telegram.webhook.secret` |

### Post-Vault, Pre-Deploy

| Credential | Service | How to Obtain | Vault Key |
|------------|---------|---------------|-----------|
| **SFTPGo Operator Public Key** | SFTPGo | Generate SSH keypair | `sftpgo.operator.public_key` |

### Post-Deploy (Capture After Deployment)

| Credential | Service | How to Obtain | Vault Key |
|------------|---------|---------------|-----------|
| **MongoDB Connection URL** | MongoDB | Railway dashboard | `railway.mongodb.mongo_url` |
| **SFTPGo Host Key Fingerprint** | SFTPGo | SSH keyscan | `sftpgo.hostkey.fingerprint_sha256` |
| **Railway Service Domain** | Railway | Railway dashboard | `railway.service.domain` |

---

## Configuration Files Needed

### OpenClaw
- `openclaw.json` - Main configuration
  - Memory backend: QMD
  - Model provider: Anthropic (post-setup)
  - Channels: Telegram

### SFTPGo
- `sftpgo.json` - SFTP server configuration
  - Admin UI: ENABLED
  - Public key auth: REQUIRED
  - Password auth: DISABLED

### Railway
- `railway.toml` - Deployment configuration
  - Volume mount: `/data`
  - Health check: `/setup/healthz`

---

## Summary

**Systems**: 5 (OpenClaw, QMD, SFTPGo, MongoDB, Railway)
**Credentials**: 10 total (6 pre-deploy, 1 post-vault, 3 post-deploy)
**Model Provider**: Anthropic (Claude) - configured post-deployment
**Removed**: Ollama (not required by client)
