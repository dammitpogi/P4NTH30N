# src/hooks/

## Responsibility

Provides lifecycle hooks that intercept and modify OpenCode plugin behavior at key points in the execution flow. The hooks system enables cross-cutting concerns like update checking, workflow compliance enforcement, and task management optimization through event interception and message transformation.

## Design

### Core Architecture Pattern
**Factory-based Hook System**
- Each hook exports a factory function that returns a configured hook instance
- Options types are shared between hook creators and consumers
- Hooks registered through OpenCode's experimental hook registry
- Event-driven architecture with message transformation capabilities

### Hook Types
1. **AutoUpdateChecker** - Background update monitoring and installation
2. **PhaseReminder** - Workflow compliance enforcement through message injection
3. **PostReadNudge** - Delegation encouragement after file operations
4. **IdleOrchestrator** - Proactive background task flushing

### Entry Point Pattern
- `index.ts` serves as the central re-export hub
- Flat namespace pattern: `import { createAutoUpdateCheckerHook, AutoUpdateCheckerOptions } from 'src/hooks'`
- No direct imports from subdirectories, keeping implementation details hidden

## Flow

### Hook Registration Flow
```
Plugin Startup
    ↓
Register hook factories from src/hooks/index.ts
    ↓
OpenCode experimental hook registry receives hooks
    ↓
Hooks activated on respective events
```

### Message Transformation Flow
```
User Input → Message Processing
    ↓
Hook receives outgoing messages array
    ↓
Hook inspects messages (finds last user message)
    ↓
Hook modifies message content (if applicable)
    ↓
Transformed messages sent to API
    ↓
Hook effect appears in next response
```

### Event Interception Flow
```
Session Event → Hook Handler
    ↓
Event validation (session type, agent ownership)
    ↓
Business logic execution
    ↓
Side effects (UI updates, logging, task creation)
    ↓
Event propagation continues
```

## Integration

### Dependencies
- **OpenCore SDK**: Event system (`session.created`, `experimental.chat.messages.transform`)
- **Utils Module**: Logging, configuration management, tmux integration
- **CLI Config**: Plugin configuration, version management, update checking
- **Plugin Core**: Main plugin entry point for hook registration

### Consumers
1. **Direct Consumers**
   - `src/index.ts` - Main plugin entry point registers all hooks
   - OpenCode event system - Receives hook events and processes them

2. **Hook-Specific Integrations**
   - **AutoUpdateChecker**: Integrates with CLI config manager for version detection
   - **PhaseReminder**: Integrates with message flow for workflow compliance
   - **PostReadNudge**: Integrates with file operations for delegation encouragement
   - **IdleOrchestrator**: Integrates with background task management

### Configuration Integration
Hooks respect user preferences through typed option interfaces:
- `AutoUpdateCheckerOptions`: `autoUpdate`, `showStartupToast`
- `PhaseReminderOptions`: Enabled/disabled state
- `PostReadNudgeOptions`: Nudge frequency and content
- `IdleOrchestratorOptions`: Timeout settings and prompt configuration

### Event Flow Integration
- **session.created**: Triggered by new sessions, used for startup hooks
- **experimental.chat.messages.transform**: Message preprocessing before API calls
- **tool.execute.after**: Post-operation hooks for task completion

### Error Handling
- Graceful degradation: Hook failures don't break main functionality
- Logging: All hook operations logged with structured metadata
- Fallback mechanisms: Default behavior when hooks are unavailable

### Performance Considerations
- Lazy initialization: Hooks only activated when needed
- Memoization: Expensive operations cached between runs
- Minimal overhead: Message transformation is lightweight
- Event filtering: Hooks only process relevant events
