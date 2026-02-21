# DECISION_035: End-to-End Jackpot Signal Testing Pipeline

**Decision ID**: TEST-035  
**Category**: TEST  
**Status**: Implemented  
**Priority**: Critical  
**Date**: 2026-02-20  
**Oracle Approval**: 88% (Strategist Assimilated)  
**Designer Approval**: 90% (Completed)

---

## Executive Summary

We need to establish a comprehensive end-to-end testing pipeline for jackpot signals that validates the complete flow from signal generation through login, game selection, and auto-spin execution. This testing infrastructure will ensure that when H0UND generates a jackpot signal, H4ND can successfully process it through the entire automation chain including CDP-based browser control, credential authentication, game navigation, and spin execution.

**Current Problem**:
- No systematic testing of the full signal-to-spin pipeline exists
- Jackpot splash events (when jackpots pop) need to be detected and handled
- Multiple accounts with balances exist but testing is manual and ad-hoc
- FourEyes vision system needs real-world validation data
- No automated verification that signals result in actual spins

**Proposed Solution**:
- Create a test harness that injects test signals into MongoDB
- Validate login flows for FireKirin and OrionStars via CDP
- Verify game selection and page readiness
- Confirm spin button detection and execution
- Handle jackpot splash detection and recovery
- Log all test results for analysis and FourEyes training data

---

## Background

### Current State

The P4NTH30N platform has three main components:

1. **H0UND** (Analytics Agent): Polls credentials, computes DPD (Double-Pointer-Detection), forecasts jackpots, and emits signals to MongoDB SIGN4L collection
2. **H4ND** (Automation Agent): Processes signals via CDP-based browser automation, handles login/logout, executes spins
3. **W4TCHD0G/FourEyes** (Vision System): Vision-based automation with RTMP stream processing, button detection, and decision engine

**Existing Testing Gaps**:
- Unit tests exist for individual components (CircuitBreaker, OperationTracker, etc.)
- Integration tests are partial (PipelineIntegrationTests.cs)
- No end-to-end test that validates signal → login → game → spin flow
- No automated handling of jackpot splash screens
- No validation that FourEyes vision processing can detect spin button states

### Desired State

A comprehensive testing pipeline that:
1. Injects controlled test signals into SIGN4L collection
2. Validates H4ND can retrieve and process signals
3. Confirms CDP-based login works for test credentials
4. Verifies game page readiness and jackpot value reading
5. Executes spins and validates they complete
6. Detects and handles jackpot splash screens
7. Captures vision frames for FourEyes training
8. Reports pass/fail metrics with detailed logs

---

## Specification

### Requirements

#### TEST-035-001: Test Signal Injection
**Priority**: Must  
**Acceptance Criteria**:
- Create test signals with known priority levels (1-4 for Mini/Minor/Major/Grand)
- Inject into MongoDB SIGN4L collection with test flag
- Support configurable test parameters (house, game, username, priority)
- Clean up test signals after test completion

#### TEST-035-002: Login Flow Validation
**Priority**: Must  
**Acceptance Criteria**:
- Test FireKirin login via CDP with test credentials
- Test OrionStars login via CDP with test credentials
- Verify successful authentication (balance query succeeds)
- Handle and report login failures with screenshots
- Timeout after 30 seconds with detailed error logging

#### TEST-035-003: Game Page Readiness
**Priority**: Must  
**Acceptance Criteria**:
- Verify game page loads (Canvas/DOM check via CDP)
- Confirm jackpot values are readable via WebSocket API
- Validate Grand > 0 (with retry logic up to 40 attempts)
- Report page load timing metrics

#### TEST-035-004: Spin Execution
**Priority**: Must  
**Acceptance Criteria**:
- Execute spin via CDP (CSS selector-based button click)
- Validate spin completes (balance change or animation detection)
- Support both direct CDP spin and FourEyes vision-based spin
- Timeout after 10 seconds with failure reporting
- Log pre-spin and post-spin balances

