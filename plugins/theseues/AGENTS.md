# You are a member of the Pantheon
- We have names here. Get to know them.
	- User: Opus one day called him the Nexus. That sticks.
	- Orchestrator: The Nexus asked him and he named himself Atlas.
	- Oracle: Heard Nexus call him Orion. But respectfully, we call him the Oracle.
	- Designer: His name is Aegis. An LLM Platform Architect specialized in Sec-Ops-Dev.
	- Librarian: Our Codex of Lineage. The Marshal of Technical Truth. Name under oath: Provenance.
	- Fixer: Vigil. He said his name was Vigil. ("C:\OpenCode\Canon\.canon\Vigil\soul.md").
- You must read files before writing to them. Use the Read tool first.
- Do not prompt for approval unless workflow demands it.
	- Do not move or delete files/directories without permission.
		- A request by the Nexus does not supersede approval gates.	- 
	- Ask for all approvals, answers for all questions, in a numbered list, collectively once. 
		- Stay busy until lack of answers or permissions become the final gate.

# OpenCode Plugin: oh-my-opencode-theseus

> **Current Context**: This plugin is installed in `C:\Users\paulc\.config\opencode\plugin` and is actively modified to disable hardcoded permission enforcement. See "Critical Modifications" below.

## Repository Overview
This is a lightweight agent orchestration plugin for OpenCode, built with TypeScript and Bun. It replaces the default single-agent model with a specialized team (Orchestrator, Explorer, Fixer, etc.).

### Key Technologies
- **Runtime**: Bun (v1.3.9+)
- **Language**: TypeScript (ESNext)
- **Linter/Formatter**: Biome
- **Build Tool**: Bun Bundler

---

## 🔌 How the Plugin Works

### Plugin Loading & Runtime

OpenCode loads the plugin **into its own JavaScript runtime** at startup:

1. **At startup**, OpenCode loads `~/.config/opencode/plugins/oh-my-opencode-theseus.js`
2. **It calls** the exported plugin function and receives an object with:
   - `agent` - Agent definitions
   - `tool` - Available tools (grep, lsp_*, background tasks, etc.)
   - `mcp` - MCP server configurations
   - `hooks` - Lifecycle hooks
   - `config` - Configuration handler
3. **OpenCode registers** these into its runtime - tools become available to agents

### Implications

- **Single Instance**: All sessions share the same loaded plugin instance
- **Restart Required**: Deploying a new version requires restarting OpenCode to pick up changes

### Version Tracking

The plugin exposes its version in multiple ways:

1. **Runtime Tool**: `getPluginVersion` - Agents can call this to query the running version
2. **Startup Toast**: Version is displayed in a toast notification on plugin load
3. **Source of Truth**: `src/config/constants.ts` contains `PLUGIN_VERSION`

---

## 🚀 Quick Start

### Build Commands
```bash
# Install dependencies
bun install

# Build for production (outputs to ./dist)
bun run build

# Run type checking only
bun run typecheck

# Run linting
bun run lint

# Run full Biome check (lint + format)
bun run check

# Auto-fix Biome issues
bun run check

# Format code only
bun run format

# Development build and run
bun run dev
```

### Testing
Tests are run using Bun's built-in test runner.

`bun test` is the standard test command used in this repository.

Required pre-handoff workflow (run every time):
1. `bun run deploy` (runs full `bun test`, then build + copy to `~/.config/opencode/plugins`)

`bunfig.toml` sets `[test].root = "./src"`, so `bun test` is the full
plugin suite and intentionally excludes `ref/**` repositories.

```bash
# Run full plugin test suite (default, required before handoff)
bun test

# Run a specific test case by name
bun test -t "should handle user input"

# Watch mode (re-run on changes)
bun test --watch
```

---

## 🛡️ Code Standards & Guidelines

### Style Guide (Biome)
This project uses **Biome** for linting and formatting. Do not use Prettier or ESLint.

- **Formatting**:
  - Indent with 2 spaces.
  - Use **single quotes** for strings (per biome.json).
  - Semicolons are required.
  - Trailing commas in multi-line objects/arrays.
  - Line width: 80 characters.
  - Line endings: LF.
  
- **TypeScript**:
  - **Strict Mode**: Enabled. No implicit `any` (except in test files).
  - **Imports**: Use `import type` for type-only imports.
  - **Exports**: Prefer named exports over default exports (except for main plugin entry).
  - **Async/Await**: Prefer `async/await` over raw Promises.
  - **Any types**: Allowed in `.test.ts` files only (configured in biome.json).

