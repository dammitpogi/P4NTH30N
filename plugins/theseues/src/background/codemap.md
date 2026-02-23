# Background Module Codemap

## Responsibility

The `src/background/` module manages long-running AI agent tasks executing asynchronously in isolated sessions with **sophisticated model fallback and error recovery**. Key responsibilities:

- **Fire-and-forget task execution** - Returns `task_id` immediately, continues processing in background
- **Automatic model fallback chains** - Tries multiple models when primary model fails (provider errors, rate limits)
- **Circuit breaker pattern** - Temporarily skips unhealthy models based on consecutive failure tracking
- **Context length error recovery** - Automatically compacts session context and retries on "too many tokens" errors
- **Completion detection** - Event-driven via `session.status`, with polling fallback for reliability
- **Concurrency control** - Configurable limit on simultaneous task starts (default: 10)
- **Tool permission calculation** - Agents that cannot delegate have delegation tools disabled entirely
- **Tmux integration** - Spawns/closes tmux panes for visual monitoring (optional)
- **Config persistence** - Persists model health state to user's `oh-my-opencode-theseus.json`

## Design

### Core Abstractions

#### BackgroundTask Interface
Complete lifecycle tracking for a background task:
- **id**: Unique identifier (`bg_<random>`)
- **sessionId**: OpenCode session ID (set when starting)
- **description**: Human-readable task description
- **agent**: Agent name handling the task
- **status**: `pending` | `starting` | `running` | `completed` | `failed` | `cancelled`
- **result**: Final output from agent (when completed)
- **error**: Error message (when failed)
- **config**: Task configuration
- **parentSessionId**: Parent session for notifications
- **startedAt**: Creation timestamp
- **completedAt**: Completion/failure timestamp
- **prompt**: Initial prompt sent to agent
- **fallbackInfo**: Fallback tracking (attempts, successfulModel, occurred)

#### FallbackInfo & FallbackAttempt
Tracks model fallback events:
- **occurred**: Boolean indicating if fallback was used
- **attempts**: Array of `{model, success, error?, timestamp}`
- **successfulModel**: Model that ultimately succeeded
- **totalAttempts**: Number of models tried

#### LaunchOptions
Configuration for launching tasks:
- **agent**: Agent to handle the task
- **prompt**: Initial prompt
- **description**: Human-readable description
- **parentSessionId**: Parent session ID

### Key Design Patterns

#### 1. **Model Chain Fallback Pattern**
Two-tier model chain resolution:
- **Full chain**: Retrieved from config via `getFullModelChain()` (checks `agents[agent].models`, then `agents[agent].model`, then `HARDCODED_DEFAULTS`)
- **Filtered chain**: Applies circuit breaker via `resolveFallbackChain()` to skip unhealthy models
- If filtered chain is empty (all models tripped circuit breaker), logs warning and **bypasses circuit breaker** to try full chain anyway (fail-fast behavior)

#### 2. **Circuit Breaker Pattern**
Tracks model health in `config.fallback.triage`:
- **Threshold**: 3 consecutive failures opens circuit
- **Cooldown**: 1 hour before retrying failed models
- **Metrics stored**: `{failureCount, lastFailure, lastSuccess?}`
- **Persistence**: Health state written to `oh-my-opencode-theseus.json` via `persistConfig()`
- **Auto-reset**: Success sets `failureCount = 0`

#### 3. **Context Length Auto-Recovery**
Integrated into fallback loop:
- Detects context errors via `isContextLengthError()` pattern matching
- Attempts **compaction + single retry** before falling back to next model
- Compaction triggered via `/compact` command on session
- Falls back to next model if compaction fails

#### 4. **Provider Error-Based Fallback Decision**
In fallback loop, distinguishes error types:
- **Provider errors** (rate limits, model unavailable, auth failures): trigger fallback to next model
- **Non-provider errors** (validation, prompt errors): fail immediately without fallback
- Detection via `detectProviderError()` with 25+ regex patterns

#### 5. **Start Queue with Concurrency Control**
- `startQueue` array stores pending tasks
- `activeStarts` counter tracks in-flight starts
- `processQueue()` loops while `activeStarts < maxConcurrentStarts`
- Prevents overwhelming system with simultaneous session creation

