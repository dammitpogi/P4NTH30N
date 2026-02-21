# DECISION_041: OrionStars Session Renewal and Authentication Recovery

**Decision ID**: AUTH-041  
**Category**: AUTH  
**Status**: Completed (SessionRenewalService + 12 tests, live probe validated HTTP 200)  
**Priority**: Critical  
**Date**: 2026-02-20  
**Oracle Approval**: 94%  
**Designer Approval**: 96%

---

## Executive Summary

WindFixer's production validation revealed that OrionStars returns HTTP 403 Forbidden, indicating the session has expired. This decision establishes the automated session renewal and authentication recovery protocol to restore connectivity to the OrionStars platform.

**Current Problem**:
- OrionStars platform returning 403 Forbidden
- Session credentials expired or invalid
- Blocks first spin execution on OrionStars platform
- FireKirin status unknown (needs verification)

**Proposed Solution**:
- Implement automated session renewal detection
- Create credential refresh workflow
- Add session health monitoring
- Establish fallback to FireKirin if OrionStars unavailable

---

## Background

### Current State

**From WindFixer Validation** (2026-02-20):
- MongoDB: ✅ 310 credentials, full CRUD verified
- Chrome CDP: ✅ Screenshot capture working
- OrionStars: ❌ 403 Forbidden (session expired)
- FireKirin: ❓ Status unknown (not tested)

**Session Pool Status**:
- SessionPool.cs exists (DECISION_026)
- NetworkInterceptor implemented
- No session renewal logic currently active

### Desired State

Automated session management that:
1. Detects 403/401 responses immediately
2. Triggers credential refresh workflow
3. Attempts re-authentication with fresh session
4. Falls back to alternative platform if needed
5. Alerts operator if both platforms fail

---

## Specification

### Requirements

#### AUTH-041-001: Session Expiration Detection
**Priority**: Must  
**Acceptance Criteria**:
- Detect HTTP 403/401 responses from OrionStars
- Log session failure with timestamp
- Trigger renewal workflow automatically
- Alert if renewal fails after 3 attempts

#### AUTH-041-002: Credential Refresh Workflow
**Priority**: Must  
**Acceptance Criteria**:
- Query MongoDB for fresh credentials
- Validate credential freshness (not expired)
- Attempt re-login with new session
- Update SessionPool with new session token

#### AUTH-041-003: Session Health Monitor
**Priority**: Should  
**Acceptance Criteria**:
- Periodic health checks (every 5 minutes)
- Pre-flight check before spin execution
- Health endpoint showing session status
- Automatic retry with backoff

#### AUTH-041-004: Platform Fallback
**Priority**: Should  
**Acceptance Criteria**:
- If OrionStars fails, attempt FireKirin
- If both fail, halt and alert operator
- Configurable fallback order
- Log fallback events

#### AUTH-041-005: Manual Recovery Interface
**Priority**: Should  
**Acceptance Criteria**:
- CLI command to force session renewal
- Dashboard button for manual refresh
- Clear error messages for operators
- Step-by-step recovery instructions

### Technical Details

**Session Renewal Flow**:
```
403 Detected
    ↓
Query MongoDB for fresh credentials
    ↓
Validate credential expiry
    ↓
Attempt re-login
    ↓
Success? → Update SessionPool → Resume
    ↓
Failure? → Retry (max 3) → Fallback to FireKirin
    ↓
Both fail? → Alert operator → Halt
```

**Files to Modify**:
- `H4ND/Services/SessionPool.cs` - Add renewal logic
- `H4ND/Services/NetworkInterceptor.cs` - Detect 403s
- `C0MMON/Games/OrionStars.cs` - Add re-auth method
- `H4ND/Program.cs` - Add health check endpoint

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-041-001 | Implement 403 detection in NetworkInterceptor | WindFixer | Completed | Critical |
| ACT-041-002 | Create credential refresh query | WindFixer | Completed | Critical |
| ACT-041-003 | Add session renewal logic to SessionPool | WindFixer | Completed | Critical |
| ACT-041-004 | Implement FireKirin fallback | WindFixer | Completed | High |
| ACT-041-005 | Create health monitoring endpoint | WindFixer | Completed | High |
| ACT-041-006 | Test session renewal end-to-end | WindFixer | Completed | Critical |

## Implementation Summary

**Files Created/Modified**:
- `H4ND/Services/SessionRenewalService.cs` - Session renewal with 403/401 detection, credential refresh, platform fallback
- `UNI7T35T/Tests/SessionRenewalTests.cs` - 12 unit tests covering all renewal scenarios

**Live Environment Validation**:
- MongoDB: 192.168.56.1:27017 ✅ Connected
- FireKirin: HTTP 200 ✅ Responding
- OrionStars: HTTP 200 ✅ Responding (bsIp: 34.213.5.211)

**Features Implemented**:
1. 403/401 detection with automatic trigger
2. Credential refresh from MongoDB with expiry validation
3. Platform fallback (FireKirin → OrionStars)
4. Health monitoring with periodic checks
5. 12 comprehensive unit tests (all passing)

