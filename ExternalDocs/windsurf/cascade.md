> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Cascade Overview

> Cascade is Windsurf's agentic AI assistant with Code/Chat modes, tool calling, voice input, checkpoints, real-time awareness, and linter integration.

Windsurf's Cascade unlocks a new level of collaboration between human and AI.

To open Cascade, press `Cmd/Ctrl+L`click the Cascade icon in the top right corner of the Windsurf window. Any selected text in the editor or terminal will automatically be included.

### Quick links to features

<CardGroup cols={2}>
  <Card title="Web Search" icon="globe-pointer" href="/windsurf/cascade/web-search">
    Search the web for information to be referenced in Cascade's suggestions.
  </Card>

  <Card title="Memories & Rules" icon="cloud-word" href="/windsurf/cascade/memories">
    Memories and rules help customize behavior.
  </Card>
</CardGroup>

<CardGroup cols={2}>
  <Card title="MCP" icon="hammer" href="/windsurf/cascade/mcp">
    MCP servers extend the agent's capabilities.
  </Card>

  <Card title="Terminal" icon="terminal" href="/windsurf/terminal">
    An upgraded Terminal experience.
  </Card>
</CardGroup>

<CardGroup cols={2}>
  <Card title="Workflows" icon="list" href="/windsurf/cascade/workflows">
    Automate repetitive trajectories.
  </Card>

  <Card title="App Deploys" icon="rocket" href="/windsurf/cascade/app-deploys">
    Deploy applications in one click.
  </Card>
</CardGroup>

# Model selection

Select your desired model from the selection menu below the Cascade conversation input box. Click below too see the full list of the available models and their availability across different plans and pricing.

<Card title="Models" icon="gear-code" href="/windsurf/models" horizontal={true}>
  Model availability in Windsurf.
</Card>

# Cascade Code / Cascade Chat

Cascade comes in two primary modes: **Code** and **Chat**.

Code mode allows Cascade to create and make modifications to your codebase, while Chat mode is optimized for questions around your codebase or general coding principles.

While in Chat mode, Cascade may propose new code to you that you can accept and insert.

# Plans and Todo Lists

Cascade has built-in planning capabilities that help improve performance for longer tasks.

In the background, a specialized planning agent continuously refines the long-term plan while your selected model focuses on taking short-term actions based on that plan.

Cascade will create a Todo list within the conversation to track progress on complex tasks. To make changes to the plan, simply ask Cascade to make updates to the Todo list.

Cascade may also automatically make updates to the plan as it picks up new information, such as a [Memory](/windsurf/cascade/memories), during the course of a conversation.

# Queued Messages

While you are waiting for Cascade to finish its current task, you can queue up new messages to execute in order once the task is complete.

To add a message to the queue, simply type in your message while Cascade is working and press `Enter`.

* **Send immediately**: Press Enter again on an empty text box to send it right away.
* **Delete**: Remove any message from the queue before it's sent

# Tool Calling

Cascade has a variety of tools at its disposal, such as Search, Analyze, [Web Search](/windsurf/cascade/web-search), [MCP](/windsurf/cascade/mcp), and the [terminal](/windsurf/terminal).

It can detect which packages and tools that you're using, which ones need to be installed, and even install them for you. Just ask Cascade how to run your project and press Accept.

<Note>Cascade can make up to 20 tool calls per prompt. If the trajectory stops, simply press the `continue` button and Cascade will resume from where it left off. However, each `continue` will count as a new prompt credit due to tool calling costs.</Note>

You can configure an `Auto-Continue` setting to have Cascade automatically continue its response if it hits a limit. These will consume a prompt credit(s) corresponding to the model you are using.

<Frame>
  <video autoPlay muted loop playsInline src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/auto-continue.mp4?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=0f75d2d9de596f1ead6f37c4f68eca43" data-path="assets/windsurf/cascade/auto-continue.mp4" />
</Frame>

# Voice input

Use Voice input to use your voice to interact with Cascade. In its current form it can transcribe your speech to text.

<video autoPlay controls muted loop playsInline className="w-full aspect-video" src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/voice-mode.mp4?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=b6881ef11385d4f05fa151e0808a9e78" data-path="assets/windsurf/cascade/voice-mode.mp4" />

# Named Checkpoints and Reverts

You have the ability to revert changes that Cascade has made. Simply hover your mouse over the original prompt and click on the revert arrow on the right, or revert directly from the table of contents. This will revert all code changes back to the state of your codebase at the desired step.

<Warning>Reverts are currently irreversible, so be careful!</Warning>

<video autoPlay controls muted loop playsInline className="w-full aspect-video" src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/cascade-revert.mp4?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=fe494383062acfc1efe07b23c03607a2" data-path="assets/windsurf/cascade/cascade-revert.mp4" />

You can also create a named snapshot/checkpoint of the current state of your project from within the conversation, which you can easily navigate to and revert at any time.

<video autoPlay controls muted loop playsInline className="w-full aspect-video" src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/namedcheckpoints.mp4?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=d3c50b95ea5c2e67c2f08f00af4d11f6" data-path="assets/windsurf/cascade/namedcheckpoints.mp4" />

# Real-time awareness

A unique capability of Windsurf and Cascade is that it is aware of your real-time actions, removing the need to prompt with context on your prior actions.