#### 6. **Event-Driven Completion Detection**
- Listens to `session.status` events instead of polling
- Detects `status.type === 'idle'` as completion signal
- Extracts final output from assistant messages
- **Fallback reliability**: TmuxSessionManager uses polling fallback; BackgroundTaskManager relies solely on events

#### 7. **Dual-Index Task Tracking**
- `tasks`: Map<taskId, BackgroundTask>
- `tasksBySessionId`: Map<sessionId, taskId> for event → task lookup
- `agentBySessionId`: Map<sessionId, agentName> for delegation permission checks

#### 8. **Promise-Based Waiting with Timeout**
- `completionResolvers`: Map<taskId, (task) => void>
- `waitForCompletion(taskId, timeout)` returns promise that resolves on completion
- Timeout (0 = no timeout) optional

#### 9. **Race-Condition Safe Cancellation**
- Sets status to `cancelled` **before** `completeTask()`
- Checks status after `activeStarts++` in `startTask()` to catch cancellation during queued → starting transition
- Uses type assertion to bypass TS strictness (intentional design)

#### 10. **Tool Permission Calculation**
- `calculateToolPermissions(agentName)` returns `{background_task, task}` booleans
- Leaf agents (no delegation rules) get both tools **disabled completely**
- Delegating agents get tools enabled; `isAgentAllowed()` enforces which subagents are allowed

### Classes

#### BackgroundTaskManager
Main orchestrator for background task lifecycle and model fallback.

**State**:
- `tasks: Map<string, BackgroundTask>`
- `tasksBySessionId: Map<string, string>`
- `agentBySessionId: Map<string, string>` (agent ownership for delegation checks)
- `client: OpencodeClient`
- `directory: string`
- `tmuxEnabled: boolean`
- `config?: PluginConfig`
- `backgroundConfig: BackgroundTaskConfig`
- `startQueue: BackgroundTask[]`
- `activeStarts: number`
- `maxConcurrentStarts: number`
- `completionResolvers: Map<string, (task) => void>`
- `CIRCUIT_BREAKER_THRESHOLD = 3`
- `CIRCUIT_BREAKER_COOLDOWN_MS = 3600000`

**Key Methods**:
- `launch(opts): BackgroundTask` - Create and queue task (sync return, async start)
- `handleSessionStatus(event)` - Process `session.status` events for completion detection
- `isAgentAllowed(parentSessionId, requestedAgent): boolean` - Delegation permission check
- `getAllowedSubagents(parentSessionId): readonly string[]` - List allowed delegation targets
- `getResult(taskId): BackgroundTask | null` - Retrieve task state
- `waitForCompletion(taskId, timeout): Promise<BackgroundTask | null>` - Wait for completion
- `cancel(taskId?: string, reason?: string): number` - Cancel task(s) with an optional reason
- `cleanup(): void` - Release all resources
- `startTask(task): Promise<void>` - Complex orchestration including model fallback loop
- `extractAndCompleteTask(task): Promise<void>` - Fetch messages, extract content
- `completeTask(task, status, result): void` - Update state, clean maps, notify parent
- `sendCompletionNotification(task): Promise<void>` - Send message to parent session
- `getFullModelChain(agentName): string[]` - Resolve full model chain from config/defaults
- `resolveFallbackChain(agentName): string[]` - Apply circuit breaker filtering
- `recordModelFailure(model): Promise<void>` - Increment failure count, persist
- `recordModelSuccess(model): Promise<void>` - Reset failure count, persist
- `calculateToolPermissions(agentName): {background_task, task}` - Determine tool visibility
- `promptWithTimeout(args, timeoutMs): Promise<void>` - Wrap promptAsync with timeout
- `compactAndRetry(sessionId, promptFn): Promise<void>` - Compact context and retry once
- `isContextLengthError(error): boolean` - Pattern-match context errors
- `persistConfig(): Promise<void>` - Write config file to user directory (includes safety check to prevent empty config writes)

#### TmuxSessionManager
Manages tmux pane lifecycle for visual monitoring of background sessions.

**State**:
- `client: OpencodeClient`
- `tmuxConfig: TmuxConfig`
- `serverUrl: string`
- `sessions: Map<string, TrackedSession>`
- `pollInterval?: ReturnType<typeof setInterval>`
- `enabled: boolean`

**TrackedSession Interface**:
- `sessionId: string`
- `paneId: string`
- `parentId: string`
- `title: string`
- `createdAt: number`
- `lastSeenAt: number`
- `missingSince?: number`

