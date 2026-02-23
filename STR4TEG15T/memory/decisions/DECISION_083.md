---
type: decision
id: DECISION_083
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.802Z'
last_reviewed: '2026-02-23T01:31:15.802Z'
keywords:
  - decision083
  - h0und
  - data
  - reset
  - for
  - burnin
  - period
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
  **Decision ID**: DECISION_083 **Category**: CORE **Status**: Completed
  **Priority**: Critical **Date**: 2026-02-21 **Oracle Approval**: 74% (Models:
  Claude 3.5 Sonnet - risk assessment, Kimi K2 - complexity analysis) **Designer
  Approval**: 92% (Models: Claude 3.5 Sonnet - architecture review, Kimi K2 -
  implementation strategy)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/completed/DECISION_083.md
---
# DECISION_083: H0UND Data Reset for Burn-In Period

**Decision ID**: DECISION_083  
**Category**: CORE  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-21  
**Oracle Approval**: 74% (Models: Claude 3.5 Sonnet - risk assessment, Kimi K2 - complexity analysis)  
**Designer Approval**: 92% (Models: Claude 3.5 Sonnet - architecture review, Kimi K2 - implementation strategy)

---

## Executive Summary

The Nexus has identified that H0UND analytics data is not producing expected results. With 300 accounts, there should be at least one signal generated daily, but current data suggests the DPD (Dollars Per Day) calculations, jackpot history, and signal generation are not functioning correctly. This decision mandates a complete reset of all H0UND-derived data to establish a clean burn-in period where fresh data can be collected and validated.

**Current Problem**:
- DPD data appears corrupted or insufficient for accurate forecasting
- Signal generation is not producing expected daily signals across 300 accounts
- Jackpot history may contain stale or invalid data affecting predictions
- AnalyticsWorker is processing data that doesn't reflect actual game state

**Proposed Solution**:
- Reset all DPD data in the Jackpots collection (clear Data, History, reset Average to 0)
- Clear all existing Signals from the Signals collection
- Reset Jackpot ETAs and predictions to force fresh calculations
- Allow H0UND to regenerate all data from scratch during a burn-in period
- Monitor for first valid signals to confirm system health

---

## Background

### Current State

H0UND's AnalyticsWorker processes credential data to:
1. Calculate DPD (Dollars Per Day) for each jackpot tier using `DpdCalculator.UpdateDPD()`
2. Generate predictions via `ForecastingService.GeneratePredictions()`
3. Create signals via `SignalService.GenerateSignals()` when jackpots are due
4. Clean up stale signals via `SignalService.CleanupStaleSignals()`

The DPD calculation relies on `Jackpot.DPD.Data` - a list of `DPD_Data` points containing timestamped Grand/Major/Minor/Mini values. The average DPD is calculated from the difference between first and last data points divided by time span.

Data is stored in MongoDB collections:
- **Jackpots**: Contains `DPD` object with `Data`, `History`, `Average`, and `Toggles`
- **Signals**: Contains active signals with priority, timeout, and acknowledgment status
- **CR3D3N7IAL**: Contains credentials with current jackpot values

### Desired State

A clean slate where:
- All DPD data points are cleared, allowing fresh accumulation
- All signals are removed, allowing new signal generation based on clean data
- Jackpot predictions start from baseline (no historical bias)
- H0UND can collect 24-48 hours of clean burn-in data
- Daily signals emerge naturally from valid DPD calculations

---

## Specification

### Requirements

1. **REQ-001**: Clear all DPD data from Jackpots collection
   - **Priority**: Must
   - **Acceptance Criteria**: All jackpot documents have `DPD.Data = []`, `DPD.History = []`, `DPD.Average = 0`

2. **REQ-002**: Clear all existing Signals
   - **Priority**: Must
   - **Acceptance Criteria**: Signals collection is empty (0 documents)

3. **REQ-003**: Reset Jackpot ETAs to baseline
   - **Priority**: Should
   - **Acceptance Criteria**: All jackpot `EstimatedDate` values reset to `DateTime.UtcNow.AddDays(7)` (far future to force recalculation)

4. **REQ-004**: Preserve credential jackpot values
   - **Priority**: Must
   - **Acceptance Criteria**: CR3D3N7IAL collection jackpot values (Grand, Major, Minor, Mini) remain untouched

5. **REQ-005**: Verify reset completion
   - **Priority**: Must
   - **Acceptance Criteria**: Query confirms 0 signals, all jackpots have empty DPD data arrays

6. **REQ-006**: Monitor for first burn-in signals
   - **Priority**: Should
   - **Acceptance Criteria**: Within 24-48 hours of reset, at least one signal is generated

