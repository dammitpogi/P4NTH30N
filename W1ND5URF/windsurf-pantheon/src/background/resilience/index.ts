/**
 * INFRA-037: Subagent Fallback System - Resilience Layer
 *
 * Provides network error resilience for subagent tasks:
 * - ErrorClassifier: Categorizes errors as transient/permanent/logic
 * - BackoffManager: Exponential backoff (1s, 2s, 4s, 8s, 16s) with jitter
 * - ConnectionHealthMonitor: Pre-flight checks and keepalive pings
 * - NetworkCircuitBreaker: Per-endpoint circuit breaking (5-min cooldown)
 * - TaskRestartManager: Auto-restart failed tasks (max 3 attempts)
 * - RetryMetrics: Success rate tracking (target: 80%+)
 */

export { ErrorClassifier, ErrorCategory } from './error-classifier';
export type { ClassifiedError } from './error-classifier';

export { BackoffManager } from './backoff-manager';
export type { BackoffConfig } from './backoff-manager';

export { ConnectionHealthMonitor } from './connection-health-monitor';
export type { EndpointHealth, HealthMonitorConfig } from './connection-health-monitor';

export { NetworkCircuitBreaker, CircuitState } from './network-circuit-breaker';
export type { CircuitBreakerConfig } from './network-circuit-breaker';

export { TaskRestartManager } from './task-restart-manager';
export type { TaskConfig, TaskState } from './task-restart-manager';

export { RetryMetrics } from './retry-metrics';
export type { RetryMetricsSnapshot } from './retry-metrics';

/**
 * Creates a fully configured resilience stack with defaults.
 */
export function createResilienceStack(options?: {
  backoffBaseMs?: number;
  backoffMaxMs?: number;
  circuitFailureThreshold?: number;
  circuitRecoveryMs?: number;
  maxRestarts?: number;
}) {
  const { ErrorClassifier: EC } = require('./error-classifier');
  const { BackoffManager: BM } = require('./backoff-manager');
  const { ConnectionHealthMonitor: CHM } = require('./connection-health-monitor');
  const { NetworkCircuitBreaker: NCB } = require('./network-circuit-breaker');
  const { TaskRestartManager: TRM } = require('./task-restart-manager');
  const { RetryMetrics: RM } = require('./retry-metrics');

  const errorClassifier = new EC();
  const backoffManager = new BM({
    baseDelayMs: options?.backoffBaseMs ?? 1000,
    maxDelayMs: options?.backoffMaxMs ?? 16000,
  });
  const healthMonitor = new CHM();
  const circuitBreaker = new NCB({
    failureThreshold: options?.circuitFailureThreshold ?? 5,
    recoveryTimeoutMs: options?.circuitRecoveryMs ?? 300000,
  });
  const taskManager = new TRM(errorClassifier, backoffManager, circuitBreaker);
  const metrics = new RM();

  // Wire circuit breaker trips to metrics
  circuitBreaker.onStateChange((_endpoint: string, state: string) => {
    if (state === 'open') metrics.recordCircuitBreakerTrip();
  });

  return {
    errorClassifier,
    backoffManager,
    healthMonitor,
    circuitBreaker,
    taskManager,
    metrics,
  };
}
