# SPEC_SECURITY_MONITORING

**Status:** Accepted (addresses DECISION_172 Oracle “Monitoring Required”)  
**Owner:** Nexus  
**Audience:** Implementers  
**Last updated:** 2026-02-28

## 0) Purpose

Define minimum observability for security and operational resilience.

Goals:
- Detect auth abuse and token failures
- Detect core instability and cold-start pain
- Detect Mongo error spikes and pool saturation (best-effort)
- Keep metrics lightweight for MVP

---

## 1) Events to log (minimum)

### 1.1 Security events (Web)
- `auth.login.success`
- `auth.login.fail` (no account enumeration in response)
- `auth.rate_limited`
- `internal.core.auth_fail` (token invalid/expired)
- `admin.action` (reindex, publish, import)
- `agent.skill.invoked` (skill name, user id)
- `agent.skill.rate_limited`

### 1.2 Operational events
- `core.unavailable` (timeout/503/health fail)
- `core.wake.time_to_first_success_ms`
- `mongo.connect.fail`
- `qmd.search.p95_ms` (if measured inside core)

---

## 2) Alert thresholds (starter values)

### 2.1 Security alerts
- >5 `auth.login.fail` per minute from same IP → alert
- >10 `internal.core.auth_fail` per minute → alert
- >10 admin actions in 5 minutes → alert (possible automation misuse)

### 2.2 Operational alerts
- core startup time >30s (if measurable) → warn
- >3 `core.unavailable` events in 5 minutes → warn
- Mongo selection/connect errors >5 in 5 minutes → warn

---

## 3) Correlation IDs
Web generates `X-Request-Id` for each request and propagates to core.
Include request id in every log line.

---

## 4) Where to store metrics (MVP)
- Primary: Railway logs (structured JSON if possible)
- Secondary: `audit_log` collection for key actions and failures (rate limited)

---

## 5) Admin status page requirements
`/admin` must show:
- last reindex run time + state + error (if any)
- last core health check time
- last core unavailable time
- last mongo error time (if any)

---

## 6) Checklist
- [ ] Logs include request ids
- [ ] Rate-limit events are logged
- [ ] Core auth failures are logged
- [ ] Admin page surfaces last-run and error status (no silent failure)
