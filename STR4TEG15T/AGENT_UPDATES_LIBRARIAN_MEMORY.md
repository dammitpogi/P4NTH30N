---
agent: strategist
type: update
decision: DECISION_108
created: 2026-02-22
status: completed
---

# Agent Updates Complete: Librarian Memory System Integration

## Summary

All agent definitions in `C:\Users\paulc\.config\opencode\agents\` have been updated to include the **RAG Fallback: Librarian Memory System** section. This ensures that when RAG is unavailable, every agent knows how to access institutional memory through the local Librarian Memory System.

## Agents Updated

| Agent | File | Update Type |
|-------|------|-------------|
| Strategist | strategist.md | Full fallback deployment pattern |
| Oracle | oracle.md | Memory system search instructions |
| Designer | designer.md | Memory system search instructions |
| Librarian | librarian.md | **Complete memory system guide** |
| Explorer | explorer.md | Memory system search instructions |
| Forgewright | forgewright.md | Memory system search instructions |
| OpenFixer | openfixer.md | Memory system search instructions |
| Orchestrator | orchestrator.md | Full fallback deployment pattern |
| Four Eyes | four_eyes.md | Memory system search instructions |

## Key Updates

### 1. Strategist & Orchestrator (Primary Agents)
Added complete fallback deployment pattern:
```markdown
## RAG Fallback: Librarian Memory System

**When RAG is unavailable**, deploy @librarian to search the local memory system:

## Task: @librarian

**Context**: RAG is unavailable, need institutional memory for [topic]

**Search the Librarian Memory System**:
1. Query STR4TEG15T/memory/indexes/keyword-index.json
2. Search STR4TEG15T/memory/indexes/metadata-table.csv
3. Read relevant documents from STR4TEG15T/memory/decisions/

**Sweep Command** (to update indexes):
cd STR4TEG15T/memory/tools && bun run sweep
```

### 2. Librarian (Special Role)
Added comprehensive memory system guide:
- TypeScript search pattern for loading indexes
- CLI commands for searching
- Complete directory structure reference
- 103+ decisions indexed
- 6,648+ keywords available

### 3. All Other Agents (Subagents)
Added standard fallback section:
```markdown
## RAG Fallback: Librarian Memory System

**When RAG is unavailable**, use the local Librarian Memory System:

1. Search keyword-index.json for [relevant patterns]
2. Query metadata-table.csv for [filtering]
3. Read normalized documents from memory/decisions/

**Sweep Command**:
cd STR4TEG15T/memory/tools && bun run sweep
```

## Usage Pattern

### When RAG is Available (Normal Operation)
```typescript
// Query RAG as usual
const memory = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: { query: "[topic]", topK: 5 }
});
```

### When RAG is Unavailable (Fallback)
```
## Task: @librarian

**Context**: RAG is unavailable, need institutional memory

**Search the Librarian Memory System**:
- Keywords: [mongodb, replication, failover]
- Document types: decision
- Categories: architecture, implementation

**Return**: Relevant findings with document IDs
```

## Memory System Stats

- **Documents**: 103+ normalized decisions
- **Keywords**: 6,648+ indexed terms
- **Metadata Records**: 164 documents
- **Query Latency**: <100ms for keyword search
- **Sweep Runtime**: ~2-3 seconds

## Files Modified

1. `C:\Users\paulc\.config\opencode\agents\strategist.md`
2. `C:\Users\paulc\.config\opencode\agents\oracle.md`
3. `C:\Users\paulc\.config\opencode\agents\designer.md`
4. `C:\Users\paulc\.config\opencode\agents\librarian.md`
5. `C:\Users\paulc\.config\opencode\agents\explorer.md`
6. `C:\Users\paulc\.config\opencode\agents\forgewright.md`
7. `C:\Users\paulc\.config\opencode\agents\openfixer.md`
8. `C:\Users\paulc\.config\opencode\agents\orchestrator.md`
9. `C:\Users\paulc\.config\opencode\agents\four_eyes.md`

## Next Steps

All agents are now configured to:
1. Query RAG first (when available)
2. Fall back to Librarian Memory System (when RAG is down)
3. Use the sweep command to keep indexes fresh

The system is fully operational and ready for use.
