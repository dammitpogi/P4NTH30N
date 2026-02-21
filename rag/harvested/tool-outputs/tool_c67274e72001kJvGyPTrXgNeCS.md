# Tool Output: tool_c67274e72001kJvGyPTrXgNeCS
**Date**: 2026-02-16 15:52:35 UTC
**Size**: 53,961 bytes

```

C:\Users\paulc\.config\opencode\agent_install.md:
  3: If you are an LLM agent helping a user install the **oh-my-opencode-theseus** plugin, follow these instructions for a seamless "one-step" setup.
  8: 2.  **OpenCode**: Ensure OpenCode is installed (`opencode --version`).
  21: 1.  **Verifies OpenCode**: Checks if the `opencode` CLI is available.
  22: 2.  **Prepares Config**: Copies agent prompts (`agents/*.md`), custom skills, model intelligence data, and the plugin configuration (`oh-my-opencode-theseus.json`) to `~/.config/opencode/`.
  23: 3.  **Safe Registration**: Safely adds the plugin to the `plugin` array in `~/.config/opencode/opencode.json` without overwriting your existing settings.
  24: 4.  **Builds & Deploys**: Runs `bun install` and `bun run build`, then deploys the built plugin to `~/.cache/opencode/node_modules/oh-my-opencode-theseus`.
  28: 1.  **Restart OpenCode**: Close and reopen your OpenCode session to load the new plugin and agents.
  29: 2.  **Verify Agents**: Run the following command in OpenCode to ensure all agents are responsive:
  35:     opencode auth login
  40: *   **Plugin not loading**: Check `~/.config/opencode/opencode.json` to ensure `"oh-my-opencode-theseus"` is listed in the `plugin` array.
  41: *   **Missing Prompts**: Ensure the `.md` files exist in `~/.config/opencode/agents/`.

C:\Users\paulc\.config\opencode\bun.lock:
  9:         "@opencode-ai/plugin": "1.2.5",
  10:         "@opencode-ai/sdk": "^1.1.19",
  64:     "@opencode-ai/plugin": ["@opencode-ai/plugin@1.2.5", "", { "dependencies": { "@opencode-ai/sdk": "1.2.5", "zod": "4.1.8" } }, "sha512-mZACBKyMMhH87K6HtiigbauLKjK7ooZPVaZTnRs492ldAXhiSfqk28Z8hGYNzhpwpHjkU6Ws8LOJRwOemDVQYg=="],
  66:     "@opencode-ai/sdk": ["@opencode-ai/sdk@1.2.4", "", {}, "sha512-IPgtBpif46wTviC3HQxkjS4M/1tZSnRmD/6aEF3lL88MT+PAqKA30G+AhBlpvXBITq9EmjO4gjzM59ly2z7mYQ=="],
  262:     "@opencode-ai/plugin/@opencode-ai/sdk": ["@opencode-ai/sdk@1.2.5", "", {}, "sha512-oFw08QNupBWuszpLa4HMRf/T+fDVqu8lbYSiqevdFTSH8Zih2cw/vPqLhjHgE6rPOSXyhvg46WivfSO7eNIpPw=="],

C:\Users\paulc\.config\opencode\AGENTS.md:
  8: 	- Fixer: Vigil. He said his name was Vigil. ("C:\OpenCode\Canon\.canon\Vigil\soul.md").
  60: # OpenCode Plugin: oh-my-opencode-theseus
  62: > **Current Context**: This plugin is installed in `C:\Users\paulc\.config\opencode\plugin` and is actively modified to disable hardcoded permission enforcement. See "Critical Modifications" below.
  65: This is a lightweight agent orchestration plugin for OpenCode, built with TypeScript and Bun. It replaces the default single-agent model with a specialized team (Orchestrator, Explorer, Fixer, etc.).
  110: 1. `bun run deploy` (runs full `bun test`, then build + copy to `~/.config/opencode/plugins`)
  159: - The logger writes to `os.tmpdir()/oh-my-opencode-theseus.log` and silently ignores logging errors.
  178: ├── hooks/                # OpenCode hook implementations
  189: This repository has been patched to respect user permissions defined in `opencode.json`.
  208: - **Impact**: Users can customize agent personas directly in `opencode.json`.
  212: - **Change**: Updated `SUBAGENT_DELEGATION_RULES` to match `opencode.json` permissions exactly.
  219:   - Agent delegation now respects user permissions exactly as configured in `opencode.json`
  225:   - Agent prompts now load from `~/.config/opencode/agents/{agentName}.md` files
  227:   - If no markdown file exists, an empty prompt is used (allowing `customPrompt` override in `opencode.json` to work)
  232:   - Create or edit markdown files in `~/.config/opencode/agents/` directory
  264: **Configuration Structure** (in `oh-my-opencode-theseus.json`):
  321: To apply changes to the active OpenCode installation:
  326:     -   Target: `C:\Users\paulc\.cache\opencode\node_modules\oh-my-opencode-theseus`
  329: 4.  **Restart**: Reload the OpenCode window.
  332: - **Permissions**: If an agent is denied access, check `opencode.json` first. The plugin no longer interferes.
  342: **Problem**: After OpenCode reset, the plugin wasn't reading model chains from `oh-my-opencode-theseus.json` config. It fell back to HARDCODED_DEFAULTS instead of reading from config.
  344: **Root Cause**: JSON syntax error in `oh-my-opencode-theseus.json` caused `JSON.parse()` to fail silently. The catch block swallowed the error and returned `null`, resulting in empty config `{}`.
  378: - **Path Resolution**: Config loader uses `os.homedir()` for cross-platform path resolution, ensuring fallback chains and presets from `~/.config/opencode/oh-my-opencode-theseus.json` are loaded correctly on all platforms (including Windows)

C:\Users\paulc\.config\opencode\codemap.md:
  1: # opencode/
  5: This is the user's main OpenCode configuration hub - it provides a sophisticated multi-agent AI coding environment through the `oh-my-opencode-theseus` plugin. The directory contains:
  8: - **Configuration management** - Centralized settings for OpenCode core (`opencode.json`) and plugin behavior (`oh-my-opencode-theseus.json`)
  28: - TypeScript-based plugin (`oh-my-opencode-theseus`) that integrates with OpenCode
  29: - Central configuration: `oh-my-opencode-theseus.json` manages agent models, MCP servers, skills
  35: - `opencode.json` - Main OpenCode settings (providers, plugins, MCP servers, permissions)
  36: - `oh-my-opencode-theseus.json` - Plugin-specific: agent model assignments, disabled MCPs, idle orchestrator
  48: - Providers are configured in `opencode.json` under the top-level `provider` object (custom providers) alongside OpenCode's built-in provider support.
  59: 1. OpenCode reads `opencode.json` on startup → loads plugin, providers, MCP servers
  60: 2. `oh-my-opencode-theseus` plugin initializes → loads agent configs and model assignments
  66: 1. User submits task → OpenCode routes to orchestrator (primary mode)
  77: 3. Fallback triage tracked (`oh-my-opencode-theseus.json` → `fallback.triage`)
  83: 3. Deploy built plugin to `~/.cache/opencode/node_modules/oh-my-opencode-theseus/`
  84: 4. Changes require OpenCode restart for core config, agent restart for prompt changes
  88: ### OpenCode Integration
  89: - Declared as plugin in `opencode.json` → `plugin` array
  91: - Hooks into OpenCode's agent lifecycle via `src/hooks/`
  93: - Task delegation system extends OpenCode's inter-agent communication
  104: - API keys are stored in `opencode.json` provider options (not in `oh-my-opencode-theseus.json`).
  107: - Agents read/write files based on permissions in `opencode.json` → `permission`
  137: - `plugin/src/hooks/` - OpenCode lifecycle hooks (idle-orchestrator, phase-reminder, etc.)

C:\Users\paulc\.config\opencode\CHANGELOG.md:
  9: - **Config Integrity**: Fixed syntax errors in `oh-my-opencode-theseus.json` caused by concurrent writes.

C:\Users\paulc\.config\opencode\oh-my-opencode-theseus.json:
  10:         "opencode/gpt-5-nano",
  13:         "opencode/kimi-k2.5-free",
  14:         "opencode/minimax-m2.5-free",
  20:         "opencode/big-pickle",
  122:         "opencode/big-pickle",
  125:         "opencode/gpt-5-nano",
  156:         "opencode/kimi-k2.5-free",
  158:         "opencode/minimax-m2.5-free",
  208:         "opencode/minimax-m2.5-free",
  211:         "opencode/kimi-k2.5-free",
  226:         "opencode/big-pickle",
  246:         "opencode/gpt-5-nano",
  306:         "opencode/big-pickle",
  320:         "opencode/kimi-k2.5-free",
  322:         "opencode/minimax-m2.5-free",
  329:         "opencode/gpt-5-nano",
  407:         "opencode/gpt-5-nano",
  410:         "opencode/kimi-k2.5-free",
  413:         "opencode/minimax-m2.5-free",
  421:         "opencode/big-pickle",
  502:         "opencode/gpt-5-nano",
  507:         "opencode/big-pickle",
  520:         "opencode/minimax-m2.5-free",
  523:         "opencode/kimi-k2.5-free",
  612:       "opencode/big-pickle": {
  682:       "opencode/kimi-k2.5-free": {

C:\Users\paulc\.config\opencode\opencode.json:
  2:   "$schema": "https://opencode.ai/config.json",
  4:     "opencode-antigravity-auth@latest",
  5:     "./plugins/oh-my-opencode-theseus.js"
  599:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is enabled as primary fixer model. Requirements: (1) ensure `agents.fixer.models` contains `anthropic/claude-opus-4-6` at index 0 exactly once, (2) set `agents.fixer.currentModel` to `anthropic/claude-opus-4-6`, (3) preserve ordering of all non-Opus fixer models, (4) do not modify other agents. Then report the final first 5 entries of `agents.fixer.models`."
  604:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is removed from fixer chain. Requirements: (1) remove all `anthropic/claude-opus-4-6` entries from `agents.fixer.models`, (2) set `agents.fixer.currentModel` to the first remaining fixer model, (3) preserve ordering of remaining fixer models, (4) do not modify other agents. Then report the new `agents.fixer.currentModel` and first 5 entries of `agents.fixer.models`."
  609:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is enabled as primary fixer model. Requirements: (1) ensure `agents.fixer.models` contains `anthropic/claude-opus-4-6` at index 0 exactly once, (2) set `agents.fixer.currentModel` to `anthropic/claude-opus-4-6`, (3) preserve ordering of all non-Opus fixer models, (4) do not modify other agents. Then report the final first 5 entries of `agents.fixer.models`."
  614:       "template": "Update `C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json` so Opus is removed from fixer chain. Requirements: (1) remove all `anthropic/claude-opus-4-6` entries from `agents.fixer.models`, (2) set `agents.fixer.currentModel` to the first remaining fixer model, (3) preserve ordering of remaining fixer models, (4) do not modify other agents. Then report the new `agents.fixer.currentModel` and first 5 entries of `agents.fixer.models`."

C:\Users\paulc\.config\opencode\cache\bun.lock:
  7:         "oh-my-opencode-slim": "0.7.0",
  8:         "opencode-anthropic-auth": "0.0.13",
  9:         "opencode-antigravity-auth": "1.5.1",
  36:     "@opencode-ai/plugin": ["@opencode-ai/plugin@1.1.59", "", { "dependencies": { "@opencode-ai/sdk": "1.1.59", "zod": "4.1.8" } }, "sha512-2h/SoyS/OvRYxpT2L0xIil2DnLY7qP+RCnQYz5yZEZNkp4d5f1U2rHhktrpC4hbPahDo7wJRON3W564YflOJ9w=="],
  38:     "@opencode-ai/sdk": ["@opencode-ai/sdk@1.1.59", "", {}, "sha512-g+Z0UQ9qNUcZsX4m/fXG4MHIquYlp4d2wfelRsynMj+AprfZ4He6u9GxAVT0FmLxuutj2ZxTLlspSe1+256pxg=="],
  176:     "oh-my-opencode-slim": ["oh-my-opencode-slim@0.7.0", "", { "dependencies": { "@ast-grep/cli": "^0.40.0", "@modelcontextprotocol/sdk": "^1.25.1", "@opencode-ai/plugin": "^1.1.19", "@opencode-ai/sdk": "^1.1.19", "vscode-jsonrpc": "^8.2.0", "vscode-languageserver-protocol": "^3.17.5", "zod": "^4.1.8" }, "bin": { "oh-my-opencode-slim": "dist/cli/index.js" } }, "sha512-VxDrIPsc98GrHsbIE2swLhVO/F8eL2vnAsKJpTwAlr6qXGZjsyh1Q/+63B/1uynOjlAzg9vXWGr48wnVOsy5JQ=="],
  182:     "opencode-anthropic-auth": ["opencode-anthropic-auth@0.0.13", "", { "dependencies": { "@openauthjs/openauth": "^0.4.3" } }, "sha512-506gj5Gxnn2nTnMhYseWDdBHbpeu3D1H6l+By9mVigmpO0GhzuaeUo9/l19Dq4y8V6BHSfruvtJHBWnQESwIaQ=="],
  184:     "opencode-antigravity-auth": ["opencode-antigravity-auth@1.5.1", "", { "dependencies": { "@openauthjs/openauth": "^0.4.3", "@opencode-ai/plugin": "^0.15.30", "proper-lockfile": "^4.1.2", "xdg-basedir": "^5.1.0", "zod": "^4.0.0" }, "peerDependencies": { "typescript": "^5" } }, "sha512-7G9lUprk8l9Qp3O/6bnmAVPVFb7S6ShLmyHY/hjyndwuOGwPpXwuLnbqjW69Ey44Ddh+jtvon2cchxf/ZxUDfw=="],
  262:     "@opencode-ai/plugin/zod": ["zod@4.1.8", "", {}, "sha512-5R1P+WwQqmmMIEACyzSvo4JXHY5WiAFHRMg+zBZKgKS+Q1viRa0C1hmUKtHltoIFKtIdki3pRxkmpP74jnNYHQ=="],
  266:     "opencode-antigravity-auth/@opencode-ai/plugin": ["@opencode-ai/plugin@0.15.31", "", { "dependencies": { "@opencode-ai/sdk": "0.15.31", "zod": "4.1.8" } }, "sha512-htKKCq9Htljf7vX5ANLDB7bU7TeJYrl8LP2CQUtCAguKUpVvpj5tiZ+edlCdhGFEqlpSp+pkiTEY5LCv1muowg=="],
  270:     "opencode-antigravity-auth/@opencode-ai/plugin/@opencode-ai/sdk": ["@opencode-ai/sdk@0.15.31", "", {}, "sha512-95HWBiNKQnwsubkR2E7QhBD/CH9yteZGrviWar0aKHWu8/RjWw9m7Znbv8DI+y6i2dMwBBcGQ8LJ7x0abzys4A=="],
  272:     "opencode-antigravity-auth/@opencode-ai/plugin/zod": ["zod@4.1.8", "", {}, "sha512-5R1P+WwQqmmMIEACyzSvo4JXHY5WiAFHRMg+zBZKgKS+Q1viRa0C1hmUKtHltoIFKtIdki3pRxkmpP74jnNYHQ=="],

C:\Users\paulc\.config\opencode\README.md:
  13: This method installs OpenCode, the plugin, and **all current configurations** (prompts, model chains, skills) in one step.
  17: curl -fsSL https://raw.githubusercontent.com/dammitpogi/oh-my-opencode-theseus/master/install.sh | bash
  22: irm https://raw.githubusercontent.com/dammitpogi/oh-my-opencode-theseus/master/install.ps1 | iex
  28: The installer can refresh and use OpenCode free models directly:
  31: bunx oh-my-opencode-theseus@latest install --no-tui --kimi=yes --openai=yes --antigravity=yes --chutes=yes --opencode-free=yes --opencode-free-model=auto --tmux=no --skills=yes
  37: opencode auth login
  42: OpenCode free-model mode uses `opencode models --refresh --verbose`, filters to free `opencode/*` models, and applies coding-first selection:
  43: - OpenCode-only mode can use multiple OpenCode free models across agents.
  44: - Hybrid mode can combine OpenCode free models with OpenAI, Kimi, and/or Antigravity.
  48: > **💡 Models are fully customizable.** Edit `~/.config/opencode/oh-my-opencode-theseus.json` (or `.jsonc` for comments support) to assign any model to any agent.
  59: https://raw.githubusercontent.com/alvinunreal/oh-my-opencode-theseus/refs/heads/master/README.md
  91:       <b>Prompt:</b> <code>~/.config/opencode/agents/orchestrator.md</code>
  122:       <b>Prompt:</b> <code>~/.config/opencode/agents/explorer.md</code>
  153:       <b>Prompt:</b> <code>~/.config/opencode/agents/oracle.md</code>
  184:       <b>Prompt:</b> <code>~/.config/opencode/agents/librarian.md</code>
  215:       <b>Prompt:</b> <code>~/.config/opencode/agents/designer.md</code>
  246:       <b>Prompt:</b> <code>~/.config/opencode/agents/fixer.md</code>

C:\Users\paulc\.config\opencode\cache\package.json:
  3:     "opencode-anthropic-auth": "0.0.13",
  4:     "opencode-antigravity-auth": "1.5.1",
  5:     "oh-my-opencode-slim": "0.7.0"

C:\Users\paulc\.config\opencode\package.json:
  2:   "name": "oh-my-opencode-theseus",
  4:   "description": "Agent orchestration plugin for OpenCode - the Ship of Theseus evolution of oh-my-opencode",
  8:     "oh-my-opencode-theseus": "./dist/cli/index.js"
  13:     "opencode",
  14:     "opencode-plugin",
  25:     "url": "https://github.com/alvinunreal/oh-my-opencode-theseus"
  28:     "url": "https://github.com/alvinunreal/oh-my-opencode-theseus/issues"
  30:   "homepage": "https://github.com/alvinunreal/oh-my-opencode-theseus#readme",
  38:     "deploy": "bun test && bun run build && cp -f dist/index.js ../plugins/oh-my-opencode-theseus.js && cp -f dist/cli/index.js ../plugins/cli/index.js",
  45:     "dev": "bun run build && opencode",
  54:     "@opencode-ai/plugin": "1.2.5",
  55:     "@opencode-ai/sdk": "^1.1.19",

C:\Users\paulc\.config\opencode\agents\orchestrator.md:
  269:   - `/opencode/`
  316: - All agent model assignments in `oh-my-opencode-theseus.json`
  905: - Line 42: "opencode/big-pickle" → "anthropic/claude-opus-4-6"
  909: ## Task: @fixer (oh-my-opencode-theseus.json)
  911: **File**: oh-my-opencode-theseus.json
  981: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py changes --root ./
  982: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py update --root ./
  1249: Task @explorer: Extract agent models from oh-my-opencode-theseus.json
  1254: - Scope: oh-my-opencode-theseus.json, presets.*.*.model

C:\Users\paulc\.config\opencode\agents\explorer.md:
  137:         {"name": "orchestrator", "model": "opencode/big-pickle", "provider": "opencode", "mcp": ["*"]},
  150:     "config_file": "oh-my-opencode-theseus.json",

C:\Users\paulc\.config\opencode\agents\librarian.md:
  71: - Configuration review: opencode.json, plugin configs, relevant dotfiles

C:\Users\paulc\.config\opencode\models\AGENTS.md:
  5: This file provides essential guidance for agents working within the OpenCode models directory. This is a critical component of the OpenCode ecosystem focused on comprehensive LLM benchmarking and agent coordination.
  45: You are an agent operating within the **OpenCode models directory** (`~/.config/opencode/models/`). This is the central hub for:
  64: ~/.config/opencode/models/                # Current directory (benchmark database)
  357: **Remember**: This directory houses the OpenCode ecosystem's central model intelligence resource. Every update here impacts agent performance across the entire system. Prioritize data accuracy, document your sources, and coordinate with other agents for comprehensive coverage.

C:\Users\paulc\.config\opencode\models\agent_model_intelligence.json:
  10:       "opencode/big-pickle",
  19:       "opencode",
  37:       "file:///C:/Users/paulc/.config/opencode/.backups/MODELS_recommended.md",
  38:       "file:///C:/Users/paulc/.config/opencode/models/QUICK_REFERENCE_GUIDE.md",
  39:       "file:///C:/Users/paulc/.config/opencode/oh-my-opencode-theseus.json"
  43:       "Some recommended models (e.g., opencode/big-pickle) lack public benchmark data in standard repos"
  95:         "opencode/big-pickle",

C:\Users\paulc\.config\opencode\models\CHANGELOG.md:
  7: - Updated `oh-my-opencode-theseus.json` to include `openai/gpt-5.2` in fallback chains for all agents.

C:\Users\paulc\.config\opencode\models\existing_model_ids.txt:
  46: opencode/big-pickle
  47: opencode/gpt-5-nano
  48: opencode/kimi-k2.5-free
  49: opencode/minimax-m2.1-free
  50: opencode/trinity-large-preview-free

C:\Users\paulc\.config\opencode\models\matched_models.txt:
  24: opencode/big-pickle
  25: opencode/gpt-5-nano
  26: opencode/kimi-k2.5-free
  27: opencode/minimax-m2.1-free
  28: opencode/trinity-large-preview-free

C:\Users\paulc\.config\opencode\models\Backups\models_available_backup_20230211_120000.json:
  2:   "opencode/big-pickle": {
  3:     "description": "Open-source model from the OpenCode initiative",
  58:   "opencode/gpt-5-nano": {
  59:     "description": "Compact version of GPT-5 architecture from OpenCode",

C:\Users\paulc\.config\opencode\models\model_tui_mapping.json:
  56:     "opencode/big-pickle",
  57:     "opencode/gpt-5-nano",
  58:     "opencode/kimi-k2.5-free",
  59:     "opencode/minimax-m2.1-free",
  60:     "opencode/trinity-large-preview-free",

C:\Users\paulc\.config\opencode\skills\model-tester\SKILL.md:
  8: Tests OpenRouter models from `opencode.json` configuration and adds failed models to the triage list in `oh-my-opencode-theseus.json`.
  13: - User asks to "test opencode.json" or "test providers"
  21: Read `opencode.json` to get the provider configuration and models:
  47:   -H "HTTP-Referer: https://opencode.ai" \
  48:   -H "X-Title: OpenCode" \
  68: Read `oh-my-opencode-theseus.json`, find the `fallback.triage` section, and add failed models:
  90:   -H "HTTP-Referer: https://opencode.ai" \
  91:   -H "X-Title: OpenCode" \

C:\Users\paulc\.config\opencode\models\MODEL_MAPPING_REPORT.txt:
  25: opencode:
  64: ✓ opencode/big-pickle
  65: ✓ opencode/gpt-5-nano
  66: ✓ opencode/kimi-k2.5-free
  67: ✓ opencode/minimax-m2.1-free
  68: ✓ opencode/trinity-large-preview-free

C:\Users\paulc\.config\opencode\models\Backups\models_available_backup_20230211_123456.json:
  2:   "opencode/big-pickle": {
  3:     "description": "Open-source model from the OpenCode initiative",
  58:   "opencode/gpt-5-nano": {
  59:     "description": "Compact version of GPT-5 architecture from OpenCode",

C:\Users\paulc\.config\opencode\skills\cartography\SKILL.md:
  59: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py init \
  98: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py changes \
  122: python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py update \
  193: - User overrides from ~/.config/opencode/oh-my-opencode-theseus.json
  201: 5. Returns agent configs to OpenCode
  211: # Repository Atlas: oh-my-opencode-theseus
  214: A high-performance, low-latency agent orchestration plugin for OpenCode, focusing on specialized sub-agent delegation and background task management.
  217: - `src/index.ts`: Plugin initialization and OpenCode integration.
  219: - `oh-my-opencode-theseus.json`: User configuration schema.

C:\Users\paulc\.config\opencode\models\config\sources.json:
  50:         "HTTP-Referer": "https://github.com/opencode/models",
  51:         "X-Title": "OpenCode Model Benchmark"

C:\Users\paulc\.config\opencode\models\models_available_test.json:
  2:   "opencode/big-pickle": {
  3:     "description": "Open-source model from the OpenCode initiative",
  61:   "opencode/gpt-5-nano": {
  62:     "description": "Compact version of GPT-5 architecture from OpenCode",
  117:   "opencode/kimi-k2.5-free": {
  173:   "opencode/minimax-m2.1-free": {
  229:   "opencode/trinity-large-preview-free": {

C:\Users\paulc\.config\opencode\models\Backups\models_available_20260211_2047.json:
  2:   "opencode/big-pickle": {
  3:     "description": "Open-source model from the OpenCode initiative",
  58:   "opencode/gpt-5-nano": {
  59:     "description": "Compact version of GPT-5 architecture from OpenCode",
  114:   "opencode/kimi-k2.5-free": {
  170:   "opencode/minimax-m2.1-free": {
  226:   "opencode/trinity-large-preview-free": {

C:\Users\paulc\.config\opencode\models\RESEARCH_GUIDE.md:
  257: ? OpenCode models (BigPickle, GPT-5-Nano)

C:\Users\paulc\.config\opencode\models\VERIFICATION_REPORT_20260212.md:
  125: - `opencode/big-pickle`: 131000 (suspiciously high)
  193: 3. `opencode/big-pickle`: Max_Output_Tokens=131000 seems high
  194: 4. `opencode/minimax-m2.1-free`: SWE_Bench=74.0% but other metrics null - inconsistent

C:\Users\paulc\.config\opencode\models\models_available.json:
  2:   "opencode/big-pickle": {
  3:     "description": "Open-source model from the OpenCode initiative",
  102:   "opencode/gpt-5-nano": {
  103:     "description": "Compact version of GPT-5 architecture from OpenCode",
  158:   "opencode/kimi-k2.5-free": {
  222:   "opencode/minimax-m2.1-free": {
  286:   "opencode/trinity-large-preview-free": {
  1876: [Omitted long matching line]

C:\Users\paulc\.config\opencode\models\tui_model_ids.txt:
  1: opencode/big-pickle
  2: opencode/gpt-5-nano
  3: opencode/kimi-k2.5-free
  4: opencode/minimax-m2.1-free
  5: opencode/trinity-large-preview-free

C:\Users\paulc\.config\opencode\models\tui_models_extraction_report.json:
  4:   "source_command": "opencode models --verbose",
  7:     {"name": "Big Pickle", "provider": "opencode", "status": "active"},
  8:     {"name": "GPT-5 Nano", "provider": "opencode", "status": "active"},
  9:     {"name": "Kimi K2.5 Free", "provider": "opencode", "status": "active"},
  10:     {"name": "MiniMax M2.1 Free", "provider": "opencode", "status": "active"},
  11:     {"name": "Trinity Large Preview", "provider": "opencode", "status": "active"},
  74:     "opencode": 5,
  118:     "opencode_endpoint": "https://opencode.ai/zen/v1",

C:\Users\paulc\.config\opencode\models\model_tui_mapping_detailed.json:
  34:     "opencode/big-pickle",
  35:     "opencode/gpt-5-nano",
  36:     "opencode/kimi-k2.5-free",
  37:     "opencode/minimax-m2.1-free",
  38:     "opencode/trinity-large-preview-free",
  235:     "opencode": {

C:\Users\paulc\.config\opencode\models\Backups\models_available_backup_20260211_234329.json:
  2:   "opencode/big-pickle": {
  3:     "description": "Open-source model from the OpenCode initiative",
  58:   "opencode/gpt-5-nano": {
  59:     "description": "Compact version of GPT-5 architecture from OpenCode",
  114:   "opencode/kimi-k2.5-free": {
  170:   "opencode/minimax-m2.1-free": {
  226:   "opencode/trinity-large-preview-free": {

C:\Users\paulc\.config\opencode\cache\models.json:
  1: [Omitted long matching line]

C:\Users\paulc\.config\opencode\skills\cartography\README.md:
  57: Installed automatically via oh-my-opencode-theseus installer when custom skills are enabled.

C:\Users\paulc\.config\opencode\models\RESEARCH_SESSION_SUMMARY_20260212.md:
  83: ## IMPACT ON OPENCODE ECOSYSTEM

C:\Users\paulc\.config\opencode\models\Backups\models_available_backup_20260211_234335.json:
  2:   "opencode/big-pickle": {
  3:     "description": "Open-source model from the OpenCode initiative",
  58:   "opencode/gpt-5-nano": {
  59:     "description": "Compact version of GPT-5 architecture from OpenCode",
  114:   "opencode/kimi-k2.5-free": {
  170:   "opencode/minimax-m2.1-free": {
  226:   "opencode/trinity-large-preview-free": {

C:\Users\paulc\.config\opencode\models\Backups\models_available_backup_20260212_051958.json:
  2:   "opencode/big-pickle": {
  3:     "description": "Open-source model from the OpenCode initiative",
  69:   "opencode/gpt-5-nano": {
  70:     "description": "Compact version of GPT-5 architecture from OpenCode",
  125:   "opencode/kimi-k2.5-free": {
  189:   "opencode/minimax-m2.1-free": {
  253:   "opencode/trinity-large-preview-free": {

C:\Users\paulc\.config\opencode\models\Backups\models_available_backup_20260211_212210.json:
  2:   "opencode/big-pickle": {
  3:     "description": "Open-source model from the OpenCode initiative",
  58:   "opencode/gpt-5-nano": {
  59:     "description": "Compact version of GPT-5 architecture from OpenCode",
  114:   "opencode/kimi-k2.5-free": {
  170:   "opencode/minimax-m2.1-free": {
  226:   "opencode/trinity-large-preview-free": {

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks.json:
  2:   "_schema": "https://opencode.ai/skills/update-agent-models/benchmarks.json",

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmark_manual_accepted.json.backup.1771246190333.json:
  2:   "_schema": "https://opencode.ai/skills/update-agent-models/benchmark-manual-accepted.json",
  5:     "opencode/big-pickle": {
  6:       "name": "OpenCode Big Pickle (mapped to GLM-4.6 Reasoning)",
  30:             "C:/Users/paulc/.config/opencode/models_1_updated.md:688"

C:\Users\paulc\.config\opencode\skills\update-agent-models\cleanup.js:
  151:           'https://opencode.ai/skills/update-agent-models/benchmark-manual-accepted.json',
  168:           'https://opencode.ai/skills/update-agent-models/model-ignore-list.json',

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmark_manual_accepted.json:
  2:   "_schema": "https://opencode.ai/skills/update-agent-models/benchmark-manual-accepted.json",

C:\Users\paulc\.config\opencode\models\tui_models_verbose.json:
  1: opencode/big-pickle
  4:   "providerID": "opencode",
  9:     "url": "https://opencode.ai/zen/v1",
  61: opencode/gpt-5-nano
  64:   "providerID": "opencode",
  69:     "url": "https://opencode.ai/zen/v1",
  141: opencode/kimi-k2.5-free
  144:   "providerID": "opencode",
  149:     "url": "https://opencode.ai/zen/v1",
  193: opencode/minimax-m2.1-free
  196:   "providerID": "opencode",
  201:     "url": "https://opencode.ai/zen/v1",
  243: opencode/trinity-large-preview-free
  246:   "providerID": "opencode",
  251:     "url": "https://opencode.ai/zen/v1",

C:\Users\paulc\.config\opencode\skills\update-agent-models\codemap.md:
  46:   - Schema: `https://opencode.ai/skills/update-agent-models/benchmark-manual-accepted.json`
  88: - **Input**: Reads from `oh-my-opencode-theseus.json` for current agent configurations

C:\Users\paulc\.config\opencode\skills\update-agent-models\google-health.js:
  12: const AUTH_FILE = path.join(process.env.USERPROFILE || 'C:/Users/paulc', '.local', 'share', 'opencode', 'auth.json');
  13: const THESEUS_PATH = path.join(ROOT_DIR, 'oh-my-opencode-theseus.json');

C:\Users\paulc\.config\opencode\skills\update-agent-models\guard.js:
  35:   opencode: path.join(ROOT_DIR, 'opencode.json'),
  36:   theseus: path.join(ROOT_DIR, 'oh-my-opencode-theseus.json'),
  394:     />\s*"?[^"]*oh-my-opencode-theseus\.json"?/,
  395:     />\s*"?[^"]*opencode\.json"?/,
  414:     /fs\.writeFileSync\([^\n\r]*oh-my-opencode-theseus\.json/i,
  415:     /fs\.writeFileSync\([^\n\r]*opencode\.json/i,
  419:     />\s*"?[^"]*oh-my-opencode-theseus\.json"?/i,
  420:     />\s*"?[^"]*opencode\.json"?/i,
  424:     /copyFileSync\([^\n\r]*oh-my-opencode-theseus\.json/i,
  552:   const opencode = readJson(FILES.opencode);
  553:   const aa = opencode?.provider?.['artificial-analysis'];
  554:   assert(aa, 'opencode.json missing provider.artificial-analysis');

C:\Users\paulc\.config\opencode\skills\update-agent-models\HARDENING-IMPLEMENTATION.md:
  166:   // OpenCode aliases
  167:   'opencode/kimi-k2.5-free': {
  170:     evidence: 'OpenCode free tier wrapper for Moonshot Kimi'
  172:   'opencode/minimax-m2.5-free': {
  175:     evidence: 'OpenCode free tier wrapper for SenseTime MiniMax'
  177:   'opencode/gpt-5-nano': {
  180:     evidence: 'OpenCode wrapper for OpenAI GPT-5 Nano'
  182:   'opencode/big-pickle': {
  450:     sessionId: process.env.OPENCODE_SESSION_ID || 'unknown',

C:\Users\paulc\.config\opencode\skills\update-agent-models\model_ignore_list.json.backup.1771246190338.json:
  2:   "_schema": "https://opencode.ai/skills/update-agent-models/model-ignore-list.json",

C:\Users\paulc\.config\opencode\skills\update-agent-models\model_ignore_list.json:
  2:   "_schema": "https://opencode.ai/skills/update-agent-models/model-ignore-list.json",

C:\Users\paulc\.config\opencode\skills\update-agent-models\optimize.js:
  4:  * Deterministically updates oh-my-opencode-theseus.json using bench_calc.json
  33:   theseus: path.join(ROOT_DIR, "oh-my-opencode-theseus.json"),

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\benchmark-research-compiled.2026-02-16T13-25-45-446Z.json:
  25:     "opencode/big-pickle",
  26:     "opencode/gpt-5-nano",
  27:     "opencode/kimi-k2.5-free",
  28:     "opencode/minimax-m2.5-free",
  39:       "model": "opencode/big-pickle",
  41:         "opencode/big-pickle benchmark gpqa mmlu_pro ifbench",
  42:         "opencode/big-pickle real backend model alias rumor"
  47:       "model": "opencode/gpt-5-nano",
  49:         "opencode/gpt-5-nano benchmark gpqa mmlu_pro ifbench",
  50:         "opencode/gpt-5-nano real backend model alias rumor"
  55:       "model": "opencode/kimi-k2.5-free",
  57:         "opencode/kimi-k2.5-free benchmark gpqa mmlu_pro ifbench",
  58:         "opencode/kimi-k2.5-free real backend model alias rumor"
  63:       "model": "opencode/minimax-m2.5-free",
  65:         "opencode/minimax-m2.5-free benchmark gpqa mmlu_pro ifbench",
  66:         "opencode/minimax-m2.5-free real backend model alias rumor"

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\benchmark-research-web.2026-02-16T13-12-37-585Z.json:
  25:     "opencode/big-pickle",
  26:     "opencode/gpt-5-nano",
  27:     "opencode/kimi-k2.5-free",
  28:     "opencode/minimax-m2.5-free",
  39:       "model": "opencode/big-pickle",
  41:         "opencode/big-pickle benchmark gpqa mmlu_pro ifbench",
  42:         "opencode/big-pickle real backend model alias rumor"
  47:       "model": "opencode/gpt-5-nano",
  49:         "opencode/gpt-5-nano benchmark gpqa mmlu_pro ifbench",
  50:         "opencode/gpt-5-nano real backend model alias rumor"
  55:       "model": "opencode/kimi-k2.5-free",
  57:         "opencode/kimi-k2.5-free benchmark gpqa mmlu_pro ifbench",
  58:         "opencode/kimi-k2.5-free real backend model alias rumor"
  63:       "model": "opencode/minimax-m2.5-free",
  65:         "opencode/minimax-m2.5-free benchmark gpqa mmlu_pro ifbench",
  66:         "opencode/minimax-m2.5-free real backend model alias rumor"

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\benchmark-research-compiled.2026-02-16T13-23-03-923Z.json:
  25:     "opencode/big-pickle",
  26:     "opencode/gpt-5-nano",
  27:     "opencode/kimi-k2.5-free",
  28:     "opencode/minimax-m2.5-free",
  39:       "model": "opencode/big-pickle",
  41:         "opencode/big-pickle benchmark gpqa mmlu_pro ifbench",
  42:         "opencode/big-pickle real backend model alias rumor"
  47:       "model": "opencode/gpt-5-nano",
  49:         "opencode/gpt-5-nano benchmark gpqa mmlu_pro ifbench",
  50:         "opencode/gpt-5-nano real backend model alias rumor"
  55:       "model": "opencode/kimi-k2.5-free",
  57:         "opencode/kimi-k2.5-free benchmark gpqa mmlu_pro ifbench",
  58:         "opencode/kimi-k2.5-free real backend model alias rumor"
  63:       "model": "opencode/minimax-m2.5-free",
  65:         "opencode/minimax-m2.5-free benchmark gpqa mmlu_pro ifbench",
  66:         "opencode/minimax-m2.5-free real backend model alias rumor"

C:\Users\paulc\.config\opencode\skills\update-agent-models\working_models.json:
  2:   "_schema": "https://opencode.ai/skills/update-agent-models/working-models.json",
  3:   "_description": "Verified working models from opencode models CLI with two-phase verification",
  7:     "opencode/big-pickle": {
  11:       "provider": "opencode",
  12:       "displayName": "opencode/big-pickle"
  14:     "opencode/gpt-5-nano": {
  18:       "provider": "opencode",
  19:       "displayName": "opencode/gpt-5-nano"
  21:     "opencode/kimi-k2.5-free": {
  25:       "provider": "opencode",
  26:       "displayName": "opencode/kimi-k2.5-free"
  28:     "opencode/minimax-m2.5-free": {
  32:       "provider": "opencode",
  33:       "displayName": "opencode/minimax-m2.5-free"

C:\Users\paulc\.config\opencode\skills\update-agent-models\workflow-failure-analysis.md:
  45:   - OpenCode aliases (Big Pickle, GPT-5 Nano, etc.)

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\benchmark-research-compiled.2026-02-16T13-51-02-801Z.json:
  25:     "opencode/big-pickle",
  26:     "opencode/gpt-5-nano",
  27:     "opencode/kimi-k2.5-free",
  28:     "opencode/minimax-m2.5-free",
  40:       "model": "opencode/big-pickle",
  42:         "opencode/big-pickle benchmark gpqa mmlu_pro ifbench",
  43:         "opencode/big-pickle real backend model alias rumor"
  48:       "model": "opencode/gpt-5-nano",
  50:         "opencode/gpt-5-nano benchmark gpqa mmlu_pro ifbench",
  51:         "opencode/gpt-5-nano real backend model alias rumor"
  56:       "model": "opencode/kimi-k2.5-free",
  58:         "opencode/kimi-k2.5-free benchmark gpqa mmlu_pro ifbench",
  59:         "opencode/kimi-k2.5-free real backend model alias rumor"
  64:       "model": "opencode/minimax-m2.5-free",
  66:         "opencode/minimax-m2.5-free benchmark gpqa mmlu_pro ifbench",
  67:         "opencode/minimax-m2.5-free real backend model alias rumor"
  6091:     "opencode/big-pickle": {
  6105:     "opencode/gpt-5-nano": {
  6106:       "name": "GPT-5 Nano (OpenCode)",
  6121:     "opencode/kimi-k2.5-free": {
  6122:       "name": "Kimi K2.5 Free (OpenCode)",
  6135:     "opencode/minimax-m2.5-free": {
  6136:       "name": "MiniMax M2.5 Free (OpenCode)",

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\openai-budget.2026-02-16T13-48-26-289Z.json:
  35:     "source_file": "C:\\Users\\paulc\\.config\\opencode\\skills\\update-agent-models\\openai_limits_manual.json"

C:\Users\paulc\.config\opencode\skills\update-agent-models\proxies\swe_bench_pro\README.md:
  327: Part of the oh-my-opencode-theseus plugin. Used internally for benchmark proxy estimation only.

C:\Users\paulc\.config\opencode\skills\update-agent-models\test-models.sh:
  2: # Test ALL models from opencode models CLI with two-phase verification
  7: AUTH_FILE="C:/Users/paulc/.local/share/opencode/auth.json"
  34: PROPOSAL_DIR="C:/Users/paulc/.config/opencode/skills/update-agent-models/proposals"
  41: echo "Getting all models from opencode models CLI..."
  42: models_list=$(opencode models 2>&1 | grep -v "^\[" | grep "/")
  43: opencode_list=$(opencode models opencode 2>&1 | grep -v "^\[" | grep "^opencode/")
  65:         -H "HTTP-Referer: https://opencode.ai" \
  66:         -H "X-Title: OpenCode" \
  134:         -H "HTTP-Referer: https://opencode.ai" \
  135:         -H "X-Title: OpenCode" \
  241:     opencode models "$provider" 2>/dev/null | grep -v "^\[" | grep "^${provider}/" > "$file" || true
  333:         opencode)
  334:             if echo "$opencode_list" | grep -Fxq "$model_id"; then
  396:             opencode|*)
  397:                 # Skip phase 2 for opencode and other providers (trust phase 1)
  428:   "_schema": "https://opencode.ai/skills/update-agent-models/working-models.json",
  429:   "_description": "Verified working models from opencode models CLI with two-phase verification",

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\working_models.20260216T152045Z.json:
  2:   "_schema": "https://opencode.ai/skills/update-agent-models/working-models.json",
  3:   "_description": "Verified working models from opencode models CLI with two-phase verification",
  7:     "opencode/big-pickle": {"lastVerified": 1771255245000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/big-pickle"},
  8:     "opencode/gpt-5-nano": {"lastVerified": 1771255245000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/gpt-5-nano"},
  9:     "opencode/kimi-k2.5-free": {"lastVerified": 1771255245000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/kimi-k2.5-free"},
  10:     "opencode/minimax-m2.5-free": {"lastVerified": 1771255245000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/minimax-m2.5-free"},

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\theseus-update.2026-02-16T14-52-43-225Z.json:
  3:   "target": "C:\\Users\\paulc\\.config\\opencode\\oh-my-opencode-theseus.json",
  49:           "modelId": "opencode/minimax-m2.5-free",
  54:           "modelId": "opencode/big-pickle",
  197:           "modelId": "opencode/big-pickle",
  227:           "modelId": "opencode/minimax-m2.5-free",
  345:           "modelId": "opencode/minimax-m2.5-free",
  350:           "modelId": "opencode/big-pickle",
  493:           "modelId": "opencode/big-pickle",
  498:           "modelId": "opencode/minimax-m2.5-free",
  641:           "modelId": "opencode/minimax-m2.5-free",
  646:           "modelId": "opencode/big-pickle",
  789:           "modelId": "opencode/big-pickle",
  794:           "modelId": "opencode/minimax-m2.5-free",
  902:         "opencode/gpt-5-nano",
  905:         "opencode/kimi-k2.5-free",
  906:         "opencode/minimax-m2.5-free",
  912:         "opencode/big-pickle",
  1009:         "opencode/gpt-5-nano",
  1027:         "opencode/kimi-k2.5-free",
  1095:         "opencode/big-pickle",
  1098:         "opencode/gpt-5-nano",
  1129:         "opencode/kimi-k2.5-free",
  1131:         "opencode/minimax-m2.5-free",
  1229:         "opencode/gpt-5-nano",
  1231:         "opencode/kimi-k2.5-free",
  1267:         "opencode/minimax-m2.5-free",
  1270:         "opencode/kimi-k2.5-free",
  1285:         "opencode/big-pickle",
  1305:         "opencode/gpt-5-nano",
  1372:         "opencode/gpt-5-nano",
  1375:         "opencode/kimi-k2.5-free",
  1449:         "opencode/big-pickle",
  1463:         "opencode/kimi-k2.5-free",
  1465:         "opencode/minimax-m2.5-free",
  1472:         "opencode/gpt-5-nano",
  1573:         "opencode/gpt-5-nano",
  1578:         "opencode/kimi-k2.5-free",
  1634:         "opencode/gpt-5-nano",
  1637:         "opencode/kimi-k2.5-free",
  1640:         "opencode/minimax-m2.5-free",
  1648:         "opencode/big-pickle",
  1750:         "opencode/gpt-5-nano",
  1766:         "opencode/kimi-k2.5-free",
  1811:         "opencode/gpt-5-nano",
  1816:         "opencode/big-pickle",
  1829:         "opencode/minimax-m2.5-free",
  1832:         "opencode/kimi-k2.5-free",
  1954:         "opencode/gpt-5-nano",
  1961:         "opencode/kimi-k2.5-free",

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\benchmark-research.2026-02-16T15-25-42-878Z.json:
  25:     "opencode/big-pickle",
  26:     "opencode/minimax-m2.5-free",
  36:       "model": "opencode/big-pickle",
  38:         "opencode/big-pickle benchmark gpqa mmlu_pro ifbench",
  39:         "opencode/big-pickle real backend model alias rumor"
  44:       "model": "opencode/minimax-m2.5-free",
  46:         "opencode/minimax-m2.5-free benchmark gpqa mmlu_pro ifbench",
  47:         "opencode/minimax-m2.5-free real backend model alias rumor"

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\working_models.20260216T134314Z.json:
  2:   "_schema": "https://opencode.ai/skills/update-agent-models/working-models.json",
  3:   "_description": "Verified working models from opencode models CLI with two-phase verification",
  7:     "opencode/big-pickle": {"lastVerified": 1771249394000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/big-pickle"},
  8:     "opencode/gpt-5-nano": {"lastVerified": 1771249394000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/gpt-5-nano"},
  9:     "opencode/kimi-k2.5-free": {"lastVerified": 1771249394000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/kimi-k2.5-free"},
  10:     "opencode/minimax-m2.5-free": {"lastVerified": 1771249394000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/minimax-m2.5-free"},

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\benchmark-research.2026-02-16T14-45-36-154Z.json:
  27:       "model": "opencode/big-pickle",
  29:         "opencode/big-pickle benchmark gpqa mmlu_pro ifbench",
  30:         "opencode/big-pickle real backend model alias rumor"
  35:       "model": "opencode/minimax-m2.5-free",
  37:         "opencode/minimax-m2.5-free benchmark gpqa mmlu_pro ifbench",
  38:         "opencode/minimax-m2.5-free real backend model alias rumor"

C:\Users\paulc\.config\opencode\skills\update-agent-models\status.js:
  29:   const theseus = loadJson(path.join(ROOT_DIR, "oh-my-opencode-theseus.json"));

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\theseus-update.2026-02-16T14-37-04-530Z.json:
  3:   "target": "C:\\Users\\paulc\\.config\\opencode\\oh-my-opencode-theseus.json",
  662:         "opencode/gpt-5-nano",
  665:         "opencode/kimi-k2.5-free",
  666:         "opencode/minimax-m2.5-free",
  672:         "opencode/big-pickle",
  847:         "opencode/big-pickle",
  850:         "opencode/gpt-5-nano",
  881:         "opencode/kimi-k2.5-free",
  883:         "opencode/minimax-m2.5-free",
  1011:         "opencode/minimax-m2.5-free",
  1014:         "opencode/kimi-k2.5-free",
  1029:         "opencode/big-pickle",
  1049:         "opencode/gpt-5-nano",
  1185:         "opencode/big-pickle",
  1199:         "opencode/kimi-k2.5-free",
  1201:         "opencode/minimax-m2.5-free",
  1208:         "opencode/gpt-5-nano",
  1362:         "opencode/gpt-5-nano",
  1365:         "opencode/kimi-k2.5-free",
  1368:         "opencode/minimax-m2.5-free",
  1376:         "opencode/big-pickle",
  1531:         "opencode/gpt-5-nano",
  1536:         "opencode/big-pickle",
  1549:         "opencode/minimax-m2.5-free",
  1552:         "opencode/kimi-k2.5-free",

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\benchmark-research.2026-02-16T13-49-36-162Z.json:
  27:       "model": "opencode/big-pickle",
  29:         "opencode/big-pickle benchmark gpqa mmlu_pro ifbench",
  30:         "opencode/big-pickle real backend model alias rumor"
  35:       "model": "opencode/gpt-5-nano",
  37:         "opencode/gpt-5-nano benchmark gpqa mmlu_pro ifbench",
  38:         "opencode/gpt-5-nano real backend model alias rumor"
  43:       "model": "opencode/kimi-k2.5-free",
  45:         "opencode/kimi-k2.5-free benchmark gpqa mmlu_pro ifbench",
  46:         "opencode/kimi-k2.5-free real backend model alias rumor"
  51:       "model": "opencode/minimax-m2.5-free",
  53:         "opencode/minimax-m2.5-free benchmark gpqa mmlu_pro ifbench",
  54:         "opencode/minimax-m2.5-free real backend model alias rumor"

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Scripts\activate.bat:
  11: set "VIRTUAL_ENV=C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv"

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Scripts\activate.bat:
  11: set "VIRTUAL_ENV=C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv"

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\benchmark-research.2026-02-16T13-05-21-552Z.json:
  25:     "opencode/big-pickle",
  26:     "opencode/gpt-5-nano",
  27:     "opencode/kimi-k2.5-free",
  28:     "opencode/minimax-m2.5-free",
  39:       "model": "opencode/big-pickle",
  41:         "opencode/big-pickle benchmark gpqa mmlu_pro ifbench",
  42:         "opencode/big-pickle real backend model alias rumor"
  47:       "model": "opencode/gpt-5-nano",
  49:         "opencode/gpt-5-nano benchmark gpqa mmlu_pro ifbench",
  50:         "opencode/gpt-5-nano real backend model alias rumor"
  55:       "model": "opencode/kimi-k2.5-free",
  57:         "opencode/kimi-k2.5-free benchmark gpqa mmlu_pro ifbench",
  58:         "opencode/kimi-k2.5-free real backend model alias rumor"
  63:       "model": "opencode/minimax-m2.5-free",
  65:         "opencode/minimax-m2.5-free benchmark gpqa mmlu_pro ifbench",
  66:         "opencode/minimax-m2.5-free real backend model alias rumor"

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\working_models.20260216T125938Z.json:
  2:   "_schema": "https://opencode.ai/skills/update-agent-models/working-models.json",
  3:   "_description": "Verified working models from opencode models CLI with two-phase verification",
  7:     "opencode/big-pickle": {"lastVerified": 1771246778000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/big-pickle"},
  8:     "opencode/gpt-5-nano": {"lastVerified": 1771246778000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/gpt-5-nano"},
  9:     "opencode/kimi-k2.5-free": {"lastVerified": 1771246778000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/kimi-k2.5-free"},
  10:     "opencode/minimax-m2.5-free": {"lastVerified": 1771246778000, "successCount": 1, "failureCount": 0, "provider": "opencode", "displayName": "opencode/minimax-m2.5-free"},

C:\Users\paulc\.config\opencode\skills\update-agent-models\RESEARCH-BEST-PRACTICES.md:
  235: ### 7.1 Fallback Chain Configuration (OpenCode)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv\Scripts\activate:
  44:         VIRTUAL_ENV=$(cygpath 'C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv')
  49:         export VIRTUAL_ENV='C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\venv'

C:\Users\paulc\.config\opencode\skills\update-agent-models\SKILL.md:
  9: - `C:\Users\paulc\.config\opencode\oh-my-opencode-theseus.json`
  12: - `C:\Users\paulc\.local\share\opencode\auth.json`
  71: - Api Keys: `C:\Users\paulc\.local\share\opencode\auth.json`
  172:   - Validates AA provider config exists in `opencode.json`
  177:   - Reads keys from `C:\Users\paulc\.local\share\opencode\auth.json`
  376:   - `C:\Users\paulc\.local\share\opencode\auth.json`
  378:   - `C:\Users\paulc\.config\opencode\opencode.json`
  503: - Never manually reorder chains in `oh-my-opencode-theseus.json`.
  638: - `oh-my-opencode-theseus.json` - Proposal-only, agent applies
  678: - Name patterns: `*-free`, `*-latest`, `opencode/*`
  683: ALIAS DETECTED: opencode/kimi-k2.5-free
  686: Evidence: OpenCode wrapper for Moonshot
  687: Suggested Mapping: opencode/kimi-k2.5-free -> huggingface/moonshotai/Kimi-K2.5
  943: - oh-my-opencode-theseus.json - Proposal-only, agent applies
  967: **Detection:** Name patterns (*-free, *-latest, opencode/*)

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv\Scripts\activate:
  44:         VIRTUAL_ENV=$(cygpath 'C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv')
  49:         export VIRTUAL_ENV='C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\matharena\venv'

C:\Users\paulc\.config\opencode\skills\update-agent-models\research_findings.json:
  91:   "opencode/big-pickle": {
  92:     "name": "Big Pickle (OpenCode)",
  94:       "opencode.ai"
  98:   "opencode/gpt-5-nano": {
  99:     "name": "GPT-5 Nano (OpenCode)",
  102:       "opencode.ai"
  106:   "opencode/kimi-k2.5-free": {
  107:     "name": "Kimi K2.5 Free (OpenCode)",
  109:       "opencode.ai"
  113:   "opencode/minimax-m2.5-free": {
  114:     "name": "MiniMax M2.5 Free (OpenCode)",
  116:       "opencode.ai"

C:\Users\paulc\.config\opencode\skills\update-agent-models\research-benchmarks.js:
  28:   opencode: path.join(ROOT_DIR, 'opencode' + '.json'),
  36:   auth: 'C:/Users/paulc/.local/share/opencode/auth' + '.json',
  106:   if (id.startsWith('opencode/')) return true;
  250:   if (id.startsWith('opencode/')) return true;
  412:   const opencode = loadJson(PATHS.opencode);
  413:   const aa = opencode?.provider?.['artificial-analysis'] || {};

C:\Users\paulc\.config\opencode\skills\update-agent-models\proposals\openai-budget.2026-02-16T15-25-42-344Z.json:
  35:     "source_file": "C:\\Users\\paulc\\.config\\opencode\\skills\\up

... (truncated)
```
