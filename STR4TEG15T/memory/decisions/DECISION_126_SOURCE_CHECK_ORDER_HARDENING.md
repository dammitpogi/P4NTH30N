---
type: decision
id: DECISION_126
category: FORGE
status: completed
version: 1.0.0
created_at: '2026-02-24T21:10:00Z'
last_reviewed: '2026-02-24T21:10:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_126_SOURCE_CHECK_ORDER_HARDENING.md
---
# DECISION_126: OpenFixer Source-Check Order Hardening

**Decision ID**: DECISION_126  
**Category**: FORGE  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-24

## Context

Nexus requested workflow hardening so execution always checks historical Decisions first, then OpenFixer knowledgebase, then discovery/exploration, and only then web search when still necessary.

## Decision

Adopt a mandatory source-check order for all non-trivial OpenFixer passes:

1. Decisions
2. OpenFixer knowledgebase
3. Local discovery/exploration
4. Web search (only if unresolved)

## Implementation

- Updated OpenFixer source-of-truth prompt with explicit ordered workflow rules:
  - `C:/Users/paulc/.config/opencode/agents/openfixer.md`
- Updated OpenFixer operational governance rules with explicit ordered source-check sequence:
  - `OP3NF1XER/AGENTS.md`
- Added reusable implementation pattern for future passes:
  - `OP3NF1XER/patterns/SOURCE_CHECK_ORDER.md`

## Validation

- Verified source-of-truth prompt now includes mandatory execution order and discovery/web gating language.
- Verified OP3NF1XER governance docs now enforce the same sequence.
- Verified reusable pattern artifact exists in `OP3NF1XER/patterns`.

## Audit Matrix

- Decisions checked first requirement: **PASS**
- Knowledgebase checked second requirement: **PASS**
- Discovery/exploration after Decisions and knowledgebase requirement: **PASS**
- Web search only as needed requirement: **PASS**
- Workflow hardening documented for reuse requirement: **PASS**
