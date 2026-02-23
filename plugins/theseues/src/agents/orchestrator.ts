import { readFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';

import type { AgentConfig } from '@opencode-ai/sdk';

import { log } from '../utils/logger';

export interface AgentDefinition {
  name: string;
  description?: string;
  config: AgentConfig;
}

/**
 * Load an agent prompt from ~/.config/opencode/agents/{agentName}.md
 * Returns the file contents if readable, empty string otherwise.
 */
export function loadAgentPrompt(agentName: string): string {
  const promptPath = join(
    homedir(),
    '.config',
    'opencode',
    'agents',
    `${agentName}.md`,
  );
  try {
    const content = readFileSync(promptPath, 'utf-8');
    log(`[agent-prompt] Loaded prompt for ${agentName} from ${promptPath}`);
    return content;
  } catch {
    log(
      `[agent-prompt] No prompt file for ${agentName} at ${promptPath}, using empty`,
    );
    return '';
  }
}

export function createOrchestratorAgent(
  model: string,
  customPrompt?: string,
  customAppendPrompt?: string,
): AgentDefinition {
  const basePrompt = loadAgentPrompt('orchestrator');

  let prompt: string;
  if (customPrompt) {
    prompt = customPrompt;
  } else if (customAppendPrompt) {
    prompt = basePrompt
      ? `${basePrompt}\n\n${customAppendPrompt}`
      : customAppendPrompt;
  } else {
    prompt = basePrompt;
  }

  return {
    name: 'orchestrator',
    description:
      'AI coding orchestrator that delegates tasks to specialist agents for optimal quality, speed, and cost',
    config: {
      model,
      temperature: 0.1,
      prompt,
    },
  };
}