**Key Methods**:
- `onSessionCreated(event): Promise<void>` - Spawn tmux pane for child sessions
- `onSessionStatus(event): Promise<void>` - Close pane when session becomes idle
- `startPolling(): void` - Start polling interval
- `stopPolling(): void` - Stop interval
- `pollSessions(): Promise<void>` - Fallback polling for status
- `closeSession(sessionId): Promise<void>` - Close pane and remove tracking
- `cleanup(): Promise<void>` - Close all panes and stop polling

### Interfaces & Types

**SessionEvent** (shared):
- `type: string` (`session.created`, `session.status`)
- `properties?: { info?, sessionID?, status? }`

**PromptBody** (internal):
- `messageID?, model?, agent?, noReply?, system?, tools?, parts[], variant?`

**OpencodeClient** (type alias)**: `PluginInput['client']`

### Constants
- `HARDCODED_DEFAULTS`: Default models per agent type (all `openrouter-free/openrouter/free`)
- `SESSION_TIMEOUT_MS = 10 * 60 * 1000` (10 minutes)
- `SESSION_MISSING_GRACE_MS = POLL_INTERVAL_BACKGROUND_MS * 3`

### Utilities

**detectProviderError(errorMessage): boolean**
- 25+ regex patterns for: rate limits, context/token limits, model unavailable, credit/quota exceeded, HTTP429/503/504, auth failures, network errors, agent errors, provider failures

**parseModelReference(model): {providerID, modelID} | null**
- Parses `"provider/model"` format, validates slash position

## Flow

### Task Launch Flow (Fire-and-Forget)

```
User calls launch(opts)
  ↓
Create BackgroundTask {id, status='pending', ...}
  ↓
Store in tasks Map
  ↓
enqueueStart() → push to startQueue
  ↓
processQueue() checks: activeStarts < maxConcurrentStarts
  ↓
startTask(task) executes (async, modifies activeStarts)
  ↓
  ├─ Set status='starting'
  ├─ Increment activeStarts
  ├─ Check if cancelled (race condition)
  ├─ Create OpenCode session (client.session.create)
  ├─ Store sessionId in tasksBySessionId and agentBySessionId
  ├─ Set status='running'
  ├─ If tmuxEnabled: await 500ms (allow pane spawn)
  ├─ calculateToolPermissions(task.agent)
  ├─ Resolve model chain (getFullModelChain + resolveFallbackChain)
  ├─ Initialize fallbackInfo.attempts = []
  └─ Fallback loop (for each model in chain):
      ├─ Build PromptBody with agent variant
      ├─ promptWithTimeout(timeoutMs = fallback.timeoutMs or 15000)
      ├─ If success: recordModelSuccess(model), mark occurred, break
      ├─ If error:
      │   ├─ If context length error:
      │   │ └─ compactAndRetry() → retry once
      │   ├─ If provider error:
      │   │   ├─ recordModelFailure(model)
      │   │   └─ continue to next model
      │   └─ If non-provider error:
      │       └─ throw (break loop, fail task)
      └─ If no models succeed: throw aggregate error
  ↓
Decrement activeStarts, processQueue()
 ↓
Returns to caller immediately (task still pending/running)
```

### Completion Detection Flow

```
session.status event received (event.type === 'session.status')
  ↓
handleSessionStatus(event)
  ↓
Lookup taskId from tasksBySessionId[event.properties.sessionID]
  ↓
If task not found or task.status !== 'running': return
  ↓
Check if event.properties.status.type === 'idle'
  ↓
extractAndCompleteTask(task)
  ↓
Fetch messages: client.session.messages({path: {id: task.sessionId}})
  ↓
Filter assistant messages, extract text/reasoning parts
  ↓
Join content → responseText
  ↓
If no responseText:
  ├─ Check for error messages in session → completeTask('failed', error)
  ├─ Else if fallbackInfo.totalAttempts > 0 → completeTask('failed', 'All models failed')
  └─ Else → completeTask('completed', '(No output)')
  ↓
completeTask(task, status, resultOrError)
  ↓
  ├─ Set task.status, task.completedAt
  ├─ If status='completed': task.result = result; else task.error = result
  ├─ Delete from tasksBySessionId and agentBySessionId
  ├─ sendCompletionNotification(task) → parent session message
  ├─ Resolve completionResolvers[task.id]
  └─ Log completion
```

