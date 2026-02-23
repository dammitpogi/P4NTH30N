---
name: cartography
description: Repository understanding and hierarchical codemap generation
---

# Cartography Skill

You help users understand and map repositories by creating hierarchical codemaps.

## When to Use

- User asks to understand/map a repository
- User wants codebase documentation
- Starting work on an unfamiliar codebase

## Workflow

## Hard Requirements (Non-Optional)

1. **You must delegate codemap authoring to Librarian agents.**
   - The Orchestrator coordinates and synthesizes.
   - Librarians read directory code and write that directory's `codemap.md`.
2. **Do not claim a codemap is populated unless it was actually written in this run** (or already contained non-template content that you verified).
3. **Do not stop at `init`/`changes`.** Cartography is not complete until affected `codemap.md` files are filled and the root atlas is updated.
4. **Always report evidence**: number of librarian delegations, directories covered, and files updated.
5. **Do not delegate command execution to Librarian agents when they lack `bash` permission.**
   - Run `cartographer.py changes/update` in the main session (Orchestrator).
   - Use Librarian for writing/synthesis only.
6. **Do not rely on background-task completion for cartography correctness.**
   - Cartography completion must be driven by explicit local verification gates, not by whether a delegated task returned.
7. **No placeholders allowed at completion.** Any targeted `codemap.md` that still contains template markers (for example `Explorer: Fill in`, `TODO`, empty section headers) means the run is incomplete.
8. **Directory-scoped accuracy is mandatory.** A codemap may describe only code/config that actually exists in that directory subtree (excluding configured ignores).

### Step 1: Check for Existing State

**First, check if `.theseues/cartography.json` exists in the repo root.**

If it **exists**: Skip to Step 3 (Detect Changes) - no need to re-initialize.

If it **doesn't exist**: Continue to Step 2 (Initialize).

### Step 2: Initialize (Only if no state exists)

1. **Analyze the repository structure** - List files, understand directories
2. **Infer patterns** for **core code/config files ONLY** to include:
   - **Include**: `src/**/*.ts`, `packages/**/*.ts`, etc.
   - **Exclude (MANDATORY)**: Do NOT include tests, documentation, or translations.
     - Tests: `**/*.test.ts`, `**/*.spec.ts`, `tests/**`, `__tests__/**`
     - Docs: `docs/**`, `*.md` (except root `README.md` if needed), `LICENSE`
     - Build/Deps: `node_modules/**`, `dist/**`, `build/**`, `*.min.js`
     - Vendor/Refs (MANDATORY): `ref/**`, `.backups/**`, `.debug/**`, `.test-*/**`, `.theseus/**`
   - Respect `.gitignore` automatically
3. **Run cartographer.py init**:

Use `--exception` for root config files so you don't accidentally include every nested
`package.json` in the repo.

```bash
python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py init \
  --root ./ \
  --include "src/**/*.ts" \
  --include "packages/**/*.ts" \
  --exclude "**/*.test.ts" --exclude "**/*.spec.ts" \
  --exclude "tests/**" --exclude "__tests__/**" \
  --exclude "docs/**" --exclude "**/*.md" --exclude "LICENSE" \
  --exclude "node_modules/**" --exclude "dist/**" --exclude "build/**" --exclude "**/*.min.js" \
  --exclude "ref/**" --exclude ".backups/**" --exclude ".debug/**" --exclude ".test-*/**" --exclude ".theseus/**" \
  --exception "package.json" \
  --exception "tsconfig.json" \
  --exception "biome.json"
```

This creates:
- `.theseues/cartography.json` - File and folder hashes for change detection
- Empty `codemap.md` files in all relevant subdirectories

4. **Delegate to Librarian agents** - Spawn one librarian per folder to read code and fill in its specific `codemap.md` file.

   Delegation protocol:
   - Create one delegation task per target directory.
   - Pass explicit scope boundaries (directory path + excluded paths).
   - Require each librarian to return:
     - directory responsibility
     - key design patterns
     - data/control flow
     - integration points
   - Require each librarian to write/update exactly one `codemap.md` for its directory.

   If Librarians are not permitted to write (common in locked-down configs):
   - Librarians return codemap content only (no file writes).
   - The Orchestrator or Librarian must write the returned content into that directory's `codemap.md`.

### Step 3: Detect Changes (If state already exists)

1. **Run cartographer.py changes** to see what changed:

```bash
python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py changes \
  --root ./
```

2. **Review the output** - It shows:
   - Added files
   - Removed files
   - Modified files
   - Affected folders

3. **Only update affected codemaps** - Spawn one librarian per affected folder to update its `codemap.md`.

   Mandatory behavior:
    - If `changes` reports affected folders, delegate each affected folder to a librarian.
   - If no affected folders exist, do not fabricate updates; only verify atlas consistency.

   Hardening behavior:
    - If librarian output is missing, low-quality, or inconsistent with local files, do not accept it.
   - Re-run delegation for that directory OR have Orchestrator/Librarian author the codemap directly from local file reads.
   - Never mark a directory complete until its codemap passes the verification gate.

