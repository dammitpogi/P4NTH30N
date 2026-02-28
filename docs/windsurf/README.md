# WindSurf Documentation

**Date**: 2026-02-18
**Status**: Active

---

## Overview

WindSurf is the AI-powered IDE used for P4NTHE0N development. This document describes the WindSurf configuration and workflow integration.

---

## Cascade Modes

WindSurf Cascade offers three modes:

| Mode | Use Case | Tools |
|------|----------|-------|
| **Code** | Implementation, refactoring | All tools enabled |
| **Plan** | Complex features requiring planning | All tools enabled (exploratory) |
| **Ask** | Learning, questions | Search tools only |

**Shortcuts**: `⌘+.` (Mac) or `Ctrl+.` (Windows/Linux)

---

## Workflows

Workflows are markdown files in `.windsurf/workflows/` invoked via slash commands.

### Available Workflows

- `/address-pr-comments` - Process PR review comments
- `/run-tests` - Execute test suite
- `/deploy` - Deploy to target environment
- `/decision-implementation` - Implement a Decision
- `/fixer-execution` - Execute autonomous Fixer

### Workflow Format

```markdown
# Workflow Title

## Description
What this workflow does

## Steps
1. Step one
2. Step two
3. Step three

## Example
/example-command --option value
```

---

## Skills

Skills are reusable capabilities in `.windsurf/skills/[skill-name]/SKILL.md`.

### Available Skills

- `@decision-analysis` - Analyze Decision specifications
- `@code-review` - Review code for compliance
- `@test-execution` - Run and manage tests
- `@deployment` - Deploy with validation

### Skill Format

```markdown
# Skill Name

## Description
What this skill does

## When to Use
Usage scenarios

## Resources
Supporting files and templates
```

---

## AGENTS.md

Directory-scoped instructions automatically applied by Cascade:

- **Root AGENTS.md**: Global conventions (this file)
- **C0MMON/AGENTS.md**: Shared library patterns
- **H0UND/AGENTS.md**: Analytics agent guidelines
- **H4ND/AGENTS.md**: Automation agent guidelines

---

## Hooks

Cascade hooks in `.windsurf/hooks/` execute at specific events:

| Event | Trigger |
|-------|---------|
| pre_read_code | Before reading file |
| post_read_code | After reading file |
| pre_write_code | Before writing file |
| post_write_code | After writing file |
| pre_terminal | Before terminal command |
| post_terminal | After terminal command |
| pre_cascade_start | Before Cascade starts |
| post_cascade_end | After Cascade ends |
| on_error | When error occurs |

---

## Context Awareness

### Memories

Auto-generated based on codebase analysis. Persist across conversations.

### Rules

User-defined behavior in `.windsurf/rules/`.

### Fast Context

Instant codebase understanding.

### .codeiumignore

Exclude files from AI context (similar to .gitignore).

---

## Best Practices

1. **Use Code Mode** for implementation (default)
2. **Use Plan Mode** for complex multi-step features
3. **Use Ask Mode** for learning codebase
4. **Create Workflows** for repetitive tasks
5. **Create Skills** for reusable capabilities
6. **Use AGENTS.md** for directory-specific conventions
7. **Review AI suggestions** before accepting
8. **Run tests** after AI-generated changes
9. **Check formatting** with CSharpier
10. **Update Decisions** after implementation

---

## Integration with P4NTHE0N

### Decision Framework

Implement Decisions using workflows:

```
/decision-implementation WIND-001
```

### Testing

Run tests after changes:

```
/run-tests
```

### Deployment

Deploy with validation:

```
/deploy --environment staging
```

---

## MCP Servers

WindSurf uses MCP servers for tool access:

- **toolhive-mcp**: Tool discovery (localhost:22368)
- **mongodb**: Database operations (localhost:27017)

---

## Configuration Files

| File | Purpose |
|------|---------|
| `.windsurf/workflows/*.md` | Workflow definitions |
| `.windsurf/skills/*/SKILL.md` | Skill definitions |
| `.windsurf/hooks/*.sh` | Hook scripts |
| `.windsurf/rules/*.md` | Rule definitions |
| `.windsurf/templates/*.md` | Plan templates |
| `.codeiumignore` | Context exclusion |
| `AGENTS.md` | Directory instructions |

---

## Troubleshooting

### Workflow not found
- Check `.windsurf/workflows/` directory exists
- Verify markdown file format
- Ensure under 12000 characters

### Skill not invoking
- Check SKILL.md exists in skill directory
- Verify description is clear
- Ensure resources are present

### AGENTS.md not applied
- Verify file is named AGENTS.md or agents.md
- Check it's in correct directory
- Reload WindSurf if needed