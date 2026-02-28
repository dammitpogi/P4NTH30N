# DECISION_114 Change Control v1

**Version**: v1  
**Parent Decision**: `STR4TEG15T/decisions/active/DECISION_114.md`  
**Date**: 2026-02-23

## Purpose

Define practical editing rules for strategist workflow artifacts so decision files stay maintainable and auditable.

## Rules

1. Minor changes are appended to existing decision files when scope is unchanged.
2. Major changes create a new versioned companion document and are referenced from the parent decision.
3. Decision files should be actively edited to keep line counts below 1000 where possible.
4. External documentation is preferred for deep implementation context and long rationale.

## Deletion Governance

Before deletion attempt, strategist must state:
- exact path,
- reason,
- expected impact.

Deletion attempt proceeds after this statement, and OpenCode permission flow asks Nexus to allow or deny.