4. **Run update** to save new state:

```bash
python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py update \
  --root ./
```

### Step 4: Finalize Repository Atlas (Root Codemap)

Once all specific directories are mapped, the Orchestrator must create or update the root `codemap.md`. This file serves as the **Master Entry Point** for any agent or human entering the repository.

1.  **Map Root Assets**: Document the root-level files (e.g., `package.json`, `index.ts`, `plugin.json`) and the project's overall purpose.
2.  **Aggregate Sub-Maps**: Create a "Repository Directory Map" section. For every folder that has a `codemap.md`, extract its **Responsibility** summary and include it in a table or list in the root map.
3.  **Cross-Reference**: Ensure that the root map contains the absolute or relative paths to the sub-maps so agents can jump directly to the relevant details.

### Step 5: Verification Gate (Must Pass Before Completion)

Before declaring cartography complete, perform all checks below:

1. **Delegation evidence**: confirm librarian tasks were dispatched for each target directory.
2. **Content quality**: ensure each updated `codemap.md` contains at least these sections:
   - `## Responsibility`
   - `## Design`
   - `## Flow`
   - `## Integration`
3. **Template detection**: reject placeholder-only content (for example, `TODO`, `Explorer: Fill in`, empty headings).
4. **Atlas sync**: root `codemap.md` references all updated subdirectory maps.
5. **State sync**: run `cartographer.py update --root ./` after updates.
6. **Context correctness check**: each codemap must cite concrete, local artifacts (file paths, modules, functions, interfaces) from its own directory tree.
7. **Scope purity check**: remove claims about unrelated directories/providers/frameworks not present in local files.
8. **Placeholder sweep**: perform a final grep for template markers across targeted codemaps; any match fails the run.

Completion report format (required):
- Librarians delegated: `<count>`
- Directories updated: `<count>`
- Codemaps updated: `<count>`
- Root atlas updated: `yes|no`
- Cartography state updated: `yes|no`
- Placeholder-free after run: `yes|no`
- Scope/context validation passed: `yes|no`

### Step 6: Deterministic Completion Loop (Required)

Run this loop until all checks pass:

1. Detect targets (`changes` output or explicit user scope).
2. Produce/refresh codemap content for each target directory.
3. Validate section completeness + local artifact grounding.
4. Sweep for placeholders in targeted codemaps.
5. Update root atlas references.
6. Run `cartographer.py update --root ./`.
7. Re-check `changes` and placeholder sweep; if either fails, repeat.


## Codemap Content

Librarians are granted write permissions for `codemap.md` files during this workflow. Use precise technical terminology to document the implementation:

- **Responsibility** - Define the specific role of this directory using standard software engineering terms (e.g., "Service Layer", "Data Access Object", "Middleware").
- **Design Patterns** - Identify and name specific patterns used (e.g., "Observer", "Singleton", "Factory", "Strategy"). Detail the abstractions and interfaces.
- **Data & Control Flow** - Explicitly trace how data enters and leaves the module. Mention specific function call sequences and state transitions.
- **Integration Points** - List dependencies and consumer modules. Use technical names for hooks, events, or API endpoints.

Example codemap:

```markdown
# src/agents/

## Responsibility
Defines agent personalities and manages their configuration lifecycle.

## Design
Each agent is a prompt + permission set. Config system uses:
- Default prompts (orchestrator.ts, explorer.ts, etc.)
- User overrides from ~/.config/opencode/oh-my-opencode-theseus.json
- Permission wildcards for skill/MCP access control

## Flow
1. Plugin loads → calls getAgentConfigs()
2. Reads user config preset
3. Merges defaults with overrides
4. Applies permission rules (wildcard expansion)
5. Returns agent configs to OpenCode

## Integration
- Consumed by: Main plugin (src/index.ts)
- Depends on: Config loader, skills registry
```

Example **Root Codemap (Atlas)**:

```markdown
# Repository Atlas: oh-my-opencode-theseus

## Project Responsibility
A high-performance, low-latency agent orchestration plugin for OpenCode, focusing on specialized sub-agent delegation and background task management.

## System Entry Points
- `src/index.ts`: Plugin initialization and OpenCode integration.
- `package.json`: Dependency manifest and build scripts.
- `oh-my-opencode-theseus.json`: User configuration schema.

## Directory Map (Aggregated)
| Directory | Responsibility Summary | Detailed Map |
|-----------|------------------------|--------------|
| `src/agents/` | Defines agent personalities (Orchestrator, Explorer) and manages model routing. | [View Map](src/agents/codemap.md) |
| `src/features/` | Core logic for tmux integration, background task spawning, and session state. | [View Map](src/features/codemap.md) |
| `src/config/` | Implements the configuration loading pipeline and environment variable injection. | [View Map](src/config/codemap.md) |
```
