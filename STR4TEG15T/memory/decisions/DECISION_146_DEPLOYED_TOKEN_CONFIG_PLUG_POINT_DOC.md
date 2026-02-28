---
type: decision
id: DECISION_146
category: DOCS
status: completed
version: 1.0.0
created_at: '2026-02-25T00:20:00Z'
last_reviewed: '2026-02-25T00:20:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_146_DEPLOYED_TOKEN_CONFIG_PLUG_POINT_DOC.md
---
# DECISION_146: Deployed Token Config Plug-Point Documentation

**Decision ID**: DECISION_146  
**Category**: DOCS  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-25

## Context

Nexus requested documentation-only guidance showing where to plug Claude setup-token and Telegram bot token for a deployed OpenClaw install, without modifying OpenClaw base code or Railway deployment logic.

## Historical Decision Recall

- `DECISION_142`: Nate-Alma control-plane governance and operator documentation requirements.
- `DECISION_145`: local clone + deploy lane pin refresh for Nate-Alma continuity.

## Decision

Publish a dedicated operator doc in the Nate-Alma docs set that identifies:

1. deployed config/auth file paths,
2. setup UI entry points for Claude setup-token and Telegram token,
3. read-only verification endpoints/commands,
4. minimal security handling rules (no git token commits).

## Implementation

- Added `OP3NF1XER/nate-alma/docs/DEPLOYED_CONFIG_TOKEN_PLUG_POINTS.md`.
- Added index entry in `OP3NF1XER/nate-alma/docs/INDEX.md`.

## Validation Evidence

- Path guidance aligns with wrapper/core path resolution and setup routes.
- No runtime code changes were introduced.

## Decision Parity Matrix

- Document Claude setup-token plug point for deployed install: **PASS**
- Document Telegram bot token plug point for deployed install: **PASS**
- Keep pass documentation-only (no base/deploy rewrites): **PASS**

## Closure Recommendation

`Close` - operator documentation is in place and indexed.
