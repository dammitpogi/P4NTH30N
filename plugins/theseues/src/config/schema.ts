import { z } from 'zod';

const FALLBACK_AGENT_NAMES = [
  'orchestrator',
  'oracle',
  'designer',
  'explorer',
  'librarian',
  'fixer',
] as const;

export type FallbackAgentName = (typeof FALLBACK_AGENT_NAMES)[number];

// Agent override configuration (distinct from SDK's AgentConfig)
export const AgentOverrideConfigSchema = z.object({
  currentModel: z.string().optional(),
  temperature: z.number().min(0).max(2).optional(),
  variant: z.string().optional().catch(undefined),
  mcps: z.array(z.string()).optional(), // MCPs this agent can use ("*" = all, "!item" = exclude)
  models: z.array(z.string()).optional(), // Model fallback chain for this agent (first = default)
});

// Tmux layout options
export const TmuxLayoutSchema = z.enum([
  'main-horizontal', // Main pane on top, agents stacked below
  'main-vertical', // Main pane on left, agents stacked on right
  'tiled', // All panes equal size grid
  'even-horizontal', // All panes side by side
  'even-vertical', // All panes stacked vertically
]);

export type TmuxLayout = z.infer<typeof TmuxLayoutSchema>;

// Tmux integration configuration
export const TmuxConfigSchema = z.object({
  enabled: z.boolean().default(false),
  layout: TmuxLayoutSchema.default('main-vertical'),
  main_pane_size: z.number().min(20).max(80).default(60), // percentage for main pane
});

export type TmuxConfig = z.infer<typeof TmuxConfigSchema>;

export type AgentOverrideConfig = z.infer<typeof AgentOverrideConfigSchema>;

export const PresetSchema = z.record(z.string(), AgentOverrideConfigSchema);

export type Preset = z.infer<typeof PresetSchema>;

// MCP names
export const McpNameSchema = z.enum([]);
export type McpName = z.infer<typeof McpNameSchema>;

// Background task configuration
export const BackgroundTaskConfigSchema = z.object({
  maxConcurrentStarts: z.number().min(1).max(50).default(10),
  maxModelRetries: z.number().min(1).max(10).optional(),
  retryDelayMs: z.number().min(0).max(60000).optional(),
});

export type BackgroundTaskConfig = z.infer<typeof BackgroundTaskConfigSchema>;

// Idle Orchestrator configuration
export const IdleOrchestratorConfigSchema = z.object({
  enabled: z.boolean().default(true),
  idleTimeoutMs: z.number().min(5000).max(300000).default(30000),
  minPromptIntervalMs: z.number().min(10000).max(600000).default(120000),
});

export type IdleOrchestratorConfig = z.infer<
  typeof IdleOrchestratorConfigSchema
>;

export const CodemapInjectionConfigSchema = z.object({
  enabled: z.boolean().default(true),
  maxSummaries: z.number().min(1).max(20).default(3),
  maxTokens: z.number().min(64).max(1200).default(220),
  summarizeWithLmStudio: z.boolean().default(true),
  autoEnsureModel: z.boolean().default(true),
  hfModel: z.string().default('unsloth/SmolLM2-135M-Instruct-GGUF'),
  lmStudioModel: z.string().default('smollm2-135m-instruct'),
  lmStudioBaseUrl: z.string().url().default('http://127.0.0.1:1234'),
  lmStudioApiKey: z.string().optional(),
  lmStudioTimeoutMs: z.number().min(1000).max(30000).default(6000),
  maxCodemapChars: z.number().min(2000).max(50000).default(12000),
  cacheTtl: z.number().min(1000).max(3600000).default(600000),
  triggerTools: z
    .array(z.string())
    .default(['read', 'ls', 'cd', 'grep', 'ast-grep']),
  fallback: z.enum(['truncated']).default('truncated'),
});

export type CodemapInjectionConfig = z.infer<
  typeof CodemapInjectionConfigSchema
>;

