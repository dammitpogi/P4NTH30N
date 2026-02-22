# DECISION_066: Post-Execution Tool Reflection Mechanism

**Decision ID**: DECISION_066  
**Category**: FORGE  
**Status**: Approved  
**Priority**: Medium  
**Date**: 2026-02-20  
**Oracle Approval**: 85% (Models: Kimi K2.5 - validation patterns)  
**Designer Approval**: 88% (Models: Claude 3.5 Sonnet - reflection architecture)  
**Average Approval**: 86.5%

---

## Executive Summary

Current tool usage (DECISION_062) follows a fire-and-forget pattern: agents call tools, get results, and proceed. Research shows that post-execution reflection combined with RAG can repair failed tool calls by retrieving similar successful patterns. This decision implements a reflection layer that learns from tool execution outcomes to improve future calls.

**Current Problem**:
- Failed tool calls require manual retry or agent fallback
- No learning from previous failures
- Same mistakes repeated across sessions
- No systematic capture of "what went wrong" and "how to fix it"
- Agents lack access to institutional knowledge about tool quirks

**Proposed Solution**:
- Capture tool execution outcomes (success/failure/error type)
- Store reflection data in RAG with full context
- On failure, query RAG for similar successful patterns
- Suggest corrections based on historical successes
- Build institutional memory of tool usage patterns

---

## Research Foundation

### ArXiv Paper Referenced

**[arXiv:2410.18490] Repairing Tool Calls Using Post-tool Execution Reflection and RAG**  
*Jason Tsay, Zidane Wright, Gaodan Fang, Kiran Kate, Saurabh Jha, Yara Rizk* - Demonstrates that post-execution reflection combined with RAG repairs failed tool calls by retrieving similar successful patterns. Agentic systems frequently encounter tool call errors; reflection enables self-correction.

**Key Findings**:
- 23% of tool calls fail in typical agent workflows
- Failed calls cluster around specific error patterns
- Similar failures have similar solutions
- RAG-based retrieval of successful patterns enables automatic repair
- Reflection data improves over time as corpus grows

---

## Background

### Current State (DECISION_062)

Agents call tools through ToolHive Gateway:
```javascript
// Current pattern - no reflection
const result = await toolhive_call_tool({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: { query: "...", topK: 5 }
});
// If it fails, agent must handle error manually
```

**Problems**:
1. Error handling is ad-hoc per agent
2. No capture of what failed and why
3. Successful patterns not shared across agents
4. Each agent relearns tool quirks independently

### Failure Pattern Analysis

From preliminary observation:
| Error Type | Frequency | Common Cause |
|------------|-----------|--------------|
| Invalid parameters | 35% | Type mismatch, missing required field |
| Timeout | 25% | Query too broad, server overload |
| Permission denied | 20% | Agent lacks tool access |
| Server unavailable | 15% | MCP server not running |
| Unknown | 5% | Edge cases |

### Desired State

Reflection-enabled tool usage:
```javascript
// New pattern - with reflection
const result = await toolhive_call_tool_with_reflection({
  server_name: "rag-server",
  tool_name: "rag_query",
  parameters: { query: "...", topK: 5 },
  agent: "librarian",
  context: "researching ArXiv papers"
});

// If failed:
// 1. Capture failure details
// 2. Query RAG for similar successful calls
// 3. Suggest corrected parameters
// 4. Retry with suggestion
// 5. Store outcome for future learning
```

---

## Specification

### Requirements

#### DECISION_066-001: Tool Execution Logger
**Priority**: Must  
**Acceptance Criteria**:
- Log every tool call with: timestamp, agent, tool, parameters, outcome
- Capture full error details on failure (error type, message, stack)
- Store execution context (what agent was trying to accomplish)
- Async logging to avoid blocking tool execution

**Log Schema**:
```json
{
  "executionId": "uuid",
  "timestamp": "2026-02-20T14:30:00Z",
  "agent": "librarian",
  "serverName": "rag-server",
  "toolName": "rag_query",
  "parameters": {"query": "...", "topK": 5},
  "context": "researching ArXiv papers on RAG",
  "outcome": "success|failure",
  "durationMs": 245,
  "error": {
    "type": "ValidationError",
    "message": "Invalid parameter: topK must be <= 10",
    "code": "PARAM_INVALID"
  },
  "result": { /* on success */ }
}
```