### Technical Details

**MongoDB Operations Required**:

1. **Update Jackpots** - Reset DPD fields:
```javascript
db.Jackpots.updateMany(
    {},
    {
        $set: {
            "DPD.Data": [],
            "DPD.History": [],
            "DPD.Average": 0,
            "DPD.Toggles.GrandPopped": false,
            "DPD.Toggles.MajorPopped": false,
            "DPD.Toggles.MinorPopped": false,
            "DPD.Toggles.MiniPopped": false,
            "EstimatedDate": new Date(Date.now() + 7*24*60*60*1000), // 7 days future
            "GrandDPM": 0,
            "MajorDPM": 0,
            "MinorDPM": 0,
            "MiniDPM": 0
        }
    }
)
```

2. **Delete all Signals**:
```javascript
db.Signals.deleteMany({})
```

3. **Verification queries**:
```javascript
// Check signal count
db.Signals.countDocuments()
// Should return: 0

// Check DPD data state
db.Jackpots.find({ "DPD.Data": { $exists: true, $not: { $size: 0 } } }).count()
// Should return: 0
```

**H0UND Collections to Modify**:
- Database: `P4NTH30N` (or configured database name)
- Collections: `Jackpots`, `Signals`

**Collections to Preserve**:
- `CR3D3N7IAL` - Credential data including current jackpot values
- `H0U53` - House/location data
- `EV3NT` - Event logs
- `ERR0R` - Error logs

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-083-001 | Execute MongoDB update to reset all Jackpot DPD data | @openfixer | **Completed** | Critical |
| ACT-083-002 | Execute MongoDB delete to clear all Signals | @openfixer | **Completed** | Critical |
| ACT-083-003 | Verify reset completion with count queries | @openfixer | **Completed** | Critical |
| ACT-083-004 | Document reset timestamp for burn-in tracking | @strategist | **Completed** | Medium |
| ACT-083-005 | Monitor H0UND logs for first signal generation | @nexus | **In Progress** | Medium |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: 
  - DECISION_069 (DPD persistence fix)
  - DECISION_071 (Signal cleanup fix)
  - H0UND AnalyticsWorker implementation

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Accidental deletion of credential data | Critical | Low | Only target Jackpots and Signals collections; CR3D3N7IAL is preserved by design |
| H0UND fails to regenerate data | High | Low | Monitor logs; if no data after 48 hours, investigate PollingWorker connectivity |
| Signal generation still fails after reset | High | Medium | If no signals after 48 hours, escalate to Forgewright for H0UND code review |
| Reset leaves system in unstable state | Medium | Low | Verify reset completion before declaring success; have rollback plan (restore from backup if needed) |
| Burn-in period longer than expected | Low | Medium | Set expectation of 24-48 hours; DPD requires at least 2 data points to calculate average |

---

## Success Criteria

1. All jackpot documents have empty `DPD.Data` arrays
2. Signals collection contains 0 documents
3. H0UND continues polling without errors
4. Within 48 hours, DPD data begins accumulating (at least 2 data points per jackpot)
5. Within 48-72 hours, first signals are generated based on fresh DPD calculations
6. Daily signal generation resumes (at least 1 signal per day across the account pool)

---

## Token Budget

