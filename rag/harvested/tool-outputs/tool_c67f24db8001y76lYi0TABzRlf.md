# Tool Output: tool_c67f24db8001y76lYi0TABzRlf
**Date**: 2026-02-16 19:34:18 UTC
**Size**: 118,858 bytes

```

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\AGENTS.md:
  123: OpenCode plugin: multi-model agent orchestration (Claude Opus 4.5, GPT-5.2, Gemini 3 Flash). 34 lifecycle hooks, 20+ tools (LSP, AST-Grep, delegation), 11 specialized agents, full Claude Code compatibility. "oh-my-zsh" for OpenCode.
  212: | explore | xai/grok-code-fast-1 | Fast codebase grep (fallback: claude-haiku-4-5 → gpt-5-mini → gpt-5-nano) |

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\docs\cli-guide.md:
  43: 1. **Provider Selection**: Choose your AI provider from Claude, ChatGPT, or Gemini.
  44: 2. **API Key Input**: Enter the API key for your selected provider.

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\docs\configurations.md:
  13: It asks about your providers (Claude, OpenAI, Gemini, etc.) and generates optimal config automatically.
  25:     "explore": { "model": "opencode/gpt-5-nano" }        // Free model for grep
  30:     "quick": { "model": "opencode/gpt-5-nano" },         // Fast/cheap for trivial tasks
  36: **Find available models:** Run `opencode models` to see all models in your environment.
  78:       "model": "opencode/gpt-5-nano"  // Free & fast for exploration
  88: ## Ollama Provider
  90: **IMPORTANT**: When using Ollama as a provider, you **must** disable streaming to avoid JSON parsing errors.
  166: Each agent supports: `model`, `temperature`, `top_p`, `prompt`, `prompt_append`, `tools`, `disable`, `description`, `mode`, `color`, `permission`, `category`, `variant`, `maxTokens`, `thinking`, `reasoningEffort`, `textVerbosity`, `providerOptions`.
  178: | `providerOptions`    | object  | Provider-specific options passed directly to OpenCode SDK.                                      |
  254: - **playwright** (default) / **agent-browser**: Browser automation for web scraping, testing, screenshots, and browser interactions. See [Browser Automation](#browser-automation) for switching between providers.
  368: Choose between two browser automation providers:
  370: | Provider | Interface | Features | Installation |
  375: **Switch providers** via `browser_automation_engine` in `oh-my-opencode.json`:
  380:     "provider": "agent-browser"
  690:     "providerConcurrency": {
  705: | `defaultConcurrency`  | -       | Default maximum concurrent background tasks for all providers/models                                                    |
  707: | `providerConcurrency` | -       | Per-provider concurrency limits. Keys are provider names (e.g., `anthropic`, `openai`, `google`)                        |
  708: | `modelConcurrency`    | -       | Per-model concurrency limits. Keys are full model names (e.g., `anthropic/claude-opus-4-5`). Overrides provider limits. |
  710: **Priority Order**: `modelConcurrency` > `providerConcurrency` > `defaultConcurrency`
  715: - Respect provider rate limits by setting provider-level caps
  839: At runtime, Oh My OpenCode uses a 3-step resolution process to determine which model to use for each agent and category. This happens dynamically based on your configuration and available models.
  843: **Problem**: Users have different provider configurations. The system needs to select the best available model for each task at runtime.
  847: 2. **Step 2: Provider Fallback** — Try each provider in the requirement's priority order until one is available
  848: 3. **Step 3: System Default** — Fall back to OpenCode's configured default model
  865: │   Step 2: PROVIDER PRIORITY FALLBACK                            │
  867: │   │ For each provider in requirement.providers order:       │   │
  879: │   │ Not found? → Try next provider                          │   │
  882: │                              ▼ (all providers exhausted)        │
  891: ### Agent Provider Chains
  893: Each agent has a defined provider priority chain. The system tries providers in order until it finds an available model:
  895: | Agent | Model (no prefix) | Provider Priority Chain |
  907: ### Category Provider Chains
  911: | Category | Model (no prefix) | Provider Priority Chain |
  932: - Provider fallback chain
  958: When you specify a model override, it takes precedence (Step 1) and the provider fallback chain is skipped entirely.

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\package.json:
  4:   "description": "The Best AI Agent Harness - Batteries-Included OpenCode Plugin with Multi-Model Orchestration, Parallel Background Agents, and Crafted LSP/AST Tools",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\docs\features.md:
  7: Oh-My-OpenCode provides 11 specialized AI agents. Each has distinct expertise, optimized models, and tool permissions.
  17: | **explore** | `anthropic/claude-haiku-4-5` | Fast codebase exploration and contextual grep. Fallback: gpt-5-mini → gpt-5-nano. |
  18: | **multimodal-looker** | `google/gemini-3-flash` | Visual content specialist. Analyzes PDFs, images, diagrams to extract information. Fallback: gpt-5.2 → glm-4.6v → kimi-k2.5 → claude-haiku-4-5 → gpt-5-nano. |
  107: Oh-My-OpenCode provides two browser automation providers, configurable via `browser_automation_engine.provider`:
  111: The default provider uses Playwright MCP server:
  127: Alternative provider using [Vercel's agent-browser CLI](https://github.com/vercel-labs/agent-browser):
  132:     "provider": "agent-browser"
  147: #### Capabilities (Both Providers)

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\docs\guide\installation.md:
  24: Follow the prompts to configure your Claude, ChatGPT, and Gemini subscriptions. After installation, authenticate your providers as instructed.
  61: 5. **Do you have access to OpenCode Zen (opencode/ models)?**
  69: **Provider Priority**: Native (anthropic/, openai/, google/) > GitHub Copilot > OpenCode Zen > Z.ai Coding Plan
  119: Following is the configuration guides for each providers. Please use interactive terminal like tmux to do following:
  125: # Interactive Terminal: find Provider: Select Anthropic
  148: Read the [opencode-antigravity-auth documentation](https://github.com/NoeFabris/opencode-antigravity-auth), copy the full model configuration from the README, and merge carefully to avoid breaking the user's existing setup. The plugin now uses a **variant system** — models like `antigravity-gemini-3-pro` support `low`/`high` variants instead of separate `-low`/`-high` model entries.
  150: ##### oh-my-opencode Agent Model Override
  152: The `opencode-antigravity-auth` plugin uses different model names than the built-in Google auth. Override the agent models in `oh-my-opencode.json` (or `.opencode/oh-my-opencode.json`):
  178: # Interactive Terminal: Provider: Select Google
  187: #### GitHub Copilot (Fallback Provider)
  189: GitHub Copilot is supported as a **fallback provider** when native providers are unavailable.
  195: When GitHub Copilot is the best available provider, oh-my-opencode uses these model assignments:
  201: | **Explore**   | `opencode/gpt-5-nano`              |
  204: GitHub Copilot acts as a proxy provider, routing requests to underlying models based on your subscription.
  208: Z.ai Coding Plan provides access to GLM-4.7 models. When enabled, the **Librarian agent always uses `zai-coding-plan/glm-4.7`** regardless of other available providers.
  210: If Z.ai is the only provider available, all agents will use GLM models:
  221: OpenCode Zen provides access to `opencode/` prefixed models including `opencode/claude-opus-4-5`, `opencode/gpt-5.2`, `opencode/gpt-5-nano`, and `opencode/glm-4.7-free`.
  223: When OpenCode Zen is the best available provider (no native or Copilot), these models are used:
  229: | **Explore**   | `opencode/gpt-5-nano`             |

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\docs\guide\overview.md:
  93: Oh My OpenCode automatically configures models based on your available providers. You don't need to manually specify every model.
  99: When you run `bunx oh-my-opencode install`, the installer asks which providers you have:
  107: Based on your answers, it generates `~/.config/opencode/oh-my-opencode.json` with optimal model assignments for each agent and category.
  111: Each agent has a **provider priority chain**. The system tries providers in order until it finds an available model:
  117: gemini   gpt-5.2     glm-4.6v       haiku     gpt-5-nano
  133:     "explore": { "model": "opencode/gpt-5-nano" },
  138:     "quick": { "model": "opencode/gpt-5-nano" },
  150: - Mix providers freely (Claude for main work, Z.ai for cheap tasks, etc.)
  154: Run `opencode models` to see all available models in your environment. Model names follow the format `provider/model-name`.

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\README - Copy.md:
  322: - **Background Tasks**: Configure concurrency limits per provider/model

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\docs\troubleshooting\ollama-streaming-issue.md:
  5: When using Ollama as a provider with oh-my-opencode agents, you may encounter:
  34: Configure your Ollama provider to use `stream: false`:
  38:   "provider": "ollama",
  123: 1. Check your Ollama provider configuration

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\README.md:
  322: - **Background Tasks**: Configure concurrency limits per provider/model

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\AGENTS.md:
  41: | explore | xai/grok-code-fast-1 | 0.1 | Fast contextual grep (fallback: claude-haiku-4-5 → gpt-5-mini → gpt-5-nano) |

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\AGENTS.md:
  45: | `install` | Interactive setup with provider selection |

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\AGENTS.md:
  15: │   └── concurrency.ts          # Per-provider limits
  49: - **Concurrency**: Per-provider/model limits via `ConcurrencyManager`

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\config\schema.ts:
  137:   /** Provider-specific options. Passed directly to OpenCode SDK. */
  138:   providerOptions: z.record(z.string(), z.unknown()).optional(),
  310:   providerConcurrency: z.record(z.string(), z.number().min(0)).optional(),
  332: export const BrowserAutomationProviderSchema = z.enum(["playwright", "agent-browser", "dev-browser"])
  336:    * Browser automation provider to use for the "playwright" skill.
  341:   provider: BrowserAutomationProviderSchema.default("playwright"),
  344: export const WebsearchProviderSchema = z.enum(["exa", "tavily"])
  348:    * Websearch provider to use.
  352:   provider: WebsearchProviderSchema.optional(),
  436: export type BrowserAutomationProvider = z.infer<typeof BrowserAutomationProviderSchema>
  438: export type WebsearchProvider = z.infer<typeof WebsearchProviderSchema>

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\config\schema.test.ts:
  5:   BrowserAutomationProviderSchema,
  519: describe("BrowserAutomationProviderSchema", () => {
  520:   test("accepts 'playwright' as valid provider", () => {
  525:     const result = BrowserAutomationProviderSchema.safeParse(input)
  532:   test("accepts 'agent-browser' as valid provider", () => {
  537:     const result = BrowserAutomationProviderSchema.safeParse(input)
  544:   test("rejects invalid provider", () => {
  546:     const input = "invalid-provider"
  549:     const result = BrowserAutomationProviderSchema.safeParse(input)
  557:   test("defaults provider to 'playwright' when not specified", () => {
  565:     expect(result.provider).toBe("playwright")
  568:   test("accepts agent-browser provider", () => {
  570:     const input = { provider: "agent-browser" }
  576:     expect(result.provider).toBe("agent-browser")
  585:         provider: "agent-browser",
  594:     expect(result.data?.browser_automation_engine?.provider).toBe("agent-browser")

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\config-manager.ts:
  496:  * Antigravity Provider Configuration
  500:  * Since opencode-antigravity-auth v1.3.0, models use a variant system:
  507:  * @see https://github.com/NoeFabris/opencode-antigravity-auth#models
  509: export const ANTIGRAVITY_PROVIDER_CONFIG = {
  562: export function addProviderConfig(config: InstallConfig): ConfigMergeResult {
  584:     const providers = (newConfig.provider ?? {}) as Record<string, unknown>
  587:       providers.google = ANTIGRAVITY_PROVIDER_CONFIG.google
  590:     if (Object.keys(providers).length > 0) {
  591:       newConfig.provider = providers
  597:     return { success: false, configPath: path, error: formatErrorWithSuggestion(err, "add provider config") }
  601: function detectProvidersFromOmoConfig(): { hasOpenAI: boolean; hasOpencodeZen: boolean; hasZaiCodingPlan: boolean; hasKimiForCoding: boolean } {
  660:   const { hasOpenAI, hasOpencodeZen, hasZaiCodingPlan, hasKimiForCoding } = detectProvidersFromOmoConfig()

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\config-manager.test.ts:
  3: import { ANTIGRAVITY_PROVIDER_CONFIG, getPluginNameWithVersion, fetchNpmDistTags, generateOmoConfig } from "./config-manager"
  172: describe("config-manager ANTIGRAVITY_PROVIDER_CONFIG", () => {
  174:     const google = (ANTIGRAVITY_PROVIDER_CONFIG as any).google
  205:     // #given the antigravity provider config
  206:     const models = (ANTIGRAVITY_PROVIDER_CONFIG as any).google.models as Record<string, any>
  226:     // #given the antigravity provider config
  227:     const models = (ANTIGRAVITY_PROVIDER_CONFIG as any).google.models as Record<string, any>
  259:     // #then Sisyphus uses Claude (OR logic - at least one provider available)
  281:     // #then Sisyphus uses Claude (OR logic - at least one provider available)
  301:     // #then Sisyphus uses Copilot (OR logic - copilot is in claude-opus-4-5 providers)
  305:   test("uses ultimate fallback when no providers configured", () => {
  306:     // #given user has no providers
  321:     // #then Sisyphus is omitted (requires all fallback providers)
  364:     // #then Sisyphus is omitted (requires all fallback providers)

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\builtin-skills\skills.ts:
  2: import type { BrowserAutomationProvider } from "../../config/schema"
  13:   browserProvider?: BrowserAutomationProvider
  18:   const { browserProvider = "playwright", disabledSkills } = options
  20:   const browserSkill = browserProvider === "agent-browser" ? agentBrowserSkill : playwrightSkill

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\builtin-skills\skills.test.ts:
  18: 	test("returns playwright skill when browserProvider is 'playwright'", () => {
  20: 		const options = { browserProvider: "playwright" as const }
  32: 	test("returns agent-browser skill when browserProvider is 'agent-browser'", () => {
  34: 		const options = { browserProvider: "agent-browser" as const }
  51: 		const options = { browserProvider: "agent-browser" as const }
  65: 		// given - both provider options
  69: 		const agentBrowserSkills = createBuiltinSkills({ browserProvider: "agent-browser" })
  78: 	test("returns exactly 4 skills regardless of provider", () => {
  83: 		const agentBrowserSkills = createBuiltinSkills({ browserProvider: "agent-browser" })

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\index.ts:
  20:   .description("The ultimate OpenCode plugin - multi-model orchestration, LSP tools, and more")
  41: Model Providers (Priority: Native > Copilot > OpenCode Zen > Z.ai > Kimi):
  46:   OpenCode Zen  opencode/ models (opencode/claude-opus-4-5, etc.)
  144:   authentication   Check auth provider status

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\install.ts:
  10:   addProviderConfig,
  28: function formatProvider(name: string, enabled: boolean, detail?: string): string {
  42:   lines.push(formatProvider("Claude", config.hasClaude, claudeDetail))
  43:   lines.push(formatProvider("OpenAI/ChatGPT", config.hasOpenAI, "GPT-5.2 for Oracle"))
  44:   lines.push(formatProvider("Gemini", config.hasGemini))
  45:   lines.push(formatProvider("GitHub Copilot", config.hasCopilot, "fallback"))
  46:   lines.push(formatProvider("OpenCode Zen", config.hasOpencodeZen, "opencode/ models"))
  47:   lines.push(formatProvider("Z.ai Coding Plan", config.hasZaiCodingPlan, "Librarian/Multimodal"))
  48:   lines.push(formatProvider("Kimi For Coding", config.hasKimiForCoding, "Sisyphus/Prometheus fallback"))
  56:   lines.push(`  ${SYMBOLS.info} Models auto-configured based on provider priority`)
  231:       { value: "no" as const, label: "No", hint: "Only native providers will be used" },
  232:       { value: "yes" as const, label: "Yes", hint: "Fallback option when native providers unavailable" },
  243:     message: "Do you have access to OpenCode Zen (opencode/ models)?",
  245:       { value: "no" as const, label: "No", hint: "Will use other configured providers" },
  259:       { value: "no" as const, label: "No", hint: "Will use other configured providers" },
  273:       { value: "no" as const, label: "No", hint: "Will use other configured providers" },
  352:     printStep(step++, totalSteps, "Adding provider configurations...")
  353:     const providerResult = addProviderConfig(config)
  354:     if (!providerResult.success) {
  355:       printError(`Failed: ${providerResult.error}`)
  358:     printSuccess(`Providers configured ${SYMBOLS.arrow} ${color.dim(providerResult.configPath)}`)
  388:     printWarning("No model providers configured. Using opencode/glm-4.7-free as fallback.")
  410:       `Run ${color.cyan("opencode auth login")} and select your provider:\n` +
  414:       "Authenticate Your Providers"
  471:     s.start("Adding provider configurations")
  472:     const providerResult = addProviderConfig(config)
  473:     if (!providerResult.success) {
  474:       s.stop(`Failed to add provider config: ${providerResult.error}`)
  478:     s.stop(`Provider config added to ${color.cyan(providerResult.configPath)}`)
  505:     p.log.warn("No model providers configured. Using opencode/glm-4.7-free as fallback.")
  526:     const providers: string[] = []
  527:     if (config.hasClaude) providers.push(`Anthropic ${color.gray("→ Claude Pro/Max")}`)
  528:     if (config.hasGemini) providers.push(`Google ${color.gray("→ OAuth with Antigravity")}`)
  529:     if (config.hasCopilot) providers.push(`GitHub ${color.gray("→ Copilot")}`)
  532:     console.log(color.bold("Authenticate Your Providers"))
  535:     for (const provider of providers) {
  536:       console.log(`   ${SYMBOLS.bullet} ${provider}`)

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\builtin-skills\skills\playwright.ts:
  217: | \`-p, --provider <name>\` | Cloud browser provider (\`AGENT_BROWSER_PROVIDER\` env) |

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\__snapshots__\model-fallback.test.ts.snap:
  3: exports[`generateModelConfig no providers available returns ULTIMATE_FALLBACK for all agents and categories when no providers 1`] = `
  64: exports[`generateModelConfig single native provider uses Claude models when only Claude is available 1`] = `
  126: exports[`generateModelConfig single native provider uses Claude models with isMax20 flag 1`] = `
  189: exports[`generateModelConfig single native provider uses OpenAI models when only OpenAI is available 1`] = `
  197:       "model": "opencode/gpt-5-nano",
  256: exports[`generateModelConfig single native provider uses OpenAI models with isMax20 flag 1`] = `
  264:       "model": "opencode/gpt-5-nano",
  323: exports[`generateModelConfig single native provider uses Gemini models when only Gemini is available 1`] = `
  331:       "model": "opencode/gpt-5-nano",
  383: exports[`generateModelConfig single native provider uses Gemini models with isMax20 flag 1`] = `
  391:       "model": "opencode/gpt-5-nano",
  443: exports[`generateModelConfig all native providers uses preferred models from fallback chains when all natives available 1`] = `
  516: exports[`generateModelConfig all native providers uses preferred models with isMax20 flag when all natives available 1`] = `
  590: exports[`generateModelConfig fallback providers uses OpenCode Zen models when only OpenCode Zen is available 1`] = `
  663: exports[`generateModelConfig fallback providers uses OpenCode Zen models with isMax20 flag 1`] = `
  737: exports[`generateModelConfig fallback providers uses GitHub Copilot models when only Copilot is available 1`] = `
  810: exports[`generateModelConfig fallback providers uses GitHub Copilot models with isMax20 flag 1`] = `
  884: exports[`generateModelConfig fallback providers uses ZAI model for librarian when only ZAI is available 1`] = `
  892:       "model": "opencode/gpt-5-nano",
  939: exports[`generateModelConfig fallback providers uses ZAI model for librarian with isMax20 flag 1`] = `
  947:       "model": "opencode/gpt-5-nano",
  994: exports[`generateModelConfig mixed provider scenarios uses Claude + OpenCode Zen combination 1`] = `
  1067: exports[`generateModelConfig mixed provider scenarios uses OpenAI + Copilot combination 1`] = `
  1140: exports[`generateModelConfig mixed provider scenarios uses Claude + ZAI combination (librarian uses ZAI) 1`] = `
  1202: exports[`generateModelConfig mixed provider scenarios uses Gemini + Claude combination (explore uses Gemini) 1`] = `
  1267: exports[`generateModelConfig mixed provider scenarios uses all fallback providers together 1`] = `
  1340: exports[`generateModelConfig mixed provider scenarios uses all providers together 1`] = `
  1413: exports[`generateModelConfig mixed provider scenarios uses all providers with isMax20 flag 1`] = `

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\doctor\types.ts:
  73: export type AuthProviderId = "anthropic" | "openai" | "google"
  75: export interface AuthProviderInfo {
  76:   id: AuthProviderId

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\task-toast-manager\manager.test.ts:
  216:         modelInfo: { model: "my-provider/my-model", type: "user-defined" as const },

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\mcp-oauth\login.ts:
  1: import { McpOAuthProvider } from "../../features/mcp-oauth/provider"
  17:     const provider = new McpOAuthProvider({
  24:     const tokenData = await provider.login()

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\mcp-oauth\login.test.ts:
  5: mock.module("../../features/mcp-oauth/provider", () => ({
  6:   McpOAuthProvider: class MockMcpOAuthProvider {

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\model-fallback.ts:
  8: interface ProviderAvailability {
  43: function toProviderAvailability(config: InstallConfig): ProviderAvailability {
  58: function isProviderAvailable(provider: string, avail: ProviderAvailability): boolean {
  68:   return mapping[provider] ?? false
  71: function transformModelForProvider(provider: string, model: string): string {
  72:   if (provider === "github-copilot") {
  86:   avail: ProviderAvailability
  89:     for (const provider of entry.providers) {
  90:       if (isProviderAvailable(provider, avail)) {
  91:         const transformedModel = transformModelForProvider(provider, entry.model)
  93:           model: `${provider}/${transformedModel}`,
  108:   avail: ProviderAvailability
  111:     entry.providers.some((provider) => isProviderAvailable(provider, avail))
  118:   avail: ProviderAvailability
  122:   return matchingEntry.providers.some((provider) => isProviderAvailable(provider, avail))
  126:   const avail = toProviderAvailability(config)
  127:   const hasAnyProvider =
  136:   if (!hasAnyProvider) {
  167:         agents[role] = { model: "opencode/gpt-5-nano" }

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\model-fallback.test.ts:
  21:   describe("no providers available", () => {
  22:     test("returns ULTIMATE_FALLBACK for all agents and categories when no providers", () => {
  23:       // #given no providers are available
  34:   describe("single native provider", () => {
  102:   describe("all native providers", () => {
  104:       // #given all native providers are available
  114:       // #then should use first provider in each fallback chain
  119:       // #given all native providers are available with Max 20 plan
  135:   describe("fallback providers", () => {
  136:     test("uses OpenCode Zen models when only OpenCode Zen is available", () => {
  143:       // #then should use OPENCODE_ZEN_MODELS
  147:     test("uses OpenCode Zen models with isMax20 flag", () => {
  203:   describe("mixed provider scenarios", () => {
  260:     test("uses all fallback providers together", () => {
  261:       // #given all fallback providers are available
  275:     test("uses all providers together", () => {
  276:       // #given all providers are available
  289:       // #then should prefer native providers, librarian uses ZAI
  293:     test("uses all providers with isMax20 flag", () => {
  294:       // #given all providers are available with Max 20 plan
  314:     test("explore uses gpt-5-nano when only Gemini available (no Claude)", () => {
  321:       // #then explore should use gpt-5-nano (Claude haiku not available)
  322:       expect(result.agents?.explore?.model).toBe("opencode/gpt-5-nano")
  347:     test("explore uses gpt-5-nano when only OpenAI available", () => {
  354:       // #then explore should use gpt-5-nano (fallback)
  355:       expect(result.agents?.explore?.model).toBe("opencode/gpt-5-nano")
  371:     test("Sisyphus is created when at least one fallback provider is available (Claude)", () => {
  382:     test("Sisyphus is created when multiple fallback providers are available", () => {
  399:     test("Sisyphus is omitted when no fallback provider is available (OpenAI not in chain)", () => {
  483:     test("librarian uses ZAI when ZAI is available regardless of other providers", () => {

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\builtin-skills\agent-browser\SKILL.md:
  203: | `-p, --provider <name>` | Cloud browser provider (`AGENT_BROWSER_PROVIDER` env) |

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\hook-message-injector\types.ts:
  13:     providerID: string
  27:     providerID?: string

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\hook-message-injector\injector.ts:
  9:   model?: { providerID?: string; modelID?: string; variant?: string }
  25:         if (msg.agent && msg.model?.providerID && msg.model?.modelID) {
  39:         if (msg.agent || (msg.model?.providerID && msg.model?.modelID)) {
  124:       hasModel: !!(originalMessage.model?.providerID && originalMessage.model?.modelID)
  133:     !originalMessage.model?.providerID ||
  144:     originalMessage.model?.providerID && originalMessage.model?.modelID
  146:           providerID: originalMessage.model.providerID, 
  150:       : fallback?.model?.providerID && fallback?.model?.modelID
  152:             providerID: fallback.model.providerID, 

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\mcp-oauth\provider.test.ts:
  3: import { McpOAuthProvider, generateCodeVerifier, generateCodeChallenge, buildAuthorizationUrl } from "./provider"
  6: describe("McpOAuthProvider", () => {
  120:       const provider = new McpOAuthProvider(options)
  123:       expect(provider.tokens()).toBeNull()
  124:       expect(provider.clientInformation()).toBeNull()
  125:       expect(provider.codeVerifier()).toBeNull()
  133:       const provider = new McpOAuthProvider(options)
  136:       expect(provider.redirectUrl()).toBe("http://127.0.0.1:19877/callback")
  143:       const provider = new McpOAuthProvider({ serverUrl: "https://mcp.example.com" })
  146:       provider.saveCodeVerifier("my-verifier")
  149:       expect(provider.codeVerifier()).toBe("my-verifier")
  161:       const testDir = join(tmpdir(), "mcp-oauth-provider-test-" + Date.now())
  176:       const provider = new McpOAuthProvider({ serverUrl: "https://mcp.example.com" })
  184:       const saved = provider.saveTokens(tokenData)
  185:       const loaded = provider.tokens()
  196:       const provider = new McpOAuthProvider({ serverUrl: "https://mcp.example.com" })
  204:       const result = provider.redirectToAuthorization(metadata)
  214:       const provider = new McpOAuthProvider({ serverUrl: "https://mcp.example.com" })
  217:       const url = provider.redirectUrl()

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\utils.ts:
  14: import { deepMerge, fetchAvailableModels, resolveModelPipeline, AGENT_MODEL_REQUIREMENTS, readConnectedProvidersCache, isModelAvailable, isAnyFallbackModelAvailable, migrateAgentConfig } from "../shared"
  19: import type { BrowserAutomationProvider } from "../config/schema"
  60:   browserProvider?: BrowserAutomationProvider,
  85:     const { resolved } = resolveMultipleSkills(agentWithCategory.skills, { gitMasterConfig, browserProvider, disabledSkills })
  159:   requirement?: { fallbackChain?: { providers: string[]; model: string; variant?: string }[] }
  172:   fallbackChain?: { providers: string[]; model: string; variant?: string }[]
  175:   if (!entry || entry.providers.length === 0) return undefined
  177:     model: `${entry.providers[0]}/${entry.model}`,
  178:     provenance: "provider-fallback" as const,
  237:   browserProvider?: BrowserAutomationProvider,
  241:   const connectedProviders = readConnectedProvidersCache()
  246:     connectedProviders: connectedProviders ?? undefined,
  249:     availableModels.size === 0 && (!connectedProviders || connectedProviders.length === 0)
  263:   const builtinSkills = createBuiltinSkills({ browserProvider, disabledSkills })
  316:     let config = buildAgent(source, model, mergedCategories, gitMasterConfig, browserProvider, disabledSkills)

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\utils.test.ts:
  5: import * as connectedProvidersCache from "../shared/connected-providers-cache"
  85:     const cacheSpy = spyOn(connectedProvidersCache, "readConnectedProvidersCache").mockReturnValue(null)
  101:    test("Oracle uses connected provider fallback when availableModels is empty and cache exists", async () => {
  102:      // #given - connected providers cache has "openai", which matches oracle's first fallback entry
  103:      const cacheSpy = spyOn(connectedProvidersCache, "readConnectedProvidersCache").mockReturnValue(["openai"])
  117:      const cacheSpy = spyOn(connectedProvidersCache, "readConnectedProvidersCache").mockReturnValue(null)
  191:      const cacheSpy = spyOn(connectedProvidersCache, "readConnectedProvidersCache").mockReturnValue(["openai"])
  204:      const cacheSpy = spyOn(connectedProvidersCache, "readConnectedProvidersCache").mockReturnValue(null)
  214:   test("sisyphus created via connected cache fallback when all providers available", async () => {
  216:     const cacheSpy = spyOn(connectedProvidersCache, "readConnectedProvidersCache").mockReturnValue([
  244:   test("hephaestus is not created when gpt-5.2-codex is unavailable and provider not connected", async () => {
  249:     const cacheSpy = spyOn(connectedProvidersCache, "readConnectedProvidersCache").mockReturnValue([])
  282:     const cacheSpy = spyOn(connectedProvidersCache, "readConnectedProvidersCache").mockReturnValue(null)
  339:     const cacheSpy = spyOn(connectedProvidersCache, "readConnectedProvidersCache").mockReturnValue(null)
  373:   test("sisyphus is not created when no fallback model is available and provider not connected", async () => {
  378:     const cacheSpy = spyOn(connectedProvidersCache, "readConnectedProvidersCache").mockReturnValue([])
  605:   test("agent with agent-browser skill resolves when browserProvider is set", () => {
  616:     // #when - browserProvider is "agent-browser"
  624:   test("agent with agent-browser skill NOT resolved when browserProvider not set", () => {
  635:     // #when - no browserProvider (defaults to playwright)
  811:      // - Plugin init waits for server response (client.provider.list())
  814:      const cacheSpy = spyOn(connectedProvidersCache, "readConnectedProvidersCache").mockReturnValue(null)
  817:        provider: { list: () => Promise.resolve({ data: { connected: [] } }) },

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\run\types.ts:
  51:     providerID?: string

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\claude-code-hooks\index.ts:
  75:         model?: { providerID: string; modelID: string }

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\context-injector\types.ts:
  71:     providerID?: string

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\context-injector\injector.ts:
  44:   model?: { providerID: string; modelID: string }

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\context-injector\injector.test.ts:
  25:       model: { providerID: "test", modelID: "test" },

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\mcp-oauth\provider.ts:
  12: export type McpOAuthProviderOptions = {
  133: export class McpOAuthProvider {
  141:   constructor(options: McpOAuthProviderOptions) {

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\skill-mcp-manager\manager.test.ts:
  28: mock.module("../mcp-oauth/provider", () => ({
  29:   McpOAuthProvider: class MockMcpOAuthProvider {
  737:     it("does not create auth provider when oauth config is absent", async () => {

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\skill-mcp-manager\manager.ts:
  7: import { McpOAuthProvider } from "../mcp-oauth/provider"
  65:   private authProviders: Map<string, McpOAuthProvider> = new Map()
  76:    * Get or create an McpOAuthProvider for a given server URL + oauth config.
  77:    * Providers are cached by server URL to reuse tokens across reconnections.
  79:   private getOrCreateAuthProvider(
  82:   ): McpOAuthProvider {
  83:     const existing = this.authProviders.get(serverUrl)
  88:     const provider = new McpOAuthProvider({
  93:     this.authProviders.set(serverUrl, provider)
  94:     return provider
  243:     let authProvider: McpOAuthProvider | undefined
  245:       authProvider = this.getOrCreateAuthProvider(config.url, config.oauth)
  246:       let tokenData = authProvider.tokens()
  251:           tokenData = await authProvider.login()
  411:     this.authProviders.clear()
  585:     this.authProviders.delete(config.url)
  586:     const provider = this.getOrCreateAuthProvider(config.url, config.oauth)
  589:       await provider.login()

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\doctor\checks\auth.ts:
  3: import type { CheckResult, CheckDefinition, AuthProviderInfo, AuthProviderId } from "../types"
  11: const AUTH_PLUGINS: Record<AuthProviderId, { plugin: string; name: string }> = {
  34: export function getAuthProviderInfo(providerId: AuthProviderId): AuthProviderInfo {
  37:   const authConfig = AUTH_PLUGINS[providerId]
  42:     id: providerId,
  49: export async function checkAuthProvider(providerId: AuthProviderId): Promise<CheckResult> {
  50:   const info = getAuthProviderInfo(providerId)
  51:   const checkId = `auth-${providerId}` as keyof typeof CHECK_NAMES
  60:         `Plugin: ${AUTH_PLUGINS[providerId].plugin}`,
  71:       providerId === "anthropic"
  73:         : `Plugin: ${AUTH_PLUGINS[providerId].plugin}`,
  79:   return checkAuthProvider("anthropic")
  83:   return checkAuthProvider("openai")
  87:   return checkAuthProvider("google")

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\doctor\checks\auth.test.ts:
  5:   describe("getAuthProviderInfo", () => {
  7:       // given anthropic provider
  9:       const info = auth.getAuthProviderInfo("anthropic")
  16:     it("returns correct name for each provider", () => {
  17:       // given each provider
  20:       expect(auth.getAuthProviderInfo("anthropic").name).toContain("Claude")
  21:       expect(auth.getAuthProviderInfo("openai").name).toContain("ChatGPT")
  22:       expect(auth.getAuthProviderInfo("google").name).toContain("Gemini")
  26:   describe("checkAuthProvider", () => {
  35:       getInfoSpy = spyOn(auth, "getAuthProviderInfo").mockReturnValue({
  43:       const result = await auth.checkAuthProvider("anthropic")
  51:       getInfoSpy = spyOn(auth, "getAuthProviderInfo").mockReturnValue({
  59:       const result = await auth.checkAuthProvider("openai")
  104:     it("returns definitions for all three providers", () => {

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\unstable-agent-babysitter\index.ts:
  24:           model?: { providerID: string; modelID: string }
  40:   model?: { providerID: string; modelID: string }
  41:   providerID?: string
  66:   const model = modelValue && typeof modelValue.providerID === "string" && typeof modelValue.modelID === "string"
  67:     ? { providerID: modelValue.providerID, modelID: modelValue.modelID }
  73:     providerID: typeof info.providerID === "string" ? info.providerID : undefined,
  107: ): Promise<{ agent?: string; model?: { providerID: string; modelID: string } }> {
  109:   let model: { providerID: string; modelID: string } | undefined
  118:       if (info?.agent || info?.model || (info?.providerID && info?.modelID)) {
  120:         model = info?.model ?? (info?.providerID && info?.modelID ? { providerID: info.providerID, modelID: info.modelID } : undefined)

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\unstable-agent-babysitter\index.test.ts:
  51:     model: { providerID: "google", modelID: "gemini-1.5" },
  68:           { info: { agent: "sisyphus", model: { providerID: "openai", modelID: "gpt-4" } } },
  101:           { info: { agent: "sisyphus", model: { providerID: "openai", modelID: "gpt-4" } } },
  110:       createTask({ model: { providerID: "minimax", modelID: "minimax-1" } }),
  138:       createTask({ model: { providerID: "openai", modelID: "gpt-4" } }),

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\todo-continuation-enforcer.ts:
  160:     model?: { providerID: string; modelID: string }
  209:       model = model ?? (prevMessage?.model?.providerID && prevMessage?.model?.modelID
  211:             providerID: prevMessage.model.providerID, 
  399:             model?: { providerID: string; modelID: string }
  401:             providerID?: string
  411:           if (info?.agent || info?.model || (info?.modelID && info?.providerID)) {
  414:               model: info.model ?? (info.providerID && info.modelID ? { providerID: info.providerID, modelID: info.modelID } : undefined),

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\todo-continuation-enforcer.test.ts:
  123:   let promptCalls: Array<{ sessionID: string; agent?: string; model?: { providerID?: string; modelID?: string }; text: string }>
  962:   test("should extract model from assistant message with flat modelID/providerID", async () => {
  963:     // given - session with assistant message that has flat modelID/providerID (OpenCode API format)
  967:     // OpenCode returns assistant messages with flat modelID/providerID, not nested model object
  969:       { info: { id: "msg-1", role: "user", agent: "sisyphus", model: { providerID: "openai", modelID: "gpt-5.2" } } },
  970:       { info: { id: "msg-2", role: "assistant", agent: "sisyphus", modelID: "gpt-5.2", providerID: "openai" } },
  1003:     // then - model should be extracted from assistant message's flat modelID/providerID
  1005:     expect(promptCalls[0].model).toEqual({ providerID: "openai", modelID: "gpt-5.2" })
  1020:       { info: { id: "msg-1", role: "user", agent: "sisyphus", model: { providerID: "anthropic", modelID: "claude-sonnet-4-5" } } },
  1021:       { info: { id: "msg-2", role: "assistant", agent: "sisyphus", modelID: "claude-sonnet-4-5", providerID: "anthropic" } },
  1022:       { info: { id: "msg-3", role: "assistant", agent: "compaction", modelID: "claude-sonnet-4-5", providerID: "anthropic" } },

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\plugin-state.ts:
  15:   providerID: string,
  18:   const key = `${providerID}/${modelID}`;
  23:     providerID === "anthropic" &&

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\plugin-handlers\config-handler.ts:
  28: import { log, fetchAvailableModels, readConnectedProvidersCache, resolveModelPipeline } from "../shared";
  77:     type ProviderConfig = {
  81:     const providers = config.provider as
  82:       | Record<string, ProviderConfig>
  86:       providers?.anthropic?.options?.headers?.["anthropic-beta"];
  90:     if (providers) {
  91:       for (const [providerID, providerConfig] of Object.entries(providers)) {
  92:         const models = providerConfig?.models;
  98:                 `${providerID}/${modelID}`,
  156:     const browserProvider = pluginConfig.browser_automation_engine?.provider ?? "playwright";
  170:       browserProvider,
  270:         const connectedProviders = readConnectedProvidersCache();
  272:         // Calling client API (e.g., client.provider.list()) from config handler causes deadlock:
  278:           connectedProviders: connectedProviders ?? undefined,

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\plugin-handlers\config-handler.test.ts:
  67:   spyOn(shared, "readConnectedProvidersCache" as any).mockReturnValue(null)
  102:   ;(shared.readConnectedProvidersCache as any)?.mockRestore?.()
  553:     // - Plugin init waits for server response (client.provider.list())
  567:       provider: { list: () => Promise.resolve({ data: { connected: [] } }) },

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\prometheus\interview-mode.ts:
  119: 2. What auth providers do you need? (Google, GitHub, email/password?)

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\prometheus\identity-constraints.ts:
  264: | **Question to user** | "Which auth provider do you prefer: OAuth, JWT, or session-based?" |

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\mcp\AGENTS.md:
  38: ## Websearch Provider Configuration
  40: The `websearch` MCP supports multiple providers. Exa is the default for backward compatibility and works without an API key.
  42: | Provider | URL | Auth | API Key Required |
  52:     "provider": "tavily"  // or "exa" (default)
  59: - `EXA_API_KEY`: Optional. Used when provider is `exa`.
  60: - `TAVILY_API_KEY`: Required when provider is `tavily`.
  64: - **Default**: Exa is used if no provider is specified.

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\index.ts:
  98:   hasConnectedProvidersCache,
  393:   const browserProvider =
  394:     pluginConfig.browser_automation_engine?.provider ?? "playwright";
  403:     browserProvider,
  424:   const builtinSkills = createBuiltinSkills({ browserProvider, disabledSkills }).filter((skill) => {
  540:       if (!hasConnectedProvidersCache()) {
  544:               title: "⚠️ Provider Cache Missing",
  851:         providerID: "anthropic",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\mcp\index.test.ts:
  92:     const config = { websearch: { provider: "tavily" as const } }

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\doctor\checks\model-resolution.test.ts:
  7:     // then: Returns info for all agents and categories with their provider chains
  9:     it("returns agent requirements with provider chains", async () => {
  18:       expect(sisyphus!.requirement.fallbackChain[0]?.providers).toContain("anthropic")
  19:       expect(sisyphus!.requirement.fallbackChain[0]?.providers).toContain("github-copilot")
  22:     it("returns category requirements with provider chains", async () => {
  31:       expect(visual!.requirement.fallbackChain[0]?.providers).toContain("google")
  78:     it("shows provider fallback when no override exists", async () => {
  86:       // then: Should show provider fallback chain
  90:       expect(sisyphus!.effectiveResolution).toContain("Provider fallback:")

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\think-mode\types.ts:
  5:   providerID?: string
  10:   providerID: string

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\think-mode\switcher.ts:
  8:  * PROVIDER ALIASING:
  9:  * GitHub Copilot acts as a proxy provider that routes to underlying providers
  10:  * (Anthropic, Google, OpenAI). We resolve the proxy to the actual provider
  20:  * Extracts provider-specific prefix from model ID (if present).
  21:  * Custom providers may use prefixes for routing (e.g., vertex_ai/, openai/).
  57:  * Resolves proxy providers (like github-copilot) to their underlying provider.
  59:  * model provider (Anthropic, Google, OpenAI).
  62:  * resolveProvider("github-copilot", "claude-opus-4-5") // "anthropic"
  63:  * resolveProvider("github-copilot", "gemini-3-pro") // "google"
  64:  * resolveProvider("github-copilot", "gpt-5.2") // "openai"
  65:  * resolveProvider("anthropic", "claude-opus-4-5") // "anthropic" (unchanged)
  67: function resolveProvider(providerID: string, modelID: string): string {
  68:   // GitHub Copilot is a proxy - infer actual provider from model name
  69:   if (providerID === "github-copilot") {
  82:   // Direct providers or unknown - return as-is
  83:   return providerID
  99:   "gpt-5-nano": "gpt-5-nano-high",
  132:     providerOptions: {
  141:     providerOptions: {
  153:     providerOptions: {
  200: type ThinkingProvider = keyof typeof THINKING_CONFIGS
  202: function isThinkingProvider(provider: string): provider is ThinkingProvider {
  203:   return provider in THINKING_CONFIGS
  207:   providerID: string,
  217:   const resolvedProvider = resolveProvider(providerID, modelID)
  219:   if (!isThinkingProvider(resolvedProvider)) {
  223:   const config = THINKING_CONFIGS[resolvedProvider]
  224:   const capablePatterns = THINKING_CAPABLE_MODELS[resolvedProvider]

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\think-mode\switcher.test.ts:
  10:   describe("GitHub Copilot provider support", () => {
  13:         // given a github-copilot provider with Claude Opus model
  14:         const providerID = "github-copilot"
  18:         const config = getThinkingConfig(providerID, modelID)
  32:         // given a github-copilot provider with Claude Sonnet model
  52:         // given a github-copilot provider with Gemini Pro model
  57:         expect(config?.providerOptions).toBeDefined()
  59:           config?.providerOptions as Record<string, unknown>
  65:         // given a github-copilot provider with Gemini Flash model
  73:         expect(config?.providerOptions).toBeDefined()
  79:         // given a github-copilot provider with GPT-5.2 model
  88:         // given a github-copilot provider with GPT-5 model
  97:         // given a github-copilot provider with o1 model
  106:         // given a github-copilot provider with o3 model
  117:         // given a github-copilot provider with unknown model
  120:         // then should return null (no matching provider)
  241:     describe("Unknown providers", () => {
  242:       it("should return null for unknown providers", () => {
  243:         // given unknown provider IDs
  244:         expect(getThinkingConfig("unknown-provider", "some-model")).toBeNull()
  250:   describe("Direct provider configs (backwards compatibility)", () => {
  251:     it("should still work for direct anthropic provider", () => {
  252:       // given direct anthropic provider
  261:     it("should still work for direct google provider", () => {
  262:       // given direct google provider
  267:       expect(config?.providerOptions).toBeDefined()
  270:     it("should still work for amazon-bedrock provider", () => {
  271:       // given amazon-bedrock provider with claude model
  279:     it("should still work for google-vertex provider", () => {
  280:       // given google-vertex provider
  285:       expect(config?.providerOptions).toBeDefined()
  286:       const vertexOptions = (config?.providerOptions as Record<string, unknown>)?.[
  292:     it("should work for direct openai provider", () => {
  293:       // given direct openai provider
  311:       expect(config.providerOptions).toBeDefined()
  326:   describe("Custom provider prefixes support", () => {
  394:       it("should return null for custom providers (not in THINKING_CONFIGS)", () => {
  395:         // given custom provider with prefixed Claude model
  398:         // then should return null (custom provider not in THINKING_CONFIGS)
  402:       it("should work with prefixed models on known providers", () => {
  403:         // given known provider (anthropic) with prefixed model
  421:     describe("Real-world custom provider scenario", () => {
  423:         // given a custom LLM proxy provider using vertex_ai/ prefix
  424:         const providerID = "dia-llm"
  437:         // #and when getting thinking config for custom provider
  438:         const config = getThinkingConfig(providerID, modelID)
  440:         // then should return null (custom provider, not anthropic)
  441:         // This prevents applying incompatible thinking configs to custom providers
  462:   describe("Z.AI GLM-4.7 provider support", () => {
  465:         // given zai-coding-plan provider with glm-4.7 model
  470:         expect(config?.providerOptions).toBeDefined()
  471:         const zaiOptions = (config?.providerOptions as Record<string, unknown>)?.[
  482:         // given zai-coding-plan provider with glm-4.6v model
  487:         expect(config?.providerOptions).toBeDefined()
  491:         

... (truncated)
```
