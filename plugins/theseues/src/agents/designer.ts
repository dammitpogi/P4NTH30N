import { type AgentDefinition, loadAgentPrompt } from './orchestrator';

export function createDesignerAgent(
  model: string,
  customPrompt?: string,
  customAppendPrompt?: string,
): AgentDefinition {
  const basePrompt = loadAgentPrompt('designer');

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
    name: 'designer',
    description:
      'UI/UX design and implementation. Use for styling, responsive design, component architecture and visual polish.',
    config: {
      model,
      temperature: 0.7,
      prompt,
    },
  };
}
