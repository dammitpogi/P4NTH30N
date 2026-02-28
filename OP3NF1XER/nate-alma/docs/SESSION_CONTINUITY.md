# Session Continuity

## Goal

Allow the next operator session to resume deterministically after interruption.

## Continuity File

- Path: `../srv/state/continuity.json`
- Fields:
  - `traceId`
  - `tool`
  - `phase`
  - `status`
  - `details`
  - `updatedAtUtc`

## Resume Procedure

1. Read `continuity.json`.
2. Open matching trace file(s) in `../srv/logs` using `traceId`.
3. Resume from the last failed or in-progress phase.
4. Re-run validation commands.
5. Update decision + journal + learning docs.

## Mandatory Self-Learning Step

If a new failure class is discovered:

1. Patch tools and/or workflows.
2. Update docs in `nate-alma/docs` and `nate-alma/dev`.
3. Update reusable pattern in `OP3NF1XER/patterns`.
4. Update OpenFixer source policy if methodology changed.
