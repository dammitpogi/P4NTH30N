---
title: Visual Style Direction
kind: note
status: draft
last_updated: 2026-02-28
topics:
  - design
  - style
  - ui
---

The OpenAI site feel is basically:

* **editorial typography**
* **generous but disciplined spacing**
* **high contrast without harshness**
* **quiet UI chrome**
* **big type + restrained components**
* **rhythmic vertical layout** (everything aligns and breathes)

Here’s a **small visual style direction section** you can drop straight into your Deep Research prompt or design doc.

---

## Visual style direction

### Overall vibe

Modern, calm, “trading-adjacent” (serious, analytical) but **not gamer**. The interface should feel like a **premium research journal**: confident typography, high clarity, minimal decoration, and subtle depth. Every page should feel “full” because of **structure and rhythm**, not because it’s crowded.

### Typography

* **Type personality:** contemporary grotesk / neo-grotesk with an editorial feel (clean, neutral, slightly warm).
* **Hierarchy:** big headlines, restrained body, small labels; few weights (regular + medium/semibold).
* **Readable measure:** keep text blocks to ~**65–80 characters per line** for comfort.
* **Line height:** body text slightly generous (around **1.55–1.7**) to create air without looking sparse.
* **Paragraph rhythm:** use consistent paragraph spacing instead of heavy rules/dividers.
* **Alignment:** primarily **left-aligned** body for readability; if you like the “justified” look, mimic it with a **tight measure + balanced rag** (not true justification, which can create awkward spacing).

### Layout + spacing (the “breathing but not far away” feeling)

* **Grid:** 12-column mental model; keep content on a centered container.
* **Max width:** constrain main reading content (ex: ~960–1100px container, but the *text* column is narrower).
* **Three-zone layout:**

  * left rail (nav/TOC),
  * center (content),
  * right rail (agent/tools).
    Even if rails are empty sometimes, the center column stays stable so it still feels intentional.
* **Spacing system:** use a consistent scale (ex: 4/8/12/16/24/32/48/64). The “OpenAI feel” comes from *consistent* vertical rhythm more than huge whitespace.
* **Sectioning:** prefer **typographic separation** (spacing + subtle headings) over boxes and borders.

### Color and contrast (dark, calm, not neon)

* **Background:** near-black / charcoal (not pure black).
* **Surfaces:** slightly lighter charcoal layers for panels and cards (very subtle elevation).
* **Text:** off-white for primary, muted gray for secondary, low-contrast gray for metadata.
* **Accent:** one restrained accent color (cool teal, slate-blue, or muted green) used sparingly for:

  * active states
  * links
  * small indicators
    Not used for big fills; no neon gradients.

### Components (quiet, premium)

* **Buttons:** minimal, rounded (but not bubbly), clear hover/focus states. Primary button should be solid but not loud.
* **Inputs:** calm borders, strong focus ring, good placeholder contrast. Inputs should feel “systematic” and consistent everywhere.
* **Cards:** use subtle surface contrast; avoid heavy outlines.
* **Dividers:** thin + low-contrast, used sparingly.
* **Icons:** simple line icons; don’t overuse.
* **Tables:** clean, high readability; zebra striping only if needed.

### Motion (subtle, purposeful)

* Short fades and gentle slide transitions (150–220ms). Motion should signal state changes, not entertain.

### Trading-adjacent cues (without being a “trading app”)

* Use **language and structure** (Today / Alerts / Review / Playbooks) to imply trading context rather than bright colors or chart-heavy chrome.
* Charts (when added) should look like “analysis tools,” not a brokerage dashboard: muted gridlines, minimal saturation, readable labels.

---

## Words you can use to describe what you like about OpenAI’s site

If you want a quick vocabulary list:

* **editorial** / **research-grade**
* **high-contrast minimalism**
* **soft hierarchy**
* **disciplined spacing**
* **quiet UI**
* **typographic rhythm**
* **calm density**
* **structured breathing room**
* **subtle depth** (not flat, not skeuomorphic)

---

## “Controls and inputs” libraries to standardize the look

Since you asked for this specifically, here are two very common, very effective paths:

1. **Tailwind + shadcn/ui**

* Extremely consistent components, easy to theme with tokens.
* Great for the “quiet, premium” look.

2. **Radix UI primitives + your styling system (Tailwind or CSS variables)**

* Radix gives accessible behavior; you design the look.
* Slightly more work, maximum control.