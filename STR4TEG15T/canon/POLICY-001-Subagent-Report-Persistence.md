# STR4TEG15T Policy: Subagent Report Persistence

**Policy ID**: POLICY-001  
**Category**: Process  
**Status**: Active  
**Date**: 2026-02-20  
**Authority**: Strategist (Atlas)

---

## Policy Statement

All subagent consultation reports MUST be persisted as verbatim files to ensure provenance security and maintain lineage. Subagent responses delivered via task results are ephemeral and subject to loss. File-based persistence guarantees:

1. **Provenance**: Immutable record of who said what, when
2. **Lineage**: Complete audit trail from decision to consultation to implementation
3. **Recoverability**: Reports survive session interruptions, tool failures, or context loss
4. **Verification**: Future audits can verify consultation content against decisions

---

## Requirements

### 1. Mandatory File Creation

When a subagent provides a consultation report, the Strategist MUST:

1. Create a verbatim file at: `STR4TEG15T/consultations/{agent-type}/DECISION_{NNN}_{agent-type}.md`
2. Copy the subagent's response content EXACTLY as provided
3. Do NOT summarize, paraphrase, or edit the subagent's findings
4. Include metadata header with task ID, timestamp, and agent name

### 2. File Structure

```markdown
# {Agent} Consultation: DECISION_{NNN}

**Decision ID**: {CATEGORY}-{NNN}  
**Agent**: {oracle|designer|explorer|librarian}  
**Task ID**: {task_id from Task tool}  
**Date**: {YYYY-MM-DD HH:MM:SS}  
**Status**: {Complete|Partial|Failed}

---

## Original Response

{VERBATIM subagent response content}

---

## Metadata

- **Input Prompt**: {summary of what was asked}
- **Response Length**: {character count}
- **Key Findings**: {bullet list for quick reference}
- **Approval Rating**: {if provided}
- **Files Referenced**: {any files mentioned}
```

### 3. Decision File Updates

After persisting the consultation file, update the decision's Consultation Log section:

```markdown
### {Agent} Consultation
- **Date**: {YYYY-MM-DD}
- **Approval**: {X}% (or "Pending" if not provided)
- **Key Findings**: {3-5 bullet summary}
- **File**: consultations/{agent}/DECISION_{NNN}_{agent}.md
```

### 4. Exception Handling

If a subagent task fails or returns incomplete results:

1. **Document the failure** in the consultation file
2. **Assimilate the role** if the agent is unavailable (per Strategist instructions)
3. **Record the assimilation** explicitly: "Oracle Approval: X% (Strategist Assimilated)"
4. **Preserve partial results** if any were returned before failure

---

## Rationale

### Why Verbatim?

- **Legal/Compliance**: Some decisions may require audit trails
- **Knowledge Preservation**: Subagent insights are valuable organizational knowledge
- **Debugging**: If implementation diverges from consultation, we need the original reference
- **Learning**: Future strategists can learn from past consultation patterns

### Why Files?

- **Durability**: Files persist across sessions; task results do not
- **Searchability**: Can grep across consultation history
- **Version Control**: Git tracks changes to consultation files
- **Accessibility**: Any agent can read files; task results are ephemeral

---

## Examples

### Example 1: Successful Oracle Consultation

```markdown
# Oracle Consultation: DECISION_035

**Decision ID**: TEST-035  
**Agent**: Oracle  
**Task ID**: ses_385650e30ffeghbhZ32HKPhx5s  
**Date**: 2026-02-20 14:32:15  
**Status**: Complete

---

## Original Response

Approval Rating: 88%
Feasibility Score: 8/10
Risk Score: 4/10
...
[full verbatim response]
```

### Example 2: Failed Task with Assimilation

```markdown
# Oracle Consultation: DECISION_037

**Decision ID**: INFRA-037  
**Agent**: Oracle  
**Task ID**: ses_3855f3ad9ffe75H9TMCS62PfmP  
**Date**: 2026-02-20 14:45:22  
**Status**: Failed - Strategist Assimilated

---

## Original Response

[TASK FAILED - No response received]

---

## Assimilated Analysis

**Strategist (Atlas) Assimilated Oracle Role:**

- Approval Rating: 92%
- Feasibility Score: 9/10
- Risk Score: 3/10
- [full assimilated analysis]
```

---

## Compliance Checklist

Before marking any decision as "Approved", verify:

- [ ] All requested subagent consultations have corresponding files
- [ ] File content is verbatim (no editing)
- [ ] File path follows naming convention
- [ ] Decision's Consultation Log references the file
- [ ] Metadata header is complete

---

*Policy POLICY-001*  
*Subagent Report Persistence*  
*2026-02-20*
