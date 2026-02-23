/**
 * Task Restart Manager
 *
 * Detects network-caused task failures and queues them for automatic
 * restart with exponential backoff between restart attempts.
 *
 * DECISION_037 (INFRA-037-005)
 */

import { log } from '../../utils/debug';
import { ErrorClassifier, ErrorType } from './error-classifier';

export interface RestartRequest {
  /** Original task ID */
  taskId: string;
  /** Original agent name */
  agent: string;
  /** Original prompt to re-send */
  prompt: string;
  /** Human-readable description */
  description: string;
  /** Parent session for notifications */
  parentSessionId: string;
  /** How many restarts this task has had */
  restartCount: number;
  /** Unix ms timestamp when restart should execute */
  executeAt: number;
  /** Error that caused the failure */
  originalError: string;
}

export interface TaskRestartConfig {
  /** Maximum number of restarts per task */
  maxRestarts: number;
  /** Base delay between restart attempts (ms) */
  baseDelayMs: number;
  /** Maximum delay between restart attempts (ms) */
  maxDelayMs: number;
}

const DEFAULT_CONFIG: TaskRestartConfig = {
  maxRestarts: 3,
  baseDelayMs: 60_000, // 1 minute
  maxDelayMs: 300_000, // 5 minutes
};

export interface TaskInfo {
  id: string;
  agent: string;
  prompt: string;
  description: string;
  parentSessionId: string;
  restartCount?: number;
}

export class TaskRestartManager {
  private queue: RestartRequest[] = [];
  private classifier: ErrorClassifier;
  private config: TaskRestartConfig;
  private restartCallback?: (request: RestartRequest) => Promise<void>;
  private timer?: ReturnType<typeof setInterval>;

  constructor(
    config?: Partial<TaskRestartConfig>,
    classifier?: ErrorClassifier,
  ) {
    this.config = { ...DEFAULT_CONFIG, ...config };
    this.classifier = classifier ?? new ErrorClassifier();
  }

  /**
   * Register a callback that will be called to actually restart a task.
   */
  onRestart(callback: (request: RestartRequest) => Promise<void>): void {
    this.restartCallback = callback;
  }

  /**
   * Evaluate whether a failed task should be queued for restart.
   * Returns true if the task was queued.
   */
  handleFailure(task: TaskInfo, error: unknown): boolean {
    const errorType = this.classifier.classify(error);

    // Only restart on transient network errors
    if (errorType !== ErrorType.NetworkTransient) {
      log(
        `[task-restart] Task ${task.id} failed with ${errorType}, not restarting`,
      );
      return false;
    }

    const restartCount = task.restartCount ?? 0;
    if (restartCount >= this.config.maxRestarts) {
      log(
        `[task-restart] Task ${task.id} has reached max restarts (${this.config.maxRestarts})`,
      );
      return false;
    }

    const delay = this.calculateDelay(restartCount);
    const errorMsg =
      error instanceof Error ? error.message : String(error);

    const request: RestartRequest = {
      taskId: task.id,
      agent: task.agent,
      prompt: task.prompt,
      description: task.description,
      parentSessionId: task.parentSessionId,
      restartCount: restartCount + 1,
      executeAt: Date.now() + delay,
      originalError: errorMsg,
    };

    this.queue.push(request);
    log(
      `[task-restart] Queued task ${task.id} for restart #${request.restartCount} in ${delay}ms`,
    );

    // Start processing timer if not already running
    this.ensureTimer();

    return true;
  }

  /**
   * Get all pending restart requests.
   */
  getPendingRestarts(): ReadonlyArray<RestartRequest> {
    return this.queue;
  }

  /**
   * Get count of pending restarts.
   */
  get pendingCount(): number {
    return this.queue.length;
  }

  /**
   * Cancel a pending restart for a specific task.
   */
  cancelRestart(taskId: string): boolean {
    const index = this.queue.findIndex((r) => r.taskId === taskId);
    if (index >= 0) {
      this.queue.splice(index, 1);
      log(`[task-restart] Cancelled restart for task ${taskId}`);
      return true;
    }
    return false;
  }

  /**
   * Cancel all pending restarts.
   */
  cancelAll(): void {
    const count = this.queue.length;
    this.queue.length = 0;
    if (count > 0) {
      log(`[task-restart] Cancelled ${count} pending restarts`);
    }
  }

  /**
   * Process the restart queue, executing any ready tasks.
   */
  async processQueue(): Promise<number> {
    if (this.queue.length === 0) return 0;

    const now = Date.now();
    const ready = this.queue.filter((r) => r.executeAt <= now);

    if (ready.length === 0) return 0;

    // Remove ready items from queue
    this.queue = this.queue.filter((r) => r.executeAt > now);

    let executed = 0;
    for (const request of ready) {
      if (this.restartCallback) {
        try {
          log(
            `[task-restart] Executing restart #${request.restartCount} for task ${request.taskId}`,
          );
          await this.restartCallback(request);
          executed++;
        } catch (err) {
          const msg = err instanceof Error ? err.message : String(err);
          log(
            `[task-restart] Restart callback failed for ${request.taskId}: ${msg}`,
          );
          // Re-queue if possible
          if (request.restartCount < this.config.maxRestarts) {
            request.restartCount++;
            request.executeAt =
              Date.now() + this.calculateDelay(request.restartCount);
            this.queue.push(request);
            log(
              `[task-restart] Re-queued task ${request.taskId} for restart #${request.restartCount}`,
            );
          }
        }
      }
    }

    // Stop timer if queue is empty
    if (this.queue.length === 0 && this.timer) {
      clearInterval(this.timer);
      this.timer = undefined;
    }

    return executed;
  }

  /**
   * Cleanup: stop timer and clear queue.
   */
  dispose(): void {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = undefined;
    }
    this.queue.length = 0;
  }

  private calculateDelay(restartCount: number): number {
    const exponential = this.config.baseDelayMs * 2 ** restartCount;
    return Math.min(exponential, this.config.maxDelayMs);
  }

  private ensureTimer(): void {
    if (this.timer) return;
    // Check queue every 10 seconds
    this.timer = setInterval(() => {
      void this.processQueue();
    }, 10_000);
  }
}
