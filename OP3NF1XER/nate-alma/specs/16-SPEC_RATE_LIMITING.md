# SPEC_RATE_LIMITING

**Status:** Accepted (addresses DECISION_172 Oracle “Must Implement #3”)  
**Owner:** Nexus  
**Audience:** Implementers  
**Last updated:** 2026-02-28

## 0) Purpose

Define rate limits for Web API routes and internal calls.

Goals:
- Prevent abuse and accidental loops (agent/search)
- Protect login from brute force
- Preserve “calm UX” with clear error copy
- Work under Railway sleep/scale-to-zero constraints

---

## 1) Rate limit policy (minimums)

### 1.1 Login
- **5 attempts per 15 minutes per IP**
- After threshold: return 429 with message:
  - “Too many attempts. Try again in 15 minutes.”

### 1.2 Agent skills
- **10 per minute per user**
- **100 per hour per user**
- If exceeded: 429 with message:
  - “You’ve hit the assistant limit. Try again soon.”

### 1.3 Search
- **30 per minute per user**
- If exceeded: 429 with message:
  - “Search is busy. Try again soon.”

### 1.4 Admin actions
- **5 per minute per admin user**
- Applies to: reindex, publish, import
- If exceeded: 429 with message:
  - “Too many admin actions. Try again shortly.”

---

## 2) Implementation strategy

### 2.1 MVP approach (Mongo-backed counters with TTL)
Implement counters in MongoDB so rate limits survive process restarts/sleep.

Create collection: `rate_limits`
- fields: `key`, `windowStart`, `count`, `createdAt`
- TTL index on `createdAt` ~ 2 hours

Keys:
- login: `login:ip:{ip}`
- agent: `agent:user:{userId}`
- search: `search:user:{userId}`
- admin: `admin:user:{userId}`

Algorithm:
- Determine fixed window bucket (e.g., minute/hour/15m)
- Upsert doc for bucket, increment `count`
- If `count` exceeds limit, reject

### 2.2 Optional enhancement (in-memory + Mongo)
- L1 in-memory for hot paths
- L2 Mongo as authority
- Keeps latency low while remaining robust

---

## 3) UX and response shape

Return:
```json
{
  "error": {
    "code": "rate_limited",
    "message": "Too many attempts. Try again in 15 minutes.",
    "details": { "retryAfterSeconds": 900 }
  }
}
```

Also set:
- `Retry-After: <seconds>`

---

## 4) Audit and monitoring
- Log rate-limit events with:
  - user id (if known)
  - IP (for login)
  - route
  - request id
- Alert on spikes (see SPEC_SECURITY_MONITORING.md)

---

## 5) Checklist
- [ ] Login endpoints rate limited
- [ ] Agent endpoints rate limited by user id
- [ ] Search endpoints rate limited by user id
- [ ] Admin endpoints rate limited by admin user id
- [ ] UI shows calm, non-accusatory messaging
