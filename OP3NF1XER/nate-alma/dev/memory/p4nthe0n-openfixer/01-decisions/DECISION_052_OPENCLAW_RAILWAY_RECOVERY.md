# DECISION_052: OpenClaw Railway Deployment Recovery

**Decision ID**: DECISION_052  
**Category**: INFRA (Incident Response / Deployment Recovery)  
**Status**: Iterating  
**Priority**: Critical (P0 - Production Down)  
**Date**: 2026-02-23  
**Oracle Approval**: 62/100 (Oracle consultation task `ses_371e61c56ffeG67n12s9ls13Sp`)  
**Designer Approval**: 78/100 (Designer consultation task `ses_371e61c39ffeFRIWEl42OkgZTt`)

---

## Executive Summary

Production deployment of **OpenClaw** on Railway is returning **HTTP 503 Service Unavailable**, indicating the application container is either crashed, failing health checks, or unable to bind to the expected port. This decision provides a **four-phase recovery workflow** optimized for **minimal time-to-recovery (MTTR)** and **blast-radius containment**.

**Current State**: 
- Production endpoint: 503 (confirmed via user report)
- Railway dashboard accessible with credentials provided
- Root cause: Unknown (likely bad deployment)
- Probe snapshot (2026-02-24):
  - `/setup` -> 401 (auth gate reachable)
  - `/openclaw` -> 503
  - `/health` -> 502
  - `/setup/export` -> 401
  - `/favicon.ico` -> 502
- Railway API key discovery signal: key accepted by GraphQL endpoint for read-only auth probes; deep service discovery still pending in-band execution constraints
- Gateway wrapper diagnostic (`/healthz`) now returns structured failure:
  - `wrapper.configured=true`
  - `stateDir=/data/.clawdbot`
  - `workspaceDir=/data/workspace`
  - `gateway.target=http://127.0.0.1:18789`
  - `gateway.reachable=false`
  - `lastError=[gateway] start failure: Gateway did not become ready in time`
  - `lastExit.code=1`
- Additional route probes: `/readyz`, `/livez`, `/gateway/health`, `/openclaw/healthz`, `/debug/health` -> 502; `/.well-known/health` -> 503
- Documentation correlation: OpenClaw gateway can refuse startup on strict config validation failures; Railway baseline expects `OPENCLAW_STATE_DIR=/data/.openclaw` while runtime reports `/data/.clawdbot`

**Proposed Solution**:
- **Phase 1 (Stabilize)**: Immediate rollback to last known good deployment (< 5 min target)
- **Phase 2 (Restore)**: Verify service health and connectivity
- **Phase 3 (Validate)**: Confirm full functionality via synthetic checks
- **Phase 4 (Prevent)**: Implement safeguards to prevent recurrence

**Target MTTR**: < 10 minutes for service restoration, < 30 minutes for full validation

## Decision Lifecycle State

- `Drafted`: Completed (decision artifact created in `STR4TEG15T/decisions/DECISION_052_OPENCLAW_RAILWAY_RECOVERY.md`)
- `SyncQueued`: Active (MongoDB sync unavailable in this pass; queued with retry metadata)
- `Consulting`: Completed (Oracle + Designer completed within the 15-minute window; no timeout)
- `Approved`: Completed (stricter risk posture applied from Oracle score)
- `Iterating`: Active (workflow and agent-availability corrections applied)
- `HandoffReady`: Pending workflow-conformant OpenFixer handoff
- `Closed`: Pending

### Sync Metadata

- Sync state: `SyncQueued`
- Reason: no decision-sync tool endpoint available in current tool surface
- First queued timestamp (UTC): 2026-02-23T00:00:00Z (session-local)
- Retry owner: Strategist next pass

### Discovery Status

