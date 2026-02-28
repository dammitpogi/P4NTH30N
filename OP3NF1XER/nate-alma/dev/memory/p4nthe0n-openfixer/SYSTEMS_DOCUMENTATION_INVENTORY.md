---
type: documentation-inventory
decision: DECISION_168
date: 2026-02-26
version: 1.0.0
---

# Systems Documentation Inventory - ALMA QMD Railway Deployment

## Overview

This inventory lists ALL documentation to be gathered for the ALMA QMD deployment. Documentation will be stored at:
`C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\documentation\`

---

## 1. OpenClaw Core Documentation

**Source**: `OP3NF1XER/nate-alma/openclaw/docs/`
**Priority**: CRITICAL

### 1.1 Concepts (Memory, Agents, Configuration)

| File | Priority | Purpose | Key Sections |
|------|----------|---------|--------------|
| `concepts/memory.md` | **CRITICAL** | QMD configuration, vector search, BM25 hybrid | Lines 123-254 (QMD backend), Lines 395-446 (hybrid search) |
| `concepts/agent.md` | HIGH | Agent runtime, model selection | Model fallbacks, workspace |
| `concepts/agent-workspace.md` | HIGH | Workspace layout, file organization | Directory structure |
| `concepts/channels.md` | **CRITICAL** | Telegram integration | Webhook setup, bot configuration |
| `concepts/model-providers.md` | HIGH | Provider configuration | Ollama, Anthropic setup |
| `concepts/models.md` | MEDIUM | Model selection guidance | Context windows, costs |
| `concepts/permissions.md` | MEDIUM | Permission system | Allow/deny rules |
| `concepts/sessions.md` | MEDIUM | Session management | Compaction, memory flush |
| `concepts/tools.md` | MEDIUM | Tool system overview | Built-in tools |

### 1.2 Providers (Ollama, Anthropic)

| File | Priority | Purpose | Key Sections |
|------|----------|---------|--------------|
| `providers/ollama.md` | **CRITICAL** | Local LLM setup | Lines 19-27 (models), Lines 99-121 (explicit config) |
| `providers/anthropic.md` | HIGH | Claude API setup | Setup key configuration |
| `providers/openai.md` | LOW | OpenAI compatibility | Fallback options |
| `providers/gemini.md` | LOW | Google AI setup | Alternative provider |
| `providers/README.md` | MEDIUM | Provider overview | Comparison table |

### 1.3 Tools

| File | Priority | Purpose |
|------|----------|---------|
| `tools/browser.md` | MEDIUM | Browser automation |
| `tools/canvas.md` | MEDIUM | Canvas/game interaction |
| `tools/cron.md` | LOW | Scheduled tasks |
| `tools/skills.md` | MEDIUM | Skill system |
| `tools/webhooks.md` | MEDIUM | Webhook configuration |

### 1.4 Gateway & Reference

| File | Priority | Purpose | Key Sections |
|------|----------|---------|--------------|
| `gateway/configuration.md` | HIGH | Full config reference | JSON5 syntax, all options |
| `reference/session-management-compaction.md` | MEDIUM | Session lifecycle | Compaction triggers |

---

## 2. QMD Implementation Documentation

**Source**: `OP3NF1XER/nate-alma/openclaw/src/memory/`
**Priority**: CRITICAL

| File | Type | Purpose | Key Content |
|------|------|---------|-------------|
| `qmd-manager.ts` | Source | QMD integration implementation | Backend initialization, query execution |
| `qmd-manager.test.ts` | Tests | Usage examples | Test cases show API |
| `qmd-query-parser.ts` | Source | Query parsing logic | Search syntax |
| `qmd-query-parser.test.ts` | Tests | Query examples | Valid/invalid queries |
| `qmd-scope.ts` | Source | Scope management | Collection scoping |
| `qmd-scope.test.ts` | Tests | Scope examples | Permission boundaries |

**Create Summary File**: `documentation/qmd/README-QMD-INTEGRATION.md`
- Summarize how QMD is integrated
- Key configuration options
- Fallback behavior

---

## 3. Configuration Examples

**Source**: `OP3NF1XER/nate-alma/openclaw/`
**Priority**: HIGH

Search for and copy:
- `*.json` - JSON configuration examples
- `*.json5` - JSON5 examples with comments
- `*.config.*` - Config files
- `.env.example` - Environment templates
- `README.md` - Setup instructions

---

## 4. Deployment Documentation

**Source**: `OP3NF1XER/nate-alma/deploy/`
**Priority**: CRITICAL

| File | Priority | Purpose |
|------|----------|---------|
| `README.md` | HIGH | Deployment overview |
| `Dockerfile` | **CRITICAL** | Container specification |
| `railway.toml` | **CRITICAL** | Railway configuration |
| `entrypoint.sh` | **CRITICAL** | Container entrypoint |
| `supervisord.conf` | HIGH | Process management |
| `CLAUDE.md` | MEDIUM | Claude-specific notes |
| `.env.example` | HIGH | Environment template |
| `package.json` | MEDIUM | Dependencies |

---

## 5. Historical Deployment Knowledge

**Source**: `OP3NF1XER/deployments/`
**Priority**: HIGH

### 5.1 Railway-Specific Journals

| File | Priority | Lessons Learned |
|------|----------|-----------------|
| `JOURNAL_2026-02-25_DECISION_150_NATE_ALMA_DEPLOY_AUDIT_AND_RELEASE.md` | **CRITICAL** | Volume mount fix, first deployment |
| `JOURNAL_2026-02-25_DECISION_151_SETUP_PASSWORD_TOOL_AND_AGENTS_SECRET_MARKER.md` | HIGH | Setup password handling |
| `JOURNAL_2026-02-24_DECISION_145_OPENCLAW_LOCAL_CLONE_DEPLOY_PIN.md` | MEDIUM | Source pinning |
| `JOURNAL_2026-02-24_DECISION_144_RAILWAY_LOCALIZATION_SSH_PREFLIGHT.md` | MEDIUM | SSH setup |
| `JOURNAL_2026-02-25_DECISION_146_DEPLOYED_TOKEN_CONFIG_DOC.md` | HIGH | Token configuration |
| `JOURNAL_2026-02-25_WINDTERM_ASSIMILATION.md` | LOW | Terminal setup |

### 5.2 Infrastructure Journals

| File | Priority | Purpose |
|------|----------|---------|
| `JOURNAL_2026-02-24_DECISION_149_MACHINE_PATH_POLICY_GOVERNANCE.md` | LOW | Path policies |
| `JOURNAL_2026-02-24_DECISION_148_OPENSSH_PATH_POLICY_AND_DEV_PARITY.md` | LOW | SSH paths |
| `JOURNAL_2026-02-24_DECISION_147_OPENSSH_PATH_POLICY_AND_DEV_PARITY.md` | LOW | SSH config |
| `JOURNAL_2026-02-24_DECISION_143_WORKSPACE_SPLIT_PARITY_MERGE.md` | LOW | Workspace setup |

### 5.3 Incident Recovery (R050)

**Critical**: Round R050 from manifest documents the OpenClaw Railway incident.
Extract and document:
- Root cause: Hard provider env dependencies
- Solution: Dependency ladder removal
- Prevention: Validation gates

---

## 6. Decision Documentation

**Source**: `STR4TEG15T/memory/decisions/`
**Priority**: HIGH

| File | Priority | Purpose |
|------|----------|---------|
| `DECISION_146_ALMA_RAILWAY_MERGED_ENVIRONMENT.md` | **CRITICAL** | Base deployment spec |
| `DECISION_165_ALMA_DEPLOYMENT_SUCCESS_AND_ADMIN_SECRETS.md` | **CRITICAL** | Success criteria, secrets vault |
| `DECISION_168_QMD_RAILWAY_DEPLOYMENT_COMPLETE_ENVIRONMENT.md` | **CRITICAL** | This decision |
| `DECISION_166_MODEL_SELECTION_ALGORITHM_IMPLEMENTATION.md` | MEDIUM | Model selection |

---

## 7. External Documentation

**Source**: Web (to be fetched)
**Priority**: MEDIUM

| Resource | URL | Purpose |
|----------|-----|---------|
| QMD Repository | https://github.com/tobi/qmd | QMD installation, usage |
| Ollama Models | https://ollama.com/library | Model selection |
| Railway Docs | https://docs.railway.app/ | Platform specifics |
| Telegram Bot API | https://core.telegram.org/bots/api | Webhook setup |
| Anthropic API | https://docs.anthropic.com/ | Claude setup |

---

## 8. Telegram-Specific Documentation

**Priority**: CRITICAL

### 8.1 BotFather Instructions

Document the exact steps:
1. Message @BotFather
2. Send `/newbot`
3. Provide name and username
4. Receive token
5. Configure webhook

### 8.2 Webhook Configuration

```
POST https://api.telegram.org/bot<TOKEN>/setWebhook
{
  "url": "https://<RAILWAY_DOMAIN>/webhook/telegram",
  "secret_token": "<WEBHOOK_SECRET>"
}
```

### 8.3 OpenClaw Telegram Config

```json5
{
  channels: {
    telegram: {
      enabled: true,
      botToken: "${TELEGRAM_BOT_TOKEN}",
      webhook: {
        enabled: true,
        url: "https://${RAILWAY_DOMAIN}/webhook/telegram",
        secret: "${TELEGRAM_WEBHOOK_SECRET}"
      }
    }
  }
}
```

---

## Target Directory Structure

```
C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\documentation\
├── INDEX.md                              # Master index
├── README.md                             # Documentation guide
├── openclaw/
│   ├── concepts/
│   │   ├── memory.md                     # CRITICAL
│   │   ├── channels.md                   # CRITICAL
│   │   ├── agent.md
│   │   ├── agent-workspace.md
│   │   ├── model-providers.md
│   │   ├── models.md
│   │   ├── permissions.md
│   │   ├── sessions.md
│   │   └── tools.md
│   ├── providers/
│   │   ├── ollama.md                     # CRITICAL
│   │   ├── anthropic.md                  # HIGH
│   │   ├── openai.md
│   │   ├── gemini.md
│   │   └── README.md
│   ├── tools/
│   │   ├── browser.md
│   │   ├── canvas.md
│   │   ├── cron.md
│   │   ├── skills.md
│   │   └── webhooks.md
│   └── gateway/
│       └── configuration.md
├── qmd/
│   ├── qmd-manager.ts
│   ├── qmd-manager.test.ts
│   ├── qmd-query-parser.ts
│   ├── qmd-query-parser.test.ts
│   ├── qmd-scope.ts
│   ├── qmd-scope.test.ts
│   └── README-QMD-INTEGRATION.md         # CREATE THIS
├── telegram/
│   ├── setup-guide.md                    # CREATE THIS
│   ├── webhook-configuration.md          # CREATE THIS
│   └── botfather-steps.md                # CREATE THIS
├── deployment/
│   ├── railway/
│   │   ├── Dockerfile
│   │   ├── railway.toml
│   │   ├── entrypoint.sh
│   │   ├── supervisord.conf
│   │   ├── README.md
│   │   └── .env.example
│   └── historical/
│       ├── JOURNAL_2026-02-25_DECISION_150.md
│       ├── JOURNAL_2026-02-25_DECISION_151.md
│       ├── JOURNAL_2026-02-25_DECISION_146.md
│       └── JOURNAL_2026-02-24_DECISION_145.md
├── decisions/
│   ├── DECISION_146.md
│   ├── DECISION_165.md
│   └── DECISION_168.md
└── external/
    ├── qmd-repo-readme.md                # FETCH FROM GITHUB
    ├── ollama-models.md                  # FETCH FROM OLLAMA.COM
    └── railway-volumes.md                # FETCH FROM RAILWAY DOCS
