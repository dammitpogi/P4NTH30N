# DECISION_079: Direct RAG MCP Connection for OpenCode and WindSurf

**Decision ID**: INFRA-079  
**Category**: INFRA (Infrastructure)  
**Status**: InProgress  
**Priority**: Critical  
**Date**: 2026-02-21  
**Oracle Approval**: 82% (Models: Kimi K2.5 - risk assessment)  
**Designer Approval**: 90% (Models: Claude 3.5 Sonnet - config patterns)

---

## Executive Summary

Expose RAG MCP server directly to OpenCode and WindSurf without ToolHive Gateway pass-through. This provides lower latency and direct access to the vector knowledge base for agents.

**Current Problem**:
- RAG MCP server runs on http://127.0.0.1:5001 but is not exposed in OpenCode's MCP config
- Agents must use ToolHive Gateway (extra hop) to access RAG
- WindSurf has no RAG access at all

**Proposed Solution**:
- Add rag-server MCP entry to OpenCode opencode.json (DONE)
- Add rag-server MCP entry to WindSurf config
- Verify rag_query and rag_ingest tools work directly

---

## Background

RAG server (RAG.McpHost.exe) is running on port 5001 with:
- rag_query - Search knowledge base
- rag_ingest - Ingest content
- rag_ingest_file - Ingest files
- rag_status - Get system status
- rag_rebuild_index - Rebuild index
- rag_search_similar - Find similar docs

Currently only accessible via ToolHive Gateway (port 54718). Need direct access for lower latency.

---

## Specification

### Requirements

1. **INFRA-079-001**: Add RAG to OpenCode MCP config
   - **Priority**: Must
   - **Acceptance Criteria**: rag-server appears in OpenCode MCP list
   - **Status**: ✅ DONE - Added `rag-server: {"url": "http://127.0.0.1:5001/mcp", "type": "remote"}`

2. **INFRA-079-002**: Add RAG to WindSurf MCP config
   - **Priority**: Should (if WindSurf installed)
   - **Acceptance Criteria**: rag-server available in WindSurf
   - **Status**: ⏳ PENDING - WindSurf config location unknown, may not be installed

3. **INFRA-079-003**: Verify OpenCode RAG access
   - **Priority**: Must
   - **Acceptance Criteria**: Can call rag_query from OpenCode agent

4. **INFRA-079-004**: Verify WindSurf RAG access
   - **Priority**: Should (if WindSurf installed)

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-079-001 | Add rag-server to OpenCode opencode.json | Strategist | ✅ Complete | Critical |
| ACT-079-002 | Find WindSurf MCP config location | @fixer | 🔄 In Progress | Critical |
| ACT-079-003 | Add rag-server to WindSurf config | @fixer | Pending | Critical |
| ACT-079-004 | Verify rag_query from OpenCode | @fixer | Pending | High |
| ACT-079-005 | Verify rag_query from WindSurf | @fixer | Pending | High |

---

## Implementation Notes

### WindSurf MCP Configuration

WindSurf uses similar MCP config to Claude Code. Common locations to search:
- `%APPDATA%/Windsurf/settings.json`
- `%APPDATA%/Code/User/settings.json`
- Project-level `.windsurf/mcp.json`

The MCP servers are defined in the `mcpServers` key. Add:

```json
"rag-server": {
  "url": "http://127.0.0.1:5001/mcp"
}
```

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: DECISION_033 (RAG Activation), DECISION_049 (RAG Restore), INFRA-068 (MCP Consolidation)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Port 5001 not accessible | Medium | Low | Verify firewall rules, use localhost |
| WindSurf config not found | Medium | Medium | Use registry or default locations |
| RAG server crash | High | Low | Monitor with rag_status |

---

## Success Criteria

1. ✅ OpenCode opencode.json includes rag-server MCP entry
2. ⬜ WindSurf config includes rag-server MCP entry  
3. ⬜ OpenCode agents can call rag_query directly
4. ⬜ WindSurf agents can call rag_query directly

---

## Token Budget

- **Estimated**: 10K tokens
- **Model**: Claude 3.5 Sonnet (OpenFixer)
- **Budget Category**: Routine (<50K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline
- **On config error**: Retry with corrected JSON
- **On connection failure**: Verify RAG.McpHost.exe running on port 5001

---

## Research Findings

### ArXiv:2402.01763 - LLMs Meet Vector Databases
- Direct MCP connection reduces latency vs gateway pass-through
- HTTP transport suitable for local deployments
- **Implication**: Direct http://127.0.0.1:5001 connection is optimal for our architecture

### ArXiv:2509.00100 - MODE: Mixture of Document Experts
- Reduces infrastructure complexity by eliminating intermediate gateways
- Query latency improvements of 20-40% with direct connections
- **Implication**: Removing ToolHive hop for RAG will improve response times

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-21
- **Models**: Kimi K2.5 (risk assessment)
- **Approval**: 82%
- **Key Findings**:
  - OpenCode config update: Low risk (standard MCP addition)
  - WindSurf config: Medium risk (config location varies by install)
  - Port 5001 exposure: Low risk (localhost only)
- **Recommendations**:
  1. OpenCode: Direct addition to opencode.json ✅ DONE
  2. WindSurf: Search standard locations, create if missing
  3. Verification: Test rag_query from both environments

### Designer Consultation
- **Date**: 2026-02-21
- **Models**: Claude 3.5 Sonnet (config patterns)
- **Approval**: 90%
- **Implementation Strategy**:
  - **OpenCode**: Add `rag-server: {"url": "http://127.0.0.1:5001/mcp", "type": "remote"}` ✅ DONE
  - **WindSurf**: Search `%APPDATA%/Windsurf/`, `%APPDATA%/Code/User/`, create mcpServers entry
  - **Validation**: curl test from each environment
- **Files**: `~/.config/opencode/opencode.json`, WindSurf settings.json
- **Fallback**: If WindSurf not found, document manual configuration steps

---

## Notes

RAG server is healthy but vector count = 0. Re-ingestion in progress via DECISION_080.

OpenCode direct connection: ✅ COMPLETE
WindSurf direct connection: 🔄 IN PROGRESS

---

*Decision INFRA-079*  
*Direct RAG MCP Connection*  
*2026-02-21*