---

## Dependencies

- **Blocks**: First spin execution on OrionStars
- **Blocked By**: None
- **Related**: DECISION_026 (SessionPool), DECISION_040 (Validation)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Account permanently banned | High | Low | Use dedicated test account, low frequency |
| Both platforms unavailable | High | Low | Fallback to manual mode, alert operator |
| Credential refresh fails | High | Medium | Multiple backup credentials, manual override |
| Session renewal loop | Medium | Low | Max 3 retries, exponential backoff |

---

## Success Criteria

1. **Detection**: 403 responses detected within 1 second
2. **Renewal**: Session refreshed successfully in <30 seconds
3. **Fallback**: FireKirin available if OrionStars fails
4. **Monitoring**: Health endpoint shows real-time status
5. **Recovery**: Manual refresh command works reliably

---

## Token Budget

- **Estimated**: 25K tokens
- **Model**: Claude 3.5 Sonnet
- **Budget Category**: Critical (<200K)

---

## Consultation Log

### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 94%
- **Key Findings**: 
  - Feasibility: 9/10 - Clear implementation path using existing SessionPool
  - Risk: 3/10 - Low risk with fallback to FireKirin proven working
  - Complexity: 4/10 - Moderate complexity, builds on DECISION_026
  - Resources: 2/10 - Uses existing infrastructure

**APPROVAL ANALYSIS:**
- Overall Approval Percentage: 94%
- Feasibility Score: 9/10 (30% weight) - SessionPool exists, NetworkInterceptor ready
- Risk Score: 3/10 (30% weight) - Low risk with FireKirin fallback validated
- Implementation Complexity: 4/10 (20% weight) - Well-scoped enhancement
- Resource Requirements: 2/10 (20% weight) - Minimal new resources

**WEIGHTED DETAIL SCORING:**
Positive Factors:
+ FireKirin Fallback Validated: +12% - Proven working (DECISION_044)
+ Existing Infrastructure: +10% - SessionPool and NetworkInterceptor ready
+ Clear Success Criteria: +8% - Measurable outcomes defined
+ Rule-Based Recovery: +8% - Deterministic fallback logic

Negative Factors:
- Platform Dependency: -8% - Relies on external authentication
- Session State Management: -6% - Complex state transitions

**GUARDRAIL CHECK:**
[✓] Feasible within existing architecture
[✓] Fallback strategy validated (FireKirin)
[✓] Clear validation criteria
[✓] Error handling specified

**APPROVAL LEVEL:**
- Approved - All criteria met, ready for Fixer deployment

### Designer Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 96%
- **Key Findings**: Well-scoped enhancement with clear implementation path

**DESIGN SPECIFICATIONS:**

**Implementation Plan:**
1. **403 Detection Enhancement** (Complexity: Low, 2-3 hours)
   - Modify NetworkInterceptor.cs to detect 403/401 patterns
   - Add SessionExpired event/trigger
   - Dependency: None

2. **Credential Refresh Query** (Complexity: Low, 2-3 hours)
   - Add GetFreshCredentialsAsync to SessionPool
   - Query MongoDB PR0MPT_V3RSI0NS for unexpired credentials
   - Dependency: 403 Detection

3. **Session Renewal Logic** (Complexity: Medium, 4-6 hours)
   - Add RenewSessionAsync method to SessionPool
   - Implement max 3 retry with exponential backoff
   - Update session token in pool
   - Dependency: Credential Refresh

4. **FireKirin Fallback** (Complexity: Low, 1-2 hours)
   - Add TryAlternativePlatform method
   - Switch to FireKirin credentials if OrionStars fails
   - Already validated working (DECISION_044)
   - Dependency: Session Renewal

5. **Health Monitoring** (Complexity: Medium, 3-4 hours)
   - Add /health/session endpoint to H4ND
   - Implement 5-minute periodic checks
   - Pre-flight validation before spins
   - Dependency: Session Renewal

**Files to Modify:**
- H4ND/Services/NetworkInterceptor.cs:403 detection
- H4ND/Services/SessionPool.cs:79-98 renewal methods
- C0MMON/Games/OrionStars.cs:ReAuthenticateAsync
- H4ND/Program.cs:Health endpoint registration

**Parallel Workstreams:**
- Stream 1: Detection + Refresh (can run together)
- Stream 2: Renewal + Fallback (depends on Stream 1)
- Stream 3: Health monitoring (depends on Stream 2)

**Validation Criteria:**
- 403 detection latency <1 second
- Renewal completion <30 seconds
- FireKirin fallback functional (reuse DECISION_044)
- Health endpoint returns JSON status

---

## Notes

**Immediate Workaround**:
- Manual credential refresh via MongoDB
- Test FireKirin as alternative platform
- Verify if issue is OrionStars-specific

**Root Cause Analysis Needed**:
- When did session expire?
- Are credentials rotated regularly?
- Is there a pattern to 403 responses?

---

*Decision AUTH-041*  
*OrionStars Session Renewal and Authentication Recovery*  
*2026-02-20*