```

---

## Critical Documentation (Must Have)

These files are **blocking** - deployment cannot proceed without them:

1. `openclaw/concepts/memory.md` - QMD configuration
2. `openclaw/providers/ollama.md` - Ollama setup
3. `openclaw/concepts/channels.md` - Telegram integration
4. `qmd/qmd-manager.ts` - QMD implementation
5. `deployment/railway/Dockerfile` - Container spec
6. `deployment/railway/railway.toml` - Railway config
7. `JOURNAL_2026-02-25_DECISION_150.md` - Volume mount lessons

---

## Documentation Gathering Checklist

### Phase 1: Critical Files
- [ ] Copy `openclaw/concepts/memory.md`
- [ ] Copy `openclaw/providers/ollama.md`
- [ ] Copy `openclaw/concepts/channels.md`
- [ ] Copy `qmd/*.ts` files
- [ ] Copy `deployment/railway/*`
- [ ] Copy `JOURNAL_2026-02-25_DECISION_150.md`

### Phase 2: High Priority
- [ ] Copy remaining `concepts/*.md`
- [ ] Copy `providers/anthropic.md`
- [ ] Copy `gateway/configuration.md`
- [ ] Copy remaining JOURNAL files

### Phase 3: Medium Priority
- [ ] Copy `tools/*.md`
- [ ] Copy decision files
- [ ] Fetch external docs

### Phase 4: Create Summary Files
- [ ] Create `INDEX.md`
- [ ] Create `qmd/README-QMD-INTEGRATION.md`
- [ ] Create `telegram/setup-guide.md`
- [ ] Create `telegram/webhook-configuration.md`

---

## Verification

After gathering, verify:

```powershell
# Check critical files exist
Test-Path documentation/openclaw/concepts/memory.md
Test-Path documentation/openclaw/providers/ollama.md
Test-Path documentation/openclaw/concepts/channels.md
Test-Path documentation/qmd/qmd-manager.ts
Test-Path documentation/deployment/railway/Dockerfile

# Count total files
(Get-ChildItem documentation -Recurse -File).Count
# Expected: 30+ files

# Verify INDEX.md exists
Test-Path documentation/INDEX.md
```

---

## Usage During Deployment

1. **Pre-deploy**: Reference `ollama.md` for model configuration
2. **Deploy**: Reference `Dockerfile`, `railway.toml` for deployment
3. **Post-deploy**: Reference `channels.md` for Telegram setup
4. **Troubleshooting**: Reference JOURNAL files for known issues
