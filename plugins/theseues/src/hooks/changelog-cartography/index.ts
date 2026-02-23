import type { PluginInput } from '@opencode-ai/plugin';
import type { BackgroundTaskManager } from '../../background/background-manager';
import { log } from '../../utils/logger';

type ToolExecuteBeforeInput = {
  tool: string;
  sessionID: string;
  callID: string;
};

type ToolExecuteBeforeOutput = {
  args: any;
};

type ToolExecuteAfterInput = {
  tool: string;
  sessionID: string;
  callID: string;
};

type ToolExecuteAfterOutput = {
  title: string;
  output: string;
  metadata: any;
};

type SessionStatusEvent = {
  type: string;
  properties?: { sessionID?: string; status?: { type: string } };
};

interface PendingToolChange {
  tool: string;
  args: unknown;
  recordedAt: number;
  filePaths: string[];
}

interface ChangelogCartographyState {
  pendingByCallId: Map<string, PendingToolChange>;
  changedFiles: Set<string>;
  lastPromptAt: number;
  awaitingCartographyUpdate: boolean;
  lastPromptedSnapshotKey?: string;
  mainSessionCache: Map<string, boolean>;
}

const DEFAULT_MIN_PROMPT_INTERVAL_MS = 30_000;

function normalizeToolName(tool: string): string {
  return tool.trim().toLowerCase();
}

function looksLikeError(outputText: string): boolean {
  const t = outputText.trim();
  if (!t) return false;
  return /^error\b|^\[error\]/i.test(t);
}

function shouldIgnoreFilePath(filePath: string): boolean {
  const p = filePath.replace(/\\/g, '/');
  if (p.endsWith('/codemap.md') || p === 'codemap.md') return true;
  if (p.includes('/.theseues/')) return true;
  return false;
}

function uniqKeepOrder(values: string[]): string[] {
  const seen = new Set<string>();
  const out: string[] = [];
  for (const v of values) {
    if (seen.has(v)) continue;
    seen.add(v);
    out.push(v);
  }
  return out;
}

function extractFilePathsFromArgs(toolName: string, args: any): string[] {
  const t = normalizeToolName(toolName);

  if (t === 'write' || t === 'edit') {
    const fp =
      (typeof args?.filePath === 'string' && args.filePath) ||
      (typeof args?.path === 'string' && args.path);
    return fp ? [fp] : [];
  }

  // Apply-patch style tool: parse patch headers.
  if (t === 'apply_patch' || t === 'apply-patch' || t === 'applypatch') {
    const patchText =
      (typeof args?.patchText === 'string' && args.patchText) ||
      (typeof args?.patch === 'string' && args.patch) ||
      '';
    if (!patchText) return [];

    const paths: string[] = [];
    for (const line of patchText.split(/\r?\n/)) {
      const m = line.match(/^\*\*\* (Add File|Update File|Delete File): (.+)$/);
      if (m?.[2]) paths.push(m[2].trim());
    }
    return paths;
  }

  return [];
}

function isCartographyUpdateCommand(toolName: string, args: any): boolean {
  const t = normalizeToolName(toolName);
  if (t !== 'bash') return false;

  const cmd = typeof args?.command === 'string' ? args.command : '';
  return cmd.includes('cartographer.py') && /\bupdate\b/.test(cmd);
}

async function isMainSession(ctx: PluginInput, sessionId: string): Promise<boolean> {
  try {
    const sessionResult = await ctx.client.session.get({
      path: { id: sessionId },
    });
    const parentID = (sessionResult.data as { parentID?: string })?.parentID;
    return !parentID;
  } catch {
    // If we cannot verify, assume it's main (consistent with idle-orchestrator).
    return true;
  }
}

function snapshotKey(files: string[]): string {
  return files.slice().sort().join('\n');
}

function buildPrompt(files: string[]): string {
  const sorted = files.slice().sort();
  const MAX_FILES = 80;
  const shown = sorted.slice(0, MAX_FILES);
  const omitted = sorted.length - shown.length;
  const bulletList = shown.map((f) => `- ${f}`).join('\n');
  const omittedLine = omitted > 0 ? `\n- ... (${omitted} more)` : '';
  return `run cartography. The following files have been updated:\n\n${bulletList}${omittedLine}\n\nInstructions:\n- Delegate to exactly one Librarian to run the cartography skill workflow.\n- Update codemaps per affected directory (use cartographer.py changes/update and update the root atlas if needed).\n- When cartography is complete, ensure cartographer.py update has been run.`;
}