Simply instruct Cascade to "Continue".

<video autoPlay controls muted loop playsInline className="w-full aspect-video" src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/windsurf-continue.mp4?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=72fa8688e966ff308daa5876e6dc7f98" data-path="assets/windsurf-continue.mp4" />

# Send problems to Cascade

When you have problems in your code which show up in the Problems panel at the bottom of the editor, simply click the `Send to Cascade` button to bring them into the Cascade panel as an @ mention.

<Frame>
  <img style={{ maxHeight: "500px" }} src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/send-problems-to-cascade.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=46a20b503cb0cda0139ab1b081ca3de3" data-og-width="316" width="316" data-og-height="122" height="122" data-path="assets/windsurf/cascade/send-problems-to-cascade.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/send-problems-to-cascade.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=28061b4d7f851d8840f436f8b0919e15 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/send-problems-to-cascade.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=93934a76820912a1fd5a1778cf641844 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/send-problems-to-cascade.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=0aab2818d64a7b08e266baacf6560cce 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/send-problems-to-cascade.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=fe744688100032ab1c298e97ef822efc 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/send-problems-to-cascade.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=8d794127338249c9fbc74399ac7d1414 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/send-problems-to-cascade.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=74ef3a1d9023525aeea7ca654149a3b4 2500w" />
</Frame>

# Explain and fix

For any errors that you run into from within the editor, you can simply highlight the error and click `Explain and Fix` to have Cascade fix it for you.

<Frame>
  <img style={{ maxHeight: "500px" }} src="https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-explain-fix.png?fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=e2d18a81a54554b523805d75317488f5" data-og-width="886" width="886" data-og-height="140" height="140" data-path="assets/windsurf/windsurf-explain-fix.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-explain-fix.png?w=280&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=79109955cb9719ec411c6f41ff2a4f52 280w, https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-explain-fix.png?w=560&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=a122405e2d8bf975f03842eb63fda6e3 560w, https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-explain-fix.png?w=840&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=628e64768d102e28f380f1d5f8c1a770 840w, https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-explain-fix.png?w=1100&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=13161a7f834d458a9436b337d67cc58f 1100w, https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-explain-fix.png?w=1650&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=1d9ebea051ccb1a80798c57e2ef2b89b 1650w, https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-explain-fix.png?w=2500&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=c2e9a3082c59fe0299d68fcfd74b4185 2500w" />
</Frame>

# Ignoring files

If you'd like Cascade to ignore files, you can add your files to `.codeiumignore` at the root of your workspace. This will prevent Cascade from viewing, editing or creating files inside of the paths designated. You can declare the file paths in a format similar to `.gitignore`.

## Global .codeiumignore

For enterprise customers managing multiple repositories, you can enforce ignore rules across all repositories by placing a global `.codeiumignore` file in the `~/.codeium/` folder. This global configuration will apply to all Windsurf workspaces on your system and works in addition to any repository-specific `.codeiumignore` files.

# Linter integration

Cascade can automatically fix linting errors on generated code. This is turned on by default, but it can be disabled by clicking `Auto-fix` on the tool call, and clicking `disable`. This edit will not consume any credits.

<Frame>
  <img src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/auto-fix-lint.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=ae3f3ecca77f0a0a646adedb91b6a22e" data-og-width="584" width="584" data-og-height="196" height="196" data-path="assets/windsurf/cascade/auto-fix-lint.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/auto-fix-lint.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=4c3726305eed4f34d6985a4fe06b5816 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/auto-fix-lint.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=fb969e8bfe739b9daa9d0ef6284a19fe 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/auto-fix-lint.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=462f5f2e5fd3f6e632bf417c35f739bd 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/auto-fix-lint.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=651fa582a7c313772372a49bad3438b1 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/auto-fix-lint.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=1aed8edc51e41f0121e93d5dd253be07 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/auto-fix-lint.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=0c3129926f6965afb414bf5e5dd641cd 2500w" />
</Frame>

When Cascade makes an edit with the primary goal of fixing lints that it created and auto-detected,
it may discount the edit to be free of credit charge. This is in recognition of the fact that
fixing lint errors increases the number of tool calls that Cascade makes.

# Sharing your conversation

<Note>This feature is currently only available for Teams and Enterprise customers.</Note>

You can share your Cascade trajectories with your team by clicking the `...` Additional options button in the top right of the Cascade panel, and clicking `Share Conversation`.

# @-mention previous conversations

You can also reference previous conversations with other conversations via an `@-mention`.

When you do this, Cascade will retrieve the most relevant and useful information like the conversation summaries and checkpoints, and specific parts of the conversation that you query for. It typically will not retrieve the full conversation as to not overwhelm the context window.

<video autoPlay controls muted loop playsInline className="w-full aspect-video" src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/at-mention-convos.mp4?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=f580f0222fdf75ec42cb7a9470e6de02" data-path="assets/windsurf/cascade/at-mention-convos.mp4" />

# Simultaneous Cascades

Users can have multiple Cascades running simultaneously. You can navigate between them using the dropdown menu in the top left of the Cascade panel.

<Warning>If two Cascades edit the same file at the same time, the edits can race, and sometimes the second edit will fail.</Warning>

If you expect two Cascades to edit similar files, you should consider using [worktrees](./worktrees) to keep them isolated.
