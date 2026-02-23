# src/hooks/changelog-cartography/

## Responsibility

Tracks successful file modifications made through write/edit/apply_patch and prompts the main Orchestrator session to re-run cartography when the session becomes idle. This keeps `codemap.md` documentation in sync with recently changed code.

## Design

- Implemented as a hook factory: `createChangelogCartographyHook(ctx, backgroundManager, options)`.
- Maintains in-memory state:
  - `changedFiles`: set of file paths that were modified successfully.
  - `pendingByCallId`: correlates `tool.execute.before` and `tool.execute.after`.
  - `awaitingCartographyUpdate`: blocks repeated prompts for the same snapshot.
  - `mainSessionCache`: memoizes whether a session is a main session (not a background child).
- Extracts file paths from tool args for:
  - `write`/`edit` (`filePath`/`path`)
  - `apply_patch` (parses `*** Add/Update/Delete File:` headers)
- Completion signal:
  - watches for a `bash` tool invocation whose command contains `cartographer.py` and `update`; on success clears the changelog.

## Flow

1. `tool.execute.before`: record candidate file paths for write/edit/apply_patch.
2. `tool.execute.after`: if tool succeeded (no obvious error), add file paths to `changedFiles`.
3. `session.status` (idle): if there are changed files and no background tasks running, prompt the main session with a cartography run request that includes the changed file list.
4. Later: when cartography `update` is detected, clear `changedFiles` and reset prompt state.

## Integration

- Uses the OpenCode client (`ctx.client.session.promptAsync`) to inject the cartography run request.
- Consults `BackgroundTaskManager` to avoid prompting while background tasks are active.
- Designed to work with the cartography skill + `cartographer.py` helper.
