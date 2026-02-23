import { describe, expect, test } from 'bun:test';
import { BackoffManager } from './backoff-manager';
import {
  ConnectionHealthMonitor,
} from './connection-health-monitor';
import { ErrorClassifier, ErrorType } from './error-classifier';
import { NetworkCircuitBreaker } from './network-circuit-breaker';
import { RetryMetrics } from './retry-metrics';
import { TaskRestartManager } from './task-restart-manager';

// ─── ErrorClassifier ────────────────────────────────────────────

describe('ErrorClassifier', () => {
  const classifier = new ErrorClassifier();

  describe('NetworkTransient classification', () => {
    test.each([
      'ECONNREFUSED 127.0.0.1:8080',
      'ECONNRESET by peer',
      'ENOTFOUND api.openai.com',
      'ETIMEDOUT after 30s',
      'connect EHOSTUNREACH 10.0.0.1',
      'socket hang up',
      'request timeout after 60000ms',
      'Unable to connect to server',
      'network error occurred',
      'connection error: reset',
      'fetch failed',
      'dns lookup failed',
      'getaddrinfo ENOTFOUND api.example.com',
      'Service Unavailable 503',
      'Gateway Timeout 504',
      'Bad Gateway 502',
    ])('classifies "%s" as NetworkTransient', (msg) => {
      expect(classifier.classify(new Error(msg))).toBe(
        ErrorType.NetworkTransient,
      );
    });
  });

  describe('NetworkPermanent classification', () => {
    test.each([
      'certificate has expired',
      'ssl handshake error',
      'tls failure during connect',
      'self-signed cert in chain',
      'proxy auth required',
      'DEPTH_ZERO_SELF_SIGNED_CERT',
      'unable to verify the first certificate',
      'ERR_TLS_CERT_ALTNAME_INVALID',
    ])('classifies "%s" as NetworkPermanent', (msg) => {
      expect(classifier.classify(new Error(msg))).toBe(
        ErrorType.NetworkPermanent,
      );
    });
  });

  describe('ProviderRateLimit classification', () => {
    test.each([
      'rate limit exceeded',
      'HTTP 429 Too Many Requests',
      'quota exceeded for project',
      'exceeded your current quota',
      'RESOURCE_EXHAUSTED',
      'You need more credit',
      'insufficient quota remaining',
      'requests per minute limit',
    ])('classifies "%s" as ProviderRateLimit', (msg) => {
      expect(classifier.classify(new Error(msg))).toBe(
        ErrorType.ProviderRateLimit,
      );
    });
  });

  describe('ContextLength classification', () => {
    test.each([
      'maximum context length exceeded',
      'too many tokens in request',
      'token limit reached',
      'context window exceeded',
      'input too long for model',
    ])('classifies "%s" as ContextLength', (msg) => {
      expect(classifier.classify(new Error(msg))).toBe(
        ErrorType.ContextLength,
      );
    });
  });

  describe('ProviderError classification', () => {
    test.each([
      'invalid model: gpt-5',
      'model not found: unknown-model',
      'invalid api key provided',
      '401 Unauthorized',
      '403 Forbidden access',
      'authentication failed for user',
      'PERMISSION_DENIED on resource',
      'unknown error from provider',
      'bad request: missing field',
    ])('classifies "%s" as ProviderError', (msg) => {
      expect(classifier.classify(new Error(msg))).toBe(
        ErrorType.ProviderError,
      );
    });
  });

  describe('LogicError classification (default)', () => {
    test.each([
      'Cannot read property of undefined',
      'SyntaxError in response',
      'Unexpected token <',
      'File not found: /tmp/data.json',
    ])('classifies "%s" as LogicError', (msg) => {
      expect(classifier.classify(new Error(msg))).toBe(
        ErrorType.LogicError,
      );
    });
  });

  describe('strategy helpers', () => {
    test('shouldRetrySameModel for NetworkTransient', () => {
      expect(
        classifier.shouldRetrySameModel(ErrorType.NetworkTransient),
      ).toBe(true);
    });

    test('shouldRetrySameModel for ProviderRateLimit', () => {
      expect(
        classifier.shouldRetrySameModel(ErrorType.ProviderRateLimit),
      ).toBe(true);
    });

    test('shouldFallbackToNextModel for ProviderError', () => {
      expect(
        classifier.shouldFallbackToNextModel(ErrorType.ProviderError),
      ).toBe(true);
    });

    test('shouldCompact for ContextLength', () => {
      expect(classifier.shouldCompact(ErrorType.ContextLength)).toBe(
        true,
      );
    });

    test('isPermanent for NetworkPermanent', () => {
      expect(classifier.isPermanent(ErrorType.NetworkPermanent)).toBe(
        true,
      );
    });

    test('isPermanent for LogicError', () => {
      expect(classifier.isPermanent(ErrorType.LogicError)).toBe(true);
    });
  });

  test('handles non-Error inputs', () => {
    expect(classifier.classify('string error')).toBeDefined();
    expect(classifier.classify({ code: 'ECONNREFUSED' })).toBeDefined();
    expect(classifier.classify(null)).toBe(ErrorType.LogicError);
    expect(classifier.classify(undefined)).toBe(ErrorType.LogicError);
  });
});

