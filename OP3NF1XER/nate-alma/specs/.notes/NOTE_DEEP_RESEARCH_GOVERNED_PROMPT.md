---
title: Governed Deep Research Prompt
kind: note
status: draft
last_updated: 2026-02-28
topics:
  - design
  - prompts
  - governance
---

You are a senior **product designer + UX architect** with strong **UI systems** thinking and enough full-stack awareness to specify interaction contracts clearly. I am a backend/full-stack developer, **not a UI designer** and **not a trader**. I want **design-first, implementation-oriented UI guidance** (wireframe-level specs, component inventory, interaction states, copy), not trading theory.

### FOUNDATION DECISION (Non-negotiable governance)

1. **Book-first:** Every feature must improve reading, retention, recall, or playbook application.
2. **Stable shell:** 3-column layout is sacred: **TOC left, Reader center, Agent right**.
3. **No empty pages:** Every page has an intentional empty state + one “next action.”
4. **No silent failure:** Every async action surfaces status + last run + errors.
5. **One design system:** Standardize controls; no one-off UI components.
6. **Stop rules:** Fully spec Book UI + Agent panel before expanding into lower priority areas.

### Context Snapshot (authoritative)

* Product: Personal trading helper centered on **book learning + playbook guidance**.
* User: trades **SPY listed options**, mostly **0DTE/weekly**, uses **defined-risk spreads only**.
* Non-goal: **No auto-execution** and no “click to trade” UX.
* Tech: **Next.js App Router**, Tailwind, **shadcn/ui**, Lucide, `@tailwindcss/typography`.
* Persistence: **MongoDB** stores users, book sections, notes, highlights, bookmarks, reading progress, playbooks, audit log (and optionally agent run history).
* Deployment: Railway with three services:

  1. **Next.js Web App** (only public service; owns auth and UI)
  2. **Core container** (OpenClaw + QMD + SFTPGo) internal only
  3. **MongoDB** internal only
* Content: The book is stored in MongoDB (source of truth). QMD powers semantic search.
* Visual style: **modern, calm, editorial “research UI”** (OpenAI-like): disciplined spacing, strong typography, quiet chrome, one restrained accent.

---

# 1) PRIORITY ORDER (do not reorder)

You must output in this order. Do not expand lower items until the higher items are complete.

## (1) Book UI: Library + Reader (highest priority)

### Library page goals

* Left rail: Parts → Chapters → Sections tree (TOC), collapsible groups, progress indicators.
* Top: global search, “Continue”, bookmarks.
* Main: section list with summaries + reading progress.
* Right rail: “Today’s focus” (1–3 sections), recent notes.

### Reader page goals

* Center: section content in editorial typography.
* Required section blocks (consistent everywhere):

  * TL;DR (3 bullets)
  * Checklist (max 5)
  * Common mistakes (max 3)
  * Drill (1 exercise)
* Right rail: agent panel with skill actions.
* Must support: highlights, notes, bookmarks, tags, deep-links to headings/anchors.

## (2) Agent Panel (book-centric tools/skills)

Design as UI actions in the Reader’s right rail. Must include:

1. Explain/Rephrase (simple/technical/analogy)
2. Socratic Tutor (3–5 questions, track missed concepts)
3. Flashcards/Quiz generator (5–10)
4. Checklist builder (pre/during/post)
5. Scenario tree builder (If/Then → save as Playbook draft)
6. Notes assistant (create note, tag concepts, link to anchors)
   Optional: “Where does this show up in SPY?” = **text-only** for MVP

For each skill provide:

* UI label + microcopy
* input context used (section, anchor, selected text, notes)
* output format (structured)
* where it can be saved (note/playbook draft)
* guardrails language: education-first, no financial advice, no execution

## (3) Notes / Highlights / Bookmarks / Progress

UI specs for:

* Notes page (filters, tags, backlinks, “recent notes”)
* Highlighting flow inside Reader (selection → action menu → attach note)
* Bookmarks (section or anchor)
* Reading progress + “Continue” experience

## (4) Playbooks (draft → review → publish)

UI specs for:

* Playbooks list (draft vs published)
* Playbook detail view (triggers, checklist, scenario tree, linked sections)
* Draft lifecycle: draft → review → publish (admin) → archive

## (5) Minimal Admin (only what’s necessary)

* Status dashboard: last import/publish, last reindex, health indicators
* “Publish” controls (if drafts exist)
* “Reindex Book” control (triggers QMD reindex + UI cache refresh)
* Minimal audit log surface

## (6) Placeholder nav items (Dashboard / Journal / Alerts)

Provide **intentional** placeholder pages with:

* empty state copy
* one next action
* clear “coming soon” structure
  (These should not bloat the design. Keep them lean.)

---

# 2) DESIGN SYSTEM REQUIREMENTS (very important)

I want consistent controls and modern spacing/typography.

## Style direction

