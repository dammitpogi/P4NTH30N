# DECISION_069: Fix DPD Data Loss Bug in AnalyticsWorker

**Decision ID**: BUG-001  
**Category**: CORE  
**Status**: Completed

**MCP Workaround**: ToolHive Gateway timeout bypassed. Direct MCP server configuration in opencode.json. RAG server unavailable - use file-based decisions and direct MongoDB queries.  
**Priority**: Critical  
**Date**: 2026-02-21  
**Oracle Approval**: 95% (Assimilated - Critical bug fix)  
**Designer Approval**: 95% (Aegis - PROCEED WITH IMPLEMENTATION)

---

## Executive Summary

**CRITICAL BUG DISCOVERED**: The DPD (Dollars Per Day) calculation system in H0UND is losing all accumulated data points, causing 95.4% of jackpots to have invalid estimated dates (year 9990) and preventing signal generation.

**Root Cause**: In `AnalyticsWorker.ProcessPredictionPhase()`, the code calls `DpdCalculator.UpdateDPD()` to add data points to jackpot objects in memory, but then calls `ForecastingService.GeneratePredictions()` which creates **brand new Jackpot objects** that overwrite the MongoDB documents, discarding all accumulated DPD data.

**Impact**: 
- 773 of 810 jackpots (95.4%) have invalid estimated dates
- 0 signals generated despite 310 credentials available
- Burn-in cannot proceed
- System appears to work but produces no actionable output

---

## Background

### Current State (BROKEN)

In `H0UND/Application/Analytics/AnalyticsWorker.cs` lines 97-103:

```csharp
List<Jackpot> existingJackpots = uow.Jackpots.GetAll().Where(j => j.House == representative.House && j.Game == representative.Game).ToList();
foreach (Jackpot jackpot in existingJackpots)
{
    DpdCalculator.UpdateDPD(jackpot, representative);  // Updates IN MEMORY only
}

ForecastingService.GeneratePredictions(representative, uow, dateLimit);  // Creates NEW objects, overwrites MongoDB
```

**The Problem Flow:**
1. `GetAll()` retrieves existing jackpots with their DPD history from MongoDB
2. `UpdateDPD()` adds new data points to those objects **in memory only**
3. **NO `Upsert()` call saves the updated DPD to MongoDB**
4. `GeneratePredictions()` creates **brand new Jackpot objects** with only 1 DPD data point
5. `Upsert()` in `GeneratePredictions()` replaces the MongoDB document with the new object
6. **All accumulated DPD history is lost forever**

### Evidence

