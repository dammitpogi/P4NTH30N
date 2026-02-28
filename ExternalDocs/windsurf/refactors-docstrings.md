> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Refactors, Docstrings, and More

> Use Command-powered features like code lenses for refactoring, docstring generation, and Smart Paste for cross-language code translation.

Command enables streamlined experiences for a few common operations.

## Function Refactors and Docstring Generation

Above functions and classes, Windsurf renders *code lenses*,
which are small, clickable text labels that invoke Windsurf's AI capabilities on the labeled item.

<Tip>You can disable code lenses by clicking the `✕` to the right of the code lens text.</Tip>

The `Refactor` and `Docstring` code lenses in particular will invoke Command.

* If you click `Refactor`, Windsurf will prompt you with a dropdown of selectable, pre-populated
  instructions that you can choose from. You can also write your own. This is equivalent to highlighting the function and invoking Command.
* If you click `Docstring`, Windsurf will generate a docstring for you above the function header.
  (In Python, the docstring will be correctly generated *underneath* the function header.)

<Frame caption="Encouraging readable and maintainable code, one docstring at a time.">
  <video autoPlay muted loop playsInline src="https://mintcdn.com/codeium/d8O4q6w3H2CjrirL/assets/jetbrains_docstrings.mp4?fit=max&auto=format&n=d8O4q6w3H2CjrirL&q=85&s=508c5797d57e88cf7b7db1c07a1e45c7" data-path="assets/jetbrains_docstrings.mp4" />
</Frame>

## Smart Paste

This feature allows you to copy code and paste it into a file in your IDE written in a different programming language.
Use `⌘+⌥+V` (Mac) or `Ctrl+Alt+V` (Windows/Linux) to invoke Smart Paste.
Behind the scenes, Windsurf will detect the language of the destination file and use Command to translate the code in your clipboard.
Windsurf's context awareness will try to write it to fit in your code, for example by referencing proper variable names.

<Frame>
  <video autoPlay muted loop playsInline src="https://exafunction.github.io/public/videos/demos/Smart_Paste_Demo_1080p.mp4" />
</Frame>

Some possible use cases:

* **Migrating code**: you're rewriting JavaScript into TypeScript, or Java into Kotlin.
* **Pasting from Stack Overflow**: you found a utility function online written in Go, but you're using Rust.
* **Learning a new language**: you're curious about Haskell and want to see what your would look like if written in it.
