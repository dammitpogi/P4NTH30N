# DECISION_033: RAG Activation and Institutional Memory Hub

**Decision ID**: DECISION_033
**Category**: Architecture
**Status**: Approved
**Priority**: High
**Date**: 2026-02-20
**Oracle Approval**: 97% (Strategist Assimilated)
**Designer Approval**: 94% (Strategist Assimilated)

---

## Executive Summary

Activate the existing RAG system as the institutional memory hub for all P4NTH30N agents. The RAG infrastructure exists but is not ingesting automatically and is rarely utilized. This decision makes RAG the central knowledge store that all agents read from and write to, transforming isolated agent sessions into a shared learning experience.

**Current Problem**:
- RAG.McpHost.exe exists at C:\ProgramData\P4NTH30N\bin\ but is not running as a service
- FileWatcher.cs exists but is not configured with correct watch paths
- No agent currently queries RAG before starting work
- Each session starts from scratch with no memory of past decisions or outcomes
- Agent prompts, speech logs, decision files, and deployment journals are not ingested
- rag-manifest.json files exist in every agent directory but documents arrays are empty

**Proposed Solution**:
- Configure and start RAG.McpHost as a Windows service or scheduled task
- Configure FileWatcher with correct paths for auto-ingestion
- Update all agent prompts to query RAG at session start
- Ingest existing content: decision files, speech logs, canon files, deployment journals
- Make RAG the first stop for context in every agent workflow

---

## RAG Architecture (Existing)

```
RAG.McpHost.exe (MCP Server - port 5001)
  ├── RagService.cs (query + similarity search)
  ├── IngestionPipeline.cs (chunk, sanitize, embed, store)
  ├── FileWatcher.cs (filesystem monitoring with debounce)
  ├── FaissVectorStore.cs (FAISS index)
  ├── EmbeddingService.cs (ONNX model: all-MiniLM-L6-v2)
  ├── ContextBuilder.cs (context assembly)
  └── PythonBridge/ (Python embedding fallback)
```

---

## What Gets Ingested

### Agent Directories (High Priority)
| Path | Content | Frequency |
|------|---------|-----------|
| STRATEGIST/decisions/active/*.md | Active decisions | On change |
| STRATEGIST/decisions/completed/*.md | Historical decisions | On change |
| STRATEGIST/speech/*.md | Narrative development logs | On change |
| STRATEGIST/canon/*.md | Proven patterns | On change |
| STRATEGIST/manifest/manifest.json | Decision change tracking | On change |
| OPENFIXER/deployments/*.md | Deployment journals | On change |
| WINDFIXER/deployments/*.md | WindFixer deployment history | On change |
| ORACLE/consultations/*.md | Oracle approval history | On change |
| DESIGNER/consultations/*.md | Designer strategy history | On change |

### Config and Documentation
| Path | Content | Frequency |
|------|---------|-----------|
| AGENTS.md (root) | System architecture | On change |
| */AGENTS.md | Per-project guidelines | On change |
| docs/**/*.md | All documentation | On change |
| */codemap.md | Code structure maps | On change |

### Session History (via Harvester - DECISION_034)
| Path | Content | Frequency |
|------|---------|-----------|
| OpenCode sessions | Chat transcripts | Nightly |
| OpenCode tool outputs | Tool execution results | Nightly |
| WindSurf sessions | Cascade chat history | Nightly |

---

## Implementation Strategy

### Phase 1: Service Activation
1. Create Windows scheduled task to start RAG.McpHost.exe on login
2. Configure correct startup arguments in mcp.json
3. Verify MCP server responds on port 5001
4. Health check: query for test document

### Phase 2: FileWatcher Configuration
1. Update FileWatcherConfig with correct watch paths:
   - C:\P4NTH30N\STRATEGIST\ (decisions, speech, canon, manifest)
   - C:\P4NTH30N\OPENFIXER\deployments\
   - C:\P4NTH30N\WINDFIXER\deployments\
   - C:\P4NTH30N\ORACLE\
   - C:\P4NTH30N\DESIGNER\
   - C:\P4NTH30N\docs\
2. Set file patterns: *.md, *.json
3. Set debounce period: 5 minutes
4. Exclude patterns: bin/, obj/, .git/

### Phase 3: Initial Bulk Ingestion
1. Ingest all existing decision files
2. Ingest all speech logs
3. Ingest all canon files
4. Ingest all deployment journals
5. Ingest all AGENTS.md files
6. Verify ingestion counts match expected

### Phase 4: Agent Prompt Updates
1. Add RAG query instruction to every agent prompt:
   "Before starting any task, query RAG for relevant context"
2. Add RAG ingestion instruction to every agent:
   "After completing significant work, ingest results to RAG"
3. Specific patterns:
   - Strategist: Query past decisions before creating new ones
   - Oracle: Query past approval patterns before rating
   - Designer: Query past implementations before designing
   - Fixers: Query past deployments before implementing

### Phase 5: Populate rag-manifest.json Files
1. Update each agent rag-manifest.json with actual document IDs
2. Set lastIngested timestamps
3. Verify searchQueries return expected results

---

## Agent Prompt RAG Integration Template

Each agent prompt should include:

```
## RAG Integration

Before starting work, query RAG for relevant context:
- Query: "[task description]"
- Filter: {agent: "[your-agent-name]", type: "decision|deployment|pattern"}
- Use results to avoid repeating past mistakes
- Reference proven patterns from past sessions

After completing work, ingest results:
- Ingest decision files, deployment logs, and key findings
- Tag with: agent name, decision ID, date, outcome
- This builds institutional memory for all agents
```

---

## Success Criteria

1. RAG.McpHost responds to queries within 500ms
2. FileWatcher auto-ingests new documents within 5 minutes
3. All existing decisions, speech logs, and journals are searchable
4. Every agent prompt includes RAG query and ingest instructions
5. Agent sessions start with relevant context from past work

---

## Dependencies

- **Blocks**: DECISION_034 (harvester needs RAG to be active)
- **Blocked By**: None (RAG infrastructure already exists)
- **Related**: DECISION_032 (config deployer can trigger re-ingestion), DECISION_034 (session harvester)

---

*Decision DECISION_033 - RAG Institutional Memory - 2026-02-20*