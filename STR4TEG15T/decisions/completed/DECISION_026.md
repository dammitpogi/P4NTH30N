# DECISION_026: CDP Automation with Request Interception and Session Sandboxing

**Decision ID**: DECISION_026
**Category**: Automation
**Status**: Approved
**Priority**: High
**Date**: 2026-02-20
**Oracle Approval**: 95%
**Designer Approval**: Approved

---

## Executive Summary

Upgrade H4ND CDP implementation with Network domain interception for API-based jackpot extraction, Target domain for session isolation, and Tracing domain for debugging. Moves from fragile DOM parsing to reliable API interception.

**Current Problem**:
- DOM parsing is fragile and breaks with UI changes
- No session isolation between concurrent credentials
- Limited debugging capability for automation failures

**Proposed Solution**:
- CDP Network domain for HTTP request/response interception
- SessionPool for isolated CDP sessions per credential
- Tracing domain for debugging and performance analysis

---

## Research Source

ArXiv 2503.02950v1 - LiteWebAgent: CDP-based browser control
ArXiv 2512.12594v1 - Sandboxing Browser AI Agents

---

## Specification

### Requirements

1. **CDP-001**: Network domain interception for jackpot API calls
   - **Priority**: Must
   - **Acceptance Criteria**: Jackpot values extracted from API responses

2. **CDP-002**: SessionPool with isolated connections per credential
   - **Priority**: Must
   - **Acceptance Criteria**: No cross-contamination between sessions

3. **CDP-003**: Tracing domain for debugging
   - **Priority**: Should
   - **Acceptance Criteria**: Traces stored in MongoDB on error

4. **CDP-004**: Feature flag rollout
   - **Priority**: Must
   - **Acceptance Criteria**: Gradual migration from DOM to API

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-026-1 | Add Network domain to CDPManager | WindFixer | Pending | 10 |
| ACT-026-2 | Create SessionPool.cs | WindFixer | Pending | 10 |
| ACT-026-3 | Create NetworkInterceptor.cs | WindFixer | Pending | 9 |
| ACT-026-4 | Create AutomationTrace entity | WindFixer | Pending | 7 |
| ACT-026-5 | Feature flag and dual-read validation | WindFixer | Pending | 8 |

---

## Files

- H4ND/Services/CDPManager.cs (enhance)
- H4ND/Services/SessionPool.cs (new)
- H4ND/Services/NetworkInterceptor.cs (new)
- C0MMON/Entities/AutomationTrace.cs (new)

---

## Dependencies

- **Blocks**: DECISION_027
- **Blocked By**: None
- **Related**: DECISION_025

---

## Designer Strategy

### Phase 1: CDP Network Interception
1. Add Network domain methods to CDPManager
2. Implement RequestMatcher for jackpot API URL patterns
3. Create ApiResponseParser for JSON extraction

### Phase 2: Session Pool
1. Create SessionPool with lazy initialization
2. GetSession/ReturnSession with health checks
3. Add SessionMetrics tracking

### Phase 3: Tracing
1. Add Tracing domain support
2. Create AutomationTrace entity for MongoDB

### Phase 4: Migration
1. Feature flag EnableNetworkInterception default false
2. Dual-read: compare DOM vs API, log discrepancies
3. Gradual rollout 10%, 50%, 100%

### Validation
1000 automated spins with dual-read comparison.

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-20
- **Approval**: 95%
- **Feasibility**: 9/10
- **Risk**: 4/10
- **Complexity**: 5/10
- **Key Findings**: Risk of race conditions with concurrent sessions. Feature flag recommended.

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: Approved
- **Key Findings**: Network and SessionPool can be parallel. DOM fallback included.

---

*Decision DECISION_026 - CDP Enhancement - 2026-02-20*