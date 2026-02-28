# SWE-1.5 Context Management Guidelines
## P4NTHE0N Multi-Agent System

**Decision**: SWE-001  
**Status**: Implemented  
**Date**: 2026-02-18  
**Model**: SWE-1.5 (128K input, 8K output)

---

## 1. Session Chunking

### Turn Limits
- **Soft limit**: 30 turns per session
- **Hard limit**: 50 turns (session reset triggered)
- **Warning threshold**: 25 turns (context compression begins)

### Session Boundary Detection
Sessions should be chunked when:
1. Turn counter reaches soft limit (30)
2. Context window exceeds 90% capacity (~115K tokens)
3. Task domain changes significantly
4. Error rate exceeds threshold (>3 consecutive failures)

### Handoff Procedure
At session boundary:
1. Serialize current state to handoff JSON
2. Summarize completed work (max 2000 chars)
3. List pending items with priority
4. Record file modification history
5. Pass handoff to next session

---

## 2. File Limits

### Per-Session Constraints
| Resource | Recommended | Maximum | Notes |
|----------|-------------|---------|-------|
| Files read | 50 | 75 | Prefer targeted reads over broad scanning |
| Files modified | 15 | 25 | Group related edits |
| New files created | 10 | 20 | Batch creation when possible |
| Lines per file read | 500 | 1000 | Use offset/limit for larger files |

### File Size Guidelines
- **Small files** (<200 lines): Read in full
- **Medium files** (200-500 lines): Read in full, edit targeted sections
- **Large files** (500-1000 lines): Read targeted sections only
- **Very large files** (>1000 lines): Use offset/limit, never read in full

---

## 3. Code Generation Caps

### Per-Response Limits
| Metric | Analysis | Generation | Refactoring |
|--------|----------|------------|-------------|
| Response time | 2-5s | 5-15s | 3-10s |
| Output lines | 50-100 | 200-500 | 100-300 |
| Max output | 500 lines | 3000 lines | 1500 lines |

### Generation Guidelines
- Maximum 800 lines per class file
- Maximum 50 lines per method
- Maximum 3000 lines per response
- Prefer multiple smaller edits over single large writes
- Break large implementations into sequential steps

---

## 4. Context Compression

### When to Compress
- At 25+ turns (warning threshold)
- When context exceeds 80% capacity
- After completing a major subtask
- Before domain switch

### Compression Strategy
1. **Drop stale context**: Remove file contents read >10 turns ago
2. **Summarize tool outputs**: Replace verbose outputs with summaries
3. **Collapse completed items**: Reduce completed task details to one-liners
4. **Preserve active state**: Keep current file contents, pending edits, errors

---

## 5. Performance Degradation Model

### Context Size Impact
| Context Size | Performance Impact | Recommended Action |
|-------------|-------------------|-------------------|
| 0-50K tokens | Baseline | Normal operation |
| 50-75K tokens | ~5% slower | Monitor turn count |
| 75-100K tokens | ~15% slower | Begin compression |
| 100-115K tokens | ~25% slower | Compress aggressively |
| >115K tokens | >30% slower | Force session reset |

### Mitigation Strategies
- Prefer targeted file reads over full reads
- Use search tools to find relevant sections first
- Batch independent operations
- Use todo list for state tracking (survives compression)

---

## 6. Multi-Agent Coordination

### Agent Context Budgets
| Agent | Context Budget | Typical Session |
|-------|---------------|-----------------|
| WindFixer | 128K tokens | 30-50 turns, bulk edits |
| OpenFixer | 128K tokens | 20-30 turns, CLI operations |
| Strategist | 64K tokens | 10-20 turns, planning |
| Oracle | 32K tokens | 5-10 turns, consultation |

### Handoff Format
```json
{
  "sessionId": "uuid",
  "agent": "WindFixer",
  "turnsCompleted": 30,
  "completedTasks": ["TASK-001", "TASK-002"],
  "pendingTasks": ["TASK-003"],
  "modifiedFiles": ["path/to/file.cs"],
  "state": { "key": "value" },
  "summary": "Brief description of session work"
}
```

---

## 7. Error Recovery

### Session Recovery Protocol
1. On crash/timeout: Load last handoff state
2. Verify file system matches expected state
3. Resume from last completed checkpoint
4. Re-read only files actively being modified

### Error Budget
- Maximum 3 consecutive failures before escalation
- Maximum 5 total failures per session
- Circuit breaker: 3 failures → 60s cooldown → retry

---

*SWE-001: Context Management Strategy*  
*Ready for SessionManager.cs implementation*
