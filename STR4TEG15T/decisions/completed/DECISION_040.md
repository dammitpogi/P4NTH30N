# DECISION_040: Production Environment Validation and First Spin Execution

**Decision ID**: PROD-040  
**Category**: PROD  
**Status**: Proposed  
**Priority**: Critical  
**Date**: 2026-02-20  
**Oracle Approval**: Pending  
**Designer Approval**: Pending

---

## Executive Summary

The infrastructure decisions (035-039) have been implemented with code files created, but production validation against live services has not been completed. This decision establishes the validation protocol to confirm all systems are operational: MongoDB connectivity, Chrome CDP accessibility, game server reachability, and the complete signal-to-spin pipeline. The goal is to execute the first autonomous jackpot spin in a controlled production environment.

**Current Problem**:
- Code exists for test harness, FourEyes, subagent resilience, and tool migration
- Production environment services are running (MongoDB, Chrome CDP)
- No validation that code actually connects to and operates with real services
- First spin execution is blocked pending verification

**Proposed Solution**:
- Execute systematic production validation protocol
- Test MongoDB connectivity with real document insertion/retrieval
- Verify Chrome CDP connection and browser automation capability
- Validate game server accessibility (FireKirin/OrionStars)
- Execute controlled first spin with full monitoring

---

## Background

### Current State

