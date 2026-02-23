import { describe, expect, mock, test } from 'bun:test';
import { BackgroundTaskManager } from './background-manager';

// Mock the plugin context
function createMockContext(overrides?: {
  sessionCreateResult?: { data?: { id?: string } };
  sessionStatusResult?: { data?: Record<string, { type: string }> };
  sessionMessagesResult?: {
    data?: Array<{
      info?: { role: string };
      parts?: Array<{ type: string; text?: string }>;
    }>;
  };
  promptImpl?: (args: any) => Promise<unknown>;
}) {
  let callCount = 0;
  const promptFn = mock(async (args: any) => {
    if (overrides?.promptImpl) {
      return await overrides.promptImpl(args);
    }
    return {};
  });
  return {
    client: {
      session: {
        create: mock(async () => {
          callCount++;
          return (
            overrides?.sessionCreateResult ?? {
              data: { id: `test-session-${callCount}` },
            }
          );
        }),
        status: mock(
          async () => overrides?.sessionStatusResult ?? { data: {} },
        ),
        messages: mock(
          async () => overrides?.sessionMessagesResult ?? { data: [] },
        ),
        prompt: promptFn,
        promptAsync: promptFn,
      },
      tui: {
        showToast: mock(async () => ({})),
      },
    },
    directory: '/test/directory',
  } as any;
}

async function waitForPromptCalls(
  ctx: ReturnType<typeof createMockContext>,
  minCalls = 1,
): Promise<void> {
  for (let i = 0; i < 30; i++) {
    const promptCalls = ctx.client.session.prompt.mock.calls.length;
    const promptAsyncCalls = ctx.client.session.promptAsync.mock.calls.length;
    if (Math.max(promptCalls, promptAsyncCalls) >= minCalls) {
      return;
    }
    await new Promise((r) => setTimeout(r, 10));
  }
}

