# SPEC_MONGODB_SECURITY

**Status:** Accepted (addresses DECISION_172 Oracle “Must Implement #4”)  
**Owner:** Nexus  
**Audience:** Implementers  
**Last updated:** 2026-02-28

## 0) Purpose

Define MongoDB security posture for Railway deployment.

Goals:
- Mongo is internal-only (no public exposure)
- Authentication is enabled (do not rely on network isolation)
- Least privilege users for Web and (optionally) Core
- Operational verification steps included

---

## 1) Network posture
- MongoDB service must not expose a public port.
- Only `web` (and optionally `core`) may connect.

Verification (external):
- Ensure no public hostname/port is assigned.
- From outside, scanning port 27017 should be closed/filtered.

---

## 2) Authentication (required)
Enable MongoDB authentication and create DB users.

### 2.1 Users
Create:
1) `web_user`
   - Role: `readWrite` on the application database
2) `core_user` (only if core needs direct DB access)
   - Prefer: `read` only on collections it must read
   - Avoid giving core write unless necessary

### 2.2 Credentials handling
- Store usernames/passwords in Railway environment variables.
- Never store creds in repo or client-side code.

---

## 3) Least privilege guidance (practical MVP)
Web requires read/write to:
- users
- book_sections (+ optional book_toc)
- notes/highlights/bookmarks/reading_progress
- playbooks
- audit_log (+ optional agent_runs, rate_limits)

Core ideally requires **no direct DB access** for MVP.
If you must grant core access:
- grant read on `book_sections` (and maybe `book_toc`)
- deny writes unless unavoidable

---

## 4) Logging and auditing
Minimum:
- Log authentication failures in Web (as part of DB connect error logging)
- Record admin actions and agent actions in `audit_log` (already in schema)

Optional:
- Add Mongo audit logs if supported by your deployment method

---

## 5) Operational checklist
- [ ] MongoDB not publicly reachable
- [ ] MongoDB auth enabled
- [ ] Separate DB users for web/core if core needs DB
- [ ] DB creds stored only in env vars
- [ ] Backups are defined (logical export at minimum)
