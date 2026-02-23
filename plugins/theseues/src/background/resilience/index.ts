/**
 * Subagent Resilience Layer
 *
 * Provides network-aware retry logic, circuit breaking, health monitoring,
 * and automatic task restart for subagent background tasks.
 *
 * DECISION_037: Subagent Fallback System Hardening
 *
 * Components:
 * - ErrorClassifier:         Categorizes errors for retry strategy selection
 * - BackoffManager:          Exponential backoff with jitter
 * - NetworkCircuitBreaker:   Per-endpoint circuit breaking (5-min cooldown)
 * - ConnectionHealthMonitor: Per-session health tracking
 * - TaskRestartManager:      Auto-restart for network-failed tasks
 * - RetryMetrics:            Visibility and alerting for retry activity
 */

export {
  ErrorClassifier,
  ErrorType,
  errorTypeLabel,
} from './error-classifier';

export { BackoffManager, type BackoffStrategy } from './backoff-manager';

export {
  ConnectionHealthMonitor,
  type ConnectionHealthConfig,
  type HealthStatus,
} from './connection-health-monitor';

export {
  NetworkCircuitBreaker,
  type CircuitState,
  type CircuitStatus,
  type NetworkCircuitBreakerConfig,
} from './network-circuit-breaker';

export {
  TaskRestartManager,
  type RestartRequest,
  type TaskInfo,
  type TaskRestartConfig,
} from './task-restart-manager';

export {
  RetryMetrics,
  type MetricsSummary,
  type RetryEvent,
  type RetryMetricsConfig,
} from './retry-metrics';
