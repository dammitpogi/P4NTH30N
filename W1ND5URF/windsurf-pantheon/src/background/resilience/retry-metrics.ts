/**
 * INFRA-037: Retry and resilience metrics collection.
 * Tracks success rates, retry counts, circuit breaker trips, and latency.
 * Target: 80%+ retry success rate.
 */

export interface RetryMetricsSnapshot {
  /** Total operations attempted */
  totalOperations: number;
  /** Operations that succeeded (including after retries) */
  successCount: number;
  /** Operations that failed permanently */
  failureCount: number;
  /** Total retries across all operations */
  totalRetries: number;
  /** Success rate (0.0 - 1.0) */
  successRate: number;
  /** Retry success rate: operations that succeeded after at least 1 retry */
  retrySuccessRate: number;
  /** Average retries per operation */
  averageRetries: number;
  /** Circuit breaker trips */
  circuitBreakerTrips: number;
  /** Average operation latency in ms */
  averageLatencyMs: number;
  /** p95 latency in ms */
  p95LatencyMs: number;
  /** Metrics collection start time */
  startTime: Date;
  /** Errors by category */
  errorsByCategory: Record<string, number>;
}

interface OperationRecord {
  id: string;
  success: boolean;
  retries: number;
  latencyMs: number;
  timestamp: Date;
  errorCategory?: string;
}

export class RetryMetrics {
  private operations: OperationRecord[] = [];
  private circuitBreakerTrips = 0;
  private startTime: Date = new Date();
  private maxRecords: number;
  private errorsByCategory: Map<string, number> = new Map();

  constructor(maxRecords: number = 10000) {
    this.maxRecords = maxRecords;
  }

  /**
   * Records a completed operation (success or failure).
   */
  recordOperation(
    id: string,
    success: boolean,
    retries: number,
    latencyMs: number,
    errorCategory?: string,
  ): void {
    this.operations.push({
      id,
      success,
      retries,
      latencyMs,
      timestamp: new Date(),
      errorCategory,
    });

    // Trim old records
    if (this.operations.length > this.maxRecords) {
      this.operations = this.operations.slice(-this.maxRecords);
    }

    if (errorCategory) {
      this.errorsByCategory.set(
        errorCategory,
        (this.errorsByCategory.get(errorCategory) || 0) + 1,
      );
    }
  }

  /**
   * Records a circuit breaker trip.
   */
  recordCircuitBreakerTrip(): void {
    this.circuitBreakerTrips++;
  }

  /**
   * Gets the current metrics snapshot.
   */
  getSnapshot(): RetryMetricsSnapshot {
    const total = this.operations.length;
    const successes = this.operations.filter(o => o.success);
    const failures = this.operations.filter(o => !o.success);
    const retriedAndSucceeded = successes.filter(o => o.retries > 0);
    const retriedOps = this.operations.filter(o => o.retries > 0);
    const totalRetries = this.operations.reduce((sum, o) => sum + o.retries, 0);
    const latencies = this.operations.map(o => o.latencyMs).sort((a, b) => a - b);

    const errorsByCat: Record<string, number> = {};
    this.errorsByCategory.forEach((count, cat) => { errorsByCat[cat] = count; });

    return {
      totalOperations: total,
      successCount: successes.length,
      failureCount: failures.length,
      totalRetries,
      successRate: total > 0 ? successes.length / total : 0,
      retrySuccessRate: retriedOps.length > 0 ? retriedAndSucceeded.length / retriedOps.length : 0,
      averageRetries: total > 0 ? totalRetries / total : 0,
      circuitBreakerTrips: this.circuitBreakerTrips,
      averageLatencyMs: latencies.length > 0
        ? latencies.reduce((a, b) => a + b, 0) / latencies.length
        : 0,
      p95LatencyMs: latencies.length > 0
        ? latencies[Math.floor(latencies.length * 0.95)] || latencies[latencies.length - 1]
        : 0,
      startTime: this.startTime,
      errorsByCategory: errorsByCat,
    };
  }

  /**
   * Resets all metrics.
   */
  reset(): void {
    this.operations = [];
    this.circuitBreakerTrips = 0;
    this.startTime = new Date();
    this.errorsByCategory.clear();
  }

  /**
   * Returns a human-readable summary string.
   */
  getSummary(): string {
    const s = this.getSnapshot();
    return [
      `Resilience Metrics (since ${s.startTime.toISOString()})`,
      `  Operations: ${s.totalOperations} (${s.successCount} ok, ${s.failureCount} failed)`,
      `  Success Rate: ${(s.successRate * 100).toFixed(1)}%`,
      `  Retry Success Rate: ${(s.retrySuccessRate * 100).toFixed(1)}%`,
      `  Total Retries: ${s.totalRetries} (avg: ${s.averageRetries.toFixed(1)}/op)`,
      `  Circuit Breaker Trips: ${s.circuitBreakerTrips}`,
      `  Latency: avg=${s.averageLatencyMs.toFixed(0)}ms p95=${s.p95LatencyMs.toFixed(0)}ms`,
    ].join('\n');
  }
}
