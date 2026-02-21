# Four-Eyes Vision System - Decision Framework

## Executive Summary

I have assimilated the comprehensive plan from 5 strategic documents and created a complete decision framework for the Four-Eyes vision system pivot. This represents a 5-phase migration from polling-based signal generation to autonomous vision-based decision making.

**Oracle Approval: 92%** - Validated by Orion with identified risks and mitigations captured.

---

## Decision Inventory

### Phase 1: Production Hardening & Foundation (Weeks 1-2)

| ID | Decision | Status | Priority | Project |
|----|----------|--------|----------|---------|
| FOUREYES-001 | Circuit Breaker Pattern | **InProgress** | Critical | C0MMON |
| FOUREYES-002 | System Degradation Manager | **InProgress** | Critical | C0MMON |
| FOUREYES-003 | Operation Tracker (Idempotency) | **InProgress** | Critical | C0MMON |
| FOUREYES-004 | Vision Stream Health Check | Proposed | High | H0UND |
| FOUREYES-005 | OBS Vision Bridge | **InProgress** | Critical | W4TCHD0G |
| FOUREYES-006 | LM Studio Client | Proposed | Critical | W4TCHD0G |

**Parallel Tracks:**
- **Track 1 (H0UND)**: Vision Health Checks
- **Track 2 (C0MMON)**: Core Hardening Components
- **Track 3 (W4TCHD0G)**: OBS & LM Studio Integration

### Phase 2: Vision Decision Engine (Weeks 3-4)

| ID | Decision | Status | Priority | Project |
|----|----------|--------|----------|---------|
| FOUREYES-007 | Event Buffer (Temporal Memory) | Proposed | High | C0MMON |
| FOUREYES-008 | Vision Decision Engine | Proposed | Critical | H0UND |

**Parallel Tracks:**
- **Track 1 (H0UND)**: Vision Decision Engine (the brain)
- **Track 2 (C0MMON)**: Event Buffer (the memory)

### Phase 3: Risk Annihilation (Weeks 5-6)

| ID | Decision | Status | Priority | Project |
|----|----------|--------|----------|---------|
| FOUREYES-009 | Shadow Gauntlet | Proposed | High | PROF3T |
| FOUREYES-010 | Cerberus Protocol | Proposed | High | W4TCHD0G |
| FOUREYES-011 | Unbreakable Contract | Proposed | High | C0MMON |
| FOUREYES-012 | Stream Health Monitor | Proposed | High | W4TCHD0G |

**Risk Mitigations:**
1. **Shadow Gauntlet**: Model validation before promotion (>95% accuracy, 10% lower latency)
2. **Cerberus Protocol**: OBS self-healing with 3-headed response
3. **Unbreakable Contract**: Strict interfaces and API versioning
4. **Stream Health Monitor**: Automatic fallback on stream failures

### Phase 4: Autonomous Learning (Weeks 7-8)

| ID | Decision | Status | Priority | Project |
|----|----------|--------|----------|---------|
| FOUREYES-013 | Model Manager | Proposed | High | PROF3T |
| FOUREYES-014 | Autonomous Learning System | Proposed | High | PROF3T |
| FOUREYES-015 | H4ND Vision Command Integration | Proposed | High | H4ND |
| FOUREYES-016 | Redundant Vision System | Proposed | Medium | W4TCHD0G |

### Phase 5: Deployment (Weeks 9-10)

| ID | Decision | Status | Priority | Project |
|----|----------|--------|----------|---------|
| FOUREYES-017 | Production Metrics & Monitoring | Proposed | High | H0UND |
| FOUREYES-018 | Rollback Manager | Proposed | High | H0UND |
| FOUREYES-019 | Phased Rollout Strategy | Proposed | High | H0UND |
| FOUREYES-020 | Comprehensive Unit Test Suite | Proposed | Critical | UNI7T35T |

---

## Implementation Dependency Graph

```
Phase 1 (Foundation)
├── FOUREYES-001 (Circuit Breaker) ──┐
├── FOUREYES-002 (Degradation) ──────┤
├── FOUREYES-003 (Idempotency) ──────┤
├── FOUREYES-004 (Health Check) ─────┤
├── FOUREYES-005 (OBS Bridge) ───────┤
└── FOUREYES-006 (LM Studio) ────────┘
              │
              ▼
Phase 2 (Vision Brain)
├── FOUREYES-007 (Event Buffer) ─────┐
└── FOUREYES-008 (Decision Engine) ──┘
              │
              ▼
Phase 3 (Risk Mitigation)
├── FOUREYES-009 (Shadow Gauntlet) ──┐
├── FOUREYES-010 (Cerberus) ─────────┤
├── FOUREYES-011 (Contracts) ────────┤
└── FOUREYES-012 (Health Monitor) ───┘
              │
              ▼
Phase 4 (Autonomy)
├── FOUREYES-013 (Model Manager) ────┐
├── FOUREYES-014 (Learning System) ──┤
├── FOUREYES-015 (H4ND Commands) ────┤
└── FOUREYES-016 (Redundancy) ───────┘
              │
              ▼
Phase 5 (Deployment)
├── FOUREYES-017 (Metrics) ──────────┐
├── FOUREYES-018 (Rollback) ─────────┤
├── FOUREYES-019 (Rollout) ──────────┤
└── FOUREYES-020 (Tests) ────────────┘
```

---

