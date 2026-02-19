# Designer Review: All Pending Implementation Decisions

**Date:** 2026-02-18
**Status:** DESIGNER FEEDBACK COMPLETE

---

## Summary

Designer provided implementation plans for all 6 pending production decisions:
- PROD-001 through PROD-005 (Production readiness)
- STRATEGY-011 (Delegation rule updates)

All plans include research findings, architecture proposals, phased build guides, and parallel workstreams.

---

## PROD-001: Production Readiness Verification Checklist

### Designer Approval: Ready for Implementation

**Research Findings:**
Production readiness checklist should cover: Build & Deployment, Database (MongoDB), Configuration, Security, Logging & Monitoring, Error Handling, Performance, and Operational Procedures.

**Architecture:**
Markdown-based verification in `T4CT1CS/prod-readiness/` with YAML frontmatter. Each section: Verification Item → Test Method → Pass/Fail Status → Evidence. Store completed checklists in `T4CT1CS/audit/production-readiness/`.

**Build Guide:**
- Day 1: Infrastructure & Security (build verification, MongoDB connectivity, security audit)
- Day 2: Operational Procedures & Performance (rollback docs, runbooks, performance baselines)
- Day 3: Final Validation & Sign-off (smoke tests, exception review, sign-off)

**Parallel Workstreams:**
- Stream A: Build + DB validation (parallel)
- Stream B: Runbooks + performance (parallel)
- Stream C: Smoke tests (depends on A+B)

**Oracle Questions:**
- Auto-validation via CI/CD or manual sign-off only?
- Which INFRA decisions require deeper verification?

---

## PROD-002: Workflow Automation Implementation - Phase 1

### Designer Approval: Conditional (Requires Architecture Change)

**Critical Finding:**
Designer cannot delegate to Explorer/Librarian under current rules (designer→oracle only). Must use **Orchestrator-Mediated Parallel Delegation**.

**Architecture:**
1. Designer → Orchestrator (allowed): Packages research briefs
2. Orchestrator → Explorer + Librarian (allowed): Executes parallel tasks
3. Context Packaging: Structured JSON with parallel task slots, success criteria, merge instructions

**Build Guide:**
- Phase 1: Context Packaging Standard (ResearchBrief schema, Designer prompt update)
- Phase 2: Orchestrator Integration (parallel handler, result aggregation)
- Phase 3: Safe Parallel Execution (timeout boundaries, circuit breakers, result merge)

**Parallel Workstreams:**
- Stream A: Tasks 1-2 (Context packaging)
- Stream B: Tasks 3-4 (Orchestrator integration)
- Stream C: Task 5 (Safety) parallel to B
- Validation: Task 6 after all streams

**Oracle Questions:**
- Accept Orchestrator mediation for parallel delegation?
- Static or dynamic research brief templates?
- Timeout duration recommendation (60s default)?

---

## PROD-003: End-to-End Integration Testing Suite

### Designer Approval: Ready for Implementation

**Research Findings:**
- **Framework:** xUnit + Testcontainers.MongoDB (containerized MongoDB for CI/CD)
- **Browser Automation:** PlaywrightSharp (modern, faster than Selenium)
- **Mock Casino:** ASP.NET Core test host for lightweight HTTP mocking

**Architecture:**
```
T35T/
├── Fixtures/ (MongoDbFixture, MockCasinoFixture)
├── H0UND/ (DPD calculation, jackpot forecast tests)
├── H4ND/ (Login action, spin action tests)
├── Integration/ (Signal-to-action pipeline tests)
└── MockCasino/ (MockCasinoServer, GameResponses/)
```

**Build Guide (Days 1-7):**
| Day | Focus | Deliverable |
|-----|-------|-------------|
| 1 | Infrastructure | xUnit project, Testcontainers config |
| 2 | H0UND Tests | DPD calculation, jackpot forecast |
| 3 | H4ND Tests | Login action, game state machine |
| 4 | Mock Casino | HTTP mock server, endpoint responses |
| 5 | Integration Tests | H0UND→SIGN4L→H4ND pipeline |
| 6 | MongoDB Tests | Repository CRUD, collection integrity |
| 7 | CI/CD | GitHub Actions workflow |

**Parallel Workstreams:**
- Stream A: Mock casino + H4ND tests (Day 1 start)
- Stream B: xUnit infrastructure + H0UND tests (Day 1 start)
- Stream C: Integration tests (Day 5, depends on A+B)

**Oracle Questions:**
- Test project location: `T35T/` vs `UNI7T35T/`?
- Containerized MongoDB acceptable for CI?
- Prioritize H0UND analytics vs H4ND automation tests?

---

## PROD-004: Operational Documentation and Knowledge Base

### Designer Approval: Ready for Implementation

**Research Findings:**
Agentic systems need documentation that mirrors agent boundaries. Separate "how it works" (architecture) from "how to operate it" (runbooks) from "what when X fails" (troubleshooting). Use front-matter metadata for automation.

