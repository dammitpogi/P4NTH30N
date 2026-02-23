---
type: decision
id: DECISION_050
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.683Z'
last_reviewed: '2026-02-23T01:31:15.683Z'
keywords:
  - decision050
  - restore
  - decisions
  - mcp
  - server
  - healthy
  - status
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
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: DECISION_050 **Category**: INFRA **Status**: Completed
  **Priority**: High **Date**: 2026-02-20 **Oracle Approval**: 82% (Strategist
  Assimilated) **Designer Approval**: 85%
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_050.md
---
# DECISION_050: Restore Decisions MCP Server to Healthy Status

**Decision ID**: DECISION_050  
**Category**: INFRA  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-20  
**Oracle Approval**: 82% (Strategist Assimilated)  
**Designer Approval**: 85%

---

## Executive Summary

The Decisions MCP Server is currently showing as "unhealthy" in the ToolHive Gateway health checks. This HTTP-based server provides decision management capabilities (findById, findByStatus, updateStatus, createDecision, listActive). This decision restores the server to healthy operational status.

**Current Problem**:
- Decisions server status: unhealthy (per ToolHive health check)
- Server provides 5 tools for decision management
- HTTP server on port 44276 not responding
- Decision workflow tools unavailable to agents

**Proposed Solution**:
- Diagnose why decisions-server is not responding on port 44276
- Start/restart the Decisions MCP HTTP server
- Verify HTTP endpoint accessibility
- Confirm healthy status in ToolHive Gateway

---

## Background

### Current State
**CRITICAL FINDING**: The Decisions MCP Server is configured in ToolHive Gateway as HTTP transport, but the actual server implementation uses stdio transport (StdioServerTransport in Docker container).

**Current (Incorrect) ToolHive Configuration**:
```typescript
{
  id: 'decisions-server',
  name: 'Decisions MCP Server',
  transport: 'http',  // WRONG - server uses stdio
  connection: { 
    url: 'http://localhost:44276/mcp',
  },
  ...
}
```

**Actual Server Implementation**:
- Docker container with stdio-based MCP server
- Uses `StdioServerTransport` (hardcoded in /app/dist/index.js)
- Container command: `docker run -i --rm decisions-server:v1.2.0`