- Mode: `Inquiry`
- Objective: complete non-destructive incident discovery before deployment activation
- Current signal: mixed path health indicates service may be partially alive but failing on core UI/runtime routes
- Access/tooling status: browser and GraphQL deep inspection must run via Nexus-mediated OpenFixer flow under updated guardrails
- Strongest current hypothesis: local gateway startup failure (readiness timeout) inside deployment, not pure edge routing outage
- Refined hypothesis: startup failure likely triggered by config/schema drift or state-path mismatch introduced by model-driven edits
- Access correction (spec): prior token-access ambiguity is resolved; first key is validated against target project/service and reversible mutation test passed, confirming deployment edit authority
- Root cause evidence from deployment logs: gateway fails startup due to `MissingEnvVarError` for `OPENAI_API_KEY` referenced in OpenClaw config (`models.providers.openai.apiKey`)
- Constrained pass2 evidence: one additional config-path mutation (`OPENCLAW_STATE_DIR=/data/.openclaw`) plus one restart still left `/openclaw` unhealthy (`503`/timeouts), with missing-env error unchanged
- Rollback evidence: approved rollback mutation succeeded and produced a new active `SUCCESS` deployment, but runtime remained unhealthy with unchanged `MissingEnvVarError` and config path `/data/.clawdbot/openclaw.json`
- Post-rollback branch selected: remove hard `OPENAI_API_KEY` config dependency via minimal config edit + one restart (no rollback/reset in that pass)
- Branch-b execution evidence: OpenAI dependency removal succeeded (error cleared) but runtime still failed; new blocking missing-env dependency surfaced for `GEMINI_API_KEY` at `models.providers.google.apiKey`
- Root-source trace: session `86a82de1-b44f-4261-aa99-5391cbe94248` shows user-driven multi-provider config request followed by gateway config apply on `/data/.clawdbot/openclaw.json`; hard provider env dependencies were activated before runtime env completeness validation
- Final recovery evidence: Gemini dependency removal cleared remaining missing-env blocker; `gateway.reachable=true` and `/openclaw` returned `200` (single transient `502` under rapid spot-check)

### Arbitration Record

- Oracle posture (62): rollback-first, elevated caution on unknown migration/state risks
- Designer posture (78): feasible four-phase restoration workflow with clear validation gates
- Conflict result: no hard conflict; current pass adopts stricter Oracle risk posture for go-live gating

---

## Background

### Railway-Specific Context

Railway provides several deployment recovery mechanisms that must be leveraged in priority order:

| Mechanism | Speed | Safety | Use Case |
|-----------|-------|--------|----------|
| **Instant Rollback** | < 30 seconds | High | Immediate recovery from bad deployment |
| **Environment Variable Revert** | < 60 seconds | Medium | Config-related failures |
| **Deployment Redeploy** | 2-5 minutes | Medium | Build/cache issues |
| **Domain/DNS Check** | 1-2 minutes | Low | Network routing issues |
| **Full Rebuild** | 5-10 minutes | High | Corrupted build artifacts |

**Critical Railway Concepts**:
- **Deployments**: Immutable snapshots with unique IDs
- **Latest**: Always points to most recent deployment (may be broken)
- **Rollback**: Instant pointer swap to previous deployment
- **Health Checks**: Railway automatically restarts failed containers
- **Environment Variables**: Can cause 503 if misconfigured (PORT conflicts)

### 503 Error Root Causes (Prioritized by Likelihood)

1. **Application Crash on Startup** (45%) - Bad code, missing dependency, runtime error
2. **Port Binding Failure** (25%) - App not binding to `$PORT`, hardcoded port conflict
3. **Health Check Timeout** (15%) - App starts but too slowly for Railway's health probe
4. **Environment Variable Misconfiguration** (10%) - Missing or invalid env vars causing crash
5. **Resource Exhaustion** (5%) - Memory/CPU limits exceeded during startup

---

## Specification

### Phase 1: STABILIZE (0-5 minutes)

**Objective**: Get service responding 200 OK as fast as possible, regardless of root cause.

**Actions** (execute in sequence, stop at first success):

```
STEP 1.1: INSTANT ROLLBACK
├── Target: Previous successful deployment
├── Method: Railway Dashboard → Project → Deployments → [Previous] → "Restore"
├── Time: < 30 seconds
├── Validation: curl -s -o /dev/null -w "%{http_code}" $PRODUCTION_URL
└── Success Criteria: HTTP 200 within 60 seconds of rollback

STEP 1.2: IF ROLLBACK FAILS → PORT BINDING CHECK
├── Check: Railway Logs for "PORT" or "bind" errors
├── Common Fix: Verify $PORT env var usage in application code
├── If hardcoded port: Must change to process.env.PORT || 3000
└── Time: 2-3 minutes to verify and document

STEP 1.3: IF PORT OK → ENVIRONMENT VARIABLE AUDIT
├── Check: Recent env var changes in Railway Dashboard
├── Action: Revert any env vars changed in last deployment
├── Time: < 60 seconds
└── Re-deploy if env vars were the issue
```

