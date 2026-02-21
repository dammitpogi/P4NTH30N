# Tool Output: tool_c6a4fb04a001OdXiHrif4sbm8R
**Date**: 2026-02-17 06:35:33 UTC
**Size**: 81,182 bytes

```

.\src\background\tmux-session-manager.ts:
  120:       // Start polling for fallback reliability
  163:    * Poll sessions for status updates (fallback for reliability).
  199:         // Check for timeout as a safety fallback

.\src\config\schema.ts:
  20:   models: z.array(z.string()).optional(), // Model fallback chain for this agent (first = default)
  89:   fallback: z.enum(['truncated']).default('truncated'),
  122:   // Backward-compat fallback chains (legacy + CLI emitted)
  149:       fallbackToAlternativeModel: z.boolean().default(true),
  159:       fallbackToAlternativeModel: true,
  186:   fallback: FailoverConfigSchema.optional(),

.\src\agents\index.ts:
  102:   const triage = config?.fallback?.triage;

.\src\background\background-manager.test.ts:
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

.\src\background\background-manager.ts:
  47:     // Invalid model errors should trigger fallback
  52:     // Generic unknown errors should trigger fallback
  55:     // Auth and key errors should trigger fallback
  67:     // Agent-specific errors that should trigger fallback
  123:  * Represents a fallback attempt during task execution.
  133:  * Tracks fallback events for a background task.
  145:   action: 'fallback-retry-started' | 'fallback-exhausted';
  171:   fallbackInfo?: FallbackInfo; // Fallback tracking info
  209:   // Guaranteed fallback config with all required fields
  210:   private fallbackConfig!: {
  247:   private MAX_MODEL_RETRIES = 10; // Number of retries per model before fallback
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
  400:       this.config.fallback && Object.keys(this.config.fallback).length > 0;
  402:     // More strict check: must have agents OR presets OR fallback with content
  465:         existingConfig.fallback &&
  466:         Object.keys(existingConfig.fallback as Record<string, unknown>).length >
  478:       // Only update triage data in fallback - never replace the entire fallback object
  479:       if (this.config.fallback?.triage) {
  481:           !mergedConfig.fallback ||
  482:           typeof mergedConfig.fallback !== 'object'
  484:           mergedConfig.fallback = {};
  486:         (mergedConfig.fallback as Record<string, unknown>).triage =
  487:           this.config.fallback.triage;
  522:         mergedConfig.fallback &&
  523:         Object.keys(mergedConfig.fallback as Record<string, unknown>).length >
  753:       const retried = await this.retryWithNextModel(task, reason);
  759:           action: 'fallback-exhausted',
  766:             `${reason}. No fallback model recovered task.`,
  774:           action: 'fallback-retry-started',
  790:         log(`[fallback] Ignoring invalid model reference in chain: ${model}`);
  805:    * 3) config.fallback.chains[agentName] (legacy/CLI compatibility)
  828:     // Legacy/CLI fallback chain compatibility
  829:     const legacyChains = this.config?.fallback?.chains as
  852:     const fallback = this.config?.fallback;
  859:       log(`[fallback] WARNING: No model chain for ${agentName}`);
  864:     const triage = fallback?.triage ?? {};
  938:     log(`[fallback] Resolved fallback chain for ${agentName}:`, {
  950:     if (!this.config?.fallback) {
  951:       log('[circuit-breaker] ERROR: No fallback config found');
  956:     if (!this.config.fallback.triage) {
  957:       this.config.fallback.triage = {};
  960:     const triage = this.config.fallback.triage;
  984:     if (!this.config?.fallback) return;
  987:     if (!this.config.fallback.triage) {
  988:       this.config.fallback.triage = {};
  991:     const triage = this.config.fallback.triage;
  1061:       fallbackEnabled: this.config?.fallback?.enabled,
  1116:         this.config?.fallback?.timeoutMs ?? FALLBACK_FAILOVER_TIMEOUT_MS;
  1117:       const fallbackEnabled = this.config?.fallback?.enabled ?? true;
  1122:       const filteredChain = fallbackEnabled
  1130:       log(`[fallback] Model chain for ${task.agent}:`, {
  1140:           `[fallback] WARNING: All models filtered by circuit breaker, bypassing for task ${task.id}`,
  1148:       // Initialize fallback tracking
  1149:       task.fallbackInfo = {
  1159:       log(`[fallback] Model chain for ${task.agent}:`, attemptModels);
  1160:       log(`[fallback] Starting fallback sequence for task ${task.id}`, {
  1208:               `[fallback] Attempt ${attemptCount}.${modelRetryCount}/${attemptModels.length} with model: ${modelLabel}`,
  1228:               `[fallback] SUCCESS: Attempt ${attemptCount}.${modelRetryCount} with ${modelLabel}`,
  1238:             // Task completion success is tracked separately via fallbackInfo.successfulModel
  1244:             // Track fallback attempt
  1245:             if (task.fallbackInfo && model) {
  1246:               task.fallbackInfo.attempts.push({
  1251:               task.fallbackInfo.successfulModel = modelLabel;
  1252:               task.fallbackInfo.totalAttempts = attemptCount;
  1253:               task.fallbackInfo.occurred = attemptCount > 1;
  1267:             log(`[fallback] ERROR caught in fallback loop:`, {
  1282:                 `[fallback] Permanent error detected, skipping retries: ${msg}`,
  1287:               // Track fallback attempt
  1288:               if (task.fallbackInfo && model) {
  1289:                 task.fallbackInfo.attempts.push({
  1295:                 task.fallbackInfo.totalAttempts = attemptCount;
  1303:                 '[fallback] Context length error detected, attempting compaction',
  1321:                 // If compaction also fails, log and continue to fallback
  1322:                 log('[fallback] Compaction failed, trying next model');
  1329:                 `[fallback] Waiting ${this.RETRY_DELAY_MS}ms before retry ${modelRetryCount + 1}/${this.MAX_MODEL_RETRIES}`,
  1337:                 `[fallback] All ${this.MAX_MODEL_RETRIES} retries exhausted for ${modelLabel}`,
  1340:               // EVERY error triggers fallback - try next model
  1346:               // Track fallback attempt
  1347:               if (task.fallbackInfo && model) {
  1348:                 task.fallbackInfo.attempts.push({
  1354:                 task.fallbackInfo.totalAttempts = attemptCount;
  1358:                 `[fallback] FAILED: Attempt ${attemptCount} with ${modelLabel} after ${this.MAX_MODEL_RETRIES} retries`,
  1376:           log(`[fallback] Retrying with next model in chain...`, {
  1385:         const finalError = `All fallback models failed after ${attemptCount} attempts. ${errors.join(' | ')}`;
  1386:         log(`[fallback] COMPLETE FAILURE: ${finalError}`, {
  1498:    * there are remaining models in the fallback chain, retry with the next model.
  1582:           `[fallback] Checking for errors: responseText="${responseText?.slice(0, 50)}", errorMessages.length=${errorMessages.length}`,
  1599:           // before model triage/fallback to avoid polluting circuit breaker state.
  1606:             log(`[fallback] Retrying with next model after error`, {
  1610:             const retried = await this.retryWithNextModel(task, errorText);
  1621:         ` responseText length: ${responseText?.length || 0}, fallbackInfo:`,
  1622:         task.fallbackInfo,
  1624:       if (!responseText && task.fallbackInfo) {
  1626:           ` Checking fallback - successfulModel: ${task.fallbackInfo.successfulModel}, totalAttempts: ${task.fallbackInfo.totalAttempts}, occurred: ${task.fallbackInfo.occurred}`,
  1628:         if (task.fallbackInfo.successfulModel) {
  1633:         } else if (task.fallbackInfo.totalAttempts > 0) {
  1636:           const errorMsg = task.fallbackInfo.attempts
  1665:                 log(`[fallback] Detected JSON error response:`, item.error);
  1684:         log(`[fallback] Checking responseText for errors:`, {
  1697:           log(`[fallback] Error detected in responseText, retrying`, {
  1701:           const retried = await this.retryWithNextModel(task, responseText);
  1712:         const retried = await this.retryWithNextModel(
  1721:         const retried = await this.retryWithNextModel(
  1738:    * Retry a failed task with the next model in the fallback chain.
  1743:   private async retryWithNextModel(
  1747:     const fallbackEnabled = this.config?.fallback?.enabled ?? true;
  1748:     if (!fallbackEnabled) return false;
  1753:       (task.fallbackInfo?.attempts ?? [])
  1768:         `[fallback] No more models in chain for ${task.agent} (tried ${failedModels.size}/${chain.length})`,
  1775:       log(`[fallback] Invalid model format for retry: ${nextModel}`);
  1783:       (task.fallbackInfo?.attempts ?? [])
  1791:     if (task.fallbackInfo) {
  1793:         task.fallbackInfo.attempts.push({
  1800:       task.fallbackInfo.totalAttempts =
  1801:         (task.fallbackInfo.totalAttempts ?? 0) + 1;
  1802:       task.fallbackInfo.occurred = true;
  1806:       `[fallback] Retrying task ${task.id} with next model: ${nextModel} (attempt ${task.fallbackInfo?.totalAttempts ?? 1}/${chain.length})`,
  1829:           title: `Background: ${task.description} (retry ${task.fallbackInfo?.totalAttempts ?? 1})`,
  1835:         log(`[fallback] Failed to create retry session for task ${task.id}`);
  1856:         this.config?.fallback?.timeoutMs ?? FALLBACK_FAILOVER_TIMEOUT_MS;
  1868:       if (task.fallbackInfo) {
  1869:         task.fallbackInfo.attempts.push({
  1874:         task.fallbackInfo.successfulModel = nextModel;
  1883:       log(`[fallback] Retry with ${nextModel} also failed: ${msg}`);
  1885:       if (task.fallbackInfo) {
  1886:         task.fallbackInfo.attempts.push({
  1897:       return this.retryWithNextModel(task, msg);
  2013:       // Add fallback notice if fallback occurred
  2014:       if (task.fallbackInfo?.occurred && task.fallbackInfo.successfulModel) {
  2015:         message += `\n\nSubagent ${task.agent} required model fallback, but succeeded on ${task.fallbackInfo.successfulModel}. Minor inconvenience, continuing normally.`;
  2023:       // Add fallback details if task failed during fallback
  2025:         task.fallbackInfo?.totalAttempts &&
  2026:         task.fallbackInfo.totalAttempts > 1
  2028:         message += ` (tried ${task.fallbackInfo.totalAttempts} model${task.fallbackInfo.totalAttempts > 1 ? 's' : ''})`;
  2157:     fallbackAttempts: number;
  2171:       fallbackAttempts: task.fallbackInfo?.totalAttempts ?? 0,
  2203:       const lastAttempt = (task.fallbackInfo?.attempts ?? []).at(-1);
  2214:         attempts: task.fallbackInfo?.totalAttempts ?? 0,
  2215:         successfulModel: task.fallbackInfo?.successfulModel,

.\src\hooks\phase-reminder\index.ts:
  12: ⚡ ALWAYS use background_task (not regular Task) for delegation - enables fallbacks

.\src\cli\install.ts:
  590:           'No free Chutes models found. Continuing with fallback Chutes mapping.',
  711:       'No providers configured. Zen Big Pickle models will be used as fallback.',

.\src\utils\tmux.ts:
  17:  * This is needed because ctx.serverUrl may return a fallback URL even when no server is running.
  212:   // This is needed because serverUrl may be a fallback even when no server is running

.\src\config\loader.ts:
  173:   // Also check the project directory as fallback
  210:     hasFallback: !!config?.fallback 
  218:     const mergedFallback = deepMerge(config.fallback, projectConfig.fallback);
  224:       fallback: mergedFallback,

.\src\cli\providers.ts:
  289:       models: modelInfo.models, // fallback chain
  314:     config.fallback = {
  477:     config.fallback = {

.\src\cli\providers.test.ts:
  142:   test('generateLiteConfig emits fallback chains for six agents in presets', () => {
  157:     expect((config.fallback as any).enabled).toBe(true);
  158:     expect((config.fallback as any).timeoutMs).toBe(15000);
  159:     // Chains are emitted in fallback.chains
  160:     const chains = (config.fallback as any).chains;

.\src\hooks\directory-codemap-injector\constants.ts:
  21:   fallback: 'truncated' as const,

.\src\index.ts:
  43:     hasFallback: !!config?.fallback,
  160:   // Orchestrator fallback tool - allows manual model switching
  172:       orchestrator_fallback: orchestratorFallback,

.\src\hooks\context-compressor\index.ts:
  55:     // Invalid model errors should trigger fallback
  60:     // Generic unknown errors should trigger fallback
  63:     // Auth and key errors should trigger fallback
  76:     // Agent-specific errors that should trigger fallback

.\src\tools\orchestrator-fallback.ts:
  50:   // Legacy/CLI fallback chain compatibility
  51:   const legacyChains = config?.fallback?.chains as
  139:           log(`[fallback-tool] Updated currentModel for ${agentName}`);
  149:     log('[fallback-tool] Config persisted successfully');
  152:     log('[fallback-tool] Failed to persist config', { error: msg });
  157:  * Creates a tool to manually trigger orchestrator model fallback.
  165:       'Manually trigger a model fallback for the Orchestrator. ' +
  166:       'This switches to the next model in the configured fallback chain. ' +
  173:         .describe('Optional reason for the fallback (for logging)'),
  177:       const reason = String(args.reason || 'Manual fallback triggered');
  180:       log(`[fallback-tool] Manual fallback requested`, {
  228:       log(`[fallback-tool] Fallback complete`, {
  235:         `Orchestrator model fallback triggered.\n\n` +

.\ref\opencode-dev\nix\scripts\normalize-bun-binaries.ts:
  35:       const fallback = manifest.name ?? packageDir.split("/").pop()
  36:       if (fallback) {
  37:         await linkBinary(binRoot, fallback, packageDir, binField, seen)

.\src\tools\background.ts:
  129:         task.fallbackInfo?.totalAttempts ?? 0,
  171:       // Add fallback information if available
  172:       if (task.fallbackInfo) {
  173:         if (task.fallbackInfo.occurred) {
  174:           output += `Fallback: Yes (tried ${task.fallbackInfo.totalAttempts} models)\n Successful Model: ${task.fallbackInfo.successfulModel || 'None'}\n`;
  175:         } else if (task.fallbackInfo.totalAttempts > 0) {
  198:         // Append fallback notice if fallback occurred
  199:         if (task.fallbackInfo?.occurred && task.fallbackInfo.successfulModel) {
  200:           output += `\n\n[Note: Subagent ${task.agent} required model fallback, but succeeded on ${task.fallbackInfo.successfulModel}. Minor inconvenience, continuing normally.]`;
  205:         // Add fallback details if task failed during fallback
  207:           task.fallbackInfo?.totalAttempts &&
  208:           task.fallbackInfo.totalAttempts > 1
  210:           output += `\n\n[Fallback: Tried ${task.fallbackInfo.totalAttempts} models before failing]`;

.\src\tools\index.ts:
  15: // Orchestrator fallback tool
  16: export { createOrchestratorFallbackTool } from './orchestrator-fallback';

.\src\tools\ast-grep\downloader.ts:
  11: // This is only used as fallback when @ast-grep/cli package.json cannot be read

.\ref\oh-my-opencode-theseus-master\src\utils\tmux.ts:
  17:  * This is needed because ctx.serverUrl may return a fallback URL even when no server is running.
  212:   // This is needed because serverUrl may be a fallback even when no server is running

.\ref\opencode-dev\packages\console\app\test\rateLimiter.test.ts:
  85:   test("fallback returns time until next hour when rows are empty", () => {

.\ref\opencode-dev\packages\app\src\utils\uuid.ts:
  1: const fallback = () => Math.random().toString(16).slice(2)
  5:   if (!c || typeof c.randomUUID !== "function") return fallback()
  6:   if (typeof globalThis.isSecureContext === "boolean" && !globalThis.isSecureContext) return fallback()
  10:     return fallback()

.\ref\oh-my-opencode-theseus-master\src\tools\ast-grep\downloader.ts:
  10: // This is only used as fallback when @ast-grep/cli package.json cannot be read

.\ref\opencode-dev\packages\app\src\utils\server-health.test.ts:
  33:   test("uses timeout fallback when AbortSignal.timeout is unavailable", async () => {

.\ref\opencode-dev\packages\app\src\utils\persist.ts:
  20: const fallback = new Map<string, boolean>()
  68: function fallbackDisabled(scope: string) {
  69:   return fallback.get(scope) === true
  72: function fallbackSet(scope: string) {
  73:   fallback.set(scope, true)
  220:       if (fallbackDisabled(scope)) return cached ?? null
  226:           fallbackSet(scope)
  236:       if (fallbackDisabled(scope)) return
  240:         fallbackSet(scope)
  243:       fallbackSet(scope)
  248:       if (fallbackDisabled(scope)) return
  252:         fallbackSet(scope)
  263:       if (fallbackDisabled(scope)) return cached ?? null
  269:           fallbackSet(scope)
  278:       if (fallbackDisabled(scope)) return
  282:         fallbackSet(scope)
  285:       fallbackSet(scope)
  289:       if (fallbackDisabled(scope)) return
  293:         fallbackSet(scope)

.\ref\opencode-dev\packages\app\src\utils\persist.test.ts:
  93:   test("failing fallback scope does not poison direct storage scope", () => {

.\ref\opencode-dev\packages\app\src\pages\session\scroll-spy.test.ts:
  65: describe("createScrollSpy fallback", () => {

.\ref\opencode-dev\packages\console\core\src\model.ts:
  25:     fallbackValue: z.number().int().optional(),
  48:     fallbackProvider: z.string().optional(),

.\ref\opencode-dev\packages\app\src\pages\layout\helpers.ts:
  56: export const errorMessage = (err: unknown, fallback: string) => {
  62:   return fallback

.\ref\opencode-dev\packages\app\src\pages\layout\helpers.test.ts:
  82:   test("formats fallback project display name", () => {
  87:   test("extracts api error message and fallback", () => {
  88:     expect(errorMessage({ data: { message: "boom" } }, "fallback")).toBe("boom")
  89:     expect(errorMessage(new Error("broken"), "fallback")).toBe("broken")
  90:     expect(errorMessage("unknown", "fallback")).toBe("fallback")

.\ref\opencode-dev\packages\app\src\i18n\zht.ts:
  474:   "notification.session.error.fallbackDescription": "發生錯誤",

.\ref\opencode-dev\packages\app\src\i18n\zh.ts:
  478:   "notification.session.error.fallbackDescription": "发生错误",

.\ref\oh-my-opencode-theseus-master\src\config\schema.ts:
  31:     fallback1: ProviderModelIdSchema,
  32:     fallback2: ProviderModelIdSchema,
  33:     fallback3: ProviderModelIdSchema,
  38:       value.fallback1,
  39:       value.fallback2,
  40:       value.fallback3,
  45:         message: 'primary and fallbacks must be unique per agent',
  145:   fallback: FailoverConfigSchema.optional(),

.\ref\oh-my-opencode-theseus-master\src\config\loader.ts:
  162:       fallback: deepMerge(config.fallback, projectConfig.fallback),

.\ref\opencode-dev\packages\app\src\i18n\th.ts:
  476:   "notification.session.error.fallbackDescription": "เกิดข้อผิดพลาด",
  601:   "settings.general.row.wayland.description": "ปิดใช้งาน X11 fallback บน Wayland ต้องรีสตาร์ท",

.\ref\oh-my-opencode-theseus-master\src\config\loader.test.ts:
  92:             fallback1: 'anthropic/claude-opus-4-6',
  93:             fallback2: 'chutes/kimi-k2.5',
  94:             fallback3: 'opencode/gpt-5-nano',
  98:             fallback1: 'anthropic/claude-opus-4-6',
  99:             fallback2: 'chutes/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8-TEE',
  100:             fallback3: 'opencode/gpt-5-nano',
  104:             fallback1: 'anthropic/claude-opus-4-6',
  105:             fallback2: 'chutes/kimi-k2.5',
  106:             fallback3: 'opencode/gpt-5-nano',
  110:             fallback1: 'anthropic/claude-opus-4-6',
  111:             fallback2: 'chutes/kimi-k2.5',
  112:             fallback3: 'opencode/gpt-5-nano',
  116:             fallback1: 'anthropic/claude-opus-4-6',
  117:             fallback2: 'chutes/kimi-k2.5',
  118:             fallback3: 'opencode/gpt-5-nano',
  122:             fallback1: 'anthropic/claude-opus-4-6',
  123:             fallback2: 'chutes/kimi-k2.5',
  124:             fallback3: 'opencode/gpt-5-nano',
  131:     expect(config.manualPlan?.oracle?.fallback2).toBe(
  344:   test('merges fallback timeout and chains from user and project', () => {
  350:         fallback: {
  365:         fallback: {
  374:     expect(config.fallback?.timeoutMs).toBe(15000);
  375:     expect(config.fallback?.chains.oracle).toEqual([
  379:     expect(config.fallback?.chains.explorer).toEqual([
  384:   test('preserves fallback chains with additional agent keys', () => {
  391:         fallback: {
  400:     expect(config.fallback?.chains.writing).toEqual(['openai/gpt-5.2-codex']);
  689:         agents: { oracle: { model: 'fallback' } },
  697:     expect(config.agents?.oracle?.model).toBe('fallback');

.\ref\opencode-dev\packages\app\src\i18n\ru.ts:
  481:   "notification.session.error.fallbackDescription": "Произошла ошибка",
  607:   "settings.general.row.wayland.description": "Отключить X11 fallback на Wayland. Требуется перезапуск.",

.\ref\opencode-dev\packages\app\src\i18n\pl.ts:
  429:   "notification.session.error.fallbackDescription": "Wystąpił błąd",
  539:   "settings.general.row.wayland.description": "Wyłącz fallback X11 na Wayland. Wymaga restartu.",

.\ref\opencode-dev\packages\app\src\i18n\no.ts:
  481:   "notification.session.error.fallbackDescription": "Det oppstod en feil",
  609:   "settings.general.row.wayland.description": "Deaktiver X11-fallback på Wayland. Krever omstart.",

.\ref\opencode-dev\packages\app\src\i18n\ko.ts:
  430:   "notification.session.error.fallbackDescription": "오류가 발생했습니다",

.\ref\oh-my-opencode-dev\src\index.test.ts:
  57:     it("returns true when disabled_agents is undefined (fallback to empty)", () => {

.\ref\opencode-dev\packages\app\src\i18n\ja.ts:
  428:   "notification.session.error.fallbackDescription": "エラーが発生しました",

.\ref\opencode-dev\packages\app\src\i18n\fr.ts:
  436:   "notification.session.error.fallbackDescription": "Une erreur s'est produite",

.\ref\opencode-dev\packages\app\src\i18n\es.ts:
  481:   "notification.session.error.fallbackDescription": "Ocurrió un error",
  609:   "settings.general.row.wayland.description": "Deshabilitar fallback a X11 en Wayland. Requiere reinicio.",

.\ref\opencode-dev\packages\console\app\src\routes\zen\util\rateLimiter.ts:
  10:   const limitValue = limit.checkHeader && !headers.get(limit.checkHeader) ? limit.fallbackValue! : limit.value

.\ref\oh-my-opencode-theseus-master\src\cli\types.ts:
  63:   | 'provider-fallback-policy'
  97:   fallback1: string;
  98:   fallback2: string;
  99:   fallback3: string;

.\ref\opencode-dev\packages\app\src\i18n\en.ts:
  479:   "notification.session.error.fallbackDescription": "An error occurred",
  607:   "settings.general.row.wayland.description": "Disable X11 fallback on Wayland. Requires restart.",

.\ref\opencode-dev\packages\app\src\i18n\de.ts:
  438:   "notification.session.error.fallbackDescription": "Ein Fehler ist aufgetreten",

.\ref\opencode-dev\packages\app\src\i18n\da.ts:
  477:   "notification.session.error.fallbackDescription": "Der opstod en fejl",
  601:   "settings.general.row.wayland.description": "Deaktiver X11-fallback på Wayland. Kræver genstart.",

.\ref\opencode-dev\packages\app\src\i18n\bs.ts:
  480:   "notification.session.error.fallbackDescription": "Došlo je do greške",
  606:   "settings.general.row.wayland.description": "Onemogući X11 fallback na Waylandu. Zahtijeva restart.",

.\ref\opencode-dev\packages\app\src\i18n\br.ts:
  430:   "notification.session.error.fallbackDescription": "Ocorreu um erro",
  540:   "settings.general.row.wayland.description": "Desabilitar fallback X11 no Wayland. Requer reinicialização.",

.\ref\opencode-dev\packages\app\src\i18n\ar.ts:
  427:   "notification.session.error.fallbackDescription": "حدث خطأ",

.\ref\opencode-dev\packages\console\app\src\routes\zen\util\handler.ts:
  146:       // Try another provider => stop retrying if using fallback provider
  153:         modelInfo.fallbackProvider &&
  154:         providerInfo.id !== modelInfo.fallbackProvider
  409:       // fallback provider
  410:       return modelInfo.providers.find((provider) => provider.id === modelInfo.fallbackProvider)

.\ref\oh-my-opencode-theseus-master\src\cli\providers.ts:
  251:         // Build fallback chain from manual config
  252:         const fallbackChain = [
  254:           manualConfig.fallback1,
  255:           manualConfig.fallback2,
  256:           manualConfig.fallback3,
  258:         chains[agentName] = fallbackChain;
  263:     config.fallback = {
  367:     config.fallback = {
  527:     config.fallback = {

.\ref\oh-my-opencode-theseus-master\src\cli\providers.test.ts:
  152:   test('generateLiteConfig emits fallback chains for six agents', () => {
  169:     expect((config.fallback as any).enabled).toBe(true);
  170:     expect((config.fallback as any).timeoutMs).toBe(15000);
  171:     const chains = (config.fallback as any).chains;

.\ref\oh-my-opencode-theseus-master\src\cli\precedence-resolver.ts:
  56:       layer: 'provider-fallback-policy',

.\ref\oh-my-opencode-theseus-master\src\cli\install.ts:
  423:   const fallback1 =
  432:   if (fallback1 !== primary) selectedModels.add(fallback1);
  434:   // Filter again for fallback 2
  439:   const fallback2 =
  446:         )) ?? fallback1)
  447:       : fallback1;
  448:   if (fallback2 !== fallback1) selectedModels.add(fallback2);
  450:   // Filter again for fallback 3
  455:   const fallback3 =
  462:         )) ?? fallback2)
  463:       : fallback2;
  467:     fallback1,
  468:     fallback2,
  469:     fallback3,
  668:   // Always include zen fallback
  1204:           'No Chutes models found. Continuing with fallback Chutes mapping.',
  1416:       'No providers configured. Zen Big Pickle models will be used as fallback.',

.\ref\oh-my-opencode-dev\src\tools\delegate-task\types.ts:
  2: import type { BackgroundManager } from "../../features/background-agent"
  50:   manager: BackgroundManager

.\ref\opencode-dev\packages\app\src\context\global-sync.test.ts:
  33:     let fallback = 0
  43:         fallback += 1
  50:     expect(fallback).toBe(0)
  55:     let fallback = 0
  66:         fallback += 1
  76:     expect(fallback).toBe(1)

.\ref\oh-my-opencode-theseus-master\src\cli\dynamic-model-selection.ts:
  772:       winnerLayer: 'provider-fallback-policy',
  1307:         winnerLayer: 'provider-fallback-policy',

.\ref\oh-my-opencode-dev\src\tools\delegate-task\tools.test.ts:
  434:        // then proceeds without error - uses fallback chain
  739:     test("systemDefaultModel is used as fallback when custom category has no model", () => {
  2040:   describe("category model resolution fallback", () => {
  2053:             id: "task-fallback",
  2054:             sessionID: "ses_fallback_test",
  2093:           description: "Test category fallback",
  2142:            "fallback-test": { model: "anthropic/claude-opus-4-6" },
  2416:       // then - sisyphus-junior override model should be used as fallback
  2867:       // Using type assertion since we're testing fallback behavior for categories without model
  2882:       // Using type assertion since we're testing fallback behavior for categories without model
  3117:     test("agent without model resolves via fallback chain", async () => {
  3118:       // given - agent registered without model field, fallback chain should resolve
  3174:       // then - model should be resolved via AGENT_MODEL_REQUIREMENTS fallback chain
  3309:     test("fallback chain resolves model when no override and no matchedAgent.model (#1357)", async () => {
  3310:       // given - agent registered without model, no override, but AGENT_MODEL_REQUIREMENTS has fallback
  3332:            create: async () => ({ data: { id: "ses_fallback_test" } }),
  3338:            status: async () => ({ data: { "ses_fallback_test": { type: "idle" } } }),
  3360:           description: "Consult oracle with fallback",
  3369:       // then - should resolve via AGENT_MODEL_REQUIREMENTS fallback chain for oracle
  3370:       // oracle fallback chain: gpt-5.2 (openai) > gemini-3-pro (google) > claude-opus-4-6 (anthropic)

.\ref\oh-my-opencode-dev\src\hooks\unstable-agent-babysitter\unstable-agent-babysitter-hook.ts:
  1: import type { BackgroundManager } from "../../features/background-agent"
  49:   backgroundManager: Pick<BackgroundManager, "getTasksByParentSession">

.\ref\oh-my-opencode-dev\src\tools\delegate-task\sync-session-poller.ts:
  108:       log("[task] Poll complete - assistant text detected (fallback)", {

.\ref\oh-my-opencode-dev\src\hooks\unstable-agent-babysitter\index.test.ts:
  33: function createBackgroundManager(tasks: BackgroundTask[]) {
  80:     const backgroundManager = createBackgroundManager([createTask()])
  113:     const backgroundManager = createBackgroundManager([
  141:     const backgroundManager = createBackgroundManager([
  164:     const backgroundManager = createBackgroundManager([createTask()])

.\ref\oh-my-opencode-dev\src\tools\delegate-task\subagent-resolver.ts:
  98:         fallbackChain: agentRequirement?.fallbackChain,

.\ref\oh-my-opencode-theseus-master\src\background\tmux-session-manager.ts:
  120:       // Start polling for fallback reliability
  181:    * Poll sessions for status updates (fallback for reliability).
  217:         // Check for timeout as a safety fallback

.\ref\oh-my-opencode-theseus-master\src\background\background-manager.ts:
  234:     const fallback = this.config?.fallback;
  235:     const chains = fallback?.chains as
  344:         this.config?.fallback?.timeoutMs ?? FALLBACK_FAILOVER_TIMEOUT_MS;
  345:       const fallbackEnabled = this.config?.fallback?.enabled ?? true;
  346:       const chain = fallbackEnabled
  364:               throw new Error(`Invalid fallback model format: ${model}`);
  391:         throw new Error(`All fallback models failed. ${errors.join(' | ')}`);
  547:     // Clean up session tracking maps as fallback

.\ref\oh-my-opencode-theseus-master\src\background\background-manager.test.ts:
  508:         fallback: {
  532:     test('fails task when all fallback models fail', async () => {
  545:         fallback: {
  566:       expect(task.error).toContain('All fallback models failed');

.\ref\oh-my-opencode-dev\src\tools\delegate-task\model-selection.ts:
  12:   fallbackChain?: FallbackEntry[]
  35:   const fallbackChain = input.fallbackChain
  36:   if (fallbackChain && fallbackChain.length > 0) {
  38:       const first = fallbackChain[0]
  44:       for (const entry of fallbackChain) {

.\ref\oh-my-opencode-dev\src\tools\delegate-task\executor-types.ts:
  1: import type { BackgroundManager } from "../../features/background-agent"
  6:   manager: BackgroundManager

.\ref\oh-my-opencode-dev\src\tools\delegate-task\category-resolver.ts:
  98:       fallbackChain: requirement.fallbackChain,

.\ref\opencode-dev\packages\opencode\src\config\markdown.ts:
  18:   // frontmatter, we need to fallback to a more permissive parser for those cases
  19:   export function fallbackSanitization(content: string): string {
  78:         return matter(fallbackSanitization(template))

.\ref\oh-my-opencode-dev\src\hooks\todo-continuation-enforcer\types.ts:
  1: import type { BackgroundManager } from "../../features/background-agent"
  5:   backgroundManager?: BackgroundManager

.\ref\oh-my-opencode-dev\src\agents\utils.test.ts:
  169:    test("Oracle uses connected provider fallback when availableModels is empty and cache exists", async () => {
  170:      // #given - connected providers cache has "openai", which matches oracle's first fallback entry
  176:      // #then - oracle resolves via connected cache fallback to openai/gpt-5.2 (not system default)
  190:      // #then - oracle should be created with system default model (fallback to systemDefaultModel)
  473:    test("agents created via connected cache fallback even without systemDefaultModel", async () => {
  474:      // #given - connected cache has "openai", which matches oracle's fallback chain
  498:   test("sisyphus created via connected cache fallback when all providers available", async () => {
  638:   test("sisyphus is created when at least one fallback model is available", async () => {
  691:   test("sisyphus is not created when no fallback model is available and provider not connected", async () => {
  692:     // #given - only openai/gpt-5.2 available, not in sisyphus fallback chain
  710:   test("sisyphus uses user-configured plugin model even when not in cache or fallback chain", async () => {
  712:     // that is NOT in the availableModels cache and NOT in the fallback chain

.\ref\oh-my-opencode-dev\src\tools\delegate-task\background-task.ts:
  35:     // BackgroundManager.launch() returns immediately (pending) before the session exists,

.\ref\oh-my-opencode-dev\src\hooks\todo-continuation-enforcer\todo-continuation-enforcer.test.ts:
  3: import type { BackgroundManager } from "../../features/background-agent"
  180:   function createMockBackgroundManager(runningTasks: boolean = false): BackgroundManager {
  208:       backgroundManager: createMockBackgroundManager(false),
  256:       backgroundManager: createMockBackgroundManager(true),
  1063:   test("should use API fallback when event is missed but API shows abort", async () => {
  1065:     const sessionID = "main-api-fallback"
  1081:     // then - no continuation (API fallback detected the abort)
  1092:       backgroundManager: createMockBackgroundManager(false),
  1151:        backgroundManager: createMockBackgroundManager(false),
  1212:        backgroundManager: createMockBackgroundManager(false),

.\ref\oh-my-opencode-dev\src\agents\types.ts:
  6:  * - "subagent": Uses own fallback chain, ignores UI selection (oracle, explore, etc.)

.\ref\oh-my-opencode-dev\src\hooks\todo-continuation-enforcer\idle-event.ts:
  3: import type { BackgroundManager } from "../../features/background-agent"
  23:   backgroundManager?: BackgroundManager
  70:       log(`[${HOOK_NAME}] Skipped: last assistant message was aborted (API fallback)`, { sessionID })

.\ref\oh-my-opencode-dev\src\hooks\todo-continuation-enforcer\handler.ts:
  3: import type { BackgroundManager } from "../../features/background-agent"
  14:   backgroundManager?: BackgroundManager

.\ref\oh-my-opencode-dev\src\hooks\todo-continuation-enforcer\countdown.ts:
  3: import type { BackgroundManager } from "../../features/background-agent"
  38:   backgroundManager?: BackgroundManager

.\ref\oh-my-opencode-dev\src\hooks\todo-continuation-enforcer\continuation-injection.ts:
  3: import type { BackgroundManager } from "../../features/background-agent"
  32:   backgroundManager?: BackgroundManager

.\ref\oh-my-opencode-theseus-master\src\agents\index.test.ts:
  71: describe('fixer agent fallback', () => {

.\ref\opencode-dev\packages\opencode\src\tool\websearch.ts:
  23:       livecrawl?: "fallback" | "preferred"
  49:         .enum(["fallback", "preferred"])
  52:           "Live crawl mode - 'fallback': use live crawling as backup if cached content unavailable, 'preferred': prioritize live crawling (default: 'fallback')",
  89:             livecrawl: params.livecrawl || "fallback",

.\ref\opencode-dev\packages\opencode\src\tool\webfetch.ts:
  43:     // Build Accept header based on requested format with q parameters for fallbacks

.\ref\oh-my-opencode-dev\src\tools\call-omo-agent\tools.ts:
  4: import type { BackgroundManager } from "../../features/background-agent"
  11:   backgroundManager: BackgroundManager

.\ref\oh-my-opencode-dev\src\tools\call-omo-agent\session-creator.ts:
  35:     log(`[call_omo_agent] Parent session dir: ${parentSession?.data?.directory}, fallback: ${ctx.directory}`)

.\ref\opencode-dev\packages\opencode\src\provider\sdk\copilot\responses\openai-responses-language-model.ts:
  1531:   z.object({ type: z.string() }).loose(), // fallback for unknown chunks

.\ref\opencode-dev\packages\opencode\src\tool\edit.ts:
  159: // Similarity thresholds for block anchor fallback matching

.\ref\oh-my-opencode-dev\src\tools\call-omo-agent\background-executor.ts:
  2: import type { BackgroundManager } from "../../features/background-agent"
  18:   manager: BackgroundManager

.\ref\opencode-dev\packages\app\src\components\session\session-context-metrics.test.ts:
  70:   test("preserves fallback labels and null usage when model metadata is missing", () => {

.\ref\oh-my-opencode-dev\src\tools\call-omo-agent\background-executor.test.ts:
  2: import type { BackgroundManager } from "../../features/background-agent"
  15:   } as unknown as BackgroundManager

.\ref\opencode-dev\packages\opencode\test\provider\provider.test.ts:
  1410: test("provider env fallback - second env var used if first missing", async () => {
  1418:             "fallback-env": {
  1439:       // Only set fallback, not primary
  1440:       Env.set("FALLBACK_KEY", "fallback-api-key")
  1444:       // Provider should load because fallback env var is set
  1445:       expect(providers["fallback-env"]).toBeDefined()

.\ref\oh-my-opencode-dev\src\tools\call-omo-agent\background-agent-executor.ts:
  1: import type { BackgroundManager } from "../../features/background-agent"
  12: 	manager: BackgroundManager,

.\ref\oh-my-opencode-dev\src\tools\call-omo-agent\background-agent-executor.test.ts:
  2: import type { BackgroundManager } from "../../features/background-agent"
  15:   } as unknown as BackgroundManager

.\ref\oh-my-opencode-dev\src\tools\look-at\tools.test.ts:
  30:       const args = { file_path: "/preferred.png", path: "/fallback.png", goal: "test" }

.\ref\opencode-dev\packages\opencode\test\plugin\codex.test.ts:
  61:     test("extracts from organizations array as fallback", () => {

.\ref\opencode-dev\packages\opencode\src\provider\error.ts:
  21:     /context[_ ]length[_ ]exceeded/i, // Generic fallback

.\ref\oh-my-opencode-dev\src\tools\background-task\types.ts:
  50: export type BackgroundOutputManager = Pick<import("../../features/background-agent").BackgroundManager, "getTask">

.\ref\opencode-dev\packages\opencode\src\shell\shell.ts:
  38:   function fallback() {
  59:     return fallback()
  65:     return fallback()

.\ref\opencode-dev\packages\opencode\test\permission\next.test.ts:
  323: test("evaluate - wildcard permission fallback for unknown tool", () => {

.\ref\oh-my-opencode-dev\src\tools\index.ts:
  33: import type { BackgroundManager } from "../features/background-agent"
  47: export function createBackgroundTools(manager: BackgroundManager, client: OpencodeClient): Record<string, ToolDefinition> {

.\ref\oh-my-opencode-dev\src\tools\background-task\tools.test.ts:
  5: import type { BackgroundManager, BackgroundTask } from "../../features/background-agent"
  327:     } as unknown as BackgroundManager
  353:     } as unknown as BackgroundManager
  377:     } as unknown as BackgroundManager
  401:     } as unknown as BackgroundManager
  427:     } as unknown as BackgroundManager

.\ref\opencode-dev\packages\opencode\src\cli\cmd\tui\ui\spinner.ts:
  145:   // We use RGBA.fromHex for the fallback to ensure we have an RGBA object.

.\ref\oh-my-opencode-dev\src\tools\background-task\modules\background-task.ts:
  2: import type { BackgroundManager } from "../../../features/background-agent"
  11: export function createBackgroundTask(manager: BackgroundManager): ToolDefinition {

.\ref\oh-my-opencode-dev\src\tools\background-task\modules\background-cancel.ts:
  3: import type { BackgroundManager } from "../../../features/background-agent"
  7: export function createBackgroundCancel(manager: BackgroundManager, client: BackgroundCancelClient): ToolDefinition {

.\ref\oh-my-opencode-dev\src\tools\background-task\create-background-task.ts:
  2: import type { BackgroundManager } from "../../features/background-agent"
  21: export function createBackgroundTask(manager: BackgroundManager): ToolDefinition {

.\ref\oh-my-opencode-dev\src\tools\background-task\create-background-task.test.ts:
  2: import type { BackgroundManager } from "../../features/background-agent"
  15:   } as unknown as BackgroundManager

.\ref\oh-my-opencode-dev\src\tools\background-task\create-background-cancel.ts:
  2: import type { BackgroundManager } from "../../features/background-agent"
  7: export function createBackgroundCancel(manager: BackgroundManager, client: BackgroundCancelClient): ToolDefinition {

.\ref\oh-my-opencode-dev\src\tools\background-task\clients.ts:
  1: import type { BackgroundManager } from "../../features/background-agent"
  32: export type BackgroundOutputManager = Pick<BackgroundManager, "getTask">

.\ref\opencode-dev\packages\app\src\components\prompt-input\editor-dom.ts:
  90:   const fallbackRange = document.createRange()
  91:   const fallbackSelection = window.getSelection()
  95:     fallbackRange.setStart(last, len)
  98:     fallbackRange.selectNodeContents(parent)
  100:   fallbackRange.collapse(false)
  101:   fallbackSelection?.removeAllRanges()
  102:   fallbackSelection?.addRange(fallbackRange)

.\ref\opencode-dev\packages\opencode\src\lsp\server.ts:
  1244:       // 4) Maven fallback
  1915:       // Finally, use the instance directory as fallback

.\ref\oh-my-opencode-dev\src\tools\glob\cli.ts:
  73:   // which handles symlinks via --follow. This fallback rarely triggers in practice.

.\ref\oh-my-opencode-dev\src\tools\ast-grep\downloader.ts:
  18: // This is only used as fallback when @ast-grep/cli package.json cannot be read

.\ref\opencode-dev\packages\opencode\src\cli\cmd\run.ts:
  64: function fallback(part: ToolPart) {
  423:           return fallback(part)
  425:           return fallback(part)

.\ref\oh-my-opencode-dev\src\hooks\rules-injector\rule-file-scanner.ts:
  44:  * Resolve symlinks safely with fallback to original path

.\ref\oh-my-opencode-dev\src\agents\dynamic-agent-prompt-builder.ts:
  123: Use it as a **peer tool**, not a fallback. Fire liberally.

.\ref\oh-my-opencode-dev\src\agents\builtin-agents\general-agents.ts:
  78:     // Apply resolved variant from model fallback chain

.\ref\oh-my-opencode-dev\src\agents\builtin-agents\sisyphus-agent.ts:
  48:     isAnyFallbackModelAvailable(sisyphusRequirement.fallbackChain, availableModels)

.\ref\oh-my-opencode-dev\src\agents\builtin-agents\model-resolution.ts:
  6:   requirement?: { fallbackChain?: { providers: string[]; model: string; variant?: string }[] }
  14:     policy: { fallbackChain: requirement?.fallbackChain, systemDefaultModel },
  19:   fallbackChain?: { providers: string[]; model: string; variant?: string }[]
  21:   const entry = requirement?.fallbackChain?.[0]
  25:     provenance: "provider-fallback" as const,

.\ref\oh-my-opencode-dev\src\create-managers.ts:
  6: import { BackgroundManager } from "./features/background-agent"
  15:   backgroundManager: BackgroundManager
  30:   const backgroundManager = new BackgroundManager(

.\ref\oh-my-opencode-dev\src\create-hooks.ts:
  4: import type { BackgroundManager } from "./features/background-agent"
  16:   backgroundManager: BackgroundManager

.\ref\oh-my-opencode-dev\src\hooks\prometheus-md-only\agent-resolution.ts:
  32:  * 3. Message files (fallback for sessions without boulder state)

.\ref\oh-my-opencode-dev\src\hooks\comment-checker\cli-runner.ts:
  11:   fallback: T,
  16:     return fallback

.\ref\oh-my-opencode-dev\src\hooks\keyword-detector\index.test.ts:
  742:     // then - prometheus fallback from input.agent, ultrawork skipped

.\ref\oh-my-opencode-dev\src\cli\tui-installer.ts:
  101:     p.log.warn("No model providers configured. Using opencode/glm-4.7-free as fallback.")

.\ref\oh-my-opencode-dev\src\cli\tui-install-prompts.ts:
  35:       { value: "no", label: "No", hint: "Will use opencode/glm-4.7-free as fallback" },
  46:       { value: "no", label: "No", hint: "Oracle will use fallback models" },
  56:       { value: "no", label: "No", hint: "Frontend/docs agents will use fallback" },
  97:       { value: "yes", label: "Yes", hint: "Kimi K2.5 for Sisyphus/Prometheus fallback" },

.\ref\oh-my-opencode-dev\src\cli\config-manager\generate-omo-config.ts:
  2: import { generateModelConfig } from "../model-fallback"

.\ref\oh-my-opencode-dev\src\cli\cli-program.ts:
  45:   Copilot       github-copilot/ models (fallback)
  48:   Kimi          kimi-for-coding/k2p5 (Sisyphus/Prometheus fallback)
  71:   .option("-a, --agent <name>", "Agent to use (default: from CLI/env/config, fallback: Sisyphus)")
  94:   4) Sisyphus (fallback)

.\ref\oh-my-opencode-dev\src\cli\cli-installer.ts:
  131:     printWarning("No model providers configured. Using opencode/glm-4.7-free as fallback.")

.\ref\oh-my-opencode-dev\src\cli\run\agent-resolver.ts:
  50:     const fallback = pickFallbackAgent(pluginConfig)
  51:     const fallbackDisabled = isAgentDisabled(fallback, pluginConfig)
  52:     if (fallbackDisabled) {
  55:           `Requested agent "${normalized}" is disabled and no enabled core agent was found. Proceeding with "${fallback}".`
  58:       return fallback
  62:         `Requested agent "${normalized}" is disabled. Falling back to "${fallback}".`
  65:     return fallback

.\ref\oh-my-opencode-dev\src\cli\provider-availability.ts:
  2: import type { ProviderAvailability } from "./model-fallback-types"

.\ref\oh-my-opencode-dev\src\cli\model-fallback.ts:
  7: import type { AgentConfig, CategoryConfig, GeneratedOmoConfig } from "./model-fallback-types"
  15: } from "./fallback-chain-resolution"
  17: export type { GeneratedOmoConfig } from "./model-fallback-types"
  74:       const fallbackChain = getSisyphusFallbackChain()
  75:       if (req.requiresAnyModel && !isAnyFallbackEntryAvailable(fallbackChain, avail)) {
  78:       const resolved = resolveModelFromChain(fallbackChain, avail)
  86:     if (req.requiresModel && !isRequiredModelAvailable(req.requiresModel, req.fallbackChain, avail)) {
  93:     const resolved = resolveModelFromChain(req.fallbackChain, avail)
  104:     const fallbackChain =
  106:         ? CATEGORY_MODEL_REQUIREMENTS["unspecified-low"].fallbackChain
  107:         : req.fallbackChain
  109:     if (req.requiresModel && !isRequiredModelAvailable(req.requiresModel, req.fallbackChain, avail)) {
  116:     const resolved = resolveModelFromChain(fallbackChain, avail)

.\ref\oh-my-opencode-dev\src\cli\model-fallback.test.ts:
  3: import { generateModelConfig } from "./model-fallback"
  103:     test("uses preferred models from fallback chains when all natives available", () => {
  114:       // #then should use first provider in each fallback chain
  135:   describe("fallback providers", () => {
  260:     test("uses all fallback providers together", () => {
  261:       // #given all fallback providers are available
  354:       // #then explore should use gpt-5-nano (fallback)
  365:       // #then explore should use gpt-5-mini (Copilot fallback)
  371:     test("Sisyphus is created when at least one fallback provider is available (Claude)", () => {
  382:     test("Sisyphus is created when multiple fallback providers are available", () => {
  399:     test("Sisyphus is omitted when no fallback provider is available (OpenAI not in chain)", () => {
  504:       // #then librarian should use claude-sonnet-4-5 (third in fallback chain after ZAI and opencode/glm)

.\ref\oh-my-opencode-dev\src\hooks\claude-code-hooks\pre-tool-use.ts:
  145:           // Return if decision is set OR if any common fields are set (fallback to allow)

.\ref\oh-my-opencode-dev\src\hooks\claude-code-hooks\post-tool-use.ts:
  76:       // Use temp transcript if available, otherwise fallback to append-based

.\ref\oh-my-opencode-dev\src\shared\shell-env.ts:
  9:  * 3. Platform fallback → win32: cmd, others: unix

.\ref\oh-my-opencode-dev\src\hooks\background-notification\hook.ts:
  1: import type { BackgroundManager } from "../../features/background-agent"
  13:  * Background notification hook - handles event routing to BackgroundManager.
  18: export function createBackgroundNotificationHook(manager: BackgroundManager) {

.\ref\oh-my-opencode-dev\src\cli\install-validators.ts:
  37:   lines.push(formatProvider("GitHub Copilot", config.hasCopilot, "fallback"))
  40:   lines.push(formatProvider("Kimi For Coding", config.hasKimiForCoding, "Sisyphus/Prometheus fallback"))

.\ref\oh-my-opencode-dev\src\hooks\compaction-context-injector\hook.ts:
  1: import type { BackgroundManager } from "../../features/background-agent"
  59: export function createCompactionContextInjector(backgroundManager?: BackgroundManager) {

.\ref\oh-my-opencode-dev\src\shared\fallback-model-availability.ts:
  6: 	fallbackChain: Array<{ providers: string[]; model: string }>,
  10: 		for (const entry of fallbackChain) {
  23: 		for (const entry of fallbackChain) {

.\ref\o

... (truncated)
```
