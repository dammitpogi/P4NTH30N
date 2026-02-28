---
title: UI Layouts v0
kind: spec
status: superseded
owner: Nexus
last_updated: 2026-02-28
topics:
  - ui
  - layouts
  - design
related:
  - SPEC_UI_LAYOUTS.md
---

## 1) The 3–4 UI layouts that govern everything (design-first)

Think of these as **four shells** that share components, not four separate apps.

### A) Book Shell (Learning + Playbook)

**Primary job:** guide skill development + provide “what to do next” playbook when alerts fire.

**Top nav**

* Library (Book)
* Playbooks
* Glossary
* Drills / Practice
* Search (global)

**Left rail (content)**

* Part → Chapter → Section tree
* “Continue” / “Recently read”
* Bookmarks
* “My weak spots” (links to relevant sections)

**Main pane (reading)**

* Section text
* “Key ideas” cards
* “Common mistakes” callouts
* “Checklist for today” (1–5 bullets)
* “If X happens…” scenario tree (compact)
* Related: concepts, alerts, playbooks

**Right rail (agent assist)**

* “Explain like I’m five”
* “Quiz me” (3–5 questions)
* “Make flashcards”
* “Show examples using SPY”
* “Where does this show up on charts?”

**Design rules (keep it not-empty, not-bloated)**

* Every section has: **1 summary**, **1 checklist**, **1 drill**, **links to 1–3 related alerts**
* Avoid long “wiki sprawl”: cap related links + enforce a template per section

---

### B) Trade Journal + Dashboard Shell (Daily workflow)

**Primary job:** morning plan → intraday alerts → end-of-day review → lessons loop.

**Top nav**

* Today
* Alerts
* Journal
* Review
* Stats

**Today page (single page that makes it “feel alive”)**

* Market day status (pre/open/close)
* “Plan for Today” (generated from yesterday + book skill goals)
* Watchlist / levels
* Upcoming events (CPI/FOMC/opex)
* “Risk guardrails armed” (max loss/day, max trades, cooldown)

**Alerts page**

* Feed with filters:

  * Severity (info/warn/critical)
  * Category (vol regime / dealer-flow / level break / time-to-close / risk)
  * State (new → acknowledged → acted → dismissed)
* Each alert expands into:

  * Why it triggered (human text)
  * What to check next (3 bullets)
  * Relevant playbook (one-click open)
  * “Create journal entry from alert” button

**Journal page**

* List of trades + “notes without trades” (important!)
* Fast add buttons:

  * “New trade”
  * “Adjustment / roll”
  * “Missed trade”
  * “Lesson learned”
* Inline tags + quick filters (strategy, DTE, direction, thesis tags, mistake tags)

**Review page**

* EOD checklist (guided)
* “Top 3 mistakes” (agent suggested)
* “One skill to focus tomorrow” (links into book)
* “Replay timeline” (alerts + actions + journal entries)

---

### C) Admin / Ops / Agent Config Shell (you + power users)

**Primary job:** keep the system stable, safe, and configurable without redeploys.

**Top nav**

* System Status
* Config
* Data Sources
* Users/Roles
* Logs/Audit

**Key pages**

* **Status:** uptime, last data refresh, alert pipeline health, model health
* **Config:** risk limits, alert thresholds, trading hours, notification routing
* **Curriculum ingest:** upload/update book content, rebuild QMD index
* **Agent behavior:** “tone”, strictness, allowed outputs, prompt templates
* **Audit log:** every agent action, every alert emission, every config change

**Design rule**

* Everything risky requires **two steps**: change → review → apply (your “defense-in-depth” pattern fits). 

---

### D) Public-Facing / Login / Onboarding Shell

**Primary job:** clean entry + fast “what is this” explanation, then hand off to the product.

**Pages**

* Landing (what it does, who it’s for, disclaimers)
* Login
* First-run onboarding:

  * set risk limits
  * choose strategies allowed (defined-risk only)
  * notifications (email/telegram/etc.)
  * pick skill goal (from book)

**Design rule**

* Keep public marketing minimal; most value is behind login.

---

## 2) Trading Journal (UI emphasis): what inputs + buttons + layouts

You don’t need to understand options to design a great journal—design it around **decisions + risk + outcome**.

### A) Journal entry types (buttons)

* **New Trade**
* **Adjustment** (roll, add, reduce, hedge)
* **Exit**
* **No-Trade Note** (discipline is a “trade”)
* **Lesson Learned**
* **Screenshot / Chart note**

### B) New Trade form (inputs)

**Step 1: Snapshot**

* Date/time
* Underlying: SPY
* Strategy template (dropdown: credit spread / debit spread / iron condor / butterfly)
* Direction: bullish/bearish/neutral
* DTE bucket: 0DTE / 1–7 / 8–30 / 30–60
* Defined risk: (yes locked)

**Step 2: Risk**

* Max loss ($)
* Target profit ($ or %)
* “Stop / invalidation rule” (text)
* Size / contracts
* Account risk % (optional)

**Step 3: Thesis**

* Thesis tags (dropdown chips): vol regime, dealer-flow, level break, mean reversion, trend day, event premium, etc.
* One-paragraph thesis
* Link to playbook used (auto-suggest)

**Step 4: Execution**

* Entry price
* Planned exit conditions (profit, time stop, invalidation)
* “What would make me exit early?” (text)

**Step 5: Attach**

* Chart snapshot
* Alerts that preceded trade (select from today’s feed)

### C) Derived metrics (computed; shown in UI)

You don’t want the user to enter these manually.

* R multiple (P/L ÷ max risk)
* Win/loss streak
* Average hold time
* Time-of-day performance
* Strategy performance (per template)
* “Mistake tags” frequency
* “Followed playbook?” yes/no

### D) EOD workflow (guided layout)

One page with a checklist + auto-filled context:

* “Did you follow your max trades / max loss?” (yes/no)
* “What did you do well?” (free text)
* “Top mistake tag” (suggested + editable)
* “One improvement tomorrow” (agent suggests, user confirms)
* “Book assignment for tomorrow” (links to section + drill)

### E) Weekly review (UI)

* Performance by:

  * strategy template
  * regime tag
  * time-of-day
* Mistake heatmap (simple)
* “Stop doing / start doing / keep doing” (3 boxes)
* “Next week focus” (1 skill)

---

## 3) Guidance on the Book (navigation + “not empty” without bloat)

You already have a strong Part/Chapter/Section structure. The trick is to make each section feel *useful* with a consistent, small template.

### Minimum per Section (to avoid emptiness)

* **Summary (3 bullets)**
* **Checklist (5 bullets max)**
* **One scenario tree** (If X and Y → do A; else → do B)
* **One drill**
* **1–3 linked alerts** (what alerts relate to this section)
* **Glossary terms** (auto-linked)

### Cross-cutting book features that stay lean

* Global search (QMD-backed)
* Bookmarks + highlights
* “Continue reading”
* “Related playbooks”
* “Ask the agent about this section” (contextual)

### Keep it coherent with your Part breakdown

* **Foundations:** the language + base mental models + basic workflows
* **Microstructure:** the “why did price move / what does flow imply” + alert mappings
* **Macro:** scheduled risk + regime context + “don’t get chopped” rules
* **Crisis:** what to do when conditions break (kill-switch behaviors)
* **Trader Mind:** discipline, review, and skill development loops