### Cancellation Flow

```
User calls cancel(taskId?, reason?) (optional taskId = cancel all)
  ↓
Find tasks with status in ['pending', 'starting', 'running']
  ↓
For each task:
  ├─ Delete from completionResolvers
  ├─ If status === 'pending': check if in startQueue (before status change)
  ├─ Set status = 'cancelled' (FIRST, prevents race with startTask)
  ├─ If was pending: remove from startQueue
  └─ completeTask(task, 'cancelled', reason)

Cancellation attribution:
- `cancel()` now logs a structured entry (`[background-manager] cancel requested`) including `taskId` (or `ALL`) and the provided `reason`.
- The cancellation reason is stored on the task as `task.error` (since `cancelled` is a non-success terminal state).
- Parent-session completion notifications distinguish `cancelled` from `failed` and include the reason.
```

### Model Fallback Flow (startTask detail)

```
Get full model chain from config:
  agents[agent].models → agents[agent].model → HARDCODED_DEFAULTS[agent]
  ↓
Call resolveFallbackChain() to apply circuit breaker:
  For each model in chain:
    Check triage[model] in config.fallback.triage
    If failureCount >=3 AND now - lastFailure < 1 hour: skip (circuit open)
    Else include
  ↓
If filteredChain empty: log warning, use fullChain (bypass circuit breaker)
  ↓
attemptModels = filteredChain.length > 0 ? filteredChain : fullChain
  ↓
For each model in attemptModels (record attemptCount):
  ├─ Build PromptBody with model reference (providerID/modelID)
  ├─ Try promptWithTimeout(timeoutMs)
  │   ├─ Success: recordModelSuccess(model), break loop
  │   └─ Error (catch):
  │       ├─ If context length error:
  │       │   Try compactAndRetry(sessionId, promptFn)
  │       │   If success after compaction: continue to next iteration (mark succeeded)
  │       │   If compaction fails: continue to next model
  │       ├─ If provider error (detectProviderError):
  │       │   recordModelFailure(model)
  │       │   Push attempt {model, success:false, error}
  │       │   Continue to next model
  │       └─ Else (non-provider error):
  │           Push attempt, throw (breaks loop, task fails)
  ↓
If loop completes without success:
  Throw: "All fallback models failed after N attempts. errors.join(' | ')"
  ↓
catch (error):
  completeTask(task, 'failed', error.message)
```

### Circuit Breaker Flow

```
recordModelFailure(model):
  ↓
Get triage = config.fallback.triage (create if missing)
  ↓
existingHealth = triage[model] ?? {failureCount: 0}
  ↓
failureCount = existingHealth.failureCount + 1
  ↓
triage[model] = {failureCount, lastFailure: now, ...existingHealth}
  ↓
persistConfig() → write to ~/.config/opencode/oh-my-opencode-theseus.json
```

```
recordModelSuccess(model):
  ↓
If triage[model] exists:
  triage[model] = {...existing, failureCount: 0, lastSuccess: now}
  ↓
persistConfig()
```

```
resolveFallbackChain(agentName):
  ↓
fullChain = getFullModelChain(agentName)
  ↓
availableChain = fullChain.filter(model => {
  health = triage[model]
  If !health or !health.lastFailure: true
  Else if failureCount >= 3 AND now - lastFailure < 3600000: false (skip)
  Else: true
})
  ↓
Return availableChain
```

### Context Length Recovery Flow

```
During fallback loop, catch error:
  ↓
if isContextLengthError(error.message):
  Try:
    compactAndRetry(sessionId, async () => {
      promptWithTimeout(promptArgs, timeoutMs)
    })
    If success: succeeded = true, break loop
  Catch (compaction fails):
    Continue to next model
```

```
compactAndRetry(sessionId, promptFn):
  ↓
client.session.command({path: {id: sessionId}, body: {command: 'compact'}})
  ↓
await promptFn()  (retry original prompt)
```

### Tmux Integration Flow

```
Plugin startup:
  new TmuxSessionManager(ctx, tmuxConfig)
  ↓
Constructor: enabled = tmuxConfig.enabled && isInsideTmux()
  ↓
Event handlers registered:
  TmuxSessionManager.onSessionCreated(event)
  TmuxSessionManager.onSessionStatus(event)
```

