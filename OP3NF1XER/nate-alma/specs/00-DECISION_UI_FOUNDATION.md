---
title: UI Foundation Decision
kind: dec
status: accepted
owner: Nexus
last_updated: 2026-02-28
topics:
  - ui
  - governance
  - foundation
---

## 0) Purpose

This document defines the non‑negotiable UI governance for the project.  
Any UI spec, Deep Research output, or implementation must **not contradict** these decisions.

If a proposal conflicts with this document, it must be revised or escalated as a new decision.

---

## 1) Product stance

### 1.1 Book-first MVP (core thesis)
The product is **education + playbook guidance** centered on a structured “Book” corpus.

**Non-goal:** No trade execution UX (no “place trade”, no broker order entry).

### 1.2 Target user and scope
- Primary user: trades **SPY listed options**, mostly **0DTE/weekly**, prefers **defined-risk spreads only**.
- The UI is not a brokerage clone. It is a **research/learning environment** with “book + agent panel + playbooks + notes”.

---

## 2) UI foundation rules (non-negotiable)

### 2.1 Stable shell
The core layout is a stable 3‑column shell:

- **Left rail:** Book TOC / navigation (Parts → Chapters → Sections)
- **Center:** Reader / content (editorial typography)
- **Right rail:** Agent panel (skills/actions)

This shell is “sacred” for the Book experience and must remain consistent across pages where it applies.

### 2.2 Book-first prioritization
Every feature must tie back to **reading, retention, recall, or playbook application**.

If a module does not improve the learning loop, it is lower priority and may remain a placeholder.

### 2.3 No empty pages
Every page must have an intentional empty state:
- a short explanation of what belongs here
- exactly one clear “next action”

### 2.4 No silent failure
Every asynchronous process must surface:
- **status** (idle/running/succeeded/failed)
- **last run time**
- **error visibility** (with a retry action when appropriate)

Examples: reindex, publish, search, agent run, import.

### 2.5 One design system
We standardize UI controls and styling. No one-off components.

**Recommended stack:**
- Next.js **App Router**
- Tailwind CSS
- shadcn/ui (Radix-based)
- Lucide icons
- @tailwindcss/typography for Reader/editorial rendering

---

## 3) Visual style direction (short)

### 3.1 Vibe
Modern, calm, “trading-adjacent” but **not gamer**.  
Feels like a premium research journal: disciplined spacing, strong typography, quiet chrome.

### 3.2 Typography + spacing principles
- Editorial readability: constrained text measure, relaxed line height, clear hierarchy.
- “Full but breathable”: structure and rhythm create density without clutter.
- Quiet surfaces, minimal borders; subtle separators only where needed.
- One restrained accent color for links/focus/active states (no neon).

---

## 4) Architecture & security boundary (UI-relevant)

### 4.1 Public/private boundary
- **Only the Next.js website is public.**
- OpenClaw/QMD/SFTPGo and MongoDB are **internal-only** (not reachable from browsers).

### 4.2 Identity boundary
- **Next.js is the single identity boundary** (login, sessions, roles).
- The browser never calls internal services directly.
- Next.js calls internal services server-to-server with an authenticated service token.

### 4.3 Hardening expectations (MVP-friendly)
- Rate limit login and expensive operations (search, agent actions, reindex).
- Strict CORS (browser → Next.js only).
- Audit log for admin actions (publish, reindex, config changes) and agent actions (skill invoked, saved outputs).

---

## 5) Canonical page set (MVP)

### 5.1 Must ship (Book-first MVP)
1) **Library** (Book index)
2) **Reader** (Section view)
3) **Playbooks** (list + detail, can start as shells)
4) **Notes** (filters/tags/backlinks)
5) **Admin minimal** (reindex + status; publish if drafts exist)
6) **Login + onboarding**

Everything else may exist as placeholders (Dashboard/Journal/Alerts) with strong empty states.

### 5.2 Required Reader section template blocks
Every section page renders (when present):
- TL;DR (≤ 3 bullets)
- Checklist (≤ 5 bullets)
- Common mistakes (≤ 3)
- Drill (1 exercise)

If any block is missing, show a small “Coming soon” stub (not empty whitespace).

---

## 6) Agent panel governance

### 6.1 Required MVP skills
The Agent panel must expose **buttonable skills** (UI actions) that operate on the current section:

1) Explain/Rephrase (simple/technical/analogy)
2) Socratic Tutor (3–5 questions; track missed concepts)
3) Flashcards/Quiz (5–10)
4) Checklist builder (pre/during/post)
5) Scenario tree builder (If/Then → save as Playbook draft)
6) Notes assistant (create note, tag concepts, link to anchors)

Optional early skill: “Where does this show up in SPY?” **text-only** for MVP.

### 6.2 Output saving affordances
Every agent output must offer:
- Copy
- Save as Note
- For scenario/checklist outputs: Save as Playbook Draft

### 6.3 Safety language
Agent outputs must be education-first and avoid:
- explicit “do this trade now”
- execution instructions
- certainty language that reads like financial advice

---

## 7) Deep Research governance (how to use this file)

When prompting Deep Research:
- Treat this document as canonical.
- Enforce priority order: **Book UI + Agent panel first**.
- Require wireframe-level concreteness: component lists, layout constraints, states, microcopy.
- Apply “stop conditions”: spec Library/Reader/Agent fully before expanding into lower priority modules.

---

## 8) Acceptance criteria checklist (Definition of Done)

A UI spec is acceptable only if it includes:

- [ ] IA + routing (including heading deep-links)
- [ ] Library wireframe spec (components + states + empty copy)
- [ ] Reader wireframe spec (editorial typography + section blocks + highlight/note UX)
- [ ] Agent panel skill specs (inputs/outputs/save actions/guardrails)
- [ ] Notes and Playbooks UX (draft lifecycle at least)
- [ ] Admin minimal UX (reindex status, last run, errors)
- [ ] Login + onboarding UX (MVP-hardened patterns)
- [ ] Design system component inventory (shadcn components + variants)
- [ ] “No empty pages” and “no silent failure” compliance

---
