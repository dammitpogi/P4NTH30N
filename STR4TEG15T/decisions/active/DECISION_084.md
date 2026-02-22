# DECISION_084: Filter Jackpots with Insufficient DPD Data from Display

**Decision ID**: DECISION_084  
**Category**: CORE  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-21  
**Oracle Approval**: 82% (Strategist assimilated - display filter is low-risk, appropriate threshold)  
**Designer Approval**: 85% (Claude 3.5 Sonnet - implementation review, formatting guidance)

---

## Executive Summary

Following the H0UND data reset (DECISION_083), the Nexus has observed that jackpots are being displayed with estimated dates for "today" despite not having sufficient DPD (Dollars Per Day) data to produce accurate estimates. This creates misleading visual feedback suggesting jackpots are due when the forecasting data is actually insufficient. This decision mandates filtering out jackpots with insufficient DPD data from the AnalyticsWorker display until they accumulate enough data points for valid estimates.

**Current Problem**:
- Jackpots with empty or minimal DPD.Data are showing estimated dates
- Estimates appear accurate but are based on insufficient data
- Visual display misleadingly suggests jackpots are "due today"
- Burn-in period confusion - can't distinguish valid vs invalid estimates

**Proposed Solution**:
- Add minimum DPD data threshold filter to PrintSummary method
- Only display jackpots with at least 2 DPD data points (minimum for average calculation)
- Optionally show count of filtered/hidden jackpots for transparency
- Maintain all jackpots in database - filter is display-only

---

## Background

### Current State

The `AnalyticsWorker.PrintSummary()` method (lines 156-181) displays all jackpots that meet basic criteria:
- Not hidden (via `IsHiddenGame`)
- Not Mini category (filtered out)
- Sorted by EstimatedDate descending

The display shows:
```
CATEGORY| Estimated Date | Game      | DPD/day | Current/Threshold| (Count) House
```

However, after DECISION_083 reset:
- All jackpots have DPD.Data = [] (empty)
- DPD.Average = 0
- EstimatedDate was set to 2099-12-31 (far future)

As H0UND polls, jackpots are getting new DPD data points, but many still have insufficient data for accurate forecasting.

### Desired State

Display filtering that:
- Hides jackpots with fewer than 2 DPD data points
- Shows only jackpots with valid DPD averages
- Optionally displays a summary line: "X jackpots hidden (insufficient data)"
- Prevents misleading "due today" displays during burn-in

---

## Specification

### Requirements

1. **REQ-001**: Filter jackpots by DPD data count in PrintSummary
   - **Priority**: Must
   - **Acceptance Criteria**: Only jackpots with `DPD.Data.Count >= 2` are displayed

2. **REQ-002**: Show hidden jackpot count
   - **Priority**: Should
   - **Acceptance Criteria**: Display line showing how many jackpots are filtered out

3. **REQ-003**: Preserve all jackpots in system
   - **Priority**: Must
   - **Acceptance Criteria**: Filter is display-only; all jackpots remain in database

4. **REQ-004**: Maintain existing display format
   - **Priority**: Must
   - **Acceptance Criteria**: Visible jackpots display exactly as before

### Technical Details

**File to Modify**: `H0UND/Application/Analytics/AnalyticsWorker.cs`

**Method to Modify**: `PrintSummary()` (lines 156-181)

**Current Code**:
```csharp
private static void PrintSummary(List<Credential> credentials, List<Jackpot> jackpots)
{
    double totalBalance = credentials.Where(c => c.Enabled).Sum(c => c.Balance);

    IEnumerable<Jackpot> visible = jackpots
        .Where(j => !IsHiddenGame(credentials, j.House, j.Game))
        .Where(j => j.Category != "Mini")
        .OrderByDescending(j => j.EstimatedDate);

    foreach (Jackpot j in visible)
    {
        // ... display logic
    }
    // ... summary line
}
```

