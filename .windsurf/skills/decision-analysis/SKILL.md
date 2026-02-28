---
name: decision-analysis
description: Analyze a Decision from the P4NTH30N decision framework. Query specifications, assess complexity, identify dependencies, and provide implementation recommendations. Use before implementing a Decision, evaluating Decision priority, complexity estimation, or identifying potential blockers.
---

# Decision Analysis

## Description
Analyze a Decision from the P4NTH30N decision framework. Query specifications, assess complexity, identify dependencies, and provide implementation recommendations.

## When to Use
- Before implementing a Decision
- When evaluating Decision priority
- For complexity estimation
- To identify potential blockers

## Usage

```markdown
@decision-analysis
Decision: WIND-001
```

Or ask Cascade:
"Analyze Decision WIND-001 for me"

## Resources

This skill includes:
- Decision query templates
- Complexity scoring rubric
- Dependency mapping guide
- Implementation checklist

## Output

Provides:
1. Decision summary (title, description, priority)
2. Complexity assessment (Simple/Medium/Complex)
3. Dependency status (complete/incomplete)
4. Implementation recommendations
5. Estimated effort and cost
6. Risk assessment

## Example

```
Decision: WIND-004 (WindFixerCheckpointManager)
Priority: Critical
Complexity: Complex (3 points)
Dependencies: WIND-001, WIND-002, WIND-003 [INCOMPLETE]

Recommendations:
- Complete WIND-001, WIND-002, WIND-003 first
- Use hybrid storage (File + MongoDB)
- Implement file locking for concurrency

Estimated: 2-3 days, ~$1.20 cost
```