- MongoDB query shows 773 jackpots with `EstimatedDate: ISODate('9990-01-03')`
- DPD.Data arrays contain exactly 1 data point each (should have many)
- DPD.Average = 0 for most jackpots (can't calculate with only 1 point)
- Zero signals in SIGN4L collection despite 310 credentials

### Desired State (FIXED)

DPD data points accumulate over time in MongoDB, enabling:
- Valid DPD.Average calculations
- Accurate EstimatedDate predictions
- Signal generation when thresholds are met
- Functional burn-in and operational deployment

---

## Specification

### Requirements

**BUG-001-1**: Persist DPD updates before creating new jackpot objects
- **Priority**: Must
- **Acceptance Criteria**: 
  - After `UpdateDPD()` loop, call `uow.Jackpots.Upsert(jackpot)` for each updated jackpot
  - DPD.Data arrays in MongoDB accumulate multiple data points over time
  - DPD.Average is calculated correctly after 2+ data points

**BUG-001-2**: Ensure DPD data flows correctly through the pipeline
- **Priority**: Must
- **Acceptance Criteria**:
  - `UpdateDPD()` adds data points to existing jackpots
  - Updated jackpots are persisted to MongoDB
  - `GeneratePredictions()` uses the updated DPD data
  - No data loss occurs between analytics runs

**BUG-001-3**: Add unit test to prevent regression
- **Priority**: Must
- **Acceptance Criteria**:
  - Unit test verifies DPD data accumulation across multiple `ProcessPredictionPhase()` calls
  - Test mocks MongoDB to verify `Upsert()` is called after `UpdateDPD()`
  - Test fails with current code, passes with fix

### Technical Details

**File to Modify**: `H0UND/Application/Analytics/AnalyticsWorker.cs`

**Current Code (lines 97-103)**:
```csharp
List<Jackpot> existingJackpots = uow.Jackpots.GetAll().Where(j => j.House == representative.House && j.Game == representative.Game).ToList();
foreach (Jackpot jackpot in existingJackpots)
{
    DpdCalculator.UpdateDPD(jackpot, representative);
}

ForecastingService.GeneratePredictions(representative, uow, dateLimit);
```

**Fixed Code**:
```csharp
List<Jackpot> existingJackpots = uow.Jackpots.GetAll().Where(j => j.House == representative.House && j.Game == representative.Game).ToList();
foreach (Jackpot jackpot in existingJackpots)
{
    DpdCalculator.UpdateDPD(jackpot, representative);
    // CRITICAL: Must persist before GeneratePredictions() creates new objects
    // Otherwise accumulated DPD history is lost (BUG-001)
    uow.Jackpots.Upsert(jackpot);
}

ForecastingService.GeneratePredictions(representative, uow, dateLimit);
```

**Unit Test Location**: `UNI7T35T/H0UND/AnalyticsWorkerTests.cs` (create if doesn't exist)

**Unit Test Structure** (per Designer specification):
```csharp
[Fact]
public void ProcessPredictionPhase_DPD_Data_Accumulates_Over_Multiple_Calls()
{
    // Arrange: Mock IUnitOfWork, IRepoJackpots
    // Setup: Create jackpot with initial DPD data
    // Act: Call ProcessPredictionPhase() twice with different timestamps
    // Assert:
    //   - Upsert() called twice on same jackpot
    //   - DPD.Data count increased from 1 to 3 (initial + 2 updates)
    //   - DPD.Average > 0 after 2+ points
}
```

**Unit Test Requirements**:
- Mock `IUnitOfWork` and `IRepoJackpots`
- Mock `IUnitOfWork.Jackpots` → returns mocked `IRepoJackpots`
- Mock `IUnitOfWork.CommitAsync()` → returns `Task.CompletedTask`
- Use `DateTime` parameters directly for determinism (no time provider needed)
- Call `ProcessPredictionPhase()` multiple times with same House/Game
- Verify `Upsert()` is called after each `UpdateDPD()` using `mockRepo.Received(2).Upsert(Arg.Any<Jackpot>())`
- Verify DPD.Data count increases with each call (from 1 to 3)
- Verify DPD.Average > 0 after accumulating 2+ data points
- Test fails with current code, passes with fix

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-069-1 | Add `uow.Jackpots.Upsert(jackpot)` after `UpdateDPD()` in AnalyticsWorker.cs | @windfixer | Pending | Critical |
| ACT-069-2 | Create unit test verifying DPD data accumulation | @windfixer | Pending | Critical |
| ACT-069-3 | Run existing tests to ensure no regression | @windfixer | Pending | Critical |
| ACT-069-4 | Verify fix by checking MongoDB DPD.Data growth over time | @strategist | Pending | High |

---

## Dependencies

- **Blocks**: DECISION_047 (Burn-in cannot proceed without signals)
- **Blocked By**: None
- **Related**: DECISION_068 (Signal Generation - depends on this fix)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Fix causes performance issues (more DB writes) | Medium | Low | **ACCEPTABLE** per Designer—documents are small, MongoDB handles it; each jackpot gets 2 Upserts per cycle |
| Fix doesn't fully resolve signal generation | High | Low | Verify DPD calculations and signal thresholds separately |
| Unit test is flaky due to timing | Low | Medium | Use `DateTime` parameters directly for determinism (Designer recommendation) |
| Transaction boundary concern | Low | Low | If GeneratePredictions fails, DPD update persists (may be desirable); document this behavior in code |

---

## Success Criteria

1. **Immediate**: `Upsert()` is called after each `UpdateDPD()` call
2. **Short-term**: DPD.Data arrays in MongoDB accumulate 2+ data points per jackpot
3. **Medium-term**: DPD.Average is calculated correctly (non-zero values)
4. **Long-term**: EstimatedDate values are reasonable (2026-2027, not 9990)
5. **Final**: Signals are generated and burn-in can proceed

---

## Token Budget

- **Estimated**: 15,000 tokens
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
  - Fix is straightforward: add Upsert() call
  - Risk is low, impact is high
  - Unit test essential to prevent regression

### Designer Consultation (Aegis)
- **Date**: 2026-02-21
- **Approval**: 95%
- **Key Findings**:
  - Single-line fix in AnalyticsWorker.cs confirmed optimal
  - Unit test should mock IUnitOfWork with refined verification points
  - No architectural changes required
  - Clear acceptance criteria defined
  - **Code Comment Recommended**: Add explanatory comment about BUG-001
  - **Write Amplification**: Acceptable - each jackpot gets 2 Upserts per cycle
  - **Transaction Boundary**: If GeneratePredictions fails, DPD update persists (document this behavior)
  - **Alternative Approaches Rejected**: Moving UpdateDPD into GeneratePredictions (too invasive), batch Upsert (introduces new pattern)
- **Designer Sign-Off**: PROCEED WITH IMPLEMENTATION
  - ✅ Root cause clearly identified
  - ✅ Fix is minimal and surgical
  - ✅ Risk profile acceptable
  - ✅ Unit test strategy defined
  - ✅ Acceptance criteria measurable
  - ✅ No architectural changes needed
- **Estimated Completion**: 15-30 minutes including unit test

---

## Notes

**Discovery Process**:
1. Noticed 0 signals in SIGN4L collection despite 310 credentials
2. Found 773 jackpots with EstimatedDate in year 9990
3. Discovered DPD.Data arrays only had 1 data point each
4. Traced code flow in AnalyticsWorker.ProcessPredictionPhase()
5. Identified that UpdateDPD() updates in memory but never persists
6. Confirmed GeneratePredictions() creates new objects that overwrite MongoDB

**Why This Was Missed**:
- Code looks correct at first glance
- No unit test verified DPD accumulation
- Integration testing didn't catch it because single-run appears to work
- Only visible after multiple analytics cycles

**Related Files**:
- `H0UND/Application/Analytics/AnalyticsWorker.cs` (main fix)
- `H0UND/Domain/Forecasting/DpdCalculator.cs` (works correctly, just not persisted)
- `H0UND/Domain/Forecasting/ForecastingService.cs` (creates new objects)
- `C0MMON/Infrastructure/Persistence/Repositories.cs` (RepoJackpots.Upsert)

---

*Decision BUG-001*  
*Fix DPD Data Loss Bug in AnalyticsWorker*  
*2026-02-21*