## Action Items Summary

**Total Action Items: 60+**

### Critical Priority (10/10)
- CircuitBreaker core implementation
- SystemDegradationManager implementation
- OperationTracker implementation
- OBSVisionBridge WebSocket client
- VisionDecisionEngine main loop
- Unit test suite foundation

### High Priority (9/10)
- Health check integration
- LM Studio client
- Event buffer
- Detection algorithms
- Shadow mode validation
- Cerberus protocol
- Interface definitions
- Model management
- Autonomous learning
- H4ND command integration
- Metrics collection
- Rollback manager
- Rollout orchestration

---

## Unit Test Strategy

Per Nexus requirement: **Each migration unit tested so problems found early.**

### Test Coverage by Decision

| Decision | Test Files |
|----------|------------|
| FOUREYES-001 | CircuitBreakerTests.cs - All states |
| FOUREYES-002 | SystemDegradationManagerTests.cs - All levels |
| FOUREYES-003 | OperationTrackerTests.cs - Deduplication |
| FOUREYES-005 | OBSVisionBridgeTests.cs - WebSocket |
| FOUREYES-006 | LMStudioClientTests.cs - Routing |
| FOUREYES-007 | EventBufferTests.cs - Thread safety |
| FOUREYES-008 | VisionDecisionEngineTests.cs - Detection |
| FOUREYES-009 | ShadowModeManagerTests.cs - Validation |
| FOUREYES-010 | OBSHealerTests.cs - Protocol |
| FOUREYES-014 | AutonomousLearningSystemTests.cs |
| FOUREYES-015 | VisionCommandListenerTests.cs |

### Integration Tests
- VisionIntegrationTests.cs - End-to-end pipeline
- FullSystemTests.cs - All components together

---

## Rollout Strategy

### Phase 1: Foundation (In Progress)
**Timeline**: Immediate - Week 2
**Track Execution**: 3 parallel tracks with @fixer
**Success Criteria**:
- Circuit breaker operational
- Degradation levels functional
- Idempotency guaranteed
- OBS bridge connected
- LM Studio responding

### Phase 2: Brain (Ready to Start)
**Timeline**: Week 3-4
**Dependencies**: Phase 1 complete
**Success Criteria**:
- Event buffer operational
- Decision engine analyzing streams
- Temporal patterns detected
- Signals generated from vision

### Phase 3: Risk Mitigation (Planned)
**Timeline**: Week 5-6
**Addresses Oracle Concerns**:
- Model drift → Shadow Gauntlet
- OBS instability → Cerberus Protocol
- Integration complexity → Unbreakable Contract

### Phase 4: Autonomy (Planned)
**Timeline**: Week 7-8
**Capabilities**:
- Model self-management
- Performance-based improvements
- H4ND command integration
- Multi-stream redundancy

### Phase 5: Deployment (Planned)
**Timeline**: Week 9-10
**Rollout**:
1. Canary: 10% for 24 hours
2. Gradual: 50% for 48 hours
3. Full: 100%

---

## Key Technologies

### Vision Models (Hugging Face)
| Model | Purpose | Size | Latency |
|-------|---------|------|---------|
| microsoft/trocr-base-handwritten | OCR (jackpot values) | 58MB | <100ms |
| microsoft/dit-base-finetuned | UI state detection | 1.5GB | <50ms |
| nvidia/nvdino | Animation detection | 600MB | <30ms |
| google/owlvit-base-patch32 | Error detection | 1.1GB | <40ms |

### Infrastructure
- **OBS Studio**: WebSocket on localhost:4455
- **LM Studio**: Local inference engine
- **InfluxDB**: Time-series metrics
- **Grafana**: Dashboard visualization

---

## Risk Mitigations (Oracle Approved)

### 1. Model Drift / Hallucination
**Mitigation**: Shadow Gauntlet
- 24-hour shadow mode
- >95% accuracy required
- 10% latency improvement required
- Automatic promotion/rejection

### 2. OBS Stream Instability
**Mitigation**: Cerberus Protocol
- Continuous monitoring
- 3-headed response (restart, verify, fallback)
- Automatic polling fallback
- Nexus alerting

### 3. Integration Complexity
**Mitigation**: Unbreakable Contract
- Strict interfaces in C0MMON
- OpenAPI spec
- DI enforcement
- No direct class dependencies

---

## Next Actions

1. **@fixer** begins implementation of Phase 1 Critical decisions:
   - FOUREYES-001: Circuit Breaker
   - FOUREYES-002: System Degradation Manager
   - FOUREYES-003: Operation Tracker
   - FOUREYES-005: OBS Vision Bridge

2. **Unit tests** written with each implementation

3. **Integration** as components complete

4. **Phase 2** begins upon Phase 1 completion

---

## Success Metrics

### Technical
- [ ] 99.9% vision stream uptime
- [ ] >95% OCR accuracy
- [ ] <100ms decision latency
- [ ] 100% idempotency guarantee
- [ ] Automatic recovery <30 seconds

### Operational
- [ ] 0 double-spins
- [ ] 0 cascading failures
- [ ] Graceful degradation functional
- [ ] All unit tests passing
- [ ] Integration tests passing

---

*Generated: 2026-02-18*
*Strategist: Four-Eyes Vision System Pivot*
*Total Decisions: 20*
*Total Action Items: 60+*
*Estimated Duration: 10 weeks*
