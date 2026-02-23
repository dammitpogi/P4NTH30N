import { type AgentDefinition, loadAgentPrompt } from './orchestrator';

export function createFixerAgent(
  model: string,
  customPrompt?: string,
  customAppendPrompt?: string,
): AgentDefinition {
  const basePrompt = loadAgentPrompt('fixer');

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
    name: 'fixer',
    description:
      'Fast implementation specialist. Receives complete context and task spec, executes code changes efficiently.',
    config: {
      model,
      temperature: 0.2,
      prompt,
    },
  };
}