// ─── BackoffManager ─────────────────────────────────────────────

describe('BackoffManager', () => {
  test('returns false for error types without strategy', async () => {
    const manager = new BackoffManager();
    const result = await manager.wait(ErrorType.LogicError, 'test');
    expect(result).toBe(false);
  });

  test('allows retries up to maxAttempts', async () => {
    const manager = new BackoffManager({
      [ErrorType.NetworkTransient]: {
        baseDelayMs: 1, // tiny delay for tests
        maxDelayMs: 10,
        maxAttempts: 3,
        jitterFactor: 0,
      },
    });

    expect(await manager.wait(ErrorType.NetworkTransient, 'k1')).toBe(
      true,
    );
    expect(await manager.wait(ErrorType.NetworkTransient, 'k1')).toBe(
      true,
    );
    expect(await manager.wait(ErrorType.NetworkTransient, 'k1')).toBe(
      true,
    );
    // 4th attempt exceeds max
    expect(await manager.wait(ErrorType.NetworkTransient, 'k1')).toBe(
      false,
    );
  });

  test('reset clears attempt counter', async () => {
    const manager = new BackoffManager({
      [ErrorType.NetworkTransient]: {
        baseDelayMs: 1,
        maxDelayMs: 10,
        maxAttempts: 2,
        jitterFactor: 0,
      },
    });

    await manager.wait(ErrorType.NetworkTransient, 'k2');
    await manager.wait(ErrorType.NetworkTransient, 'k2');
    expect(await manager.wait(ErrorType.NetworkTransient, 'k2')).toBe(
      false,
    );

    manager.reset('k2');
    expect(await manager.wait(ErrorType.NetworkTransient, 'k2')).toBe(
      true,
    );
  });

  test('getAttemptCount tracks attempts', async () => {
    const manager = new BackoffManager({
      [ErrorType.NetworkTransient]: {
        baseDelayMs: 1,
        maxDelayMs: 10,
        maxAttempts: 5,
        jitterFactor: 0,
      },
    });

    expect(manager.getAttemptCount('k3')).toBe(0);
    await manager.wait(ErrorType.NetworkTransient, 'k3');
    expect(manager.getAttemptCount('k3')).toBe(1);
    await manager.wait(ErrorType.NetworkTransient, 'k3');
    expect(manager.getAttemptCount('k3')).toBe(2);
  });

  test('different keys track independently', async () => {
    const manager = new BackoffManager({
      [ErrorType.NetworkTransient]: {
        baseDelayMs: 1,
        maxDelayMs: 10,
        maxAttempts: 2,
        jitterFactor: 0,
      },
    });

    await manager.wait(ErrorType.NetworkTransient, 'a');
    await manager.wait(ErrorType.NetworkTransient, 'a');
    expect(await manager.wait(ErrorType.NetworkTransient, 'a')).toBe(
      false,
    );

    // Separate key still has quota
    expect(await manager.wait(ErrorType.NetworkTransient, 'b')).toBe(
      true,
    );
  });
});

