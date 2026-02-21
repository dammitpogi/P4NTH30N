# DECISION_070: Fix Credential Lock Leak in H0UND Polling Loop

**Decision ID**: BUG-002  
**Category**: CORE  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-21  
**Oracle Approval**: 95% (Assimilated - Critical bug fix)  
**Designer Approval**: 95% (Assimilated - Clear fix path)

---

## Executive Summary

**CRITICAL BUG DISCOVERED**: When `GetBalancesWithRetry()` throws an exception, the credential is **NEVER UNLOCKED**, causing it to be skipped forever by subsequent `GetNext()` calls. This creates a cascading failure where entire house/game combinations become permanently unavailable for polling.

**Root Cause**: In `H0UND.cs`, the `uow.Credentials.Unlock(credential)` call only occurs in the happy path or two specific catch blocks (`CircuitBreakerOpenException`, account suspended). Any other exception (WebSocket timeout, DNS failure, balance query failure) escapes without unlocking.

**Impact**: 
- Credentials that fail polling are permanently locked
- `GetNext()` skips locked credentials when selecting next to poll
- Eventually ALL credentials for a house/game become locked
- No new jackpot data, no DPD calculations, no signals
- System appears to work but produces no actionable output

---

## Background

### Current State (BROKEN)

In `H0UND/H0UND.cs` lines 170-220:

```csharp
uow.Credentials.Lock(credential);

try
{
    // ... balance polling logic ...
    
    // SUCCESS PATH - unlock happens here (line 367)
    uow.Credentials.Unlock(credential);
    credential.LastUpdated = DateTime.UtcNow;
    uow.Credentials.Upsert(credential);
}
catch (CircuitBreakerOpenException)
{
    // Unlock happens here (line 411)
    uow.Credentials.Unlock(credential);
    Thread.Sleep(5000);
}
catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
{
    // Unlock happens here (line 420)
    uow.Credentials.Unlock(credential);
}
// ALL OTHER EXCEPTIONS ESCAPE WITHOUT UNLOCKING!
```

**The Problem Flow:**
1. `GetNext()` selects a credential and `Lock()` is called
2. `GetBalancesWithRetry()` throws after 3 failed attempts
3. Exception is NOT `CircuitBreakerOpenException` or suspended account
4. Exception bubbles to outer catch (lines 424-442)
5. **Credential is NEVER unlocked**
6. Next iteration: `GetNext()` skips this locked credential
7. After multiple failures, ALL credentials are locked
8. **System can no longer poll any credentials**

### Evidence

- `login_failures.log` shows "Server busy / no WS response" errors
- No corresponding unlock operations in logs
- MongoDB shows credentials with `Unlocked = false`
- DPD data never accumulates because credentials aren't being polled

### Desired State (FIXED)

Credentials are ALWAYS unlocked after polling attempt, regardless of success or failure, ensuring the polling queue continues to function.

---

## Specification

### Requirements

**BUG-002-1**: Ensure credentials are always unlocked after polling
- **Priority**: Must
- **Acceptance Criteria**: 
  - Add `finally` block around polling logic to guarantee unlock
  - Credential is unlocked even when exceptions occur
  - No credential remains locked after polling attempt completes

**BUG-002-2**: Add unit test for credential unlock guarantee
- **Priority**: Must
- **Acceptance Criteria**:
  - Unit test simulates `QueryBalances` throwing exception
  - Verifies `Unlock()` is called even when exception occurs
  - Test fails with current code, passes with fix

**BUG-002-3**: Audit all credential lock/unlock pairs
- **Priority**: Should
- **Acceptance Criteria**:
  - Review all `Lock()` calls in H0UND
  - Ensure every `Lock()` has corresponding `Unlock()` in `finally` block
  - Document any intentional exceptions

### Technical Details

**File to Modify**: `H0UND/H0UND.cs`

**Current Code (lines 170-220)**:
```csharp
uow.Credentials.Lock(credential);

try
{
    // Circuit breaker around API polling
    (double Balance, double Grand, double Major, double Minor, double Mini) balances = s_apiCircuit
        .ExecuteAsync(async () =>
        {
            return pollingWorker.GetBalancesWithRetry(credential, uow);
        })
        .GetAwaiter()
        .GetResult();

    // ... validation and processing ...

    // SUCCESS PATH
    Dashboard.IncrementPoll(true);
    uow.Credentials.Unlock(credential);  // <-- ONLY HERE
    credential.LastUpdated = DateTime.UtcNow;
    uow.Credentials.Upsert(credential);
}
catch (CircuitBreakerOpenException)
{
    Dashboard.AddLog($"API circuit open - skipping {credential.Username}@{credential.Game}", "yellow");
    Dashboard.IncrementPoll(false);
    Dashboard.Render();
    uow.Credentials.Unlock(credential);  // <-- HERE
    Thread.Sleep(5000);
}
catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
{
    Dashboard.AddLog($"Account suspended for {credential.Username} on {credential.Game}", "red");
    Dashboard.TrackError("AccountSuspended");
    Dashboard.IncrementPoll(false);
    Dashboard.Render();
    uow.Credentials.Unlock(credential);  // <-- HERE
}
// Missing: catch-all that unlocks before rethrowing
```

