---
title: Next.js Design System Checklist
kind: note
status: draft
last_updated: 2026-02-28
topics:
  - nextjs
  - design-system
  - implementation
---

Perfect — Next.js + this design system will get you to that “calm research UI” fast.

### What to do next (minimal, practical checklist)

#### 1) Pick the UI foundation

Use:

* **Tailwind CSS**
* **shadcn/ui** (Radix-based components)
* **Lucide** icons
* **@tailwindcss/typography** for the Reader

That combo is the fastest path to a consistent, “OpenAI-ish” feel.

#### 2) Lock the “Reader layout skeleton”

Make this your default app shell (so every page feels cohesive):

* **Left rail:** TOC (Part → Chapter → Section)
* **Center:** prose reader (constrained width)
* **Right rail:** agent panel (skills/actions)

This layout alone creates the “full but breathable” feeling.

#### 3) Standardize the component set (no one-off UI)

At minimum:

* Button, Input, Textarea, Select/Combobox
* Tabs, Dialog, Dropdown, Tooltip, Toast
* Card, Badge/Chip, Separator (sparingly)
* Command palette (for search + actions)
* “Prose” style for markdown

If you enforce these, your UI will stay consistent even as you iterate via SFTP deployments.