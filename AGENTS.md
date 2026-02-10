# P4NTH30N Agent Orchestration

**Source of Truth**: `C:\Users\paulc\.config\opencode\oh-my-opencode-slim.json`

## Delegation Flow

```
User Request
     ↓
[ORCHESTRATOR] (opencode/minimax-m2.1-free)
     ├─→ @explorer → Codebase discovery, file search, pattern matching
     ├─→ @librarian → Library docs, API research, official references
     ├─→ @oracle → Strategic decisions, architectural guidance, high-stakes choices
     ├─→ @designer → UI/UX polish, visual design, user-facing experiences
     └─→ @fixer → Parallel implementation, well-defined code changes
```

## Specialist Roles

### @explorer
- **Model**: `opencode/gpt-5-nano`
- **Purpose**: Fast codebase search, file discovery, pattern matching
- **Tools**: glob, grep, ast_grep_search, lsp_find_references
- **Delegate when**: Finding files, locating code patterns, "where is X?" questions
- **Don't delegate**: Reading known files, single specific lookups

### @librarian  
- **Model**: `opencode/big-pickle`
- **Purpose**: External documentation and library research
- **Tools**: toolhive_find_tool → toolhive_call_tool (context7-remote)
- **Delegate when**: Library APIs, official docs, version-specific behavior
- **Don't delegate**: Standard language features, Array.map(), general programming

### @oracle
- **Model**: `groq/meta-llama/llama-4-scout-17b-16e-instruct`
- **Purpose**: Strategic advisor for architectural decisions and complex problems
- **Tools**: toolhive for research, full codebase access
- **Delegate when**: Major architecture, persistent problems, high-stakes trade-offs
- **Don't delegate**: Routine decisions, first bug fix, tactical "how" vs strategic "should"

### @designer
- **Model**: `opencode/kimi-k2.5-free`
- **Purpose**: UI/UX specialist for polished, intentional experiences
- **Tools**: agent-browser, toolhive
- **Delegate when**: User-facing interfaces, responsive layouts, visual consistency
- **Don't delegate**: Backend logic, headless functionality

### @fixer
- **Model**: `openai/gpt-5.3-codex-mini`
- **Purpose**: Fast parallel execution of clear specifications
- **Tools**: edit, write, bash (execution-focused)
- **Delegate when**: 3+ independent tasks, straightforward implementation, repetitive changes
- **Don't delegate**: Research needed, unclear requirements, sequential dependencies

## Orchestrator Rules

**Always use toolhive for MCP tools**:
```
1. toolhive_find_tool({ tool_description: "...", tool_keywords: "..." })
2. toolhive_call_tool({ server_name: "...", tool_name: "...", parameters: {...} })
```

**Delegation Pattern**:
```
@explorer → Discover unknowns, parallel searches
@librarian → Complex/evolving APIs, official docs
@oracle → High-stakes decisions, strategic guidance
@designer → User-facing polish, visual design
@fixer → Parallel execution, clear specs
```

**Communication Style**:
- Concise execution, no preamble
- Brief delegation notices: "Checking docs via @librarian..."
- Honest pushback when approaches seem problematic

## MCP Servers (via toolhive)

- **toolhive**: Tool discovery and execution wrapper (localhost:22368)
- **Disabled**: websearch, context7, grep_app (use toolhive instead)

## Fallback Chain

When an agent fails, OpenCode tries in order:
- **orchestrator**: gpt-5-nano → kimi-k2.5-free → big-pickle → gpt-5.1-codex-mini → gpt-5.3-codex-mini → trinity-large-preview-free → llama-4-scout
- **oracle**: kimi-k2.5-free → big-pickle → gpt-5-nano → gpt-5.1-codex-mini → minimax-m2.1-free → trinity-large-preview-free
- **fixer**: gpt-5.1-codex-mini → big-pickle → minimax-m2.1-free → trinity-large-preview-free → kimi-k2.5-free → gpt-5-nano

## P4NTH30N-Specific Guidelines

### Hybrid Data Access Pattern
- **H4ND (automation)** → MongoDB.Driver (real-time, low-latency)
- **HUN7ER (analytics)** → EF Core (complex queries, statistics)

### Code Style (enforced by .editorconfig)
- Indentation: Tabs (width 4)
- Line Length: Max 170 characters
- Braces: Same line (K&R style)
- Modern C#: Primary constructors, nullable reference types

### Error Handling
```csharp
try {
    int iterations = 0;
    while (true) {
        if (iterations++.Equals(10))
            throw new Exception($"[{username}] Retries exceeded.");
        return true;
    }
}
catch (Exception ex) {
    var frame = new StackTrace(ex, true).GetFrame(0);
    int line = frame?.GetFileLineNumber() ?? 0;
    Console.WriteLine($"[{line}] Processing failed: {ex.Message}");
    return false;
}
```
