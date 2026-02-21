# DECISION_072: Fix Idempotent Signal Generator Silent Group Drops

**Decision ID**: BUG-004  
**Category**: CORE  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-21  
**Oracle Approval**: 95% (Assimilated - Critical bug fix)  
**Designer Approval**: 95% (Assimilated - Clear fix path)

---

## Executive Summary

**CRITICAL BUG DISCOVERED**: When `IdempotentSignalGenerator` encounters lock contention, cache timeouts, or unexpected exceptions, it **SILENTLY RETURNS EMPTY LIST** for that entire house/game group. No retry, no fallback, no alerting - the signals for that group are simply dropped without trace.

**Root Cause**: In `IdempotentSignalGenerator.ProcessGroupWithProtection()`, multiple code paths return `new List<Signal>()` when errors occur (lines 114, 121, 174). These empty returns are not logged at error level, and the caller (`GenerateSignals`) continues processing other groups without knowing signals were lost.

**Impact**: 
- Under lock contention, entire house/game groups lose signals
- No visibility into how many signals are being dropped
- System appears to work but produces fewer signals than expected
- Burn-in may pass but with reduced signal coverage
- DECISION_047 parallel execution is undermined by silent signal loss

---

## Background

### Current State (BROKEN)

In `H0UND/Domain/Signals/IdempotentSignalGenerator.cs` lines 85-188:

```csharp
private List<Signal> ProcessGroupWithProtection(
    IUnitOfWork uow,
    IGrouping<(string House, string Game), Credential> group,
    List<Jackpot> jackpots,
    List<Signal> existingSignals,
    string lockResource)
{
    // Phase 1: Try to acquire distributed lock
    bool lockAcquired = false;
    try
    {
        lockAcquired = _circuitBreaker
            .ExecuteAsync(async () =>
            {
                return _lockService.TryAcquire(lockResource, _instanceId, s_lockTtl);
            })
            .GetAwaiter()
            .GetResult();
    }
    catch (Exception ex)
    {
        _logger?.Invoke($"[IdempotentSignal] Lock acquire failed for {lockResource}: {ex.Message}");
        _metrics.RecordLockContention();
        return new List<Signal>();  // <-- SILENT DROP #1
    }

    if (!lockAcquired)
    {
        _metrics.RecordLockContention();
        _logger?.Invoke($"[IdempotentSignal] Lock contention on {lockResource} — skipping");
        return new List<Signal>();  // <-- SILENT DROP #2
    }

    try
    {
        // Phase 2: Generate signals
        List<Signal> qualified = _retryPolicy.Execute(
            () =>
            {
                return SignalService.GenerateSignals(uow, new List<IGrouping<...>> { group }, groupJackpots, existingSignals);
            },
            $"GenerateSignals:{lockResource}"
        );
        // ... deduplication ...
        return deduplicated;
    }
    catch (Exception ex)
    {
        // Dead-letter failed signals
        _logger?.Invoke($"[IdempotentSignal] Signal generation failed for {lockResource}: {ex.Message}");
        Signal deadSignal = new() { ... };
        _deadLetterQueue.Enqueue(deadSignal, $"Generation failed: {ex.Message}", ex);
        _metrics.RecordDeadLettered();
        return new List<Signal>();  // <-- SILENT DROP #3
    }
}
```

**The Problem Flow:**
1. `GenerateSignals()` iterates through all house/game groups
2. For each group, calls `ProcessGroupWithProtection()`
3. If lock fails: returns empty list, logs at info level
4. If lock contention: returns empty list, logs at info level  
5. If generation fails: returns empty list, logs at info level, dead-letters one signal
6. **All signals for that group are lost**
7. **No error-level alerting occurs**
8. **Metrics are recorded but may be ignored**

**Three Silent Drop Points:**
1. **Line 114**: Lock acquisition exception → returns empty
2. **Line 121**: Lock not acquired (contention) → returns empty
3. **Line 174**: Signal generation exception → returns empty

### Evidence

- Idempotent signal generation is enabled (`UseIdempotentSignals = true`)
- Lock contention metrics may be non-zero but not investigated
- Signal count lower than expected for number of credentials
- No error logs about signal generation failures
- Dead letter queue may have entries but not monitored

### Desired State (FIXED)

Signal generation failures are:
1. **Logged at ERROR level** for visibility
2. **Retried with backoff** when transient (lock contention)
3. **Alerted** when signals are dropped
4. **Escalated** when multiple groups fail

---

## Specification

### Requirements

**BUG-004-1**: Add proper error logging and alerting for signal drops
- **Priority**: Must
- **Acceptance Criteria**: 
  - Log at ERROR level when signals are dropped
  - Include house/game identifier in error log
  - Include reason for drop (lock failure, contention, generation error)
  - Alert when >10% of groups drop signals in a single run

**BUG-004-2**: Implement retry with backoff for lock contention
- **Priority**: Must
- **Acceptance Criteria**:
  - Retry lock acquisition up to 3 times with exponential backoff
  - Only return empty after retries exhausted
  - Each retry logged at WARNING level
  - Final failure logged at ERROR level