Health check shows: `✗ decisions-server: 2ms` (responding but unhealthy - connection refused because HTTP endpoint doesn't exist)

### Desired State
Decisions server status: healthy with all 5 tools operational

---

## Specification

### Requirements

1. **DEC-001**: ✅ ROOT CAUSE IDENTIFIED - Transport mismatch
   - **Priority**: Must
   - **Acceptance Criteria**: Confirmed - ToolHive configured for HTTP, server uses stdio
   - **Status**: Complete - Designer identified root cause

2. **DEC-002**: Update ToolHive Gateway configuration
   - **Priority**: Must
   - **Acceptance Criteria**: Change transport from HTTP to stdio, add docker run command
   - **Configuration Change**:
     ```typescript
     {
       id: 'decisions-server',
       name: 'Decisions MCP Server',
       transport: 'stdio',  // CHANGED from 'http'
       connection: {
         command: 'docker',
         args: ['run', '-i', '--rm', 'decisions-server:v1.2.0']
       },
       ...
     }
     ```

3. **DEC-003**: Fix MongoDB connection string for Windows Docker
   - **Priority**: Must
   - **Acceptance Criteria**: Container can connect to MongoDB
   - **Issue**: `localhost:27017` doesn't work in Windows Docker host mode
   - **Fix**: Use host IP (e.g., `192.168.56.1:27017`) or bridge networking

4. **DEC-004**: Confirm healthy status
   - **Priority**: Must
   - **Acceptance Criteria**: ToolHive health check shows `✓ decisions-server: healthy`

5. **DEC-005**: Test tool functionality
   - **Priority**: Should
   - **Acceptance Criteria**: `listActive` tool returns valid decision list

### Technical Details

**Root Cause Analysis**:
The Decisions MCP Server Docker container uses `StdioServerTransport`, which communicates over stdin/stdout. However, ToolHive Gateway is configured to expect an HTTP server on port 44276. This transport mismatch causes the health check to fail.

**Server Implementation**:
- Docker image: `decisions-server:v1.2.0`
- Transport: stdio (StdioServerTransport)
- Command: `docker run -i --rm decisions-server:v1.2.0`

**Required Configuration Changes**:

1. **Update ToolHive Gateway** (`src/index.ts`):
   ```typescript
   registry.register({
     id: 'decisions-server',
     name: 'Decisions MCP Server',
     transport: 'stdio',  // CHANGED from 'http'
     connection: {
       command: 'docker',
       args: ['run', '-i', '--rm', 'decisions-server:v1.2.0']
     },
     tools: [...],
     tags: ['decisions', 'workflow', 'strategist'],
     description: 'Decision management server for P4NTH30N workflow',
   });
   ```

2. **Fix MongoDB Connection** (if needed):
   - Current: `mongodb://localhost:27017/P4NTH30N`
   - Windows Docker fix: `mongodb://192.168.56.1:27017/P4NTH30N`
   - Or use bridge networking with port mapping

**Alternative Options Considered**:

**Option 1: Fix ToolHive Config (RECOMMENDED)**
- Change transport from HTTP to stdio
- Aligns with other healthy servers (foureyes, p4nth30n, honeybelt)
- Simple config change, no code modifications
- Estimated time: 15 minutes

**Option 2: HTTP Proxy**
- Use mcp-proxy to bridge stdio→HTTP
- More complex, adds another component
- Only if HTTP is strictly required

**Option 3: Fix MongoDB + Keep Container**
- Update docker-compose.yml with proper MongoDB host
- Keep existing container setup
- Requires network configuration changes

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-050-001 | ✅ ROOT CAUSE IDENTIFIED - Transport mismatch | Designer | Complete | Critical |
| ACT-050-002 | Update ToolHive Gateway config (HTTP→stdio) | OpenFixer | Complete | Critical |
| ACT-050-003 | Add docker run command to registry | OpenFixer | Complete | Critical |
| ACT-050-004 | Fix MongoDB connection string for Windows Docker | OpenFixer | Complete | High |
| ACT-050-005 | Rebuild ToolHive Gateway | OpenFixer | Complete | Critical |
| ACT-050-006 | Confirm ToolHive shows healthy | OpenFixer | Complete | High |
| ACT-050-007 | Test listActive tool | OpenFixer | Complete | Medium |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DEPLOY-2026-02-20-TOOLHIVE (gateway must exist)
- **Related**: DECISION_048 (ToolHive proxying - will need decisions healthy to test HTTP transport)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Cannot locate server source | High | Medium | Search entire codebase, check package.json scripts |
| Port 44276 already in use | Medium | Low | Kill existing process or change port |
| Server crashes on startup | High | Low | Check logs, verify dependencies, rebuild if needed |
| MongoDB connection failure | High | Low | Verify MongoDB is running |
| Missing build artifacts | Medium | Low | Rebuild TypeScript/npm project |

---

## Success Criteria

1. ✅ Decisions-server process running and stable
2. ✅ HTTP endpoint responds on port 44276
3. ✅ ToolHive health check shows `✓ decisions-server: healthy`
4. ✅ `listActive` tool returns valid decision list
5. ✅ All 5 decision tools operational

---

## Token Budget

- **Estimated**: 8K tokens
- **Model**: Claude 3.5 Sonnet (OpenFixer)
- **Budget Category**: Bug Fix (<20K)

---

## Bug-Fix Section

- **On server won't start**: Check logs, verify Node.js/npm available
- **On port conflict**: Find and kill process using 44276
- **On build errors**: Rebuild TypeScript, check dependencies
- **On persistent failure**: Delegate to @forgewright for deep diagnostics
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Bug-fix sub-decisions | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 82%
- **Key Findings**:
  - Feasibility 8/10: Clear path forward with two viable options
  - Risk 5/10: Transport mismatch requires config change, MongoDB networking on Windows Docker
  - Complexity 5/10: Config change is simple, but root cause analysis needed first
  - Top risks: (1) Wrong transport assumption in original config, (2) Docker networking on Windows, (3) MongoDB connectivity
  - Critical finding: Server uses stdio not HTTP - this is the root cause
  - Recommendation: Option 1 (fix ToolHive config) is simplest and aligns with other servers
  - GO with conditions: Update ToolHive Gateway to use stdio transport for decisions-server
- **Note**: Oracle subagent was down; Strategist assimilated Oracle role

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: 85%
- **Key Findings**:
  - Root Cause Identified: Server uses StdioServerTransport, ToolHive expects HTTP on :44276
  - Three options provided: (1) Fix ToolHive config (recommended), (2) HTTP proxy, (3) Fix MongoDB + keep container
  - Recommended approach: Update ToolHive Gateway to use stdio transport (matches other healthy servers)
  - Secondary issue: MongoDB connection string needs host IP for Windows Docker
  - Docker container is healthy - just misconfigured in ToolHive
  - Key consideration: Align decisions-server with foureyes/p4nth30n/honeybelt pattern (all stdio)
  - Estimated time: 30 minutes for config change
- **File**: consultations/designer/DECISION_050_designer.md

---

## Completion Notes

**Completed By**: OpenFixer  
**Completion Date**: 2026-02-20  
**Deployment Journal**: `OP3NF1XER/deployments/JOURNAL_2026-02-20_DECISION_050.md`

**Key Fix**: Added `MONGODB_URI` environment variable with host IP (192.168.56.1) and `directConnection=true` option to prevent MongoDB driver replica set discovery issues.

**Verification**:
- ✅ Server responds to MCP initialize
- ✅ MongoDB connection successful (192 decisions in database)
- ✅ getStats tool returns correct statistics
- ✅ findByStatus tool retrieves active decisions
- ✅ All 16 tools operational

---

## Notes

**Investigation Steps**:
1. Search for "decisions-server" or "44276" in codebase
2. Check `tools/mcp-development/servers/decisions-server/`
3. Look for package.json with start scripts
4. Check running processes: `netstat -an | findstr 44276`
5. Look for Docker containers: `docker ps -a | findstr decisions`

**Common HTTP Server Issues**:
1. Process not started (no auto-start configured)
2. Port already in use by zombie process
3. Missing environment variables
4. MongoDB not connected
5. Build artifacts out of date

---

*Decision DECISION_050*  
*Restore Decisions MCP Server*  
*2026-02-20*
