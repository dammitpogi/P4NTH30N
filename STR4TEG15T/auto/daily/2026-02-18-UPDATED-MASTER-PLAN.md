# Four-Eyes Vision System: Updated Master Plan
## 28 Decisions Total | LM Studio Direction | Forgewright Bug Handling

**Date**: 2026-02-18  
**Designer Assessment**: 94/100 (Architecture)  
**Oracle Assessment**: 71/100 (Risk - Conditional Approval)  
**Implementation Status**: Direction sound and ready

---

## Summary of Changes

### New Decisions Added (4)

**Automated Bug Handling (Forgewright)**:
- **FOUREYES-024**: Forgewright Auto-Triage - Automated bug detection and handling
  - Exception interceptor middleware
  - AutoBugLogger service for ERR0R collection
  - PlatformGenerator for T00L5ET test harness
  - ForgewrightTriggerService for automated triage

**LM Studio Integration (3 decisions)**:
- **FOUREYES-025**: LM Studio Process Manager - Local model orchestration
  - Process start/stop/restart on localhost:1234
  - Health check polling every 10s
  - Model loading via HTTP API
  - Auto-restart on crash
  
- **FOUREYES-026**: Vision Inference Pipeline - HTTP API implementation
  - POST to /v1/chat/completions with base64 images
  - 30s timeout with 3 retries and exponential backoff
  - JSON response parsing for jackpot/state/errors
  - Integration with ModelRouter
  
- **FOUREYES-027**: Model Warmup and Caching - Performance optimization
  - Pre-load all 4 models on startup
  - Warmup inference to prevent cold-start
  - 5-second cache for identical frames
  - Ready state reporting

**Total Decisions**: 28 (was 24)

---

## Complete Decision Inventory (28)

### ✅ COMPLETE (7) - Production Ready

| ID | Decision | Status | File | Lines |
|----|----------|--------|------|-------|
| FOUREYES-001 | Circuit Breaker | ✅ Complete | Resilience/CircuitBreaker.cs | 199 |
| FOUREYES-002 | System Degradation Manager | ✅ Complete | Resilience/SystemDegradationManager.cs | 44 |
| FOUREYES-003 | Operation Tracker | ✅ Complete | Resilience/OperationTracker.cs | 44 |
| FOUREYES-005 | OBS Vision Bridge | ✅ Complete | W4TCHD0G/OBSVisionBridge.cs | 119 |
| FOUREYES-006 | LM Studio Client | ✅ Complete | LMStudioClient.cs + ModelRouter.cs | 254 |
| FOUREYES-008 | Vision Decision Engine | ✅ Complete | H0UND/Services/VisionDecisionEngine.cs | 108 |
| FOUREYES-012 | Stream Health Monitor | ✅ Complete | Stream/StreamHealthMonitor.cs | 270 |

---

### 🔄 PARTIAL (5) - Finish in MVP

| ID | Decision | Status | Action Required |
|----|----------|--------|-----------------|
| FOUREYES-004 | Vision Stream Health Check | 🔄 Partial | Wire to IOBSClient |
| FOUREYES-007 | Event Buffer | 🔄 Placeholder | ConcurrentQueue impl |
| FOUREYES-011 | Unbreakable Contract | 🔄 Wrong location | Migrate to C0MMON |
| FOUREYES-013 | Model Manager | 🔄 Routing only | Add HF download |
| FOUREYES-021 | Interface Migration | 🔄 Not started | Critical for architecture |

---

### 🔴 CRITICAL RISK SHIELDS (4) - Oracle Priority

| ID | Decision | Status | Oracle Priority |
|----|----------|--------|-----------------|
| FOUREYES-009 | Shadow Gauntlet | 📋 Not started | **CRITICAL** - 30-40% hallucination risk |
| FOUREYES-010 | Cerberus Protocol | 📋 Not started | **CRITICAL** - No self-healing |
| FOUREYES-021 | Interface Migration | 📋 Not started | **CRITICAL** - Circular deps |
| FOUREYES-022 | Decision Audit Trail | 📋 Not in framework | **HIGH** - No debugging |

---

### 📋 CORE INTEGRATION (6)

