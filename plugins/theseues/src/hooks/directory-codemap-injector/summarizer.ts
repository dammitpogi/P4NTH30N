import {
  DEFAULT_CODEMAP_CONFIG,
  SUMMARIZATION_PROMPT_TEMPLATE,
} from './constants';

interface SummarizeResult {
  summary: string;
  tokens: number;
}

interface LmStudioResponse {
  choices?: Array<{
    message?: {
      content?: string;
    };
  }>;
}

function authHeaders(apiKey: string): Record<string, string> {
  if (!apiKey) {
    return {};
  }

  return {
    Authorization: `Bearer ${apiKey}`,
  };
}

function estimateTokens(text: string): number {
  return Math.ceil(text.length / 4);
}

function clampContent(content: string, maxChars: number): string {
  if (content.length <= maxChars) {
    return content;
  }

  return `${content.slice(0, maxChars)}\n\n[truncated]`;
}

function focusedCondense(content: string): string {
  const lines = content
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line.length > 0)
    .filter((line) => !line.startsWith('<!--'));

  const preferred: string[] = [];
  for (const line of lines) {
    if (
      line.startsWith('#') ||
      line.startsWith('##') ||
      line.startsWith('- ') ||
      line.startsWith('* ') ||
      /^\d+\./.test(line)
    ) {
      preferred.push(line);
      continue;
    }

    if (
      /responsibility|design|flow|integration|dependency|architecture|pattern|boundary/i.test(
        line,
      )
    ) {
      preferred.push(line);
    }
  }

  if (preferred.length > 0) {
    return preferred.slice(0, 60).join('\n');
  }

  return lines.slice(0, 60).join('\n');
}

export function truncateCodemap(content: string, maxTokens: number): SummarizeResult {
  const maxChars = Math.max(1, maxTokens * 4);
  const focused = focusedCondense(content);
  const summary =
    focused.length <= maxChars
      ? focused
      : `${focused.slice(0, maxChars)}\n\n[truncated]`;

  return {
    summary,
    tokens: estimateTokens(summary),
  };
}

export async function summarizeCodemap(
  content: string,
  config: Partial<typeof DEFAULT_CODEMAP_CONFIG>,
): Promise<SummarizeResult> {
  const maxTokens = config.maxTokens ?? DEFAULT_CODEMAP_CONFIG.maxTokens;

  if (!config.summarizeWithLmStudio) {
    return truncateCodemap(content, maxTokens);
  }

  const maxCodemapChars =
    config.maxCodemapChars ?? DEFAULT_CODEMAP_CONFIG.maxCodemapChars;
  const lmStudioTimeoutMs =
    config.lmStudioTimeoutMs ?? DEFAULT_CODEMAP_CONFIG.lmStudioTimeoutMs;
  const lmStudioBaseUrl =
    config.lmStudioBaseUrl ?? DEFAULT_CODEMAP_CONFIG.lmStudioBaseUrl;
  const lmStudioModel =
    config.lmStudioModel ?? DEFAULT_CODEMAP_CONFIG.lmStudioModel;

  const codemapInput = clampContent(content, maxCodemapChars);

  const controller = new AbortController();
  const timeout = setTimeout(() => {
    controller.abort();
  }, lmStudioTimeoutMs);

  try {
    const response = await fetch(`${lmStudioBaseUrl}/v1/chat/completions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...authHeaders(config.lmStudioApiKey ?? ''),
      },
      signal: controller.signal,
      body: JSON.stringify({
        model: lmStudioModel,
        temperature: 0.1,
        max_tokens: maxTokens,
        messages: [
          {
            role: 'system',
            content: SUMMARIZATION_PROMPT_TEMPLATE,
          },
          {
            role: 'user',
            content: codemapInput,
          },
        ],
      }),
    });

    if (!response.ok) {
      throw new Error(`LM Studio request failed with status ${response.status}`);
    }

    const json = (await response.json()) as LmStudioResponse;
    const summary = json.choices?.[0]?.message?.content?.trim();

    if (!summary) {
      throw new Error('LM Studio returned empty summary');
    }

    return {
      summary,
      tokens: estimateTokens(summary),
    };
  } catch {
    return truncateCodemap(content, maxTokens);
  } finally {
    clearTimeout(timeout);
  }
}
