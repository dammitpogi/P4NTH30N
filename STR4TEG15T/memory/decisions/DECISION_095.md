---
type: decision
id: DECISION_095
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.749Z'
last_reviewed: '2026-02-23T01:31:15.750Z'
keywords:
  - decision095
  - toolhivenative
  - mongodb
  - hardening
  - with
  - default
  - database
  - resolution
  - executive
  - summary
  - background
  - current
  - state
  - desired
  - specification
  - requirements
  - technical
  - details
  - action
  - items
roles:
  - librarian
  - oracle
summary: >-
  # DECISION_095: ToolHive-Native MongoDB Hardening With Default Database
  Resolution **Decision ID**: INFRA-095 **Category**: INFRA **Status**: Proposed
  **Priority**: High **Date**: 2026-02-22 **Oracle Approval**: 78% (Feasibility
  7/10, Risk 6/10, Complexity 5/10) **Designer Approval**: 84% (Phased
  implementation strategy accepted) --- ## Executive Summary We will harden
  `mongodb-p4nth30n` for ToolHive-native operation by introducing a controlled
  default-database resolution layer
source:
  type: decision
  original_path: >-
    ../../../STR4TEG15T/decisions/active/DECISION_095_MONGODB_TOOLHIVE_HARDENING.md
---

# DECISION_095: ToolHive-Native MongoDB Hardening With Default Database Resolution

**Decision ID**: INFRA-095  
**Category**: INFRA  
**Status**: Proposed  
**Priority**: High  
**Date**: 2026-02-22  
**Oracle Approval**: 78% (Feasibility 7/10, Risk 6/10, Complexity 5/10)  
**Designer Approval**: 84% (Phased implementation strategy accepted)

---

## Executive Summary

We will harden `mongodb-p4nth30n` for ToolHive-native operation by introducing a controlled default-database resolution layer that removes repetitive `database` arguments from common calls while preserving explicit override support and auditability.

This decision keeps compatibility with ToolHive expectations and MongoDB MCP conventions by avoiding an unsafe global implicit context. Instead, we resolve defaults deterministically with a clear precedence model and strict validation.

**Current Problem**:
- Callers repeatedly pass `database: "P4NTHE0N"` in nearly every MongoDB tool call.
- Existing behavior is noisy and error-prone across agents and workflows.
- Prior implementations mixed custom assumptions with ToolHive semantics.

**Proposed Solution**:
- Add default database resolution in the `mongodb-p4nth30n` integration layer.
- Keep explicit per-call database override as highest precedence.
- Return resolved context metadata for traceability.

---

## Background

The current ToolHive MongoDB server model is explicit by default and requires database in most tool schemas. This is robust, but repetitive for single-database operations (`P4NTHE0N`).

Recent remediation stabilized the server by aligning to ToolHive and official MongoDB MCP behavior. The next step is developer-experience hardening without reintroducing hidden context risks.

### Current State
- Official MongoDB MCP server runs in ToolHive.
- Calls require explicit `database` for many operations.
- Tooling and planners spend tokens on repeated boilerplate args.

### Desired State
- Common calls omit `database` safely.
- The resolved database is deterministic, visible, and auditable.
- Explicit override remains available for multi-database cases.

---

## Specification

### Requirements

1. **REQ-095-001: Deterministic database resolution**
   - **Priority**: Must
   - **Acceptance Criteria**:
     - Resolution precedence is enforced as: call arg > tool-specific default > server default.
     - Error is returned when no database can be resolved.

2. **REQ-095-002: ToolHive compatibility first**
   - **Priority**: Must
   - **Acceptance Criteria**:
     - No fork of ToolHive protocol behavior.
     - Uses ToolHive-supported env/config semantics.

3. **REQ-095-003: Audit visibility**
   - **Priority**: Must
   - **Acceptance Criteria**:
     - Responses include resolved context metadata (`database`, `collection`, tool id).

4. **REQ-095-004: Safe multi-database override**
   - **Priority**: Should
   - **Acceptance Criteria**:
     - Per-call `database` override is always honored.
     - Optional allowlist can restrict unexpected target databases.

### Technical Details

- Introduce a wrapper/integration layer in `mcp-p4nthon` to inject defaults when absent.
- Resolve from configuration first, then environment, with explicit precedence.
- Keep upstream ToolHive MongoDB MCP contract intact at transport/tool schema boundary.

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-095-001 | Implement config loader for default database resolution | OpenFixer | Pending | High |
| ACT-095-002 | Implement parameter injection middleware with precedence rules | OpenFixer | Pending | High |
| ACT-095-003 | Add resolved-context metadata to responses | OpenFixer | Pending | Medium |
| ACT-095-004 | Add migration helper for legacy explicit calls | OpenFixer | Pending | Medium |
| ACT-095-005 | Validate against ToolHive MCP tooling and docs behavior | Oracle + Designer | Pending | High |

---

## Dependencies

- **Blocks**: Future ToolHive MongoDB ergonomics decisions
- **Blocked By**: None
- **Related**: DECISION_092, DECISION_093, DECISION_094

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Hidden writes to wrong DB via implicit defaults | High | Medium | Deterministic precedence + explicit error on unresolved DB + optional allowlist |
| Cache/stale server tool metadata in ToolHive ecosystem | Medium | Medium | Add restart/refresh verification in validation plan |
| Migration confusion between explicit and implicit calls | Medium | Medium | Keep explicit override support and publish migration helper |

---

## Success Criteria

1. Common MongoDB calls execute without explicit `database` argument in primary workflows.
2. Explicit `database` override still works for multi-database operations.
3. Validation confirms ToolHive compatibility and no regression in existing automation.

---

## Token Budget

- **Estimated**: 30K tokens
- **Model**: Claude 3.5 Sonnet (OpenFixer)
- **Budget Category**: Routine (<50K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On config error**: Delegate to @openfixer
- **On verification failure**: revert to explicit-db mode and re-run validation
- **Escalation threshold**: 30 minutes blocked -> auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Oracle | Validation sub-decisions | Medium | No |
| Designer | Architecture sub-decisions | Medium | No |
| WindFixer | Implementation sub-decisions | High | Yes (Strategist) |
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Bug-fix sub-decisions | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-22
- **Approval**: 78%
- **Key Findings**:
  - Safe if explicit override semantics remain highest precedence.
  - Require structured errors when default DB is unresolved.
  - Include resolved context in responses for auditability.

### Designer Consultation
- **Date**: 2026-02-22
- **Approval**: 84%
- **Key Findings**:
  - Use phased rollout with config loader + middleware injection.
  - Keep ToolHive protocol semantics unchanged.
  - Add migration helper and backward compatibility path.

---

## Notes

This decision intentionally avoids hidden global mutable session state. The implementation target is predictable defaulting, not implicit magic.

---

*Decision INFRA-095*  
*ToolHive-Native MongoDB Hardening With Default Database Resolution*  
*2026-02-22*
