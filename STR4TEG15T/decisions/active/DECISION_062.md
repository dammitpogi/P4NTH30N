# DECISION_062: Agent Prompt Tool Usage Documentation Update

**Decision ID**: DECISION_062  
**Category**: FORGE  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-21  
**Oracle Approval**: 84%  
**Designer Approval**: 95%

---

## Executive Summary

The agent prompts were updated in DECISION_061 to reflect that RAG is active and ToolHive Gateway is the tool access method. However, the documentation shows tool usage patterns that don't match the actual OpenCode plugin architecture. This decision standardizes how tool usage should be documented in agent prompts to ensure agents can actually invoke tools correctly.

**Current Problem**:
- Agent prompts show tool calls like `rag_query(query="...")` or `rag-server.rag_query`
- These patterns don't match how OpenCode actually exposes tools to agents
- Agents may be confused about whether they have direct tool access or need to use ToolHive wrapper functions
- No clear distinction between what the Strategist documents vs what agents can actually call

**Proposed Solution**:
- Audit all agent prompts for tool usage documentation
- Standardize on the correct OpenCode tool invocation pattern
- Clarify which agents have direct tool access vs wrapper-based access
- Update DECISION_061 completion criteria to include tool usage verification

---

## Background

### Current State

After DECISION_061, agent prompts contain RAG and ToolHive references:

**Strategist.md** (lines 287-315):
```markdown
## RAG Integration
RAG is active. Use RAG tools through the ToolHive Gateway for:

### Pre-Decision Research
```
rag-server.rag_query
  query: "[topic] implementation patterns"
  topK: 5
  filter: {"type": "decision"}
```
```

**Librarian.md** (lines 331-361):
```markdown
## RAG Integration

# Query RAG for past research on similar topics
rag_query(
  query="[topic] implementation patterns",
  topK=5,
  filter={"type": "decision"}
)
```
```

**OpenFixer.md** (lines 111-155):
```markdown
2. **Query RAG for Patterns**
   
   rag_query(
     query="implementation patterns for [technology]",
     topK=5,
     filter={"type": "decision"}
   )

9. **Ingest to RAG**
   
   rag_ingest(
     content="Implementation details...",
     source="openfixer/DECISION_XXX",
     metadata={"agent": "openfixer", "type": "implementation"}
   )
```
```

### The Problem

These documentation patterns suggest agents can call tools directly, but the actual OpenCode architecture works differently:

1. **ToolHive Gateway** is configured in `opencode.json` as an MCP server
2. **Agents don't directly invoke MCP tools** - they use wrapper functions or the system routes calls
3. **The `toolhive_find_tool` and `toolhive_call_tool` pattern** is shown in some prompts but not consistently
4. **No verification** that agents can actually successfully call these tools

### What Actually Works

From the skill file (`toolhive/SKILL.md`):
```javascript
// Step 1: Find the right tool
const toolInfo = await toolhive_find_tool({
  tool_description: "search the web for current information",
  tool_keywords: "search web news"
});

// Step 2: Call the tool with the exact server_name and tool_name from step 1
const result = await toolhive_call_tool({
  server_name: "tavily-mcp",
  tool_name: "tavily_search",
  parameters: { query: "...", max_results: 5 }
});
```

But this JavaScript/TypeScript pattern doesn't match the PowerShell-style examples in agent prompts.

---

## Specification

### Requirements

#### DECISION_062-001: Tool Usage Pattern Audit
**Priority**: Must  
**Acceptance Criteria**:
- Audit all 11 agent prompt files for tool usage documentation
- Identify which prompts show direct tool calls vs wrapper calls
- Document the actual OpenCode tool exposure mechanism
- Create a matrix of which agents have which tools available

#### DECISION_062-002: Standardize Tool Documentation
**Priority**: Must  
**Acceptance Criteria**:
- Choose ONE consistent pattern for documenting tool usage
- Update all agent prompts to use the standardized pattern
- Include examples that match actual invocation syntax
- Add troubleshooting section for common tool call failures

#### DECISION_062-003: Tool Access Verification
**Priority**: Should  
**Acceptance Criteria**:
- Test that each agent can actually invoke their documented tools
- Verify RAG queries work from librarian, oracle, designer, explorer
- Verify ToolHive gateway calls work from all agents
- Document any agents that need wrapper functions vs direct access

#### DECISION_062-004: Update DECISION_061 Completion Criteria
**Priority**: Should  
**Acceptance Criteria**:
- Add tool usage verification to DECISION_061's definition of done
- Update DECISION_061.md to reflect that tool documentation was part of the work
- Ensure future prompt updates include tool usage testing

