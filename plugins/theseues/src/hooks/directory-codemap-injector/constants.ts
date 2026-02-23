/**
 * Constants for directory codemap injection system
 */

export const CODEMAP_INJECTION_CONFIG_KEY = 'codemapInjection';

export const DEFAULT_CODEMAP_CONFIG = {
  enabled: true,
  maxSummaries: 3,
  maxTokens: 220,
  summarizeWithLmStudio: true,
  autoEnsureModel: true,
  hfModel: 'unsloth/SmolLM2-135M-Instruct-GGUF',
  lmStudioModel: 'smollm2-135m-instruct',
  lmStudioBaseUrl: 'http://127.0.0.1:1234',
  lmStudioApiKey: process.env.LM_STUDIO_API_KEY ?? '',
  lmStudioTimeoutMs: 6000,
  maxCodemapChars: 12000,
  cacheTtl: 10 * 60 * 1000, // 10 minutes
  triggerTools: ['Read', 'read', 'Ls', 'ls', 'Cd', 'cd', 'Grep', 'grep', 'AstGrep', 'ast-grep'],
  fallback: 'truncated' as const,
};

export const CODEMAP_FILENAME = 'codemap.md';

export const SESSION_CACHE_PREFIX = 'codemap-injection:';

export const CACHE_KEY_DELIMITER = '::';

export const INJECTION_MARKER_START = '\n\n---\n📋 **Project Context - Code Map**\n\n';
export const INJECTION_MARKER_END = '\n\n---';

export const SUMMARIZATION_PROMPT_TEMPLATE =
  'Summarize this codemap for an AI coding agent. Focus only on what helps make edits safely: module responsibility, critical files, boundaries, dependencies, data/control flow, and gotchas. Keep concise and factual.';