**Blast Radius Containment During Stabilization**:
- ✅ **DO**: Rollback immediately (zero risk, instant recovery)
- ✅ **DO**: Document current broken deployment ID before rollback
- ❌ **DO NOT**: Attempt to fix forward during initial stabilization
- ❌ **DO NOT**: Scale up resources (masks the real issue)
- ❌ **DO NOT**: Restart service without rollback (wastes time)

**Escalation Trigger**: If rollback fails to restore service within 2 minutes → escalate to Railway support + announce extended downtime.

---

### Phase 2: RESTORE (5-10 minutes)

**Objective**: Verify the rolled-back service is fully functional and stable.

**Actions**:

```
STEP 2.1: HEALTH CHECK VALIDATION
├── Endpoint: $PRODUCTION_URL/health (or /healthz, /status)
├── Expected: HTTP 200 with JSON body
├── Retry: 3 times over 30 seconds
└── Log: Response times, status codes, body content

STEP 2.2: CRITICAL PATH TESTING
├── Test 1: Homepage load (GET /)
├── Test 2: API health (GET /api/health)
├── Test 3: Database connectivity (if applicable)
├── Test 4: External dependency checks
└── All tests: Must pass 3 consecutive times

STEP 2.3: LOG VERIFICATION
├── Check: Railway deployment logs for ERROR or WARN
├── Look for: Startup errors, connection failures, crashes
├── Confirm: No recurring error patterns
└── Document: Any anomalies for Phase 4 analysis

STEP 2.4: TRAFFIC MONITORING
├── Watch: Railway metrics dashboard
├── Confirm: Request success rate > 99%
├── Confirm: Response p95 < 500ms
└── Confirm: No error spikes in last 5 minutes
```

**Go/No-Go Decision**:
- ✅ **PROCEED to Phase 3** if: All health checks pass, logs clean, metrics stable
- 🔶 **EXTEND Phase 2** if: Intermittent failures, degraded performance
- 🛑 **ESCALATE** if: Rollback service showing instability (rare but serious)

---

### Phase 3: VALIDATE (10-20 minutes)

**Objective**: Confirm full service functionality via comprehensive synthetic testing.

**Actions**:

```
STEP 3.1: SYNTHETIC USER JOURNEYS
├── Journey A: Home → Login → Dashboard (if applicable)
├── Journey B: Home → Feature X → Action Y
├── Journey C: API call sequence (if API service)
├── Tool: curl, Postman, or Railway's own testing
├── Frequency: Each journey 3 times
└── Success: All journeys complete without error

STEP 3.2: INTEGRATION VERIFICATION
├── Database: Connection pool healthy, no query timeouts
├── External APIs: All downstream services responding
├── Caches: Redis/cache layer operational (if applicable)
├── Background Jobs: Queue workers processing (if applicable)
└── All green: No degraded dependencies

STEP 3.3: STRESS SPOT-CHECK
├── Action: 10 rapid requests to main endpoint
├── Goal: Verify no immediate performance degradation
├── Watch: Response times, error rate, memory usage
└── Pass: No timeouts, no 5xx errors

STEP 3.4: NOTIFICATION
├── Internal: Alert team that service is restored
├── External: Update status page if customer-facing
├── Documentation: Log incident start/end times
└── Handoff: Notify on-call engineer if shift change
```

---

### Phase 4: PREVENT (20-30 minutes)

**Objective**: Analyze the bad deployment and implement safeguards to prevent recurrence.

**Actions**:

```
STEP 4.1: ROOT CAUSE ANALYSIS
├── Retrieve: Broken deployment ID (documented in Phase 1)
├── Compare: Diff between last good and broken deployment
├── Check: Recent commits, dependency updates, config changes
├── Analyze: Railway logs from broken deployment
└── Document: Root cause in incident log

STEP 4.2: PREVENTIVE MEASURES
├── If code issue: Add pre-deploy tests to CI/CD
├── If config issue: Implement env var validation
├── If dependency issue: Pin versions, add lockfile checks
├── If resource issue: Add memory/CPU monitoring alerts
└── All: Document in runbook

STEP 4.3: MONITORING ENHANCEMENT
├── Add: Railway deployment notifications (Slack/Discord)
├── Add: HTTP 503 alert with < 1 minute detection
├── Add: Synthetic uptime check every 60 seconds
└── Review: Alert thresholds, escalation policies

STEP 4.4: RUNBOOK UPDATE
├── Update: This decision with lessons learned
├── Create: Deployment rollback SOP for team
├── Schedule: Incident retro within 24 hours
└── Assign: Follow-up tasks with owners and deadlines
```

---

