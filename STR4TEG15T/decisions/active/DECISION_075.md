# DECISION_075: Fix SignalDistributor Reclaim Window Double Processing

**Decision ID**: BUG-007  
**Category**: CORE  
**Status**: Completed  
**Priority**: Low  
**Date**: 2026-02-21  
**Oracle Approval**: 80% (Assimilated - Edge case)  
**Designer Approval**: 80% (Assimilated - Tuning required)

---

## Executive Summary

**ISSUE IDENTIFIED**: `SignalDistributor` reclaims signals after 2 minutes, but if a worker is legitimately still processing a long spin or stalled after `ClaimNext` but before `Acknowledge`, the signal is released and another worker picks it up, potentially causing double spins.

**Root Cause**: The reclaim window (2 minutes) may be shorter than legitimate spin processing time, especially for complex games or slow connections. The `ClaimedAt` timestamp is checked, but not the `Timeout` field set by `Acknowledge`.

**Impact**: 
- Potential double spins for same signal
- Wasted spins on same jackpot
- Account suspension risk from rapid duplicate actions
- Rare edge case but high impact when it occurs

---

## Background

### Current State

In `H4ND/Parallel/SignalDistributor.cs` lines 48-63:

```csharp
// Reclaim signals with stale claims (>2 minutes)
var staleClaims = _signals.Find(s => 
    s.ClaimedBy != null && 
    s.ClaimedAt < DateTime.UtcNow.AddMinutes(-2));  // <-- Fixed 2 minutes

foreach (var signal in staleClaims)
{
    _repo.ReleaseClaim(signal);  // <-- Released while worker may still be processing
}
```

In `C0MMON/Infrastructure/Persistence/Repositories.cs` lines 237-245:
```csharp
public void Acknowledge(Signal signal)
{
    signal.Acknowledged = true;
    signal.Timeout = DateTime.UtcNow.AddMinutes(1);  // <-- 1 minute timeout
    // ... update ...
}
```

**The Problem:**
- Worker claims signal at 12:00
- Worker starts spin (may take 30-60 seconds)
- At 12:02, SignalDistributor reclaims the signal (2 minutes expired)
- Worker finishes spin at 12:02:30 and calls `Acknowledge`
- But signal was already reclaimed and assigned to Worker 2
- Worker 2 also spins the same jackpot
- **Double spin occurs**

### Desired State

Reclaim logic respects the `Timeout` field set by `Acknowledge`, preventing reclamation of signals that are still within their processing window.

---

## Specification

### Requirements

**BUG-007-1**: Use Timeout field for reclaim decision
- **Priority**: Should
- **Acceptance Criteria**: 
  - Only reclaim signals where `ClaimedAt < now - 2 minutes` AND `Timeout < now`
  - If `Timeout` is in future, signal is still being processed
  - If `Timeout` is null, use current 2-minute logic

**BUG-007-2**: Increase reclaim window to 3 minutes
- **Priority**: Should
- **Acceptance Criteria**:
  - Change reclaim threshold from 2 minutes to 3 minutes
  - Matches typical spin processing time
  - Reduce false positives

**BUG-007-3**: Add metric for reclaimed signals
- **Priority**: Could
- **Acceptance Criteria**:
  - Track number of signals reclaimed per cycle
  - Alert if reclaim rate > 5%
  - Log which workers had signals reclaimed

**BUG-007-4**: Add heartbeat from workers
- **Priority**: Could
- **Acceptance Criteria**:
  - Workers update `ClaimedAt` periodically while processing
  - Heartbeat every 30 seconds extends claim
  - Prevents reclamation of long-running legitimate operations

### Technical Details

**File to Modify**: `H4ND/Parallel/SignalDistributor.cs`

**Current Code**:
```csharp
var filter = Builders<Signal>.Filter.And(
    Builders<Signal>.Filter.Eq(s => s.Acknowledged, false),
    Builders<Signal>.Filter.Or(
        Builders<Signal>.Filter.Eq(s => s.ClaimedBy, null),
        Builders<Signal>.Filter.Lt(s => s.ClaimedAt, DateTime.UtcNow.AddMinutes(-2))
    )
);
```

**Fixed Code**:
```csharp
// BUG-007: Respect Timeout field and increase reclaim window to 3 minutes
var filter = Builders<Signal>.Filter.And(
    Builders<Signal>.Filter.Eq(s => s.Acknowledged, false),
    Builders<Signal>.Filter.Or(
        Builders<Signal>.Filter.Eq(s => s.ClaimedBy, null),
        Builders<Signal>.Filter.And(
            // Claim is stale (3 minutes)
            Builders<Signal>.Filter.Lt(s => s.ClaimedAt, DateTime.UtcNow.AddMinutes(-3)),
            // AND timeout has expired (or no timeout set)
            Builders<Signal>.Filter.Or(
                Builders<Signal>.Filter.Eq(s => s.Timeout, null),
                Builders<Signal>.Filter.Lt(s => s.Timeout, DateTime.UtcNow)
            )
        )
    )
);
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-075-1 | Update reclaim filter to respect Timeout field | @windfixer | Pending | Low |
| ACT-075-2 | Increase reclaim window from 2 to 3 minutes | @windfixer | Pending | Low |
| ACT-075-3 | Add reclaim metrics | @windfixer | Pending | Low |
| ACT-075-4 | Monitor reclaim rate after deployment | @strategist | Pending | Low |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: DECISION_047 (Parallel execution)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Stuck signals never reclaimed | Medium | Low | Timeout field ensures eventual reclaim |
| Longer window increases latency | Low | Low | 3 minutes is still reasonable |
| Complex filter impacts performance | Low | Low | Index on ClaimedAt and Timeout |

---

## Success Criteria

1. Reclaim filter respects Timeout field
2. Reclaim window increased to 3 minutes
3. Reclaim rate < 5%
4. No double spin incidents
5. Stuck signals still eventually reclaimed

---

## Token Budget

- **Estimated**: 6,000 tokens
- **Model**: Claude 3.5 Sonnet (WindFixer)
- **Budget Category**: Bug Fix (<20K)

---

*Decision BUG-007*  
*Fix SignalDistributor Reclaim Window Double Processing*  
*2026-02-21*