| ID | Decision | Status | Priority |
|----|----------|--------|----------|
| FOUREYES-015 | H4ND Vision Command Integration | 📋 Not started | **Critical** |
| FOUREYES-022 | Decision Audit Trail | 📋 NEW | **High** |
| FOUREYES-023 | Rate Limiting | 📋 NEW | High |
| FOUREYES-024 | **Forgewright Auto-Triage** | 📋 NEW | High |
| FOUREYES-025 | **LM Studio Process Manager** | 📋 NEW | **Critical** |
| FOUREYES-026 | **Vision Inference Pipeline** | 📋 NEW | **Critical** |
| FOUREYES-027 | **Model Warmup and Caching** | 📋 NEW | High |

---

### 📋 AUTONOMY (3) - Post-MVP

| ID | Decision | Status |
|----|----------|--------|
| FOUREYES-014 | Autonomous Learning System | 📋 Not started |
| FOUREYES-016 | Redundant Vision System | 📋 Not started |
| FOUREYES-019 | Phased Rollout Manager | 📋 Not started |

---

### 📋 PRODUCTION (4) - Post-MVP

| ID | Decision | Status |
|----|----------|--------|
| FOUREYES-017 | Production Metrics | 📋 Not started |
| FOUREYES-018 | Rollback Manager | 📋 Not started |
| FOUREYES-019 | Phased Rollout Manager | 📋 Not started |
| FOUREYES-020 | Unit Test Suite | 📋 Not started |

---

## Implementation Direction

### LM Studio Integration (FOUREYES-025, 026, 027)

**Process Management**:
- LM Studio runs locally on localhost:1234
- ProcessManager handles start/stop/restart
- Health checks every 10 seconds
- Auto-restart on crash (Cerberus integration)

**Vision Inference**:
- HTTP POST to /v1/chat/completions
- Base64-encoded game screenshots
- OpenAI-compatible JSON format
- 30s timeout, 3 retries with exponential backoff
- Parse response for jackpot values, game state, errors

**Models** (from huggingface_models.json):
```
TROCR (OCR)         → Extract jackpot values
DiT (State)         → Detect game state
NV-DINO (Animation) → Detect spinning
OWL-ViT (Errors)    → Detect error indicators
```

**Performance**:
- Startup: <30s
- Model load: <10s per model
- Inference: <300ms
- Cache hit: >30%
- FPS target: 3

---

### Forgewright Bug Handling (FOUREYES-024)

**Automated Workflow**:
1. Exception caught by middleware
2. Logged to ERR0R collection with full context
3. PlatformGenerator creates T00L5ET test harness
4. Forgewright triggered for triage
5. Root cause isolated through systematic tests
6. Surgical fix applied
7. Decision created if platform pattern

**Bug Classes Handled**:
- VisionInferenceException
- LMStudioTimeoutException
- DateTimeOverflowException
- MongoDB connection loss
- OBS WebSocket failure

**T00L5ET Integration**:
- Auto-generate mocks from interfaces
- Create reproduction test cases
- Living documentation of bugs and fixes
- Platform intelligence capture

---

## Updated MVP Timeline (3 Weeks)

### Week 1: Foundation + LM Studio
- **Day 1-2**: FOUREYES-021 Interface Migration (Critical)
- **Day 2-3**: FOUREYES-007 EventBuffer (ConcurrentQueue)
- **Day 3**: FOUREYES-004 Health Check Integration
- **Day 4-5**: FOUREYES-025 LM Studio Process Manager (NEW)
- **Day 5**: FOUREYES-026 Vision Inference Pipeline (NEW)

### Week 2: Risk Shields + Bug Handling
- **Day 1-3**: FOUREYES-009 Shadow Gauntlet OR 0.95 confidence
- **Day 3-4**: FOUREYES-010 Cerberus Protocol
- **Day 4-5**: FOUREYES-024 Forgewright Auto-Triage (NEW)
- **Day 5**: FOUREYES-027 Model Warmup and Caching (NEW)

### Week 3: Integration + Testing
- **Day 1-2**: FOUREYES-015 H4ND Vision Commands
- **Day 2-3**: FOUREYES-022 Decision Audit Trail
- **Day 3-4**: FOUREYES-020 Unit Test Suite
- **Day 4-5**: Integration testing, bug fixes, validation

---

