# Four-Eyes Vision System: Final Master Plan
## Designer (94/100) + Oracle (71/100) Validated

**Status**: CONDITIONAL APPROVAL  
**MVP Timeline**: 2-3 weeks (Oracle: recommend 3)  
**Total Decisions**: 24 (20 original + 4 from Designer/Oracle)  
**Production Ready**: After critical risk shields implemented

---

## Assessment Summary

### Designer (Aegis): 94/100 - Architecture Excellence
- ✅ **Verdict**: Production-ready architecture
- ✅ **Confidence**: High (94%)
- ✅ **Strengths**: Solid patterns, clean separation, proper resilience
- ⚠️ **Issue**: Interface placement (70/100)
- 📋 **Gaps**: Audit trail, rate limiting

### Oracle (Orion): 71/100 - Risk Assessment
- ⚠️ **Verdict**: Conditional approval
- ⚠️ **Confidence**: Conditional
- ✅ **Strengths**: Foundation is solid
- 🔴 **Issues**: 3 critical risk mitigations have ZERO CODE
- 📋 **Required**: Shadow Gauntlet, Cerberus Protocol, Interface Migration, Audit Trail

### Gap Analysis: 23-Point Difference
**Not a disagreement** - both are correct:
- **Designer**: "The architecture is production-ready" (what's built)
- **Oracle**: "The risk shields are not" (what's missing)

**Solution**: Build the missing risk shields.

---

## UPDATED Decision Inventory (24 Total)

### ✅ FOUNDATION COMPLETE (7) - Production Ready

| ID | Decision | File | Lines | Status | Used By |
|----|----------|------|-------|--------|---------|
| FOUREYES-001 | Circuit Breaker | Resilience/CircuitBreaker.cs | 199 | ✅ Complete | H0UND.cs:33-44, 118-124 |
| FOUREYES-002 | Degradation Manager | Resilience/SystemDegradationManager.cs | 44 | ✅ Complete | H0UND.cs:43 |
| FOUREYES-003 | Operation Tracker | Resilience/OperationTracker.cs | 44 | ✅ Complete | H0UND.cs:44 |
| FOUREYES-005 | OBS Vision Bridge | W4TCHD0G/OBSVisionBridge.cs | 119 | ✅ Complete | FourEyesAgent |
| FOUREYES-006 | LM Studio Client | LMStudioClient.cs + ModelRouter.cs | 254 | ✅ Complete | FourEyesAgent |
| FOUREYES-008 | Vision Decision Engine | H0UND/Services/VisionDecisionEngine.cs | 108 | ✅ Complete | DecisionEngine |
| FOUREYES-012 | Stream Health Monitor | Stream/StreamHealthMonitor.cs | 270 | ✅ Complete | FourEyesAgent |

**Integration Points**:
```
H0UND.cs:33-44    → Circuit breakers + degradation + tracker instantiated
H0UND.cs:118-124  → Circuit breaker wraps API polling
FourEyesAgent     → Full pipeline orchestration
```

---

### 🔄 PARTIAL (5) - Finish These First

| ID | Decision | Current State | Required Action | Risk |
|----|----------|---------------|-----------------|------|
| FOUREYES-004 | Vision Stream Health Check | Placeholder (lines 97-100) | Wire to IOBSClient | Medium |
| FOUREYES-007 | Event Buffer | Placeholder (7 lines) | ConcurrentQueue impl | Medium |
| FOUREYES-011 | Unbreakable Contract | Interfaces in wrong place | Migrate to C0MMON | **Critical** |
| FOUREYES-013 | Model Manager | Routing only | Add HF download | Medium |
| FOUREYES-021 | **Interface Migration** | NEW | Move IOBSClient, ILMStudioClient | **Critical** |

**Oracle on FOUREYES-021**: "Without this, H0UND/H4ND can't use vision interfaces without circular dependency. CRITICAL for production."

---

### 🔴 CRITICAL RISK SHIELDS (4) - Oracle Priority

| ID | Decision | Status | Oracle Assessment | Impact |
|----|----------|--------|-------------------|--------|
| FOUREYES-009 | **Shadow Gauntlet** | ❌ ZERO CODE | 30-40% hallucination risk | **$500-5000** |
| FOUREYES-010 | **Cerberus Protocol** | ❌ ZERO CODE | No self-healing on OBS failure | **System stop** |
| FOUREYES-021 | **Interface Migration** | ❌ Not started | Circular dependencies | **Hard to test** |
| FOUREYES-022 | **Decision Audit Trail** | ❌ Not in framework | No debugging capability | **No trust** |

**Oracle**: "These 4 must be in MVP, not post-MVP."

---

### 📋 CORE INTEGRATION (3)

| ID | Decision | Status | Priority | Notes |
|----|----------|--------|----------|-------|
| FOUREYES-015 | H4ND Vision Command Integration | Not started | **Critical** | Extend Signal entity |
| FOUREYES-022 | Decision Audit Trail | Not in framework | **High** | NEW (Oracle) |
| FOUREYES-023 | Rate Limiting | Not started | High | NEW (Designer) |

---

### 📋 AUTONOMY (3) - Post-MVP

| ID | Decision | Status | Priority |
|----|----------|--------|----------|
| FOUREYES-014 | Autonomous Learning System | Not started | Medium |
| FOUREYES-016 | Redundant Vision System | Not started | Low |
| FOUREYES-019 | Phased Rollout Manager | Not started | Low |

---

### 📋 PRODUCTION (4) - Post-MVP

| ID | Decision | Status | Priority |
|----|----------|--------|----------|
| FOUREYES-017 | Production Metrics | Not started | Medium |
| FOUREYES-018 | Rollback Manager | Not started | Medium |
| FOUREYES-019 | Phased Rollout Manager | Not started | Low |
| FOUREYES-020 | Unit Test Suite | Not started | **Critical** |

---

## Critical Risk Analysis

### Risk 1: Model Hallucination (HIGH) 🔴

**Probability**: 30-40%  
**Impact**: $500-5000 in incorrect spins  
**Status**: NOT MITIGATED

**The Problem**:
```
TROCR reads: "Grand: $1,785" → Correct
TROCR reads: "Grand: $17,850" → Hallucination (extra digit)
System: "95% threshold! SIGNAL!"
Result: Spins on non-existent opportunity
Loss: 10 spins × $5 = $50
```

**Mitigation** (CHOOSE ONE):
1. ✅ **Shadow Gauntlet** (FOUREYES-009): 24-hour validation
2. ✅ **Confidence threshold 0.95+**: With manual review
3. ⚠️ **Do nothing**: Accept 30-40% risk (Oracle: NOT RECOMMENDED)

**Oracle Recommendation**: Implement Shadow Gauntlet OR use 0.95 threshold.

---

### Risk 2: OBS Stream Failure (MEDIUM-HIGH) 🟠

**Probability**: 20-30%  
**Impact**: Loss of vision capability  
**Status**: PARTIALLY MITIGATED

**Current State**:
- ✅ StreamHealthMonitor detects failures
- ❌ Cerberus Protocol: ZERO CODE
- ❌ No automatic restart
- ❌ No fallback to polling

**Timeline**:
```
T+0: OBS crashes
T+0.5: StreamHealthMonitor detects
T+1: OnHealthChanged fires
T+...: HUMAN MUST INTERVENE
```

**Mitigation**:
1. ✅ **Cerberus Protocol** (FOUREYES-010): 3-headed healing
2. Alert timing: Oracle says 1 failure, not 3

**Oracle**: "Alert after 1 failure, not waiting for 3."

---

### Risk 3: Integration Coupling (MEDIUM) 🟡

**Status**: PARTIALLY MITIGATED  
**Problem**: Interfaces in W4TCHD0G/, not C0MMON/Interfaces/

**Current (Wrong)**:
```
H0UND → C0MMON
H0UND → W4TCHD0G (to use interfaces) ❌ Circular!
H4ND → C0MMON
H4ND → W4TCHD0G (to use interfaces) ❌ Circular!
```

**Required (Correct)**:
```
C0MMON/Interfaces ← H0UND
C0MMON/Interfaces ← H4ND
C0MMON/Interfaces ← W4TCHD0G
```

**Mitigation**: FOUREYES-021 (Interface Migration)

---

## MVP Timeline

### Oracle Recommended: 3 Weeks (not 2)

**Week 1: Critical Foundation**
- [ ] **Day 1-2**: FOUREYES-021 Interface Migration (Critical)
  - Move IOBSClient.cs → C0MMON/Interfaces/
  - Move ILMStudioClient.cs → C0MMON/Interfaces/
  - Create IVisionDecisionEngine.cs
  - Update all references
  
- [ ] **Day 2-3**: FOUREYES-007 EventBuffer (Critical)
  - Implement with ConcurrentQueue
  - Capacity: 15 (5 seconds at 3 FPS)
  - Methods: Add(), GetRecent(), GetLatest()

- [ ] **Day 3**: FOUREYES-004 Health Check Integration (Critical)
  - Wire CheckVisionStreamHealth() to IOBSClient
  - Return real OBS status

- [ ] **Day 4-5**: FOUREYES-022 Decision Audit Trail (Critical - NEW)
  - VisionDecisionLogger class
  - EventLog integration
  - Decision serialization

**Week 2: Risk Shields**
- [ ] **Day 1-3**: FOUREYES-009 Shadow Gauntlet OR Confidence Threshold
  - Option A: Full Shadow Gauntlet implementation
  - Option B: 0.95 confidence + manual review (faster)

- [ ] **Day 3-5**: FOUREYES-010 Cerberus Protocol (Critical)
  - Head 1: OBS restart
  - Head 2: Scene verification
  - Head 3: Fallback to polling
  - Alert after 1 failure (not 3)

**Week 3: Integration & Testing**
- [ ] **Day 1-2**: FOUREYES-015 H4ND Vision Commands (Critical)
  - Extend Signal entity with SignalSource
  - H4ND processes vision commands
  - Test command flow

- [ ] **Day 2-4**: FOUREYES-020 Unit Test Suite (Critical)
  - UNI7T35T/FourEyes/ directory
  - EventBufferTests, VisionDecisionEngineTests
  - Mock implementations
  - Target: 80% coverage

- [ ] **Day 5**: Integration testing
  - End-to-end pipeline test
  - Performance validation (3 FPS)
  - Bug fixes

---

## Production Readiness Checklist

### Must Have (Before Production)
- [ ] FOUREYES-021: Interface Migration to C0MMON/Interfaces/ (Critical)
- [ ] FOUREYES-009: Shadow Gauntlet OR 0.95 confidence threshold (Critical)
- [ ] FOUREYES-010: Cerberus Protocol with 1-failure alerting (Critical)
- [ ] FOUREYES-022: Decision Audit Trail (Critical)
- [ ] FOUREYES-007: EventBuffer implementation (Critical)
- [ ] FOUREYES-004: Health Check integration (Critical)
- [ ] FOUREYES-015: H4ND Command Integration (Critical)
- [ ] FOUREYES-020: Unit test baseline 80% (Critical)
- [ ] FPS increased to 3 (from 2)
- [ ] Monitoring dashboard operational

### Should Have (Post-MVP)
- [ ] FOUREYES-014: Autonomous Learning System
- [ ] FOUREYES-023: Rate Limiting for LM Studio
- [ ] FOUREYES-017: Production Metrics (InfluxDB/Grafana)
- [ ] FOUREYES-018: Rollback Manager

### Nice to Have (Future)
- [ ] FOUREYES-016: Redundant Vision System
- [ ] FOUREYES-019: Phased Rollout Manager
- [ ] FOUREYES-013: Model Manager with HF download

---

## Monitoring Requirements (Oracle Specified)

### Metrics to Monitor

| Metric | Target | Alert Threshold | Action |
|--------|--------|-----------------|--------|
| VisionStreamUptime | >99.9% | <99% | Disable vision |
| OCRAccuracy | >95% | <90% | Alert operator |
| DecisionLatency | <100ms | >200ms | Scale resources |
| ModelInferenceTime | <300ms | >500ms | Check LM Studio |
| SignalAccuracy | >85% | <70% | Alert Nexus |
| CircuitBreakerOpen | 0/min | >1/min | Investigate |
| OBSConnectionFail | 0/hr | >1/hr | Alert Nexus |

### Alert Escalation

| Severity | Condition | Response | Action |
|----------|-----------|----------|--------|
| **CRITICAL** | OBS disconnect, Model accuracy <70% | Immediate | Disable vision, alert Nexus |
| **HIGH** | Decision latency >200ms, FPS <20 | 5 minutes | Scale resources, alert operator |
| **MEDIUM** | CircuitBreaker open | 15 minutes | Investigate, log |
| **LOW** | Warnings | 1 hour | Monitor, review |

---

## Key Design Decisions

### 1. Frame Rate: 2 → 3 FPS ✅
- **Designer**: Recommends 3-5 FPS
- **Oracle**: 3 FPS reduces missed event probability from 20% to 8%
- **Implementation**: Change VisionConfig.FrameRate from 2 to 3

### 2. EventBuffer: ConcurrentQueue ✅
- **Designer**: Use ConcurrentQueue (not List+lock)
- **Oracle**: Concurs
- **Rationale**: Lock-free, better performance
- **Capacity**: 15 (5 seconds at 3 FPS)

### 3. H4ND Integration: Extend Signal Entity ✅
- **Designer**: Extend Signal with Source enum (Polling/Vision/Manual)
- **Oracle**: Concurs, prevents race conditions
- **Alternative**: Separate queue (rejected - more complex)

### 4. Interface Location: C0MMON/Interfaces/ 🔴
- **Designer**: 70/100 for current placement
- **Oracle**: CRITICAL - prevents circular dependencies
- **Action**: FOUREYES-021 must be in MVP

### 5. Model Validation: Shadow Gauntlet OR 0.95 Threshold 🔴
- **Designer**: Shadow Gauntlet for long-term
- **Oracle**: 30-40% hallucination risk without it
- **Short-term**: 0.95 confidence + manual review
- **Long-term**: Full Shadow Gauntlet

---

## Documentation Reference

| Document | Location | Contains |
|----------|----------|----------|
| Decision Framework | T4CT1CS/decisions/active/FOUREYES_DECISION_FRAMEWORK.md | 24 decisions |
| Codebase Reference | T4CT1CS/decisions/active/FOUREYES_CODEBASE_REFERENCE.md | File-by-file status |
| Designer Assessment | T4CT1CS/intel/DESIGNER_ASSESSMENT_FOUREYES.md | 94/100 review |
| Oracle Assessment | T4CT1CS/intel/ORACLE_ASSESSMENT_FOUREYES.md | 71/100 risk analysis |
| Fixer Brief v2 | T4CT1CS/actions/pending/FIXER_BRIEF_v2.md | Implementation guide |
| This Document | T4CT1CS/auto/daily/2026-02-18-FINAL-MASTER-PLAN.md | Master plan |

---

## Final Verdict

### Designer Says: "Architecture is production-ready" (94/100)
### Oracle Says: "With risk shields, system is production-ready" (71/100)

**Synthesis**: Build the 4 critical risk shields, then deploy.

**Timeline**: 
- **2 weeks**: Aggressive (Oracle: not recommended)
- **3 weeks**: Conservative (Oracle: recommended)
- **4 weeks**: Safe (with buffer)

**Confidence After Mitigations**: 90%+

---

## Next Actions

1. **@fixer**: Start FOUREYES-021 (Interface Migration) - Day 1
2. **@fixer**: Implement FOUREYES-007 (EventBuffer) - Day 2
3. **@fixer**: Wire FOUREYES-004 (Health Check) - Day 3
4. **@fixer**: Build FOUREYES-022 (Audit Trail) - Day 4-5
5. **@strategist**: Monitor progress, update decisions
6. **@oracle**: Review weekly, pre-production sign-off

---

*Plan validated by Designer (94/100) and Oracle (71/100)*  
*Conditional approval granted*  
*Ready for implementation with expanded scope*  
*2026-02-18*
