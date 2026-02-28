> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Terminal

> Use Windsurf's enhanced terminal with Command mode, Cascade integration, Turbo mode for auto-execution, and allow/deny lists for command control.

# Command in the terminal

Use our [Command](/command/overview) modality in the terminal (`Cmd/Ctrl+I`) to generate the proper CLI syntax from prompts in natural language.

<Frame style={{ border: 'none', background: 'none' }}>
  <img src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=b03f1498ac0b7dc344270f975f9a234f" data-og-width="980" width="980" data-og-height="164" height="164" data-path="assets/windsurf-terminal-command.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=ec94b782cbe3b3d0a3e8d44ce7b27c74 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=9e3839c701ba2308cbc754842c8472a4 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=25245a6097e94c63ed47cb382097f82b 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=ecfdf898fe06e81255add438d3daff49 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=c46a449c560b98a2e295e904601a3c51 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=44ec229230a00b642a4aa61f1d4c571c 2500w" />
</Frame>

# Send terminal selection to Cascade

Highlight a portion of the stack trace and press `Cmd/Ctrl+L` to send it to Cascade, where you can reference this selection in your next prompt.

<Frame style={{ border: 'none', background: 'none' }}>
  <img src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-selection-mention.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=0f8b76d17cdd96983010e88d9dadf265" data-og-width="744" width="744" data-og-height="144" height="144" data-path="assets/windsurf-terminal-selection-mention.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-selection-mention.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=3123ae3c3b9d8fdc2a0ed5714554da0f 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-selection-mention.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=8f51c119c9e38fb22de968c62be4deb0 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-selection-mention.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=2e3dabb40323131b23575fceef294ff0 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-selection-mention.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=a4ebfaaa9b1ed7fcbba0c471731a8319 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-selection-mention.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=1d236c51a624f3f307ab65a5088910f8 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-selection-mention.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=26af2fd26f29c5a4d9f119c6d943314f 2500w" />
</Frame>

# @-mention your terminal

Chat with Cascade about your active terminals.

<Frame>
  <video autoPlay muted loop playsInline src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/terminal-at-mention.mp4?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=bf7766fe81e0847d7f58d4126980fe64" data-path="assets/terminal-at-mention.mp4" />
</Frame>

# Auto-executed Cascade commands

Cascade has the ability to run terminal commands on its own with user permission. You can configure how Cascade handles command execution through four distinct auto-execution levels, and certain terminal commands can be accepted or rejected automatically through the Allow and Deny lists.

## Auto-Execution Levels

Windsurf provides four levels of command auto-execution, giving you control over how Cascade runs terminal commands:

| Level              | Description                                                                                                                                                                                                                 |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Disabled**       | Auto-execution is completely disabled. All commands require manual approval before execution.                                                                                                                               |
| **Allowlist Only** | Only commands that match entries in your allow list can be auto-executed. All other commands require manual approval.                                                                                                       |
| **Auto**           | Cascade uses its judgment to determine whether a command is safe to auto-execute. Commands deemed potentially risky will still require your approval. This feature is only available for messages sent with premium models. |
| **Turbo**          | All commands are auto-executed immediately, except those in your deny list.                                                                                                                                                 |

You can select your preferred auto-execution level via the Windsurf Settings panel in the bottom right corner of the editor.

<Frame>
  <img style={{ maxHeight: "500px" }} src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=8860ea8311000ae2cc440cef26560620" data-og-width="680" width="680" data-og-height="60" height="60" data-path="assets/windsurf/cascade/cascade-turbo-mode.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=dbcaa01fab58d7ba1fac05acc91ae12f 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=c5dc736ca3cd591d00f0c8b3b4f13f90 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=13ee4803cf3edcdaba2b9d76dcf109aa 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=389cfcb06aec368986869bfd15a42553 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=e9829ad62b78b641213d472b4bca8683 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=db556ad06ddff8c4fbe5186569bf8334 2500w" />
</Frame>

### Admin-Controlled Maximum Level (Teams & Enterprise)

For Teams and Enterprise users, administrators can set a maximum allowed auto-execution level for their organization. This setting restricts which levels are available to team members, allowing admins to enforce security policies while still giving users flexibility within those bounds.

When an admin sets a maximum level, users can select any level up to and including that maximum. For example, if an admin sets the maximum to "Auto", users can choose between Disabled, Allowlist Only, or Auto, but cannot enable Turbo mode.

Administrators can configure this setting in the <a href="https://windsurf.com/team/settings" target="_blank">Admin Portal</a> under Team Settings.

### Team-Wide Command Lists (Teams & Enterprise)

Administrators can configure **team-wide allowlist and denylist** for terminal commands that apply to all team members. These lists work in addition to individual user allow/deny lists.

| List Type     | Behavior                                                                                                                              |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| **Allowlist** | Commands matching entries in this list will be auto-executed without user confirmation (when auto-execution is enabled for the user). |
| **Denylist**  | Commands matching entries in this list will always require user approval before execution, regardless of user settings.               |

**Key behaviors:**

