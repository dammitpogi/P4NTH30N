# DECISION_039: Tool Migration to MCP Server via ToolHive

**Decision ID**: MIGRATE-004  
**Category**: INFRA  
**Status**: Partially Implemented (Gateway Only)  
**Priority**: Critical  
**Date**: 2026-02-20  
**Oracle Approval**: 94% (Strategist Assimilated)  
**Designer Approval**: 91% (Strategist Assimilated)

---

## Executive Summary

Migrate existing tools from the legacy `~/.config/opencode/tools/` directory structure to MCP Server architecture via ToolHive. This migration reduces context window pollution, standardizes tool exposure, and enables better configuration management across environments.

**Current Problem**:
- Tools are scattered in `~/.config/opencode/tools/` with inconsistent structure
- Tool configurations directly in config folder lengthen context windows
- No standardized way to expose tools to agents
- WindSurf lacks unified knowledge of tool configurations across environments
- ToolHive MCP server exists but tools are not properly migrated to it

**Proposed Solution**:
- Migrate all tools to MCP Server structure under `mcp-development/servers/`
- Expose tools via ToolHive to prevent context window pollution
- Standardize tool schemas and configurations
- Enable WindSurf to manage configs across environments
- Update agent knowledge base with ToolHive tool exposure patterns

---

## Background

### Current State

**Legacy Tool Structure**:
```
~/.config/opencode/tools/
├── tool-development/
│   ├── tools/
│   │   ├── honeybelt-cli/     # Standalone CLI tool
│   │   └── mongodb-tool/      # MongoDB operations
├── mcp-development/servers/
│   ├── decisions-server/      # MCP server (partial)
│   └── mongodb-server/        # MCP server (partial)
└── [various docs and configs]
```

**Problems**:
1. Tools are in `tools/` but should be in `mcp-development/servers/`
2. Tool configurations mixed with runtime configs
3. Agents don't know about ToolHive tool exposure
4. No unified config management across dev/prod environments

### Desired State

**MCP Server Structure**:
```
~/.config/opencode/tools/
└── mcp-development/servers/
    ├── mongodb-server/        # ✅ Already exists
    ├── decisions-server/      # ✅ Already exists
    ├── honeybelt-server/      # 🔄 Migrate from honeybelt-cli
    ├── toolhive-gateway/      # 🔄 New: ToolHive integration layer
    └── [future tools as MCP servers]
```

**ToolHive Integration**:
- Tools exposed via ToolHive MCP protocol
- Context window stays clean (tools externalized)
- Standardized tool discovery via `toolhive-mcp-optimizer`
- Configurations managed per-environment

---

## Specification

### Requirements

#### MIGRATE-004-001: Tool Inventory and Assessment
**Priority**: Must  
**Acceptance Criteria**:
- Inventory all tools in `tool-development/tools/`
- Assess each tool's readiness for MCP migration
- Document dependencies and external services
- Identify tools that can be consolidated
- Catalog configuration requirements per environment

#### MIGRATE-004-002: MCP Server Migration
**Priority**: Must  
**Acceptance Criteria**:
- Migrate `honeybelt-cli` to `mcp-development/servers/honeybelt-server/`
- Implement MCP protocol wrapper for each tool
- Standardize tool schemas (input/output)
- Add health check endpoints
- Ensure backward compatibility during transition

#### MIGRATE-004-003: ToolHive Integration
**Priority**: Must  
**Acceptance Criteria**:
- Create `toolhive-gateway` MCP server
- Register all migrated tools with ToolHive
- Implement tool discovery via `toolhive-mcp-optimizer`
- Ensure tools are discoverable by agents
- Document ToolHive tool exposure patterns

#### MIGRATE-004-004: Agent Knowledge Update
**Priority**: Must  
**Acceptance Criteria**:
- Update all agent prompts with ToolHive knowledge
- Document how to discover and call ToolHive tools
- Provide examples of tool usage patterns
- Ensure agents know NOT to push tools directly to config
- Add ToolHive skill to agent capabilities

#### MIGRATE-004-005: Configuration Management
**Priority**: Should  
**Acceptance Criteria**:
- Separate tool configs from runtime configs
- Environment-specific configuration support
- WindSurf can update configs across environments
- Config validation before deployment
- Rollback capability for config changes

#### MIGRATE-004-006: Documentation and Training
**Priority**: Should  
**Acceptance Criteria**:
- Document new MCP server architecture
- Create migration guide for future tools
- Update AGENTS.md with ToolHive patterns
- Provide troubleshooting guide
- Train agents on new tool discovery workflow

### Technical Details

**Migration Architecture**:
```
┌─────────────────────────────────────────────────────────────────┐
│                    TOOLHIVE MCP GATEWAY                          │
└─────────────────────────────────────────────────────────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          ▼                   ▼                   ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  mongodb-server │  │ honeybelt-server│  │ decisions-server│
│  (existing)     │  │  (migrated)     │  │  (existing)     │
├─────────────────┤  ├─────────────────┤  ├─────────────────┤
│ • Query         │  │ • Honeybelt CLI │  │ • Decision CRUD │
│ • Insert        │  │ • Operations    │  │ • Validation    │
│ • Update        │  │ • Reporting     │  │ • Queries       │
│ • Delete        │  │                 │  │                 │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

**ToolHive Discovery Pattern**:
```typescript
// How agents discover and use ToolHive tools

