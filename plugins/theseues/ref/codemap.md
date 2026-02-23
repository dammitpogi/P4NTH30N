# Reference Repositories Index

This directory contains GitHub repository clones used for reference, research, and development of the oh-my-opencode-theseus plugin.

## Repository Overview

| Repository | Purpose | Codemap |
|------------|---------|---------|
| `oh-my-opencode-dev/` | Main oh-my-opencode repository with full features | [View Map](oh-my-opencode-dev/codemap.md) |
| `oh-my-opencode-theseus-master/` | Slimmed-down fork for lightweight operation | [View Map](oh-my-opencode-theseus-master/codemap.md) |
| `opencode-dev/` | OpenCode core application | [View Map](opencode-dev/codemap.md) |

## Repository Details

### oh-my-opencode-dev

**Purpose**: Full-featured agent orchestration plugin for OpenCode with complete feature set.

**Key Features**:
- Multi-agent orchestration with 6 specialized agents
- Background task management with tmux integration
- MCP (Model Context Protocol) integration
- LSP (Language Server Protocol) tools
- Code search (grep, AST-grep)
- Comprehensive hooks system
- CLI installer with interactive TUI

**Source Directories**:
- `src/agents/` - Agent definitions and factories
- `src/background/` - Background task management
- `src/cli/` - CLI installer
- `src/config/` - Configuration system
- `src/hooks/` - Lifecycle hooks
- `src/mcp/` - MCP configurations
- `src/plugin/` - Plugin core
- `src/shared/` - Shared utilities
- `src/tools/` - Tool implementations

**Status**: 901 TypeScript files mapped

---

### oh-my-opencode-theseus-master

**Purpose**: Lightweight agent orchestration plugin - a evolved fork optimized for performance and simplicity.

**Key Features**:
- 6 specialized agents (Orchestrator, Explorer, Librarian, Oracle, Designer, Fixer)
- Background task management with model fallback
- Built-in MCPs (websearch, context7, grep.app)
- Code search tools (grep, AST-grep, LSP)
- Auto-update checking
- Configuration presets

**Source Directories**:
- `src/agents/` - Agent definitions
- `src/background/` - Background task management
- `src/cli/` - CLI installer
- `src/config/` - Configuration schemas
- `src/hooks/` - Hook implementations
- `src/mcp/` - MCP registry
- `src/tools/` - Tool implementations
- `src/utils/` - Shared utilities
- `src/skills/` - Bundled skills (cartography, toolhive)

**Status**: 83 TypeScript files mapped

**Codemap Quality**:
- ✅ Comprehensive: agents, background, cli, config, tools
- ✅ Enhanced: hooks, mcp, utils
- ✅ Complete root codemap

---

### opencode-dev

**Purpose**: Main OpenCode application - AI-powered coding assistant combining AI agents with development tools.

**Key Features**:
- AI agent system with orchestration
- LSP integration for code intelligence
- GitHub integration (Actions, issues, PRs)
- Plugin system with skills
- Session-based persistent context
- Desktop and web applications

**Main Packages**:
- `packages/app/` - Main application
- `packages/opencode/` - Core runtime
- `packages/sdk/` - Plugin SDK
- `packages/plugin/` - Plugin system
- `packages/ui/` - Shared UI components
- `github/` - GitHub Actions
- `infra/` - Infrastructure (SST)
- `sdks/vscode/` - VS Code extension

**Status**: 1 file mapped (initial setup)

---

## Usage Guidelines

### Finding Code Patterns

1. **Grep Search**: Use grep in any repository
   ```bash
   grep -r "pattern" ref/oh-my-opencode-dev/src/
   ```

2. **Codemap Navigation**: Browse codemaps for architectural understanding
   - Start with root codemap for repository overview
   - Navigate to specific directories for detailed maps

3. **Reference Comparison**: Compare implementations across repositories
   - oh-my-opencode-dev → full implementation
   - oh-my-opencode-theseus-master → simplified version

### Key Differences

| Feature | oh-my-opencode-dev | oh-my-opencode-theseus |
|---------|-------------------|---------------------|
| Agent Count | 6+ specialized | 6 (Orchestrator + 5 subagents) |
| Background Tasks | Full tmux integration | Model fallback, compaction |
| Hooks | Many specialized hooks | Core hooks only |
| MCPs | Configurable | 3 built-in |
| Size | Larger | ~90% smaller |

### Extension Points

#### Adding to oh-my-opencode-theseus
1. Define agent in `src/agents/`
2. Add factory to `src/agents/index.ts`
3. Configure defaults in `src/config/constants.ts`
4. Register hooks in `src/index.ts`

#### Creating New Skills
1. Create skill directory in `src/skills/`
2. Add SKILL.md with metadata
3. Implement skill functionality
4. Register in plugin system

---

## Cartography State

| Repository | Files Mapped | Last Updated |
|------------|--------------|--------------|
| oh-my-opencode-dev | 901 | 2026-02-13 |
| oh-my-opencode-theseus-master | 83 | 2026-02-13 |
| opencode-dev | 1 | 2026-02-13 |

---

## Quick Reference

### File Locations

**Configuration**:
- Plugin config: `~/.config/opencode/oh-my-opencode-theseus.json`
- OpenCode config: `~/.config/opencode/opencode.json`

**Agent Prompts**:
- `~/.config/opencode/agents/`

**Skills**:
- `~/.config/opencode/skills/`

**Logs**:
- `~/AppData/Local/Temp/oh-my-opencode-theseus.log` (Windows)
- `/tmp/oh-my-opencode-theseus.log` (Unix)
