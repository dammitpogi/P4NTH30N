# Tool Output: tool_c6a4b5a64001Y3vG4XxFEig9aA
**Date**: 2026-02-17 06:30:49 UTC
**Size**: 159,213 bytes

```

C:\Users\paulc\.config\opencode\dev\src\utils\agent-variant.test.ts:
  2: import type { PluginConfig } from '../config';
  7: } from './agent-variant';
  110:     expect(result).toBe(body); // Same reference
  117:     expect(result).toBe(body); // Same reference
  125:     expect(result).not.toBe(body); // New object

C:\Users\paulc\.config\opencode\dev\src\index.ts:
  1: // TEST COMMENT - VERSION 4
  2: import type { Plugin, PluginInput } from '@opencode-ai/plugin';
  3: import { type ToolDefinition, tool } from '@opencode-ai/plugin/tool';
  4: import { getAgentConfigs } from './agents';
  5: import { BackgroundTaskManager, TmuxSessionManager } from './background';
  6: import { loadPluginConfig, PLUGIN_VERSION, type TmuxConfig } from './config';
  10:   // createChangelogCartographyHook, // Disabled - auto-injection too slow
  16: } from './hooks';
  17: import { createBuiltinMcps } from './mcp';
  27: } from './tools';
  28: import { startTmuxCheck } from './utils';
  29: import { log } from './utils/logger';
  32:   // Use process.cwd() to get user's working directory, not plugin directory
  45:   // Show version toast on startup
  59:   // Check if config is missing and show warning
  63:     // Log to file (not console)
  66:     // Show toast notification
  84:   // Log loaded agents for verification
  86:   // Parse tmux config with defaults
  99:   // Start background tmux check if enabled
  113:   // Initialize TmuxSessionManager to handle OpenCode's built-in Task tool sessions
  116:   // Initialize auto-update checker hook
  122:   // Initialize phase reminder hook for workflow compliance
  125:   // Initialize post-read nudge hook
  128:   // Initialize directory codemap injector hook
  135:   // Initialize idle orchestrator hook - keeps Orchestrator busy for background task auto-flush
  141:   // Cartography auto-injection disabled - too slow
  142:   // const changelogCartographyHook = createChangelogCartographyHook(
  143:   //   ctx,
  144:   //   backgroundManager,
  145:   // );
  147:   // Track session todos and prompt for productive follow-up after delegation.
  150:   // Version query tool - available to agents
  180:       // Show config warning after a delay to ensure TUI is ready
  201:       // Merge Agent configs
  222:       // Merge MCP configs
  242:       // For each agent, create permission rules based on their mcps list
  247:         // Get or create agent permission config
  260:         // Update agent config with permissions
  266:       // Handle server.connected - show warning immediately when server is ready
  271:           // Show toast notification (user will see this)
  289:       // Check for missing config on first session creation
  297:         // Show config missing toast for main session only
  305:                     'Config not found at ~/.config/opencode/oh-my-opencode-theseus.json. Run: bunx oh-my-opencode-theseus install',
  315:       // Handle auto-update checking
  318:       // Handle idle orchestrator - proactive prompts to keep Orchestrator busy
  321:       // Cartography auto-injection disabled
  322:       // await changelogCartographyHook.event(input as any);
  324:       // Handle codemap injector lifecycle cache cleanup
  327:       // Handle tmux pane spawning for OpenCode's Task tool sessions
  337:       // Handle session.status events for:
  338:       // 1. BackgroundTaskManager: completion detection
  339:       // 2. TmuxSessionManager: pane cleanup
  355:       // Cartography auto-injection disabled
  356:       // await changelogCartographyHook['tool.execute.before']?.(
  357:       //   input as { tool: string; sessionID: string; callID: string },
  358:       //   output as { args: any },
  359:       // );
  366:     // Chain message transforms: add phase reminder
  373:     // Inject codemap summaries and then nudge after file reads
  393:       // Cartography auto-injection disabled
  394:       // if (callID) {
  395:       //   await changelogCartographyHook['tool.execute.after']?.(
  396:       //     input as { tool: string; sessionID: string; callID: string },
  397:       //     output as { title: string; output: string; metadata: any },
  398:       //   );
  399:       // }
  417: } from './config';
  418: export type { RemoteMcpConfig } from './mcp';
  419: // PLUGIN_VERSION is defined in ./config/constants but not exported to avoid OpenCode treating it as a callable export

C:\Users\paulc\.config\opencode\dev\src\skills\codemap.md:
  1: # src/skills/
  5: Holds skill assets that ship with the plugin repository (markdown skill definitions and any bundled helper scripts). These files are intended to be copied/installed into an OpenCode skills directory so the Orchestrator can follow deterministic workflows (for example: cartography).
  12:   - `scripts/`: optional helpers executed via the Orchestrator (e.g., `cartographer.py`).
  13: - Skill content is documentation/data; it is not part of the plugin runtime TypeScript execution path.
  24: - This repository bundles a cartography skill under `src/skills/cartography/`.

C:\Users\paulc\.config\opencode\dev\src\utils\debug.ts:
  1: export * from "./debug/logger";

C:\Users\paulc\.config\opencode\dev\src\utils\codemap.md:
  1: # src/utils/
  11: Each helper lives in its own module and re-exports through `src/utils/index.ts`, keeping public surface area flat. Key ideas include memoized state (cached TMUX path, server availability cache, stored layouts), configuration defaults fed from `../config` constants, defensive guards (abort checks, empty-string variants), and layered platform detection (Windows build/tar, PowerShell fallbacks). Logging is best-effort: synchronous file append inside a try/catch so it never throws upstream.
  15: Agent variant helpers normalize names, read `PluginConfig.agents`, trim/validate variants, and only mutate request bodies when a variant is missing; `log` simply timestamps and appends strings to a temp file. `pollUntilStable` loops with configurable intervals, fetch callbacks, and stability guards, honoring max time and abort signals before returning a typed `PollResult`. TMUX helpers scan for the binary (`which/where`), cache the result, verify layouts, spawn panes with `opencode attach`, reapply stored layouts on close, and guard against missing servers by checking `/health`. `extractZip` detects the OS (tar on modern Windows, pwsh/powershell fallback) before spawning native unpack commands and bubbling errors when processes fail.
  19: Imported wherever safe, reusable utilities are needed: agent variant helpers are used by CLI commands that build request payloads, polling is shared by logic that waits for stable responses, TMUX orchestration ties into session management to open/close panes, `log` is consumed across modules for diagnostics, and `extractZip` supports tooling that unpacks bundles. The folder’s re-exports let features import everything from `src/utils`, which keeps higher-level modules free of implementation detail changes here.

C:\Users\paulc\.config\opencode\dev\src\utils\logger.ts:
  13:     // Silently ignore logging errors

C:\Users\paulc\.config\opencode\dev\src\utils\agent-variant.ts:
  1: import type { PluginConfig } from '../config';
  2: import { log } from './logger';
  4: /**
  11:  * normalizeAgentName("@oracle") // returns "oracle"
  12:  * normalizeAgentName("  explore  ") // returns "explore"
  13:  */
  19: /**
  33:  * resolveAgentVariant(config, "@oracle") // returns "high" if configured
  34:  */
  55: /**
  67:  * applyAgentVariant("high", { agent: "oracle" }) // returns { agent: "oracle", variant: "high" }
  68:  * applyAgentVariant("high", { agent: "oracle", variant: "low" }) // returns original body with variant: "low"
  69:  */

C:\Users\paulc\.config\opencode\dev\src\utils\index.ts:
  1: export * from './agent-variant';
  2: export { log } from './logger';
  3: export * from './polling';
  4: export * from './tmux';
  5: export { extractZip } from './zip-extractor';

C:\Users\paulc\.config\opencode\dev\src\utils\zip-extractor.ts:
  27:   return path.replace(/'/g, "''");

C:\Users\paulc\.config\opencode\dev\src\utils\logger.test.ts:
  5: import { log } from './logger';
  11:     // Clean up log file before each test
  18:     // Clean up log file after each test
  36:     // Check for ISO timestamp format [YYYY-MM-DDTHH:MM:SS.sssZ]
  37:     expect(content).toMatch(/\[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z\]/);
  54:     // Should not have extra JSON at the end
  55:     expect(content.trim()).toMatch(/message without data\s*$/);
  100:       /\[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z\]\s+\n/,
  105:     // Make the log directory read-only to force a write error
  106:     // This test is platform-dependent and might not work on all systems
  107:     // So we'll just verify that log() doesn't throw
  117:     // JSON.stringify will throw on circular references
  118:     // The logger should handle this gracefully (catch block)

C:\Users\paulc\.config\opencode\dev\src\utils\polling.ts:
  5: } from '../config';
  21: /**
  23:  * Returns when the condition is satisfied or timeout/abort occurs.
  24:  */
  62: /**
  64:  */

C:\Users\paulc\.config\opencode\dev\src\utils\tmux.ts:
  2: import type { TmuxConfig, TmuxLayout } from '../config/schema';
  3: import { log } from './logger';
  8: // Store config for reapplying layout on close
  11: // Cache server availability check
  15: /**
  18:  */
  20:   // Use cached result if checking the same URL
  25:   const healthUrl = new URL('/health', serverUrl).toString();
  59: /**
  61:  */
  67: /**
  69:  */
  93:     // Verify it works
  112: /**
  114:  */
  126: /**
  128:  */
  133: /**
  135:  */
  142:     // Apply the layout
  149:     // For main-* layouts, set the main pane size
  163:       // Reapply layout to use the new size
  179:   paneId?: string; // e.g., "%42"
  182: /**
  187:  */
  211:   // Check if the OpenCode HTTP server is actually running
  212:   // This is needed because serverUrl may be a fallback even when no server is running
  229:   // Store config for use in closeTmuxPane
  233:     // Use `opencode attach <url> --session <id>` to connect to the existing server
  234:     // This ensures the TUI receives streaming updates from the same server handling the prompt
  237:     // Simple split - layout will handle positioning
  238:     // Use -h for horizontal split (new pane to the right) as default
  242:       '-d', // Don't switch focus to new pane
  243:       '-P', // Print pane info
  245:       '#{pane_id}', // Format: just the pane ID
  259:     const paneId = stdout.trim(); // e.g., "%42"
  268:       // Rename the pane for visibility
  275:       // Apply layout to auto-rebalance all panes
  294: /**
  296:  */
  325:       // Reapply layout to rebalance remaining panes
  336:     // Pane might already be closed (user closed it manually, or process exited)
  347: /**
  349:  */

C:\Users\paulc\.config\opencode\dev\src\utils\tmux.test.ts:
  2: import { resetServerCheck } from './tmux';
  23:   // Note: Testing getTmuxPath, spawnTmuxPane, and closeTmuxPane requires:
  24:   // 1. Mocking Bun's spawn function
  25:   // 2. Mocking file system operations
  26:   // 3. Running in a tmux environment
  27:   // 4. Mocking HTTP fetch for server checks
  28:   //
  29:   // These are better suited for integration tests rather than unit tests.
  30:   // The current tests cover the simple, pure functions that don't require mocking.

C:\Users\paulc\.config\opencode\dev\src\utils\polling.test.ts:
  2: import { delay, pollUntilStable } from './polling';
  30:     const isStable = () => false; // Never stable
  34:       maxPollTime: 50, // Very short timeout
  46:       // Abort after first call
  81:       stableThreshold: 3, // Require 3 stable polls
  85:     expect(callCount).toBeGreaterThanOrEqual(5); // At least 2 changing + 3 stable
  90:     const values = ['a', 'a', 'b', 'b', 'b', 'b']; // Unstable, then stable
  153:       // Check if data is actually stable (same as previous)
  174:     // Allow some tolerance for timing

C:\Users\paulc\.config\opencode\dev\src\config\utils.ts:
  1: import { AGENT_ALIASES } from './constants';
  2: import type { AgentOverrideConfig, PluginConfig } from './schema';
  4: /**
  11:  */

C:\Users\paulc\.config\opencode\dev\src\utils\debug\logger.ts:
  78:     file: resolveLogPath('.debug/opencode-debug.log'),
  141:       // Ignore logging failures.

C:\Users\paulc\.config\opencode\dev\src\config\codemap.md:
  5: The `src/config/` module is responsible for:
  18: - User config: `~/.config/opencode/oh-my-opencode-theseus.json` (or `$XDG_CONFIG_HOME`)
  19: - Project config: `<directory>/.opencode/oh-my-opencode-theseus.json`
  30: **Wildcard/Exclusion Syntax**
  84: - `parseList(items, allAvailable): string[]` - Parse wildcard/exclusion lists
  95: ├─→ Load user config from ~/.config/opencode/oh-my-opencode-theseus.json
  97: │       └─→ Return null if invalid/missing
  99: ├─→ Load project config from <directory>/.opencode/oh-my-opencode-theseus.json
  101: │       └─→ Return null if invalid/missing
  145: | orchestrator | `openrouter-free/openrouter/free` |
  146: | oracle      | `openrouter-free/openrouter/free` |
  147: | librarian   | `openrouter-free/openrouter/free` |
  148: | explorer    | `openrouter-free/openrouter/free` |
  149: | designer    | `openrouter-free/openrouter/free` |
  150: | fixer       | `openrouter-free/openrouter/free` |
  155: src/config/

C:\Users\paulc\.config\opencode\dev\src\skills\cartography\SKILL.md:
  12: - User asks to understand/map a repository
  20: **First, check if `.slim/cartography.json` exists in the repo root.**
  29: 2. **Infer patterns** for **core code/config files ONLY** to include:
  30:    - **Include**: `src/**/*.ts`, `package.json`, etc.
  32:      - Tests: `**/*.test.ts`, `**/*.spec.ts`, `tests/**`, `__tests__/**`
  33:      - Docs: `docs/**`, `*.md` (except root `README.md` if needed), `LICENSE`
  34:      - Build/Deps: `node_modules/**`, `dist/**`, `build/**`, `*.min.js`
  39: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py init \
  40:   --root ./ \
  41:   --include "src/**/*.ts" \
  42:   --exclude "**/*.test.ts" --exclude "dist/**" --exclude "node_modules/**"
  46: - `.slim/cartography.json` - File and folder hashes for change detection
  56: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py changes \
  57:   --root ./
  70: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py update \
  71:   --root ./
  95: # src/agents/
  103: - User overrides from ~/.config/opencode/oh-my-opencode-theseus.json
  104: - Permission wildcards for skill/MCP access control
  114: - Consumed by: Main plugin (src/index.ts)
  127: - `src/index.ts`: Plugin initialization and OpenCode integration.
  134: | `src/agents/` | Defines agent personalities (Orchestrator, Explorer) and manages model routing. | [View Map](src/agents/codemap.md) |
  135: | `src/features/` | Core logic for tmux integration, background task spawning, and session state. | [View Map](src/features/codemap.md) |
  136: | `src/config/` | Implements the configuration loading pipeline and environment variable injection. | [View Map](src/config/codemap.md) |

C:\Users\paulc\.config\opencode\dev\src\utils\debug\codemap.md:
  1: # src/utils/debug/
  5: Implements a best-effort debug logging framework with configurable verbosity and output targets (console and/or file). This is designed to replace ad-hoc `console.*` logging in runtime code.
  11:   - `debug` singleton (`DebugLogger`) configured from `~/.config/opencode/.debug/debug.json`.
  15:   - supports relative log path resolution rooted at `~/.config/opencode/`.
  16: - File writes are synchronous and wrapped in try/catch to avoid breaking plugin runtime.
  26: - Re-exported through `src/utils/debug.ts` as `../utils/debug`.
  27: - Used by runtime modules that want structured debug output (for example `src/background/background-manager.ts`).

C:\Users\paulc\.config\opencode\dev\src\config\schema.ts:
  14: // Agent override configuration (distinct from SDK's AgentConfig)
  19:   mcps: z.array(z.string()).optional(), // MCPs this agent can use ("*" = all, "!item" = exclude)
  20:   models: z.array(z.string()).optional(), // Model fallback chain for this agent (first = default)
  23: // Tmux layout options
  25:   'main-horizontal', // Main pane on top, agents stacked below
  26:   'main-vertical', // Main pane on left, agents stacked on right
  27:   'tiled', // All panes equal size grid
  28:   'even-horizontal', // All panes side by side
  29:   'even-vertical', // All panes stacked vertically
  34: // Tmux integration configuration
  38:   main_pane_size: z.number().min(20).max(80).default(60), // percentage for main pane
  49: // MCP names
  53: // Background task configuration
  62: // Idle Orchestrator configuration
  79:   hfModel: z.string().default('unsloth/SmolLM2-135M-Instruct-GGUF'),
  81:   lmStudioBaseUrl: z.string().url().default('http://127.0.0.1:1234'),
  97:   lastFailure: z.number().optional(), // Unix timestamp (ms) of last failure
  98:   failureCount: z.number().min(0).default(0), // Consecutive failure count
  99:   lastSuccess: z.number().optional(), // Unix timestamp (ms) of last success
  100:   lastChecked: z.number().optional(), // Last health-check/probe timestamp
  101:   disabled: z.boolean().optional(), // Model disabled due to repeated failures
  122:   // Backward-compat fallback chains (legacy + CLI emitted)
  124:   // Model health tracking (failure counts, last failure timestamps)
  128: // Hang Detection Configuration
  178: // Main plugin config - preset/presets kept for backwards compatibility but not used
  194: // Agent names - re-exported from constants for convenience
  195: export type { AgentName } from './constants';

C:\Users\paulc\.config\opencode\dev\src\config\agent-mcps.ts:
  8: /** Default MCPs per agent - "*" means all MCPs, "!item" excludes specific MCPs */
  19: /**
  21:  */
  41: /**
  43:  */
  50: /**
  52:  */

