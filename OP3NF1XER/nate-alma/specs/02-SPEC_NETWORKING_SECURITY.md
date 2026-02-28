---
title: Networking & Security Specification
kind: spec
status: accepted
owner: Nexus
last_updated: 2026-02-28
topics:
  - networking
  - security
  - railway
---

## Networking & Security (Railway)

### High-level model

* **Only the Next.js website is public.**
* **OpenClaw/QMD/SFTPGo and MongoDB are private/internal** and must not be directly reachable from the public internet.
* The **website is the single identity boundary** (login, sessions, roles). OpenClaw is treated as a protected backend service.

### Railway service exposure

* **Next.js (Web UI):** public HTTP enabled (the only public endpoint).
* **Core container (OpenClaw + QMD + SFTPGo):** no public exposure required; accessible only via Railway internal networking.
* **MongoDB:** not publicly exposed; only accessible from other Railway services on the internal network.

### Authentication + authorization boundary

* **User authentication happens only in Next.js** (session cookie / token-based).
* **All calls from Next.js → OpenClaw must be server-to-server authenticated**, using one of:

  * a short-lived signed JWT (preferred), or
  * a rotating shared secret API key
* OpenClaw must **verify** the token on every request and enforce:

  * user roles (admin vs user)
  * allowed agent actions (no execution)
  * rate limits / request budgets per user/session

### Request flow (recommended)

1. User logs into **Next.js**
2. Next.js establishes a session and issues an internal token for backend calls
3. Next.js calls OpenClaw via **internal URL** with:

   * `Authorization: Bearer <service token>`
   * user identity + role claims
4. OpenClaw returns responses only to authenticated internal callers

### Data access rules

* **MongoDB is only accessed by services inside Railway** (Next.js for Book/Notes/Playbooks; Core only if necessary).
* Avoid DB credentials in the browser; **no direct client-side DB access**.

### Admin access

* Admin pages are **inside the Next.js app** and require:

  * admin role
  * optional second step confirmation for destructive actions (“Publish”, “Reindex”, “Delete”)
* SFTPGo remains the controlled interface for file/persistence operations; never expose raw filesystem paths to users.

### Hardening requirements (must-have)

* Rate limit:

  * login attempts
  * agent actions (per user/day and per minute)
  * expensive endpoints (search, reindex)
* Strict CORS:

  * browser only talks to Next.js domain
  * backend services do not accept cross-origin requests
* Secrets management:

  * service tokens and DB creds in Railway environment variables
  * rotate secrets periodically; no secrets stored in repo
* Audit trail:

  * log admin actions (publish/reindex/config changes)
  * log agent actions (which skill invoked, inputs referenced, outputs produced)

### Non-goals / avoid

* No public MongoDB port.
* No public OpenClaw endpoints.
* No “frontend calls OpenClaw directly.”
* No embedding credentials in client code.