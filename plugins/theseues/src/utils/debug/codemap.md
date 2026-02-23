# src/utils/debug/

## Responsibility

Implements a best-effort debug logging framework with configurable verbosity and output targets (console and/or file). This is designed to replace ad-hoc `console.*` logging in runtime code.

## Design

- `logger.ts` exports:
  - `DebugLevel` enum (SILENT..TRACE)
  - `debug` singleton (`DebugLogger`) configured from `~/.config/opencode/.debug/debug.json`.
  - Convenience wrappers (`log`, `error`, `warn`, `info`, `debugMsg`, `trace`).
- Configuration loading is defensive:
  - uses defaults if config missing or JSON parse fails.
  - supports relative log path resolution rooted at `~/.config/opencode/`.
- File writes are synchronous and wrapped in try/catch to avoid breaking plugin runtime.

## Flow

1. Module loads and calls `loadDebugConfig()`.
2. `DebugLogger.log()` checks level gate and formats message with ISO timestamp.
3. If enabled, logs to console; if configured, appends to log file (creating directories as needed).

## Integration

- Re-exported through `src/utils/debug.ts` as `../utils/debug`.
- Used by runtime modules that want structured debug output (for example `src/background/background-manager.ts`).
