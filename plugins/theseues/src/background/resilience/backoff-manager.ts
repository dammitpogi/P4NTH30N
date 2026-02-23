/**
 * Backoff Manager for Subagent Resilience
 *
 * Implements exponential backoff with jitter for retry delays.
 * Different error types get different backoff strategies:
 * - NetworkTransient:  1s base, 2x growth, 30s cap, 5 max attempts
 * - ProviderRateLimit: 2s base, 2x growth, 60s cap, 5 max attempts
 * - ContextLength:     1 attempt (compact, then fallback)
 * - Others:            no backoff (immediate fallback or fail)
 *
 * DECISION_037 (INFRA-037-002)
 */

import { log } from '../../utils/debug';
import { ErrorType } from './error-classifier';

export interface BackoffStrategy {
  /** Base delay in milliseconds */
  baseDelayMs: number;
  /** Maximum delay cap in milliseconds */
  maxDelayMs: number;
  /** Maximum retry attempts before giving up */
  maxAttempts: number;
  /** Jitter factor (0-1): fraction of delay to randomize */
  jitterFactor: number;
}

/** Default strategies per error type */
const DEFAULT_STRATEGIES: Partial<Record<ErrorType, BackoffStrategy>> = {
  [ErrorType.NetworkTransient]: {
    baseDelayMs: 1000,
    maxDelayMs: 30_000,
    maxAttempts: 5,
    jitterFactor: 0.2,
  },
  [ErrorType.ProviderRateLimit]: {
    baseDelayMs: 2000,
    maxDelayMs: 60_000,
    maxAttempts: 5,
    jitterFactor: 0.25,
  },
};

export class BackoffManager {
  /** Tracks attempt counts per key (e.g., "taskId:model") */
  private attempts = new Map<string, number>();
  /** Custom strategies (merged with defaults) */
  private strategies: Partial<Record<ErrorType, BackoffStrategy>>;

  constructor(overrides?: Partial<Record<ErrorType, BackoffStrategy>>) {
    this.strategies = { ...DEFAULT_STRATEGIES, ...overrides };
  }

  /**
   * Wait for the appropriate backoff delay, then return whether
   * another attempt is allowed.
   *
   * @param errorType — the classified error type
   * @param key       — unique key for tracking (e.g., taskId or taskId:model)
   * @returns true if retry is allowed, false if max attempts exceeded
   */
  async wait(errorType: ErrorType, key: string): Promise<boolean> {
    const strategy = this.strategies[errorType];
    if (!strategy) {
      // No strategy for this error type — don't retry
      return false;
    }

    const attempt = this.attempts.get(key) ?? 0;

    if (attempt >= strategy.maxAttempts) {
      log(
        `[backoff] Max attempts (${strategy.maxAttempts}) reached for key=${key}`,
      );
      return false;
    }

    const delay = this.calculateDelay(strategy, attempt);
    this.attempts.set(key, attempt + 1);

    log(
      `[backoff] Waiting ${delay}ms (attempt ${attempt + 1}/${strategy.maxAttempts}) for key=${key}, errorType=${errorType}`,
    );

    await new Promise((resolve) => setTimeout(resolve, delay));
    return true;
  }

  /**
   * Reset attempt counter for a key (call on success).
   */
  reset(key: string): void {
    if (this.attempts.has(key)) {
      log(`[backoff] Reset counter for key=${key}`);
      this.attempts.delete(key);
    }
  }

  /**
   * Reset all counters.
   */
  resetAll(): void {
    this.attempts.clear();
  }

  /**
   * Get current attempt count for a key.
   */
  getAttemptCount(key: string): number {
    return this.attempts.get(key) ?? 0;
  }

  /**
   * Get max attempts for a given error type.
   */
  getMaxAttempts(errorType: ErrorType): number {
    return this.strategies[errorType]?.maxAttempts ?? 0;
  }

  /**
   * Calculate delay with exponential growth + jitter.
   *
   * Formula: min(base * 2^attempt, maxDelay) + random jitter
   */
  private calculateDelay(strategy: BackoffStrategy, attempt: number): number {
    const exponential = strategy.baseDelayMs * 2 ** attempt;
    const capped = Math.min(exponential, strategy.maxDelayMs);
    // Jitter: uniform random in [-jitter, +jitter] range
    const jitterRange = capped * strategy.jitterFactor;
    const jitter = jitterRange * (2 * Math.random() - 1);
    return Math.max(0, Math.floor(capped + jitter));
  }
}