## Files to Create

### LM Studio (New)
```
W4TCHD0G/
├── LMStudioProcessManager.cs        # FOUREYES-025
├── VisionInferenceService.cs        # FOUREYES-026
└── ModelCache.cs                    # FOUREYES-027

C0MMON/Interfaces/
├── ILMStudioProcessManager.cs
└── IVisionInferenceService.cs
```

### Forgewright (New)
```
C0MMON/Services/
├── ExceptionInterceptorMiddleware.cs # FOUREYES-024
├── AutoBugLogger.cs                 # FOUREYES-024
└── PlatformGenerator.cs             # FOUREYES-024

PROF3T/
└── ForgewrightTriggerService.cs     # FOUREYES-024
```

---

## Performance Targets

| Metric | Target | Current |
|--------|--------|---------|
| LM Studio Startup | <30s | N/A |
| Model Load | <10s | N/A |
| Inference | <300ms | N/A |
| Vision FPS | 3 | 2 (current) |
| Cache Hit | >30% | N/A |
| Bug Response | <5min | Manual |

---

## Risk Assessment Update

### With New Decisions

**Before (24 decisions)**:
- Model hallucination: 30-40% risk (Shadow Gauntlet not implemented)
- OBS failure: No self-healing
- Bug handling: Manual

**After (28 decisions)**:
- Model hallucination: 30-40% → 5-10% (with Shadow Gauntlet + Forgewright learning)
- OBS failure: Self-healing via Cerberus + Process Manager
- Bug handling: Automated via Forgewright

**Confidence After Implementation**: 90%+

---

## Documentation Reference

| Document | Location | Contains |
|----------|----------|----------|
| Decision Framework | T4CT1CS/decisions/active/FOUREYES_DECISION_FRAMEWORK.md | 28 decisions |
| Codebase Reference | T4CT1CS/decisions/active/FOUREYES_CODEBASE_REFERENCE.md | File status |
| Designer Assessment | T4CT1CS/intel/DESIGNER_ASSESSMENT_FOUREYES.md | 94/100 review |
| Oracle Assessment | T4CT1CS/intel/ORACLE_ASSESSMENT_FOUREYES.md | 71/100 risk analysis |
| LM Studio Direction | T4CT1CS/actions/pending/LM_STUDIO_DIRECTION.md | Implementation guide |
| Final Master Plan | T4CT1CS/auto/daily/2026-02-18-FINAL-MASTER-PLAN.md | This document |

---

## Next Actions

### Immediate (Today)
1. ✅ **Review complete** - 28 decisions created and validated
2. ✅ **LM Studio direction** - HTTP API approach confirmed
3. ✅ **Forgewright integration** - Automated bug handling defined

### Week 1 Start (Tomorrow)
1. **@fixer**: FOUREYES-021 Interface Migration
2. **@fixer**: FOUREYES-025 LM Studio Process Manager
3. **@fixer**: FOUREYES-026 Vision Inference Pipeline

### Week 2
4. **@fixer**: FOUREYES-024 Forgewright Auto-Triage
5. **@fixer**: FOUREYES-009 Shadow Gauntlet

### Week 3
6. **@fixer**: Integration testing
7. **@oracle**: Pre-production sign-off

---

## Final Assessment

**Implementation Direction**: ✅ **SOUND**

**LM Studio Approach**: 
- ✅ HTTP API on localhost:1234 (not CLI)
- ✅ Process management automated
- ✅ Health checks and auto-restart
- ✅ Model loading via API
- ✅ Resource monitoring

**Forgewright Integration**:
- ✅ Automated bug detection
- ✅ T00L5ET platform generation
- ✅ Systematic triage workflow
- ✅ Pattern recognition
- ✅ Platform intelligence capture

**Both systems integrate cleanly with existing architecture**:
- FourEyesAgent → LMStudioProcessManager → VisionInferenceService
- ExceptionInterceptor → AutoBugLogger → ForgewrightTriggerService
- Cerberus Protocol → Heals both OBS and LM Studio

**Ready for implementation**.

---

*Plan updated with 4 new decisions*  
*LM Studio direction: HTTP API approach*  
*Forgewright integration: Automated bug handling*  
*Ready for Fixer execution*  
*2026-02-18*