**Proposed Change**:
```csharp
private static void PrintSummary(List<Credential> credentials, List<Jackpot> jackpots)
{
    double totalBalance = credentials.Where(c => c.Enabled).Sum(c => c.Balance);

    // DECISION_084: Filter jackpots with insufficient DPD data
    const int MinimumDpdDataPoints = 2;
    
    IEnumerable<Jackpot> validJackpots = jackpots
        .Where(j => !IsHiddenGame(credentials, j.House, j.Game))
        .Where(j => j.Category != "Mini")
        .Where(j => j.DPD.Data.Count >= MinimumDpdDataPoints)  // NEW FILTER
        .OrderByDescending(j => j.EstimatedDate);

    int hiddenCount = jackpots.Count(j => !IsHiddenGame(credentials, j.House, j.Game) 
        && j.Category != "Mini" 
        && j.DPD.Data.Count < MinimumDpdDataPoints);

    foreach (Jackpot j in validJackpots)
    {
        int creds = credentials.Count(c => c.House == j.House && c.Game == j.Game);
        Dashboard.AddAnalyticsLog(
            $"{j.Category.ToUpper().PadRight(7)}| {j.EstimatedDate.ToLocalTime():ddd MM/dd HH:mm:ss} | {j.Game[..Math.Min(9, j.Game.Length)].PadRight(9)} | {GetDPD(jackpots, j.House, j.Game):F2}/day |{j.Current, 7:F2}/{j.Threshold, 4:F0}| ({creds, 2}) {j.House}",
            "white"
        );
    }

    // Show hidden count if any
    if (hiddenCount > 0)
    {
        Dashboard.AddAnalyticsLog(
            $"        | {hiddenCount,2} hidden (insufficient DPD data)         |",
            "grey"
        );
    }

    // ... rest of summary line
}
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-084-001 | Add DPD data count filter to PrintSummary | @windfixer | **Completed** | High |
| ACT-084-002 | Add hidden jackpot count display | @windfixer | **Completed** | Medium |
| ACT-084-003 | Test filter during burn-in period | @nexus | **In Progress** | High |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DECISION_083 (H0UND Data Reset) - provides context for why filter is needed
- **Related**: 
  - DECISION_069 (DPD persistence fix)
  - H0UND AnalyticsWorker implementation

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Filter hides all jackpots during early burn-in | Low | High | Expected behavior - will show as DPD data accumulates |
| Users confused by empty display | Medium | Medium | Hidden count message explains why |
| Filter logic error hides valid jackpots | Medium | Low | Simple count check, easy to verify |
| Performance impact from additional Count() | Low | Low | Negligible for 810 documents |

---

## Success Criteria

1. Jackpots with `DPD.Data.Count < 2` are not displayed
2. Hidden jackpot count is shown when applicable
3. Valid jackpots (2+ DPD points) display normally
4. During burn-in, display gradually populates as DPD data accumulates
5. No jackpots with "today" estimates shown until valid data exists

---

## Token Budget

- **Estimated**: 5,000 tokens
- **Model**: Claude 3.5 Sonnet (for WindFixer implementation)
- **Budget Category**: Bug Fix (<20K)

---

## Consultation Log

### Oracle Consultation (Assimilated by Strategist)
- **Date**: 2026-02-21
- **Models**: Kimi K2.5 (risk assessment)
- **Approval**: 82%
- **Key Findings**:
  - **Feasibility**: 9/10 - Simple display filter, no data changes
  - **Risk Level**: 3/10 - Low risk, display-only change
  - **Complexity**: 2/10 - Single method modification
  - **Primary Risks**:
    - Empty display during early burn-in may cause confusion
    - Users may think system is broken if no jackpots shown initially
    - Threshold of 2 may be too aggressive (could use 3-5 for better accuracy)
  - **Threshold Recommendation**: 2 is mathematically correct (minimum for rate calculation), but consider 3 for more stable estimates
  - **Fallback**: Easy to revert - just remove the Where clause
  - **Approval**: Proceed with implementation, threshold of 2 is acceptable

### Designer Consultation
- **Date**: 2026-02-21
- **Models**: Claude 3.5 Sonnet (implementation review)
- **Approval**: 85%
- **Key Findings**:
  - **Threshold Configuration**: Use `const int` in method (not configurable) - this is a mathematical invariant
  - **Performance**: `.Count >= 2` is optimal - O(1) property access, no enumerator allocation
  - **Additional Filter**: Do NOT filter by DPD.Average > 0 - would hide valid scenarios with negative trends or zero averages
  - **Color/Style**: "grey" is perfect for hidden count - visually subordinate, informational
  - **Formatting**: Align columns to maintain visual table structure
  - **Implementation**:
    ```csharp
    // DECISION_084: Only display jackpots with sufficient DPD data (2+ points minimum)
    const int MinimumDpdDataPoints = 2;
    
    IEnumerable<Jackpot> validJackpots = jackpots
        .Where(j => !IsHiddenGame(credentials, j.House, j.Game))
        .Where(j => j.Category != "Mini")
        .Where(j => j.DPD.Data.Count >= MinimumDpdDataPoints)
        .OrderByDescending(j => j.EstimatedDate);
    ```
  - **Testing**: Verify hidden count decreases as DPD data accumulates during burn-in

---

## Notes

This is a display-only fix to prevent misleading information during the burn-in period. The underlying data collection continues normally - we're just not showing jackpots until they have enough data for meaningful estimates.

The threshold of 2 DPD data points is the minimum needed to calculate a DPD average (requires at least 2 points to compute rate of change).

---

*Decision DECISION_084*  
*Filter Jackpots with Insufficient DPD Data*  
*2026-02-21*
