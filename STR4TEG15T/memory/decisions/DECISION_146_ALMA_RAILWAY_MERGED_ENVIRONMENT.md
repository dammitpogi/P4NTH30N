---
type: decision
id: DECISION_146
version: 2.0.0
category: INFRA
status: superseded
created_at: '2026-02-27T00:15:15Z'
last_reviewed: '2026-02-28T14:00:00Z'
superseded_by: DECISION_172
priority: Critical
keywords:
  - alma
  - nate
  - openclaw
  - railway
  - sftpgo
  - volume
  - merged-service
  - ollama
  - local-model
  - memory
  - retrieval
  - mongodb
roles:
  - strategist
  - oracle
  - designer
  - openfixer
  - windfixer
summary: >-
  [SUPERSEDED by DECISION_172] ALMA Railway deployment architecture. Single 
  merged container running OpenClaw + SFTPGo with Railway Volume at /data. 
  Ollama provides free local LLM inference. OpenClaw's built-in memory/retrieval
  (memory_search, memory_get, vector + BM25 hybrid) satisfies RAG requirements.
  MongoDB Railway template for persistence. All OpenClaw features enabled.
  
  Historical value: Captured single-container deployment pattern and Railway
  volume management lessons. Superseded by 3-service Book-First MVP architecture.
---

# DECISION_146: ALMA Railway Merged Environment (v2.0.0) - SUPERSEDED

**Decision ID**: DECISION_146  
**Version**: 2.0.0 (Corrected)  
**Category**: INFRA  
**Status**: **SUPERSEDED** by DECISION_172  
**Priority**: Critical (Historical)  
**Date**: 2026-02-27  
**Superseded**: 2026-02-28

## Supersession Notice

**This decision has been superseded by DECISION_172: Book-First MVP Architecture.**

The single merged container approach (OpenClaw + SFTPGo + Ollama in one service) has been replaced by a 3-service architecture:
- Service A: Next.js (public)
- Service B: Core (OpenClaw + QMD + SFTPGo, internal)
- Service C: MongoDB (internal)

**Historical Value**: This decision captured the single-container deployment pattern, Railway volume management, and Ollama integration approach. These patterns remain useful for reference but are not the current implementation path.

**Reason for Supersession**: Product pivot from "OpenClaw-first agent" to "Book-First MVP with Next.js frontend" requires different service topology and public/private boundaries.

## Correction Notice

This v2.0.0 corrects v1.6.0 errors:
- **Removed**: External RAG services (LightRAG, AnythingLLM) - unnecessary
- **Removed**: "LM Anywhere" references - non-existent component
- **Clarified**: OpenClaw's built-in retrieval IS the RAG implementation
- **Specified**: Ollama as the free local model runtime

## Intake