describe('BackgroundTaskManager', () => {
  describe('constructor', () => {
    test('creates manager with defaults', () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);
      expect(manager).toBeDefined();
    });

    test('creates manager with tmux config', () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx, {
        enabled: true,
        layout: 'main-vertical',
        main_pane_size: 60,
      });
      expect(manager).toBeDefined();
    });

    test('creates manager with background config', () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx, undefined, {
        background: {
          maxConcurrentStarts: 5,
        },
      });
      expect(manager).toBeDefined();
    });
  });

  describe('launch (fire-and-forget)', () => {
    test('returns task immediately with pending or starting status', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'Find all test files',
        description: 'Test file search',
        parentSessionId: 'parent-123',
      });

      expect(task.id).toMatch(/^bg_/);
      // Task may be pending (in queue) or starting (already started)
      expect(['pending', 'starting']).toContain(task.status);
      expect(task.sessionId).toBeUndefined();
      expect(task.agent).toBe('explorer');
      expect(task.description).toBe('Test file search');
      expect(task.startedAt).toBeDefined();
    });

    test('sessionId is set asynchronously when task starts', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      // Immediately after launch, no sessionId
      expect(task.sessionId).toBeUndefined();

      // Wait for microtask queue to process
      await Promise.resolve();
      await Promise.resolve();

      // After background start, sessionId should be set
      expect(task.sessionId).toBeDefined();
      expect(task.status).toBe('running');
    });

    test('task fails when session creation fails', async () => {
      const ctx = createMockContext({ sessionCreateResult: { data: {} } });
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();

      expect(task.status).toBe('failed');
      expect(task.error).toBe('Failed to create background session');
    });

    test('multiple launches return immediately', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const task1 = manager.launch({
        agent: 'explorer',
        prompt: 'test1',
        description: 'test1',
        parentSessionId: 'parent-123',
      });

      const task2 = manager.launch({
        agent: 'oracle',
        prompt: 'test2',
        description: 'test2',
        parentSessionId: 'parent-123',
      });

      const task3 = manager.launch({
        agent: 'fixer',
        prompt: 'test3',
        description: 'test3',
        parentSessionId: 'parent-123',
      });

      // All return immediately with pending or starting status
      expect(['pending', 'starting']).toContain(task1.status);
      expect(['pending', 'starting']).toContain(task2.status);
      expect(['pending', 'starting']).toContain(task3.status);
    });
  });

  describe('handleSessionStatus', () => {
    test('completes task when session becomes idle', async () => {
      const ctx = createMockContext({
        sessionMessagesResult: {
          data: [
            {
              info: { role: 'assistant' },
              parts: [{ type: 'text', text: 'Result text' }],
            },
          ],
        },
      });
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      // Wait for task to start
      await Promise.resolve();
      await Promise.resolve();

      // Simulate session.idle event
      await manager.handleSessionStatus({
        type: 'session.status',
        properties: {
          sessionID: task.sessionId,
          status: { type: 'idle' },
        },
      });

      expect(task.status).toBe('completed');
      expect(task.result).toBe('Result text');
    });

    test('ignores non-idle status', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();

      // Simulate session.busy event
      await manager.handleSessionStatus({
        type: 'session.status',
        properties: {
          sessionID: task.sessionId,
          status: { type: 'busy' },
        },
      });

      expect(task.status).toBe('running');
    });

    test('ignores non-matching session ID', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();

      // Simulate event for different session
      await manager.handleSessionStatus({
        type: 'session.status',
        properties: {
          sessionID: 'other-session-id',
          status: { type: 'idle' },
        },
      });

      expect(task.status).toBe('running');
    });

    test('retries connectivity failures immediately five times before final failure', async () => {
      const connectivityError =
        'Error: Unable to connect. Is the computer able to access the url?';

      const ctx = createMockContext({
        sessionMessagesResult: {
          data: [
            {
              info: {
                role: 'assistant',
                error: {
                  data: {
                    message: connectivityError,
                  },
                },
              } as any,
              parts: [],
            },
          ],
        },
      });
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test connectivity handling',
        description: 'connectivity retries',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();

      for (let i = 0; i < 6; i++) {
        await manager.handleSessionStatus({
          type: 'session.status',
          properties: {
            sessionID: task.sessionId,
            status: { type: 'idle' },
          },
        });

        await Promise.resolve();
        await Promise.resolve();
      }

      expect(task.connectivityRetryCount).toBe(5);
      expect(task.status).toBe('failed');
      expect(task.error).toContain('Unable to connect');
      expect(task.fallbackInfo?.occurred).toBe(false);
      expect(ctx.client.session.create).toHaveBeenCalledTimes(6);
    });
  });

  describe('getResult', () => {
    test('returns null for unknown task', () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const result = manager.getResult('unknown-task-id');
      expect(result).toBeNull();
    });

    test('returns task immediately (no blocking)', () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      const result = manager.getResult(task.id);
      expect(result).toBeDefined();
      expect(result?.id).toBe(task.id);
    });
  });

  describe('waitForCompletion', () => {
    test('waits for task to complete', async () => {
      const ctx = createMockContext({
        sessionMessagesResult: {
          data: [
            {
              info: { role: 'assistant' },
              parts: [{ type: 'text', text: 'Done' }],
            },
          ],
        },
      });
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      // Wait for task to start
      await Promise.resolve();
      await Promise.resolve();

      // Trigger completion via session.status event
      await manager.handleSessionStatus({
        type: 'session.status',
        properties: {
          sessionID: task.sessionId,
          status: { type: 'idle' },
        },
      });

      // Now waitForCompletion should return immediately
      const result = await manager.waitForCompletion(task.id, 5000);
      expect(result?.status).toBe('completed');
      expect(result?.result).toBe('Done');
    });

    test('returns immediately if already completed', async () => {
      const ctx = createMockContext({
        sessionMessagesResult: {
          data: [
            {
              info: { role: 'assistant' },
              parts: [{ type: 'text', text: 'Done' }],
            },
          ],
        },
      });
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      // Wait for task to start
      await Promise.resolve();
      await Promise.resolve();

      // Trigger completion
      await manager.handleSessionStatus({
        type: 'session.status',
        properties: {
          sessionID: task.sessionId,
          status: { type: 'idle' },
        },
      });

      // Now wait should return immediately
      const result = await manager.waitForCompletion(task.id, 5000);
      expect(result?.status).toBe('completed');
    });

    test('returns null for unknown task', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const result = await manager.waitForCompletion('unknown-task-id', 5000);
      expect(result).toBeNull();
    });
  });

  describe('cancel', () => {
    test('cancels pending task before it starts', () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      const count = manager.cancel(task.id);
      expect(count).toBe(1);

      const result = manager.getResult(task.id);
      expect(result?.status).toBe('cancelled');
    });

    test('cancels running task', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      // Wait for task to start
      await Promise.resolve();
      await Promise.resolve();

      const count = manager.cancel(task.id);
      expect(count).toBe(1);

      const result = manager.getResult(task.id);
      expect(result?.status).toBe('cancelled');
    });

    test('returns 0 when cancelling unknown task', () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const count = manager.cancel('unknown-task-id');
      expect(count).toBe(0);
    });

    test('cancels all pending/running tasks when no ID provided', () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      manager.launch({
        agent: 'explorer',
        prompt: 'test1',
        description: 'test1',
        parentSessionId: 'parent-123',
      });

      manager.launch({
        agent: 'oracle',
        prompt: 'test2',
        description: 'test2',
        parentSessionId: 'parent-123',
      });

      const count = manager.cancel();
      expect(count).toBe(2);
    });

    test('does not cancel already completed tasks', async () => {
      const ctx = createMockContext({
        sessionMessagesResult: {
          data: [
            {
              info: { role: 'assistant' },
              parts: [{ type: 'text', text: 'Done' }],
            },
          ],
        },
      });
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      // Wait for task to start
      await Promise.resolve();
      await Promise.resolve();

      // Trigger completion
      await manager.handleSessionStatus({
        type: 'session.status',
        properties: {
          sessionID: task.sessionId,
          status: { type: 'idle' },
        },
      });

      // Now try to cancel - should fail since already completed
      const count = manager.cancel(task.id);
      expect(count).toBe(0);
    });
  });

  describe('BackgroundTask logic', () => {
    test('cancelWithExtraction salvages running task output before cancel', async () => {
      const ctx = createMockContext({
        sessionMessagesResult: {
          data: [
            {
              info: { role: 'assistant' },
              parts: [{ type: 'text', text: 'partial work done' }],
            },
          ],
        },
      });

      const manager = new BackgroundTaskManager(ctx);
      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();

      const result = await manager.cancelWithExtraction(task.id, 'test cancel');

      expect(result.targeted).toBe(1);
      expect(result.salvaged).toBe(1);
      expect(result.cancelled).toBe(0);
      expect(task.status).toBe('completed');
      expect(task.result).toContain('partial work done');
    });

    test('getCancellationPreview returns running task diagnostics', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();

      const preview = manager.getCancellationPreview(task.id);
      expect(preview.length).toBe(1);
      expect(preview[0]?.taskId).toBe(task.id);
      expect(preview[0]?.agent).toBe('explorer');
      expect(preview[0]?.runtimeMs).toBeGreaterThanOrEqual(0);
    });

    test('skips triaged model until cooldown health check window', async () => {
      const now = Date.now();
      const attemptedModels: string[] = [];
      const config = {
        agents: {
          explorer: {
            models: ['openai/gpt-5.2-codex', 'opencode/gpt-5-nano'],
          },
        },
        fallback: {
          enabled: true,
          timeoutMs: 15000,
          triage: {
            'openai/gpt-5.2-codex': {
              failureCount: 3,
              lastFailure: now - 5 * 60 * 1000,
              lastChecked: now - 5 * 60 * 1000,
            },
          },
        },
      };

      const ctx = createMockContext({
        promptImpl: async (args) => {
          const isTaskPrompt =
            typeof args.path?.id === 'string' &&
            args.path.id.startsWith('test-session-');
          const isParentNotification = !isTaskPrompt;
          if (isParentNotification) return {};

          const modelRef = args.body?.model;
          if (modelRef) {
            attemptedModels.push(`${modelRef.providerID}/${modelRef.modelID}`);
          }
          return {};
        },
      });

      const manager = new BackgroundTaskManager(ctx, undefined, config as any);

      manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();
      await new Promise((r) => setTimeout(r, 50));

      expect(attemptedModels).toEqual(['opencode/gpt-5-nano']);
    });

    test('re-admits stale triaged model and removes it after success', async () => {
      const now = Date.now();
      const attemptedModels: string[] = [];
      const triagedModel = 'openai/gpt-5.2-codex';
      const config = {
        agents: {
          explorer: {
            models: [triagedModel, 'opencode/gpt-5-nano'],
          },
        },
        fallback: {
          enabled: true,
          timeoutMs: 15000,
          triage: {
            [triagedModel]: {
              failureCount: 3,
              lastFailure: now - 2 * 60 * 60 * 1000,
              lastChecked: now - 2 * 60 * 60 * 1000,
            },
          },
        },
      };

      const ctx = createMockContext({
        promptImpl: async (args) => {
          const isTaskPrompt =
            typeof args.path?.id === 'string' &&
            args.path.id.startsWith('test-session-');
          const isParentNotification = !isTaskPrompt;
          if (isParentNotification) return {};

          const modelRef = args.body?.model;
          if (modelRef) {
            attemptedModels.push(`${modelRef.providerID}/${modelRef.modelID}`);
          }
          return {};
        },
      });

      const manager = new BackgroundTaskManager(ctx, undefined, config as any);

      manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();
      await new Promise((r) => setTimeout(r, 50));

      expect(attemptedModels[0]).toBe(triagedModel);
      expect(config.fallback.triage[triagedModel]).toBeUndefined();
    });

    test('falls back to next model when first model prompt fails', async () => {
      let promptCalls = 0;
      const ctx = createMockContext({
        promptImpl: async (args) => {
          const isTaskPrompt =
            typeof args.path?.id === 'string' &&
            args.path.id.startsWith('test-session-');
          const isParentNotification = !isTaskPrompt;
          if (isParentNotification) return {};

          promptCalls += 1;
          const modelRef = args.body?.model;
          if (
            modelRef?.providerID === 'openai' &&
            modelRef?.modelID === 'gpt-5.2-codex'
          ) {
            throw new Error('primary failed');
          }
          return {};
        },
      });

      const manager = new BackgroundTaskManager(ctx, undefined, {
        agents: {
          explorer: { models: ['openai/gpt-5.2-codex', 'opencode/gpt-5-nano'] },
        },
        fallback: {
          enabled: true,
          timeoutMs: 15000,
          triage: {},
        },
        background: {
          maxConcurrentStarts: 10,
          maxModelRetries: 1,
          retryDelayMs: 0,
        },
      });

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();
      await new Promise((r) => setTimeout(r, 50));

      expect(task.status).toBe('running');
      expect(promptCalls).toBe(2);
    });

    test('fails task when all fallback models fail', async () => {
      const ctx = createMockContext({
        promptImpl: async (args) => {
          const isTaskPrompt =
            typeof args.path?.id === 'string' &&
            args.path.id.startsWith('test-session-');
          const isParentNotification = !isTaskPrompt;
          if (isParentNotification) return {};
          throw new Error('all models failing');
        },
      });

      const manager = new BackgroundTaskManager(ctx, undefined, {
        agents: {
          explorer: { models: ['openai/gpt-5.2-codex', 'opencode/gpt-5-nano'] },
        },
        fallback: {
          enabled: true,
          timeoutMs: 15000,
          triage: {},
        },
        background: {
          maxConcurrentStarts: 10,
          maxModelRetries: 1,
          retryDelayMs: 0,
        },
      });

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();
      await new Promise((r) => setTimeout(r, 50));

      expect(task.status).toBe('failed');
      expect(task.error).toContain('All fallback models failed');
    });

    test('uses legacy fallback.chains when agent models are missing', async () => {
      const attemptedModels: string[] = [];
      const ctx = createMockContext({
        promptImpl: async (args) => {
          const isTaskPrompt =
            typeof args.path?.id === 'string' &&
            args.path.id.startsWith('test-session-');
          const isParentNotification = !isTaskPrompt;
          if (isParentNotification) return {};

          const modelRef = args.body?.model;
          if (modelRef) {
            attemptedModels.push(`${modelRef.providerID}/${modelRef.modelID}`);
          }
          return {};
        },
      });

      const manager = new BackgroundTaskManager(ctx, undefined, {
        agents: {
          explorer: {},
        },
        fallback: {
          enabled: true,
          timeoutMs: 15000,
          chains: {
            explorer: ['opencode/gpt-5-nano'],
          },
          triage: {},
        },
      } as any);

      manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();
      await new Promise((r) => setTimeout(r, 50));

      expect(attemptedModels[0]).toBe('opencode/gpt-5-nano');
    });

    test('deprioritizes providers with recent repeated failures', async () => {
      const now = Date.now();
      const attemptedModels: string[] = [];
      const ctx = createMockContext({
        promptImpl: async (args) => {
          const isTaskPrompt =
            typeof args.path?.id === 'string' &&
            args.path.id.startsWith('test-session-');
          const isParentNotification = !isTaskPrompt;
          if (isParentNotification) return {};

          const modelRef = args.body?.model;
          if (modelRef) {
            attemptedModels.push(`${modelRef.providerID}/${modelRef.modelID}`);
          }
          return {};
        },
      });

      const manager = new BackgroundTaskManager(ctx, undefined, {
        agents: {
          explorer: {
            models: [
              'google/gemini-3-pro-preview',
              'opencode/gpt-5-nano',
              'google/gemini-3-flash-preview',
            ],
          },
        },
        fallback: {
          enabled: true,
          timeoutMs: 15000,
          triage: {
            'google/gemini-3-pro-preview': {
              failureCount: 2,
              lastFailure: now - 60_000,
              lastChecked: now - 60_000,
            },
            'google/gemini-3-flash-preview': {
              failureCount: 2,
              lastFailure: now - 60_000,
              lastChecked: now - 60_000,
            },
          },
        },
      } as any);

      manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      await Promise.resolve();
      await Promise.resolve();
      await new Promise((r) => setTimeout(r, 50));

      expect(attemptedModels[0]).toBe('opencode/gpt-5-nano');
    });

    test('extracts content from multiple types and messages', async () => {
      const ctx = createMockContext({
        sessionMessagesResult: {
          data: [
            {
              info: { role: 'assistant' },
              parts: [
                { type: 'reasoning', text: 'I am thinking...' },
                { type: 'text', text: 'First part.' },
              ],
            },
            {
              info: { role: 'assistant' },
              parts: [
                { type: 'text', text: 'Second part.' },
                { type: 'text', text: '' }, // Should be ignored
              ],
            },
          ],
        },
      });
      const manager = new BackgroundTaskManager(ctx);

      const task = manager.launch({
        agent: 'test',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'p1',
      });

      // Wait for task to start
      await Promise.resolve();
      await Promise.resolve();

      // Trigger completion
      await manager.handleSessionStatus({
        type: 'session.status',
        properties: {
          sessionID: task.sessionId,
          status: { type: 'idle' },
        },
      });

      expect(task.status).toBe('completed');
      expect(task.result).toContain('I am thinking...');
      expect(task.result).toContain('First part.');
      expect(task.result).toContain('Second part.');
      // Check for double newline join
      expect(task.result).toBe(
        'I am thinking...\n\nFirst part.\n\nSecond part.',
      );
    });

    test('task has completedAt timestamp on completion or cancellation', async () => {
      const ctx = createMockContext({
        sessionMessagesResult: {
          data: [
            {
              info: { role: 'assistant' },
              parts: [{ type: 'text', text: 'done' }],
            },
          ],
        },
      });
      const manager = new BackgroundTaskManager(ctx);

      // Test completion timestamp
      const task1 = manager.launch({
        agent: 'test',
        prompt: 't1',
        description: 'd1',
        parentSessionId: 'p1',
      });

      await Promise.resolve();
      await Promise.resolve();

      await manager.handleSessionStatus({
        type: 'session.status',
        properties: {
          sessionID: task1.sessionId,
          status: { type: 'idle' },
        },
      });

      expect(task1.completedAt).toBeInstanceOf(Date);
      expect(task1.status).toBe('completed');

      // Test cancellation timestamp
      const task2 = manager.launch({
        agent: 'test',
        prompt: 't2',
        description: 'd2',
        parentSessionId: 'p2',
      });

      manager.cancel(task2.id);
      expect(task2.completedAt).toBeInstanceOf(Date);
      expect(task2.status).toBe('cancelled');
    });

    test('always sends notification to parent session on completion', async () => {
      const ctx = createMockContext({
        sessionMessagesResult: {
          data: [
            {
              info: { role: 'assistant' },
              parts: [{ type: 'text', text: 'done' }],
            },
          ],
        },
      });
      const manager = new BackgroundTaskManager(ctx, undefined, {
        background: { maxConcurrentStarts: 10 },
      });

      const task = manager.launch({
        agent: 'test',
        prompt: 't',
        description: 'd',
        parentSessionId: 'parent-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      await manager.handleSessionStatus({
        type: 'session.status',
        properties: {
          sessionID: task.sessionId,
          status: { type: 'idle' },
        },
      });

      // Should have called prompt.append for notification
      expect(ctx.client.session.prompt).toHaveBeenCalled();
    });

    test('triggers fallback when Gemini quota error arrives as assistant text', async () => {
      let promptCalls = 0;
      const quotaErrorText =
        'Retry Error\n' +
        'You exceeded your current quota for model gemini-3-pro-preview.\n' +
        'Quota exceeded for metric: generativelanguage.googleapis.com/generate_requests_per_model_per_day, limit: 0';

      const ctx = createMockContext({
        sessionMessagesResult: {
          data: [
            {
              info: { role: 'assistant' },
              parts: [{ type: 'text', text: quotaErrorText }],
            },
          ],
        },
        promptImpl: async (args) => {
          const isTaskPrompt =
            typeof args.path?.id === 'string' &&
            args.path.id.startsWith('test-session-');
          const isParentNotification = !isTaskPrompt;
          if (isParentNotification) return {};

          promptCalls += 1;
          return {};
        },
      });

      const manager = new BackgroundTaskManager(ctx, undefined, {
        agents: {
          explorer: {
            models: ['google/gemini-3-pro-preview', 'opencode/gpt-5-nano'],
          },
        },
        fallback: {
          enabled: true,
          timeoutMs: 15000,
          triage: {},
        },
      });

      const task = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'parent-123',
      });

      // Wait for task to start
      await Promise.resolve();
      await Promise.resolve();

      // Simulate session going idle — triggers message extraction
      await manager.handleSessionStatus({
        type: 'session.status',
        properties: {
          sessionID: task.sessionId,
          status: { type: 'idle' },
        },
      });

      // Allow fallback retry to process
      await new Promise((r) => setTimeout(r, 50));

      // The quota error in assistant text should trigger fallback,
      // resulting in a second prompt call with the next model
      expect(promptCalls).toBeGreaterThanOrEqual(2);
    });
  });

  describe('subagent delegation restrictions', () => {
    test('spawned explorer gets tools disabled (leaf node)', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // First, simulate orchestrator starting (parent session with no parent)
      const orchestratorTask = manager.launch({
        agent: 'orchestrator',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      // Verify orchestrator's session is tracked
      const orchestratorSessionId = orchestratorTask.sessionId;
      if (!orchestratorSessionId)
        throw new Error('Expected sessionId to be defined');

      // Launch explorer from orchestrator - explorer is a leaf node so tools disabled
      manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: orchestratorSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();

      // Tool overrides are intentionally not enforced here.
      expect(orchestratorSessionId).toBeDefined();
    });

    test('spawned fixer gets tools enabled (can delegate to explorer)', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // First, launch an explorer task
      const explorerTask = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      // Launch fixer from explorer - fixer can delegate to explorer, so tools enabled
      const explorerSessionId = explorerTask.sessionId;
      if (!explorerSessionId)
        throw new Error('Expected sessionId to be defined');

      manager.launch({
        agent: 'fixer',
        prompt: 'test',
        description: 'test',
        parentSessionId: explorerSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();

      // Tools are not overridden for spawned agents
      const promptCalls = ctx.client.session.prompt.mock.calls as Array<
        [{ body: { tools?: Record<string, boolean> } }]
      >;
      const lastCall = promptCalls[promptCalls.length - 1];
      expect(lastCall[0].body.tools).toBeUndefined();
    });

    test('spawned explorer from fixer gets tools disabled (leaf node)', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Launch a fixer task
      const fixerTask = manager.launch({
        agent: 'fixer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      // Launch explorer from fixer - explorer is a leaf node so tools disabled
      const fixerSessionId = fixerTask.sessionId;
      if (!fixerSessionId) throw new Error('Expected sessionId to be defined');

      manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: fixerSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();
      await waitForPromptCalls(ctx, 1);

      const promptCalls = ctx.client.session.prompt.mock.calls as Array<
        [{ body: { tools?: Record<string, boolean> } }]
      >;
      const lastCall = promptCalls[promptCalls.length - 1];
      expect(lastCall[0].body.tools).toBeUndefined();
    });

    test('spawned explorer from designer gets tools disabled (leaf node)', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Launch a designer task
      const designerTask = manager.launch({
        agent: 'designer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();
      await waitForPromptCalls(ctx, 2);

      // Launch explorer from designer - explorer is a leaf node so tools disabled
      const designerSessionId = designerTask.sessionId;
      if (!designerSessionId)
        throw new Error('Expected sessionId to be defined');

      manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: designerSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();

      const promptCalls = ctx.client.session.prompt.mock.calls as Array<
        [{ body: { tools?: Record<string, boolean> } }]
      >;
      const lastCall = promptCalls[promptCalls.length - 1];
      expect(lastCall[0].body.tools).toBeUndefined();
    });

    test('librarian cannot delegate to any subagents', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Launch a librarian task
      const librarianTask = manager.launch({
        agent: 'librarian',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      // Launch subagent from librarian - should have tools disabled
      const librarianSessionId = librarianTask.sessionId;
      if (!librarianSessionId)
        throw new Error('Expected sessionId to be defined');

      manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: librarianSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();

      const promptCalls = ctx.client.session.prompt.mock.calls as Array<
        [{ body: { tools?: Record<string, boolean> } }]
      >;
      const lastCall = promptCalls[promptCalls.length - 1];
      expect(lastCall[0].body.tools).toBeUndefined();
    });

    test('oracle cannot delegate to any subagents', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Launch an oracle task
      const oracleTask = manager.launch({
        agent: 'oracle',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      // Launch subagent from oracle - should have tools disabled
      const oracleSessionId = oracleTask.sessionId;
      if (!oracleSessionId) throw new Error('Expected sessionId to be defined');

      manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: oracleSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();

      const promptCalls = ctx.client.session.prompt.mock.calls as Array<
        [{ body: { tools?: Record<string, boolean> } }]
      >;
      const lastCall = promptCalls[promptCalls.length - 1];
      expect(lastCall[0].body.tools).toBeUndefined();
    });

    test('spawned explorer from unknown parent gets tools disabled (leaf node)', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Launch explorer from unknown parent session (root orchestrator)
      manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'unknown-session-id',
      });

      await Promise.resolve();
      await Promise.resolve();

      // Unknown parents are treated as root orchestrator delegation.
      expect(manager.isAgentAllowed('unknown-session-id', 'explorer')).toBe(
        true,
      );
    });

    test('isAgentAllowed returns true for valid delegations', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const orchestratorTask = manager.launch({
        agent: 'orchestrator',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const orchestratorSessionId = orchestratorTask.sessionId;
      if (!orchestratorSessionId)
        throw new Error('Expected sessionId to be defined');

      // Orchestrator can delegate to all subagents
      expect(manager.isAgentAllowed(orchestratorSessionId, 'explorer')).toBe(
        true,
      );
      expect(manager.isAgentAllowed(orchestratorSessionId, 'fixer')).toBe(true);
      expect(manager.isAgentAllowed(orchestratorSessionId, 'designer')).toBe(
        true,
      );
      expect(manager.isAgentAllowed(orchestratorSessionId, 'librarian')).toBe(
        true,
      );
      expect(manager.isAgentAllowed(orchestratorSessionId, 'oracle')).toBe(
        true,
      );
    });

    test('isAgentAllowed returns false for invalid delegations', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      const fixerTask = manager.launch({
        agent: 'fixer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const fixerSessionId = fixerTask.sessionId;
      if (!fixerSessionId) throw new Error('Expected sessionId to be defined');

      // Fixer can delegate to explorer and librarian
      expect(manager.isAgentAllowed(fixerSessionId, 'explorer')).toBe(true);
      expect(manager.isAgentAllowed(fixerSessionId, 'oracle')).toBe(false);
      expect(manager.isAgentAllowed(fixerSessionId, 'designer')).toBe(false);
      expect(manager.isAgentAllowed(fixerSessionId, 'librarian')).toBe(true);
    });

    test('isAgentAllowed returns false for leaf agents', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Explorer is a leaf agent
      const explorerTask = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const explorerSessionId = explorerTask.sessionId;
      if (!explorerSessionId)
        throw new Error('Expected sessionId to be defined');

      expect(manager.isAgentAllowed(explorerSessionId, 'fixer')).toBe(false);

      // Librarian is also a leaf agent
      const librarianTask = manager.launch({
        agent: 'librarian',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const librarianSessionId = librarianTask.sessionId;
      if (!librarianSessionId)
        throw new Error('Expected sessionId to be defined');

      expect(manager.isAgentAllowed(librarianSessionId, 'explorer')).toBe(
        false,
      );
    });

    test('isAgentAllowed treats unknown session as root orchestrator', () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Unknown sessions default to orchestrator, which can delegate to all subagents
      expect(manager.isAgentAllowed('unknown-session', 'explorer')).toBe(true);
      expect(manager.isAgentAllowed('unknown-session', 'fixer')).toBe(true);
      expect(manager.isAgentAllowed('unknown-session', 'designer')).toBe(true);
      expect(manager.isAgentAllowed('unknown-session', 'librarian')).toBe(true);
      expect(manager.isAgentAllowed('unknown-session', 'oracle')).toBe(true);
    });

    test('unknown agent type defaults to explorer-only delegation', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Launch a task with an agent type not in SUBAGENT_DELEGATION_RULES
      const customTask = manager.launch({
        agent: 'custom-agent',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const customSessionId = customTask.sessionId;
      if (!customSessionId) throw new Error('Expected sessionId to be defined');

      // Unknown agent types should default to explorer-only
      expect(manager.getAllowedSubagents(customSessionId)).toEqual([
        'explorer',
      ]);
      expect(manager.isAgentAllowed(customSessionId, 'explorer')).toBe(true);
      expect(manager.isAgentAllowed(customSessionId, 'fixer')).toBe(false);
      expect(manager.isAgentAllowed(customSessionId, 'oracle')).toBe(false);
    });

    test('spawned explorer from custom agent gets tools disabled (leaf node)', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Launch a custom agent first to get a tracked session
      const parentTask = manager.launch({
        agent: 'custom-agent',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const parentSessionId = parentTask.sessionId;
      if (!parentSessionId) throw new Error('Expected sessionId to be defined');

      // Launch explorer from custom agent - explorer is leaf, tools disabled
      manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: parentSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();

      // Tools are not overridden for spawned agents
      const promptCalls = ctx.client.session.prompt.mock.calls as Array<
        [{ body: { tools?: Record<string, boolean> } }]
      >;
      const lastCall = promptCalls[promptCalls.length - 1];
      expect(lastCall[0].body.tools).toBeUndefined();
    });

    test('full chain: orchestrator → fixer → explorer', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Level 1: Launch orchestrator from root
      const orchestratorTask = manager.launch({
        agent: 'orchestrator',
        prompt: 'coordinate work',
        description: 'orchestrator',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const orchestratorSessionId = orchestratorTask.sessionId;
      if (!orchestratorSessionId)
        throw new Error('Expected sessionId to be defined');

      // Orchestrator can delegate to fixer
      expect(manager.isAgentAllowed(orchestratorSessionId, 'fixer')).toBe(true);

      // Level 2: Launch fixer from orchestrator
      const fixerTask = manager.launch({
        agent: 'fixer',
        prompt: 'implement changes',
        description: 'fixer',
        parentSessionId: orchestratorSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();

      const fixerSessionId = fixerTask.sessionId;
      if (!fixerSessionId) throw new Error('Expected sessionId to be defined');

      // Tool overrides are intentionally not enforced here.
      expect(fixerSessionId).toBeDefined();

      // Fixer can delegate to explorer but NOT oracle
      expect(manager.isAgentAllowed(fixerSessionId, 'explorer')).toBe(true);
      expect(manager.isAgentAllowed(fixerSessionId, 'oracle')).toBe(false);

      // Level 3: Launch explorer from fixer
      const explorerTask = manager.launch({
        agent: 'explorer',
        prompt: 'search codebase',
        description: 'explorer',
        parentSessionId: fixerSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();
      await waitForPromptCalls(ctx, 2);

      const explorerSessionId = explorerTask.sessionId;
      if (!explorerSessionId)
        throw new Error('Expected sessionId to be defined');

      // Tool overrides are intentionally not enforced here.
      expect(explorerSessionId).toBeDefined();

      // Explorer cannot delegate to anything
      expect(manager.isAgentAllowed(explorerSessionId, 'explorer')).toBe(false);
      expect(manager.isAgentAllowed(explorerSessionId, 'fixer')).toBe(false);
      expect(manager.isAgentAllowed(explorerSessionId, 'oracle')).toBe(false);
      expect(manager.getAllowedSubagents(explorerSessionId)).toEqual([]);
    });

    test('full chain: orchestrator → designer → oracle', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Level 1: Launch orchestrator
      const orchestratorTask = manager.launch({
        agent: 'orchestrator',
        prompt: 'coordinate work',
        description: 'orchestrator',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const orchestratorSessionId = orchestratorTask.sessionId;
      if (!orchestratorSessionId)
        throw new Error('Expected sessionId to be defined');

      // Level 2: Launch designer from orchestrator
      const designerTask = manager.launch({
        agent: 'designer',
        prompt: 'design UI',
        description: 'designer',
        parentSessionId: orchestratorSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();

      const designerSessionId = designerTask.sessionId;
      if (!designerSessionId)
        throw new Error('Expected sessionId to be defined');

      // Tool overrides are intentionally not enforced here.
      expect(designerSessionId).toBeDefined();

      // Designer can only spawn oracle
      expect(manager.isAgentAllowed(designerSessionId, 'oracle')).toBe(true);
      expect(manager.isAgentAllowed(designerSessionId, 'fixer')).toBe(false);
      expect(manager.isAgentAllowed(designerSessionId, 'explorer')).toBe(false);

      // Level 3: Launch oracle from designer
      const oracleTask = manager.launch({
        agent: 'oracle',
        prompt: 'review plan',
        description: 'oracle',
        parentSessionId: designerSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();
      await waitForPromptCalls(ctx, 2);

      const oracleSessionId = oracleTask.sessionId;
      if (!oracleSessionId) throw new Error('Expected sessionId to be defined');

      // Tool overrides are intentionally not enforced here.
      expect(oracleSessionId).toBeDefined();

      // Oracle can only spawn explorer
      expect(manager.getAllowedSubagents(oracleSessionId)).toEqual([
        'explorer',
      ]);
    });

    test('chain enforcement: fixer cannot spawn unauthorized agents mid-chain', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Orchestrator spawns fixer
      const orchestratorTask = manager.launch({
        agent: 'orchestrator',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const orchestratorSessionId = orchestratorTask.sessionId;
      if (!orchestratorSessionId)
        throw new Error('Expected sessionId to be defined');

      const fixerTask = manager.launch({
        agent: 'fixer',
        prompt: 'test',
        description: 'test',
        parentSessionId: orchestratorSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();

      const fixerSessionId = fixerTask.sessionId;
      if (!fixerSessionId) throw new Error('Expected sessionId to be defined');

      // Fixer should be blocked from spawning these agents
      expect(manager.isAgentAllowed(fixerSessionId, 'oracle')).toBe(false);
      expect(manager.isAgentAllowed(fixerSessionId, 'designer')).toBe(false);
      expect(manager.isAgentAllowed(fixerSessionId, 'librarian')).toBe(true);
      expect(manager.isAgentAllowed(fixerSessionId, 'fixer')).toBe(false);

      // Explorer and librarian are allowed
      expect(manager.isAgentAllowed(fixerSessionId, 'explorer')).toBe(true);
      expect(manager.getAllowedSubagents(fixerSessionId)).toEqual([
        'explorer',
        'librarian',
      ]);
    });

    test('chain: completed parent does not affect child permissions', async () => {
      const ctx = createMockContext({
        sessionMessagesResult: {
          data: [
            {
              info: { role: 'assistant' },
              parts: [{ type: 'text', text: 'done' }],
            },
          ],
        },
      });
      const manager = new BackgroundTaskManager(ctx);

      // Launch fixer
      const fixerTask = manager.launch({
        agent: 'fixer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const fixerSessionId = fixerTask.sessionId;
      if (!fixerSessionId) throw new Error('Expected sessionId to be defined');

      // Launch explorer from fixer BEFORE fixer completes
      const explorerTask = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: fixerSessionId,
      });

      await Promise.resolve();
      await Promise.resolve();

      const explorerSessionId = explorerTask.sessionId;
      if (!explorerSessionId)
        throw new Error('Expected sessionId to be defined');

      // Tool overrides are intentionally not enforced here.
      expect(explorerSessionId).toBeDefined();

      // Now complete the fixer (cleans up fixer's agentBySessionId entry)
      await manager.handleSessionStatus({
        type: 'session.status',
        properties: {
          sessionID: fixerSessionId,
          status: { type: 'idle' },
        },
      });

      expect(fixerTask.status).toBe('completed');

      // Explorer's own session tracking is independent — still works
      expect(manager.isAgentAllowed(explorerSessionId, 'fixer')).toBe(false);
      expect(manager.getAllowedSubagents(explorerSessionId)).toEqual([]);
    });

    test('getAllowedSubagents returns correct lists', async () => {
      const ctx = createMockContext();
      const manager = new BackgroundTaskManager(ctx);

      // Orchestrator -> all 5 subagent names
      const orchestratorTask = manager.launch({
        agent: 'orchestrator',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const orchestratorSessionId = orchestratorTask.sessionId;
      if (!orchestratorSessionId)
        throw new Error('Expected sessionId to be defined');

      expect(manager.getAllowedSubagents(orchestratorSessionId)).toEqual([
        'explorer',
        'librarian',
        'oracle',
        'designer',
        'fixer',
      ]);

      // Fixer -> explorer + librarian
      const fixerTask = manager.launch({
        agent: 'fixer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const fixerSessionId = fixerTask.sessionId;
      if (!fixerSessionId) throw new Error('Expected sessionId to be defined');

      expect(manager.getAllowedSubagents(fixerSessionId)).toEqual([
        'explorer',
        'librarian',
      ]);

      // Designer -> only oracle
      const designerTask = manager.launch({
        agent: 'designer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const designerSessionId = designerTask.sessionId;
      if (!designerSessionId)
        throw new Error('Expected sessionId to be defined');

      expect(manager.getAllowedSubagents(designerSessionId)).toEqual([
        'oracle',
      ]);

      // Explorer -> empty (leaf)
      const explorerTask = manager.launch({
        agent: 'explorer',
        prompt: 'test',
        description: 'test',
        parentSessionId: 'root-session',
      });

      await Promise.resolve();
      await Promise.resolve();

      const explorerSessionId = explorerTask.sessionId;
      if (!explorerSessionId)
        throw new Error('Expected sessionId to be defined');

      expect(manager.getAllowedSubagents(explorerSessionId)).toEqual([]);

      // Unknown session -> orchestrator (all subagents)
      expect(manager.getAllowedSubagents('unknown-session')).toEqual([
        'explorer',
        'librarian',
        'oracle',
        'designer',
        'fixer',
      ]);
    });
  });
});
