---
title: Style Guide
kind: techp
status: accepted
owner: Nexus
last_updated: 2026-02-28
topics:
  - design
  - style
  - ui
related:
  - TECHP_DESIGN_SYSTEM.md
---

# STYLE_GUIDE

**Status:** Accepted (MVP baseline)  
**Owner:** Nexus  
**Audience:** Pyxis (Strategist), Implementers  
**Last updated:** 2026-02-28

## 0) Purpose

This document defines the visual design direction and UI consistency rules for the project.

Target vibe: **modern, calm, editorial "research UI"** (OpenAI-like) with disciplined spacing and typography.  
Not a "trading gamer" aesthetic. No neon. No loud gradients. No busy chrome.

---

## 1) Visual principles (non-negotiable)

1) **Editorial first**  
   Typography and layout rhythm carry the UI.

2) **Calm density**  
   Pages can contain a lot, but never feel cramped. "Full but breathable."

3) **Quiet chrome**  
   Minimal borders. Subtle surfaces. Dividers used sparingly.

4) **One accent**  
   One restrained accent color used for focus, links, and active states only.

5) **Consistency > decoration**  
   Standard components everywhere. Avoid one-off UI elements.

---

## 2) Typography

### 2.1 Font
- Preferred: neutral neo-grotesk (e.g., Inter or similar system font stack).
- Use 2 weights max: **Regular** and **Semibold**.

### 2.2 Scale and hierarchy (Tailwind-friendly)
- Display / Page title: `text-4xl leading-[1.1] tracking-[-0.02em]`
- H1: `text-3xl leading-[1.15]`
- H2: `text-2xl leading-[1.2]`
- H3: `text-xl leading-[1.25]`
- Body: `text-base leading-[1.65]`
- Small: `text-sm leading-[1.6]`
- Meta: `text-xs leading-[1.5]` (muted)

### 2.3 Text measure
- Reader center column measure should be ~**65–80 characters** per line.
- Constrain reader text block to ~**680–760px**.

### 2.4 Paragraph rhythm
- Prefer paragraph spacing over heavy dividers.
- Default: 12–16px between paragraphs.

---

## 3) Layout, spacing, and rhythm

### 3.1 Container and columns (defaults)
- Container: `max-w-[1280px] mx-auto px-6`
- Left rail (TOC): `w-[280px]`
- Right rail (agent/tools): `w-[360px]`
- Reader center: `max-w-[760px] mx-auto`

### 3.2 Spacing scale
Use a consistent scale:
- 8, 12, 16, 24, 32, 48, 64px (Tailwind: 2,3,4,6,8,12,16)

Guidance:
- "Micro": 8–12px (chips, icon buttons, tight lists)
- "Standard": 16–24px (forms, cards, panels)
- "Section": 32–48px (page blocks)
- "Hero": 64px (page headers)

### 3.3 Dividers and borders
- Avoid heavy borders.
- Use `Separator` sparingly.
- Inputs may have subtle borders; other surfaces should rely on contrast.

---

## 4) Color system (dark theme baseline)

### 4.1 Palette philosophy
- Background: near-black charcoal (not pure black)
- Surfaces: slightly lighter charcoal layers
- Text: off-white + muted grays
- Accent: restrained (cool teal/slate-blue)

### 4.2 Token approach (CSS vars for shadcn)
Use HSL CSS variables (`globals.css`) for:
- `--background`, `--foreground`
- `--card`, `--muted`, `--border`, `--ring`
- `--accent` used for links/focus/active

Constraints:
- Accent is not used for large fills.
- Avoid multiple competing accent colors.

---

## 5) Components: shape, shadows, interaction

### 5.1 Corners (radii)
- Inputs: `rounded-lg` or `rounded-xl`
- Cards: `rounded-2xl`
- Chips: `rounded-full`

### 5.2 Shadows
- Prefer no shadow on cards (use surface contrast).
- Use soft shadow only for floating layers (menus, dialogs).
- Hover shadows are allowed but subtle.

### 5.3 Buttons
- Primary: solid, calm, not loud.
- Secondary/ghost: minimal.
- Link buttons: used for inline actions.

### 5.4 Inputs
- Calm border.
- Clear focus ring (`--ring`).
- Strong placeholder contrast (but muted).

### 5.5 Tables
- Minimal gridlines.
- Use zebra striping only if readability needs it.
- Default to cards/lists early; tables later for dense journal.

---

## 6) Reader typography (markdown / MDX)

### 6.1 Base
Use Tailwind Typography:
- `prose prose-invert max-w-none`

Then constrain with a wrapper:
- `max-w-[760px] mx-auto`

### 6.2 Headings
- Provide anchor links on hover.
- Avoid huge jumps between levels.

### 6.3 Lists
- Slightly increased spacing.
- List markers should be muted.

### 6.4 Links
- Accent color for links.
- Underline on hover.

### 6.5 Callouts / blocks
Structured blocks (TL;DR, Checklist, Mistakes, Drill) should be cards with:
- strong heading
- short bullet lists
- consistent spacing and icon usage

---

## 7) Motion

- Subtle fades and gentle slide transitions only.
- Duration: ~150–220ms.
- Motion indicates state changes (save success, panel open), not "fun".

---

## 8) Accessibility baseline

- Full keyboard navigation (Tab order logical and visible).
- Visible focus states (no removing outlines).
- ARIA labels for icon buttons.
- Sufficient contrast for text and muted UI.

---

## 9) Anti-patterns (do not do)

- Neon colors, heavy gradients, glow effects
- Excessive borders and boxes
- Dense dashboards early (Book-first MVP)
- Mixed component styles (stick to shadcn)
- True justification for long body text (can create uneven spacing). Prefer constrained measure + balanced rag.

---

## 10) Quick reference: "OpenAI-ish" vocabulary

Use these words in specs:
- editorial, research-grade
- calm density
- disciplined spacing
- quiet chrome
- typographic rhythm
- subtle depth