C:\Users\paulc\.config\opencode\dev\src\config\loader.ts.backup:
  4: import { stripJsonComments } from '../cli/config-io';
  5: import { type PluginConfig, PluginConfigSchema } from './schema';
  6: import { log } from '../utils/logger';
  10: /**
  12:  * Falls back to ~/.config if XDG_CONFIG_HOME is not set.
  15:  */
  20: /**
  28:  */
  32:     // Use stripJsonComments to support JSONC format (comments and trailing commas)
  45:     // Log the error type and message for debugging
  54: /**
  58:  * @param basePath - Base path without extension (e.g., /path/to/oh-my-opencode-slim)
  60:  */
  65:   // Prefer .jsonc over .json
  75: /**
  82:  */
  114: /**
  118:  * 1. User config: ~/.config/opencode/oh-my-opencode-slim.jsonc or .json (or $XDG_CONFIG_HOME)
  119:  * 2. Project config: <directory>/.opencode/oh-my-opencode-slim.jsonc or .json
  127:  */
  129:   // Always use the user config directory for plugin config
  130:   // The plugin config should come from the user's home directory, not from the project
  138:   // Also check the project directory as fallback
  145:   // Find existing config files (preferring .jsonc over .json)
  153:   // Check if config files exist - warn if neither user nor project config found
  167:   // Log successful config load
  193:   // Preset system removed - use DEFAULT_MODELS from constants instead
  194:   // This ensures user config (opencode.json) is the source of truth

