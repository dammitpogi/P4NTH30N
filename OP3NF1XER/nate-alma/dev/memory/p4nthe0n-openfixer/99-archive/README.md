# Decision Engine Memory Domain

This directory is reserved for runtime decision-engine data that supports strategist workflow execution.

Scope (planned):

- status indexes
- migration maps
- replay/reconciliation metadata
- health and integrity checks for manifest v2

Current generated artifacts:

- `decision-status-index.json` generated via `STR4TEG15T/memory/tools/decision-status-indexer.ts`
- `migration-manifest.json` generated from reconsolidation inventory pass
- `reconsolidation-validation-report.json` generated from migration-manifest integrity checks
- `DECISION_ENGINE_BEAST_MODE_PROTOCOL.md` strategist execution protocol for high-variance and external-audit missions
- `SYNTHESIS_PROVOCATION_PROTOCOL.md` strategist journal/speech synthesis quality and provocation protocol

Validation gate:

- `STR4TEG15T/memory/tools/reconsolidation-gate.ts`
- Run with `bun run reconsolidation:gate` from `STR4TEG15T/memory/tools`

Canonical rule:

- Machine-readable authority: `STR4TEG15T/ROOT.json` defines the canonical root and migration state.
- This memory domain is the authoritative strategist workflow surface.
- Canonical decision markdown lives in `STR4TEG15T/memory/decisions/`.
- `STR4TEG15T/decisions/` is treated as legacy migration source until fully reconciled.

Parent decisions:

- `STR4TEG15T/decisions/active/DECISION_116.md`
- `STR4TEG15T/memory/decision-engine/DECISION_RECONSOLIDATION_2026-02-24.md`
