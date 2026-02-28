# Deployment Journal: DECISION_140 OpenClaw Webpage + Bible + Gateway Continuity

Date: 2026-02-25
Decision: `DECISION_140`
Related Decisions: `DECISION_136`, `DECISION_137`, `DECISION_138`, `DECISION_139`

## Source-Check Order Evidence

1. Decisions first: reviewed `DECISION_140` plus historical chain `136-139`.
2. Knowledgebase second: reviewed `OP3NF1XER/knowledge/DECISION_139_OPENCLAW_DELIVERABLE_COMPLETENESS_2026_02_25.md`.
3. Patterns second: reviewed `OP3NF1XER/patterns/RAILWAY_DEPLOY_PREFLIGHT_AND_ROUTE_PROBE.md` and `OP3NF1XER/patterns/WORKFLOW_IMPLEMENTATION_PARITY_AUDIT.md`.
4. Local discovery third: audited deployment repo paths and runtime wrapper behavior in `_tmpbuild/clawdbot-railway-template`.
5. Web search fourth: not required.

## Deterministic Takeover Control Notes

- Stabilize: captured live Railway auth/status and current deployment id before edits.
- Diagnose: confirmed `/textbook/` 404 cause was missing doctrine bundle in image and route root mismatch; confirmed gateway auth continuity risk where Basic auth header prevented Bearer injection.
- Remediate: patched wrapper route resolution, token header override, and Docker image copy paths; patched portal and manifest visibility.
- Verify: redeployed and reran authenticated route/body probes plus websocket upgrade probe.
- Harden: recorded parity and reusable learning in knowledge memory.

## File-Level Diff Summary

- `C:/P4NTH30N/_tmpbuild/clawdbot-railway-template/src/server.js`
  - Added deterministic textbook root/site resolution across workspace + image paths.
  - Added explicit `/textbook/` handling and `p4nthe0n-openfixer` artifact route.
  - Changed gateway auth injection to always set Bearer token for proxied HTTP/WS while preserving incoming dashboard auth in `x-openclaw-dashboard-authorization` for traceability.
- `C:/P4NTH30N/_tmpbuild/clawdbot-railway-template/Dockerfile`
  - Added doctrine+bible payload copy into runtime image (`memory/doctrine-bible`, `memory/p4nthe0n-openfixer`).
- `C:/P4NTH30N/_tmpbuild/clawdbot-railway-template/memory/doctrine-bible/site/index.html`
  - Added explicit bible references and clickable links for canonical bible + delivery mirror.
- `C:/P4NTH30N/_tmpbuild/clawdbot-railway-template/memory/doctrine-bible/README.md`
  - Added `memory/p4nthe0n-openfixer` doctrine source references.
- `C:/P4NTH30N/_tmpbuild/clawdbot-railway-template/memory/p4nthe0n-openfixer/OPENCLAW_DELIVERY_MANIFEST_2026-02-25.md`
  - Added explicit `memory/p4nthe0n-openfixer` bible/textbook entries in doctrine package list.

## Commands Run

- `node -c src/server.js`
- `node --test`
- `railway whoami`
- `railway status --json`
- `railway up --detach`
- `curl -i https://clawdbot-railway-template-production-461f.up.railway.app/healthz`
- `curl -i -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/textbook/`
- `curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/textbook/ | grep -i "Nate Doctrine Textbook Portal"`
- `curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/textbook/ | grep -Ei "AI_BIBLE|bible"`
- `curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/setup/api/debug`
- `curl -i -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/openclaw`
- `curl --max-time 10 -i -u ":$SETUP_PASSWORD" -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Sec-WebSocket-Version: 13" -H "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==" https://clawdbot-railway-template-production-461f.up.railway.app/openclaw`

## Verification Results

- Textbook portal body visible under auth at `/textbook/`: `PASS`.
- Portal body contains bible references and links: `PASS`.
- Bible artifacts retrievable (`/textbook/bible/...` and `/textbook/p4nthe0n-openfixer/...`): `PASS`.
- Gateway continuity from wrapper to proxied websocket path validated by `101 Switching Protocols` + `connect.challenge` event: `PASS`.
- Railway deploy status: `b50cb6c8-bd82-4628-9297-f38643f96fdc` = `SUCCESS`.

## Decision Parity Matrix (Requirement-by-Requirement)

- Patch `/textbook/` route behavior (serve portal, avoid SPA fallback): **PASS**
- Surface bible references/links and path visibility in portal: **PASS**
- Verify bible artifact integrity/presence and manifest references: **PASS**
- Resolve gateway token continuity for normal authenticated use: **PASS**
- Deploy to Railway and return runtime evidence: **PASS**

## Deployment Usage Guidance

- Access textbook portal: `/textbook/` (dashboard auth required).
- Canonical bible link in portal: `/textbook/bible/AI_BIBLE_v3_AGENT_INDEXED.md`.
- Delivery mirror bible link in portal: `/textbook/p4nthe0n-openfixer/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md`.
- Debug path for continuity: `/setup/api/debug`.

## Triage and Repair Runbook

- Detect: `/textbook/` returns 404 or Control UI throws token-missing/unauthorized.
- Diagnose:
  - Check `railway status --json` for latest deployment id/status.
  - Probe `/textbook/` and grep for portal title + bible markers.
  - Probe websocket upgrade (expect `101 Switching Protocols`).
- Recover:
  - Ensure Docker image includes doctrine directories via Dockerfile `COPY` lines.
  - Ensure wrapper always injects gateway Bearer token before proxying.
  - Redeploy with `railway up --detach`.
- Verify:
  - Re-run health + textbook + grep + debug probes.
  - Re-run websocket upgrade probe and confirm challenge event.

## Decision Lifecycle

- Decision state on entry: `HandoffReady` (`DECISION_140`).
- Decision implementation state this pass: `Updated` with deployed evidence in this journal.
- Closure recommendation: `Close`.

## Completeness Recommendation Section

- Status: `Implemented`.
- Notes: all non-negotiable components (textbook webpage and bible visibility) are now live and evidenced.

## Audit Results

- All requirements audited `PASS` with evidence paths in this journal and runtime command outputs.

## Re-Audit Results

- Trigger: operator reported setup visibility failure after initial close evidence.
- Remediation deployment: `fab3abac-58e9-4615-9003-05ffd8af31a2` (`SUCCESS`).
- Added password login page + session cookie auth path for `/setup` and dashboard routes.
- Evidence:
  - `curl -i https://clawdbot-railway-template-production-461f.up.railway.app/setup` -> `401` with HTML login form body (not blank auth text only).
  - `curl -i -d "password=...&next=/setup" -H "Content-Type: application/x-www-form-urlencoded" https://clawdbot-railway-template-production-461f.up.railway.app/setup/auth/login` -> `302` + `Set-Cookie: openclaw_dashboard_auth=...`.
  - `curl -v -b cookie.txt https://clawdbot-railway-template-production-461f.up.railway.app/setup` -> `200` setup UI body.
- Re-audit matrix:
  - Setup entrypoint visible for operator without browser basic-auth ambiguity: **PASS**
  - Existing textbook+bible visibility path preserved: **PASS**
  - Gateway token continuity path preserved: **PASS**
