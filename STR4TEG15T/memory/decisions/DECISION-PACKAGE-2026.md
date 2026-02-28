---
type: decision
id: DECISION-PACKAGE-2026
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.791Z'
last_reviewed: '2026-02-23T01:31:15.791Z'
keywords:
  - strategist
  - summary
  - threedecision
  - package
  - decision
  - overview
  - executive
  - infra037
  - subagent
  - fallback
  - system
  - hardening
  - problem
  - solution
  - critical
  - path
  - components
  - files
  - create
  - modify
roles:
  - librarian
  - oracle
summary: >-
  **Date**: 2026-02-20 **Strategist**: Pyxis **Status**: Approved for
  Implementation **Total Decisions**: 3 **Total Action Items**: 35 **Estimated
  Effort**: 6-8 weeks
source:
  type: decision
  original_path: >-
    ../../../STR4TEG15T/decisions/active/SUMMARY-Three-Decision-Package-2026-02-20.md
---
# Strategist Summary: Three-Decision Package

**Date**: 2026-02-20  
**Strategist**: Pyxis  
**Status**: Approved for Implementation  
**Total Decisions**: 3  
**Total Action Items**: 35  
**Estimated Effort**: 6-8 weeks

---

## Decision Overview

| Decision | ID | Category | Priority | Oracle | Designer | Status |
|----------|-----|----------|----------|--------|----------|--------|
| End-to-End Jackpot Signal Testing Pipeline | TEST-035 | TEST | Critical | 88% | 90% | ✅ Approved |
| FourEyes Development Assistant Activation | FEAT-036 | FEAT | Critical | 85% | 90% | ✅ Approved |
| Subagent Fallback System Hardening | INFRA-037 | INFRA | Critical | 92% | 90% | ✅ Approved |

---

## Executive Summary

This three-decision package establishes comprehensive testing infrastructure, activates the FourEyes vision system for development assistance, and hardens subagent reliability. All three decisions are **APPROVED** with high confidence ratings and are ready for Fixer implementation.

**Key Dependencies**:
- DECISION_035 (Testing Pipeline) generates training data for DECISION_036 (FourEyes)
- DECISION_037 (Subagent Hardening) should be implemented FIRST to ensure reliable subagent execution for the other two decisions
- All three can proceed in parallel after INFRA-037 Phase 1 is complete

---

## Decision 1: INFRA-037 - Subagent Fallback System Hardening

**Priority**: IMPLEMENT FIRST  
**Oracle Approval**: 92%  
**Designer Approval**: 90%

### Problem
Subagent tasks fail on transient network errors without adequate retry. When the Nexus sends the same prompt multiple times due to server unresponsiveness, human intervention allows recovery—but subagents have no such mechanism.

### Solution
Implement intelligent network error detection, exponential backoff retry with jitter, connection health monitoring, network-level circuit breaker, and automatic task restart for network failures.

### Critical Path Components
1. **ErrorClassifier** - Classify errors as NetworkTransient, NetworkPermanent, ProviderRateLimit, LogicError
2. **BackoffManager** - Exponential backoff (1s, 2s, 4s, 8s, 16s) with jitter
3. **ConnectionHealthMonitor** - Pre-flight checks, keepalive pings
4. **NetworkCircuitBreaker** - Per-endpoint tracking, 5-minute cooldown
5. **TaskRestartManager** - Auto-restart on network failures (max 3 restarts)

### Files to Create (9)
- `src/background/resilience/error-classifier.ts`
- `src/background/resilience/backoff-manager.ts`
- `src/background/resilience/connection-health-monitor.ts`
- `src/background/resilience/network-circuit-breaker.ts`
- `src/background/resilience/task-restart-manager.ts`
- `src/background/resilience/retry-metrics.ts`
- `src/background/resilience/index.ts`

### Files to Modify (3)
- `src/background/background-manager.ts` (lines 1199-1257)
- `src/config/schema.ts`
- `src/config/constants.ts`

### Implementation Timeline
- **Phase 1 (Week 1)**: ErrorClassifier + BackoffManager
- **Phase 2 (Week 1-2)**: Health Monitor + Circuit Breaker
- **Phase 3 (Week 2)**: Task Restart + Visibility
- **Phase 4 (Week 2-3)**: Testing + Hardening

### Success Criteria
- 95%+ accuracy in classifying network vs logic errors
- 80%+ of network-related subagent failures succeed on retry
- Average 3 retries before success or final fallback
- No more than 5 consecutive failures before circuit opens

---

## Decision 2: TEST-035 - End-to-End Jackpot Signal Testing Pipeline

**Priority**: IMPLEMENT SECOND  
**Oracle Approval**: 88%  
**Designer Approval**: 90%

### Problem
No systematic testing of the full signal-to-spin pipeline exists. Jackpot splash events need detection, multiple accounts exist but testing is manual, FourEyes needs validation data, no automated verification that signals result in spins.

