# Jackpot Threshold Calibration Strategy (WIN-006)

## Overview

Jackpot thresholds determine when H0UND generates signals for FourEyes to act. Properly calibrated thresholds maximize win probability while minimizing cost per attempt.

## Jackpot Tiers

| Tier | Typical Range | Default Threshold | Signal Trigger |
|------|--------------|-------------------|----------------|
| **Grand** | $500–$5,000+ | $1,785 | When value ≥ threshold |
| **Major** | $100–$1,000 | $565 | When value ≥ threshold |
| **Minor** | $25–$200 | $117 | When value ≥ threshold |
| **Mini** | $5–$50 | $23 | When value ≥ threshold |

## Calibration Methodology

### Phase 1: Data Collection (Passive)

Before setting thresholds, collect historical jackpot data:

1. Run H0UND in monitoring-only mode (no signals generated)
2. Record jackpot values every polling interval
3. Track when jackpots reset (indicating a win occurred)
4. Collect minimum 7 days of data per game

### Phase 2: Statistical Analysis

From collected data, calculate for each tier:

- **Mean reset value**: Average jackpot value when it resets
- **Median reset value**: 50th percentile reset value
- **P75 reset value**: 75th percentile (more conservative)
- **DPD (Dollars Per Day)**: Average daily value increase
- **Reset frequency**: How often the jackpot resets per day

### Phase 3: Threshold Selection

**Conservative approach** (recommended for first attempts):
- Set threshold at **P75 of historical reset values**
- Higher threshold = fewer triggers but higher expected value per trigger
- Lower cost per day but fewer opportunities

**Aggressive approach** (after proven system):
- Set threshold at **median of historical reset values**
- More triggers, lower expected value per trigger
- Higher daily cost but more opportunities

### Phase 4: Cost/Benefit Calculation

For each tier, calculate:

```
Expected Win = P(jackpot at threshold) × Jackpot Value at Threshold
Cost Per Attempt = Bet Amount × Average Spins to Win
Daily Cost = Cost Per Attempt × Triggers Per Day
ROI = (Expected Win × Win Rate) / Daily Cost
```

**Target**: ROI > 1.0 (net positive expected value)

## Configuration

Thresholds are stored in the `G4ME` collection in MongoDB:

```json
{
  "Game": "game_name",
  "House": "casino_name",
  "Thresholds": {
    "Grand": 1785,
    "Major": 565,
    "Minor": 117,
    "Mini": 23
  }
}
```

## Adjustment Procedures

### After First 100 Spins
1. Review actual cost vs estimated cost
2. Check if signals triggered at expected rate
3. Adjust thresholds if cost exceeds 120% of estimate

### After First Win
1. Record actual jackpot value at win time
2. Compare to threshold — was timing optimal?
3. Adjust thresholds based on real data

### Weekly Review
1. Update DPD calculations with new data
2. Recalculate optimal thresholds
3. Check if game mechanics have changed (casino updates)

## Safety Constraints

- **Never** set thresholds below the game's minimum jackpot seed value
- **Always** validate thresholds against the daily loss limit (WIN-004)
- **Maximum** daily cost must be < 50% of daily loss limit
- **Review** threshold changes with stakeholders before applying
