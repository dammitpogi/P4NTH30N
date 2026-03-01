---
type: decision
id: DECISION_168
version: 1.0.0
category: INFRA
status: superseded
created_at: '2026-02-27T03:00:00Z'
last_reviewed: '2026-02-28T14:00:00Z'
superseded_by: DECISION_172
priority: Critical
keywords:
  - alma
  - nate
  - openclaw
  - railway
  - qmd
  - sftpgo
  - mongodb
  - deployment
  - environment
roles:
  - strategist
  - oracle
  - designer
  - openfixer
  - windfixer
summary: >-
  [SUPERSEDED by DECISION_172] ALMA Railway deployment with QMD backend for
  advanced retrieval (BM25 + vectors + reranking), SFTPGo for file transfer,
  MongoDB for persistence, and encrypted secrets vault. Solves all documented
  Railway deployment pains from prior attempts.
  
  Historical value: Captured QMD integration approach and Railway deployment
  patterns. Superseded by Book-First MVP architecture with Next.js frontend.
---

# DECISION_168: QMD Railway Deployment - Complete Environment (v1.0.0) - SUPERSEDED

**Decision ID**: DECISION_168  
**Version**: 1.0.0  
**Category**: INFRA  
**Status**: **SUPERSEDED** by DECISION_172  
**Priority**: Critical (Historical)  
**Date**: 2026-02-26  
**Superseded**: 2026-02-28

## Supersession Notice

**This decision has been superseded by DECISION_172: Book-First MVP Architecture.**

The QMD-focused deployment approach in this decision has been integrated into a broader 3-service architecture where:
- Next.js is the public entry point (not OpenClaw)
- QMD runs in the Core container as internal service
- MongoDB is internal only
- OpenClaw is optional (client choice)

**Historical Value**: This decision captured QMD integration patterns, Railway deployment hardening, and solutions to prior deployment failures (config remediation, rollback procedures, health validation).

**Reason for Supersession**: Product pivot to Book-First MVP requires Next.js as primary interface, not OpenClaw. QMD remains the retrieval engine but is accessed via internal API, not as public service.

---

## Original Content (Historical)

**Decision ID**: DECISION_168  
**Version**: 1.0.0  
**Category**: INFRA  
**Status**: Draft  
**Priority**: Critical  
**Date**: 2026-02-26

## Mission

