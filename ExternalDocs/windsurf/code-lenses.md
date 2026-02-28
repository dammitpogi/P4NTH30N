> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Code Lenses

> Use Windsurf code lenses for quick Explain, Refactor, and Docstring operations on functions and classes directly in the editor.

## Explain, Refactor, and Add Docstring

At the top of the text editor, Windsurf gives exposes *code lenses* on functions and classes.

<Frame>
  <img src="https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-code-lenses.png?fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=741eb72a40e5ae8eca97e8e2a493bd28" data-og-width="884" width="884" data-og-height="216" height="216" data-path="assets/windsurf/windsurf-code-lenses.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-code-lenses.png?w=280&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=a5e987745a245a5f5590007017e2e4e0 280w, https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-code-lenses.png?w=560&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=7af9cdcc98aa12db8887762d00b73089 560w, https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-code-lenses.png?w=840&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=40525c3d300b9414df551b4d18be9bf7 840w, https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-code-lenses.png?w=1100&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=fa91fe10929dbe193f549e4cd1165731 1100w, https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-code-lenses.png?w=1650&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=afd8a62eda36eb99b758e5503238be8c 1650w, https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-code-lenses.png?w=2500&fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=3f7775b532340787a9a17dcdf8c0e590 2500w" />
</Frame>

The `Explain` code lens will invoke Cascade, which will simply explain what the function or class does and how it works.

The `Refactor` and `Docstring` code lenses in particular will invoke Command.

* If you click `Refactor`, Windsurf will prompt you with a dropdown of selectable, pre-populated
  instructions that you can choose from. You can also write your own. This is equivalent to highlighting the function and invoking Command.
* If you click `Docstring`, Windsurf will generate a docstring for you above the function header.
  (In Python, the docstring will be correctly generated *underneath* the function header.)

<Frame>
  <video autoPlay muted loop playsInline src="https://mintcdn.com/codeium/bVGscI7v3lPUsThV/assets/windsurf/windsurf-refactor-code-lens.mp4?fit=max&auto=format&n=bVGscI7v3lPUsThV&q=85&s=484ec31a18bc46297583ca82ebb4a5fd" data-path="assets/windsurf/windsurf-refactor-code-lens.mp4" />
</Frame>
