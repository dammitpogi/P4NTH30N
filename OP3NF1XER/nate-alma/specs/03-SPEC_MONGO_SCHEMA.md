---
title: MongoDB Schema Specification
kind: spec
status: accepted
owner: Nexus
last_updated: 2026-02-28
topics:
  - mongodb
  - schema
  - database
---

## 0) Purpose

This document specifies the MongoDB data model for the **Book-first MVP**:
- Book content (sections + TOC)
- Notes, highlights, bookmarks, reading progress
- Playbooks (draft → published)
- Optional agent run history
- Audit log for admin and agent actions

This schema is designed to support:
- Next.js App Router UI
- shadcn/ui UX patterns
- QMD semantic search integration
- Internal-only MongoDB access (browser never connects directly)

---

## 1) Conventions

### 1.1 IDs and timestamps
- Use MongoDB ObjectIds for `_id`.
- Store timestamps as ISO dates: `createdAt`, `updatedAt`, etc.

### 1.2 Slugs
- `sectionSlug` is the canonical identifier for a section:
  - Example: `part-1-foundations/ch-1/01-gamma-basics`
- `anchorId` identifies a heading within a section and is used for deep links.

### 1.3 Draft vs published
- The MVP may start with published-only sections.
- If drafts are enabled, use `status` and (optional) `version`.

---

## 2) Collections

## 2.1 users
**Purpose:** identity, roles, onboarding preferences

**Document shape**
```json
{
  "_id": "ObjectId",
  "email": "string",
  "name": "string",
  "role": "admin|user",
  "prefs": {
    "learningGoal": { "sectionSlug": "string" },
    "notificationChannel": { "type": "string", "value": "string" },
    "riskGuardrails": { "maxTradesPerDay": 0, "maxLossPerDay": 0, "cooldownMinutes": 0 }
  },
  "createdAt": "date",
  "updatedAt": "date",
  "lastLoginAt": "date"
}
```

**Indexes**
- Unique: `{ email: 1 }`
- `{ role: 1 }`

---

## 2.2 book_sections
**Purpose:** canonical book content for Reader

**Document shape**
```json
{
  "_id": "ObjectId",
  "slug": "string",
  "part": { "index": 1, "slug": "string", "title": "string" },
  "chapter": { "index": 1, "slug": "string", "title": "string" },
  "section": { "index": 1, "slug": "string", "title": "string" },

  "bodyMarkdown": "string",
  "frontmatter": {
    "summary": ["string"],
    "checklist": ["string"],
    "mistakes": ["string"],
    "drill": { "prompt": "string", "answerKey": "string" },
    "tags": ["string"],
    "playbooks": ["string"]
  },

  "headings": [
    { "id": "string", "text": "string", "level": 2 }
  ],

  "status": "draft|review|published",
  "version": 1,

  "createdAt": "date",
  "updatedAt": "date",
  "publishedAt": "date"
}
```

**Indexes**
- If versioned:
  - Unique: `{ slug: 1, version: -1 }`
- If unversioned:
  - Unique: `{ slug: 1 }`
- Sort/index for TOC rendering:
  - `{ status: 1, "part.index": 1, "chapter.index": 1, "section.index": 1 }`
- Optional fallback search:
  - Text index on `bodyMarkdown` and titles (not required if QMD is primary)

**Notes**
- Keep `headings` updated at import time to support anchor nav without re-parsing on every request.

---

## 2.3 book_toc (optional but recommended)
**Purpose:** cached TOC tree for fast Library rendering

**Document shape**
```json
{
  "_id": "default",
  "tree": {},
  "publishedVersion": 1,
  "updatedAt": "date"
}
```

**Indexes**
- None

---

## 2.4 notes
**Purpose:** user notes linked to sections and anchors

**Document shape**
```json
{
  "_id": "ObjectId",
  "userId": "ObjectId",
  "sectionSlug": "string",
  "anchorId": "string",
  "selection": { "text": "string", "startOffset": 0, "endOffset": 0 },
  "title": "string",
  "body": "string",
  "tags": ["string"],
  "createdAt": "date",
  "updatedAt": "date"
}
```

**Indexes**
- `{ userId: 1, sectionSlug: 1, updatedAt: -1 }`
- `{ userId: 1, tags: 1 }`

---

