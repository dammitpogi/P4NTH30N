---
title: UI Layouts Specification
kind: spec
status: accepted
owner: Nexus
last_updated: 2026-02-28
topics:
  - ui
  - layouts
  - wireframes
---

## 0) Purpose

This document defines the **wireframe-level UI layouts** and **component composition** for the Book-first MVP.

It is intentionally concrete:
- fixed layout constraints
- page structure
- required components
- required states (loading/empty/error)
- microcopy guidelines
- interaction patterns for highlights/notes and agent outputs

This doc should be treated as canonical unless superseded by a new decision.

---

## 1) Global layout system

### 1.1 App Shell (authenticated)
**Applies to:** all `(app)` routes (Book/Playbooks/Notes/Admin).

**Structure**
- Top app bar (sticky)
- Main 3-column grid
  - Left rail (nav)
  - Center (content)
  - Right rail (context panel: agent or page tools)

**Constraints (defaults)**
- Container: `max-w-[1280px] mx-auto px-6`
- Left rail width: `w-[280px]`
- Right rail width: `w-[360px]`
- Center content max width: `max-w-[760px]` (reader); `max-w-[900px]` (lists)
- Scroll model: left/center/right each scroll independently via `ScrollArea`
- Top bar: sticky, 56–64px height

**shadcn components**
- `NavigationMenu` or custom top nav
- `ScrollArea` for each column
- `Separator` sparingly
- `CommandDialog` (global actions/search)
- `DropdownMenu` (profile/actions)
- `Button`, `Badge`, `Tooltip`, `Sheet` (mobile)

**Global actions**
- `⌘K / Ctrl+K` opens Command Dialog:
  - Search book
  - Jump to section
  - Create note
  - Open playbooks
  - Admin: reindex (admin only)

---

## 2) Layout A: Book Shell (Library + Reader)

### 2.1 Left rail: TOC Tree
**Purpose:** stable navigation; reinforces “book-first.”

**Components**
- Header: “Book” + small “Search” hint
- TOC tree:
  - Part (collapsible)
  - Chapter (collapsible)
  - Section links (with progress indicator)
- Footer: bookmarks shortcut; “Continue reading”

**shadcn**
- `Accordion` (Parts/Chapters) OR custom collapsible tree
- `Button` (ghost) for items
- `Badge` (optional: “New”)
- `Progress` (small bar per section or per chapter)
- `Input` (optional TOC filter)

**States**
- Loading: skeleton tree
- Empty: “No sections published yet.” + CTA “Import/Publish content” (admin)
- Error: “TOC failed to load.” + CTA “Retry”

### 2.2 Page: Library (Book Index)
**Route:** `/book`

**Goal:** feels full even with minimal content.

**Center column blocks**
1) Page header
- Title: “Library”
- Subtitle (muted): “Your curriculum and playbooks.”

2) Continue card (if progress exists)
- “Continue: {Section Title}”
- Progress percent
- CTA: “Resume”

3) Part list
- Each Part rendered as a Card:
  - Part title + short description
  - Chapter list (compact)
  - CTA: “Open Part”

4) Recently viewed (optional)
- small list of last 5 sections

**Right rail blocks**
- “Today’s focus” card (1–3 section links)
- “Recent notes” (latest 3 notes)
- “Skill goal” (onboarding selection)

**shadcn**
- `Card`, `CardHeader`, `CardContent`
- `Button` variants (primary, ghost, link)
- `Badge` for tags
- `Skeleton` for loading

**Empty states**
- No progress: show “Start here” card linking to Part I / Ch 1 / Sec 1
- No notes: “No notes yet.” + “Add a note while reading.”

### 2.3 Page: Reader (Section View)
**Route:** `/book/[...slug]`

**Center column structure**
1) Breadcrumbs (Part / Chapter / Section)
2) Section title + lead paragraph (optional)
3) Structured blocks (render when present; otherwise show minimal stubs)
   - TL;DR (≤3 bullets)
   - Checklist (≤5)
   - Common mistakes (≤3)
   - Drill (1 exercise)
4) Prose body (markdown rendered)
5) Footer navigation:
   - Previous / Next section

**Right rail: Agent Panel**
- Sticky panel header: “Assistant”
- Skill buttons:
  - Explain (simple/technical/analogy)
  - Socratic Tutor
  - Flashcards
  - Checklist builder
  - Scenario tree → Playbook draft
  - Notes assistant
- Output area: last run result(s)
- Save actions: Copy, Save as Note, Save as Playbook Draft (when applicable)

**shadcn**
- `Breadcrumb`
- `Card` for structured blocks
- `Tabs` (optional for “Simple/Technical/Analogy”)
- `Button`, `ToggleGroup`, `DropdownMenu`
- `Textarea` (notes)
- `Toast` (save confirmations)
- `ScrollArea` (agent output history)
- `Dialog` (flashcards preview)
- `Separator` minimal

**Reader typography**
- Use `prose prose-invert` + custom tweaks:
  - Body: `text-base leading-[1.65]`
  - Headings: clear hierarchy; anchor links on hover
  - Lists: slightly increased spacing
  - Links: accent color; underline on hover

