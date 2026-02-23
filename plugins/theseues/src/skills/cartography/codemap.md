# src/skills/cartography/

## Responsibility

Defines the `cartography` skill: a deterministic workflow for generating and maintaining a hierarchy of `codemap.md` files that document repository structure and module responsibilities.

## Design

- `SKILL.md`: the authoritative workflow steps and guardrails the Orchestrator follows.
- `README.md`: a short description and example commands.
- `scripts/`: contains the executable helper (`cartographer.py`) that:
  - tracks repository file/folder hashes in `.theseues/cartography.json`,
  - creates empty `codemap.md` templates, and
  - reports changes since the last run.

## Flow

1. Orchestrator checks `.theseues/cartography.json`.
2. If missing: runs `cartographer.py init` with include/exclude patterns.
3. If present: runs `cartographer.py changes` to identify affected folders.
4. Codemaps are written/updated for affected folders; the root `codemap.md` atlas is refreshed.
5. Orchestrator runs `cartographer.py update` to snapshot the new hashes.

## Integration

- Used by the Orchestrator to keep the repository's `codemap.md` documentation accurate and directory-scoped.
- The helper script is executed via Orchestrator `bash`; subagents (Explorer/Librarian) may contribute content but the Orchestrator owns correctness gates.
