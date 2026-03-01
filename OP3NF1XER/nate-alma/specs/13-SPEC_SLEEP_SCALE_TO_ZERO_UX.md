# SPEC_SLEEP_SCALE_TO_ZERO_UX

**Status:** Accepted (addresses DECISION_172 “Must Address #4”)  
**Owner:** Nexus  
**Audience:** Pyxis (Strategist), Implementers  
**Last updated:** 2026-02-28

## 0) Purpose

Define UX patterns for when the `core` service is sleeping/unreachable (cold start, scale-to-zero),
without violating:
- **No silent failure**
- **Calm UI**
- Book-first priority

---

## 1) Detection rules (Web)
Treat Core as unavailable when:
- request times out
- 502/503
- `/internal/health` fails

Do not spin forever. Use a 5–8s timeout and then surface UI state.

---

## 2) User-facing patterns

### 2.1 Agent Panel (Reader)
States:
- **Ready**
- **Waking** (first failure or health check indicates sleeping)
- **Unavailable** (after timeout or repeated failures)

**Waking UI**
- Title: “Waking assistant…”
- Body: “This can take a few seconds after inactivity.”
- CTA: `Button` “Retry”
- Secondary: “Continue reading” (no blocking)

**Unavailable UI**
- Title: “Assistant temporarily unavailable”
- Body: “Try again in a moment.”
- CTA: “Retry”
- Show small status line: “Last success: {timestamp}”

### 2.2 Book Search (⌘K)
- If QMD unavailable:
  - fall back to Mongo text search (if enabled) or
  - return “Search is waking up” with Retry
- Never return empty results silently; show a status card.

### 2.3 Admin Reindex
- If Core unavailable:
  - show explicit error: “Core service is asleep/unreachable.”
  - CTA: “Wake and retry”
  - Show last run time and last error details

---

## 3) Retry strategy
- User-driven retry button
- Optional auto-retry once after 2s
- Do not loop infinitely
- Show “still waking…” message after 2 attempts

---

## 4) Telemetry (minimum)
Log in Web:
- core_unavailable events
- time-to-first-success after waking
- retries attempted

This helps tune sleep and timeouts.

---

## 5) Compliance checklist
- [ ] No silent failure: every failure state shows message + retry
- [ ] User can continue reading even if Core is down
- [ ] Admin surfaces last run time + error details
