import { type AgentDefinition, loadAgentPrompt } from './orchestrator';

export function createLibrarianAgent(
  model: string,
  customPrompt?: string,
  customAppendPrompt?: string,
): AgentDefinition {
  const basePrompt = loadAgentPrompt('librarian');

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
    name: 'librarian',
    description:
      'External documentation and library research. Use for official docs lookup, GitHub examples, and understanding library internals.',
    config: {
      model,
      temperature: 0.1,
      prompt,
    },
  };
}