C:\Users\paulc\.config\opencode\dev\src\codemap.md:
  1: # src/
  4: - `src/index.ts` delivers the oh-my-opencode-theseus plugin by merging configuration, instantiating orchestrator/subagent definitions, wiring background managers, tmux helpers, built-in tools, MCPs, and lifecycle hooks so OpenCode sees a single cohesive module.
  5: - `config/`, `agents/`, `tools/`, `background/`, `hooks/`, and `utils/` contain the reusable building blocks (loader/schema/constants, agent factories/permission helpers, tool factories, background polling/session managers, hook implementations, and tmux/variant/log helpers) that power that entry point.
  6: - `cli/` exposes the install/update script (argument parsing + interactive prompts) that edits OpenCode config, installs recommended/custom skills, and updates provider credentials to bootstrap this plugin on a host machine.
  9: - Agent creation follows explicit factories (`agents/index.ts`, per-agent creators under `agents/`) with override/permission helpers (`config/utils.ts`, `cli/skills.ts`) so defaults live in `config/constants.ts`, prompts can be swapped via `config/loader.ts`, and variant labels propagate through `utils/agent-variant.ts`.
  10: - Background tooling composes `BackgroundTaskManager`, `TmuxSessionManager`, and `createBackgroundTools` (which uses `tool` with Zod schemas) to provide async/sync task launches plus cancel/output helpers; polling/prompt flow lives in `tools/background.ts` while TMUX lifecycle uses `utils/tmux.ts` to spawn/close panes and reapply layouts.
  11: - Hooks are isolated (`hooks/auto-update-checker`, `phase-reminder`, `post-read-nudge`) and exported via `hooks/index.ts`, so the plugin simply registers them via the `event`, `experimental.chat.messages.transform`, and `tool.execute.after` hooks defined in `index.ts`.
  12: - Supplemental tools (`tools/grep`, `tools/lsp`, `tools/quota`) bundle ripgrep, LSP helpers, and Antigravity quota calls behind the OpenCode `tool` interface and are mounted in `index.ts` alongside background/task tools.
  15: - Startup: `index.ts` calls `loadPluginConfig` (user + project JSON + presets) to build a `PluginConfig`, passes it to `getAgentConfigs` (which uses `createAgents`, agent factories, and `getAgentMcpList`) and to `BackgroundTaskManager`/`TmuxSessionManager`/`createBackgroundTools` so the in-memory state matches user overrides.
  16: - Plugin registration: `index.ts` registers agents, the tool map (background/task, `grep`, `ast_grep_*`, `lsp_*`, `antigravity_quota`), MCP definitions (`createBuiltinMcps`), and hooks (`createAutoUpdateCheckerHook`, `createPhaseReminderHook`, `createPostReadNudgeHook`); configuration hook merges those values back into the OpenCode config (default agent, permission rules parsed from `config/agent-mcps`, and MCP access policies).
  17: - Runtime: `BackgroundTaskManager.launch` spins up sessions and prompts agents via the OpenCode client, `pollTask`/`pollSession` watch for idle status before resolving results, while `TmuxSessionManager` observes `session.created` events to spawn panes via `utils/tmux` and close them when sessions idle or time out; tool hooks prevent recursion by toggling `background_task/task` permission when sending prompts.
  18: - CLI flow: `cli/install.ts` parses flags, optionally asks interactive prompts, checks OpenCode installation, adds plugin entries via `cli/config-manager.ts`, disables default agents, writes the lite config (`cli/config-io.ts`), and installs skills (`cli/skills.ts`, `cli/custom-skills.ts`).
  21: - Connects directly to the OpenCode plugin API (`@opencode-ai/plugin`): registers agents/tools/mcps, responds to `session.created` and `tool.execute.after` events, injects `experimental.chat.messages.transform`, and makes RPC calls via `ctx.client`/`ctx.client.session` throughout `tools/background` and `background/*`.
  22: - Integrates with the host environment: `utils/tmux.ts` checks for tmux and server availability, `startTmuxCheck` pre-seeds the binary path, and `TmuxSessionManager`/`BackgroundTaskManager` coordinate via shared configuration and `tools/background` to keep CLI panes synchronized.
  23: - Hooks and helpers tie into external behavior: `hooks/auto-update-checker` reads `package.json` metadata, runs safe `bun install`, and posts toasts; `hooks/phase-reminder/post-read-nudge` enforce workflow reminders; `utils/logger.ts` centralizes structured logging used across modules.
  24: - CLI utilities modify OpenCode CLI/user config files (`cli/config-manager.ts`) and install additional skills/ providers, ensuring the plugin lands with the expected agents, provider auth helpers, and custom skill definitions.

