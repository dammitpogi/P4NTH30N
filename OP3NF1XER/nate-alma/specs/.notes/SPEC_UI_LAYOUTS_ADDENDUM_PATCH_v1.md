---
title: UI Layouts Addendum Patch v1
kind: spec
status: proposed
owner: Nexus
last_updated: 2026-02-28
topics:
  - ui
  - layouts
  - patches
related:
  - SPEC_UI_LAYOUTS.md
  - SPEC_UI_CONSULTATION_02.md
---

## 0) Purpose

The Deep Research output in `Consultation_02.md` is highly actionable, but it contains a few **canon mismatches** and a few **shadcn naming mismatches**.

This patch document provides **drop-in corrections** so the addendum fully aligns with:
- `DECISION_UI_FOUNDATION.md`
- `SPEC_UI_LAYOUTS.md`
- `STYLE_GUIDE.md`
- `SPEC_ENDPOINT_CONTRACT.md`
- `SPEC_MONGO_SCHEMA.md`
- `SPEC_RAILWAY_ARCHITECTURE.md`

Use this as a “diff checklist” while implementing.

---

## 1) Canon mismatches to fix

### 1.1 Library (/book) must be a **single corpus** library, not “All Books / Add Book”
**Problem in Consultation_02:** Library is framed as a multi-book bookshelf with “All Books / Categories” and an “Add Book” CTA.

**Canon:** The product is a structured Book corpus with Parts → Chapters → Sections. Library should surface TOC + continue + part overview.

**Patch: Replace Library wireframe blocks**
- **Left rail:** TOC Tree (Parts → Chapters → Sections), not “All Books / Categories”.
- **Center:** Page header + Continue card + Part cards + Recently viewed (optional).
- **Right rail:** Today’s focus + Recent notes + Skill goal.

**Patch: Replace Library empty microcopy**
- Instead of: “No books in your library yet. Click Add Book…”
- Use: “No sections published yet.”  
  **Next action (admin only):** “Import/Publish content”.

**Why:** keeps Book-first governance and avoids unnecessary “multi-book” concepts.

---

### 1.2 Reader structured blocks must show **stubs when missing**
**Canon:** “If any block is missing, show a small ‘Coming soon’ stub (not empty whitespace).”

**Patch: Reader block behavior**
- TL;DR / Checklist / Mistakes / Drill:
  - If present: render as specified.
  - If missing: show a small stub card:
    - Title: “TL;DR (coming soon)”
    - Body: “This section’s summary will appear here.”

---

### 1.3 Onboarding must be 3–4 steps (not just “Get Started”)
**Canon:** Onboarding steps:
1) Display name
2) Notification channel (placeholder)
3) Learning goal (choose starting section)
4) Guardrails prefs (placeholder)

**Patch: Replace Onboarding page**
- Implement as a stepper (or tabs) with those 3–4 steps.
- Final step: “Open Library” CTA.

---

### 1.4 Design Tokens: remove serif headings
**Problem in Consultation_02:** “Serif for headings (Times New Roman)”.

**Canon:** Calm editorial “research UI” achieved with spacing + hierarchy; stick to a neo-grotesk (Inter) and 2 weights.

**Patch: Token change**
- Use **Inter** everywhere (or a single sans stack).
- Weights: 400 + 600 only.
- Editorial feel comes from:
  - tighter heading tracking (e.g., -0.02em)
  - relaxed body line height (1.65)
  - constrained measure (max 760px)

---

### 1.5 Endpoint alignment: playbook creation should use draft endpoint
**Canon endpoints:**
- `POST /api/playbooks/draft` to create a draft
- `PATCH /api/playbooks/:id` to edit
- `POST /api/playbooks/:id/publish` admin only

**Patch: Save-as-Playbook actions**
- Label as: “Save as Playbook Draft”
- Calls: `POST /api/playbooks/draft` (or PATCH existing draft)

---

## 2) shadcn naming / component reality check

Some components named in Consultation_02 are “conceptual”, not literal shadcn exports.

**Patch mappings**
- `<Navbar>` / `<Header>` → simple `<header className="...">` + shadcn `NavigationMenu` (optional)
- `<SidebarNav>` → a styled `<nav>` with `Button variant="ghost"` items
- `<Spinner>` → Lucide `Loader2` icon with `animate-spin`
- `<Pagination>` → shadcn patterns exist but often implemented as custom buttons
- `<Tree>` → implement via `Accordion` / collapsibles (Parts/Chapters) + links

This is fine—just don’t block implementation looking for a non-existent component.

---

## 3) Small UX improvements (optional, but consistent with canon)

### 3.1 Replace “Add Book” / “New Playbook” with “Generate from Section”
To reinforce Book-first:
- Keep “New Playbook” but de-emphasize it.
- Primary path: Scenario Tree skill → Save as Playbook Draft.

### 3.2 Playbook detail: avoid interactive “Start / Save Progress” for MVP
Unless you explicitly want a “run playbook” workflow, keep Playbook detail read-only-ish:
- Triggers
- Checklist
- Scenario tree
- Linked sections
- (Admin) publish/archive

---

## 4) Implementation checklist (apply before shipping)

- [ ] Library reflects TOC-first, not multi-book shelf.
- [ ] Remove “Add Book” UI; replace with admin-only “Import/Publish”.
- [ ] Reader always shows TL;DR/checklist/mistakes/drill blocks (or stubs).
- [ ] Onboarding is a 3–4 step wizard.
- [ ] Design tokens: one sans font; no serif headings.
- [ ] “Save as Playbook” renamed to “Save as Playbook Draft” and uses `/api/playbooks/draft`.
- [ ] Any named shadcn components that don’t exist are implemented as patterns.

---
