---
type: decision
id: DECISION_073
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.711Z'
last_reviewed: '2026-02-23T01:31:15.711Z'
keywords:
  - decision073
  - fix
  - websocket
  - balance
  - query
  - error
  - handling
  - executive
  - summary
  - background
  - current
  - state
  - desired
  - specification
  - requirements
  - technical
  - details
  - action
  - items
  - dependencies
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: BUG-005 **Category**: CORE **Status**: Completed
  **Priority**: High **Date**: 2026-02-21 **Oracle Approval**: 90% (Assimilated
  - Important reliability fix) **Designer Approval**: 90% (Assimilated -
  Standard resilience pattern)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_073.md
---
# DECISION_073: Fix WebSocket Balance Query Error Handling

**Decision ID**: BUG-005  
**Category**: CORE  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-21  
**Oracle Approval**: 90% (Assimilated - Important reliability fix)  
**Designer Approval**: 90% (Assimilated - Standard resilience pattern)

---

## Executive Summary

**ISSUE IDENTIFIED**: WebSocket balance queries in `FireKirin.QueryBalances()` and `OrionStars.QueryBalances()` lack graceful degradation. When config fetch fails, WebSocket connection fails, or authentication fails, exceptions are thrown with no fallback, causing credentials to be skipped and potentially locked (see DECISION_070).

**Root Cause**: The QueryBalances methods throw exceptions for any failure (config fetch, connection, auth, timeout) with no retry logic, no cached config fallback, and no error logging to ERR0R collection. Failures bubble up and cause credential locks.

**Impact**: 
- Temporary network issues cause permanent credential skips
- No visibility into why balance queries fail
- Game server downtime blocks all polling
- No resilience against transient failures

---

## Background

### Current State

In `C0MMON/Games/FireKirin.cs` lines 127-218:

```csharp
public static FireKirinBalances QueryBalances(string username, string password)
{
    FireKirinNetConfig config = FetchNetConfig();  // <-- Throws on failure
    string wsUrl = $"{config.GameProtocol}{config.BsIp}:{config.WsPort}";
    using var ws = new ClientWebSocket();
    
    // <-- Throws on connection failure
    ws.ConnectAsync(new Uri(wsUrl), connectCts.Token).GetAwaiter().GetResult();
    
    // <-- Throws on auth failure
    SendJson(ws, new { mainID = 100, subID = 6, ... });
    
    // <-- Throws on timeout
    WaitForMessage(ws, 100, 116, TimeSpan.FromSeconds(10), ...);
    
    // ... jackpot query ...
    
    return new FireKirinBalances(balance, grand, major, minor, mini);
}
```

**Failure Points:**
1. `FetchNetConfig()` - HTTP request to get server config
2. `ws.ConnectAsync()` - WebSocket connection
3. `SendJson()` - Authentication request
4. `WaitForMessage()` - Response timeout
5. Any exception bubbles up and causes credential lock

### Desired State

Balance queries have multiple layers of resilience:
- Cached config fallback when fetch fails
- Retry with backoff for transient failures
- Error logging to ERR0R collection
- Graceful degradation (return last known values or zeros)
- Circuit breaker to prevent hammering failed servers

---

## Specification

### Requirements

**BUG-005-1**: Add retry with exponential backoff for balance queries
- **Priority**: Must
- **Acceptance Criteria**: 
  - Retry WebSocket operations up to 3 times
  - Exponential backoff between retries (1s, 2s, 4s)
  - Only throw after all retries exhausted
  - Log each retry attempt

**BUG-005-2**: Cache config and use as fallback
- **Priority**: Must
- **Acceptance Criteria**:
  - Cache FireKirinNetConfig in memory (static or singleton)
  - If FetchNetConfig fails, use cached config
  - Cache expires after 1 hour
  - Log when using cached config

**BUG-005-3**: Log errors to ERR0R collection
- **Priority**: Must
- **Acceptance Criteria**:
  - All balance query failures logged to ERR0R collection
  - Include credential info (username, game) but NOT password
  - Include specific failure reason (config, connection, auth, timeout)
  - Include retry count

**BUG-005-4**: Return graceful fallback values
- **Priority**: Should
- **Acceptance Criteria**:
  - After all retries exhausted, return zeros instead of throwing
  - Log fallback at WARNING level
  - Allow credential to be unlocked and retried later
  - Don't mark credential as banned

