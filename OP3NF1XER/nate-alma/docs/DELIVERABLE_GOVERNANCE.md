# Nate-Alma Deliverable Governance

Use this governance contract for every future Nate deployment request.

## Required Evidence Chain

1. Decision file in `STR4TEG15T/memory/decisions`.
2. Deployment journal in `OP3NF1XER/deployments`.
3. Knowledge write-back in `OP3NF1XER/knowledge` and/or `OP3NF1XER/patterns`.
4. Nate-Alma artifacts under `OP3NF1XER/nate-alma/srv`.

## Mandatory Workflow

1. Pull remote snapshot first.
2. Apply change over SSH toolchain.
3. Validate with status, debug, and task-specific probes.
4. Publish parity audit (`PASS`/`PARTIAL`/`FAIL`).
5. If any requirement is `PARTIAL`/`FAIL`, self-fix and re-audit in same pass.
6. Persist session continuity state to `OP3NF1XER/nate-alma/srv/state/continuity.json`.
7. Write self-learning updates to workflow docs (`nate-alma/dev`, `OP3NF1XER/patterns`, and if needed `C:/Users/paulc/.config/opencode/agents/openfixer.md`).

## Minimum Validation Command Set

- `openclaw --version`
- `openclaw status`
- `openclaw doctor`
- setup route probes: `/setup/api/status`, `/setup/api/debug`

## Traceability Standard (OpenFixer Methodology)

- Failure points must emit verbose logs with severity markers (`INFO`, `WARN`, `ERROR`, `RISK`).
- Every tool run uses a `TraceId` and writes logs to `OP3NF1XER/nate-alma/srv/logs`.
- High-risk operations (remote tar extract, config mutation, token-related writes) must log explicit risk markers.
- On failure, logs must state the failing phase and deterministic next action.

## Future Request Intake

For each request, append:

- request timestamp,
- decision id,
- command log,
- resulting artifacts,
- closure recommendation (`Close`, `Iterate`, `Keep HandoffReady`).