### Solution
Create a test harness that injects test signals into MongoDB, validates login flows via CDP, verifies game readiness, executes spins, detects jackpot splashes, captures vision frames, and reports results.

### Critical Path Components
1. **TestOrchestrator** - Main test controller
2. **TestSignalInjector** - MongoDB SIGN4L injection
3. **CdpTestClient** - H4ND CDP wrapper for isolation
4. **LoginValidator** - FireKirin/OrionStars login testing
5. **GameReadinessChecker** - Page load + jackpot verification
6. **SpinExecutor** - CDP-based spin testing
7. **SplashDetector** - Jackpot splash detection
8. **VisionCapture** - Frame storage for training data
9. **TestReportGenerator** - JSON + MongoDB output

### Files to Create (14)
- `UNI7T35T/TestHarness/TestOrchestrator.cs`
- `UNI7T35T/TestHarness/TestSignalInjector.cs`
- `UNI7T35T/TestHarness/CdpTestClient.cs`
- `UNI7T35T/TestHarness/LoginValidator.cs`
- `UNI7T35T/TestHarness/GameReadinessChecker.cs`
- `UNI7T35T/TestHarness/SpinExecutor.cs`
- `UNI7T35T/TestHarness/SplashDetector.cs`
- `UNI7T35T/TestHarness/VisionCapture.cs`
- `UNI7T35T/TestHarness/TestReportGenerator.cs`
- `UNI7T35T/TestHarness/TestConfiguration.cs`
- `C0MMON/Entities/TestResult.cs`
- `UNI7T35T/TestHarness/TestFixture.cs`
- `UNI7T35T/Tests/EndToEndTests.cs`
- `UNI7T35T/Mocks/MockFourEyesClient.cs`

### Files to Modify (8)
- `UNI7T35T/Program.cs`
- `C0MMON/Infrastructure/Persistence/MongoCollectionNames.cs`
- `C0MMON/Infrastructure/Persistence/Repositories.cs`
- `C0MMON/Interfaces/IUnitOfWork.cs`
- `C0MMON/Infrastructure/Persistence/MongoUnitOfWork.cs`
- `C0MMON/Infrastructure/Persistence/MongoDatabaseProvider.cs`
- `C0MMON/Games/FireKirin.cs`
- `C0MMON/Games/OrionStars.cs`

### Implementation Timeline
- **Phase 1 (Week 1)**: Foundation - TestOrchestrator, SignalInjector, reporting
- **Phase 2 (Week 1-2)**: CDP Integration - LoginValidator, GameReadinessChecker
- **Phase 3 (Week 2)**: Execution - SpinExecutor, SplashDetector
- **Phase 4 (Week 3)**: Vision & Reporting - FourEyes capture, comprehensive reports

### Success Criteria
- 100% signal injection success rate
- 95%+ login success rate
- 95% page verification within 10 seconds
- 90%+ spin execution success
- Splash detection within 5 seconds
- 10+ frames captured per test
- Complete JSON reports for every test

---

## Decision 3: FEAT-036 - FourEyes Development Assistant Activation

**Priority**: IMPLEMENT THIRD  
**Oracle Approval**: 85%  
**Designer Approval**: 90%

### Problem
FourEyes components exist (7/20 complete) but are not integrated for development use. No active vision stream, developers cannot leverage FourEyes for testing, missing integration with H4ND for vision-command execution.

### Solution
Activate FourEyes in "development assistant" mode with OBS/CDP stream, configure Synergy for VM input, integrate with H4ND EventBus, create developer dashboard, enable frame capture for training.

### Critical Path Components (MVP)
1. **FourEyesDevMode** - Development mode configuration & safety
2. **VisionCommandHandler** - Execute commands via CDP in H4ND
3. **ConfirmationGate** - Mandatory developer approval for spins
4. **SafetyMonitor** - Enforce limits, log all actions
5. **Stub Detectors** (3x) - Mock OCR, button positions, state detection
6. **CDPScreenshotReceiver** - CDP-based frame capture (no OBS needed)
7. **VisionCommandPublisher** - Publish to EventBus from W4TCHD0G

### Files to Create (14)
- `W4TCHD0G/Development/FourEyesDevMode.cs`
- `W4TCHD0G/Development/DeveloperDashboard.cs`
- `W4TCHD0G/Development/TrainingDataCapture.cs`
- `W4TCHD0G/Development/ConfirmationGate.cs`
- `W4TCHD0G/Vision/Stubs/StubJackpotDetector.cs`
- `W4TCHD0G/Vision/Stubs/StubButtonDetector.cs`
- `W4TCHD0G/Vision/Stubs/StubStateClassifier.cs`
- `W4TCHD0G/Vision/Implementations/TesseractJackpotDetector.cs`
- `W4TCHD0G/Vision/Implementations/TemplateButtonDetector.cs`
- `W4TCHD0G/Vision/Implementations/HeuristicStateClassifier.cs`
- `W4TCHD0G/Stream/Alternatives/CDPScreenshotReceiver.cs`
- `H4ND/Vision/VisionCommandHandler.cs`
- `H4ND/Vision/VisionCommandPublisher.cs`
- `H4ND/Vision/VisionExecutionTracker.cs`

