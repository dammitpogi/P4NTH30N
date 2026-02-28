# TradingView Skill

Fetch real-time market data and technical indicators from TradingView.

## Commands

### Fetch Single Symbol
```bash
node /data/workspace/skills/tradingview/fetch.js SPY
```

### Fetch Watchlist
```bash
node /data/workspace/skills/tradingview/fetch.js SPY SPX ES VIX VVIX XSP
```

### Output
Data saved to `/data/workspace/trading/market-data/`:
- `current.json` — Latest fetch (all symbols)
- `{symbol}.json` — Individual symbol history

## Supported Indicators
- Price (open, high, low, close, change, change%)
- Volume
- RSI (14)
- MACD
- Stochastic %K/%D
- ATR
- 20/50/200 EMA/SMA
- Volatility (for VIX/VVIX)

## Cron Jobs
- **Pre-market**: 7:00 AM MT (14:00 UTC) Mon-Fri
- **Intraday**: Every 10 min, 7:30-9:30 AM MT (14:30-16:30 UTC) Mon-Fri

## Symbol Mapping
| User Symbol | TradingView Symbol |
|-------------|-------------------|
| SPY         | AMEX:SPY          |
| SPX         | SP:SPX            |
| ES          | CME_MINI:ES1!     |
| XSP         | CBOE:XSP          |
| VIX         | CBOE:VIX          |
| VVIX        | CBOE:VVIX         |
