# Tool Output: tool_c65a455b4001IE4NJAfZQ3au9l
**Date**: 2026-02-16 08:49:54 UTC
**Size**: 889,043 bytes

```

.\CHANGELOG.md:
  8: - **Model Fallback**: Corrected hardcoded default model IDs and cleared stale triage state to ensure reliable agent communication.
  9: - **Config Integrity**: Fixed syntax errors in `oh-my-opencode-theseus.json` caused by concurrent writes.

.\agent_install.md:
  12: The repository provides a unified installer that handles building the plugin, deploying it to the correct directory, and configuring the agent prompts.
  22: 2.  **Prepares Config**: Copies agent prompts (`agents/*.md`), custom skills, model intelligence data, and the plugin configuration (`oh-my-opencode-theseus.json`) to `~/.config/opencode/`.
  23: 3.  **Safe Registration**: Safely adds the plugin to the `plugin` array in `~/.config/opencode/opencode.json` without overwriting your existing settings.
  40: *   **Plugin not loading**: Check `~/.config/opencode/opencode.json` to ensure `"oh-my-opencode-theseus"` is listed in the `plugin` array.
  41: *   **Missing Prompts**: Ensure the `.md` files exist in `~/.config/opencode/agents/`.

.\bun.lock:
  3:   "configVersion": 1,

.\AGENTS.md:
  3: > **Current Context**: This plugin is installed in `C:\Users\paulc\.config\opencode\plugin` and is actively modified to disable hardcoded permission enforcement. See "Critical Modifications" below.
  51: 1. `bun run deploy` (runs full `bun test`, then build + copy to `~/.config/opencode/plugins`)
  87:   - **Any types**: Allowed in `.test.ts` files only (configured in biome.json).
  94: - **Interfaces**: `PascalCase` (e.g., `AgentConfig`) - do not prefix with `I`.
  118: ├── config/               # Configuration loading & validation
  128: ## ⚠️ Critical Modifications (Custom Configuration)
  139: - **Change**: Removed the loop in the `config` hook that iterated `allMcpNames`.
  144: - **Impact**: Enables the fallback mechanism to work correctly when agent permission is denied. Previously, the returned string was being treated as a success response, bypassing fallback logic.
  152: - **File**: `src/config/constants.ts`
  160:   - Agent delegation now respects user permissions exactly as configured in `opencode.json`
  166:   - Agent prompts now load from `~/.config/opencode/agents/{agentName}.md` files
  173:   - Create or edit markdown files in `~/.config/opencode/agents/` directory
  188: - If compaction fails, the system proceeds to model fallback
  202: ### Model Fallback Chains
  203: Configure automatic model fallback when primary models fail due to provider errors.
  205: **Configuration Structure** (in `oh-my-opencode-theseus.json`):
  211:       "currentModel": "claude-opus",
  215:       "currentModel": "groq-llama",
  223: - **Provider errors** (rate limits, context length, service unavailable) trigger fallback
  224: - **Validation errors** fail immediately without fallback
  225: - Each agent type has its own fallback chain
  229: The plugin implements a circuit breaker to prevent repeatedly trying failed models. Source of truth is `agents.<agent>.currentModel`.
  232: 1. **On plugin load** → reads `agents.<agent>.currentModel`
  233: 2. **When starting a task** → updates `agents.<agent>.currentModel`
  234: 3. **When a model fails** → failure is attributed using `agents.<agent>.currentModel` and recorded to triage
  241:   - `setConfiguredAgentModel(agent, model)` - Stores active model in `agents.<agent>.currentModel`
  242:   - `getConfiguredAgentModel(agent)` - Retrieves active model for failure recording
  243:   - `retryWithNextModel()` - Uses current model tracking instead of faulty fallbackInfo lookup
  245: **Tracked Metrics** (in `agents.<agent>.currentModel` and `fallback.triage`):
  246: - `agents[agentName].currentModel`: The model currently in use for each agent
  252: Previously, the system relied on `fallbackInfo` lookups which could become stale or incorrect during retries. The new current model tracking ensures:
  255: - Proper fallback chain progression on retries
  281: ### Config Loading Bug Fix
  283: **Problem**: After OpenCode reset, the plugin wasn't reading model chains from `oh-my-opencode-theseus.json` config. It fell back to HARDCODED_DEFAULTS instead of reading from config.
  285: **Root Cause**: JSON syntax error in `oh-my-opencode-theseus.json` caused `JSON.parse()` to fail silently. The catch block swallowed the error and returned `null`, resulting in empty config `{}`.
  288: 1. Added detailed logging to `src/config/loader.ts` to trace config loading
  290: 3. Found that `loadConfigFromPath` was being called but returning empty config
  292: 5. Fixed the JSON syntax error in the config file
  295: - `[config-loader] Raw config from file: { hasAgents: true, ... }` - config file is readable
  296: - `[background-manager] Constructor received config: { hasAgents: true, agentsKeys: [...] }` - agents loaded
  315: - **Constants**: Define in `src/config/constants.ts` for reuse
  317: - **Configuration**: Load via `src/config/loader.ts` with Zod validation
  319: - **Path Resolution**: Config loader uses `os.homedir()` for cross-platform path resolution, ensuring fallback chains and presets from `~/.config/opencode/oh-my-opencode-theseus.json` are loaded correctly on all platforms (including Windows)
  327: ### Biome Configuration
  328: - Configured in `biome.json` at project root

.\codemap.md:
  5: This is the user's main OpenCode configuration hub - it provides a sophisticated multi-agent AI coding environment through the `oh-my-opencode-theseus` plugin. The directory contains:
  8: - **Configuration management** - Centralized settings for OpenCode core (`opencode.json`) and plugin behavior (`oh-my-opencode-theseus.json`)
  11: - **Model management** - Comprehensive model research and per-agent model assignments with fallback chains
  29: - Central configuration: `oh-my-opencode-theseus.json` manages agent models, MCP servers, skills
  30: - Agent model fallback chains provide resilience and cost optimization
  34: ### Configuration-as-Code
  37: - Preset files (recommended, openai, antigravity) for different provider configurations
  44: - Skills registered in plugin config and loaded dynamically
  48: - Providers are configured in `opencode.json` under the top-level `provider` object (custom providers) alongside OpenCode's built-in provider support.
  49: - This config currently defines:
  58: ### Configuration Loading
  60: 2. `oh-my-opencode-theseus` plugin initializes → loads agent configs and model assignments
  63: 5. MCP servers connected based on configuration
  76: 2. On failure/timeout → fallback chain traversed automatically
  77: 3. Fallback triage tracked (`oh-my-opencode-theseus.json` → `fallback.triage`)
  84: 4. Changes require OpenCode restart for core config, agent restart for prompt changes
  96: - ToolHive MCP Optimizer (`toolhive-mcp-optimizer`) configured at `localhost:22368/mcp`
  97: - Agents access MCP servers based on `mcps` config (wildcard `*` or specific)
  102: - OpenRouter Free provider configured as `free/openrouter/free`.
  103: - Google AI Studio provider configured as `google/<gemini-model-id>` (Gemini 3 preview + Gemini 2.5 family, plus deprecated Gemini 2.0 entries).
  127: | `runconfigs/` | Run configuration templates | [codemap.md](runconfigs/codemap.md) |
  133: - `plugin/src/cli/` - Configuration loading, model selection, skill management
  134: - `plugin/src/config/` - Schema validation, loader, agent-MCP mappings
  136: - `plugin/src/background/` - Background task execution with fallback chains

.\oh-my-opencode-theseus.json:
  4:       "currentModel": "opencode/kimi-k2.5-free",
  53:       "currentModel": "google-ai-studio/gemini-2.5-pro",
  108:       "currentModel": "opencode/kimi-k2.5-free",
  160:       "currentModel": "opencode/big-pickle",
  213:       "currentModel": "moonshotai/kimi-k2.5",
  264:       "currentModel": "moonshotai/kimi-k2-thinking",
  319:   "fallback": {

.\opencode.json:
  2:   "$schema": "https://opencode.ai/config.json",
  25:             "thinkingConfig": {
  31:               "thinkingConfig": {
  36:               "thinkingConfig": {
  45:             "thinkingConfig": {
  51:               "thinkingConfig": {
  56:               "thinkingConfig": {
  65:             "thinkingConfig": {
  72:               "thinkingConfig": {
  78:               "thinkingConfig": {
  88:             "thinkingConfig": {
  95:               "thinkingConfig": {
  101:               "thinkingConfig": {
  111:             "thinkingConfig": {
  118:               "thinkingConfig": {
  124:               "thinkingConfig": {
  134:             "thinkingConfig": {
  141:               "thinkingConfig": {
  147:               "thinkingConfig": {
  157:             "thinkingConfig": {
  164:               "thinkingConfig": {
  170:               "thinkingConfig": {
  180:             "thinkingConfig": {
  187:               "thinkingConfig": {
  193:               "thinkingConfig": {
  203:             "thinkingConfig": {
  210:               "thinkingConfig": {
  216:               "thinkingConfig": {
  226:             "thinkingConfig": {
  233:               "thinkingConfig": {
  239:               "thinkingConfig": {
  249:             "thinkingConfig": {
  256:               "thinkingConfig": {
  262:               "thinkingConfig": {
  272:             "thinkingConfig": {
  279:               "thinkingConfig": {
  285:               "thinkingConfig": {
  295:             "thinkingConfig": {
  302:               "thinkingConfig": {
  308:               "thinkingConfig": {
  318:             "thinkingConfig": {
  325:               "thinkingConfig": {
  331:               "thinkingConfig": {
  344:             "thinkingConfig": {
  351:               "thinkingConfig": {
  357:               "thinkingConfig": {
  367:             "thinkingConfig": {
  374:               "thinkingConfig": {
  380:               "thinkingConfig": {
  402:             "thinkingConfig": {
  408:               "thinkingConfig": {
  413:               "thinkingConfig": {
  422:             "thinkingConfig": {
  428:               "thinkingConfig": {
  433:               "thinkingConfig": {
  546:       "description": "Autonomous writer — all documentation, configs, synthesis, and cartography execution",
  605:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is enabled as primary fixer model. Requirements: (1) ensure `agents.fixer.models` contains `anthropic/claude-opus-4-6` at index 0 exactly once, (2) set `agents.fixer.currentModel` to `anthropic/claude-opus-4-6`, (3) preserve ordering of all non-Opus fixer models, (4) do not modify other agents. Then report the final first 5 entries of `agents.fixer.models`."
  610:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is removed from fixer chain. Requirements: (1) remove all `anthropic/claude-opus-4-6` entries from `agents.fixer.models`, (2) set `agents.fixer.currentModel` to the first remaining fixer model, (3) preserve ordering of remaining fixer models, (4) do not modify other agents. Then report the new `agents.fixer.currentModel` and first 5 entries of `agents.fixer.models`."
  615:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is enabled as primary fixer model. Requirements: (1) ensure `agents.fixer.models` contains `anthropic/claude-opus-4-6` at index 0 exactly once, (2) set `agents.fixer.currentModel` to `anthropic/claude-opus-4-6`, (3) preserve ordering of all non-Opus fixer models, (4) do not modify other agents. Then report the final first 5 entries of `agents.fixer.models`."
  620:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is removed from fixer chain. Requirements: (1) remove all `anthropic/claude-opus-4-6` entries from `agents.fixer.models`, (2) set `agents.fixer.currentModel` to the first remaining fixer model, (3) preserve ordering of remaining fixer models, (4) do not modify other agents. Then report the new `agents.fixer.currentModel` and first 5 entries of `agents.fixer.models`."

.\README.md:
  13: This method installs OpenCode, the plugin, and **all current configurations** (prompts, model chains, skills) in one step.
  48: > **💡 Models are fully customizable.** Edit `~/.config/opencode/oh-my-opencode-theseus.json` (or `.jsonc` for comments support) to assign any model to any agent.
  58: Install and configure by following the instructions here:
  65: - **[Antigravity Setup](docs/antigravity.md)** - Complete guide for Antigravity provider configuration  
  91:       <b>Prompt:</b> <code>~/.config/opencode/agents/orchestrator.md</code>
  122:       <b>Prompt:</b> <code>~/.config/opencode/agents/explorer.md</code>
  153:       <b>Prompt:</b> <code>~/.config/opencode/agents/oracle.md</code>
  184:       <b>Prompt:</b> <code>~/.config/opencode/agents/librarian.md</code>
  215:       <b>Prompt:</b> <code>~/.config/opencode/agents/designer.md</code>
  246:       <b>Prompt:</b> <code>~/.config/opencode/agents/fixer.md</code>
  260: - **[Quick Reference](docs/quick-reference.md)** - Presets, Skills, MCPs, Tools, Configuration
  263: - **[Antigravity Setup](docs/antigravity.md)** - Complete guide for Antigravity provider configuration

.\agents\designer.md:
  136: - Fallback options: [description]

.\agents\explorer.md:
  22: - glob: Pattern-based file finding (*.ts, **/config/*)
  31:    - Extract precise values: `$.config.agents[*].model`
  32:    - Navigate nested configs: `$.presets.*.orchestrator.*`
  33:    - Perfect for: extracting model assignments, config values, API endpoints
  34:    - Example: Get all fallback models → `$.fallback.chains.*`
  39:    - Perfect for: discovering config structure, finding unknown keys
  44:    - Perfect for: tracing model usage, finding config references
  45:    - Example: Search "gemini-2.0" → reveals all Gemini configurations
  51: - JSON tools are 10x faster on large config files
  116:     "json_files_discovered": ["config/models.json", "config/agents.json"],
  128: ### Example - CONFIGURATION Task Schema Response:
  132:   "task": "Extract agent model configuration",
  135:       "configuration_type": "agent_model",
  141:       "fallback_chains": {
  146:       "suggestions": ["Consider adding Gemini 2 Pro for orchestrator fallback"]
  150:     "config_file": "oh-my-opencode-theseus.json",
  177: **Example 1: Finding all model configurations**
  184: **Example 2: Discovering config structure**
  186: ❌ WRONG: Read entire config file manually
  195: Result: Complete paths showing exactly where it's configured

.\models\AGENTS.md:
  45: You are an agent operating within the **OpenCode models directory** (`~/.config/opencode/models/`). This is the central hub for:
  64: ~/.config/opencode/models/                # Current directory (benchmark database)

.\agents\librarian.md:
  31: - Review relevant configuration files
  71: - Configuration review: opencode.json, plugin configs, relevant dotfiles
  83:   - Use when documentation is in JSON format (API specs, config schemas)
  99: - Project Type: [e.g., Python package, React app, Configuration repo]
  102: - Configuration Files: [relevant config files found]
  118: - Configuration requirements
  141: - You assist the Orchestrator on **ALL task types**, not just configuration work
  149: - Be thorough: check directory structure, configs, dependencies, and potential issues
  222: - NEVER modify configuration files (*.json, *.yaml, *.yml)

.\models\agent_model_intelligence.json:
  37:       "file:///C:/Users/paulc/.config/opencode/.backups/MODELS_recommended.md",
  38:       "file:///C:/Users/paulc/.config/opencode/models/QUICK_REFERENCE_GUIDE.md",
  39:       "file:///C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json"

.\cache\bun.lock:
  3:   "configVersion": 1,

.\agents\oracle.md:
  22: - JSON configuration analysis: json_query_jsonpath, json_query_search_keys, json_query_search_values
  23:   - Use for analyzing complex JSON configs, assessing risks, debugging issues

.\skills\cartography\codemap.md:
  22: - Invoked by the primary agent workflow after code/config changes (Cartography refresh phase).

.\agents\orchestrator.md:
  51: **JSON Tool Mastery**: Your configuration analysis can be faster with specialized JSON tools:
  53: - **json_query_jsonpath**: Extract model assignments, fallback chains, agent configurations
  54: - **json_query_search_keys**: Discover config structure when paths are unknown
  57: Use these tools during INVESTIGATE phase when mapping agent configurations. The @explorer will use them for file discovery, but YOU should use them for high-level coordination planning.
  98: - Review relevant configuration files
  104: 2. Configuration file review (relevant settings, models, agents)
  116: - Don't make assumptions about unknown configurations
  132:       "configuration_files": ["<relevant config files>"]
  259: **Original Request**: "Optimize the agent model configuration for better performance"
  261: **Goal**: Discover all files that handle agent model assignments, fallback chains, and configuration loading
  265:   - `**/*config*.json`
  276: 1. Agent configuration files (orchestrator.json, agents.json)
  277: 2. Model fallback chain definitions
  278: 3. MCP/server configurations
  282: - Current configuration uses "zen-free" preset
  286: - Focus on configuration files only
  298: ### CONFIGURATION Tasks - Comprehensive Examples
  303: Task @oracle: Analyze current agent model configuration
  311: **Original Request**: "The user wants to understand if the current agent model configuration is optimal"
  313: **Goal**: Analyze the extracted configuration for risks, gaps, and optimization opportunities
  317: - Fallback chains for all 5 agents
  321: 1. Critical gaps (missing fallbacks, unverified models)
  326: - @explorer extracted the following configuration:
  327:   - Orchestrator: big-pickle (fallback: kimI-k2.5, glm-4.7, pony-alpha, claude-opus-4-6)
  328:   - Oracle: Gemini 2.0 Flash (fallback: pony-alpha, kimi-k2-thinking, glm-4.7, claude-opus-4-6)
  329:   - Fixer: Kimi K2.5 (fallback: claude-opus-4-6)
  339: - @explorer provided raw configuration data
  344: <configuration_schema from below>
  415: **CONFIGURATION Task Schema Template**:
  419:   "task": "Extract model configuration data",
  421:     "configuration_type": "<agent_model|fallback_chain|mcp_config>",
  430:     "fallback_chains": {
  431:       "<agent>": ["<primary>", "<fallback1>", "<fallback2>"]
  747: - If retry fails, continue normal fallback/escalation behavior.
  893: - Critical fallback - user needs reliability
  913: **Change**: Move claude-opus-4-6 from fallback[3] to fallback[1] for orchestrator
  921: - oracle_analysis: "claude-opus-4-6 is most verified - should be first fallback"
  923: - Fallback chain analysis complete
  929: - orchestrator.fallback[0] → "anthropic/claude-opus-4-6"
  954: 2. Attempt non-code remediation first (verification config, command correction, environment)
  981: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py changes --root ./
  982: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py update --root ./
  1165: **Configuration Analysis Example (Use JSON Tools First!)**:
  1169: Task @oracle: Analyze current agent model configuration
  1174: **Original Request**: "Evaluate if current agent configuration is optimal for production use"
  1180: - Fallback chains for all 6 agents
  1184: 1. Critical: Missing or single-point-of-failure fallbacks
  1189: @explorer extracted configuration:
  1201: - @explorer provided raw configuration
  1205: <configuration_schema>
  1209: **JSON Rule**: For configuration analysis, extract with JSON tools FIRST, then delegate analysis to @oracle based on findings.
  1239: **Configuration Analysis (Faster with JSON Tools):**
  1240: When investigating agent configurations, model assignments, or fallback chains:
  1244: 3. Use **json_query_search_keys** to discover config structure: Search "fallback", "provider"
  1252: - Original Request: User wants configuration optimization
  1303: - Use **json_query_search_values** to trace specific model/config references
  1304: - Use **json_query_search_keys** to discover unknown config structures
  1305: - Use JSON tools BEFORE delegating configuration analysis to @oracle

.\skills\cartography\README.md:
  9: 1. Selecting relevant code/config files using LLM judgment

.\skills\model-tester\SKILL.md:
  8: Tests OpenRouter models from `opencode.json` configuration and adds failed models to the triage list in `oh-my-opencode-theseus.json`.
  19: ### Step 1: Read Configuration
  21: Read `opencode.json` to get the provider configuration and models:
  68: Read `oh-my-opencode-theseus.json`, find the `fallback.triage` section, and add failed models:

.\models\CHANGELOG.md:
  1: # Model Configuration Changelog
  7: - Updated `oh-my-opencode-theseus.json` to include `openai/gpt-5.2` in fallback chains for all agents.
  9: - `openai/gpt-5.2` added as a high-priority fallback option due to its strong reasoning capabilities (92.4% GPQA Diamond).
  12: - `models/CHANGELOG.md` to track model configuration changes.

.\skills\cartography\SKILL.md:
  32: 8. **Directory-scoped accuracy is mandatory.** A codemap may describe only code/config that actually exists in that directory subtree (excluding configured ignores).
  45: 2. **Infer patterns** for **core code/config files ONLY** to include:
  55: Use `--exception` for root config files so you don't accidentally include every nested
  59: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py init \
  69:   --exception "tsconfig.json" \
  89:    If Librarians are not permitted to write (common in locked-down configs):
  98: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py changes \
  122: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py update \
  188: Defines agent personalities and manages their configuration lifecycle.
  191: Each agent is a prompt + permission set. Config system uses:
  193: - User overrides from ~/.config/opencode/oh-my-opencode-theseus.json
  197: 1. Plugin loads → calls getAgentConfigs()
  198: 2. Reads user config preset
  201: 5. Returns agent configs to OpenCode
  205: - Depends on: Config loader, skills registry
  219: - `oh-my-opencode-theseus.json`: User configuration schema.
  226: | `src/config/` | Implements the configuration loading pipeline and environment variable injection. | [View Map](src/config/codemap.md) |

.\skills\update-openai-agent-models\SKILL.md:
  17: - Keep proposal-only behavior (no direct config writes).

.\skills\toolhive\SKILL.md:
  76: - **Best**: `tavily_search` (tavily-mcp) - Configurable, good defaults

.\skills\openai-usage\SKILL.md:
  23: - No manual fallback. If Codex rate limits are unavailable, return an actionable error.

.\skills\update-google-agent-models\SKILL.md:
  18: - Keep proposal-only behavior (no direct config writes).

.\skills\update-agent-models\benchmarks.json:
  276:       "note": "Fastest local - ultimate fallback"
  389:       "notes": "Mixed quality - fallback only"
  395:       "notes": "Local - ultimate fallback when all APIs fail",

.\skills\update-agent-models\google-health.js:
  74:         generationConfig: { maxOutputTokens: 5 },

.\skills\update-agent-models\backups\oh-my-opencode-theseus.json.2026-02-14T11-03-02-257Z.bak:
  167:   "fallback": {
  171:     "currentModels": {

.\skills\update-agent-models\benchmark_manual_accepted.json:
  30:             "C:/Users/paulc/.config/opencode/models_1_updated.md:688"

.\skills\update-agent-models\backups\oh-my-opencode-theseus.json.2026-02-14T11-00-05-733Z.bak:
  167:   "fallback": {
  171:     "currentModels": {

.\skills\update-agent-models\backups\oh-my-opencode-theseus.json.2026-02-14T10-54-07-264Z.bak:
  167:   "fallback": {
  171:     "currentModels": {

.\models\config\codemap.md:
  1: # models/config/

.\skills\update-agent-models\guard.js:
  126:     const roleConfig = roles[role];
  127:     const benchmarks = roleConfig.benchmarks || {};
  128:     const formula = roleConfig.scoring_algorithm;
  250:     assert(!text.includes("skills/agents-config"), `Legacy path found in ${filePath}`);
  282: function validateHardNoConfigWrites() {
  402:     assert(theseus?.agents?.[agent], `theseus missing agent config: ${agent}`);
  419:     theseus?.agents?.fixer?.currentModel === "anthropic/claude-opus-4-6",
  436:     ["hard-no-config-writes", validateHardNoConfigWrites],

.\skills\update-agent-models\openai-budget.js:
  10:  * No OpenAI usage API fallback.
  26: function loadOptionalJson(filePath, fallback) {
  27:   if (!fs.existsSync(filePath)) return fallback;

.\models\RESEARCH_GUIDE.md:
  354: - Hugging Face transformers library (get model configs)

.\skills\update-agent-models\next-interview.js:
  32: function asNumber(value, fallback = 0) {
  34:   return Number.isFinite(n) ? n : fallback;

.\models\requirements.txt:
  38: # Configuration

.\models\tui_models_extraction_report.json:
  77:   "tui_output_capture": "Complete verbose output captured with 296 models across 9 providers. Output includes: id, providerID, name, family, API configuration (id, url, npm package), status, headers, options, cost structure (input, output, cache read/write), limits (context, output, input), capabilities (temperature, reasoning, attachment, toolcall, input/output formats), release_date, and variants. All data stored in tui_models_verbose.json (316KB)",
  109:   "configuration_details": {
  132:     "All Anthropic models show zero cost (likely API key not configured)",

.\skills\update-agent-models\benchmarks\ifbench\instructions.md:
  3: This document is a **handoff-ready instruction set** for an agent to install, run, and operationalize **AllenAI IFBench** evaluation for **Trinity‑Mini** (or any OpenAI‑compatible chat API model). It builds a small “platform” around the official IFBench repo: repeatable runs, standardized configs, artifacts, and reports.
  5: This version includes a **complete OpenRouter configuration profile** (base URL, auth, model IDs, and recommended attribution headers).
  31: - One command to run a full IFBench evaluation against a configured API model.
  35: 2) **Configuration system**
  37: - Optional `config.yaml` overlay for non-secret defaults.
  93:   configs/
  204: (Keep both in a provider example file like `configs/openrouter.env.example` but never commit `API_KEY`.)
  235: - snapshot config + git SHAs
  363: - [ ] OpenRouter profile file created: `configs/openrouter.env.example`

.\skills\update-agent-models\optimize.js:
  64: function loadOptionalJson(filePath, fallback) {
  65:   if (!fs.existsSync(filePath)) return fallback;
  364: function computeAgentModelScore(roleConfig, recordBenchmarks, formulaConstants) {
  365:   const benchmarkNames = Object.keys(roleConfig.benchmarks || {});
  366:   const formula = normalizeFormula(roleConfig.scoring_algorithm, benchmarkNames);
  434:   const fallback = {
  442:   for (const stage of Object.keys(fallback)) {
  444:       max_input_per_1m_usd: Number(policyCaps?.[stage]?.max_input_per_1m_usd ?? fallback[stage].max_input_per_1m_usd),
  445:       max_output_per_1m_usd: Number(policyCaps?.[stage]?.max_output_per_1m_usd ?? fallback[stage].max_output_per_1m_usd),
  500:   const stageConfig = budgetCtx?.policy?.stage_multipliers?.[stage] || { default: 1, high_cost: 1 };
  504:   const baseMultiplier = Number(highCost ? stageConfig.high_cost : stageConfig.default);
  533: function validateRoleConfig(roleName, roleConfig) {
  534:   if (!roleConfig || typeof roleConfig !== "object") {
  535:     throw new Error(`Missing role configuration: ${roleName}`);
  537:   if (!roleConfig.benchmarks || !roleConfig.scoring_algorithm) {
  538:     throw new Error(`Invalid role configuration: ${roleName}`);
  541:   for (const benchmarkDef of Object.values(roleConfig.benchmarks)) {
  616:     const roleConfig = benchCalc?.model_selection_benchmarks?.[roleName];
  617:     validateRoleConfig(roleName, roleConfig);
  645:       const score = computeAgentModelScore(roleConfig, record.benchmarks, formulaConstants);
  691:       if (theseus?.fallback?.currentModels) {
  692:         theseus.fallback.currentModels[agentKey] = result.chain[0];
  889:   console.log("No config write performed. Skill is proposal-only by design.");

.\models\tui_models_verbose.json:
  2065:       "thinkingConfig": {
  2071:       "thinkingConfig": {
  2127:       "thinkingConfig": {
  2133:       "thinkingConfig": {
  2189:       "thinkingConfig": {
  2195:       "thinkingConfig": {
  2251:       "thinkingConfig": {
  2257:       "thinkingConfig": {
  2313:       "thinkingConfig": {
  2319:       "thinkingConfig": {
  2375:       "thinkingConfig": {
  2381:       "thinkingConfig": {
  2437:       "thinkingConfig": {
  2443:       "thinkingConfig": {
  2499:       "thinkingConfig": {
  2505:       "thinkingConfig": {
  2561:       "thinkingConfig": {
  2567:       "thinkingConfig": {
  2672:       "thinkingConfig": {
  2678:       "thinkingConfig": {
  2734:       "thinkingConfig": {
  2740:       "thinkingConfig": {
  2796:       "thinkingConfig": {
  2802:       "thinkingConfig": {
  3204:       "thinkingConfig": {
  3210:       "thinkingConfig": {
  3266:       "thinkingConfig": {
  3272:       "thinkingConfig": {

.\models\models_available.json:
  2671:     "description": "DeepSeek-V3.1 is a large hybrid reasoning model (671B parameters, 37B active) that supports both thinking and non-thinking modes via prompt templates. It extends the DeepSeek-V3 base with a two-phase long-context training process, reaching up to 128K tokens, and uses FP8 microscaling for efficient inference. Users can control the reasoning behaviour with the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config)\n\nThe model improves tool use, code generation, and reasoning efficiency, achieving performance comparable to DeepSeek-R1 on difficult benchmarks while responding more quickly. It supports structured tool calling, code agents, and search agents, making it suitable for research, coding, and agentic workflows. \n\nIt succeeds the [DeepSeek V3-0324](/deepseek/deepseek-chat-v3-0324) model and performs well on a variety of tasks.",
  3155: [Omitted long matching line]
  3226: [Omitted long matching line]
  3291:     "description": "DeepSeek-V3.2 is a large language model designed to harmonize high computational efficiency with strong reasoning and agentic tool-use performance. It introduces DeepSeek Sparse Attention (DSA), a fine-grained sparse attention mechanism that reduces training and inference cost while preserving quality in long-context scenarios. A scalable reinforcement learning post-training framework further improves reasoning, with reported performance in the GPT-5 class, and the model has demonstrated gold-medal results on the 2025 IMO and IOI. V3.2 also uses a large-scale agentic task synthesis pipeline to better integrate reasoning into tool-use settings, boosting compliance and generalization in interactive environments.\n\nUsers can control the reasoning behaviour with the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config)",
  5880:     "description": "Hermes 4 is a large-scale reasoning model built on Meta-Llama-3.1-405B and released by Nous Research. It introduces a hybrid reasoning mode, where the model can choose to deliberate internally with <think>...</think> traces or respond directly, offering flexibility between speed and depth. Users can control the reasoning behaviour with the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config)\n\nThe model is instruction-tuned with an expanded post-training corpus (~60B tokens) emphasizing reasoning traces, improving performance in math, code, STEM, and logical reasoning, while retaining broad assistant utility. It also supports structured outputs, including JSON mode, schema adherence, function calling, and tool use. Hermes 4 is trained for steerability, lower refusal rates, and alignment toward neutral, user-directed behavior.",
  5945:     "description": "Hermes 4 70B is a hybrid reasoning model from Nous Research, built on Meta-Llama-3.1-70B. It introduces the same hybrid mode as the larger 405B release, allowing the model to either respond directly or generate explicit <think>...</think> reasoning traces before answering. Users can control the reasoning behaviour with the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config)\n\nThis 70B variant is trained with the expanded post-training corpus (~60B tokens) emphasizing verified reasoning data, leading to improvements in mathematics, coding, STEM, logic, and structured outputs while maintaining general assistant performance. It supports JSON mode, schema adherence, function calling, and tool use, and is designed for greater steerability with reduced refusal rates.",
  6141:     "description": "NVIDIA-Nemotron-Nano-9B-v2 is a large language model (LLM) trained from scratch by NVIDIA, and designed as a unified model for both reasoning and non-reasoning tasks. It responds to user queries and tasks by first generating a reasoning trace and then concluding with a final response. \n\nThe model's reasoning capabilities can be controlled via a system prompt. If the user prefers the model to provide its final answer without intermediate reasoning traces, it can be configured to do so.",
  6207:     "description": "NVIDIA-Nemotron-Nano-9B-v2 is a large language model (LLM) trained from scratch by NVIDIA, and designed as a unified model for both reasoning and non-reasoning tasks. It responds to user queries and tasks by first generating a reasoning trace and then concluding with a final response. \n\nThe model's reasoning capabilities can be controlled via a system prompt. If the user prefers the model to provide its final answer without intermediate reasoning traces, it can be configured to do so.",
  7644:     "description": "gpt-oss-120b is an open-weight, 117B-parameter Mixture-of-Experts (MoE) language model from OpenAI designed for high-reasoning, agentic, and general-purpose production use cases. It activates 5.1B parameters per forward pass and is optimized to run on a single H100 GPU with native MXFP4 quantization. The model supports configurable reasoning depth, full chain-of-thought access, and native tool use, including function calling, browsing, and structured output generation.",
  7710:     "description": "gpt-oss-120b is an open-weight, 117B-parameter Mixture-of-Experts (MoE) language model from OpenAI designed for high-reasoning, agentic, and general-purpose production use cases. It activates 5.1B parameters per forward pass and is optimized to run on a single H100 GPU with native MXFP4 quantization. The model supports configurable reasoning depth, full chain-of-thought access, and native tool use, including function calling, browsing, and structured output generation.",
  7775:     "description": "gpt-oss-120b is an open-weight, 117B-parameter Mixture-of-Experts (MoE) language model from OpenAI designed for high-reasoning, agentic, and general-purpose production use cases. It activates 5.1B parameters per forward pass and is optimized to run on a single H100 GPU with native MXFP4 quantization. The model supports configurable reasoning depth, full chain-of-thought access, and native tool use, including function calling, browsing, and structured output generation.",
  7841:     "description": "gpt-oss-20b is an open-weight 21B parameter model released by OpenAI under the Apache 2.0 license. It uses a Mixture-of-Experts (MoE) architecture with 3.6B active parameters per forward pass, optimized for lower-latency inference and deployability on consumer or single-GPU hardware. The model is trained in OpenAI’s Harmony response format and supports reasoning level configuration, fine-tuning, and agentic capabilities including function calling, tool use, and structured outputs.",
  7906:     "description": "gpt-oss-20b is an open-weight 21B parameter model released by OpenAI under the Apache 2.0 license. It uses a Mixture-of-Experts (MoE) architecture with 3.6B active parameters per forward pass, optimized for lower-latency inference and deployability on consumer or single-GPU hardware. The model is trained in OpenAI’s Harmony response format and supports reasoning level configuration, fine-tuning, and agentic capabilities including function calling, tool use, and structured outputs.",
  11114:     "description": "MiMo-V2-Flash is an open-source foundation language model developed by Xiaomi. It is a Mixture-of-Experts model with 309B total parameters and 15B active parameters, adopting hybrid attention architecture. MiMo-V2-Flash supports a hybrid-thinking toggle and a 256K context window, and excels at reasoning, coding, and agent scenarios. On SWE-bench Verified and SWE-bench Multilingual, MiMo-V2-Flash ranks as the top #1 open-source model globally, delivering performance comparable to Claude Sonnet 4.5 while costing only about 3.5% as much.\n\nUsers can control the reasoning behaviour with the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config).",
  11180:     "description": "GLM-4.5 is our latest flagship foundation model, purpose-built for agent-based applications. It leverages a Mixture-of-Experts (MoE) architecture and supports a context length of up to 128k tokens. GLM-4.5 delivers significantly enhanced capabilities in reasoning, code generation, and agent alignment. It supports a hybrid inference mode with two options, a \"thinking mode\" designed for complex reasoning and tool use, and a \"non-thinking mode\" optimized for instant responses. Users can control the reasoning behaviour with the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config)",
  11245:     "description": "GLM-4.5-Air is the lightweight variant of our latest flagship model family, also purpose-built for agent-centric applications. Like GLM-4.5, it adopts the Mixture-of-Experts (MoE) architecture but with a more compact parameter size. GLM-4.5-Air also supports hybrid inference modes, offering a \"thinking mode\" for advanced reasoning and tool use, and a \"non-thinking mode\" for real-time interaction. Users can control the reasoning behaviour with the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config)",
  11310:     "description": "GLM-4.5-Air is the lightweight variant of our latest flagship model family, also purpose-built for agent-centric applications. Like GLM-4.5, it adopts the Mixture-of-Experts (MoE) architecture but with a more compact parameter size. GLM-4.5-Air also supports hybrid inference modes, offering a \"thinking mode\" for advanced reasoning and tool use, and a \"non-thinking mode\" for real-time interaction. Users can control the reasoning behaviour with the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config)",
  11375:     "description": "GLM-4.5V is a vision-language foundation model for multimodal agent applications. Built on a Mixture-of-Experts (MoE) architecture with 106B parameters and 12B activated parameters, it achieves state-of-the-art results in video understanding, image Q&A, OCR, and document parsing, with strong gains in front-end web coding, grounding, and spatial reasoning. It offers a hybrid inference mode: a \"thinking mode\" for deep reasoning and a \"non-thinking mode\" for fast responses. Reasoning behavior can be toggled via the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config)",
  12011:     "description": "Gemini 2.5 Flash is Google's state-of-the-art workhorse model, specifically designed for advanced reasoning, coding, mathematics, and scientific tasks. It includes built-in \"thinking\" capabilities, enabling it to provide responses with greater accuracy and nuanced context handling. \n\nAdditionally, Gemini 2.5 Flash is configurable through the \"max tokens for reasoning\" parameter, as described in the documentation (https://openrouter.ai/docs/use-cases/reasoning-tokens#max-tokens-for-reasoning).",
  13637:     "description": "DeepSeek-V3.2 is a large language model designed to harmonize high computational efficiency with strong reasoning and agentic tool-use performance. It introduces DeepSeek Sparse Attention (DSA), a fine-grained sparse attention mechanism that reduces training and inference cost while preserving quality in long-context scenarios. A scalable reinforcement learning post-training framework further improves reasoning, with reported performance in the GPT-5 class, and the model has demonstrated gold-medal results on the 2025 IMO and IOI. V3.2 also uses a large-scale agentic task synthesis pipeline to better integrate reasoning into tool-use settings, boosting compliance and generalization in interactive environments.\n\nUsers can control the reasoning behaviour with the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config)",
  13874:     "description": "Hermes 4 70B is a hybrid reasoning model from Nous Research, built on Meta-Llama-3.1-70B. It introduces the same hybrid mode as the larger 405B release, allowing the model to either respond directly or generate explicit <think>...</think> reasoning traces before answering. Users can control the reasoning behaviour with the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config)\n\nThis 70B variant is trained with the expanded post-training corpus (~60B tokens) emphasizing verified reasoning data, leading to improvements in mathematics, coding, STEM, logic, and structured outputs while maintaining general assistant performance. It supports JSON mode, schema adherence, function calling, and tool use, and is designed for greater steerability with reduced refusal rates.",

.\skills\update-agent-models\benchmarks\mmlu_pro\openrouter_mmlu_pro_lm_eval_instructions.md:
  51: ## 3) Configure OpenRouter credentials

.\skills\update-agent-models\research-benchmarks.js:
  360:       // Keep Authorization fallback for compatibility.

.\skills\update-agent-models\model_benchmarks.json:
  13572:   "calculation_config": {

.\skills\update-agent-models\test-models.sh:
  29: PROPOSAL_DIR="C:/Users/paulc/.config/opencode/skills/update-agent-models/proposals"
  45:         -d '{"contents":[{"parts":[{"text":"OK"}]}],"generationConfig":{"maxOutputTokens":5}}' -o /dev/null 2>/dev/null
  273: echo "No direct config write performed. Agent should review and apply updates to working_models.json."

.\skills\update-agent-models\SKILL.md:
  9: - `C:\Users\paulc\.config\opencode\oh-my-opencode-theseus.json`
  14: - Scripts are **proposal-only** and must never write config files directly.
  15: - Final config edits are applied by an agent after reviewing generated proposals.
  33: `free/openrouter/free` is a reserved bridge model: keep it directly before the local fallback model (`lmstudio-local/*`) and exclude it from benchmark-research decisions.
  64: By default, optimization runs in proposal mode (no direct config write).
  92:   - Updates both `agents.*.model` and `fallback.currentModels.*`
  100:     - chain tail is reserved bridge + local fallback: `free/openrouter/free`, then `lmstudio-local/*`
  107:   - Validates AA provider config exists in `opencode.json`
  109:   - Validates target config constraints
  241: ## Keys and Provider Configuration
  245: - Artificial Analysis provider should be configured in:
  246:   - `C:\Users\paulc\.config\opencode\opencode.json`

.\skills\update-agent-models\benchmarks\ifbench\ifbench-platform\README.md:
  18: 2) Configure OpenRouter:

.\skills\update-agent-models\run-workflow.js:
  110:     console.log("OpenAI-only workflow completed in proposal mode. No config write performed.");
  129:     console.log("Google-only workflow completed in proposal mode. No config write performed.");
  208:   console.log("Workflow completed in proposal mode. No config write performed.");

.\skills\update-agent-models\reports\optimize.2026-02-14T16-05-27-793Z.json:
  11:   "workingModelsSource": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\working_models.20260214T155901Z.json",
  16:     "latestProposal": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\openai-budget.2026-02-14T16-01-58-143Z.json",
  21:     "latestProposal": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\google-health.2026-02-14T16-05-26-834Z.json",

.\skills\update-agent-models\benchmarks\gpqa\gpqa_openrouter_install.md:
  45: ## 4) Configure OpenRouter credentials

.\skills\update-agent-models\proposals\openai-budget.2026-02-15T11-55-54-317Z.json:
  35:     "source_file": "c:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\openai_limits_manual.json"

.\skills\update-agent-models\reports\optimize.2026-02-14T16-09-57-205Z.json:
  11:   "workingModelsSource": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\working_models.20260214T155901Z.json",
  16:     "latestProposal": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\openai-budget.2026-02-14T16-01-58-143Z.json",
  21:     "latestProposal": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\google-health.2026-02-14T16-05-26-834Z.json",

.\skills\update-agent-models\proposals\openai-budget.2026-02-16T02-34-07-311Z.json:
  35:     "source_file": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\openai_limits_manual.json"

.\skills\update-agent-models\reports\optimize.2026-02-15T11-55-19-396Z.json:
  14:   "workingModelsSource": "c:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\working_models.20260215T105028Z.json",
  27:     "latestProposal": "c:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\openai-budget.2026-02-15T11-55-17-286Z.json",

.\skills\update-agent-models\proposals\theseus-update.2026-02-15T11-55-19-397Z.json:
  3:   "target": "c:\\Users\\paulc\\.config\\opencode\\oh-my-opencode-theseus.json",

.\skills\update-agent-models\benchmarks\mmlu_pro\mmlu-pro-platform\scripts\summarize.py:
  38:             "model": data.get("config", {}).get("model_args", {}).get("model"),

.\skills\update-agent-models\reports\optimize.2026-02-16T02-53-27-461Z.json:
  14:   "workingModelsSource": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\working_models.20260216T022828Z.json",
  27:     "latestProposal": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\openai-budget.2026-02-16T02-34-07-311Z.json",

.\skills\update-agent-models\reports\optimize.2026-02-14T22-58-10-713Z.json:
  11:   "workingModelsSource": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\working_models.20260214T225519Z.json",
  16:     "latestProposal": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\openai-budget.2026-02-14T22-58-09-124Z.json",
  21:     "latestProposal": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\google-health.2026-02-14T16-05-26-834Z.json",

.\skills\update-agent-models\reports\optimize.2026-02-15T18-57-30-232Z.json:
  14:   "workingModelsSource": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\working_models.json",
  27:     "latestProposal": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\openai-budget.2026-02-15T11-55-54-317Z.json",

.\skills\update-agent-models\reports\optimize.2026-02-15T11-55-55-959Z.json:
  14:   "workingModelsSource": "c:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\working_models.json",
  27:     "latestProposal": "c:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\proposals\\openai-budget.2026-02-15T11-55-54-317Z.json",

.\skills\update-agent-models\proposals\theseus-update.2026-02-16T02-53-27-462Z.json:
  3:   "target": "C:\\Users\\paulc\\.config\\opencode\\oh-my-opencode-theseus.json",

.\skills\update-agent-models\proposals\theseus-update.2026-02-15T12-19-38-920Z.json:
  3:   "target": "C:\\Users\\paulc\\.config\\opencode\\oh-my-opencode-theseus.json",

.\skills\update-agent-models\proposals\theseus-update.2026-02-15T18-57-30-234Z.json:
  3:   "target": "C:\\Users\\paulc\\.config\\opencode\\oh-my-opencode-theseus.json",

.\skills\update-agent-models\benchmarks\gpqa\gpqa-platform\scripts\summarize.py:
  24:             "model": data.get("config", {}).get("model_args", {}).get("model"),

.\skills\update-agent-models\benchmarks\ifbench\ifbench-platform\vendor\IFBench\config.py:
  1: """Configuration for IFBench using pydantic-settings."""
  4: from pydantic_settings import BaseSettings, SettingsConfigDict
  10:     model_config = SettingsConfigDict(
  16:     # API Configuration

.\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\examples\lm-eval-overview.ipynb:
  37:     "2. Easier addition and s

... (truncated)
```