export function createChangelogCartographyHook(
  ctx: PluginInput,
  backgroundManager: BackgroundTaskManager,
  options?: { minPromptIntervalMs?: number },
) {
  const state: ChangelogCartographyState = {
    pendingByCallId: new Map(),
    changedFiles: new Set(),
    lastPromptAt: 0,
    awaitingCartographyUpdate: false,
    mainSessionCache: new Map(),
  };

  const minPromptIntervalMs =
    options?.minPromptIntervalMs ?? DEFAULT_MIN_PROMPT_INTERVAL_MS;

  async function maybePrompt(sessionId: string): Promise<void> {
    if (state.changedFiles.size === 0) return;
    if (backgroundManager.hasActiveTasks()) return;

    const now = Date.now();
    if (now - state.lastPromptAt < minPromptIntervalMs) return;

    const files = Array.from(state.changedFiles.values());
    const key = snapshotKey(files);
    if (state.lastPromptedSnapshotKey === key && state.awaitingCartographyUpdate) {
      // Already asked for this snapshot; wait for cartography completion.
      return;
    }

    const prompt = buildPrompt(files);
    try {
      await ctx.client.session.promptAsync({
        path: { id: sessionId },
        body: { parts: [{ type: 'text' as const, text: prompt }] },
      });
      state.lastPromptAt = now;
      state.awaitingCartographyUpdate = true;
      state.lastPromptedSnapshotKey = key;
      log('[changelog-cartography] prompted orchestrator to run cartography', {
        sessionId,
        fileCount: files.length,
      });
    } catch (error) {
      const msg = error instanceof Error ? error.message : String(error);
      log('[changelog-cartography] failed to prompt orchestrator', {
        sessionId,
        error: msg,
      });
    }
  }

  return {
    event: async ({ event }: { event: SessionStatusEvent }) => {
      if (event.type !== 'session.status') return;
      const sessionId = event.properties?.sessionID;
      const statusType = event.properties?.status?.type;
      if (!sessionId || statusType !== 'idle') return;

      // Only prompt on main sessions (not background tasks).
      // Cache decisions to avoid extra API calls.
      const cached = state.mainSessionCache.get(sessionId);
      if (cached === false) return;
      if (cached === undefined) {
        const ok = await isMainSession(ctx, sessionId);
        state.mainSessionCache.set(sessionId, ok);
        if (!ok) return;
      }

      await maybePrompt(sessionId);
    },

    'tool.execute.before': async (input: ToolExecuteBeforeInput, output: ToolExecuteBeforeOutput) => {
      const toolName = input.tool;
      const args = output.args;
      const filePathsRaw = extractFilePathsFromArgs(toolName, args);
      const filePaths = uniqKeepOrder(filePathsRaw).filter(
        (p) => p && !shouldIgnoreFilePath(p),
      );
      if (filePaths.length === 0 && !isCartographyUpdateCommand(toolName, args)) {
        return;
      }

      state.pendingByCallId.set(input.callID, {
        tool: toolName,
        args,
        recordedAt: Date.now(),
        filePaths,
      });
    },

    'tool.execute.after': async (input: ToolExecuteAfterInput, output: ToolExecuteAfterOutput) => {
      const pending = state.pendingByCallId.get(input.callID);
      if (!pending) return;
      state.pendingByCallId.delete(input.callID);

      // If this was cartography update, treat it as completion signal.
      if (isCartographyUpdateCommand(pending.tool, pending.args)) {
        if (!looksLikeError(output.output)) {
          state.changedFiles.clear();
          state.awaitingCartographyUpdate = false;
          state.lastPromptedSnapshotKey = undefined;
          log('[changelog-cartography] cartography update detected; changelog cleared');
        }
        return;
      }

      if (pending.filePaths.length === 0) return;
      if (looksLikeError(output.output)) return;

      for (const p of pending.filePaths) {
        state.changedFiles.add(p);
      }
      log('[changelog-cartography] file changes recorded', {
        tool: pending.tool,
        fileCount: pending.filePaths.length,
      });
    },
  };
}

export type { ChangelogCartographyState };