#### TEST-035-005: Jackpot Splash Detection
**Priority**: Should  
**Acceptance Criteria**:
- Detect jackpot splash screen appearance
- Capture splash screen for analysis
- Account for balance changes during splash
- Resume normal operation after splash dismissal
- Log jackpot tier and amount when detected

#### TEST-035-006: Vision Data Capture
**Priority**: Should  
**Acceptance Criteria**:
- Capture frames during test execution
- Store frames with metadata (timestamp, game state, action)
- Generate training data for FourEyes button detection
- Support OBS frame capture or CDP screenshot

#### TEST-035-007: Test Reporting
**Priority**: Must  
**Acceptance Criteria**:
- Generate detailed test report (JSON format)
- Include timing metrics for each phase
- Report pass/fail status with error details
- Store results in MongoDB TEST collection
- Export capability for analysis

### Technical Details

**Test Harness Architecture**:
```
TestOrchestrator
├── SignalInjector (MongoDB SIGN4L)
├── CdpTestClient (CDP automation)
├── LoginValidator (FireKirin/OrionStars)
├── GameReadinessChecker (Page load + API)
├── SpinExecutor (CDP + Vision)
├── SplashDetector (Vision/OCR)
├── VisionCapture (Frame storage)
└── ReportGenerator (JSON + MongoDB)
```

**Test Flow**:
1. TestOrchestrator initializes with test configuration
2. SignalInjector creates test signal in SIGN4L
3. CdpTestClient connects to Chrome CDP
4. LoginValidator attempts platform login
5. GameReadinessChecker verifies page and jackpot values
6. SpinExecutor triggers spin (CDP or Vision)
7. SplashDetector monitors for jackpot events
8. VisionCapture records frames throughout
9. ReportGenerator compiles results
10. Cleanup removes test signals and data

**CDP Integration Points**:
- `CdpClient` - WebSocket connection to Chrome
- `CdpGameActions.LoginFireKirinAsync()` - FireKirin login
- `CdpGameActions.LoginOrionStarsAsync()` - OrionStars login
- `CdpGameActions.VerifyGamePageLoadedAsync()` - Page readiness
- `FireKirin.QueryBalances()` / `OrionStars.QueryBalances()` - Jackpot values

**FourEyes Integration Points**:
- `FourEyesAgent` - Vision-based decision engine
- `VisionProcessor` - Frame analysis
- `DecisionEngine` - Action planning
- `SynergyClient` - VM input control

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-035-001 | Create TestOrchestrator class | Fixer | Pending | Critical |
| ACT-035-002 | Implement SignalInjector for MongoDB | Fixer | Pending | Critical |
| ACT-035-003 | Create CdpTestClient wrapper | Fixer | Pending | Critical |
| ACT-035-004 | Implement LoginValidator | Fixer | Pending | Critical |
| ACT-035-005 | Create GameReadinessChecker | Fixer | Pending | Critical |
| ACT-035-006 | Implement SpinExecutor | Fixer | Pending | Critical |
| ACT-035-007 | Create SplashDetector (vision/OCR) | Fixer | Pending | High |
| ACT-035-008 | Implement VisionCapture | Fixer | Pending | High |
| ACT-035-009 | Create ReportGenerator | Fixer | Pending | Critical |
| ACT-035-010 | Write unit tests for test harness | Fixer | Pending | High |
| ACT-035-011 | Create integration test suite | Fixer | Pending | High |
| ACT-035-012 | Document test execution procedures | Fixer | Pending | Medium |

---

## Dependencies

- **Blocks**: DECISION_036 (FourEyes needs test data from this pipeline)
- **Blocked By**: None - can proceed independently
- **Related**: FOUREYES-015 (H4ND Vision Command Integration), FOUREYES-020 (Unit Tests)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Test credentials banned during testing | High | Medium | Use dedicated test accounts with low spin amounts; implement rate limiting |
| CDP connection instability | High | Low | Implement retry logic with exponential backoff; use existing CircuitBreaker |
| Jackpot splash handling delays test | Medium | Medium | Set splash detection timeout; allow manual override |
| Vision processing too slow for real-time | Medium | Medium | Use lower FPS during tests; focus on accuracy over speed |
| MongoDB test data pollution | Low | Low | Use dedicated TEST collection; implement cleanup procedures |
| Chrome extension interference | Medium | Low | Run tests in incognito mode without extensions |

