---
type: decision
id: DECISION_071
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.709Z'
last_reviewed: '2026-02-23T01:31:15.709Z'
keywords:
  - decision071
  - fix
  - analytics
  - signal
  - wipe
  - generation
  - failure
  - executive
  - summary
  - background
  - current
  - state
  - broken
  - evidence
  - desired
  - fixed
  - specification
  - requirements
  - technical
  - details
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: BUG-003 **Category**: CORE **Status**: Completed
  **Priority**: Critical **Date**: 2026-02-21 **Oracle Approval**: 95%
  (Assimilated - Critical bug fix) **Designer Approval**: 95% (Assimilated -
  Clear fix path)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_071.md
---
# DECISION_071: Fix Analytics Signal Wipe on Generation Failure

**Decision ID**: BUG-003  
**Category**: CORE  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-21  
**Oracle Approval**: 95% (Assimilated - Critical bug fix)  
**Designer Approval**: 95% (Assimilated - Clear fix path)

---

## Executive Summary

**CRITICAL BUG DISCOVERED**: When `SignalService.GenerateSignals()` fails or returns empty, `AnalyticsWorker` calls `CleanupStaleSignals()` which **DELETES ALL EXISTING SIGNALS** from MongoDB. This wipes the entire signal queue, leaving H4ND with nothing to execute.

**Root Cause**: In `AnalyticsWorker.RunAnalytics()`, `CleanupStaleSignals()` is called unconditionally after signal generation, even when `qualifiedSignals` is empty due to generation failure. The cleanup logic deletes any signal not in the `qualifiedSignals` list - when that list is empty, ALL signals are deleted.

**Impact**: 
- Any signal generation failure wipes the entire SIGN4L collection
- H4ND loses all pending signals immediately
- System appears to work but has nothing to execute
- Burn-in cannot proceed because signals are deleted as fast as they're created
- DECISION_069 fix (DPD persistence) is undermined because signals get deleted anyway

---

## Background

### Current State (BROKEN)

In `H0UND/Application/Analytics/AnalyticsWorker.cs` lines 38-44:

```csharp
List<Jackpot> upcomingJackpots = GetUpcomingJackpots(jackpots, groups, dateLimit);
List<Signal> qualifiedSignals =
    _idempotentGenerator != null
        ? _idempotentGenerator.GenerateSignals(uow, groups, upcomingJackpots, signals)
        : SignalService.GenerateSignals(uow, groups, upcomingJackpots, signals);
SignalService.CleanupStaleSignals(uow, signals, qualifiedSignals);  // <-- ALWAYS CALLED
```

**The Problem Flow:**
1. `signals` = all existing signals from MongoDB (e.g., 50 signals)
2. `GenerateSignals()` fails due to exception OR returns empty (e.g., DPD=0, no thresholds met)
3. `qualifiedSignals` = empty list
4. `CleanupStaleSignals(uow, signals, qualifiedSignals)` is called
5. Cleanup iterates through all 50 existing signals
6. For each signal: `qualifiedSignals.Any(q => matches)` returns false (empty list)
7. **All 50 signals are deleted from MongoDB**
8. H4ND now has 0 signals to process

**CleanupStaleSignals Logic** (SignalService.cs lines 72-82):
```csharp
public static void CleanupStaleSignals(IUnitOfWork uow, List<Signal> signals, List<Signal> qualifiedSignals)
{
    foreach (Signal sig in signals)  // All existing signals
    {
        bool hasQualified = qualifiedSignals.Any(q => q.House == sig.House && q.Game == sig.Game && q.Username == sig.Username);
        if (!hasQualified)  // When qualifiedSignals is empty, this is ALWAYS true
        {
            uow.Signals.Delete(sig);  // <-- DELETES EVERYTHING
        }
    }
}
```

### Evidence

- SIGN4L collection has 0-3 signals despite 310 credentials
- DPD data accumulates (after DECISION_069 fix) but signals still 0
- Analytics runs every 10 seconds but signal count never grows
- Cleanup is called every run, wiping any signals that were created

### Desired State (FIXED)

Signal cleanup only occurs when signal generation succeeds and produces valid results. Failed generation preserves existing signals to prevent total signal loss.

---

## Specification

### Requirements

**BUG-003-1**: Guard cleanup to prevent wiping signals on generation failure
- **Priority**: Must
- **Acceptance Criteria**: 
  - Skip cleanup when `qualifiedSignals` is empty but `signals` is not empty
  - Log warning when cleanup is skipped due to generation failure
  - Only delete signals when generation succeeds

**BUG-003-2**: Add unit test for signal preservation on failure
- **Priority**: Must
- **Acceptance Criteria**:
  - Unit test simulates `GenerateSignals` returning empty list
  - Verifies existing signals are NOT deleted
  - Verifies cleanup IS called when generation succeeds
  - Test fails with current code, passes with fix

**BUG-003-3**: Add metrics for signal cleanup operations
- **Priority**: Should
- **Acceptance Criteria**:
  - Track number of signals deleted per cleanup
  - Track number of times cleanup is skipped
  - Alert when cleanup deletes >50% of signals

### Technical Details

**File to Modify**: `H0UND/Application/Analytics/AnalyticsWorker.cs`

**Current Code (lines 38-44)**:
```csharp
List<Jackpot> upcomingJackpots = GetUpcomingJackpots(jackpots, groups, dateLimit);
List<Signal> qualifiedSignals =
    _idempotentGenerator != null
        ? _idempotentGenerator.GenerateSignals(uow, groups, upcomingJackpots, signals)
        : SignalService.GenerateSignals(uow, groups, upcomingJackpots, signals);
SignalService.CleanupStaleSignals(uow, signals, qualifiedSignals);  // <-- UNCONDITIONAL
```

