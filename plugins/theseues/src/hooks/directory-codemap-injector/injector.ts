import type { PluginInput } from '@opencode-ai/plugin';
import { relative } from 'node:path';
import { INJECTION_MARKER_END, INJECTION_MARKER_START } from './constants';

interface InjectInput {
  ctx: PluginInput;
  sessionID: string;
  codemapPath: string;
  codemapDir: string;
  summary: string;
  tokensUsed: number;
  output: {
    title: string;
    output: string;
    metadata: unknown;
  };
}

export async function injectCodemapSummary(input: InjectInput): Promise<void> {
  const relativePath = relative(input.ctx.directory, input.codemapPath).replace(
    /\\/g,
    '/',
  );
  const relativeDir = relative(input.ctx.directory, input.codemapDir).replace(
    /\\/g,
    '/',
  );

  const locationLabel = relativeDir.length > 0 ? relativeDir : '.';

  input.output.output +=
    `${INJECTION_MARKER_START}` +
    `Path: ${relativePath}\n` +
    `Scope: ${locationLabel}\n` +
    `Tokens: ~${input.tokensUsed}\n\n` +
    `${input.summary}` +
    `${INJECTION_MARKER_END}`;
}