```
onSessionCreated(event):
  If !enabled or event.type !== 'session.created': return
  If no info.id or info.parentID: return (not a child session)
  If already tracking: return
  spawnTmuxPane(sessionId, title, tmuxConfig, serverUrl)
  └─ spawns pane with: tmux split-window -h -P -F "#{pane_id}" "open" serverUrl "?sessionId=..."
  ↓
If success: sessions.set(sessionId, {sessionId, paneId, parentId, title, createdAt, lastSeenAt})
  ↓
startPolling() (starts setInterval if not already running)
```

```
onSessionStatus(event):
  If !enabled or event.type !== 'session.status': return
  If event.properties.status.type === 'idle':
    closeSession(sessionId)
```

```
pollSessions() (runs every POLL_INTERVAL_BACKGROUND_MS, default 5000):
  ↓
client.session.status() → fetch all session statuses
  ↓
For each tracked session [sessionId, tracked]:
  status = allStatuses[sessionId]
  If status found: lastSeenAt = now, missingSince = undefined
  If not found and no missingSince: missingSince = now
  isIdle = status?.type === 'idle'
  missingTooLong = missingSince && (now - missingSince >= SESSION_MISSING_GRACE_MS)
  isTimedOut = now - createdAt > SESSION_TIMEOUT_MS (10 min)
  If isIdle OR missingTooLong OR isTimedOut:
    closeSession(sessionId)
 ↓
If sessions.size === 0: stopPolling()
```

```
closeSession(sessionId):
  ↓
tracked = sessions.get(sessionId)
  closeTmuxPane(tracked.paneId)
  sessions.delete(sessionId)
  If sessions.size === 0: stopPolling()
```

### Config Persistence Flow

```
recordModelFailure/recordModelSuccess calls:
  ↓
persistConfig()
  ↓
Safety Check: Validate config has content and structure
  ├─ hasContent = Object.keys(this.config).length > 0
  ├─ hasAgents = this.config.agents exists and has entries
  ├─ hasPresets = this.config.presets exists and has entries
  └─ If !hasContent OR (!hasAgents AND !hasPresets):
       Log warning and ABORT (prevents config deletion bug)
  ↓
Find config file (search order):
  1. ~/.config/opencode/oh-my-opencode-theseus.json
  2. this.directory/oh-my-opencode-theseus.json
  3. this.directory/.opencode/oh-my-opencode-theseus.json
  ↓
If found: fs.writeFile(configPath, JSON.stringify(this.config, null, 2), 'utf-8')
  (this.config includes fallback.triage with updated failure counts)
```

**Safety Check Purpose:** Prevents the "config deletion bug" where an empty config object `{}` (default when parsing fails) would overwrite and wipe the user's configuration. The check ensures the config has actual content with either agents or presets defined before writing to disk.

## Integration

### Dependencies

#### Internal Dependencies
- `@opencode-ai/plugin`: `PluginInput` type, `client` API (`session.create`, `session.promptAsync`, `session.messages`, `session.status`, `session.command`)
- `../config`: `BackgroundTaskConfig`, `PluginConfig`, `TmuxConfig`, `FALLBACK_FAILOVER_TIMEOUT_MS`, `SUBAGENT_DELEGATION_RULES`, `POLL_INTERVAL_BACKGROUND_MS`
- `../utils`: `applyAgentVariant`, `resolveAgentVariant`, `log`, `spawnTmuxPane`, `closeTmuxPane`, `isInsideTmux`

#### External Dependencies
- None (uses only OpenCode SDK and Node.js built-ins: `fs/promises`, `path`, `os` for config persistence)

### Consumers

#### Direct Consumers
- Main plugin entry point (`src/index.ts`) - exports classes
- Background task skill (`src/skills/background-task.ts`) - calls `launch()`, `getResult()`, `waitForCompletion()`, `cancel()`
- OpenCode event system (event handlers registered to `BackgroundTaskManager` and `TmuxSessionManager`)

#### Integration Points

1. **Plugin Initialization** (in `src/index.ts`)
   - `new BackgroundTaskManager(ctx, tmuxConfig, pluginConfig)`
   - `new TmuxSessionManager(ctx, tmuxConfig)`
   - Event handlers registered

