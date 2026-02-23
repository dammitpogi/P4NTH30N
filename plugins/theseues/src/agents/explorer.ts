import { type AgentDefinition, loadAgentPrompt } from './orchestrator';

export function createExplorerAgent(
  model: string,
  customPrompt?: string,
  customAppendPrompt?: string,
): AgentDefinition {
  const basePrompt = loadAgentPrompt('explorer');

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
    name: 'explorer',
    description:
      "Fast codebase search and pattern matching. Use for finding files, locating code patterns, and answering 'where is X?' questions.",
    config: {
      model,
      temperature: 0.1,
      prompt,
    },
  };
}
