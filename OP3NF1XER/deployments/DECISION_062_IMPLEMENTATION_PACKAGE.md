# DECISION_062 Implementation Package

**Decision**: DECISION_062 - Agent Prompt Tool Usage Documentation Update  
**Status**: Approved (89.5%)  
**Assigned To**: @openfixer  
**Priority**: Critical  
**Architecture**: ToolHive Gateway - ALL tools flow through unified interface

---

## Summary

Update ALL agent prompts to use standardized ToolHive Gateway patterns. **CRITICAL**: There is no "direct" tool access - ALL tools flow through ToolHive.

Template already exists: `STR4TEG15T/tools/tool-usage-template/TOOL-USAGE-TEMPLATE.md`

---

## Implementation Order

### Phase 1: Foundation (Critical)
1. **AGENTS.md** - Add troubleshooting section
2. **strategist.md** - Fix tool documentation (currently shows YAML syntax)
3. **orchestrator.md** - Verify already correct

### Phase 2: Research Agents (High)
4. **librarian.md** - Fix mixed patterns
5. **explorer.md** - Fix mixed patterns

### Phase 3: Decision Agents (High)
6. **oracle.md** - Fix mixed patterns  
7. **designer.md** - Fix mixed patterns

### Phase 4: Implementation Agents (High)
8. **openfixer.md** - Fix bash syntax
9. **fixer.md** - Add tool examples
10. **forgewright.md** - Clarify pattern

### Phase 5: Review Agents (Medium)
11. **four_eyes.md** - Fix patterns

### Phase 6: Verification (Critical)
12. Test tool invocation from each agent
13. Update DECISION_061 completion criteria

---

## Detailed Specifications

### 1. AGENTS.md

**File**: `c:\Users\paulc\.config\opencode\agents\AGENTS.md`

**Current**: Has ToolHive section but needs troubleshooting

**Add after line ~330 (after ToolHive Gateway Architecture section)**:

```markdown
### Tool Troubleshooting

When tools fail, follow this diagnostic flow:

**"Tool not found" Error**
1. Use `toolhive_find_tool` to discover correct server/tool names
2. Don't hardcode tool names - always discover first
3. Verify server is registered in ToolHive Gateway

**"Access denied" Error**
1. Check your agent's YAML frontmatter has `toolhive_find_tool: true` and `toolhive_call_tool: true`
2. Request tool access through ToolHive Gateway, not direct
3. Escalate to @openfixer if gateway configuration issue

**"Connection refused" Error**
1. Check target server health
2. Restart server if needed: ToolHive Desktop or Docker
3. Verify localhost ports (5001 for RAG, etc.)

**Fallback Strategy**
- Decisions server timeout → Use mongodb-p4nth30n directly
- RAG unavailable → Query filesystem directly
- Web search down → Try alternative search server

**Key Principle**: ALL tools flow through ToolHive Gateway. No exceptions.
```

---

### 2. strategist.md

**File**: `c:\Users\paulc\.config\opencode\agents\strategist.md`

**Current Issues**:
- Line 294-303: Shows `rag-server.rag_query` YAML syntax (WRONG)
- Lines show documentation format, not execution pattern

**Changes Required**:

**REPLACE lines 287-315** (RAG Integration section):

```markdown
## RAG Integration

RAG is active. Access RAG tools through ToolHive Gateway:

### Query RAG for Research
```
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: {
    query: "[topic] implementation patterns",
    topK: 5,
    filter: {"type": "decision"}
  }
});
```

### Ingest Decision Analysis
```
await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_ingest",
  parameters: {
    content: "Decision analysis for DECISION_XXX...",
    source: "strategist/DECISION_XXX",
    metadata: {"agent": "strategist", "type": "decision", "decisionId": "DECISION_XXX"}
  }
});
```

### Platform Status
```
await toolhive_call_tool({
  server_name: "p4nth30n-mcp",
  tool_name: "get_system_status",
  parameters: {}
});
```

**Note**: ALL tools flow through ToolHive Gateway. Use `toolhive_find_tool` to discover tools, `toolhive_call_tool` to execute.
```

**UPDATE line 317** (version signature):
Change: `**Strategist v3.1 - File-Based Decision System with RAG and ToolHive Gateway**`
To: `**Strategist v3.2 - File-Based Decision System with ToolHive Gateway**`

---

### 3. orchestrator.md

**File**: `c:\Users\paulc\.config\opencode\agents\orchestrator.md`

**Status**: Already mostly correct - just verify

**Check**: Lines 23-26 and 79-84 should already show ToolHive pattern

**If correct**: No changes needed

---

### 4. librarian.md

**File**: `c:\Users\paulc\.config\opencode\agents\librarian.md`