### Technical Details

**OpenCode Tool Architecture**:

```
User Request
    ↓
OpenCode Plugin (oh-my-opencode-theseus)
    ↓
MCP Client
    ↓
toolhive-gateway (configured in opencode.json)
    ↓
Routes to: rag-server, p4nth30n-mcp, decisions-server, etc.
```

**How Agents Actually Call Tools**:

**CORRECTION**: ALL tools flow through ToolHive Gateway. There is no "direct" access.

The ToolHive Gateway exposes tools from multiple servers (rag-server, decisions-server, etc.) through a unified interface:

```markdown
Use ToolHive Gateway for ALL tool access:

1. Find the tool:
```
toolhive_find_tool({
  tool_description: "search the knowledge base",
  tool_keywords: "rag query"
})
```

2. Call the tool with exact server/tool names:
```
toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: { query: "...", topK: 5 }
})
```
```

**Agent YAML Frontmatter**: The `tools:` section in agent prompts declares which tools the agent CAN call through ToolHive, not direct access permissions.

**Current Agent Tool Access**:

| Agent | rag_query | rag_ingest | toolhive_find_tool | toolhive_call_tool |
|-------|-----------|------------|-------------------|-------------------|
| librarian | ✅ | ✅ | ✅ | ✅ |
| oracle | ✅ | ✅ | ❌ | ❌ |
| designer | ✅ | ✅ | ❌ | ❌ |
| explorer | ✅ | ✅ | ❌ | ❌ |
| openfixer | ✅ | ✅ | ✅ | ✅ |
| four_eyes | ✅ | ❌ | ✅ | ✅ |
| fixer | ❌ | ❌ | ✅ | ✅ |
| forgewright | ❌ | ❌ | ✅ | ✅ |
| strategist | ❌ | ❌ | ✅ | ✅ |

**Issue**: Some agents have RAG tools enabled but show ToolHive wrapper patterns in their prompts. This is confusing.

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-062-001 | Audit all agent prompts for tool usage patterns | Strategist | Ready | Critical |
| ACT-062-002 | Test actual tool invocation from each agent | OpenFixer | Ready | Critical |
| ACT-062-003 | Document the correct tool exposure mechanism | Strategist | Ready | High |
| ACT-062-004 | Update agent prompts with standardized patterns | WindFixer | Ready | High |
| ACT-062-005 | Add tool troubleshooting section to AGENTS.md | Strategist | Ready | Medium |
| ACT-062-006 | Update DECISION_061 with tool verification criteria | Strategist | Ready | Medium |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: DECISION_061 (Agent Prompt Updates), DECISION_051 (ToolHive Gateway)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Agents can't actually call tools as documented | High | Medium | Test each agent's tool access before updating prompts |
| Inconsistent patterns confuse agents | Medium | High | Standardize on ONE pattern per agent type |
| Tool exposure changes break existing workflows | Medium | Low | Version control agent prompts, test before deploy |
| OpenCode plugin architecture changes | Low | Low | Monitor plugin updates, adapt documentation |

---

## Success Criteria

1. **All agent prompts** show consistent tool usage patterns
2. **Each agent** can successfully invoke their documented tools
3. **Tool troubleshooting guide** exists in AGENTS.md
4. **DECISION_061** updated to include tool verification
5. **No agent** shows tool calls they can't actually make

---

## Questions for Oracle

1. Should all agents have direct RAG tool access, or only specific agents?
2. Is the ToolHive wrapper pattern (find_tool → call_tool) the preferred approach?
3. What happens if an agent tries to call a tool they don't have access to?

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-21
- **Status**: Complete
- **Approval**: 84%

**Key Finding**: ALL tools flow through ToolHive Gateway. There is no "direct" access.

**Answers**:
1. RAG Access: ToolHive wrapper is universal pattern
2. Preferred Pattern: find_tool → call_tool for ALL agents
3. Failure Mode: Permission errors throw Errors requiring fallback

### Designer Consultation
- **Date**: 2026-02-21
- **Status**: Complete
- **Approval**: 95%

**Key Design Decisions**:
1. Universal ToolHive pattern for ALL agents
2. Frontmatter declares what's available through ToolHive
3. Single consistent syntax
4. Verification mandate
5. No bash syntax examples
6. Reference skill file

**Implementation**: 6 phases, 11 agent files + AGENTS.md + templates

---

