# DECISION_037: Subagent Fallback System Hardening

**Decision ID**: INFRA-037  
**Category**: INFRA  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-20  
**Oracle Approval**: 92% (Strategist Assimilated)  
**Designer Approval**: 90% (Completed)  
**Implemented By**: OpenFixer  
**Implementation Date**: 2026-02-20  
**Verification**: COMPLETED — Resilience module deployed to oh-my-opencode-theseus plugin
- Files Created: 7 source + 1 test in `~/.config/opencode/dev/src/background/resilience/`
- Tests: 88 resilience tests pass, 377 total plugin tests pass (0 failures)
- Build: Plugin built (0.96 MB) and deployed to `~/.config/opencode/plugins/`
- Integration: ErrorClassifier, BackoffManager, NetworkCircuitBreaker, ConnectionHealthMonitor, TaskRestartManager, RetryMetrics all wired into background-manager.ts
- Backward Compatible: Existing retry logic preserved as fallback

---

## Executive Summary

The subagent fallback system in the oh-my-opencode-theseus plugin has network resilience gaps that cause subagent tasks to fail when transient network issues occur. When the Nexus sends the same prompt multiple times due to server unresponsiveness, human intervention allows recovery—but subagents have no such mechanism. This decision establishes automated retry logic with exponential backoff, network error detection, and seamless fallback chaining to ensure subagent reliability matches the robustness of the main session.

**Current Problem**:
- Subagent tasks fail on transient network errors without retry
- No human to retry prompts when subagent server is unresponsive
- Network issues (ECONNREFUSED, ECONNRESET, timeout) kill subagent tasks
- Current retry logic (10 retries at 500ms) is insufficient for network recovery
- Subagents cannot recover from temporary provider unavailability

**Proposed Solution**:
- Implement intelligent network error detection and classification
- Add exponential backoff retry with jitter for network failures
- Create network-level circuit breaker separate from model-level circuit breaker
- Establish connection health monitoring for subagent sessions
- Add automatic subagent task restart on recoverable network failures
- Implement retry persistence across model fallback chains

---

## Background

### Current State

**Existing Fallback Infrastructure** (from background-manager.ts analysis):

1. **Model-Level Fallback**:
   - Circuit breaker pattern (3 failures = 1 hour cooldown)
   - Model chain resolution from config
   - Provider-aware prioritization
   - Triage tracking for model health
   - 10 retries per model at 500ms intervals

2. **Error Classification**:
   - `detectProviderError()`: 40+ error patterns detected
   - `isPermanentError()`: Auth, permission, invalid model errors
   - `isConnectivityError()`: Network/connection error detection
   - `isContextLengthError()`: Compaction-triggering errors

3. **Current Retry Logic** (lines 1203-1257):
   ```typescript
   while (modelRetryCount < this.MAX_MODEL_RETRIES && !modelSucceeded) {
     modelRetryCount++;
     try {
       await this.promptWithTimeout(...);
       // Success handling
     } catch (error) {
       // Error handling with permanent error check
       // But NO network-specific retry strategy
     }
   }
   ```

**Identified Gaps**:
1. Network errors are treated same as other errors—no special handling
2. No exponential backoff—fixed 500ms delay regardless of error type
3. No connection health checks before attempting prompts
4. Subagent session connectivity not monitored independently
5. Network recovery not detected to resume normal operation
6. No task restart mechanism for network-related failures

### Desired State

A resilient subagent system that:
1. Detects network errors specifically and applies aggressive retry
2. Uses exponential backoff with jitter for network recovery
3. Monitors connection health and pauses during network outages
4. Automatically restarts subagent tasks when network recovers
5. Distinguishes between network failures (retryable) and logic failures (not)
6. Provides clear visibility into network-related retry activity

---

## Specification

### Requirements

#### INFRA-037-001: Network Error Classification
**Priority**: Must  
**Acceptance Criteria**:
- Expand `isConnectivityError()` to detect all network failure modes
- Classify errors as: `NetworkTransient`, `NetworkPermanent`, `ProviderError`, `LogicError`
- Add patterns for: DNS failures, TLS errors, proxy failures, gateway timeouts
- Distinguish between "cannot reach provider" vs "provider rejecting request"

#### INFRA-037-002: Exponential Backoff Retry
**Priority**: Must  
**Acceptance Criteria**:
- Network errors: exponential backoff (1s, 2s, 4s, 8s, 16s) with jitter
- Max 5 network retries before escalating to next model in chain
- Reset backoff counter on successful connection
- Different retry strategy for different error types:
  - Network transient: exponential backoff
  - Provider rate limit: exponential backoff with longer delays
  - Other errors: immediate fallback to next model

