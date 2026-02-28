# INFRA-068: MCP Server Configuration Consolidation and Cleanup

**Decision ID**: INFRA-068  
**Category**: INFRA  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-21  
**Oracle Approval**: 95  
**Designer Approval**: Approved

---

## Executive Summary

Consolidated and cleaned up the MCP (Model Context Protocol) server configuration in OpenCode to use **ToolHive Desktop** as the single source of truth. Removed redundant, broken, and duplicate MCP entries, resulting in a clean 16-server configuration (3 local + 13 remote) with all servers verified healthy.

**Current Problem**:
- MCP configuration was fragmented with duplicate gateways and overlapping functionality
- `toolhive-gateway` (custom Node.js aggregator) was redundant with ToolHive Desktop's native capabilities
- `mcp-p4nthon` duplicated ToolHive's `mongodb-p4nth30n` server
- `kimi-mcp-server` entry pointed to non-existent file
- Mixed configuration formats causing potential conflicts

**Proposed Solution**:
- Use ToolHive Desktop (`thv client register opencode`) as the single MCP authority
- Remove redundant custom gateway and duplicate local servers
- Clean up dead entries with missing files
- Standardize all remote MCPs on `"type": "remote"` format
- Verify all remaining local MCP entry points exist

---

## Background

### Current State
The OpenCode MCP configuration had grown organically with overlapping and redundant entries:

1. **Custom `toolhive-gateway`** - Node.js aggregator at `C:/P4NTHE0N/tools/mcp-development/servers/toolhive-gateway/dist/index.js` that manually aggregated 5 MCP servers
2. **ToolHive Desktop** - Native containerized MCP management with 15 servers
3. **Mixed local entries** - Some with missing files, some duplicating ToolHive functionality
4. **Incorrect format** - Some entries used `"type": "http"` (wrong) instead of `"type": "remote"` (correct)

### Desired State
ToolHive Desktop manages ALL MCP servers via its native OpenCode client registration, exposing them as `"type": "remote"` HTTP endpoints. Only standalone local MCPs that ToolHive doesn't manage remain as `"type": "local"`.

---

## Specification

### Requirements

1. **INFRA-068-1**: Remove redundant `toolhive-gateway` custom aggregator
   - **Priority**: Must
   - **Acceptance Criteria**: No custom gateway entry in opencode.json

2. **INFRA-068-2**: Remove duplicate `mcp-p4nthon` local server
   - **Priority**: Must
   - **Acceptance Criteria**: ToolHive's `mongodb-p4nth30n` remains as sole MongoDB access point

3. **INFRA-068-3**: Remove dead `kimi-mcp-server` entry
   - **Priority**: Must
   - **Acceptance Criteria**: Entry removed; file `undefined_publisher.windsurf-cartography-1.1.0/mcp/dist/index.js` confirmed non-existent

4. **INFRA-068-4**: Verify remaining local MCP entry points exist
   - **Priority**: Must
   - **Acceptance Criteria**: All 3 remaining local MCPs have valid entry point files

5. **INFRA-068-5**: Validate final JSON syntax
   - **Priority**: Must
   - **Acceptance Criteria**: `node -e "JSON.parse(...)"` passes without errors

### Technical Details

**Before (messy, 18+ entries)**:
```json
{
  "toolhive-gateway": {"type": "local", ...},  // REDUNDANT
  "mcp-p4nthon": {"type": "local", ...},       // DUPLICATE of mongodb-p4nth30n
  "kimi-mcp-server": {"type": "local", ...},   // DEAD - file missing
  // ... plus ToolHive's 15 servers
}
```

**After (clean, 16 entries)**:
```json
{
  // 3 Local MCPs (verified healthy)
  "foureyes-mcp": {"type": "local", "command": [...]},
  "honeybelt-server": {"type": "local", "command": [...]},
  "json-query-mcp": {"type": "local", "command": [...]},
  
  // 13 Remote MCPs (ToolHive-managed, all healthy)
  "toolhive-mcp-optimizer": {"type": "remote", "url": "http://127.0.0.1:19206/mcp"},
  "memory": {"type": "remote", "url": "http://127.0.0.1:40357/mcp"},
  // ... 11 more
}
```

**ToolHive Command Used**:
```bash
thv client register opencode
```
This auto-writes all ToolHive-managed MCPs to opencode.json with correct `"type": "remote"` format.

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-068-1 | Remove `toolhive-gateway` from opencode.json | OpenFixer | Completed | High |
| ACT-068-2 | Remove `mcp-p4nthon` (redundant) | OpenFixer | Completed | High |
| ACT-068-3 | Remove `kimi-mcp-server` (dead entry) | OpenFixer | Completed | High |
| ACT-068-4 | Verify local MCP files exist | OpenFixer | Completed | High |
| ACT-068-5 | Validate JSON syntax | OpenFixer | Completed | Medium |
| ACT-068-6 | Document final configuration | OpenFixer | Completed | Medium |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: DECISION_062 (Agent Prompt Tool Usage), DECISION_061 (RAG File Watcher)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Removing working MCP breaks functionality | High | Low | Verified all ToolHive servers healthy before removal |
| JSON syntax error corrupts config | Medium | Low | Validated with `node -e "JSON.parse(...)"` |
| Local MCP files missing | Medium | Low | Verified all 3 local entry points exist with `ls -la` |

