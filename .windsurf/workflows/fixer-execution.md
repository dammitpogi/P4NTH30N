# Fixer Execution

## Description
Execute a Fixer workflow for autonomous Decision implementation. Load tasks, execute in order, track progress, handle failures.

## Steps

1. **Initialize Fixer Session**
   - Load checkpoint from .windfixer-checkpoint.json
   - Determine starting point from last successful Decision
   - Initialize cost tracking

2. **Load Task Queue**
   - Query decisions-server for pending tasks
   - Filter by priority (Critical first)
   - Check dependencies for each task

3. **Execute Tasks**
   For each Decision:
   - Estimate complexity (Simple/Medium/Complex)
   - Select appropriate model (Opus 4.6 → 4.0 → Sonnet → Haiku)
   - Execute implementation
   - Run verification (build + test)
   - Update Decision status
   - Save checkpoint
   - Track costs

4. **Failure Handling**
   - Compile Error: Retry 1x, then SKIP
   - Test Failure: Retry 1x, then SKIP + FLAG
   - Runtime Error: SKIP + LOG + ALERT
   - 3 consecutive failures: Skip, log, continue
   - 5 failures (10%): PAUSE, notify Nexus
   - 10 failures (50%): HALT, require intervention

5. **Completion Report**
   - Generate summary of completed Decisions
   - Report skipped/failed Decisions
   - Total cost incurred
   - Recommendations for next session

## Example Invocation
```
/fixer-execution --phase 1
/fixer-execution --decision WIND-001
```

## Constraints
- Max $2.00 per Decision
- Max 10 minutes per Decision
- Session budget: $15.00
- Always save checkpoint after each Decision