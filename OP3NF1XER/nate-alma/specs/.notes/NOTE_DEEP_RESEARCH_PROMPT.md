---
title: Deep Research Prompt
kind: note
status: draft
last_updated: 2026-02-28
topics:
  - design
  - prompts
  - research
---

## Deep Research Prompt (Copy/Paste)

You are an expert **product designer + UI/UX architect + full-stack systems architect**. I am a backend/full-stack developer, not a trader, and I need **implementation-oriented UI direction** for a “book-first” trading helper. Development is not an obstacle; the goal is to ship a **polished, consistent UI** fast.

### Product Goal

Build a personal trading helper centered on a **Book UI** and **agentic learning tools**. The user trades **SPY options** (mostly **0DTE/weekly**) and uses **defined-risk spreads only**, but **do not** focus on trading theory—focus on **UI + workflows + agent tools**.

### Hard Constraints

* **Book-first MVP**: the Book experience is the main product. Everything else may be placeholder stubs initially.
* **No auto-execution**. No “place trade” UX.
* Must support a workflow where I can iterate quickly via **pull/merge/push deployments through SFTP** (content updates happen frequently).
* Use **MongoDB** (preferred) for persistence (notes, bookmarks, user profiles, settings). Content is file-based (markdown) and indexed for search.
* Agent must provide learning support and playbook drafting, not financial advice.

### MVP Scope (must be fully specified)

Deliver the design + implementation blueprint for these **three core pages** and supporting systems:

1. **Library**

* Left rail: Parts → Chapters → Sections tree (TOC)
* Top: global search, “Continue”, bookmarks
* Main: section list with summaries + reading progress
* Right rail: Today’s Focus (1–3 sections), recent notes

2. **Reader**

* Main: section content rendering
* Required consistent section template blocks:

  * TL;DR (3 bullets)
  * Checklist (max 5)
  * Common mistakes (max 3)
  * Drill (1 exercise)
* Right rail: Agent panel (skills listed below)
* Must support highlights, bookmarks, notes, tags, and deep-links to headings

3. **Playbooks**

* A playbook is a structured artifact:

  * Triggers (plain English)
  * Checklist
  * Scenario tree (If/Then)
  * Linked book sections (2–6)
* Start with ~10 playbook shells; support “draft → review → publish” lifecycle

Everything else can exist in navigation as “coming soon” placeholders:

* Dashboard, Journal, Alerts, Admin (beyond what’s necessary)

### Agent Panel: Required Skills/Tools (book-centric)

Design and specify “agent skills” as UI actions in the reader’s right panel. Must include:

1. Explain/Rephrase (simple/technical/analogy)
2. Socratic Tutor (3–5 questions + track missed concepts)
3. Flashcards/Quiz generator (5–10 cards)
4. Checklist builder (pre/during/post)
5. Scenario tree builder (If/Then; saved as Playbook draft)
6. Notes assistant (create note, tag concepts, link to section anchors)
   Optional: “Where does this show up in SPY?” should be text-only for MVP (no charts required).

For each skill:

* UI button label
* expected input context (current section, highlights, user notes)
* output format
* where it is saved (notes, playbook drafts, etc.)
* guardrails (avoid financial advice wording; emphasize education)

### Content Pipeline Requirements

* Book content is stored as versioned markdown in a repo and deployed via SFTP.
* Define a file structure convention (e.g., `book/part-1/.../section-x.md`) with frontmatter fields.
* Provide an “Admin: Reindex Book” control that rebuilds the search index and updates the TOC after a deploy.
* Search is powered by vector search (QMD); specify how the UI integrates global search results (snippets + deep links).

### Design System Requirements (VERY IMPORTANT)

I want a consistent, modern UI with standardized inputs and controls. Provide:

* Recommended UI stack(s) and component libraries for **controls + inputs** (buttons, dropdowns, chips/tags, modals, toasts, tables, command palette, sidebar nav).
* A design token plan (typography scale, spacing, radii, shadows, color system).
* Accessibility requirements (keyboard nav, focus states, ARIA expectations).
* A “component inventory” list the app will standardize on.

I prefer pragmatic choices that a developer can implement quickly. Provide 1 recommended stack and 1 alternative stack.

### Login / Onboarding Requirements (Iconic + Hardened)

Design an “iconic” login/onboarding experience with security-minded UX:

* Clean landing → login → first-run onboarding
* First-run onboarding must set:

  * display name
  * notification channel (placeholder ok)
  * risk guardrails preferences (even if not used yet)
  * “learning goal” selector (maps into book sections)
* “Hardened” means: modern best-practice patterns (rate limiting, lockout UX, device/session handling, secure password reset, 2FA optional as later), but keep MVP implementable.
  Provide:
* Login screen layout description
* Onboarding steps
* Minimal auth model suggestion suitable for a personal deployment (no enterprise complexity)

### Deliverables (must be concrete, not vague)

1. **Information Architecture**

* top nav and sidebar nav trees
* route/URL scheme (deep-linkable to section headings)

2. **Wireframe-level page specs**
   For Library / Reader / Playbooks / Notes:

* layout structure
* components used
* key user actions
* empty states (must not feel empty)

3. **Component inventory + design system**

* recommended library stack(s)
* list of standardized components
* token guidance

4. **Data model (MongoDB)**
   Define collections and key fields for:

* users
* bookmarks
* highlights
* notes
* reading progress
* playbook drafts/published playbooks
* agent outputs history (optional)
  Include indexing considerations for search and speed.

5. **Agent skill contracts**
   For each skill:

* input context
* output schema
* save location
* UI rendering rules
* safety language guidelines

6. **Admin minimal spec**

* Reindex Book button + status display
* content ingest rules
* audit log minimal

7. **MVP build order**
   Give a “build sequence” that ships the Book experience fast, with placeholders for later.

### Output Format (strict)

* Executive summary
* IA + routing
* Page-by-page specs
* Component library + design system recommendation
* Data model
* Agent skills contracts
* Admin spec
* MVP build sequence
* Minimal open questions (at end only)
