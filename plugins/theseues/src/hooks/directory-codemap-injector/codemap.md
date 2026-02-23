# src/hooks/directory-codemap-injector/

## Responsibility

Injects a concise, directory-scoped codebase context block into tool outputs (Read/Ls/Cd/Grep/AstGrep) by locating nearby `codemap.md` files and summarizing them. This reduces navigation overhead and keeps agents oriented to the architecture of the files they just touched.

## Design

- Triggered by `tool.execute.after` in `createDirectoryCodemapInjectorHook()`.
- Discovery (`discovery.ts`): finds `codemap.md` in the target directory and a limited set of ancestors (`maxSummaries`) while respecting a workspace root boundary.
- Summarization (`summarizer.ts`):
  - default path: truncate/condense the codemap content to a token budget,
  - optional path: call LM Studio (`/v1/chat/completions`) to summarize (with strict timeout),
  - filters out HTML comment lines (e.g., template markers) before condensing.
- Injection (`injector.ts`): appends a fenced, well-marked block to the tool output using `INJECTION_MARKER_START/END`.
- Caching (`cache.ts`):
  - per-session directory cache to avoid repeated injection,
  - in-memory summary cache keyed by `(codemapPath, modifiedTime, model, maxTokens)` with TTL.
- Model bootstrap (`model-manager.ts`): can auto-download/load the configured LM Studio model via `lms` CLI and show user toasts.

## Flow

1. A configured tool completes (e.g., Read).
2. Extract file path from tool output; resolve to absolute path under workspace.
3. Find relevant `codemap.md` files for the file's directory and ancestors.
4. For each codemap not yet injected this session:
  - build cache key; reuse cached summary if fresh,
  - otherwise summarize (LM Studio or truncation fallback),
  - append context block to the tool output.

## Integration

- Registered as a hook in plugin initialization; consumes `PluginInput` for workspace root and client APIs.
- Tight coupling with the cartography skill output (`codemap.md` files). Placeholder/low-quality codemaps will degrade injection quality.