**Implemented Infrastructure** (from git history and file system):
- DECISION_037: Subagent resilience files created (7 TypeScript files in W1ND5URF)
- DECISION_038: Multi-agent workflow tools created (4 PowerShell scripts in STR4TEG15T/tools)
- DECISION_035: Test harness created (11 C# files in UNI7T35T/TestHarness)
- DECISION_036: FourEyes development mode created (4 C# files in W4TCHD0G/Development)
- DECISION_039: Tool migration structure created (MCP server files)

**Production Environment Status** (verified 2026-02-20):
- MongoDB: Running and accessible (ping successful)
- Chrome CDP: Running on localhost:9222 (version endpoint responding)
- VM Network: 192.168.56.1 reachable
- Game Servers: Status unknown, credentials available

### Desired State

All implemented code validated against production services with:
1. Successful MongoDB document operations
2. Successful Chrome CDP browser automation
3. Successful game login and navigation
4. Successful first autonomous spin execution
5. Full telemetry and monitoring capture

---

## Specification

### Requirements

#### PROD-040-001: MongoDB Connectivity Validation
**Priority**: Must  
**Acceptance Criteria**:
- Connect to mongodb://192.168.56.1:27017
- Insert test document to P4NTH30N.TEST collection
- Retrieve and verify test document
- Measure connection latency (<100ms target)
- Clean up test document

#### PROD-040-002: Chrome CDP Validation
**Priority**: Must  
**Acceptance Criteria**:
- Connect to ws://localhost:9222/devtools/browser/...
- Create new browser context
- Navigate to about:blank
- Execute simple JavaScript (1+1=2)
- Close context cleanly

#### PROD-040-003: Game Server Accessibility
**Priority**: Must  
**Acceptance Criteria**:
- Verify FireKirin login page reachable
- Verify OrionStars login page reachable
- Test credential authentication (read-only check)
- Measure page load times
- Document any connectivity issues

#### PROD-040-004: Test Harness Execution
**Priority**: Must  
**Acceptance Criteria**:
- Run TestOrchestrator with production configuration
- Inject test signal to MongoDB SIGN4L collection
- Execute login flow via CDP
- Verify game page readiness
- Report success/failure with timing metrics

#### PROD-040-005: First Spin Execution
**Priority**: Should  
**Acceptance Criteria**:
- Execute single spin with $0.10 bet (minimum)
- Capture pre-spin and post-spin balance
- Verify spin completed (balance change or animation)
- Log all telemetry (timing, errors, screenshots)
- Manual confirmation gate before execution

#### PROD-040-006: FourEyes Vision Validation
**Priority**: Should  
**Acceptance Criteria**:
- Connect to OBS WebSocket (if running)
- Capture single frame from stream
- Run stub detectors on frame
- Verify vision pipeline latency <500ms
- Log frame metadata

### Technical Details

**Validation Sequence**:
```
Phase 1: Infrastructure
├── MongoDB connectivity test
├── Chrome CDP connectivity test
└── Network latency measurements

Phase 2: Game Access
├── FireKirin reachability test
├── OrionStars reachability test
└── Credential validation (read-only)

Phase 3: Test Harness
├── TestOrchestrator initialization
├── Signal injection
├── Login flow execution
└── Game readiness verification

Phase 4: First Spin (with confirmation)
├── Pre-spin balance check
├── Spin execution ($0.10)
├── Post-spin balance check
└── Telemetry capture
```

**Configuration**:
```json
{
  "ProductionValidation": {
    "MongoDB": {
      "ConnectionString": "mongodb://192.168.56.1:27017",
      "Database": "P4NTH30N",
      "TestCollection": "TEST"
    },
    "ChromeCDP": {
      "DebuggerUrl": "ws://localhost:9222/devtools/browser/...",
      "TimeoutMs": 30000
    },
    "GameServers": {
      "FireKirin": "https://firekirin.com",
      "OrionStars": "https://orionstars.com"
    },
    "TestParameters": {
      "MaxBetAmount": 0.10,
      "RequireConfirmation": true,
      "MaxSpinDurationSec": 30
    }
  }
}
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-040-001 | Create production validation configuration | OpenFixer | Pending | Critical |
| ACT-040-002 | Implement MongoDB connectivity test | WindFixer | Pending | Critical |
| ACT-040-003 | Implement Chrome CDP validation test | WindFixer | Pending | Critical |
| ACT-040-004 | Implement game server reachability test | WindFixer | Pending | Critical |
| ACT-040-005 | Execute TestOrchestrator against production | WindFixer | Pending | Critical |
| ACT-040-006 | Execute first spin with confirmation | WindFixer | Pending | High |
| ACT-040-007 | Validate FourEyes vision pipeline | WindFixer | Pending | High |
| ACT-040-008 | Generate validation report | WindFixer | Pending | Critical |

---

## Dependencies

- **Blocks**: None (this is final validation)
- **Blocked By**: DECISION_035, 036, 037, 038, 039 (infrastructure must be implemented)
- **Related**: All previous implementation decisions

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| MongoDB connection fails | High | Low | Verify VM network, check MongoDB logs, test with mongosh |
| Chrome CDP connection fails | High | Low | Verify Chrome running with --remote-debugging-port=9222 |
| Game servers unreachable | High | Medium | Check network, verify URLs, test from browser |
| Test credentials invalid | High | Low | Use read-only validation first, have backup credentials |
| First spin fails | Medium | Medium | Start with minimum bet ($0.10), manual confirmation |
| Account banned during test | High | Low | Use dedicated test account, low frequency, manual control |

---

## Success Criteria

1. **MongoDB**: Document insert/retrieve succeeds in <100ms
2. **Chrome CDP**: Browser context created, JS executed, closed cleanly
3. **Game Servers**: Both platforms reachable and responding
4. **Test Harness**: Signal injection → login → readiness completes
5. **First Spin**: Single $0.10 spin executes successfully with balance verification
6. **FourEyes**: Frame capture and processing completes in <500ms
7. **Overall**: All validation tests pass, first spin executed

---

## Token Budget

- **Estimated**: 30K tokens
- **Model**: Claude 3.5 Sonnet (OpenRouter)
- **Budget Category**: Critical (<200K)

---

## Bug-Fix Section

- **On syntax error**: WindFixer auto-fixes
- **On connection error**: Verify service status, retry with exponential backoff
- **On test failure**: Log detailed diagnostics, continue with other tests
- **On spin failure**: Stop, analyze logs, do not retry without human review
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| WindFixer | Validation sub-decisions | Medium | Yes (Strategist) |
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Bug-fix sub-decisions | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 93%
- **Key Findings**:
  - Feasibility Score: 9/10 - Infrastructure confirmed running, code exists
  - Risk Score: 4/10 - Real money risk mitigated by $0.10 minimum bet
  - Complexity Score: 5/10 - Integration validation, not novel development
  - Top Risks: (1) Account ban during spin, (2) Service instability, (3) Invalid credentials
  - Critical Success Factors: Service health verification, minimum bet protocol, manual confirmation
  - Recommendation: Phase 1 first, read-only tests, single spin only, document everything
  - Safety Rule: Manual confirmation required before any spin
- **File**: consultations/oracle/DECISION_040_oracle.md

### Designer Consultation (Aegis)
- **Date**: 2026-02-20
- **Approval**: 85%
- **Key Findings**:
  - Implementation Strategy: 7 phases over ~3 hours
  - Phase 1: Infrastructure validation (MongoDB, Chrome CDP, Network)
  - Phase 2: Service accessibility (FireKirin, OrionStars)
  - Phase 3: Test harness execution
  - Phase 4: First spin preparation
  - Phase 5: First spin execution (with manual confirmation)
  - Phase 6: Vision pipeline validation
  - Phase 7: Report generation
  - Files to Create: 12 new validation files
  - Files to Modify: 4 existing files
  - Key Architecture: ValidationCoordinator pattern with phase-specific validators
  - Safety: Confirmation gate, no auto-retry on spin failure, comprehensive telemetry
  - Token Budget: 35K tokens (Claude 3.5 Sonnet recommended)
- **File**: consultations/designer/DECISION_040_designer.md

---

## Notes

**Production Environment** (verified 2026-02-20):
- MongoDB: mongodb://192.168.56.1:27017 (ping successful)
- Chrome CDP: ws://localhost:9222 (version endpoint responding)
- VM Network: 192.168.56.1 reachable

**Test Credentials**:
- Need to verify test account status before first spin
- Use minimum bet ($0.10) for first execution
- Manual confirmation required before any real money spin

**Validation vs Implementation**:
- This decision is about VALIDATING existing code
- Not about creating new infrastructure
- Focus: Does the code work with real services?

---

*Decision PROD-040*  
*Production Environment Validation and First Spin Execution*  
*2026-02-20*
