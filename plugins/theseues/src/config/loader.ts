import * as fs from 'node:fs';
import * as os from 'node:os';
import * as path from 'node:path';
import { stripJsonComments } from '../cli/config-io';
import { ALL_AGENT_NAMES, DEFAULT_MODELS } from './constants';
import { type PluginConfig, PluginConfigSchema } from './schema';
import { log } from '../utils/logger';

const PROMPTS_DIR_NAME = 'agents';

/**
 * Get the user's configuration directory following XDG Base Directory specification.
 * Falls back to ~/.config if XDG_CONFIG_HOME is not set.
 *
 * @returns The absolute path to the user's config directory
 */
function getUserConfigDir(): string {
  return process.env.XDG_CONFIG_HOME || path.join(os.homedir(), '.config');
}

/**
 * Load and validate plugin configuration from a specific file path.
 * Supports both .json and .jsonc formats (JSON with comments).
 * Returns null if the file doesn't exist, is invalid, or cannot be read.
 * Logs warnings for validation errors and unexpected read errors.
 *
 * @param configPath - Absolute path to the config file
 * @returns Validated config object, or null if loading failed
 */
function loadConfigFromPath(configPath: string): PluginConfig | null {
  try {
    const content = fs.readFileSync(configPath, 'utf-8');
    // Use stripJsonComments to support JSONC format (comments and trailing commas)
    const rawConfig = normalizeRawConfig(JSON.parse(stripJsonComments(content)));
    
    const result = PluginConfigSchema.safeParse(rawConfig);

    if (!result.success) {
      console.warn(`[oh-my-opencode-theseus] Invalid config at ${configPath}:`);
      console.warn(result.error.format());
      return null;
    }

    return result.data;
  } catch (error) {
    // Log the error type and message for debugging
    const errorMessage = error instanceof Error ? error.message : String(error);
    console.warn(
      `[oh-my-opencode-theseus] Error parsing config from ${configPath}: ${errorMessage}`,
    );
    return null;
  }
}

function normalizeRawConfig(raw: unknown): unknown {
  if (!raw || typeof raw !== 'object') {
    return raw;
  }

  const cfg = raw as Record<string, unknown>;

  // Migrate agents.<name>.model -> agents.<name>.currentModel
  if (cfg.agents && typeof cfg.agents === 'object') {
    const migratedAgents: Record<string, unknown> = {};
    for (const [agentName, value] of Object.entries(
      cfg.agents as Record<string, unknown>,
    )) {
      if (!value || typeof value !== 'object') {
        migratedAgents[agentName] = value;
        continue;
      }

      const agentConfig = { ...(value as Record<string, unknown>) };
      if (
        typeof agentConfig.model === 'string' &&
        typeof agentConfig.currentModel !== 'string'
      ) {
        agentConfig.currentModel = agentConfig.model;
      }
      delete agentConfig.model;
      migratedAgents[agentName] = agentConfig;
    }
    cfg.agents = migratedAgents;
  }

  return cfg;
}

/**
 * Find existing config file path, preferring .jsonc over .json.
 * Checks for .jsonc first, then falls back to .json.
 *
 * @param basePath - Base path without extension (e.g., /path/to/oh-my-opencode-theseus)
 * @returns Path to existing config file, or null if neither exists
 */
function findConfigPath(basePath: string): string | null {
  const jsoncPath = `${basePath}.jsonc`;
  const jsonPath = `${basePath}.json`;

  // Prefer .jsonc over .json
  if (fs.existsSync(jsoncPath)) {
    return jsoncPath;
  }
  if (fs.existsSync(jsonPath)) {
    return jsonPath;
  }
  return null;
}

/**
 * Recursively merge two objects, with override values taking precedence.
 * For nested objects, merges recursively. For arrays and primitives, override replaces base.
 *
 * @param base - Base object to merge into
 * @param override - Override object whose values take precedence
 * @returns Merged object, or undefined if both inputs are undefined
 */
