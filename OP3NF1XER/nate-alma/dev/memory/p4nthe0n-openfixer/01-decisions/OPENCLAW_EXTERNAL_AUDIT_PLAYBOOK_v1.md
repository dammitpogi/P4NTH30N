# OpenClaw External Audit Playbook v1

Parent Decision: `STR4TEG15T/memory/decisions/DECISION_136_OPENCLAW_EXTERNAL_CODEBASE_AUDIT_KICKOFF.md`
Mode: `External Codebase Audit`
Status: `Active`

## Purpose

Provide a deterministic execution playbook for OpenClaw inspection that is easier for Alma to operate and more expansive for Nate to utilize, while preserving non-destructive governance.

## Execution Sequence

1. Boundary map verification (`inspectable`, `changeable`, `advisory-only`).
2. Lens A evidence sweep (`System Correctness` + stock runtime behavior).
3. Lens B evidence sweep (`Change Governance` + stock workflow governance).
4. Alma/Nate usability expansion scoring.
5. Advisory recommendation staging (`Tier 0`, `Tier 1`, `Tier 2`).

## Lens A Evidence Checklist

- Runtime startup contract: state dir, config path, dependency interpolation behavior.
- Endpoint truth matrix: `/healthz`, `/setup`, `/openclaw` with gateway truth parity.
- Failure-mode catalog: missing-env, timeout, transient 5xx, and recovery signatures.
- Stock-path operator ergonomics: discoverability, error readability, and task completion friction.

## Lens B Evidence Checklist

- Change control discipline: preflight checks, rollout granularity, and rollback semantics.
- Audit trail quality: deployment journals, mutation traceability, and recovery chain integrity.
- Ownership clarity: Alma-maintained zones vs advisory-only zones.
- Expansion governance: Nate capability tiers and risk controls.

## Alma Ease / Nate Expansion Scoring

- `Alma Ease` score bands:
  - `A`: single-path runbook + clear error decoding + safe defaults.
  - `B`: runbook exists but requires expert interpretation.
  - `C`: fragmented operator path and high cognitive load.
- `Nate Expansion` score bands:
  - `A`: tiered extension points with rollback-ready packets.
  - `B`: partial extension map with manual safety controls.
  - `C`: ad hoc expansion path with unclear blast radius.

## Recommendation Tiers

- `Tier 0 (Docs/Ops)`:
  - Runbook clarity upgrades, error taxonomy, operator quick checks.
- `Tier 1 (Config-Safe)`:
  - Save-time guards, schema checks, deterministic defaults.
- `Tier 2 (Code Advisory)`:
  - Staged, reversible design recommendations for maintainer implementation.

## Validation Commands

- `python -c "import json; json.load(open(r'C:\\P4NTH30N\\STR4TEG15T\\memory\\manifest\\manifest.json', encoding='utf-8')); print('manifest ok')"`
- `grep -R "OpenClaw|stateDir|configPath|gateway.reachable|MissingEnvVarError" STR4TEG15T/memory OP3NF1XER/deployments`
- `grep -R "Alma Ease|Nate Expansion|Tier 0|Tier 1|Tier 2" STR4TEG15T/memory/decision-engine/OPENCLAW_EXTERNAL_AUDIT_PLAYBOOK_v1.md`

## Closure Packet Targets

- Parity matrix (claims vs evidence).
- File-level evidence summary.
- Usage guidance for Alma and Nate.
- Triage and repair runbook.
- Closure recommendation (`Close|Iterate|Keep HandoffReady`).