**States**
- Loading: skeleton title + blocks + prose
- Error: “Section failed to load.” + Retry + Back to Library
- Empty body: show structured blocks only + “Body coming soon.”

---

## 3) Layout B: Notes

### 3.1 Page: Notes
**Route:** `/notes`

**Center structure**
- Header: “Notes”
- Filters row:
  - Search notes
  - Tag chips
  - Section filter (optional)
- Notes list:
  - Each note card shows:
    - title/first line
    - tags
    - link back to section + anchor
    - updated timestamp
- Note detail drawer (optional):
  - opens in right rail or modal

**Right rail**
- “Recent highlights”
- “Top tags”
- “Backlinks” (notes pointing to same concept)

**shadcn**
- `Input`, `Badge`, `Popover` (tag filter)
- `Card`, `Button`
- `Sheet` or `Dialog` for detail on small screens

**Empty state**
- “No notes yet.”  
  CTA: “Open the book and highlight text to create your first note.”

---

## 4) Layout C: Playbooks

### 4.1 Page: Playbooks list
**Route:** `/playbooks`

**Center**
- Header: “Playbooks”
- Tabs: Draft / Published
- Playbook cards:
  - title
  - trigger summary (1–2 lines)
  - linked sections count
  - status badge

**Right rail**
- “Create playbook draft” (admin-only)
- “Recently updated”

**shadcn**
- `Tabs`, `Card`, `Badge`, `Button`

**Empty state**
- Drafts empty: “No drafts yet.” CTA: “Generate a draft from a section using Scenario Tree.”
- Published empty: “No playbooks published yet.” CTA: “Publish a draft.”

### 4.2 Page: Playbook detail
**Route:** `/playbooks/[id]`

**Center**
- Title + status
- Sections:
  - Triggers
  - Checklist
  - Scenario tree
  - Linked sections (click to open reader)
- Actions:
  - Edit (draft)
  - Publish (admin)
  - Archive (admin)

**Right rail**
- “Open linked section”
- “Create note from playbook”
- “Related playbooks” (optional)

**shadcn**
- `Card`, `Accordion` (sections)
- `Button`, `Dialog` (confirm publish/archive)
- `Separator` minimal

---

## 5) Layout D: Admin (minimal)

### 5.1 Page: Admin status
**Route:** `/admin`

**Center**
- Header: “Admin”
- System status cards:
  - Book: last publish/import, last reindex
  - Search: QMD health
  - Agent: OpenClaw health
- Actions:
  - Reindex Book (primary)
  - Publish drafts (if enabled)

**Right rail**
- “Last errors”
- “Audit log (recent)”

**No silent failure compliance**
- Every job shows:
  - current state
  - last run time
  - error details
  - retry

**shadcn**
- `Card`, `Button`, `Alert`, `Table` (audit log)
- `Toast` for job started/succeeded/failed

---

## 6) Layout E: Public / Login / Onboarding

### 6.1 Login
**Route:** `/login`

**Design goals**
- Iconic but minimal.
- Calm, editorial.
- Security-minded UX.

**Center**
- Brand mark + short description
- Login form card:
  - email
  - password or code
  - submit
- Secondary links:
  - “Forgot password”
  - “Need an invite?” (optional)

**Security UX**
- Rate limit messaging: “Too many attempts. Try again in X minutes.”
- Generic error: “Login failed.” (avoid account enumeration)

**shadcn**
- `Card`, `Input`, `Button`, `Alert` (error)
- Optional `OTPInput` style component (custom)

### 6.2 Onboarding
**Route:** `/onboarding`

**Steps (3–4)**
1) Display name
2) Notification channel (placeholder)
3) Learning goal (choose a starting section)
4) Guardrails prefs (placeholder)

**shadcn**
- `Stepper` pattern (custom) or `Tabs`
- `Input`, `Select`, `Button`
- Success page: “You’re set.” → “Open Library”

---

## 7) Interaction specs (minimum)

### 7.1 Highlighting + note attachment
**Flow**
- User selects text in Reader → floating toolbar appears:
  - Highlight
  - Add note
  - Copy
- Highlight creates `highlights` doc.
- Add note creates `notes` doc and links highlight via `noteId`.

**States**
- Saving… (disable buttons)
- Saved → Toast “Saved”
- Error → Toast “Failed. Retry” + keep selection text available

### 7.2 Agent output saving
Every agent output block includes:
- Copy
- Save as Note
- Save as Playbook Draft (when output type is checklist/tree)

### 7.3 “No empty pages”
Every empty state includes:
- short explanation
- a single CTA

---

## 8) Keyboard shortcuts (MVP)
- `⌘K / Ctrl+K`: Command palette
- `n`: New note (in Reader)
- `b`: Toggle bookmark (in Reader)
- `?`: Shortcut help (optional)

---

## 9) Definition of Done (UI layouts)
A page is “layout-complete” when:
- component composition is implemented
- loading/error/empty states exist
- primary action works (even if backend is stubbed)
- microcopy is present and calm (no shouting UI)
