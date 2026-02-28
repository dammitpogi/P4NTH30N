# Deployment Journal: DECISION_137 OpenClaw Delivery (Pass 2)

Date: 2026-02-24
Decision: `DECISION_137`
Related Decisions: `DECISION_052`, `DECISION_053`, `DECISION_054`, `DECISION_055`

## Source-Check Order Evidence

1. Decisions first: `STR4TEG15T/memory/decisions/DECISION_137_NATE_SUBSTACK_TEACHINGS_CAPTURE_AND_SEARCH.md`.
2. Knowledge/patterns second: `OP3NF1XER/knowledge/DECISION_137_OPENCLAW_DELIVERY_LEARNINGS_2026_02_24.md`, `OP3NF1XER/patterns/SOURCE_CHECK_ORDER.md`, `OP3NF1XER/patterns/WORKFLOW_IMPLEMENTATION_PARITY_AUDIT.md`.
3. Local discovery third: workspace git state, doctrine/endpoint skill files, live endpoint responses.
4. Web search fourth: not required in this pass.

## File-Level Diff Summary

- Updated endpoint probe to classify textbook route body (`textbook-static` vs `openclaw-spa-shell`) in `STR4TEG15T/tools/workspace/skills/openclaw-endpoint-kit/scripts/endpoint_probe.py`.
- Updated endpoint skill contract with route-kind semantics in `STR4TEG15T/tools/workspace/skills/openclaw-endpoint-kit/SKILL.md`.
- Updated textbook deployment plan with route-kind verification step in `STR4TEG15T/tools/workspace/memory/doctrine-bible/site/DEPLOYMENT.md`.
- Added reusable deploy governance pattern in `OP3NF1XER/patterns/RAILWAY_DEPLOY_PREFLIGHT_AND_ROUTE_PROBE.md`.
- Updated DECISION_137 learning artifact and query anchors in `OP3NF1XER/knowledge/DECISION_137_OPENCLAW_DELIVERY_LEARNINGS_2026_02_24.md`.
- Updated quick index in `OP3NF1XER/knowledge/QUICK_QUERY_INDEX.md`.

## Commands Run

- `python skills/doctrine-engine/scripts/rebuild_index.py`
- `python skills/doctrine-engine/scripts/search_bible.py --query "fomc pivot invalidation" --top 5`
- `python skills/doctrine-engine/scripts/cite_doctrine.py --doc bible-v3 --query "event pressure" --max 3`
- `python skills/doctrine-engine/scripts/query_decision_engine.py --query "railway auth token" --top 5`
- `python skills/openclaw-endpoint-kit/scripts/endpoint_probe.py --base "https://clawdbot-railway-template-production-461f.up.railway.app"`
- `railway whoami`
- `curl -s -o /dev/null -w "%{http_code} %{url_effective}\n" "https://clawdbot-railway-template-production-461f.up.railway.app/healthz"`
- `curl -s -o /dev/null -w "%{http_code} %{url_effective}\n" "https://clawdbot-railway-template-production-461f.up.railway.app/openclaw"`
- `curl -s -o /dev/null -w "%{http_code} %{url_effective}\n" "https://clawdbot-railway-template-production-461f.up.railway.app/textbook/"`
- `curl -s "https://clawdbot-railway-template-production-461f.up.railway.app/textbook/"`
- `node --check tools/substack-scraper/post-auth-capture.js`

## Verification Results

- Doctrine index/search/cite/query scripts: `PASS` (returned ranked results and line citations).
- Endpoint probe: `PASS` for execution and route bundle output.
- `railway whoami`: `FAIL` (`Unauthorized. Please login with railway login`).
- HTTP checks: `PASS` (`/healthz=200`, `/openclaw=200`, `/textbook/=200`).
- Textbook body check: `PARTIAL` (`/textbook/` currently serves `OpenClaw Control` SPA shell).
- Substack post-auth capture script syntax: `PASS`.

## Decision Parity Matrix

- Integrate doctrine retrieval and citation tooling in workspace: **PASS**
- Add endpoint validation kit for operator handoff: **PASS**
- Validate Railway auth/session for deployment continuation: **PARTIAL** (missing active auth session)
- Validate textbook exposure path behavior: **PARTIAL** (`/textbook/` route returns control UI shell)
- Record governance write-back in OP3NF1XER knowledge/patterns: **PASS**

## Triage and Repair Runbook

- Detect: `railway whoami` unauthorized or `/textbook/` route kind = `openclaw-spa-shell`.
- Diagnose:
  - Auth blocker -> no active CLI session/token.
  - Route blocker -> static route mapping not wired to textbook site bundle.
- Recover:
  1. Authenticate (`railway login` or set valid `RAILWAY_TOKEN`/`RAILWAY_API_TOKEN`).
  2. Ensure project/service linkage (`railway link`, `railway status`).
  3. Deploy route mapping for textbook static bundle and redeploy.
  4. Re-run endpoint probe and confirm `textbookCheck.routeKind == textbook-static`.
- Verify: rerun full command set in this journal and confirm both blocker classes clear.

## Audit Results

- Requested outcome: continue implementation and harden delivery surface -> **PASS**
- Requested outcome: deploy completion on Railway -> **PARTIAL** (auth session unavailable)
- Requested outcome: textbook/doctrine route exposure verification -> **PARTIAL** (body classification indicates SPA shell)

## Re-Audit Results (After In-Pass Self-Fix)

- Self-fix applied: added route-kind body classification to endpoint probe and updated docs/patterns -> **PASS**
- Re-verify textbook detection quality: now explicitly reports `openclaw-spa-shell` when mapping is wrong -> **PASS**
- Deployment auth state after remediation: still blocked pending valid Railway auth -> **PARTIAL** (Owner: Nexus)

## Decision Lifecycle

- Decision updated: `STR4TEG15T/memory/decisions/DECISION_137_NATE_SUBSTACK_TEACHINGS_CAPTURE_AND_SEARCH.md` (pass-2 section added in this pass).
- Journal created: this file.
- Closure state: `Iterate`.

## Completeness Recommendation

- Implemented now:
  - Doctrine and endpoint hardening updates.
  - Governance write-back and reusable pattern promotion.
- Deferred (blocked): final Railway deploy and textbook static route activation.
  - Owner: Nexus (provide active Railway auth session/token in current runtime).
