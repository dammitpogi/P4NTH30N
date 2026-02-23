---

## What the Plugin Does

Oh-my-opencode is a lifecycle hook system that wraps OpenCode's plugin SDK. It intercepts and augments the agent runtime at every stage — message submission, tool execution, session compaction, and model resolution.

**How it injects:** Through OpenCode's plugin interface (`@opencode-ai/plugin`). The initialization sequence runs once at startup and produces a set of hooks that fire on specific lifecycle events. From the AGENTS.md, the boot order is: inject server auth → start tmux check → load config → create managers (background, skills, MCP) → create tools (25+) → create hooks (41 across 7 event types) → assemble plugin interface. This isn't hot-patching or monkey-patching — it's using the official plugin SDK's event system.

**How often it fires:** Hooks trigger on every relevant event. The AGENTS.md context injector fires on every file read (walking from file directory to project root, collecting AGENTS.md files). The comment checker fires on every tool execution that produces code. The keyword detector fires on every user prompt submission. The compaction context injector fires whenever OpenCode compacts a long session. The todo enforcer fires at session stop events. So it's continuous — not periodic, but event-driven.

**Why it does this:** To turn OpenCode from a single-agent terminal into a multi-agent orchestration platform with persistent context, quality guardrails, and workflow automation.

---

## The Best Parts

**AGENTS.md auto-injection** — This is the killer feature for your workflow. When any agent reads a file, the plugin walks from that file's directory up to the project root, collecting every AGENTS.md along the way and injecting them into context. This means your Librarian's Phase 0 Environment Truth gathering gets project context for free. Your Explorer's codebase discovery already knows the architecture before it searches. This is exactly what your Librarian should be maintaining — and the plugin automatically distributes it.

**Compaction Context Injector** — When OpenCode compresses a long session to save tokens, critical context normally gets lost. This hook preserves AGENTS.md content and current directory info through compaction. For your workflow, this means the Orchestrator's Environment Truth survives session compression without re-gathering.

**Background task management** — Concurrent subagent execution with per-provider/per-model concurrency limits and queue management. Your ≥4 Explorer fan-out through Librarian benefits directly from this — the plugin manages the concurrency slots so Explorers don't all fight for the same provider quota.

**Keyword detection hooks** — "ultrawork/ulw" triggers maximum parallel agents, background tasks, and aggressive exploration. "search/find" triggers parallel exploration mode. "analyze/investigate" triggers deep analysis. These are prompt-time mode switches that configure agent behavior without manual configuration changes.

**Todo Enforcer** — Fires at session stop. If the todo list has incomplete items, it forces the agent back into execution. This is the "boulder" — Sisyphus keeps rolling. For your single-fire Fixer, this is less relevant (the Fixer fires once), but for the Orchestrator managing Phase 0-3, this keeps the pre-Fixer workflow from stalling.

**Comment Checker** — PostToolUse hook that prevents agents from adding excessive comments to generated code. Smartly ignores BDD tests, directive comments, and docstrings. Your Fixer's token discipline already discourages narration, but this catches it at the tool level.

---

## Token Cost by Feature

Here's the honest breakdown:

