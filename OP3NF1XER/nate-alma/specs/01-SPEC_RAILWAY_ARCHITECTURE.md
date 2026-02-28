---
title: Railway Architecture Specification
kind: spec
status: accepted
owner: Nexus
last_updated: 2026-02-28
topics:
  - railway
  - architecture
  - deployment
---

## 0) Purpose

This document defines the deployment architecture on **Railway** for the Book-first MVP.

Goals:
- Simple, low-ops deployment.
- Clear network boundary: only the web app is public.
- Internal-only access for MongoDB and OpenClaw/QMD/SFTPGo.
- Supports sleeping/scale-to-zero patterns where possible, without breaking core UX.
- Aligns with the endpoint boundary in `SPEC_ENDPOINT_CONTRACT.md`.

---

## 1) Service topology (3 services)

### Service A — `web`
**Type:** Next.js App Router (public)

**Responsibilities**
- Public UI (Library, Reader, Notes, Playbooks, Admin)
- Authentication/session management (identity boundary)
- API routes (`/api/*`) for browser requests
- Server-to-server calls to internal services (Core container)
- Reads/writes MongoDB for:
  - book sections
  - notes/highlights/bookmarks/progress
  - playbooks
  - audit log
  - (optional) agent_runs

**Exposure**
- Public HTTP enabled (the ONLY public entry point)

**Environment variables**
- `MONGODB_URI`
- `INTERNAL_CORE_BASE_URL` (internal URL for Service B)
- `INTERNAL_SERVICE_TOKEN` or `INTERNAL_JWT_SIGNING_KEY`
- Auth variables (e.g., `AUTH_SECRET`, `AUTH_URL`, provider creds)
- Optional: `APP_BASE_URL` (for absolute URLs)

**Health**
- `/api/health` (optional) for Railway checks
- Display readiness: DB connectivity, internal service reachability (non-blocking)

---

### Service B — `core`
**Type:** Docker container (internal)

**Components inside one container (required bundle)**
- OpenClaw (agent runtime/orchestration)
- QMD (vector search)
- SFTPGo (admin surface + persistence/file access)

**Responsibilities**
- Internal agent execution endpoint(s): `/internal/agent/run`
- Internal retrieval endpoint(s): `/internal/search` (QMD)
- Indexing/reindex jobs: `/internal/index/rebuild`, `/internal/index/status`
- SFTP-based content/persistence workflows if needed

**Exposure**
- Internal only. No public HTTP.
- If Railway forces a port, do not route or publish externally.

**Environment variables**
- `INTERNAL_SERVICE_TOKEN` (must match Web for verification)
- QMD index/config vars
- Storage paths / SFTPGo config vars
- Optional: `MONGODB_URI` if Core needs direct DB access (prefer Web owns DB)

**Security**
- All endpoints require `Authorization: Bearer <service token>`
- Reject requests missing token; do not rely on obscurity.
- Rate limit internal endpoints defensively (especially indexing)

---

### Service C — `mongo`
**Type:** MongoDB (internal)

**Responsibilities**
- Persistent storage for Book-first MVP entities
- Optional indexes for fallback search (QMD remains primary)

**Exposure**
- Internal only (no public DB port)
- Accessible only from Service A (and Service B if explicitly needed)

**Backups**
- At minimum: scheduled logical dump/export (implementation detail)
- Prefer an export script or external managed backups if available

---

## 2) Networking and security boundary (canonical)

### 2.1 Public/private rule
- Browser → Service A only.
- Service A → Service B internal only.
- Service A → Service C internal only.
- Browser → Service B/C is forbidden.

### 2.2 Auth boundary
- Service A is the identity provider for users (sessions/roles).
- Service B trusts Service A via:
  - short-lived JWT **or**
  - rotating shared secret token

### 2.3 Headers/token strategy
- Recommended: JWT signed by Service A
  - includes `sub` (user id), `role`, `exp`
- Alternative: shared token + trusted headers:
  - `X-User-Id`, `X-User-Role`

---

## 3) Request flows

### 3.1 Reader load (typical)
1) Browser requests `/book/...` page
2) Service A fetches section from MongoDB
3) Service A optionally calls Service B for QMD “related” suggestions (optional)
4) Page renders with Reader + Agent panel

### 3.2 Search (command palette)
1) Browser calls `/api/book/search?q=...`
2) Service A calls Service B `/internal/search`
3) Service B returns results
4) Service A returns sanitized results to browser

### 3.3 Agent skill run
1) Browser calls `/api/agent/skill`
2) Service A validates session, constructs internal request
3) Service A calls Service B `/internal/agent/run` with service auth
4) Service A returns structured output to browser

### 3.4 Reindex (admin)
1) Admin clicks “Reindex Book”
2) Browser calls `/api/admin/book/reindex`
3) Service A triggers Service B `/internal/index/rebuild`
4) Service A stores job record (optional) + returns `jobId`
5) UI polls `/api/admin/status` (or job endpoint) to show progress and errors

---

## 4) Sleep / scale-to-zero considerations

### 4.1 General
Railway may sleep services when idle depending on plan/settings.  
Design must tolerate cold starts:
- Web: user sees spinner/skeleton; retries are safe
- Core: agent/search endpoints may have delayed availability on first request

### 4.2 “No silent failure” compliance
When Core is sleeping or unreachable:
- UI must show “Agent temporarily unavailable” with retry
- Search must show fallback message (and optionally a Mongo text search fallback)

### 4.3 Recommended approach
- Keep Web service responsive; allow Core to sleep if necessary
- Avoid background chatter from Web/Core that prevents sleeping unless required

---

## 5) Observability (minimum)

### 5.1 Logs
- Web logs:
  - auth events (success/fail)
  - agent skill invocations
  - admin actions
  - errors with request IDs
- Core logs:
  - agent runs
  - QMD searches
  - indexing jobs
  - authorization failures

### 5.2 Correlation IDs
- Web generates `X-Request-Id` for each request
- Propagate to Core calls as header for tracing

---

## 6) Secrets and configuration

### 6.1 Railway environment variables
- Store all secrets in Railway environment variables
- No secrets in repo
- Rotate internal tokens periodically

### 6.2 SFTP workflows
- If SFTPGo is used for content deployment:
  - treat uploads as untrusted input
  - sanitize filenames and paths
  - keep reindex/import admin-controlled

---

## 7) Security checklist (MVP)

- [ ] Only Web is publicly exposed
- [ ] Mongo not publicly accessible
- [ ] Core not publicly accessible
- [ ] Service-to-service auth implemented (token/JWT)
- [ ] Login rate limiting + generic error messages
- [ ] Admin actions require admin role + confirmation
- [ ] Audit log for admin actions and agent actions
- [ ] CORS locked down (browser → Web only)

---

## 8) Future evolution (non-blocking)

Optional later additions:
- Dedicated “jobs” worker service for indexing/import if Core becomes busy
- Redis/Valkey if you need queueing/limiting at scale
- Separate SFTPGo if admin surface needs isolation

These are not required for MVP.
