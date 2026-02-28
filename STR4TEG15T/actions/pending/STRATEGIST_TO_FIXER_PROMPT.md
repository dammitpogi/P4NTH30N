# OpenCode Fixer Activation Prompt

**From**: Strategist
**To**: Fixer (OpenCode)
**Date**: 2026-02-18

---

WindFixer (WindSurf) completed what it could. These Decisions require OpenCode execution.

## What WindFixer Completed

(WindFixer reports what was done in their reply to Strategist)

## What Requires OpenCode Fixer

The following Decision could not be completed by WindFixer and requires OpenCode execution:

### Decision: [DECISION_ID]
**Title**: [Decision Title]
**File**: [Target file path]

**Blocked Because**:
- [Reason WindFixer couldn't complete: e.g., complex, architecture change debugging, etc.]

**Required Action**:
[Specific implementation task]

## Implementation Context

**Project**: P4NTHE0N
**Solution**: P4NTHE0N.slnx
**Test Project**: UNI7T35T

## Verification Commands

```bash
# Build
dotnet build P4NTHE0N.slnx --no-restore

# Format check
dotnet csharpier check

# Unit tests
dotnet test UNI7T35T/UNI7T35T.csproj
```

## Decision Update Required

After completion, update the Decision status in decisions-server:

```javascript
toolhive_call_tool({
  server_name: "decisions-server",
  tool_name: "updateStatus",
  parameters: {
    decisionId: "[DECISION_ID]",
    status: "Completed",
    note: "[What was accomplished]"
  }
})
```

## Report To

When complete, respond to **Strategist** with:
- What was accomplished
- Files modified
- Tests added/updated
- Decision status updated