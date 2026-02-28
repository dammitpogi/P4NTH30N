> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Chat Overview

> Chat with your codebase using Windsurf Chat in VS Code and JetBrains. Use @-mentions, persistent context, pinned files, and inline citations.

<Note>
  Chat and its related features are only supported in: VS Code, JetBrains IDEs, Eclipse, X-Code, and Visual Studio.
</Note>

**Windsurf Chat** enables you to talk to your codebase from within your editor.
Chat is powered by our [context awareness](/context-awareness/overview.mdx) engine.
It combines built-in context retrieval with optional user guidance to provide accurate and grounded answers.

<Tabs>
  <Tab title="VS Code">
    In VS Code, Windsurf Chat can be found by default on the left sidebar.
    If you wish to move it elsewhere, you can click and drag the Windsurf icon and relocate it as desired.

    <Frame>
      <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_vscode_where_to_find.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=7834d605c66fe4413718ad0d6e54ba29" data-og-width="1037" width="1037" data-og-height="702" height="702" data-path="assets/chat_vscode_where_to_find.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_vscode_where_to_find.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=7a5d521234f9566acdcffd7b44639054 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_vscode_where_to_find.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=6ac39537389f4c36e0e0bcf0c998cc88 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_vscode_where_to_find.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=3d1fb062d8f5a0e5ecaedc2ed078a7fb 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_vscode_where_to_find.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=7ca31423b43f8a27ea85b94f0c5ac83e 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_vscode_where_to_find.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=f9c8f91b37219aa81348ced8e5cdb76f 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_vscode_where_to_find.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=771b59b1da45de39e55fc8f579b40e9c 2500w" />
    </Frame>

    You can use `⌘+⇧+A` on Mac or `Ctrl+⇧+A` on Windows/Linux to open the chat panel and toggle focus between it and the editor.
    You can also pop the chat window out of the IDE entirely by clicking the page icon at the top of the chat panel.
  </Tab>

  <Tab title="JetBrains">
    In JetBrains IDEs, Windsurf Chat can be found by default on the right sidebar.
    If you wish to move it elsewhere, you can click and drag the Windsurf icon and relocate it as desired.

    <Frame>
      <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_jetbrains_where_to_find.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=d2679679c30f27acf855984e168e9707" data-og-width="989" width="989" data-og-height="771" height="771" data-path="assets/chat_jetbrains_where_to_find.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_jetbrains_where_to_find.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=936a0dbdc0e9da439451a63238565681 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_jetbrains_where_to_find.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=1e4bf489fb2a6f66b3bb63cea143c61e 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_jetbrains_where_to_find.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=3649e5197cd42796a64ea9eec82dcad4 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_jetbrains_where_to_find.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=dca7d5401898aef03321bb29680d1d50 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_jetbrains_where_to_find.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=b510f4cb1b276b4e60c2c2932ae92457 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_jetbrains_where_to_find.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=4d352422c10737108cd2bfcdbe051153 2500w" />
    </Frame>

    You can use `⌘+⇧+L` on Mac or `Ctrl+⇧+L` on Windows/Linux to open the chat panel while you are typing in the editor.
    You can also open the chat in a popped-out browser window by clicking `Tools > Windsurf > Open Windsurf Chat in Browser` in the top menu bar.
  </Tab>
</Tabs>

## @-Mentions

<Tip>An @-mention is a deterministic way of bringing in context, and is guaranteed to be part of the context used to respond to a chat.</Tip>

In any given chat message you send, you can explicitly refer to context items from within the chat input by prefixing a word with `@`.

Context items available to be @-mentioned:

