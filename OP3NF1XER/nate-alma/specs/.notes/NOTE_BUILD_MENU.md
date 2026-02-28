---
title: Build Menu for SPY Options Agent
kind: note
status: draft
last_updated: 2026-02-28
topics:
  - build
  - menu
  - architecture
---

Below is (1) a comprehensive build menu you can choose from, and (2) a polished deep-research prompt tailored to your situation (developer, not trader; SPY + options; OpenClaw agent; Railway deployment; low/no cost).

---

## Comprehensive build menu for a SPY + options helper agent

### A) Data sources and ingestion

* **Broker API market data adapter(s)** (quotes, options chain, greeks if available, account positions)
* **Underlying-only data** (SPY OHLCV, volume, VWAP proxies) for regimes/triggers even when options data is limited
* **Economic calendar ingestion** (Fed meetings, CPI, jobs, etc.)
* **Earnings & events calendar** for major SPY holdings (helps with IV spikes)
* **News/event feed ingestion** (structured feed preferred over web scraping)
* **SEC EDGAR watcher** for top holdings (8-K/10-Q/10-K diffs → alerts)

### B) Storage and retrieval

* **Trade journal DB** (paper + real): orders, fills, tags, thesis, screenshots/links
* **Signal store**: alerts fired, features at the time, outcomes
* **RAG library**: your QMD vector search over his books + your own internal “playbook” docs
* **Caching layer** for rate-limited APIs + fast retrieval
* **Configuration vault**: risk parameters, allowed strategies, max loss/day, etc.

### C) Analytics and indicators (SPY-first, options-aware)

* **Volatility regime engine** (HV, ATR, range expansion, trend/mean reversion classification)
* **IV proxy + event premium heuristics** (even without full OPRA, you can approximate useful regimes)
* **Basic TA pack**: MA slopes, RSI, MACD, breadth proxies if you add them
* **Support/resistance + anchored VWAP tools**
* **Backtesting harness** for simple rules (don’t overfit; focus on sanity checks)

### D) Options-specific intelligence

* **Strategy selector**: given regime + time horizon + risk, propose strategy templates:

  * debit spreads, credit spreads, calendars/diagonals, iron condors, butterflies, collars
* **Payoff + Greeks calculator** (PnL curves, break-evens, theta decay profile)
* **Position sizing module** (risk per trade, max portfolio exposure, defined-risk only)
* **“What-if” scenario runner** (move + vol crush/expansion + time decay)
* **Expiration tooling**: DTE planning, roll rules, assignment risk warnings

### E) Execution layer (paper first, then real)

* **Paper trading integration** (orders, simulated fills, slippage model)
* **Live trading integration** (optional, with hard safety rails)
* **Order policy engine**: limit/market constraints, max spreads, avoid illiquid strikes
* **Kill switch & circuit breakers**: daily max loss, consecutive losses, volatility spikes

### F) Alerts & monitoring (this is where traders feel value)

* **Price/level alerts**: breaks, reclaims, gap fills, VWAP/AVWAP touches
* **Vol alerts**: HV spike, IV spike proxy, dispersion/event premium
* **Time-based alerts**: “30 min to close,” “tomorrow is CPI,” “opex week”
* **Position alerts**: delta exposure drift, theta burn, nearing stop, roll candidates
* **News/filing alerts**: “material 8-K filed for top holding”

### G) UX surfaces

* **Telegram/Discord/Slack bot** for alerts + Q&A
* **Web dashboard**

  * positions
  * watchlist
  * alert history
  * trade journal
  * PnL + attribution
  * “agent recommendations” with explainability
* **Email digests** (morning plan + end-of-day recap)
* **One-click “explain this trade”**: why, what could go wrong, what invalidates

### H) Safety, compliance, and guardrails

* **Permission levels**: read-only vs paper trade vs live trade
* **Defined-risk enforcement** (especially important for options)
* **Advice disclaimers + “education mode”**
* **Audit log** of every agent action and data source used
* **Prompt injection hardening** for any web/news ingestion

### I) Reliability / ops (Railway-friendly)

* **Sleep-friendly architecture** (avoid background chatter that prevents sleeping)
* **Job scheduler** (polling windows aligned with market hours)
* **Observability**: request logs, latency, alert delivery tracking
* **Cost controls**: caching, rate limiting, bounded fanout for the agent