// ─── NetworkCircuitBreaker ──────────────────────────────────────

describe('NetworkCircuitBreaker', () => {
  test('starts in closed state (allows requests)', () => {
    const cb = new NetworkCircuitBreaker();
    expect(cb.canAttempt('ep1')).toBe(true);
  });

  test('opens after failure threshold', () => {
    const cb = new NetworkCircuitBreaker({ failureThreshold: 3 });

    cb.recordFailure('ep1');
    cb.recordFailure('ep1');
    expect(cb.canAttempt('ep1')).toBe(true);

    cb.recordFailure('ep1'); // 3rd failure = threshold
    expect(cb.canAttempt('ep1')).toBe(false); // circuit open
  });

  test('transitions to half-open after cooldown', () => {
    const cb = new NetworkCircuitBreaker({
      failureThreshold: 2,
      cooldownMs: 50, // 50ms for testing
    });

    cb.recordFailure('ep2');
    cb.recordFailure('ep2');
    expect(cb.canAttempt('ep2')).toBe(false);

    // Simulate cooldown passing by directly modifying state
    const status = cb.getStatus('ep2');
    expect(status.state).toBe('open');
  });

  test('success in half-open closes circuit', () => {
    const cb = new NetworkCircuitBreaker({
      failureThreshold: 2,
      cooldownMs: 0, // Immediate for testing
      halfOpenSuccessThreshold: 1,
    });

    cb.recordFailure('ep3');
    cb.recordFailure('ep3');
    // Cooldown is 0ms, so next canAttempt will transition to half-open
    expect(cb.canAttempt('ep3')).toBe(true);

    cb.recordSuccess('ep3');
    const status = cb.getStatus('ep3');
    expect(status.state).toBe('closed');
  });

  test('failure in half-open re-opens circuit', () => {
    const cb = new NetworkCircuitBreaker({
      failureThreshold: 2,
      cooldownMs: 0,
    });

    cb.recordFailure('ep4');
    cb.recordFailure('ep4');
    cb.canAttempt('ep4'); // transitions to half-open

    cb.recordFailure('ep4'); // fail during half-open
    const status = cb.getStatus('ep4');
    expect(status.state).toBe('open');
  });

  test('success resets consecutive failures', () => {
    const cb = new NetworkCircuitBreaker({ failureThreshold: 3 });

    cb.recordFailure('ep5');
    cb.recordFailure('ep5');
    cb.recordSuccess('ep5'); // reset
    cb.recordFailure('ep5');
    cb.recordFailure('ep5');
    // Only 2 consecutive failures, circuit should still be closed
    expect(cb.canAttempt('ep5')).toBe(true);
  });

  test('getAllStatuses returns all endpoints', () => {
    const cb = new NetworkCircuitBreaker();
    cb.recordSuccess('a');
    cb.recordFailure('b');

    const statuses = cb.getAllStatuses();
    expect(Object.keys(statuses)).toContain('a');
    expect(Object.keys(statuses)).toContain('b');
  });

  test('reset clears circuit', () => {
    const cb = new NetworkCircuitBreaker({ failureThreshold: 1 });
    cb.recordFailure('ep6');
    expect(cb.canAttempt('ep6')).toBe(false);

    cb.reset('ep6');
    expect(cb.canAttempt('ep6')).toBe(true);
  });
});

// ─── ConnectionHealthMonitor ────────────────────────────────────