## 2.5 highlights
**Purpose:** text highlights in Reader

**Document shape**
```json
{
  "_id": "ObjectId",
  "userId": "ObjectId",
  "sectionSlug": "string",
  "anchorId": "string",
  "range": { "startOffset": 0, "endOffset": 0 },
  "text": "string",
  "color": "string",
  "noteId": "ObjectId",
  "createdAt": "date"
}
```

**Indexes**
- `{ userId: 1, sectionSlug: 1, createdAt: -1 }`
- Optional: `{ noteId: 1 }`

---

## 2.6 bookmarks
**Purpose:** quick save points in the book

**Document shape**
```json
{
  "_id": "ObjectId",
  "userId": "ObjectId",
  "sectionSlug": "string",
  "anchorId": "string",
  "createdAt": "date"
}
```

**Indexes**
- Unique: `{ userId: 1, sectionSlug: 1, anchorId: 1 }`

---

## 2.7 reading_progress
**Purpose:** “Continue” and progress bars

**Document shape**
```json
{
  "_id": "ObjectId",
  "userId": "ObjectId",
  "sectionSlug": "string",
  "percent": 0,
  "lastAnchorId": "string",
  "updatedAt": "date"
}
```

**Indexes**
- Unique: `{ userId: 1, sectionSlug: 1 }`
- `{ userId: 1, updatedAt: -1 }`

---

## 2.8 playbooks
**Purpose:** playbook drafts + published playbooks

**Document shape**
```json
{
  "_id": "ObjectId",
  "status": "draft|published|archived",
  "title": "string",
  "triggers": ["string"],
  "checklist": ["string"],
  "scenarioTree": "string",
  "linkedSections": ["string"],
  "tags": ["string"],
  "createdBy": "ObjectId",
  "createdAt": "date",
  "updatedAt": "date",
  "publishedAt": "date"
}
```

**Indexes**
- `{ status: 1, updatedAt: -1 }`
- `{ createdBy: 1, status: 1 }`
- `{ linkedSections: 1 }`

---

## 2.9 agent_runs (optional but recommended)
**Purpose:** audit + replay of agent outputs (helps UX and debugging)

**Document shape**
```json
{
  "_id": "ObjectId",
  "userId": "ObjectId",
  "skill": "explain|socratic|flashcards|checklist|scenario_tree|notes_assist",
  "context": {
    "sectionSlug": "string",
    "anchorId": "string",
    "selectedText": "string",
    "mode": "simple|technical|analogy"
  },
  "output": {},
  "savedTo": { "noteId": "ObjectId", "playbookId": "ObjectId" },
  "createdAt": "date"
}
```

**Indexes**
- `{ userId: 1, createdAt: -1 }`
- `{ skill: 1, createdAt: -1 }`

---

## 2.10 audit_log
**Purpose:** track admin actions, indexing, config changes, and notable events

**Document shape**
```json
{
  "_id": "ObjectId",
  "actorUserId": "ObjectId",
  "action": "book_import|book_publish|reindex|config_change|agent_run|login_fail",
  "details": {},
  "createdAt": "date"
}
```

**Indexes**
- `{ createdAt: -1 }`
- `{ actorUserId: 1, createdAt: -1 }`

---

## 3) Relationships & UI mapping

### 3.1 Canonical linkages
- Notes/highlights/bookmarks/progress always reference `sectionSlug` and (optionally) `anchorId`.
- Highlights may link to a note via `noteId`.
- Playbooks link to sections via `linkedSections[]`.

### 3.2 UI flows supported
- Reader selection → highlight → optional note
- Agent output → Save as note / Save as playbook draft
- Library → continue reading from `reading_progress`
- Playbook detail → open linked section at anchor

---

## 4) Indexing & performance

### 4.1 Read patterns
- Library loads TOC tree + progress summaries (either computed or cached `book_toc`).
- Reader fetches one `book_section` by slug.
- Notes/highlights/bookmarks are per-user, per-section queries.

### 4.2 QMD integration
- QMD is the primary semantic search engine.
- MongoDB text index is a fallback and optional.

---

## 5) Evolution notes

This schema intentionally covers MVP and near-term needs:
- Add “journal” collections later (trades, reviews, metrics)
- Add “alerts” collections later (alert definitions, state, acknowledgements)
- Add more robust versioning/publishing if needed