**BUG-004-3**: Add circuit breaker for signal generation failures
- **Priority**: Should
- **Acceptance Criteria**:
  - Track signal generation failure rate per house/game
  - If >5 failures in 5 minutes, bypass idempotent generator for that group
  - Fall back to direct `SignalService.GenerateSignals()` call
  - Log fallback activation

**BUG-004-4**: Add unit test for signal drop scenarios
- **Priority**: Must
- **Acceptance Criteria**:
  - Test lock contention scenario
  - Test lock acquisition failure scenario
  - Test signal generation exception scenario
  - Verify ERROR level logging occurs
  - Verify retry logic works

### Technical Details

**File to Modify**: `H0UND/Domain/Signals/IdempotentSignalGenerator.cs`

**Current Code (simplified)**:
```csharp
private List<Signal> ProcessGroupWithProtection(...)
{
    // Lock acquisition
    try { ... }
    catch (Exception ex)
    {
        _logger?.Invoke($"[IdempotentSignal] Lock acquire failed...");  // Info level
        return new List<Signal>();  // Silent drop
    }

    if (!lockAcquired)
    {
        _logger?.Invoke($"[IdempotentSignal] Lock contention...");  // Info level
        return new List<Signal>();  // Silent drop
    }

    try { ... }
    catch (Exception ex)
    {
        _logger?.Invoke($"[IdempotentSignal] Signal generation failed...");  // Info level
        return new List<Signal>();  // Silent drop
    }
}
```

**Fixed Code**:
```csharp
private List<Signal> ProcessGroupWithProtection(...)
{
    // BUG-004: Retry lock acquisition with backoff
    int lockAttempts = 0;
    bool lockAcquired = false;
    Exception? lastLockException = null;
    
    while (lockAttempts < 3 && !lockAcquired)
    {
        try
        {
            lockAcquired = _circuitBreaker
                .ExecuteAsync(async () =>
                {
                    return _lockService.TryAcquire(lockResource, _instanceId, s_lockTtl);
                })
                .GetAwaiter()
                .GetResult();
            
            if (!lockAcquired && lockAttempts < 2)
            {
                _logger?.Invoke($"[IdempotentSignal] Lock attempt {lockAttempts + 1} failed for {lockResource}, retrying...", "warning");
                Thread.Sleep(100 * (int)Math.Pow(2, lockAttempts)); // Exponential backoff
            }
        }
        catch (Exception ex)
        {
            lastLockException = ex;
            if (lockAttempts < 2)
            {
                _logger?.Invoke($"[IdempotentSignal] Lock exception on attempt {lockAttempts + 1} for {lockResource}: {ex.Message}", "warning");
                Thread.Sleep(100 * (int)Math.Pow(2, lockAttempts));
            }
        }
        lockAttempts++;
    }

    if (!lockAcquired)
    {
        // BUG-004: Log at ERROR level, not info
        string errorMsg = lastLockException != null 
            ? $"Lock acquisition failed after 3 attempts for {lockResource}: {lastLockException.Message}"
            : $"Lock contention persisted after 3 attempts for {lockResource}";
        
        _logger?.Invoke($"[IdempotentSignal] ERROR: {errorMsg}. DROPPING SIGNALS for {group.Key.House}/{group.Key.Game}", "red");
        _metrics.RecordSignalDrop(group.Key.House, group.Key.Game, "LockFailure");
        
        // BUG-004: Fall back to non-idempotent generation
        _logger?.Invoke($"[IdempotentSignal] FALLBACK: Using direct SignalService for {lockResource}", "yellow");
        return SignalService.GenerateSignals(uow, new List<IGrouping<...>> { group }, 
            jackpots.Where(j => j.House == group.Key.House && j.Game == group.Key.Game).ToList(), 
            existingSignals);
    }

    try
    {
        // ... signal generation ...
        return deduplicated;
    }
    catch (Exception ex)
    {
        // BUG-004: Log at ERROR level with full context
        _logger?.Invoke($"[IdempotentSignal] ERROR: Signal generation failed for {lockResource}: {ex.Message}. DROPPING SIGNALS for {group.Key.House}/{group.Key.Game}", "red");
        _metrics.RecordSignalDrop(group.Key.House, group.Key.Game, "GenerationFailure");
        
        // Still dead-letter but also fall back
        Signal deadSignal = new() { House = group.Key.House, Game = group.Key.Game, Username = "GROUP_FAILURE", Priority = 0 };
        _deadLetterQueue.Enqueue(deadSignal, $"Generation failed: {ex.Message}", ex);
        _metrics.RecordDeadLettered();
        
        // BUG-004: Fall back to non-idempotent generation instead of returning empty
        _logger?.Invoke($"[IdempotentSignal] FALLBACK: Using direct SignalService for {lockResource}", "yellow");
        return SignalService.GenerateSignals(uow, new List<IGrouping<...>> { group }, 
            jackpots.Where(j => j.House == group.Key.House && j.Game == group.Key.Game).ToList(), 
            existingSignals);
    }
    finally
    {
        // Always release lock
        try { _lockService.Release(lockResource, _instanceId); }
        catch (Exception ex) { _logger?.Invoke($"[IdempotentSignal] Lock release failed: {ex.Message}"); }
    }
}
```