Deploy ALMA (Nate's OpenClaw agent) to Railway with **complete, production-ready environment** including:

- **OpenClaw**: All features operational with QMD backend for advanced retrieval
- **SFTPGo**: File transfer with key-only authentication
- **MongoDB**: Persistence via Railway template
- **QMD**: Advanced retrieval backend (BM25 + vectors + reranking)
- **Secrets Vault**: Encrypted CRUD store at `OP3NF1XER/nate-alma/secrets`

## Historical Pain Points (SOLVED)

Based on analysis of R050 (OpenClaw Railway incident), R049 (deployment documentation drift), and all prior Railway deployments:

| Pain Point | Root Cause | Solution in This Decision |
|------------|------------|---------------------------|
| **Hard provider env dependencies** | Active config at `/data/.clawdbot/openclaw.json` with interpolated API keys | Separate build-time config from runtime config; use Railway variables only |
| **Rollback failure** | Control plane rollback didn't recover runtime | Health checks + circuit breaker + explicit validation gates |
| **Volume mount failures** | `requiredMountPath` unmet at `/data` | Explicit volume configuration in railway.toml |
| **Missing src/ and entrypoint.sh** | Documentation drift between spec and implementation | Complete file inventory with checksums |
| **Provider throttle cascades** | Rapid retries without backoff | Exponential backoff + circuit breaker pattern |
| **Config interpolation errors** | JSON with env vars breaking parser | Separate config layers: static + templated |
| **Missing health validation** | No runtime verification after deploy | 8-point success criteria with automated checks |
| **Secrets in environment** | API keys visible in Railway dashboard | Encrypted vault + env var references only |

## System Topology

### Services Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         Railway Project (ALMA-QMD)                          │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │              Debian Bookworm Container (Merged Service)              │   │
│  │                                                                      │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐                 │   │
│  │  │   OpenClaw   │  │    SFTPGo    │  │    QMD      │                 │   │
│  │  │   Gateway    │  │   (sftp)     │  │ (retrieval) │                 │   │
│  │  │   :8080      │  │   :2022      │  │   :3000     │                 │   │
│  │  └──────────────┘  └──────────────┘  └─────────────┘                 │   │
│  │                                                                      │   │
│  │  ┌────────────────────────────────────────────────────────────────┐ │   │
│  │  │              Railway Volume (mounted at /data)                  │ │   │
│  │  │  ┌────────────┐ ┌────────────┐ ┌──────────────┐                │ │   │
│  │  │  │  OpenClaw  │ │   SFTPGo   │ │     QMD      │                │ │   │
│  │  │  │   state    │ │   files    │ │   index/     │                │ │   │
│  │  │  │            │ │            │ │   cache      │                │ │   │
│  │  │  └────────────┘ └────────────┘ └──────────────┘                │ │   │
│  │  └────────────────────────────────────────────────────────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  External: MongoDB (Railway Template)                                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Port Allocation

| Port | Service | Exposure | Purpose |
|------|---------|----------|---------|
| 8080 | OpenClaw HTTP | Public (Railway domain) | Gateway, Control UI, WebChat |
| 2022 | SFTPGo | TCP Proxy | File transfer |
| 3000 | QMD | Private (localhost only) | Retrieval backend |
| 18789 | OpenClaw Gateway | Private (localhost only) | Internal gateway |

## Component Specifications

### 1. OpenClaw (Primary)

**Version**: Latest (`openclaw@latest`)  
**Runtime**: Node.js 22 (Bookworm)  
**State Directory**: `/data/.openclaw/`  
**Workspace**: `/data/workspace/`

**Configuration** (`/data/.openclaw/openclaw.json`):
```json5
{
  agents: {
    defaults: {
      memorySearch: {
        enabled: true,
        provider: "local",
        local: {
          modelPath: "hf:openai/text-embedding-3-small-gguf"
        },
        fallback: "none"
      }
    }
  },
  memory: {
    backend: "qmd",
    citations: "auto",
    qmd: {
      includeDefaultMemory: true,
      update: { interval: "5m", debounceMs: 15000 },
      limits: { maxResults: 6, timeoutMs: 4000 }
    }
  }
}
```

**Note**: Model provider configuration (Anthropic, OpenAI, etc.) is client-specific and configured separately.

### 2. QMD (Retrieval Backend)

**Repository**: `https://github.com/tobi/qmd`  
**Runtime**: Bun + SQLite with extensions + node-llama-cpp  
**XDG Directories**: `/data/.qmd/xdg-config/`, `/data/.qmd/xdg-cache/`

**Prerequisites**:
- Bun 1.1+ installed
- SQLite with loadable extensions support
- node-llama-cpp native bindings

**Installation**:
```bash
# Install Bun
curl -fsSL https://bun.sh/install | bash

# Install QMD globally
bun install -g https://github.com/tobi/qmd

# QMD auto-downloads GGUF models on first use
```

**Configuration**:
```json5
{
  memory: {
    backend: "qmd",
    qmd: {
      command: "qmd",
      searchMode: "search",
      includeDefaultMemory: true,
      update: {
        interval: "5m",
        debounceMs: 15000,
        onBoot: true,
        waitForBootSync: false
      },
      limits: {
        maxResults: 6,
        maxSnippetChars: 700,
        timeoutMs: 4000
      }
    }
  }
}
```

### 3. SFTPGo (File Transfer)

**Version**: Latest stable  
**Configuration**: `/data/.sftpgo/sftpgo.json`  
**Host Keys**: `/data/.sftpgo/hostkeys/`  
**User Files**: `/data/workspace/`

**Security Requirements**:
- Password authentication: DISABLED
- Public key authentication: REQUIRED
- Admin UI: ENABLED (via Railway domain)
- REST API: ENABLED (via Railway domain)

### 4. MongoDB (Persistence)

**Source**: Railway MongoDB template  
**Access**: Private networking only (no TCP proxy)  
**Connection**: Via `MONGO_URL` environment variable

## Railway Configuration

### railway.toml

```toml
[build]
builder = "dockerfile"
dockerfilePath = "Dockerfile"

[deploy]
healthcheckPath = "/setup/healthz"
healthcheckTimeout = 300
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 3

[[deploy.volumes]]
name = "alma-data"
mountPath = "/data"

[variables]
PORT = "8080"
NODE_ENV = "production"
```

### Required Environment Variables

| Variable | Service | Source | Purpose |
|----------|---------|--------|---------|
| `SETUP_PASSWORD` | OpenClaw | You generate | Gate setup wizard |
| `OPENCLAW_GATEWAY_TOKEN` | OpenClaw | You generate | Control UI auth |
| `MONGO_URL` | MongoDB | Railway template | Database connection |
| `QMD_ENABLED` | QMD | Set to "true" | Enable QMD backend |
| `SFTPGO_OPERATOR_KEY` | SFTPGo | You provide | Operator SSH public key |

### Generated/Runtime Variables

| Variable | Source | Purpose |
|----------|--------|---------|
| `RAILWAY_DOMAIN` | Railway | Public HTTPS endpoint |
| `RAILWAY_SERVICE_NAME` | Railway | Service identifier |
| `SFTPGO_HOSTKEY_FP` | First deploy | Recorded fingerprint |

## Dockerfile (Complete)

```dockerfile
# ============================================================================
# ALMA QMD Railway Deployment - Complete Dockerfile
# ============================================================================
# Base: Debian Bookworm (not Alpine - QMD needs glibc)
FROM node:22-bookworm

# ----------------------------------------------------------------------------
# Phase 1: System Dependencies
# ----------------------------------------------------------------------------
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    # Core utilities
    ca-certificates \
    curl \
    git \
    gosu \
    procps \
    python3 \
    python3-pip \
    build-essential \
    pkg-config \
    # SQLite with extensions (required for QMD)
    sqlite3 \
    libsqlite3-dev \
    # SFTPGo dependencies
    openssh-client \
    # QMD/Bun dependencies
    unzip \
    # Cleanup
    && rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------------------------
# Phase 2: Install Bun (for QMD)
# ----------------------------------------------------------------------------
RUN curl -fsSL https://bun.sh/install | bash
ENV BUN_INSTALL="/root/.bun"
ENV PATH="$BUN_INSTALL/bin:$PATH"

# ----------------------------------------------------------------------------
# Phase 3: Install QMD
# ----------------------------------------------------------------------------
RUN bun install -g https://github.com/tobi/qmd

# ----------------------------------------------------------------------------
# Phase 3: Install OpenClaw
# ----------------------------------------------------------------------------
RUN npm install -g openclaw@latest

# ----------------------------------------------------------------------------
# Phase 4: Create User and Directories
# ----------------------------------------------------------------------------
RUN useradd -m -s /bin/bash openclaw \
    && mkdir -p /data \
    && mkdir -p /app \
    && chown -R openclaw:openclaw /data \
    && chown -R openclaw:openclaw /app

# ----------------------------------------------------------------------------
# Phase 5: Application Setup
# ----------------------------------------------------------------------------
WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile --prod

# Copy application source
COPY src ./src
COPY scripts ./scripts
COPY entrypoint.sh ./entrypoint.sh
COPY supervisord.conf ./supervisord.conf

# Make scripts executable
RUN chmod +x entrypoint.sh scripts/*.sh

# ----------------------------------------------------------------------------
# Phase 6: Health Check
# ----------------------------------------------------------------------------
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/setup/healthz || exit 1

# ----------------------------------------------------------------------------
# Phase 7: Runtime
# ----------------------------------------------------------------------------
EXPOSE 8080 2022

USER root
ENTRYPOINT ["./entrypoint.sh"]
```

## Entrypoint Script

```bash
#!/bin/bash
set -e

# ============================================================================
# ALMA QMD Entrypoint - Orchestrates All Services
# ============================================================================

echo "[ALMA] Starting initialization..."

# ----------------------------------------------------------------------------
# Phase 1: Volume Setup
# ----------------------------------------------------------------------------
echo "[ALMA] Setting up volume directories..."
chown -R openclaw:openclaw /data
chmod 700 /data

# Create required directories
mkdir -p /data/.openclaw
mkdir -p /data/.qmd/xdg-config
mkdir -p /data/.qmd/xdg-cache
mkdir -p /data/.sftpgo/hostkeys
mkdir -p /data/workspace
mkdir -p /var/log/supervisor

chown -R openclaw:openclaw /data

# ----------------------------------------------------------------------------
# Phase 2: QMD Setup
# ----------------------------------------------------------------------------
echo "[ALMA] Configuring QMD..."
export XDG_CONFIG_HOME=/data/.qmd/xdg-config
export XDG_CACHE_HOME=/data/.qmd/xdg-cache

# Initialize QMD collection if not exists
if [ ! -d "$XDG_CONFIG_HOME/qmd/collections" ]; then
    echo "[ALMA] Initializing QMD..."
    mkdir -p "$XDG_CONFIG_HOME/qmd/collections"
fi

# ----------------------------------------------------------------------------
# Phase 4: OpenClaw Configuration
# ----------------------------------------------------------------------------
echo "[ALMA] Configuring OpenClaw..."
export OPENCLAW_STATE_DIR=/data/.openclaw
export OPENCLAW_WORKSPACE_DIR=/data/workspace

# Create initial config if not exists
if [ ! -f "$OPENCLAW_STATE_DIR/openclaw.json" ]; then
    echo "[ALMA] Creating initial OpenClaw config..."
    mkdir -p "$OPENCLAW_STATE_DIR"
    cat > "$OPENCLAW_STATE_DIR/openclaw.json" << 'EOF'
{
  "agents": {
    "defaults": {
      "memorySearch": {
        "enabled": true,
        "provider": "local",
        "local": {
          "modelPath": "hf:openai/text-embedding-3-small-gguf"
        },
        "fallback": "none"
      }
    }
  },
  "memory": {
    "backend": "qmd",
    "citations": "auto",
    "qmd": {
      "includeDefaultMemory": true,
      "update": {
        "interval": "5m",
        "debounceMs": 15000,
        "onBoot": true,
        "waitForBootSync": false
      },
      "limits": {
        "maxResults": 6,
        "timeoutMs": 4000
      }
    }
  }
}
EOF
    chown -R openclaw:openclaw "$OPENCLAW_STATE_DIR"
fi

# ----------------------------------------------------------------------------
# Phase 5: SFTPGo Setup
# ----------------------------------------------------------------------------
echo "[ALMA] Configuring SFTPGo..."
if [ ! -f /data/.sftpgo/sftpgo.json ]; then
    mkdir -p /data/.sftpgo
    # SFTPGo config will be generated on first run
fi

# ----------------------------------------------------------------------------
# Phase 6: Start Supervisord
# ----------------------------------------------------------------------------
echo "[ALMA] Starting services via supervisord..."
exec gosu openclaw /usr/bin/supervisord -c /app/supervisord.conf
```

## Supervisord Configuration

```ini
[supervisord]
nodaemon=true
user=openclaw
logfile=/var/log/supervisor/supervisord.log
pidfile=/var/run/supervisord.pid

[program:qmd]
command=qmd server
environment=XDG_CONFIG_HOME=/data/.qmd/xdg-config,XDG_CACHE_HOME=/data/.qmd/xdg-cache
autostart=true
autorestart=true
priority=10
stdout_logfile=/var/log/supervisor/qmd.log
stderr_logfile=/var/log/supervisor/qmd.err

[program:openclaw]
command=node src/server.js
environment=NODE_ENV=production,PORT=8080,OPENCLAW_STATE_DIR=/data/.openclaw,OPENCLAW_WORKSPACE_DIR=/data/workspace
autostart=true
autorestart=true
priority=20
stdout_logfile=/var/log/supervisor/openclaw.log
stderr_logfile=/var/log/supervisor/openclaw.err

[program:sftpgo]
command=sftpgo serve -c /data/.sftpgo
autostart=true
autorestart=true
priority=30
stdout_logfile=/var/log/supervisor/sftpgo.log
stderr_logfile=/var/log/supervisor/sftpgo.err
```

## Success Criteria (7-Point Validation)

Deployment is **successful** only if ALL checks pass:

### 1. OpenClaw Health
```bash
curl -fsS https://$RAILWAY_DOMAIN/healthz
# Expected: HTTP 200
```

### 2. QMD Backend
```bash
qmd status
# Expected: Shows collections, index status
```

### 3. Memory Search
```bash
openclaw memory search "test query" --json
# Expected: Returns snippets with scores
```

### 4. MongoDB Connection
```bash
mongosh "$MONGO_URL" --quiet --eval 'db.runCommand({ ping: 1 })'
# Expected: { ok: 1 }
```

### 5. SFTP Access
```bash
ssh-keyscan -p $TCP_PORT $TCP_HOST 2>/dev/null | ssh-keygen -lf -
# Expected: Stable fingerprint
```

### 6. SFTPGo Admin UI
```bash
curl -fsS http://localhost:8080/sftpgo/admin
# Expected: HTTP 200 (Admin UI accessible)
```

### 7. Volume Persistence
```bash
# Create test file
echo "test" > /data/persistence-test.txt
# Redeploy
# Verify file still exists
cat /data/persistence-test.txt
# Expected: "test"
```

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

### Required Secrets

| Key | Service | Generated By | Stored When |
|-----|---------|--------------|-------------|
| `railway.openclaw.setup_password` | OpenClaw | You / alma-secrets | Pre-deploy |
| `railway.openclaw.gateway_token` | OpenClaw | You / alma-secrets | Pre-deploy |
| `railway.mongodb.mongo_url` | MongoDB | Railway (copy) | Post-deploy |
| `sftpgo.hostkey.fingerprint_sha256` | SFTPGo | First deploy capture | Post-deploy |
| `sftpgo.operator.public_key` | SFTPGo | You provide | Pre-deploy |

### Encryption
- **Algorithm**: AES-256-GCM
- **Key**: 32 bytes from `ALMA_SECRETS_KEY_B64` environment variable
- **Storage**: Atomic writes (temp file + rename)

## Policy Gates

**BLOCK deployment if:**
- MongoDB TCP proxy enabled
- SFTPGo password auth enabled
- Secrets committed to git
- Missing required environment variables

**REQUIRE before mark successful:**
- All 7 success criteria pass
- Evidence captured for each
- Secrets stored in vault
- Fingerprints recorded
- Health checks stable for 5 minutes

## Handoff

**Owner**: OpenFixer

### Deliverables

1. **Files to Create/Modify**:
   - `OP3NF1XER/nate-alma/deploy/Dockerfile` (complete version above)
   - `OP3NF1XER/nate-alma/deploy/entrypoint.sh` (complete version above)
   - `OP3NF1XER/nate-alma/deploy/supervisord.conf` (complete version above)
   - `OP3NF1XER/nate-alma/deploy/railway.toml` (complete version above)
   - `OP3NF1XER/nate-alma/deploy/scripts/validate-deployment.sh`
   - `OP3NF1XER/nate-alma/secrets/` (vault implementation)

2. **Deployment Steps**:
   - Initialize secrets vault
   - Generate and store `SETUP_PASSWORD`
   - Generate and store `OPENCLAW_GATEWAY_TOKEN`
   - Add Railway MongoDB template
   - Deploy with volume attached
   - Capture SFTP hostkey fingerprint
   - Run 8-point validation
   - Store all credentials in vault

3. **Return Evidence**:
   - All 8 validation check outputs
   - Railway service URL
   - SFTP TCP endpoint + fingerprint
   - Secrets inventory (keys only, not values)
   - Deployment journal

## Nexus Decisions (Recorded)

| Question | Answer | Implementation |
|----------|--------|----------------|
| **1. Claude CLI Setup-Key** | Use Claude CLI for setup | Add `CLAUDE_SETUP_KEY` to credentials; Claude CLI (`claude setup`) for initial configuration |
| **2. QMD Model Download** | Runtime (Option B) | Models download at container boot; smaller image |
| **3. SFTP Operator Key** | Populate after secrets ready | Generate keypair after vault initialization |
| **4. Channels** | Telegram | Configure Telegram bot integration |

## Telegram Channel Configuration

### Bot Setup

**Prerequisites**:
1. Create Telegram bot via [@BotFather](https://t.me/botfather)
2. Get bot token (format: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)
3. Configure webhook or polling mode

**OpenClaw Configuration** (`openclaw.json`):
```json5
{
  channels: {
    telegram: {
      enabled: true,
      botToken: "${TELEGRAM_BOT_TOKEN}",  // From Railway variable
      webhook: {
        enabled: true,
        url: "https://${RAILWAY_DOMAIN}/webhook/telegram",
        secret: "${TELEGRAM_WEBHOOK_SECRET}"
      },
      // Or polling (if webhook not preferred)
      // polling: { enabled: true, interval: 1000 }
    }
  }
}
```

**Railway Variables**:
| Variable | Value | Stored In Vault |
|----------|-------|-----------------|
| `TELEGRAM_BOT_TOKEN` | From @BotFather | `telegram.bot.token` |
| `TELEGRAM_WEBHOOK_SECRET` | Generate 32+ chars | `telegram.webhook.secret` |

### Additional Credentials Required

| Credential | Source | Vault Key | When |
|------------|--------|-----------|------|
| **Claude CLI Setup Key** | `claude setup` | `claude.setup_key` | Pre-deploy |
| **Telegram Bot Token** | @BotFather | `telegram.bot.token` | Pre-deploy |
| **Telegram Webhook Secret** | You generate | `telegram.webhook.secret` | Pre-deploy |

## Documentation Requirements

Before deployment, gather all OpenClaw documentation into:
`C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\documentation\`

**See**: Documentation gathering prompt in companion task.

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| QMD SQLite extension issues | Medium | High | Use Debian base (not Alpine) |
| Ollama model download timeout | Medium | Medium | Pre-pull in entrypoint with retry |
| Volume mount failure | Low | Critical | Explicit railway.toml config |
| Memory search fallback loops | Low | Medium | Explicit fallback: "none" |
| Provider API key interpolation | Low | Critical | No API keys in config files |

## Model Provider Configuration

**Provider**: Anthropic (Claude)
**Setup**: Uses `CLAUDE_SETUP_KEY` for initialization
**Configuration**: Set via Railway environment variables

**Railway Variables**:
| Variable | Value | Source |
|----------|-------|--------|
| `CLAUDE_SETUP_KEY` | Setup token from `claude setup` | Vault: `claude.setup_key` |

**Note**: Model provider is configured post-deployment via OpenClaw setup wizard using the Claude CLI setup key.

---

## References

- DECISION_146: ALMA Railway Merged Environment (v2.0.0)
- DECISION_165: ALMA Deployment Success + Admin Secrets (v2.0.0)
- OpenClaw Memory Docs: `OP3NF1XER/nate-alma/openclaw/docs/concepts/memory.md`
- QMD Repository: `https://github.com/tobi/qmd`
- Manifest Round R050: OpenClaw Railway incident recovery
