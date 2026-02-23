// Plugin version - single source of truth for runtime version checking
export const PLUGIN_VERSION = '0.7.4';

// Agent names
export const AGENT_ALIASES: Record<string, string> = {
  explore: 'explorer',
  'frontend-ui-ux-engineer': 'designer',
};

export const SUBAGENT_NAMES = [
  'explorer',
  'librarian',
  'oracle',
  'designer',
  'fixer',
] as const;

export const ORCHESTRATOR_NAME = 'orchestrator' as const;

export const ALL_AGENT_NAMES = [ORCHESTRATOR_NAME, ...SUBAGENT_NAMES] as const;

// Agent name type (for use in DEFAULT_MODELS)
export type AgentName = (typeof ALL_AGENT_NAMES)[number];

// Subagent delegation rules: which agents can spawn which subagents
// orchestrator: can spawn all subagents (full delegation)
// fixer: can spawn explorer (for research during implementation)
// designer: can spawn oracle (for approval) and explorer (for research)
// oracle: can spawn designer (for planning) and explorer (for research)
// explorer/librarian: cannot spawn any subagents (leaf nodes)
// Unknown agent types not listed here default to explorer-only access
export const SUBAGENT_DELEGATION_RULES: Record<AgentName, readonly string[]> = {
  orchestrator: SUBAGENT_NAMES,
  fixer: ['explorer', 'librarian'],
  designer: ['oracle'],
  oracle: ['explorer'],
  explorer: [],
  librarian: [],
};

// Default models for each agent
export const DEFAULT_MODELS: Record<AgentName, string> = {
  orchestrator: 'openrouter-free/openrouter/free',
  oracle: 'openrouter-free/openrouter/free',
  librarian: 'openrouter-free/openrouter/free',
  explorer: 'openrouter-free/openrouter/free',
  designer: 'openrouter-free/openrouter/free',
  fixer: 'openrouter-free/openrouter/free',
};

// Polling configuration
export const POLL_INTERVAL_MS = 500;
export const POLL_INTERVAL_SLOW_MS = 1000;
export const POLL_INTERVAL_BACKGROUND_MS = 2000;

// Timeouts
export const DEFAULT_TIMEOUT_MS = 2 * 60 * 1000; // 2 minutes
export const MAX_POLL_TIME_MS = 5 * 60 * 1000; // 5 minutes
export const FALLBACK_FAILOVER_TIMEOUT_MS = 15_000;

// Polling stability
export const STABLE_POLLS_THRESHOLD = 3;