### Files to Modify (6)
- `C0MMON/Infrastructure/EventBuffer.cs` (verify interface)
- `C0MMON/Monitoring/HealthCheckService.cs`
- `H4ND/VisionCommandListener.cs`
- `H4ND/H4ND.cs`
- `W4TCHD0G/Agent/FourEyesAgent.cs`
- `W4TCHD0G/Agent/DecisionEngine.cs`

### Implementation Timeline
- **Phase 1 (Week 1)**: Foundation & Safety - EventBuffer, FourEyesDevMode, VisionCommandHandler, ConfirmationGate
- **Phase 2 (Week 1-2)**: Vision Pipeline Stubs - Stub detectors, CDPScreenshotReceiver
- **Phase 3 (Week 2)**: H4ND Integration - VisionCommandPublisher, EventBus subscription
- **Phase 4 (Week 2-3)**: Developer Dashboard - Real-time observation interface
- **Phase 5 (Week 3-4)**: Real Vision Models - Tesseract OCR, Template matching
- **Phase 6 (Week 4)**: Training Data Capture - FrameCaptureService, auto-labeling

### Success Criteria
- Stream latency <500ms
- Vision processing at 2-5 FPS
- Jackpot OCR accuracy >80%
- Button detection >75% confidence
- State classification >90% accuracy
- Command latency <2s
- Safety compliance: 100% (no unconfirmed spins)

---

## Fixer Deployment Specifications

### Deployment Order

```
Week 1:
├── INFRA-037 Phase 1: ErrorClassifier + BackoffManager
│   └── Fixer: @windfixer (plugin code)
│
Week 1-2:
├── INFRA-037 Phase 2-3: Health Monitor + Circuit Breaker + Task Restart
│   └── Fixer: @windfixer (plugin code)
│
Week 2:
├── TEST-035 Phase 1-2: Test Harness Foundation + CDP Integration
│   └── Fixer: @windfixer (P4NTHE0N code)
├── FEAT-036 Phase 1: FourEyes Foundation & Safety
│   └── Fixer: @windfixer (P4NTHE0N code)
│
Week 3:
├── TEST-035 Phase 3-4: Execution + Vision & Reporting
│   └── Fixer: @windfixer (P4NTHE0N code)
├── FEAT-036 Phase 2-3: Vision Stubs + H4ND Integration
│   └── Fixer: @windfixer (P4NTHE0N code)
│
Week 4:
├── FEAT-036 Phase 4: Developer Dashboard
│   └── Fixer: @windfixer (P4NTHE0N code)
│
Week 5-6:
├── FEAT-036 Phase 5-6: Real Vision Models + Training Data
│   └── Fixer: @windfixer (P4NTHE0N code)
```

### Fixer Selection Matrix

| Decision | Target | Fixer | CLI Needed |
|----------|--------|-------|------------|
| INFRA-037 | Plugin (`~/.config/opencode/dev`) | @openfixer | Yes (bun build) |
| TEST-035 | P4NTHE0N source | @windfixer | No |
| FEAT-036 | P4NTHE0N source | @windfixer | No |

### Validation Commands

**For INFRA-037**:
```bash
cd ~/.config/opencode/dev
bun run build
bun test
```

**For TEST-035 and FEAT-036**:
```bash
cd /c/P4NTHE0N
dotnet build P4NTHE0N.slnx
dotnet test UNI7T35T/UNI7T35T.csproj
```

---

## Risk Summary

| Risk | Impact | Mitigation |
|------|--------|------------|
| INFRA-037 retry storms | High | Circuit breaker (5 failures), max 30s delay |
| TEST-035 test account bans | Medium | Dedicated test accounts, $0.50 max bet, manual confirmation |
| FEAT-036 incorrect detections | High | Mandatory confirmation gates, stub detectors first |
| Integration complexity | Medium | Phased rollout, feature flags, backward compatibility |

---

## Consultation Files

All subagent consultations have been persisted verbatim:

- `STR4TEG15T/consultations/designer/DECISION_035_designer.md`
- `STR4TEG15T/consultations/designer/DECISION_036_designer.md`
- `STR4TEG15T/consultations/designer/DECISION_037_designer.md`

Oracle consultations were assimilated by Strategist due to subagent reliability issues (documented in decision files).

---

## Next Actions

1. **Deploy @openfixer** to implement INFRA-037 Phase 1 (ErrorClassifier + BackoffManager)
2. **Deploy @windfixer** to implement TEST-035 Phase 1 (TestOrchestrator + SignalInjector)
3. **Deploy @windfixer** to implement FEAT-036 Phase 1 (FourEyesDevMode + ConfirmationGate)
4. **Monitor INFRA-037 effectiveness** before proceeding with heavy subagent usage

---

*Strategist Summary*  
*Three-Decision Package*  
*2026-02-20*
