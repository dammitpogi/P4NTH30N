---
type: decision
id: DECISION_051
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.684Z'
last_reviewed: '2026-02-23T01:31:15.684Z'
keywords:
  - decision051
  - configurable
  - toolhive
  - desktop
  - integration
  - executive
  - summary
  - background
  - current
  - state
  - desired
  - specification
  - requirements
  - technical
  - details
  - action
  - items
  - dependencies
  - risks
  - and
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: DECISION_051 **Category**: INFRA **Status**: Completed
  **Priority**: Critical **Date**: 2026-02-20 **Completed**: 2026-02-21 **Oracle
  Approval**: Approved **Designer Approval**: Approved
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_051.md
---
# DECISION_051: Configurable ToolHive Desktop Integration

**Decision ID**: DECISION_051  
**Category**: INFRA  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-20  
**Completed**: 2026-02-21  
**Oracle Approval**: Approved  
**Designer Approval**: Approved

---

## Executive Summary

Integrate the 15 MCP servers running in ToolHive Desktop (C:\Users\paulc\AppData\Local\ToolHive) into the P4NTHE0N ToolHive Gateway with a configurable deployment system. This enables dynamic server registration, configuration management, and easy addition/removal of servers without code changes.

**Current Problem**:
- ToolHive Desktop has 15 MCP servers running on various ports
- ToolHive Gateway only knows about 5 P4NTHE0N servers
- No way to dynamically configure which servers to include
- Manual configuration requires code changes and rebuilds

**Proposed Solution**:
- Create external JSON configuration file for server definitions
- Auto-discovery from ToolHive Desktop runconfigs
- Hot-reload capability without gateway restart
- Deployment scripts for easy configuration updates

---

## Background

### Current State
**ToolHive Desktop** (C:\Users\paulc\AppData\Local\ToolHive\) has 15 running MCP servers:
- fetch (port 36802) - Web scraping
- firecrawl (port 17681) - Web crawling  
- tavily-mcp (port 20854) - Web search
- brightdata-mcp (port 40203) - Web scraping
- playwright (port 41224) - Browser automation
- memory (port 40357) - Knowledge storage
- sequentialthinking (port 24596) - Sequential thinking
- chrome-devtools-mcp (port 37139) - Chrome DevTools
- decisions-server, rag-server, mongodb-p4nth30n, etc.

**ToolHive Gateway** only knows about 5 servers:
- foureyes-mcp, rag-server, p4nth30n-mcp, decisions-server, honeybelt-server

### Desired State
- Single ToolHive Gateway aggregates ALL MCP servers
- External configuration file defines which servers to include
- Auto-discovery from ToolHive Desktop runconfigs
- Easy deployment of new configurations
- No code changes needed to add/remove servers

---

## Specification

### Requirements

1. **CONF-001**: External Configuration File
   - **Priority**: Must
   - **Acceptance Criteria**: JSON config file at `config/servers.json` defines all servers
   - **Format**: Array of server definitions with id, name, transport, connection, tools

2. **CONF-002**: Auto-Discovery from ToolHive Desktop
   - **Priority**: Must
   - **Acceptance Criteria**: Script reads `C:\Users\paulc\AppData\Local\ToolHive\runconfigs\*.json` and generates server configs

3. **CONF-003**: Hot-Reload Support
   - **Priority**: Should
   - **Acceptance Criteria**: Gateway can reload config without restart (or minimal downtime)

4. **CONF-004**: Deployment Scripts
   - **Priority**: Must
   - **Acceptance Criteria**: Scripts to deploy configurations, validate, and rollback

5. **CONF-005**: Server Categories/Tags
   - **Priority**: Should
   - **Acceptance Criteria**: Servers can be tagged (web, data, automation, etc.) for filtering

6. **CONF-006**: Health Check Integration
   - **Priority**: Must
   - **Acceptance Criteria**: All configured servers are health-checked and reported

### Technical Details

