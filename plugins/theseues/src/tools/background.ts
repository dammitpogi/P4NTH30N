import {
  type PluginInput,
  type ToolDefinition,
  tool,
} from '@opencode-ai/plugin';
import type { BackgroundTaskManager } from '../background';
import type { PluginConfig } from '../config';
import { SUBAGENT_NAMES } from '../config';
import type { TmuxConfig } from '../config/schema';

const z = tool.schema;

/**
 * Creates background task management tools for the plugin.
 * @param _ctx - Plugin input context
 * @param manager - Background task manager for launching and tracking tasks
 * @param _tmuxConfig - Optional tmux configuration for session management
 * @param _pluginConfig - Optional plugin configuration for agent variants
 * @returns Object containing background_task, background_output, and background_cancel tools
 */
export function createBackgroundTools(
  _ctx: PluginInput,
  manager: BackgroundTaskManager,
  _tmuxConfig?: TmuxConfig,
  _pluginConfig?: PluginConfig,
): Record<string, ToolDefinition> {
  const agentNames = SUBAGENT_NAMES.join(', ');
  const cancelDoubleRunGuard = new Map<
    string,
    { signature: string; expiresAt: number }
  >();
  const CANCEL_CONFIRM_WINDOW_MS = 60000;
  const outputPollGuard = new Map<
    string,
    { snapshot: string; lastCheckedAt: number }
  >();
  const OUTPUT_POLL_COOLDOWN_MS = 10000;

  // Tool for launching agent tasks (fire-and-forget)
  const background_task = tool({
    description: `Launch background agent task. Returns task_id immediately.\n\nFlow: launch → wait for automatic notification when complete.\n\nKey behaviors:\n- Fire-and-forget: returns task_id in ~1ms\n- Parallel: up to 10 concurrent tasks\n- Auto-notify: parent session receives result when task completes`,

    args: {
      description: z
        .string()
        .describe('Short description of the task (5-10 words)'),
      prompt: z.string().describe('The task prompt for the agent'),
      agent: z.string().describe(`Agent to use: ${agentNames}`),
    },
    async execute(args, toolContext) {
      if (
        !toolContext ||
        typeof toolContext !== 'object' ||
        !('sessionID' in toolContext)
      ) {
        throw new Error('Invalid toolContext: missing sessionID');
      }

      const agent = String(args.agent);
      const prompt = String(args.prompt);
      const description = String(args.description);
      const parentSessionId = (toolContext as { sessionID: string }).sessionID;

      // Validate agent against delegation rules
      if (!manager.isAgentAllowed(parentSessionId, agent)) {
        const allowed = manager.getAllowedSubagents(parentSessionId);
        throw new Error(
          `Agent '${agent}' is not allowed. Allowed agents: ${allowed.join(', ')}`,
        );
      }

      // Fire-and-forget launch
      const task = manager.launch({
        agent,
        prompt,
        description,
        parentSessionId,
      });

      return `Background task launched.\n\nTask ID: ${task.id}\nAgent: ${agent}\nStatus: ${task.status}\n\nUse \`background_output\` with task_id="${task.id}" to get results.`;
    },
  });

  // Tool for retrieving output from background tasks
  const background_output = tool({
    description: `Get background task results after completion notification received.\n\ntimeout=0: returns status immediately (no wait)\ntimeout=N: waits up to N ms for completion\n\nReturns: results if completed, error if failed, status if running. Add peek=true to see current output if running.`,

    args: {
      task_id: z.string().describe('Task ID from background_task'),
      timeout:
        z
          .number()
          .optional()
          .describe('Wait for completion (in ms, 0=no wait, default: 0)'),
      peek: z
        .boolean()
        .optional()
        .describe('Peek at current output (if running)'),
    },
    async execute(args, toolContext) {
      const taskId = String(args.task_id);
      const timeout =
        typeof args.timeout === 'number' && args.timeout > 0 ? args.timeout : 0;
      const peek = args.peek === true;

      let task = manager.getResult(taskId);

      // Wait for completion if timeout specified
      if (
        task &&
        timeout > 0 &&
        task.status !== 'completed' &&
        task.status !== 'failed' &&
        task.status !== 'cancelled'
      ) {
        task = await manager.waitForCompletion(taskId, timeout);
      }

      if (!task) {
        return `Task not found: ${taskId}`;
      }

      const telemetry = manager.getTaskTelemetry(task.id);
      const taskSnapshot = [
        task.status,
        task.completedAt?.getTime() ?? 0,
        task.error ?? '',
        task.result?.length ?? 0,
        task.fallbackInfo?.totalAttempts ?? 0,
        task.hangRecoveryEvents?.length ?? 0,
        telemetry?.sessionStatus ?? '',
        telemetry?.activeModel ?? '',
      ].join('|');

      const now = Date.now();
      const previousPoll = outputPollGuard.get(task.id);
      const isActiveTask =
        task.status === 'pending' ||
        task.status === 'starting' ||
        task.status === 'running';

      if (
        timeout === 0 &&
        isActiveTask &&
        previousPoll &&
        previousPoll.snapshot === taskSnapshot &&
        now - previousPoll.lastCheckedAt < OUTPUT_POLL_COOLDOWN_MS
      ) {
        const waitMs =
          OUTPUT_POLL_COOLDOWN_MS - (now - previousPoll.lastCheckedAt);
        const waitSeconds = Math.max(1, Math.ceil(waitMs / 1000));
        return `Task ${task.id} is still ${task.status} with no new output yet. Check again in ~${waitSeconds}s, or wait for the completion notification/toast.`;
      }

      outputPollGuard.set(task.id, {
        snapshot: taskSnapshot,
        lastCheckedAt: now,
      });

      // Calculate task duration
      const duration = task.completedAt
        ? `${Math.floor((task.completedAt.getTime() - task.startedAt.getTime()) / 1000)}s`
        : `${Math.floor((Date.now() - task.startedAt.getTime()) / 1000)}s`;
      const lastActivity =
        typeof telemetry?.lastActivityAgoMs === 'number'
          ? `${Math.floor(telemetry.lastActivityAgoMs / 1000)}s ago`
          : 'unknown';

      let output = `Task: ${task.id}\n Description: ${task.description}\n Status: ${task.status}\n Duration: ${duration}\n Agent: ${task.agent}\n Session: ${telemetry?.sessionStatus || 'unknown'}\n Last Activity: ${lastActivity}\n`;

      // Add fallback information if available
      if (task.fallbackInfo) {
        if (task.fallbackInfo.occurred) {
          output += `Fallback: Yes (tried ${task.fallbackInfo.totalAttempts} models)\n Successful Model: ${task.fallbackInfo.successfulModel || 'None'}\n`;
        } else if (task.fallbackInfo.totalAttempts > 0) {
          output += `Fallback: No (first model succeeded)\n`;
        }
      }

      if (telemetry?.activeModel) {
        output += `Current Model: ${telemetry.activeModel}\n`;
      }

      if (task.hangRecoveryEvents && task.hangRecoveryEvents.length > 0) {
        const latest =
          task.hangRecoveryEvents[task.hangRecoveryEvents.length - 1];
        const eventTime =
          latest ? new Date(latest.timestamp).toISOString() : 'unknown';
        output += `Hang Recovery: Yes (${task.hangRecoveryEvents.length} event${task.hangRecoveryEvents.length > 1 ? 's' : ''})\n Latest Event: ${latest?.action || 'unknown'} @ ${eventTime}\n Reason: ${latest?.reason || 'unknown'}\n`;
      }

      output += `\n ---\n\n`;

      // Include task result or error based on status
      if (task.status === 'completed' && task.result != null) {
        output += task.result;

        // Append fallback notice if fallback occurred
        if (task.fallbackInfo?.occurred && task.fallbackInfo.successfulModel) {
          output += `\n\n[Note: Subagent ${task.agent} required model fallback, but succeeded on ${task.fallbackInfo.successfulModel}. Minor inconvenience, continuing normally.]`;
        }
      } else if (task.status === 'failed') {
        output += `Error: ${task.error}`;

        // Add fallback details if task failed during fallback
        if (
          task.fallbackInfo?.totalAttempts &&
          task.fallbackInfo.totalAttempts > 1
        ) {
          output += `\n\n[Fallback: Tried ${task.fallbackInfo.totalAttempts} models before failing]`;
        }
      } else if (task.status === 'cancelled') {
        const reason = task.error || 'Unknown cancellation reason';
        output += `Task cancelled: ${reason}`;
      } else {
        if (peek) {
          // Attempt to peek at the current session messages
          if (task.sessionId) {
            try {
              const messagesResult = await _ctx.client.session.messages({
                path: { id: task.sessionId },
              });
              const messages = (messagesResult.data ?? []) as Array<{
                info?: { role: string };
                parts?: Array<{ type: string; text?: string }>;
              }>;

              const assistantMessages = messages.filter(
                (m) => m.info?.role === 'assistant',
              );
              const extractedContent: string[] = [];
              for (const message of assistantMessages) {
                for (const part of message.parts ?? []) {
                  if (
                    part.text &&
                    (part.type === 'text' || part.type === 'reasoning')
                  ) {
                    extractedContent.push(part.text);
                  }
                  if (
                    (part as any).content &&
                    typeof (part as any).content === 'string'
                  ) {
                    extractedContent.push((part as any).content);
                  }
                }
              }
              const peekedText = extractedContent
                .filter((t) => t.length > 0)
                .join('\n\n');
              if (peekedText) {
                output += `\n\n--- Peeked Output ---\n${peekedText}`;
              } else {
                output += '\n\n(No output yet)';
              }
            } catch (e) {
              output += `\n\n(Error peeking at output: ${String(e)})`;
            }
          } else {
            output += '\n\n(No session ID yet)';
          }
        }
        output +=
          '(Task still running)\n\nHint: Completion notifications are now delivered immediately to the chat even if the agent is busy polling. You can wait for the notification instead of polling repeatedly.';
      }

      return output;
    },
  });

  // Tool for canceling running background tasks
  const background_cancel = tool({
    description: `Cancel background task(s).\n\ntask_id: cancel specific task\nall=true: cancel all running tasks\n\nOnly cancels pending/starting/running tasks.`,
    args: {
      task_id: z.string().optional().describe('Specific task to cancel'),
      all: z.boolean().optional().describe('Cancel all running tasks'),
    },
    async execute(args, toolContext) {
      const sessionID =
        toolContext &&
        typeof toolContext === 'object' &&
        'sessionID' in toolContext
          ? String((toolContext as { sessionID: string }).sessionID)
          : undefined;

      const cancelReason = sessionID
        ? `Cancelled via background_cancel (session ${sessionID})`
        : 'Cancelled via background_cancel';

      const targetSignature =
        args.all === true
          ? 'all'
          : typeof args.task_id === 'string'
            ? `task:${args.task_id}`
            : '';

      if (!targetSignature) {
        return 'Specify task_id or use all=true.';
      }

      const preview = manager.getCancellationPreview(
        typeof args.task_id === 'string' ? args.task_id : undefined,
      );

      if (preview.length === 0) {
        return typeof args.task_id === 'string'
          ? `Task ${args.task_id} not found or not running.`
          : 'No cancellable tasks found.';
      }

      const confirmationKey = sessionID ?? 'global';
      const now = Date.now();
      const pending = cancelDoubleRunGuard.get(confirmationKey);
      const isConfirmed =
        pending?.signature === targetSignature && pending.expiresAt > now;

      if (!isConfirmed) {
        cancelDoubleRunGuard.set(confirmationKey, {
          signature: targetSignature,
          expiresAt: now + CANCEL_CONFIRM_WINDOW_MS,
        });

        const lines = preview.map((task) => {
          const duration = `${Math.floor(task.runtimeMs / 1000)}s`;
          const attempts =
            task.attempts > 0 ? `, attempts=${task.attempts}` : '';
          const sessionStatus = task.sessionStatus
            ? `, session=${task.sessionStatus}`
            : '';
          const recent = task.recentError
            ? `, last_error=${task.recentError.slice(0, 120)}`
            : task.recentResult
              ? `, partial_result=${task.recentResult.slice(0, 120)}`
              : '';
          return `- ${task.taskId} (${task.agent}, ${task.status}, runtime=${duration}${sessionStatus}${attempts}${recent})`;
        });

        const repeatHint =
          args.all === true
            ? 'background_cancel({"all":true})'
            : `background_cancel({"task_id":"${args.task_id}"})`;

        return `Cancellation requires double-run confirmation.\n\nPending cancellation targets:\n${lines.join('\n')}\n\nRun the same command again within 60s to proceed: ${repeatHint}\n\nOn second run, the manager will first attempt extraction/completion to preserve partial output, then cancel only tasks still active.`;

      }

      cancelDoubleRunGuard.delete(confirmationKey);

      // Cancel all running tasks if requested
      if (args.all === true) {
        const result = await manager.cancelWithExtraction(
          undefined,
          cancelReason,
        );
        return `Cancellation confirmed. Targeted ${result.targeted} task(s); salvaged ${result.salvaged}; cancelled ${result.cancelled}.`;
      }

      // Cancel specific task if task_id provided
      if (typeof args.task_id === 'string') {
        const result = await manager.cancelWithExtraction(
          args.task_id,
          cancelReason,
        );
        return result.targeted > 0
          ? `Cancellation confirmed for ${args.task_id}. Salvaged ${result.salvaged}; cancelled ${result.cancelled}.`
          : `Task ${args.task_id} not found or not running.`;
      }

      return 'Specify task_id or use all=true.';
    },
  });

  return { background_task, background_output, background_cancel };
}
