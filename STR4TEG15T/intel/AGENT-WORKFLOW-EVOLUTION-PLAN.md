# P4NTHE0N Agent Workflow Evolution Plan

**Date:** 2026-02-18
**Status:** ORACLE CONSULTATION COMPLETE

---

## Executive Summary

Created 4 strategic decisions to evolve agent workflows with Explorer and Librarian integration. Oracle consultations revealed delegation rule constraints that must be resolved before implementation.

---

## Decisions Created

### STRATEGY-007: Explorer-Enhanced Investigation Workflows
- **Oracle Approval:** 45% (REJECTED)
- **Blockers:**
  - Designer cannot delegate to Explorer (current rules: designer→oracle only)
  - Strategist delegation rules undefined
  - Oracle already has glob/grep - delegation adds complexity without clear benefit
- **Required Actions:** Update delegation rules, define investigation schemas

### STRATEGY-008: Librarian-Enhanced Documentation Workflows
- **Oracle Approval:** 41% (REJECTED)
- **Blockers:**
  - Oracle and Designer cannot delegate to Librarian under current rules
  - Permission escalation risk
  - Performance overhead concerns
- **Required Actions:** Update opencode.json permissions, add throttling rules

### STRATEGY-009: Parallel Agent Delegation Framework
- **Oracle Approval:** 47% (REJECTED)
- **Blockers:**
  - Context fragmentation risk
  - No standardized synthesis protocols
  - Attempts too much in single iteration
- **Required Actions:** Split into phased approach (Phase 1: documentation only)

### STRATEGY-011: Delegation Rule Updates (NEW - Critical)
- **Priority:** Critical
- **Purpose:** Update src/config/constants.ts to enable Explorer/Librarian access
- **Required Changes:**
  - Add explorer to designer permissions
  - Add librarian to designer permissions
  - Define strategist delegation permissions

---

## Oracle's Key Findings

### Current Delegation Permissions

| Agent | Can Delegate To | Blocked From |
|-------|----------------|--------------|
| Orchestrator | All agents | - |
| Oracle | Explorer | Librarian |
| Designer | Oracle | Explorer, Librarian |
| Explorer | None | All |
| Librarian | Explorer | Most |
| Fixer | Explorer, Librarian | - |

### Critical Issues

1. **Designer is isolated** - Can only delegate to Oracle, blocking Explorer/Librarian workflows
2. **Strategist rules undefined** - No clear delegation permissions documented
3. **Oracle has redundancy** - Already has glob/grep, Explorer delegation adds overhead
4. **Permission changes are high-risk** - Could break established workflows

---

## Recommended Path Forward

### Phase 1: Foundation (Critical)
1. **Execute STRATEGY-011** - Update delegation rules in src/config/constants.ts
2. **Test permission changes** - Verify Designer→Explorer, Designer→Librarian works
3. **Document new rules** - Update AGENTS.md with delegation capabilities

### Phase 2: Pilot (High Priority)
1. **Select one agent** for Explorer/Librarian integration (recommend Oracle)
2. **Create minimal delegation guide** - Basic patterns only
3. **Measure performance** - Benchmark direct vs delegated investigation
4. **Iterate based on results**

### Phase 3: Rollout (Medium Priority)
1. **Expand to additional agents** based on pilot success
2. **Create comprehensive guides** - Full patterns and schemas
3. **Establish synthesis protocols** - Standardize result merging
4. **Update all workflows**

---

## Immediate Actions

### For Nexus
1. **Approve STRATEGY-011** - Delegation rule updates are prerequisite
2. **Execute via Fixer** - Update src/config/constants.ts
3. **Test delegation** - Verify Designer can now call Explorer and Librarian

### For Strategist (Me)
1. **Refine STRATEGY-007** - Narrow scope to Oracle-only initially
2. **Refine STRATEGY-008** - Phase 1: documentation only
3. **Refine STRATEGY-009** - Remove orchestrator updates from initial scope
4. **Create pilot plan** - Single-agent proof of concept

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Permission escalation | Add only Explorer/Librarian to Designer, not other agents |
| Performance overhead | Benchmark before/after, rollback if >20% slower |
| Context fragmentation | Require explicit dependency declarations |
| Error propagation | Add timeout/cooldown mechanisms |

---

## Success Criteria

- Designer can successfully delegate to Explorer and Librarian
- Investigation tasks complete in <120% of direct tool time
- No agent workflow regressions
- Clear documentation exists for delegation patterns

---

**Next Step:** Execute STRATEGY-011 to unblock workflow evolution.