**Current Issues**:
- Lines 336-361: Shows direct `rag_query()` calls (WRONG - should be through ToolHive)
- Line 36: Already mentions ToolHive Gateway (GOOD)

**Changes Required**:

**REPLACE lines 331-365** (RAG Integration section):

```markdown
## RAG Integration

Access RAG through ToolHive Gateway:

### Query RAG
```
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: {
    query: "[topic] implementation patterns",
    topK: 5,
    filter: {"type": "decision"}
  }
});
```

### Search Similar Documents
```
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_search_similar",
  parameters: {
    documentId: "[known_doc_id]",
    topK: 5
  }
});
```

### Ingest Research Findings
```
await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_ingest",
  parameters: {
    content: "Research findings...",
    source: "librarian/DECISION_XXX",
    metadata: {"agent": "librarian", "type": "research", "decisionId": "DECISION_XXX"}
  }
});
```

### Check RAG Status
```
await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_status",
  parameters: {}
});
```
```

**UPDATE version signature** at end:
Change: `**Librarian v3.1 - Parallel Research Consultant with Active RAG and ToolHive Gateway**`
To: `**Librarian v3.2 - Parallel Research Consultant with ToolHive Gateway**`

---

### 5. explorer.md

**File**: `c:\Users\paulc\.config\opencode\agents\explorer.md`

**Current Issues**:
- Lines 280-297: Shows direct `rag_query()` and `rag_ingest()` calls (WRONG)

**Changes Required**:

**REPLACE lines 274-300** (RAG Integration section):

```markdown
## RAG Integration

Query RAG through ToolHive Gateway before exploration:

### Pre-Exploration Research
```
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: {
    query: "[component] codebase location",
    topK: 5
  }
});
```

### Preserve Findings
```
await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_ingest",
  parameters: {
    content: "Discovery: [component] located at [path]...",
    source: "explorer/DECISION_XXX",
    metadata: {"agent": "explorer", "type": "discovery", "decisionId": "DECISION_XXX"}
  }
});
```
```

**UPDATE version signature**:
Change: `**Explorer v2.1 - Parallel Codebase Discovery with RAG and Platform Data**`
To: `**Explorer v2.2 - Parallel Codebase Discovery with ToolHive Gateway**`

---

### 6. oracle.md

**File**: `c:\Users\paulc\.config\opencode\agents\oracle.md`

**Current Issues**:
- Lines 260-278: Shows direct `rag_query()` and `rag_ingest()` calls (WRONG)
- Lines 298-309: Shows bash syntax for decisions-server (WRONG)

**Changes Required**:

**REPLACE lines 254-315** (RAG Integration and Platform Data sections):

```markdown
## RAG Integration

### Pre-Consultation Research
Query RAG through ToolHive Gateway for similar decisions:

```
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: {
    query: "[related topic]",
    topK: 3,
    filter: {"type": "decision"}
  }
});
```

### Find Patterns
```
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: {
    query: "risk assessment patterns",
    topK: 5
  }
});
```

### Preserve Approval Analysis
```
await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_ingest",
  parameters: {
    content: "Oracle approval analysis for DECISION_XXX...",
    source: "oracle/DECISION_XXX",
    metadata: {"agent": "oracle", "type": "approval", "decisionId": "DECISION_XXX"}
  }
});
```

## Platform Data Access

### Query Decision Details
```
const result = await toolhive_call_tool({
  server_name: "decisions-server",
  tool_name: "findById",
  parameters: {
    decisionId: "DECISION_XXX",
    fields: ["decisionId", "title", "status", "oracleApproval"]
  }
});
```

### Update Decision with Analysis
```
await toolhive_call_tool({
  server_name: "decisions-server",
  tool_name: "updateImplementation",
  parameters: {
    decisionId: "DECISION_XXX",
    oracleAnalysis: {
      approvalPercentage: 85,
      keyFindings: ["..."],
      risks: ["..."]
    }
  }
});
```
```

**UPDATE version signature**:
Change: `**Oracle v2.1 - Approval Rating System with RAG and Platform Data**`
To: `**Oracle v2.2 - Approval Rating System with ToolHive Gateway**`

---

### 7. designer.md

**File**: `c:\Users\paulc\.config\opencode\agents\designer.md`

**Current Issues**:
- Lines 292-301: Shows direct `rag_query()` and `rag_ingest()` calls (WRONG)
- Lines 321-332: Shows bash syntax (WRONG)

**Changes Required**:

**REPLACE lines 286-340** (RAG Usage and Platform Data sections):

