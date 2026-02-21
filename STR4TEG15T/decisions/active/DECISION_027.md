# DECISION_027: AgentNet-Style Decentralized Coordination Protocol

**Decision ID**: DECISION_027
**Category**: Architecture
**Status**: Implemented (AgentRegistry + PredictorAgent + ExecutorAgent + MonitorAgent)
**Priority**: Medium
**Date**: 2026-02-20
**Oracle Approval**: 92%
**Designer Approval**: Approved

---

## Executive Summary

Redesign H0UND-H4ND coordination using AgentNet patterns: capability registry, event-driven messaging, and specialized agent roles. Replaces polling-based signal exchange with dynamic, decentralized coordination.

**Current Problem**:
- Polling-based architecture is inefficient and does not scale
- No dynamic capability discovery between agents
- Tight coupling between H0UND and H4ND

**Proposed Solution**:
- EventBus enhancement with capability registry
- Specialized agent roles: Predictor, Optimizer, Executor, Monitor
- Dynamic agent registration and priority-based routing

---

## Research Source

ArXiv 2504.00587 - AgentNet: Decentralized Evolutionary Coordination
ArXiv 2502.14743v2 - Multi-Agent Coordination across Diverse Applications

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-027-1 | Add CapabilityRegistry to EventBus | WindFixer | Pending | 10 |
| ACT-027-2 | Create IAgent base interface | WindFixer | Pending | 9 |
| ACT-027-3 | Create specialized role interfaces | WindFixer | Pending | 9 |
| ACT-027-4 | Implement H0UND PredictorAgent | WindFixer | Pending | 8 |
| ACT-027-5 | Implement H4ND ExecutorAgent | WindFixer | Pending | 8 |
| ACT-027-6 | Backward compatible migration | WindFixer | Pending | 10 |

---

## Files

- C0MMON/Services/EventBus.cs (enhance)
- C0MMON/Interfaces/IAgent.cs (new)
- H0UND/Agents/PredictorAgent.cs (new)
- H0UND/Agents/OptimizerAgent.cs (new)
- H4ND/Agents/ExecutorAgent.cs (new)
- H4ND/Agents/MonitorAgent.cs (new)

---

## Dependencies

- **Blocks**: DECISION_028
- **Blocked By**: DECISION_026
- **Related**: DECISION_025, DECISION_028

---

## Designer Strategy

### Phase 1: EventBus Enhancement
1. Add CapabilityRegistry with Register/Get/Unregister
2. Add priority-based message routing

### Phase 2: Agent Role Interfaces
1. Create IAgent base in C0MMON/Interfaces
2. Specialized: IPredictor, IOptimizer, IExecutor, IMonitor
3. Create AgentRegistry for dynamic registration

### Phase 3-4: Agent Implementations
1. H0UND agents: PredictorAgent, OptimizerAgent
2. H4ND agents: ExecutorAgent, MonitorAgent

### Phase 5: Migration
1. Maintain backward compatibility with SIGN4L format
2. Dual-mode: Polling plus Event-driven during transition

### Validation
Test message routing and agent coordination end to end.

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-20
- **Approval**: 92%
- **Feasibility**: 7/10
- **Risk**: 6/10
- **Complexity**: 8/10
- **Key Findings**: Biggest risk is integration failure. Backward compatibility is critical.

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: Approved
- **Key Findings**: Clear interfaces for agent roles. Phased migration essential.

---

*Decision DECISION_027 - AgentNet Coordination - 2026-02-20*