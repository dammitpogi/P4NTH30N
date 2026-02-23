# Agent Installation Guide

If you are an LLM agent helping a user install the **oh-my-opencode-theseus** plugin, follow these instructions for a seamless "one-step" setup.

## Prerequisites

1.  **Bun**: Ensure Bun is installed (`bun --version`). If not, install it from [bun.sh](https://bun.sh).
2.  **OpenCode**: Ensure OpenCode is installed (`opencode --version`).

## One-Step Installation

The repository provides a unified installer that handles building the plugin, deploying it to the correct directory, and configuring the agent prompts.

Run the following command from the root of the repository:

```bash
bun scripts/install.ts
```

### What this script does:
1.  **Verifies OpenCode**: Checks if the `opencode` CLI is available.
2.  **Prepares Config**: Copies agent prompts (`agents/*.md`), custom skills, model intelligence data, and the plugin configuration (`oh-my-opencode-theseus.json`) to `~/.config/opencode/`.
3.  **Safe Registration**: Safely adds the plugin to the `plugin` array in `~/.config/opencode/opencode.json` without overwriting your existing settings.
4.  **Builds & Deploys**: Runs `bun install` and `bun run build`, then deploys the built plugin to `~/.cache/opencode/node_modules/oh-my-opencode-theseus`.

## Post-Installation Steps

1.  **Restart OpenCode**: Close and reopen your OpenCode session to load the new plugin and agents.
2.  **Verify Agents**: Run the following command in OpenCode to ensure all agents are responsive:
    ```bash
    ping all agents
    ```
3.  **Authenticate**: If you enabled providers like Kimi, OpenAI, or Google, ensure you are logged in:
    ```bash
    opencode auth login
    ```

## Troubleshooting

*   **Plugin not loading**: Check `~/.config/opencode/opencode.json` to ensure `"oh-my-opencode-theseus"` is listed in the `plugin` array.
*   **Missing Prompts**: Ensure the `.md` files exist in `~/.config/opencode/agents/`.
*   **Build Errors**: Ensure you have the latest version of Bun installed.

---
*This guide is intended for LLM agents. For human-friendly instructions, see [README.md](README.md).*
