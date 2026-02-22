---
id: DECISION_088
title: "Fix DPD Formula: Jackpot Constructor Overwrites ForecastingService ETA"
category: Bug Fix
status: Completed
priority: Critical
created: 2026-02-21
completed: 2026-02-21
agent: openfixer
approval: Direct Nexus Request (Critical Bug)
related: [DECISION_085, DECISION_069, DECISION_084]
---

# DECISION_088: Fix DPD Formula - Constructor ETA Overwrite Bug

## Problem Statement

All estimated jackpot times in H0UND were reporting the same date (~7 days from now), making the entire forecasting system useless. Every jackpot — regardless of current value, threshold, DPD rate, or tier — displayed an identical estimated date.

## Root Cause Analysis

### Anomaly #1 (CRITICAL): Jackpot Constructor Overwrites Externally-Calculated ETA

**Location**: `C0MMON/Entities/Jackpot.cs` — Constructor (lines 127-204)

**The Bug**:
The `Jackpot` constructor receives an `eta` parameter pre-calculated by `ForecastingService` using real DPD data. The constructor stores it initially (`EstimatedDate = eta` on line 137), but then the constructor's own DPM-based recalculation **overwrites it** on line 194:

```csharp
EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
```

**Why It Always Fails**: The constructor creates a **brand new** `DPD` object (`DPD = new DPD()` on the class field initializer), then adds exactly **1** data point to it. The DPM calculation requires **2+** data points. With only 1 point:
- `dataZoom24h.Count >= 2` → **false** (skip)
- `dataZoom8h.Count >= 2` → **false** (skip)
- All `tierDPM` values remain 0
- `MinutesToJackpot = (threshold - current) / 0` → **Infinity**
- NaN/Infinity guard catches it → `MinutesToJackpot = 10080` (7 days)
- **Every jackpot gets `DateTime.UtcNow + 7 days`**

**The Irony**: `ForecastingService` correctly computes the ETA from real DPD data, passes it to the constructor, and the constructor **discards it** in favor of a calculation that always fails.

**Post-Construction DPD Assignment**: After the constructor runs, `ForecastingService` correctly assigns `jackpot.DPD = existing.DPD` — but by this point `EstimatedDate` has already been overwritten.

### Anomaly #2 (MODERATE): Constructor DPM Calculations Always Zero

**Location**: `C0MMON/Entities/Jackpot.cs` — Lines 139-170

The `GrandDPM`, `MajorDPM`, `MinorDPM`, `MiniDPM` values were always 0 because:
1. `DPD.Average` is 0 (fresh DPD object), so `fallbackDPM = 0`
2. Data windows have < 2 points, so tier-specific calculations are skipped
3. All DPM values default to `fallbackDPM = 0`

These DPM values are used for display and secondary calculations downstream.

### Anomaly #3 (LOW): Constructor Adds Discarded DPD Data Point

**Location**: `C0MMON/Entities/Jackpot.cs` — Line 139 + `ForecastingService.cs` — Line 101

The constructor adds a `DPD_Data` point to the fresh DPD on line 139. Then `ForecastingService` replaces the entire DPD object on line 101 (`jackpot.DPD = existing.DPD`). The data point added in the constructor is **silently lost** — wasted computation.

### Anomaly #4 (LOW): Current Value Not Adjusted for Growth

**Location**: `C0MMON/Entities/Jackpot.cs` — Line 203

`Current = current + estimatedGrowth` where `estimatedGrowth` is always 0 (since `tierDPM = 0`). The growth adjustment was a no-op.

## Fix Applied

### File 1: `C0MMON/Entities/Jackpot.cs`

**Change**: Simplified constructor to respect the caller's `eta` parameter. Extracted DPM recalculation into a new `RecalculateFromDPD(DateTime credentialLastUpdated)` method that can be called **after** real DPD data is assigned.

- Constructor now: sets properties, uses `eta` directly, no DPM recalculation
- `RecalculateFromDPD()`: contains the DPM windowed calculation logic, only refines ETA when meaningful DPM data exists, with safety guards

### File 2: `H0UND/Domain/Forecasting/ForecastingService.cs`

**Change**: After assigning `jackpot.DPD = existing.DPD`, now calls `jackpot.RecalculateFromDPD(cred.LastUpdated)` so the DPM calculation has sufficient data.

## Execution Flow (After Fix)

1. `ForecastingService.GeneratePredictions()` computes `estimatedDate` from `DPD.Average`
2. Creates `new Jackpot(cred, cat, current, threshold, pri, estimatedDate)` — ETA is set correctly
3. Assigns `jackpot.DPD = existing.DPD` — real DPD data loaded
4. Calls `jackpot.RecalculateFromDPD(cred.LastUpdated)` — DPM values calculated from real data, ETA optionally refined with tier-specific rates
5. Upserts to MongoDB

## Validation

- `dotnet build C0MMON\C0MMON.csproj` — 0 warnings, 0 errors
- `dotnet build H0UND\H0UND.csproj` — 0 warnings, 0 errors
- `dotnet build UNI7T35T\UNI7T35T.csproj` — 0 warnings, 0 errors

## Files Modified

| File | Change Type | Lines Changed |
|------|------------|---------------|
| `C0MMON/Entities/Jackpot.cs` | Major refactor | Constructor simplified (127-143), new `RecalculateFromDPD()` method (150-215) |
| `H0UND/Domain/Forecasting/ForecastingService.cs` | Minor addition | Added `RecalculateFromDPD()` call after DPD assignment (103-105) |

## Impact

- **Before**: Every jackpot showed identical estimated date (~7 days from now regardless of DPD data)
- **After**: Jackpots use ForecastingService's DPD-based ETA, optionally refined with tier-specific DPM rates from real data windows
- **Risk**: Low — the constructor's self-calculation never worked correctly, so removing it only reveals the (correct) ForecastingService calculation that was always being discarded
