# Designer Consultation: DECISION_037

**Decision ID**: INFRA-037
**Decision Title**: Subagent Fallback System Hardening
**Consultation Date**: 2026-02-20
**Designer Status**: Strategist Assimilated

---

## Designer Assessment

### Approval Rating: 90%

---

## Implementation Strategy

### Phase 1: Foundation (Week 1)
**Goal**: Error classification and backoff infrastructure

1. **ErrorClassifier** (`src/background/resilience/error-classifier.ts`)
   - Classify errors into: NetworkTransient, NetworkPermanent, ProviderRateLimit, ProviderError, LogicError, ContextLength
   - Pattern matching for 50+ error types
   - Unit tests with real error messages

2. **BackoffManager** (`src/background/resilience/backoff-manager.ts`)
   - Exponential backoff: 1s, 2s, 4s, 8s, 16s (capped at 30s)
   - Jitter: 20% randomization
   - Per-key tracking with reset on success

3. **Integration** into background-manager.ts
   - Replace existing `isConnectivityError()` with ErrorClassifier
   - Replace fixed 500ms delays with BackoffManager

### Phase 2: Monitoring (Week 1-2)
**Goal**: Connection health and circuit breaking

1. **ConnectionHealthMonitor** (`src/background/resilience/connection-monitor.ts`)
   - Pre-flight connection checks before prompts
   - Periodic ping/keepalive (30s interval)
   - Session death detection (tmux pane crash, process exit)
   - Health metrics: latency, success rate, failure rate

2. **NetworkCircuitBreaker** (`src/background/resilience/network-circuit-breaker.ts`)
   - Per-endpoint tracking (not just model)
   - 5-failure threshold, 5-minute cooldown
   - Health check probes after cooldown
   - Half-open state for recovery testing

### Phase 3: Recovery (Week 2)
**Goal**: Automatic task restart

1. **TaskRestartManager** (`src/background/resilience/task-restart.ts`)
   - Detect network-failure vs logic-failure
   - Queue for automatic restart with same parameters
   - Max 3 restarts per task
   - Exponential backoff between restarts (1m, 2m, 4m)
   - Preserve task context and history

2. **RetryVisibility** (`src/background/resilience/visibility.ts`)
   - Log all retry attempts with error type and backoff duration
   - Surface in task status
   - Network health metrics reporting
   - Alert on persistent issues (10+ failures in 5 minutes)

### Phase 4: Testing & Hardening (Week 2-3)
**Goal**: Production readiness

1. **Unit Tests** (`src/background/resilience/*.test.ts`)
   - ErrorClassifier with 50+ error patterns
   - BackoffManager timing verification
   - Circuit breaker state transitions
   - Task restart queue management

2. **Integration Tests** (`src/background/background-manager.test.ts`)
   - Mock network failures
   - Simulated provider outages
   - Load testing for circuit breaker

---

## Files to Create

| File | Purpose | Lines (Est) |
|------|---------|-------------|
| `src/background/resilience/error-classifier.ts` | Error type classification | 150 |
| `src/background/resilience/backoff-manager.ts` | Exponential backoff with jitter | 100 |
| `src/background/resilience/connection-monitor.ts` | Session health monitoring | 120 |
| `src/background/resilience/network-circuit-breaker.ts` | Per-endpoint circuit breaker | 80 |
| `src/background/resilience/task-restart.ts` | Automatic task restart | 100 |
| `src/background/resilience/visibility.ts` | Retry logging and metrics | 60 |
| `src/background/resilience/index.ts` | Module exports | 20 |
| `src/background/resilience/types.ts` | Shared types and interfaces | 50 |

**Total**: ~680 new lines across 8 files

---

## Files to Modify

| File | Changes | Lines Affected |
|------|---------|----------------|
| `src/background/background-manager.ts` | Integrate resilience layer, replace retry logic | Lines 1199-1257 |
| `src/config/constants.ts` | Add network resilience constants | +30 lines |
| `src/config/schema.ts` | Add NetworkResilienceConfigSchema | +50 lines |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Network Resilience Layer                        │
│                    (src/background/resilience/)                    │
└─────────────────────────────────────────────────────────────────┘

ErrorClassifier ──▶ RetryStrategy ──▶ BackoffManager
       │                                     │
       └────────────────┬────────────────────┘
                        ▼
              ConnectionHealthMonitor
                        │
                        ▼
              NetworkCircuitBreaker
                        │
                        ▼
               TaskRestartManager