```markdown
### RAG Usage

Query RAG through ToolHive Gateway before research:

```
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: {
    query: "[implementation pattern]",
    topK: 5,
    filter: {"type": "documentation"}
  }
});
```

### Preserve Specifications
```
await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_ingest",
  parameters: {
    content: "Implementation specification for DECISION_XXX...",
    source: "designer/DECISION_XXX",
    metadata: {"agent": "designer", "type": "specification", "decisionId": "DECISION_XXX"}
  }
});
```

## Platform Data Access

### Query Decision Context
```
const result = await toolhive_call_tool({
  server_name: "decisions-server",
  tool_name: "findById",
  parameters: {
    decisionId: "DECISION_XXX"
  }
});
```

### Update with Implementation Plan
```
await toolhive_call_tool({
  server_name: "decisions-server",
  tool_name: "updateImplementation",
  parameters: {
    decisionId: "DECISION_XXX",
    designerAnalysis: {
      approvalPercentage: 92,
      implementationStrategy: "...",
      filesToModify: ["..."]
    }
  }
});
```
```

**UPDATE version signature**:
Change: `**Designer v2.1 - Direct Strategist Consultation with RAG and Platform Data**`
To: `**Designer v2.2 - Direct Strategist Consultation with ToolHive Gateway**`

---

### 8. openfixer.md

**File**: `c:\Users\paulc\.config\opencode\agents\openfixer.md`

**Current Issues**:
- Lines 106-142: Shows bash syntax `toolhive-mcp-optimizer_call_tool` (WRONG)
- Lines 153-155: Shows direct `rag_ingest()` call (WRONG)

**Changes Required**:

**REPLACE lines 100-160** (Implementation Steps):

```markdown
## Implementation Steps

1. **Query Decision from Server**
   ```
   const decision = await toolhive_call_tool({
     server_name: "decisions-server",
     tool_name: "findById",
     parameters: { decisionId: "DECISION_XXX" }
   });
   ```

2. **Query RAG for Patterns**
   ```
   const patterns = await toolhive_call_tool({
     server_name: "rag-server",
     tool_name: "rag_query",
     parameters: {
       query: "implementation patterns for [technology]",
       topK: 5,
       filter: {"type": "decision"}
     }
   });
   ```

3. **Implement Changes**
   - Follow decision specification
   - Use file tools (read, edit, write) - these are native OpenCode tools
   - Reference patterns from RAG

4. **Test Implementation**
   - Run validation commands
   - Verify acceptance criteria

5. **Update Decision Status**
   ```
   await toolhive_call_tool({
     server_name: "decisions-server",
     tool_name: "updateStatus",
     parameters: {
       decisionId: "DECISION_XXX",
       status: "Completed",
       implementationNotes: "..."
     }
   });
   ```

6. **Ingest Implementation Details to RAG**
   ```
   await toolhive_call_tool({
     server_name: "rag-server",
     tool_name: "rag_ingest",
     parameters: {
       content: "Implementation details for DECISION_XXX...",
       source: "openfixer/DECISION_XXX",
       metadata: {
         "agent": "openfixer",
         "type": "implementation",
         "decisionId": "DECISION_XXX",
         "filesModified": ["..."]
       }
     }
   });
   ```
```

**UPDATE version signature**:
Change: `**OpenFixer v2.2 - Documentation-Critical Workflow with Active RAG and Honeybelt**`
To: `**OpenFixer v2.3 - Documentation-Critical Workflow with ToolHive Gateway**`

---

### 9. fixer.md

**File**: `c:\Users\paulc\.config\opencode\agents\fixer.md`

**Current**: Very short, mentions ToolHive but no examples

**Changes Required**:

**ADD after line 28** (after Canon Patterns):

```markdown
## Tool Usage

### Your Available Tools
- `toolhive_find_tool` - Discover available tools
- `toolhive_call_tool` - Execute any tool through ToolHive Gateway

### How to Use Tools

**Find a tool:**
```
const toolInfo = await toolhive_find_tool({
  tool_description: "search the web for information",
  tool_keywords: "search web"
});
```

**Call the tool:**
```
const result = await toolhive_call_tool({
  server_name: "tavily-mcp",
  tool_name: "tavily_search",
  parameters: { query: "...", max_results: 5 }
});
```

### Common Patterns

**Research before implementation:**
```
const research = await toolhive_call_tool({
  server_name: "tavily-mcp",
  tool_name: "tavily_search",
  parameters: { query: "[technology] best practices" }
});
```

**Query RAG for patterns:**
```
const patterns = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: { query: "[pattern] implementation", topK: 3 }
});
```

**Preserve findings:**
After completing work, findings are ingested to RAG by background @librarian task.
```

---

### 10. forgewright.md

**File**: `c:\Users\paulc\.config\opencode\agents\forgewright.md`

**Current**: Line 25 mentions RAG but unclear pattern

**Changes Required**:

