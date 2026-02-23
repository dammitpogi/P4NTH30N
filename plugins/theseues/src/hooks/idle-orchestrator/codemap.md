# src/hooks/idle-orchestrator/

## Responsibility

Proactively prompts the Orchestrator when a main session becomes idle, so background task results can flush (via `client.session.promptAsync`) and the orchestrator can propose next work.

## Design

- Exposes `createIdleOrchestratorHook(ctx, options)`.
- Tracks idle state per session with an in-memory `Map<sessionID, IdleTracker>`.
- Guards:
  - respects `IdleOrchestratorConfig.enabled`.
  - only reacts to `session.status` events.
  - attempts to verify the session is a main session (skips background sessions by checking `parentID`).
- Prompt cadence:
  - `idleTimeoutMs`: how long the session must remain idle.
  - `minPromptIntervalMs`: throttles repeated prompts.

## Flow

1. Receive `session.status` event.
2. On `idle`: create tracker or update timers; when thresholds pass, call `sendProactivePrompt()`.
3. On `busy`: delete tracker and stop prompting.
4. `sendProactivePrompt()` posts a small `<Proactive Work>` message into the session.

## Integration

- Hook is registered during plugin initialization (`src/index.ts`).
- Uses the OpenCode client API (`ctx.client.session.get`, `ctx.client.session.promptAsync`).
- Options type comes from config schema (`IdleOrchestratorConfig`).