#### INFRA-037-003: Connection Health Monitor
**Priority**: Must  
**Acceptance Criteria**:
- Pre-flight connection check before sending prompts
- Monitor session health via periodic ping/keepalive
- Detect session death (tmux pane crash, process exit)
- Track connection quality metrics (latency, success rate)
- Pause task execution during detected network outages

#### INFRA-037-004: Network Circuit Breaker
**Priority**: Should  
**Acceptance Criteria**:
- Separate circuit breaker for network-level failures
- Track failures per provider endpoint (not just model)
- Shorter cooldown period for network issues (5 minutes vs 1 hour)
- Automatic health check probe after cooldown
- Distinguish between "provider down" vs "model overloaded"

#### INFRA-037-005: Automatic Task Restart
**Priority**: Should  
**Acceptance Criteria**:
- Detect when subagent task failed due to network (not logic)
- Queue task for automatic restart with same parameters
- Limit restart attempts (max 3 restarts per task)
- Exponential backoff between restart attempts
- Preserve task context and history across restarts

#### INFRA-037-006: Retry Visibility
**Priority**: Should  
**Acceptance Criteria**:
- Log all retry attempts with error type and backoff duration
- Surface network retry activity in task status
- Report network health metrics (retry count, success rate)
- Alert on persistent network issues (10+ failures in 5 minutes)

### Technical Details

**Architecture**:
```
┌─────────────────────────────────────────────────────────────────┐
│                  Network Resilience Layer                        │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  ErrorClassifier │───▶│  RetryStrategy   │───▶│  BackoffManager  │
│                  │    │   (per type)     │    │ (exponential +   │
│ - Network        │    │                  │    │  jitter)         │
│ - Provider       │    │ - Network: exp   │    │                  │
│ - Logic          │    │ - Provider: exp+ │    │ - Track delays   │
│ - Permanent      │    │ - Logic: none    │    │ - Reset on success│
└──────────────────┘    └──────────────────┘    └──────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 ▼
                    ┌──────────────────────┐
                    │  ConnectionMonitor   │
                    │                      │
                    │ - Pre-flight checks  │
                    │ - Keepalive pings    │
                    │ - Health metrics     │
                    │ - Outage detection   │
                    └──────────┬───────────┘
                               ▼
                    ┌──────────────────────┐
                    │  NetworkCircuitBreaker│
                    │                      │
                    │ - Per-endpoint tracking│
                    │ - 5-min cooldown      │
                    │ - Health probes       │
                    └──────────┬───────────┘
                               ▼
                    ┌──────────────────────┐
                    │   TaskRestartManager │
                    │                      │
                    │ - Network failure detect│
                    │ - Auto-restart queue  │
                    │ - Max 3 restarts      │
                    │ - Context preservation │
                    └──────────────────────┘
```

**Implementation Plan**:

1. **Error Classification Enhancement**:
   ```typescript
   enum ErrorType {
     NetworkTransient,  // Retry with exponential backoff
     NetworkPermanent,  // Fail immediately
     ProviderRateLimit, // Retry with longer backoff
     ProviderError,     // Fallback to next model
     LogicError,        // Fail immediately
     ContextLength,     // Compact and retry
   }

   class ErrorClassifier {
     classify(error: Error): ErrorType {
       const msg = error.message;
       
       // Network transient patterns
       if (/econnrefused|econnreset|enotfound|timeout|unable to connect/i.test(msg)) {
         return ErrorType.NetworkTransient;
       }
       
       // Network permanent patterns
       if (/cert.*error|ssl.*error|proxy.*error/i.test(msg)) {
         return ErrorType.NetworkPermanent;
       }
       
       // Provider rate limit
       if (/rate.*limit|429|too many requests/i.test(msg)) {
         return ErrorType.ProviderRateLimit;
       }
       
       // ... etc
     }
   }
   ```

