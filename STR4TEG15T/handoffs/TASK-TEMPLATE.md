# Task Template for Strategist.toFixer/

**Copy this template and fill in details for each task.**

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
- Related: `T4CT1CS/intel/...`
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

1. **Strategist** creates task file in `Strategist.toFixer/`
2. **User** opens WindSurf and runs `/windfixer`
3. **WindFixer** reads task from `Strategist.toFixer/`
4. **WindFixer** moves file to `WindFixer.fromStrategist/` (claims task)
5. **WindFixer** implements solution
6. **WindFixer** writes report to `WindFixer.reports/COMPLETION-*.md`
7. **Strategist** reads report, moves to `Fixer.archive/` when done

---

## Folder Purposes

| Folder | Purpose | Who Writes | Who Reads |
|--------|---------|------------|-----------|
| `Strategist.toFixer/` | Pending tasks | Strategist | WindFixer |
| `WindFixer.fromStrategist/` | Claimed tasks | WindFixer | WindFixer |
| `WindFixer.reports/` | Completion reports | WindFixer | Strategist |
| `Fixer.archive/` | Completed tasks | Strategist | Archive |

---

**Place task files in Strategist.toFixer/ to trigger WindFixer.**