**Additional Metrics to Add**:
```csharp
// In SignalMetrics class
public void RecordSignalDrop(string house, string game, string reason)
{
    _signalDrops++;
    _logger?.Invoke($"[SignalMetrics] Signal drop recorded: {house}/{game} - {reason}. Total drops: {_signalDrops}", "red");
}
```

**Unit Test Location**: `UNI7T35T/H0UND/IdempotentSignalGeneratorTests.cs` (create)

**Unit Test Requirements**:
- Mock `ILockService` to simulate lock failures
- Mock `ILockService` to simulate lock contention
- Mock `SignalService` to throw exception
- Verify ERROR level logging occurs
- Verify retry logic executes
- Verify fallback to `SignalService.GenerateSignals()` occurs
- Verify metrics are recorded

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-072-1 | Add retry logic with backoff for lock acquisition | @windfixer | Pending | Critical |
| ACT-072-2 | Change log level to ERROR for signal drops | @windfixer | Pending | Critical |
| ACT-072-3 | Add fallback to direct SignalService on failure | @windfixer | Pending | Critical |
| ACT-072-4 | Add SignalDrop metrics tracking | @windfixer | Pending | High |
| ACT-072-5 | Create unit test for signal drop scenarios | @windfixer | Pending | Critical |
| ACT-072-6 | Run existing tests to ensure no regression | @windfixer | Pending | Critical |

---

## Dependencies

- **Blocks**: DECISION_047 (Parallel execution undermined by silent signal loss)
- **Blocked By**: None
- **Related**: 
  - DECISION_069 (DPD data loss)
  - DECISION_070 (Lock leak)
  - DECISION_071 (Signal wipe)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Fallback causes duplicate signals | Medium | Medium | Deduplication cache should catch duplicates; monitor for duplicates |
| Retry increases latency | Low | High | Max 3 retries with short backoff; acceptable for signal accuracy |
| Excessive error logging | Low | Medium | Log once per group per run, not per retry |
| Fallback bypasses idempotency | Medium | Low | Acceptable tradeoff for signal availability; dedup cache still active |

---

## Success Criteria

1. **Immediate**: ERROR level logging for all signal drops
2. **Short-term**: Retry logic prevents transient lock failures
3. **Medium-term**: Fallback ensures signals are generated even when idempotent path fails
4. **Long-term**: Signal count matches expected count for credentials
5. **Final**: No silent signal loss, all drops are visible and alerted

---

## Token Budget

- **Estimated**: 18,000 tokens
- **Model**: Claude 3.5 Sonnet (WindFixer)
- **Budget Category**: Bug Fix (<20K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On config error**: Delegate to @openfixer
- **On test failure**: WindFixer self-resolves or delegates to Forgewright if >30min blocked
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Consultation Log

### Oracle Consultation (Assimilated)
- **Date**: 2026-02-21
- **Approval**: 95%
- **Key Findings**: 
  - Silent failures are critical anti-pattern
  - Retry with backoff is standard resilience pattern
  - Fallback to direct generation maintains availability
  - Error logging essential for observability

### Designer Consultation (Assimilated)
- **Date**: 2026-02-21
- **Approval**: 95%
- **Key Findings**:
  - 3 retry attempts with exponential backoff (100ms, 200ms, 400ms)
  - Fallback to SignalService maintains signal flow
  - Add SignalDrop metric for monitoring
  - Ensure finally block releases lock even on fallback

---

## Notes

**Discovery Process**:
1. Explorer audit identified multiple silent return points
2. Reviewed ProcessGroupWithProtection error handling
3. Realized empty returns were logged at info level only
4. Identified three distinct failure modes
5. Confirmed no retry or fallback exists

**Why This Was Missed**:
- Idempotent generator appeared to work (no errors)
- Info-level logs were not investigated
- Metrics existed but weren't monitored
- Signal count discrepancy attributed to other causes
- Silent failures are hardest to detect

**Related Files**:
- `H0UND/Domain/Signals/IdempotentSignalGenerator.cs` (main fix)
- `H0UND/Domain/Signals/SignalService.cs` (fallback target)
- `C0MMON/Infrastructure/Monitoring/SignalMetrics.cs` (metrics)

**Monitoring Recommendations**:
- Alert when `SignalDrops` metric > 0
- Alert when `LockContention` metric > 10% of groups
- Dashboard widget showing signals dropped per run
- Weekly review of dead letter queue

---

*Decision BUG-004*  
*Fix Idempotent Signal Generator Silent Group Drops*  
*2026-02-21*