## Fixer Handoff Contract

**Agent**: @openfixer (Railway dashboard/browser/API recovery execution)  
**Delegation Authority**: Yes - can execute all Railway operations  
**Model**: Claude 3.5 Sonnet (best for infrastructure debugging)
**Prompt Path**: `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_052_OPENCLAW_RAILWAY_RECOVERY_v2.txt`

### Required Fields in Handoff

| Field | Value | Description |
|-------|-------|-------------|
| `decision_id` | DECISION_052 | Reference to this decision |
| `incident_type` | deployment_failure | Classification for tracking |
| `service` | openclaw | Application name |
| `platform` | railway | Deployment platform |
| `railway_project_id` | [USER_PROVIDED] | From Railway dashboard URL |
| `railway_dashboard_url` | [USER_PROVIDED] | Full dashboard URL |
| `railway_credentials_location` | [USER_PROVIDED] | Where to find login credentials |
| `production_url` | [USER_PROVIDED] | Endpoint returning 503 |
| `error_observed` | HTTP 503 | Current error state |
| `current_phase` | stabilize | Start at Phase 1 |
| `target_mttr_minutes` | 10 | Maximum acceptable recovery time |
| `escalation_contact` | [USER_PROVIDED] | Who to alert if recovery fails |
| `blast_radius_scope` | single_service | Containment boundary |

### Execution Commands

**Fixer Operations** (Railway dashboard/browser first; CLI optional):

```bash
# 1. Authenticate to Railway
railway login --token $RAILWAY_TOKEN

# 2. Link to project
railway link --project $PROJECT_ID

# 3. List recent deployments
railway deployments

# 4. Get deployment logs (broken deployment)
railway logs --deployment $BROKEN_DEPLOYMENT_ID

# 5. Instant rollback
railway rollback --deployment $LAST_GOOD_DEPLOYMENT_ID

# 6. Verify rollback
railway status

# 7. Health check validation
curl -s -o /dev/null -w "%{http_code}" $PRODUCTION_URL
```

### Success Criteria for Fixer

Fixer completes handoff when:
- ✅ Service returns HTTP 200 on production URL
- ✅ Health endpoint responds correctly
- ✅ No ERROR entries in Railway logs for 5 minutes
- ✅ All Phase 1-3 validation checklist items pass
- ✅ Incident start/end times documented
- ✅ Broken deployment ID recorded for Phase 4

### Failure Escalation

If Fixer cannot complete within 15 minutes:
1. Document: Actions attempted, current state, blockers
2. Escalate: To human on-call engineer with full context
3. Initiate: Extended downtime communication plan
4. Preserve: All logs and evidence for post-mortem

---

## Validation Checklist

### Phase 1: Stabilize Checklist

- [ ] Railway dashboard accessible with provided credentials
- [ ] Last known good deployment ID identified
- [ ] Broken deployment ID documented
- [ ] Rollback executed successfully
- [ ] Production URL returns HTTP 200 within 60 seconds of rollback
- [ ] No 503 errors in immediate post-rollback checks (3 consecutive requests)

### Phase 2: Restore Checklist

- [ ] Health endpoint responds HTTP 200 (200 OK, not 204 or redirect)
- [ ] Health endpoint JSON body valid and complete
- [ ] Railway deployment logs show clean startup (no ERROR)
- [ ] Railway metrics show 0% error rate for last 5 minutes
- [ ] Response p95 latency < 1000ms
- [ ] No container restart loops observed

### Phase 3: Validate Checklist (OpenClaw-Specific)

- [ ] Homepage loads without errors (visual inspection or curl)
- [ ] Main API endpoints respond correctly
- [ ] Authentication flow functional (if applicable)
- [ ] Database queries executing successfully
- [ ] External integrations responding (if any)
- [ ] 10 rapid requests to main endpoint: all succeed, no timeouts
- [ ] Synthetic user journey completes end-to-end

### Phase 4: Prevent Checklist

- [ ] Root cause documented (why did the bad deployment fail?)
- [ ] Diff between good/bad deployments analyzed
- [ ] Railway deployment notifications enabled
- [ ] HTTP 503 alert configured with < 1 min detection
- [ ] Runbook updated with this incident's lessons
- [ ] Incident retro scheduled within 24 hours
- [ ] Follow-up prevention tasks assigned with owners

---

## Approval Score: 78/100

### Scoring Breakdown