C:\Users\paulc\.config\opencode\dev\src\config\loader.ts:
  4: import { stripJsonComments } from '../cli/config-io';
  5: import { ALL_AGENT_NAMES, DEFAULT_MODELS } from './constants';
  6: import { type PluginConfig, PluginConfigSchema } from './schema';
  7: import { log } from '../utils/logger';
  11: /**
  13:  * Falls back to ~/.config if XDG_CONFIG_HOME is not set.
  16:  */
  21: /**
  29:  */
  33:     // Use stripJsonComments to support JSONC format (comments and trailing commas)
  46:     // Log the error type and message for debugging
  62:   // Migrate agents.<name>.model -> agents.<name>.currentModel
  89: /**
  93:  * @param basePath - Base path without extension (e.g., /path/to/oh-my-opencode-theseus)
  95:  */
  100:   // Prefer .jsonc over .json
  110: /**
  117:  */
  149: /**
  153:  * 1. User config: ~/.config/opencode/oh-my-opencode-theseus.jsonc or .json (or $XDG_CONFIG_HOME)
  154:  * 2. Project config: <directory>/.opencode/oh-my-opencode-theseus.jsonc or .json
  162:  */
  164:   // Always use the user config directory for plugin config
  165:   // The plugin config should come from the user's home directory, not from the project
  173:   // Also check the project directory as fallback
  180:   // Find existing config files (preferring .jsonc over .json)
  188:   // Check if config files exist - warn if neither user nor project config found
  202:   // Log successful config load
  228:   // Ensure all agents have a currentModel populated from defaults if missing
  243:   // Preset system removed - use DEFAULT_MODELS from constants instead
  244:   // This ensures user config (opencode.json) is the source of truth