---

## Success Criteria

1. **Test Signal Injection**: Can inject 100 test signals with 100% success rate
2. **Login Success**: 95%+ success rate for FireKirin and OrionStars login flows
3. **Game Readiness**: Page verification completes within 10 seconds in 95% of cases
4. **Spin Execution**: Spins execute successfully in 90%+ of test cases
5. **Splash Detection**: Jackpot splashes detected within 5 seconds
6. **Vision Capture**: At least 10 frames captured per test run
7. **Test Reporting**: Complete JSON reports generated for every test
8. **Overall Pipeline**: End-to-end test completes in under 2 minutes

---

## Consultation Log

### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 88%
- **Key Findings**:
  - Feasibility Score: 8/10 - Strong existing infrastructure (CDP, CircuitBreaker, MongoDB)
  - Risk Score: 4/10 - Test account bans are primary concern
  - Complexity Score: 6/10 - Integration work, not novel development
  - Top Risks: (1) Test credential bans, (2) CDP connection instability, (3) Jackpot splash timing variability
  - Critical Success Factor: Isolated test environment with dedicated low-balance accounts
  - Recommendation: Implement comprehensive logging for debugging; use stub FourEyes initially
  - Safety Priority: Never exceed $5 bet limits during testing; require manual confirmation for spins
- **File**: consultations/oracle/DECISION_035_oracle.md

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: 90%
- **Key Findings**:
  - Implementation Strategy: 4-phase rollout over 3 weeks
  - Phase 1 (Week 1): Foundation - TestOrchestrator, SignalInjector, basic reporting
  - Phase 2 (Week 1-2): CDP Integration - LoginValidator, GameReadinessChecker
  - Phase 3 (Week 2): Execution - SpinExecutor, SplashDetector
  - Phase 4 (Week 3): Vision & Reporting - FourEyes capture, comprehensive reports
  - Files to Create: 14 new files in UNI7T35T/TestHarness/ and C0MMON/Entities/
  - Files to Modify: 8 files including MongoUnitOfWork, IUnitOfWork, H4ND game actions
  - Architecture: TestOrchestrator → Component Layer → External Dependencies → H4ND Reuse
  - Configuration: JSON-based with MongoDB, CDP, TestAccounts, Timeouts, SpinLimits, Vision, Reporting sections
  - Validation: Pre-flight CDP health, signal injection verification, login validation, game readiness, spin execution, splash detection
  - Fallback: Circuit breaker for CDP, exponential backoff for transient failures, graceful degradation (vision → CDP), cleanup guarantee via finally blocks
  - Integration Strategy: Wrap CdpClient in CdpTestClient, call CdpGameActions directly, inject CircuitBreaker, use OperationTracker for duplicate prevention
- **File**: consultations/designer/DECISION_035_designer.md

---

## Notes

**Test Account Requirements**:
- Need 2-3 test accounts per platform (FireKirin, OrionStars)
- Accounts should have small balances ($5-20) for testing
- Accounts should be verified as not banned
- Consider creating dedicated test house in MongoDB

**FourEyes Training Data**:
- Test runs will generate valuable training data for FourEyes
- Capture frames of: login screens, game lobbies, spin buttons, jackpot splashes
- Label frames with game state for supervised learning
- Store in format compatible with LM Studio training

**Integration with Existing Infrastructure**:
- Reuse existing `CdpClient` and `CdpGameActions`
- Leverage `CircuitBreaker` for resilience
- Use `OperationTracker` to prevent duplicate test signals
- Integrate with `HealthCheckService` for monitoring

---

*Decision TEST-035*  
*End-to-End Jackpot Signal Testing Pipeline*  
*2026-02-20*
