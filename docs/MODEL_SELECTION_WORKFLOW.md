# Model Selection Workflow
## SWE-1.5 vs Opus 4.6 Thinking - Cost-Optimized Routing

**Decision**: BENCH-002  
**Status**: Completed  
**Date**: 2026-02-18

---

## 1. Model Selection Flowchart

```
                    ┌─────────────────┐
                    │   New Task       │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Classify Task   │
                    │ Complexity      │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
     ┌────────▼──────┐ ┌────▼─────┐ ┌─────▼───────┐
     │ Simple        │ │ Medium   │ │ Complex     │
     │ (<10 files)   │ │ (10-30)  │ │ (30+ files) │
     └────────┬──────┘ └────┬─────┘ └─────┬───────┘
              │              │              │
     ┌────────▼──────┐ ┌────▼─────┐ ┌─────▼───────┐
     │ SWE-1.5       │ │ SWE-1.5  │ │ Opus 4.6    │
     │ $0.003/turn   │ │ $0.003   │ │ $0.015/turn │
     └────────┬──────┘ └────┬─────┘ └─────┬───────┘
              │              │              │
              │         ┌────▼─────┐        │
              │         │ Quality  │        │
              │         │ Check    │        │
              │         └────┬─────┘        │
              │              │              │
              │    Pass ┌────┴────┐ Fail    │
              │         │        ├──────────┘
              │         │        │ Escalate to
              │         │        │ Opus 4.6
              ▼         ▼        ▼
         ┌──────────────────────────┐
         │      Complete Task       │
         │      Track Cost          │
         └──────────────────────────┘
```

## 2. Escalation Criteria

### Automatic Escalation to Opus 4.6
- Task involves >30 files
- Architecture decisions required
- Oracle consultation needed
- Quality check fails on SWE-1.5 output
- 3+ retry attempts on SWE-1.5

### Stay on SWE-1.5
- Bulk file edits (same pattern)
- Documentation generation
- Test creation
- Simple refactoring (<10 files)
- Code formatting/linting

## 3. Cost Tracking

### Per-Model Costs
| Model | Cost/Turn | Avg Turns/Task | Cost/Task |
|-------|-----------|----------------|-----------|
| SWE-1.5 | $0.003 | 15 | $0.045 |
| Opus 4.6 | $0.015 | 10 | $0.150 |

### Cost Savings Formula
```
Savings = (OpusTasks × OpusCost) - (SWETasks × SWECost + EscalatedTasks × OpusCost)
```

### Target Distribution
- **80%** tasks on SWE-1.5 (bulk operations)
- **15%** tasks on Opus 4.6 (complex reasoning)
- **5%** escalated from SWE-1.5 to Opus 4.6

### Monthly Cost Projection
| Scenario | Tasks/Month | SWE-1.5 | Opus 4.6 | Total |
|----------|-------------|---------|----------|-------|
| Low | 100 | $3.60 | $2.25 | $5.85 |
| Medium | 300 | $10.80 | $6.75 | $17.55 |
| High | 500 | $18.00 | $11.25 | $29.25 |
| All-Opus (baseline) | 300 | $0 | $45.00 | $45.00 |

**Savings at medium volume: ~61%** ($45.00 → $17.55)

## 4. Quality Validation Checklist

### SWE-1.5 Output Validation
- [ ] Code compiles without errors
- [ ] All existing tests still pass
- [ ] New code follows P4NTHE0N style (CSharpier check)
- [ ] No regressions in functionality
- [ ] File count within session limits

### Escalation Triggers
- [ ] Compilation error after 2 attempts
- [ ] Test failure after fix attempt
- [ ] Task requires cross-project reasoning
- [ ] Architecture decision needed
- [ ] Security-sensitive changes

## 5. SWE-1.5 Prompt Templates

### Bulk Edit Template
```
Execute the following changes across {N} files:
Pattern: {description}
Files: {file_list}
Change: {old_pattern} → {new_pattern}
Constraints: No functional changes, preserve tests
```

### Documentation Template
```
Generate documentation for:
Component: {component_name}
Files: {source_files}
Format: XML doc comments + README
Style: P4NTHE0N standards (see AGENTS.md)
```

### Test Generation Template
```
Create unit tests for:
Class: {class_name}
Methods: {method_list}
Framework: xUnit
Mocks: {mock_requirements}
Coverage target: >90%
```

## 6. Opus 4.6 Escalation Triggers

### Complexity Indicators
- Cyclomatic complexity >20
- Cross-project dependencies >3
- File count >30
- Architecture decision required
- Oracle consultation needed
- Security review required

### Performance Indicators
- SWE-1.5 context usage >90%
- Response degradation >25%
- Error rate >10%
- 3+ consecutive failures

## 7. Cost Tracking Dashboard

### Metrics Collected
- `model_usage_count{model="swe15|opus46"}` — Tasks per model
- `model_cost_total{model="swe15|opus46"}` — Cumulative cost
- `model_escalation_count` — SWE→Opus escalations
- `model_quality_score{model="swe15|opus46"}` — Quality ratings
- `model_turns_per_task{model="swe15|opus46"}` — Efficiency metric

### Dashboard Panels (Grafana)
1. **Model Usage Split** — Pie chart of SWE-1.5 vs Opus 4.6 usage
2. **Cost Over Time** — Line chart of daily/weekly costs
3. **Escalation Rate** — Gauge showing % of tasks escalated
4. **Quality Comparison** — Bar chart comparing quality scores
5. **Savings Calculator** — Stat panel showing actual vs baseline cost

---

*BENCH-002: Model Selection Workflow - Complete*  
*Cost tracking dashboard metrics defined for Grafana integration*
