# DECISION_116 Automation Strategy v1

**Version**: v1  
**Parent Decision**: `STR4TEG15T/decisions/active/DECISION_116.md`  
**Date**: 2026-02-23

## Principle

Token efficiency and operational speed improve when strategist workflow emits structured, machine-readable artifacts that can be maintained by automation instead of manual edits.

## Automation Targets

1. `decision-status-index.json` generation from decision markdown status lines.
2. Manifest v2 event append + view refresh automation.
3. Integrity check automation (event/view parity, checksum, replay validation).
4. Archival compaction automation (snapshot + partition archive + catalog update).

## Minimal-Maintenance Rule

- Prefer append-only and generated views over hand-curated large files.
- Avoid introducing new long-lived manual registries unless auto-regenerated.
- Every new storage artifact should declare owner process and refresh trigger.