---

## Success Criteria

1. ✅ Only 16 MCP servers in opencode.json (down from 18+)
2. ✅ All 13 ToolHive remote servers use correct `"type": "remote"` format
3. ✅ All 3 local MCPs have verified entry point files
4. ✅ JSON syntax validation passes
5. ✅ No duplicate or redundant servers
6. ✅ No dead entries pointing to missing files

---

## Token Budget

- **Estimated**: 8,000 tokens
- **Actual**: ~6,500 tokens
- **Model**: OpenFixer (Claude 3.5 Sonnet)
- **Budget Category**: Routine (<50K)

---

## Bug-Fix Section

- **On syntax error**: Revert to backup, re-apply changes carefully
- **On missing file**: Remove entry or restore missing file
- **On config error**: Delegate to @openfixer for CLI/config operations
- **Escalation threshold**: Not applicable — simple cleanup task

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |

---

## Verification Log

### Local MCP Entry Point Verification
| MCP | File Path | Exists? | Size | Modified |
|-----|-----------|---------|------|----------|
| foureyes-mcp | `C:/P4NTHE0N/tools/mcp-foureyes/server.js` | ✅ Yes | 17KB | Feb 20 21:57 |
| honeybelt-server | `C:/P4NTHE0N/tools/mcp-development/servers/honeybelt-server/dist/index.js` | ✅ Yes | 6KB | Feb 20 16:27 |
| json-query-mcp | `C:/Users/paulc/AppData/Local/json-query-mcp/dist/index.js` | ✅ Yes | 3KB | Feb 12 13:45 |
| mcp-p4nthon | `C:/P4NTHE0N/tools/mcp-p4nthon/dist/index.js` | ✅ Yes (removed - redundant) | 7KB | Feb 20 16:27 |
| kimi-mcp-server | `C:/Users/paulc/.vscode/extensions/undefined_publisher.windsurf-cartography-1.1.0/mcp/dist/index.js` | ❌ No (removed - dead) | N/A | N/A |

### ToolHive Server Health (13 servers)
All servers verified running via `thv list`:
- brightdata-mcp (port 40203) ✅
- chrome-devtools-mcp (port 37139) ✅
- context7-remote (port 29249) ✅
- decisions-server (port 46818) ✅
- fetch (port 36802) ✅
- firecrawl (port 17681) ✅
- memory (port 40357) ✅
- mongodb-p4nth30n (port 59767) ✅
- playwright (port 41224) ✅
- sequentialthinking (port 24596) ✅
- tavily-mcp (port 20854) ✅
- toolhive-mcp-optimizer (port 19206) ✅
- rag-server (port 16238) ✅

### JSON Validation
```bash
node -e "JSON.parse(require('fs').readFileSync('C:/Users/paulc/.config/opencode/opencode.json','utf8')); console.log('JSON is valid')"
# Result: JSON is valid ✅
```

---

## Final Configuration Summary

**File**: `C:\Users\paulc\.config\opencode\opencode.json`
**Total MCP Servers**: 16
**File Size**: 603 lines (down from 620+)

### Local MCPs (3)
1. **foureyes-mcp** - Vision analysis via LMStudio/CDP
2. **honeybelt-server** - System operations and reporting
3. **json-query-mcp** - JSONPath queries on local files

### Remote MCPs via ToolHive (13)
4. toolhive-mcp-optimizer - Tool discovery and optimization
5. memory - Knowledge graph storage
6. chrome-devtools-mcp - Browser automation
7. brightdata-mcp - Web scraping and SERP
8. tavily-mcp - Web search and extraction
9. mongodb-p4nth30n - MongoDB database access
10. firecrawl - Web crawling and extraction
11. decisions-server - Decision tracking and queries
12. sequentialthinking - Multi-step reasoning
13. playwright - Browser automation (alternative)
14. fetch - URL fetching
15. context7-remote - Documentation lookup
16. rag-server - RAG vector search

---

## Notes

### Why ToolHive Desktop Instead of Custom Gateway?
- **Native integration**: `thv client register opencode` auto-writes correct config
- **Container management**: Each MCP runs in isolated container
- **Health monitoring**: Built-in status tracking and auto-restart
- **Port management**: Automatic port allocation, no conflicts
- **Standard format**: Consistent `"type": "remote"` for all HTTP MCPs

### What Was Removed and Why

| Removed | Reason | Replacement |
|---------|--------|-------------|
| `toolhive-gateway` | Redundant custom aggregator | ToolHive Desktop native management |
| `mcp-p4nthon` | Duplicated MongoDB access | ToolHive's `mongodb-p4nth30n` |
| `kimi-mcp-server` | Entry point file missing | None (wasn't functional anyway) |

### Potential Future Cleanup
- **oh-my-opencode-theseus.json**: `disabled_mcps: ["context7"]` may conflict with ToolHive's `context7-remote`
- Consider removing `"context7"` from disabled list since it's now provided by ToolHive

---

*Decision INFRA-068*  
*MCP Server Configuration Consolidation and Cleanup*  
*2026-02-21*