2. **Exponential Backoff Manager**:
   ```typescript
   class BackoffManager {
     private attempts = new Map<string, number>();
     private readonly baseDelayMs = 1000;
     private readonly maxDelayMs = 30000;
     private readonly jitterPercent = 0.2;

     async wait(errorType: ErrorType, key: string): Promise<boolean> {
       const attempt = this.attempts.get(key) ?? 0;
       const maxAttempts = this.getMaxAttempts(errorType);
       
       if (attempt >= maxAttempts) {
         return false; // Max retries exceeded
       }
       
       const delay = this.calculateDelay(errorType, attempt);
       this.attempts.set(key, attempt + 1);
       
       await sleep(delay);
       return true;
     }

     reset(key: string): void {
       this.attempts.delete(key);
     }

     private calculateDelay(errorType: ErrorType, attempt: number): number {
       const base = this.baseDelayMs * Math.pow(2, attempt);
       const capped = Math.min(base, this.maxDelayMs);
       const jitter = capped * this.jitterPercent * (Math.random() - 0.5);
       return Math.floor(capped + jitter);
     }
   }
   ```

3. **Connection Health Monitor**:
   ```typescript
   class ConnectionHealthMonitor {
     private readonly healthChecks = new Map<string, HealthStatus>();
     private readonly pingIntervalMs = 30000;

     async checkConnection(sessionId: string): Promise<boolean> {
       try {
         await this.client.session.ping({ path: { id: sessionId } });
         this.recordSuccess(sessionId);
         return true;
       } catch (error) {
         this.recordFailure(sessionId);
         return false;
       }
     }

     isHealthy(sessionId: string): boolean {
       const health = this.healthChecks.get(sessionId);
       if (!health) return true; // Unknown = assume healthy
       return health.failureRate < 0.5; // Less than 50% failure rate
     }
   }
   ```

4. **Network Circuit Breaker**:
   ```typescript
   class NetworkCircuitBreaker {
     private readonly circuits = new Map<string, CircuitState>();
     private readonly failureThreshold = 5;
     private readonly cooldownMs = 300000; // 5 minutes

     canAttempt(endpoint: string): boolean {
       const state = this.circuits.get(endpoint);
       if (!state) return true;
       
       if (state.status === 'open') {
         if (Date.now() - state.lastFailure > this.cooldownMs) {
           // Try half-open
           state.status = 'half-open';
           return true;
         }
         return false;
       }
       
       return true;
     }

     recordFailure(endpoint: string): void {
       const state = this.circuits.get(endpoint) ?? { failures: 0, status: 'closed' };
       state.failures++;
       state.lastFailure = Date.now();
       
       if (state.failures >= this.failureThreshold) {
         state.status = 'open';
       }
       
       this.circuits.set(endpoint, state);
     }
   }
   ```

5. **Task Restart Manager**:
   ```typescript
   class TaskRestartManager {
     private readonly restartQueue: RestartRequest[] = [];
     private readonly maxRestarts = 3;
     private readonly restartBackoffMs = 60000; // 1 minute base

     async handleTaskFailure(task: BackgroundTask, error: Error): Promise<void> {
       const errorType = this.errorClassifier.classify(error);
       
       if (errorType !== ErrorType.NetworkTransient) {
         return; // Don't restart non-network failures
       }
       
       const restartCount = task.restartCount ?? 0;
       if (restartCount >= this.maxRestarts) {
         log(`[restart] Max restarts reached for task ${task.id}`);
         return;
       }
       
       const delay = this.restartBackoffMs * Math.pow(2, restartCount);
       
       this.restartQueue.push({
         task,
         restartCount: restartCount + 1,
         executeAt: Date.now() + delay,
       });
       
       log(`[restart] Queued task ${task.id} for restart in ${delay}ms`);
     }
   }
   ```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-037-001 | Create ErrorClassifier with network error patterns | OpenFixer | Complete | Critical |
| ACT-037-002 | Implement BackoffManager with exponential backoff + jitter | OpenFixer | Complete | Critical |
| ACT-037-003 | Create ConnectionHealthMonitor for session health | OpenFixer | Complete | Critical |
| ACT-037-004 | Implement NetworkCircuitBreaker (per-endpoint) | OpenFixer | Complete | High |
| ACT-037-005 | Create TaskRestartManager for auto-restart | OpenFixer | Complete | High |
| ACT-037-006 | Integrate resilience layer into BackgroundTaskManager | OpenFixer | Complete | Critical |
| ACT-037-007 | Add retry visibility logging and metrics | OpenFixer | Complete | Medium |
| ACT-037-008 | Write unit tests for error classification | OpenFixer | Complete | High |
| ACT-037-009 | Write integration tests for retry scenarios | OpenFixer | Complete | High |
| ACT-037-010 | Update plugin configuration schema | OpenFixer | Deferred | Medium |
| ACT-037-011 | Document retry behavior for users | OpenFixer | Deferred | Low |

