import type { PluginInput } from '@opencode-ai/plugin';
import { log } from '../../utils/logger';

async function getTodoStorePath(sessionID: string): Promise<string> {
  const os = await import('node:os');
  const path = await import('node:path');
  return path.join(
    os.homedir(),
    '.config',
    'opencode',
    'session-todos',
    `${sessionID}.json`,
  );
}

async function persistTodos(sessionID: string, todos: TodoItem[]): Promise<void> {
  try {
    const fs = await import('node:fs/promises');
    const path = await import('node:path');
    const filePath = await getTodoStorePath(sessionID);
    await fs.mkdir(path.dirname(filePath), { recursive: true });
    await fs.writeFile(
      filePath,
      JSON.stringify({ sessionID, todos, savedAt: Date.now() }, null, 2),
      'utf-8',
    );
  } catch (error) {
    const msg = error instanceof Error ? error.message : String(error);
    log('[background-followup] failed to persist todos', { sessionID, error: msg });
  }
}

async function loadPersistedTodos(sessionID: string): Promise<TodoItem[] | null> {
  try {
    const fs = await import('node:fs/promises');
    const filePath = await getTodoStorePath(sessionID);
    const raw = await fs.readFile(filePath, 'utf-8');
    const parsed = JSON.parse(raw) as { todos?: unknown };
    const todos = parseTodos(parsed);
    return todos.length > 0 ? todos : [];
  } catch {
    return null;
  }
}

type TodoItem = {
  content: string;
  status: string;
  priority: string;
};

type ToolExecuteBeforeInput = {
  tool: string;
  sessionID?: string;
  callID?: string;
};

type ToolExecuteBeforeOutput = {
  args?: unknown;
};

type ToolExecuteAfterInput = {
  tool: string;
  sessionID?: string;
  callID?: string;
};

type ToolExecuteAfterOutput = {
  output?: string;
};

interface PendingCall {
  tool: string;
  sessionID: string;
  args: unknown;
}

const FOLLOWUP_TIMER_MS = 60000;
const FOLLOWUP_PROMPT =
  'Continue working on tasks. I will notify you of results.';

function normalizeToolName(tool: string): string {
  return tool.trim().toLowerCase();
}

function looksLikeError(outputText: string): boolean {
  const text = outputText.trim();
  if (!text) return false;
  return /^error\b|^\[error\]/i.test(text);
}

function parseTodos(args: unknown): TodoItem[] {
  if (!args || typeof args !== 'object') return [];
  const rawTodos = (args as { todos?: unknown }).todos;
  if (!Array.isArray(rawTodos)) return [];

  const parsed: TodoItem[] = [];
  for (const raw of rawTodos) {
    if (!raw || typeof raw !== 'object') continue;
    const content = (raw as { content?: unknown }).content;
    const status = (raw as { status?: unknown }).status;
    const priority = (raw as { priority?: unknown }).priority;
    if (typeof content !== 'string') continue;
    parsed.push({
      content,
      status: typeof status === 'string' ? status : 'pending',
      priority: typeof priority === 'string' ? priority : 'medium',
    });
  }

  return parsed;
}

function formatTodoList(todos: TodoItem[]): string {
  if (todos.length === 0) {
    return '- (No todo list recorded yet for this session)';
  }

  return todos
    .map((todo, index) => {
      return `${index + 1}. [${todo.status} | ${todo.priority}] ${todo.content}`;
    })
    .join('\n');
}

function buildFollowupPrompt(todos: TodoItem[]): string {
  return `${FOLLOWUP_PROMPT}\n\n\nSession todo list:\n${formatTodoList(todos)}`;
}

export function createBackgroundFollowupHook(ctx: PluginInput) {
  const pendingByCallId = new Map<string, PendingCall>();
  const todosBySessionId = new Map<string, TodoItem[]>();
  const reminderTimers = new Map<string, ReturnType<typeof setTimeout>>();

  async function sendFollowupPrompt(sessionID: string): Promise<void> {
    reminderTimers.delete(sessionID);

    let todos = todosBySessionId.get(sessionID);
    if (!todos) {
      const persisted = await loadPersistedTodos(sessionID);
      if (persisted) {
        todosBySessionId.set(sessionID, persisted);
        todos = persisted;
      }
    }

    const resolvedTodos = todos ?? [];
    const text = buildFollowupPrompt(resolvedTodos);

    try {
      await ctx.client.session.promptAsync({
        path: { id: sessionID },
        body: { parts: [{ type: 'text' as const, text }] },
      });
      log('[background-followup] sent follow-up prompt', {
        sessionID,
        todoCount: resolvedTodos.length,
      });
    } catch (error) {
      const msg = error instanceof Error ? error.message : String(error);
      log('[background-followup] failed to send follow-up prompt', {
        sessionID,
        error: msg,
      });
    }
  }

  function resetReminderTimer(sessionID: string): void {
    const existing = reminderTimers.get(sessionID);
    if (existing) {
      clearTimeout(existing);
    }

    const timer = setTimeout(() => {
      void sendFollowupPrompt(sessionID);
    }, FOLLOWUP_TIMER_MS);

    reminderTimers.set(sessionID, timer);
    log('[background-followup] reset background follow-up timer', {
      sessionID,
      timeoutMs: FOLLOWUP_TIMER_MS,
    });
  }

  return {
    'tool.execute.before': async (
      input: ToolExecuteBeforeInput,
      output: ToolExecuteBeforeOutput,
    ) => {
      const callID = input.callID;
      const sessionID = input.sessionID;
      if (!callID || !sessionID) return;

      const toolName = normalizeToolName(input.tool ?? '');
      if (toolName !== 'todowrite' && toolName !== 'background_task') return;

      pendingByCallId.set(callID, {
        tool: toolName,
        sessionID,
        args: output.args,
      });
    },

    'tool.execute.after': async (
      input: ToolExecuteAfterInput,
      output: ToolExecuteAfterOutput,
    ) => {
      const callID = input.callID;
      if (!callID) return;

      const pending = pendingByCallId.get(callID);
      if (!pending) return;
      pendingByCallId.delete(callID);

      const outputText = typeof output.output === 'string' ? output.output : '';
      if (looksLikeError(outputText)) return;

      if (pending.tool === 'todowrite') {
        const todos = parseTodos(pending.args);
        todosBySessionId.set(pending.sessionID, todos);
        await persistTodos(pending.sessionID, todos);
        log('[background-followup] saved session todo list', {
          sessionID: pending.sessionID,
          todoCount: todos.length,
        });
        return;
      }

      if (pending.tool === 'background_task') {
        resetReminderTimer(pending.sessionID);
      }
    },
  };
}