* Functions & classes
  * Only functions and classes in the local indexed
  * Also only available for languages we have built AST parsers for (Python, TypeScript, JavaScript, Go, Java, C, C++, PHP, Ruby, C#, Perl, Kotlin, Dart, Bash, COBOL, and more)
* Directories and files in your codebase
* Remote repositories
* The contents of your in-IDE terminal (VS Code only).

<Frame>
  <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/at_mentions.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=941c76f7691cd053706a4bc281112cc5" data-og-width="1456" width="1456" data-og-height="814" height="814" data-path="assets/at_mentions.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/at_mentions.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=b17499e00a66c3b95cf3b8df263d5ca3 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/at_mentions.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=1298aa3619877ab24155a201a5ad5d6b 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/at_mentions.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=5417614970f16b9add22b087b1ab80b1 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/at_mentions.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=441ca49ce613783ab5d358e8a7c2e2db 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/at_mentions.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=e1438fc87ade47cb3dbcbf6a620c0901 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/at_mentions.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=7fdd33c52d96e9cccbb8772a0630c30f 2500w" />
</Frame>

You can also try `@diff`, which lets you chat about your repository's current `git diff` state.
The `@diff` feature is currently in beta.

<Tip>If you want to pull a section of code into the chat and you don't have @-Mentions available, you can: 1. highlight the code -> 2. right click -> 3. select 'Windsurf: Explain Selected Code Block'</Tip>

## Persistent Context

You can instruct the chat model to use certain context throughout a conversation and across different conversations
by clicking on the `Advanced` tab in the chat panel.

<Frame caption="Chat shows you the context it is considering.">
  <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_context.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=414beb483cf5725f5999ae090b01c986" data-og-width="1314" width="1314" data-og-height="624" height="624" data-path="assets/chat_context.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_context.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=121339f0f4c77b54027afa9f94fe3134 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_context.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=d654f90f78945825c6b75e805190184a 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_context.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=daf01b0d5d17b9ff09d0a2da033f93db 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_context.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=9badbb464a1dd8f48dbf02e80740ae27 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_context.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=84e13b33be53ce5950d9d89e234eec0a 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_context.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=998839dcc4a2e446bc52108d2f0c4655 2500w" />
</Frame>

In this tab, you can see:

* **Custom Chat Instructions**: a short prompt guideline like "Respond in Kotlin and assume I have little familiarity with it" to orient the model towards a certain type of response.
* **Pinned Contexts**: items from your codebase like files, directories, and code snippets that you would like explicitly for the model to take into account.
  See also [Context Pinning](/context-awareness/overview#context-pinning).
* **Active Document**: a marker for your currently active file, which receives special focus.
* **Local Indexes**: a list of local repositories that the Windsurf context engine has indexed.

## Slash Commands

You can prefix a message with `/explain` to ask the model to explain something of your choice.
Currently, `/explain` is the only supported slash command.
[Let us know](https://codeium.canny.io/feature-requests/) if there are other common workflows you want wrapped in a slash command.

## Copy and Insert

Sometimes, Chat responses will contain code blocks. You can copy a code block to your clipboard or insert it directly into the editor
at your cursor position by clicking the appropriate button atop the code block.

<Note>
  If you would like the AI to enact a change directly in your editor based on an instruction,
  consider using [Windsurf Command](/command/overview).
</Note>

## Inline Citations

Chat is aware of code context items, and its responses often contain linked references to snippets of code in your files.

<Frame>
  <video autoPlay muted loop playsInline src="https://exafunction.github.io/public/videos/chat/inline-citations.mp4" />
</Frame>

## Regenerate with Context

By default, Windsurf makes a judgment call whether any given question is general or if it requires codebase context.

You can force the model to use codebase context by submitting your question with `⌘⏎`.
For a question that has already received a response, you rerun with context by clicking the sparkle icon.

<Frame>
  <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_regenerate_with_context.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=6da54122318e3b654ba4613abe6a68a1" data-og-width="440" width="440" data-og-height="206" height="206" data-path="assets/chat_regenerate_with_context.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_regenerate_with_context.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=2ca70708a90c6e97b389b08eeb60b26c 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_regenerate_with_context.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=326e458558a6a57be9b521dc07963b54 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_regenerate_with_context.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=ebd00e0f95d8d560400bbb2656fb19f0 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_regenerate_with_context.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=8161fac3aa906991d1510eda1e75082c 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_regenerate_with_context.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=174d713ca67d151027d309575771f342 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_regenerate_with_context.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=3f8d542e05683a12054aa6a7e34d0922 2500w" />
</Frame>

## Stats for Nerds

Lots of things happen under the hood for every chat message. You can click the stats icon to see these statistics for yourself.

<Frame>
  <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_stats_for_nerds.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=048a60359f0330d1281175296804fbcb" data-og-width="1634" width="1634" data-og-height="1180" height="1180" data-path="assets/chat_stats_for_nerds.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_stats_for_nerds.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=d2196e0d69106a2968b1ad74d4a58b24 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_stats_for_nerds.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=39ecd5c9e5a8c4e5f2022e620c4e96c7 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_stats_for_nerds.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=859c020aae04741595aca4b14c16dd2b 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_stats_for_nerds.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=0abab7be0839b348c23b73bd27961bc0 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_stats_for_nerds.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=96264b627b032f8ac6bbdafa748bb810 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_stats_for_nerds.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=5518d27d397fce3c2c4b5d3ebe3a54a7 2500w" />
</Frame>

## Chat History

To revisit past conversations, click the history icon at the top of the chat panel.
You can click the `+` to create a new conversation, and
you can click the `⋮` button to export your conversation. This applies only for the Windsurf Plugins.

<Frame>
  <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_history.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=2c18d444db63df1329fa744079e7a05d" data-og-width="828" width="828" data-og-height="210" height="210" data-path="assets/chat_history.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_history.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=5ba6db18a93a757a3543879cf087d2c2 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_history.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=ff9fa87e8e4fdeb8ac8bfca0caff3b7d 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_history.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=89476debc7aecaf71a3689546f78291d 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_history.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=f8208fecceea890b07205e4f41e5c9de 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_history.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=cf57079f15d6cb6bc45ade9ff3ecd04f 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_history.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=a5c87ee97b6eb69739b3f1a03f0b935d 2500w" />
</Frame>

## Settings

Click on the gear icon to reach the `Settings` tab. Here, you can view settings that are applicable to your account. For example, you can update your theme preferences (light or dark), change autocomplete speed, view current plan, and change font size.
The settings panel also gives you an option to download diagnostics, which are debug logs that can be helpful for the Windsurf team to debug an issue, should you encounter one.

<Frame caption="On Windsurf Chat, click on the gear icon on the top right corner">
  <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_settings.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=d32c713a4055cf8f5c9cb0472671a5f0" data-og-width="1488" width="1488" data-og-height="1536" height="1536" data-path="assets/chat_settings.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_settings.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=0e57e72ba502af91b5cc131a3b1d4477 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_settings.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=100a22920312851b534aad48f94390f7 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_settings.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=6d3ce9a08bcbe10aafc3ab3c36c4e113 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_settings.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=01081c274077a9c7bea2c18fdd2b25e5 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_settings.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=5d5999526b4b4daba82b61361ade1776 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/chat_settings.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=cb0c379dacfca12e912a1a4901e0c587 2500w" />
</Frame>

## Telemetry

<Note>You may encounter issues with Chat if Telemetry is not enabled.</Note>

<Tabs>
  <Tab title="VS Code">
    To enable telemetry, open your VS Code settings and navigate to User > Application > Telemetry. In the following dropdown, select "all".

    <img width="350" src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_telemetry_settings.png?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=0d4cd0b8d2c1dfaf0fa5c3a87e9e639f" data-og-width="634" data-og-height="348" data-path="assets/vscode_telemetry_settings.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_telemetry_settings.png?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=0ed5126c8fb51e98df309a6fc64ea276 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_telemetry_settings.png?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=2216ff691d5675b9c3875598d9e3af9e 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_telemetry_settings.png?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=69cc7901cfb5772f2a923e965a4af186 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_telemetry_settings.png?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=586d828c16de1d34eadef84cd957c3f4 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_telemetry_settings.png?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=237d861b04375c9e4ce5ca223f105d56 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/vscode_telemetry_settings.png?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=2e4453f2733662eacdb1605243d83c36 2500w" />
  </Tab>

  <Tab title="JetBrains">
    To enable telemetry in JetBrains IDEs, open your Settings and navigate to Appearance & Hehavior > System Settings > Data Sharing.

    <img width="350" src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_telemetry_settings.png?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=ded930e34656b692d02371b36b9d612b" data-og-width="922" data-og-height="436" data-path="assets/jetbrains_telemetry_settings.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_telemetry_settings.png?w=280&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=bdc98fc2189716134e1cc2d50b2f30e5 280w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_telemetry_settings.png?w=560&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=c885517091a3049f3dbdcc779a80867d 560w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_telemetry_settings.png?w=840&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=0ad7ed77b6ff507743a3288a381ac092 840w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_telemetry_settings.png?w=1100&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=b8b728bba6045aed81b3a95fbae48ba0 1100w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_telemetry_settings.png?w=1650&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=3fc49a151dfd9d9ae951f8621caf3bb0 1650w, https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_telemetry_settings.png?w=2500&fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=77eb834b6a8abfea4d3d1dfc62de8937 2500w" />
  </Tab>
</Tabs>
