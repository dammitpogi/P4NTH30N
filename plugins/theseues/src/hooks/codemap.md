# src/hooks/

This directory exposes the public hook entry points that feature code imports to tap into behavior such as update checks, phase reminders, post-read nudges, and idle orchestrator.

## Responsibility

It acts as a single entry point that re-exports the factory functions and option types for every hook implementation underneath `src/hooks/`, so other modules can `import { createAutoUpdateCheckerHook, AutoUpdateCheckerOptions } from 'src/hooks'` without needing to know the subpaths.

### Hooks Available

1. **AutoUpdateChecker** - Checks for plugin updates on startup
2. **PhaseReminder** - Reminds users of workflow phases during tasks
3. **PostReadNudge** - Nudges users after reading files
4. **IdleOrchestrator** - Proactively prompts the Orchestrator when idle to flush background task results

## Design

- **Aggregator/re-export pattern**: `index.ts` consolidates factories (`createAutoUpdateCheckerHook`, `createPhaseReminderHook`, `createPostReadNudgeHook`, `createIdleOrchestratorHook`) and shared types so the rest of the app depends only on this flat namespace.
- **Factory-based design**: Each hook implementation follows a factory pattern; callers receive a configured hook instance by passing structured options through the exported creator functions.
- **Event-driven**: All hooks respond to OpenCode session events (`session.status`, etc.)

## Hooks Detail

### IdleOrchestrator Hook
Keeps the Orchestrator "busy" so background task results can auto-flush via `client.session.promptAsync()`.

**Configuration** (`IdleOrchestratorConfig`):
- `enabled: boolean` - Enable/disable the hook
- `idleTimeoutMs: number` - How long session must be idle before prompting (default: 30000ms)
- `minPromptIntervalMs: number` - Minimum time between prompts (default: 120000ms)

**Behavior**:
1. Tracks sessions that become `idle`
2. After `idleTimeoutMs` of idle time, sends a proactive prompt
3. Prompt asks Orchestrator to check for background task results
4. If still idle after processing, suggests potential next work (TODOs, FIXME, docs updates)
5. Resumes tracking when session becomes `busy` again

## Flow

```
Callers import a factory from `src/hooks`, supply any typed options (e.g., `IdleOrchestratorOptions`), and the factory wires together the hook's internal checks/side-effects before returning the hook interface that the feature layer consumes.

Event flow for IdleOrchestrator:
  session.status event (idle)
    → Verify session is main (not background)
    → Start idle tracking
    → After idleTimeoutMs + minPromptIntervalMs
    → sendProactivePrompt() via promptAsync
    → Update lastPromptTime

  session.status event (busy)
    → Remove from idle tracking
```

## Integration

- Feature modules across the app import everything through `src/hooks/index.ts`; there are no direct relations to deeper hook files, keeping consumers ignorant of the implementation details.
- Option types such as `AutoUpdateCheckerOptions` and `IdleOrchestratorConfig` are shared from this file so both the hook creator and its consumers agree on the configuration contract.
- Hooks are registered in `src/index.ts` during plugin initialization
