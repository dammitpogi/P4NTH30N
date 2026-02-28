# Strategist Directory Analysis (2026-02-24)

Decision link: `DECISION_125`

## Summary

- Total files analyzed: 6,932
- Largest top-level segments:
  - `tools/`: 4,961 files
  - `memory/`: 1,511 files
  - `decisions/`: 139 files

## Usage Pattern Findings

1. **Knowledgebase reality split**
   - Active canonical memory is now `STR4TEG15T/memory`.
   - Legacy strategist docs still reference older `decisions/active`, `speech/`, and `T4CT1CS` paths.

2. **Strategist-owned knowledge creation**
   - Strategist creates and curates independent knowledge in:
     - `intel/`
     - `consultations/`
     - `handoffs/`
     - `memory/decisions/`

3. **Operational risk**
   - High-volume embedded tooling under `tools/` obscures strategist intent during search and maintenance.
   - Legacy reference drift causes confusion for fixer execution prompts.

## Organization Actions Completed

- Added strategist governance doc: `STR4TEG15T/AGENTS.md`.
- Replaced outdated strategist README architecture narrative with current canonical guidance.
- Added this analysis and inventory artifacts under `STR4TEG15T/knowledge`.
- Added decision-search workflow support for OpenFixer to force historical recall before UI automation changes.

## Recommended Ongoing Pattern

- Treat `memory/` as canonical decision engine.
- Treat `decisions/`, `actions/`, `handoffs/`, `consultations/`, `intel/` as operational overlays.
- Keep large tool workspaces isolated from strategist decision retrieval by using targeted search scopes.