* Calm editorial “research UI” (OpenAI-like)
* Charcoal-based dark theme, subtle surfaces, quiet borders
* One restrained accent (links/focus/active only)
* Strong readable type hierarchy; relaxed body line height
* “Full but breathable”: consistent rhythm > huge whitespace
* Avoid “trading gamer” aesthetics (no neon, no aggressive gradients)

## Library stack

Provide:

* **One recommended** component stack: Tailwind + shadcn/ui + Lucide (+ typography plugin)
* **One alternative** stack: Radix primitives + Tailwind with custom wrappers
  For each:
* component inventory you’ll standardize on (buttons, inputs, selects, chips/tags, dialogs, dropdowns, command palette, rails, cards, tables)
* rules to prevent UI drift (“no one-off controls”)

Also include:

* accessibility baseline (keyboard nav, focus states, aria patterns)
* design tokens guidance (type scale, spacing scale, radii, shadows)

---

# 3) NETWORKING & SECURITY GOVERNANCE

You must respect this boundary in your UI/flow assumptions.

* Only Next.js is public.
* MongoDB and OpenClaw/QMD/SFTPGo are **internal** only (no direct browser access).
* Next.js is the identity boundary. OpenClaw is a protected backend.

Hardening expectations:

* login rate limiting + clear UX for errors/lockout
* server-to-server auth for Next.js → OpenClaw calls
* audit log for admin actions and agent actions (at least minimal)

---

# 4) MINIMAL ENDPOINT CONTRACT (use this structure in your design)

## Browser → Next.js only

* Auth:

  * POST `/api/auth/login`, POST `/api/auth/logout`, GET `/api/auth/me`
* Book:

  * GET `/api/book/toc`
  * GET `/api/book/section?slug=...`
  * GET `/api/book/search?q=...`
* Notes/Highlights/Bookmarks/Progress:

  * POST/GET/PATCH/DELETE `/api/notes`
  * POST `/api/highlights`
  * POST `/api/bookmarks/toggle`
  * POST `/api/progress`
  * GET `/api/progress/summary`
* Playbooks:

  * GET `/api/playbooks`
  * POST `/api/playbooks/draft`
  * PATCH `/api/playbooks/:id`
  * POST `/api/playbooks/:id/publish` (admin)
  * POST `/api/playbooks/:id/archive` (admin)
* Agent:

  * POST `/api/agent/skill` (single contract endpoint; include skill + context)
* Admin:

  * POST `/api/admin/book/reindex`
  * GET `/api/admin/status`
  * POST `/api/admin/config` (optional; can be stubbed)

## Next.js → OpenClaw internal only

* POST `/internal/search` (QMD)
* POST `/internal/agent/run`
* POST `/internal/index/rebuild`
* GET `/internal/index/status`
* GET `/internal/health`

You do not need to implement these, but your UI specs must align with these contracts.

---

# 5) DELIVERABLES (must be concrete, wireframe-level, not vague)

You must produce:

1. **Information Architecture**

* Top nav + sidebar/TOC nav trees
* Route/URL scheme (deep-linkable to heading anchors)

2. **Page-by-page wireframe specs** (in priority order 1→6)
   For each page, include:

* purpose
* layout structure (rails + blocks)
* components used (by name)
* primary actions
* empty states + microcopy
* states (loading, error, success)
* what makes it feel “full” even with minimal content

3. **Interaction/state diagrams (text is fine)**

* highlighting flow + attach note
* agent skill output → save as note / save as playbook draft
* playbook draft → review → publish
* search results → open section at anchor

4. **Component inventory**

* exact shadcn components used per page
* component variants (primary/secondary/ghost/link, chip variants, etc.)
* rules that enforce consistency

5. **Login + onboarding UX**

* iconic, minimal login screen layout
* onboarding steps (3–4): name, notification placeholder, learning goal mapping into book, guardrails prefs placeholder
* hardened UX patterns: rate-limit messaging, error copy, session cues
  (Keep MVP implementable; do not propose enterprise IAM.)

6. **MVP build sequence**

* A recommended build order that ships Book UI + agent panel fast, with placeholders elsewhere.
* Include acceptance criteria for “Book UI is shippable.”

7. **Minimal open questions**

* Ask only at the end, and only what is absolutely necessary.

---

# 6) STOP CONDITIONS (to prevent drift)

* After completing **(1) Book UI** and **(2) Agent Panel**, you must output a **one-paragraph summary** of remaining items (3–6) and confirm you are proceeding, then continue.
* If output length becomes large, you must compress lower-priority items first (5–6), never (1–2).

---

# OUTPUT FORMAT (strict)

* Executive summary
* IA + routing
* (1) Library wireframe spec
* (1) Reader wireframe spec
* (2) Agent panel skill specs (contracts + UI)
* Stop condition paragraph, then continue
* (3) Notes/Highlights/Bookmarks/Progress
* (4) Playbooks (draft→publish)
* (5) Admin minimal
* (6) Placeholders
* Design system + tokens + component inventory
* Login/onboarding UX
* MVP build sequence + acceptance criteria
* Minimal open questions
