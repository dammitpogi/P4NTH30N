// TEST COMMENT - VERSION 4
import type { Plugin, PluginInput } from '@opencode-ai/plugin';
import { type ToolDefinition, tool } from '@opencode-ai/plugin/tool';
import { getAgentConfigs } from './agents';
import { BackgroundTaskManager, TmuxSessionManager } from './background';
import { loadPluginConfig, PLUGIN_VERSION, type TmuxConfig } from './config';
import {
  createAutoUpdateCheckerHook,
  createBackgroundFollowupHook,
  // createChangelogCartographyHook, // Disabled - auto-injection too slow
  createDirectoryCodemapInjectorHook,
  createIdleOrchestratorHook,
  createPhaseReminderHook,
  createPostReadNudgeHook,
  ensureLmStudioModelLoaded,
} from './hooks';
import { createBuiltinMcps } from './mcp';
import {
  ast_grep_replace,
  ast_grep_search,
  createBackgroundTools,
  grep,
  lsp_diagnostics,
  lsp_find_references,
  lsp_goto_definition,
  lsp_rename,
} from './tools';
import { startTmuxCheck } from './utils';
import { log } from './utils/logger';

const OhMyOpenCodeLite: Plugin = async (ctx: PluginInput) => {
  // Use process.cwd() to get user's working directory, not plugin directory
  const userDirectory = process.cwd();
  const config = loadPluginConfig(userDirectory);

  log('[plugin] Version:', PLUGIN_VERSION);
  log('[plugin] Config loaded:', {
    pluginDirectory: ctx.directory,
    userDirectory: userDirectory,
    hasConfig: !!config,
    hasAgents: !!config?.agents,
    hasFallback: !!config?.fallback,
  });

  // Show version toast on startup
  setTimeout(() => {
    ctx.client.tui
      .showToast({
        body: {
          title: 'oh-my-opencode-theseus',
          message: `v${PLUGIN_VERSION} loaded`,
          variant: 'info',
          duration: 5000,
        },
      })
      .catch(() => {});
  }, 3000);

  // Check if config is missing and show warning
  const configMissing =
    !config?.agents || Object.keys(config.agents).length === 0;
  if (configMissing) {
    // Log to file (not console)
    log('[plugin] Config missing, showing toast');

    // Show toast notification
    setTimeout(() => {
      ctx.client.tui
        .showToast({
          body: {
            title: '⚠️ Config Missing',
            message:
              'oh-my-opencode-theseus.json not found. Run: bunx oh-my-opencode-theseus install',
            variant: 'error',
            duration: 20000,
          },
        })
        .catch(() => {});
    }, 2000);
  }

  const agents = getAgentConfigs(config);

  // Log loaded agents for verification

  // Parse tmux config with defaults
  const tmuxConfig: TmuxConfig = {
    enabled: config.tmux?.enabled ?? false,
    layout: config.tmux?.layout ?? 'main-vertical',
    main_pane_size: config.tmux?.main_pane_size ?? 60,
  };

  log('[plugin] initialized with tmux config', {
    tmuxConfig,
    rawTmuxConfig: config.tmux,
    directory: ctx.directory,
  });

  // Start background tmux check if enabled
  if (tmuxConfig.enabled) {
    startTmuxCheck();
  }

  const backgroundManager = new BackgroundTaskManager(ctx, tmuxConfig, config);
  const backgroundTools = createBackgroundTools(
    ctx,
    backgroundManager,
    tmuxConfig,
    config,
  );
  const mcps = createBuiltinMcps(config.disabled_mcps);

  // Initialize TmuxSessionManager to handle OpenCode's built-in Task tool sessions
  const tmuxSessionManager = new TmuxSessionManager(ctx, tmuxConfig);

  // Initialize auto-update checker hook
  const autoUpdateChecker = createAutoUpdateCheckerHook(ctx, {
    showStartupToast: true,
    autoUpdate: true,
  });

  // Initialize phase reminder hook for workflow compliance
  const phaseReminderHook = createPhaseReminderHook();

  // Initialize post-read nudge hook
  const postReadNudgeHook = createPostReadNudgeHook();

  // Initialize directory codemap injector hook
  const directoryCodemapInjectorHook = createDirectoryCodemapInjectorHook(
    ctx,
    config.codemapInjection,
  );
  void ensureLmStudioModelLoaded(ctx, config.codemapInjection);

  // Initialize idle orchestrator hook - keeps Orchestrator busy for background task auto-flush
  const idleOrchestratorHook = createIdleOrchestratorHook(
    ctx,
    config.idleOrchestrator,
  );

  // Cartography auto-injection disabled - too slow
  // const changelogCartographyHook = createChangelogCartographyHook(
  //   ctx,
  //   backgroundManager,
  // );

  // Track session todos and prompt for productive follow-up after delegation.
  const backgroundFollowupHook = createBackgroundFollowupHook(ctx);

  // Version query tool - available to agents
  const getPluginVersion: ToolDefinition = tool({
    description: 'Returns the version of the oh-my-opencode-theseus plugin',
    args: {},
    execute: async () => {
      return `oh-my-opencode-theseus v${PLUGIN_VERSION}`;
    },
  });

  return {
    name: 'oh-my-opencode-theseus',
    version: PLUGIN_VERSION,

    agent: agents,

    tool: {
      ...backgroundTools,
      getPluginVersion,
      lsp_goto_definition,
      lsp_find_references,
      lsp_diagnostics,
      lsp_rename,
      grep,
      ast_grep_search,
      ast_grep_replace,
    },

    mcp: mcps,

    config: async (opencodeConfig: Record<string, unknown>) => {
      // Show config warning after a delay to ensure TUI is ready
      const hasAgents = config?.agents && Object.keys(config.agents).length > 0;
      if (!hasAgents) {
        setTimeout(() => {
          ctx.client.tui
            .showToast({
              body: {
                title: '⚠️ Config Missing',
                message:
                  'oh-my-opencode-theseus.json not found. Run: bunx oh-my-opencode-theseus install',
                variant: 'error',
                duration: 15000,
              },
            })
            .catch(() => {});
        }, 2000);
      }

      (opencodeConfig as { default_agent?: string }).default_agent =
        'orchestrator';

      // Merge Agent configs
      if (!opencodeConfig.agent) {
        opencodeConfig.agent = { ...agents };
      } else {
        const opencodeAgents = opencodeConfig.agent as Record<string, unknown>;
        for (const [name, defaultAgentConfig] of Object.entries(agents)) {
          const existingConfig = opencodeAgents[name] as
            | Record<string, unknown>
            | undefined;
          if (existingConfig) {
            opencodeAgents[name] = {
              ...defaultAgentConfig,
              ...existingConfig,
            };
          } else {
            opencodeAgents[name] = defaultAgentConfig;
          }
        }
      }
      const configAgent = opencodeConfig.agent as Record<string, unknown>;

      // Merge MCP configs
      if (!opencodeConfig.mcp) {
        opencodeConfig.mcp = { ...mcps };
      } else {
        const configMcp = opencodeConfig.mcp as Record<string, unknown>;
        for (const [name, defaultMcpConfig] of Object.entries(mcps)) {
          const existingConfig = configMcp[name] as
            | Record<string, unknown>
            | undefined;
          if (existingConfig) {
            configMcp[name] = {
              ...defaultMcpConfig,
              ...existingConfig,
            };
          } else {
            configMcp[name] = defaultMcpConfig;
          }
        }
      }

      // For each agent, create permission rules based on their mcps list
      for (const [agentName, agentConfig] of Object.entries(agents)) {
        const agentMcps = (agentConfig as { mcps?: string[] })?.mcps;
        if (!agentMcps) continue;

        // Get or create agent permission config
        if (!configAgent[agentName]) {
          configAgent[agentName] = { ...agentConfig };
        }
        const agentConfigEntry = configAgent[agentName] as Record<
          string,
          unknown
        >;
        const agentPermission = (agentConfigEntry.permission ?? {}) as Record<
          string,
          unknown
        >;

        // Update agent config with permissions
        agentConfigEntry.permission = agentPermission;
      }
    },

    event: async (input) => {
      // Handle server.connected - show warning immediately when server is ready
      if (input.event.type === 'server.connected') {
        const hasAgents =
          config?.agents && Object.keys(config.agents).length > 0;
        if (!hasAgents) {
          // Show toast notification (user will see this)
          setTimeout(() => {
            ctx.client.tui
              .showToast({
                body: {
                  title: '⚠️ Config Missing',
                  message:
                    'oh-my-opencode-theseus.json not found. Run: bunx oh-my-opencode-theseus install',
                  variant: 'error',
                  duration: 15000,
                },
              })
              .catch(() => {});
          }, 1000);
        }
        return;
      }

      // Check for missing config on first session creation
      if (input.event.type === 'session.created') {
        const props = input.event.properties as
          | { info?: { parentID?: string } }
          | undefined;
        const hasAgents =
          config?.agents && Object.keys(config.agents).length > 0;

        // Show config missing toast for main session only
        if (!props?.info?.parentID && !hasAgents) {
          setTimeout(() => {
            ctx.client.tui
              .showToast({
                body: {
                  title: '⚠️ oh-my-opencode-theseus Config Missing',
                  message:
                    'Config not found at ~/.config/opencode/oh-my-opencode-theseus.json. Run: bunx oh-my-opencode-theseus install',
                  variant: 'error',
                  duration: 15000,
                },
              })
              .catch(() => {});
          }, 500);
        }
      }

      // Handle auto-update checking
      await autoUpdateChecker.event(input);

      // Handle idle orchestrator - proactive prompts to keep Orchestrator busy
      await idleOrchestratorHook.event(input);

      // Cartography auto-injection disabled
      // await changelogCartographyHook.event(input as any);

      // Handle codemap injector lifecycle cache cleanup
      await directoryCodemapInjectorHook.event?.(input);

      // Handle tmux pane spawning for OpenCode's Task tool sessions
      await tmuxSessionManager.onSessionCreated(
        input.event as {
          type: string;
          properties?: {
            info?: { id?: string; parentID?: string; title?: string };
          };
        },
      );

      // Handle session.status events for:
      // 1. BackgroundTaskManager: completion detection
      // 2. TmuxSessionManager: pane cleanup
      await backgroundManager.handleSessionStatus(
        input.event as {
          type: string;
          properties?: { sessionID?: string; status?: { type: string } };
        },
      );
      await tmuxSessionManager.onSessionStatus(
        input.event as {
          type: string;
          properties?: { sessionID?: string; status?: { type: string } };
        },
      );
    },

    'tool.execute.before': async (input, output) => {
      // Cartography auto-injection disabled
      // await changelogCartographyHook['tool.execute.before']?.(
      //   input as { tool: string; sessionID: string; callID: string },
      //   output as { args: any },
      // );
      await backgroundFollowupHook['tool.execute.before']?.(
        input as { tool: string; sessionID?: string; callID?: string },
        output as { args?: unknown },
      );
    },

    // Chain message transforms: add phase reminder
    'experimental.chat.messages.transform': async (_input, output) => {
      const phaseReminderTransform =
        phaseReminderHook['experimental.chat.messages.transform'];
      await phaseReminderTransform(_input, output);
    },

    // Inject codemap summaries and then nudge after file reads
    'tool.execute.after': async (input, output) => {
      await directoryCodemapInjectorHook.toolExecuteAfter?.(
        input as {
          tool: string;
          sessionID: string;
          callID?: string;
        },
        output as { title: string; output: string; metadata: unknown },
      );
      await postReadNudgeHook['tool.execute.after'](
        input as { tool: string; sessionID?: string; callID?: string },
        output as {
          title: string;
          output: string;
          metadata: Record<string, unknown>;
        },
      );

      const callID = (input as { callID?: string }).callID;
      // Cartography auto-injection disabled
      // if (callID) {
      //   await changelogCartographyHook['tool.execute.after']?.(
      //     input as { tool: string; sessionID: string; callID: string },
      //     output as { title: string; output: string; metadata: any },
      //   );
      // }
      await backgroundFollowupHook['tool.execute.after']?.(
        input as { tool: string; sessionID?: string; callID?: string },
        output as { output?: string },
      );
    },
  };
};

export default OhMyOpenCodeLite;

export type {
  AgentName,
  AgentOverrideConfig,
  McpName,
  PluginConfig,
  TmuxConfig,
  TmuxLayout,
} from './config';
export type { RemoteMcpConfig } from './mcp';
// PLUGIN_VERSION is defined in ./config/constants but not exported to avoid OpenCode treating it as a callable export
