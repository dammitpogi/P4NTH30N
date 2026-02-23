import type { PluginInput } from '@opencode-ai/plugin';
import type { IdleOrchestratorConfig } from '../../config/schema';
import { log } from '../../utils/logger';

interface IdleTracker {
  sessionID: string;
  idleSince: number;
  lastPromptTime: number;
}

/**
 * Creates a hook that proactively prompts the Orchestrator when idle.
 * This keeps the Orchestrator "busy" so that background task results
 * can auto-flush via client.session.promptAsync().
 */
export function createIdleOrchestratorHook(
  ctx: PluginInput,
  options: IdleOrchestratorConfig = {
    enabled: true,
    idleTimeoutMs: 30000,
    minPromptIntervalMs: 120000,
  },
) {
  const { enabled, idleTimeoutMs, minPromptIntervalMs } = options;
  const idleTrackers = new Map<string, IdleTracker>();

  return {
    event: async ({
      event,
    }: {
      event: { type: string; properties?: unknown };
    }) => {
      if (!enabled) return;
      if (event.type !== 'session.status') return;

      const props = event.properties as
        | { sessionID?: string; status?: { type: string } }
        | undefined;
      const sessionId = props?.sessionID;
      const statusType = props?.status?.type;

      if (!sessionId) return;

      const tracker = idleTrackers.get(sessionId);
      const now = Date.now();

      if (statusType === 'idle') {
        if (!tracker) {
          // First time seeing this session - verify it's main orchestrator
          try {
            const sessionResult = await ctx.client.session.get({
              path: { id: sessionId },
            });
            const parentID = (sessionResult.data as { parentID?: string })
              ?.parentID;
            if (parentID) return; // Skip background sessions
          } catch {
            log(
              '[idle-orchestrator] Could not verify session parentID, assuming main session',
            );
          }

          idleTrackers.set(sessionId, {
            sessionID: sessionId,
            idleSince: now,
            lastPromptTime: 0,
          });
          log('[idle-orchestrator] Started tracking idle session', {
            sessionId,
          });
        } else {
          const idleDuration = now - tracker.idleSince;
          const timeSinceLastPrompt = now - tracker.lastPromptTime;

          const shouldPrompt =
            idleDuration >= idleTimeoutMs &&
            timeSinceLastPrompt >= minPromptIntervalMs;

          if (shouldPrompt) {
            log('[idle-orchestrator] Sending proactive prompt', {
              sessionId,
              idleDuration,
              timeSinceLastPrompt,
            });

            await sendProactivePrompt(ctx, sessionId);
            tracker.lastPromptTime = now;
            tracker.idleSince = now;
          }
        }
      } else if (statusType === 'busy') {
        if (tracker) {
          log('[idle-orchestrator] Session busy, stopping idle tracking', {
            sessionId,
          });
          idleTrackers.delete(sessionId);
        }
      }
    },
  };
}

async function sendProactivePrompt(
  ctx: PluginInput,
  sessionId: string,
): Promise<void> {
  const prompt = `<Proactive Work>
Background tasks may have completed. Please check for any queued results.

If still idle after processing results, analyze the project for potential next work:
- Review recent changes for follow-up tasks
- Check for TODO comments or FIXME markers
- Identify files that need documentation updates
- Consider architectural improvements

Return any findings or confirm no immediate work needed.
</Proactive Work>`;

  try {
    await ctx.client.session.promptAsync({
      path: { id: sessionId },
      body: {
        parts: [{ type: 'text' as const, text: prompt }],
      },
    });
    log('[idle-orchestrator] Proactive prompt sent successfully');
  } catch (error) {
    const msg = error instanceof Error ? error.message : String(error);
    log('[idle-orchestrator] Failed to send proactive prompt', { error: msg });
  }
}

export type { IdleOrchestratorConfig };