**Fixed Code**:
```csharp
uow.Credentials.Lock(credential);
bool unlockCalled = false;

try
{
    // Circuit breaker around API polling
    (double Balance, double Grand, double Major, double Minor, double Mini) balances = s_apiCircuit
        .ExecuteAsync(async () =>
        {
            return pollingWorker.GetBalancesWithRetry(credential, uow);
        })
        .GetAwaiter()
        .GetResult();

    // ... validation and processing ...

    // SUCCESS PATH
    Dashboard.IncrementPoll(true);
}
catch (CircuitBreakerOpenException)
{
    Dashboard.AddLog($"API circuit open - skipping {credential.Username}@{credential.Game}", "yellow");
    Dashboard.IncrementPoll(false);
    Dashboard.Render();
    Thread.Sleep(5000);
}
catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
{
    Dashboard.AddLog($"Account suspended for {credential.Username} on {credential.Game}", "red");
    Dashboard.TrackError("AccountSuspended");
    Dashboard.IncrementPoll(false);
    Dashboard.Render();
}
catch (Exception ex)
{
    // Log the error but don't prevent unlock
    Dashboard.AddLog($"Polling error for {credential.Username}@{credential.Game}: {ex.Message}", "red");
    Dashboard.TrackError("PollingException");
    Dashboard.IncrementPoll(false);
    Dashboard.Render();
}
finally
{
    // CRITICAL: Always unlock, even if exception occurred
    if (!unlockCalled)
    {
        uow.Credentials.Unlock(credential);
        unlockCalled = true;
    }
    credential.LastUpdated = DateTime.UtcNow;
    uow.Credentials.Upsert(credential);
}
```

**Alternative Simpler Fix** (using `try-finally` pattern):
```csharp
uow.Credentials.Lock(credential);

try
{
    // ... entire polling logic including all catch blocks ...
}
finally
{
    // CRITICAL BUG-002: Always unlock credential regardless of success/failure
    // This prevents credentials from being permanently locked when exceptions occur
    uow.Credentials.Unlock(credential);
    credential.LastUpdated = DateTime.UtcNow;
    uow.Credentials.Upsert(credential);
}
```

**Unit Test Location**: `UNI7T35T/H0UND/H0UNDCredentialLockTests.cs` (create)

**Unit Test Requirements**:
- Mock `IUnitOfWork`, `IRepoCredentials`, `PollingWorker`
- Setup `pollingWorker.GetBalancesWithRetry()` to throw `Exception`
- Call the polling loop logic
- Verify `uow.Credentials.Unlock()` is called exactly once
- Verify test fails with current code (no unlock), passes with fix

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-070-1 | Add `finally` block to guarantee credential unlock in H0UND.cs | @windfixer | Pending | Critical |
| ACT-070-2 | Create unit test verifying unlock happens on exception | @windfixer | Pending | Critical |
| ACT-070-3 | Run existing tests to ensure no regression | @windfixer | Pending | Critical |
| ACT-070-4 | Audit all Lock/Unlock pairs in codebase | @windfixer | Pending | High |

---

## Dependencies

- **Blocks**: DECISION_047 (Burn-in cannot proceed with locked credentials)
- **Blocked By**: None
- **Related**: DECISION_069 (DPD data loss - credentials locked can't accumulate data)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| `finally` block masks other issues | Low | Low | Keep existing catch blocks for specific handling, add `finally` for guarantee |
| Unlock called twice (redundant) | Low | Low | Use boolean flag or move unlock ONLY to `finally` block |
| Performance impact of `finally` | None | None | `finally` has negligible overhead |
| Test flakiness | Low | Medium | Use strict mock verification with `Received(1)` |

---

## Success Criteria

1. **Immediate**: `Unlock()` is called in `finally` block
2. **Short-term**: Unit test verifies unlock on exception
3. **Medium-term**: No permanently locked credentials in MongoDB
4. **Long-term**: All credentials continue to be polled even after failures
5. **Final**: DPD data accumulates because credentials are being polled

---

## Token Budget

- **Estimated**: 12,000 tokens
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
  - Critical resource leak confirmed
  - `finally` block is standard pattern for guaranteed cleanup
  - Risk is minimal, impact is severe
  - Unit test essential to prevent regression

### Designer Consultation (Assimilated)
- **Date**: 2026-02-21
- **Approval**: 95%
- **Key Findings**:
  - `try-finally` pattern is correct approach
  - Alternative: `using` statement with disposable lock context
  - Keep existing catch blocks for specific error handling
  - Move shared cleanup (Unlock, LastUpdated, Upsert) to `finally`

---

## Notes

**Discovery Process**:
1. Explorer audit identified missing unlock in exception paths
2. Reviewed H0UND.cs exception handling flow
3. Confirmed `Unlock()` only in 3 of many possible code paths
4. Identified that `GetBalancesWithRetry()` throws after 3 retries
5. Confirmed exception bubbles to outer catch without unlocking

**Why This Was Missed**:
- Code reviews focused on happy path
- Exception handling appeared complete (multiple catch blocks)
- Missing catch-all was not obvious
- Integration tests didn't simulate persistent failures
- Lock state not visible in normal operation

**Related Files**:
- `H0UND/H0UND.cs` (main fix)
- `C0MMON/Interfaces/IRepoCredentials.cs` (Lock/Unlock interface)
- `C0MMON/Infrastructure/Persistence/Repositories.cs` (Lock/Unlock implementation)

**Pattern to Apply**:
```csharp
// ALWAYS use this pattern for lock/unlock
resource.Lock();
try
{
    // ... work ...
}
finally
{
    resource.Unlock(); // Guaranteed to execute
}
```

---

*Decision BUG-002*  
*Fix Credential Lock Leak in H0UND Polling Loop*  
*2026-02-21*
