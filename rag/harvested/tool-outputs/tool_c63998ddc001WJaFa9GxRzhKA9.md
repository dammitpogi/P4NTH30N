# Tool Output: tool_c63998ddc001WJaFa9GxRzhKA9
**Date**: 2026-02-15 23:18:53 UTC
**Size**: 209,009 bytes

```

c:\Users\paulc\.config\opencode\dev\AGENTS.md:
  176: - **Impact**: Enables the fallback mechanism to work correctly when agent permission is denied. Previously, the returned string was being treated as a success response, bypassing fallback logic.
  232: - If compaction fails, the system proceeds to model fallback
  236: - Compaction and retry logic (lines 524-540)
  246: ### Model Fallback Chains
  247: Configure automatic model fallback when primary models fail due to provider errors.
  267: - **Provider errors** (rate limits, context length, service unavailable) trigger fallback
  268: - **Validation errors** fail immediately without fallback
  269: - Each agent type has its own fallback chain
  280: 5. **On retry** → picks next available model from chain and updates current model tracking
  287:   - `retryWithNextModel()` - Uses current model tracking instead of faulty fallbackInfo lookup
  289: **Tracked Metrics** (in `agents.<agent>.currentModel` and `fallback.triage`):
  296: Previously, the system relied on `fallbackInfo` lookups which could become stale or incorrect during retries. The new current model tracking ensures:
  299: - Proper fallback chain progression on retries
  383: - **Path Resolution**: Config loader uses `os.homedir()` for cross-platform path resolution, ensuring fallback chains and presets from `~/.config/opencode/oh-my-opencode-theseus.json` are loaded correctly on all platforms (including Windows)

c:\Users\paulc\.config\opencode\dev\CHANGELOG.md:
  7: - **Connectivity Error Detection**: Updated `background-manager.ts` to recognize "typo in the url or port" and "unable to connect" as retryable provider errors.
  8: - **Model Fallback**: Corrected hardcoded default model IDs and cleared stale triage state to ensure reliable agent communication.

c:\Users\paulc\.config\opencode\dev\codemap.md:
  11: - **Model management** - Comprehensive model research and per-agent model assignments with fallback chains
  30: - Agent model fallback chains provide resilience and cost optimization
  76: 2. On failure/timeout → fallback chain traversed automatically
  77: 3. Fallback triage tracked (`oh-my-opencode-theseus.json` → `fallback.triage`)
  136: - `plugin/src/background/` - Background task execution with fallback chains

c:\Users\paulc\.config\opencode\dev\ref\codemap.md:
  49: - Background task management with model fallback
  123: | Background Tasks | Full tmux integration | Model fallback, compaction |

c:\Users\paulc\.config\opencode\dev\skills\model-tester\SKILL.md:
  62: | 429 | Rate limited | Retry later |
  68: Read `oh-my-opencode-theseus.json`, find the `fallback.triage` section, and add failed models:

c:\Users\paulc\.config\opencode\dev\skills\openai-usage\SKILL.md:
  23: - No manual fallback. If Codex rate limits are unavailable, return an actionable error.

c:\Users\paulc\.config\opencode\dev\src\agents\codemap.md:
  41: - Fallback mechanism: Fixer inherits Librarian's model if not configured
  71:   │   ├─→ Get model (with fallback for fixer)
  232: 5. **Fallback Model**: Fixer inherits Librarian's model for backward compatibility

c:\Users\paulc\.config\opencode\dev\src\agents\index.test.ts:
  71: describe('fixer agent fallback', () => {

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\AGENTS.md:
  219: | Sisyphus | anthropic/claude-opus-4-6 | 0.1 | Primary orchestrator (fallback: kimi-k2.5 → glm-4.7 → gpt-5.3-codex → gemini-3-pro) |
  220: | Hephaestus | openai/gpt-5.3-codex | 0.1 | Autonomous deep worker (NO fallback) |
  221: | Atlas | anthropic/claude-sonnet-4-5 | 0.1 | Master orchestrator (fallback: kimi-k2.5 → gpt-5.2) |
  222: | Prometheus | anthropic/claude-opus-4-6 | 0.1 | Strategic planning (fallback: kimi-k2.5 → gpt-5.2) |
  223: | oracle | openai/gpt-5.2 | 0.1 | Consultation, debugging (fallback: claude-opus-4-6) |
  224: | librarian | zai-coding-plan/glm-4.7 | 0.1 | Docs, GitHub search (fallback: glm-4.7-free) |
  225: | explore | xai/grok-code-fast-1 | 0.1 | Fast codebase grep (fallback: claude-haiku-4-5 → gpt-5-mini → gpt-5-nano) |
  227: | Metis | anthropic/claude-opus-4-6 | 0.3 | Pre-planning analysis (fallback: kimi-k2.5 → gpt-5.2) |
  228: | Momus | openai/gpt-5.2 | 0.1 | Plan validation (fallback: claude-opus-4-6) |

c:\Users\paulc\.config\opencode\dev\skills\update-agent-models\backups\oh-my-opencode-theseus.json.2026-02-14T10-54-07-264Z.bak:
  167:   "fallback": {

c:\Users\paulc\.config\opencode\dev\skills\update-agent-models\backups\oh-my-opencode-theseus.json.2026-02-14T11-00-05-733Z.bak:
  167:   "fallback": {

c:\Users\paulc\.config\opencode\dev\skills\update-agent-models\backups\oh-my-opencode-theseus.json.2026-02-14T11-03-02-257Z.bak:
  167:   "fallback": {

c:\Users\paulc\.config\opencode\dev\skills\update-agent-models\benchmarks.json:
  276:       "note": "Fastest local - ultimate fallback"
  389:       "notes": "Mixed quality - fallback only"
  395:       "notes": "Local - ultimate fallback when all APIs fail",

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\issue-1501-analysis.md:
  275:    - Fallback plan 생성

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\assets\oh-my-opencode.schema.json:
  90:           "delegate-task-retry",

c:\Users\paulc\.config\opencode\dev\src\utils\tmux.ts:
  17:  * This is needed because ctx.serverUrl may return a fallback URL even when no server is running.
  212:   // This is needed because serverUrl may be a fallback even when no server is running

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\bun.lock:
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

c:\Users\paulc\.config\opencode\dev\skills\update-agent-models\SKILL.md:
  33: `free/openrouter/free` is a reserved bridge model: keep it directly before the local fallback model (`lmstudio-local/*`) and exclude it from benchmark-research decisions.
  92:   - Updates both `agents.*.model` and `fallback.currentModels.*`
  100:     - chain tail is reserved bridge + local fallback: `free/openrouter/free`, then `lmstudio-local/*`

c:\Users\paulc\.config\opencode\dev\src\utils\codemap.md:
  11: Each helper lives in its own module and re-exports through `src/utils/index.ts`, keeping public surface area flat. Key ideas include memoized state (cached TMUX path, server availability cache, stored layouts), configuration defaults fed from `../config` constants, defensive guards (abort checks, empty-string variants), and layered platform detection (Windows build/tar, PowerShell fallbacks). Logging is best-effort: synchronous file append inside a try/catch so it never throws upstream.
  15: Agent variant helpers normalize names, read `PluginConfig.agents`, trim/validate variants, and only mutate request bodies when a variant is missing; `log` simply timestamps and appends strings to a temp file. `pollUntilStable` loops with configurable intervals, fetch callbacks, and stability guards, honoring max time and abort signals before returning a typed `PollResult`. TMUX helpers scan for the binary (`which/where`), cache the result, verify layouts, spawn panes with `opencode attach`, reapply stored layouts on close, and guard against missing servers by checking `/health`. `extractZip` detects the OS (tar on modern Windows, pwsh/powershell fallback) before spawning native unpack commands and bubbling errors when processes fail.

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\orchestration-guide.md:
  410: - Plans exist but boulder.json points elsewhere → Delete `.sisyphus/boulder.json` and retry

c:\Users\paulc\.config\opencode\dev\skills\update-agent-models\research-benchmarks.js:
  360:       // Keep Authorization fallback for compatibility.

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\nix\scripts\normalize-bun-binaries.ts:
  35:       const fallback = manifest.name ?? packageDir.split("/").pop()
  36:       if (fallback) {
  37:         await linkBinary(binRoot, fallback, packageDir, binField, seen)

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\guide\understanding-orchestration-system.md:
  151: If REJECTED, Prometheus fixes issues and resubmits. **No maximum retry limit.**

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\guide\overview.md:
  109: **2. At Runtime (Fallback Chain)**
  130:     // Override specific agents only - rest use fallback chain
  149: - Unspecified agents/categories use the automatic fallback chain

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\guide\installation.md:
  187: #### GitHub Copilot (Fallback Provider)
  189: GitHub Copilot is supported as a **fallback provider** when native providers are unavailable.
  202: | **Librarian** | `zai-coding-plan/glm-4.7` (if Z.ai available) or fallback |

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\features.md:
  13: | **Sisyphus** | `anthropic/claude-opus-4-6` | **The default orchestrator.** Plans, delegates, and executes complex tasks using specialized subagents with aggressive parallel execution. Todo-driven workflow with extended thinking (32k budget). Fallback: kimi-k2.5 → glm-4.7 → gpt-5.3-codex → gemini-3-pro. |
  14: | **Hephaestus** | `openai/gpt-5.3-codex` | **The Legitimate Craftsman.** Autonomous deep worker inspired by AmpCode's deep mode. Goal-oriented execution with thorough research before action. Explores codebase patterns, completes tasks end-to-end without premature stopping. Named after the Greek god of forge and craftsmanship. Requires gpt-5.3-codex (no fallback - only activates when this model is available). |
  16: | **librarian** | `zai-coding-plan/glm-4.7` | Multi-repo analysis, documentation lookup, OSS implementation examples. Deep codebase understanding with evidence-based answers. Fallback: glm-4.7-free → claude-sonnet-4-5. |
  17: | **explore** | `anthropic/claude-haiku-4-5` | Fast codebase exploration and contextual grep. Fallback: gpt-5-mini → gpt-5-nano. |
  18: | **multimodal-looker** | `google/gemini-3-flash` | Visual content specialist. Analyzes PDFs, images, diagrams to extract information. Fallback: gpt-5.2 → glm-4.6v → kimi-k2.5 → claude-haiku-4-5 → gpt-5-nano. |
  24: | **Prometheus** | `anthropic/claude-opus-4-6` | Strategic planner with interview mode. Creates detailed work plans through iterative questioning. Fallback: kimi-k2.5 → gpt-5.2 → gemini-3-pro. |
  25: | **Metis** | `anthropic/claude-opus-4-6` | Plan consultant - pre-planning analysis. Identifies hidden intentions, ambiguities, and AI failure points. Fallback: kimi-k2.5 → gpt-5.2 → gemini-3-pro. |
  26: | **Momus** | `openai/gpt-5.2` | Plan reviewer - validates plans against clarity, verifiability, and completeness standards. Fallback: gpt-5.2 → claude-opus-4-6 → gemini-3-pro. |
  377: | **delegate-task-retry** | PostToolUse | Retries failed task calls. |

c:\Users\paulc\.config\opencode\dev\src\tools\lsp\utils.ts:
  101:           `LSP server is still initializing. Please retry in a few seconds.`,

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\docs\configurations.md:
  46: | **Windows**     | `~/.config/opencode/oh-my-opencode.jsonc` (preferred) or `~/.config/opencode/oh-my-opencode.json` (fallback); `%APPDATA%\opencode\oh-my-opencode.jsonc` / `%APPDATA%\opencode\oh-my-opencode.json` (fallback) |
  47: | **macOS/Linux** | `~/.config/opencode/oh-my-opencode.jsonc` (preferred) or `~/.config/opencode/oh-my-opencode.json` (fallback)                |
  847: 2. **Step 2: Provider Fallback** — Try each provider in the requirement's priority order until one is available
  865: │   Step 2: PROVIDER PRIORITY FALLBACK                            │
  932: - Provider fallback chain
  958: When you specify a model override, it takes precedence (Step 1) and the provider fallback chain is skipped entirely.

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\install:
  333:         # Fallback to standard curl on Windows, non-TTY environments, or if custom progress fails

c:\Users\paulc\.config\opencode\dev\src\tools\lsp\codemap.md:
  12: - Utility helpers in `src/tools/lsp/utils.ts` keep formatting, severity mapping, diagnostic filtering, workspace root discovery, URI translation, and workspace-edit application consolidated; they also host `withLspClient`, which orchestrates server lookup, client acquisition/release, and retry messaging when initialization is still in progress.

c:\Users\paulc\.config\opencode\dev\skills\update-agent-models\optimize.js:
  64: function loadOptionalJson(filePath, fallback) {
  65:   if (!fs.existsSync(filePath)) return fallback;
  434:   const fallback = {
  442:   for (const stage of Object.keys(fallback)) {
  444:       max_input_per_1m_usd: Number(policyCaps?.[stage]?.max_input_per_1m_usd ?? fallback[stage].max_input_per_1m_usd),
  445:       max_output_per_1m_usd: Number(policyCaps?.[stage]?.max_output_per_1m_usd ?? fallback[stage].max_output_per_1m_usd),
  691:       if (theseus?.fallback?.currentModels) {
  692:         theseus.fallback.currentModels[agentKey] = result.chain[0];

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\utils\tmux.ts:
  17:  * This is needed because ctx.serverUrl may return a fallback URL even when no server is running.
  212:   // This is needed because serverUrl may be a fallback even when no server is running

c:\Users\paulc\.config\opencode\dev\skills\update-agent-models\openai-budget.js:
  10:  * No OpenAI usage API fallback.
  26: function loadOptionalJson(filePath, fallback) {
  27:   if (!fs.existsSync(filePath)) return fallback;

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\config\schema.ts:
  3: const FALLBACK_AGENT_NAMES = [
  31:     fallback1: ProviderModelIdSchema,
  32:     fallback2: ProviderModelIdSchema,
  33:     fallback3: ProviderModelIdSchema,
  38:       value.fallback1,
  39:       value.fallback2,
  40:       value.fallback3,
  45:         message: 'primary and fallbacks must be unique per agent',
  67: const FallbackChainsSchema = z
  78: export type FallbackAgentName = (typeof FALLBACK_AGENT_NAMES)[number];
  126: export const FailoverConfigSchema = z.object({
  129:   chains: FallbackChainsSchema.default({}),
  132: export type FailoverConfig = z.infer<typeof FailoverConfigSchema>;
  145:   fallback: FailoverConfigSchema.optional(),

c:\Users\paulc\.config\opencode\dev\skills\update-agent-models\next-interview.js:
  32: function asNumber(value, fallback = 0) {
  34:   return Number.isFinite(n) ? n : fallback;

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\config\loader.ts:
  162:       fallback: deepMerge(config.fallback, projectConfig.fallback),

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\config\loader.test.ts:
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

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\utils\codemap.md:
  11: Each helper lives in its own module and re-exports through `src/utils/index.ts`, keeping public surface area flat. Key ideas include memoized state (cached TMUX path, server availability cache, stored layouts), configuration defaults fed from `../config` constants, defensive guards (abort checks, empty-string variants), and layered platform detection (Windows build/tar, PowerShell fallbacks). Logging is best-effort: synchronous file append inside a try/catch so it never throws upstream.
  15: Agent variant helpers normalize names, read `PluginConfig.agents`, trim/validate variants, and only mutate request bodies when a variant is missing; `log` simply timestamps and appends strings to a temp file. `pollUntilStable` loops with configurable intervals, fetch callbacks, and stability guards, honoring max time and abort signals before returning a typed `PollResult`. TMUX helpers scan for the binary (`which/where`), cache the result, verify layouts, spawn panes with `opencode attach`, reapply stored layouts on close, and guard against missing servers by checking `/health`. `extractZip` detects the OS (tar on modern Windows, pwsh/powershell fallback) before spawning native unpack commands and bubbling errors when processes fail.

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\config\constants.ts:
  55: export const FALLBACK_FAILOVER_TIMEOUT_MS = 15_000;

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\agents\dynamic-agent-prompt-builder.ts:
  123: Use it as a **peer tool**, not a fallback. Fire liberally.

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\agents\utils.test.ts:
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

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\agents\types.ts:
  6:  * - "subagent": Uses own fallback chain, ignores UI selection (oracle, explore, etc.)

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\sisyphus-prompt.md:
  184: Use it as a **peer tool**, not a fallback. Fire liberally.

c:\Users\paulc\.config\opencode\dev\src\tools\grep\codemap.md:
  7: Serve as the authoritative implementation of the fast content-search tool. It discovers which binary to run (`rg` vs fallback `grep`), enforces safety defaults (timeouts, max files/size/depth), parses the child-process output, formats readable responses, and exposes the ready-to-use tool definition consumed by the CLI/plugin layer.

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\agents\index.test.ts:
  71: describe('fixer agent fallback', () => {

c:\Users\paulc\.config\opencode\dev\src\tools\codemap.md:
  7: 1. **Grep** - Fast regex-based content search using ripgrep (with fallback to system grep)
  63: - **constants.ts**: CLI path resolution with fallback chain
  81: - Graceful degradation (ripgrep → grep fallback)
  103:     └─→ System grep (fallback)
  301: - **Fallback**: System grep if ripgrep unavailable
  307: - **Fallback**: Manual installation instructions
  315: 4. Graceful degradation (fallback tools)

c:\Users\paulc\.config\opencode\dev\src\tools\background.ts:
  141:         task.fallbackInfo?.totalAttempts ?? 0,
  190:       // Add fallback information if available
  191:       if (task.fallbackInfo) {
  192:         if (task.fallbackInfo.occurred) {
  193:           output += `Fallback: Yes (tried ${task.fallbackInfo.totalAttempts} models)
  194:  Successful Model: ${task.fallbackInfo.successfulModel || 'None'}
  196:         } else if (task.fallbackInfo.totalAttempts > 0) {
  197:           output += `Fallback: No (first model succeeded)
  228:         // Append fallback notice if fallback occurred
  229:         if (task.fallbackInfo?.occurred && task.fallbackInfo.successfulModel) {
  230:           output += `\n\n[Note: Subagent ${task.agent} required model fallback, but succeeded on ${task.fallbackInfo.successfulModel}. Minor inconvenience, continuing normally.]`;
  235:         // Add fallback details if task failed during fallback
  237:           task.fallbackInfo?.totalAttempts &&
  238:           task.fallbackInfo.totalAttempts > 1
  240:           output += `\n\n[Fallback: Tried ${task.fallbackInfo.totalAttempts} models before failing]`;

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\agents\codemap.md:
  41: - Fallback mechanism: Fixer inherits Librarian's model if not configured
  72:   │   ├─→ Get model (with fallback for fixer)
  233: 5. **Fallback Model**: Fixer inherits Librarian's model for backward compatibility

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\agents\AGENTS.md:
  5: 11 AI agents with factory functions, fallback chains, and model-specific prompt variants. Each agent has metadata (category, cost, triggers) and configurable tool restrictions.
  38: ├── utils.ts                    # Agent creation, model fallback resolution (571 lines)
  45: | Agent | Model | Temp | Fallback Chain | Cost |

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\agents\builtin-agents\hephaestus-agent.ts:
  9: import { applyModelResolution, getFirstFallbackModel } from "./model-resolution"
  60:     hephaestusResolution = getFirstFallbackModel(hephaestusRequirement)

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\agents\builtin-agents\sisyphus-agent.ts:
  5: import { AGENT_MODEL_REQUIREMENTS, isAnyFallbackModelAvailable } from "../../shared"
  8: import { applyModelResolution, getFirstFallbackModel } from "./model-resolution"
  48:     isAnyFallbackModelAvailable(sisyphusRequirement.fallbackChain, availableModels)
  61:     sisyphusResolution = getFirstFallbackModel(sisyphusRequirement)

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\agents\builtin-agents\general-agents.ts:
  78:     // Apply resolved variant from model fallback chain

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\agents\builtin-agents\model-resolution.ts:
  6:   requirement?: { fallbackChain?: { providers: string[]; model: string; variant?: string }[] }
  14:     policy: { fallbackChain: requirement?.fallbackChain, systemDefaultModel },
  18: export function getFirstFallbackModel(requirement?: {
  19:   fallbackChain?: { providers: string[]; model: string; variant?: string }[]
  21:   const entry = requirement?.fallbackChain?.[0]
  25:     provenance: "provider-fallback" as const,

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\tools\lsp\utils.ts:
  101:           `LSP server is still initializing. Please retry in a few seconds.`,

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\sdks\vscode\bun.lock:
  95:     "@humanfs/node": ["@humanfs/node@0.16.6", "", { "dependencies": { "@humanfs/core": "^0.19.1", "@humanwhocodes/retry": "^0.3.0" } }, "sha512-YuI2ZHQL78Q5HbhDiBA1X4LmYdXCKCMQIfw0pw7piHJwyREFebJUvrQN4cMssyES6x+vfUbx1CIpaQUKYdQZOw=="],
  99:     "@humanwhocodes/retry": ["@humanwhocodes/retry@0.4.3", "", {}, "sha512-bV0Tgo9K4hfPCek+aMAn81RppFKv2ySDQeMoSZuvTASywNTnVJCArCZE2FWqpvIatKu7VMRLWlR1EazvVhDyhQ=="],
  229: [Omitted long matching line]
  515:     "@humanfs/node/@humanwhocodes/retry": ["@humanwhocodes/retry@0.3.1", "", {}, "sha512-JBxkERygn7Bv/GbN5Rv8Ul6LVknS+5Bp6RgDC/O8gEBU/yeH5Ui5C/OlWrTb6qct7LjjfT6Re2NxB0ln0yYybA=="],

c:\Users\paulc\.config\opencode\dev\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\tests\test_evaluator_utils.py:
  214:     def test_fallback_to_mean_for_unknown_metric(self):
  272:         task = MockEvalTask("fallback_task", agg={"acc": mean})
  275:         result = _collect_results({"fallback_task": acc}, bootstrap_iters=0)
  276:         assert result.metrics["fallback_task"]["alias"] == "fallback_task"

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\agents\atlas\default.ts:
  256: 3. Maximum 3 retry attempts with the SAME session

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\agents\librarian.ts:
  95: // Fallback options:

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\github\index.ts:
  270:   let retry = 0
  285:   } while (retry++ < 30)

c:\Users\paulc\.config\opencode\dev\src\tools\ast-grep\downloader.ts.backup:
  10: // This is only used as fallback when @ast-grep/cli package.json cannot be read

c:\Users\paulc\.config\opencode\dev\src\tools\ast-grep\downloader.ts:
  11: // This is only used as fallback when @ast-grep/cli package.json cannot be read

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\agents\prometheus\high-accuracy-mode.ts:
  49: 3. **KEEP LOOPING**: There is no maximum retry limit.

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\tools\lsp\codemap.md:
  12: - Utility helpers in `src/tools/lsp/utils.ts` keep formatting, severity mapping, diagnostic filtering, workspace root discovery, URI translation, and workspace-edit application consolidated; they also host `withLspClient`, which orchestrates server lookup, client acquisition/release, and retry messaging when initialization is still in progress.

c:\Users\paulc\.config\opencode\dev\src\tools\ast-grep\codemap.md:
  11: - **Singleton initialization with retries:** `getAstGrepPath` caches an init promise so concurrent requests share discovery/download work and fallback from local binaries to downloads (`cli.ts`).
  21: - `downloader.ts` is the fallback path: it infers the platform key, downloads the matching GitHub release, extracts `sg`, sets executable bits, and caches it under `~/.cache/oh-my-opencode-theseus/bin` (or Windows AppData) so subsequent commands reuse the binary.

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\cli\types.ts:
  63:   | 'provider-fallback-policy'
  97:   fallback1: string;
  98:   fallback2: string;
  99:   fallback3: string;

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\cli\system.ts:
  71:   // Fallback to 'opencode' and hope it's in PATH

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.no.md:
  87: 4. `$HOME/.opencode/bin` - Standard fallback

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.md:
  88: 4. `$HOME/.opencode/bin` - Default fallback

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.it.md:
  87: 4. `$HOME/.opencode/bin` – Fallback predefinito

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\cli\dynamic-model-selection.ts:
  772:       winnerLayer: 'provider-fallback-policy',
  1210:       providerFallbackPolicy: providerPolicyChain,
  1307:         winnerLayer: 'provider-fallback-policy',

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\cli\codemap.md:
  127:    - Kimi > OpenAI > Zen-free (fallback)

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.de.md:
  87: 4. `$HOME/.opencode/bin` - Standard-Fallback

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.da.md:
  87: 4. `$HOME/.opencode/bin` - Standard fallback

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.br.md:
  87: 4. `$HOME/.opencode/bin` - Fallback padrão

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\docs\quick-reference.md:
  457: 2. `oh-my-opencode-theseus.json` (fallback)

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\cli\providers.ts:
  251:         // Build fallback chain from manual config
  252:         const fallbackChain = [
  254:           manualConfig.fallback1,
  255:           manualConfig.fallback2,
  256:           manualConfig.fallback3,
  258:         chains[agentName] = fallbackChain;
  263:     config.fallback = {
  367:     config.fallback = {
  455:   const getOpenCodeFallbackForAgent = (agentName: AgentName) => {
  470:   const getChutesFallbackForAgent = (agentName: AgentName) => {
  489:   const attachFallbackConfig = (presetAgents: Record<string, unknown>) => {
  517:         getChutesFallbackForAgent(agentName),
  518:         getOpenCodeFallbackForAgent(agentName),
  527:     config.fallback = {
  577:     attachFallbackConfig(
  598:     attachFallbackConfig(

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\docs\provider-combination-matrix.md:
  37: - Fallback chains:
  57: - Fallback chains:
  77: - Fallback chains:
  97: - Fallback chains:
  117: - Fallback chains:

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\cli\providers.test.ts:
  152:   test('generateLiteConfig emits fallback chains for six agents', () => {
  169:     expect((config.fallback as any).enabled).toBe(true);
  170:     expect((config.fallback as any).timeoutMs).toBe(15000);
  171:     const chains = (config.fallback as any).chains;

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\cli\precedence-resolver.ts:
  9:   providerFallbackPolicy?: string[];
  56:       layer: 'provider-fallback-policy',
  57:       models: input.providerFallbackPolicy ?? [],

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\tools\codemap.md:
  7: 1. **Grep** - Fast regex-based content search using ripgrep (with fallback to system grep)
  63: - **constants.ts**: CLI path resolution with fallback chain
  81: - Graceful degradation (ripgrep → grep fallback)
  103:     └─→ System grep (fallback)
  295: - **Fallback**: System grep if ripgrep unavailable
  301: - **Fallback**: Manual installation instructions
  309: 4. Graceful degradation (fallback tools)

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\background\tmux-session-manager.ts:
  120:       // Start polling for fallback reliability
  181:    * Poll sessions for status updates (fallback for reliability).
  217:         // Check for timeout as a safety fallback

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\cli\precedence-resolver.test.ts:
  12:       providerFallbackPolicy: ['chutes/kimi-k2.5'],

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\docs\antigravity.md:
  61: ### Gemini CLI Models (Fallback)
  201: - **Fallback**: Gemini CLI models require separate authentication but work as fallback

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\background\codemap.md:
  107: - `pollSessions()`: Fallback polling for status updates
  231: ### Polling Fallback Flow (TmuxSessionManager)

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\tools\grep\codemap.md:
  7: Serve as the authoritative implementation of the fast content-search tool. It discovers which binary to run (`rg` vs fallback `grep`), enforces safety defaults (timeouts, max files/size/depth), parses the child-process output, formats readable responses, and exposes the ready-to-use tool definition consumed by the CLI/plugin layer.

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\cli\install.ts:
  419:   const availableForFallback1 = allModels.filter(
  423:   const fallback1 =
  424:     availableForFallback1.length > 0
  427:           availableForFallback1,
  428:           'Fallback 1 (optional, press Enter to skip)',
  432:   if (fallback1 !== primary) selectedModels.add(fallback1);
  434:   // Filter again for fallback 2
  435:   const availableForFallback2 = allModels.filter(
  439:   const fallback2 =
  440:     availableForFallback2.length > 0
  443:           availableForFallback2,
  444:           'Fallback 2 (optional, press Enter to skip)',
  446:         )) ?? fallback1)
  447:       : fallback1;
  448:   if (fallback2 !== fallback1) selectedModels.add(fallback2);
  450:   // Filter again for fallback 3
  451:   const availableForFallback3 = allModels.filter(
  455:   const fallback3 =
  456:     availableForFallback3.length > 0
  459:           availableForFallback3,
  460:           'Fallback 3 (optional, press Enter to skip)',
  462:         )) ?? fallback2)
  463:       : fallback2;
  467:     fallback1,
  468:     fallback2,
  469:     fallback3,
  668:   // Always include zen fallback
  1204:           'No Chutes models found. Continuing with fallback Chutes mapping.',
  1416:       'No providers configured. Zen Big Pickle models will be used as fallback.',

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.ru.md:
  87: 4. `$HOME/.opencode/bin` - Fallback по умолчанию

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\background\background-manager.ts:
  19:   FALLBACK_FAILOVER_TIMEOUT_MS,
  233:   private resolveFallbackChain(agentName: string): string[] {
  234:     const fallback = this.config?.fallback;
  235:     const chains = fallback?.chains as
  344:         this.config?.fallback?.timeoutMs ?? FALLBACK_FAILOVER_TIMEOUT_MS;
  345:       const fallbackEnabled = this.config?.fallback?.enabled ?? true;
  346:       const chain = fallbackEnabled
  347:         ? this.resolveFallbackChain(task.agent)
  364:               throw new Error(`Invalid fallback model format: ${model}`);
  391:         throw new Error(`All fallback models failed. ${errors.join(' | ')}`);
  547:     // Clean up session tracking maps as fallback

c:\Users\paulc\.config\opencode\dev\ref\opencode-dev\README.pl.md:
  87: 4. `$HOME/.opencode/bin` - Domyślny fallback

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\background\background-manager.test.ts:
  508:         fallback: {
  532:     test('fails task when all fallback models fail', async () => {
  545:         fallback: {
  566:       expect(task.error).toContain('All fallback models failed');

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\hooks\codemap.md:
  102: - Fallback mechanisms: Default behavior when hooks are unavailable

c:\Users\paulc\.config\opencode\dev\src\shared\codemap-utils.ts:
  50:     // Fallback: Try to extract structured information from markdown

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\tools\ast-grep\codemap.md:
  11: - **Singleton initialization with retries:** `getAstGrepPath` caches an init promise so concurrent requests share discovery/download work and fallback from local binaries to downloads (`cli.ts`).
  21: - `downloader.ts` is the fallback path: it infers the platform key, downloads the matching GitHub release, extracts `sg`, sets executable bits, and caches it under `~/.cache/oh-my-opencode-theseus/bin` (or Windows AppData) so subsequent commands reuse the binary.

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-theseus-master\src\tools\ast-grep\downloader.ts:
  10: // This is only used as fallback when @ast-grep/cli package.json cannot be read

c:\Users\paulc\.config\opencode\dev\src\cli\codemap.md:
  124:    - Kimi > OpenAI > Zen-free (fallback)

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\tools\delegate-task\unstable-agent-task.ts:
  139: - Do NOT retry automatically if you see this message - the task already succeeded

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\tools\delegate-task\tools.ts:
  152:       let modelInfo: import("../../features/task-toast-manager/types").ModelFallbackInfo | undefined

c:\Users\paulc\.config\opencode\dev\src\config\schema.ts:
  3: const FALLBACK_AGENT_NAMES = [
  12: export type FallbackAgentName = (typeof FALLBACK_AGENT_NAMES)[number];
  20:   models: z.array(z.string()).optional(), // Model fallback chain for this agent (first = default)
  57:   retryDelayMs: z.number().min(0).max(60000).optional(),
  89:   fallback: z.enum(['truncated']).default('truncated'),
  108: const FallbackChainsSchema = z
  119: export const FailoverConfigSchema = z.object({
  122:   // Backward-compat fallback chains (legacy + CLI emitted)
  123:   chains: FallbackChainsSchema.optional(),
  133:       rateLimitRetryThreshold: z.number().min(1).max(20).default(5),
  136:       contextLengthRetryLimit: z.number().min(1).max(10).default(3),
  140:       rateLimitRetryThreshold: 5,
  143:       contextLengthRetryLimit: 3,
  149:       fallbackToAlternativeModel: z.boolean().default(true),
  159:       fallbackToAlternativeModel: true,
  176: export type FailoverConfig = z.infer<typeof FailoverConfigSchema>;
  186:   fallback: FailoverConfigSchema.optional(),

c:\Users\paulc\.config\opencode\dev\src\config\loader.ts.backup:
  138:   // Also check the project directory as fallback
  175:     hasFallback: !!config?.fallback 
  183:     const mergedFallback = deepMerge(config.fallback, projectConfig.fallback);
  189:       fallback: mergedFallback,

c:\Users\paulc\.config\opencode\dev\src\index.ts:
  43:     hasFallback: !!config?.fallback,

c:\Users\paulc\.config\opencode\dev\src\config\loader.ts:
  172:   // Also check the project directory as fallback
  209:     hasFallback: !!config?.fallback 
  217:     const mergedFallback = deepMerge(config.fallback, projectConfig.fallback);
  223:       fallback: mergedFallback,

c:\Users\paulc\.config\opencode\dev\src\background\tmux-session-manager.ts:
  120:       // Start polling for fallback reliability
  163:    * Poll sessions for status updates (fallback for reliability).
  199:         // Check for timeout as a safety fallback

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\tools\delegate-task\tools.test.ts:
  434:        // then proceeds without error - uses fallback chain
  739:     test("systemDefaultModel is used as fallback when custom category has no model", () => {
  2040:   describe("category model resolution fallback", () => {
  2053:             id: "task-fallback",
  2054:             sessionID: "ses_fallback_test",
  2055:             description: "Fallback test task",
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

c:\Users\paulc\.config\opencode\dev\src\config\constants.ts:
  59: export const FALLBACK_FAILOVER_TIMEOUT_MS = 15_000;

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\tools\delegate-task\sync-task.ts:
  1: import type { ModelFallbackInfo } from "../../features/task-toast-manager/types"
  20:   modelInfo?: ModelFallbackInfo,

c:\Users\paulc\.config\opencode\dev\src\background\codemap.md:
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
  62: - **Cooldown**: 1 hour before retrying failed models
  68: Integrated into fallback loop:
  70: - Attempts **compaction + single retry** before falling back to next model
  74: #### 4. **Provider Error-Based Fallback Decision**
  75: In fallback loop, distinguishes error types:
  76: - **Provider errors** (rate limits, model unavailable, auth failures): trigger fallback to next model
  77: - **Non-provider errors** (validation, prompt errors): fail immediately without fallback
  90: - **Fallback reliability**: TmuxSessionManager uses polling fallback; BackgroundTaskManager relies solely on events
  115: Main orchestrator for background task lifecycle and model fallback.
  142: - `startTask(task): Promise<void>` - Complex orchestration including model fallback loop
  147: - `resolveFallbackChain(agentName): string[]` - Apply circuit breaker filtering
  152: - `compactAndRetry(sessionId, promptFn): Promise<void>` - Compact context and retry once
  181: - `pollSessions(): Promise<void>` - Fallback polling for status
  234:   ├─ Resolve model chain (getFullModelChain + resolveFallbackChain)
  235:   ├─ Initialize fallbackInfo.attempts = []
  236:   └─ Fallback loop (for each model in chain):
  238:       ├─ promptWithTimeout(timeoutMs = fallback.timeoutMs or 15000)
  242:       │   │ └─ compactAndRetry() → retry once
  278:   ├─ Else if fallbackInfo.totalAttempts > 0 → completeTask('failed', 'All models failed')
  311: ### Model Fallback Flow (startTask detail)
  317: Call resolveFallbackChain() to apply circuit breaker:
  319:     Check triage[model] in config.fallback.triage
  333:   │       │   Try compactAndRetry(sessionId, promptFn)
  344:   Throw: "All fallback models failed after N attempts. errors.join(' | ')"
  355: Get triage = config.fallback.triage (create if missing)
  376: resolveFallbackChain(agentName):
  393: During fallback loop, catch error:
  397:     compactAndRetry(sessionId, async () => {
  406: compactAndRetry(sessionId, promptFn):
  410: await promptFn()  (retry original prompt)
  493:   (this.config includes fallback.triage with updated failure counts)
  504: - `../config`: `BackgroundTaskConfig`, `PluginConfig`, `TmuxConfig`, `FALLBACK_FAILOVER_TIMEOUT_MS`, `SUBAGENT_DELEGATION_RULES`, `POLL_INTERVAL_BACKGROUND_MS`
  528:    - `TmuxSessionManager.pollSessions()` provides fallback reliability
  556: - `fallback?: {enabled?: boolean, timeoutMs?: number, triage?: Record<string, {failureCount, lastFailure?, lastSuccess?}>}`
  562: 3. `HARDCODED_DEFAULTS[agentName]` (fallback)
  569: - **Context length errors**: Trigger compaction + retry, then continue to next model if fails
  581: - `[fallback]`: model chain resolution, attempt outcomes, warnings
  592: 1. **Model fallback chains** with automatic switching on provider errors
  594: 3. **Context length auto-recovery** via compaction + retry
  599: - `startTask()` now includes complex fallback loop with error classification
  600: - `extractAndCompleteTask()` includes fallback error summarization
  601: - `sendCompletionNotification()` adds fallback success notice to parent
  606: - `BackgroundTask.fallbackInfo?: FallbackInfo`
  607: - `FallbackInfo` and `FallbackAttempt` types added
  610: - `config.fallback` object: `{enabled, timeoutMs, triage: {[model]: {failureCount, lastFailure, lastSuccess?}}}`
  611: - `config.agents[agent].models` (array) or `config.agents[agent].model` (string) for full fallback chains

c:\Users\paulc\.config\opencode\dev\src\cli\install.ts:
  590:           'No free Chutes models found. Continuing with fallback Chutes mapping.',
  711:       'No providers configured. Zen Big Pickle models will be used as fallback.',

c:\Users\paulc\.config\opencode\dev\ref\oh-my-opencode-dev\src\tools\delegate-task\sync-session-poller.ts:
  58:       log("[task] Poll status fetch failed, retrying", { sessionID: input.sessionID, error: String(error) })
  81:       log("[task] Poll messages fetch failed, retrying", { sessionID: input.sessionID, error: String(error) })
  108:       log("[task] Poll complete - assistant text detected (fallback)", {

c:\Users\paulc

... (truncated)
```