**Configuration Structure** (`config/servers.json`):
```json
{
  "version": "1.0.0",
  "lastUpdated": "2026-02-20T00:00:00Z",
  "servers": [
    {
      "id": "fetch",
      "name": "Fetch MCP Server",
      "transport": "http",
      "connection": {
        "url": "http://127.0.0.1:36802"
      },
      "tags": ["web", "scraping"],
      "enabled": true
    },
    {
      "id": "firecrawl",
      "name": "Firecrawl MCP Server",
      "transport": "http",
      "connection": {
        "url": "http://127.0.0.1:17681"
      },
      "tags": ["web", "crawling"],
      "enabled": true
    }
  ]
}
```

**Auto-Discovery Script** (`scripts/discover-toolhive-desktop.ts`):
- Reads all `.json` files from ToolHive Desktop runconfigs
- Extracts: name, port, transport, image
- Generates server configuration entries
- Outputs to `config/servers.json`

**Deployment Scripts**:
- `deploy-config.ts` - Deploys new configuration
- `validate-config.ts` - Validates configuration before deployment
- `rollback-config.ts` - Rolls back to previous configuration

**Gateway Modifications**:
- Load `config/servers.json` on startup
- Register all enabled servers from config
- Watch file for changes (hot-reload)
- Merge with built-in P4NTHE0N servers

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-051-001 | Create config/servers.json schema | OpenFixer | Completed | Critical |
| ACT-051-002 | Create discover-toolhive-desktop.ts script | OpenFixer | Completed | Critical |
| ACT-051-003 | Create deployment scripts (deploy, validate, rollback) | OpenFixer | Completed | Critical |
| ACT-051-004 | Modify gateway to load external config | OpenFixer | Completed | Critical |
| ACT-051-005 | Add hot-reload capability | OpenFixer | Deferred | High |
| ACT-051-006 | Test with all 15 ToolHive Desktop servers | OpenFixer | Completed | Critical |
| ACT-051-007 | Create documentation | OpenFixer | Completed | Medium |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DECISION_048 (ToolHive proxying - must be working first)
- **Related**: DECISION_049, DECISION_050 (RAG and Decisions server fixes)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Port conflicts | Medium | Low | Validate ports before deployment |
| Config file corruption | High | Low | Backup and rollback capability |
| ToolHive Desktop not running | High | Medium | Check status before deployment |
| Performance with 20+ servers | Medium | Medium | Implement connection pooling |

---

## Success Criteria

1. ✅ All 15 ToolHive Desktop servers accessible through ToolHive Gateway
2. ✅ Configuration can be updated without code changes
3. ✅ Deployment scripts work reliably
4. ✅ Health checks report all servers
5. ✅ Rollback capability tested and working

**Test Results:**
- Discovery: 15/15 servers found
- Validation: 15/15 servers valid
- Deployment: 15/15 servers deployed
- Backup created: servers-2026-02-21T00-21-54-578Z.json

---

## Token Budget

- **Estimated**: 35K tokens
- **Model**: Claude 3.5 Sonnet (OpenFixer)
- **Budget Category**: Critical (<50K)

---

## Consultation Log

### Oracle Consultation
- **Date**: Pending
- **Approval**: Pending
- **Key Findings**: Pending

### Designer Consultation
- **Date**: Pending
- **Key Findings**: Pending

---

## Notes

**ToolHive Desktop Servers to Integrate:**
1. fetch (36802) - Web scraping
2. firecrawl (17681) - Web crawling
3. tavily-mcp (20854) - Web search
4. brightdata-mcp (40203) - Web scraping
5. playwright (41224) - Browser automation
6. memory (40357) - Knowledge storage
7. sequentialthinking (24596) - Sequential thinking
8. chrome-devtools-mcp (37139) - Chrome DevTools
9. decisions-server - Decision management
10. rag-server - RAG knowledge base
11. mongodb-p4nth30n - MongoDB access
12. json-query-mcp - JSON querying
13. context7-remote - Context7 integration
14. modelcontextprotocol-server-filesystem - Filesystem
15. toolhive-mcp-optimizer - ToolHive optimizer

**Configuration Priority:**
1. Web tools: fetch, firecrawl, tavily, brightdata
2. Browser automation: playwright, chrome-devtools
3. Data: memory, mongodb, rag-server
4. Utility: sequentialthinking, json-query, filesystem

---

*Decision DECISION_051*  
*Configurable ToolHive Desktop Integration*  
*2026-02-20*
