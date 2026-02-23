---
type: decision
id: DECISION_074
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.712Z'
last_reviewed: '2026-02-23T01:31:15.712Z'
keywords:
  - decision074
  - fix
  - signal
  - deduplication
  - cache
  - ttl
  - suppression
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
  **Decision ID**: BUG-006 **Category**: CORE **Status**: Completed
  **Priority**: Medium **Date**: 2026-02-21 **Oracle Approval**: 85%
  (Assimilated - Moderate impact) **Designer Approval**: 85% (Assimilated -
  Tuning required)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_074.md
---
# DECISION_074: Fix Signal Deduplication Cache TTL Suppression

**Decision ID**: BUG-006  
**Category**: CORE  
**Status**: Completed  
**Priority**: Medium  
**Date**: 2026-02-21  
**Oracle Approval**: 85% (Assimilated - Moderate impact)  
**Designer Approval**: 85% (Assimilated - Tuning required)

---

## Executive Summary

**ISSUE IDENTIFIED**: The `SignalDeduplicationCache` uses a fixed 5-minute TTL (time-to-live). For fast-moving jackpots or rapid credential churn, legitimate signals within 5 minutes are considered duplicates and dropped, causing missed opportunities.

**Root Cause**: The deduplication key is based only on `(House, Game, Username)` and the cache entry lives for 5 minutes regardless of jackpot values or conditions. If a jackpot triggers, resets, and triggers again within 5 minutes, the second signal is dropped.

**Impact**: 
- Fast-moving jackpots may miss signals
- Rapid credential changes may be ignored
- Signal count lower than expected for active games
- 5-minute window may be too long for high-frequency scenarios

---

## Background

### Current State

In `C0MMON/Infrastructure/Resilience/SignalDeduplicationCache.cs`:

```csharp
public class SignalDeduplicationCache
{
    private static readonly TimeSpan s_ttl = TimeSpan.FromMinutes(5);  // <-- Fixed 5 minutes
    private readonly ConcurrentDictionary<string, DateTime> _cache = new();
    
    public static string BuildKey(Signal signal)
    {
        return $"{signal.House}:{signal.Game}:{signal.Username}";  // <-- No jackpot values
    }
    
    public bool IsProcessed(string key)
    {
        if (_cache.TryGetValue(key, out DateTime expiry))
        {
            if (DateTime.UtcNow < expiry)
            {
                return true;  // <-- Within 5 minutes, considered duplicate
            }
            _cache.TryRemove(key, out _);
        }
        return false;
    }
}
```

**The Problem:**
- Jackpot triggers at 12:00 → Signal generated, cache entry created (expires 12:05)
- Jackpot resets and triggers again at 12:03 → **Signal dropped as duplicate**
- Legitimate second signal is lost

### Desired State

Deduplication is smarter:
- Shorter TTL (1-2 minutes) for fast-moving jackpots
- Key includes jackpot values to allow different-threshold signals
- Configurable TTL based on jackpot tier
- Metrics to track deduplication rate

---

## Specification

### Requirements

**BUG-006-1**: Reduce deduplication TTL to 2 minutes
- **Priority**: Should
- **Acceptance Criteria**: 
  - Change `s_ttl` from 5 minutes to 2 minutes
  - Monitor for duplicate signal increase
  - Adjust if needed based on metrics

**BUG-006-2**: Include jackpot values in deduplication key
- **Priority**: Should
- **Acceptance Criteria**:
  - Key format: `{House}:{Game}:{Username}:{Priority}:{Threshold}:{Current}`
  - Signals with different thresholds are not considered duplicates
  - Signals with different priorities are not considered duplicates

**BUG-006-3**: Add deduplication metrics
- **Priority**: Should
- **Acceptance Criteria**:
  - Track number of deduplicated signals per run
  - Track deduplication rate (deduped / total)
  - Alert if deduplication rate > 20%

**BUG-006-4**: Make TTL configurable per tier
- **Priority**: Could
- **Acceptance Criteria**:
  - Grand: 1 minute TTL (fast)
  - Major: 2 minutes TTL
  - Minor: 3 minutes TTL
  - Mini: 5 minutes TTL (slower)

### Technical Details

**File to Modify**: `C0MMON/Infrastructure/Resilience/SignalDeduplicationCache.cs`

**Current Code**:
```csharp
private static readonly TimeSpan s_ttl = TimeSpan.FromMinutes(5);

public static string BuildKey(Signal signal)
{
    return $"{signal.House}:{signal.Game}:{signal.Username}";
}
```

**Fixed Code**:
```csharp
// BUG-006: Configurable TTL per priority tier
private static TimeSpan GetTtlForPriority(int priority)
{
    return priority switch
    {
        4 => TimeSpan.FromMinutes(1),  // Grand - fast
        3 => TimeSpan.FromMinutes(2),  // Major
        2 => TimeSpan.FromMinutes(3),  // Minor
        1 => TimeSpan.FromMinutes(5),  // Mini - slower
        _ => TimeSpan.FromMinutes(2)   // Default
    };
}

public static string BuildKey(Signal signal)
{
    // BUG-006: Include values to distinguish different-threshold signals
    return $"{signal.House}:{signal.Game}:{signal.Username}:{signal.Priority}:{signal.Threshold:F0}:{signal.Current:F0}";
}

public void MarkProcessed(Signal signal)  // Changed to accept Signal instead of string
{
    string key = BuildKey(signal);
    TimeSpan ttl = GetTtlForPriority(signal.Priority);
    _cache[key] = DateTime.UtcNow.Add(ttl);
    _metrics?.RecordDeduplication(key);
}
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-074-1 | Reduce default TTL to 2 minutes | @windfixer | Pending | Medium |
| ACT-074-2 | Update BuildKey to include jackpot values | @windfixer | Pending | Medium |
| ACT-074-3 | Add tier-based TTL configuration | @windfixer | Pending | Medium |
| ACT-074-4 | Add deduplication metrics | @windfixer | Pending | Medium |
| ACT-074-5 | Monitor deduplication rate after deployment | @strategist | Pending | Medium |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DECISION_072 (Idempotent generator uses this cache)
- **Related**: DECISION_069, DECISION_070, DECISION_071, DECISION_072, DECISION_073

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Duplicate signals increase | Medium | Medium | Monitor metrics; increase TTL if needed |
| Key length increase | Low | Low | Key is still reasonable size |
| Cache memory increase | Low | Low | Entries expire faster, not slower |
| False negatives (missed dedup) | Low | Low | Better to have duplicates than miss signals |

---

## Success Criteria

1. TTL reduced to 2 minutes (or tier-based)
2. Key includes jackpot values
3. Deduplication rate < 20%
4. Signal count increases for fast-moving jackpots
5. No significant duplicate signal increase

---

## Token Budget

- **Estimated**: 8,000 tokens
- **Model**: Claude 3.5 Sonnet (WindFixer)
- **Budget Category**: Bug Fix (<20K)

---

*Decision BUG-006*  
*Fix Signal Deduplication Cache TTL Suppression*  
*2026-02-21*
