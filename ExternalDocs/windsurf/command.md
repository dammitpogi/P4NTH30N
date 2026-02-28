> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Command

> Use Windsurf Command (Cmd/Ctrl+I) for inline code generation and edits with natural language. No premium credits required.

**Command** generates new or edits existing code via natural language inputs, directly in the editor window.

<Tip>Command does NOT consume any premium model credits.</Tip>

To invoke Command, press `⌘+I` on Mac or `Ctrl+I` on Windows/Linux.

You can enter a prompt in natural language and hit the Submit button (or `⌘+⏎`/`Ctrl+⏎`) to forward the instruction to the AI.

If you highlight a section of code before invoking Command, then the AI will edit the selection spanned by the highlighted lines.
Otherwise, it will generate code at your cursor's location.

<Frame style={{ border: 'none', background: 'none' }}>
  <img src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/windsurf-command.png?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=355f106c06d14c5150b8fd6ade2544d8" data-og-width="1786" width="1786" data-og-height="1018" height="1018" data-path="assets/windsurf-command.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/windsurf-command.png?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=927da1f69fbaabe5ba9a17e0f88cfefd 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/windsurf-command.png?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=b4785a636080ad292d742119776f9538 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/windsurf-command.png?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=63f27f54aae36f7c7c48b59ff86a1dc8 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/windsurf-command.png?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=7c67b7a3910176da619cf57b45f2577f 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/windsurf-command.png?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=8d30a6e68e175618f8b9dcd079cfcfd8 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/windsurf-command.png?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=c0964663193b983f1b612706b362cd2a 2500w" />
</Frame>

You can accept, reject, or follow-up a generation by clicking the corresponding code lens above the generated diff,or by using the appropriate shortcuts (`Cmd/Ctrl+Enter`/`Cmd/Ctrl+Delete`)

# Models

Command comes with its own set of models that are optimized for current-file edits.

<Frame>
  <video autoPlay muted loop playsInline src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/windsurf-command-models.mp4?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=56ff76bccc777e7bb30af7d4a4991325" data-path="assets/windsurf-command-models.mp4" />
</Frame>

<Tip> Windsurf Fast is the fastest, most accurate model available.</Tip>

# Terminal Command

You can use Command in the terminal (`Cmd/Ctrl+I`) to generate the proper CLI syntax using prompts in natural language.

<Frame style={{ border: 'none', background: 'none' }}>
  <img src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=b03f1498ac0b7dc344270f975f9a234f" data-og-width="980" width="980" data-og-height="164" height="164" data-path="assets/windsurf-terminal-command.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=ec94b782cbe3b3d0a3e8d44ce7b27c74 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=9e3839c701ba2308cbc754842c8472a4 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=25245a6097e94c63ed47cb382097f82b 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=ecfdf898fe06e81255add438d3daff49 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=c46a449c560b98a2e295e904601a3c51 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf-terminal-command.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=44ec229230a00b642a4aa61f1d4c571c 2500w" />
</Frame>

# Best Practices

Command is great for file-scoped, in-line changes that you can describe as an instruction in natural language.
Here are some pointers to keep in mind:

* The model that powers Command is larger than the one powering autocomplete.
  It is slower but more capable, and it is trained to be especially good at instruction-following.

* If you highlight a block of code before invoking Command, it will edit the selection. Otherwise, it will do a pure generation.

* Using Command effectively can be an art. Simple prompts like "Fix this" or "Refactor" will likely work
  thanks to Windsurf's context awareness.
  A specific prompt like "Write a function that takes two inputs of type `Diffable` and implements the Myers diff algorithm"
  that contains a clear objective and references to relevant context may help the model even more.
