# opencode/

## Responsibility

This is the user's main OpenCode configuration hub - it provides a sophisticated multi-agent AI coding environment through the `oh-my-opencode-theseus` plugin. The directory contains:

- **Agent orchestration system** - 6 specialized AI agents (orchestrator, oracle, designer, explorer, librarian, fixer) with distinct roles and permissions
- **Configuration management** - Centralized settings for OpenCode core (`opencode.json`) and plugin behavior (`oh-my-opencode-theseus.json`)
- **Custom skill framework** - Extensible capabilities (cartography, toolhive, model-tester) that enhance agent functionality
- **Plugin development** - Complete TypeScript source code for the multi-agent orchestration plugin
- **Model management** - Comprehensive model research and per-agent model assignments with fallback chains
- **Documentation** - User guides (AGENTS.md), troubleshooting, and agent-specific help files. AGENTS.md documents error handling practices and log directory locations (`~/.local/share/opencode/`)

## Design

### Multi-Agent Architecture

| Agent | Role | Can Spawn |
|-------|------|-----------|
| orchestrator | Primary coordinator | all subagents |
| oracle | Advisory/risk validation | designer, explorer |
| designer | Planning/architecture | oracle, explorer |
| explorer | Discovery/research | (leaf node) |
| librarian | Documentation/research | (leaf node) |
| fixer | Implementation | explorer |

### Plugin System
- TypeScript-based plugin (`oh-my-opencode-theseus`) that integrates with OpenCode
- Central configuration: `oh-my-opencode-theseus.json` manages agent models, MCP servers, skills
- Agent model fallback chains provide resilience and cost optimization
- Dynamic model selection via `src/cli/dynamic-model-selection.ts`
- Background manager (`src/background/background-manager.ts`) handles agent lifecycle

### Configuration-as-Code
- `opencode.json` - Main OpenCode settings (providers, plugins, MCP servers, permissions)
- `oh-my-opencode-theseus.json` - Plugin-specific: agent model assignments, disabled MCPs, idle orchestrator
- Preset files (recommended, openai, antigravity) for different provider configurations
- YAML frontmatter in agent `.md` files defines prompts and permissions

### Skill Framework
- Skills are autonomous modules in `skills/` directories with `SKILL.md` spec
- Built-in skills: cartography (repo mapping), toolhive (MCP optimization), model-tester
- Cartography maintenance is librarian-authored (directory codemaps + root atlas), driven by `skills/cartography/scripts/cartographer.py`
- Skills registered in plugin config and loaded dynamically
- Skills provide specialized tools and workflows

### Provider Abstraction
- Providers are configured in `opencode.json` under the top-level `provider` object (custom providers) alongside OpenCode's built-in provider support.
- This config currently defines:
  - `free` (OpenRouter via `@ai-sdk/openai-compatible`)
  - `lmstudio-local` (local OpenAI-compatible endpoint via `@ai-sdk/openai-compatible`)
  - `artificial-analysis` (Artificial Analysis API via `@ai-sdk/openai-compatible`)
  - `google-ai-studio` (Google AI Studio / Gemini API via `@ai-sdk/google`)
- Models are enumerated under each provider's `models` map with human-readable names; model selection uses `provider_id/model_id` (e.g. `google/gemini-2.5-pro`).

## Flow

### Configuration Loading
1. OpenCode reads `opencode.json` on startup → loads plugin, providers, MCP servers
2. `oh-my-opencode-theseus` plugin initializes → loads agent configs and model assignments
3. Agent prompts loaded from `agents/*.md` files with YAML frontmatter
4. Skills discovered and initialized from `skills/` directories
5. MCP servers connected based on configuration

### Request Processing
1. User submits task → OpenCode routes to orchestrator (primary mode)
2. Orchestrator analyzes task → delegates to appropriate subagents via `task` tool
3. Subagents execute with their assigned models and permissions
4. Explorer performs discovery/grep/ast searches as leaf node
5. Fixer implements code changes; librarian documents results
6. Oracle validates; designer plans architecture
7. Results synthesized and returned through orchestrator

### Model Selection
1. Agent requested → primary model attempted first
2. On failure/timeout → fallback chain traversed automatically
3. Fallback triage tracked (`oh-my-opencode-theseus.json` → `fallback.triage`)
4. Dynamic model selection adapts based on availability and performance

### Plugin Build & Deploy
1. Source in `plugin/src/` → TypeScript compiled to `plugin/dist/`
2. Build command: `bun run build` in plugin directory
3. Deploy built plugin to `~/.cache/opencode/node_modules/oh-my-opencode-theseus/`
4. Changes require OpenCode restart for core config, agent restart for prompt changes

## Integration

### OpenCode Integration
- Declared as plugin in `opencode.json` → `plugin` array
- Registers custom agent modes and background services
- Hooks into OpenCode's agent lifecycle via `src/hooks/`
- Provides LSP tools (grep, ast-grep, LSP client) as agent capabilities
- Task delegation system extends OpenCode's inter-agent communication

### MCP (Model Context Protocol)
- ToolHive MCP Optimizer (`toolhive-mcp-optimizer`) configured at `localhost:22368/mcp`
- Agents access MCP servers based on `mcps` config (wildcard `*` or specific)
- ToolHive wrapper used for all external tool access (search, scrape, docs)
- MCP server status tracked in plugin's MCP module (`src/mcp/`)

### External Providers
- OpenRouter Free provider configured as `free/openrouter/free`.
- Google AI Studio provider configured as `google/<gemini-model-id>` (Gemini 3 preview + Gemini 2.5 family, plus deprecated Gemini 2.0 entries).
- API keys are stored in `opencode.json` provider options (not in `oh-my-opencode-theseus.json`).

### Filesystem Integration
- Agents read/write files based on permissions in `opencode.json` → `permission`
- External directory access: `external_directory: "allow"`
- Web fetching: `webfetch: "deny"` (policy)
- Bash/edit permissions: `"ask"` or `"allow"` per agent

### Skills Integration
- Skills extend agent toolset with domain-specific capabilities
- Cartography skill provides repository mapping and code analysis
- ToolHive skill optimizes MCP tool discovery and usage
- Skills can delegate to Explorer for fan-out operations

## Directory Map

| Directory | Purpose | Detailed Map |
|-----------|---------|--------------|
| `agents/` | Agent prompt definitions | [codemap.md](agents/codemap.md) |
| `skills/` | Custom skills | [codemap.md](skills/codemap.md) |
| `models/` | Model research data | [codemap.md](models/codemap.md) |
| `plugin/` | Plugin source code | [codemap.md](plugin/codemap.md) |
| `scripts/` | Utility scripts | [codemap.md](scripts/codemap.md) |
| `runconfigs/` | Run configuration templates | [codemap.md](runconfigs/codemap.md) |

## Key Code Paths

- `plugin/src/agents/` - Agent implementations (orchestrator, explorer, oracle, librarian, designer, fixer)
- `plugin/src/tools/` - Agent tools (grep, ast-grep, LSP)
- `plugin/src/cli/` - Configuration loading, model selection, skill management
- `plugin/src/config/` - Schema validation, loader, agent-MCP mappings
- `plugin/src/mcp/` - MCP server connection and management
- `plugin/src/background/` - Background task execution with fallback chains
- `plugin/src/hooks/` - OpenCode lifecycle hooks (idle-orchestrator, phase-reminder, etc.)