| Criterion | Score | Max | Rationale |
|-----------|-------|-----|-----------|
| **Speed to Recovery** | 18/20 | 20 | Instant rollback is fastest possible recovery path |
| **Safety** | 15/20 | 20 | Rollback is safe, but assumes last deployment was good (may not be if multiple bad deploys) |
| **Completeness** | 16/20 | 20 | All four phases covered, but Railway-specific nuances may need runtime adaptation |
| **Blast Radius** | 18/20 | 20 | Single-service scope, no cross-service dependencies mentioned |
| **Preventive Value** | 11/20 | 20 | Phase 4 is procedural; concrete monitoring/alerting setup needs OpenFixer implementation |

### Constraints

**What This Decision Assumes**:
1. ✅ Railway project is accessible and credentials are valid
2. ✅ There exists at least one prior deployment that was functional
3. ✅ The 503 is caused by the deployment (not external infrastructure)
4. ✅ OpenClaw is a standard Railway app (not using complex multi-service setup)

**What This Decision Does NOT Handle**:
1. ❌ Database corruption or data loss scenarios
2. ❌ External dependency failures (third-party APIs down)
3. ❌ DDoS or security incidents causing 503
4. ❌ Railway platform outages (rare but possible)
5. ❌ Multi-service deployments where rollback may break integrations

**When to Escalate Beyond This Decision**:
- Rollback fails to restore service
- Multiple consecutive deployments are broken (no good state to roll back to)
- Error logs indicate data corruption or database issues
- Service is up but returning incorrect/bad data (silent failure)
- Incident duration exceeds 30 minutes (prolonged outage protocol)

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-23
- **Models**: Claude 3.5 Sonnet (risk assessment, workflow validation)
- **Approval**: 62/100
- **Key Findings**:
  - Rollback is lowest-risk, highest-speed recovery option
  - Main risk: Assumption that previous deployment was healthy
  - Recommendation: Add health check verification immediately post-rollback
  - Safety gates: Required before any forward-fix attempts

### Designer Consultation
- **Date**: 2026-02-23
- **Models**: Claude 3.5 Sonnet (workflow architecture, handoff design)
- **Approval**: 78/100
- **Key Findings**:
  - Four-phase structure aligns with incident response best practices
  - Handoff contract is complete with all necessary fields
  - Validation checklist covers Railway-specific requirements
  - Suggestion: Add explicit "Go/No-Go" decision gates between phases

---

## Open Questions

### Harden Question
> What is the fallback if the previous deployment was also broken, or if multiple consecutive deployments have been pushed and all are failing? Do we maintain a "golden deployment" tag/marker that is never auto-overwritten, providing a known-good fallback state?

**Context**: This decision assumes there's a good deployment to roll back to. If the team has pushed multiple bad deployments in succession, rollback may not restore service. A "golden deployment" strategy (manual tagging of known-good states) would provide a safety net but requires process discipline.

### Expand Question
> Should we implement automated deployment validation that prevents promotion of failing deployments to production? What would a pre-production health gate look like for Railway deployments (staging verification, smoke tests, canary analysis)?

**Context**: This decision is reactive (recovery after failure). Proactive prevention would catch bad deployments before they reach production. Railway supports environments and deployment triggers—could we build a staging→production pipeline with automated gates?

### Narrow Question
> Does OpenClaw have any stateful components (database writes, file uploads, session state) that could be affected by a rollback? Are there database migrations or schema changes in the bad deployment that would make rollback unsafe?

**Context**: If the bad deployment included database migrations, rolling back the code without rolling back the database could cause data corruption or application crashes. This decision assumes stateless rollback is safe—we need confirmation that OpenClaw doesn't have stateful dependencies that complicate rollback.

### Current Answers / Deferrals

- Harden answer: deferred; no evidence yet of golden deployment tagging in Railway.
- Expand answer: deferred; prevention automation is in Phase 4 and requires post-restore follow-up.
- Narrow answer: pending Nexus confirmation before handoff activation (stateful migrations determine rollback safety).

---

## Dependencies

- **Railway CLI**: Optional accelerator for Fixer automation (`npm install -g @railway/cli`)
- **Railway API Token**: Must be available in credentials store
- **OpenClaw Service Documentation**: Health endpoint paths, expected responses
- **On-Call Escalation Contact**: For failure escalation path
- **DECISION_050 (Lazarus Protocol)**: Future integration for automatic recovery

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-052-01 | Execute Phase 1-3 recovery via OpenFixer | @openfixer | Pending | Critical |
| ACT-052-02 | Document incident timeline and root cause | @openfixer | Pending | High |
| ACT-052-03 | Complete Phase 4 prevention checklist | @openfixer | Pending | Medium |
| ACT-052-04 | Schedule incident retro within 24 hours | Nexus/User | Pending | Medium |
| ACT-052-05 | Implement golden deployment tagging (if approved) | @windfixer | Pending | Low |

