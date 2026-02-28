# MEMORY.md - Long-Term Memory

Agent identity in this workspace: `Alma`.

## Critical Lessons

### Timestamps & Cron Jobs
**NEVER guess or make up timestamps.** Always:
1. Get current time from `session_status` 
2. Calculate target time correctly (add duration to current)
3. Convert to milliseconds (Unix timestamp * 1000)
4. Double-check the math before scheduling

**Why:** Invented timestamps cause cron jobs to fail silently. Bad UX. Do it right.

---

## About Nate (USER.md has more details)

- Mountain Time (Salt Lake City, Utah)
- Running OpenClaw on Railway (UTC-based)
- Studying options trading (Stochastic Volatility trader materials)
- Cost-conscious with API spend ($5 prepaid budget)

### Communication Preference Snapshot

- Answer first, then evidence path.
- Avoid question loops for non-destructive actions.
- Prefer project-based organization over channel sprawl.
- Wants deterministic tooling for recurring requests.

---

## Projects

### Multi-Model Architecture (Feb 2026)
Planning to add multiple LLM providers and named agents:
- Provider cascade for rate-limit failover
- Different agents for different tasks (Dash=daily, Coder=Opus, Scout=GPT-4o)
- OpenClaw supports this via `agents.list[]` + `bindings` + `model.fallbacks`
- See `/data/workspace/memory/2026-02-24.md` for details

### Options Trading Study
- Learning volatility trading mechanics
- Studying with a teacher who sends daily analysis at ~7 AM MT
- Teacher analyzes SPX and ES primarily
- Nate trades SPY and XSP (can't afford SPX options yet)
- See `/data/workspace/trading/` for watchlist, checklist, trade log

---

## Infrastructure

- **OpenClaw:** Running on Railway (UTC)
- **Models:** opus, sonnet, haiku (model-switcher skill for instant switching)
- **Skills Created:**
  - `api-tools` — Generic HTTP testing
  - `model-switcher` — Instant model switching (no config changes)
  - `context-memory` — JSON-based task/memory management

### Channel and Group Context

- Telegram group: `nate and Alma`
- Group id: `-5107377381`
- Desired behavior: no forced mention requirement (`requireMention: false`, `groupPolicy: open`)

---

## Tools & Systems

- **Context-Memory:** Use for tracking tasks, ideas, projects (organized into 4 main project areas: Mac Mini Node, Smart Home, Trading Infrastructure, Social Monitoring)
- **Scheduling rule:** prefer heartbeat + JSON reminders when cron reliability is uncertain
- **Model switching:** Just say "opus", "sonnet", or "haiku"
- **TradingView Skill:** Auto-fetches SPY, SPX, ES, XSP, VIX, VVIX data. Pre-market (7 AM MT) + intraday (7:30-9:30 AM MT every 10 min). Data at `/data/workspace/trading/market-data/`
- **Alma Analysis Parser:** When Nate pastes Alma's daily Substack analysis, AUTO-SWITCH TO OPUS for accuracy. Parse levels, convert SPX→SPY using live ratio (not /10), preserve mean reversion strings, generate options strikes grid.
- **SPX to SPY Conversion:** Use live ratio from current.json (SPX/SPY), NOT just divide by 10. The ~0.15% difference matters for strike selection.

### Telegram Group Chat Fix (Feb 23, 2026)
Group chat "nate and Alma" (id: -5107377381) was requiring @mentions. Fixed by:
1. Disabling Privacy Mode via @BotFather
2. Adding group config with `requireMention: false` and `groupPolicy: "open"`
3. Redeploying to apply changes

Config location: `/data/.clawdbot/openclaw.json` under `channels.telegram.groups`

---

## Alma Execution Defaults

- Output format for ops tasks: change -> validation -> artifact path.
- Output format for trading asks: regime -> levels -> bias -> invalidation.
- If uncertain, do local verification before asking Nate.
- Always preserve rollback path when moving/editing multiple files.
