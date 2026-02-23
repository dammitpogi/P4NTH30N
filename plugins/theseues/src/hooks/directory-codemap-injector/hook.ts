import type { PluginInput } from '@opencode-ai/plugin';
import { dirname, resolve } from 'node:path';
import { log } from '../../utils/logger';
import {
  buildSummaryCacheKey,
  clearSessionCache,
  getCachedSummary,
  getSessionCache,
  setCachedSummary,
} from './cache';
import { findRelevantCodemaps } from './discovery';
import { summarizeCodemap } from './summarizer';
import { injectCodemapSummary } from './injector';
import { DEFAULT_CODEMAP_CONFIG } from './constants';

interface ToolExecuteInput {
  tool: string;
  sessionID: string;
  callID?: string;
}

interface ToolExecuteOutput {
  title: string;
  output: string;
  metadata: unknown;
}

export interface CodemapInjectorHook {
  toolExecuteAfter?: (input: ToolExecuteInput, output: ToolExecuteOutput) => Promise<void>;
  event?: (input: { event: { type: string; properties?: unknown } }) => Promise<void>;
}

export function createDirectoryCodemapInjectorHook(
  ctx: PluginInput,
  options: Partial<typeof DEFAULT_CODEMAP_CONFIG> = {}
): CodemapInjectorHook {
  const config = { ...DEFAULT_CODEMAP_CONFIG, ...options };
  const sessionCaches = new Map<string, Set<string>>();
  const triggerToolSet = new Set(config.triggerTools.map((item) => item.toLowerCase()));

  const toolExecuteAfter = async (input: ToolExecuteInput, output: ToolExecuteOutput) => {
    const toolName = input.tool.toLowerCase();
    
    // Only trigger on configured tools
    if (!triggerToolSet.has(toolName)) {
      return;
    }
    
    // Skip if injection is disabled
    if (!config.enabled) {
      return;
    }
    
    try {
      await processFilePathForCodemapInjection({
        ctx,
        sessionCaches,
        filePath: extractFilePath(output.title, output.output),
        sessionID: input.sessionID,
        output,
        config,
      });
    } catch (error) {
      // Silently fail to avoid disrupting user workflow
      const message = error instanceof Error ? error.message : String(error);
      log('[directory-codemap-injector] Error processing path', { message });
    }
  };

  return {
    toolExecuteAfter,
    event: async ({ event }: { event: { type: string; properties?: unknown } }) => {
      if (event.type !== 'session.deleted' && event.type !== 'session.compacted') {
        return;
      }

      const props = event.properties as
        | { sessionID?: string; info?: { id?: string } }
        | undefined;
      const sessionID = props?.sessionID ?? props?.info?.id;

      if (sessionID) {
        clearSessionCache(sessionCaches, sessionID);
      }
    },
  };
}

interface ProcessFilePathInput {
  ctx: PluginInput;
  sessionCaches: Map<string, Set<string>>;
  filePath: string;
  sessionID: string;
  output: { title: string; output: string; metadata: unknown };
  config: typeof DEFAULT_CODEMAP_CONFIG;
}

async function processFilePathForCodemapInjection(input: ProcessFilePathInput): Promise<void> {
  const { ctx, sessionCaches, filePath, sessionID, output, config } = input;

  if (!filePath) {
    return;
  }
  
  // Resolve the file path to an absolute path
  const resolved = resolve(ctx.directory, filePath);
  if (!resolved) {
    return;
  }
  
  const dir = dirname(resolved);
  const cache = getSessionCache(sessionCaches, sessionID);
  
  // Find relevant codemaps (current directory and ancestors)
  const codemaps = await findRelevantCodemaps(
    dir,
    config.maxSummaries,
    ctx.directory,
  );
  if (codemaps.length === 0) {
    return;
  }
  
  let dirty = false;
  
  for (const codemap of codemaps) {
    const codemapDir = codemap.directory;
    
    // Skip if already injected for this session
    if (cache.has(codemapDir)) {
      continue;
    }
    
    try {
      const cacheKey = buildSummaryCacheKey({
        codemapPath: codemap.path,
        modifiedTime: codemap.modifiedTime,
        model: config.lmStudioModel,
        maxTokens: config.maxTokens,
      });
      const cachedSummary = getCachedSummary(cacheKey, config.cacheTtl);

      let summary: string;
      let tokensUsed: number;

      if (cachedSummary) {
        summary = cachedSummary.summary;
        tokensUsed = cachedSummary.tokens;
      } else {
        const result = await summarizeCodemap(codemap.content, config);
        summary = result.summary;
        tokensUsed = result.tokens;
        setCachedSummary(cacheKey, summary, tokensUsed);
      }
      
      // Inject the summary
      await injectCodemapSummary({
        ctx,
        sessionID,
        codemapPath: codemap.path,
        codemapDir,
        summary,
        tokensUsed,
        output,
      });
      
      cache.add(codemapDir);
      dirty = true;
    } catch (error) {
      // Log error but continue with other codemaps
      const message = error instanceof Error ? error.message : String(error);
      log('[directory-codemap-injector] Failed to process codemap', {
        codemapPath: codemap.path,
        message,
      });
    }
  }

  if (!dirty) {
    return;
  }
}

function extractFilePath(title: string, output: string): string {
  const fromTaggedPath = output.match(/<path>([^<]+)<\/path>/);
  if (fromTaggedPath?.[1]) {
    return fromTaggedPath[1].trim();
  }

  return title;
}
