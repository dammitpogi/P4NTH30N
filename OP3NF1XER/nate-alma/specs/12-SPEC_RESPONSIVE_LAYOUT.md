# SPEC_RESPONSIVE_LAYOUT

**Status:** Accepted (addresses DECISION_172 “Must Address #1”)  
**Owner:** Nexus  
**Audience:** Pyxis (Strategist), Implementers  
**Last updated:** 2026-02-28

## 0) Purpose

Define responsive behavior for the Book-first MVP **without breaking the sacred 3-column shell** concept.

The desktop ideal remains:
- **Left:** TOC
- **Center:** Reader
- **Right:** Agent

But at common laptop widths (e.g., 1366px), we must avoid overflow and preserve comfort.

---

## 1) Breakpoints (Tailwind)

Use Tailwind defaults:
- `sm` 640
- `md` 768
- `lg` 1024
- `xl` 1280
- `2xl` 1536

---

## 2) Core layout modes

### Mode A — Three-column (2xl and up)
**Applies:** `2xl` (≥1536)

- Container: `max-w-[1280px] mx-auto px-6`
- Grid: `grid-cols-[280px_minmax(0,760px)_360px] gap-6`
- Left rail: visible (TOC)
- Right rail: visible (Agent)
- Independent scroll: left/center/right via `ScrollArea`

**Goal:** the “full but breathable” ideal.

---

### Mode B — Two-column + Agent Drawer (xl to <2xl)
**Applies:** `xl` (≥1280 and <1536) including 1366px laptops

- Container: `max-w-[1200px] mx-auto px-6`
- Grid: `grid-cols-[280px_minmax(0,1fr)] gap-6`
- Left rail: visible (TOC)
- Right rail: **hidden** as a **Sheet** (drawer) opened by an “Assistant” button in the top bar

**Agent access pattern**
- Top bar right side: `Button variant="secondary"` labeled **Assistant**
- Opens `Sheet` on the right containing the Agent panel (same UI as desktop)
- Sheet supports:
  - close (Esc)
  - persisted last open tab/skill

**Why:** avoids 280+760+360 = 1400+px layouts that exceed common screens.

---

### Mode C — Single column + TOC Drawer + Agent Drawer (lg to <xl)
**Applies:** `lg` (≥1024 and <1280)

- Container: `max-w-[900px] mx-auto px-4`
- Center content only
- Left rail becomes a **TOC Sheet** opened by a **Contents** button
- Right rail remains an **Assistant Sheet**

**Buttons**
- Left: **Contents**
- Right: **Assistant**

**Scroll:** single scroll container for content.

---

### Mode D — Mobile (below lg)
**Applies:** <1024

- Single column
- TOC opens as full-height `Sheet` from left
- Agent opens as full-height `Sheet` from right
- Reader typography remains constrained and readable

---

## 3) Page-specific notes

### Library (/book)
- Mode B+: TOC visible (desktop), Assistant in drawer for xl
- Mode C/D: TOC in drawer; “Today’s focus” moves into center as a card near top

### Reader (/book/[...slug])
- Mode B: center content + TOC; Agent in drawer
- Ensure section blocks (TL;DR, Checklist, Mistakes, Drill) remain above fold when possible

### Notes / Playbooks / Admin
- Same rails behavior as Mode B/C/D
- Right rail becomes “Tools” rail for those pages (or hidden unless needed)

---

## 4) Implementation checklist

- [ ] Add “Contents” and “Assistant” buttons to TopBar for lg and down
- [ ] Hide Agent rail at `xl` and below; replace with `Sheet`
- [ ] Keep TOC rail visible only at `xl` and above; otherwise `Sheet`
- [ ] Ensure no horizontal scroll at 1366px with browser chrome
- [ ] Preserve keyboard shortcuts: `⌘K` opens Command palette regardless of mode
