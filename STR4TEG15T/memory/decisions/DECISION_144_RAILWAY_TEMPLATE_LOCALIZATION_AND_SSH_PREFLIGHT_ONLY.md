---
type: decision
id: DECISION_144
category: INFRA
status: completed
version: 1.0.0
created_at: '2026-02-24T23:15:00Z'
last_reviewed: '2026-02-24T23:15:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_144_RAILWAY_TEMPLATE_LOCALIZATION_AND_SSH_PREFLIGHT_ONLY.md
---
# DECISION_144: Railway Template Localization and SSH Preflight Only

**Decision ID**: DECISION_144  
**Category**: INFRA  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-24

## Context

Nexus directed OpenFixer to stop active Railway deployment actions and keep work in local-prep mode with SSH preconfiguration only.

## Historical Decision Recall

- `DECISION_120`: stack assimilation and source/dev mirror governance.
- `DECISION_142`: Nate-Alma SSH control-plane workflow and traceability mandates.

## Decision

Localize the cloned Railway template under `OP3NF1XER/nate-alma/deploy`, strip inherited remote GitHub control metadata, preconfigure SSH operator assets, and rollback newly created Railway project state.

## Implementation

- Cloned `vignesh07/clawdbot-railway-template` into local deploy path.
- Removed inherited `.git` and `.github` control metadata from localized template copy.
- Added OpenSSH runtime support and operator SSH preflight scripts/docs.
- Added `ops/railway-target.json` scaffold for local project/service mapping.
- Deleted temporary Railway project `OpenClaw-MoltBot-ClawdBot-Alma` after rollback instruction.

## Acceptance Requirements

1. Railway deployment creation actions are rolled back.  
2. Template remains local-only and editable.  
3. SSH preflight assets are present and syntax-valid.  
4. Governance evidence is captured in decision, journal, and knowledge write-back.

## Validation Plan

- Validate Railway rollback with `railway status` and `railway list`.
- Validate template tests/lint for safe local continuation.
- Validate SSH probe script syntax.