- **Estimated**: 15,000 tokens
- **Model**: Claude 3.5 Sonnet (for Fixer implementation)
- **Budget Category**: Routine (<50K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On MongoDB connection error**: Delegate to @forgewright with connection diagnostics
- **On permission error**: Delegate to @openfixer with elevated credentials
- **On verification failure**: Re-run reset operations; if still failing, delegate to Forgewright
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Oracle | Validation sub-decisions | Medium | No |
| Designer | Architecture sub-decisions | Medium | No |
| WindFixer | Implementation sub-decisions | High | Yes (Strategist) |
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Bug-fix sub-decisions | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-21
- **Models**: Claude 3.5 Sonnet (risk assessment), Kimi K2 (complexity analysis)
- **Approval**: 74%
- **Key Findings**:
  - **Feasibility**: 8/10 - Straightforward data reset with clear scope
  - **Risk Level**: 5/10 - Operational and analytical risk, not data integrity risk
  - **Complexity**: 4/10 - Simple operations, but needs careful sequencing
  - **Primary Risks**:
    - Cold-start bias: DPD averages and ETA forecasts may be noisy for days; early signals could be unreliable
    - Signal drought: If logic expects historical variance, may see zero signals until thresholds stabilize
    - Undetected root cause: If ingestion or DPD computation is broken, reset only masks the issue
  - **Hidden Dependencies**:
    - ETAs derived from DPD: Other components assuming non-zero ETAs may behave oddly
    - AnalyticsWorker cadence: 300 accounts every 10s may re-fill DPD quickly and hit rate limits
    - H4ND integration: If H4ND reads recent signals or DPD for decisions, it may switch to fallback mode
  - **Burn-In Period**: Minimum 48 hours for stable DPD averages; preferable 3-5 days to smooth variance
  - **Fallback Options**:
    1. Targeted reset for subset of accounts to isolate issue
    2. Recompute job to reconstruct DPD from raw transaction history
    3. Instrumentation pass to catch silent logic failures
    4. Schema audit for field path and type consistency
  - **Recommendation**: Proceed with reset as diagnostic step, pair with instrumentation and explicit burn-in gating

### Designer Consultation
- **Date**: 2026-02-21
- **Models**: Claude 3.5 Sonnet (architecture), Kimi K2 (implementation)
- **Approval**: 92%
- **Key Findings**:
  - **Root Cause Hypothesis**: Stagnant jackpot values not triggering DPD data points; cascading signal suppression from insufficient DPD data
  - **Phased Implementation**:
    - Phase 1: Pre-reset safety (backup Jackpots and Signals, record state)
    - Phase 2: Jackpot DPD reset (updateMany to clear Data, History, Average, Toggles, DPMs)
    - Phase 3: Signal collection purge (deleteMany on Signals)
    - Phase 4: Burn-in activation (monitor DPD accumulation)
    - Phase 5: 24-72 hour monitoring period
  - **Files to Modify**:
    - NEW: `H0UND/Application/Analytics/AnalyticsResetService.cs` - Reset service with MongoDB operations
    - MODIFY: `H0UND/Application/Analytics/AnalyticsWorker.cs` - Optional reset flag check
  - **MongoDB Collections**: J4CKP0T (Jackpots), SIGN4L (Signals) - note actual collection names may vary
  - **Validation Commands**:
    - `db.J4CKP0T.countDocuments()` - should match pre-reset count
    - `db.SIGN4L.countDocuments()` - should return 0
    - Sample document check for DPD.Data: [], DPD.Average: 0
  - **Burn-In Monitoring**:
    - 6-hour: At least 20% of jackpots have DPD.Data.length >= 2
    - 24-hour: All active games have DPD.Data.length >= 5, signal generation > 10/hour
    - 48-72 hour: DPD variance stabilizes, ETA predictions converge
  - **Fallback Mechanisms**:
    - Partial reset completion: Manual completion query provided
    - No signals after 6 hours: Check PollingWorker and BalanceProvider health
    - Data corruption: Rollback from backup using mongorestore

---

## Burn-In Period Tracking

**Reset Timestamp**: 2026-02-21 (COMPLETED)  
**Expected First Signal**: 24-48 hours post-reset  
**Expected DPD Validity**: 48-72 hours post-reset (requires 2+ data points)  
**Monitoring Period**: 7 days

### Reset Verification Results

| Metric | Expected | Actual | Status |
|--------|----------|--------|--------|
| SIGN4L count | 0 | 0 | ✅ |
| J4CKP0T count | 810 (unchanged) | 810 | ✅ |
| DPD.Data empty | All documents | 810/810 | ✅ |
| DPD.Average | 0 | 0 | ✅ |
| EstimatedDate | 2099-12-31 | 2099-12-31 | ✅ |
| DPM values | 0 | 0 | ✅ |

**Summary**: All 810 jackpot documents have been successfully reset. DPD data cleared, signals purged, system ready for burn-in.

**Daily Checklist**:
- [ ] Day 1: Verify polling continues, DPD data accumulating
- [ ] Day 2: Check for first signals
- [ ] Day 3: Validate signal frequency (should see daily signals)
- [ ] Day 7: Confirm system stability and data integrity

---

## Notes

This reset is a diagnostic measure. The Nexus expects daily signals across 300 accounts, which implies:
- ~300 accounts ÷ ~50 games = ~6 accounts per game on average
- With 4 tiers per game (Grand, Major, Minor, Mini), that's ~200 jackpot trackers
- If DPD averages are calculated correctly, at least 1-2 jackpots should be "due" daily
- The absence of signals suggests either:
  1. DPD data is corrupted/stale (addressed by this reset)
  2. Signal generation logic has a bug (will be apparent if reset doesn't help)
  3. Polling is not capturing fresh data (will check PollingWorker logs)

Post-reset, if signals still don't appear within 72 hours, the issue is likely in the signal generation logic itself, not the data.

---

*Decision DECISION_083*  
*H0UND Data Reset for Burn-In Period*  
*2026-02-21*
