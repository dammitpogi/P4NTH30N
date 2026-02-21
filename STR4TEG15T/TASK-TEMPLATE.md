# Task Specification for STR4TEG15T\toFixer\

**Place this file in:** `C:\P4NTH30N\STR4TEG15T\toFixer\`

---

## Filename Format

```
TASK-{DecisionId}-{Sequence}.md
```

Examples:
- `TASK-ARCH-004-001.md`
- `TASK-DEPLOY-002-003.md`

---

## Template

```markdown
# Task {TaskId}

**Decision:** {DecisionId}  
**Priority:** Critical/High/Medium/Low  
**Created:** {DateTime}

## Description

Clear description of what needs to be implemented.

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Context

```json
{
  "relatedFiles": ["path/to/file.cs"],
  "dependencies": ["other-task-id"],
  "notes": "Additional context"
}
```

## Files to Create/Modify

- `W1NDF1X3R/Services/...`
- `W1NDF1X3R.Tests/...`

## References

- Decision: `docs/decisions/{DecisionId}.md`
```

---

## Example Task

```markdown
# Task ARCH-004-001

**Decision:** ARCH-004  
**Priority:** High  
**Created:** 2026-02-19 15:30:00

## Description

Implement Windows service manager that can start, stop, and query status of Windows services.

## Acceptance Criteria

- [ ] Can start a service by name
- [ ] Can stop a service by name
- [ ] Can query service status
- [ ] Handles errors gracefully (service not found, access denied)
- [ ] Unit tests for all operations

## Context

```json
{
  "relatedFiles": [],
  "dependencies": [],
  "notes": "Use ServiceController class from System.ServiceProcess"
}
```

## Files to Create/Modify

- `W1NDF1X3R/Services/ServiceManager.cs` (create)
- `W1NDF1X3R/Interfaces/IServiceManager.cs` (create)
- `W1NDF1X3R.Tests/Services/ServiceManagerTests.cs` (create)

## References

- Decision: `docs/decisions/ARCH-004-strategist-agency.md`
```

---

## How It Works

### Two-Folder System

```
C:\P4NTH30N\
├── STR4TEG15T\toFixer\          ← STRATEGIST WRITES HERE
└── W1NDF1X3R\fromFixer\         ← WINDFIXER MOVES HERE
```

### Flow

1. **Strategist** creates task file in `STR4TEG15T\toFixer\`
2. **User** opens WindSurf and runs `/windfixer`
3. **WindFixer** reads **ALL** files from `toFixer\`
4. **WindFixer** moves **ALL** files to `fromFixer\` (archival)
5. **WindFixer** implements solutions
6. **WindFixer** writes completion report to `W1NDF1X3R\COMPLETION-{timestamp}.md`

### Single Command

**No parameters needed.** Just run:

```
/windfixer
```

WindFixer automatically:
- Assimilates all contents from `toFixer\`
- Archives to `fromFixer\`
- Implements solutions
- Reports completion

---

**Place task files in STR4TEG15T\toFixer\ to trigger WindFixer.**
