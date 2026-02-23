# skills/cartography/scripts/

## Responsibility

Implements the Cartography state engine and CLI in `skills/cartography/scripts/cartographer.py`. It selects files, computes hashes, reports changes, and updates `.theseues/cartography.json`.

## Design

- Single-file CLI with subcommands: `init`, `changes`, `update` (argparse in `main()`; dispatch via `cmd_init`, `cmd_changes`, `cmd_update`).
- Deterministic selection: `select_files()` walks the repo (`os.walk`) and filters by include/exclude patterns plus `.gitignore` via `PatternMatcher`.
- Stable hashing:
  - `compute_file_hash()` returns MD5 of file contents.
  - `compute_folder_hash()` hashes `path:hash` pairs to produce a stable folder digest.
- State file: `.theseues/cartography.json` stores `metadata` (patterns, root, last_run) plus `file_hashes` and `folder_hashes`.

## Flow

1. `init`:
   - loads patterns + `.gitignore` (`load_gitignore()`)
   - selects files (`select_files()`)
   - hashes files/folders and writes state (`save_state()`)
   - creates `codemap.md` templates per folder (`create_empty_codemap()`)
2. `changes`:
   - loads state (`load_state()`)
   - re-selects files using saved patterns
   - reports added/removed/modified paths and affected folders
3. `update`:
   - re-hashes selected files/folders and refreshes `metadata.last_run`

## Integration

- Called from the Cartography workflow: `python3 skills/cartography/scripts/cartographer.py <init|changes|update> --root ./`.
- Output is consumed by the operator/agent to decide which directory codemaps to refresh.
- Template codemap creation uses `<!-- Explorer: Fill in... -->` markers (in `create_empty_codemap()`), which the workflow replaces with grounded content.
