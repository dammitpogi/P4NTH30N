---
title: MongoDB Schema v0 (Superseded)
kind: spec
status: superseded
owner: Nexus
last_updated: 2026-02-28
topics:
  - mongodb
  - schema
  - database
---

Love it. If you want to lock this in so it’s immediately usable, here’s the **MongoDB schema mapping** that matches the endpoint contract (collections + key fields + indexes) — pasteable into your spec.

---

## MongoDB schema mapping

### 1) `users`

**Purpose:** identity, roles, onboarding prefs

**Fields**

* `_id`
* `email` (unique)
* `name`
* `role` (`admin` | `user`)
* `createdAt`, `updatedAt`, `lastLoginAt`
* `prefs`

  * `learningGoal` (e.g., `{ partSlug, chapterSlug, sectionSlug }`)
  * `notificationChannel` (placeholder: `{ type, value }`)
  * `riskGuardrails` (placeholder: `{ maxTradesPerDay, maxLossPerDay, cooldownMinutes }`)

**Indexes**

* `{ email: 1 }` unique
* `{ role: 1 }`

---

### 2) `book_sections`

**Purpose:** source-of-truth content for Reader

**Fields**

* `_id`
* `slug` (canonical section slug, e.g. `part-1-foundations/ch-1/01-gamma-basics`)
* `part` `{ index, slug, title }`
* `chapter` `{ index, slug, title }`
* `section` `{ index, slug, title }`
* `bodyMarkdown` (string)
* `frontmatter`

  * `summary[]`
  * `checklist[]`
  * `mistakes[]`
  * `drill` `{ prompt, answerKey? }`
  * `tags[]`
  * `playbooks[]` (ids or slugs)
* `headings[]` optional: `{ id, text, level }`
* `status` (`draft` | `review` | `published`)
* `version` (int or semver string)
* `publishedAt`, `updatedAt`, `createdAt`

**Indexes**

* `{ slug: 1, version: -1 }` unique (or slug unique if you only keep latest)
* `{ status: 1, "part.index": 1, "chapter.index": 1, "section.index": 1 }`
* Optional text index for fallback search:

  * `{ bodyMarkdown: "text", "section.title": "text" }`

---

### 3) `book_toc`

**Purpose:** cached TOC tree + display labels (optional but fast)

**Fields**

* `_id` (single doc like `"default"`)
* `tree` (Parts → Chapters → Sections)
* `updatedAt`
* `publishedVersion` (optional)

**Indexes**

* none required

---

### 4) `notes`

**Purpose:** user notes attached to a section or anchor

**Fields**

* `_id`
* `userId`
* `sectionSlug`
* `anchorId` optional
* `selection` optional: `{ text, startOffset?, endOffset? }`
* `title` optional
* `body` (note text)
* `tags[]`
* `createdAt`, `updatedAt`

**Indexes**

* `{ userId: 1, sectionSlug: 1, updatedAt: -1 }`
* `{ userId: 1, tags: 1 }`

---

### 5) `highlights`

**Purpose:** saved highlights in Reader

**Fields**

* `_id`
* `userId`
* `sectionSlug`
* `anchorId` optional
* `range` optional: `{ startOffset, endOffset }` (or store exact text only)
* `text` (captured highlighted text)
* `color` optional (or style enum)
* `noteId` optional (link highlight → note)
* `createdAt`

**Indexes**

* `{ userId: 1, sectionSlug: 1, createdAt: -1 }`

---

### 6) `bookmarks`

**Purpose:** quick save points (section or heading)

**Fields**

* `_id`
* `userId`
* `sectionSlug`
* `anchorId` optional
* `createdAt`

**Indexes**

* `{ userId: 1, sectionSlug: 1, anchorId: 1 }` unique

---

### 7) `reading_progress`

**Purpose:** “Continue” + progress bars

**Fields**

* `_id`
* `userId`
* `sectionSlug`
* `percent` (0–100)
* `lastAnchorId` optional
* `updatedAt`

**Indexes**

* `{ userId: 1, updatedAt: -1 }`
* `{ userId: 1, sectionSlug: 1 }` unique

---

### 8) `playbooks`

**Purpose:** playbook drafts + published playbooks

**Fields**

* `_id`
* `status` (`draft` | `published` | `archived`)
* `title`
* `triggers[]` (strings)
* `checklist[]`
* `scenarioTree` (string or structured JSON)
* `linkedSections[]` (section slugs)
* `createdBy` (userId)
* `createdAt`, `updatedAt`, `publishedAt`
* `tags[]` optional

**Indexes**

* `{ status: 1, updatedAt: -1 }`
* `{ linkedSections: 1 }`
* `{ createdBy: 1, status: 1 }`

---

### 9) `agent_runs` (optional but valuable)

**Purpose:** audit + “what did the agent output?”

**Fields**

* `_id`
* `userId`
* `skill` (`explain|socratic|flashcards|checklist|scenario_tree|notes_assist`)
* `context` `{ sectionSlug, anchorId?, selectedText? }`
* `output` (structured)
* `createdAt`
* `savedTo` optional: `{ noteId?, playbookId? }`

**Indexes**

* `{ userId: 1, createdAt: -1 }`
* `{ skill: 1, createdAt: -1 }`

---

### 10) `audit_log` (admin actions)

**Purpose:** track reindex, publish, config changes

**Fields**

* `_id`
* `actorUserId`
* `action` (`book_import|book_publish|reindex|config_change|login_fail|...`)
* `details` (object)
* `createdAt`

**Indexes**

* `{ createdAt: -1 }`
* `{ actorUserId: 1, createdAt: -1 }`

---

title: MongoDB Schema v0 (Superseded)
kind: spec
status: superseded
owner: Nexus
last_updated: 2026-02-28
topics:
  - mongodb
  - schema
  - database

Got it — **MongoDB-backed book content over a Tailscale connection** is a totally workable "code-first" approach, and it pairs nicely with App Router **if you design for caching + reindex + offline fallback**.

Here's the cleanest way to think about it.produce a **single “spec page”** you can hand to your strategist: endpoint contract + schema + UI page list + MVP build order, all in one place.
