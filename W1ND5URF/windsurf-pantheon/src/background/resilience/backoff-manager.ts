/**
 * INFRA-037: Exponential backoff with jitter for retry delays.
 * Sequence: 1s, 2s, 4s, 8s, 16s (configurable base and max).
 */

export interface BackoffConfig {
  /** Base delay in ms (default: 1000) */
  baseDelayMs: number;
  /** Maximum delay in ms (default: 16000) */
  maxDelayMs: number;
  /** Jitter factor 0.0-1.0 (default: 0.25) */
  jitterFactor: number;
  /** Backoff multiplier (default: 2) */
  multiplier: number;
}

const DEFAULT_CONFIG: BackoffConfig = {
  baseDelayMs: 1000,
  maxDelayMs: 16000,
  jitterFactor: 0.25,
  multiplier: 2,
};

export class BackoffManager {
  private config: BackoffConfig;
  private attemptCounts: Map<string, number> = new Map();

  constructor(config?: Partial<BackoffConfig>) {
    this.config = { ...DEFAULT_CONFIG, ...config };
  }

  /**
   * Calculates the delay for the next retry attempt for a given key.
   * Automatically increments the attempt counter.
   */
  getDelay(key: string): number {
    const attempt = this.attemptCounts.get(key) || 0;
    this.attemptCounts.set(key, attempt + 1);
    return this.calculateDelay(attempt);
  }

  /**
   * Calculates delay for a specific attempt number without modifying state.
   */
  calculateDelay(attempt: number): number {
    const exponentialDelay = this.config.baseDelayMs * Math.pow(this.config.multiplier, attempt);
    const cappedDelay = Math.min(exponentialDelay, this.config.maxDelayMs);

    // Add jitter to prevent thundering herd
    const jitterRange = cappedDelay * this.config.jitterFactor;
    const jitter = (Math.random() * 2 - 1) * jitterRange; // [-jitterRange, +jitterRange]

    return Math.max(0, Math.round(cappedDelay + jitter));
  }

  /**
   * Waits for the backoff delay. Returns the delay waited.
   */
  async wait(key: string): Promise<number> {
    const delay = this.getDelay(key);
    await new Promise(resolve => setTimeout(resolve, delay));
    return delay;
  }

  /**
   * Resets the attempt counter for a key (call on success).
   */
  reset(key: string): void {
    this.attemptCounts.delete(key);
  }

  /**
   * Resets all attempt counters.
   */
  resetAll(): void {
    this.attemptCounts.clear();
  }

  /**
   * Gets the current attempt count for a key.
   */
  getAttemptCount(key: string): number {
    return this.attemptCounts.get(key) || 0;
  }
}
