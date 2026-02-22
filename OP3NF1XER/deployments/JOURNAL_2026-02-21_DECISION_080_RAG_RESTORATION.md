# DEPLOYMENT JOURNAL: DECISION_080 - RAG Vector Index Restoration & Auto-Ingest Hardening

**Date**: 2026-02-21  
**Agent**: OpenFixer (Vigil)  
**Decision**: DECISION_080 (INFRA-080)  
**Duration**: ~15 minutes  
**Status**: COMPLETE  

---

## Executive Summary

Restored the RAG vector index from 16 vectors to **3,655 vectors** (exceeding the original 2,470 by 48%). Built and hardened a permanent auto-ingestion system that survives Windows restarts and ensures the vault never goes empty again.

---

## Phase Execution

### Phase 1: Speech Logs
- **Files**: 115 (was estimated at 86)
- **Failures**: 0
- **Method**: PowerShell batch script via `rag_ingest_file` HTTP JSON-RPC
- **Script**: `C:\OP3NF1XER\scripts\rag-ingest-phase1.ps1`

### Phase 2: Decision Documents
- **Files**: 74 (63 active + 11 completed)
- **Failures**: 0
- **Method**: PowerShell batch script with `decisionId` metadata extraction
- **Script**: `C:\OP3NF1XER\scripts\rag-ingest-phase2.ps1`

### Phase 3: Codebase Patterns
- **Files**: 26 (10 RAG .cs + 15 Infrastructure .cs + 1 AGENTS.md)
- **Failures**: 0
- **Method**: PowerShell batch script with source-path categorization
- **Script**: `C:\OP3NF1XER\scripts\rag-ingest-phase3.ps1`

### Watcher v2 Additional Ingestion
- **Files**: 199 additional (actions, submissions, full Infrastructure recursive, config)
- **Failures**: 0
- **Total files tracked**: 314

---

## Validation Results

| Test | Result | Detail |
|------|--------|--------|
| Vector count > 150 | PASS | 3,655 vectors (target was 150) |
| Query: "Canvas typing fix" | PASS | Returns DECISION-FORGE-004, DECISION_054 |
| Query: "Chrome profile isolation" | PASS | Returns DECISION_050, QUICK_REF_064-067 |
| Query: "RAG001 deployment phases" | PASS | Returns DEPLOYMENT-PACKAGE, DECISION_052 |
| Avg query latency | PASS | 12-39ms |
| Watcher running | PASS | P4NTH30N-RAG-Watcher: Running |

---

## Permanent Auto-Ingest System

### Architecture

```
┌────────────────────────────────────────────────────────┐
│          P4NTH30N-RAG-Watcher (Scheduled Task)        │
│          Boot trigger → Continuous watch mode          │
│          Script: Watch-RagIngest.ps1 v2.0.0            │
├────────────────────────────────────────────────────────┤
│                                                        │
│  Monitors 11 directories (30s polling interval):       │
│                                                        │
│  STRATEGIST CORPUS:                                    │
│  ├─ STR4TEG15T/decisions/active/     → decision        │
│  ├─ STR4TEG15T/decisions/completed/  → decision        │
│  ├─ STR4TEG15T/speech/               → speech          │
│  ├─ STR4TEG15T/manifest/             → manifest        │
│  ├─ STR4TEG15T/actions/              → action (recur)  │
│  └─ STR4TEG15T/submissions/          → submission      │
│                                                        │
│  OPENFIXER CORPUS:                                     │
│  └─ OP3NF1XER/deployments/           → deployment      │
│                                                        │
│  CODEBASE PATTERNS:                                    │
│  ├─ C0MMON/RAG/                      → pattern         │
│  └─ C0MMON/Infrastructure/           → pattern (recur) │
│                                                        │
│  EXTERNAL CONFIG:                                      │
│  └─ ~/.config/opencode/AGENTS.md     → config          │
│                                                        │
├────────────────────────────────────────────────────────┤
│  State: C:\P4NTH30N\RAG-watcher-state.json             │
│  Log:   C:\P4NTH30N\logs\rag-watcher.log               │
│  Hash:  MD5 content hashing (skip unchanged)           │
│  API:   rag_ingest_file (file-based, no truncation)    │
│  Boot:  Waits up to 10 min for RAG service             │
│  Health: Every 100 cycles (~50 min)                    │
└────────────────────────────────────────────────────────┘
```

### Scheduled Tasks (3 total, all persistent)