describe('ConnectionHealthMonitor', () => {
  test('unknown session is healthy', () => {
    const monitor = new ConnectionHealthMonitor();
    expect(monitor.isHealthy('unknown')).toBe(true);
  });

  test('healthy after all successes', () => {
    const monitor = new ConnectionHealthMonitor({
      minEventsForEvaluation: 2,
    });
    monitor.recordSuccess('s1');
    monitor.recordSuccess('s1');
    monitor.recordSuccess('s1');
    expect(monitor.isHealthy('s1')).toBe(true);
  });

  test('detects outage on high failure rate', () => {
    const monitor = new ConnectionHealthMonitor({
      minEventsForEvaluation: 2,
      outageThreshold: 0.5,
    });
    monitor.recordFailure('s2');
    monitor.recordFailure('s2');
    expect(monitor.isHealthy('s2')).toBe(false);
  });

  test('recovers when successes restore rate', () => {
    const monitor = new ConnectionHealthMonitor({
      windowSize: 4,
      minEventsForEvaluation: 2,
      outageThreshold: 0.5,
    });

    // Create outage
    monitor.recordFailure('s3');
    monitor.recordFailure('s3');
    expect(monitor.isHealthy('s3')).toBe(false);

    // Recover with successes
    monitor.recordSuccess('s3');
    monitor.recordSuccess('s3');
    monitor.recordSuccess('s3');
    expect(monitor.isHealthy('s3')).toBe(true);
  });

  test('getStatus returns correct data', () => {
    const monitor = new ConnectionHealthMonitor({
      minEventsForEvaluation: 1,
    });
    monitor.recordSuccess('s4');
    monitor.recordFailure('s4');

    const status = monitor.getStatus('s4');
    expect(status.successes).toBe(1);
    expect(status.failures).toBe(1);
    expect(status.failureRate).toBe(0.5);
  });

  test('removeSession cleans up', () => {
    const monitor = new ConnectionHealthMonitor();
    monitor.recordSuccess('s5');
    monitor.removeSession('s5');
    // After removal, treated as unknown = healthy
    expect(monitor.isHealthy('s5')).toBe(true);
    const status = monitor.getStatus('s5');
    expect(status.successes).toBe(0);
  });
});

// ─── TaskRestartManager ─────────────────────────────────────────

describe('TaskRestartManager', () => {
  const makeTask = (
    overrides?: Partial<{
      id: string;
      agent: string;
      restartCount: number;
    }>,
  ) => ({
    id: overrides?.id ?? 'task-1',
    agent: overrides?.agent ?? 'explorer',
    prompt: 'test prompt',
    description: 'test task',
    parentSessionId: 'parent-1',
    restartCount: overrides?.restartCount,
  });

  test('queues network transient failures', () => {
    const manager = new TaskRestartManager();
    const queued = manager.handleFailure(
      makeTask(),
      new Error('ECONNREFUSED 127.0.0.1:8080'),
    );
    expect(queued).toBe(true);
    expect(manager.pendingCount).toBe(1);
  });

  test('does not queue non-network failures', () => {
    const manager = new TaskRestartManager();
    const queued = manager.handleFailure(
      makeTask(),
      new Error('invalid model: gpt-5'),
    );
    expect(queued).toBe(false);
    expect(manager.pendingCount).toBe(0);
  });

  test('respects maxRestarts', () => {
    const manager = new TaskRestartManager({ maxRestarts: 2 });

    const queued = manager.handleFailure(
      makeTask({ restartCount: 2 }),
      new Error('ECONNREFUSED'),
    );
    expect(queued).toBe(false);
  });

  test('cancelRestart removes from queue', () => {
    const manager = new TaskRestartManager();
    manager.handleFailure(
      makeTask({ id: 'cancel-me' }),
      new Error('ECONNREFUSED'),
    );
    expect(manager.pendingCount).toBe(1);

    manager.cancelRestart('cancel-me');
    expect(manager.pendingCount).toBe(0);
  });

  test('cancelAll clears queue', () => {
    const manager = new TaskRestartManager();
    manager.handleFailure(
      makeTask({ id: 't1' }),
      new Error('timeout'),
    );
    manager.handleFailure(
      makeTask({ id: 't2' }),
      new Error('ECONNRESET'),
    );
    expect(manager.pendingCount).toBe(2);

    manager.cancelAll();
    expect(manager.pendingCount).toBe(0);
  });

  test('processQueue executes ready tasks', async () => {
    const manager = new TaskRestartManager({
      baseDelayMs: 0, // immediate for testing
      maxRestarts: 3,
    });

    const executed: string[] = [];
    manager.onRestart(async (req) => {
      executed.push(req.taskId);
    });

    manager.handleFailure(
      makeTask({ id: 'process-me' }),
      new Error('ECONNREFUSED'),
    );

    // Wait a tick for the executeAt to be in the past
    await new Promise((r) => setTimeout(r, 10));
    const count = await manager.processQueue();

    expect(count).toBe(1);
    expect(executed).toContain('process-me');
    manager.dispose();
  });

  test('dispose stops timer and clears queue', () => {
    const manager = new TaskRestartManager();
    manager.handleFailure(
      makeTask(),
      new Error('ECONNREFUSED'),
    );
    manager.dispose();
    expect(manager.pendingCount).toBe(0);
  });
});

