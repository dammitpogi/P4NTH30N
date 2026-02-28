# JOURNAL_2026-02-24_DECISION_144_RAILWAY_LOCALIZATION_SSH_PREFLIGHT

## Decision

- `DECISION_144`

## Scope

- Localize Railway template for owner-controlled edits and preconfigure SSH access only.
- Roll back the newly created Railway project on owner pivot.

## Decision Parity Matrix

- R1 Roll back active Railway creation state -> **PASS**
- R2 Keep template local-only and editable -> **PASS**
- R3 Preconfigure SSH client integration and preflight -> **PASS**
- R4 Capture governance + learning evidence -> **PASS**

## File-Level Diff Summary

- Updated `OP3NF1XER/nate-alma/deploy/Dockerfile` to include `openssh-client`.
- Updated `OP3NF1XER/nate-alma/deploy/package.json` with `ssh:probe` script and localized package name.
- Updated `OP3NF1XER/nate-alma/deploy/README.md` and `OP3NF1XER/nate-alma/deploy/CONTRIBUTING.md` for local-owned workflow.
- Added `OP3NF1XER/nate-alma/deploy/scripts/railway-ssh-probe.sh`.
- Added `OP3NF1XER/nate-alma/deploy/ops/ssh/ssh_config.template`.
- Added `OP3NF1XER/nate-alma/deploy/ops/ssh/README.md`.
- Added `OP3NF1XER/nate-alma/deploy/ops/railway-target.json`.
- Removed inherited metadata and automation:
  - `.git/`
  - `.github/workflows/docker-build.yml`
  - `.github/workflows/bump-openclaw-ref.yml`
  - `scripts/bump-openclaw-ref.mjs`

## Deployment Usage Guidance

1. Set SSH variables (`RAILWAY_SSH_HOST`, `RAILWAY_SSH_PORT`, `RAILWAY_SSH_USER`, `RAILWAY_SSH_KEY_PATH`).
2. Run `npm run ssh:probe` from template root.
3. Keep Railway deploy paused until additional local changes are complete.

## Triage and Repair Runbook

- Detect: `npm run ssh:probe` fails.
- Diagnose:
  - check missing env vars,
  - check key path exists,
  - check local `ssh` in PATH.
- Recover:
  - fix env/key/path,
  - rerun `npm run ssh:probe`.
- Verify:
  - probe returns `railway ssh probe ok`.

## Validation Commands + Results

- `npm test` -> pass (11/11).
- `npm run lint` -> pass.
- `bash -n scripts/railway-ssh-probe.sh` -> pass.
- `railway status --json` -> showed project + service with no deployments.
- `railway delete -p 6706edc7-9886-47fb-b7e4-997a723a5c64 -y` -> project deleted.
- `railway status` -> `Project not found`.
- `railway list` -> deleted project absent.

## Closure Recommendation

- **DECISION_144**: `Close`
- Blockers: none.