### Technical Details

**Files to Modify**:
- `C0MMON/Games/FireKirin.cs` - QueryBalances method
- `C0MMON/Games/OrionStars.cs` - QueryBalances method

**Implementation Pattern**:
```csharp
private static FireKirinNetConfig? _cachedConfig;
private static DateTime _configCacheTime = DateTime.MinValue;
private static readonly TimeSpan ConfigCacheTtl = TimeSpan.FromHours(1);

public static FireKirinBalances QueryBalances(string username, string password, IStoreErrors? errorLog = null)
{
    int retryCount = 0;
    Exception? lastException = null;
    
    while (retryCount < 3)
    {
        try
        {
            return QueryBalancesInternal(username, password);
        }
        catch (Exception ex)
        {
            lastException = ex;
            retryCount++;
            
            if (retryCount < 3)
            {
                int delayMs = (int)Math.Pow(2, retryCount) * 1000; // 2s, 4s
                errorLog?.Insert(ErrorLog.Create(
                    ErrorType.NetworkError,
                    "FireKirin.QueryBalances",
                    $"Attempt {retryCount} failed for {username}: {ex.Message}. Retrying in {delayMs}ms...",
                    ErrorSeverity.Medium
                ));
                Thread.Sleep(delayMs);
            }
        }
    }
    
    // All retries failed - log final error and return zeros
    errorLog?.Insert(ErrorLog.Create(
        ErrorType.NetworkError,
        "FireKirin.QueryBalances",
        $"All {retryCount} attempts failed for {username}: {lastException?.Message}",
        ErrorSeverity.High
    ));
    
    return new FireKirinBalances(0, 0, 0, 0, 0); // Graceful fallback
}

private static FireKirinBalances QueryBalancesInternal(string username, string password)
{
    FireKirinNetConfig config = GetConfigWithCache();
    // ... rest of implementation ...
}

private static FireKirinNetConfig GetConfigWithCache()
{
    if (_cachedConfig != null && DateTime.UtcNow - _configCacheTime < ConfigCacheTtl)
    {
        return _cachedConfig;
    }
    
    try
    {
        _cachedConfig = FetchNetConfig();
        _configCacheTime = DateTime.UtcNow;
        return _cachedConfig;
    }
    catch
    {
        if (_cachedConfig != null)
        {
            // Use stale cache rather than fail
            return _cachedConfig;
        }
        throw; // No cache available, must throw
    }
}
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-073-1 | Add retry logic to FireKirin.QueryBalances | @windfixer | Pending | High |
| ACT-073-2 | Add retry logic to OrionStars.QueryBalances | @windfixer | Pending | High |
| ACT-073-3 | Implement config caching with fallback | @windfixer | Pending | High |
| ACT-073-4 | Add error logging to ERR0R collection | @windfixer | Pending | High |
| ACT-073-5 | Add graceful fallback to return zeros | @windfixer | Pending | High |
| ACT-073-6 | Create unit tests for retry logic | @windfixer | Pending | High |

---

## Dependencies

- **Blocks**: DECISION_070 (Lock leak - this reduces lock-causing exceptions)
- **Blocked By**: None
- **Related**: DECISION_069, DECISION_070, DECISION_071, DECISION_072

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Stale config causes persistent failures | Medium | Low | Config cache expires after 1 hour; failures still retry |
| Returning zeros causes false jackpot resets | Medium | Medium | Only return zeros after all retries; log clearly |
| Increased latency from retries | Low | High | Max 3 retries with exponential backoff; acceptable |
| Memory leak from static cache | Low | Low | Cache is small (one config object); use static field |

---

## Success Criteria

1. Balance queries retry 3 times before failing
2. Config is cached and used as fallback
3. All failures logged to ERR0R collection
4. Graceful fallback returns zeros instead of throwing
5. Credentials are not locked due to transient failures

---

## Token Budget

- **Estimated**: 15,000 tokens
- **Model**: Claude 3.5 Sonnet (WindFixer)
- **Budget Category**: Bug Fix (<20K)

---

*Decision BUG-005*  
*Fix WebSocket Balance Query Error Handling*  
*2026-02-21*