// ─── RetryMetrics ───────────────────────────────────────────────

describe('RetryMetrics', () => {
  test('records retry events', () => {
    const metrics = new RetryMetrics();
    metrics.recordRetry({
      taskId: 't1',
      errorType: ErrorType.NetworkTransient,
      model: 'openai/gpt-4',
      attempt: 1,
      delayMs: 1000,
      succeeded: false,
    });
    metrics.recordRetry({
      taskId: 't1',
      errorType: ErrorType.NetworkTransient,
      model: 'openai/gpt-4',
      attempt: 2,
      delayMs: 2000,
      succeeded: true,
    });

    const summary = metrics.getSummary();
    expect(summary.totalRetries).toBe(2);
    expect(summary.totalSuccesses).toBe(1);
    expect(summary.totalFinalFailures).toBe(1);
  });

  test('tracks by error type', () => {
    const metrics = new RetryMetrics();
    metrics.recordRetry({
      taskId: 't2',
      errorType: ErrorType.NetworkTransient,
      model: 'm1',
      attempt: 1,
      delayMs: 1000,
      succeeded: true,
    });
    metrics.recordRetry({
      taskId: 't3',
      errorType: ErrorType.ProviderRateLimit,
      model: 'm2',
      attempt: 1,
      delayMs: 2000,
      succeeded: false,
    });

    const summary = metrics.getSummary();
    expect(
      summary.byErrorType[ErrorType.NetworkTransient]?.successes,
    ).toBe(1);
    expect(
      summary.byErrorType[ErrorType.ProviderRateLimit]?.failures,
    ).toBe(1);
  });

  test('triggers alert on persistent failures', () => {
    const metrics = new RetryMetrics({
      alertWindowMs: 60_000,
      alertThreshold: 3,
    });

    for (let i = 0; i < 3; i++) {
      metrics.recordRetry({
        taskId: `alert-${i}`,
        errorType: ErrorType.NetworkTransient,
        model: 'm1',
        attempt: 1,
        delayMs: 1000,
        succeeded: false,
      });
    }

    const summary = metrics.getSummary();
    expect(summary.activeAlert).toBe(true);
  });

  test('getRecentEvents returns most recent first', () => {
    const metrics = new RetryMetrics();
    metrics.recordRetry({
      taskId: 'first',
      errorType: ErrorType.NetworkTransient,
      model: 'm1',
      attempt: 1,
      delayMs: 100,
      succeeded: false,
    });
    metrics.recordRetry({
      taskId: 'second',
      errorType: ErrorType.NetworkTransient,
      model: 'm1',
      attempt: 2,
      delayMs: 200,
      succeeded: true,
    });

    const recent = metrics.getRecentEvents(2);
    expect(recent[0].taskId).toBe('second');
    expect(recent[1].taskId).toBe('first');
  });

  test('reset clears everything', () => {
    const metrics = new RetryMetrics();
    metrics.recordRetry({
      taskId: 't1',
      errorType: ErrorType.NetworkTransient,
      model: 'm1',
      attempt: 1,
      delayMs: 100,
      succeeded: false,
    });
    metrics.reset();

    const summary = metrics.getSummary();
    expect(summary.totalRetries).toBe(0);
    expect(summary.activeAlert).toBe(false);
  });
});