## Strategist Assessment

**Average Approval**: 89.5% - APPROVED

**Critical Correction**: All tools flow through ToolHive Gateway. No "direct" access exists.

---

## Notes

**Why This Decision Exists**:
DECISION_061 updated agent prompts to say "RAG is active" but showed inconsistent patterns. This decision standardizes on the ToolHive wrapper pattern for ALL agents.

**Scope**:
- Update agent prompt documentation ONLY
- Standardize on ToolHive wrapper pattern
- No changes to tool implementations
- No changes to OpenCode plugin configuration

**Definition of Done**:
- [x] All 11 agent prompts audited
- [x] Tool usage patterns standardized (ToolHive wrapper only)
- [x] Each agent's tool access tested and verified
- [x] AGENTS.md includes tool troubleshooting guide
- [x] DECISION_061 updated with tool verification criteria

---

## Research Foundation

### ArXiv Papers Referenced

This decision incorporates findings from peer-reviewed research on agent tool usage:

**[arXiv:2509.07223] Agentic DraCor and the Art of Docstring Engineering**  
*Peer Trilcke et al.* - Documents MCP server implementation showing well-engineered docstrings directly impact agent tool usage effectiveness. Agents perform significantly better with structured, example-rich documentation.

**[arXiv:2509.02535] Improving LLMs Function Calling via Guided-Structured Templates**  
*Hy Dang et al.* - Demonstrates that guided-structured templates improve both accuracy and interpretability of tool usage. Templates should include: purpose, parameters (with types/examples), return values, error conditions, and usage examples.

**[arXiv:2410.18490] Repairing Tool Calls Using Post-tool Execution Reflection and RAG**  
*Jason Tsay et al.* - Shows that tool documentation should include not just "how to call" but "common failure modes and recovery patterns." Post-execution reflection combined with RAG can repair failed tool calls by retrieving similar successful patterns.

**[arXiv:2509.14009] OpaqueToolsBench: Learning Nuances of Tool Behavior**  
*Skyler Hallinan et al.* - Finds that static documentation is insufficient—agents need interactive learning mechanisms and usage examples, not just function signatures.

### Research-Backed Requirements

Based on these papers, SKILL.md templates must include:

1. **Purpose Section** - Clear statement of what the tool does
2. **Parameters** - Type information with concrete examples
3. **Return Values** - Expected output structure with examples
4. **Error Conditions** - Common failure modes and their meanings
5. **Usage Examples** - Working code samples (not just syntax)
6. **Common Pitfalls** - Mistakes agents frequently make
7. **Recovery Patterns** - How to handle failures gracefully

---

## Implementation Completion

**Implemented By**: @openfixer  
**Completion Date**: 2026-02-21  
**Status**: ✅ COMPLETED

### Files Modified
| # | File | Changes | Version |
|---|------|---------|---------|
| 1 | AGENTS.md | Added troubleshooting section (~30 lines) | — |
| 2 | strategist.md | RAG Integration section | v3.1 → v3.2 |
| 3 | orchestrator.md | Verified already correct | — |
| 4 | librarian.md | RAG Integration + Tool Usage | v3.1 → v3.2 |
| 5 | explorer.md | RAG Integration section | v2.1 → v2.2 |
| 6 | oracle.md | RAG Integration + Platform Data | v2.1 → v2.2 |
| 7 | designer.md | RAG Usage + Platform Data | v2.1 → v2.2 |
| 8 | openfixer.md | Implementation Steps | v2.2 → v2.3 |
| 9 | fixer.md | Added Tool Usage section | — |
| 10 | forgewright.md | Canon Pattern 3 | — |
| 11 | four_eyes.md | RAG Integration section | v1.1 → v1.2 |
| 12 | DECISION_061.md | Tool Usage Verification criteria | — |

### Key Corrections Applied
**Before (WRONG)**:
- ❌ `rag_query({query: "..."})` - suggests direct function
- ❌ `rag-server.rag_query` - YAML documentation format
- ❌ `toolhive-mcp-optimizer_call_tool` - bash syntax

**After (CORRECT)**:
- ✅ `await toolhive_call_tool({server_name: "...", tool_name: "...", parameters: {...}})`

### Critical Architecture Documented
ALL tools flow through ToolHive Gateway. No exceptions. The `tools:` YAML frontmatter shows what's available through ToolHive, not direct access.

---

*Decision DECISION_062*  
*Agent Prompt Tool Usage Documentation Update*  
*2026-02-21*  
*Status: Completed*
