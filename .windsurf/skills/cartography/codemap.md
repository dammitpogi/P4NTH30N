# skills/cartography/

## Responsibility

Defines the Cartography skill: a deterministic workflow for maintaining directory-scoped `codemap.md` files and a root repository atlas (`codemap.md`) using the file/folder hash state stored in `.slim/cartography.json`.

## Design

- Spec-driven: `skills/cartography/SKILL.md` defines the required workflow (init -> changes -> update), quality gates, and completion reporting.
- State-based change detection: `skills/cartography/scripts/cartographer.py` stores hashes for selected files/folders in `.slim/cartography.json` so updates can be targeted to affected scopes.
- Directory-scoped maps: each mapped directory owns a `codemap.md` describing only artifacts in that subtree.

## Flow

1. Initialize state (once): `cartographer.py init --root ./ ...` selects files (include/exclude/exception patterns), writes `.slim/cartography.json`, and creates empty `codemap.md` templates.
2. Detect deltas: `cartographer.py changes --root ./` compares current hashes to saved hashes and reports modified files and affected folders.
3. Update codemaps: author/update `codemap.md` for each affected folder and ensure the root atlas references the updated maps.
4. Persist state: `cartographer.py update --root ./` refreshes hashes and stamps `metadata.last_run`.

## Integration

- Invoked by the primary agent workflow after code/config changes (Cartography refresh phase).
- Uses `skills/cartography/scripts/cartographer.py` as the sole state source of truth (`.slim/cartography.json`) for detecting affected scopes.
- Produces human/agent-facing entry points: root `codemap.md` plus per-directory `codemap.md` files.