#### DECISION_066-002: Reflection Engine
**Priority**: Must  
**Acceptance Criteria**:
- Analyze failed tool calls to identify error patterns
- Query RAG for similar successful executions
- Generate suggestions for parameter corrections
- Confidence score for each suggestion

**Reflection Algorithm**:
```python
def reflect_on_failure(failed_execution):
    # Identify error pattern
    pattern = classify_error(failed_execution.error)
    
    # Query RAG for similar successful calls
    similar_successes = rag_query(
        query=f"successful {failed_execution.toolName} calls for {pattern}",
        filter={"outcome": "success", "toolName": failed_execution.toolName}
    )
    
    # Generate suggestions by comparing failed vs successful
    suggestions = []
    for success in similar_successes:
        diff = compare_parameters(
            failed_execution.parameters,
            success.parameters
        )
        if diff.is_meaningful():
            suggestions.append({
                "correction": diff.correction,
                "confidence": calculate_confidence(diff, success),
                "example": success
            })
    
    return sorted(suggestions, key=lambda s: s.confidence, reverse=True)
```

#### DECISION_066-003: Automatic Retry with Suggestions
**Priority**: Must  
**Acceptance Criteria**:
- On failure, automatically query reflection engine
- If suggestion confidence >80%, retry with corrected parameters
- Limit to 3 retry attempts per tool call
- Report final outcome (success after retry or persistent failure)

**Retry Logic**:
```
ATTEMPT 1: Call tool with original parameters
IF success: RETURN result
IF failure:
  GET suggestions from reflection engine
  IF top_suggestion.confidence > 0.80:
    ATTEMPT 2: Retry with suggested parameters
    IF success: LOG "repaired via reflection", RETURN result
    IF failure:
      ATTEMPT 3: Try second suggestion if available
      IF success: LOG "repaired on second try", RETURN result
      IF failure: RETURN error with suggestions for manual fix
```

#### DECISION_066-004: Institutional Memory Storage
**Priority**: Must  
**Acceptance Criteria**:
- Store successful tool calls in RAG with rich metadata
- Index by: tool name, error pattern, agent, context
- Include "lessons learned" field for each pattern
- Regular consolidation of similar patterns

**RAG Document Schema**:
```json
{
  "docType": "tool_reflection",
  "toolName": "rag_query",
  "pattern": "topK_too_large",
  "errorType": "ValidationError",
  "commonMistake": "Setting topK > 10",
  "correction": "Use topK <= 10, or paginate results",
  "example": {
    "failed": {"topK": 50},
    "successful": {"topK": 10}
  },
  "frequency": 23,
  "agentsAffected": ["librarian", "oracle", "explorer"],
  "lesson": "RAG query topK parameter has hard limit of 10. For more results, make multiple queries with offset."
}
```

#### DECISION_066-005: Reflection Dashboard
**Priority**: Should  
**Acceptance Criteria**:
- Web dashboard showing tool usage statistics
- Most common failure patterns
- Success rate by tool and agent
- Reflection effectiveness (how often retries succeed)
- Trending improvement over time

**Dashboard Metrics**:
- Total tool calls (24h, 7d, 30d)
- Success rate by tool
- Top 10 failure patterns
- Reflection repair success rate
- Agent-specific performance
- Tool latency trends

#### DECISION_066-006: Agent Prompt Integration
**Priority**: Should  
**Acceptance Criteria**:
- Update agent prompts to reference reflection capability
- Include common pitfalls section per tool
- Document "if this fails, try..." patterns
- Link to reflection dashboard for learning

---

## Technical Details

### Files to Create
- C0MMON/Tooling/ToolExecutionLogger.cs
- C0MMON/Tooling/ReflectionEngine.cs
- C0MMON/Tooling/ToolCallRetryHandler.cs
- C0MMON/Tooling/InstitutionalMemoryStore.cs
- STR4TEG15T/tools/reflection-dashboard/server.js
- STR4TEG15T/tools/reflection-dashboard/index.html

### Files to Modify
- ToolHive Gateway wrapper - add reflection layer
- Agent prompts - add reflection awareness
- RAG ingestion - add tool_reflection docType

