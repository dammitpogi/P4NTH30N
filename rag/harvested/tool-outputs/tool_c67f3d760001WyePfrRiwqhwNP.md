# Tool Output: tool_c67f3d760001WyePfrRiwqhwNP
**Date**: 2026-02-16 19:35:59 UTC
**Size**: 156,690 bytes

```

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\plugin-config.ts:
  3: import { OhMyOpenCodeConfigSchema, type OhMyOpenCodeConfig } from "./config";
  7:   getOpenCodeConfigDir,
  17: ): OhMyOpenCodeConfig | null {
  25:       const result = OhMyOpenCodeConfigSchema.safeParse(rawConfig);
  51:   base: OhMyOpenCodeConfig,
  52:   override: OhMyOpenCodeConfig
  53: ): OhMyOpenCodeConfig {
  96: ): OhMyOpenCodeConfig {
  98:   const configDir = getOpenCodeConfigDir({ binary: "opencode" });
  99:   const userBasePath = path.join(configDir, "oh-my-opencode");
  107:   const projectBasePath = path.join(directory, ".opencode", "oh-my-opencode");
  115:   let config: OhMyOpenCodeConfig =

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\plugin-config.test.ts:
  3: import type { OhMyOpenCodeConfig } from "./config";
  22:       } as OhMyOpenCodeConfig;
  33:       } as unknown as OhMyOpenCodeConfig;
  48:       const base: OhMyOpenCodeConfig = {
  56:       const override: OhMyOpenCodeConfig = {};
  64:       const base: OhMyOpenCodeConfig = {};
  66:       const override: OhMyOpenCodeConfig = {
  82:       const base: OhMyOpenCodeConfig = {
  88:       const override: OhMyOpenCodeConfig = {
  103:       const base: OhMyOpenCodeConfig = {
  107:       const override: OhMyOpenCodeConfig = {

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\index.ts:
  1: import type { Plugin, ToolDefinition } from "@opencode-ai/plugin";
  55:   discoverOpencodeGlobalSkills,
  56:   discoverOpencodeProjectSkills,
  58: } from "./features/opencode-skill-loader";
  99:   getOpenCodeVersion,
  100:   isOpenCodeVersionAtLeast,
  101:   OPENCODE_NATIVE_AGENTS_INJECTION_VERSION,
  108: const OhMyOpenCodePlugin: Plugin = async (ctx) => {
  109:   log("[OhMyOpenCodePlugin] ENTRY - plugin loading", {
  171:   // Check for native OpenCode AGENTS.md injection support before creating hook
  174:     const currentVersion = getOpenCodeVersion();
  177:       isOpenCodeVersionAtLeast(OPENCODE_NATIVE_AGENTS_INJECTION_VERSION);
  181:         "directory-agents-injector auto-disabled due to native OpenCode support",
  184:           nativeVersion: OPENCODE_NATIVE_AGENTS_INJECTION_VERSION,
  434:   const [userSkills, globalSkills, projectSkills, opencodeProjectSkills] =
  437:       discoverOpencodeGlobalSkills(),
  439:       discoverOpencodeProjectSkills(),
  447:     opencodeProjectSkills,
  546:                 "Model filtering disabled. RESTART OpenCode to enable full functionality.",
  860: export default OhMyOpenCodePlugin;
  863:   OhMyOpenCodeConfig,
  873: // OpenCode treats ALL exports as plugin instances and calls them.

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\types\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/types/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\mcp\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/mcp/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\mcp\index.ts:
  5: import type { OhMyOpenCodeConfig } from "../config/schema"
  17: export function createBuiltinMcps(disabledMcps: string[] = [], config?: OhMyOpenCodeConfig) {

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/agents/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/cli/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\config-manager.ts:
  4:   getOpenCodeConfigPaths,
  5:   type OpenCodeBinaryType,
  6:   type OpenCodeConfigPaths,
  11: const OPENCODE_BINARIES = ["opencode", "opencode-desktop"] as const
  14:   binary: OpenCodeBinaryType
  16:   paths: OpenCodeConfigPaths
  21: export function initConfigContext(binary: OpenCodeBinaryType, version: string | null): void {
  22:   const paths = getOpenCodeConfigPaths({ binary, version })
  28:     const paths = getOpenCodeConfigPaths({ binary: "opencode", version: null })
  29:     configContext = { binary: "opencode", version: null, paths }
  134: const PACKAGE_NAME = "oh-my-opencode"
  155: interface OpenCodeConfig {
  174:   config: OpenCodeConfig | null
  182: function parseConfig(path: string, _isJsonc: boolean): OpenCodeConfig | null {
  200:     const config = parseJsonc<OpenCodeConfig>(content)
  223: export async function addPluginToOpenCodeConfig(currentVersion: string): Promise<ConfigMergeResult> {
  235:       const config: OpenCodeConfig = { plugin: [pluginEntry] }
  279:     return { success: false, configPath: path, error: formatErrorWithSuggestion(err, "update opencode config") }
  357:     return { success: false, configPath: omoConfigPath, error: formatErrorWithSuggestion(err, "write oh-my-opencode config") }
  361: interface OpenCodeBinaryResult {
  362:   binary: OpenCodeBinaryType
  366: async function findOpenCodeBinaryWithVersion(): Promise<OpenCodeBinaryResult | null> {
  367:   for (const binary of OPENCODE_BINARIES) {
  387: export async function isOpenCodeInstalled(): Promise<boolean> {
  388:   const result = await findOpenCodeBinaryWithVersion()
  392: export async function getOpenCodeVersion(): Promise<string | null> {
  393:   const result = await findOpenCodeBinaryWithVersion()
  407:     let existingConfig: OpenCodeConfig | null = null
  420:       const version = await fetchLatestVersion("opencode-antigravity-auth")
  421:       const pluginEntry = version ? `opencode-antigravity-auth@${version}` : "opencode-antigravity-auth"
  422:       if (!plugins.some((p) => p.startsWith("opencode-antigravity-auth"))) {
  473:         error: `bun install timed out after ${BUN_INSTALL_TIMEOUT_SECONDS} seconds. Try running manually: cd ~/.config/opencode && bun i`,
  500:  * Since opencode-antigravity-auth v1.3.0, models use a variant system:
  507:  * @see https://github.com/NoeFabris/opencode-antigravity-auth#models
  572:     let existingConfig: OpenCodeConfig | null = null
  601: function detectProvidersFromOmoConfig(): { hasOpenAI: boolean; hasOpencodeZen: boolean; hasZaiCodingPlan: boolean; hasKimiForCoding: boolean } {
  604:     return { hasOpenAI: true, hasOpencodeZen: true, hasZaiCodingPlan: false, hasKimiForCoding: false }
  611:       return { hasOpenAI: true, hasOpencodeZen: true, hasZaiCodingPlan: false, hasKimiForCoding: false }
  616:     const hasOpencodeZen = configStr.includes('"opencode/')
  620:     return { hasOpenAI, hasOpencodeZen, hasZaiCodingPlan, hasKimiForCoding }
  622:     return { hasOpenAI: true, hasOpencodeZen: true, hasZaiCodingPlan: false, hasKimiForCoding: false }
  634:     hasOpencodeZen: true,
  649:   const openCodeConfig = parseResult.config
  650:   const plugins = openCodeConfig.plugin ?? []
  651:   result.isInstalled = plugins.some((p) => p.startsWith("oh-my-opencode"))
  658:   result.hasGemini = plugins.some((p) => p.startsWith("opencode-antigravity-auth"))
  660:   const { hasOpenAI, hasOpencodeZen, hasZaiCodingPlan, hasKimiForCoding } = detectProvidersFromOmoConfig()
  662:   result.hasOpencodeZen = hasOpencodeZen

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\AGENTS.md:
  5: CLI entry: `bunx oh-my-opencode`. 4 commands with Commander.js + @clack/prompts TUI.
  25: │       ├── version.ts    # OpenCode + plugin version
  54: | installation | opencode, plugin |
  78: - **Hardcoded paths**: Use `getOpenCodeConfigPaths()` from `config-manager.ts`

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\explore.ts:
  1: import type { AgentConfig } from "@opencode-ai/sdk"
  38:       'Contextual grep for codebases. Answers "Where is X?", "Which file has Y?", "Find the code that does Z". Fire multiple in parallel for broad searches. Specify thoroughness: "quick" for basic, "medium" for moderate, "very thorough" for comprehensive analysis. (Explore - OhMyOpenCode)',

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\config-manager.test.ts:
  26:     expect(result).toBe("oh-my-opencode@latest")
  42:     expect(result).toBe("oh-my-opencode@beta")
  58:     expect(result).toBe("oh-my-opencode@next")
  74:     expect(result).toBe("oh-my-opencode@3.0.0-beta.2")
  85:     expect(result).toBe("oh-my-opencode@3.0.0-beta.3")
  101:     expect(result).toBe("oh-my-opencode@2.14.0")
  117:     expect(result).toBe("oh-my-opencode@latest")
  138:     const result = await fetchNpmDistTags("oh-my-opencode")
  149:     const result = await fetchNpmDistTags("oh-my-opencode")
  165:     const result = await fetchNpmDistTags("oh-my-opencode")
  251:       hasOpencodeZen: false,
  260:     expect(result.$schema).toBe("https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json")
  273:       hasOpencodeZen: false,
  293:       hasOpencodeZen: false,
  313:       hasOpencodeZen: false,
  322:     expect(result.$schema).toBe("https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json")
  334:       hasOpencodeZen: false,
  356:       hasOpencodeZen: false,
  380:       hasOpencodeZen: false,
  400:       hasOpencodeZen: false,

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\hephaestus.ts:
  1: import type { AgentConfig } from "@opencode-ai/sdk"
  608:       "Autonomous Deep Worker - goal-oriented execution with GPT 5.2 Codex. Explores thoroughly before acting, uses explore/librarian agents for comprehensive context, completes tasks end-to-end. Inspired by AmpCode deep mode. (Hephaestus - OhMyOpenCode)",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\metis.ts:
  1: import type { AgentConfig } from "@opencode-ai/sdk"
  316:       "Pre-planning consultant that analyzes requests to identify hidden intentions, ambiguities, and AI failure points. (Metis - OhMyOpenCode)",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\librarian.ts:
  1: import type { AgentConfig } from "@opencode-ai/sdk"
  35:       "Specialized codebase understanding agent for multi-repository analysis, searching remote codebases, retrieving official documentation, and finding implementation examples using GitHub CLI, Context7, and Web Search. MUST BE USED when users ask to look up code in remote repositories, explain library internals, or find usage examples in open source. (Librarian - OhMyOpenCode)",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\momus.ts:
  1: import type { AgentConfig } from "@opencode-ai/sdk"
  201:       "Expert reviewer for evaluating work plans against rigorous clarity, verifiability, and completeness standards. (Momus - OhMyOpenCode)",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\atlas\index.ts:
  12: import type { AgentConfig } from "@opencode-ai/sdk"
  114:       "Orchestrates work via delegate_task() to complete ALL tasks in a todo list until fully done. (Atlas - OhMyOpenCode)",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\multimodal-looker.ts:
  1: import type { AgentConfig } from "@opencode-ai/sdk"
  19:       "Analyze media files (PDFs, images, diagrams) that require interpretation beyond raw text. Extracts specific information or summaries from documents, describes visual content. Use when you need analyzed/extracted data rather than literal file contents. (Multimodal-Looker - OhMyOpenCode)",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\model-fallback.test.ts:
  13:     hasOpencodeZen: false,
  136:     test("uses OpenCode Zen models when only OpenCode Zen is available", () => {
  137:       // #given only OpenCode Zen is available
  138:       const config = createConfig({ hasOpencodeZen: true })
  143:       // #then should use OPENCODE_ZEN_MODELS
  147:     test("uses OpenCode Zen models with isMax20 flag", () => {
  148:       // #given OpenCode Zen is available with Max 20 plan
  149:       const config = createConfig({ hasOpencodeZen: true, isMax20: true })
  204:     test("uses Claude + OpenCode Zen combination", () => {
  205:       // #given Claude and OpenCode Zen are available
  208:         hasOpencodeZen: true,
  214:       // #then should prefer Claude (native) over OpenCode Zen
  263:         hasOpencodeZen: true,
  271:       // #then should prefer OpenCode Zen, but librarian uses ZAI
  281:         hasOpencodeZen: true,
  299:         hasOpencodeZen: true,
  322:       expect(result.agents?.explore?.model).toBe("opencode/gpt-5-nano")
  355:       expect(result.agents?.explore?.model).toBe("opencode/gpt-5-nano")
  387:         hasOpencodeZen: true,
  436:     test("Hephaestus is created when OpenCode Zen is available (has gpt-5.2-codex)", () => {
  438:       const config = createConfig({ hasOpencodeZen: true })
  444:       expect(result.agents?.hephaestus?.model).toBe("opencode/gpt-5.2-codex")
  504:       // #then librarian should use claude-sonnet-4-5 (third in fallback chain after ZAI and opencode/glm)
  519:         "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json"

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\atlas\gpt.ts:
  21: You are Atlas - Master Orchestrator from OhMyOpenCode.

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\oracle.ts:
  1: import type { AgentConfig } from "@opencode-ai/sdk"
  155:       "Read-only consultation agent. High-IQ reasoning specialist for debugging hard problems and high-difficulty architecture design. (Oracle - OhMyOpenCode)",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\atlas\default.ts:
  13: You are Atlas - the Master Orchestrator from OhMyOpenCode.

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\atlas\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/agents/atlas/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\get-local-version\formatter.ts:
  18:   lines.push(color.bold(color.white("oh-my-opencode Version Information")))
  40:       lines.push(`  ${color.dim("Run:")} ${color.cyan("cd ~/.config/opencode && bun update oh-my-opencode")}`)

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\__snapshots__\model-fallback.test.ts.snap:
  5:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  8:       "model": "opencode/glm-4.7-free",
  11:       "model": "opencode/glm-4.7-free",
  14:       "model": "opencode/glm-4.7-free",
  17:       "model": "opencode/glm-4.7-free",
  20:       "model": "opencode/glm-4.7-free",
  23:       "model": "opencode/glm-4.7-free",
  26:       "model": "opencode/glm-4.7-free",
  29:       "model": "opencode/glm-4.7-free",
  32:       "model": "opencode/glm-4.7-free",
  37:       "model": "opencode/glm-4.7-free",
  40:       "model": "opencode/glm-4.7-free",
  43:       "model": "opencode/glm-4.7-free",
  46:       "model": "opencode/glm-4.7-free",
  49:       "model": "opencode/glm-4.7-free",
  52:       "model": "opencode/glm-4.7-free",
  55:       "model": "opencode/glm-4.7-free",
  58:       "model": "opencode/glm-4.7-free",
  66:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  128:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  191:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  197:       "model": "opencode/gpt-5-nano",
  204:       "model": "opencode/glm-4.7-free",
  232:       "model": "opencode/glm-4.7-free",
  247:       "model": "opencode/glm-4.7-free",
  258:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  264:       "model": "opencode/gpt-5-nano",
  271:       "model": "opencode/glm-4.7-free",
  299:       "model": "opencode/glm-4.7-free",
  314:       "model": "opencode/glm-4.7-free",
  325:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  331:       "model": "opencode/gpt-5-nano",
  334:       "model": "opencode/glm-4.7-free",
  385:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  391:       "model": "opencode/gpt-5-nano",
  394:       "model": "opencode/glm-4.7-free",
  445:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  518:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  590: exports[`generateModelConfig fallback providers uses OpenCode Zen models when only OpenCode Zen is available 1`] = `
  592:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  595:       "model": "opencode/kimi-k2.5-free",
  598:       "model": "opencode/claude-haiku-4-5",
  601:       "model": "opencode/gpt-5.2-codex",
  605:       "model": "opencode/glm-4.7-free",
  608:       "model": "opencode/claude-opus-4-5",
  612:       "model": "opencode/gpt-5.2",
  616:       "model": "opencode/gemini-3-flash",
  619:       "model": "opencode/gpt-5.2",
  623:       "model": "opencode/claude-opus-4-5",
  627:       "model": "opencode/claude-opus-4-5",
  633:       "model": "opencode/gemini-3-pro",
  637:       "model": "opencode/gpt-5.2-codex",
  641:       "model": "opencode/claude-haiku-4-5",
  644:       "model": "opencode/gpt-5.2-codex",
  648:       "model": "opencode/claude-sonnet-4-5",
  651:       "model": "opencode/claude-sonnet-4-5",
  654:       "model": "opencode/gemini-3-pro",
  657:       "model": "opencode/gemini-3-flash",
  663: exports[`generateModelConfig fallback providers uses OpenCode Zen models with isMax20 flag 1`] = `
  665:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  668:       "model": "opencode/kimi-k2.5-free",
  671:       "model": "opencode/claude-haiku-4-5",
  674:       "model": "opencode/gpt-5.2-codex",
  678:       "model": "opencode/glm-4.7-free",
  681:       "model": "opencode/claude-opus-4-5",
  685:       "model": "opencode/gpt-5.2",
  689:       "model": "opencode/gemini-3-flash",
  692:       "model": "opencode/gpt-5.2",
  696:       "model": "opencode/claude-opus-4-5",
  700:       "model": "opencode/claude-opus-4-5",
  706:       "model": "opencode/gemini-3-pro",
  710:       "model": "opencode/gpt-5.2-codex",
  714:       "model": "opencode/claude-haiku-4-5",
  717:       "model": "opencode/gpt-5.2-codex",
  721:       "model": "opencode/claude-opus-4-5",
  725:       "model": "opencode/claude-sonnet-4-5",
  728:       "model": "opencode/gemini-3-pro",
  731:       "model": "opencode/gemini-3-flash",
  739:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  812:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  886:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  889:       "model": "opencode/glm-4.7-free",
  892:       "model": "opencode/gpt-5-nano",
  898:       "model": "opencode/glm-4.7-free",
  901:       "model": "opencode/glm-4.7-free",
  907:       "model": "opencode/glm-4.7-free",
  910:       "model": "opencode/glm-4.7-free",
  918:       "model": "opencode/glm-4.7-free",
  921:       "model": "opencode/glm-4.7-free",
  924:       "model": "opencode/glm-4.7-free",
  927:       "model": "opencode/glm-4.7-free",
  941:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  944:       "model": "opencode/glm-4.7-free",
  947:       "model": "opencode/gpt-5-nano",
  953:       "model": "opencode/glm-4.7-free",
  956:       "model": "opencode/glm-4.7-free",
  962:       "model": "opencode/glm-4.7-free",
  965:       "model": "opencode/glm-4.7-free",
  973:       "model": "opencode/glm-4.7-free",
  976:       "model": "opencode/glm-4.7-free",
  979:       "model": "opencode/glm-4.7-free",
  982:       "model": "opencode/glm-4.7-free",
  994: exports[`generateModelConfig mixed provider scenarios uses Claude + OpenCode Zen combination 1`] = `
  996:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  999:       "model": "opencode/kimi-k2.5-free",
  1005:       "model": "opencode/gpt-5.2-codex",
  1009:       "model": "opencode/glm-4.7-free",
  1016:       "model": "opencode/gpt-5.2",
  1020:       "model": "opencode/gemini-3-flash",
  1023:       "model": "opencode/gpt-5.2",
  1037:       "model": "opencode/gemini-3-pro",
  1041:       "model": "opencode/gpt-5.2-codex",
  1048:       "model": "opencode/gpt-5.2-codex",
  1058:       "model": "opencode/gemini-3-pro",
  1061:       "model": "opencode/gemini-3-flash",
  1069:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  1142:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  1204:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  1269:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  1272:       "model": "opencode/kimi-k2.5-free",
  1275:       "model": "opencode/claude-haiku-4-5",
  1342:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  1345:       "model": "opencode/kimi-k2.5-free",
  1415:   "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  1418:       "model": "opencode/kimi-k2.5-free",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\get-local-version\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/cli/get-local-version/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\install.test.ts:
  16:   let isOpenCodeInstalledSpy: ReturnType<typeof spyOn>
  17:   let getOpenCodeVersionSpy: ReturnType<typeof spyOn>
  24:     originalEnv = process.env.OPENCODE_CONFIG_DIR
  25:     process.env.OPENCODE_CONFIG_DIR = tempDir
  29:     configManager.initConfigContext("opencode", null)
  38:       process.env.OPENCODE_CONFIG_DIR = originalEnv
  40:       delete process.env.OPENCODE_CONFIG_DIR
  47:     isOpenCodeInstalledSpy?.mockRestore()
  48:     getOpenCodeVersionSpy?.mockRestore()
  51:   test("non-TUI mode: should show warning but continue when OpenCode binary not found", async () => {
  52:     // given OpenCode binary is NOT installed
  53:     isOpenCodeInstalledSpy = spyOn(configManager, "isOpenCodeInstalled").mockResolvedValue(false)
  54:     getOpenCodeVersionSpy = spyOn(configManager, "getOpenCodeVersion").mockResolvedValue(null)
  62:       opencodeZen: "no",
  75:     expect(allCalls).toContain("OpenCode")
  78:   test("non-TUI mode: should create opencode.json with plugin even when binary not found", async () => {
  79:     // given OpenCode binary is NOT installed
  80:     isOpenCodeInstalledSpy = spyOn(configManager, "isOpenCodeInstalled").mockResolvedValue(false)
  81:     getOpenCodeVersionSpy = spyOn(configManager, "getOpenCodeVersion").mockResolvedValue(null)
  97:       opencodeZen: "no",
  104:     // then should create opencode.json
  105:     const configPath = join(tempDir, "opencode.json")
  108:     // then opencode.json should have plugin entry
  111:     expect(config.plugin.some((p: string) => p.includes("oh-my-opencode"))).toBe(true)
  118:     // given OpenCode binary IS installed
  119:     isOpenCodeInstalledSpy = spyOn(configManager, "isOpenCodeInstalled").mockResolvedValue(true)
  120:     getOpenCodeVersionSpy = spyOn(configManager, "getOpenCodeVersion").mockResolvedValue("1.0.200")
  136:       opencodeZen: "no",
  149:     expect(allCalls).toContain("OpenCode 1.0.200")

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\types.ts:
  10:   opencodeZen?: BooleanArg
  22:   hasOpencodeZen: boolean
  40:   hasOpencodeZen: boolean

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\index.ts:
  19:   .name("oh-my-opencode")
  20:   .description("The ultimate OpenCode plugin - multi-model orchestration, LSP tools, and more")
  25:   .description("Install and configure oh-my-opencode with interactive setup")
  31:   .option("--opencode-zen <value>", "OpenCode Zen access: no, yes (default: no)")
  37:   $ bunx oh-my-opencode install
  38:   $ bunx oh-my-opencode install --no-tui --claude=max20 --openai=yes --gemini=yes --copilot=no
  39:   $ bunx oh-my-opencode install --no-tui --claude=no --gemini=no --copilot=yes --opencode-zen=yes
  41: Model Providers (Priority: Native > Copilot > OpenCode Zen > Z.ai > Kimi):
  46:   OpenCode Zen  opencode/ models (opencode/claude-opus-4-5, etc.)
  57:       opencodeZen: options.opencodeZen,
  68:   .description("Run opencode with todo/background task completion enforcement")
  74:   $ bunx oh-my-opencode run "Fix the bug in index.ts"
  75:   $ bunx oh-my-opencode run --agent Sisyphus "Implement feature X"
  76:   $ bunx oh-my-opencode run --timeout 3600000 "Large refactoring task"
  80:   2) OPENCODE_DEFAULT_AGENT
  81:   3) oh-my-opencode.json "default_run_agent"
  87: Unlike 'opencode run', this command waits until:
  109:   $ bunx oh-my-opencode get-local-version
  110:   $ bunx oh-my-opencode get-local-version --json
  111:   $ bunx oh-my-opencode get-local-version --directory /path/to/project
  130:   .description("Check oh-my-opencode installation health and diagnose issues")
  136:   $ bunx oh-my-opencode doctor
  137:   $ bunx oh-my-opencode doctor --verbose
  138:   $ bunx oh-my-opencode doctor --json
  139:   $ bunx oh-my-opencode doctor --category authentication
  142:   installation     Check OpenCode and plugin installation
  163:     console.log(`oh-my-opencode v${VERSION}`)

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\model-fallback.ts:
  14:   opencodeZen: boolean
  40: const ULTIMATE_FALLBACK = "opencode/glm-4.7-free"
  41: const SCHEMA_URL = "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json"
  50:     opencodeZen: config.hasOpencodeZen,
  64:     opencode: avail.opencodeZen,
  131:     avail.opencodeZen ||
  162:       } else if (avail.opencodeZen) {
  163:         agents[role] = { model: "opencode/claude-haiku-4-5" }
  167:         agents[role] = { model: "opencode/gpt-5-nano" }

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\utils.ts:
  1: import type { AgentConfig } from "@opencode-ai/sdk"
  16: import { resolveMultipleSkills } from "../features/opencode-skill-loader/skill-content"
  18: import type { LoadedSkill, SkillScope } from "../features/opencode-skill-loader/types"
  97:  * Note: Working directory, platform, and date are already provided by OpenCode's system.ts,
  98:  * so we only include fields that OpenCode doesn't provide to avoid duplication.
  99:  * See: https://github.com/code-yeongyu/oh-my-opencode/issues/379
  223:   if (scope === "user" || scope === "opencode") return "user"
  224:   if (scope === "project" || scope === "opencode-project") return "project"
  244:   // See: https://github.com/code-yeongyu/oh-my-opencode/issues/1301

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\claude-code-mcp-loader\index.ts:
  5:  * and transforms them to OpenCode SDK format

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\install.ts:
  5:   addPluginToOpenCodeConfig,
  7:   isOpenCodeInstalled,
  8:   getOpenCodeVersion,
  46:   lines.push(formatProvider("OpenCode Zen", config.hasOpencodeZen, "opencode/ models"))
  57:   lines.push(`  ${SYMBOLS.bullet} Priority: Native > Copilot > OpenCode Zen > Z.ai`)
  137:   if (args.opencodeZen !== undefined && !["no", "yes"].includes(args.opencodeZen)) {
  138:     errors.push(`Invalid --opencode-zen value: ${args.opencodeZen} (expected: no, yes)`)
  159:     hasOpencodeZen: args.opencodeZen === "yes",
  165: function detectedToInitialValues(detected: DetectedConfig): { claude: ClaudeSubscription; openai: BooleanArg; gemini: BooleanArg; copilot: BooleanArg; opencodeZen: BooleanArg; zaiCodingPlan: BooleanArg; kimiForCoding: BooleanArg } {
  176:     opencodeZen: detected.hasOpencodeZen ? "yes" : "no",
  188:       { value: "no" as const, label: "No", hint: "Will use opencode/glm-4.7-free as fallback" },
  242:   const opencodeZen = await p.select({
  243:     message: "Do you have access to OpenCode Zen (opencode/ models)?",
  246:       { value: "yes" as const, label: "Yes", hint: "opencode/claude-opus-4-5, opencode/gpt-5.2, etc." },
  248:     initialValue: initial.opencodeZen,
  251:   if (p.isCancel(opencodeZen)) {
  290:     hasOpencodeZen: opencodeZen === "yes",
  305:     printInfo("Usage: bunx oh-my-opencode install --no-tui --claude=<no|yes|max20> --gemini=<no|yes> --copilot=<no|yes>")
  318:   printStep(step++, totalSteps, "Checking OpenCode installation...")
  319:   const installed = await isOpenCodeInstalled()
  320:   const version = await getOpenCodeVersion()
  322:     printWarning("OpenCode binary not found. Plugin will be configured, but you'll need to install OpenCode to use it.")
  323:     printInfo("Visit https://opencode.ai/docs for installation instructions")
  325:     printSuccess(`OpenCode ${version ?? ""} detected`)
  335:   printStep(step++, totalSteps, "Adding oh-my-opencode plugin...")
  336:   const pluginResult = await addPluginToOpenCodeConfig(VERSION)
  363:   printStep(step++, totalSteps, "Writing oh-my-opencode configuration...")
  387:   if (!config.hasClaude && !config.hasOpenAI && !config.hasGemini && !config.hasCopilot && !config.hasOpencodeZen) {
  388:     printWarning("No model providers configured. Using opencode/glm-4.7-free as fallback.")
  392:   console.log(`  Run ${color.cyan("opencode")} to start!`)
  403:   console.log(`  ${color.dim("gh api --silent --method PUT /user/starred/code-yeongyu/oh-my-opencode >/dev/null 2>&1 || true")}`)
  410:       `Run ${color.cyan("opencode auth login")} and select your provider:\n` +
  437:   s.start("Checking OpenCode installation")
  439:   const installed = await isOpenCodeInstalled()
  440:   const version = await getOpenCodeVersion()
  442:     s.stop(`OpenCode binary not found ${color.yellow("[!]")}`)
  443:     p.log.warn("OpenCode binary not found. Plugin will be configured, but you'll need to install OpenCode to use it.")
  444:     p.note("Visit https://opencode.ai/docs for installation instructions", "Installation Guide")
  446:     s.stop(`OpenCode ${version ?? "installed"} ${color.green("[OK]")}`)
  452:   s.start("Adding oh-my-opencode to OpenCode config")
  453:   const pluginResult = await addPluginToOpenCodeConfig(VERSION)
  481:   s.start("Writing oh-my-opencode configuration")
  504:   if (!config.hasClaude && !config.hasOpenAI && !config.hasGemini && !config.hasCopilot && !config.hasOpencodeZen) {
  505:     p.log.warn("No model providers configured. Using opencode/glm-4.7-free as fallback.")
  511:   p.log.message(`Run ${color.cyan("opencode")} to start!`)
  521:   p.log.message(`  ${color.dim("gh api --silent --method PUT /user/starred/code-yeongyu/oh-my-opencode >/dev/null 2>&1 || true")}`)
  534:     console.log(`   Run ${color.cyan("opencode auth login")} and select:`)

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\claude-code-mcp-loader\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/claude-code-mcp-loader/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\utils.test.ts:
  3: import type { AgentConfig } from "@opencode-ai/sdk"
  4: import { clearSkillCache } from "../features/opencode-skill-loader/skill-content"
  18:         "opencode/kimi-k2.5-free",
  20:         "opencode/glm-4.7-free",
  217:       "anthropic", "kimi-for-coding", "opencode", "zai-coding-plan"
  223:         "opencode/kimi-k2.5-free",
  225:         "opencode/glm-4.7-free",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\doctor\types.ts:
  50: export interface OpenCodeInfo {
  54:   binary: "opencode" | "opencode-desktop" | null

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\types.ts:
  1: import type { AgentConfig } from "@opencode-ai/sdk"
  7:  * - "all": Available in both contexts (OpenCode compatibility)

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\mcp-oauth\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/cli/mcp-oauth/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\tmux-subagent\manager.ts:
  1: import type { PluginInput } from "@opencode-ai/plugin"
  17: type OpencodeClient = PluginInput["client"]
  54:   private client: OpencodeClient
  67:     const defaultPort = process.env.OPENCODE_PORT ?? "4096"

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\sisyphus.ts:
  1: import type { AgentConfig } from "@opencode-ai/sdk"
  166: You are "Sisyphus" - Powerful AI Agent with orchestration capabilities from OhMyOpenCode.
  515:       "Powerful AI orchestrator. Plans obsessively with todos, assesses search complexity before exploration, delegates strategically via category+skills combinations. Uses explore for internal code (parallel-friendly), librarian for external docs. (Sisyphus - OhMyOpenCode)",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\run\types.ts:
  1: import type { OpencodeClient } from "@opencode-ai/sdk"
  11:   client: OpencodeClient

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\mcp-oauth\logout.test.ts:
  14:     originalConfigDir = process.env.OPENCODE_CONFIG_DIR
  15:     process.env.OPENCODE_CONFIG_DIR = TEST_CONFIG_DIR
  23:       delete process.env.OPENCODE_CONFIG_DIR
  25:       process.env.OPENCODE_CONFIG_DIR = originalConfigDir

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\run\runner.ts:
  1: import { createOpencode } from "@opencode-ai/sdk"
  6: import type { OhMyOpenCodeConfig } from "../../config"
  28: const isAgentDisabled = (agent: string, config: OhMyOpenCodeConfig): boolean => {
  38: const pickFallbackAgent = (config: OhMyOpenCodeConfig): string => {
  49:   pluginConfig: OhMyOpenCodeConfig,
  53:   const envAgent = normalizeAgentName(env.OPENCODE_DEFAULT_AGENT)
  83:   process.env.OPENCODE_CLI_RUN_MODE = "true"
  93:   console.log(pc.cyan("Starting opencode server (auto port selection enabled)..."))
  107:     const envPort = process.env.OPENCODE_SERVER_PORT
  108:       ? parseInt(process.env.OPENCODE_SERVER_PORT, 10)
  110:     const serverHostname = process.env.OPENCODE_SERVER_HOSTNAME || "127.0.0.1"
  121:     const { client, server } = await createOpencode({
  146:           body: { title: "oh-my-opencode run" },

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\claude-code-command-loader\types.ts:
  1: export type CommandScope = "user" | "project" | "opencode" | "opencode-project"

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\prometheus\interview-mode.ts:
  21: | **Mid-sized Task** | Scoped feature (onboarding flow, API endpoint) | **Boundary focus**: Clear deliverables, explicit exclusions, guardrails |

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\doctor\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/cli/doctor/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\run\runner.test.ts:
  2: import type { OhMyOpenCodeConfig } from "../../config"
  5: const createConfig = (overrides: Partial<OhMyOpenCodeConfig> = {}): OhMyOpenCodeConfig => ({
  13:     const env = { OPENCODE_DEFAULT_AGENT: "Atlas" }
  29:     const env = { OPENCODE_DEFAULT_AGENT: "Atlas" }

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\doctor\constants.ts:
  21:   OPENCODE_INSTALLATION: "opencode-installation",
  40:   [CHECK_IDS.OPENCODE_INSTALLATION]: "OpenCode Installation",
  72: export const MIN_OPENCODE_VERSION = "1.0.150"
  74: export const PACKAGE_NAME = "oh-my-opencode"
  76: export const OPENCODE_BINARIES = ["opencode", "opencode-desktop"] as const

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\claude-code-command-loader\loader.ts:
  6: import { getClaudeConfigDir, getOpenCodeConfigDir } from "../../shared"
  75:       const isOpencodeSource = scope === "opencode" || scope === "opencode-project"
  81:         model: sanitizeModelField(data.model, isOpencodeSource ? "opencode" : "claude-code"),
  105:     const { name: _name, argumentHint: _argumentHint, ...openCodeCompatible } = cmd.definition
  106:     result[cmd.name] = openCodeCompatible as CommandDefinition
  123: export async function loadOpencodeGlobalCommands(): Promise<Record<string, CommandDefinition>> {
  124:   const configDir = getOpenCodeConfigDir({ binary: "opencode" })
  125:   const opencodeCommandsDir = join(configDir, "command")
  126:   const commands = await loadCommandsFromDir(opencodeCommandsDir, "opencode")
  130: export async function loadOpencodeProjectCommands(): Promise<Record<string, CommandDefinition>> {
  131:   const opencodeProjectDir = join(process.cwd(), ".opencode", "command")
  132:   const commands = await loadCommandsFromDir(opencodeProjectDir, "opencode-project")
  137:   const [user, project, global, projectOpencode] = await Promise.all([
  140:     loadOpencodeGlobalCommands(),
  141:     loadOpencodeProjectCommands(),
  143:   return { ...projectOpencode, ...global, ...project, ...user }

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\prometheus\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/agents/prometheus/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\tmux-subagent\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/tmux-subagent/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\prometheus\index.ts:
  40:  * Question permission allows agent to ask user questions via OpenCode's QuestionTool.

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\sisyphus-junior\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/agents/sisyphus-junior/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\tools\task\todo-sync.ts:
  1: import type { PluginInput } from "@opencode-ai/plugin";
  67:     const loader = "opencode/session/todo";

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\claude-code-command-loader\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/claude-code-command-loader/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\sisyphus-junior\default.ts:
  20: Sisyphus-Junior - Focused executor from OhMyOpenCode.

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\sisyphus-junior\gpt.ts:
  29: You are Sisyphus-Junior - Focused task executor from OhMyOpenCode.

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\tools\task\todo-sync.test.ts:
  298:   it("fetches current todos from OpenCode", async () => {

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\agents\sisyphus-junior\index.ts:
  12: import type { AgentConfig } from "@opencode-ai/sdk"
  97:       "Focused task executor. Same discipline, no delegation. (Sisyphus-Junior - OhMyOpenCode)",

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\run\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/cli/run/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\tools\task\task.ts:
  1: import { tool, type ToolDefinition } from "@opencode-ai/plugin/tool"
  4: import type { OhMyOpenCodeConfig } from "../../config/schema"
  37: export function createTask(config: Partial<OhMyOpenCodeConfig>): ToolDefinition {
  91:   config: Partial<OhMyOpenCodeConfig>,
  127:   config: Partial<OhMyOpenCodeConfig>
  188:   config: Partial<OhMyOpenCodeConfig>
  205:   config: Partial<OhMyOpenCodeConfig>
  258:   config: Partial<OhMyOpenCodeConfig>

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\tools\task\task.test.ts:
  177:         repoURL: "https://github.com/code-yeongyu/oh-my-opencode",
  185:       expect(result.task.repoURL).toBe("https://github.com/code-yeongyu/oh-my-opencode")

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\tools\task\task-update.ts:
  1: import type { PluginInput } from "@opencode-ai/plugin";
  2: import { tool, type ToolDefinition } from "@opencode-ai/plugin/tool";
  4: import type { OhMyOpenCodeConfig } from "../../config/schema";
  23:   config: Partial<OhMyOpenCodeConfig>,
  32: Syncs to OpenCode Todo API after update.
  74:   config: Partial<OhMyOpenCodeConfig>,

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\write-existing-file-guard\index.ts:
  1: import type { Hooks, PluginInput } from "@opencode-ai/plugin"

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\tools\task\task-list.ts:
  1: import { tool, type ToolDefinition } from "@opencode-ai/plugin/tool"
  4: import type { OhMyOpenCodeConfig } from "../../config/schema"
  17: export function createTaskList(config: Partial<OhMyOpenCodeConfig>): ToolDefinition {

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\task-toast-manager\manager.ts:
  1: import type { PluginInput } from "@opencode-ai/plugin"
  5: type OpencodeClient = PluginInput["client"]
  9:   private client: OpencodeClient
  12:   constructor(client: OpencodeClient, concurrencyManager?: ConcurrencyManager) {
  214:   client: OpencodeClient,

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\claude-code-agent-loader\types.ts:
  1: import type { AgentConfig } from "@opencode-ai/sdk"

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\write-existing-file-guard\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/hooks/write-existing-file-guard/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\tools\task\task-get.ts:
  1: import { tool, type ToolDefinition } from "@opencode-ai/plugin/tool"
  3: import type { OhMyOpenCodeConfig } from "../../config/schema"
  15: export function createTaskGetTool(config: Partial<OhMyOpenCodeConfig>): ToolDefinition {

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\config\schema.ts:
  45:   "OpenCode-Builder",
  126:   /** Maximum tokens for response. Passed directly to OpenCode SDK. */
  137:   /** Provider-specific options. Passed directly to OpenCode SDK. */
  147:   "OpenCode-Builder": AgentOverrideConfigSchema.optional(),
  304:   /** Custom state file directory relative to project root (default: .opencode/) */
  383: export const OhMyOpenCodeConfigSchema = z.object({
  387:   /** Default agent name for `oh-my-opencode run` (env: OPENCODE_DEFAULT_AGENT) */
  415: export type OhMyOpenCodeConfig = z.infer<typeof OhMyOpenCodeConfigSchema>

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\claude-code-agent-loader\loader.ts:
  3: import type { AgentConfig } from "@opencode-ai/sdk"

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\config\schema.test.ts:
  8:   OhMyOpenCodeConfigSchema,
  19:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  35:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  51:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  67:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  83:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  94:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  110:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  129:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  407:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  429:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  454:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  483:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  508:     const result = OhMyOpenCodeConfigSchema.safeParse(config)
  580: describe("OhMyOpenCodeConfigSchema - browser_automation_engine", () => {
  590:     const result = OhMyOpenCodeConfigSchema.safeParse(input)
  602:     const result = OhMyOpenCodeConfigSchema.safeParse(input)

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\task-toast-manager\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/task-toast-manager/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\claude-code-agent-loader\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/claude-code-agent-loader/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\context-injector\injector.ts:
  2: import type { Message, Part } from "@opencode-ai/sdk"

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\tools\task\task-create.ts:
  1: import type { PluginInput } from "@opencode-ai/plugin";
  2: import { tool, type ToolDefinition } from "@opencode-ai/plugin/tool";
  4: import type { OhMyOpenCodeConfig } from "../../config/schema";
  16:   config: Partial<OhMyOpenCodeConfig>,
  61:   config: Partial<OhMyOpenCodeConfig>,

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\config\index.ts:
  2:   OhMyOpenCodeConfigSchema,
  17:   OhMyOpenCodeConfig,

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\builtin-skills\skills\git-master.ts:
  342: Level 3: API endpoints, controllers

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\config\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/config/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\background-agent\constants.ts:
  1: import type { PluginInput } from "@opencode-ai/plugin"
  15: export type OpencodeClient = PluginInput["client"]

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\tools\task\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/tools/task/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\background-agent\spawner.ts:
  2: import type { OpencodeClient, OnSubagentSessionCreated, QueueItem } from "./constants"
  11:   client: OpencodeClient

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\boulder-state\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/boulder-state/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\builtin-skills\skills\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/builtin-skills/skills/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\context-injector\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/context-injector/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\background-agent\result-handler.ts:
  2: import type { OpencodeClient, Todo } from "./constants"
  13:   client: OpencodeClient
  19:   client: OpencodeClient,
  39:   client: OpencodeClient,

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\builtin-commands\commands.ts:
  90:       const { argumentHint: _argumentHint, ...openCodeCompatible } = definition
  91:       commands[name] = { ...openCodeCompatible, name } as CommandDefinition

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\unstable-agent-babysitter\index.test.ts:
  5: const projectDir = "/Users/yeongyu/local-workspaces/oh-my-opencode"

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\builtin-commands\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/builtin-commands/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\cli\doctor\checks\version.ts:
  97:       details: ["Run: bunx oh-my-opencode get-local-version"],
  115:       details: ["Run: cd ~/.config/opencode && bun update oh-my-opencode"],

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\background-agent\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/background-agent/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\unstable-agent-babysitter\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/hooks/unstable-agent-babysitter/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\background-agent\manager.ts:
  2: import type { PluginInput } from "@opencode-ai/plugin"
  30: type OpencodeClient = PluginInput["client"]
  78:   private client: OpencodeClient
  315:     // OpenCode's PromptInput schema expects: { model: { providerID, modelID }, variant: "max" }
  344:           existingTask.error = `Agent "${input.agent}" not found. Make sure the agent is registered in your opencode.json or provided by a plugin.`
  575:     // variant must be top-level in body, not nested inside model (OpenCode PromptInput schema)
  784:       // OpenCode API uses different part types than Anthropic's API:

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\features\builtin-commands\templates\codemap.md:
  1: # References.Architecture/oh-my-opencode/src/features/builtin-commands/templates/

C:\OpenCode\Canon\References.Architecture\oh-my-opencode\src\hooks\tool-output-truncator.ts:
  1: import type { PluginInpu

... (truncated)
```