export const ModelHealthSchema = z.object({
  lastFailure: z.number().optional(), // Unix timestamp (ms) of last failure
  failureCount: z.number().min(0).default(0), // Consecutive failure count
  lastSuccess: z.number().optional(), // Unix timestamp (ms) of last success
  lastChecked: z.number().optional(), // Last health-check/probe timestamp
  disabled: z.boolean().optional(), // Model disabled due to repeated failures
});

export type ModelHealth = z.infer<typeof ModelHealthSchema>;

const AgentModelChainSchema = z.array(z.string()).min(1);

const FallbackChainsSchema = z
  .object({
    orchestrator: AgentModelChainSchema.optional(),
    oracle: AgentModelChainSchema.optional(),
    designer: AgentModelChainSchema.optional(),
    explorer: AgentModelChainSchema.optional(),
    librarian: AgentModelChainSchema.optional(),
    fixer: AgentModelChainSchema.optional(),
  })
  .catchall(AgentModelChainSchema);

export const FailoverConfigSchema = z.object({
  enabled: z.boolean().default(true),
  timeoutMs: z.number().min(1000).max(120000).default(15000),
  // Backward-compat fallback chains (legacy + CLI emitted)
  chains: FallbackChainsSchema.optional(),
  // Model health tracking (failure counts, last failure timestamps)
  triage: z.record(z.string(), ModelHealthSchema).default({}),
});

// Hang Detection Configuration
export const HangDetectionConfigSchema = z.object({
  enabled: z.boolean().default(true),
  detection: z
    .object({
      rateLimitRetryThreshold: z.number().min(1).max(20).default(5),
      sessionCreationTimeout: z.number().min(5000).max(120000).default(30000),
      inactivityTimeout: z.number().min(60000).max(600000).default(300000),
      contextLengthRetryLimit: z.number().min(1).max(10).default(3),
      providerErrorTimeout: z.number().min(1000).max(60000).default(5000),
    })
    .default({
      rateLimitRetryThreshold: 5,
      sessionCreationTimeout: 30000,
      inactivityTimeout: 300000,
      contextLengthRetryLimit: 3,
      providerErrorTimeout: 5000,
    }),
  recovery: z
    .object({
      maxAttempts: z.number().min(1).max(10).default(3),
      fallbackToAlternativeModel: z.boolean().default(true),
      sessionTerminationTimeout: z
        .number()
        .min(60000)
        .max(600000)
        .default(600000),
      enableCompaction: z.boolean().default(true),
    })
    .default({
      maxAttempts: 3,
      fallbackToAlternativeModel: true,
      sessionTerminationTimeout: 600000,
      enableCompaction: true,
    }),
  circuitBreaker: z
    .object({
      failureThreshold: z.number().min(1).max(20).default(3),
      cooldownPeriod: z.number().min(60000).max(3600000).default(3600000),
    })
    .default({
      failureThreshold: 3,
      cooldownPeriod: 3600000,
    }),
});

export type HangDetectionConfig = z.infer<typeof HangDetectionConfigSchema>;

export type FailoverConfig = z.infer<typeof FailoverConfigSchema>;

// Main plugin config - preset/presets kept for backwards compatibility but not used
export const PluginConfigSchema = z.object({
  preset: z.string().optional(),
  presets: z.record(z.string(), PresetSchema).optional(),
  agents: z.record(z.string(), AgentOverrideConfigSchema).optional(),
  disabled_mcps: z.array(z.string()).optional(),
  tmux: TmuxConfigSchema.optional(),
  background: BackgroundTaskConfigSchema.optional(),
  fallback: FailoverConfigSchema.optional(),
  hangDetection: HangDetectionConfigSchema.optional(),
  idleOrchestrator: IdleOrchestratorConfigSchema.optional(),
  codemapInjection: CodemapInjectionConfigSchema.optional(),
});

export type PluginConfig = z.infer<typeof PluginConfigSchema>;

// Agent names - re-exported from constants for convenience
export type { AgentName } from './constants';
