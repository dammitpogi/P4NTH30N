# HANDOFF: DECISION_140 OpenClaw Webpage + Bible Visibility and Gateway Token Continuity

## Owner

- Primary implementation owner: `OpenFixer`
- Mode: `Deployment`

## Mission

Close the two critical deliverable gaps reported by Nexus:

1. A verifiable textbook webpage route users can actually load.
2. A verifiable bible artifact that is discoverable from the deployed experience.

Additionally, resolve the runtime continuity symptom:

- `disconnected (1008): unauthorized: gateway token missing (open the dashboard URL and paste the token in Control UI settings)`

## Required File Targets (Deployment Repo)

- `src/server.js`
- `memory/doctrine-bible/site/index.html`
- `memory/doctrine-bible/README.md`
- `memory/p4nthe0n-openfixer/OPENCLAW_DELIVERY_MANIFEST_2026-02-25.md`
- `memory/p4nthe0n-openfixer/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md`

## Implementation Contract

1. Ensure `/textbook/` route serves textbook portal content after dashboard auth and is not shadowing to SPA shell.
2. Ensure textbook portal has explicit bible visibility link(s) and file path references.
3. Ensure gateway token continuity is deterministic across restart/deploy and Control UI websocket session can connect without 1008 unauthorized.
4. Keep setup/dashboard auth protections in place (no accidental public exposure of protected control plane).
5. Produce deployment evidence proving webpage+bible visibility and token continuity.

## Mandatory Validation Commands

Run and include raw output for each command below:

- `git status --short`
- `git diff --stat`
- `railway status --json`
- `railway whoami`
- `curl -i https://clawdbot-railway-template-production-461f.up.railway.app/healthz`
- `curl -i -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/textbook/`
- `curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/textbook/ | grep -i "Nate Doctrine Textbook Portal"`
- `curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/textbook/ | grep -Ei "AI_BIBLE|bible"`
- `curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/setup/api/debug`

## Success Gates (Must All Pass)

1. `textbook route`: body includes `Nate Doctrine Textbook Portal`.
2. `bible visibility`: body includes explicit bible reference and path.
3. `runtime continuity`: no active 1008 unauthorized token-missing disconnect on Control UI session.
4. `deployment evidence`: Railway deployment id reported as success.

## Failure Modes and Fallbacks

- If Railway auth unavailable:
  - capture `railway whoami` output,
  - complete all local file and local route checks,
  - return blocker as `PARTIAL` with exact missing credential/session requirement.
- If `/textbook/` still loads SPA shell:
  - treat as `FAIL`, do not close,
  - provide route mismatch root cause and patch diff.
- If token disconnect persists:
  - capture setup debug payload and wrapper token path evidence,
  - provide deterministic repair steps and re-run probes.

## Completion Evidence Back to Strategist

1. Commit hash(es) and changed-file list.
2. Railway deploy id and status output.
3. Endpoint probe outputs proving textbook+bible visibility.
4. Explicit statement whether 1008 unauthorized was eliminated.

## Copy-Paste Prompt for OpenFixer

```text
OpenFixer, execute DECISION_140 now. No planning mode. Deliver and verify.

Context:
- Nexus reports critical gap: cannot see webpage or bible.
- Runtime symptom: disconnected (1008): unauthorized: gateway token missing.
- Two components are non-negotiable: textbook webpage + bible visibility.

Do this in one deployment pass:
1) Patch and verify textbook route behavior in deployment repo (`src/server.js`) so `/textbook/` serves textbook portal content after auth and not SPA shell fallback.
2) Ensure textbook portal (`memory/doctrine-bible/site/index.html`) explicitly surfaces bible references/links and path visibility.
3) Verify bible artifact integrity/presence (`memory/p4nthe0n-openfixer/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md`) and manifest references.
4) Resolve gateway token continuity so Control UI no longer throws 1008 unauthorized token-missing in normal authenticated usage.
5) Deploy to Railway and return hard evidence only.

Run and return raw outputs:
- git status --short
- git diff --stat
- railway whoami
- railway status --json
- curl -i https://clawdbot-railway-template-production-461f.up.railway.app/healthz
- curl -i -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/textbook/
- curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/textbook/ | grep -i "Nate Doctrine Textbook Portal"
- curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/textbook/ | grep -Ei "AI_BIBLE|bible"
- curl -sS -u ":$SETUP_PASSWORD" https://clawdbot-railway-template-production-461f.up.railway.app/setup/api/debug

Success criteria:
- Textbook webpage visible and body-verified.
- Bible visible and linked from textbook portal.
- 1008 unauthorized token-missing issue resolved.
- Railway deployment id + status returned.

If Railway auth is blocked, do not fake completion. Return PARTIAL with exact blocker and local proof.
```
