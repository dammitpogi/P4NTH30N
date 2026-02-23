# Config Module Codemap

## Responsibility

The `src/config/` module is responsible for:

1. **Configuration Management**: Loading, validating, and merging plugin configuration from multiple sources (user config, project config, environment variables)
2. **Schema Validation**: Providing type-safe configuration using Zod schemas
3. **Agent Configuration**: Managing agent-specific overrides, models, skills, and MCP (Model Context Protocol) assignments
4. **Prompt Customization**: Loading custom agent prompts from user directories
5. **Constants Management**: Centralizing agent names, default models, polling intervals, and timeouts

## Design

### Key Patterns

**Multi-Source Configuration Merging**
- User config: `~/.config/opencode/oh-my-opencode-theseus.json` (or `$XDG_CONFIG_HOME`)
- Project config: `<directory>/.opencode/oh-my-opencode-theseus.json`
- Environment override: `OH_MY_OPENCODE_SLIM_PRESET`
- Project config takes precedence over user config
- Nested objects (agents, tmux) are deep-merged; arrays are replaced
- **Automatic Default Population**: Missing `currentModel` values are automatically populated from `DEFAULT_MODELS` on load, ensuring consistency and persistence.

**Preset System**
- Named presets contain agent configurations
- Presets are merged with root-level agent config (root overrides)
- Supports preset selection via config file or environment variable

**Wildcard/Exclusion Syntax**
- Skills and MCPs support `"*"` (all) and `"!item"` (exclude) syntax
- Used in `parseList()` function for flexible filtering

**Backward Compatibility**
- Agent aliases map legacy names to current names (e.g., `explore` → `explorer`)
- `getAgentOverride()` checks both current name and aliases

### Core Abstractions

**Configuration Schema Hierarchy**
```
PluginConfig
├── preset?: string
├── presets?: Record<string, Preset>
├── agents?: Record<string, AgentOverrideConfig>
├── disabled_mcps?: string[]
├── tmux?: TmuxConfig
└── background?: BackgroundTaskConfig

AgentOverrideConfig
├── model?: string
├── temperature?: number
├── variant?: string
├── skills?: string[]
└── mcps?: string[]

TmuxConfig
├── enabled: boolean
├── layout: TmuxLayout
└── main_pane_size: number
```

**Agent Names**
- `ORCHESTRATOR_NAME`: `'orchestrator'`
- `SUBAGENT_NAMES`: `['explorer', 'librarian', 'oracle', 'designer', 'fixer']`
- `ALL_AGENT_NAMES`: All agents combined
- `AGENT_ALIASES`: Legacy name mappings

### Interfaces

**TypeScript Types**
- `PluginConfig`: Main configuration object
- `AgentOverrideConfig`: Per-agent configuration overrides
- `TmuxConfig`: Tmux integration settings
- `TmuxLayout`: Layout enum (`main-horizontal`, `main-vertical`, `tiled`, `even-horizontal`, `even-vertical`)
- `Preset`: Named agent configuration presets
- `AgentName`: Union type of all agent names
- `McpName`: Union type of available MCPs
- `BackgroundTaskConfig`: Background task concurrency settings

**Exported Functions**
- `loadPluginConfig(directory: string): PluginConfig` - Load and merge all configs
- `getAgentOverride(config, name): AgentOverrideConfig | undefined` - Get agent config with alias support
- `parseList(items, allAvailable): string[]` - Parse wildcard/exclusion lists
- `getAvailableMcpNames(config?): string[]` - Get enabled MCPs
- `getAgentMcpList(agentName, config?): string[]` - Get MCPs for specific agent

## Flow

### Configuration Loading Flow

```
loadPluginConfig(directory)
│
├─→ Load user config from ~/.config/opencode/oh-my-opencode-theseus.json
│   └─→ Validate with PluginConfigSchema
│       └─→ Return null if invalid/missing
│
├─→ Load project config from <directory>/.opencode/oh-my-opencode-theseus.json
│   └─→ Validate with PluginConfigSchema
│       └─→ Return null if invalid/missing
│
├─→ Deep merge configs (project overrides user)
│   ├─→ Top-level: project replaces user
│   └─→ Nested (agents, tmux): deep merge
│
├─→ Apply environment preset override (OH_MY_OPENCODE_SLIM_PRESET)
│
└─→ Resolve and merge preset
    ├─→ Find preset in config.presets[preset]
    ├─→ Deep merge preset agents with root agents
    └─→ Warn if preset not found
```

### Constants Usage

**Polling Configuration**
- `POLL_INTERVAL_MS` (500ms): Standard polling interval
- `POLL_INTERVAL_SLOW_MS` (1000ms): Slower polling for background tasks
- `POLL_INTERVAL_BACKGROUND_MS` (2000ms): Background task polling

**Timeouts**
- `DEFAULT_TIMEOUT_MS` (2 minutes): Default operation timeout
- `MAX_POLL_TIME_MS` (5 minutes): Maximum polling duration

**Stability**
- `STABLE_POLLS_THRESHOLD` (3): Number of stable polls before considering state settled

### Default MCP Assignments

| Agent      | Default MCPs                          |
|------------|---------------------------------------|
| orchestrator | `[]`                                  |
| designer    | `[]`                                  |
| oracle      | `[]`                                  |
| explorer    | `[]`                                  |
| librarian   | `[]`                                  |
| explorer    | `[]`                                  |
| fixer       | `[]`                                  |

### Default Models

| Agent      | Model                          |
|------------|--------------------------------|
| orchestrator | `openrouter-free/openrouter/free` |
| oracle      | `openrouter-free/openrouter/free` |
| librarian   | `openrouter-free/openrouter/free` |
| explorer    | `openrouter-free/openrouter/free` |
| designer    | `openrouter-free/openrouter/free` |
| fixer       | `openrouter-free/openrouter/free` |

## File Organization

```
src/config/
├── index.ts          # Public API exports
├── loader.ts         # Config loading and merging logic
├── schema.ts         # Zod schemas and TypeScript types
├── constants.ts      # Agent names, defaults, timeouts
├── utils.ts          # Helper functions (agent overrides)
└── agent-mcps.ts     # MCP configuration and resolution
```

## Error Handling

**Configuration Loading**
- Missing config files: Returns empty config (expected behavior)
- Invalid JSON: Logs warning, returns null
- Schema validation failure: Logs detailed error, returns null
- File read errors (non-ENOENT): Logs warning, returns null

**Prompt Loading**
- Missing prompt files: Returns empty object (expected behavior)
- File read errors: Logs warning, continues

**Preset Resolution**
- Invalid preset name: Logs warning with available presets, continues without preset

## Extension Points

**Adding New Agents**
1. Add to `SUBAGENT_NAMES` in `constants.ts`
2. Add default model to `DEFAULT_MODELS`
3. Add default MCPs to `DEFAULT_AGENT_MCPS` in `agent-mcps.ts`

**Adding New MCPs**
1. Add to `McpNameSchema` enum in `schema.ts`
2. Update `DEFAULT_AGENT_MCPS` as needed

**Adding New Configuration Options**
1. Add to `PluginConfigSchema` in `schema.ts`
2. Update deep merge logic in `loader.ts` if nested
3. Document in user-facing config documentation