function deepMerge<T extends Record<string, unknown>>(
  base?: T,
  override?: T,
): T | undefined {
  if (!base) return override;
  if (!override) return base;

  const result = { ...base } as T;
  for (const key of Object.keys(override) as (keyof T)[]) {
    const baseVal = base[key];
    const overrideVal = override[key];

    if (
      typeof baseVal === 'object' &&
      baseVal !== null &&
      typeof overrideVal === 'object' &&
      overrideVal !== null &&
      !Array.isArray(baseVal) &&
      !Array.isArray(overrideVal)
    ) {
      result[key] = deepMerge(
        baseVal as Record<string, unknown>,
        overrideVal as Record<string, unknown>,
      ) as T[keyof T];
    } else {
      result[key] = overrideVal;
    }
  }
  return result;
}

/**
 * Load plugin configuration from user and project config files, merging them appropriately.
 *
 * Configuration is loaded from two locations:
 * 1. User config: ~/.config/opencode/oh-my-opencode-theseus.jsonc or .json (or $XDG_CONFIG_HOME)
 * 2. Project config: <directory>/.opencode/oh-my-opencode-theseus.jsonc or .json
 *
 * JSONC format is preferred over JSON (allows comments and trailing commas).
 * Project config takes precedence over user config. Nested objects (agents, tmux) are
 * deep-merged, while top-level arrays are replaced entirely by project config.
 *
 * @param directory - Project directory to search for .opencode config
 * @returns Merged plugin configuration (empty object if no configs found)
 */
export function loadPluginConfig(directory: string): PluginConfig {
  // Always use the user config directory for plugin config
  // The plugin config should come from the user's home directory, not from the project
  const userConfigBasePath = path.join(
    os.homedir(),
    '.config',
    'opencode',
    'oh-my-opencode-theseus',
  );

  // Also check the project directory as fallback
  const projectConfigBasePath = path.join(
    directory,
    '.opencode',
    'oh-my-opencode-theseus',
  );

  // Find existing config files (preferring .jsonc over .json)
  const userConfigPath = findConfigPath(userConfigBasePath);
  const projectConfigPath = findConfigPath(projectConfigBasePath);

  log('[config-loader] User home:', os.homedir());
  log('[config-loader] User config path:', userConfigPath);
  log('[config-loader] Project config path:', projectConfigPath);

  // Check if config files exist - warn if neither user nor project config found
  if (!userConfigPath && !projectConfigPath) {
    console.warn(
      '[oh-my-opencode-theseus] WARNING: No config file found! Expected at:\n' +
      `  - ${userConfigBasePath}.jsonc\n` +
      `  - ${userConfigBasePath}.json\n` +
      'Falling back to defaults. Create a config file to customize the plugin.',
    );
  }

  let config: PluginConfig = userConfigPath
    ? (loadConfigFromPath(userConfigPath) ?? {})
    : {};

  // Log successful config load
  if (userConfigPath || projectConfigPath) {
    const loadedFrom = projectConfigPath ? 'project' : 'user';
    log(`[config-loader] Config loaded from ${loadedFrom} config.`);
  }

  log('[config-loader] Config loaded:', { 
    hasAgents: !!config?.agents, 
    hasFallback: !!config?.fallback 
  });
 
  const projectConfig = projectConfigPath
    ? loadConfigFromPath(projectConfigPath)
    : null;
  if (projectConfig) {
    const mergedAgents = deepMerge(config.agents, projectConfig.agents);
    const mergedFallback = deepMerge(config.fallback, projectConfig.fallback);
    config = {
      ...config,
      ...projectConfig,
      agents: mergedAgents,
      tmux: deepMerge(config.tmux, projectConfig.tmux),
      fallback: mergedFallback,
    };
  }

  // Ensure all agents have a currentModel populated from defaults if missing
  if (!config.agents) {
    config.agents = {};
  }

  for (const agentName of ALL_AGENT_NAMES) {
    if (!config.agents[agentName]) {
      config.agents[agentName] = {};
    }
    if (!config.agents[agentName].currentModel) {
      config.agents[agentName].currentModel = DEFAULT_MODELS[agentName];
      log(`[config-loader] Populated default model for ${agentName}: ${DEFAULT_MODELS[agentName]}`);
    }
  }

  // Preset system removed - use DEFAULT_MODELS from constants instead
  // This ensures user config (opencode.json) is the source of truth

  return config;
}
