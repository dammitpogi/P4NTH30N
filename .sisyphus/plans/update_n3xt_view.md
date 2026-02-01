# Plan: Update N3XT View with DPD Priority

The goal is to update the `N3XT` MongoDB view to prioritize games based on their DPD (Dollars Per Day) value, increasing check frequency for high-DPD games without starving others.

## Tasks

- [x] **Analyze Database and View Structure**
  - Read `C0MMON/Database.cs` to understand command execution capabilities.
  - Confirm `N3XT` current definition (from `AGENTS.md` or code).
- [x] **Design Aggregation Pipeline**
  - Construct a MongoDB aggregation pipeline that:
    - Joins `QU3EU` with `G4ME` to access `DPD`.
    - Calculates a `NextCheckTime` based on `Updated` timestamp and `DPD`.
    - Sorts by `NextCheckTime` ascending.
- [x] **Implement View Update**
  - Create a C# method in `PROF3T/PROF3T.cs` (or a dedicated migration script) to:
    - Drop the existing `N3XT` view.
    - Create the new `N3XT` view with the designed pipeline.
- [x] **Verify Update**
  - Run the update method.
  - Verify the view definition (if possible via code or logs).
  - Verify `N3XT` returns the expected game (high DPD, long wait).

## Technical Details

**Proposed Priority Formula:**
`NextCheckTime = LastUpdated + (BaseInterval / (1 + DPD_Factor * DPD))`
- `BaseInterval`: Nominal time between checks for 0 DPD (e.g., 60 mins).
- `DPD_Factor`: Tuning parameter (e.g., 1.0).

**Pipeline Steps:**
1. `$match`: `{ Unlocked: true }` (from `QU3EU`)
2. `$lookup`: Join `G4ME` on House/Name.
3. `$unwind`: Flatten game data.
4. `$addFields`: Calculate `NextCheckTime`.
5. `$sort`: `{ NextCheckTime: 1 }`.
6. `$limit`: 1.
7. `$replaceRoot`: Output the `Game` document.
