/**
 * Retry Metrics & Visibility
 *
 * Tracks retry activity across the resilience layer for
 * logging, alerting, and diagnostic purposes.
 *
 * DECISION_037 (INFRA-037-006)
 */

import { log } from '../../utils/debug';
import type { ErrorType } from './error-classifier';

export interface RetryEvent {
  /** When the retry occurred */
  timestamp: number;
  /** Task that triggered the retry */
  taskId: string;
  /** Error type classification */
  errorType: ErrorType;
  /** Model being retried */
  model: string;
  /** Attempt number */
  attempt: number;
  /** Backoff delay applied (ms) */
  delayMs: number;
  /** Whether the retry succeeded */
  succeeded: boolean;
}

export interface MetricsSummary {
  /** Total retry events recorded */
  totalRetries: number;
  /** Total successes after retry */
  totalSuccesses: number;
  /** Total failures after all retries */
  totalFinalFailures: number;
  /** Success rate (0.0 - 1.0) */
  successRate: number;
  /** Average retries before success */
  avgRetriesBeforeSuccess: number;
  /** Breakdown by error type */
  byErrorType: Record<
    string,
    { retries: number; successes: number; failures: number }
  >;
  /** Active alert (persistent failure detected) */
  activeAlert: boolean;
  /** Alert message if active */
  alertMessage?: string;
}

export interface RetryMetricsConfig {
  /** Max events to keep in memory */
  maxEvents: number;
  /** Window for alert evaluation (ms) */
  alertWindowMs: number;
  /** Failure count in window to trigger alert */
  alertThreshold: number;
}

const DEFAULT_CONFIG: RetryMetricsConfig = {
  maxEvents: 500,
  alertWindowMs: 300_000, // 5 minutes
  alertThreshold: 10,
};

export class RetryMetrics {
  private events: RetryEvent[] = [];
  private config: RetryMetricsConfig;
  private alertActive = false;

  constructor(config?: Partial<RetryMetricsConfig>) {
    this.config = { ...DEFAULT_CONFIG, ...config };
  }

  /**
   * Record a retry attempt.
   */
  recordRetry(event: Omit<RetryEvent, 'timestamp'>): void {
    const entry: RetryEvent = { ...event, timestamp: Date.now() };
    this.events.push(entry);

    // Trim to max size
    while (this.events.length > this.config.maxEvents) {
      this.events.shift();
    }

    // Log the event
    log(
      `[retry-metrics] ${event.succeeded ? 'SUCCESS' : 'RETRY'}: task=${event.taskId} model=${event.model} type=${event.errorType} attempt=${event.attempt} delay=${event.delayMs}ms`,
    );

    // Check for alert condition
    this.evaluateAlert();
  }

  /**
   * Get a summary of retry metrics.
   */
  getSummary(): MetricsSummary {
    const successes = this.events.filter((e) => e.succeeded);
    const failures = this.events.filter((e) => !e.succeeded);

    // Group by error type
    const byErrorType: MetricsSummary['byErrorType'] = {};
    for (const event of this.events) {
      const key = event.errorType;
      if (!byErrorType[key]) {
        byErrorType[key] = { retries: 0, successes: 0, failures: 0 };
      }
      byErrorType[key].retries++;
      if (event.succeeded) {
        byErrorType[key].successes++;
      } else {
        byErrorType[key].failures++;
      }
    }

    // Average retries before success (group by taskId)
    const taskSuccesses = new Map<string, number>();
    for (const event of this.events) {
      if (event.succeeded && !taskSuccesses.has(event.taskId)) {
        taskSuccesses.set(event.taskId, event.attempt);
      }
    }
    const avgRetries =
      taskSuccesses.size > 0
        ? Array.from(taskSuccesses.values()).reduce((a, b) => a + b, 0) /
          taskSuccesses.size
        : 0;

    return {
      totalRetries: this.events.length,
      totalSuccesses: successes.length,
      totalFinalFailures: failures.length,
      successRate:
        this.events.length > 0
          ? successes.length / this.events.length
          : 0,
      avgRetriesBeforeSuccess: avgRetries,
      byErrorType,
      activeAlert: this.alertActive,
      alertMessage: this.alertActive
        ? `Persistent network issues: ${failures.length} failures in tracking window`
        : undefined,
    };
  }

  /**
   * Get recent events (most recent first).
   */
  getRecentEvents(count = 20): ReadonlyArray<RetryEvent> {
    return this.events.slice(-count).reverse();
  }

  /**
   * Clear all events and reset alert.
   */
  reset(): void {
    this.events.length = 0;
    this.alertActive = false;
  }

  private evaluateAlert(): void {
    const windowStart = Date.now() - this.config.alertWindowMs;
    const recentFailures = this.events.filter(
      (e) => !e.succeeded && e.timestamp >= windowStart,
    );

    const wasAlert = this.alertActive;
    this.alertActive =
      recentFailures.length >= this.config.alertThreshold;

    if (this.alertActive && !wasAlert) {
      log(
        `[retry-metrics] ALERT: ${recentFailures.length} failures in last ${this.config.alertWindowMs / 1000}s`,
      );
    } else if (!this.alertActive && wasAlert) {
      log('[retry-metrics] Alert cleared');
    }
  }
}
