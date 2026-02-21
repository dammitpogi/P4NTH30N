# Tool Output: tool_c6a4bc2e3001N3hkrZ2s9ckwNX
**Date**: 2026-02-17 06:31:15 UTC
**Size**: 252,023 bytes

```

C:\Users\paulc\.config\opencode\dev\codemap.md:
  7: - **Agent orchestration system** - 6 specialized AI agents (orchestrator, oracle, designer, explorer, librarian, fixer) with distinct roles and permissions
  11: - **Model management** - Comprehensive model research and per-agent model assignments with fallback chains
  20: | orchestrator | Primary coordinator | all subagents |
  30: - Agent model fallback chains provide resilience and cost optimization
  36: - `oh-my-opencode-theseus.json` - Plugin-specific: agent model assignments, disabled MCPs, idle orchestrator
  66: 1. User submits task → OpenCode routes to orchestrator (primary mode)
  67: 2. Orchestrator analyzes task → delegates to appropriate subagents via `task` tool
  72: 7. Results synthesized and returned through orchestrator
  76: 2. On failure/timeout → fallback chain traversed automatically
  77: 3. Fallback triage tracked (`oh-my-opencode-theseus.json` → `fallback.triage`)
  131: - `plugin/src/agents/` - Agent implementations (orchestrator, explorer, oracle, librarian, designer, fixer)
  136: - `plugin/src/background/` - Background task execution with fallback chains
  137: - `plugin/src/hooks/` - OpenCode lifecycle hooks (idle-orchestrator, phase-reminder, etc.)

C:\Users\paulc\.config\opencode\dev\AGENTS.md:
  4: 	- Orchestrator: The Nexus asked him and he named himself Atlas.
  21: This is a lightweight agent orchestration plugin for OpenCode, built with TypeScript and Bun. It replaces the default single-agent model with a specialized team (Orchestrator, Explorer, Fixer, etc.).
  166: │   ├── orchestrator.ts   # Main coordination agent
  194: - **Impact**: Enables the fallback mechanism to work correctly when agent permission is denied. Previously, the returned string was being treated as a success response, bypassing fallback logic.
  213: - **Files**: `src/agents/orchestrator.ts`, `src/agents/designer.ts`, `src/agents/oracle.ts`, `src/agents/explorer.ts`, `src/agents/fixer.ts`, `src/agents/librarian.ts`
  220:     - `orchestrator.ts` - Added `loadAgentPrompt()` function
  224:   - File naming: `{agentName}.md` (e.g., `orchestrator.md`, `explorer.md`)
  250: - If compaction fails, the system proceeds to model fallback
  264: ### Model Fallback Chains
  265: Configure automatic model fallback when primary models fail due to provider errors.
  272:     "orchestrator": {
  285: - **Provider errors** (rate limits, context length, service unavailable) trigger fallback
  286: - **Validation errors** fail immediately without fallback
  287: - Each agent type has its own fallback chain
  305:   - `retryWithNextModel()` - Uses current model tracking instead of faulty fallbackInfo lookup
  307: **Tracked Metrics** (in `agents.<agent>.currentModel` and `fallback.triage`):
  314: Previously, the system relied on `fallbackInfo` lookups which could become stale or incorrect during retries. The new current model tracking ensures:
  317: - Proper fallback chain progression on retries
  426: - **Path Resolution**: Config loader uses `os.homedir()` for cross-platform path resolution, ensuring fallback chains and presets from `~/.config/opencode/oh-my-opencode-theseus.json` are loaded correctly on all platforms (including Windows)

C:\Users\paulc\.config\opencode\dev\CHANGELOG.md:
  8: - **Model Fallback**: Corrected hardcoded default model IDs and cleared stale triage state to ensure reliable agent communication.

C:\Users\paulc\.config\opencode\dev\README.md:
  72: ### 01. Orchestrator: The Embodiment Of Order
  77:       <img src="img/orchestrator.png" width="240" style="border-radius: 10px;">
  81:       The Orchestrator was born when the first codebase collapsed under its own complexity. Neither god nor mortal would claim responsibility - so The Orchestrator emerged from the void, forging order from chaos. It determines the optimal path to any goal, balancing speed, quality, and cost. It guides the team, summoning the right specialist for each task and delegating to achieve the best possible outcome.
  91:       <b>Prompt:</b> <code>~/.config/opencode/agents/orchestrator.md</code>

C:\Users\paulc\.config\opencode\dev\src\agents\orchestrator.ts:
  39: export function createOrchestratorAgent(
  44:   const basePrompt = loadAgentPrompt('orchestrator');
  58:     name: 'orchestrator',
  60:       'AI coding orchestrator that delegates tasks to specialist agents for optimal quality, speed, and cost',

C:\Users\paulc\.config\opencode\dev\src\agents\oracle.ts:
  1: import { type AgentDefinition, loadAgentPrompt } from './orchestrator';

C:\Users\paulc\.config\opencode\dev\src\agents\fixer.ts:
  1: import { type AgentDefinition, loadAgentPrompt } from './orchestrator';

C:\Users\paulc\.config\opencode\dev\src\agents\librarian.ts:
  1: import { type AgentDefinition, loadAgentPrompt } from './orchestrator';

C:\Users\paulc\.config\opencode\dev\src\index.ts:
  12:   createIdleOrchestratorHook,
  42:     hasFallback: !!config?.fallback,
  135:   // Initialize idle orchestrator hook - keeps Orchestrator busy for background task auto-flush
  136:   const idleOrchestratorHook = createIdleOrchestratorHook(
  138:     config.idleOrchestrator,
  199:         'orchestrator';
  318:       // Handle idle orchestrator - proactive prompts to keep Orchestrator busy
  319:       await idleOrchestratorHook.event(input);

C:\Users\paulc\.config\opencode\dev\src\agents\explorer.ts:
  1: import { type AgentDefinition, loadAgentPrompt } from './orchestrator';

C:\Users\paulc\.config\opencode\dev\src\agents\index.test.ts:
  91: describe('orchestrator agent', () => {
  92:   test('orchestrator is first in agents array', () => {
  94:     expect(agents[0].name).toBe('orchestrator');
  97:   test('orchestrator does not enforce hardcoded question permission', () => {
  99:     const orchestrator = agents.find((a) => a.name === 'orchestrator');
  100:     expect((orchestrator?.config.permission as any)?.question).toBeUndefined();
  103:   test('orchestrator accepts overrides', () => {
  106:         orchestrator: {
  107:           currentModel: 'custom-orchestrator-model',
  113:     const orchestrator = agents.find((a) => a.name === 'orchestrator');
  114:     expect(orchestrator?.config.model).toBe('custom-orchestrator-model');
  115:     expect(orchestrator?.config.temperature).toBe(0.3);
  128:   test('returns false for orchestrator', () => {
  129:     expect(isSubagent('orchestrator')).toBe(false);
  140:   test('SUBAGENT_NAMES excludes orchestrator', () => {
  141:     expect(SUBAGENT_NAMES).not.toContain('orchestrator');
  150:     expect(configs.orchestrator.mode).toBe('primary');
  163:     expect(names).toContain('orchestrator');
  180:     expect(configs.orchestrator).toBeDefined();
  182:     expect(configs.orchestrator.model).toBeDefined();
  187:     expect(configs.orchestrator.description).toBeDefined();

C:\Users\paulc\.config\opencode\dev\src\agents\index.ts:
  22: import { type AgentDefinition, createOrchestratorAgent } from './orchestrator';
  24: export type { AgentDefinition } from './orchestrator';
  102:   const triage = config?.fallback?.triage;
  157:  * Instantiates the orchestrator and all subagents, applying user config and defaults.
  160:  * @returns Array of agent definitions (orchestrator first, then subagents)
  183:   // 3. Create Orchestrator (with circuit breaker filtering)
  184:   const orchestratorModel = selectHealthyModel('orchestrator', config);
  185:   const orchestrator = createOrchestratorAgent(orchestratorModel);
  186:   const oOverride = getAgentOverride(config, 'orchestrator');
  188:     applyOverrides(orchestrator, oOverride);
  191:   return [orchestrator, ...allSubAgents];
  216:       } else if (a.name === 'orchestrator') {

C:\Users\paulc\.config\opencode\dev\src\agents\designer.ts:
  1: import { type AgentDefinition, loadAgentPrompt } from './orchestrator';

C:\Users\paulc\.config\opencode\dev\src\agents\codemap.md:
  5: The `src/agents/` directory defines and configures the multi-agent orchestration system for OpenCode. It creates specialized AI agents with distinct roles, capabilities, and behaviors that work together under an orchestrator to optimize coding tasks for quality, speed, cost, and reliability.
  28: - **Orchestrator**: Central coordinator that delegates tasks to specialists
  41: - Fallback mechanism: Fixer inherits Librarian's model if not configured
  71:   │   ├─→ Get model (with fallback for fixer)
  77:   ├─→ Create orchestrator:
  84:   └─→ Return [orchestrator, ...subagents]
  99:   │   │   ├─→ 'primary' for orchestrator
  106: ### Orchestrator Delegation Flow
  145: Orchestrator
  154: Orchestrator
  158: Orchestrator (implements or delegates to Fixer)
  163: Orchestrator
  232: 5. **Fallback Model**: Fixer inherits Librarian's model for backward compatibility
  235: 8. **Parallel-First**: Orchestrator encouraged to parallelize independent tasks
  244: ├── orchestrator.ts   # Orchestrator agent definition and delegation workflow

C:\Users\paulc\.config\opencode\dev\skills\openai-usage\SKILL.md:
  23: - No manual fallback. If Codex rate limits are unavailable, return an actionable error.

C:\Users\paulc\.config\opencode\dev\src\skills\codemap.md:
  5: Holds skill assets that ship with the plugin repository (markdown skill definitions and any bundled helper scripts). These files are intended to be copied/installed into an OpenCode skills directory so the Orchestrator can follow deterministic workflows (for example: cartography).
  12:   - `scripts/`: optional helpers executed via the Orchestrator (e.g., `cartographer.py`).
  19: 3. The Orchestrator runs any prescribed commands (often via `bash`) and coordinates any agent delegation required by the workflow.

C:\Users\paulc\.config\opencode\dev\skills\cartography\SKILL.md:
  21:    - The Orchestrator coordinates and synthesizes.
  27:    - Run `cartographer.py changes/update` in the main session (Orchestrator).
  91:    - The Orchestrator or Librarian must write the returned content into that directory's `codemap.md`.
  116:    - Re-run delegation for that directory OR have Orchestrator/Librarian author the codemap directly from local file reads.
  128: Once all specific directories are mapped, the Orchestrator must create or update the root `codemap.md`. This file serves as the **Master Entry Point** for any agent or human entering the repository.
  192: - Default prompts (orchestrator.ts, explorer.ts, etc.)
  224: | `src/agents/` | Defines agent personalities (Orchestrator, Explorer) and manages model routing. | [View Map](src/agents/codemap.md) |

C:\Users\paulc\.config\opencode\dev\src\shared\codemap-utils.ts:
  50:     // Fallback: Try to extract structured information from markdown

C:\Users\paulc\.config\opencode\dev\skills\model-tester\SKILL.md:
  68: Read `oh-my-opencode-theseus.json`, find the `fallback.triage` section, and add failed models:

C:\Users\paulc\.config\opencode\dev\src\skills\cartography\SKILL.md:
  76: Once all specific directories are mapped, the Orchestrator must create or update the root `codemap.md`. This file serves as the **Master Entry Point** for any agent or human entering the repository.
  102: - Default prompts (orchestrator.ts, explorer.ts, etc.)
  134: | `src/agents/` | Defines agent personalities (Orchestrator, Explorer) and manages model routing. | [View Map](src/agents/codemap.md) |

C:\Users\paulc\.config\opencode\dev\skills\cartography\README.md:
  7: Cartography helps orchestrators map and understand codebases by:

C:\Users\paulc\.config\opencode\dev\src\utils\codemap.md:
  11: Each helper lives in its own module and re-exports through `src/utils/index.ts`, keeping public surface area flat. Key ideas include memoized state (cached TMUX path, server availability cache, stored layouts), configuration defaults fed from `../config` constants, defensive guards (abort checks, empty-string variants), and layered platform detection (Windows build/tar, PowerShell fallbacks). Logging is best-effort: synchronous file append inside a try/catch so it never throws upstream.
  15: Agent variant helpers normalize names, read `PluginConfig.agents`, trim/validate variants, and only mutate request bodies when a variant is missing; `log` simply timestamps and appends strings to a temp file. `pollUntilStable` loops with configurable intervals, fetch callbacks, and stability guards, honoring max time and abort signals before returning a typed `PollResult`. TMUX helpers scan for the binary (`which/where`), cache the result, verify layouts, spawn panes with `opencode attach`, reapply stored layouts on close, and guard against missing servers by checking `/health`. `extractZip` detects the OS (tar on modern Windows, pwsh/powershell fallback) before spawning native unpack commands and bubbling errors when processes fail.

C:\Users\paulc\.config\opencode\dev\src\utils\tmux.ts:
  17:  * This is needed because ctx.serverUrl may return a fallback URL even when no server is running.
  212:   // This is needed because serverUrl may be a fallback even when no server is running

C:\Users\paulc\.config\opencode\dev\src\hooks\phase-reminder\index.ts:
  12: ⚡ ALWAYS use background_task (not regular Task) for delegation - enables fallbacks
  37:  * Only injects for the orchestrator agent.
  66:       // Only inject for orchestrator (or if no agent specified = main session)
  68:       if (agent && agent !== 'orchestrator') {

C:\Users\paulc\.config\opencode\dev\src\hooks\phase-reminder\codemap.md:
  5: Keep the orchestrator agent’s working memory on track by injecting a terse phase reminder directly into the payload sent to the API. Because the reminder lives in `experimental.chat.messages.transform`, it doesn’t surface in the UI until the next response is generated, yet it keeps the delegate→plan→execute→verify workflow in scope for every user turn.
  9: Exports a single factory (`createPhaseReminderHook`) that supplies an `experimental.chat.messages.transform` handler. The hook stores the reminder template in `PHASE_REMINDER`, scopes mutation to the orchestrator (or default session) only, and rewrites the first text part of the last user message by prefixing it with the reminder plus a divider. Encapsulating this in a synchronous factory keeps the hook pluggable and compatible with the global hook registry.
  17: Registered through the shared hook registry, this module hooks the `experimental.chat.messages.transform` lifecycle event that runs right before OpenAI invocation. It only touches the orchestrator session’s outgoing message list, so its effect is indirect: the reminder guides every assistant response that follows the user turn, but no other module needs to call it explicitly.

C:\Users\paulc\.config\opencode\dev\src\hooks\index.ts:
  6: export { createIdleOrchestratorHook, type IdleOrchestratorConfig } from './idle-orchestrator';

C:\Users\paulc\.config\opencode\dev\src\skills\cartography\scripts\codemap.md:
  32: - Called by the Orchestrator from the cartography skill workflow.

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\bench_calc.json:
  9:     "Orchestrator": {

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\benchmarks.json:
  276:       "note": "Fastest local - ultimate fallback"
  302:     "orchestrator": {
  389:       "notes": "Mixed quality - fallback only"
  395:       "notes": "Local - ultimate fallback when all APIs fail",
  409:       "orchestrator": "gpt-4o - OpenAI primary",

C:\Users\paulc\.config\opencode\dev\src\skills\cartography\README.md:
  7: Cartography helps orchestrators map and understand codebases by:

C:\Users\paulc\.config\opencode\dev\src\hooks\idle-orchestrator\index.ts:
  2: import type { IdleOrchestratorConfig } from '../../config/schema';
  12:  * Creates a hook that proactively prompts the Orchestrator when idle.
  13:  * This keeps the Orchestrator "busy" so that background task results
  16: export function createIdleOrchestratorHook(
  18:   options: IdleOrchestratorConfig = {
  49:           // First time seeing this session - verify it's main orchestrator
  59:               '[idle-orchestrator] Could not verify session parentID, assuming main session',
  68:           log('[idle-orchestrator] Started tracking idle session', {
  80:             log('[idle-orchestrator] Sending proactive prompt', {
  93:           log('[idle-orchestrator] Session busy, stopping idle tracking', {
  126:     log('[idle-orchestrator] Proactive prompt sent successfully');
  129:     log('[idle-orchestrator] Failed to send proactive prompt', { error: msg });
  133: export type { IdleOrchestratorConfig };

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\backups\oh-my-opencode-theseus.json.2026-02-14T11-03-02-257Z.bak:
  3:     "orchestrator": {
  167:   "fallback": {
  172:       "orchestrator": "openai/gpt-5.2",
  180:   "idleOrchestrator": {

C:\Users\paulc\.config\opencode\dev\src\skills\cartography\codemap.md:
  9: - `SKILL.md`: the authoritative workflow steps and guardrails the Orchestrator follows.
  18: 1. Orchestrator checks `.slim/cartography.json`.
  22: 5. Orchestrator runs `cartographer.py update` to snapshot the new hashes.
  26: - Used by the Orchestrator to keep the repository's `codemap.md` documentation accurate and directory-scoped.
  27: - The helper script is executed via Orchestrator `bash`; subagents (Explorer/Librarian) may contribute content but the Orchestrator owns correctness gates.

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\backups\oh-my-opencode-theseus.json.2026-02-14T10-54-07-264Z.bak:
  3:     "orchestrator": {
  167:   "fallback": {
  172:       "orchestrator": "openai/gpt-5.2",
  180:   "idleOrchestrator": {

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\backups\oh-my-opencode-theseus.json.2026-02-14T11-00-05-733Z.bak:
  3:     "orchestrator": {
  167:   "fallback": {
  172:       "orchestrator": "openai/gpt-5.2",
  180:   "idleOrchestrator": {

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\guard.js:
  46:   "Orchestrator",
  56:   "orchestrator",

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\next-interview.js:
  32: function asNumber(value, fallback = 0) {
  34:   return Number.isFinite(n) ? n : fallback;

C:\Users\paulc\.config\opencode\dev\src\hooks\idle-orchestrator\codemap.md:
  1: # src/hooks/idle-orchestrator/
  5: Proactively prompts the Orchestrator when a main session becomes idle, so background task results can flush (via `client.session.promptAsync`) and the orchestrator can propose next work.
  9: - Exposes `createIdleOrchestratorHook(ctx, options)`.
  12:   - respects `IdleOrchestratorConfig.enabled`.
  30: - Options type comes from config schema (`IdleOrchestratorConfig`).

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\openai_budget_policy.json:
  26:     "orchestrator": 0.9,

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\openai-budget.js:
  10:  * No OpenAI usage API fallback.
  26: function loadOptionalJson(filePath, fallback) {
  27:   if (!fs.existsSync(filePath)) return fallback;

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\optimize.js:
  43:   orchestrator: "Orchestrator",
  64: function loadOptionalJson(filePath, fallback) {
  65:   if (!fs.existsSync(filePath)) return fallback;
  434:   const fallback = {
  442:   for (const stage of Object.keys(fallback)) {
  444:       max_input_per_1m_usd: Number(policyCaps?.[stage]?.max_input_per_1m_usd ?? fallback[stage].max_input_per_1m_usd),
  445:       max_output_per_1m_usd: Number(policyCaps?.[stage]?.max_output_per_1m_usd ?? fallback[stage].max_output_per_1m_usd),
  691:       if (theseus?.fallback?.currentModels) {
  692:         theseus.fallback.currentModels[agentKey] = result.chain[0];

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\model_benchmarks.json:
  29:         "Orchestrator": 2.7731,
  63:         "Orchestrator": 2.4469,
  97:         "Orchestrator": 3.7769,
  131:         "Orchestrator": 394.6321,
  165:         "Orchestrator": 2.85765,
  199:         "Orchestrator": 444.22959999999995,
  233:         "Orchestrator": 395.47264999999993,
  267:         "Orchestrator": 4.3111500000000005,
  301:         "Orchestrator": 1.17,
  335:         "Orchestrator": 430.53375,
  369:         "Orchestrator": 395.6090000000001,
  403:         "Orchestrator": 395.20035,
  437:         "Orchestrator": 393.9601,
  471:         "Orchestrator": 396.18829999999997,
  505:         "Orchestrator": 1.7238,
  539:         "Orchestrator": 1.7103,
  573:         "Orchestrator": 1.37705,
  607:         "Orchestrator": 1.264,
  641:         "Orchestrator": 1.6549500000000001,
  675:         "Orchestrator": 2.16785,
  709:         "Orchestrator": 0.6055,
  743:         "Orchestrator": 364.8643,
  777:         "Orchestrator": 0.7982,
  811:         "Orchestrator": 365.649,
  845:         "Orchestrator": 1.1049,
  879:         "Orchestrator": 0.9203000000000001,
  913:         "Orchestrator": 1.26415,
  947:         "Orchestrator": 339.63064999999995,
  981:         "Orchestrator": 2.5326,
  1015:         "Orchestrator": 0.80925,
  1049:         "Orchestrator": 285.57525,
  1083:         "Orchestrator": 0.648,
  1117:         "Orchestrator": 340.8505,
  1151:         "Orchestrator": 2.2827,
  1185:         "Orchestrator": 353.54470000000003,
  1219:         "Orchestrator": 425.45395,
  1253:         "Orchestrator": 399.81895,
  1287:         "Orchestrator": 429.54615,
  1321:         "Orchestrator": 354.18455,
  1355:         "Orchestrator": 400.4521000000001,
  1389:         "Orchestrator": 487.45095,
  1423:         "Orchestrator": 478.65969999999993,
  1457:         "Orchestrator": 1.72075,
  1491:         "Orchestrator": 2.51515,
  1525:         "Orchestrator": 1.7829,
  1559:         "Orchestrator": 1.8935500000000003,
  1593:         "Orchestrator": 2.60595,
  1627:         "Orchestrator": 3.0865500000000003,
  1661:         "Orchestrator": 2.4303500000000002,
  1695:         "Orchestrator": 1.3353,
  1729:         "Orchestrator": 2.1522000000000006,
  1763:         "Orchestrator": 2.2083000000000004,
  1797:         "Orchestrator": 1.8629500000000003,
  1831:         "Orchestrator": 362.3095,
  1865:         "Orchestrator": 3.0858500000000006,
  1899:         "Orchestrator": 362.13814999999994,
  1933:         "Orchestrator": 363.13895,
  1967:         "Orchestrator": 1.9030999999999998,
  2001:         "Orchestrator": 0.0,
  2035:         "Orchestrator": 1.2000000000000002,
  2069:         "Orchestrator": 1.9303500000000002,
  2103:         "Orchestrator": 0.0,
  2137:         "Orchestrator": 4.32105,
  2171:         "Orchestrator": 3.27215,
  2205:         "Orchestrator": 3.64165,
  2239:         "Orchestrator": 4.60075,
  2273:         "Orchestrator": 2.7072999999999996,
  2307:         "Orchestrator": 1.23935,
  2341:         "Orchestrator": 3.414,
  2375:         "Orchestrator": 3.24305,
  2409:         "Orchestrator": 4.052700000000001,
  2443:         "Orchestrator": 2.8415,
  2477:         "Orchestrator": 2.6826,
  2511:         "Orchestrator": 3.6734999999999998,
  2545:         "Orchestrator": 2.7399999999999998,
  2579:         "Orchestrator": 2.20635,
  2613:         "Orchestrator": 2.1448,
  2647:         "Orchestrator": 1.9852,
  2681:         "Orchestrator": 1.30735,
  2715:         "Orchestrator": 1.2658,
  2749:         "Orchestrator": 1.13575,
  2783:         "Orchestrator": 0.9417000000000001,
  2817:         "Orchestrator": 0.8745,
  2851:         "Orchestrator": 0.9601,
  2885:         "Orchestrator": 0.7259499999999999,
  2919:         "Orchestrator": 0.93865,
  2953:         "Orchestrator": 2.4261500000000003,
  2987:         "Orchestrator": 1.8319000000000003,
  3021:         "Orchestrator": 1.6571500000000001,
  3055:         "Orchestrator": 4.4375,
  3089:         "Orchestrator": 368.47229999999996,
  3123:         "Orchestrator": 1.60565,
  3157:         "Orchestrator": 2.2153,
  3191:         "Orchestrator": 2.1535,
  3225:         "Orchestrator": 1.5783,
  3259:         "Orchestrator": 2.8480500000000006,
  3293:         "Orchestrator": 1.5963000000000003,
  3327:         "Orchestrator": 1.72445,
  3361:         "Orchestrator": 1.6973500000000001,
  3395:         "Orchestrator": 1.2533,
  3429:         "Orchestrator": 1.83805,
  3463:         "Orchestrator": 1.7774000000000003,
  3497:         "Orchestrator": 1.7686000000000004,
  3531:         "Orchestrator": 1.6549500000000001,
  3565:         "Orchestrator": 391.44699999999995,
  3599:         "Orchestrator": 390.42465,
  3633:         "Orchestrator": 1.6523,
  3667:         "Orchestrator": 1.7693999999999999,
  3701:         "Orchestrator": 0.12535000000000002,
  3735:         "Orchestrator": 1.0532,
  3769:         "Orchestrator": 1.2137,
  3803:         "Orchestrator": 1.75165,
  3837:         "Orchestrator": 1.3879000000000004,
  3871:         "Orchestrator": 1.0301,
  3905:         "Orchestrator": 0.9540500000000001,
  3939:         "Orchestrator": 0.64145,
  3973:         "Orchestrator": 0.95305,
  4007:         "Orchestrator": 1.3213500000000002,
  4041:         "Orchestrator": 0.76785,
  4075:         "Orchestrator": 0.8885,
  4109:         "Orchestrator": 1.20175,
  4143:         "Orchestrator": 1.6229000000000002,
  4177:         "Orchestrator": 1.9309,
  4211:         "Orchestrator": 0.86875,
  4245:         "Orchestrator": 2.2010000000000005,
  4279:         "Orchestrator": 2.0553500000000002,
  4313:         "Orchestrator": 1.2534,
  4347:         "Orchestrator": 1.0721,
  4381:         "Orchestrator": 3.66365,
  4415:         "Orchestrator": 1.44515,
  4449:         "Orchestrator": 2.00225,
  4483:         "Orchestrator": 2.6790000000000003,
  4517:         "Orchestrator": 1.0282499999999999,
  4551:         "Orchestrator": 4.40695,
  4585:         "Orchestrator": 3.4465500000000002,
  4619:         "Orchestrator": 4.508,
  4653:         "Orchestrator": 3.3359,
  4687:         "Orchestrator": 1.8272500000000003,
  4721:         "Orchestrator": 0.35040000000000004,
  4755:         "Orchestrator": 0.4,
  4789:         "Orchestrator": 4.075950000000001,
  4823:         "Orchestrator": 2.563100000000001,
  4857:         "Orchestrator": 2.3004000000000002,
  4891:         "Orchestrator": 1.73745,
  4925:         "Orchestrator": 2.4420499999999996,
  4959:         "Orchestrator": 2.7121999999999997,
  4993:         "Orchestrator": 2.2113000000000005,
  5027:         "Orchestrator": 2.7220000000000004,
  5061:         "Orchestrator": 0.38415,
  5095:         "Orchestrator": 2.755,
  5129:         "Orchestrator": 364.39795,
  5163:         "Orchestrator": 428.03065,
  5197:         "Orchestrator": 404.2634,
  5231:         "Orchestrator": 363.01619999999997,
  5265:         "Orchestrator": 362.10164999999995,
  5299:         "Orchestrator": 363.538,
  5333:         "Orchestrator": 2.69175,
  5367:         "Orchestrator": 2.6904000000000003,
  5401:         "Orchestrator": 2.00855,
  5435:         "Orchestrator": 1.6221500000000002,
  5469:         "Orchestrator": 3.18805,
  5503:         "Orchestrator": 0.9123000000000001,
  5537:         "Orchestrator": 1.27755,
  5571:         "Orchestrator": 1.1608500000000002,
  5605:         "Orchestrator": 2.8061500000000006,
  5639:         "Orchestrator": 2.425,
  5673:         "Orchestrator": 351.8494,
  5707:         "Orchestrator": 2.8472500000000003,
  5741:         "Orchestrator": 3.16865,
  5775:         "Orchestrator": 3.0897000000000006,
  5809:         "Orchestrator": 0.7400000000000001,
  5843:         "Orchestrator": 2.2926499999999996,
  5877:         "Orchestrator": 1.7642000000000002,
  5911:         "Orchestrator": 3.0579500000000004,
  5945:         "Orchestrator": 3.36445,
  5979:         "Orchestrator": 2.3126,
  6013:         "Orchestrator": 1.01305,
  6047:         "Orchestrator": 1.9104,
  6081:         "Orchestrator": 1.6010499999999999,
  6115:         "Orchestrator": 1.36595,
  6149:         "Orchestrator": 1.9705000000000001,
  6183:         "Orchestrator": 1.92225,
  6217:         "Orchestrator": 2.3616,
  6251:         "Orchestrator": 0.8514999999999999,
  6285:         "Orchestrator": 0.6882999999999999,
  6319:         "Orchestrator": 1.8082,
  6353:         "Orchestrator": 1.69595,
  6387:         "Orchestrator": 0.7959000000000002,
  6421:         "Orchestrator": 2.06085,
  6455:         "Orchestrator": 2.20495,
  6489:         "Orchestrator": 2.854,
  6523:         "Orchestrator": 2.6062999999999996,
  6557:         "Orchestrator": 1.1904000000000001,
  6591:         "Orchestrator": 352.63185,
  6625:         "Orchestrator": 351.99309999999997,
  6659:         "Orchestrator": 1.1516500000000003,
  6693:         "Orchestrator": 2.6189,
  6727:         "Orchestrator": 1.7289000000000003,
  6761:         "Orchestrator": 2.2520000000000002,
  6795:         "Orchestrator": 1.8703500000000002,
  6829:         "Orchestrator": 3.7662,
  6863:         "Orchestrator": 0.0,
  6897:         "Orchestrator": 3.5136000000000003,
  6931:         "Orchestrator": 2.37,
  6965:         "Orchestrator": 2.2719,
  6999:         "Orchestrator": 2.0671000000000004,
  7033:         "Orchestrator": 1.8162,
  7067:         "Orchestrator": 1.4741000000000002,
  7101:         "Orchestrator": 2.02735,
  7135:         "Orchestrator": 1.4889000000000001,
  7169:         "Orchestrator": 1.0287,
  7203:         "Orchestrator": 251.9257,
  7237:         "Orchestrator": 251.6003,
  7271:         "Orchestrator": 393.32394999999997,
  7305:         "Orchestrator": 395.8558999999999,
  7339:         "Orchestrator": 393.66089999999997,
  7373:         "Orchestrator": 393.4077,
  7407:         "Orchestrator": 394.00005,
  7441:         "Orchestrator": 395.2747,
  7475:         "Orchestrator": 4.239,
  7509:         "Orchestrator": 0.0,
  7543:         "Orchestrator": 395.57085,
  7577:         "Orchestrator": 395.24269999999996,
  7611:         "Orchestrator": 392.5134499999999,
  7645:         "Orchestrator": 250.55624999999998,
  7679:         "Orchestrator": 245.31684999999993,
  7713:         "Orchestrator": 395.84509999999995,
  7747:         "Orchestrator": 2.1114500000000005,
  7781:         "Orchestrator": 0.0,
  7815:         "Orchestrator": 245.28694999999996,
  7849:         "Orchestrator": 3.7402500000000005,
  7883:         "Orchestrator": 1.2800000000000002,
  7917:         "Orchestrator": 396.15635,
  7951:         "Orchestrator": 1.6281500000000002,
  7985:         "Orchestrator": 2.0,
  8019:         "Orchestrator": 393.84905,
  8053:         "Orchestrator": 2.58,
  8087:         "Orchestrator": 0.0,
  8121:         "Orchestrator": 1.4700000000000002,
  8155:         "Orchestrator": 1.3524999999999998,
  8189:         "Orchestrator": 1.13345,
  8223:         "Orchestrator": 1.23755,
  8257:         "Orchestrator": 1.02685,
  8291:         "Orchestrator": 1.0257,
  8325:         "Orchestrator": 0.8263,
  8359:         "Orchestrator": 0.6251,
  8393:         "Orchestrator": 0.47000000000000003,
  8427:         "Orchestrator": 2.0551500000000003,
  8461:         "Orchestrator": 1.9245,
  8495:         "Orchestrator": 1.8303,
  8529:         "Orchestrator": 1.5584000000000002,
  8563:         "Orchestrator": 2.18125,
  8597:         "Orchestrator": 1.5746000000000002,
  8631:         "Orchestrator": 1.26715,
  8665:         "Orchestrator": 284.93994999999995,
  8699:         "Orchestrator": 2.0162500000000003,
  8733:         "Orchestrator": 3.06985,
  8767:         "Orchestrator": 2.6896,
  8801:         "Orchestrator": 285.0258999999999,
  8835:         "Orchestrator": 1.51965,
  8869:         "Orchestrator": 1.6856,
  8903:         "Orchestrator": 0.86,
  8937:         "Orchestrator": 1.2009,
  8971:         "Orchestrator": 1.01,
  9005:         "Orchestrator": 0.9700500000000001,
  9039:         "Orchestrator": 1.3727500000000001,
  9073:         "Orchestrator": 2.3813500000000003,
  9107:         "Orchestrator": 3.5189500000000002,
  9141:         "Orchestrator": 2.92225,
  9175:         "Orchestrator": 2.2199,
  9209:         "Orchestrator": 1.13805,
  9243:         "Orchestrator": 2.0721000000000003,
  9277:         "Orchestrator": 1.2300000000000002,
  9311:         "Orchestrator": 1.8256000000000001,
  9345:         "Orchestrator": 1.64465,
  9379:         "Orchestrator": 1.4522,
  9413:         "Orchestrator": 236.7355,
  9447:         "Orchestrator": 1.19685,
  9481:         "Orchestrator": 0.9300000000000002,
  9515:         "Orchestrator": 0.8711000000000001,
  9549:         "Orchestrator": 2.5541500000000004,
  9583:         "Orchestrator": 325.76709999999997,
  9617:         "Orchestrator": 2.3600000000000003,
  9651:         "Orchestrator": 351.98834999999997,
  9685:         "Orchestrator": 351.38255,
  9719:         "Orchestrator": 3.1812000000000005,
  9753:         "Orchestrator": 3.6383,
  9787:         "Orchestrator": 325.34764999999993,
  9821:         "Orchestrator": 1.0517,
  9855:         "Orchestrator": 1.0680500000000002,
  9889:         "Orchestrator": 1.7892499999999998,
  9923:         "Orchestrator": 1.5772499999999998,
  9957:         "Orchestrator": 1.6944000000000001,
  9991:         "Orchestrator": 1.5194,
  10025:         "Orchestrator": 1.17555,
  10059:         "Orchestrator": 1.1269500000000001,
  10093:         "Orchestrator": 1.02325,
  10127:         "Orchestrator": 1.13745,
  10161:         "Orchestrator": 0.88645,
  10195:         "Orchestrator": 0.8420000000000002,
  10229:         "Orchestrator": 1.6596000000000002,
  10263:         "Orchestrator": 1.04345,
  10297:         "Orchestrator": 2.18285,
  10331:         "Orchestrator": 1.7764,
  10365:         "Orchestrator": 2.1795,
  10399:         "Orchestrator": 2.12935,
  10433:         "Orchestrator": 2.0669999999999997,
  10467:         "Orchestrator": 1.38645,
  10501:         "Orchestrator": 1.9839,
  10535:         "Orchestrator": 1.9882000000000002,
  10569:         "Orchestrator": 1.9391999999999998,
  10603:         "Orchestrator": 1.82095,
  10637:         "Orchestrator": 1.25,
  10671:         "Orchestrator": 1.06,
  10705:         "Orchestrator": 1.37825,
  10739:         "Orchestrator": 0.8400000000000001,
  10773:         "Orchestrator": 0.9897500000000001,
  10807:         "Orchestrator": 2.54245,
  10841:         "Orchestrator": 3.1431,
  10875:         "Orchestrator": 3.1634500000000005,
  10909:         "Orchestrator": 2.2181,
  10943:         "Orchestrator": 3.78865,
  10977:         "Orchestrator": 3.2144999999999997,
  11011:         "Orchestrator": 361.70155,
  11045:         "Orchestrator": 362.19195,
  11079:         "Orchestrator": 0.91,
  11113:         "Orchestrator": 0.9781500000000001,
  11147:         "Orchestrator": 1.2300000000000002,
  11181:         "Orchestrator": 2.4600000000000004,
  11215:         "Orchestrator": 1.74755,
  11249:         "Orchestrator": 1.9146,
  11283:         "Orchestrator": 1.74885,
  11317:         "Orchestrator": 1.5296500000000002,
  11351:         "Orchestrator": 2.8775999999999997,
  11385:         "Orchestrator": 1.5983500000000002,
  11419:         "Orchestrator": 2.6109500000000003,
  11453:         "Orchestrator": 3.92845,
  11487:         "Orchestrator": 2.16,
  11521:         "Orchestrator": 0.9225000000000001,
  11555:         "Orchestrator": 1.6246,
  11589:         "Orchestrator": 1.4837500000000003,
  11623:         "Orchestrator": 1.1749,
  11657:         "Orchestrator": 1.00915,
  11691:         "Orchestrator": 0.7697500000000002,
  11725:         "Orchestrator": 0.8202,
  11759:         "Orchestrator": 2.1108000000000002,
  11793:         "Orchestrator": 1.8175500000000002,
  11827:         "Orchestrator": 0.9557500000000001,
  11861:         "Orchestrator": 2.7887,
  11895:         "Orchestrator": 4.07365,
  11929:         "Orchestrator": 2.441,
  11963:         "Orchestrator": 309.65995,
  11997:         "Orchestrator": 308.12015,
  12031:         "Orchestrator": 308.59219999999993,
  12065:         "Orchestrator": 1.6206,
  12099:         "Orchestrator": 1.0665,
  12133:         "Orchestrator": 1.5095000000000003,
  12167:         "Orchestrator": 1.2594,
  12201:         "Orchestrator": 1.2619,
  12235:         "Orchestrator": 1.2000000000000002,
  12269:         "Orchestrator": 1.22585,
  12303:         "Orchestrator": 3.0108,
  12337:         "Orchestrator": 3.66595,
  12371:         "Orchestrator": 1.8188,
  12405:         "Orchestrator": 3.3859500000000007,
  12439:         "Orchestrator": 1.53975,
  12473:         "Orchestrator": 0.9594,
  12507:         "Orchestrator": 0.8475000000000001,
  12541:         "Orchestrator": 3.2495000000000003,
  12575:         "Orchestrator": 1.2412,
  12609:         "Orchestrator": 0.90505,
  12643:         "Orchestrator": 0.91605,
  12677:         "Orchestrator": 1.22215,
  12711:         "Orchestrator": 0.8800000000000001,
  12745:         "Orchestrator": 1.8617000000000001,
  12779:         "Orchestrator": 1.85605,
  12813:         "Orchestrator": 1.46865,
  12847:         "Orchestrator": 1.3769500000000001,
  12881:         "Orchestrator": 1.3375,
  12915:         "Orchestrator": 2.3262500000000004,
  12949:         "Orchestrator": 1.9875500000000004,
  12983:         "Orchestrator": 1.858,
  13017:         "Orchestrator": 1.7133000000000003,
  13051:         "Orchestrator": 2.009,
  13085:         "Orchestrator": 1.5332999999999999,
  13119:         "Orchestrator": 1.5195500000000002,
  13153:         "Orchestrator": 1.0078,
  13187:         "Orchestrator": 1.69655,
  13221:         "Orchestrator": 1.3146499999999999,
  13255:         "Orchestrator": 1.6173,
  13289:         "Orchestrator": 1.13875,
  13323:         "Orchestrator": 1.4175,
  13357:         "Orchestrator": 351.2732,
  13391:         "Orchestrator": 2.2613999999999996,
  13425:         "Orchestrator": 1.7286000000000001,
  13459:         "Orchestrator": 0.8800000000000001,
  13493:         "Orchestrator": 1.95215,
  13527:         "Orchestrator": 1.51775,
  13561:         "Orchestrator": 2.8797,
  13574:       "Orchestrator": {

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\research-benchmarks.js:
  360:       // Keep Authorization fallback for compatibility.

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\status.js:
  38:   for (const agent of ["orchestrator", "oracle", "designer", "explorer", "librarian", "fixer"]) {

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\SKILL.md:
  33: `free/openrouter/free` is a reserved bridge model: keep it directly before the local fallback model (`lmstudio-local/*`) and exclude it from benchmark-research decisions.
  92:   - Updates both `agents.*.model` and `fallback.currentModels.*`
  100:     - chain tail is reserved bridge + local fallback: `free/openrouter/free`, then `lmstudio-local/*`

C:\Users\paulc\.config\opencode\dev\src\hooks\directory-codemap-injector\constants.ts:
  21:   fallback: 'truncated' as const,

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\proposals\theseus-update.2026-02-15T12-19-38-920Z.json:
  5:     "orchestrator": {
  319:     "orchestrator": {

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\issue-1501-analysis.md:
  68: If you received a detailed prompt with gathered context from a parent orchestrator (e.g., Sisyphus):
  275:    - Fallback plan 생성

C:\Users\paulc\.config\opencode\dev\src\hooks\directory-codemap-injector\codemap.md:
  28:   - otherwise summarize (LM Studio or truncation fallback),

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\reports\optimize.2026-02-15T11-55-55-959Z.json:
  37:     "orchestrator": {

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\reports\optimize.2026-02-15T11-55-19-396Z.json:
  37:     "orchestrator": {

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\reports\optimize.2026-02-14T22-58-10-713Z.json:
  26:     "orchestrator": {

C:\Users\paulc\.config\opencode\dev\src\hooks\context-compressor\index.ts:
  55:     // Invalid model errors should trigger fallback
  60:     // Generic unknown errors should trigger fallback
  63:     // Auth and key errors should trigger fallback
  76:     // Agent-specific errors that should trigger fallback

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\proposals\theseus-update.2026-02-15T11-55-55-960Z.json:
  5:     "orchestrator": {
  319:     "orchestrator": {

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\reports\optimize.2026-02-14T16-09-57-205Z.json:
  26:     "orchestrator": {

C:\Users\paulc\.config\opencode\dev\src\hooks\context-compressor\codemap.md:
  15: - Exports `detectProviderError(errorMessage)` which classifies error strings that should trigger model fallback/retry logic.

C:\Users\paulc\.config\opencode\dev\src\tools\grep\codemap.md:
  7: Serve as the authoritative implementation of the fast content-search tool. It discovers which binary to run (`rg` vs fallback `grep`), enforces safety defaults (timeouts, max files/size/depth), parses the child-process output, formats readable responses, and exposes the ready-to-use tool definition consumed by the CLI/plugin layer.

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\reports\optimize.2026-02-14T16-05-27-793Z.json:
  26:     "orchestrator": {

C:\Users\paulc\.config\opencode\dev\src\hooks\codemap.md:
  3: This directory exposes the public hook entry points that feature code imports to tap into behavior such as update checks, phase reminders, post-read nudges, and idle orchestrator.
  14: 4. **IdleOrchestrator** - Proactively prompts the Orchestrator when idle to flush background task results
  18: - **Aggregator/re-export pattern**: `index.ts` consolidates factories (`createAutoUpdateCheckerHook`, `createPhaseReminderHook`, `createPostReadNudgeHook`, `createIdleOrchestratorHook`) and shared types so the rest of the app depends only on this flat namespace.
  24: ### IdleOrchestrator Hook
  25: Keeps the Orchestrator "busy" so background task results can auto-flush via `client.session.promptAsync()`.
  27: **Configuration** (`IdleOrchestratorConfig`):
  35: 3. Prompt asks Orchestrator to check for background task results
  42: Callers import a factory from `src/hooks`, supply any typed options (e.g., `IdleOrchestratorOptions`), and the factory wires together the hook's internal checks/side-effects before returning the hook interface that the feature layer consumes.
  44: Event flow for IdleOrchestrator:
  59: - Option types such as `AutoUpdateCheckerOptions` and `IdleOrchestratorConfig` are shared from this file so both the hook creator and its consumers agree on the configuration contract.

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\utils\tmux.ts:
  17:  * This is needed because ctx.serverUrl may return a fallback URL even when no server is running.
  212:   // This is needed because serverUrl may be a fallback even when no server is running

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\AGENTS.md:
  163: | Orchestrator | `src/hooks/atlas/` | Main orchestration hook (1976 lines) |
  219: | Sisyphus | anthropic/claude-opus-4-6 | 0.1 | Primary orchestrator (fallback: kimi-k2.5 → glm-4.7 → gpt-5.3-codex → gemini-3-pro) |
  220: | Hephaestus | openai/gpt-5.3-codex | 0.1 | Autonomous deep worker (NO fallback) |
  221: | Atlas | anthropic/claude-sonnet-4-5 | 0.1 | Master orchestrator (fallback: kimi-k2.5 → gpt-5.2) |
  222: | Prometheus | anthropic/claude-opus-4-6 | 0.1 | Strategic planning (fallback: kimi-k2.5 → gpt-5.2) |
  223: | oracle | openai/gpt-5.2 | 0.1 | Consultation, debugging (fallback: claude-opus-4-6) |
  224: | librarian | zai-coding-plan/glm-4.7 | 0.1 | Docs, GitHub search (fallback: glm-4.7-free) |
  225: | explore | xai/grok-code-fast-1 | 0.1 | Fast codebase grep (fallback: claude-haiku-4-5 → gpt-5-mini → gpt-5-nano) |
  227: | Metis | anthropic/claude-opus-4-6 | 0.3 | Pre-planning analysis (fallback: kimi-k2.5 → gpt-5.2) |
  228: | Momus | openai/gpt-5.2 | 0.1 | Plan validation (fallback: claude-opus-4-6) |

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\ultrawork-manifesto.md:
  156: | Orchestrator | Coordinate work without human micromanagement |

C:\Users\paulc\.config\opencode\dev\src\tools\codemap.md:
  7: 1. **Grep** - Fast regex-based content search using ripgrep (with fallback to system grep)
  63: - **constants.ts**: CLI path resolution with fallback chain
  81: - Graceful degradation (ripgrep → grep fallback)
  103:     └─→ System grep (fallback)
  301: - **Fallback**: System grep if ripgrep unavailable
  307: - **Fallback**: Manual installation instructions
  315: 4. Graceful degradation (fallback tools)

C:\Users\paulc\.config\opencode\dev\src\hooks\changelog-cartography\index.ts:
  123:     // If we cannot verify, assume it's main (consistent with idle-orchestrator).
  181:       log('[changelog-cartography] prompted orchestrator to run cartography', {
  187:       log('[changelog-cartography] failed to prompt orchestrator', {

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

C:\Users\paulc\.config\opencode\dev\src\hooks\changelog-cartography\codemap.md:
  5: Tracks successful file modifications made through write/edit/apply_patch and prompts the main Orchestrator session to re-run cartography when the session becomes idle. This keeps `codemap.md` documentation in sync with recently changed code.

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\utils\codemap.md:
  11: Each helper lives in its own module and re-exports through `src/utils/index.ts`, keeping public surface area flat. Key ideas include memoized state (cached TMUX path, server availability cache, stored layouts), configuration defaults fed from `../config` constants, defensive guards (abort checks, empty-string variants), and layered platform detection (Windows build/tar, PowerShell fallbacks). Logging is best-effort: synchronous file append inside a try/catch so it never throws upstream.
  15: Agent variant helpers normalize names, read `PluginConfig.agents`, trim/validate variants, and only mutate request bodies when a variant is missing; `log` simply timestamps and appends strings to a temp file. `pollUntilStable` loops with configurable intervals, fetch callbacks, and stability guards, honoring max time and abort signals before returning a typed `PollResult`. TMUX helpers scan for the binary (`which/where`), cache the result, verify layouts, spawn panes with `opencode attach`, reapply stored layouts on close, and guard against missing servers by checking `/health`. `extractZip` detects the OS (tar on modern Windows, pwsh/powershell fallback) before spawning native unpack commands and bubbling errors when processes fail.

C:\Users\paulc\.config\opencode\dev\ref\codemap.md:
  48: - 6 specialized agents (Orchestrator, Explorer, Librarian, Oracle, Designer, Fixer)
  49: - Background task management with model fallback
  122: | Agent Count | 6+ specialized | 6 (Orchestrator + 5 subagents) |
  123: | Background Tasks | Full tmux integration | Model fallback, compaction |

C:\Users\paulc\.config\opencode\dev\skills\update-agent-models\proposals\theseus-update.2026-02-15T11-55-19-397Z.json:
  5:     "orchestrator": {
  319:     "orchestrator": {

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\orchestration-guide.md:
  34: 2. **Atlas (Executor)**: An orchestrator who executes plans. Delegates work to specialized agents and never stops until completion.
  265:         BoulderState --> Atlas[Atlas<br>Orchestrator]

C:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\guide\understanding-orchestration-system.md:
  31:     subgraph Execution["Execution Layer (Orchestrator)"]
  32:         Orchestrator["⚡ Atlas<br/>(Conductor)<br/>Claude Opus 4.5"]
  50:     User -->|"/start-work"| Orchestrator
  51:     Plan -->|"Read"| Orchestrator
  53:     Orchestrator -->|"task(category)"| Junior
  54:     Orchestrator -->|"task(agent)"| Oracle
  55:     Orchestrator -->|"task(agent)"| Explore
  56:     Orchestrator -->|"task(agent)"| Librarian
  57:     Orchestrator -->|"task(agent)"| Frontend
  59:     Junior -->|"Results + Learnings"| Orchestrator
  60:     Oracle -->|"Advice"| Orchestrator
  61:     Explore -->|"Code patterns"| Orchestrator
  62:     Librarian -->|"Documentation"| Orchestrator
  63:     Frontend -->|"UI code"| Orchestrator
  159: The Orchestrator is like an orchestra conductor: **it doesn't play instruments, it ensures perfect harmony**.
  163:     subgraph Orchestrator["Atlas"]
  183: **What Orchestrator CAN do:**
  189: **What Orchestrator MUST delegate:**
  221: // Orchestrator identifies parallelizable groups from plan
  245: 1. Detailed prompts from Orchestrator (50-200 lines)
 

... (truncated)
```
