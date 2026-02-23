# src/skills/cartography/scripts/

## Responsibility

Implements the `cartography` helper CLI in Python. The script creates and maintains `.theseues/cartography.json` as a lightweight, git-independent change detector and generates directory-local `codemap.md` placeholders to be filled with architectural summaries.

## Design

- `cartographer.py` exposes three commands:
  - `init`: selects files via include/exclude patterns, hashes them, computes folder hashes, writes state, and creates empty `codemap.md` templates.
  - `changes`: compares current hashes to saved state and prints added/removed/modified files plus affected folders.
  - `update`: recomputes and persists the hashes ("commit" step).
- File selection uses `PatternMatcher`:
  - compiles glob-like patterns into a single combined regex for speed.
  - respects root `.gitignore` patterns.
  - supports explicit `--exception` file paths to override excludes.
- State file format:
  - `metadata`: patterns, root, last run timestamp.
  - `file_hashes`: per-file MD5.
  - `folder_hashes`: stable MD5 over sorted `path:hash` tuples.

## Flow

1. Walk filesystem under `--root` (skipping dot-directories).
2. Select files (`select_files`) based on patterns + `.gitignore`.
3. Hash selected files and derive folder hashes.
4. Persist `.theseues/cartography.json`.
5. (init only) Create `codemap.md` templates for every folder containing selected files.

## Integration

- Called by the Orchestrator from the cartography skill workflow.
- Unit coverage lives in `test_cartographer.py` (PatternMatcher, hashing, select_files behavior).
