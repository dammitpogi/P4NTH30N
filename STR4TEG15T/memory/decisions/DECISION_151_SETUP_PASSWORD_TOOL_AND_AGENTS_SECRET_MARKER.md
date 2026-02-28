---
type: decision
id: DECISION_151
category: INFRA
status: completed
version: 1.0.0
created_at: '2026-02-25T00:00:00Z'
last_reviewed: '2026-02-25T00:30:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_151_SETUP_PASSWORD_TOOL_AND_AGENTS_SECRET_MARKER.md
---
# DECISION_151: Setup Password Tool and AGENTS Secret Marker

**Decision ID**: DECISION_151  
**Category**: INFRA  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-25

## Context

Nexus requested a setup password to be created, required that password-tool deliverable presence be explicit in AGENTS documentation, and requested the setup password be stored in the AGENTS file.

## Historical Decision Recall

- `DECISION_146`: deployed token/config plug-point documentation.
- `DECISION_150`: Nate-Alma deploy audit manifest and Railway release.

## Decision

1. Create a local setup-password tool in deploy scripts.
2. Mention the password tool explicitly in `OP3NF1XER/nate-alma/deploy/AGENTS.MD`.
3. Store the generated setup password in `AGENTS.MD` as requested.
4. Set Railway `SETUP_PASSWORD` variable to match the generated value.

## Acceptance Requirements

1. Password generator tool exists in deploy lane and is runnable.
2. AGENTS manifest includes explicit password-tool documentation.
3. AGENTS manifest stores the requested setup password value.
4. Railway service variable `SETUP_PASSWORD` matches stored value.

## Implementation

- Added password generator tool: `OP3NF1XER/nate-alma/deploy/scripts/generate-setup-password.js`.
- Added npm script shortcut in `OP3NF1XER/nate-alma/deploy/package.json`:
  - `password:generate`
- Updated `OP3NF1XER/nate-alma/deploy/AGENTS.MD` to:
  - mention password tool location and invocation,
  - store requested setup password value.
- Applied matching Railway variable:
  - `SETUP_PASSWORD=@Q5PDS9zoc2eSnNr%-itS9Eqo!d^`

## Validation Evidence

- Tool generation command validation:
  - `node scripts/generate-setup-password.js` outputs strong token string.
- Railway variable validation:
  - `railway variable list --service "OpenClaw-Alma-v1"` includes `SETUP_PASSWORD` with expected value.
- Runtime auth gate validation:
  - `/setup` unauthenticated -> `401`
  - `/setup/healthz` with Basic auth using configured password -> `200` and `{\"ok\":true}`.

## Decision Parity Matrix

- Password generator tool exists and is runnable: **PASS**
- AGENTS manifest explicitly documents password tool: **PASS**
- AGENTS manifest stores requested setup password value: **PASS**
- Railway `SETUP_PASSWORD` matches stored value: **PASS**

## Closure Recommendation

`Close` - requested password tooling, documentation marker, and deployed variable alignment are complete.
