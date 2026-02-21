# Tool Output: tool_c69771a4000110xQJaTaCiUKUz
**Date**: 2026-02-17 02:38:59 UTC
**Size**: 154,519 bytes

```

C:\Users\paulc\.config\opencode\dev\AGENTS.md:
  194: - **Impact**: Enables the fallback mechanism to work correctly when agent permission is denied. Previously, the returned string was being treated as a success response, bypassing fallback logic.
  250: - If compaction fails, the system proceeds to model fallback
  254: - Compaction and retry logic (lines 524-540)
  264: ### Model Fallback Chains
  265: Configure automatic model fallback when primary models fail due to provider errors.
  285: - **Provider errors** (rate limits, context length, service unavailable) trigger fallback
  286: - **Validation errors** fail immediately without fallback
  287: - Each agent type has its own fallback chain
  305:   - `retryWithNextModel()` - Uses current model tracking instead of faulty fallbackInfo lookup
  307: **Tracked Metrics** (in `agents.<agent>.currentModel` and `fallback.triage`):
  314: Previously, the system relied on `fallbackInfo` lookups which could become stale or incorrect during retries. The new current model tracking ensures:
  317: - Proper fallback chain progression on retries
  426: - **Path Resolution**: Config loader uses `os.homedir()` for cross-platform path resolution, ensuring fallback chains and presets from `~/.config/opencode/oh-my-opencode-theseus.json` are loaded correctly on all platforms (including Windows)

C:\Users\paulc\.config\opencode\dev\codemap.md:
  11: - **Model management** - Comprehensive model research and per-agent model assignments with fallback chains
  30: - Agent model fallback chains provide resilience and cost optimization
  76: 2. On failure/timeout → fallback chain traversed automatically
  77: 3. Fallback triage tracked (`oh-my-opencode-theseus.json` → `fallback.triage`)
  136: - `plugin/src/background/` - Background task execution with fallback chains

C:\Users\paulc\.config\opencode\dev\CHANGELOG.md:
  8: - **Model Fallback**: Corrected hardcoded default model IDs and cleared stale triage state to ensure reliable agent communication.

C:\Users\paulc\.config\opencode\dev\skills\openai-usage\SKILL.md:
  23: - No manual fallback. If Codex rate limits are unavailable, return an actionable error.

C:\Users\paulc\.config\opencode\dev\ref\codemap.md:
  49: - Background task management with model fallback
  123: | Background Tasks | Full tmux integration | Model fallback, compaction |

C:\Users\paulc\.config\opencode\dev\src\index.ts:
  42:     hasFallback: !!config?.fallback,

C:\Users\paulc\.config\opencode\dev\src\utils\tmux.ts:
  17:  * This is needed because ctx.serverUrl may return a fallback URL even when no server is running.
  212:   // This is needed because serverUrl may be a fallback even when no server is running

C:\Users\paulc\.config\opencode\dev\skills\model-tester\SKILL.md:
  68: Read `oh-my-opencode-theseus.json`, find the `fallback.triage` section, and add failed models:

C:\Users\paulc\.config\opencode\dev\src\cli\codemap.md:
  124:    - Kimi > OpenAI > Zen-free (fallback)

C:\Users\paulc\.config\opencode\dev\src\config\constants.ts:
  59: export const FALLBACK_FAILOVER_TIMEOUT_MS = 15_000;

C:\Users\paulc\.config\opencode\dev\src\config\loader.ts.backup:
  138:   // Also check the project directory as fallback
  175:     hasFallback: !!config?.fallback 
  183:     const mergedFallback = deepMerge(config.fallback, projectConfig.fallback);
  189:       fallback: mergedFallback,

C:\Users\paulc\.config\opencode\dev\src\config\loader.ts:
  173:   // Also check the project directory as fallback
  210:     hasFallback: !!config?.fallback 
  218:     const mergedFallback = deepMerge(config.fallback, projectConfig.fallback);
  224:       fallback: mergedFallback,

C:\Users\paulc\.config\opencode\dev\src\config\schema.ts:
  3: const FALLBACK_AGENT_NAMES = [
  12: export type FallbackAgentName = (typeof FALLBACK_AGENT_NAMES)[number];
  20:   models: z.array(z.string()).optional(), // Model fallback chain for this agent (first = default)
  89:   fallback: z.enum(['truncated']).default('truncated'),
  108: const FallbackChainsSchema = z
  122:   // Backward-compat fallback chains (legacy + CLI emitted)
  123:   chains: FallbackChainsSchema.optional(),
  133:       rateLimitRetryThreshold: z.number().min(1).max(20).default(5),
  140:       rateLimitRetryThreshold: 5,
  149:       fallbackToAlternativeModel: z.boolean().default(true),
  159:       fallbackToAlternativeModel: true,
  186:   fallback: FailoverConfigSchema.optional(),

C:\Users\paulc\.config\opencode\dev\src\cli\install.ts:
  590:           'No free Chutes models found. Continuing with fallback Chutes mapping.',
  711:       'No providers configured. Zen Big Pickle models will be used as fallback.',

C:\Users\paulc\.config\opencode\dev\src\agents\codemap.md:
  41: - Fallback mechanism: Fixer inherits Librarian's model if not configured
  71:   │   ├─→ Get model (with fallback for fixer)
  232: 5. **Fallback Model**: Fixer inherits Librarian's model for backward compatibility

C:\Users\paulc\.config\opencode\dev\src\background\tmux-session-manager.ts:
  120:       // Start polling for fallback reliability
  163:    * Poll sessions for status updates (fallback for reliability).
  199:         // Check for timeout as a safety fallback

C:\Users\paulc\.config\opencode\dev\src\cli\providers.ts:
  289:       models: modelInfo.models, // fallback chain
  314:     config.fallback = {
  398:   const getOpenCodeFallbackForAgent = (agentName: AgentName) => {
  413:   const getChutesFallbackForAgent = (agentName: AgentName) => {
  432:   const attachFallbackConfig = (presetAgents: Record<string, unknown>) => {
  460:         getChutesFallbackForAgent(agentName),
  461:         getOpenCodeFallbackForAgent(agentName),
  477:     config.fallback = {
  527:     attachFallbackConfig(
  548:     attachFallbackConfig(

C:\Users\paulc\.config\opencode\dev\src\cli\providers.test.ts:
  142:   test('generateLiteConfig emits fallback chains for six agents in presets', () => {
  157:     expect((config.fallback as any).enabled).toBe(true);
  158:     expect((config.fallback as any).timeoutMs).toBe(15000);
  159:     // Chains are emitted in fallback.chains
  160:     const chains = (config.fallback as any).chains;

C:\Users\paulc\.config\opencode\dev\src\utils\codemap.md:
  11: Each helper lives in its own module and re-exports through `src/utils/index.ts`, keeping public surface area flat. Key ideas include memoized state (cached TMUX path, server availability cache, stored layouts), configuration defaults fed from `../config` constants, defensive guards (abort checks, empty-string variants), and layered platform detection (Windows build/tar, PowerShell fallbacks). Logging is best-effort: synchronous file append inside a try/catch so it never throws upstream.
  15: Agent variant helpers normalize names, read `PluginConfig.agents`, trim/validate variants, and only mutate request bodies when a variant is missing; `log` simply timestamps and appends strings to a temp file. `pollUntilStable` loops with configurable intervals, fetch callbacks, and stability guards, honoring max time and abort signals before returning a typed `PollResult`. TMUX helpers scan for the binary (`which/where`), cache the result, verify layouts, spawn panes with `opencode attach`, reapply stored layouts on close, and guard against missing servers by checking `/health`. `extractZip` detects the OS (tar on modern Windows, pwsh/powershell fallback) before spawning native unpack commands and bubbling errors when processes fail.

C:\Users\paulc\.config\opencode\dev\src\agents\index.ts:
  90:   const triage = config?.fallback?.triage;

C:\Users\paulc\.config\opencode\dev\src\background\background-manager.test.ts:
  324:       expect(task.connectivityRetryCount).toBe(5);
  327:       expect(task.fallbackInfo?.occurred).toBe(false);
  618:         fallback: {
  673:         fallback: {
  716:       expect(config.fallback.triage[triagedModel]).toBeUndefined();
  745:         fallback: {
  772:     test('fails task when all fallback models fail', async () => {
  788:         fallback: {
  812:       expect(task.error).toContain('All fallback models failed');
  815:     test('uses legacy fallback.chains when agent models are missing', async () => {
  837:         fallback: {
  890:         fallback: {
  1060:     test('triggers fallback when Gemini quota error arrives as assistant text', async () => {
  1094:         fallback: {
  1121:       // Allow fallback retry to process
  1124:       // The quota error in assistant text should trigger fallback,

C:\Users\paulc\.config\opencode\dev\src\background\background-manager.ts.backup:
  19:   FALLBACK_FAILOVER_TIMEOUT_MS,
  51:     // Invalid model errors should trigger fallback
  56:     // Generic unknown errors should trigger fallback
  59:     // Auth and key errors should trigger fallback
  71:     // Agent-specific errors that should trigger fallback
  114:  * Represents a fallback attempt during task execution.
  116: export interface FallbackAttempt {
  124:  * Tracks fallback events for a background task.
  126: export interface FallbackInfo {
  128:   attempts: FallbackAttempt[];
  156:   fallbackInfo?: FallbackInfo; // Fallback tracking info
  183:   // Guaranteed fallback config with all required fields
  184:   private fallbackConfig!: {
  220:       hasFallback: !!config?.fallback,
  228:     // Initialize fallback config if not present
  229:     if (!this.config.fallback) {
  230:       this.config.fallback = {
  238:       if (!this.config.fallback.triage) {
  239:         this.config.fallback.triage = {};
  242:       if (!this.config.fallback.currentModels) {
  243:         this.config.fallback.currentModels = {};
  247:     // Store reference to guaranteed fallback config
  248:     this.fallbackConfig = this.config.fallback;
  272:         const currentModels = this.fallbackConfig.currentModels;
  276:           log(`[fallback] Initialized current model for ${agentName}: ${defaultModel}`);
  286:     this.fallbackConfig.currentModels[agentName] = model;
  293:     return this.fallbackConfig.currentModels[agentName];
  479:   private resolveFallbackChain(agentName: string): string[] {
  480:     const fallback = this.config?.fallback;
  487:       log(`[fallback] WARNING: No model chain for ${agentName}`);
  492:     const triage = fallback?.triage ?? {};
  513:     log(`[fallback] Resolved fallback chain for ${agentName}:`, {
  524:     if (!this.config?.fallback) {
  525:       log('[circuit-breaker] ERROR: No fallback config found');
  530:     if (!this.config.fallback.triage) {
  531:       this.config.fallback.triage = {};
  534:     const triage = this.config.fallback.triage;
  557:     if (!this.config?.fallback) return;
  560:     if (!this.config.fallback.triage) {
  561:       this.config.fallback.triage = {};
  564:     const triage = this.config.fallback.triage;
  663:       fallbackEnabled: this.config?.fallback?.enabled,
  721:         this.config?.fallback?.timeoutMs ?? FALLBACK_FAILOVER_TIMEOUT_MS;
  722:       const fallbackEnabled = this.config?.fallback?.enabled ?? true;
  727:       const filteredChain = fallbackEnabled
  728:         ? this.resolveFallbackChain(task.agent)
  735:       log(`[fallback] Model chain for ${task.agent}:`, {
  744:         log(`[fallback] WARNING: All models filtered by circuit breaker, bypassing for task ${task.id}`, {
  750:       // Initialize fallback tracking
  751:       task.fallbackInfo = {
  761:       log(`[fallback] Model chain for ${task.agent}:`, attemptModels);
  762:       log(`[fallback] Starting fallback sequence for task ${task.id}`, {
  798:           log(`[fallback] Attempt ${attemptCount}/${attemptModels.length} with model: ${modelLabel}`, {
  814:           log(`[fallback] SUCCESS: Attempt ${attemptCount} with ${modelLabel}`, {
  825:           // Track fallback attempt
  826:           if (task.fallbackInfo && model) {
  827:             task.fallbackInfo.attempts.push({
  832:             task.fallbackInfo.successfulModel = modelLabel;
  833:             task.fallbackInfo.totalAttempts = attemptCount;
  834:             task.fallbackInfo.occurred = attemptCount > 1;
  846:           log(`[fallback] ERROR caught in fallback loop:`, {
  856:             log('[fallback] Context length error detected, attempting compaction');
  873:               // If compaction also fails, log and continue to fallback
  874:               log('[fallback] Compaction failed, trying next model');
  878:           // EVERY error triggers fallback - try next model
  884:           // Track fallback attempt
  885:           if (task.fallbackInfo && model) {
  886:             task.fallbackInfo.attempts.push({
  892:             task.fallbackInfo.totalAttempts = attemptCount;
  895:           log(`[fallback] FAILED: Attempt ${attemptCount} with ${modelLabel}`, {
  903:             log(`[fallback] Retrying with next model in chain...`, {
  913:         const finalError = `All fallback models failed after ${attemptCount} attempts. ${errors.join(' | ')}`;
  914:         log(`[fallback] COMPLETE FAILURE: ${finalError}`, {
  998:    * there are remaining models in the fallback chain, retry with the next model.
  1074:           // Check if this is a provider error that should trigger fallback
  1076:             log(`[fallback] Provider error detected in session messages: ${errorText}`);
  1087:       log(` responseText length: ${responseText?.length || 0}, fallbackInfo:`, task.fallbackInfo);
  1088:       if (!responseText && task.fallbackInfo) {
  1089:         log(` Checking fallback - successfulModel: ${task.fallbackInfo.successfulModel}, totalAttempts: ${task.fallbackInfo.totalAttempts}, occurred: ${task.fallbackInfo.occurred}`);
  1090:         if (task.fallbackInfo.successfulModel) {
  1095:         } else if (task.fallbackInfo.totalAttempts > 0) {
  1096:           // Fallback was used but all models failed - mark as failed
  1098:           const errorMsg = task.fallbackInfo.attempts
  1121:    * Retry a failed task with the next model in the fallback chain.
  1130:     const fallbackEnabled = this.config?.fallback?.enabled ?? true;
  1131:     if (!fallbackEnabled) return false;
  1133:     const chain = this.resolveFallbackChain(task.agent);
  1134:     const attemptsSoFar = task.fallbackInfo?.totalAttempts ?? 1;
  1138:       log(`[fallback] No more models in chain for ${task.agent} (tried ${attemptsSoFar}/${chain.length})`);
  1147:       log(`[fallback] Invalid model format for retry: ${nextModel}`);
  1158:     if (task.fallbackInfo) {
  1160:         task.fallbackInfo.attempts.push({
  1167:       task.fallbackInfo.totalAttempts = attemptsSoFar + 1;
  1168:       task.fallbackInfo.occurred = true;
  1171:     log(`[fallback] Retrying task ${task.id} with next model: ${nextModel} (attempt ${attemptsSoFar + 1}/${chain.length})`);
  1197:         log(`[fallback] Failed to create retry session for task ${task.id}`);
  1220:         this.config?.fallback?.timeoutMs ?? FALLBACK_FAILOVER_TIMEOUT_MS;
  1232:       if (task.fallbackInfo) {
  1233:         task.fallbackInfo.attempts.push({
  1238:         task.fallbackInfo.successfulModel = nextModel;
  1245:       log(`[fallback] Retry with ${nextModel} also failed: ${msg}`);
  1247:       if (task.fallbackInfo) {
  1248:         task.fallbackInfo.attempts.push({
  1323:       // Add fallback notice if fallback occurred
  1324:       if (task.fallbackInfo?.occurred && task.fallbackInfo.successfulModel) {
  1325:         message += `\n\nSubagent ${task.agent} required model fallback, but succeeded on ${task.fallbackInfo.successfulModel}. Minor inconvenience, continuing normally.`;
  1330:       // Add fallback details if task failed during fallback
  1331:       if (task.fallbackInfo?.totalAttempts && task.fallbackInfo.totalAttempts > 1) {
  1332:         message += ` (tried ${task.fallbackInfo.totalAttempts} model${task.fallbackInfo.totalAttempts > 1 ? 's' : ''})`;

C:\Users\paulc\.config\opencode\dev\src\hooks\phase-reminder\index.ts:
  12: ⚡ ALWAYS use background_task (not regular Task) for delegation - enables fallbacks

C:\Users\paulc\.config\opencode\dev\src\agents\index.test.ts:
  71: describe('fixer agent fallback', () => {

C:\Users\paulc\.config\opencode\dev\src\background\codemap.md:
  5: The `src/background/` module manages long-running AI agent tasks executing asynchronously in isolated sessions with **sophisticated model fallback and error recovery**. Key responsibilities:
  8: - **Automatic model fallback chains** - Tries multiple models when primary model fails (provider errors, rate limits)
  11: - **Completion detection** - Event-driven via `session.status`, with polling fallback for reliability
  35: - **fallbackInfo**: Fallback tracking (attempts, successfulModel, occurred)
  37: #### FallbackInfo & FallbackAttempt
  38: Tracks model fallback events:
  39: - **occurred**: Boolean indicating if fallback was used
  53: #### 1. **Model Chain Fallback Pattern**
  56: - **Filtered chain**: Applies circuit breaker via `resolveFallbackChain()` to skip unhealthy models
  60: Tracks model health in `config.fallback.triage`:
  68: Integrated into fallback loop:
  74: #### 4. **Provider Error-Based Fallback Decision**
  75: In fallback loop, distinguishes error types:
  76: - **Provider errors** (rate limits, model unavailable, auth failures): trigger fallback to next model
  77: - **Non-provider errors** (validation, prompt errors): fail immediately without fallback
  90: - **Fallback reliability**: TmuxSessionManager uses polling fallback; BackgroundTaskManager relies solely on events
  115: Main orchestrator for background task lifecycle and model fallback.
  142: - `startTask(task): Promise<void>` - Complex orchestration including model fallback loop
  147: - `resolveFallbackChain(agentName): string[]` - Apply circuit breaker filtering
  181: - `pollSessions(): Promise<void>` - Fallback polling for status
  234:   ├─ Resolve model chain (getFullModelChain + resolveFallbackChain)
  235:   ├─ Initialize fallbackInfo.attempts = []
  236:   └─ Fallback loop (for each model in chain):
  238:       ├─ promptWithTimeout(timeoutMs = fallback.timeoutMs or 15000)
  278:   ├─ Else if fallbackInfo.totalAttempts > 0 → completeTask('failed', 'All models failed')
  311: ### Model Fallback Flow (startTask detail)
  317: Call resolveFallbackChain() to apply circuit breaker:
  319:     Check triage[model] in config.fallback.triage
  344:   Throw: "All fallback models failed after N attempts. errors.join(' | ')"
  355: Get triage = config.fallback.triage (create if missing)
  376: resolveFallbackChain(agentName):
  393: During fallback loop, catch error:
  493:   (this.config includes fallback.triage with updated failure counts)
  504: - `../config`: `BackgroundTaskConfig`, `PluginConfig`, `TmuxConfig`, `FALLBACK_FAILOVER_TIMEOUT_MS`, `SUBAGENT_DELEGATION_RULES`, `POLL_INTERVAL_BACKGROUND_MS`
  528:    - `TmuxSessionManager.pollSessions()` provides fallback reliability
  556: - `fallback?: {enabled?: boolean, timeoutMs?: number, triage?: Record<string, {failureCount, lastFailure?, lastSuccess?}>}`
  562: 3. `HARDCODED_DEFAULTS[agentName]` (fallback)
  581: - `[fallback]`: model chain resolution, attempt outcomes, warnings
  592: 1. **Model fallback chains** with automatic switching on provider errors
  599: - `startTask()` now includes complex fallback loop with error classification
  600: - `extractAndCompleteTask()` includes fallback error summarization
  601: - `sendCompletionNotification()` adds fallback success notice to parent
  606: - `BackgroundTask.fallbackInfo?: FallbackInfo`
  607: - `FallbackInfo` and `FallbackAttempt` types added
  610: - `config.fallback` object: `{enabled, timeoutMs, triage: {[model]: {failureCount, lastFailure, lastSuccess?}}}`
  611: - `config.agents[agent].models` (array) or `config.agents[agent].model` (string) for full fallback chains

C:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.br.md:
  87: 4. `$HOME/.opencode/bin` - Fallback padrão

C:\Users\paulc\.config\opencode\dev\src\background\background-manager.ts:
  24:   FALLBACK_FAILOVER_TIMEOUT_MS,
  47:     // Invalid model errors should trigger fallback
  52:     // Generic unknown errors should trigger fallback
  55:     // Auth and key errors should trigger fallback
  67:     // Agent-specific errors that should trigger fallback
  123:  * Represents a fallback attempt during task execution.
  125: export interface FallbackAttempt {
  133:  * Tracks fallback events for a background task.
  135: export interface FallbackInfo {
  137:   attempts: FallbackAttempt[];
  145:   action: 'fallback-retry-started' | 'fallback-exhausted';
  171:   fallbackInfo?: FallbackInfo; // Fallback tracking info
  209:   // Guaranteed fallback config with all required fields
  210:   private fallbackConfig!: {
  246:   // Retry configuration for unconditional retries (5 retries, no delay)
  247:   private MAX_MODEL_RETRIES = 5; // Number of retries per model before fallback
  261:    * These errors will skip retries and go directly to fallback
  299:       hasFallback: !!config?.fallback,
  318:     // Initialize fallback config if not present
  319:     if (!this.config.fallback) {
  320:       this.config.fallback = {
  327:       if (!this.config.fallback.triage) {
  328:         this.config.fallback.triage = {};
  332:     // Store reference to guaranteed fallback config
  333:     this.fallbackConfig = this.config.fallback;
  376:     log(`[fallback] Updated agents.${agentName}.currentModel to ${model}`);
  399:     const hasFallback =
  400:       this.config.fallback && Object.keys(this.config.fallback).length > 0;
  402:     // More strict check: must have agents OR presets OR fallback with content
  403:     if (!hasContent || (!hasAgents && !hasPresets && !hasFallback)) {
  408:         hasFallback,
  460:       const existingHasFallback = existingConfig.fallback && 
  461:         Object.keys(existingConfig.fallback as Record<string, unknown>).length > 0;
  463:       if (!existingHasAgents && !existingHasFallback && hasAgents) {
  470:       // Only update triage data in fallback - never replace the entire fallback object
  471:       if (this.config.fallback?.triage) {
  472:         if (!mergedConfig.fallback || typeof mergedConfig.fallback !== 'object') {
  473:           mergedConfig.fallback = {};
  475:         (mergedConfig.fallback as Record<string, unknown>).triage = this.config.fallback.triage;
  502:       const mergedHasFallback = mergedConfig.fallback && 
  503:         Object.keys(mergedConfig.fallback as Record<string, unknown>).length > 0;
  505:       if (!mergedHasAgents && !mergedHasFallback) {
  734:           action: 'fallback-exhausted',
  741:             `${reason}. No fallback model recovered task.`,
  749:           action: 'fallback-retry-started',
  765:         log(`[fallback] Ignoring invalid model reference in chain: ${model}`);
  780:    * 3) config.fallback.chains[agentName] (legacy/CLI compatibility)
  803:     // Legacy/CLI fallback chain compatibility
  804:     const legacyChains = this.config?.fallback?.chains as
  825:   private async resolveFallbackChain(agentName: string): Promise<string[]> {
  826:     const fallback = this.config?.fallback;
  833:       log(`[fallback] WARNING: No model chain for ${agentName}`);
  838:     const triage = fallback?.triage ?? {};
  912:     log(`[fallback] Resolved fallback chain for ${agentName}:`, {
  924:     if (!this.config?.fallback) {
  925:       log('[circuit-breaker] ERROR: No fallback config found');
  930:     if (!this.config.fallback.triage) {
  931:       this.config.fallback.triage = {};
  934:     const triage = this.config.fallback.triage;
  958:     if (!this.config?.fallback) return;
  961:     if (!this.config.fallback.triage) {
  962:       this.config.fallback.triage = {};
  965:     const triage = this.config.fallback.triage;
  1035:       fallbackEnabled: this.config?.fallback?.enabled,
  1090:         this.config?.fallback?.timeoutMs ?? FALLBACK_FAILOVER_TIMEOUT_MS;
  1091:       const fallbackEnabled = this.config?.fallback?.enabled ?? true;
  1096:       const filteredChain = fallbackEnabled
  1097:         ? await this.resolveFallbackChain(task.agent)
  1104:       log(`[fallback] Model chain for ${task.agent}:`, {
  1114:           `[fallback] WARNING: All models filtered by circuit breaker, bypassing for task ${task.id}`,
  1122:       // Initialize fallback tracking
  1123:       task.fallbackInfo = {
  1133:       log(`[fallback] Model chain for ${task.agent}:`, attemptModels);
  1134:       log(`[fallback] Starting fallback sequence for task ${task.id}`, {
  1182:               `[fallback] Attempt ${attemptCount}.${modelRetryCount}/${attemptModels.length} with model: ${modelLabel}`,
  1202:               `[fallback] SUCCESS: Attempt ${attemptCount}.${modelRetryCount} with ${modelLabel}`,
  1212:             // Task completion success is tracked separately via fallbackInfo.successfulModel
  1218:             // Track fallback attempt
  1219:             if (task.fallbackInfo && model) {
  1220:               task.fallbackInfo.attempts.push({
  1225:               task.fallbackInfo.successfulModel = modelLabel;
  1226:               task.fallbackInfo.totalAttempts = attemptCount;
  1227:               task.fallbackInfo.occurred = attemptCount > 1;
  1241:             log(`[fallback] ERROR caught in fallback loop:`, {
  1256:                 `[fallback] Permanent error detected, skipping retries: ${msg}`,
  1261:               // Track fallback attempt
  1262:               if (task.fallbackInfo && model) {
  1263:                 task.fallbackInfo.attempts.push({
  1269:                 task.fallbackInfo.totalAttempts = attemptCount;
  1277:                 '[fallback] Context length error detected, attempting compaction',
  1295:                 // If compaction also fails, log and continue to fallback
  1296:                 log('[fallback] Compaction failed, trying next model');
  1303:                 `[fallback] Waiting ${this.RETRY_DELAY_MS}ms before retry ${modelRetryCount + 1}/${this.MAX_MODEL_RETRIES}`,
  1311:                 `[fallback] All ${this.MAX_MODEL_RETRIES} retries exhausted for ${modelLabel}`,
  1314:               // EVERY error triggers fallback - try next model
  1320:               // Track fallback attempt
  1321:               if (task.fallbackInfo && model) {
  1322:                 task.fallbackInfo.attempts.push({
  1328:                 task.fallbackInfo.totalAttempts = attemptCount;
  1332:                 `[fallback] FAILED: Attempt ${attemptCount} with ${modelLabel} after ${this.MAX_MODEL_RETRIES} retries`,
  1350:           log(`[fallback] Retrying with next model in chain...`, {
  1359:         const finalError = `All fallback models failed after ${attemptCount} attempts. ${errors.join(' | ')}`;
  1360:         log(`[fallback] COMPLETE FAILURE: ${finalError}`, {
  1472:    * there are remaining models in the fallback chain, retry with the next model.
  1556:           `[fallback] Checking for errors: responseText="${responseText?.slice(0, 50)}", errorMessages.length=${errorMessages.length}`,
  1573:           // before model triage/fallback to avoid polluting circuit breaker state.
  1580:             log(`[fallback] Retrying with next model after error`, {
  1595:         ` responseText length: ${responseText?.length || 0}, fallbackInfo:`,
  1596:         task.fallbackInfo,
  1598:       if (!responseText && task.fallbackInfo) {
  1600:           ` Checking fallback - successfulModel: ${task.fallbackInfo.successfulModel}, totalAttempts: ${task.fallbackInfo.totalAttempts}, occurred: ${task.fallbackInfo.occurred}`,
  1602:         if (task.fallbackInfo.successfulModel) {
  1607:         } else if (task.fallbackInfo.totalAttempts > 0) {
  1608:           // Fallback was used but all models failed - mark as failed
  1610:           const errorMsg = task.fallbackInfo.attempts
  1639:                 log(`[fallback] Detected JSON error response:`, item.error);
  1658:         log(`[fallback] Checking responseText for errors:`, {
  1671:           log(`[fallback] Error detected in responseText, retrying`, {
  1712:    * Retry a failed task with the next model in the fallback chain.
  1721:     const fallbackEnabled = this.config?.fallback?.enabled ?? true;
  1722:     if (!fallbackEnabled) return false;
  1724:     const chain = await this.resolveFallbackChain(task.agent);
  1727:       (task.fallbackInfo?.attempts ?? [])
  1742:         `[fallback] No more models in chain for ${task.agent} (tried ${failedModels.size}/${chain.length})`,
  1749:       log(`[fallback] Invalid model format for retry: ${nextModel}`);
  1757:       (task.fallbackInfo?.attempts ?? [])
  1765:     if (task.fallbackInfo) {
  1767:         task.fallbackInfo.attempts.push({
  1774:       task.fallbackInfo.totalAttempts =
  1775:         (task.fallbackInfo.totalAttempts ?? 0) + 1;
  1776:       task.fallbackInfo.occurred = true;
  1780:       `[fallback] Retrying task ${task.id} with next model: ${nextModel} (attempt ${task.fallbackInfo?.totalAttempts ?? 1}/${chain.length})`,
  1803:           title: `Background: ${task.description} (retry ${task.fallbackInfo?.totalAttempts ?? 1})`,
  1809:         log(`[fallback] Failed to create retry session for task ${task.id}`);
  1830:         this.config?.fallback?.timeoutMs ?? FALLBACK_FAILOVER_TIMEOUT_MS;
  1842:       if (task.fallbackInfo) {
  1843:         task.fallbackInfo.attempts.push({
  1848:         task.fallbackInfo.successfulModel = nextModel;
  1857:       log(`[fallback] Retry with ${nextModel} also failed: ${msg}`);
  1859:       if (task.fallbackInfo) {
  1860:         task.fallbackInfo.attempts.push({
  1987:       // Add fallback notice if fallback occurred
  1988:       if (task.fallbackInfo?.occurred && task.fallbackInfo.successfulModel) {
  1989:         message += `\n\nSubagent ${task.agent} required model fallback, but succeeded on ${task.fallbackInfo.successfulModel}. Minor inconvenience, continuing normally.`;
  1997:       // Add fallback details if task failed during fallback
  1999:         task.fallbackInfo?.totalAttempts &&
  2000:         task.fallbackInfo.totalAttempts > 1
  2002:         message += ` (tried ${task.fallbackInfo.totalAttempts} model${task.fallbackInfo.totalAttempts > 1 ? 's' : ''})`;
  2131:     fallbackAttempts: number;
  2145:       fallbackAttempts: task.fallbackInfo?.totalAttempts ?? 0,
  2177:       const lastAttempt = (task.fallbackInfo?.attempts ?? []).at(-1);
  2188:         attempts: task.fallbackInfo?.totalAttempts ?? 0,
  2189:         successfulModel: task.fallbackInfo?.successfulModel,

C:\Users\paulc\.config\opencode\dev\src\hooks\context-compressor\index.ts:
  55:     // Invalid model errors should trigger fallback
  60:     // Generic unknown errors should trigger fallback
  63:     // Auth and key errors should trigger fallback
  75:     // Agent-specific errors that should trigger fallback

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\issue-1501-analysis.md:
  275:    - Fallback plan 생성

C:\Users\paulc\.config\opencode\dev\src\hooks\context-compressor\codemap.md:
  15: - Exports `detectProviderError(errorMessage)` which classifies error strings that should trigger model fallback/retry logic.

C:\Users\paulc\.config\opencode\dev\ref\opencode-dev\install:
  333:         # Fallback to standard curl on Windows, non-TTY environments, or if custom progress fails

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\SKILL.md:
  33: `free/openrouter/free` is a reserved bridge model: keep it directly before the local fallback model (`lmstudio-local/*`) and exclude it from benchmark-research decisions.
  92:   - Updates both `agents.*.model` and `fallback.currentModels.*`
  100:     - chain tail is reserved bridge + local fallback: `free/openrouter/free`, then `lmstudio-local/*`

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\AGENTS.md:
  219: | Sisyphus | anthropic/claude-opus-4-6 | 0.1 | Primary orchestrator (fallback: kimi-k2.5 → glm-4.7 → gpt-5.3-codex → gemini-3-pro) |
  220: | Hephaestus | openai/gpt-5.3-codex | 0.1 | Autonomous deep worker (NO fallback) |
  221: | Atlas | anthropic/claude-sonnet-4-5 | 0.1 | Master orchestrator (fallback: kimi-k2.5 → gpt-5.2) |
  222: | Prometheus | anthropic/claude-opus-4-6 | 0.1 | Strategic planning (fallback: kimi-k2.5 → gpt-5.2) |
  223: | oracle | openai/gpt-5.2 | 0.1 | Consultation, debugging (fallback: claude-opus-4-6) |
  224: | librarian | zai-coding-plan/glm-4.7 | 0.1 | Docs, GitHub search (fallback: glm-4.7-free) |
  225: | explore | xai/grok-code-fast-1 | 0.1 | Fast codebase grep (fallback: claude-haiku-4-5 → gpt-5-mini → gpt-5-nano) |
  227: | Metis | anthropic/claude-opus-4-6 | 0.3 | Pre-planning analysis (fallback: kimi-k2.5 → gpt-5.2) |
  228: | Momus | openai/gpt-5.2 | 0.1 | Plan validation (fallback: claude-opus-4-6) |

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\research-benchmarks.js:
  360:       // Keep Authorization fallback for compatibility.

C:\Users\paulc\.config\opencode\dev\src\tools\grep\codemap.md:
  7: Serve as the authoritative implementation of the fast content-search tool. It discovers which binary to run (`rg` vs fallback `grep`), enforces safety defaults (timeouts, max files/size/depth), parses the child-process output, formats readable responses, and exposes the ready-to-use tool definition consumed by the CLI/plugin layer.

C:\Users\paulc\.config\opencode\dev\ref\opencode-dev\bun.lock:
  552:     "@actions/artifact": ["@actions/artifact@5.0.1", "", { "dependencies": { "@actions/core": "^2.0.0", "@actions/github": "^6.0.1", "@actions/http-client": "^3.0.0", "@azure/storage-blob": "^12.29.1", "@octokit/core": "^5.2.1", "@octokit/plugin-request-log": "^1.0.4", "@octokit/plugin-retry": "^3.0.9", "@octokit/request": "^8.4.1", "@octokit/request-error": "^5.1.1", "@protobuf-ts/plugin": "^2.2.3-alpha.1", "archiver": "^7.0.1", "jwt-decode": "^3.1.2", "unzip-stream": "^0.3.1" } }, "sha512-dHJ5rHduhCKUikKTT9eXeWoUvfKia3IjR1sO/VTAV3DVAL4yMTRnl2iO5mcfiBjySHLwPNezwENAVskKYU5ymw=="],
  664: [Omitted long matching line]
  666: [Omitted long matching line]
  668: [Omitted long matching line]
  706: [Omitted long matching line]
  1228:     "@octokit/plugin-retry": ["@octokit/plugin-retry@3.0.9", "", { "dependencies": { "@octokit/types": "^6.0.3", "bottleneck": "^2.15.3" } }, "sha512-r+fArdP5+TG6l1Rv/C9hVoty6tldw6cE2pRHNGmFPdyfrc696R6JjrQ3d7HdVqGwuzfyrcaLAKD7K8TX8aehUQ=="],
  1584:     "@slack/web-api": ["@slack/web-api@6.13.0", "", { "dependencies": { "@slack/logger": "^3.0.0", "@slack/types": "^2.11.0", "@types/is-stream": "^1.1.0", "@types/node": ">=12.0.0", "axios": "^1.7.4", "eventemitter3": "^3.1.0", "form-data": "^2.5.0", "is-electron": "2.2.2", "is-stream": "^1.1.0", "p-queue": "^6.6.1", "p-retry": "^4.0.0" } }, "sha512-dv65crIgdh9ZYHrevLU6XFHTQwTyDmNqEqzuIrV+Vqe/vgiG6w37oex5ePDU1RGm2IJ90H8iOvHFvzdEO/vB+g=="],
  1626:     "@smithy/middleware-retry": ["@smithy/middleware-retry@4.4.29", "", { "dependencies": { "@smithy/node-config-provider": "^4.3.8", "@smithy/protocol-http": "^5.3.8", "@smithy/service-error-classification": "^4.2.8", "@smithy/smithy-client": "^4.11.1", "@smithy/types": "^4.12.0", "@smithy/util-middleware": "^4.2.8", "@smithy/util-retry": "^4.2.8", "@smithy/uuid": "^1.1.0", "tslib": "^2.6.2" } }, "sha512-bmTn75a4tmKRkC5w61yYQLb3DmxNzB8qSVu9SbTYqW6GAL0WXO2bDZuMAn/GJSbOdHEdjZvWxe+9Kk015bw6Cg=="],
  1676:     "@smithy/util-retry": ["@smithy/util-retry@4.2.8", "", { "dependencies": { "@smithy/service-error-classification": "^4.2.8", "@smithy/types": "^4.12.0", "tslib": "^2.6.2" } }, "sha512-CfJqwvoRY0kTGe5AkQokpURNCT1u/MkRzMTASWMPPo2hNSnKtF1D45dQl3DE2LKLr4m+PW9mCeBMJr5mCAVThg=="],
  1918:     "@types/retry": ["@types/retry@0.12.0", "", {}, "sha512-wWKOClTTiizcZhXnPY4wikVAwmdYHp8q6DmC+EJUzAMsycb7HB32Kh9RN4+0gExjmPmZSAQjgURXIGATPegAvA=="],
  3330:     "p-retry": ["p-retry@4.6.2", "", { "dependencies": { "@types/retry": "0.12.0", "retry": "^0.13.1" } }, "sha512-312Id396EbJdvRONlngUx0NydfrIQ5lsYu0znKVUzVvArzEIt08V1qhtyESbGVd1FGX7UKtiFp5uwKZdM8wIuQ=="],
  3598:     "retry": ["retry@0.13.1", "", {}, "sha512-XQBQ3I8W1Cge0Seh+6gjj03LbmRFWuoszgK9ooCpwYIrhhoO80pfq4cUkU5DkknwfOfFteRwlZ56PYOGYyFWdg=="],
  4366:     "@octokit/plugin-retry/@octokit/types": ["@octokit/types@6.41.0", "", { "dependencies": { "@octokit/openapi-types": "^12.11.0" } }, "sha512-eJ2jbzjdijiL3B4PrSQaSjuF2sPEQPVCPzBvTHJD9Nz+9dw2SGH4K4xeQJ77YfTq5bRQ+bD8wT11JbeDPmxmGg=="],
  4382:     "@opencode-ai/desktop/@actions/artifact": ["@actions/artifact@4.0.0", "", { "dependencies": { "@actions/core": "^1.10.0", "@actions/github": "^6.0.1", "@actions/http-client": "^2.1.0", "@azure/core-http": "^3.0.5", "@azure/storage-blob": "^12.15.0", "@octokit/core": "^5.2.1", "@octokit/plugin-request-log": "^1.0.4", "@octokit/plugin-retry": "^3.0.9", "@octokit/request": "^8.4.1", "@octokit/request-error": "^5.1.1", "@protobuf-ts/plugin": "^2.2.3-alpha.1", "archiver": "^7.0.1", "jwt-decode": "^3.1.2", "unzip-stream": "^0.3.1" } }, "sha512-HCc2jMJRAfviGFAh0FsOR/jNfWhirxl7W6z8zDtttt0GltwxBLdEIjLiweOPFl9WbyJRW1VWnPUSAixJqcWUMQ=="],
  4952:     "@octokit/plugin-retry/@octokit/types/@octokit/openapi-types": ["@octokit/openapi-types@12.11.0", "", {}, "sha512-VsXyi8peyRq9PqIz/tpqiL2w3w80OgVMwBHltTml3LmVvXiphgeqmY9mvBw9Wu7e0QWk/fqD37ux8yP5uVekyQ=="],
  5222: [Omitted long matching line]
  5224: [Omitted long matching line]
  5228: [Omitted long matching line]
  5360: [Omitted long matching line]

C:\Users\paulc\.config\opencode\dev\src\tools\codemap.md:
  7: 1. **Grep** - Fast regex-based content search using ripgrep (with fallback to system grep)
  63: - **constants.ts**: CLI path resolution with fallback chain
  81: - Graceful degradation (ripgrep → grep fallback)
  103:     └─→ System grep (fallback)
  301: - **Fallback**: System grep if ripgrep unavailable
  307: - **Fallback**: Manual installation instructions
  315: 4. Graceful degradation (fallback tools)

C:\Users\paulc\.config\opencode\dev\src\hooks\directory-codemap-injector\constants.ts:
  21:   fallback: 'truncated' as const,

C:\Users\paulc\.config\opencode\dev\src\hooks\directory-codemap-injector\codemap.md:
  28:   - otherwise summarize (LM Studio or truncation fallback),

C:\Users\paulc\.config\opencode\dev\src\tools\background.ts:
  129:         task.fallbackInfo?.totalAttempts ?? 0,
  171:       // Add fallback information if available
  172:       if (task.fallbackInfo) {
  173:         if (task.fallbackInfo.occurred) {
  174:           output += `Fallback: Yes (tried ${task.fallbackInfo.totalAttempts} models)\n Successful Model: ${task.fallbackInfo.successfulModel || 'None'}\n`;
  175:         } else if (task.fallbackInfo.totalAttempts > 0) {
  176:           output += `Fallback: No (first model succeeded)\n`;
  198:         // Append fallback notice if fallback occurred
  199:         if (task.fallbackInfo?.occurred && task.fallbackInfo.successfulModel) {
  200:           output += `\n\n[Note: Subagent ${task.agent} required model fallback, but succeeded on ${task.fallbackInfo.successfulModel}. Minor inconvenience, continuing normally.]`;
  205:         // Add fallback details if task failed during fallback
  207:           task.fallbackInfo?.totalAttempts &&
  208:           task.fallbackInfo.totalAttempts > 1
  210:           output += `\n\n[Fallback: Tried ${task.fallbackInfo.totalAttempts} models before failing]`;

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\configurations.md:
  46: | **Windows**     | `~/.config/opencode/oh-my-opencode.jsonc` (preferred) or `~/.config/opencode/oh-my-opencode.json` (fallback); `%APPDATA%\opencode\oh-my-opencode.jsonc` / `%APPDATA%\opencode\oh-my-opencode.json` (fallback) |
  47: | **macOS/Linux** | `~/.config/opencode/oh-my-opencode.jsonc` (preferred) or `~/.config/opencode/oh-my-opencode.json` (fallback)                |
  847: 2. **Step 2: Provider Fallback** — Try each provider in the requirement's priority order until one is available
  865: │   Step 2: PROVIDER PRIORITY FALLBACK                            │
  932: - Provider fallback chain
  958: When you specify a model override, it takes precedence (Step 1) and the provider fallback chain is skipped entirely.

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\features.md:
  13: | **Sisyphus** | `anthropic/claude-opus-4-6` | **The default orchestrator.** Plans, delegates, and executes complex tasks using specialized subagents with aggressive parallel execution. Todo-driven workflow with extended thinking (32k budget). Fallback: kimi-k2.5 → glm-4.7 → gpt-5.3-codex → gemini-3-pro. |
  14: | **Hephaestus** | `openai/gpt-5.3-codex` | **The Legitimate Craftsman.** Autonomous deep worker inspired by AmpCode's deep mode. Goal-oriented execution with thorough research before action. Explores codebase patterns, completes tasks end-to-end without premature stopping. Named after the Greek god of forge and craftsmanship. Requires gpt-5.3-codex (no fallback - only activates when this model is available). |
  16: | **librarian** | `zai-coding-plan/glm-4.7` | Multi-repo analysis, documentation lookup, OSS implementation examples. Deep codebase understanding with evidence-based answers. Fallback: glm-4.7-free → claude-sonnet-4-5. |
  17: | **explore** | `anthropic/claude-haiku-4-5` | Fast codebase exploration and contextual grep. Fallback: gpt-5-mini → gpt-5-nano. |
  18: | **multimodal-looker** | `google/gemini-3-flash` | Visual content specialist. Analyzes PDFs, images, diagrams to extract information. Fallback: gpt-5.2 → glm-4.6v → kimi-k2.5 → claude-haiku-4-5 → gpt-5-nano. |
  24: | **Prometheus** | `anthropic/claude-opus-4-6` | Strategic planner with interview mode. Creates detailed work plans through iterative questioning. Fallback: kimi-k2.5 → gpt-5.2 → gemini-3-pro. |
  25: | **Metis** | `anthropic/claude-opus-4-6` | Plan consultant - pre-planning analysis. Identifies hidden intentions, ambiguities, and AI failure points. Fallback: kimi-k2.5 → gpt-5.2 → gemini-3-pro. |
  26: | **Momus** | `openai/gpt-5.2` | Plan reviewer - validates plans against clarity, verifiability, and completeness standards. Fallback: gpt-5.2 → claude-opus-4-6 → gemini-3-pro. |

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\sisyphus-prompt.md:
  184: Use it as a **peer tool**, not a fallback. Fire liberally.

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\guide\overview.md:
  109: **2. At Runtime (Fallback Chain)**
  130:     // Override specific agents only - rest use fallback chain
  149: - Unspecified agents/categories use the automatic fallback chain

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\guide\installation.md:
  187: #### GitHub Copilot (Fallback Provider)
  189: GitHub Copilot is supported as a **fallback provider** when native providers are unavailable.
  202: | **Librarian** | `zai-coding-plan/glm-4.7` (if Z.ai available) or fallback |

C:\Users\paulc\.config\opencode\dev\src\tools\ast-grep\downloader.ts.backup:
  10: // This is only used as fallback when @ast-grep/cli package.json cannot be read

C:\Users\paulc\.config\opencode\dev\src\tools\ast-grep\downloader.ts:
  11: // This is only used as fallback when @ast-grep/cli package.json cannot be read

C:\Users\paulc\.config\opencode\dev\src\tools\ast-grep\codemap.md:
  11: - **Singleton initialization with retries:** `getAstGrepPath` caches an init promise so concurrent requests share discovery/download work and fallback from local binaries to downloads (`cli.ts`).
  21: - `downloader.ts` is the fallback path: it infers the platform key, downloads the matching GitHub release, extracts `sg`, sets executable bits, and caches it under `~/.cache/oh-my-opencode-theseus/bin` (or Windows AppData) so subsequent commands reuse the binary.

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\plugin-handlers\prometheus-agent-config-builder.ts:
  48:       fallbackChain: requirement?.fallbackChain,

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\plugin-handlers\config-handler.test.ts:
  72:   spyOn(modelResolver, "resolveModelWithFallback" as any).mockReturnValue({ model: "anthropic/claude-opus-4-6" })
  101:   ;(modelResolver.resolveModelWithFallback as any)?.mockRestore?.()
  610:       provenance: "provider-fallback",
  709:       provenance: "provider-fallback",
  752:       provenance: "provider-fallback",

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\optimize.js:
  64: function loadOptionalJson(filePath, fallback) {
  65:   if (!fs.existsSync(filePath)) return fallback;
  434:   const fallback = {
  442:   for (const stage of Object.keys(fallback)) {
  444:       max_input_per_1m_usd: Number(policyCaps?.[stage]?.max_input_per_1m_usd ?? fallback[stage].max_input_per_1m_usd),
  445:       max_output_per_1m_usd: Number(policyCaps?.[stage]?.max_output_per_1m_usd ?? fallback[stage].max_output_per_1m_usd),
  691:       if (theseus?.fallback?.currentModels) {
  692:         theseus.fallback.currentModels[agentKey] = result.chain[0];

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\openai-budget.js:
  10:  * No OpenAI usage API fallback.
  26: function loadOptionalJson(filePath, fallback) {
  27:   if (!fs.existsSync(filePath)) return fallback;

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\utils\tmux.ts:
  17:  * This is needed because ctx.serverUrl may return a fallback URL even when no server is running.
  212:   // This is needed because serverUrl may be a fallback even when no server is running

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\next-interview.js:
  32: function asNumber(value, fallback = 0) {
  34:   return Number.isFinite(n) ? n : fallback;

C:\Users\paulc\.config\opencode\dev\ref\opencode-dev\sdks\vscode\bun.lock:
  95:     "@humanfs/node": ["@humanfs/node@0.16.6", "", { "dependencies": { "@humanfs/core": "^0.19.1", "@humanwhocodes/retry": "^0.3.0" } }, "sha512-YuI2ZHQL78Q5HbhDiBA1X4LmYdXCKCMQIfw0pw7piHJwyREFebJUvrQN4cMssyES6x+vfUbx1CIpaQUKYdQZOw=="],
  99:     "@humanwhocodes/retry": ["@humanwhocodes/retry@0.4.3", "", {}, "sha512-bV0Tgo9K4hfPCek+aMAn81RppFKv2ySDQeMoSZuvTASywNTnVJCArCZE2FWqpvIatKu7VMRLWlR1EazvVhDyhQ=="],
  229: [Omitted long matching line]
  515:     "@humanfs/node/@humanwhocodes/retry": ["@humanwhocodes/retry@0.3.1", "", {}, "sha512-JBxkERygn7Bv/GbN5Rv8Ul6LVknS+5Bp6RgDC/O8gEBU/yeH5Ui5C/OlWrTb6qct7LjjfT6Re2NxB0ln0yYybA=="],

C:\Users\paulc\.config\opencode\dev\src\shared\codemap-utils.ts:
  50:     // Fallback: Try to extract structured information from markdown

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\utils\codemap.md:
  11: Each helper lives in its own module and re-exports through `src/utils/index.ts`, keeping public surface area flat. Key ideas include memoized state (cached TMUX path, server availability cache, stored layouts), configuration defaults fed from `../config` constants, defensive guards (abort checks, empty-string variants), and layered platform detection (Windows build/tar, PowerShell fallbacks). Logging is best-effort: synchronous file append inside a try/catch so it never throws upstream.
  15: Agent variant helpers normalize names, read `PluginConfig.agents`, trim/validate variants, and only mutate request bodies when a variant is missing; `log` simply timestamps and appends strings to a temp file. `pollUntilStable` loops with configurable intervals, fetch callbacks, and stability guards, honoring max time and abort signals before returning a typed `PollResult`. TMUX helpers scan for the binary (`which/where`), cache the result, verify layouts, spawn panes with `opencode attach`, reapply stored layouts on close, and guard against missing servers by checking `/health`. `extractZip` detects the OS (tar on modern Windows, pwsh/powershell fallback) before spawning native unpack commands and bubbling errors when processes fail.

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\tools\glob\cli.ts:
  73:   // which handles symlinks via --follow. This fallback rarely triggers in practice.

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\benchmarks.json:
  276:       "note": "Fastest local - ultimate fallback"
  389:       "notes": "Mixed quality - fallback only"
  395:       "notes": "Local - ultimate fallback when all APIs fail",

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\plugin\session-status-normalizer.test.ts:
  59: 					status: { type: "retry", attempt: 1, message: "retrying", next: 5000 },

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\cli\types.ts:
  63:   | 'provider-fallback-policy'
  97:   fallback1: string;
  98:   fallback2: string;
  99:   fallback3: string;

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\cli\system.ts:
  71:   // Fallback to 'opencode' and hope it's in PATH

C:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.ru.md:
  87: 4. `$HOME/.opencode/bin` - Fallback по умолчанию

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\hooks\todo-continuation-enforcer\todo-continuation-enforcer.test.ts:
  1063:   test("should use API fallback when event is missed but API shows abort", async () => {
  1065:     const sessionID = "main-api-fallback"
  1081:     // then - no continuation (API fallback detected the abort)

C:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.pl.md:
  87: 4. `$HOME/.opencode/bin` - Domyślny fallback

C:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.no.md:
  87: 4. `$HOME/.opencode/bin` - Standard fallback

C:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.md:
  88: 4. `$HOME/.opencode/bin` - Default fallback

C:\Users\paul

... (truncated)
```