```

---

## Configuration Schema

```typescript
// src/config/schema.ts
const NetworkResilienceConfigSchema = z.object({
  retry: z.object({
    maxNetworkRetries: z.number().default(5),
    baseDelayMs: z.number().default(1000),
    maxDelayMs: z.number().default(30000),
    jitterPercent: z.number().default(0.2),
  }),
  circuitBreaker: z.object({
    failureThreshold: z.number().default(5),
    cooldownMs: z.number().default(300000), // 5 minutes
    healthProbeEnabled: z.boolean().default(true),
  }),
  taskRestart: z.object({
    maxRestarts: z.number().default(3),
    restartBackoffBaseMs: z.number().default(60000),
  }),
  healthCheck: z.object({
    pingIntervalMs: z.number().default(30000),
    unhealthyThreshold: z.number().default(0.5), // 50% failure rate
  }),
  visibility: z.object({
    logRetries: z.boolean().default(true),
    alertThreshold: z.number().default(10), // failures in 5 minutes
  }),
});
```

---

## Key Design Decisions

### 1. Network Retries Separate from Model Fallback
- Network errors retry SAME model with backoff
- Provider errors fall back to NEXT model immediately
- Rationale: Connection issues are transient; provider issues are not

### 2. Per-Endpoint Circuit Breaking
- Track failures by endpoint URL, not just model name
- Allows granular control when multiple models share same provider
- Example: Claude on OpenRouter vs Claude direct have separate circuits

### 3. Task Restart vs Task Retry
- Task Retry: Immediate retry within same execution
- Task Restart: Queue for new execution after delay
- Rationale: Network outages may last minutes; restart gives time for recovery

---

## Integration Points

### background-manager.ts Changes

```typescript
// Lines 1199-1257 replacement
async executeWithResilience<T>(
  task: () => Promise<T>,
  context: TaskContext
): Promise<T> {
  const classifier = new ErrorClassifier();
  const backoff = new BackoffManager(this.config.resilience);
  const circuitBreaker = new NetworkCircuitBreaker(this.config.resilience);
  
  let lastError: Error;
  
  while (true) {
    // Pre-flight check
    if (!await this.connectionMonitor.isHealthy(context.sessionId)) {
      await this.connectionMonitor.waitForRecovery(context.sessionId);
    }
    
    // Circuit breaker check
    if (!circuitBreaker.canAttempt(context.endpoint)) {
      throw new Error(`Circuit breaker open for ${context.endpoint}`);
    }
    
    try {
      const result = await task();
      backoff.reset(context.key);
      circuitBreaker.recordSuccess(context.endpoint);
      return result;
    } catch (error) {
      lastError = error;
      const errorType = classifier.classify(error);
      
      if (errorType === ErrorType.NetworkTransient) {
        const canRetry = await backoff.wait(errorType, context.key);
        if (!canRetry) break;
        continue;
      }
      
      if (errorType === ErrorType.ProviderRateLimit) {
        circuitBreaker.recordFailure(context.endpoint);
        const canRetry = await backoff.wait(errorType, context.key);
        if (!canRetry) break;
        continue;
      }
      
      // Permanent errors - no retry
      break;
    }
  }
  
  // Consider task restart for network failures
  if (classifier.classify(lastError) === ErrorType.NetworkTransient) {
    await this.taskRestartManager.maybeQueue(context, lastError);
  }
  
  throw lastError;
}
```

---

## Backward Compatibility

- Existing `MAX_MODEL_RETRIES` and `RETRY_DELAY_MS` constants deprecated but supported
- Feature flag `enableNetworkResilience` to roll out gradually
- Default configuration matches current behavior (disabled)
- Migration path: enable per-agent, monitor, expand

---

## Validation Steps

1. **Pre-flight**: CDP health check before prompt
2. **Signal injection**: Verify test signal created
3. **Classification**: Verify error type logged correctly
4. **Backoff**: Verify exponential delays with jitter
5. **Circuit breaker**: Verify opens at threshold, closes after cooldown
6. **Task restart**: Verify queued for restart on network failure

---

## Fallback Mechanisms

1. **Circuit breaker fallback**: If circuit breaker stuck open, manual override via config
2. **Health monitor fallback**: If ping fails, assume healthy (fail-open)
3. **Restart fallback**: If restart queue full, fail immediately
4. **Config fallback**: If resilience config missing, use legacy behavior

---

## Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Network error classification accuracy | 95%+ | Unit test coverage |
| Network failure recovery rate | 80%+ | Retry success tracking |
| Average retries before success | 3 | Metrics logging |
| Circuit breaker false positives | <5% | Health probe validation |
| Task restart success rate | 90%+ | Restart queue tracking |

---

*Designer Consultation by Strategist (Role Assimilated)*
*2026-02-20*
