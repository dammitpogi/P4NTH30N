/**
 * INFRA-037: Task restart manager for auto-restarting failed subagent tasks.
 * Maximum 3 restarts per task with exponential backoff between attempts.
 */

import { ErrorClassifier, ClassifiedError } from './error-classifier';
import { BackoffManager } from './backoff-manager';
import { NetworkCircuitBreaker } from './network-circuit-breaker';

export interface TaskConfig {
  /** Unique task identifier */
  id: string;
  /** Task name for logging */
  name: string;
  /** Maximum restart attempts (default: 3) */
  maxRestarts: number;
  /** The async function to execute */
  execute: () => Promise<void>;
  /** Optional endpoint this task communicates with */
  endpoint?: string;
}

export interface TaskState {
  id: string;
  name: string;
  status: 'pending' | 'running' | 'completed' | 'failed' | 'restarting' | 'exhausted';
  restartCount: number;
  maxRestarts: number;
  lastError?: ClassifiedError;
  startedAt?: Date;
  completedAt?: Date;
  totalDurationMs: number;
}

export class TaskRestartManager {
  private errorClassifier: ErrorClassifier;
  private backoffManager: BackoffManager;
  private circuitBreaker: NetworkCircuitBreaker;
  private tasks: Map<string, TaskState> = new Map();
  private listeners: Array<(taskId: string, state: TaskState) => void> = [];

  constructor(
    errorClassifier: ErrorClassifier,
    backoffManager: BackoffManager,
    circuitBreaker: NetworkCircuitBreaker,
  ) {
    this.errorClassifier = errorClassifier;
    this.backoffManager = backoffManager;
    this.circuitBreaker = circuitBreaker;
  }

  /**
   * Executes a task with automatic restart on retryable failures.
   * Returns true if the task eventually succeeded.
   */
  async executeWithRestart(config: TaskConfig): Promise<boolean> {
    const maxRestarts = config.maxRestarts ?? 3;
    const taskState: TaskState = {
      id: config.id,
      name: config.name,
      status: 'pending',
      restartCount: 0,
      maxRestarts,
      startedAt: new Date(),
      totalDurationMs: 0,
    };
    this.tasks.set(config.id, taskState);

    for (let attempt = 0; attempt <= maxRestarts; attempt++) {
      // Check circuit breaker for the endpoint
      if (config.endpoint && !this.circuitBreaker.allowRequest(config.endpoint)) {
        console.log(`[TaskRestartManager] Circuit open for ${config.endpoint}, skipping ${config.name}`);
        taskState.status = 'failed';
        taskState.completedAt = new Date();
        taskState.totalDurationMs = Date.now() - taskState.startedAt!.getTime();
        this.notify(config.id, taskState);
        return false;
      }

      taskState.status = attempt === 0 ? 'running' : 'restarting';
      taskState.restartCount = attempt;
      this.notify(config.id, taskState);

      try {
        const start = Date.now();
        await config.execute();
        const latency = Date.now() - start;

        // Success
        taskState.status = 'completed';
        taskState.completedAt = new Date();
        taskState.totalDurationMs = Date.now() - taskState.startedAt!.getTime();
        this.backoffManager.reset(config.id);

        if (config.endpoint) {
          this.circuitBreaker.recordSuccess(config.endpoint);
        }

        this.notify(config.id, taskState);
        console.log(`[TaskRestartManager] ${config.name} completed (attempt ${attempt + 1}, ${latency}ms)`);
        return true;
      } catch (err) {
        const error = err instanceof Error ? err : new Error(String(err));
        const classified = this.errorClassifier.classify(error);
        taskState.lastError = classified;

        if (config.endpoint) {
          this.circuitBreaker.recordFailure(config.endpoint);
        }

        console.log(
          `[TaskRestartManager] ${config.name} failed (attempt ${attempt + 1}/${maxRestarts + 1}): ` +
          `[${classified.category}] ${classified.message}`
        );

        // Check if error is retryable and we have attempts left
        if (!classified.isRetryable || attempt >= maxRestarts) {
          taskState.status = attempt >= maxRestarts ? 'exhausted' : 'failed';
          taskState.completedAt = new Date();
          taskState.totalDurationMs = Date.now() - taskState.startedAt!.getTime();
          this.notify(config.id, taskState);

          console.log(
            `[TaskRestartManager] ${config.name} ${taskState.status}: ` +
            `${classified.isRetryable ? 'max restarts exhausted' : 'non-retryable error'}`
          );
          return false;
        }

        // Wait with backoff before retry
        const delay = await this.backoffManager.wait(config.id);
        console.log(`[TaskRestartManager] ${config.name} waiting ${delay}ms before restart...`);
      }
    }

    return false;
  }

  /**
   * Gets the state of a task.
   */
  getTaskState(taskId: string): TaskState | undefined {
    return this.tasks.get(taskId);
  }

  /**
   * Gets all task states.
   */
  getAllTaskStates(): TaskState[] {
    return Array.from(this.tasks.values());
  }

  /**
   * Registers a task state change listener.
   */
  onTaskStateChange(listener: (taskId: string, state: TaskState) => void): void {
    this.listeners.push(listener);
  }

  /**
   * Gets summary metrics.
   */
  getMetrics(): {
    total: number;
    completed: number;
    failed: number;
    exhausted: number;
    running: number;
    totalRestarts: number;
  } {
    const states = Array.from(this.tasks.values());
    return {
      total: states.length,
      completed: states.filter(s => s.status === 'completed').length,
      failed: states.filter(s => s.status === 'failed').length,
      exhausted: states.filter(s => s.status === 'exhausted').length,
      running: states.filter(s => s.status === 'running' || s.status === 'restarting').length,
      totalRestarts: states.reduce((sum, s) => sum + s.restartCount, 0),
    };
  }

  private notify(taskId: string, state: TaskState): void {
    for (const listener of this.listeners) {
      try { listener(taskId, { ...state }); } catch { /* ignore */ }
    }
  }
}