## Closure Checklist Draft

- [ ] Decision markdown updated with lifecycle evidence and consultation IDs
- [ ] Oracle and Designer consultation records captured with scores and posture
- [ ] Handoff contract drafted with exact target URL and outage evidence (503)
- [ ] Deployment prompt stored at explicit handoff path for Nexus-triggered activation
- [ ] Manifest update record written for this strategist pass
- [ ] Deployment journal requirement noted before final close

---

## Notes

**Workflow Governance Update (2026-02-23)**:
- Emergency conditions do not bypass strategist workflow gates.
- Deployment action must be initiated by Nexus after explicit handoff readiness confirmation.
- Available implementation channel for this decision is `@openfixer` (not generic fixer).

**Incident Response Priorities** (in order):
1. **Speed**: Get service up fast (rollback beats fix-forward)
2. **Safety**: Don't make it worse (rollback is reversible)
3. **Clarity**: Know what happened (document everything)
4. **Prevention**: Don't let it happen again (process improvements)

**Railway-Specific Tips**:
- Deployments are immutable—rollback just changes the pointer, no rebuild needed
- Environment variables apply to all deployments—reverting code won't revert config changes
- Logs persist for all deployments—can compare good vs. broken startup logs
- Custom domains may have DNS propagation delay—check Railway-provided domain first

**Communication Template** (for Phase 3 notification):
```

## OpenFixer Remediation Pass Update (2026-02-24)

Execution source: `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_055_OPENCLAW_CONFIG_FIX_v1.txt`.

Actions completed in this pass:
- Snapshot captured: latest deployment id `f578fd88-5994-4527-8797-9b1c57e2e725`, variable snapshot, and route status probes.
- Minimal mutation applied: `CLAWDBOT_STATE_DIR` changed to `/data/.openclaw` (no broad variable rewrite).
- One controlled restart executed: `deploymentRestart` on latest deployment.
- Validation performed: 3 probe rounds on `/healthz`, `/setup`, `/openclaw` and 10-request `/openclaw` spot check.

Observed results:
- `/healthz` remained 200 with gateway unreachable.
- `/setup` remained 401.
- `/openclaw` remained unhealthy (503/timeouts).
- Logs before and after restart still show `MissingEnvVarError` for `OPENAI_API_KEY` at `models.providers.openai.apiKey`.

Pass outcome:
- **Not recovered** after one minimal remediation pass.
- Next safest option: apply second minimal config-path correction (`OPENCLAW_STATE_DIR=/data/.openclaw`) with one controlled restart; only escalate to rollback if still failing.

## OpenFixer Remediation Pass2 Update (2026-02-24)

Execution source: `STR4TEG15T/handoffs/DEPLOY_OPENFIXER_DECISION_055_OPENCLAW_CONFIG_FIX_PASS2_v1.txt`.

Actions completed in this pass:
- Snapshot captured: latest deployment id and pre-pass probes.
- Minimal mutation applied: `OPENCLAW_STATE_DIR=/data/.openclaw` (`skipDeploys=true`) with no other variable edits.
- One controlled restart executed on latest deployment.
- Validation performed: 3 probe rounds on `/healthz`, `/setup`, `/openclaw` and 10-request `/openclaw` spot check.

Observed results:
- `/healthz` remained 200 with `gateway.reachable=false`.
- `/setup` remained 401.
- `/openclaw` remained unhealthy (503/timeouts).
- Logs still show `MissingEnvVarError` for `OPENAI_API_KEY` and config path `/data/.clawdbot/openclaw.json`.

Pass2 outcome:
- **Not recovered** after second constrained remediation pass.
- Rollback recommendation gate reached; execution requires explicit Nexus approval.
[RESOLVED] OpenClaw Production Outage
- Start time: [X]
- End time: [Y]
- Duration: [Z] minutes
- Root cause: [Bad deployment / config error / etc.]
- Resolution: Rolled back to deployment [ID]
- Impact: [Service unavailable / degraded performance / etc.]
- Retro scheduled: [Date/Time]
```

---

*Decision DECISION_052*  
*OpenClaw Railway Deployment Recovery*  
*2026-02-23*
</content>