**REPLACE line 25** (Canon Pattern 3):

From:
```markdown
3. **RAG is active**: RAG.McpHost is running. Query RAG for past bug patterns and triage history. Ingest your findings after every triage for the team's benefit.
```

To:
```markdown
3. **RAG via ToolHive**: Query RAG through ToolHive Gateway for past bug patterns:
   ```
   const patterns = await toolhive_call_tool({
     server_name: "rag-server",
     tool_name: "rag_query",
     parameters: { query: "bug patterns [category]", topK: 5 }
   });
   ```
   Ingest findings after triage:
   ```
   await toolhive_call_tool({
     server_name: "rag-server",
     tool_name: "rag_ingest",
     parameters: {
       content: "Triage findings for [bug]...",
       source: "forgewright/[bug-id]",
       metadata: {"agent": "forgewright", "type": "triage"}
     }
   });
   ```
```

---

### 11. four_eyes.md

**File**: `c:\Users\paulc\.config\opencode\agents\four_eyes.md`

**Current Issues**:
- Lines 89-95: Shows direct `rag_query()` call (WRONG)
- Lines 251-272: Shows RAG integration with direct calls (WRONG)

**Changes Required**:

**REPLACE lines 245-280** (RAG Integration section):

```markdown
## RAG Integration

### Pre-Review Research (MANDATORY)
Query RAG through ToolHive Gateway for related decisions:

```
const related = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: {
    query: "[decision topic]",
    topK: 3,
    filter: {"type": "decision"}
  }
});
```

### Find Similar Decisions
```
const similar = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: {
    query: "similar to DECISION_XXX",
    topK: 5
  }
});
```

### Preserve Review Findings
```
await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_ingest",
  parameters: {
    content: "FourEyes review of DECISION_XXX...",
    source: "four_eyes/DECISION_XXX",
    metadata: {
      "agent": "four_eyes",
      "type": "review",
      "decisionId": "DECISION_XXX",
      "reviewType": "second_opinion"
    }
  }
});
```
```

**UPDATE version signature**:
Change: `**Four Eyes v1.1 - Independent Second Opinion Review with Active RAG**`
To: `**Four Eyes v1.2 - Independent Second Opinion Review with ToolHive Gateway**`

---

## Verification Steps

After updating each agent prompt:

1. **Read the updated file** to verify changes
2. **Check YAML frontmatter** has `toolhive_find_tool: true` and `toolhive_call_tool: true`
3. **Verify no direct tool calls** remain (no `rag_query()`, no `tavily_search()`)
4. **Verify no bash syntax** remains (no `toolhive-mcp-optimizer_call_tool`)
5. **Verify no YAML syntax** remains (no `rag-server.rag_query`)
6. **Test if possible**: Have agent invoke a simple tool call

---

## DECISION_061 Update

**File**: `c:\P4NTHE0N\STR4TEG15T\decisions\active\DECISION_061.md`

**Add to completion criteria** (around line 20):

```markdown
**Tool Usage Verification**:
- Agent prompts updated with correct ToolHive Gateway patterns
- All direct tool call examples removed
- ToolHive wrapper pattern (find_tool → call_tool) documented
- Verification tests completed for each agent
- DECISION_062 created to track tool documentation standardization
```

---

## Success Criteria

- [ ] All 11 agent prompts updated
- [ ] AGENTS.md has troubleshooting section
- [ ] No direct tool call examples remain
- [ ] No bash syntax remains
- [ ] No YAML syntax for tool calls remains
- [ ] All agents show ToolHive Gateway pattern
- [ ] DECISION_061 updated with tool verification criteria
- [ ] Version numbers bumped (v3.1 → v3.2, v2.1 → v2.2, etc.)

---

## Notes for Implementation

**CRITICAL ARCHITECTURE UNDERSTANDING**:
- ALL tools flow through ToolHive Gateway
- The `tools:` YAML frontmatter declares what's AVAILABLE, not direct access
- Agents use `toolhive_find_tool` → `toolhive_call_tool` for ALL tool access
- No exceptions, no "direct" access, no shortcuts

**Common Mistakes to Avoid**:
- ❌ `rag_query({query: "..."})` - Direct call doesn't exist
- ❌ `rag-server.rag_query` - YAML documentation format, not execution
- ❌ `toolhive-mcp-optimizer_call_tool` - Bash syntax, not agent pattern
- ✅ `toolhive_call_tool({server_name: "...", tool_name: "...", parameters: {...}})` - CORRECT

**Template Reference**:
Full examples in: `STR4TEG15T/tools/tool-usage-template/TOOL-USAGE-TEMPLATE.md`

---

*Implementation Package for DECISION_062*  
*ToolHive Gateway Architecture*  
*All tools flow through unified interface*
