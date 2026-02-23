import * as fs from 'node:fs';
import * as os from 'node:os';
import * as path from 'node:path';

import type { AgentConfig as SDKAgentConfig } from '@opencode-ai/sdk';

import {
  type AgentOverrideConfig,
  DEFAULT_MODELS,
  getAgentOverride,
  type ModelHealth,
  type PluginConfig,
  SUBAGENT_NAMES,
} from '../config';
import { getAgentMcpList } from '../config/agent-mcps';

import { createDesignerAgent } from './designer';
import { createExplorerAgent } from './explorer';
import { createFixerAgent } from './fixer';
import { createLibrarianAgent } from './librarian';
import { createOracleAgent } from './oracle';
import { type AgentDefinition, createOrchestratorAgent } from './orchestrator';

export type { AgentDefinition } from './orchestrator';

type AgentFactory = (
  model: string,
  customPrompt?: string,
  customAppendPrompt?: string,
) => AgentDefinition;

const CIRCUIT_BREAKER_THRESHOLD = 3;
const CIRCUIT_BREAKER_COOLDOWN_MS = 3600000;

interface WorkingModelsSnapshot {
  models?: Record<
    string,
    { lastVerified?: number; successCount?: number; failureCount?: number }
  >;
}

function isGoogleModel(modelId: string): boolean {
  return modelId.startsWith('google/') || modelId.startsWith('google-vertex/');
}

function loadWorkingModels(): WorkingModelsSnapshot | null {
  try {
    const proposalsDir = path.join(
      os.homedir(),
      '.config',
      'opencode',
      'skills',
      'update-agent-models',
      'proposals',
    );
    if (!fs.existsSync(proposalsDir)) return null;

    const files = fs
      .readdirSync(proposalsDir)
      .filter((f) => f.startsWith('working_models.') && f.endsWith('.json'))
      .sort()
      .reverse();

    if (files.length === 0) return null;

    const latestFile = path.join(proposalsDir, files[0]);
    const content = fs.readFileSync(latestFile, 'utf8');
    return JSON.parse(content) as WorkingModelsSnapshot;
  } catch {
    return null;
  }
}

function isModelHealthy(
  modelId: string,
  triage: Record<string, ModelHealth> | undefined,
  workingModels: WorkingModelsSnapshot | null,
): boolean {
  const isVerified = workingModels?.models?.[modelId] != null;
  if (workingModels && !isVerified) {
    return false;
  }

  if (!triage) return true;
  const health = triage[modelId];
  if (!health || !health.lastFailure) return true;
  if ((health.failureCount ?? 0) >= CIRCUIT_BREAKER_THRESHOLD) {
    const ageMs =
      Date.now() - Math.max(health.lastFailure, health.lastChecked ?? 0);
    if (ageMs < CIRCUIT_BREAKER_COOLDOWN_MS) return false;
  }
  return true;
}

function selectHealthyModel(
  agentName: string,
  config: PluginConfig | undefined,
): string {
  const override = getAgentOverride(config, agentName);
  const chain = override?.models ?? [];
  const currentModel = override?.currentModel;
  const triage = config?.fallback?.triage;
  const workingModels = loadWorkingModels();

  const allCandidates = [...new Set([currentModel, ...chain].filter(Boolean))];
  for (const model of allCandidates) {
    if (!model) continue;
    if (isModelHealthy(model, triage, workingModels)) {
      return model;
    }
  }
  return (
    DEFAULT_MODELS[agentName as keyof typeof DEFAULT_MODELS] ??
    currentModel ??
    allCandidates[0] ??
    'opencode/gpt-5-nano'
  );
}

// Agent Configuration Helpers

/**
 * Apply user-provided overrides to an agent's configuration.
 * Supports overriding model and temperature.
 */
function applyOverrides(
  agent: AgentDefinition,
  override: AgentOverrideConfig,
): void {
  if (override.currentModel) agent.config.model = override.currentModel;
  if (override.temperature !== undefined)
    agent.config.temperature = override.temperature;
}

// Agent Classification

export type SubagentName = (typeof SUBAGENT_NAMES)[number];

export function isSubagent(name: string): name is SubagentName {
  return (SUBAGENT_NAMES as readonly string[]).includes(name);
}

// Agent Factories

const SUBAGENT_FACTORIES: Record<SubagentName, AgentFactory> = {
  explorer: createExplorerAgent,
  librarian: createLibrarianAgent,
  oracle: createOracleAgent,
  designer: createDesignerAgent,
  fixer: createFixerAgent,
};

// Public API

/**
 * Create all agent definitions with optional configuration overrides.
 * Instantiates the orchestrator and all subagents, applying user config and defaults.
 *
 * @param config - Optional plugin configuration with agent overrides
 * @returns Array of agent definitions (orchestrator first, then subagents)
 */
export function createAgents(config?: PluginConfig): AgentDefinition[] {
  const getModelForAgent = (name: SubagentName): string => {
    return selectHealthyModel(name, config);
  };

  // 1. Gather all sub-agent definitions
  const protoSubAgents = (
    Object.entries(SUBAGENT_FACTORIES) as [SubagentName, AgentFactory][]
  ).map(([name, factory]) => {
    return factory(getModelForAgent(name));
  });

  // 2. Apply overrides to each agent
  const allSubAgents = protoSubAgents.map((agent) => {
    const override = getAgentOverride(config, agent.name);
    if (override) {
      applyOverrides(agent, override);
    }
    return agent;
  });

  // 3. Create Orchestrator (with circuit breaker filtering)
  const orchestratorModel = selectHealthyModel('orchestrator', config);
  const orchestrator = createOrchestratorAgent(orchestratorModel);
  const oOverride = getAgentOverride(config, 'orchestrator');
  if (oOverride) {
    applyOverrides(orchestrator, oOverride);
  }

  return [orchestrator, ...allSubAgents];
}

/**
 * Get agent configurations formatted for the OpenCode SDK.
 * Converts agent definitions to SDK config format and applies classification metadata.
 *
 * @param config - Optional plugin configuration with agent overrides
 * @returns Record mapping agent names to their SDK configurations
 */
export function getAgentConfigs(
  config?: PluginConfig,
): Record<string, SDKAgentConfig> {
  const agents = createAgents(config);
  return Object.fromEntries(
    agents.map((a) => {
      const sdkConfig: SDKAgentConfig & { mcps?: string[] } = {
        ...a.config,
        description: a.description,
        mcps: getAgentMcpList(a.name, config),
      };

      // Apply classification-based visibility and mode
      if (isSubagent(a.name)) {
        sdkConfig.mode = 'subagent';
      } else if (a.name === 'orchestrator') {
        sdkConfig.mode = 'primary';
      }

      return [a.name, sdkConfig];
    }),
  );
}
