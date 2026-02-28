# Alma Analysis Parser

## Purpose
Parse Alma's morning Substack analysis and extract key levels, converting SPX to SPY.

## SPX to SPY Conversion
- **Ratio:** SPX ÷ 10.015 ≈ SPY (or just ÷ 10 for quick math)
- Example: SPX 6850 → SPY 684.15

## Key Levels to Extract

### Directional Levels
| Level Type | Description |
|------------|-------------|
| **Centroid** | Central pivot/mean - key reference point |
| **Upside Pivot** | Resistance that if broken = bullish |
| **Upside Target** | Price target if upside pivot breaks |
| **Downside Pivot** | Support that if broken = bearish |
| **Downside Target** | Price target if downside pivot breaks |

### Key Price Zones
| Level Type | Description |
|------------|-------------|
| **Magnets** | Prices that attract price action (often round numbers, high volume nodes) |
| **Confirm Levels** | Price above/below confirms directional bias |
| **Reject Levels** | Price rejection here = reversal signal |
| **Support Levels** | Demand zones, buyers expected |
| **Resistance Levels** | Supply zones, sellers expected |

### Mean Reversion Levels (for indicator input)
| Level | Description |
|-------|-------------|
| **99.73% (3σ)** | Extreme upper/lower bands |
| **95.4% (2σ)** | Outer bands |
| **68.2% (1σ)** | Inner bands |
| **Risk Levels** | Key risk management zones |

## Output Format

```
## Alma Analysis Summary - [DATE]

### Bias: [BULLISH/BEARISH/NEUTRAL]
[One sentence summary of her thesis]

### Key Levels (SPY)

**Upside:**
- Target: XXX.XX
- Pivot: XXX.XX  
- Confirm: XXX.XX

**Center:**
- Centroid: XXX.XX
- Magnets: XXX.XX, XXX.XX

**Downside:**
- Confirm: XXX.XX
- Pivot: XXX.XX
- Target: XXX.XX

### Mean Reversion Inputs
[Ready to paste into TradingView indicator]
Upper 3σ: XXX.XX | Upper 2σ: XXX.XX | Upper 1σ: XXX.XX
Center: XXX.XX
Lower 1σ: XXX.XX | Lower 2σ: XXX.XX | Lower 3σ: XXX.XX

### Trade Ideas
- [Key setups she mentions]
```

## Pattern Recognition

Look for these phrases to identify level types:
- "centroid", "center", "mean", "pivot point" → Centroid
- "upside pivot", "break above", "resistance at" → Upside Pivot
- "target", "measured move", "extension" → Targets
- "downside pivot", "break below", "support at" → Downside Pivot
- "magnet", "attracted to", "gravitating" → Magnets
- "confirm", "acceptance above/below" → Confirm Levels
- "reject", "rejection at", "failed at" → Reject Levels
- "σ", "sigma", "standard deviation", "band" → Mean Reversion Levels
