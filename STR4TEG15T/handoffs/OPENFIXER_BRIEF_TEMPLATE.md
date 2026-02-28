# STRATEGIST → OPENFIXER DELEGATION BRIEF TEMPLATE

**Brief ID**: OFB-[YYYYMMDD]-[###]  
**Date**: [YYYY-MM-DD HH:MM]  
**Strategist**: [Your name/identifier]  
**Priority**: [Critical / High / Medium / Low]

---

## SOURCE DECISION

**Original Decision ID**: [e.g., RAG-001]  
**Title**: [Full decision title]  
**WindFixer Report**: [Link to WindFixer completion report]

### Decision Context
[2-3 sentence summary of what this decision does and why it matters]

**Example**:  
RAG-001 implements a Retrieval-Augmented Generation layer for P4NTHE0N, enabling all agents to query a vector database of documentation, code, and decisions. WindFixer has completed the P4NTHE0N-side implementation (MCP server, embedding service, FAISS store), but deployment to OpenCode environment requires OpenFixer access.

---

## WINDFIXER COMPLETION STATUS

### What WindFixer Completed ✅
- [x] All P4NTHE0N codebase implementation
- [x] Unit tests (45/45 passing)
- [x] Build validation (0 errors)
- [x] Documentation in P4NTHE0N/docs/

### Files Created by WindFixer
```
src/RAG/
├── McpServer.cs              ✅ Created
├── EmbeddingService.cs       ✅ Created
├── FaissVectorStore.cs       ✅ Created
├── QueryPipeline.cs          ✅ Created
└── IngestionPipeline.cs      ✅ Created

tests/RAG/
└── *Tests.cs                 ✅ 45 tests passing

docs/
└── RAG-001-IMPLEMENTATION.md ✅ Complete
```

---

## OPENFIXER SCOPE

### Blocked Tasks Requiring OpenFixer

| Task | Description | Location | Acceptance Criteria |
|------|-------------|----------|---------------------|
| 1 | Deploy agent configs | `C:\Users\paulc\.config\opencode\agents\` | `deploy-agents.ps1` reports success |
| 2 | Register MCP server | ToolHive MCP registry | `toolhive list-tools` shows rag_* |
| 3 | Verify integration | Cross-platform test | Strategist can call rag_query |

### What OpenFixer Should NOT Do
- ❌ Modify P4NTHE0N/src/ files (WindFixer owns this)
- ❌ Change C# implementation (preserved)
- ❌ Re-run tests (already validated)

### What OpenFixer SHOULD Do
- ✅ Execute deployment scripts
- ✅ Configure OpenCode environment
- ✅ Register MCP tools
- ✅ Validate cross-platform integration
- ✅ Report completion to Strategist

---

## EXECUTION INSTRUCTIONS

### Step 1: Deploy Agent Configurations

**Command**:
```powershell
cd C:\P4NTHE0N
.\scripts\deploy-agents.ps1 -WhatIf   # Preview first
.\scripts\deploy-agents.ps1 -Force    # Execute
```

**Expected Output**:
```
=== Agent Deployment Report ===
Source:  C:\P4NTHE0N\agents
Target:  C:\Users\paulc\.config\opencode\agents
Time:    2026-02-18_21-30-00

Changes detected:
  [+] rag-mcp-server.md (new)
  [~] strategist.md (modified)

Unchanged: 8 file(s)

Deploy 2 change(s)? (y/N): y
  Deployed:  rag-mcp-server.md
  Deployed:  strategist.md

=== Deployment Complete ===
  Files deployed: 2
  Total deployments: 42
```

**Verification**:
```powershell
ls C:\Users\paulc\.config\opencode\agents\rag-mcp-server.md
# Should exist with recent timestamp
```

### Step 2: Register MCP Server

**Command**:
```bash
# Add to MCP config
code C:\Users\paulc\.config\opencode\mcp.json

# Add entry:
{
  "mcpServers": {
    "rag-server": {
      "command": "dotnet",
      "args": ["run", "--project", "C:/P4NTHE0N/src/RAG/McpServer.csproj"]
    }
  }
}
```

**Verification**:
```bash
toolhive list-tools | findstr rag_
# Should show:
# - rag_query
# - rag_ingest
# - rag_status
# etc.
```

### Step 3: Cross-Platform Integration Test

**Test Command** (from Strategist agent):
```csharp
var result = await mcpClient.CallToolAsync(
    "rag-server", 
    "rag_status", 
    new { }
);

// Expected: { healthy: true, vectorCount: 0, status: "ready" }
```

---

## DECISION CONTEXT FOR OPENFIXER

### Why This Matters
[Explain the strategic importance so OpenFixer understands priority]

**Example**:  
RAG-001 enables all agents to access institutional knowledge. Without OpenFixer deployment, agents cannot use RAG capabilities, limiting their effectiveness. This is a blocker for multiple downstream decisions.

### Dependencies
- **Blocks**: [List decisions waiting on this]
- **Depends on**: [List prerequisites already satisfied by WindFixer]

### Oracle/Designer Conditions
- **Designer Rating**: [e.g., 90/100]
- **Oracle Rating**: [e.g., 82/100 conditional]
- **Conditions**: [List any conditions OpenFixer must satisfy]

---

## CONSTRAINTS & LIMITATIONS

### Environment Constraints
- OpenCode directory: `C:\Users\paulc\.config\opencode\`
- Requires PowerShell execution
- ToolHive MCP registry access needed

### Known Issues
- [ ] WindFixer could not access OpenCode (permission boundary)
- [ ] Symbolic links not supported (use copy instead)
- [ ] MCP registration requires OpenCode environment context

### Rollback Plan
If deployment fails:
1. Backups in: `C:\Users\paulc\.config\opencode\agents\.backups\`
2. Restore: Copy `.backups/*.[timestamp].bak` to parent
3. WindFixer state preserved in P4NTHE0N/ (can redeploy)

---

## ACCEPTANCE CRITERIA

OpenFixer completion is validated when:

- [ ] `deploy-agents.ps1` reports success
- [ ] Agent configs exist in OpenCode/agents/
- [ ] MCP server registered with ToolHive
- [ ] `rag_status` tool responds successfully
- [ ] Strategist can execute `rag_query` from agent context
- [ ] No errors in OpenCode logs

---

## REPORTING BACK

Upon completion, OpenFixer must report to Strategist:

**Format**: T4CT1CS/handoffs/completed/OPENFIXER-[DECISION]-[DATE].md

**Required**:
- [ ] Deployment confirmation
- [ ] MCP registration verification
- [ ] Integration test results
- [ ] Any issues encountered
- [ ] Recommendations for WindFixer (if applicable)

---

## ESCALATION

If OpenFixer encounters blockers:
1. Document in T4CT1CS/handoffs/blocked/
2. Tag Strategist for re-assessment
3. Possible actions:
   - Re-delegate to WindFixer (if P4NTHE0N-side fix needed)
   - Escalate to Nexus (if architectural decision needed)
   - Modify decision scope (if condition cannot be met)

---

## REFERENCES

- WindFixer Report: [Link]
- Decision Document: `T4CT1CS/intel/[DECISION]_FINAL_DECISION.md`
- Implementation Guide: `docs/[DECISION]-implementation.md`
- Oracle Brief: `T4CT1CS/intel/ORACLE_BRIEF_[DECISION].md`
- Designer Brief: `T4CT1CS/intel/DESIGNER_BRIEF_[DECISION].md`

---

**Strategist Signature**: [timestamp]  
**OpenFixer Acknowledgment**: [awaiting]  
**Expected Completion**: [timeframe]
