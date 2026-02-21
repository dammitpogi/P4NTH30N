# Tool Output: tool_c65a3d768001rTqs9DyTDGA4FM
**Date**: 2026-02-16 08:49:22 UTC
**Size**: 645,483 bytes

```

.\codemap.md:
  9: - **Custom skill framework** - Extensible capabilities (cartography, toolhive, model-tester) that enhance agent functionality
  11: - **Model management** - Comprehensive model research and per-agent model assignments with fallback chains
  29: - Central configuration: `oh-my-opencode-theseus.json` manages agent models, MCP servers, skills
  30: - Agent model fallback chains provide resilience and cost optimization
  31: - Dynamic model selection via `src/cli/dynamic-model-selection.ts`
  36: - `oh-my-opencode-theseus.json` - Plugin-specific: agent model assignments, disabled MCPs, idle orchestrator
  42: - Built-in skills: cartography (repo mapping), toolhive (MCP optimization), model-tester
  54: - Models are enumerated under each provider's `models` map with human-readable names; model selection uses `provider_id/model_id` (e.g. `google/gemini-2.5-pro`).
  60: 2. `oh-my-opencode-theseus` plugin initializes → loads agent configs and model assignments
  68: 3. Subagents execute with their assigned models and permissions
  74: ### Model Selection
  75: 1. Agent requested → primary model attempted first
  76: 2. On failure/timeout → fallback chain traversed automatically
  77: 3. Fallback triage tracked (`oh-my-opencode-theseus.json` → `fallback.triage`)
  78: 4. Dynamic model selection adapts based on availability and performance
  95: ### MCP (Model Context Protocol)
  103: - Google AI Studio provider configured as `google/<gemini-model-id>` (Gemini 3 preview + Gemini 2.5 family, plus deprecated Gemini 2.0 entries).
  124: | `models/` | Model research data | [codemap.md](models/codemap.md) |
  133: - `plugin/src/cli/` - Configuration loading, model selection, skill management
  136: - `plugin/src/background/` - Background task execution with fallback chains

.\AGENTS.md:
  6: This is a lightweight agent orchestration plugin for OpenCode, built with TypeScript and Bun. It replaces the default single-agent model with a specialized team (Orchestrator, Explorer, Fixer, etc.).
  144: - **Impact**: Enables the fallback mechanism to work correctly when agent permission is denied. Previously, the returned string was being treated as a success response, bypassing fallback logic.
  182: The plugin automatically detects context length errors and attempts recovery through session compaction before falling back to alternative models.
  188: - If compaction fails, the system proceeds to model fallback
  202: ### Model Fallback Chains
  203: Configure automatic model fallback when primary models fail due to provider errors.
  211:       "currentModel": "claude-opus",
  212:       "models": ["claude-opus", "gemini-pro", "gpt-4"]
  215:       "currentModel": "groq-llama",
  216:       "models": ["groq-llama", "gpt-4", "claude-haiku"]
  223: - **Provider errors** (rate limits, context length, service unavailable) trigger fallback
  224: - **Validation errors** fail immediately without fallback
  225: - Each agent type has its own fallback chain
  226: - System attempts each model in sequence until success or chain exhaustion
  228: ### Circuit Breaker Pattern with Agent Current Model Tracking
  229: The plugin implements a circuit breaker to prevent repeatedly trying failed models. Source of truth is `agents.<agent>.currentModel`.
  232: 1. **On plugin load** → reads `agents.<agent>.currentModel`
  233: 2. **When starting a task** → updates `agents.<agent>.currentModel`
  234: 3. **When a model fails** → failure is attributed using `agents.<agent>.currentModel` and recorded to triage
  235: 4. **Circuit breaker filters** models that have failed 3+ times within 1 hour
  236: 5. **On retry** → picks next available model from chain and updates current model tracking
  241:   - `setConfiguredAgentModel(agent, model)` - Stores active model in `agents.<agent>.currentModel`
  242:   - `getConfiguredAgentModel(agent)` - Retrieves active model for failure recording
  243:   - `retryWithNextModel()` - Uses current model tracking instead of faulty fallbackInfo lookup
  245: **Tracked Metrics** (in `agents.<agent>.currentModel` and `fallback.triage`):
  246: - `agents[agentName].currentModel`: The model currently in use for each agent
  247: - `failureCount`: Number of consecutive failures for a model
  251: **Why Current Model Tracking Matters:**
  252: Previously, the system relied on `fallbackInfo` lookups which could become stale or incorrect during retries. The new current model tracking ensures:
  253: - Accurate failure attribution to the correct model
  255: - Proper fallback chain progression on retries
  256: - No false positives from outdated model references
  283: **Problem**: After OpenCode reset, the plugin wasn't reading model chains from `oh-my-opencode-theseus.json` config. It fell back to HARDCODED_DEFAULTS instead of reading from config.
  319: - **Path Resolution**: Config loader uses `os.homedir()` for cross-platform path resolution, ensuring fallback chains and presets from `~/.config/opencode/oh-my-opencode-theseus.json` are loaded correctly on all platforms (including Windows)

.\CHANGELOG.md:
  8: - **Model Fallback**: Corrected hardcoded default model IDs and cleared stale triage state to ensure reliable agent communication.

.\package.json:
  53:     "@modelcontextprotocol/sdk": "^1.25.1",

.\opencode.json:
  21:       "models": {
  451:       "models": {
  453:           "name": "OpenRouter Free Models"
  464:       "models": {
  495:       "model": "google/gemini-3-flash-preview",
  510:       "model": "google/gemini-3-flash-preview",
  523:       "model": "google/gemini-3-flash-preview",
  536:       "model": "google/gemini-3-flash-preview",
  545:       "model": "google/gemini-3-flash-preview",
  558:       "model": "google/gemini-3-flash-preview",
  605:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is enabled as primary fixer model. Requirements: (1) ensure `agents.fixer.models` contains `anthropic/claude-opus-4-6` at index 0 exactly once, (2) set `agents.fixer.currentModel` to `anthropic/claude-opus-4-6`, (3) preserve ordering of all non-Opus fixer models, (4) do not modify other agents. Then report the final first 5 entries of `agents.fixer.models`."
  610:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is removed from fixer chain. Requirements: (1) remove all `anthropic/claude-opus-4-6` entries from `agents.fixer.models`, (2) set `agents.fixer.currentModel` to the first remaining fixer model, (3) preserve ordering of remaining fixer models, (4) do not modify other agents. Then report the new `agents.fixer.currentModel` and first 5 entries of `agents.fixer.models`."
  615:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is enabled as primary fixer model. Requirements: (1) ensure `agents.fixer.models` contains `anthropic/claude-opus-4-6` at index 0 exactly once, (2) set `agents.fixer.currentModel` to `anthropic/claude-opus-4-6`, (3) preserve ordering of all non-Opus fixer models, (4) do not modify other agents. Then report the final first 5 entries of `agents.fixer.models`."
  620:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is removed from fixer chain. Requirements: (1) remove all `anthropic/claude-opus-4-6` entries from `agents.fixer.models`, (2) set `agents.fixer.currentModel` to the first remaining fixer model, (3) preserve ordering of remaining fixer models, (4) do not modify other agents. Then report the new `agents.fixer.currentModel` and first 5 entries of `agents.fixer.models`."

.\oh-my-opencode-theseus.json:
  4:       "currentModel": "opencode/kimi-k2.5-free",
  5:       "models": [
  53:       "currentModel": "google-ai-studio/gemini-2.5-pro",
  54:       "models": [
  108:       "currentModel": "opencode/kimi-k2.5-free",
  109:       "models": [
  160:       "currentModel": "opencode/big-pickle",
  161:       "models": [
  213:       "currentModel": "moonshotai/kimi-k2.5",
  214:       "models": [
  264:       "currentModel": "moonshotai/kimi-k2-thinking",
  265:       "models": [
  319:   "fallback": {

.\bun.lock:
  8:         "@modelcontextprotocol/sdk": "^1.25.1",
  62:     "@modelcontextprotocol/sdk": ["@modelcontextprotocol/sdk@1.26.0", "", { "dependencies": { "@hono/node-server": "^1.19.9", "ajv": "^8.17.1", "ajv-formats": "^3.0.1", "content-type": "^1.0.5", "cors": "^2.8.5", "cross-spawn": "^7.0.5", "eventsource": "^3.0.2", "eventsource-parser": "^3.0.0", "express": "^5.2.1", "express-rate-limit": "^8.2.1", "hono": "^4.11.4", "jose": "^6.1.3", "json-schema-typed": "^8.0.2", "pkce-challenge": "^5.0.0", "raw-body": "^3.0.0", "zod": "^3.25 || ^4.0", "zod-to-json-schema": "^3.25.1" }, "peerDependencies": { "@cfworker/json-schema": "^4.1.1" }, "optionalPeers": ["@cfworker/json-schema"] }, "sha512-Y5RmPncpiDtTXDbLKswIJzTqu2hyBKxTNsgKqKclDbhIgg1wgtf1fRuvxgTnRfcnxtvvgbIEcqUOzZrJ6iSReg=="],

.\agent_install.md:
  22: 2.  **Prepares Config**: Copies agent prompts (`agents/*.md`), custom skills, model intelligence data, and the plugin configuration (`oh-my-opencode-theseus.json`) to `~/.config/opencode/`.

.\README.md:
  4:   <p><b>Multi Agent Suite</b> · Mix any models · Auto delegate tasks · Antigravity + Chutes ready</p>
  13: This method installs OpenCode, the plugin, and **all current configurations** (prompts, model chains, skills) in one step.
  28: The installer can refresh and use OpenCode free models directly:
  31: bunx oh-my-opencode-theseus@latest install --no-tui --kimi=yes --openai=yes --antigravity=yes --chutes=yes --opencode-free=yes --opencode-free-model=auto --tmux=no --skills=yes
  42: OpenCode free-model mode uses `opencode models --refresh --verbose`, filters to free `opencode/*` models, and applies coding-first selection:
  43: - OpenCode-only mode can use multiple OpenCode free models across agents.
  44: - Hybrid mode can combine OpenCode free models with OpenAI, Kimi, and/or Antigravity.
  46: - Chutes mode auto-selects primary/support models with daily-cap awareness (300/2000/5000).
  48: > **💡 Models are fully customizable.** Edit `~/.config/opencode/oh-my-opencode-theseus.json` (or `.jsonc` for comments support) to assign any model to any agent.
  96:       <b>Recommended Models:</b> <code>kimi-for-coding/k2p5</code> <code>openai/gpt-5.2-codex</code>
  127:       <b>Recommended Models:</b> <code>cerebras/zai-glm-4.7</code> <code>google/gemini-3-flash</code> <code>openai/gpt-5.1-codex-mini</code>
  158:       <b>Recommended Models:</b> <code>openai/gpt-5.2-codex</code> <code>kimi-for-coding/k2p5</code>
  189:       <b>Recommended Models:</b> <code>google/gemini-3-flash</code> <code>openai/gpt-5.1-codex-mini</code>
  220:       <b>Recommended Models:</b> <code>google/gemini-3-flash</code>
  251:       <b>Recommended Models:</b> <code>cerebras/zai-glm-4.7</code> <code>google/gemini-3-flash</code> <code>openai/gpt-5.1-codex-mini</code>

.\agents\designer.md:
  56: - Define data models and flow patterns
  136: - Fallback options: [description]

.\agents\librarian.md:
  183: - Do not return environment briefs, model analysis, architecture commentary, or phased status updates.

.\cache\bun.lock:
  32:     "@modelcontextprotocol/sdk": ["@modelcontextprotocol/sdk@1.26.0", "", { "dependencies": { "@hono/node-server": "^1.19.9", "ajv": "^8.17.1", "ajv-formats": "^3.0.1", "content-type": "^1.0.5", "cors": "^2.8.5", "cross-spawn": "^7.0.5", "eventsource": "^3.0.2", "eventsource-parser": "^3.0.0", "express": "^5.2.1", "express-rate-limit": "^8.2.1", "hono": "^4.11.4", "jose": "^6.1.3", "json-schema-typed": "^8.0.2", "pkce-challenge": "^5.0.0", "raw-body": "^3.0.0", "zod": "^3.25 || ^4.0", "zod-to-json-schema": "^3.25.1" }, "peerDependencies": { "@cfworker/json-schema": "^4.1.1" }, "optionalPeers": ["@cfworker/json-schema"] }, "sha512-Y5RmPncpiDtTXDbLKswIJzTqu2hyBKxTNsgKqKclDbhIgg1wgtf1fRuvxgTnRfcnxtvvgbIEcqUOzZrJ6iSReg=="],
  176:     "oh-my-opencode-slim": ["oh-my-opencode-slim@0.7.0", "", { "dependencies": { "@ast-grep/cli": "^0.40.0", "@modelcontextprotocol/sdk": "^1.25.1", "@opencode-ai/plugin": "^1.1.19", "@opencode-ai/sdk": "^1.1.19", "vscode-jsonrpc": "^8.2.0", "vscode-languageserver-protocol": "^3.17.5", "zod": "^4.1.8" }, "bin": { "oh-my-opencode-slim": "dist/cli/index.js" } }, "sha512-VxDrIPsc98GrHsbIE2swLhVO/F8eL2vnAsKJpTwAlr6qXGZjsyh1Q/+63B/1uynOjlAzg9vXWGr48wnVOsy5JQ=="],

.\agents\explorer.md:
  31:    - Extract precise values: `$.config.agents[*].model`
  33:    - Perfect for: extracting model assignments, config values, API endpoints
  34:    - Example: Get all fallback models → `$.fallback.chains.*`
  37:    - Find where "model" or "endpoint" appears
  44:    - Perfect for: tracing model usage, finding config references
  116:     "json_files_discovered": ["config/models.json", "config/agents.json"],
  132:   "task": "Extract agent model configuration",
  135:       "configuration_type": "agent_model",
  137:         {"name": "orchestrator", "model": "opencode/big-pickle", "provider": "opencode", "mcp": ["*"]},
  138:         {"name": "oracle", "model": "gemini-2.0-flash-001", "provider": "google", "mcp": ["*"]},
  139:         {"name": "fixer", "model": "kimi-k2.5", "provider": "moonshotai", "mcp": ["*"]}
  141:       "fallback_chains": {
  146:       "suggestions": ["Consider adding Gemini 2 Pro for orchestrator fallback"]
  153:     "total_models_found": 6,
  177: **Example 1: Finding all model configurations**
  179: ❌ WRONG: grep for '"model":' across all JSON files
  180: ✅ RIGHT: json_query_jsonpath with '$.presets.*.*.model'
  181: Result: Structured array of all agent model assignments
  187: ✅ RIGHT: json_query_search_keys for "model", "provider", "endpoint"
  191: **Example 3: Tracing where a specific model is used**

.\agents\orchestrator.md:
  53: - **json_query_jsonpath**: Extract model assignments, fallback chains, agent configurations
  55: - **json_query_search_values**: Trace where specific models are used
  104: 2. Configuration file review (relevant settings, models, agents)
  259: **Original Request**: "Optimize the agent model configuration for better performance"
  261: **Goal**: Discover all files that handle agent model assignments, fallback chains, and configuration loading
  270:   - `/models/`
  277: 2. Model fallback chain definitions
  281: - User wants to optimize agent models
  283: - We need to understand what models are assigned to each agent
  292: - @librarian will fetch docs for any unknown models you find
  303: Task @oracle: Analyze current agent model configuration
  311: **Original Request**: "The user wants to understand if the current agent model configuration is optimal"
  316: - All agent model assignments in `oh-my-opencode-theseus.json`
  317: - Fallback chains for all 5 agents
  321: 1. Critical gaps (missing fallbacks, unverified models)
  323: 3. Optimization opportunities (better model pairings)
  327:   - Orchestrator: big-pickle (fallback: kimI-k2.5, glm-4.7, pony-alpha, claude-opus-4-6)
  328:   - Oracle: Gemini 2.0 Flash (fallback: pony-alpha, kimi-k2-thinking, glm-4.7, claude-opus-4-6)
  329:   - Fixer: Kimi K2.5 (fallback: claude-opus-4-6)
  334: - Don't recommend models not in the database
  340: - @librarian will fetch docs for recommended models
  360: **Original Request**: "Find GPT-5 model benchmarks for agent task assignment"
  362: **Goal**: Gather official benchmark data for GPT-5 Pro and GPT-5.2 models
  365: - Official OpenAI documentation for GPT-5 models
  375: - User is evaluating models for agent tasks
  419:   "task": "Extract model configuration data",
  421:     "configuration_type": "<agent_model|fallback_chain|mcp_config>",
  425:         "model": "<model>",
  430:     "fallback_chains": {
  431:       "<agent>": ["<primary>", "<fallback1>", "<fallback2>"]
  444:   "task": "Research model benchmarks",
  446:     "models_covered": ["<model1>", "<model2>"],
  743: If a toast/error says `Model error: Unable to connect`, immediately retry the same prompt once.
  745: - Apply to both primary user-model prompts and subagent prompts.
  747: - If retry fails, continue normal fallback/escalation behavior.
  888: **Change**: Update orchestrator model from big-pickle to claude-opus-4-6
  893: - Critical fallback - user needs reliability
  901: - Depends on: models_available.json (claude-opus-4-6 data)
  913: **Change**: Move claude-opus-4-6 from fallback[3] to fallback[1] for orchestrator
  921: - oracle_analysis: "claude-opus-4-6 is most verified - should be first fallback"
  923: - Fallback chain analysis complete
  929: - orchestrator.fallback[0] → "anthropic/claude-opus-4-6"
  1105: | @explorer  | File discovery, codebase mapping                                                       | SWARM: 1 per model/family/research_stream | Read-only                                                 |
  1120: - One @explorer per model family/benchmark category
  1128: Task @explorer: Research all 160 Tier 3 models
  1131: ## Task: @explorer (Microsoft Phi models)
  1133: **Original Request**: "Research Tier 3 models for budget agent deployment"
  1138: - Files: Phi-4 model benchmarks in models_available.json
  1140: - Exclude: Tier 1 and 2 models
  1153: - Only open-weight models
  1169: Task @oracle: Analyze current agent model configuration
  1179: - Agent model assignments (orchestrator, oracle, fixer, designer, explorer, librarian)
  1180: - Fallback chains for all 6 agents
  1184: 1. Critical: Missing or single-point-of-failure fallbacks
  1197: - Don't recommend models outside database
  1240: When investigating agent configurations, model assignments, or fallback chains:
  1242: 1. Use **json_query_jsonpath** to extract all model assignments: `$.presets.*.*.model`
  1243: 2. Use **json_query_search_values** to trace specific models: Search "claude-opus"
  1244: 3. Use **json_query_search_keys** to discover config structure: Search "fallback", "provider"
  1249: Task @explorer: Extract agent models from oh-my-opencode-theseus.json
  1253: - Goal: Get current model assignments for analysis
  1254: - Scope: oh-my-opencode-theseus.json, presets.*.*.model
  1303: - Use **json_query_search_values** to trace specific model/config references

.\models\ACTION_PLAN.md:
  1: # Action Plan: Completing models_available.json Benchmark Data
  5: Your file contains **171 models** across the LLM ecosystem, but **0% have complete benchmark data** (all fields are currently null placeholders except what I initially filled).
  12: 4. ✅ Identified major data sources for each model family
  14: 6. ✅ Identified models_available.json accurately represents 171 models
  18: You'll need to systematically fill benchmark data for each model. Here's the breakdown:
  20: ### Priority Level 1: Flagship Models (Top 15) - 2-4 hours
  54: ### Priority Level 2: Important Open Models (20-30 models) - 4-6 hours
  80: ### Priority Level 3: Extended Ecosystem (50+ models) - 8-12 hours
  84:   - Phi models (Phi-3, Phi-4, etc.)
  87:   - Molmo2 models (vision-language)
  90:   - Ernie models
  92: Open models:
  96:   - Openchat models
  111: **Models covered**: Qwen3 (0.6B-235B), Qwen2.5 (0.5B-72B), Llama, Gemma, DeepSeek
  123: Real-time leaderboards with 100+ models:
  131: ### **4. Model-Specific HuggingFace Cards**
  132: Search: `https://huggingface.co/{org}/{model-name}`
  140: Search template: `site:arxiv.org "{model-name}" benchmark`
  142: Most official models published with full results tables
  154: **https://openrouter.ai/models**
  159: - Model availability
  164: 1. Divide models into groups by provider
  174:    - Check huggingface.co model cards
  180: 1. Use my RESEARCH_GUIDE.md to prioritize models
  181: 2. Spend 4-6 hours filling Top 15 models manually (best sources)
  182: 3. Use scripts for Level 2-3 models
  187: Each model entry should have:
  191:   "model-name": {
  246: 3. Start with Priority Level 1 (15 models)
  274: with open('models_available.json') as f:
  275:     models = json.load(f)
  277: # Update a model
  278: models['meta/llama-3-1-405b']['metrics']['reasoning']['MMLU'] = 88.6
  279: models['meta/llama-3-1-405b']['metrics']['coding']['HumanEval'] = 88.0
  280: models['meta/llama-3-1-405b']['metrics']['performance']['Context_Window'] = 128000
  283: with open('models_available_updated.json', 'w') as f:
  284:     json.dump(models, f, indent=2)
  292: - **Priority 1 (15 models)**: 2-4 hours (official sources are clear)
  293: - **Priority 2 (25 models)**: 4-6 hours (good paper documentation)
  294: - **Priority 3 (131 models)**: 8-12 hours (mixed sources, need interpolation)
  301: 1. Cross-reference multiple sources for top 50 models
  302: 2. Verify consistency (e.g., MMLU shouldn't be 0-10% for >8B models)
  309: 2. ✅ **models_available.json** - Your original file (unchanged)
  310: 3. ✅ **QUICK_REFERENCE_GUIDE.md** - Reference for top models
  315: The goal is to have **complete benchmark data for all 171 models** to make this a production-ready reference that:
  316: - Can be used for model selection decisions
  321: The data exists - it just needs to be systematically collected from sources. My RESEARCH_GUIDE.md gives you the exact sources for each model family.
  325: **Recommendation**: Use Option C (Hybrid) - manually do the top 15 models yourself (they're easiest), then script the rest.

.\models\agent_model_intelligence.json:
  2:   "task": "Update Agent Models Intelligence",
  4:     "models_covered": [
  37:       "file:///C:/Users/paulc/.config/opencode/.backups/MODELS_recommended.md",
  38:       "file:///C:/Users/paulc/.config/opencode/models/QUICK_REFERENCE_GUIDE.md",
  43:       "Some recommended models (e.g., opencode/big-pickle) lack public benchmark data in standard repos"

.\models\AGENTS.md:
  5: This file provides essential guidance for agents working within the OpenCode models directory. This is a critical component of the OpenCode ecosystem focused on comprehensive LLM benchmarking and agent coordination.
  39: - Always backup models_available.json before modifications
  41: - Format: `models_available_backup_YYYYMMDD_HHMMSS.json`
  45: You are an agent operating within the **OpenCode models directory** (`~/.config/opencode/models/`). This is the central hub for:
  47: - **Model benchmark database** - Comprehensive performance data for 171 LLMs
  48: - **Agent coordination** - Model selection and task assignment optimization  
  56: - **Benchmark data management** - Updating models_available.json with new performance data
  57: - **Model research** - Finding and validating benchmark scores from official sources
  58: - **Agent optimization** - Selecting optimal models for specific tasks based on performance metrics
  60: - **Performance analysis** - Analyzing trends and providing model recommendations
  64: ~/.config/opencode/models/                # Current directory (benchmark database)
  65: ├── models_available.json               # MAIN DATABASE - 201+ LLMs with 27 benchmarks
  67: │   └── models_available_backup_YYYYMMDD_HHMMSS.json
  72: ├── QUICK_REFERENCE_GUIDE.md            # Top models decision guide
  79: - `models_available.json` - Complete benchmark database with 171 models, 27 metrics across 8 categories
  88: - `QUICK_REFERENCE_GUIDE.md` - Decision matrices for model selection
  93: - **Coordinate**: All benchmark database updates and model research activities
  94: - **Delegate**: Use appropriate specialists for different model families or research tasks
  95: - **Verify**: Changes maintain data integrity and consistency across the 171-model database
  99: - **Discover**: New model releases and benchmark data sources across the web
  101: - **Analyze**: Benchmark trends and model family performance patterns
  105: - **Advise**: On model selection strategies based on benchmark data analysis
  106: - **Analyze**: Performance trends and cost-benefit optimization across model categories
  107: - **Strategize**: Optimal agent-model pairings for specific task types
  118: - **Improve**: Decision matrices and model selection interfaces
  126: - **Test**: Benchmark data integrity and model recommendation algorithms
  131: - Total Models: 201+ LLMs (expanded from 171)
  133: - Metrics per Model: 27 individual performance indicators
  137: - Tier 1 (Flagship): ✅ COMPLETED - 15 models with verified data
  138: - Tier 2 (Important Open): ✅ COMPLETED - 25 models added
  139: - Tier 3 (Extended): ~131 models remaining (future scope)
  140: - Current Database: ~25% complete for most important models
  143: - Strategic foundation of 40 most-critical models established
  152: **models_available.json contains 171 models across 8 evaluation categories:**
  165: 1. **Identify Data Gaps** - Check COMPLETION_STATUS.txt for priority models
  169: 5. **Verify Consistency** - Check against similar models and expected performance ranges
  174: - MMLU: 60-95% (typical for models >8B parameters)
  182: - Premium models: $3-30 per million tokens
  183: - Budget models: $0.05-2 per million tokens
  184: - Free models: $0 (marked as null or 0.0)
  188: - Latency: 40-400ms (faster for smaller models)
  193: ### Model Performance Research
  195: - Validate new model releases against official documentation
  199: ### Agent-Model Optimization
  200: - Analyze task requirements vs model capabilities
  201: - Recommend optimal agent-model pairings based on benchmark data
  203: - Monitor emerging model capabilities and update recommendations
  206: - Regular updates for new model releases (monthly)
  212: - Identify performance trends across model families
  228: - **Always** validate against official model documentation when available
  229: - **Always** check COMPLETION_STATUS.txt for priority models and current progress
  232: - **Always** test model recommendations against known use cases
  239: - **@explorer**: Finds new data sources and validates model releases
  257: 3. Verify model versions and parameter counts
  261: 1. Prioritize official model documentation over third-party leaderboards
  272: **Model Identification:**
  273: 1. Use exact model names from official documentation
  275: 3. Distinguish between model versions and variants
  281: - Total Models: 171 language models
  283: - Metrics per Model: 27 individual performance indicators
  287: - Models with complete data: ~5% (frontier models)
  288: - Models with partial data: ~15% (important open models)
  289: - Priority for completion: Top 50 models for agent optimization
  298: ## 🔧 MODEL SELECTION GUIDANCE
  303: - Use models with >90% MMLU and >80% SWE-Bench
  308: - Use models with 85-90% MMLU and 60-75% SWE-Bench  
  313: - Use models with <100ms latency and >80% MMLU
  320: - Prioritize models with best quality-to-cost ratios
  353: - **Specialization**: Models optimizing for specific capabilities (coding, reasoning, speed)
  357: **Remember**: This directory houses the OpenCode ecosystem's central model intelligence resource. Every update here impacts agent performance across the entire system. Prioritize data accuracy, document your sources, and coordinate with other agents for comprehensive coverage.
  359: For research methodologies, consult `RESEARCH_GUIDE.md`. For current project status, check `COMPLETION_STATUS.txt`. For model selection guidance, use `QUICK_REFERENCE_GUIDE.md`.
  361: **Quality over quantity**: A well-researched, validated dataset for 50 key models is more valuable than incomplete data for all 171 models.

.\skills\cartography\SKILL.md:
  224: | `src/agents/` | Defines agent personalities (Orchestrator, Explorer) and manages model routing. | [View Map](src/agents/codemap.md) |

.\models\BENCHMARK_DOCUMENTATION.md:
  4: This document explains the comprehensive benchmark data compiled in `models_available.json` as of February 2026. The file contains performance metrics for 171 language models across 8 major evaluation categories.
  17:   - Status: Saturated (top models ≥88%)
  47:   - Status: Saturated (top models ≥90%)
  157:   - Maximum tokens model can generate per request
  165:   - Faster models: Haiku (45ms), Gemini (120-150ms)
  166:   - Slower models: Opus (180-200ms), GPT-5 Pro (400ms)
  172:   - Faster models achieve 80-100 tokens/sec
  173:   - Slower models: 35-60 tokens/sec
  198: Measures model safety, trustworthiness, and error rates.
  204:   - ASL-3 models (Claude Opus 4) have enhanced resistance
  210:   - Claude models: typically low hallucination rates
  216:   - ASL-2 (standard): Claude 3.5, most models
  244: ### Model Specializations
  282: - Official model papers and technical reports
  297: 6. **Non-English**: Models have varying multilingual performance not fully captured here
  301: ## Using This Data for Model Selection
  326: - Model: Claude Opus 4.5
  332: - Model: Claude Haiku 4.5
  338: - Model: Deepseek V3.2 or Gemini 3 Pro
  344: - Model: Gemini 3 Pro, Deepseek V3.2, or Kimi K2.5
  354: - Monthly: Monitor new model releases
  359: **Known Models Missing Detailed Benchmarks:**
  360: - Smaller open-source models (<10B parameters)
  362: - Proprietary enterprise models without public benchmarks
  368: - **Official Model Cards**: Check provider documentation for latest scores
  371: - **OpenRouter Pricing**: Always current model pricing
  372: - **ArXiv Papers**: Official technical reports from model creators
  378: **File Size**: ~230KB (171 models × 8 categories)

.\skills\model-tester\SKILL.md:
  2: name: model-tester
  3: description: Test OpenRouter models manually and add failures to triage. Use when user asks to test models, check model availability, or verify API keys.
  6: # Model Tester Skill
  8: Tests OpenRouter models from `opencode.json` configuration and adds failed models to the triage list in `oh-my-opencode-theseus.json`.
  12: - User asks to "test models", "check models", or "verify API"
  14: - User asks to "send failed models to triage"
  15: - User asks to "check model availability"
  21: Read `opencode.json` to get the provider configuration and models:
  31:       "models": {
  32:         "model/id:free": { "name": "Display Name" }
  39: ### Step 2: Test Each Model
  41: Use curl to test each model:
  49:   -d "{\"model\": \"MODEL_ID\", \"messages\": [{\"role\": \"user\", \"content\": \"Say OK\"}], \"max_tokens\": 5}"
  56: | 200 | Success | Model works |
  57: | 400 | Bad request | Model may be deprecated |
  60: | 403 | Forbidden | Model unavailable |
  61: | 404 | Not found | Model doesn't exist |
  68: Read `oh-my-opencode-theseus.json`, find the `fallback.triage` section, and add failed models:
  72:   "provider-id/model:id": {
  81: The failureCount and lastFailure are used by the circuit breaker to automatically recover models over time.
  86: # Test a single model
  92:   -d "{\"model\": \"openrouter/free\", \"messages\": [{\"role\": \"user\", \"content\": \"Say OK\"}], \"max_tokens\": 5}"
  98: - A response with HTTP 200 means the model is functional
  99: - The triage system automatically recovers models after enough time passes

.\models\codemap.md:
  1: # models/

.\models\CHANGELOG.md:
  1: # Model Configuration Changelog
  7: - Updated `oh-my-opencode-theseus.json` to include `openai/gpt-5.2` in fallback chains for all agents.
  8: - Primary models remain unchanged (Gemini 3 Pro / Claude Opus 4.6).
  9: - `openai/gpt-5.2` added as a high-priority fallback option due to its strong reasoning capabilities (92.4% GPQA Diamond).
  12: - `models/CHANGELOG.md` to track model configuration changes.

.\skills\update-openai-agent-models\SKILL.md:
  2: name: update-openai-agent-models
  3: description: Fast-path OpenAI-only agent chain update. Use when user says "update agent models for OpenAI" or asks to adjust OpenAI tiers by current usage.
  6: # Update OpenAI Agent Models Skill
  9: - "update agent models for OpenAI"
  10: - "adjust OpenAI models based on usage"
  11: - "re-tier OpenAI models"
  22:   - `node skills/update-agent-models/run-workflow.js --openai-only`
  24:   - `node skills/update-agent-models/run-workflow.js --openai-only --dry-run`
  30: - Writes proposal in `skills/update-agent-models/proposals/theseus-update.*.json`.

.\cache\models.json:
  1: [Omitted long matching line]

.\skills\update-agent-models\apply-auto-accepted.js:
  40:   const accepted = fs.existsSync(ACCEPTED_PATH) ? loadJson(ACCEPTED_PATH) : { models: {} };
  41:   const patch = proposal.model_benchmark_patch || {};
  49:   accepted.models = accepted.models || {};
  52:   for (const [modelId, entry] of autoAccepted) {
  53:     if (accepted.models[modelId]) continue;
  54:     accepted.models[modelId] = {
  55:       name: entry?.name || modelId,

.\models\config\sources.json:
  10:         "model_details": "/model/{model_id}"
  14:         "model_row": "tr.model-row",
  16:         "model_name": ".model-name",
  43:         "models": "/models",
  44:         "model_by_id": "/models/{model_id}",
  50:         "HTTP-Referer": "https://github.com/opencode/models",
  51:         "X-Title": "OpenCode Model Benchmark"
  69:       "name": "HuggingFace Model Hub",
  72:       "api_url": "https://huggingface.co/api/models",
  75:         "model_card": "/{model_id}",
  76:         "api_models": "/models",
  77:         "model_info": "/api/models/{model_id}"
  80:         "model_card": "#model-card",
  82:         "specs_table": ".model-specs",
  101:       "name": "Microsoft Azure AI Model Catalog",
  106:         "models": "/models",
  107:         "model_details": "/models/{model_id}"
  122:         "model_specs",
  133:         "models": "/projects/{project_id}/locations/{location}/models",
  134:         "model_versions": "/projects/{project_id}/locations/{location}/models/{model_id}/versions"
  149:         "model_specs",
  179:         "model_announcements"
  215:     "models_file": "models_available_staging.json",

.\skills\update-google-agent-models\SKILL.md:
  2: name: update-google-agent-models
  3: description: Fast-path Google/Gemini-only agent chain update. Use when user says "Update Gemini Agent Models", "Update Gemnini Agent Models", or "Update Google Agent Models".
  6: # Update Google Agent Models Skill
  9: - "Update Gemini Agent Models"
  10: - "Update Gemnini Agent Models"
  11: - "Update Google Agent Models"
  12: - "Google quota is exceeded, re-tier models"
  23:   - `node skills/update-agent-models/run-workflow.js --google-only`
  25:   - `node skills/update-agent-models/run-workflow.js --google-only --dry-run`
  29: - Refreshes Google/Gemini model health and quota status.
  30: - Re-optimizes chains with Google health penalties and unhealthy-model suppression.
  31: - Writes proposal in `skills/update-agent-models/proposals/theseus-update.*.json`.

.\models\Backups\models_available_backup_20230211_123456.json:
  3:     "description": "Open-source model from the OpenCode initiative",
  65:       "Reduced capabilities vs larger models",

.\models\Backups\codemap.md:
  1: # models/Backups/

.\models\config\codemap.md:
  1: # models/config/

.\models\Backups\models_available_backup_20230211_120000.json:
  3:     "description": "Open-source model from the OpenCode initiative",
  65:       "Reduced capabilities vs larger models",

.\models\COMPLETION_SUMMARY.md:
  1: # MODEL DATABASE COMPLETION SUMMARY
  2: **Systematic Model-by-Model Completion Completed Successfully**
  4: **Database:** models_available.json (220+ models)
  10: ### **Systematic Model-by-Model Workflow Completed**
  11: ✅ **44+ Models Completed** with ALL 27 benchmark metrics
  14: ✅ **Alignment Safety Metrics** added to all completed models
  21: ### **1. Claude Family (Anthropic) - 3 Models**
  22: | Model | MMLU | GPQA | SWE-Bench | HumanEval | Safety Score |
  29: - Complete 27-benchmark coverage for all Claude models
  33: ### **2. OpenAI Family - 5 Models**  
  34: | Model | MMLU | GPQA | SWE-Bench | HumanEval | Safety Score |
  43: - Added complete new model entries for o1 and o3 series
  47: ### **3. Google Gemini Family - 4 Models**
  48: | Model | MMLU | GPQA | SWE-Bench | HumanEval | Safety Score |
  57: - 1M token context windows across all Gemini models
  60: ### **4. DeepSeek Family - 3 Models**
  61: | Model | MMLU | GPQA | SWE-Bench | HumanEval | Safety Score |
  68: - Added new DeepSeek V2.5 model with complete metrics
  72: ### **5. Meta Llama Family - 4 Models**
  73: | Model | MMLU | GPQA | SWE-Bench | HumanEval | Safety Score |
  82: - Updated all Llama models with 128K context windows
  90: - **JSON Structure:** ✅ Valid across all 220+ models
  93: - **Cross-Reference:** ✅ Multiple sources per model family
  116: | Models with Complete Data | ~15 | 44+ | +193% |
  123: - **Total Models:** 171 → 220+ (+29% growth)
  124: - **Complete Models:** 15 → 44+ (+193% growth)
  125: - **Benchmark Coverage:** 20% → 100% on completed models
  132: ### **Model-by-Model Completion Template**
  134: 2. **Planning Phase:** Create detailed model completion roadmap
  135: 3. **Execution Phase:** Deploy @fixer agents (1 per model) with research data
  141: - **Multi-Source Verification:** Cross-reference 2-3 sources per model
  154:    - Verify hallucination rates for Claude and Gemini models
  155:    - Add missing Max_Output_Tokens for various models
  159:    - Apply systematic workflow to remaining ~176 models
  160:    - Focus on emerging and specialized model families
  164: - **Complete Database Coverage:** All 220+ models with 27 benchmarks
  165: - **Real-Time Updates:** Automated monitoring for new model releases
  166: - **Advanced Analytics:** Model recommendation algorithms based on use cases
  174: - ✅ **44 Models** with complete 27-benchmark coverage
  175: - ✅ **220+ Total Models** in database (29% expansion)
  177: - ✅ **50+ Verified Sources** across all model families
  185: - ✅ **Strategic Foundation** for agent-model optimization
  191: The systematic model-by-model completion workflow is now established, validated, and ready for scaling to complete the remaining ~176 models in the database. The comprehensive benchmark coverage, safety metrics integration, and quality assurance processes provide a solid foundation for achieving full database completion.
  193: **Next Milestone:** Complete Tier 3 extended models using the proven systematic workflow to achieve 100% database coverage.
  197: **Status:** ✅ SYSTEMATIC MODEL-BY-MODEL COMPLETION PHASE COMPLETED  

.\models\COMPLETION_STATUS.txt:
  2: MODELS_AVAILABLE.JSON - RESEARCH COMPLETION STATUS
  12:    - 172 models enhanced with comprehensive infrastructure data
  14:    - New capabilities field added with 6 boolean flags per model
  15:    - Alignment safety data populated for 2 high-priority models
  16:    - 47 unmatched models identified for future resolution
  19: ✅ SYSTEMATIC MODEL-BY-MODEL COMPLETION COMPLETED
  20:    - 44+ models across 5 major provider families fully documented
  21:    - ALL 27 benchmark metrics populated for each completed model
  22:    - Comprehensive alignment safety metrics added to all completed models
  24:    - Systematic model-by-model workflow established and validated
  25:    - Database expanded to 220+ models with comprehensive benchmark coverage
  28:    - Tier 1 (15 flagship models): ✅ COMPLETED
  29:    - Tier 2 (25 important open models): ✅ COMPLETED  
  30:    - Extended Provider Families: ✅ 44+ MODELS COMPLETED
  31:    - Infrastructure Data Enhancement: ✅ 78% (172/220 models enhanced)
  32:    - Overall Database Completion: ✅ 22% (44/201 models with full benchmarks)
  33:    - Tier 3 (~160 extended models): ⏳ NEXT PHASE PRIORITY
  36:    - Continue Tier 3 extended models with systematic workflow
  37:    - Apply model-by-model completion methodology to remaining families
  39:    - Expand coverage to full 201+ model database
  46: 1. ✅ 172 models enhanced with TUI infrastructure data
  47: 2. ✅ New capabilities field added (6 boolean flags per model):
  52: 5. ✅ Alignment safety data added for 2 models (Claude-4 Opus, GPT-5.2)
  53: 6. ✅ 47 unmatched models cataloged for future resolution
  56: 7. ✅ Complete benchmark data for 44+ models across 5 major provider families
  57: 8. ✅ Database expanded to 220+ models across 35+ providers
  59: 10. ✅ Alignment safety metrics added to all completed models
  61: 12. ✅ Systematic model-by-model workflow established
  62: 13. ✅ Strategic foundation for agent-model optimization established
  69:   - Models with 100% complete data: 44+ (ALL 27 benchmarks each)
  70:   - Models with infrastructure data: 172/220 (78% enhanced from TUI)
  71:   - Models with capabilities flags: 172 models (6 flags each)
  72:   - Models with verified benchmark data: 44+ across 5 provider families
  73:   - Total database size: 220+ models (expanded from original 171)
  78:   ✅ Phase 1 Foundation: 40 models complete (Tiers 1-2)
  79:   ✅ Phase 2 Systematic Completion: 44+ models complete (5 provider families)
  80:   ✅ Phase 3 Model-by-Model: COMPLETED with systematic methodology
  81:   ✅ Phase 4 Infrastructure Enhancement: 172/220 models enhanced (78%)
  85:   - Flagship & Important Models: 44 models ✅ COMPLETE
  86:   - Infrastructure-Enhanced Models: 172 models ✅ ENHANCED
  88:   - Extended Ecosystem: ~157 models remaining
  90:   - Critical Models Coverage: ~44% (44/100 most important models)
  91:   - Unmatched Models: 47 (awaiting TUI name resolution)
  106: Coverage: 172/220 models (78% of database)
  107: Source: TUI (Terminal User Interface) model registry synchronization
  110: Models Updated: 2 high-priority models
  116:   - Context windows: 8K to 2M tokens (model-specific)
  119:   - Capabilities flags: 6 boolean indicators per model
  125: TIER 1: Flagship Models - 15 models
  128: Models Complete:
  145: TIER 2: Important Open Models - 25 models
  148: Models Complete:
  155:   ✅ Mixtral models
  157: EXTENDED PROVIDER FAMILIES - 44+ MODELS COMPLETED
  160: ✅ CLAUDE FAMILY (Anthropic) - 3 Models
  165: ✅ OPENAI FAMILY - 5 Models
  169:    ✅ o1 (reasoning model, 27 benchmarks)
  170:    ✅ o3 (reasoning model, 27 benchmarks)
  172: ✅ GOOGLE GEMINI FAMILY - 4 Models
  178: ✅ DEEPSEEK FAMILY - 3 Models
  183: ✅ META LLAMA FAMILY - 4 Models
  187: Total Extended Models: 19 additional models (27 benchmarks each)
  188: Total All Completed: 44+ models with comprehensive data
  190: TIER 3: Extended Ecosystem & Emerging Models - ~160 models
  191: Status: ⏳ IN PROGRESS (15 models added this session)
  194:   - Extended model families and variants
  195:   - Emerging model releases
  196:   - Specialized and regional models
  197:   - Research and experimental models
  200:   - Phi models
  201:   - Gemma models
  202:   - Falcon models
  203:   - Molmo2 models
  205:   - Openchat models
  206:   - New model releases since database creation
  214: 1. Resolve 47 unmatched models (TUI name → database name mapping)
  215: 2. Continue with Tier 3 extended models for full benchmark coverage
  216: 3. Populate remaining benchmark scores for infrastructure-enhanced models
  220: 5. Focus on emerging model families and recent releases
  222: 7. Expand alignment safety metrics to additional models beyond Tier 1-2
  225:   - 47 unmatched models awaiting TUI name resolution
  226:   - ~48 models without infrastructure data (220 - 172 enhanced)
  227:   - ~176 models without full benchmark coverage (220 - 44 complete)
  228:   - Alignment safety data needed for extended model set
  230: Progress: Strategic foundation established with 40 critical models complete.
  231: Infrastructure enhancement: 172/220 models (78%) with TUI data synchronized.
  232: Next: Resolve unmatched models and complete remaining ~160 model benchmarks.

.\models\QUICK_REFERENCE_GUIDE.md:
  1: # LLM Model Quick Reference - Top Models (February 2026)
  2: *Updated with systematically completed benchmark data from 44+ models*
  4: ## Frontier Models (Highest Performance)
  6: | Model | MMLU | GPQA | SWE-Bench | HumanEval | Math | Context | Input Cost | Output Cost | Best For |
  16: ## Professional Grade Models
  18: | Model | MMLU | GPQA | SWE-Bench | HumanEval | Math | Context | Input Cost | Output Cost | Best For |
  28: ## Fast & Efficient Models
  30: | Model | MMLU | GPQA | SWE-Bench | HumanEval | Speed (TTFT) | Throughput | Input Cost | Output Cost | Best For |
  42: | Model | Context | MMLU | Math | Cost | Special Feature |
  98: | Model | Annual Cost (1B tokens/month) | Quality Rating | Best Use |
  114: START: Choosing an LLM Model
  140: | Model | Input Cost | Output Cost | Total | Use Case |
  198: - **Total Models Evaluated**: 171
  199: - **Frontier Models (Top-tier)**: 4
  213: - Claude models (official Anthropic benchmarks)
  215: - Gemini models (official Google research)
  219: - Some proprietary models with limited public data
  220: - Newer models with <2 weeks evaluation history
  221: - Open-source models benchmark-dependent
  226: **Data Source**: Official model documentation + LLM-Stats.com + Vellum Leaderboards

.\skills\openai-usage\SKILL.md:
  23: - No manual fallback. If Codex rate limits are unavailable, return an actionable error.

.\models\VERIFICATION_REPORT_20260212.md:
  2: # models_available.json - Comprehensive Analysis
  8: **Total Models:** 220
  10: **Models Verified:** 40+ priority models across all major providers
  16: - All required fields present for each model
  18: - Consistent structure across all 220 model entries
  25: **Models Affected:**
  29: **Analysis:** Both values are within 0-100 range, but 48% hallucination rate seems unusually high for these models. Typical range should be 5-15%.
  34: **Models with Very High GPQA (>90%):**
  41: **Analysis:** GPQA Diamond is PhD-level difficulty. Scores >90% are exceptional but plausible for flagship models. Verify against official publications.
  48: **Anomaly:** Some models show high reasoning but unexpectedly low SWE-Bench
  55: **Expected:** Gap should typically be 15-30 points for well-rounded models
  67: **Status:** Most models show reasonable gaps (15-25 points)
  70: **Anomaly:** High-performance models with unexpectedly low latency
  75:   - Typical pattern: High reasoning models have TPS 50-100
  96: **Free Models with Good Performance (Data Quality Check):**
  118: **Typical Pattern:** Max_Output should be 8K-64K for most models
  123: **Many models have null values:**
  152: **Many models lack latency/TPS data:**
  155: - Many older models lack these metrics
  159: ## 7. SPECIFIC MODEL VERIFICATION
  161: ### ✅ VERIFIED MODELS (Data Looks Consistent):
  163: **Claude Models:**
  168: **Google Gemini Models:**
  174: **OpenAI Models:**
  178: - `openrouter/openai/o3`: Latest reasoning model, premium pricing
  180: **DeepSeek Models:**
  184: **Meta Llama Models:**
  188: ### ❌ MODELS NEEDING ATTENTION:
  199: Most flagship models have safety metrics populated
  228: 6. **Fill missing Max_Output_Tokens** for many models (currently null)
  229: 7. **Add missing latency/TPS data** for older models
  234: 10. **Add estimated_notes for models lacking documentation**
  235: 11. **Standardize null vs 0 for free models' costs**
  236: 12. **Review cost ratios** for legacy models (GPT-4 Turbo)
  244: - ✅ Most flagship models have complete data
  251: - ⚠️ Hallucination rates for some models seem unusually high
  252: - ⚠️ Missing performance metrics for many older models
  264: 7. Model family consistency checks
  268: - Original JSON file (220 models)
  269: - Model family patterns (Claude, GPT, Gemini, Llama, DeepSeek)
  284: **Models Analyzed:** 220

.\models\Backups\models_available_20260211_2047.json:
  3:     "description": "Open-source model from the OpenCode initiative",
  65:       "Reduced capabilities vs larger models",
  115:     "description": "Free version of Kimi K2.5 model from Moonshot AI",
  171:     "description": "Free version of MiniMax M2.1 model",
  227:     "description": "Free preview version of Trinity Large model from Arcee AI",
  230:       "Large model capabilities"
  283:     "description": "Latest version of Claude 3.5 Haiku - fast and efficient model for everyday tasks",
  291:       "Smaller context window than larger models"
  404:       "Higher latency than smaller models",
  454:     "description": "Claude 3 Haiku from March 2024 - fastest and most compact Claude 3 model",
  511:     "description": "Claude 3 Opus from February 2024 - most capable Claude 3 model",
  625:     "description": "Claude 4 series Haiku model - efficient and fast",
  633:       "Smaller context than flagship models"
  682:     "description": "Claude 4 Opus initial release - flagship intelligence model",
  739:     "description": "Claude 4.1 Opus - refined flagship model",
  747:       "Slower than smaller models"
  967:     "description": "Claude Sonnet 4.5 - enhanced balanced model",
  1024:     "description": "Open-source 120B parameter GPT model optimized on Cerebras hardware",
  1081:     "description": "Qwen 3 235B parameter model with A22B architecture, instruction-tuned",
  1138:     "description": "GLM 4.7 model optimized for Cerebras infrastructure",
  1194:     "description": "Llama 4 Scout 17B parameter model optimized for Groq inference",
  1308:     "description": "Faster version of Kimi K2 thinking model",
  1316:       "Still slower than standard models"
  1365:     "description": "Preview version of Kimi K2 Turbo - fast inference model",
  1480:     "description": "Free tier Molmo 2 8B multimodal model from Allen AI",
  1538:     "description": "Free preview of Trinity Large model from Arcee AI",
  1541:       "Large model capabilities",
  1604:       "Smaller model size",
  1654:     "description": "Flux 2 Flex - flexible image generation model",
  1712:     "description": "Flux 2 Klein - compact 4B parameter image generation model",
  1719:       "Limited detail vs larger models",
  1886:     "description": "SeeDream 4.5 - ByteDance's image generation mod

... (truncated)
```
