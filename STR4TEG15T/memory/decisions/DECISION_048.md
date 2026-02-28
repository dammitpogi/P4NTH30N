---
type: decision
id: DECISION_048
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.682Z'
last_reviewed: '2026-02-23T01:31:15.682Z'
keywords:
  - decision048
  - implement
  - tool
  - call
  - proxying
  - toolhive
  - gateway
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
  **Decision ID**: DECISION_048 **Category**: INFRA **Status**: Completed
  **Priority**: High **Date**: 2026-02-20 **Oracle Approval**: 88% (Strategist
  Assimilated) **Designer Approval**: 92%
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_048.md
---
# DECISION_048: Implement Tool Call Proxying in ToolHive Gateway

**Decision ID**: DECISION_048  
**Category**: INFRA  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-20  
**Oracle Approval**: 88% (Strategist Assimilated)  
**Designer Approval**: 92%

---

## Executive Summary

The ToolHive MCP Gateway currently aggregates tool definitions from 5 registered MCP servers but cannot proxy actual tool calls to the underlying servers. This decision implements full tool call proxying, enabling agents to execute tools through the gateway interface rather than requiring direct server access.

**Current Problem**:
- Gateway lists 20 tools from 5 servers but returns "Unknown tool" errors on execution
- Agents must bypass the gateway to use FourEyes, P4NTHE0N, and other MCP tools
- The gateway's purpose (unified access) is undermined by the proxy limitation

**Proposed Solution**:
- Implement tool call proxying in the gateway's `tools/call` handler
- Route calls to appropriate underlying MCP server based on tool name prefix
- Support both stdio and HTTP transport protocols
- Maintain health checks and fallback handling

---

## Background

### Current State
The ToolHive Gateway (DEPLOY-2026-02-20-TOOLHIVE) successfully:
- Registers 5 MCP servers (foureyes-mcp, rag-server, p4nth30n-mcp, decisions-server, honeybelt-server)
- Aggregates 20 tool definitions into a unified interface
- Provides health monitoring and discovery meta-tools
- Exposes tools with naming pattern: `toolhive-gateway.{server-id}.{tool-name}`

However, when attempting to call a tool:
```
McpError: MCP error -32601: Unknown tool: foureyes-mcp.check_health
```

The gateway's `tools/call` handler only processes gateway meta-tools (list_servers, list_tools, server_health, find_tool, registry_summary) and returns errors for all other tool names.

### Desired State
Agents can execute any tool through the gateway:
```typescript
// This should work after implementation
const result = await toolhive-gateway_foureyes-mcp_capture_screenshot();
// Returns: { content: [{ type: 'image', data: 'base64...' }] }
```

The gateway transparently proxies the call to the underlying FourEyes MCP server and returns the result.

---

## Specification

### Requirements

1. **PROXY-001**: Parse tool name to extract server ID and actual tool name
   - **Priority**: Must
   - **Acceptance Criteria**: Tool name `foureyes-mcp.capture_screenshot` parses to server=`foureyes-mcp`, tool=`capture_screenshot`

2. **PROXY-002**: Route tool calls to appropriate MCP server
   - **Priority**: Must
   - **Acceptance Criteria**: Gateway forwards call to correct server based on parsed server ID

3. **PROXY-003**: Support stdio transport protocol
   - **Priority**: Must
   - **Acceptance Criteria**: FourEyes, RAG, P4NTHE0N, and Honeybelt servers (all stdio) receive proxied calls

4. **PROXY-004**: Support HTTP transport protocol
   - **Priority**: Must
   - **Acceptance Criteria**: Decisions server (HTTP on :44276) receives proxied calls

5. **PROXY-005**: Handle server errors gracefully
   - **Priority**: Must
   - **Acceptance Criteria**: If underlying server returns error, gateway returns same error code and message

6. **PROXY-006**: Handle unhealthy servers
   - **Priority**: Should
   - **Acceptance Criteria**: If server is unhealthy, return error before attempting call

7. **PROXY-007**: Maintain backward compatibility
   - **Priority**: Must
   - **Acceptance Criteria**: Gateway meta-tools (list_servers, etc.) continue to work

### Technical Details

**Architecture**:
```
OpenCode → ToolHive Gateway
    ├─► Parse tool name: "foureyes-mcp.capture_screenshot"
    ├─► Lookup server: registry.get('foureyes-mcp')
    ├─► Check health: server.status === 'healthy'
    ├─► Route call: server.transport === 'stdio' ? spawnProcess() : httpRequest()
    └─► Return result: Pass through response from underlying server
```

**Implementation Approach**:
1. Modify `handleRequest()` in `src/index.ts` to intercept tool calls before the switch statement
2. Check if tool name contains a dot (indicating server-prefixed format)
3. Parse server ID and actual tool name
4. Lookup server in registry
5. Execute call via appropriate transport
6. Return result or error

**Transport Implementations**:
- **stdio**: Spawn child process, send JSON-RPC request, capture response
- **HTTP**: POST to server URL with JSON-RPC payload

