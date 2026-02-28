---
title: Endpoint Contract v0 (Superseded)
kind: spec
status: superseded
owner: Nexus
last_updated: 2026-02-28
topics:
  - api
  - endpoints
  - contracts
---

Got it — **MongoDB-backed book content over a Tailscale connection** is a totally workable "code-first" approach, and it pairs nicely with App Router **if you design for caching + reindex + offline fallback**.

Here's the cleanest way to think about it. — here’s a **minimal endpoint contract** you can paste right under the Networking & Security section. It’s designed for your boundary: **Browser → Next.js only**, and **Next.js → OpenClaw internal** with a service token.

---

## Minimal endpoint contract

### Boundary rules

* **Client (browser) calls only Next.js** under `/api/*`.
* **Next.js server calls OpenClaw** over internal networking using `Authorization: Bearer <service token>`.
* OpenClaw never receives requests directly from browsers.

---

## Next.js API (public to authenticated users)

### Auth / session

* `POST /api/auth/login`

  * Body: `{ email|username, password|code }`
  * Returns: session cookie (HTTP-only)
* `POST /api/auth/logout`
* `GET /api/auth/me`

  * Returns: `{ user, role, prefs }`

### Book (read)

* `GET /api/book/toc`

  * Returns: TOC tree + progress summaries
* `GET /api/book/section?slug=...`

  * Returns: `{ section, frontmatter, htmlOrMdx, headings }`
* `GET /api/book/search?q=...`

  * Returns: ranked results with snippets + deep links
  * Implementation: QMD first; Mongo text search fallback

### Notes / highlights / bookmarks

* `POST /api/notes`

  * Body: `{ sectionSlug, anchorId?, selection?, noteText, tags[] }`

* `GET /api/notes?sectionSlug=...`

* `PATCH /api/notes/:id`

* `DELETE /api/notes/:id`

* `POST /api/highlights`

  * Body: `{ sectionSlug, anchorId?, startOffset?, endOffset?, color?, noteId? }`

* `POST /api/bookmarks/toggle`

  * Body: `{ sectionSlug, anchorId? }`

### Reading progress

* `POST /api/progress`

  * Body: `{ sectionSlug, percent, lastAnchorId? }`
* `GET /api/progress/summary`

  * Returns: “continue”, recent, streak, etc.

### Playbooks

* `GET /api/playbooks`

  * Returns: list (draft + published based on role)
* `POST /api/playbooks/draft`

  * Body: `{ title, triggers[], checklist[], scenarioTree, linkedSections[] }`
* `PATCH /api/playbooks/:id`
* `POST /api/playbooks/:id/publish` (admin only)
* `POST /api/playbooks/:id/archive` (admin only)

### Agent skills (UI buttons in Reader)

Single endpoint pattern keeps it clean:

* `POST /api/agent/skill`

  * Body:

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
  * Returns:

    ```json
    {
      "output": { "type": "...", "content": "...", "items": [] },
      "save_suggestions": { "note": true, "playbook_draft": false }
    }
    ```

Optional (for responsiveness):

* `GET /api/agent/stream/:runId` (SSE) or websockets later

### Admin (minimal)

* `POST /api/admin/book/import` (admin)

  * Ingest markdown or structured content into Mongo (optional for your workflow)
* `POST /api/admin/book/reindex` (admin)

  * Triggers QMD reindex + refreshes TOC snapshot
* `GET /api/admin/status` (admin)

  * Returns: last import, last index, service health, queue depth
* `POST /api/admin/config` (admin)

  * Sets agent knobs, alert thresholds (placeholders now)

---

## OpenClaw internal API (private)

All requests require:

* `Authorization: Bearer <service token>`
* `X-User-Id`, `X-User-Role` (or embedded claims in JWT)

### QMD / retrieval

* `POST /internal/search`

  * Body: `{ q, filters?, limit }`
  * Returns: `{ results: [{ sectionSlug, anchorId, score, snippet }] }`

### Agent execution

* `POST /internal/agent/run`

  * Body: `{ skill, context, constraints }`
  * Returns: `{ output, citations?, runId? }`

### Indexing

* `POST /internal/index/rebuild`

  * Body: `{ scope: "book", version?, dryRun? }`
  * Returns: `{ started: true, jobId }`
* `GET /internal/index/status?jobId=...`

### Health

* `GET /internal/health`

  * Returns: `{ ok, components: { qmd, agent, storage } }`

---

## Response/behavior standards (important)

* All endpoints return structured errors:

  * `{ error: { code, message, details? } }`
* Idempotency where it matters:

  * `reindex` should be safe to call twice
* Rate limits:

  * `/api/auth/login`, `/api/agent/skill`, `/api/book/search`, `/api/admin/*`
