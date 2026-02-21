# Tool Output: tool_c68258bfa0018EBDunIQiamz8Z
**Date**: 2026-02-16 20:30:17 UTC
**Size**: 256,936 bytes

```

C:/Users/paulc/.config/opencode\CHANGELOG.md:
  7: - **Connectivity Error Detection**: Updated `background-manager.ts` to recognize "typo in the url or port" and "unable to connect" as retryable provider errors.

C:/Users/paulc/.config/opencode\AGENTS.md:
  262: Configure automatic model fallback when primary models fail due to provider errors.
  282: - **Provider errors** (rate limits, context length, service unavailable) trigger fallback

C:/Users/paulc/.config/opencode\codemap.md:
  35: - `opencode.json` - Main OpenCode settings (providers, plugins, MCP servers, permissions)
  37: - Preset files (recommended, openai, antigravity) for different provider configurations
  47: ### Provider Abstraction
  48: - Providers are configured in `opencode.json` under the top-level `provider` object (custom providers) alongside OpenCode's built-in provider support.
  54: - Models are enumerated under each provider's `models` map with human-readable names; model selection uses `provider_id/model_id` (e.g. `google/gemini-2.5-pro`).
  59: 1. OpenCode reads `opencode.json` on startup → loads plugin, providers, MCP servers
  101: ### External Providers
  102: - OpenRouter Free provider configured as `free/openrouter/free`.
  103: - Google AI Studio provider configured as `google/<gemini-model-id>` (Gemini 3 preview + Gemini 2.5 family, plus deprecated Gemini 2.0 entries).
  104: - API keys are stored in `opencode.json` provider options (not in `oh-my-opencode-theseus.json`).

C:/Users/paulc/.config/opencode\agent_install.md:
  33: 3.  **Authenticate**: If you enabled providers like Kimi, OpenAI, or Google, ensure you are logged in:

C:/Users/paulc/.config/opencode\opencode.json:
  13:   "provider": {

C:/Users/paulc/.config/opencode\README.md:
  28: The installer can refresh and use OpenCode free models directly:
  42: OpenCode free-model mode uses `opencode models --refresh --verbose`, filters to free `opencode/*` models, and applies coding-first selection:
  45: - In hybrid mode, `designer` stays on the external provider mapping.
  65: - **[Antigravity Setup](docs/antigravity.md)** - Complete guide for Antigravity provider configuration  
  263: - **[Antigravity Setup](docs/antigravity.md)** - Complete guide for Antigravity provider configuration

C:/Users/paulc/.config/opencode\agents\explorer.md:
  137:         {"name": "orchestrator", "model": "opencode/big-pickle", "provider": "opencode", "mcp": ["*"]},
  138:         {"name": "oracle", "model": "gemini-2.0-flash-001", "provider": "google", "mcp": ["*"]},
  139:         {"name": "fixer", "model": "kimi-k2.5", "provider": "moonshotai", "mcp": ["*"]}
  154:     "providers_covered": ["openrouter", "cerebras", "moonshotai", "anthropic"]
  187: ✅ RIGHT: json_query_search_keys for "model", "provider", "endpoint"

C:/Users/paulc/.config/opencode\local_share\auth.json:
  7:     "type": "oauth",
  8:     "refresh": "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",
  25:     "type": "oauth",
  26:     "refresh": "rt_HFwTdlahzjjC4rhCHbxDJ4kFwjZoY5g5U-POOUV-Ecc.XWJHakjUI9Bkkj7sU-NBoz2T3YZXVuvVu8_0uYkKSug",
  40:     "type": "oauth",
  41:     "refresh": "1//06cokc5g22Jo7CgYIARAAGAYSNwF-L9IrSjvyOBMX6cK2opcfl19gXvT8NKGVLgObBhRpvzHsIEZygkhVqqQCfqod2EkHdczTkFo|",

C:/Users/paulc/.config/opencode\agents\orchestrator.md:
  69: Phase 0: LIBRARIAN → Phase 1: SETUP → Phase 2: INVESTIGATE → Phase 3: PLAN (Oracle + Designer + Orchestrator) → [USER APPROVAL] → Phase 4: BUILD → Phase 5: VERIFY → [FIX LOOP] → Phase 6: CARTOGRAPHY REFRESH → Phase 7: CONFIRM → Phase 8: DOCUMENT → Phase 9: LIBRARIAN → DONE
  426:         "provider": "<provider>",
  447:     "providers": ["<provider1>", "<provider2>"],
  965: ### Phase 6: CARTOGRAPHY REFRESH (Mandatory Before User Completion)
  970: 2. Refresh codemaps for all affected directories
  972: 4. If this workflow included additional Orchestrator-managed changes after the main build, refresh again before final completion message
  976: - Do not skip Cartography refresh even when code verification passes.
  1108: | @librarian | Documentation, API specs                                                               | SWARM: 1 per topic/provider/source        | Read-only                                                 |
  1121: - One @librarian per provider/documentation source
  1244: 3. Use **json_query_search_keys** to discover config structure: Search "fallback", "provider"

C:/Users/paulc/.config/opencode\models\AGENTS.md:
  134: - Providers Covered: 35+ major LLM providers and research labs
  207: - Quarterly comprehensive benchmark refreshes
  274: 2. Include provider prefixes (openai/, anthropic/, google/, etc.)
  284: - Providers Covered: 35+ major LLM providers and research labs

C:/Users/paulc/.config/opencode\skills\model-tester\SKILL.md:
  13: - User asks to "test opencode.json" or "test providers"
  21: Read `opencode.json` to get the provider configuration and models:
  25:   "provider": {
  72:   "provider-id/model:id": {

C:/Users/paulc/.config/opencode\models\ACTION_PLAN.md:
  164: 1. Divide models into groups by provider

C:/Users/paulc/.config/opencode\skills\openai-usage\check-openai-usage.js:
  126:       params: { refreshToken: false },

C:/Users/paulc/.config/opencode\skills\cartography\codemap.md:
  18: 4. Persist state: `cartographer.py update --root ./` refreshes hashes and stamps `metadata.last_run`.
  22: - Invoked by the primary agent workflow after code/config changes (Cartography refresh phase).

C:/Users/paulc/.config/opencode\models\BENCHMARK_DOCUMENTATION.md:
  294: 3. **Latency Variability**: TTFT varies with load, geography, and provider
  295: 4. **Methodological Differences**: Different providers may use slight evaluation variations
  368: - **Official Model Cards**: Check provider documentation for latest scores

C:/Users/paulc/.config/opencode\skills\cartography\SKILL.md:
  148: 7. **Scope purity check**: remove claims about unrelated directories/providers/frameworks not present in local files.
  165: 2. Produce/refresh codemap content for each target directory.

C:/Users/paulc/.config/opencode\skills\update-openai-agent-models\SKILL.md:
  28: - Refreshes OpenAI usage/rate-limit snapshot.

C:/Users/paulc/.config/opencode\models\agent_model_intelligence.json:
  13:     "providers": [

C:/Users/paulc/.config/opencode\models\COMPLETION_SUMMARY.md:
  12: ✅ **5 Major Provider Families** comprehensively documented  
  19: ## 📊 COMPLETED PROVIDER FAMILIES
  117: | Provider Families Covered | 2-3 | 5 | +67% |
  178: - ✅ **5 Provider Families** comprehensively documented

C:/Users/paulc/.config/opencode\skills\update-google-agent-models\SKILL.md:
  29: - Refreshes Google/Gemini model health and quota status.

C:/Users/paulc/.config/opencode\models\COMPLETION_STATUS.txt:
  20:    - 44+ models across 5 major provider families fully documented
  30:    - Extended Provider Families: ✅ 44+ MODELS COMPLETED
  56: 7. ✅ Complete benchmark data for 44+ models across 5 major provider families
  57: 8. ✅ Database expanded to 220+ models across 35+ providers
  72:   - Models with verified benchmark data: 44+ across 5 provider families
  79:   ✅ Phase 2 Systematic Completion: 44+ models complete (5 provider families)
  87:   - Provider Family Coverage: 5/35+ families (14%)
  157: EXTENDED PROVIDER FAMILIES - 44+ MODELS COMPLETED

C:/Users/paulc/.config/opencode\models\MODEL_MAPPING_REPORT.txt:
  14: === BREAKDOWN BY PROVIDER ===

C:/Users/paulc/.config/opencode\models\RESEARCH_GUIDE.md:
  4: Your models_available.json contains 220+ models, with 44+ models having complete 27-benchmark data. This guide provides the systematic model-by-model approach that successfully completed major provider families.
  15: ### Provider Family Completion Strategy
  138: 2. Official provider APIs
  140: 4. Cloud provider pricing pages
  152: 4. Cloud provider dashboards
  167: ### Step 2: Categorize by Provider
  169: providers = {}
  171:     provider = model.split('/')[0]
  172:     if provider not in providers:
  173:         providers[provider] = []
  174:     providers[provider].append(model)
  176: for provider, models_list in sorted(providers.items()):
  177:     print(f"{provider}: {len(models_list)} models")
  180: ### Step 3: Research by Provider Group
  181: For each provider group, use the sources listed above to gather data
  406: **Solution**: Always check official provider + OpenRouter for current rates

C:/Users/paulc/.config/opencode\models\model_tui_mapping_detailed.json:
  234:   "summary_by_provider": {

C:/Users/paulc/.config/opencode\models\tui_models_extraction_report.json:
  7:     {"name": "Big Pickle", "provider": "opencode", "status": "active"},
  8:     {"name": "GPT-5 Nano", "provider": "opencode", "status": "active"},
  9:     {"name": "Kimi K2.5 Free", "provider": "opencode", "status": "active"},
  10:     {"name": "MiniMax M2.1 Free", "provider": "opencode", "status": "active"},
  11:     {"name": "Trinity Large Preview", "provider": "opencode", "status": "active"},
  12:     {"name": "Claude Haiku 3.5", "provider": "anthropic", "status": "active"},
  13:     {"name": "Claude Haiku 3.5 (latest)", "provider": "anthropic", "status": "active"},
  14:     {"name": "Claude Sonnet 3.5", "provider": "anthropic", "status": "active"},
  15:     {"name": "Claude Sonnet 3.5 v2", "provider": "anthropic", "status": "active"},
  16:     {"name": "Claude Sonnet 3.7", "provider": "anthropic", "status": "active"},
  17:     {"name": "Claude Sonnet 3.7 (latest)", "provider": "anthropic", "status": "active"},
  18:     {"name": "Claude Haiku 3", "provider": "anthropic", "status": "active"},
  19:     {"name": "Claude Opus 3", "provider": "anthropic", "status": "active"},
  20:     {"name": "Claude Sonnet 3", "provider": "anthropic", "status": "active"},
  21:     {"name": "Claude Haiku 4.5 (latest)", "provider": "anthropic", "status": "active"},
  22:     {"name": "Claude Haiku 4.5", "provider": "anthropic", "status": "active"},
  23:     {"name": "Claude Opus 4 (latest)", "provider": "anthropic", "status": "active"},
  24:     {"name": "Claude Opus 4.1 (latest)", "provider": "anthropic", "status": "active"},
  25:     {"name": "Claude Opus 4.1", "provider": "anthropic", "status": "active"},
  26:     {"name": "Claude Opus 4", "provider": "anthropic", "status": "active"},
  27:     {"name": "Claude Opus 4.5 (latest)", "provider": "anthropic", "status": "active"},
  28:     {"name": "Claude Opus 4.5", "provider": "anthropic", "status": "active"},
  29:     {"name": "Claude Opus 4.6", "provider": "anthropic", "status": "active"},
  30:     {"name": "Claude Sonnet 4 (latest)", "provider": "anthropic", "status": "active"},
  31:     {"name": "Claude Sonnet 4", "provider": "anthropic", "status": "active"},
  32:     {"name": "Claude Sonnet 4.5 (latest)", "provider": "anthropic", "status": "active"},
  33:     {"name": "Claude Sonnet 4.5", "provider": "anthropic", "status": "active"},
  34:     {"name": "GPT OSS 120B", "provider": "cerebras", "status": "active"},
  35:     {"name": "Llama 3.1 8B", "provider": "cerebras", "status": "active"},
  36:     {"name": "Qwen 3 235B Instruct", "provider": "cerebras", "status": "active"},
  37:     {"name": "Z.AI GLM-4.7", "provider": "cerebras", "status": "active"},
  38:     {"name": "Gemini 1.5 Flash", "provider": "google", "status": "active"},
  39:     {"name": "Gemini 1.5 Flash-8B", "provider": "google", "status": "active"},
  40:     {"name": "Gemini 1.5 Pro", "provider": "google", "status": "active"},
  41:     {"name": "Gemini 2.0 Flash", "provider": "google", "status": "active"},
  42:     {"name": "Gemini 2.0 Flash Lite", "provider": "google", "status": "active"},
  43:     {"name": "Gemini 2.0 Flash Thinking", "provider": "google", "status": "active"},
  44:     {"name": "Gemini 2.0 Pro", "provider": "google", "status": "active"},
  45:     {"name": "Gemini 2.5 Flash", "provider": "google", "status": "active"},
  46:     {"name": "Gemini 2.5 Pro", "provider": "google", "status": "active"},
  47:     {"name": "Gemini 3 Flash", "provider": "google", "status": "active"},
  48:     {"name": "Gemini 3 Pro", "provider": "google", "status": "active"},
  49:     {"name": "Gemini 3 Thinking", "provider": "google", "status": "active"},
  50:     {"name": "Gemini 3 Ultra", "provider": "google", "status": "active"},
  51:     {"name": "Llama 3.1 8B Instant", "provider": "groq", "status": "active"},
  52:     {"name": "Llama 3.3 70B Versatile", "provider": "groq", "status": "active"},
  53:     {"name": "Llama 4 Scout", "provider": "groq", "status": "active"},
  54:     {"name": "Llama 4 Maverick", "provider": "groq", "status": "active"},
  55:     {"name": "Mixtral 8x7B", "provider": "groq", "status": "active"},
  56:     {"name": "Qwen QwQ 32B", "provider": "groq", "status": "active"},
  57:     {"name": "Gemma 2 9B IT", "provider": "groq", "status": "active"},
  58:     {"name": "Qwen 2.5 32B", "provider": "groq", "status": "active"},
  59:     {"name": "Kimi K2 0711", "provider": "moonshotai", "status": "active"},
  60:     {"name": "Kimi K2 0905", "provider": "moonshotai", "status": "active"},
  61:     {"name": "Kimi K2.5", "provider": "moonshotai", "status": "active"},
  62:     {"name": "Kimi K2.5 Thinking", "provider": "moonshotai", "status": "active"},
  63:     {"name": "Kimi K2.5 Flash Thinking", "provider": "moonshotai", "status": "active"},
  64:     {"name": "Kimi K2.5 Short", "provider": "moonshotai", "status": "active"}
  66:   "provider_breakdown": {
  77:   "tui_output_capture": "Complete verbose output captured with 296 models across 9 providers. Output includes: id, providerID, name, family, API configuration (id, url, npm package), status, headers, options, cost structure (input, output, cache read/write), limits (context, output, input), capabilities (temperature, reasoning, attachment, toolcall, input/output formats), release_date, and variants. All data stored in tui_models_verbose.json (316KB)",
  139:       "provider",

C:/Users/paulc/.config/opencode\skills\cartography\scripts\codemap.md:
  28:    - re-hashes selected files/folders and refreshes `metadata.last_run`
  33: - Output is consumed by the operator/agent to decide which directory codemaps to refresh.

C:/Users/paulc/.config/opencode\models\VERIFICATION_REPORT_20260212.md:
  10: **Models Verified:** 40+ priority models across all major providers

C:/Users/paulc/.config/opencode\cache\models.json:
  1: [Omitted long matching line]

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmarks\benchmark-setups.md:
  261: - **API Keys:** Copy `.env.example` to `.env` and fill in LLM keys (supports any provider via [LiteLLM](https://github.com/LiteLLM/LiteLLM)【43†L443-L452】). E.g.:

C:/Users/paulc/.config/opencode\models\models_available.json:
  6010:     "description": "NVIDIA Nemotron 3 Nano 30B A3B is a small language MoE model with highest compute efficiency and accuracy for developers to build specialized agentic AI systems.\n\nThe model is fully open with open-weights, datasets and recipes so developers can easily\ncustomize, optimize, and deploy the model on their infrastructure for maximum privacy and\nsecurity.\n\nNote: For the free endpoint, all prompts and output are logged to improve the provider's model and its product and services. Please do not upload any personal, confidential, or otherwise sensitive information. This is a trial use only. Do not use for production or business-critical systems.",
  10656:     "description": "Grok 3 is the latest model from xAI. It's their flagship model that excels at enterprise use cases like data extraction, coding, and text summarization. Possesses deep domain knowledge in finance, healthcare, law, and science.\n\nExcels in structured tasks and benchmarks like GPQA, LCB, and MMLU-Pro where it outperforms Grok 3 Mini even on high thinking. \n\nNote: That there are two xAI endpoints for this model. By default when using this model we will always route you to the base endpoint. If you want the fast endpoint you can add `provider: { sort: throughput}`, to sort by throughput instead. \n",
  10787:     "description": "Grok 3 Mini is a lightweight, smaller thinking model. Unlike traditional models that generate answers immediately, Grok 3 Mini thinks before responding. It’s ideal for reasoning-heavy tasks that don’t demand extensive domain knowledge, and shines in math-specific and quantitative use cases, such as solving challenging puzzles or math problems.\n\nTransparent \"thinking\" traces accessible. Defaults to low reasoning, can boost with setting `reasoning: { effort: \"high\" }`\n\nNote: That there are two xAI endpoints for this model. By default when using this model we will always route you to the base endpoint. If you want the fast endpoint you can add `provider: { sort: throughput}`, to sort by throughput instead. \n",

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmark_manual_accepted.json.backup.1771246190333.json:
  27:           "provider": "zai",

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmarks\gpqa\gpqa_openrouter_install.md:
  145: - Consider lowering concurrency unless you know the provider allows parallelism.

C:/Users/paulc/.config/opencode\models\tui_models_verbose.json:
  4:   "providerID": "opencode",
  64:   "providerID": "opencode",
  144:   "providerID": "opencode",
  196:   "providerID": "opencode",
  246:   "providerID": "opencode",
  296:   "providerID": "anthropic",
  345:   "providerID": "anthropic",
  394:   "providerID": "anthropic",
  443:   "providerID": "anthropic",
  492:   "providerID": "anthropic",
  554:   "providerID": "anthropic",
  616:   "providerID": "anthropic",
  665:   "providerID": "anthropic",
  714:   "providerID": "anthropic",
  763:   "providerID": "anthropic",
  825:   "providerID": "anthropic",
  887:   "providerID": "anthropic",
  949:   "providerID": "anthropic",
  1011:   "providerID": "anthropic",
  1073:   "providerID": "anthropic",
  1135:   "providerID": "anthropic",
  1197:   "providerID": "anthropic",
  1259:   "providerID": "anthropic",
  1321:   "providerID": "anthropic",
  1383:   "providerID": "anthropic",
  1445:   "providerID": "anthropic",
  1507:   "providerID": "anthropic",
  1569:   "providerID": "cerebras",
  1628:   "providerID": "cerebras",
  1677:   "providerID": "cerebras",
  1726:   "providerID": "cerebras",
  1774:   "providerID": "google",
  1823:   "providerID": "google",
  1872:   "providerID": "google",
  1921:   "providerID": "google",
  1970:   "providerID": "google",
  2019:   "providerID": "google",
  2081:   "providerID": "google",
  2143:   "providerID": "google",
  2205:   "providerID": "google",
  2267:   "providerID": "google",
  2329:   "providerID": "google",
  2391:   "providerID": "google",
  2453:   "providerID": "google",
  2515:   "providerID": "google",
  2577:   "providerID": "google",
  2626:   "providerID": "google",
  2688:   "providerID": "google",
  2750:   "providerID": "google",
  2812:   "providerID": "google",
  2861:   "providerID": "google",
  2927:   "providerID": "google",
  2993:   "providerID": "google",
  3042:   "providerID": "google",
  3100:   "providerID": "google",
  3158:   "providerID": "google",
  3220:   "providerID": "google",
  3282:   "providerID": "groq",
  3331:   "providerID": "groq",
  3380:   "providerID": "groq",
  3429:   "providerID": "groq",
  3478:   "providerID": "groq",
  3527:   "providerID": "groq",
  3576:   "providerID": "groq",
  3642:   "providerID": "groq",
  3708:   "providerID": "groq",
  3774:   "providerID": "moonshotai",
  3824:   "providerID": "moonshotai",
  3874:   "providerID": "moonshotai",
  3926:   "providerID": "moonshotai",
  3978:   "providerID": "moonshotai",
  4028:   "providerID": "moonshotai",
  4080:   "providerID": "openai",
  4151:   "providerID": "openai",
  4200:   "providerID": "openai",
  4249:   "providerID": "openai",
  4298:   "providerID": "openai",
  4347:   "providerID": "openai",
  4396:   "providerID": "openai",
  4445:   "providerID": "openai",
  4494:   "providerID": "openai",
  4543:   "providerID": "openai",
  4592:   "providerID": "openai",
  4641:   "providerID": "openai",
  4690:   "providerID": "openai",
  4769:   "providerID": "openai",
  4841:   "providerID": "openai",
  4920:   "providerID": "openai",
  4999:   "providerID": "openai",
  5049:   "providerID": "openai",
  5128:   "providerID": "openai",
  5206:   "providerID": "openai",
  5278:   "providerID": "openai",
  5350:   "providerID": "openai",
  5422:   "providerID": "openai",
  5508:   "providerID": "openai",
  5593:   "providerID": "openai",
  5672:   "providerID": "openai",
  5758:   "providerID": "openai",
  5837:   "providerID": "openai",
  5908:   "providerID": "openai",
  5979:   "providerID": "openai",
  6050:   "providerID": "openai",
  6121:   "providerID": "openai",
  6192:   "providerID": "openai",
  6263:   "providerID": "openai",
  6334:   "providerID": "openai",
  6405:   "providerID": "openai",
  6476:   "providerID": "openai",
  6547:   "providerID": "openai",
  6596:   "providerID": "openai",
  6645:   "providerID": "openai",
  6694:   "providerID": "openrouter",
  6700:     "npm": "@openrouter/ai-sdk-provider"
  6744:   "providerID": "openrouter",
  6750:     "npm": "@openrouter/ai-sdk-provider"
  6794:   "providerID": "openrouter",
  6800:     "npm": "@openrouter/ai-sdk-provider"
  6844:   "providerID": "openrouter",
  6850:     "npm": "@openrouter/ai-sdk-provider"
  6894:   "providerID": "openrouter",
  6900:     "npm": "@openrouter/ai-sdk-provider"
  6944:   "providerID": "openrouter",
  6950:     "npm": "@openrouter/ai-sdk-provider"
  6994:   "providerID": "openrouter",
  7000:     "npm": "@openrouter/ai-sdk-provider"
  7044:   "providerID": "openrouter",
  7050:     "npm": "@openrouter/ai-sdk-provider"
  7102:   "providerID": "openrouter",
  7108:     "npm": "@openrouter/ai-sdk-provider"
  7160:   "providerID": "openrouter",
  7166:     "npm": "@openrouter/ai-sdk-provider"
  7218:   "providerID": "openrouter",
  7224:     "npm": "@openrouter/ai-sdk-provider"
  7268:   "providerID": "openrouter",
  7274:     "npm": "@openrouter/ai-sdk-provider"
  7318:   "providerID": "openrouter",
  7324:     "npm": "@openrouter/ai-sdk-provider"
  7368:   "providerID": "openrouter",
  7374:     "npm": "@openrouter/ai-sdk-provider"
  7418:   "providerID": "openrouter",
  7424:     "npm": "@openrouter/ai-sdk-provider"
  7468:   "providerID": "openrouter",
  7474:     "npm": "@openrouter/ai-sdk-provider"
  7518:   "providerID": "openrouter",
  7524:     "npm": "@openrouter/ai-sdk-provider"
  7568:   "providerID": "openrouter",
  7574:     "npm": "@openrouter/ai-sdk-provider"
  7618:   "providerID": "openrouter",
  7624:     "npm": "@openrouter/ai-sdk-provider"
  7668:   "providerID": "openrouter",
  7674:     "npm": "@openrouter/ai-sdk-provider"
  7718:   "providerID": "openrouter",
  7724:     "npm": "@openrouter/ai-sdk-provider"
  7768:   "providerID": "openrouter",
  7774:     "npm": "@openrouter/ai-sdk-provider"
  7818:   "providerID": "openrouter",
  7824:     "npm": "@openrouter/ai-sdk-provider"
  7868:   "providerID": "openrouter",
  7874:     "npm": "@openrouter/ai-sdk-provider"
  7918:   "providerID": "openrouter",
  7924:     "npm": "@openrouter/ai-sdk-provider"
  7968:   "providerID": "openrouter",
  7974:     "npm": "@openrouter/ai-sdk-provider"
  8018:   "providerID": "openrouter",
  8024:     "npm": "@openrouter/ai-sdk-provider"
  8068:   "providerID": "openrouter",
  8074:     "npm": "@openrouter/ai-sdk-provider"
  8118:   "providerID": "openrouter",
  8124:     "npm": "@openrouter/ai-sdk-provider"
  8168:   "providerID": "openrouter",
  8174:     "npm": "@openrouter/ai-sdk-provider"
  8218:   "providerID": "openrouter",
  8224:     "npm": "@openrouter/ai-sdk-provider"
  8268:   "providerID": "openrouter",
  8274:     "npm": "@openrouter/ai-sdk-provider"
  8318:   "providerID": "openrouter",
  8324:     "npm": "@openrouter/ai-sdk-provider"
  8368:   "providerID": "openrouter",
  8374:     "npm": "@openrouter/ai-sdk-provider"
  8418:   "providerID": "openrouter",
  8424:     "npm": "@openrouter/ai-sdk-provider"
  8468:   "providerID": "openrouter",
  8474:     "npm": "@openrouter/ai-sdk-provider"
  8518:   "providerID": "openrouter",
  8524:     "npm": "@openrouter/ai-sdk-provider"
  8568:   "providerID": "openrouter",
  8574:     "npm": "@openrouter/ai-sdk-provider"
  8618:   "providerID": "openrouter",
  8624:     "npm": "@openrouter/ai-sdk-provider"
  8668:   "providerID": "openrouter",
  8674:     "npm": "@openrouter/ai-sdk-provider"
  8718:   "providerID": "openrouter",
  8724:     "npm": "@openrouter/ai-sdk-provider"
  8768:   "providerID": "openrouter",
  8774:     "npm": "@openrouter/ai-sdk-provider"
  8818:   "providerID": "openrouter",
  8824:     "npm": "@openrouter/ai-sdk-provider"
  8901:   "providerID": "openrouter",
  8907:     "npm": "@openrouter/ai-sdk-provider"
  8984:   "providerID": "openrouter",
  8990:     "npm": "@openrouter/ai-sdk-provider"
  9034:   "providerID": "openrouter",
  9040:     "npm": "@openrouter/ai-sdk-provider"
  9084:   "providerID": "openrouter",
  9090:     "npm": "@openrouter/ai-sdk-provider"
  9134:   "providerID": "openrouter",
  9140:     "npm": "@openrouter/ai-sdk-provider"
  9184:   "providerID": "openrouter",
  9190:     "npm": "@openrouter/ai-sdk-provider"
  9234:   "providerID": "openrouter",
  9240:     "npm": "@openrouter/ai-sdk-provider"
  9284:   "providerID": "openrouter",
  9290:     "npm": "@openrouter/ai-sdk-provider"
  9334:   "providerID": "openrouter",
  9340:     "npm": "@openrouter/ai-sdk-provider"
  9384:   "providerID": "openrouter",
  9390:     "npm": "@openrouter/ai-sdk-provider"
  9434:   "providerID": "openrouter",
  9440:     "npm": "@openrouter/ai-sdk-provider"
  9484:   "providerID": "openrouter",
  9490:     "npm": "@openrouter/ai-sdk-provider"
  9534:   "providerID": "openrouter",
  9540:     "npm": "@openrouter/ai-sdk-provider"
  9584:   "providerID": "openrouter",
  9590:     "npm": "@openrouter/ai-sdk-provider"
  9634:   "providerID": "openrouter",
  9640:     "npm": "@openrouter/ai-sdk-provider"
  9684:   "providerID": "openrouter",
  9690:     "npm": "@openrouter/ai-sdk-provider"
  9734:   "providerID": "openrouter",
  9740:     "npm": "@openrouter/ai-sdk-provider"
  9784:   "providerID": "openrouter",
  9790:     "npm": "@openrouter/ai-sdk-provider"
  9834:   "providerID": "openrouter",
  9840:     "npm": "@openrouter/ai-sdk-provider"
  9884:   "providerID": "openrouter",
  9890:     "npm": "@openrouter/ai-sdk-provider"
  9934:   "providerID": "openrouter",
  9940:     "npm": "@openrouter/ai-sdk-provider"
  9984:   "providerID": "openrouter",
  9990:     "npm": "@openrouter/ai-sdk-provider"
  10034:   "providerID": "openrouter",
  10040:     "npm": "@openrouter/ai-sdk-provider"
  10086:   "providerID": "openrouter",
  10092:     "npm": "@openrouter/ai-sdk-provider"
  10138:   "providerID": "openrouter",
  10144:     "npm": "@openrouter/ai-sdk-provider"
  10188:   "providerID": "openrouter",
  10194:     "npm": "@openrouter/ai-sdk-provider"
  10238:   "providerID": "openrouter",
  10244:     "npm": "@openrouter/ai-sdk-provider"
  10288:   "providerID": "openrouter",
  10294:     "npm": "@openrouter/ai-sdk-provider"
  10338:   "providerID": "openrouter",
  10344:     "npm": "@openrouter/ai-sdk-provider"
  10388:   "providerID": "openrouter",
  10394:     "npm": "@openrouter/ai-sdk-provider"
  10438:   "providerID": "openrouter",
  10444:     "npm": "@openrouter/ai-sdk-provider"
  10488:   "providerID": "openrouter",
  10494:     "npm": "@openrouter/ai-sdk-provider"
  10538:   "providerID": "openrouter",
  10544:     "npm": "@openrouter/ai-sdk-provider"
  10588:   "providerID": "openrouter",
  10594:     "npm": "@openrouter/ai-sdk-provider"
  10638:   "providerID": "openrouter",
  10644:     "npm": "@openrouter/ai-sdk-provider"
  10688:   "providerID": "openrouter",
  10694:     "npm": "@openrouter/ai-sdk-provider"
  10738:   "providerID": "openrouter",
  10744:     "npm": "@openrouter/ai-sdk-provider"
  10788:   "providerID": "openrouter",
  10794:     "npm": "@openrouter/ai-sdk-provider"
  10838:   "providerID": "openrouter",
  10844:     "npm": "@openrouter/ai-sdk-provider"
  10888:   "providerID": "openrouter",
  10894:     "npm": "@openrouter/ai-sdk-provider"
  10938:   "providerID": "openrouter",
  10944:     "npm": "@openrouter/ai-sdk-provider"
  10988:   "providerID": "openrouter",
  10994:     "npm": "@openrouter/ai-sdk-provider"
  11038:   "providerID": "openrouter",
  11044:     "npm": "@openrouter/ai-sdk-provider"
  11090:   "providerID": "openrouter",
  11096:     "npm": "@openrouter/ai-sdk-provider"
  11140:   "providerID": "openrouter",
  11146:     "npm": "@openrouter/ai-sdk-provider"
  11192:   "providerID": "openrouter",
  11198:     "npm": "@openrouter/ai-sdk-provider"
  11242:   "providerID": "openrouter",
  11248:     "npm": "@openrouter/ai-sdk-provider"
  11292:   "providerID": "openrouter",
  11298:     "npm": "@openrouter/ai-sdk-provider"
  11342:   "providerID": "openrouter",
  11348:     "npm": "@openrouter/ai-sdk-provider"
  11392:   "providerID": "openrouter",
  11398:     "npm": "@openrouter/ai-sdk-provider"
  11442:   "providerID": "openrouter",
  11448:     "npm": "@openrouter/ai-sdk-provider"
  11492:   "providerID": "openrouter",
  11498:     "npm": "@openrouter/ai-sdk-provider"
  11542:   "providerID": "openrouter",
  11548:     "npm": "@openrouter/ai-sdk-provider"
  11592:   "providerID": "openrouter",
  11598:     "npm": "@openrouter/ai-sdk-provider"
  11642:   "providerID": "openrouter",
  11648:     "npm": "@openrouter/ai-sdk-provider"
  11692:   "providerID": "openrouter",
  11698:     "npm": "@openrouter/ai-sdk-provider"
  11742:   "providerID": "openrouter",
  11748:     "npm": "@openrouter/ai-sdk-provider"
  11823:   "providerID": "openrouter",
  11829:     "npm": "@openrouter/ai-sdk-provider"
  11904:   "providerID": "openrouter",
  11910:     "npm": "@openrouter/ai-sdk-provider"
  11985:   "providerID": "openrouter",
  11991:     "npm": "@openrouter/ai-sdk-provider"
  12066:   "providerID": "openrouter",
  12072:     "npm": "@openrouter/ai-sdk-provider"
  12147:   "providerID": "openrouter",
  12153:     "npm": "@openrouter/ai-sdk-provider"
  12228:   "providerID": "openrouter",
  12234:     "npm": "@openrouter/ai-sdk-provider"
  12309:   "providerID": "openrouter",
  12315:     "npm": "@openrouter/ai-sdk-provider"
  12390:   "providerID": "openrouter",
  12396:     "npm": "@openrouter/ai-sdk-provider"
  12471:   "providerID": "openrouter",
  12477:     "npm": "@openrouter/ai-sdk-provider"
  12552:   "providerID": "openrouter",
  12558:     "npm": "@openrouter/ai-sdk-provider"
  12633:   "providerID": "openrouter",
  12639:     "npm": "@openrouter/ai-sdk-provider"
  12714:   "providerID": "openrouter",
  12720:     "npm": "@openrouter/ai-sdk-provider"
  12795:   "providerID": "openrouter",
  12801:     "npm": "@openrouter/ai-sdk-provider"
  12876:   "providerID": "openrouter",
  12882:     "npm": "@openrouter/ai-sdk-provider"
  12957:   "providerID": "openrouter",
  12963:     "npm": "@openrouter/ai-sdk-provider"
  13038:   "providerID": "openrouter",
  13044:     "npm": "@openrouter/ai-sdk-provider"
  13119:   "providerID": "openrouter",
  13125:     "npm": "@openrouter/ai-sdk-provider"
  13200:   "providerID": "openrouter",
  13206:     "npm": "@openrouter/ai-sdk-provider"
  13281:   "providerID": "openrouter",
  13287:     "npm": "@openrouter/ai-sdk-provider"
  13362:   "providerID": "openrouter",
  13368:     "npm": "@openrouter/ai-sdk-provider"
  13443:   "providerID": "openrouter",
  13449:     "npm": "@openrouter/ai-sdk-provider"
  13493:   "providerID": "openrouter",
  13499:     "npm": "@openrouter/ai-sdk-provider"
  13543:   "providerID": "openrouter",
  13549:     "npm": "@openrouter/ai-sdk-provider"
  13593:   "providerID": "openrouter",
  13599:     "npm": "@openrouter/ai-sdk-provider"
  13643:   "providerID": "openrouter",
  13649:     "npm": "@openrouter/ai-sdk-provider"
  13693:   "providerID": "openrouter",
  13699:     "npm": "@openrouter/ai-sdk-provider"
  13743:   "providerID": "openrouter",
  13749:     "npm": "@openrouter/ai-sdk-provider"
  13793:   "providerID": "openrouter",
  13799:     "npm": "@openrouter/ai-sdk-provider"
  13843:   "providerID": "openrouter",
  13849:     "npm": "@openrouter/ai-sdk-provider"
  13893:   "providerID": "openrouter",
  13899:     "npm": "@openrouter/ai-sdk-provider"
  13943:   "providerID": "openrouter",
  13949:     "npm": "@openrouter/ai-sdk-provider"
  13993:   "providerID": "openrouter",
  13999:     "npm": "@openrouter/ai-sdk-provider"
  14043:   "providerID": "openrouter",
  14049:     "npm": "@openrouter/ai-sdk-provider"
  14093:   "providerID": "openrouter",
  14099:     "npm": "@openrouter/ai-sdk-provider"
  14143:   "providerID": "openrouter",
  14149:     "npm": "@openrouter/ai-sdk-provider"
  14193:   "providerID": "openrouter",
  14199:     "npm": "@openrouter/ai-sdk-provider"
  14243:   "providerID": "openrouter",
  14249:     "npm": "@openrouter/ai-sdk-provider"
  14293:   "providerID": "openrouter",
  14299:     "npm": "@openrouter/ai-sdk-provider"
  14343:   "providerID": "openrouter",
  14349:     "npm": "@openrouter/ai-sdk-provider"
  14393:   "providerID": "openrouter",
  14399:     "npm": "@openrouter/ai-sdk-provider"
  14443:   "providerID": "openrouter",
  14449:     "npm": "@openrouter/ai-sdk-provider"
  14493:   "providerID": "openrouter",
  14499:     "npm": "@openrouter/ai-sdk-provider"
  14543:   "providerID": "openrouter",
  14549:     "npm": "@openrouter/ai-sdk-provider"
  14593:   "providerID": "openrouter",
  14599:     "npm": "@openrouter/ai-sdk-provider"
  14643:   "providerID": "openrouter",
  14649:     "npm": "@openrouter/ai-sdk-provider"
  14693:   "providerID": "openrouter",
  14699:     "npm": "@openrouter/ai-sdk-provider"
  14743:   "providerID": "openrouter",
  14749:     "npm": "@openrouter/ai-sdk-provider"
  14793:   "providerID": "openrouter",
  14799:     "npm": "@openrouter/ai-sdk-provider"
  14843:   "providerID": "openrouter",
  14849:     "npm": "@openrouter/ai-sdk-provider"
  14893:   "providerID": "openrouter",
  14899:     "npm": "@openrouter/ai-sdk-provider"
  14943:   "providerID": "openrouter",
  14949:     "npm": "@openrouter/ai-sdk-provider"
  14993:   "providerID": "openrouter",
  14999:     "npm": "@openrouter/ai-sdk-provider"
  15043:   "providerID": "openrouter",
  15049:     "npm": "@openrouter/ai-sdk-provider"
  15093:   "providerID": "openrouter",
  15099:     "npm": "@openrouter/ai-sdk-provider"
  15143:   "providerID": "openrouter",
  15149:     "npm": "@openrouter/ai-sdk-provider"
  15193:   "providerID": "openrouter",
  15199:     "npm": "@openrouter/ai-sdk-provider"
  15243:   "providerID": "openrouter",
  15249:     "npm": "@openrouter/ai-sdk-provider"
  15293:   "providerID": "openrouter",
  15299:     "npm": "@openrouter/ai-sdk-provider"
  15343:   "providerID": "openrouter",
  15349:     "npm": "@openrouter/ai-sdk-provider"
  15393:   "providerID": "openrouter",
  15399:     "npm": "@openrouter/ai-sdk-provider"
  15454:   "providerID": "openrouter",
  15460:     "npm": "@openrouter/ai-sdk-provider"
  15515:   "providerID": "openrouter",
  15521:     "npm": "@openrouter/ai-sdk-provider"
  15565:   "providerID": "openrouter",
  15571:     "npm": "@openrouter/ai-sdk-provider"
  15615:   "providerID": "openrouter",
  15621:     "npm": "@openrouter/ai-sdk-provider"
  15665:   "providerID": "openrouter",
  15671:     "npm": "@openrouter/ai-sdk-provider"
  15715:   "providerID": "openrouter",
  15721:     "npm": "@openrouter/ai-sdk-provider"
  15765:   "providerID": "openrouter",
  15771:     "npm": "@openrouter/ai-sdk-provider"
  15815:   "providerID": "openrouter",
  15821:     "npm": "@openrouter/ai-sdk-provider"
  15865:   "providerID": "openrouter",
  15871:     "npm": "@openrouter/ai-sdk-provider"
  15915:   "providerID": "openrouter",
  15921:     "npm": "@openrouter/ai-sdk-provider"
  15965:   "providerID": "openrouter",
  15971:     "npm": "@openrouter/ai-sdk-provider"
  16015:   "providerID": "openrouter",
  16021:     "npm": "@openrouter/ai-sdk-provider"
  16065:   "providerID": "openrouter",
  16071:     "npm": "@openrouter/ai-sdk-provider"
  16117:   "providerID": "openrouter",
  16123:     "npm": "@openrouter/ai-sdk-provider"
  16169:   "providerID": "openrouter",
  16175:     "npm": "@openrouter/ai-sdk-provider"
  16221:   "providerID": "zai-coding-plan",
  16271:   "providerID": "zai-coding-plan",
  16321:   "providerID": "zai-coding-plan",
  16371:   "providerID": "zai-coding-plan",
  16421:   "providerID": "zai-coding-plan",
  16471:   "providerID": "zai-coding-plan",
  16521:   "providerID": "zai-coding-plan",
  16573:   "providerID": "zai-coding-plan",
  16623:   "providerID": "zai-coding-plan",

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmarks\ifbench\instructions.md:
  79:   - provider profiles (OpenRouter, etc.)
  101:     providers/
  158: ## 6) Provider profile: OpenRouter (Trinity‑Mini)
  196: # If your provider rejects seed, blank it:
  204: (Keep both in a provider example file like `configs/openrouter.env.example` but never commit `API_KEY`.)
  208: **Option 1 (recommended): add a provider-specific generator helper without modifying the submodule**
  210: Create `scripts/providers/generate_responses_openrouter.py` by copying upstream `vendor/IFBench/generate_responses.py` and applying a minimal patch:
  254: python scripts/providers/generate_responses_openrouter.py   --temperature "${TEMPERATURE:-0}"   --max-tokens "${MAX_TOKENS:-4096}"   --workers "${WORKERS:-8}"   --resume
  321: - Include generation params (temperature, max_tokens, seed if used) + model id + provider.
  351: 3) **Provider rejects `seed`**

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmarks.json:
  354:   "provider_reliability": {
  405:       "note": "Claude Opus 4.6 reserved exclusively for fixer agent - all other agents use OpenAI + free providers"

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmarks\aime\AIME_Benchmark_Windows_Install_Run.md:
  7: > - You have an **API key** for the model provider.  
  225: - For strict providers, you may need even smaller values.

C:/Users/paulc/.config/opencode\skills\update-agent-models\working_models.json:
  11:       "provider": "opencode",
  18:       "provider": "opencode",
  25:       "provider": "opencode",
  32:       "provider": "opencode",
  39:       "provider": "anthropic",
  46:       "provider": "anthropic",
  53:       "provider": "anthropic",
  60:       "provider": "anthropic",
  67:       "provider": "anthropic",
  74:       "provider": "anthropic",
  81:       "provider": "anthropic",
  88:       "provider": "anthropic",
  95:       "provider": "anthropic",
  102:       "provider": "anthropic",
  109:       "provider": "anthropic",
  116:       "provider": "anthropic",
  123:       "provider": "anthropic",
  130:       "provider": "anthropic",
  137:       "provider": "anthropic",
  144:       "provider": "anthropic",
  151:       "provider": "anthropic",
  158:       "provider": "anthropic",
  165:       "provider": "anthropic",
  172:       "provider": "anthropic",
  179:       "provider": "anthropic",
  186:       "provider": "google-vertex",
  193:       "provider": "google-vertex",
  200:       "provider": "google-vertex",
  207:       "provider": "google-vertex",
  214:       "provider": "google-vertex",
  221:       "provider": "google-vertex",
  228:       "provider": "google-vertex",
  235:       "provider": "google-vertex",
  242:       "provider": "google-vertex",
  249:       "provider": "google-vertex",
  256:       "provider": "google-vertex",
  263:       "provider": "google-vertex",
  270:       "provider": "google-vertex",
  277:       "provider": "google-vertex",
  284:       "provider": "google-vertex",
  291:       "provider": "google-vertex",
  298:       "provider": "google-vertex",
  305:       "provider": "google-vertex",
  312:       "provider": "google-vertex",
  319:       "provider": "google-vertex",
  326:       "provider": "google-vertex",
  333:       "provider": "google-vertex",
  340:       "provider": "google-vertex",
  347:       "provider": "google-vertex",
  354:       "provider": "huggingface",
  361:       "provider": "huggingface",
  368:       "provider": "huggingface",
  375:       "provider": "huggingface",
  382:       "provider": "huggingface",
  389:       "provider": "huggingface",
  396:       "provider": "huggingface",
  403:       "provider": "huggingface",
  410:       "provider": "huggingface",
  417:       "provider": "huggingface",
  424:       "provider": "huggingface",
  431:       "provider": "huggingface",
  438:       "provider": "huggingface",
  445:       "provider": "huggingface",
  452:       "provider": "huggingface",
  459:       "provider": "huggingface",
  466:       "provider": "huggingface",
  473:       "provider": "kimi-for-coding",
  480:       "provider": "kimi-for-coding",
  487:       "provider": "lmstudio-local",
  494:       "provider": "lmstudio-local",
  501:       "provider": "openai",
  508:       "provider": "openai",
  515:       "provider": "openai",
  522:       "provider": "openai",
  529:       "provider": "openai",
  536:       "provider": "openai",
  543:       "provider": "openai",
  550:       "provider": "openai",
  557:       "provider": "openai",
  564:       "provider": "openrouter",
  571:       "provider": "openrouter",
  578:       "provider": "openrouter",
  585:       "provider": "openrouter",
  592:       "provider": "openrouter",
  599:       "provider": "openrouter",
  606:       "provider": "openrouter",
  613:       "provider": "openrouter",
  620:       "provider": "openrouter",
  627:       "provider": "zai-coding-plan",
  634:       "provider": "zai-coding-plan",
  641:       "provider": "zai-coding-plan",
  648:       "provider": "zai-coding-plan",
  655:       "provider": "zai-coding-plan",
  662:       "provider": "zai-coding-plan",
  669:       "provider": "zai-coding-plan",
  676:       "provider": "zai-coding-plan",
  683:       "provider": "zai-coding-plan",

C:/Users/paulc/.config/opencode\skills\update-agent-models\test-models.sh:
  17:     local provider="$1"
  18:     python - "$AUTH_FILE" "$provider" <<'PY'
  21: path, provider = sys.argv[1], sys.argv[2]
  25:     entry = data.get(provider, {})
  32: # Also get keys from opencode.json provider config
  33: get_opencode_provider_key() {
  34:     local provider="$1"
  35:     python - "$provider" <<'PY'
  38: provider = sys.argv[1]
  43:     provider_config = data.get("provider", {}).get(provider, {})
  44:     api_key = provider_config.get("options", {}).get("apiKey", "")
  58: [ -z "$OPENROUTER_API_KEY" ] && OPENROUTER_API_KEY="$(get_opencode_provider_key free)"
  65: [ -z "$LMSTUDIO_API_KEY" ] && LMSTUDIO_API_KEY="$(get_opencode_provider_key lmstudio-local)"
  69: # Additional provider API keys
  76: PROVIDER_CACHE_DIR="$PROPOSAL_DIR/.provider-model-cache"
  77: mkdir -p "$PROVIDER_CACHE_DIR"
  454: is_blocked_provider() {
  455:     local provider="$1"
  456:     case "$provider" in
  488:     provider="${model_id%%/*}"
  491:     if is_blocked_provider "$provider"; then
  493:         echo "⏭️  $model_id (blocked provider)"
  502:     case "$provider" in
  553:             # For unknown providers, try a generic approach or skip
  574:         case "$provider" in
  631:                 # For unknown providers, trust phase 1
  672:         echo -n "    \"$m\": {\"lastVerified\": $TIMESTAMP, \"successCount\": 1, \"failureCount\": 0, \"provider\": \"$p\", \"displayName\": \"$m\"}"

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmarks\ifbench\ifbench-platform\scripts\run_ifbench.sh:
  85: python scripts/providers/generate_responses_openrouter.py "${GEN_ARGS[@]}"

C:/Users/paulc/.config/opencode\skills\update-agent-models\SKILL.md:
  85: 2. Refresh working models:
  88: 3. Refresh OpenAI usage budget proposal:
  101:    - **Run benchmarks**: `node skills/update-agent-models/run-benchmarks.js --model <provider/model> --benchmarks <comma-separated-list>`
  107:    - Search queries must target official sources (Hugging Face, GitHub, arXiv, provider docs)
  148:   - `node skills/update-agent-models/run-workflow.js --skip-model-refresh`
  150:   - `node skills/update-agent-models/run-workflow.js --refresh-research`
  173:   - Validates AA provider config exists in `opencode.json`
  179:   - Tests available provider models and writes a proposal file in `skills/update-agent-models/proposals/`
  272:    - **Priority sources**: Hugging Face, GitHub repos, paperswithcode.com, arXiv, official provider docs
  296:    - Only for models where provider ID doesn't map 1:1 to known benchmarks
  324:       query: `${model.name} benchmark GPQA MMLU ${model.provider}`,
  341: - Use `--skip-model-refresh` only for debugging/local iteration where stale model health is acceptable.
  374: ## Keys and Provider Configuration
  378: - Artificial Analysis provider should be configured in:
  384: Some providers/models do not publish academic benchmark results. In that case we run the benchmarks ourselves and then record the resulting metric via the normal acceptance workflow.
  534: - Provider preference
  578: Provider: [provider]
  886: - Provider preference
  904: Provider: [provider]

C:/Users/paulc/.config/opencode\skills\update-agent-models\run-workflow.js:
  78:   const skipModelRefresh = args.has("--skip-model-refresh");
  79:   const refreshResearch = args.has("--refresh-research");
  134:   if (!skipModelRefresh) {
  137:     console.log("Skipping model test refresh (--skip-model-refresh requested).");
  138:     console.log("Default behavior is to refresh model health and availability every run.");
  145:   if (!pendingDecision || refreshResearch) {
  159:     console.log("Skipping research refresh (pending interview decision exists).");
  160:     console.log("Use --refresh-research to force a new research proposal.");

C:/Users/paulc/.config/opencode\skills\update-agent-models\run-benchmarks.js:
  5:  *   node skills/update-agent-models/run-benchmarks.js --model <provider/model> [--benchmarks ifbench,mmlu_pro,gpqa]
  126: Usage: node run-benchmarks.js --model <provider/model> [--benchmarks <list>]
  129:   --model <provider/model>    Model identifier (e.g., openai/gpt-4)

C:/Users/paulc/.config/opencode\skills\update-agent-models\research_gripes.md:
  19: 1. Refresh benchmark cache with controlled scripts or approved manual process.

C:/Users/paulc/.config/opencode\skills\update-agent-models\research-plan.md:
  65: - **Model Cards**: Provider-published benchmark claims (requires verification)
  74: node skills/update-agent-models/research-benchmarks.js --focus-model <provider/model>
  105: 1. **Identify provider model family**
  106:    - Check `working_models.json` for provider
  107:    - Search provider documentation for benchmark claims
  114:    - Provider claims + independent evaluations
  167: - [ ] **Cross-validated**: At least 2 independent sources agree (or provider + 1 independent)
  191:    - Apply provider-reported conversion factors

C:/Users/paulc/.config/opencode\skills\update-agent-models\RESEARCH-BEST-PRACTICES.md:
  175: Primary Provider
  184:   Fallback Provider 1
  191: When all providers fail:
  290: 1. **Single-provider dependency**: Always have fallback providers

C:/Users/paulc/.config/opencode\skills\update-agent-models\research-benchmarks.js:
  63: function stripProviderPrefixes(modelId) {
  76:   return stripProviderPrefixes(String(modelId || ''))
  220:       m?.provider,
  413:   const aa = opencode?.provider?.['artificial-analysis'] || {};

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmarks\loft\PROMPT_EXAMPLE.txt:
  1432: ID: 718 | TITLE: IP address | CONTENT: The IP address space is managed globally by the Internet Assigned Numbers Authority (IANA), and by five regional Internet registries (RIR) responsible in their designated territories for assignment to end users and local Internet registries, such as Internet service providers. IPv4 addresses have been distributed by IANA to the RIRs in blocks of approximately 16.8Â million addresses each. Each ISP or private network administrator assigns an IP address to each device connected to its network. Such assignments may be on a static (fixed or permanent) or dynamic basis, depending on its software and practices. | END ID: 718
  1456: [Omitted long matching line]

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmarks\livecodebench\poetry.lock:
  4072: description = "Provider of IANA time zone data"

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\tests\test_requests_caching.py:
  74: def requests_caching_refresh(tasks: List[str]):
  79:     run_model_for_task_caching(tasks=tasks, cache_requests="refresh")
  111:             # test_requests_caching_refresh,

C:/Users/paulc/.config/opencode\skills\update-agent-models\proxies\swe_bench_pro\README.md:
  248: - Provider research papers/blogs

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmarks\ifbench\ifbench-platform\vendor\IFBench\eval\eval_results_strict.jsonl:
  54: [Omitted long matching line]
  79: [Omitted long matching line]
  139: [Omitted long matching line]

C:/Users/paulc/.config/opencode\skills\update-agent-models\benchmarks\matharena\venv\Lib\site-packages\pip-25.0.1.dist-info\RECORD:
  235: pip/_internal/resolution/resolvelib/__pycache__/provider.cpython-312.pyc,,
  243: pip/_internal/resolution/resolvelib/provider.py,sha256=bcsFnYvlmtB80cwVdW1fIwgol8ZNr1f1VHyRTkz4

... (truncated)
```