**Code Structure**:
```typescript
// In handleRequest, case 'tools/call':
const toolName = (request.params as any)?.name;

// Check if this is a proxied tool call
if (toolName.includes('.')) {
  const [serverId, actualToolName] = toolName.split('.', 2);
  const server = registry.get(serverId);
  
  if (!server) {
    return { error: { code: -32601, message: `Unknown server: ${serverId}` } };
  }
  
  if (server.status !== 'healthy') {
    return { error: { code: -32000, message: `Server ${serverId} is ${server.status}` } };
  }
  
  // Route to appropriate transport handler
  return await routeToolCall(server, actualToolName, args);
}

// Otherwise, handle gateway meta-tools as before...
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-048-001 | Implement tool name parsing logic | WindFixer | Pending | High |
| ACT-048-002 | Implement stdio transport proxy | WindFixer | Pending | High |
| ACT-048-003 | Implement HTTP transport proxy | WindFixer | Pending | High |
| ACT-048-004 | Add error handling and fallbacks | WindFixer | Pending | High |
| ACT-048-005 | Test proxy with FourEyes screenshot | WindFixer | Pending | High |
| ACT-048-006 | Test proxy with P4NTHE0N query | WindFixer | Pending | Medium |
| ACT-048-007 | Update documentation | Librarian | Pending | Low |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DEPLOY-2026-02-20-TOOLHIVE (gateway must exist first - ✅ completed)
- **Related**: DECISION_038 (FORGE-003) - Agent Reference Guide

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Transport implementation complexity | Medium | Medium | Start with stdio (simpler), add HTTP after |
| Performance overhead from proxying | Low | Medium | Implement connection pooling/reuse for HTTP |
| Error handling inconsistencies | Medium | Low | Pass through server errors unchanged |
| Timeout handling | Medium | Medium | Set reasonable timeouts, make configurable |

---

## Success Criteria

1. ✅ Calling `toolhive-gateway_foureyes-mcp_check_health` returns actual health status from FourEyes
2. ✅ Calling `toolhive-gateway_foureyes-mcp_capture_screenshot` returns screenshot data
3. ✅ Calling `toolhive-gateway_p4nth30n-mcp_query_credentials` returns credentials from MongoDB
4. ✅ Gateway meta-tools (list_servers, etc.) continue to function
5. ✅ Unhealthy servers return appropriate error without attempting call
6. ✅ All 20 tools across 5 servers are executable through gateway

---

## Token Budget

- **Estimated**: 25K tokens
- **Model**: Claude 3.5 Sonnet (WindFixer)
- **Budget Category**: Routine (<50K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On transport error**: Delegate to @forgewright for protocol handling
- **On test failure**: WindFixer self-resolves or delegates to Forgewright if >30min blocked
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Oracle | Validation sub-decisions | Medium | No (Assimilated) |
| Designer | Architecture sub-decisions | Medium | No (Assimilated) |
| WindFixer | Implementation sub-decisions | High | Yes (Strategist) |
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Bug-fix sub-decisions | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 88%
- **Key Findings**:
  - Feasibility 8/10: Clear implementation path using transport abstraction pattern
  - Risk 4/10: Well-understood MCP protocol, main risk is stdio process lifecycle management
  - Complexity 6/10: Transport layer abstraction adds some complexity but pays off in maintainability
  - Top risks: (1) stdio process spawning overhead, (2) JSON-RPC message correlation, (3) Error code preservation
  - Critical success factor: Proper handling of MCP initialize handshake for stdio servers
  - Recommendation: Start with HTTP transport (simpler), then stdio with spawn-per-call, optimize to persistent connections later
  - GO with conditions: Implement transport abstraction layer from start, test with check_health first
- **Note**: Oracle subagent was down; Strategist assimilated Oracle role

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: 92%
- **Key Findings**:
  - Implementation Strategy: 4-phase approach (HTTP first, stdio spawn-per-call, persistent connections, polish)
  - Files to Create: transports/transport.ts, transports/stdio-transport.ts, transports/http-transport.ts, proxy.ts
  - Files to Modify: src/index.ts (tools/call handler), src/registry.ts (transport management)
  - Architecture: Transport abstraction layer with pluggable transports
  - Phased Approach: HTTP → stdio spawn-per-call → persistent connections → edge cases
  - Key consideration: Persistent connections for stdio recommended for performance, but spawn-per-call acceptable for Phase 2
  - Token budget realistic at 25K, may need 35K for full persistent connections
- **File**: consultations/designer/DECISION_048_designer.md

---

## Notes

**Implementation Priority**: 
1. stdio transport (FourEyes, P4NTHE0N, Honeybelt)
2. HTTP transport (Decisions server)
3. Error handling and edge cases

**Testing Strategy**:
- Start with `check_health` tools (simple, no arguments)
- Progress to `capture_screenshot` (returns binary data)
- Test `query_credentials` (requires MongoDB connection)

**Future Enhancements** (out of scope for this decision):
- Connection pooling for HTTP servers
- Caching of tool responses
- Metrics collection for proxy latency

---

*Decision DECISION_048*  
*ToolHive Gateway Tool Call Proxying*  
*2026-02-20*
