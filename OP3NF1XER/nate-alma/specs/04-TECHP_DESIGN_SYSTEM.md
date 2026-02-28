---
title: Design System Specification
kind: techp
status: accepted
owner: Nexus
last_updated: 2026-02-28
topics:
  - design
  - system
  - ui
related:
  - TECHP_STYLE_GUIDE.md
---

Below is a design ** (style direction + tokens + component standards) that matches: calm density, editorial, breathes” vibe—ideal for **Next.js/React + Tailwind + shadcn/ui** (and an alternative with Radix).

1. **Design system spec** (words your strategist/designer can use)
2. **Token table** (type scale, spacing, radii, shadows)
3. **Tailwind + shadcn setup snippets** (copy/paste)
4. **Component inventory + usage rules** (to keep the UI consistent)

---

## Design system: “Calm Research UI”

### Visual principles

* **Editorial first:** typography and rhythm carry the design.
* **Calm density:** lots of information, but never cramped.
* **Quiet chrome:** minimal borders, subtle surfaces, restrained accents.
* **Predictable layout:** stable columns + consistent rails.
* **One accent color:** used for focus, links, and active states—never neon.

### Layout rules

* **Max width container:** 1200–1280px for app shells; **reader column** constrained to ~680–760px for comfort.
* **Three-zone layout:** left TOC rail (260–300px), center content, right agent rail (320–380px).
* **Vertical rhythm:** headings introduce sections; avoid excessive dividers.

---

## Tokens

### Typography scale (Tailwind-friendly)

Use a tight set of sizes and weights. Two weights max: **400 (normal)** and **550–600 (semibold)**.

* Display / page title: `text-4xl` / `leading-[1.1]` / `tracking-[-0.02em]`
* H1: `text-3xl` / `leading-[1.15]`
* H2: `text-2xl` / `leading-[1.2]`
* H3: `text-xl` / `leading-[1.25]`
* Body: `text-base` / `leading-[1.65]`
* Small: `text-sm` / `leading-[1.6]`
* Meta: `text-xs` / `leading-[1.5]` / slightly muted color

**Paragraph spacing:** 12–16px between paragraphs (not marginless).

### Spacing scale

Base scale: `1, 2, 3, 4, 6, 8, 10, 12, 16` (Tailwind: 4px → 64px)

* “Micro”: 2–3 (8–12px) for compact UI elements
* “Standard”: 4–6 (16–24px) for cards, panels, forms
* “Section”: 8–12 (32–48px) for page blocks
* “Hero”: 16 (64px) for page headers

### Radii

* Default corners: `rounded-xl`
* Cards: `rounded-2xl`
* Inputs: `rounded-lg` or `rounded-xl`
* Chips: `rounded-full`

### Shadows (subtle, not “cardy”)

* Default: small soft shadow for floating elements (menus/modals)
* Cards: usually **no shadow**, rely on surface contrast; optional light shadow on hover only.

---

## Recommended stack (fast, consistent)

### Stack A (recommended)

* **Next.js + Tailwind**
* **shadcn/ui** (built on Radix primitives)
* **Lucide icons**
* Optional: **next-themes** if you want theme switching later

Why: you get consistent controls (inputs, dialogs, dropdowns, command palette) with minimal effort and high accessibility.

### Stack B (alternative)

* **Radix UI primitives** + Tailwind + your own component wrappers
  Why: maximum control, slightly more work.

---

## Copy/paste: Tailwind + shadcn-style tokens

### `globals.css` (tokens)

This gives you a calm dark theme (charcoal surfaces, soft text contrast, one accent). Tweak hue later.

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    /* If you later want a light theme, keep these too */
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
  }

  .dark {
    /* Calm charcoal background */
    --background: 222 14% 7%;
    --foreground: 210 40% 96%;

    /* Surfaces */
    --card: 222 14% 9%;
    --card-foreground: 210 40% 96%;
    --popover: 222 14% 9%;
    --popover-foreground: 210 40% 96%;

    /* One accent color (muted, not neon) */
    --primary: 210 40% 96%;
    --primary-foreground: 222 14% 7%;

    /* Muted text + subtle surfaces */
    --secondary: 222 14% 12%;
    --secondary-foreground: 210 25% 92%;

    --muted: 222 14% 12%;
    --muted-foreground: 215 15% 70%;

    /* Accent = links/focus/active states */
    --accent: 199 89% 48%;
    --accent-foreground: 222 14% 7%;

    /* Borders are quiet */
    --border: 222 14% 16%;
    --input: 222 14% 16%;
    --ring: 199 89% 48%;

    /* Danger, etc */
    --destructive: 0 70% 50%;
    --destructive-foreground: 210 40% 96%;

    --radius: 16px;
  }
}

@layer base {
  body {
    @apply bg-background text-foreground antialiased;
  }
}
```

### `tailwind.config.js` (typography + container feel)

```js
module.exports = {
  darkMode: ["class"],
  theme: {
    container: {
      center: true,
      padding: "24px",
      screens: {
        "2xl": "1280px",
      },
    },
    extend: {
      fontFamily: {
        // Use your preferred font(s). Inter is a solid default.
        sans: ["Inter", "ui-sans-serif", "system-ui", "sans-serif"],
      },
      letterSpacing: {
        tightish: "-0.02em",
      },
      lineHeight: {
        relaxed2: "1.65",
      },
      borderRadius: {
        lg: "12px",
        xl: "16px",
        "2xl": "24px",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
};
```

### Reader typography utility (optional but very useful)

If you render markdown, you’ll want a consistent “editorial” reader style. Use Tailwind Typography plugin.

```bash
npm i -D @tailwindcss/typography
```

Then in `tailwind.config.js`:

```js
plugins: [require("tailwindcss-animate"), require("@tailwindcss/typography")],
```

And in your Reader container:

* `prose prose-invert max-w-none`
* then constrain actual reading column width with a wrapper.

---

## Component inventory (standardize this list)

If you standardize these, your app will look coherent immediately:

### Navigation & layout

* AppShell (top nav + left rail + center + right rail)
* SidebarNav (TOC tree + collapsible groups)
* CommandPalette (global search / actions)
* Breadcrumbs (for Book location)

### Core controls

* Button (primary/secondary/ghost/link)
* Input
* Textarea
* Select
* Combobox (for tagging)
* Toggle / Switch
* Tabs
* Tooltip
* DropdownMenu
* Dialog (modal)
* Sheet (side panel)
* Toast / Sonner notifications

### Content UI

* Card (surface panels)
* Badge/Chip (tags)
* Separator (sparingly)
* Table (journal lists later)
* Accordion (playbook sections)
* Skeleton (loading)

### Editor/notes UI (book-first MVP)

* Highlight tool (selection → add note)
* Note composer (title, tags, body, link to anchor)
* Bookmark toggle

---

## Usage rules (these prevent “UI drift”)

* **No custom one-off buttons**: everything maps to Button variants.
* **One radius standard**: cards 2xl, inputs xl, chips full.
* **One accent color**: links + focus ring only.
* **No heavy borders**: use surface contrast first; borders only for inputs and subtle separators.
* **Avoid dense tables early**: use cards + filters until journal is mature.
* **Empty states must feel intentional**: include a short explanation + one action.

---

## The finishing touches

* Headings use slightly tighter tracking (e.g., `tracking-tightish`).
* Body uses relaxed line height (`leading-relaxed2`).
* Constrain reading text width (even on wide screens).
* Prefer **typography and spacing** over “more components.”