// Step 1: Find the tool
const searchResults = await toolhive.find_tool({
  tool_description: "search the web for information",
  tool_keywords: "web search google"
});

// Step 2: Call the tool
const results = await toolhive.call_tool({
  server_name: "web-search-server",
  tool_name: "search",
  parameters: { query: "your search query here" }
});
```

**Configuration Structure**:
```json
{
  "mcpServers": {
    "mongodb-server": {
      "command": "node",
      "args": ["tools/mcp-development/servers/mongodb-server/dist/index.js"],
      "env": {
        "MONGODB_URI": "${MONGODB_URI}"
      }
    },
    "honeybelt-server": {
      "command": "node",
      "args": ["tools/mcp-development/servers/honeybelt-server/dist/index.js"],
      "env": {
        "HONEYBELT_API_KEY": "${HONEYBELT_API_KEY}"
      }
    }
  }
}
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-039-001 | Inventory all existing tools | OpenFixer | Pending | Critical |
| ACT-039-002 | Assess migration readiness per tool | OpenFixer | Pending | Critical |
| ACT-039-003 | Create toolhive-gateway MCP server | OpenFixer | Pending | Critical |
| ACT-039-004 | Migrate honeybelt-cli to honeybelt-server | OpenFixer | Pending | Critical |
| ACT-039-005 | Register migrated tools with ToolHive | OpenFixer | Pending | Critical |
| ACT-039-006 | Update agent prompts with ToolHive knowledge | OpenFixer | Pending | Critical |
| ACT-039-007 | Create environment-specific configs | OpenFixer | Pending | High |
| ACT-039-008 | Implement config validation | OpenFixer | Pending | High |
| ACT-039-009 | Document migration guide | OpenFixer | Pending | Medium |
| ACT-039-010 | Test tool discovery from agents | OpenFixer | Pending | Critical |
| ACT-039-011 | Update AGENTS.md with ToolHive patterns | OpenFixer | Pending | High |
| ACT-039-012 | Train agents on new workflow | OpenFixer | Pending | Medium |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: DECISION_038 (agent capabilities), all tool-dependent decisions

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Tool breakage during migration | High | Medium | Maintain backward compatibility, test thoroughly |
| Agents can't find migrated tools | High | Low | Update agent knowledge, provide discovery examples |
| Configs lost or corrupted | Medium | Low | Backup configs, version control, rollback plan |
| ToolHive unavailable | Medium | Low | Fallback to direct MCP server calls |
| Migration takes too long | Low | Medium | Prioritize critical tools, migrate incrementally |

---

## Success Criteria

1. **All tools migrated**: 100% of tools in `mcp-development/servers/`
2. **ToolHive integration**: Tools discoverable via `toolhive-mcp-optimizer`
3. **Agent knowledge**: All agents know ToolHive tool exposure patterns
4. **Config management**: WindSurf can update configs across environments
5. **Context reduction**: Context windows reduced by 30%+ from tool externalization
6. **Zero downtime**: No service interruption during migration

---

## Consultation Log

### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 94%
- **Key Findings**:
  - Feasibility Score: 9/10 - Clear migration path, existing MCP infrastructure
  - Risk Score: 3/10 - Well-understood patterns, rollback capability
  - Complexity Score: 6/10 - Multiple tools, but standardized approach
  - Top Risks: (1) Tool breakage, (2) Agent confusion, (3) Config migration
  - Critical Success Factor: Backward compatibility during transition
  - Recommendation: Migrate incrementally, one tool at a time
  - ToolHive Knowledge: Essential for agents to understand external tool exposure
- **File**: consultations/oracle/DECISION_039_oracle.md

### Designer Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 91%
- **Key Findings**:
  - Implementation Strategy: 4-phase migration
  - Phase 1: Inventory and assessment
  - Phase 2: Create toolhive-gateway
  - Phase 3: Migrate tools incrementally
  - Phase 4: Update agents and document
  - Files to Create: toolhive-gateway, honeybelt-server, config schemas
  - Files to Modify: agent prompts, AGENTS.md, mcp config
  - Architecture: MCP servers → ToolHive gateway → Agents
  - Config Management: Environment-specific JSON configs
  - Agent Update: All agents need ToolHive skill documentation
- **File**: consultations/designer/DECISION_039_designer.md

---

## Notes

**Tool Inventory** (from `~/.config/opencode/tools/`):
- `honeybelt-cli/` - CLI tool for honeybelt operations
- `mongodb-tool/` - MongoDB operations (may consolidate with mongodb-server)
- `mcp-development/servers/mongodb-server/` - Existing MCP server
- `mcp-development/servers/decisions-server/` - Existing MCP server

**Migration Order**:
1. honeybelt-cli → honeybelt-server (standalone tool)
2. mongodb-tool → consolidate into mongodb-server (if different)
3. Create toolhive-gateway for unified access
4. Update all agents

**Config Environments**:
- Development: `~/.config/opencode/dev/`
- Production: `~/.config/opencode/prod/`
- WindSurf manages both via standardized config interface

---

*Decision MIGRATE-004*  
*Tool Migration to MCP Server via ToolHive*  
*2026-02-20*