**Architecture:**
```
docs/
├── architecture/ (System design, ADRs, data flows)
├── components/ (Agent manifests with behavior)
├── runbooks/ (Step-by-step with success criteria)
├── troubleshooting/ (Symptom-first resolution)
├── api-reference/ (Interface contracts)
├── decisions/ (Decision logs with WHY)
└── procedures/ (Emergency response)
```

**Build Guide:**
- Day 1: Audit & Structure (inventory, metadata, templates)
- Day 2: Agent Manifests (H0UND/H4ND behavior docs)
- Day 3: Operational Procedures (startup/shutdown runbooks, troubleshooting trees)
- Day 4: Sync Automation (CI validation, sync scripts)

**Synchronization Strategy:**
1. Documentation lives alongside code in version control
2. Add "doc sync" check to Cartography workflow
3. Each AGENTS.md includes "Documentation checklist"
4. Inline XML documentation generates reference docs

**Oracle Questions:**
- Include rejected alternatives in decision logs?
- Acceptable staleness window (suggest 30 days)?
- Who owns runbook sign-off (Operations lead or senior Fixer)?

---

## PROD-005: Monitoring Dashboard and Alerting Deployment

### Designer Approval: Ready for Implementation

**Research Findings:**
Use **Prometheus** (metrics) + **Grafana** (visualization). Export metrics via `/metrics` HTTP endpoint using `prometheus-net` package. Query MongoDB ERR0R/EV3NT collections directly in Grafana.

**Critical Metrics:**
- **H0UND:** Poll success/failure, circuit breaker state, DPD latency, signal count, balance retrieval latency (p50/p95/p99)
- **H4ND:** Signal processing time, spin execution time, login success rate, ChromeDriver restarts, validation error rate

**Build Guide:**
- Day 1: prometheus-net integration + `/metrics` endpoint
- Day 2: Prometheus/Grafana container deployment + dashboards
- Day 3: Alerting rules + notifications + MongoDB query alerts
- Day 4: Threshold tuning + documentation + operator training

**Alert Thresholds:**
- **Critical (P1):** Circuit breaker open > 2min → Page; Validation errors > 10/min → 5min alert
- **Warning (P2):** Degradation elevated > 10min → Slack; Signal latency p95 > 30s → 15min alert
- **Info (P3):** Poll failure > 5% → Dashboard; ChromeDriver restarts > 3/hour → Track

**Escalation:** P1 pages primary (5min timeout) → secondary after 10min; P2 to Slack #ops (15min ack); P3 logged for daily review.

**Oracle Questions:**
- Acceptable alert noise levels (false positive tolerance)?
- Validate escalation chain contacts and channels?

---

## STRATEGY-011: Delegation Rule Updates

### Designer Approval: Ready for Implementation

**Exact Change Required:**
**File:** `src/config/constants.ts`

```typescript
// Current:
designer: ['oracle']

// Target:
designer: ['oracle', 'explorer', 'librarian']
```

**Safety Considerations:**
- Principle of Least Privilege: Adds research capability, aligns with existing opencode.json permissions
- No Breaking Changes: Only adds delegation paths, doesn't remove existing ones
- Previous vulnerability fixed: AGENTS.md notes hardcoded rules now match user-defined permissions

**Build & Deploy:**
```bash
# 1. Edit src/config/constants.ts
# 2. Build: bun run build
# 3. Deploy: cp -f dist/* C:\Users\paulc\.cache\opencode\node_modules\oh-my-opencode-theseus\
# 4. Restart OpenCode
```

**Testing Strategy:**
- Unit: Verify SUBAGENT_DELEGATION_RULES.designer includes 'explorer' and 'librarian'
- Integration: Task Designer to delegate to Explorer (should succeed)
- Regression: Verify Designer→Oracle still works

**Oracle Questions:**
- Any additional security review needed for Designer→Librarian?
- Does this align with strategic intent for STRATEGY-007, 008, 009?

---

## Implementation Priority

**Phase 1 (Critical - Unblocks Others):**
1. STRATEGY-011: Delegation Rule Updates

**Phase 2 (High Priority - Production Ready):**
2. PROD-001: Production Readiness Checklist
3. PROD-005: Monitoring Dashboard

**Phase 3 (Medium Priority - Quality & Documentation):**
4. PROD-003: Integration Testing Suite
5. PROD-004: Operational Documentation

**Phase 4 (Conditional - Requires Phase 1):**
6. PROD-002: Workflow Automation (blocked until STRATEGY-011 complete)

---

## Next Steps

1. **Execute STRATEGY-011** via Fixer to unblock Designer→Explorer/Librarian
2. **Consult Oracle** on each PROD decision's open questions
3. **Prioritize Phase 2** decisions for production readiness
4. **Defer PROD-002** until delegation rules updated and tested

**All decisions have actionable implementation plans ready for Fixer execution.**
