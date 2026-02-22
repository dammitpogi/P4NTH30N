---
agent: openfixer
type: deployment-journal
decision: DECISION_088
created: 2026-02-21
status: completed
tags: [bug-fix, critical, dpd, forecasting, jackpot, h0und, c0mmon]
---

# Deployment Journal: DECISION_088 - DPD Formula Critical Fix

## Mission

Nexus reported that all estimated jackpot times in H0UND were showing the same date. Investigation and fix of the DPD formula.

## Investigation Timeline

### Phase 1: Discovery
- Searched H0UND and C0MMON for all DPD-related code
- Traced the full execution path: `AnalyticsWorker` → `DpdCalculator.UpdateDPD()` → `ForecastingService.GeneratePredictions()` → `Jackpot` constructor
- Found 84 DPD-related matches across 9 files

### Phase 2: Root Cause Identified
Traced the `Jackpot` constructor step-by-step:

1. Constructor receives `eta` (good ETA from ForecastingService) — stores it on line 137
2. Constructor creates FRESH `DPD` object with 1 data point — insufficient for DPM calculation
3. All windowed DPM calculations fail (need 2+ points, have 1)
4. All `tierDPM` values are 0
5. Division by zero → NaN/Infinity → falls to default 10080 minutes (7 days)
6. **Line 194: OVERWRITES the good ETA** with `DateTime.UtcNow + 7 days`
7. ForecastingService then assigns real DPD data — but EstimatedDate is already destroyed

**Result**: Every jackpot gets `UtcNow + 7 days` regardless of actual DPD data.

### Phase 3: Fix Implementation

**Jackpot.cs**: 
- Simplified constructor — respects caller's `eta`, no self-derived overwrite
- Created `RecalculateFromDPD(DateTime credentialLastUpdated)` method for post-DPD-assignment recalculation

**ForecastingService.cs**:
- Added `RecalculateFromDPD()` call after `jackpot.DPD = existing.DPD` assignment

### Phase 4: Validation
- `dotnet build C0MMON\C0MMON.csproj` — 0W 0E
- `dotnet build H0UND\H0UND.csproj` — 0W 0E  
- `dotnet build UNI7T35T\UNI7T35T.csproj` — 0W 0E

## Anomalies Found

| # | Severity | Description | Fixed |
|---|----------|-------------|-------|
| 1 | **CRITICAL** | Constructor overwrites ForecastingService ETA with 7-day default | Yes |
| 2 | **MODERATE** | Constructor DPM values always 0 (insufficient data) | Yes |
| 3 | LOW | Constructor adds DPD data point that gets discarded | Yes (removed) |
| 4 | LOW | Current value growth adjustment always 0 (no-op) | Yes (removed) |

## Files Modified

| File | Lines | Type |
|------|-------|------|
| `C0MMON/Entities/Jackpot.cs` | 127-215 | Constructor simplified + new RecalculateFromDPD() |
| `H0UND/Domain/Forecasting/ForecastingService.cs` | 103-105 | Added RecalculateFromDPD() call |

## Architecture Insight

The fundamental issue was a **competing calculation pattern**: both `ForecastingService` and the `Jackpot` constructor tried to calculate the ETA independently. The constructor always lost because it operated on a fresh, empty DPD object rather than the accumulated historical data. The fix establishes clear separation: ForecastingService owns the initial ETA calculation, and `RecalculateFromDPD()` provides optional refinement with tier-specific DPM rates after real data is loaded.

## Completion

- Decision file: `STR4TEG15T/decisions/active/DECISION_088.md`
- Decision status: Completed
- RAG ingestion: Pending
- Build verification: All 3 projects clean
