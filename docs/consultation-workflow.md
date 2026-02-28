# Consultation Workflow

**Document ID:** WORKFLOW-001  
**Version:** 1.0  
**Last Updated:** 2026-02-18

---

## Overview

This document defines the tiered consultation model for P4NTHE0N platform operations, ensuring efficient resource utilization while maintaining system reliability.

---

## Tiered Consultation Model

### Tier 1: Self-Service (0-15 minutes)

**Scope:** Routine operations with established patterns

| Aspect | Definition |
|--------|------------|
| **Response Time** | Immediate (automated) |
| **Cost** | $0 (internal tools) |
| **Approvers** | None required |
| **Examples** | Status checks, threshold queries, signal monitoring |

**Tools:**
- MCP-P4NTHE0N server queries
- Dashboard monitoring
- Automated alerts

---

### Tier 2: Standard Consultation (15 minutes - 2 hours)

**Scope:** Non-routine issues requiring agent coordination

| Aspect | Definition |
|--------|------------|
| **Response Time** | Within 2 hours during business hours |
| **Cost** | $5-25 (depending on agent usage) |
| **Approvers** | Single agent approval |
| **Examples** | Threshold adjustments, credential issues, signal troubleshooting |

**Workflow:**
1. Issue identified via monitoring or manual report
2. Strategist agent assesses and routes
3. Relevant specialist agent (Oracle/Designer) consults
4. Resolution implemented by OpenFixer
5. Verification via automated tests

---

### Tier 3: Escalated Consultation (2-24 hours)

**Scope:** Complex architectural decisions or critical failures

| Aspect | Definition |
|--------|------------|
| **Response Time** | Within 24 hours |
| **Cost** | $25-100 (multi-agent coordination) |
| **Approvers** | Oracle approval required (78%+ conditional) |
| **Examples** | Architecture changes, security incidents, data corruption |

**Workflow:**
1. Critical issue detected
2. Emergency response protocol activated
3. Multi-agent consultation (Strategist + Oracle + Designer)
4. Decision framework invoked
5. WindFixer executes approved changes in bulk
6. ForgeWright validates via comprehensive testing

---

## SLA Requirements

### Availability

| Tier | Uptime Target | Response Time |
|------|---------------|---------------|
| Tier 1 | 99.9% | < 1 minute |
| Tier 2 | 99.5% | < 2 hours |
| Tier 3 | 98% | < 24 hours |

### Resolution Targets

| Severity | Definition | Resolution Target |
|----------|------------|-------------------|
| P1 (Critical) | System down, data loss | 4 hours |
| P2 (High) | Major feature impaired | 8 hours |
| P3 (Medium) | Minor feature issues | 24 hours |
| P4 (Low) | Cosmetic, documentation | 72 hours |

---

## Cost Control Rules

### Budget Thresholds

| Tier | Daily Limit | Monthly Limit |
|------|-------------|---------------|
| Tier 1 | Unlimited | Unlimited |
| Tier 2 | $50 | $500 |
| Tier 3 | $100 | $1,000 |

### Approval Requirements

| Cost Range | Required Approval |
|------------|-------------------|
| $0-10 | Automated |
| $10-25 | Single agent |
| $25-50 | Oracle consultation |
| $50+ | Full Decision framework |

### Cost Optimization Measures

1. **Bulk Execution:** Use WindSurf for multi-file changes
2. **Model Fallback:** Switch to cheaper models when appropriate
3. **In-House First:** Prioritize internal tools over external services
4. **Decision Framework:** Batch related changes into single Decisions

---

## Threshold Definitions

### Automation Thresholds

| Metric | Tier 1 | Tier 2 | Tier 3 |
|--------|--------|--------|--------|
| Query Complexity | Simple | Moderate | Complex |
| Files Modified | 0-1 | 2-5 | 6+ |
| Agents Required | 0 | 1-2 | 3+ |
| Risk Level | Low | Medium | High |

### Escalation Triggers

Automatic escalation occurs when:
- Cost estimate exceeds tier threshold
- Resolution time exceeds SLA
- Error rate > 5% in automated processes
- Security-related changes
- Database schema modifications

---

## Escalation Path

```
┌─────────────────┐
│  Issue Detected │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Tier 1 Check   │◄──── Can MCP query resolve?
└────────┬────────┘      Yes → Resolve
         │ No
         ▼
┌─────────────────┐
│  Tier 2 Check   │◄──── Single agent sufficient?
└────────┬────────┘      Yes → Route to specialist
         │ No
         ▼
┌─────────────────┐
│  Tier 3 Check   │◄──── Oracle approval required?
└────────┬────────┘      Yes → Full consultation
         │
         ▼
┌─────────────────┐
│ Decision        │
│ Framework       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ WindFixer       │
│ Bulk Execution  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ ForgeWright     │
│ Validation      │
└─────────────────┘
```

### Escalation Contacts

| Tier | Primary | Secondary |
|------|---------|-----------|
| Tier 1 | Automated | N/A |
| Tier 2 | Strategist | Oracle |
| Tier 3 | Oracle | Full Pantheon |

---

## Decision Framework Integration

### When to Use

- Changes affecting multiple components
- Cost estimates > $50
- Architectural modifications
- Security policy updates

### Process

1. **Strategist** creates Decision document
2. **Oracle** provides risk assessment (78% conditional approval)
3. **Designer** validates technical approach
4. **WindFixer** executes approved changes
5. **ForgeWright** validates via tests

---

## Monitoring & Reporting

### Metrics Tracked

- Consultation volume by tier
- Average resolution time
- Cost per consultation
- Escalation rate
- Agent utilization

### Review Cycle

- **Weekly:** Tier 1/2 metrics review
- **Monthly:** Full SLA compliance report
- **Quarterly:** Cost optimization analysis

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-18 | OpenFixer | Initial creation |

---

## Related Documents

- [PANTHEON.md](./PANTHEON.md) - Agent architecture
- [DECISION_FRAMEWORK.md](./DECISION_FRAMEWORK.md) - Decision process
- [INCIDENT_RESPONSE.md](./runbooks/INCIDENT_RESPONSE.md) - Emergency procedures