Deploy ALMA (Nate's OpenClaw agent) on Railway with:
- All OpenClaw features operational
- Free local LLM (no paid API dependency)
- Built-in memory/retrieval for RAG
- File transfer via SFTPGo
- MongoDB persistence

## Frame

1. **Objective**: Production Railway deployment with complete OpenClaw feature set
2. **Constraints**: Free model runtime only; no paid LLM APIs required
3. **Evidence targets**: OpenClaw docs confirm built-in retrieval; Ollama docs confirm free local inference
4. **Risk ceiling**: Medium (deployment complexity, not architectural uncertainty)
5. **Finish criteria**: All services online, all features functional, validation evidence captured

## System Topology

### Services

| Service | Type | Network | Purpose |
|---------|------|---------|---------|
| `openclaw` | Primary | Public HTTPS | Gateway, Control UI, WebChat, agent runtime |
| `sftpgo` | Sidecar | TCP Proxy | File transfer to `/data/workspace` |
| `ollama` | Internal | Private | Free local LLM inference |
| `mongodb` | Database | Private | Persistence via Railway template |

### Container Architecture

Single Railway service with merged container:

```
┌─────────────────────────────────────────────────────────────┐
│                    Railway Service                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Alpine Linux Container                  │   │
│  │                                                      │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────┐   │   │
│  │  │   OpenClaw   │  │    SFTPGo    │  │  Ollama  │   │   │
│  │  │   Gateway    │  │   (sftp)     │  │  (llm)   │   │   │
│  │  │   :18789     │  │   :2022      │  │  :11434  │   │   │
│  │  └──────────────┘  └──────────────┘  └──────────┘   │   │
│  │                                                      │   │
│  │  ┌──────────────────────────────────────────────┐   │   │
│  │  │        Railway Volume (mounted at /data)      │   │   │
│  │  │  ┌────────────┐ ┌────────────┐ ┌───────────┐ │   │   │
│  │  │  │  OpenClaw  │ │   SFTPGo   │ │  Ollama   │ │   │   │
│  │  │  │   state    │ │   files    │ │  models   │ │   │   │
│  │  │  └────────────┘ └────────────┘ └───────────┘ │   │   │
│  │  └──────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## OpenClaw Feature Implementation

### Core Features (All Enabled)

| Feature | Implementation | Documentation Source |
|---------|---------------|---------------------|
| **Agent Runtime** | Pi agent RPC mode | `docs/concepts/agent.md` |
| **Multi-channel** | WhatsApp, Telegram, Slack, Discord, etc. | `docs/channels/` |
| **Memory/Retrieval** | `memory_search`, `memory_get` tools | `docs/concepts/memory.md` |
| **Vector Search** | sqlite-vec + hybrid BM25 | `docs/concepts/memory.md` |
| **Local Embeddings** | node-llama-cpp (optional) | `docs/concepts/memory.md` |
| **QMD Backend** | BM25 + vectors + reranking (optional) | `docs/concepts/memory.md` |
| **Tools** | Browser, Canvas, Cron, Webhooks | `docs/tools/` |
| **Skills** | Bundled + managed + workspace | `docs/tools/skills.md` |
| **Voice** | Wake + Talk mode (if configured) | `docs/nodes/voicewake.md` |

### RAG Implementation (Built-in)

OpenClaw's memory system IS the RAG:

```
User Query → memory_search → Vector + BM25 Hybrid → Retrieved Chunks → LLM Context
```

**Components:**
- **memory_search**: Semantic search over `MEMORY.md` + `memory/**/*.md`
- **memory_get**: Targeted file/line reads
- **Vector index**: Per-agent SQLite with embeddings
- **BM25**: FTS5 full-text for exact token matching
- **Hybrid scoring**: Weighted merge of vector + text scores
- **MMR reranking**: Diversity optimization (optional)
- **Temporal decay**: Recency boosting (optional)

**No external RAG required.**

## Model Runtime: Ollama

### Option A: Ollama in Container (Recommended)

Install Ollama in the same container as OpenClaw:

```dockerfile
# Add to Dockerfile
RUN curl -fsSL https://ollama.com/install.sh | sh

# Pre-pull models during build or at runtime
RUN ollama pull llama3.3
```

**Configuration:**
```json5
// openclaw.json
{
  agents: {
    defaults: {
      model: { primary: "ollama/llama3.3" }
    }
  }
}
```

**Environment:**
```bash
OLLAMA_API_KEY="ollama-local"
```

### Option B: Ollama as Separate Railway Service

Deploy Ollama as standalone Railway service:

```yaml
# railway.yml for ollama service
services:
  ollama:
    image: ollama/ollama
    volumes:
      - ollama-models:/root/.ollama
```

**Configuration:**
```json5
{
  models: {
    providers: {
      ollama: {
        baseUrl: "http://ollama.railway.internal:11434",
        apiKey: "ollama-local"
      }
    }
  }
}
```

### Recommended Models (Free)

| Model | Size | Tools | Reasoning | Use Case |
|-------|------|-------|-----------|----------|
| `llama3.3` | 70B | Yes | No | General purpose |
| `qwen2.5-coder:32b` | 32B | Yes | No | Code tasks |
| `deepseek-r1:32b` | 32B | Yes | Yes | Reasoning |
| `gpt-oss:20b` | 20B | Yes | No | Balanced |

## Railway Configuration

### Required Variables

| Variable | Service | Purpose |
|----------|---------|---------|
| `SETUP_PASSWORD` | OpenClaw | Gate setup wizard |
| `OPENCLAW_GATEWAY_TOKEN` | OpenClaw | Control UI auth |
| `OLLAMA_API_KEY` | OpenClaw | Enable Ollama provider |
| `MONGO_URL` | OpenClaw | Database connection |

### Volume Mount

```toml
# railway.toml
[deploy]
mounts = [
  { path = "/data", type = "volume", name = "alma-data" }
]
```

### Ports

| Port | Service | Exposure |
|------|---------|----------|
| 8080 | OpenClaw HTTP | Public (Railway domain) |
| 2022 | SFTPGo | TCP Proxy |
| 11434 | Ollama | Private (localhost only) |
| 18789 | OpenClaw Gateway | Private (localhost only) |

## Success Criteria

1. **OpenClaw HTTPS**: `GET /healthz` returns 200
2. **Setup Gated**: `GET /setup` requires `SETUP_PASSWORD`
3. **SFTP Access**: TCP proxy endpoint accepts key-only auth
4. **Ollama Ready**: `ollama list` shows pulled models
5. **LLM Functional**: Chat completion via Ollama works
6. **Memory Search**: `memory_search` tool returns results
7. **MongoDB Connected**: `db.runCommand({ ping: 1 })` succeeds
8. **Persistence**: Files in `/data` survive redeploy

## Handoff

**Owner**: OpenFixer  
**Targets**:
- `OP3NF1XER/nate-alma/deploy/Dockerfile` (add Ollama)
- `OP3NF1XER/nate-alma/deploy/supervisord.conf` (add Ollama program)
- `OP3NF1XER/nate-alma/deploy/openclaw.json` (Ollama provider config)
- Railway variables (MongoDB, tokens)

**Validation Commands**:
```bash
# Health
curl -fsS https://$RAILWAY_DOMAIN/healthz

# Ollama
ollama list
curl http://localhost:11434/api/tags

# Memory
openclaw memory status --deep
openclaw memory search "test query"

# MongoDB
mongosh "$MONGO_URL" --eval 'db.runCommand({ ping: 1 })'
```

## Questions

1. **Harden**: Should Ollama models be pre-pulled at build time or runtime?
   - *Default*: Runtime (smaller image, flexible)

2. **Expand**: Should we enable QMD backend for advanced retrieval?
   - *Default*: Phase 2 (standard memory first)

3. **Narrow**: Which Ollama model as default?
   - *Awaiting Nexus input*

## Notes

- External RAG services removed - OpenClaw's built-in retrieval is sufficient
- "LM Anywhere" removed - Ollama is the documented, working solution
- All OpenClaw features achievable with free local models
- GPT-5.2 errors corrected in this v2.0.0