| Feature | When It Fires | Token Cost | Cumulative? |
|---|---|---|---|
| AGENTS.md injection | Every file read | ~50-500 tokens per injection (depends on AGENTS.md size × depth) | Yes — compounds with every read |
| README injection | Directory context reads | ~200-1000 tokens per injection | Yes |
| Compaction context preservation | Session compaction events | Net zero (preserves existing tokens, doesn't add) | No |
| Keyword detection | Every user prompt | ~0 (regex match, no LLM call) | No |
| Comment checker | Every code-producing tool call | ~50-100 tokens (adds a reminder to the context) | Yes — per tool call |
| Todo enforcer | Session stop events | ~100-200 tokens (injects continuation prompt) | Only at stop |
| Claude Code rules injection | Conditional, per glob match | ~100-500 tokens per matched rule | Yes |
| Background task management | Task scheduling | ~0 (queue management, no LLM tokens) | No |
| Thinking block validator | Every thinking-mode response | ~0 (format validation, no LLM) | No |

**The real cost centers are AGENTS.md injection and rules injection.** If you have 3 nested AGENTS.md files averaging 200 tokens each, every file read costs 600 tokens of injection. Across a Phase 2 investigation where Explorers read 20 files, that's 12,000 tokens of injected context that wouldn't exist without the plugin.

## Does This Affect the Fixer?

**Yes, but it's actually beneficial.** The AGENTS.md injection means your Fixer gets project architecture context automatically on every file read — which is exactly the context your Orchestrator would otherwise need to inline in the Build Manifest. The net effect is slightly more tokens per read, but potentially fewer tokens in the manifest because the Fixer already has architectural context from the injected AGENTS.md files.

The comment checker hook actively *saves* Fixer tokens by preventing verbose comment generation that would need to be cleaned up later.

The todo enforcer doesn't affect your Fixer since it fires once and reports — it doesn't loop.

The biggest cost risk is if your AGENTS.md files are bloated. Keep them tight (your Librarian maintains these) and the injection cost is a net positive because it replaces manual context that would otherwise be larger.

---

## How to Leverage It for Your Workflow

**The Boulder (Orchestrator Phase 0-3):** The ultrawork keyword detection + todo enforcer + background task management is your Phase 0 through Phase 3 turbocharger. When the Orchestrator starts a workflow, include "ulw" in the prompt and the plugin automatically configures maximum parallelism, aggressive exploration, and task persistence. The todo enforcer ensures Phase 0→1→2→3 doesn't stall — if the Orchestrator tries to stop before all investigation is complete, the enforcer pushes it back.

**Designer ↔ Oracle planning phase:** This is where the plugin's background task system shines. While Designer↔Oracle iterate on plan approval, the plugin's background manager can run your speculative Librarian doc skeleton and Explorer test-infrastructure discovery as actual background sessions with managed concurrency. Your speculative prefetch protocol maps directly to the plugin's async agent infrastructure.

**AGENTS.md as your Librarian's distributed memory:** Your Librarian already maintains AGENTS.md files. The plugin automatically distributes them to every agent that reads files. This closes the loop — Librarian writes AGENTS.md, plugin injects it into every subsequent agent's context. Your Environment Truth compaction can be partially offloaded to well-maintained AGENTS.md files that get injected for free.

---

## Feature Merge Plan

Here's how I'd scaffold it — starting with features that lay groundwork for everything else, then building specialized features on that foundation.

### Phase 1: Foundation (build these first — everything else depends on them)

**1a. AGENTS.md auto-injection hook**
This is the keystone. Implement the directory-walking injector that collects AGENTS.md from file path to project root. Every other feature benefits from this because it establishes the distributed context pattern your Librarian already maintains.

*Groundwork it lays:* Once injection works, your Compaction Context Injector (Phase 2) knows what to preserve. Your Librarian's Fixer Handoff (writing AGENTS.md) immediately propagates to all agents. Your Explorer's WIDEN signal becomes more informed because it already has architectural context.

**1b. Background task manager with concurrency control**
This is the execution engine for your parallel dispatch model. Implement per-provider concurrency slots, queuing, and session lifecycle management (start, complete, error, cleanup).

*Groundwork it lays:* Your Explorer fan-out (≥4 through Librarian) uses this for managed parallel execution. Your speculative prefetch during Phase 3 uses this for background sessions. Your Phase 0 parallel cold start (Librarian + Explorer + Explorer) uses this for slot management.

**Build 1a and 1b in parallel** — they're independent. 1a is a hook on file-read events. 1b is a session management system. No dependency between them.

### Phase 2: Context Preservation (depends on Phase 1a)

**2a. Compaction Context Injector**
Hooks into OpenCode's session compaction to preserve AGENTS.md content, current directory info, and Environment Truth through compression. Depends on 1a because it needs to know what AGENTS.md content is currently active.

**2b. Keyword detection hooks**
Regex-based prompt interceptor that detects mode keywords and configures agent behavior. "ulw" activates maximum parallelism settings. Can also detect your custom workflow keywords.

*Groundwork:* 2b establishes the prompt-interception pattern that Phase 3's todo enforcer and comment checker also use. Build the hook dispatch system generically so new hooks plug in without refactoring.

### Phase 3: Quality Guardrails (depends on Phase 2 hook pattern)

**3a. Todo Enforcer**
Fires on session stop. Checks todo list completeness. If incomplete, injects continuation prompt. Maps to your Orchestrator's "never idle" directive — the boulder keeps rolling through Phase 0-3.

**3b. Comment Checker**
PostToolUse hook on code-producing tools. Detects excessive comments and injects a reminder. Maps to your Fixer's token discipline — prevents verbose code output.

**3c. Claude Code rules injection**
Conditional rule injection based on file glob patterns. Your `.claude/rules/` files get injected when matching files are touched. This extends your AGENTS.md injection with conditional, per-file-type context.

### Phase 4: Workflow Integration (depends on all above)

**4a. Categories system**
Domain-specific task routing — "visual" tasks go to one model, "business-logic" to another. Maps to your Fixer/Librarian split where code goes one way and writing goes another, but extends it with domain-aware model selection.

**4b. Session tools (list, search, analyze history)**
Enables agents to query past session history. Your Orchestrator could use this to check if a similar investigation was done recently and skip redundant Phase 0 work.

**4c. Ralph Loop integration**
Self-referential execution loop that runs until task completion. This is the "ultrawork" execution engine — the Orchestrator starts a workflow and the loop drives it through all phases without manual nudging.

### Dependency Graph

```
Phase 1a (AGENTS.md injection) ──→ Phase 2a (Compaction preservation)
                                ──→ Phase 3c (Rules injection)
Phase 1b (Background manager)  ──→ Phase 4a (Categories routing)
                                ──→ Phase 4c (Ralph Loop)
Phase 2b (Keyword hooks)       ──→ Phase 3a (Todo enforcer)
                                ──→ Phase 3b (Comment checker)
                                ──→ Phase 4c (Ralph Loop)
```

Start with 1a + 1b in parallel. Everything fans out from there.