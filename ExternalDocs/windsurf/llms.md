# Windsurf Documentation Links

## Autocomplete
- [Autocomplete Overview](https://docs.windsurf.com/autocomplete/overview.md): AI-powered code autocomplete with single-line and multi-line suggestions, keyboard shortcuts, and customizable speed settings.
- [Autocomplete Tips](https://docs.windsurf.com/autocomplete/tips.md): Tips for getting the most out of Windsurf Autocomplete including inline comments, Fill In The Middle (FIM), and snooze functionality.

## Best Practices
- [Prompt Engineering](https://docs.windsurf.com/best-practices/prompt-engineering.md): Best practices for crafting effective prompts to get high-quality code from Windsurf, including clear objectives, context, and constraints.
- [Common Use Cases](https://docs.windsurf.com/best-practices/use-cases.md): Common use cases for Windsurf including code generation, unit test generation, code documentation, API integration, and code refactoring.

## Chat
- [Chat Models](https://docs.windsurf.com/chat/models.md): Available AI models for Windsurf Chat including Base Model, Windsurf Premier, GPT-4o, and Claude 3.5 Sonnet with different access levels.
- [Chat Overview](https://docs.windsurf.com/chat/overview.md): Chat with your codebase using Windsurf Chat in VS Code and JetBrains. Use @-mentions, persistent context, pinned files, and inline citations.

## Command
- [Command Overview](https://docs.windsurf.com/command/plugins-overview.md): Use Windsurf Command for AI-powered inline code edits in VS Code and JetBrains. Generate or edit code with natural language prompts using Cmd/Ctrl+I.
- [Refactors, Docstrings, and More](https://docs.windsurf.com/command/related-features.md): Use Command-powered features like code lenses for refactoring, docstring generation, and Smart Paste for cross-language code translation.
- [Command](https://docs.windsurf.com/command/windsurf-overview.md): Use Windsurf Command (Cmd/Ctrl+I) for inline code generation and edits with natural language. No premium credits required.
- [Code Lenses](https://docs.windsurf.com/command/windsurf-related-features.md): Use Windsurf code lenses for quick Explain, Refactor, and Docstring operations on functions and classes directly in the editor.

## Context Awareness
- [Fast Context](https://docs.windsurf.com/context-awareness/fast-context.md): Fast Context is a specialized subagent that retrieves relevant code from your codebase up to 20x faster using SWE-grep models for rapid code retrieval.
- [Context Awareness Overview](https://docs.windsurf.com/context-awareness/overview.md): Windsurf's RAG-based context engine indexes your codebase for intelligent suggestions. Learn about context pinning, knowledge base, and M-Query retrieval.
- [Remote Indexing](https://docs.windsurf.com/context-awareness/remote-indexing.md): Index remote repositories from GitHub, GitLab, and BitBucket for enterprise teams without storing code locally.
- [Windsurf Ignore](https://docs.windsurf.com/context-awareness/windsurf-ignore.md): Configure which files and directories Windsurf should ignore during indexing using .codeiumignore files with gitignore-style syntax.
- [Context Awareness for Windsurf](https://docs.windsurf.com/context-awareness/windsurf-overview.md): Windsurf's RAG-based context engine indexes your codebase for intelligent code suggestions. Supports remote repositories for Teams and Enterprise.

## Plugins - Accounts & Analytics
- [Analytics](https://docs.windsurf.com/plugins/accounts/analytics.md): View individual user analytics, team analytics, usage patterns, and metrics for your Windsurf usage including code completion stats and AI-written code percentage.
- [Analytics API](https://docs.windsurf.com/plugins/accounts/api-reference/analytics-api-introduction.md): Enterprise analytics API for querying Windsurf usage data including autocomplete, chat, command, and Cascade metrics.
- [API Reference](https://docs.windsurf.com/plugins/accounts/api-reference/api-introduction.md): Enterprise API for querying Windsurf usage data and managing configurations with service key authentication.
- [Get Cascade Analytics](https://docs.windsurf.com/plugins/accounts/api-reference/cascade-analytics.md): Query Cascade-specific usage metrics including lines suggested/accepted, model usage, credit consumption, and tool usage statistics.
- [Custom Analytics Query](https://docs.windsurf.com/plugins/accounts/api-reference/custom-analytics.md): Flexible analytics querying with custom selections, filters, and aggregations for autocomplete, chat, command, and PCW data.
- [Error Handling](https://docs.windsurf.com/plugins/accounts/api-reference/errors.md): Common error messages and debugging tips for the Analytics API including authentication, query structure, and rate limiting errors.
- [Get Team Credit Balance](https://docs.windsurf.com/plugins/accounts/api-reference/get-team-credit-balance.md): Retrieve the current credit balance for your team, including prompt credits per seat, add-on credits, and billing cycle information.
- [Get Usage Configuration](https://docs.windsurf.com/plugins/accounts/api-reference/get-usage-config.md): Retrieve per-user add-on credit cap configuration, queried by team, group, or individual user scope for enterprise billing management.
- [Set Usage Configuration](https://docs.windsurf.com/plugins/accounts/api-reference/usage-config.md): Set or clear per-user add-on credit caps, with the ability to apply them across a team, group, or individual user for enterprise billing management.
- [Get User Page Analytics](https://docs.windsurf.com/plugins/accounts/api-reference/user-page-analytics.md): Retrieve user activity statistics including names, emails, last activity times, and active days from the teams page.
- [Role Based Access & Management](https://docs.windsurf.com/plugins/accounts/rbac-role-management.md): Configure RBAC permissions, create custom roles, and manage user access for Windsurf Teams and Enterprise plans.
- [Setting up SSO & SCIM](https://docs.windsurf.com/plugins/accounts/sso-scim.md): Configure Single Sign-On (SSO) and SCIM provisioning for your organization using Google Workspace, Microsoft Azure AD, Okta, or other SAML identity providers.
- [Getting started with Teams and Enterprise](https://docs.windsurf.com/plugins/accounts/teams-getting-started.md): Set up Teams and Enterprise plans with team management, SSO, analytics, user groups, and priority support for your organization.
- [Plans and Credit Usage](https://docs.windsurf.com/plugins/accounts/usage.md): Understand Windsurf pricing plans, prompt credits, usage tracking, automatic refills, and how to upgrade from Free to Pro, Teams, or Enterprise.

## Plugins - Cascade
- [Cascade Overview](https://docs.windsurf.com/plugins/cascade/cascade-overview.md): Cascade brings agentic AI coding to JetBrains with Write/Chat modes, voice input, tool access, turbo mode, and real-time collaboration.
- [Model Context Protocol (MCP)](https://docs.windsurf.com/plugins/cascade/mcp.md): Configure MCP servers to extend Cascade with custom tools and services using stdio, HTTP, or SSE transports with admin controls for Teams and Enterprise.
- [Memories & Rules](https://docs.windsurf.com/plugins/cascade/memories.md): Configure Cascade memories and rules to persist context across conversations with global rules, workspace rules, and system-level rules for enterprise.
- [Cascade Models](https://docs.windsurf.com/plugins/cascade/models.md): Available AI models in Cascade including SWE-1.5, SWE-1, Claude, GPT, and bring-your-own-key (BYOK) options with credit costs.
- [Web and Docs Search](https://docs.windsurf.com/plugins/cascade/web-search.md): Enable Cascade to search the web and read documentation pages in real-time using @web and @docs mentions for up-to-date context.
- [Workflows](https://docs.windsurf.com/plugins/cascade/workflows.md): Create reusable Cascade workflows as markdown files to automate repetitive tasks like deployments, PR reviews, and code formatting with slash commands.

## Plugins - General
- [IDE Compatibility](https://docs.windsurf.com/plugins/compatibility.md): Supported IDEs and version requirements for Windsurf Plugins including VS Code, JetBrains, Visual Studio, NeoVim, Vim, Emacs, Xcode, Sublime Text, and Eclipse.
- [Welcome to Windsurf Plugins](https://docs.windsurf.com/plugins/getting-started.md): Install and set up Windsurf Plugins for JetBrains, VS Code, Visual Studio, Vim, NeoVim, Jupyter, Chrome, and other IDEs with AI-powered coding assistance.
- [Guide for Admins](https://docs.windsurf.com/plugins/guide-for-admins.md): Enterprise admin guide for deploying Windsurf at scale. Configure SSO, SCIM, RBAC, analytics, and team management for large organizations.

## Security
- [Reporting Security Concerns](https://docs.windsurf.com/security/reporting.md): Report security vulnerabilities to Windsurf securely via email with GPG encryption. Learn about our coordinated disclosure policy and safe harbor.
- [FedRAMP Security Admin Guide](https://docs.windsurf.com/security/security-admin-guide.md): Windsurf FedRAMP Security Admin Guide for securely setting up, configuring, operating, and decommissioning top-level administrative accounts. Includes role definitions, account lifecycle procedures, and a reference table of all admin-controlled security settings.

## Tab
- [Windsurf Tab](https://docs.windsurf.com/tab/overview.md): Windsurf Tab provides AI-powered code suggestions with Tab to Jump, Tab to Import, and inline suggestions, powered by our custom model.

## Troubleshooting
- [General Issues](https://docs.windsurf.com/troubleshooting/plugins-common-issues.md): Common Windsurf plugin issues including subscription problems, cancellation, telemetry settings, account deletion, and chat panel troubleshooting.
- [Eclipse Troubleshooting](https://docs.windsurf.com/troubleshooting/plugins-enterprise/eclipse.md): Troubleshoot Eclipse plugin issues including startup problems, empty chat screen, WebView2, and certificate errors with Java keystore solutions.
- [JetBrains Troubleshooting](https://docs.windsurf.com/troubleshooting/plugins-enterprise/jetbrains.md): Troubleshoot JetBrains plugin issues including JCEF errors, certificate problems, custom workspaces, and extension diagnostics.
- [Proxy Configuration for Windsurf in JetBrains IDEs](https://docs.windsurf.com/troubleshooting/plugins-enterprise/jetbrains-proxy.md): Configure HTTP/HTTPS proxy settings for Windsurf plugin in JetBrains IDEs including corporate networks, authentication, and certificate handling.

## Windsurf Editor
- [Analytics](https://docs.windsurf.com/windsurf/accounts/analytics.md): View individual user analytics, team analytics, usage patterns, and metrics for your Windsurf usage including code completion stats and AI-written code percentage.
- [Analytics API](https://docs.windsurf.com/windsurf/accounts/api-reference/analytics-api-introduction.md): Enterprise analytics API for querying Windsurf usage data including autocomplete, chat, command, and Cascade metrics.
- [API Reference](https://docs.windsurf.com/windsurf/accounts/api-reference/api-introduction.md): Enterprise API for querying Windsurf usage data and managing configurations with service key authentication.
- [Get Cascade Analytics](https://docs.windsurf.com/windsurf/accounts/api-reference/cascade-analytics.md): Query Cascade-specific usage metrics including lines suggested/accepted, model usage, credit consumption, and tool usage statistics.
- [Custom Analytics Query](https://docs.windsurf.com/windsurf/accounts/api-reference/custom-analytics.md): Flexible analytics querying with custom selections, filters, and aggregations for autocomplete, chat, command, and PCW data.
- [Error Handling](https://docs.windsurf.com/windsurf/accounts/api-reference/errors.md): Common error messages and debugging tips for the Analytics API including authentication, query structure, and rate limiting errors.
- [Get Team Credit Balance](https://docs.windsurf.com/windsurf/accounts/api-reference/get-team-credit-balance.md): Retrieve the current credit balance for your team, including prompt credits per seat, add-on credits, and billing cycle information.
- [Get Usage Configuration](https://docs.windsurf.com/windsurf/accounts/api-reference/get-usage-config.md): Retrieve per-user add-on credit cap configuration, queried by team, group, or individual user scope for enterprise billing management.
- [Set Usage Configuration](https://docs.windsurf.com/windsurf/accounts/api-reference/usage-config.md): Set or clear per-user add-on credit caps, with the ability to apply them across a team, group, or individual user for enterprise billing management.
- [Get User Page Analytics](https://docs.windsurf.com/windsurf/accounts/api-reference/user-page-analytics.md): Retrieve user activity statistics including names, emails, last activity times, active days, and prompt credits used from the teams page.
- [Domain Verification](https://docs.windsurf.com/windsurf/accounts/domain-verification.md): Verify your organization's domain ownership with DNS TXT records to enable SSO, user management, and automatic team invitations in Windsurf.
- [Role Based Access & Management](https://docs.windsurf.com/windsurf/accounts/rbac-role-management.md): Configure RBAC permissions, create custom roles, and manage user access for Windsurf Teams and Enterprise plans.
- [Setting up SSO & SCIM](https://docs.windsurf.com/windsurf/accounts/sso-scim.md): Configure Single Sign-On (SSO) and SCIM provisioning for your organization using Google Workspace, Microsoft Azure AD, Okta, or other SAML identity providers.
- [Getting started with Teams and Enterprise](https://docs.windsurf.com/windsurf/accounts/teams-getting-started.md): Set up Windsurf Teams and Enterprise plans with team management, SSO, analytics, user groups, and priority support for your organization.
- [Plans and Credit Usage](https://docs.windsurf.com/windsurf/accounts/usage.md): Understand Windsurf pricing plans, prompt credits, usage tracking, automatic refills, and how to upgrade from Free to Pro, Teams, or Enterprise.

## Windsurf Editor - Advanced
- [Advanced Configuration](https://docs.windsurf.com/windsurf/advanced.md): Advanced Windsurf configurations including SSH support, Dev Containers, WSL, extension marketplace settings, and gitignore access for Cascade.
- [AI Commit Messages](https://docs.windsurf.com/windsurf/ai-commit-message.md): Generate meaningful git commit messages automatically with AI by analyzing your code changes with a single click in Windsurf.
- [AGENTS.md](https://docs.windsurf.com/windsurf/cascade/agents-md.md): Create AGENTS.md files to provide directory-scoped instructions to Cascade. Instructions automatically apply based on file location in your project.
- [App Deploys](https://docs.windsurf.com/windsurf/cascade/app-deploys.md): Deploy web applications directly from Windsurf to Netlify with public URLs, automatic builds, and project claiming for Next.js, React, Vue, and Svelte.
- [Arena Mode](https://docs.windsurf.com/windsurf/cascade/arena.md): Run multiple Cascade instances in parallel using arena mode to explore different approaches simultaneously.
- [Cascade Overview](https://docs.windsurf.com/windsurf/cascade/cascade.md): Cascade is Windsurf's agentic AI assistant with Code/Chat modes, tool calling, voice input, checkpoints, real-time awareness, and linter integration.
- [Cascade Hooks](https://docs.windsurf.com/windsurf/cascade/hooks.md): Execute custom shell commands at key points in Cascade's workflow for logging, security controls, validation, and enterprise governance with pre and post hooks.
- [Model Context Protocol (MCP)](https://docs.windsurf.com/windsurf/cascade/mcp.md): Integrate MCP servers with Cascade to access custom tools like GitHub, databases, and APIs. Configure stdio, HTTP, and SSE transports with admin controls for Teams.
- [Memories & Rules](https://docs.windsurf.com/windsurf/cascade/memories.md): Persist context across Cascade conversations with auto-generated memories and user-defined rules at global, workspace, and system levels for enterprise teams.
- [Cascade Modes](https://docs.windsurf.com/windsurf/cascade/modes.md): Cascade offers multiple distinct modes, each optimized for different types of tasks.
- [Skills](https://docs.windsurf.com/windsurf/cascade/skills.md): Skills help Cascade handle complex, multi-step tasks.
- [Web and Docs Search](https://docs.windsurf.com/windsurf/cascade/web-search.md): Search the web and documentation directly from Cascade using @web and @docs mentions, URL parsing, and real-time context from web pages.
- [Workflows](https://docs.windsurf.com/windsurf/cascade/workflows.md): Automate repetitive tasks in Cascade with reusable workflows defined as markdown files. Create PR review, deployment, testing, and code formatting workflows.
- [Worktrees](https://docs.windsurf.com/windsurf/cascade/worktrees.md): Automatically set up git worktrees for parallel Cascade tasks

## Windsurf Editor - Features
- [Codemaps](https://docs.windsurf.com/windsurf/codemaps.md): Create shareable hierarchical maps of your codebase to visualize code execution flow and component relationships. Navigate and share with teammates.
- [C#, .NET, and CPP](https://docs.windsurf.com/windsurf/csharp-cpp.md): Setup guide for C#, .NET Core, .NET Framework (Mono), and C++ development in Windsurf using open-source tooling like OmniSharp, clangd, and LLDB.
- [DeepWiki](https://docs.windsurf.com/windsurf/deepwiki.md): Get AI-powered explanations of code symbols with DeepWiki. Hover over functions, variables, and classes to understand unfamiliar code in your codebase.
- [Welcome to Windsurf](https://docs.windsurf.com/windsurf/getting-started.md): Download and install Windsurf IDE for Mac, Windows, or Linux. Import VS Code or Cursor settings, configure themes, and start coding with AI-powered assistance.
- [Guide for Admins](https://docs.windsurf.com/windsurf/guide-for-admins.md): Enterprise admin guide for deploying Windsurf at scale. Configure SSO, SCIM, RBAC, analytics, and team management for large organizations.
- [AI Models](https://docs.windsurf.com/windsurf/models.md): Available AI models in Windsurf Cascade including SWE-1.5, Claude, GPT, and BYOK options. Compare model capabilities, credit costs, and performance.
- [Windsurf Previews](https://docs.windsurf.com/windsurf/previews.md): Preview your web app locally in Windsurf IDE or browser with element selection, error capture, and direct integration with Cascade for rapid iteration.
- [Recommended Extensions](https://docs.windsurf.com/windsurf/recommended-extensions.md): Popular Open VSX extensions for Windsurf including Python, Java, C#, GitLens, and more. Replicate familiar IDE experiences from VS Code, Eclipse, or Visual Studio.
- [Terminal](https://docs.windsurf.com/windsurf/terminal.md): Use Windsurf's enhanced terminal with Command mode, Cascade integration, Turbo mode for auto-execution, and allow/deny lists for command control.
- [Vibe and Replace](https://docs.windsurf.com/windsurf/vibe-and-replace.md): AI-powered find and replace that applies natural language prompts to each match. Use Smart mode for careful changes or Fast mode for quick transformations.

## Windsurf Editor - Troubleshooting
- [Common Windsurf Editor Issues](https://docs.windsurf.com/troubleshooting/windsurf-common-issues.md): Common Windsurf Editor issues including rate limiting, MacOS security warnings, Windows updates, Linux crashes, and terminal problems.
- [Gathering Windsurf Logs](https://docs.windsurf.com/troubleshooting/windsurf-gathering-logs.md): How to download diagnostic logs from Windsurf Editor using the Command Palette or Cascade panel for troubleshooting support.
- [Language Server Fails with 'No Space Left on Device' on Linux](https://docs.windsurf.com/troubleshooting/windsurf-inotify-limits.md): Resolve Linux language server startup failures caused by exhausted inotify watch/instance limits (ENOSPC). Includes symptoms, diagnosis commands, and sysctl fixes.
- [Proxy Configuration in Windsurf Editor](https://docs.windsurf.com/troubleshooting/windsurf-proxy-configuration.md): Configure HTTP/HTTPS proxy settings for Windsurf Editor in corporate networks. Includes auto-detect, manual configuration, and SSH remote proxy setup.
- [TLS / SSL Inspection Issues in Windsurf](https://docs.windsurf.com/troubleshooting/windsurf-ssl-inspection.md): Configure enterprise environments where SSL inspection (e.g., Zscaler) causes TLS certificate validation or protocol negotiation failures. Includes how to capture Console errors and what to request from IT/security.
- [Windsurf Slow or Disconnecting in WSL](https://docs.windsurf.com/troubleshooting/windsurf-wsl-performance.md): Resolve Windsurf performance issues, disconnections, and crashes when running in Windows Subsystem for Linux (WSL). Covers symptoms, root cause, and recommended fixes for Plan 9 (9P) filesystem saturation caused by excessive extension activity.