**Fixed Code**:
```csharp
List<Jackpot> upcomingJackpots = GetUpcomingJackpots(jackpots, groups, dateLimit);
List<Signal> qualifiedSignals;

try
{
    qualifiedSignals = _idempotentGenerator != null
        ? _idempotentGenerator.GenerateSignals(uow, groups, upcomingJackpots, signals)
        : SignalService.GenerateSignals(uow, groups, upcomingJackpots, signals);
}
catch (Exception ex)
{
    Dashboard.AddAnalyticsLog($"Signal generation failed: {ex.Message}. Preserving existing signals.", "red");
    qualifiedSignals = new List<Signal>(); // Empty but don't cleanup
    // Skip cleanup - preserve existing signals
    return; // Exit early, don't cleanup
}

// BUG-003: Only cleanup if generation succeeded and produced results
// OR if there were no existing signals to preserve
if (qualifiedSignals.Count > 0 || signals.Count == 0)
{
    SignalService.CleanupStaleSignals(uow, signals, qualifiedSignals);
}
else
{
    // Generation returned empty but we have existing signals - preserve them
    Dashboard.AddAnalyticsLog($"Signal generation returned empty but {signals.Count} signals exist. Preserving existing signals.", "yellow");
}
```

**Alternative Approach** (modify CleanupStaleSignals itself):
```csharp
// In SignalService.cs
public static void CleanupStaleSignals(IUnitOfWork uow, List<Signal> signals, List<Signal> qualifiedSignals)
{
    // BUG-003: Don't delete everything if qualifiedSignals is empty
    if (qualifiedSignals.Count == 0 && signals.Count > 0)
    {
        // Generation failed or produced no results - preserve existing signals
        return;
    }
    
    foreach (Signal sig in signals)
    {
        bool hasQualified = qualifiedSignals.Any(q => q.House == sig.House && q.Game == sig.Game && q.Username == sig.Username);
        if (!hasQualified)
        {
            uow.Signals.Delete(sig);
        }
    }
}
```

**Unit Test Location**: `UNI7T35T/H0UND/AnalyticsWorkerSignalPreservationTests.cs` (create)

**Unit Test Requirements**:
- Mock `IUnitOfWork`, `IRepoSignals`, `IRepoJackpots`
- Setup existing signals in database (e.g., 5 signals)
- Mock `GenerateSignals` to return empty list
- Call `RunAnalytics()`
- Verify `Delete()` is NEVER called on any signal
- Mock `GenerateSignals` to return new signals
- Call `RunAnalytics()` again
- Verify `Delete()` IS called for stale signals

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-071-1 | Add guard to skip cleanup when generation fails in AnalyticsWorker.cs | @windfixer | Pending | Critical |
| ACT-071-2 | Create unit test verifying signal preservation on failure | @windfixer | Pending | Critical |
| ACT-071-3 | Add logging when cleanup is skipped | @windfixer | Pending | High |
| ACT-071-4 | Run existing tests to ensure no regression | @windfixer | Pending | Critical |

---

## Dependencies

- **Blocks**: DECISION_047 (Burn-in cannot proceed if signals are deleted)
- **Blocked By**: None
- **Related**: 
  - DECISION_069 (DPD data loss - signals need DPD to generate)
  - DECISION_070 (Lock leak - credentials need to be polled to generate signals)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Stale signals accumulate forever | Medium | Low | Still cleanup when generation succeeds; add max age check |
| Memory pressure from preserved signals | Low | Low | Signals are in MongoDB, not memory; cleanup on success |
| Test flakiness with mock verification | Low | Medium | Use strict mock with `DidNotReceive()` for negative case |
| False positives in "generation failure" detection | Medium | Low | Only skip cleanup when qualifiedSignals is empty AND signals exist |

---

## Success Criteria

1. **Immediate**: Cleanup is guarded and skipped on generation failure
2. **Short-term**: Unit test verifies signal preservation
3. **Medium-term**: Existing signals persist across analytics runs
4. **Long-term**: Signal count grows over time instead of staying at 0
5. **Final**: H4ND has signals to execute, burn-in can proceed

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
  - Critical data loss bug confirmed
  - Guard clause is standard defensive programming
  - Risk is minimal, impact is severe
  - Unit test essential to prevent regression

### Designer Consultation (Assimilated)
- **Date**: 2026-02-21
- **Approval**: 95%
- **Key Findings**:
  - Guard in AnalyticsWorker is cleaner than modifying CleanupStaleSignals
  - Alternative: Add safety check in CleanupStaleSignals as defense in depth
  - Consider both approaches for maximum safety
  - Log when cleanup is skipped for observability

---

## Notes

**Discovery Process**:
1. Explorer audit identified unconditional cleanup call
2. Reviewed CleanupStaleSignals logic
3. Realized empty qualifiedSignals causes total deletion
4. Connected to DECISION_069 (DPD fix undermined by this bug)
5. Confirmed signals never accumulate in SIGN4L collection

**Why This Was Missed**:
- Cleanup appeared correct (removes stale signals)
- Edge case (empty generation) not considered
- No unit test for generation failure scenario
- Integration tests didn't check signal count across multiple runs
- Assumed generation would always succeed

**Related Files**:
- `H0UND/Application/Analytics/AnalyticsWorker.cs` (main fix)
- `H0UND/Domain/Signals/SignalService.cs` (alternative fix location)
- `C0MMON/Interfaces/IRepoSignals.cs` (Delete interface)

**Defense in Depth**:
Consider implementing BOTH fixes:
1. Guard in AnalyticsWorker (primary)
2. Safety check in CleanupStaleSignals (backup)

This ensures signals are preserved even if one fix fails.

---

*Decision BUG-003*  
*Fix Analytics Signal Wipe on Generation Failure*  
*2026-02-21*
