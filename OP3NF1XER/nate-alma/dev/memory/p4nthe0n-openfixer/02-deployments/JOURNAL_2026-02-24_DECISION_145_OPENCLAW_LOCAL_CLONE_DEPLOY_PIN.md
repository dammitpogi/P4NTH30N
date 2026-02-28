# Deployment Journal - DECISION_145 OpenClaw Local Clone + Deploy Pin Refresh

Date: 2026-02-24  
Decision: `DECISION_145`

## Objective

Clone upstream OpenClaw into the Nate-Alma local control plane and refresh the deployment lane pin for upcoming Nate/Alma usage.

## Actions Executed

1. Verified governance sources and Nate-Alma memory packet context.
2. Cloned `https://github.com/openclaw/openclaw` into `OP3NF1XER/nate-alma/openclaw`.
3. Resolved latest stable upstream tag from local clone (`v2026.2.24`) and commit (`b247cd6d65e63b2ee17ae7c9687431f264a40e91`).
4. Updated deployment pin in `OP3NF1XER/nate-alma/deploy/Dockerfile`.
5. Added source lock metadata in `OP3NF1XER/nate-alma/deploy/ops/openclaw-source-lock.json`.

## Verification Snapshot

- Local clone branch: `main`
- Local clone HEAD: `b247cd6d65e63b2ee17ae7c9687431f264a40e91`
- Nearest stable tag: `v2026.2.24`
- Deploy pin old -> new: `v2026.2.9` -> `v2026.2.24`

## Operator Guidance

- To rebuild against this pinned ref, deploy `OP3NF1XER/nate-alma/deploy` as normal.
- To rotate to a newer release later:
  1. Pull latest in `OP3NF1XER/nate-alma/openclaw`.
  2. Update `OPENCLAW_GIT_REF` in `deploy/Dockerfile`.
  3. Update `deploy/ops/openclaw-source-lock.json`.
  4. Record a new decision + deployment journal.
