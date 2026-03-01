# SPEC_CORE_CONTAINER_STARTUP

**Status:** Accepted (addresses DECISION_172 “Must Address #2”)  
**Owner:** Nexus  
**Audience:** Implementers  
**Last updated:** 2026-02-28

## 0) Purpose

Define the **startup order and readiness contract** for the Railway `core` service running multiple processes:

- OpenClaw (agent runtime/orchestration)
- QMD (retrieval)
- SFTPGo (admin/file surface)

Goal: predictable boots, clear health, and graceful degradation.

---

## 1) Process manager requirement

Because `core` runs multiple long-lived services, run them under a process supervisor:

**Recommended:** `s6-overlay`  
**Alternatives:** `supervisord`, `tini + custom bash` (least preferred)

Rationale:
- restart policies per process
- log routing
- reliable shutdown
- readiness gating

---

## 2) Ports (example)
You may choose different ports; what matters is consistency and health checks.

- QMD: `:7100`
- OpenClaw: `:7200`
- SFTPGo: `:7300`
- Core aggregate health (optional): `:7000`

---

## 3) Startup sequence (authoritative)

### Phase 0 — Init
1) Load configs from env + mounted config directory
2) Ensure writable paths exist (indexes, uploads, logs)
3) Validate required env vars; if missing → fail fast

### Phase 1 — Start QMD
1) Start QMD
2) Wait until QMD reports healthy:
   - `GET /health` returns 200
   - and (optional) `GET /ready` confirms index availability
3) If QMD unhealthy after timeout (e.g., 60s):
   - mark service degraded
   - but continue booting so Admin can see status and retry reindex

### Phase 2 — Start OpenClaw
1) Start OpenClaw
2) OpenClaw must be configured with:
   - QMD base URL (internal loopback)
   - service auth verification (token/JWT)
3) Wait for OpenClaw health endpoint to return 200

### Phase 3 — Start SFTPGo
1) Start SFTPGo
2) Ensure SFTPGo has access to the intended persistence directory

---

## 4) Readiness and health contract

### 4.1 Required endpoints (internal-only)
- `GET /internal/health`
  - returns `{ ok, components: { qmd, agent, sftpgo } }`
- `GET /internal/index/status?jobId=...`
- `POST /internal/index/rebuild`

### 4.2 Health semantics
- `ok=true` only when OpenClaw and QMD are healthy
- If one component fails:
  - still return 200 with `ok=false` and component-level states
  - do not “hang”; the Web UI must be able to display status (no silent failure)

---

## 5) Authorization (minimum)
All internal routes require:
- `Authorization: Bearer <service token>`
Reject requests without token with 401.

---

## 6) Reindex behavior
- Reindex is a job with:
  - startedAt, state, progress, error
- Reindex should be idempotent and safe to call multiple times