* **Team and user configs are merged**: Team-level lists are combined with individual user allow/deny lists configured in Windsurf settings. A command matching either the team or user allowlist will be auto-executed (unless blocked by a denylist).
* The **denylist takes precedence** over the allowlist—if a command matches both lists (at either team or user level), it will require approval

To configure team-wide command lists, go to the <a href="https://windsurf.com/team/settings" target="_blank">Admin Portal</a> → Team Settings → Terminal Commands → **Manage Lists**.

### Allow list

An allow list defines a set of terminal commands that will always auto-execute. For example, if you add `git`, then Cascade will always accept `git add -A`.

The setting can be via Command Palette → Open Settings (UI) → Search for `windsurf.cascadeCommandsAllowList`.

<Frame>
  <img style={{ maxHeight: "500px" }} src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/allow-list.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=be27cab4ada44ba016f41cf7d943ae20" data-og-width="2098" width="2098" data-og-height="770" height="770" data-path="assets/windsurf/cascade/allow-list.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/allow-list.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=67d775a5a8dc5f74a9b1d743b265a9e1 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/allow-list.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=fc3414e119592d5e9f7499e5e4e95d59 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/allow-list.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=05dc8b80e975470b071eeefff32484e1 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/allow-list.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=19be334d151ab04ea1c32f1732c0ed60 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/allow-list.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=7a16f9b1638e6a6b9cf4124460fdd308 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/allow-list.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=e347583986d3f7cd0e220b87494263c2 2500w" />
</Frame>

### Deny list

A deny list defines a set of terminal commands that will never auto-execute. For example, if you add `rm`, then Cascade will always ask for permission to run `rm index.py`.

The setting can be via Command Palette → Open Settings (UI) → Search for `windsurf.cascadeCommandsDenyList`.

<Frame>
  <img style={{ maxHeight: "500px" }} src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/deny-list.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=83f5c447deeb931e68781fbd6cb89733" data-og-width="2090" width="2090" data-og-height="624" height="624" data-path="assets/windsurf/cascade/deny-list.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/deny-list.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=479a1b8b643adefbca8fcd08bbb2d4cd 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/deny-list.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=fb60fb1ea1f66c2cd63eb62ae0513675 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/deny-list.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=83520e9689fae159e121ccce1dc72901 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/deny-list.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=a4832324125ef273f72d41f315a434ca 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/deny-list.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=28da77a6ed6fb67a2467df9bd95c7c90 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/deny-list.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=01bc9a72d11a63527867a908cdace643 2500w" />
</Frame>

# Dedicated terminal

Starting in Wave 13, Windsurf introduced a dedicated terminal for Cascade to use for running commands on macOS.
This dedicated terminal is separate from your default terminal and *always* uses `zsh` as the shell.

<Frame>
  <img style={{ maxHeight: "350px" }} src="https://mintcdn.com/codeium/qV7Je1rddINQc1la/assets/windsurf/dedicated-terminal.png?fit=max&auto=format&n=qV7Je1rddINQc1la&q=85&s=8de2c0092ba68abc3c44f39868ec7db5" data-og-width="1248" width="1248" data-og-height="430" height="430" data-path="assets/windsurf/dedicated-terminal.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qV7Je1rddINQc1la/assets/windsurf/dedicated-terminal.png?w=280&fit=max&auto=format&n=qV7Je1rddINQc1la&q=85&s=9be023f55788dda3e342e0f4d564f906 280w, https://mintcdn.com/codeium/qV7Je1rddINQc1la/assets/windsurf/dedicated-terminal.png?w=560&fit=max&auto=format&n=qV7Je1rddINQc1la&q=85&s=dc7ee08fe44711231e1c745a44bb5f1f 560w, https://mintcdn.com/codeium/qV7Je1rddINQc1la/assets/windsurf/dedicated-terminal.png?w=840&fit=max&auto=format&n=qV7Je1rddINQc1la&q=85&s=3a370b9d6623065b2eb67cc161dbb69d 840w, https://mintcdn.com/codeium/qV7Je1rddINQc1la/assets/windsurf/dedicated-terminal.png?w=1100&fit=max&auto=format&n=qV7Je1rddINQc1la&q=85&s=c0a082190566b7c9758532c8692634ad 1100w, https://mintcdn.com/codeium/qV7Je1rddINQc1la/assets/windsurf/dedicated-terminal.png?w=1650&fit=max&auto=format&n=qV7Je1rddINQc1la&q=85&s=0b54e6b78ad311aa7743055025b6d24c 1650w, https://mintcdn.com/codeium/qV7Je1rddINQc1la/assets/windsurf/dedicated-terminal.png?w=2500&fit=max&auto=format&n=qV7Je1rddINQc1la&q=85&s=9543e3fc42d6bb972fcc8813a4684536 2500w" />
</Frame>

The dedicated terminal *will* use your zsh configuration, so aliases and environment variables will be available from `.zshrc` and other zsh-specific files.

If you use a different shell instead of `zsh`, and want Windsurf to use shared environment variables, we recommend creating a shared configuration file that both shells can source.

### Troubleshooting

If you have issues with the dedicated terminal, you can revert to the legacy terminal by enabling the Legacy Terminal Profile option in Windsurf settings.
