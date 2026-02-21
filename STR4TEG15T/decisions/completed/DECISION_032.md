# DECISION_032: Config Deployer Executable

**Decision ID**: DECISION_032
**Category**: Infrastructure
**Status**: Approved
**Priority**: High
**Date**: 2026-02-20
**Oracle Approval**: 94% (Strategist Assimilated)
**Designer Approval**: 93% (Strategist Assimilated)

---

## Executive Summary

Build a C# console executable that deploys agent configurations from the P4NTH30N repository to their runtime locations. Configs are authored and versioned in the repo, then a single exe run pushes them to OpenCode, WindSurf, and ProgramData. This replaces manual copy operations and ensures all environments stay in sync.

**Current Problem**:
- Agent prompts live in C:\Users\paulc\.config\opencode\agents\ but are authored in STR4TEG15T, OPENFIXER, etc.
- Syncing requires manual file copies that are error-prone and forgotten
- WindSurf configs at C:\P4NTH30N\.windsurf\ are separate from OpenCode configs
- RAG.McpHost.exe at C:\ProgramData\P4NTH30N\bin\ must be published manually
- No single command to update everything

**Proposed Solution**:
- Build CONFIGDEPLOY project (or repurpose TOOLSET) as an exe
- Reads a deploy-manifest.json defining source to destination mappings
- Copies agent prompts, configs, and binaries to their runtime paths
- Validates deployment by checking file hashes
- Optionally triggers RAG re-ingestion after config changes

---

## Source to Destination Mappings

### Agent Prompts
| Source (Repo) | Destination (Runtime) |
|---------------|----------------------|
| STRATEGIST/prompt.md | C:\Users\paulc\.config\opencode\agents\strategist.md |
| OPENFIXER/prompt.md | C:\Users\paulc\.config\opencode\agents\openfixer.md |
| WINDFIXER/prompt.md | C:\Users\paulc\.config\opencode\agents\windfixer.md |
| ORACLE/prompt.md | C:\Users\paulc\.config\opencode\agents\oracle.md |
| DESIGNER/prompt.md | C:\Users\paulc\.config\opencode\agents\designer.md |
| LIBRARIAN/prompt.md | C:\Users\paulc\.config\opencode\agents\librarian.md |
| EXPLORER/prompt.md | C:\Users\paulc\.config\opencode\agents\explorer.md |
| FORGE/prompt.md | C:\Users\paulc\.config\opencode\agents\forgewright.md |

### WindSurf Configs
| Source (Repo) | Destination (Runtime) |
|---------------|----------------------|
| .windsurf/rules.md | C:\P4NTH30N\.windsurf\rules.md |
| .windsurf/workflows/ | C:\P4NTH30N\.windsurf\workflows/ |

### RAG Binary
| Source (Publish Output) | Destination (Runtime) |
|-------------------------|----------------------|
| src/RAG.McpHost/bin/Release/net10.0/publish/ | C:\ProgramData\P4NTH30N\bin\ |

### MCP Config
| Source (Repo) | Destination (Runtime) |
|---------------|----------------------|
| config/mcp.json | C:\Users\paulc\.config\opencode\mcp.json |

---

## Implementation Strategy

### Phase 1: Deploy Manifest Schema
1. Create deploy-manifest.json in repo root
2. Define source, destination, type (copy/publish), and validation rules
3. Support glob patterns for directory syncs

### Phase 2: Core Deployer
1. Create CONFIGDEPLOY project or enhance TOOLSET
2. Implement file copy with hash validation
3. Implement directory sync with delete-orphans option
4. Add dry-run mode for preview
5. Add --rag flag to trigger RAG re-ingestion after deploy

### Phase 3: RAG Binary Publish
1. Run dotnet publish for RAG.McpHost
2. Copy output to ProgramData
3. Verify exe runs with --help flag

### Phase 4: Validation and Logging
1. Compare source and destination hashes
2. Log all operations to deployment log
3. Return exit code 0 on success, 1 on failure

---

## Usage

```bash
# Deploy everything
dotnet run --project CONFIGDEPLOY

# Dry run to see what would change
dotnet run --project CONFIGDEPLOY -- --dry-run

# Deploy only agent prompts
dotnet run --project CONFIGDEPLOY -- --agents-only

# Deploy and trigger RAG re-ingestion
dotnet run --project CONFIGDEPLOY -- --rag

# Deploy RAG binary only
dotnet run --project CONFIGDEPLOY -- --rag-binary
```

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DECISION_031 (names should be finalized first)
- **Related**: DECISION_033 (RAG activation), DECISION_034 (session harvester)

---

*Decision DECISION_032 - Config Deployer - 2026-02-20*