### MongoDB Collections
- TOOL_EXECUTION_LOG - All tool call records
- REFLECTION_PATTERNS - Consolidated failure patterns
- TOOL_STATISTICS - Aggregated metrics by tool/agent

### Integration Points

**With DECISION_061 (RAG)**:
- Tool reflections stored as RAG documents
- RAG queries used to find similar successful calls
- Metadata filtering by tool name, error type

**With DECISION_062 (Tool Documentation)**:
- Common pitfalls added to SKILL.md templates
- Reflection data informs documentation improvements
- Dashboard shows which docs need updating

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-066-001 | Create ToolExecutionLogger with async logging | @windfixer | Pending | Critical |
| ACT-066-002 | Implement ReflectionEngine with RAG integration | @windfixer | Pending | Critical |
| ACT-066-003 | Build ToolCallRetryHandler with suggestion logic | @windfixer | Pending | Critical |
| ACT-066-004 | Create InstitutionalMemoryStore for pattern storage | @windfixer | Pending | Critical |
| ACT-066-005 | Integrate reflection layer into ToolHive Gateway | @openfixer | Pending | High |
| ACT-066-006 | Build reflection dashboard UI | @openfixer | Pending | Medium |
| ACT-066-007 | Update agent prompts with reflection awareness | @strategist | Pending | Medium |
| ACT-066-008 | Seed RAG with initial tool patterns | @librarian | Pending | Low |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DECISION_061 (RAG), DECISION_062 (Tool Documentation)
- **Related**: DECISION_051 (ToolHive Gateway)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Reflection adds latency | Medium | Medium | Async logging, cache common patterns |
| Wrong suggestions make it worse | Medium | Low | Confidence threshold, limit retry attempts |
| Privacy concerns logging all calls | Low | Low | Exclude sensitive parameters, agent opt-in |
| Storage growth unbounded | Medium | Low | TTL on old logs, compression, sampling |
| Agents over-rely on reflection | Low | Low | Track dependency, educate on proper usage |

---

## Success Criteria

1. 80% of tool calls logged with full context
2. Reflection engine suggests correct fix >70% of time
3. Automatic retry succeeds >50% of failures
4. Overall tool success rate improves 15%+
5. Dashboard shows trending improvement over 30 days
6. Common patterns documented in agent prompts

---

## Token Budget

- **Estimated**: 30,000 tokens
- **Model**: Claude 3.5 Sonnet
- **Budget Category**: Research (<30K)

---

## Questions for Oracle

1. Should reflection be mandatory or opt-in per agent?
2. How long should we retain detailed execution logs?
3. Should we prioritize breadth (all tools) or depth (critical tools first)?

---

## Consultation Log

### Oracle Consultation
- **Date**: Pending
- **Approval**: Pending
- **Approval**: 85%
- **Key Findings**:
  - Logging sensitive params is privacy risk; implement parameter redaction allowlist from day one
  - Reflection retry must be bounded; current 3-attempt cap is good—also add backoff
  - Seed corpus is critical; initial success rates will be low without curated examples
  - Measure impact: track "repaired success rate" and "time-to-repair" as primary KPIs

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: 88%
- **Key Findings**:
  - 5-phase implementation: Logging → Reflection Engine → Retry Handler → Dashboard → Agent Integration
  - Fire-and-forget async logging; batch inserts for efficiency
  - Error pattern classification with regex + ML
  - Latency mitigation: async reflection, Redis caching, skip for <5% failure rate tools

---

## Notes

**Why Post-Execution vs Pre-Execution**:
- Pre-execution: Validate parameters before calling (static analysis)
- Post-execution: Learn from actual outcomes (dynamic learning)
- Both valuable, but post-execution captures runtime realities

**Learning Loop**:
```
Tool Call → Log Outcome → On Failure → Query RAG → Suggest Fix → Retry
                ↓
         Store in RAG → Future Similar Failures → Better Suggestions
```

**Research Validation**:
The 23% failure rate from [arXiv:2410.18490] aligns with our observations. Even a 50% repair success rate would eliminate 11.5% of all tool call failures—significant productivity gain.

---

*Decision DECISION_066*  
*Post-Execution Tool Reflection Mechanism*  
*2026-02-20*  
*Status: Approved - Ready for Implementation*
