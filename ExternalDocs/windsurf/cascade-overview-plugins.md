> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Cascade Overview

> Cascade brings agentic AI coding to JetBrains with Write/Chat modes, voice input, tool access, turbo mode, and real-time collaboration.

Windsurf's Cascade brings the best of agentic coding to the JetBrains suite.

To open Cascade, press `Cmd/Ctrl+L` or click the Cascade icon.

# Model selection

Select your desired model from the selection menu below the Cascade conversation input box. Click below too see the full breakdown of the available models and their availability across different plans and pricing.

<Card title="Models" icon="robot" href="/windsurf/models" horizontal={true}>
  Model availability in Windsurf.
</Card>

# Write/Chat Modes

Cascade comes in two modes: **Write** and **Chat**.

Write mode allows Cascade to create and make modifications to your codebase, while Chat mode is optimized for questions around your codebase or general coding principles.

<video autoPlay muted loop playsInline className="w-full aspect-video" src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains-cascade-modes.mp4?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=dab1edae206eabdc1a675462866b1ad6" data-path="assets/jetbrains-cascade-modes.mp4" />

# Queued Messages

While you are waiting for Cascade to finish its current task, you can queue up new messages to execute in order once the task is complete.

To add a message to the queue, simply type in your message while Cascade is working and press `Enter`.

* **Send immediately**: Press Enter again on an empty text box to send it right away.
* **Delete**: Remove any message from the queue before it's sent

# Access to Tools

Cascade has a variety of tools at its disposal, such as Search, Analyze, [Web Search](/windsurf/cascade/web-search), and the [terminal](/windsurf/terminal).

It can detect which packages and tools that you're using, which ones need to be installed, and even install them for you. Just ask Cascade how to run your project and press Accept.

<Note>Cascade can make up to 25 tool calls per prompt. If the trajectory stops, simply type in `continue` and Cascade will resume from where it left off. Each `continue` will count as a new prompt. </Note>

# Voice input

Use Voice input to use your voice to interact with Cascade. In its current form it can transcribe your speech to text.

<video autoPlay controls muted loop playsInline className="w-full aspect-video" src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/voice-mode.mp4?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=b6881ef11385d4f05fa151e0808a9e78" data-path="assets/windsurf/cascade/voice-mode.mp4" />

# Revert to previous steps

You have the ability to revert changes that Cascade has made if you want to. Simply hover your mouse over the original prompt and click on the revert arrow on the right, or revert directly from the table of contents. This will revert all code changes back to the state of your codebase at the desired step.

<Warning>Reverts are currently irreversible, so be careful!</Warning>

<video autoPlay controls muted loop playsInline className="w-full aspect-video" src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-revert.mp4?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=fe494383062acfc1efe07b23c03607a2" data-path="assets/windsurf/cascade/cascade-revert.mp4" />

# Auto-Execution Modes

Cascade supports three levels of command auto-execution in JetBrains: **Off**, **Auto**, and **Turbo**. You can select your preferred level via the Windsurf Settings panel.

| Level     | Description                                                                                                    |
| --------- | -------------------------------------------------------------------------------------------------------------- |
| **Off**   | Never auto-execute terminal commands, except those in your allow list.                                         |
| **Auto**  | Model decides whether to auto-execute commands based on safety assessment. Available with premium models only. |
| **Turbo** | Always auto-execute terminal commands and browser controls, except those in your deny list.                    |

<Note>For Teams and Enterprise users, administrators can set a maximum allowed auto-execution level. Users can select any level up to that maximum, but cannot exceed it.</Note>

<Frame>
  <img style={{ maxHeight: "500px" }} src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=8860ea8311000ae2cc440cef26560620" data-og-width="680" width="680" data-og-height="60" height="60" data-path="assets/windsurf/cascade/cascade-turbo-mode.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=dbcaa01fab58d7ba1fac05acc91ae12f 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=c5dc736ca3cd591d00f0c8b3b4f13f90 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=13ee4803cf3edcdaba2b9d76dcf109aa 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=389cfcb06aec368986869bfd15a42553 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=e9829ad62b78b641213d472b4bca8683 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-turbo-mode.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=db556ad06ddff8c4fbe5186569bf8334 2500w" />
</Frame>

For more details on auto-execution levels and allow/deny lists, see the [Terminal documentation](/windsurf/terminal#auto-executed-cascade-commands).

# Real-time collaboration

A unique capability of Cascade is that it is aware of your real-time actions.

You no longer necessarily need to prompt with context on your prior actions, as Cascade is already aware.

Try making a manual change in the code editor, and then prompt Cascade to "continue my work"!

# Ignoring files

If you'd like Cascade to ignore files, you can add your files to `.codeiumignore` at the root of your workspace. This will prevent Cascade from viewing, editing or creating files inside of the paths designated. You can declare the file paths in a format similar to `.gitignore`.

## Global .codeiumignore

For enterprise customers managing multiple repositories, you can enforce ignore rules across all repositories by placing a global `.codeiumignore` file in the `~/.codeium/` folder. This global configuration will apply to all Windsurf workspaces on your system and works in addition to any repository-specific `.codeiumignore` files.