| Task | Trigger | Script | Purpose |
|------|---------|--------|---------|
| `P4NTH30N-RAG-Watcher` | Boot (continuous) | `Watch-RagIngest.ps1` | Real-time file monitoring |
| `RAG-Incremental-Rebuild` | Every 4 hours | `rebuild-index.ps1` | Catch any missed files |
| `RAG-Nightly-Rebuild` | Daily 3:00 AM | `rebuild-index.ps1 -Full` | Full state reset + re-ingest |

### Key Features of Watcher v2
1. **11 monitored directories** (was 5 in v1)
2. **rag_ingest_file** API (was rag_ingest with content truncation)
3. **Boot health check** — waits up to 10 min for RAG to come online
4. **MD5 hash tracking** — only re-ingests changed files
5. **Recursive directory support** for Infrastructure and actions
6. **Structured logging** to `C:\P4NTH30N\logs\rag-watcher.log`
7. **Periodic health checks** every ~50 min during continuous mode
8. **.cs file support** added (was .md and .json only)

---

## Files Modified

| File | Change | Purpose |
|------|--------|---------|
| `STR4TEG15T/tools/rag-watcher/Watch-RagIngest.ps1` | Rewritten to v2.0.0 | Enhanced watcher with 11 dirs, rag_ingest_file, boot health check |
| `scripts/rag/rebuild-index.ps1` | Rewritten to v2 | Delegates to watcher for actual ingestion |
| `STR4TEG15T/decisions/active/DECISION_080.md` | Status → Completed | Decision closure |

## Files Created

| File | Purpose |
|------|---------|
| `OP3NF1XER/scripts/rag-ingest-phase1.ps1` | One-time speech log batch ingestion |
| `OP3NF1XER/scripts/rag-ingest-phase2.ps1` | One-time decision doc batch ingestion |
| `OP3NF1XER/scripts/rag-ingest-phase3.ps1` | One-time codebase pattern batch ingestion |
| `OP3NF1XER/scripts/restart-watcher.ps1` | Task restart utility |
| `OP3NF1XER/scripts/verify-watcher.ps1` | Task verification utility |

---

## Monitored Folders Reference

### Add new content here for auto-ingestion:

| Folder | Extension | Type | Recurse | Notes |
|--------|-----------|------|---------|-------|
| `C:\P4NTH30N\STR4TEG15T\speech\` | .md | speech | No | Strategist speech synthesis logs |
| `C:\P4NTH30N\STR4TEG15T\decisions\active\` | .md | decision | No | Active decision documents |
| `C:\P4NTH30N\STR4TEG15T\decisions\completed\` | .md | decision | No | Completed decision documents |
| `C:\P4NTH30N\STR4TEG15T\manifest\` | .md, .json | manifest | No | Narrative manifest files |
| `C:\P4NTH30N\STR4TEG15T\actions\` | .md | action | Yes | Action prompts and results |
| `C:\P4NTH30N\STR4TEG15T\submissions\` | .md | submission | Yes | Agent submission documents |
| `C:\P4NTH30N\OP3NF1XER\deployments\` | .md | deployment | No | OpenFixer deployment journals |
| `C:\P4NTH30N\C0MMON\RAG\` | .cs | pattern | No | RAG service source code |
| `C:\P4NTH30N\C0MMON\Infrastructure\` | .cs | pattern | Yes | Core infrastructure code |
| `~\.config\opencode\AGENTS.md` | AGENTS.md | config | No | OpenCode agent configuration |

### To Add a New Monitored Folder
Edit `C:\P4NTH30N\STR4TEG15T\tools\rag-watcher\Watch-RagIngest.ps1`, add an entry to `$WatchConfigs`:
```powershell
@{
    Path = "C:\P4NTH30N\NEW_DIRECTORY"
    Extensions = @("*.md", "*.cs")
    Recurse = $false
    DefaultType = "your-type"
    DefaultAgent = "agent-name"
}
```
Then restart the watcher: `powershell -File C:\OP3NF1XER\scripts\restart-watcher.ps1`

---

## Metrics

| Metric | Before | After |
|--------|--------|-------|
| Vector count | 16 | 3,655 |
| Total documents | 16 | 3,655 |
| Files tracked | 0 | 314 |
| Monitored directories | 5 | 11 |
| File extensions | .md, .json | .md, .json, .cs |
| Ingestion API | rag_ingest (content) | rag_ingest_file (file-based) |
| Boot resilience | No health check | 10-min retry with health check |
| Avg query latency | N/A | 12-39ms |

---

*OpenFixer (Vigil) - DECISION_080 Complete*  
*2026-02-21*