C:\Users\paulc\.config\opencode\dev\src\config\index.ts:
  1: export * from './constants';
  2: export { loadPluginConfig } from './loader';
  3: export * from './schema';
  4: export { getAgentOverride } from './utils';

C:\Users\paulc\.config\opencode\dev\src\hooks\changelog-cartography\index.ts:
  1: import type { PluginInput } from '@opencode-ai/plugin';
  2: import type { BackgroundTaskManager } from '../../background/background-manager';
  3: import { log } from '../../utils/logger';
  57:   return /^error\b|^\[error\]/i.test(t);
  61:   const p = filePath.replace(/\\/g, '/');
  62:   if (p.endsWith('/codemap.md') || p === 'codemap.md') return true;
  63:   if (p.includes('/.slim/')) return true;
  88:   // Apply-patch style tool: parse patch headers.
  97:     for (const line of patchText.split(/\r?\n/)) {
  98:       const m = line.match(/^\*\*\* (Add File|Update File|Delete File): (.+)$/);
  112:   return cmd.includes('cartographer.py') && /\bupdate\b/.test(cmd);
  123:     // If we cannot verify, assume it's main (consistent with idle-orchestrator).
  139:   return `run cartography. The following files have been updated:\n\n${bulletList}${omittedLine}\n\nInstructions:\n- Delegate to exactly one Librarian to run the cartography skill workflow.\n- Update codemaps per affected directory (use cartographer.py changes/update and update the root atlas if needed).\n- When cartography is complete, ensure cartographer.py update has been run.`;
  168:       // Already asked for this snapshot; wait for cartography completion.
  201:       // Only prompt on main sessions (not background tasks).
  202:       // Cache decisions to avoid extra API calls.
  238:       // If this was cartography update, treat it as completion signal.

C:\Users\paulc\.config\opencode\dev\src\config\constants.ts:
  1: // Plugin version - single source of truth for runtime version checking
  4: // Agent names
  22: // Agent name type (for use in DEFAULT_MODELS)
  25: // Subagent delegation rules: which agents can spawn which subagents
  26: // orchestrator: can spawn all subagents (full delegation)
  27: // fixer: can spawn explorer (for research during implementation)
  28: // designer: can spawn oracle (for approval) and explorer (for research)
  29: // oracle: can spawn designer (for planning) and explorer (for research)
  30: // explorer/librarian: cannot spawn any subagents (leaf nodes)
  31: // Unknown agent types not listed here default to explorer-only access
  41: // Default models for each agent
  43:   orchestrator: 'openrouter-free/openrouter/free',
  44:   oracle: 'openrouter-free/openrouter/free',
  45:   librarian: 'openrouter-free/openrouter/free',
  46:   explorer: 'openrouter-free/openrouter/free',
  47:   designer: 'openrouter-free/openrouter/free',
  48:   fixer: 'openrouter-free/openrouter/free',
  51: // Polling configuration
  56: // Timeouts
  57: export const DEFAULT_TIMEOUT_MS = 2 * 60 * 1000; // 2 minutes
  58: export const MAX_POLL_TIME_MS = 5 * 60 * 1000; // 5 minutes
  61: // Polling stability

C:\Users\paulc\.config\opencode\dev\src\hooks\changelog-cartography\codemap.md:
  1: # src/hooks/changelog-cartography/
  5: Tracks successful file modifications made through write/edit/apply_patch and prompts the main Orchestrator session to re-run cartography when the session becomes idle. This keeps `codemap.md` documentation in sync with recently changed code.
  16:   - `write`/`edit` (`filePath`/`path`)
  17:   - `apply_patch` (parses `*** Add/Update/Delete File:` headers)
  23: 1. `tool.execute.before`: record candidate file paths for write/edit/apply_patch.

C:\Users\paulc\.config\opencode\dev\src\hooks\codemap.md:
  1: # src/hooks/
  7: It acts as a single entry point that re-exports the factory functions and option types for every hook implementation underneath `src/hooks/`, so other modules can `import { createAutoUpdateCheckerHook, AutoUpdateCheckerOptions } from 'src/hooks'` without needing to know the subpaths.
  18: - **Aggregator/re-export pattern**: `index.ts` consolidates factories (`createAutoUpdateCheckerHook`, `createPhaseReminderHook`, `createPostReadNudgeHook`, `createIdleOrchestratorHook`) and shared types so the rest of the app depends only on this flat namespace.
  28: - `enabled: boolean` - Enable/disable the hook
  42: Callers import a factory from `src/hooks`, supply any typed options (e.g., `IdleOrchestratorOptions`), and the factory wires together the hook's internal checks/side-effects before returning the hook interface that the feature layer consumes.
  58: - Feature modules across the app import everything through `src/hooks/index.ts`; there are no direct relations to deeper hook files, keeping consumers ignorant of the implementation details.
  60: - Hooks are registered in `src/index.ts` during plugin initialization

C:\Users\paulc\.config\opencode\dev\src\tools\lsp\client.test.ts:
  11: // Mock spawn from bun
  33: import { LSPClient, lspManager } from './client';
  65:     const root = '/root';
  71:     expect(startSpy).toHaveBeenCalledTimes(1); // Should be reused
  81:     const root = '/root';
  97:     const root = '/root';
  114:     await lspManager.getClient('/root1', {
  119:     await lspManager.getClient('/root2', {
  125:     // Reset stopSpy because getClient might have called stop if there were old clients
  136:     // We need to create a new instance or trigger the registration
  137:     // Since it's a singleton, we can just check if it was called during init
  138:     // But it already happened. Let's check if the handlers are there.
  139:     // Actually, we can just verify that it's intended to be called.
  141:     // For the sake of this test, let's just see if process.on was called with expected events
  142:     // This might be tricky if it happened before we started spying.
  144:     // Instead, let's just verify that stopAll is exported and works, which we already did.

C:\Users\paulc\.config\opencode\dev\src\hooks\post-read-nudge\index.ts:
  1: /**
  4:  */
  27:       // Only nudge for Read tool
  32:       // Append the nudge

C:\Users\paulc\.config\opencode\dev\src\hooks\background-followup\index.ts:
  1: import type { PluginInput } from '@opencode-ai/plugin';
  2: import { log } from '../../utils/logger';
  18:     const fs = await import('node:fs/promises');
  35:     const fs = await import('node:fs/promises');
  89:   return /^error\b|^\[error\]/i.test(text);

C:\Users\paulc\.config\opencode\dev\src\skills\cartography\scripts\test_cartographer.py:
  12:         patterns = ["node_modules/", "dist/", "*.log", "src/**/*.ts"]
  16:         self.assertTrue(matcher.matches("node_modules/foo.js"))
  17:         self.assertTrue(matcher.matches("vendor/node_modules/bar.js"))
  18:         self.assertTrue(matcher.matches("dist/main.js"))
  19:         self.assertTrue(matcher.matches("src/dist/output.js"))
  23:         self.assertTrue(matcher.matches("logs/access.log"))
  26:         self.assertTrue(matcher.matches("src/index.ts"))
  27:         self.assertTrue(matcher.matches("src/utils/helper.ts"))
  31:         self.assertFalse(matcher.matches("tests/test.py"))
  51:             "src/a.ts": "hash-a",
  52:             "src/b.ts": "hash-b",
  53:             "tests/test.ts": "hash-test"
  61:             "src/a.ts": "hash-a-modified",
  62:             "src/b.ts": "hash-b"
  70:             (root / "src").mkdir()
  71:             (root / "node_modules").mkdir()
  72:             (root / "src" / "index.ts").write_text("code")
  73:             (root / "src" / "index.test.ts").write_text("test")
  74:             (root / "node_modules" / "foo.js").write_text("dep")
  75:             (root / "package.json").write_text("{}")
  77:             includes = ["src/**/*.ts", "package.json"]
  78:             excludes = ["**/*.test.ts", "node_modules/"]
  84:             self.assertEqual(rel_selected, ["package.json", "src/index.ts"])

C:\Users\paulc\.config\opencode\dev\src\tools\index.ts:
  1: // AST-grep tools
  2: export { ast_grep_replace, ast_grep_search } from './ast-grep';
  3: export { createBackgroundTools } from './background';
  5: // Grep tool (ripgrep-based)
  6: export { grep } from './grep';
  13: } from './lsp';

C:\Users\paulc\.config\opencode\dev\src\hooks\post-read-nudge\codemap.md:
  1: # src/hooks/post-read-nudge/

C:\Users\paulc\.config\opencode\dev\src\hooks\background-followup\codemap.md:
  1: # src/hooks/background-followup/
  15: <!-- How does data/control flow through this module? -->

C:\Users\paulc\.config\opencode\dev\src\skills\cartography\scripts\codemap.md:
  1: # src/skills/cartography/scripts/
  5: Implements the `cartography` helper CLI in Python. The script creates and maintains `.slim/cartography.json` as a lightweight, git-independent change detector and generates directory-local `codemap.md` placeholders to be filled with architectural summaries.
  10:   - `init`: selects files via include/exclude patterns, hashes them, computes folder hashes, writes state, and creates empty `codemap.md` templates.
  11:   - `changes`: compares current hashes to saved state and prints added/removed/modified files plus affected folders.
  27: 4. Persist `.slim/cartography.json`.

C:\Users\paulc\.config\opencode\dev\src\tools\background.ts:
  5: } from '@opencode-ai/plugin';
  6: import type { BackgroundTaskManager } from '../background';
  7: import type { PluginConfig } from '../config';
  8: import { SUBAGENT_NAMES } from '../config';
  9: import type { TmuxConfig } from '../config/schema';
  13: /**
  20:  */
  39:   // Tool for launching agent tasks (fire-and-forget)
  64:       // Validate agent against delegation rules
  72:       // Fire-and-forget launch
  84:   // Tool for retrieving output from background tasks
  108:       // Wait for completion if timeout specified
  151:         const waitSeconds = Math.max(1, Math.ceil(waitMs / 1000));
  152:         return `Task ${task.id} is still ${task.status} with no new output yet. Check again in ~${waitSeconds}s, or wait for the completion notification/toast.`;
  160:       // Calculate task duration
  162:         ? `${Math.floor((task.completedAt.getTime() - task.startedAt.getTime()) / 1000)}s`
  163:         : `${Math.floor((Date.now() - task.startedAt.getTime()) / 1000)}s`;
  166:           ? `${Math.floor(telemetry.lastActivityAgoMs / 1000)}s ago`
  171:       // Add fallback information if available
  194:       // Include task result or error based on status
  198:         // Append fallback notice if fallback occurred
  205:         // Add fallback details if task failed during fallback
  217:           // Attempt to peek at the current session messages
  271:   // Tool for canceling running background tasks
  273:     description: `Cancel background task(s).\n\ntask_id: cancel specific task\nall=true: cancel all running tasks\n\nOnly cancels pending/starting/running tasks.`,
  324:           const duration = `${Math.floor(task.runtimeMs / 1000)}s`;
  343:         return `Cancellation requires double-run confirmation.\n\nPending cancellation targets:\n${lines.join('\n')}\n\nRun the same command again within 60s to proceed: ${repeatHint}\n\nOn second run, the manager will first attempt extraction/completion to preserve partial output, then cancel only tasks still active.`;
  349:       // Cancel all running tasks if requested
  358:       // Cancel specific task if task_id provided

C:\Users\paulc\.config\opencode\dev\src\hooks\auto-update-checker\checker.ts:
  4: import { stripJsonComments } from '../../cli/config-manager';
  5: import { log } from '../../utils/logger';
  13: } from './constants';
  19: } from './types';
  21: /**
  23:  */
  28: /**
  30:  */
  32:   return !/^\d/.test(version);
  35: /**
  39:  */
  48:       const channelMatch = prereleasePart.match(/^(alpha|beta|rc|canary|next)/);
  56: /**
  59:  */
  69: /**
  70:  * Attempts to find a local development path (file://) for the plugin in configs.
  71:  */
  81:         if (entry.startsWith('file://') && entry.includes(PACKAGE_NAME)) {
  85:             return entry.replace('file://', '');
  94: /**
  96:  */
  110:           /* empty */
  118:     /* empty */
  123: /**
  125:  */
  141: /**
  143:  */
  175: /**
  177:  */
  191:     /* empty */
  215: /**
  218:  */
  230:     // Check if the old entry actually exists as a quoted string
  231:     const escapedOldEntry = oldEntry.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  241:     // Perform the replacement
  262: /**
  264:  */
  274:       headers: { Accept: 'application/json' },

C:\Users\paulc\.config\opencode\dev\src\hooks\auto-update-checker\checker.test.ts:
  3: import { extractChannel, findPluginEntry, getLocalDevVersion } from './checker';
  5: // Mock the dependencies
  6: mock.module('./constants', () => ({
  8:   USER_OPENCODE_CONFIG: '/mock/config/opencode.json',
  9:   USER_OPENCODE_CONFIG_JSONC: '/mock/config/opencode.jsonc',
  11:     '/mock/cache/node_modules/oh-my-opencode-theseus/package.json',
  21: describe('auto-update-checker/checker', () => {
  47:       // existsSync returns false by default from mock
  48:       expect(getLocalDevVersion('/test')).toBeNull();
  64:             plugin: ['file:///dev/oh-my-opencode-theseus'],
  76:       expect(getLocalDevVersion('/test')).toBe('1.2.3-dev');
  92:       const entry = findPluginEntry('/test');
  110:       const entry = findPluginEntry('/test');

C:\Users\paulc\.config\opencode\dev\src\hooks\context-compressor\index.ts:
  1: import { log } from '../../utils/logger';
  3: const TOKEN_THRESHOLD = 150000; // Conservative threshold before 204800 limit
  4: const MESSAGES_TO_KEEP_HEAD = 2; // Keep first 2 messages (system + initial context)
  5: const MESSAGES_TO_KEEP_TAIL = 10; // Keep last 10 messages (recent context)
  24:   // Rough estimation: sum of text parts / 4
  33:   return Math.floor(totalChars / 4);
  38:     /rate.limit/i,
  39:     /context.length/i,
  40:     /token.limit/i,
  41:     /max.token/i,
  42:     /more.credit/i,
  43:     /fewer.max_token/i,
  44:     /model.unavailable/i,
  45:     /credit.exceeded/i,
  46:     /insufficient.quota/i,
  47:     /quota.exceeded/i,
  48:     /exceeded.your.current.quota/i,
  49:     /RESOURCE_EXHAUSTED/,
  50:     /generativelanguage\.googleapis\.com/,
  51:     /api.usage/i,
  52:     /429/, // HTTP status code for rate limit
  53:     /503/, // HTTP status code for service unavailable
  54:     /504/, // HTTP status code for gateway timeout
  55:     // Invalid model errors should trigger fallback
  56:     /invalid.*model/i,
  57:     /model.*not.*found/i,
  58:     /unknown.*model/i,
  59:     /model.*not.*available/i,
  60:     // Generic unknown errors should trigger fallback
  61:     /unknown.*error/i,
  62:     /unknown.*failure/i,
  63:     // Auth and key errors should trigger fallback
  64:     /api.*key/i,
  65:     /authentication/i,
  66:     /unauthorized/i,
  67:     /invalid.*api/i,
  68:     // Network and connection errors
  69:     /network.*error/i,
  70:     /connection.*error/i,
  71:     /timeout/i,
  72:     /econnrefused/i,
  73:     /econnreset/i,
  74:     /enotfound/i,
  75:     /000/i, // Connection failure (curl timeout/empty response)
  76:     // Agent-specific errors that should trigger fallback
  77:     /agent.*not.*found/i,
  78:     /agent.*not.*available/i,
  79:     /subagent.*error/i,
  80:     // General provider failures
  81:     /provider.*error/i,
  82:     /upstream.*error/i,
  83:     /server.*error/i,
  84:     /internal.*error/i,
  107:         // If under threshold, return as-is
  117:         // Keep first 2 messages (system + initial context)
  120:         // Keep last 10 messages (recent context)
  123:         // Calculate middle messages that will be truncated
  128:         // Create summary message for truncated middle section
  146:           // If there are no middle messages to truncate, just combine head and tail
  164:         // If compression fails, keep original messages to avoid breaking the chat

C:\Users\paulc\.config\opencode\dev\src\skills\cartography\scripts\cartographer.py:
  1: #!/usr/bin/env python3
  11:   cartographer.py init --root /path/to/repo --include "src/**/*.ts" --exclude "node_modules/**"
  12:   cartographer.py changes --root /path/to/repo
  13:   cartographer.py update --root /path/to/repo
  34:     gitignore_path = root / ".gitignore"
  57:             reg = reg.replace(r'\*\*/', '(?:.*/)?')  # Recursive glob
  59:             reg = reg.replace(r'\*', '[^/]*')  # Single level glob
  62:             if pattern.endswith('/'):
  65:             if pattern.startswith('/'):
  68:                 reg = '(?:^|.*/)' + reg
  90:     """Select files based on include/exclude patterns and exceptions."""
  110:             rel_path = os.path.join(rel_dir, filename).replace("\\", "/")
  111:             if rel_path.startswith("./"):
  126:                 selected.append(root / rel_path)
  149:         if path.startswith(folder + "/") or (folder == "." and "/" not in path)
  170:             folders.add("/".join(parts[: i + 1]))
  177:     state_path = root / STATE_DIR / STATE_FILE
  189:     state_dir = root / STATE_DIR
  192:     state_path = state_dir / STATE_FILE
  199:     codemap_path = folder_path / CODEMAP_FILE
  201:         content = f"""# {folder_name}/
  215: <!-- How does data/control flow through this module? -->
  235:     include_patterns = args.include or ["**/*"]
  279:     print(f"Created {STATE_DIR}/{STATE_FILE}")
  287:             folder_path = root / folder
  308:     include_patterns = metadata.get("include_patterns", ["**/*"])
  360:             affected_folders.add("/".join(parts[: i + 1]))
  365:         print(f"  {folder}/")
  381:     include_patterns = metadata.get("include_patterns", ["**/*"])
  410:     print(f"Updated {STATE_DIR}/{STATE_FILE} with {len(file_hashes)} files")

C:\Users\paulc\.config\opencode\dev\src\hooks\phase-reminder\index.ts:
  1: /**
  10:  */
  15: </reminder>`;
  34: /**
  38:  */
  51:       // Find the last user message
  66:       // Only inject for orchestrator (or if no agent specified = main session)
  72:       // Find the first text part
  81:       // Prepend the reminder to the existing text

C:\Users\paulc\.config\opencode\dev\src\tools\lsp\utils.ts:
  1: // LSP Utilities - Essential formatters and helpers
  12: import type { LSPClient } from './client';
  13: import { lspManager } from './client';
  14: import { findServerForExtension } from './config';
  15: import { SEVERITY_MAP, SYMBOL_KIND_MAP } from './constants';
  23: } from './types';
  162: // WorkspaceEdit application

C:\Users\paulc\.config\opencode\dev\src\hooks\auto-update-checker\cache.ts:
  3: import { stripJsonComments } from '../../cli/config-manager';
  4: import { log } from '../../utils/logger';
  5: import { CACHE_DIR, PACKAGE_NAME } from './constants';
  16: /**
  20:  */
  32:       // If it's not valid JSON(C), it might be the new Bun text format or binary format.
  33:       // For now, we only support JSON-based lockfile manipulation.
  61: /**
  65:  */

C:\Users\paulc\.config\opencode\dev\src\hooks\auto-update-checker\index.ts:
  1: import type { PluginInput } from '@opencode-ai/plugin';
  2: import { log } from '../../utils/logger';
  3: import { invalidatePackage } from './cache';
  11: } from './checker';
  12: import { PACKAGE_NAME } from './constants';
  13: import type { AutoUpdateCheckerOptions } from './types';
  15: /**
  20:  */
  76: /**
  80:  */
  181: /**
  186:  */
  205:         /* empty */
  217: /**
  224:  */
  239: export type { AutoUpdateCheckerOptions } from './types';

C:\Users\paulc\.config\opencode\dev\src\skills\cartography\README.md:
  9: 1. Selecting relevant code/config files using LLM judgment
  10: 2. Creating `.slim/cartography.json` for change tracking
  17: python3 cartographer.py init --root /repo --include "src/**/*.ts" --exclude "node_modules/**"
  20: python3 cartographer.py changes --root /repo
  23: python3 cartographer.py update --root /repo
  28: ### .slim/cartography.json
  35:     "include_patterns": ["src/**/*.ts"],
  36:     "exclude_patterns": ["node_modules/**"]
  39:     "src/index.ts": "abc123..."
  52: - Data/control flow

C:\Users\paulc\.config\opencode\dev\src\hooks\phase-reminder\codemap.md:
  1: # src/hooks/phase-reminder/

C:\Users\paulc\.config\opencode\dev\src\background\tmux-session-manager.ts:
  1: import type { PluginInput } from '@opencode-ai/plugin';
  2: import { POLL_INTERVAL_BACKGROUND_MS } from '../config';
  3: import type { TmuxConfig } from '../config/schema';
  4: import { log } from '../utils/logger';
  5: import { closeTmuxPane, isInsideTmux, spawnTmuxPane } from '../utils/tmux';
  19: /**
  21:  */
  31: const SESSION_TIMEOUT_MS = 10 * 60 * 1000; // 10 minutes
  34: /**
  35:  * TmuxSessionManager tracks child sessions and spawns/closes tmux panes for them.
  38:  */
  52:       ctx.serverUrl?.toString() ?? `http://localhost:${defaultPort}`;
  62:   /**
  65:    */
  72:       // Not a child session, skip
  80:     // Skip if we're already tracking this session
  120:       // Start polling for fallback reliability
  125:   /**
  130:    */
  138:     // Check if session is idle (completed)
  162:   /**
  165:    */
  185:         // Session is idle (completed).
  199:         // Check for timeout as a safety fallback
  232:   /**
  234:    */

C:\Users\paulc\.config\opencode\dev\src\tools\lsp\utils.test.ts:
  5: // Mock fs BEFORE importing modules
  23: } from './utils';
  213:         filesModified: ['/home/user/file1.ts'],

C:\Users\paulc\.config\opencode\dev\src\hooks\auto-update-checker\cache.test.ts:
  3: import { invalidatePackage } from './cache';
  5: // Mock internal dependencies
  6: mock.module('./constants', () => ({
  7:   CACHE_DIR: '/mock/cache',
  11: mock.module('../../shared/logger', () => ({
  15: // Mock fs and path
  23: mock.module('../../cli/config-manager', () => ({
  27: describe('auto-update-checker/cache', () => {

C:\Users\paulc\.config\opencode\dev\src\hooks\context-compressor\codemap.md:
  1: # src/hooks/context-compressor/
  10: - Uses a rough token estimator (sum of text chars / 4).
  15: - Exports `detectProviderError(errorMessage)` which classifies error strings that should trigger model fallback/retry logic.
  27: - Uses `src/utils/logger` for best-effort logging.

C:\Users\paulc\.config\opencode\dev\src\hooks\auto-update-checker\constants.ts:
  3: import { getOpenCodeConfigPaths } from '../../cli/config-manager';
  6: export const NPM_REGISTRY_URL = `https://registry.npmjs.org/-/package/${PACKAGE_NAME}/dist-tags`;
  16: /** The directory used by OpenCode to cache node_modules for plugins. */
  19: /** Path to this plugin's package.json within the OpenCode cache. */
  29: /** Primary OpenCode configuration file path (standard JSON). */
  32: /** Alternative OpenCode configuration file path (JSON with Comments). */

C:\Users\paulc\.config\opencode\dev\src\skills\cartography\codemap.md:
  1: # src/skills/cartography/
  11: - `scripts/`: contains the executable helper (`cartographer.py`) that:
  12:   - tracks repository file/folder hashes in `.slim/cartography.json`,
  18: 1. Orchestrator checks `.slim/cartography.json`.
  19: 2. If missing: runs `cartographer.py init` with include/exclude patterns.
  21: 4. Codemaps are written/updated for affected folders; the root `codemap.md` atlas is refreshed.
  27: - The helper script is executed via Orchestrator `bash`; subagents (Explorer/Librarian) may contribute content but the Orchestrator owns correctness gates.

C:\Users\paulc\.config\opencode\dev\src\hooks\index.ts:
  1: export type { AutoUpdateCheckerOptions } from './auto-update-checker';
  2: export { createAutoUpdateCheckerHook } from './auto-update-checker';
  3: export { createPhaseReminderHook } from './phase-reminder';
  4: export { createPostReadNudgeHook } from './post-read-nudge';
  5: export { createContextCompressorHook, detectProviderError } from './context-compress

... (truncated)
```