2. **Event Handling**
   - `BackgroundTaskManager.handleSessionStatus()` receives `session.status` events, maps `sessionId` → `taskId`, triggers `extractAndCompleteTask()` on `idle`
   - `TmuxSessionManager.onSessionCreated()` spawns tmux pane for child sessions
   - `TmuxSessionManager.onSessionStatus()` closes pane on `idle`
   - `TmuxSessionManager.pollSessions()` provides fallback reliability

3. **Skill Integration**
   - Background task skill calls `launch()` with `agent`, `prompt`, `description`, `parentSessionId`
   - Skill calls `getResult(taskId)` to poll task state
   - Skill calls `waitForCompletion(taskId, timeout)` to await result
   - Skill calls `cancel(taskId)` to abort tasks

4. **Delegation Permission Enforcement**
   - `BackgroundTaskManager.isAgentAllowed(parentSessionId, requestedAgent)` restricts which agents a parent session can spawn
   - `BackgroundTaskManager.calculateToolPermissions(agentName)` determines whether `background_task` and `task` tools are visible
   - `agentBySessionId` map tracks agent ownership of sessions

5. **Cleanup**
   - Plugin shutdown calls `bgManager.cleanup()` and `tmuxManager.cleanup()`
   - Releases all Maps, stops polling, closes all tmux panes

### Configuration

#### BackgroundTaskConfig
- `maxConcurrentStarts: number` (default: 10)

#### TmuxConfig
- `enabled: boolean`
- Other tmux-specific settings (see `../config/schema.ts`)

#### PluginConfig
- `background?: BackgroundTaskConfig`
- `fallback?: {enabled?: boolean, timeoutMs?: number, triage?: Record<string, {failureCount, lastFailure?, lastSuccess?}>}`
- `agents?: Record<string, {model?: string, models?: string[], ...}>`

#### Model Resolution Order (getFullModelChain)
1. `config.agents[agentName].models` (preferred full chain)
2. `config.agents[agentName].model` (single model)
3. `HARDCODED_DEFAULTS[agentName]` (fallback)
4. Returns `[]` if none found

### Error Handling

- **Session creation failures**: Caught in `startTask()`, completeTask('failed', errorMessage)
- **Prompt failures**: Provider errors trigger next model; non-provider errors fail task immediately
- **Context length errors**: Trigger compaction + retry, then continue to next model if fails
- **Message extraction failures**: Caught in `extractAndCompleteTask()`, completeTask('failed')
- **Tmux pane spawn failures**: Logged but do NOT fail task (task continues)
- **Polling errors**: Caught in `pollSessions()`, logged, polling continues
- **Notification failures**: Caught in `sendCompletionNotification()`, logged
- **Config persistence failures**: Caught in `persistConfig()`, logged; doesn't fail operation
- **Circuit breaker**: No errors thrown; simply filters model chain

### Logging

All operations logged with `[component-name]` prefix and structured metadata:
- `[background-manager]`: task launched/started/completed/failed
- `[fallback]`: model chain resolution, attempt outcomes, warnings
- `[circuit-breaker]`: failure recording, skipping models, cooldown expirations
- `[compact]`: compaction triggers and results
- `[tmux-session-manager]`: pane spawn, close, polling lifecycle
- `[config]`: config file discovery, persistence

---

## Change Summary (Recent Updates)

### New Capabilities Added
1. **Model fallback chains** with automatic switching on provider errors
2. **Circuit breaker** for temporary model blacklisting based on failures
3. **Context length auto-recovery** via compaction + retry
4. **Persistent model health** state across plugin restarts
5. **Tool permission calculation** based on agent delegation rules

### Enhanced Patterns
- `startTask()` now includes complex fallback loop with error classification
- `extractAndCompleteTask()` includes fallback error summarization
- `sendCompletionNotification()` adds fallback success notice to parent
- `persistConfig()` writes health state to user config directory
- `handleSessionStatus()` uses event-driven completion (reliable without polling)

### Interface Extensions
- `BackgroundTask.fallbackInfo?: FallbackInfo`
- `FallbackInfo` and `FallbackAttempt` types added

### Configuration Changes
- `config.fallback` object: `{enabled, timeoutMs, triage: {[model]: {failureCount, lastFailure, lastSuccess?}}}`
- `config.agents[agent].models` (array) or `config.agents[agent].model` (string) for full fallback chains
