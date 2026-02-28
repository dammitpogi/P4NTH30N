---
type: decision
id: DECISION_127
category: FORGE
status: completed
version: 1.0.0
created_at: '2026-02-24T21:45:00Z'
last_reviewed: '2026-02-24T21:45:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_127_CANONICAL_RAG_SELECTION_AND_ROLE_HARDENING.md
---
# DECISION_127: Canonical RAG Selection and Role Hardening

**Decision ID**: DECISION_127  
**Category**: FORGE  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-24

## Context

Multiple RAG implementations and documentation paths existed in parallel (`src/RAG*`, `C0MMON/RAG`, mixed runtime/config docs), creating role-level ambiguity and inconsistent operational usage.

## Decision

Select MCP-hosted RAG runtime as canonical:

- Runtime: `src/RAG` + `src/RAG.McpHost`
- Operational interface: ToolHive `rag-server` MCP tools
- Endpoint: `http://127.0.0.1:5001/mcp`

Retain `C0MMON/RAG` as reference/library path, not primary operational interface.

## Implementation

- Canonicalized ToolHive registration args and identity tag:
  - `tools/mcp-development/servers/toolhive-gateway/config/rag-server.json`
- Hardened runtime config path fallback and strategist path typo:
  - `src/RAG/RagActivationConfig.cs`
- Hardened Python bridge model/tokenizer resolution with primary+legacy fallback:
  - `src/RAG/PythonBridge/embedding_bridge.py`
- Updated architecture doc to explicitly mark canonical runtime path:
  - `docs/architecture/RAG.md`
- Added OpenFixer knowledge artifact for canonical stack/runbook:
  - `OP3NF1XER/knowledge/RAG_CANONICAL_STACK.md`
- Updated knowledge quick index:
  - `OP3NF1XER/knowledge/QUICK_QUERY_INDEX.md`
- Hardened active role prompts in source-of-truth agent directory to use ToolHive `rag-server` MCP path:
  - `C:/Users/paulc/.config/opencode/agents/orchestrator.md`
  - `C:/Users/paulc/.config/opencode/agents/librarian.md`
  - `C:/Users/paulc/.config/opencode/agents/explorer.md`
  - `C:/Users/paulc/.config/opencode/agents/designer.md`
  - `C:/Users/paulc/.config/opencode/agents/oracle.md`
  - `C:/Users/paulc/.config/opencode/agents/forgewright.md`
  - `C:/Users/paulc/.config/opencode/agents/windfixer.md`

## Validation

- Verified canonical runtime surface exports 6 MCP tools in `src/RAG/McpServer.cs`.
- Verified gateway config now includes full startup args (index/model/bridge/mongo/db).
- Verified role prompts now explicitly identify ToolHive `rag-server` MCP path as canonical.

## Audit Matrix

- Chose most capable RAG implementation: **PASS**
- Wired canonical operational path: **PASS**
- Hardened role-level usage guidance: **PASS**
- Preserved legacy/reference implementation without runtime ambiguity: **PASS**
