---
title: Endpoint Contract Specification
kind: spec
status: accepted
owner: Nexus
last_updated: 2026-02-28
topics:
  - api
  - endpoints
  - contracts
---

## 0) Purpose

This document defines the **minimum endpoint contract** for the project to keep boundaries clean:

- **Browser → Next.js only**
- **Next.js → OpenClaw/QMD internal only**
- MongoDB is **never** accessed directly by the browser.

This contract is intentionally minimal to support the **Book-first MVP** and agentic learning tools.

---

## 1) Boundary rules (non-negotiable)

### 1.1 Public interface
- The browser only calls the Next.js application under `/api/*`.
- Internal services are never called directly by the browser (no CORS exposure).

### 1.2 Internal interface
- Next.js calls internal OpenClaw/QMD endpoints server-to-server using:
  - `Authorization: Bearer <service token>` (JWT or rotating shared secret)
- Identity propagation:
  - Either embed user claims in the JWT **or**
  - Send trusted headers from Next.js to internal services:
    - `X-User-Id`
    - `X-User-Role`

### 1.3 Response and error shape
All endpoints should return:
- Success: JSON payload as specified below
- Error: `{ "error": { "code": string, "message": string, "details"?: any } }`

---

## 2) Next.js API endpoints (Browser → Next.js)

> NOTE: These endpoints may be implemented as Route Handlers in the App Router.

### 2.1 Auth / Session
- `POST /api/auth/login`
  - Body: `{ email|username, password|code }`
  - Result: sets HTTP-only session cookie
- `POST /api/auth/logout`
  - Result: clears session
- `GET /api/auth/me`
  - Returns: `{ user: { id, name, email }, role, prefs }`

### 2.2 Book (Read)
- `GET /api/book/toc`
  - Returns: `{ tocTree, updatedAt }`
- `GET /api/book/section?slug=...`
  - Returns:
    ```json
    {
      "section": {
        "slug": "part-x/ch-y/...",
        "title": "...",
        "part": { "index": 1, "slug": "...", "title": "..." },
        "chapter": { "index": 1, "slug": "...", "title": "..." },
        "order": { "sectionIndex": 1 }
      },
      "frontmatter": { "summary": [], "checklist": [], "mistakes": [], "drill": {} },
      "body": { "format": "markdown|mdx|html", "content": "..." },
      "headings": [{ "id": "anchor", "text": "Heading", "level": 2 }]
    }
    ```
- `GET /api/book/search?q=...`
  - Returns:
    ```json
    {
      "q": "...",
      "results": [
        { "sectionSlug": "...", "anchorId": "...", "score": 0.92, "snippet": "..." }
      ]
    }
    ```
  - Implementation preference: QMD semantic search; Mongo text search is a fallback.

### 2.3 Notes
- `POST /api/notes`
  - Body: `{ sectionSlug, anchorId?, selection?, noteText, tags? }`
  - Returns: `{ note }`
- `GET /api/notes?sectionSlug=...`
  - Returns: `{ notes: [...] }`
- `PATCH /api/notes/:id`
  - Body: `{ noteText?, tags?, title? }`
  - Returns: `{ note }`
- `DELETE /api/notes/:id`
  - Returns: `{ ok: true }`

### 2.4 Highlights
- `POST /api/highlights`
  - Body: `{ sectionSlug, anchorId?, range?, text, color?, noteId? }`
  - Returns: `{ highlight }`

### 2.5 Bookmarks
- `POST /api/bookmarks/toggle`
  - Body: `{ sectionSlug, anchorId? }`
  - Returns: `{ bookmarked: true|false }`

### 2.6 Reading progress
- `POST /api/progress`
  - Body: `{ sectionSlug, percent, lastAnchorId? }`
  - Returns: `{ progress }`
- `GET /api/progress/summary`
  - Returns: `{ continue: {...}, recent: [...], streak?: {...} }`

### 2.7 Playbooks
- `GET /api/playbooks`
  - Returns: `{ playbooks: [...] }` (draft + published based on role)
- `POST /api/playbooks/draft`
  - Body: `{ title, triggers[], checklist[], scenarioTree, linkedSections[] }`
  - Returns: `{ playbook }`
- `PATCH /api/playbooks/:id`
  - Body: `{ title?, triggers?, checklist?, scenarioTree?, linkedSections?, tags? }`
  - Returns: `{ playbook }`
- `POST /api/playbooks/:id/publish` (admin)
  - Returns: `{ playbook }`
- `POST /api/playbooks/:id/archive` (admin)
  - Returns: `{ ok: true }`

### 2.8 Agent skills (Reader right rail)
Single contract endpoint:

- `POST /api/agent/skill`
  - Body:
    ```json
    {
      "skill": "explain|socratic|flashcards|checklist|scenario_tree|notes_assist",
      "context": {
        "sectionSlug": "...",
        "anchorId": "...",
        "selectedText": "...",
        "userNoteIds": ["..."],
        "mode": "simple|technical|analogy"
      }
    }
    ```
  - Returns:
    ```json
    {
      "output": { "type": "text|qa|cards|checklist|tree", "title": "...", "content": "...", "items": [] },
      "save_suggestions": { "note": true, "playbook_draft": false }
    }
    ```

Optional streaming later:
- `GET /api/agent/stream/:runId` (SSE)

### 2.9 Admin (minimal)
- `GET /api/admin/status` (admin)
  - Returns: last import/publish time, last reindex time, component health summary
- `POST /api/admin/book/reindex` (admin)
  - Returns: `{ started: true, jobId }`
- `POST /api/admin/config` (admin, optional)
  - Body: `{ agentKnobs, uiKnobs }`
  - Returns: `{ ok: true }`

---

## 3) Internal API (Next.js → OpenClaw/QMD)

All endpoints require:
- `Authorization: Bearer <service token>`
- User identity via JWT claims or `X-User-*` trusted headers.

### 3.1 Retrieval / QMD search
- `POST /internal/search`
  - Body: `{ q, filters?, limit? }`
  - Returns:
    ```json
    {
      "results": [{ "sectionSlug": "...", "anchorId": "...", "score": 0.92, "snippet": "..." }]
    }
    ```

### 3.2 Agent execution
- `POST /internal/agent/run`
  - Body: `{ skill, context, constraints? }`
  - Returns: `{ output, runId? }`

### 3.3 Indexing
- `POST /internal/index/rebuild`
  - Body: `{ scope: "book", version?, dryRun? }`
  - Returns: `{ started: true, jobId }`
- `GET /internal/index/status?jobId=...`
  - Returns: `{ jobId, state: "queued|running|succeeded|failed", progress?, error? }`

### 3.4 Health
- `GET /internal/health`
  - Returns: `{ ok: true, components: { qmd: "ok", agent: "ok", storage: "ok" } }`

---

## 4) Behavior standards

### 4.1 Idempotency
- Reindex requests should be safe to call multiple times.
- Toggle bookmark is idempotent per (user, section, anchor).

### 4.2 Rate limiting (minimum)
- Login: strict rate limit + lockout UX messaging.
- Agent skill runs: per-user per-minute and per-day budgets.
- Search: per-user rate limit and caching.
- Admin: throttle and require admin role.

### 4.3 Observability (minimum)
- Correlation ID on requests (generated by Next.js):
  - `X-Request-Id`
- Log all:
  - admin actions
  - agent skill invocations
  - indexing jobs
  - errors

---

## 5) Notes on evolution

This spec is the **minimum contract**. Future additions (charts, alerts, journal) must respect:
- Browser → Next.js only
- OpenClaw internal only
- “No silent failure” UI requirement