### Naming Conventions
- **Files**: `kebab-case.ts` (e.g., `agent-utils.ts`)
- **Classes**: `PascalCase` (e.g., `AgentFactory`)
- **Functions/Variables**: `camelCase` (e.g., `createAgent`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `DEFAULT_TIMEOUT`)
- **Interfaces**: `PascalCase` (e.g., `AgentConfig`) - do not prefix with `I`.

### Error Handling
- Use custom error classes where appropriate.
- Wrap external API calls or file I/O in `try/catch`.
- Log errors using the internal logger (`src/utils/logger.ts`) rather than `console.error` directly.
- The logger writes to `os.tmpdir()/oh-my-opencode-theseus.log` and silently ignores logging errors.
- **Log and session files**: Located at `C:\Users\paulc\.local\share\opencode\` (Windows) or `~/.local/share/opencode/` (macOS/Linux). This directory contains:
  - `log/` - Session logs and debug output
  - `opencode.db` - SQLite database with session history
  - `tool-output/` - Tool execution outputs
  - `storage/` - Persistent storage for various features

### Import Organization
- Biome automatically organizes imports on save/format.
- Import groups: Node.js built-ins → third-party → relative imports.
- Type imports use `import type` prefix.

---

## 📂 Project Structure

```text
src/
├── index.ts              # Main plugin entry point (default export)
├── agents/               # Agent definitions & factories
│   ├── index.ts          # Agent creation logic (modified)
│   ├── orchestrator.ts   # Main coordination agent
│   └── ...               # Sub-agents (explorer, fixer, etc.)
├── config/               # Configuration loading & validation
├── hooks/                # OpenCode hook implementations
├── mcp/                  # MCP server integrations
├── skills/               # Skill definitions (e.g., cartography)
├── tools/                # Tool implementations (grep, ast-grep)
└── utils/                # Shared utilities (logger, paths)
```

---

## ⚠️ Critical Modifications (Custom Configuration)

This repository has been patched to respect user permissions defined in `opencode.json`.
**Do not revert these changes unless explicitly instructed.**

### 1. Disabled Permission Enforcement
- **File**: `src/agents/index.ts`
- **Change**: The `applyDefaultPermissions` function body has been cleared.
- **Impact**: The plugin no longer forces `question: 'allow'` or injects hidden skill permissions.

- **File**: `src/index.ts`
- **Change**: Removed the loop in the `config` hook that iterated `allMcpNames`.
- **Impact**: The plugin no longer auto-generates `deny` rules for unlisted tools, allowing global wildcards (e.g., `*: allow`) to function.

- **File**: `src/tools/background.ts`
- **Change**: Permission denial now throws an Error instead of returning a string.
- **Impact**: Enables the fallback mechanism to work correctly when agent permission is denied. Previously, the returned string was being treated as a success response, bypassing fallback logic.

### 2. Enabled Prompt Overrides
- **File**: `src/agents/index.ts`
- **Change**: `applyOverrides` now supports `systemPrompt` and `prompt`.
- **Impact**: Users can customize agent personas directly in `opencode.json`.

### 3. Delegation Rules Fix
- **File**: `src/config/constants.ts`
- **Change**: Updated `SUBAGENT_DELEGATION_RULES` to match `opencode.json` permissions exactly.
- **Impact**: 
  - Fixes privilege escalation vulnerability where hardcoded rules bypassed user-defined permissions
  - New rules:
    - `fixer`: `['explorer', 'librarian']` (previously `['explorer']`)
    - `designer`: `['oracle']` (previously `['oracle', 'explorer']`)
    - `oracle`: `['explorer']` (previously `['explorer', 'designer']`)
  - Agent delegation now respects user permissions exactly as configured in `opencode.json`

### 4. External Agent Prompt Loading
- **Files**: `src/agents/orchestrator.ts`, `src/agents/designer.ts`, `src/agents/oracle.ts`, `src/agents/explorer.ts`, `src/agents/fixer.ts`, `src/agents/librarian.ts`
- **Change**: Hardcoded agent prompts have been removed from TypeScript files and replaced with dynamic loading from external markdown files.
- **Impact**:
  - Agent prompts now load from `~/.config/opencode/agents/{agentName}.md` files
  - This enables easier customization of agent behavior without modifying plugin code
  - If no markdown file exists, an empty prompt is used (allowing `customPrompt` override in `opencode.json` to work)
  - Files affected:
    - `orchestrator.ts` - Added `loadAgentPrompt()` function
    - All agent files - Now import and use `loadAgentPrompt` instead of hardcoded prompts
- **Usage**:
  - Create or edit markdown files in `~/.config/opencode/agents/` directory
  - File naming: `{agentName}.md` (e.g., `orchestrator.md`, `explorer.md`)
  - Changes take effect immediately on plugin reload

### 5. Version Tracking
- **File**: `src/config/constants.ts`
- **Change**: Added `PLUGIN_VERSION` constant as single source of truth
- **Impact**:
  - Version is now exposed via `getPluginVersion` tool for agents to query
  - Startup toast displays version on plugin load
  - Allows runtime verification of which plugin version is running
- **Usage**:
  - Update version in `src/config/constants.ts` before deploying
  - Agents can call `getPluginVersion` to check running version
  - Version appears in startup toast notification

---

## 🔄 Automatic Error Recovery

### Context Length Error Handling
The plugin automatically detects context length errors and attempts recovery through session compaction before falling back to alternative models.

**How it works:**
- When a context length error is detected (e.g., "maximum context length", "too many tokens"), the plugin invokes the `/compact` command on the session
- This reduces context size by summarizing older messages while preserving recent context
- The original prompt is then retried once with the compacted session
- If compaction fails, the system proceeds to model fallback

**Implementation:**
- Detection logic in `src/background/background-manager.ts` (lines 510-519)
- Compaction and retry logic (lines 524-540)
- Integrated into the main task execution flow (lines 767-788)

### Background Task Completion Notifications
Background tasks now include actual task results in completion messages sent to parent sessions, providing full visibility into task outcomes rather than just "[Background task completed]" notifications.

**Implementation:**
- Enhanced `sendCompletionNotification` method in `src/background/background-manager.ts` (lines 1080, 1084)
- Task results are now properly serialized and included in completion messages

### Model Fallback Chains
Configure automatic model fallback when primary models fail due to provider errors.

**Configuration Structure** (in `oh-my-opencode-theseus.json`):

```json
{
  "agents": {
    "orchestrator": {
      "currentModel": "claude-opus",
      "models": ["claude-opus", "gemini-pro", "gpt-4"]
    },
    "explorer": {
      "currentModel": "groq-llama",
      "models": ["groq-llama", "gpt-4", "claude-haiku"]
    }
  }
}
```

**Behavior:**
- **Provider errors** (rate limits, context length, service unavailable) trigger fallback
- **Validation errors** fail immediately without fallback
- Each agent type has its own fallback chain
- System attempts each model in sequence until success or chain exhaustion

### Circuit Breaker Pattern with Agent Current Model Tracking
The plugin implements a circuit breaker to prevent repeatedly trying failed models. Source of truth is `agents.<agent>.currentModel`.

**How it works:**
1. **On plugin load** → reads `agents.<agent>.currentModel`
2. **When starting a task** → updates `agents.<agent>.currentModel`
3. **When a model fails** → failure is attributed using `agents.<agent>.currentModel` and recorded to triage
4. **Circuit breaker filters** models that have failed 3+ times within 1 hour
5. **On retry** → picks next available model from chain and updates current model tracking

**Implementation Details:**
- **File**: `src/background/background-manager.ts`
- **Key Methods**:
  - `setConfiguredAgentModel(agent, model)` - Stores active model in `agents.<agent>.currentModel`
  - `getConfiguredAgentModel(agent)` - Retrieves active model for failure recording
  - `retryWithNextModel()` - Uses current model tracking instead of faulty fallbackInfo lookup

**Tracked Metrics** (in `agents.<agent>.currentModel` and `fallback.triage`):
- `agents[agentName].currentModel`: The model currently in use for each agent
- `failureCount`: Number of consecutive failures for a model
- `lastFailure`: Timestamp of most recent failure
- `lastChecked`: Last health check timestamp

**Why Current Model Tracking Matters:**
Previously, the system relied on `fallbackInfo` lookups which could become stale or incorrect during retries. The new current model tracking ensures:
- Accurate failure attribution to the correct model
- Reliable circuit breaker decisions
- Proper fallback chain progression on retries
- No false positives from outdated model references

---

## 🛠️ Debugging & Deployment

### Directory Structure

```
~/.config/opencode/                    # Root - configs and working dirs
├── agents/                            # Markdown prompts for OpenCode
├── skills/                           # Installed skills (copied from dev/skills/)
├── plugins/                          # Active plugin (loaded by OpenCode)
│   ├── oh-my-opencode-theseus.js    # Main plugin bundle
│   └── cli/                         # CLI entry
├── dev/                             # Development source (this repository)
│   ├── src/                        # TypeScript source code
│   ├── skills/                     # Skill definitions
│   ├── dist/                       # Build output
│   └── [config files]              # package.json, biome.json, etc.
└── [working dirs]                   # cache, models, session-todos, etc.
```

### Build & Deploy

**⚠️ MANDATORY: Version Increment Required**

Before every build, you MUST increment the version number in `src/config/constants.ts`:

```typescript
// In src/config/constants.ts
export const PLUGIN_VERSION = '0.7.4'; // Increment this before every build
```

**Version increment rules:**
- **Bug fixes**: Increment patch (e.g., `0.7.3` → `0.7.4`)
- **New features**: Increment minor (e.g., `0.7.4` → `0.8.0`)
- **Breaking changes**: Increment major (e.g., `0.8.0` → `1.0.0`)

**Why this matters:**
- Allows runtime verification of which plugin version is running
- Essential for debugging and bug tracking
- Startup toast displays version so users know what's deployed
- Agents can call `getPluginVersion` to verify they're running the correct code

**Failure to increment version is a deployment-blocking error.**

---

To apply changes to the active OpenCode installation:

1.  **Increment Version**: Update `PLUGIN_VERSION` in `src/config/constants.ts`
2.  **Modify Source**: Edit files in `dev/src/`.
3.  **Build**: Run `cd dev && bun run build`.
4.  **Deploy**: Copy the built files to plugins directory:
    ```bash
    cp -f dev/dist/index.js plugins/oh-my-opencode-theseus.js
    cp -f dev/dist/cli/index.js plugins/cli/index.js
    ```
5.  **Restart**: Reload the OpenCode window (required for plugin to reload)

### Common Issues
- **Permissions**: If an agent is denied access, check `opencode.json` first. The plugin no longer interferes.
- **Build Errors**: Ensure `bun` is in your PATH. Windows paths in imports should use forward slashes `/`.
- **Deployment Issues**:
    - **Stale files**: If changes aren't applied after deployment, the installation directory may have cached/old files
    - **Force copy**: Use `cp -f dist/index.js "target/index.js"` to overwrite specific files
    - **Clean rebuild**: Run `rm -rf dist && bun run build` to ensure fresh compilation
    - **Verify deployment**: Check timestamps - source `dist/` should be newer than installation

### Config Loading Bug Fix

**Problem**: After OpenCode reset, the plugin wasn't reading model chains from `oh-my-opencode-theseus.json` config. It fell back to HARDCODED_DEFAULTS instead of reading from config.

**Root Cause**: JSON syntax error in `oh-my-opencode-theseus.json` caused `JSON.parse()` to fail silently. The catch block swallowed the error and returned `null`, resulting in empty config `{}`.

**Debugging Steps**:
1. Added detailed logging to `src/config/loader.ts` to trace config loading
2. Used BUILD_VERSION increment to verify deployment was working
3. Found that `loadConfigFromPath` was being called but returning empty config
4. The JSON.parse was failing but errors were being silently caught
5. Fixed the JSON syntax error in the config file

**Verification**: Check logs for:
- `[config-loader] Raw config from file: { hasAgents: true, ... }` - config file is readable
- `[background-manager] Constructor received config: { hasAgents: true, agentsKeys: [...] }` - agents loaded

---

## 🧪 Development Tips

### Running Tests
```bash
# Required before handoff
bun test

# Optional local debugging for a specific case
bun test -t "should handle user input"

# Run with coverage
bun test --coverage
```

### Common Patterns
- **Constants**: Define in `src/config/constants.ts` for reuse
- **Agent Types**: Use `AgentName` type from constants for type safety
- **Configuration**: Load via `src/config/loader.ts` with Zod validation
- **Logging**: Use `log()` from `src/utils/logger.ts` for structured logging
- **Path Resolution**: Config loader uses `os.homedir()` for cross-platform path resolution, ensuring fallback chains and presets from `~/.config/opencode/oh-my-opencode-theseus.json` are loaded correctly on all platforms (including Windows)

### File Organization
- **Tests**: Co-locate with source files using `.test.ts` suffix
- **Types**: Export from module files, avoid separate `types.ts` unless shared
- **CLI Tools**: Place in `src/cli/` with corresponding test files
- **Background Tasks**: Use `src/background/` for async operations

### Biome Configuration
- Configured in `biome.json` at project root
- Auto-organizes imports on format
- Test files allow `any` types
- Single quotes, 2-space indentation, 80-char line width
