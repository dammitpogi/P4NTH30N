---
type: task
id: TASK_002
decision: DECISION_168
category: Skill Configuration
priority: Critical
---

# TASK: Reconfigure Skills for ALMA Documentation Access

## Objective

Reconfigure the `update-agent-models` skill (copied from ALMA's working directory) to properly reference the gathered documentation at `C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\documentation\`.

## Background

The skill was copied from ALMA's working directory but paths and references need to be updated to point to the correct documentation location for the QMD deployment.

## Skill Location

Source: `C:\Users\paulc\.config\opencode\skills\update-agent-models\`

## Required Changes

### 1. Update Documentation References

**File**: `SKILL.md` (or main skill file)

Find references like:
```
../../openclaw/docs/concepts/memory.md
```

Replace with:
```
C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\documentation\openclaw\concepts\memory.md
```

### 2. Update Path Constants

**If skill has path configuration**:
```javascript
// OLD
const DOCS_PATH = "../../openclaw/docs";

// NEW
const DOCS_PATH = "C:\\P4NTH30N\\OP3NF1XER\\nate-alma\\dev\\memory\\documentation\\openclaw";
```

### 3. Add ALMA-Specific Context

**Add section to skill documentation**:
```markdown
## ALMA Deployment Context

This skill is configured for ALMA (Nate's OpenClaw agent) deployment.
Documentation root: `C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\documentation\`

### Critical References
- QMD Configuration: `documentation/openclaw/concepts/memory.md`
- Ollama Setup: `documentation/openclaw/providers/ollama.md`
- Deployment History: `documentation/deployment/historical/`
```

### 4. Update Model Selection Algorithm

**File**: `bench_calc.json` (if exists)

Ensure the algorithm references are updated to use local documentation for model selection decisions.

## Verification Steps

1. Read current skill configuration
2. Identify all path references
3. Update to absolute paths
4. Add ALMA context section
5. Test skill loads without errors

## Files to Modify

- `C:\Users\paulc\.config\opencode\skills\update-agent-models\SKILL.md`
- `C:\Users\paulc\.config\opencode\skills\update-agent-models\codemap.md` (if exists)
- Any configuration JSON files

## Success Criteria

- [ ] All relative paths updated to absolute
- [ ] ALMA context section added
- [ ] Skill loads without path errors
- [ ] Documentation references resolve correctly
