---
type: task
id: TASK_001
decision: DECISION_168
category: Documentation
priority: Critical
---

# TASK: Gather OpenClaw Documentation for ALMA Deployment

## Objective

Collect ALL OpenClaw documentation into a single, indexed location for:
1. Reference during QMD deployment (DECISION_168)
2. RAG ingestion for ALMA agent context
3. Offline access during Railway deployment

## Target Directory

```
C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\documentation\
```

## Documentation Sources

### 1. OpenClaw Core Documentation
**Source**: `OP3NF1XER/nate-alma/openclaw/docs/`

**Files to Copy**:
```
docs/
├── concepts/
│   ├── agent.md
│   ├── agent-workspace.md
│   ├── channels.md
│   ├── memory.md              ← CRITICAL for QMD
│   ├── model-providers.md
│   ├── models.md
│   ├── permissions.md
│   ├── sessions.md
│   └── tools.md
├── providers/
│   ├── ollama.md              ← CRITICAL for Ollama setup
│   ├── openai.md
│   ├── anthropic.md
│   ├── gemini.md
│   └── README.md
├── tools/
│   ├── browser.md
│   ├── canvas.md
│   ├── cron.md
│   ├── skills.md
│   └── webhooks.md
├── gateway/
│   └── configuration.md
└── reference/
    └── session-management-compaction.md
```

### 2. QMD-Specific Documentation
**Source**: `OP3NF1XER/nate-alma/openclaw/src/memory/`

**Files to Copy**:
```
src/memory/
├── qmd-manager.ts             ← QMD integration implementation
├── qmd-manager.test.ts        ← Test cases show usage
├── qmd-query-parser.ts        ← Query parsing logic
├── qmd-query-parser.test.ts
├── qmd-scope.ts               ← Scope management
└── qmd-scope.test.ts
```

### 3. Configuration Examples
**Source**: `OP3NF1XER/nate-alma/openclaw/`

**Files to Find/Copy**:
```
*.json        # Example configs
*.json5       # Example configs with comments
*.md          # Any README or setup docs
```

### 4. Deployment Documentation
**Source**: `OP3NF1XER/nate-alma/deploy/`

**Files to Copy**:
```
deploy/
├── README.md
├── Dockerfile
├── railway.toml
├── entrypoint.sh
├── CLAUDE.md
└── .env.example
```

### 5. Historical Deployment Knowledge
**Source**: `OP3NF1XER/deployments/`

**Files to Copy** (Railway-related only):
```
JOURNAL_2026-02-24_DECISION_145_OPENCLAW_LOCAL_CLONE_DEPLOY_PIN.md
JOURNAL_2026-02-24_DECISION_144_RAILWAY_LOCALIZATION_SSH_PREFLIGHT.md
JOURNAL_2026-02-25_DECISION_146_DEPLOYED_TOKEN_CONFIG_DOC.md
JOURNAL_2026-02-25_DECISION_150_NATE_ALMA_DEPLOY_AUDIT_AND_RELEASE.md
JOURNAL_2026-02-25_DECISION_151_SETUP_PASSWORD_TOOL_AND_AGENTS_SECRET_MARKER.md
JOURNAL_2026-02-25_WINDTERM_ASSIMILATION.md
```

## Directory Structure (Target)

```
C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\documentation\
├── INDEX.md                          # Master index of all docs
├── openclaw/
│   ├── concepts/
│   │   ├── memory.md
│   │   ├── agent.md
│   │   └── ...
│   ├── providers/
│   │   ├── ollama.md
│   │   └── ...
│   └── tools/
│       └── ...
├── qmd/
│   ├── qmd-manager.ts
│   ├── qmd-query-parser.ts
│   └── README-QMD-INTEGRATION.md     # Summary of QMD in OpenClaw
├── deployment/
│   ├── railway/
│   │   ├── Dockerfile
│   │   ├── railway.toml
│   │   └── entrypoint.sh
│   └── historical/
│       └── JOURNAL_*.md
└── examples/
    └── configs/
```

## INDEX.md Template

Create this file in the target directory:

```markdown
# OpenClaw Documentation Index

Generated: [DATE]
Purpose: ALMA QMD Deployment Reference

## Quick Reference

| Topic | File | Priority |
|-------|------|----------|
| Memory/QMD | openclaw/concepts/memory.md | CRITICAL |
| Ollama Setup | openclaw/providers/ollama.md | CRITICAL |
| Agent Config | openclaw/concepts/agent.md | HIGH |
| QMD Code | qmd/qmd-manager.ts | HIGH |
| Railway Deploy | deployment/railway/Dockerfile | HIGH |

## Search Keywords

- QMD configuration: memory.md lines 123-254
- Ollama models: ollama.md lines 19-27
- Model fallbacks: agent.md [FIND]
- Railway volume: JOURNAL_2026-02-25_DECISION_150*.md

## Critical Configuration Snippets

### QMD Backend Enable
```json5
memory: {
  backend: "qmd",
  citations: "auto",
  qmd: {
    includeDefaultMemory: true,
    update: { interval: "5m", debounceMs: 15000 }
  }
}
```

### Ollama Provider
```json5
models: {
  providers: {
    ollama: {
      apiKey: "ollama-local"
    }
  }
}
```
```

## Execution Steps

1. Create target directory structure
2. Copy all files maintaining relative paths
3. Create INDEX.md with cross-references
4. Verify all CRITICAL files present
5. Generate file manifest

## Verification Checklist

- [ ] openclaw/concepts/memory.md copied
- [ ] openclaw/providers/ollama.md copied
- [ ] qmd/qmd-manager.ts copied
- [ ] All JOURNAL files copied
- [ ] INDEX.md created with cross-references
- [ ] File manifest generated

## Success Criteria

All documentation is:
1. Copied to target directory
2. Organized by topic
3. Indexed with cross-references
4. Available offline during deployment