---

## Dependencies

- **Blocks**: DECISION_035, DECISION_036 (subagents need reliable fallback for testing)
- **Blocked By**: None
- **Related**: oh-my-opencode-theseus plugin, background-manager.ts

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Aggressive retry overloads provider | High | Medium | Implement circuit breaker; max retry limits; exponential backoff caps at 30s |
| Task restart causes duplicate work | Medium | Medium | Track restart count; preserve operation IDs for idempotency; max 3 restarts |
| False positive network error classification | Medium | Low | Comprehensive error pattern testing; classification validation |
| Increased latency from backoff delays | Medium | Low | Cap max delay at 30s; allow immediate fallback on permanent errors |
| Circuit breaker blocks all providers | High | Low | Per-endpoint tracking; health check probes; manual override capability |
| Tmux session leaks on restart | Medium | Medium | Cleanup orphaned sessions; session timeout enforcement |

---

## Success Criteria

1. **Network Error Detection**: 95%+ accuracy in classifying network vs logic errors
2. **Retry Success**: 80%+ of network-related subagent failures succeed on retry
3. **Backoff Effectiveness**: Average 3 retries before success or final fallback
4. **Circuit Breaker**: No more than 5 consecutive failures to same endpoint before opening
5. **Task Restart**: 90%+ of network-failed tasks succeed after auto-restart
6. **Visibility**: All retry activity logged with error type and duration
7. **No Regression**: Existing model fallback behavior unchanged for non-network errors

---

## Consultation Log

### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 92%
- **Key Findings**:
  - Feasibility Score: 9/10 - Builds on existing background-manager.ts infrastructure
  - Risk Score: 3/10 - Well-understood problem with proven solution patterns
  - Complexity Score: 5/10 - Modular components, clear integration points
  - Top Risks: (1) Aggressive retry overloading providers, (2) False positive error classification, (3) Task restart causing duplicate work
  - Critical Success Factor: Proper error classification accuracy (target 95%+)
  - Recommendation: Implement phased deployment with feature flags; start with ErrorClassifier + BackoffManager
  - Safety Limits: Max 5 network retries, 30s max delay, circuit breaker at 5 failures, max 3 task restarts
  - Network vs Model: Keep network retries separate from model fallback—network issues should retry same model
- **File**: consultations/oracle/DECISION_037_oracle.md

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: 90%
- **Key Findings**:
  - Implementation Strategy: 4-phase approach over 3 weeks
  - Phase 1 (Week 1): ErrorClassifier + BackoffManager foundation
  - Phase 2 (Week 1-2): ConnectionHealthMonitor + NetworkCircuitBreaker
  - Phase 3 (Week 2): TaskRestartManager + visibility
  - Phase 4 (Week 2-3): Testing + hardening
  - Files to Create: 9 new files in `src/background/resilience/`
  - Files to Modify: background-manager.ts (lines 1199-1257), config/schema.ts, config/constants.ts
  - Integration: ErrorClassifier replaces existing isConnectivityError/isPermanentError; BackoffManager replaces fixed 500ms delays
  - Configuration: NetworkResilienceConfigSchema with retry, circuitBreaker, taskRestart, healthCheck, visibility sections
  - Backward Compatibility: Existing MAX_MODEL_RETRIES and RETRY_DELAY_MS deprecated but supported
  - Key Design Decision: Network retries separate from model fallback—retry same model on network errors
  - Testing: Unit tests for classification/backoff; integration tests with mock network failures; load testing for circuit breaker
- **File**: consultations/designer/DECISION_037_designer.md

---

## Notes

**Plugin Location**: `C:/Users/paulc/.config/opencode/dev`

**Key Files to Modify**:
- `src/background/background-manager.ts` - Main integration point
- `src/config/constants.ts` - Retry configuration constants
- `src/config/schema.ts` - Configuration schema updates

**Testing Strategy**:
- Unit tests for ErrorClassifier with real error messages
- Mock network failures in background-manager.test.ts
- Integration tests with simulated provider outages
- Load testing to verify circuit breaker behavior

**Monitoring**:
- Track retry success rates per provider
- Monitor circuit breaker state changes
- Alert on persistent network issues
- Log all restart activity

**Related Patterns**:
- P4NTHE0N CircuitBreaker (C0MMON) - similar pattern, different context
- P4NTHE0N SystemDegradationManager - could share backoff strategies

---

*Decision INFRA-037*  
*Subagent Fallback System Hardening*  
*2026-02-20*
