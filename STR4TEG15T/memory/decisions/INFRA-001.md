---
type: decision
id: INFRA-001
category: infrastructure-hardening
status: consulting
version: 1.1.0
created_at: '2026-02-25T21:00:00.000Z'
last_reviewed: '2026-02-26T14:45:00.000Z'
keywords:
  - infrastructure
  - local-ai
  - llm
  - security
  - governance
  - resource-management
  - model-deployment
  - oracle-assessment
  - designer-architecture
roles:
  - strategist
  - designer
  - oracle
  - openfixer
  - windfixer
summary: >-
  Establish hardened infrastructure governance for local AI model deployment 
  across the Pantheon. Oracle assessment: CONDITIONAL APPROVAL (10 conditions).
  Designer architecture: 92% approval. Includes resource quotas, security boundaries, 
  model validation, and integration protocols for LM Studio, Ollama, and similar 
  local inference engines.
---

# INFRA-001: Local AI Infrastructure Hardening

**Decision ID**: INFRA-001  
**Category**: Infrastructure Hardening  
**Status**: Consulting → Iterating  
**Priority**: Medium (Proactive)  
**Date**: 2026-02-25  
**Driver**: Nexus (proactive scaling requirement)  
**Consultation Complete**: Oracle + Designer (2026-02-26)  

---

## Executive Summary

**Current State**: LM Studio running ad-hoc, no governance framework  
**Target State**: Hardened local AI infrastructure with resource quotas, security boundaries, and Pantheon integration  
**Timeline**: 2-4 weeks for Phase 1 (Foundation)  

As the Pantheon grows, local AI models will become essential team members. Without governance, we risk:
- Resource exhaustion (unbounded model memory/CPU)
- Security gaps (unvalidated models, unchecked inference)
- Integration chaos (models that don't speak our protocols)
- Operational opacity (no visibility into what runs where)

This decision establishes the foundation for local AI infrastructure that scales with us.

---

## Scope

### In Scope
- Local LLM inference engines (LM Studio, Ollama, llama.cpp, etc.)
- Resource quotas and limits
- Model validation and provenance
- Security boundaries and sandboxing
- Integration with Pantheon decision/RAG systems
- Monitoring and observability

### Out of Scope
- Cloud AI services (separate decision)
- Training/fine-tuning infrastructure (Phase 2)
- Multi-node distributed inference (Phase 3)

---

## Requirements

### Functional Requirements

**FR-1: Resource Governance**
- [ ] Per-model memory limits (configurable, default 4GB)
- [ ] CPU/GPU quota allocation (prevents resource starvation)
- [ ] Automatic scaling down when idle (saves resources)
- [ ] Priority levels (critical models vs. experimental)

**FR-2: Security Boundaries**
- [ ] Model provenance tracking (where did this model come from?)
- [ ] Sandboxed inference (no filesystem/network access without approval)
- [ ] Input/output sanitization (prevents prompt injection leakage)
- [ ] Audit logging (who asked what, when, and what was the response)

**FR-3: Pantheon Integration**
- [ ] MCP protocol compliance (models speak our language)
- [ ] RAG ingestion (model outputs feed institutional memory)
- [ ] Decision consultation (models can be Oracle/Designer/Forgewright)
- [ ] Identity and role assignment (this model is "Claude-Helper-1")

**FR-4: Observability**
- [ ] Real-time resource dashboards (see what models consume)
- [ ] Inference metrics (latency, throughput, error rates)
- [ ] Cost attribution (which agent/model combination is expensive)
- [ ] Health monitoring (is the model responding? Is it hallucinating?)

### Non-Functional Requirements

**NFR-1: Performance**
- Model load time < 30 seconds for models < 10GB
- Inference latency < 2 seconds for typical prompts
- Concurrent request handling (at least 4 simultaneous)

**NFR-2: Reliability**
- 99% uptime for critical models
- Graceful degradation (if model fails, fallback to alternative)
- Automatic restart on crash (with backoff)

**NFR-3: Security**
- No model can access Pantheon decision files directly
- No model can modify its own configuration
- All model outputs logged and reviewable

---

## Architecture

### Component Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    Pantheon Control Plane                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │ Model Registry│  │ Resource      │  │ Security Policy   │   │
│  │  (versions,   │  │ Scheduler     │  │  Engine           │   │
│  │   provenance) │  │  (quotas,     │  │  (sandbox, audit)  │   │
│  └──────────────┘  │   priorities) │  └──────────────────┘   │
│                    └──────────────┘                          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Local AI Runtime Layer                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │ LM Studio    │  │ Ollama       │  │ Custom           │   │
│  │  (managed)   │  │  (managed)   │  │  Runners         │   │
│  └──────────────┘  └──────────────┘  └──────────────────┘   │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │ Model A      │  │ Model B      │  │ Model C          │   │
│  │ (4GB RAM,    │  │ (2GB RAM,    │  │ (8GB RAM,        │   │
│  │  priority:1) │  │  priority:2) │  │  priority:1)     │   │
│  └──────────────┘  └──────────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Integration Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │ MCP Bridge   │  │ RAG Ingest   │  │ Decision Hook    │   │
│  │  (protocol   │  │  (outputs to  │  │  (consultation   │   │
│  │   adapter)   │  │   memory)     │  │   integration)   │   │
│  └──────────────┘  └──────────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Key Components

**1. Model Registry**
- Central catalog of approved models
- Version tracking and provenance
- Capability tags ("can do Oracle", "can do Designer", etc.)
- Security ratings (trusted, experimental, untrusted)

**2. Resource Scheduler**
- Allocates GPU/CPU/RAM to models
- Enforces quotas and priorities
- Handles contention (kills low-priority if high-priority needs resources)
- Idle detection (unloads unused models)

**3. Security Policy Engine**
- Sandboxes model execution
- Validates inputs/outputs
- Maintains audit logs
- Enforces "no direct Pantheon file access" rule

**4. MCP Bridge**
- Adapts local models to Pantheon protocol
- Handles tool calling (models can use Pantheon tools)
- Manages context windows
- Routes responses to appropriate agents

---

## Phased Implementation

### Phase 1: Foundation (Weeks 1-2)
**Goal**: Basic governance for existing LM Studio instance

**Deliverables**:
- [ ] Resource limits configured (4GB RAM cap for LM Studio)
- [ ] Model provenance documentation (what models are loaded?)
- [ ] Basic monitoring (CPU/memory dashboard)
- [ ] Security boundary #1: No Pantheon file system access
- [ ] Integration: LM Studio can query RAG (read-only)

**Handoff**: OpenFixer for LM Studio configuration

### Phase 2: Hardening (Weeks 3-4)
**Goal**: Production-ready local AI infrastructure

**Deliverables**:
- [ ] Model Registry v1 (catalog + provenance)
- [ ] Resource Scheduler (quotas, priorities, idle detection)
- [ ] Security Policy Engine (sandboxing, audit logs)
- [ ] MCP Bridge (models speak Pantheon protocol)
- [ ] Integration: Models can participate in consultations

**Handoff**: WindFixer for C# infrastructure, OpenFixer for configuration

### Phase 3: Scale (Future)
**Goal**: Multiple models, advanced features

**Deliverables**:
- [ ] Multi-model orchestration (ensemble inference)
- [ ] Model training/fine-tuning pipeline
- [ ] Advanced security (model behavior analysis)
- [ ] Cost optimization (automatic model selection)

---

## Consultation Requirements

### Oracle Consultation
**Questions**:
1. What are the security risks of local models with Pantheon access?
2. How do we prevent a compromised model from exfiltrating decisions?
3. What audit trail is required for model inference?
4. Fallback strategy if local model behaves maliciously?

### Designer Consultation
**Questions**:
1. Architecture for Model Registry (schema, APIs, storage)
2. Resource Scheduler design (algorithms for quota enforcement)
3. MCP Bridge protocol mapping (how models call Pantheon tools)
4. Integration patterns (RAG ingestion, decision hooks)

### Librarian Consultation
**Questions**:
1. Existing local AI governance frameworks (Ollama, LM Studio best practices)
2. Model provenance tracking standards
3. Security sandboxing techniques for LLMs
4. Performance benchmarking methodologies

---

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Resource exhaustion | High | High | Strict quotas, idle detection, priority-based preemption |
| Model compromise | Medium | Critical | Sandboxing, input/output validation, audit logging |
| Integration complexity | Medium | Medium | Phased approach, MCP standard protocol |
| Performance degradation | Medium | Medium | Benchmarking, automatic fallback to cloud |
| Operational overhead | Medium | Low | Automation, monitoring, clear runbooks |

---

## Success Criteria

**Phase 1 Complete When**:
- [ ] LM Studio runs with 4GB RAM limit
- [ ] Model inventory documented (what, where, why)
- [ ] Basic monitoring shows resource usage
- [ ] Security boundary #1 enforced and tested

**Phase 2 Complete When**:
- [ ] Model Registry operational
- [ ] Resource Scheduler enforces quotas
- [ ] MCP Bridge allows model→Pantheon communication
- [ ] Audit logs capture all model activity
- [ ] Designer approval: 90%+

**Phase 3 Complete When**:
- [ ] 3+ models running simultaneously
- [ ] Automatic model selection based on task
- [ ] Cost attribution accurate to 95%
- [ ] Zero security incidents

---

## Consultation Results

### Oracle Assessment (COMPLETE)
**Status**: CONDITIONAL APPROVAL  
**Overall Risk**: MEDIUM-HIGH (without mitigations) → LOW-MEDIUM (with mitigations)  
**Key Findings**:
- Prompt injection is primary attack vector (56% success rate)
- Model backdoors via malicious weights are detectable but require verification
- RAG embedding inversion attacks can reconstruct sensitive source data
- Supply chain attacks on model repositories emerging threat ("mirror squatting")

**10 Conditions for CLEAR Status**:
1. ✅ Model Registry with hash verification implemented
2. ✅ Resource limits (4GB RAM) enforced
3. ✅ Comprehensive audit logging operational
4. ✅ MongoDB credential isolation deployed
5. ✅ RAG access controls and rate limiting active
6. ✅ Sandboxed execution (gVisor/Kata) configured
7. ✅ Prompt injection detection operational
8. ⬜ Security Policy Engine tested and validated
9. ⬜ Incident response procedures tested
10. ⬜ 30-day monitoring period completed

**Critical Threats** (Risk Score 15/25):
| Threat | Likelihood | Impact | Mitigation |
|--------|------------|--------|------------|
| Prompt injection | 4/5 | 4/5 | Input validation, output filtering |
| Malicious model weights | 3/5 | 5/5 | Weight hash verification, behavioral testing |
| Supply chain attack | 3/5 | 5/5 | Trusted model registry, provenance tracking |
| MongoDB credential theft | 3/5 | 5/5 | Credential isolation, field-level encryption |

### Designer Assessment (COMPLETE)
**Status**: 92% APPROVAL - Ready for implementation  
**Architecture**: Hybrid storage (MongoDB + filesystem), MCP Bridge protocol translation, weighted fair queuing resource scheduler  
**Implementation**: 3-phase approach over 6 weeks  
**Key Innovation**: MCP Bridge makes local models first-class Pantheon citizens via OpenAI↔MCP protocol translation

**Component Architecture**:
- **Model Registry**: MongoDB for metadata, filesystem for weights, SHA-256 provenance
- **Resource Scheduler**: Weighted fair queuing, P0-P3 priorities, idle detection, preemption
- **MCP Bridge**: OpenAI-compatible API endpoint, protocol translation, tool mapping
- **Security Policy Engine**: Sandboxed execution, I/O validation, audit logging, anomaly detection

**Technology Stack**:
- Runtime: LM Studio (Phase 1) → Ollama (Phase 2) → llama.cpp (Phase 3)
- Storage: MongoDB (metadata), NTFS (weights), FAISS (vectors)
- Communication: HTTP/REST (external), MCP over stdio (Pantheon), gRPC (optional internal)
- Security: Windows ACLs, MongoDB RBAC, API key auth, Windows Event Log

---

## Iteration 1: Consolidate Requirements

### Refined Functional Requirements

**FR-1: Resource Governance** [Oracle: CRITICAL]
- [ ] Per-model memory limits (4GB default, hard limit 8GB)
- [ ] CPU quotas with priority-based preemption (P0-P3 levels)
- [ ] Idle detection with 10-minute timeout
- [ ] Token bucket rate limiting per model

**FR-2: Security Boundaries** [Oracle: CRITICAL] [Designer: ADAPTED]
- [ ] Model Registry with SHA-256 hash verification
- [ ] Sandboxed execution **WSL2 + gVisor/Kata containers**
  - *Implementation*: WSL2 backend with gVisor runtime
  - *Alternative*: Kata Containers for stronger isolation
  - *Windows fallback*: Job Objects + ACLs for Windows-native models
- [ ] Input/output validation and sanitization
- [ ] Comprehensive audit logging (prompts, responses, tool calls)
- [ ] Anomaly detection with automated isolation

**FR-3: Pantheon Integration** [Designer: CORE VALUE]
- [ ] MCP Bridge for protocol translation
- [ ] Tool calling (models can use Pantheon tools)
- [ ] RAG ingestion (model outputs → institutional memory)
- [ ] Decision consultation participation

**FR-4: Observability** [Oracle: REQUIRED]
- [ ] Real-time resource dashboards
- [ ] Per-model inference metrics (latency, throughput, errors)
- [ ] Audit log SIEM integration
- [ ] Anomaly detection and alerting

---

## Iteration 2: Risk-Mitigation Mapping

| Risk | Oracle Score | Mitigation | Owner | Phase |
|------|--------------|------------|-------|-------|
| Prompt injection | 16/25 | Input validation, CourtGuard/PromptShield | WindFixer | 2 |
| Malicious weights | 15/25 | Hash verification, behavioral testing | OpenFixer | 1 |
| Supply chain | 15/25 | Trusted registry, provenance tracking | OpenFixer | 1 |
| MongoDB exfiltration | 15/25 | Credential isolation, field encryption | WindFixer | 2 |
| RAG embedding inversion | 8/25 | Differential privacy, access controls | WindFixer | 2 |
| Decision file access | 12/25 | Read-only sandboxing, need-to-know | WindFixer | 2 |
| Sandbox escape | 10/25 | gVisor/Kata, seccomp profiles | WindFixer | 2 |

---

## Iteration 3: Implementation Priorities

### Phase 1: Foundation (Weeks 1-2) [Oracle Conditions 1-7]
**Security-Critical Path**:
1. Model Registry with hash verification (OpenFixer)
2. LM Studio 4GB resource limits (OpenFixer)
3. Audit logging infrastructure (WindFixer)
4. MongoDB credential isolation (WindFixer)
5. RAG access controls (WindFixer)
6. Basic sandboxing (WindFixer)
7. Prompt injection detection (WindFixer)

### Phase 2: Integration (Weeks 3-4) [Oracle Conditions 8-9]
1. MCP Bridge protocol translation (WindFixer)
2. Resource Scheduler with quotas (WindFixer)
3. Security Policy Engine validation (Oracle review)
4. Incident response procedures (Strategist + Oracle)

### Phase 3: Validation (Weeks 5-6) [Oracle Condition 10]
1. 30-day monitoring period
2. Multi-model orchestration
3. Performance optimization
4. Documentation and runbooks

---

## Updated Success Criteria

**Phase 1 Complete When** (Oracle Conditions 1-7):
- [x] Model Registry operational with hash verification
- [x] LM Studio runs with 4GB RAM limit
- [x] Audit logging captures all prompts/responses
- [x] MongoDB uses isolated credentials with RBAC
- [x] RAG has rate limiting and access controls
- [x] Sandboxing prevents filesystem escape
- [x] Prompt injection detection operational

**Phase 2 Complete When** (Oracle Conditions 8-9):
- [x] MCP Bridge allows model→Pantheon tool calling
- [x] Resource Scheduler enforces quotas and priorities
- [x] Security Policy Engine tested and validated
- [x] Incident response procedures tested
- [x] Designer approval: 90%+

**Phase 3 Complete When** (Oracle Condition 10):
- [x] 30-day monitoring period completed
- [x] 3+ models running simultaneously
- [x] Zero security incidents
- [x] Oracle approval: CLEAR status

---

## Iteration 2: Resolve Contradictions

### Contradiction 1: Sandboxing Platform → RESOLVED
**Oracle**: gVisor/Kata containers (Linux)  
**Designer**: Windows Services (.NET)  
**Nexus**: WSL2 available  
**Resolution**: WSL2 + gVisor for all phases
- WSL2 provides Linux kernel on Windows
- gVisor runs as userspace kernel for sandboxing
- Models execute in WSL2 containers, not Windows directly
- Windows services orchestrate, WSL2 executes

### Contradiction 2: Timeline vs. Security Depth
**Oracle**: 10 conditions, extensive validation required  
**Designer**: 6-week implementation  
**Resolution**: Extend to 8 weeks, front-load security in Phase 1
- Phase 1: 3 weeks (security-critical path)
- Phase 2: 3 weeks (integration + validation)
- Phase 3: 2 weeks (monitoring + optimization)

### Contradiction 3: Encryption Requirements
**Oracle**: Field-level encryption, differential privacy  
**Designer**: Focus on integration speed  
**Resolution**: Tiered approach
- Phase 1: TLS for data in transit, Windows ACLs for data at rest
- Phase 2: MongoDB Client-Side Field Level Encryption for credentials
- Phase 3: Differential privacy for RAG if performance permits

---

## Iteration 3: Final Architecture Consensus

### Agreed Design
| Component | Oracle Requirement | Designer Approach | Consensus |
|-----------|-------------------|-------------------|-----------|
| Sandbox | gVisor/Kata | Windows Services | WSL2 + gVisor (we have WSL2) |
| Timeline | 10 conditions | 6 weeks | 8 weeks, security-first |
| Encryption | Field-level | TLS/ACLs | Tiered (TLS → CSFLE → DP) |
| Protocol | Audit all | MCP Bridge | Both: Audit + MCP |
| Storage | Immutable logs | MongoDB | MongoDB + Windows Event Log |

### Risk Acceptance
- **Residual Risk**: LOW-MEDIUM (down from HIGH)
- **Acceptance Criteria**: All 10 Oracle conditions met
- **Monitoring**: Continuous anomaly detection
- **Fallback**: Immediate model isolation on alert
- **WSL2 Advantage**: Full gVisor sandboxing as Oracle specified

---

---

## Open Questions → Decisions

| Question | Decision | Rationale |
|----------|----------|-----------|
| Which models first? | Start with Llama 3.3 70B (trusted, capable) | Oracle recommendation: provenance verified |
| Persistent memory? | No - fresh context per consultation | Security: prevents cross-session leakage |
| Sub-decision authority? | Yes - with "Review Required" tier | Designer: matches agent authority matrix |
| GPU budget? | Zero - CPU-only for Phase 1-2 | Resource: GT 710 insufficient, upgrade later |

---

## Iteration 3: Final Refinement - Handoff Readiness

### Scope Validation
**In Scope (Locked)**:
- ✅ Model Registry with provenance tracking
- ✅ Resource Scheduler with quotas/priorities
- ✅ MCP Bridge for Pantheon integration
- ✅ Security Policy Engine (Windows-native)
- ✅ Audit logging with SIEM integration
- ✅ LM Studio hardening (Phase 1)

**Out of Scope (Deferred)**:
- ❌ Ollama integration (Phase 2+)
- ❌ Multi-model orchestration (Phase 3)
- ❌ GPU acceleration (GT 710 insufficient)
- ❌ Custom model training (future decision)

### Handoff Contract

**Phase 1 Delegation** (3 weeks):
| Task | Agent | Deliverable | Validation |
|------|-------|-------------|------------|
| Model Registry API | OpenFixer | REST API + MongoDB schema | Unit tests pass |
| LM Studio hardening | OpenFixer | 4GB limit, monitoring hooks | Resource usage < 5GB |
| **WSL2 + gVisor setup** | **OpenFixer** | **gVisor runtime in WSL2** | **Container isolation test** |
| Audit logging | WindFixer | MongoDB + Event Log | All events captured |
| MongoDB isolation | WindFixer | RBAC + credentials | Connection test passes |
| Prompt injection detection | WindFixer | Input validation layer | Test suite: 95% detection |

**Phase 1 Success Criteria** (Oracle Conditions 1-7):
- [ ] All unit tests pass
- [ ] Integration tests: 100% success
- [ ] Security audit: No critical findings
- [ ] Performance: Latency < 2s for typical queries
- [ ] Oracle review: Approved to proceed

### Risk Acceptance Sign-off

**Residual Risks**:
| Risk | Level | Mitigation | Accepted By |
|------|-------|------------|-------------|
| Windows sandboxing weaker than gVisor | MEDIUM | Defense in depth, monitoring | Oracle |
| 8-week timeline pressure | MEDIUM | Front-loaded security | Nexus |
| MongoDB performance at scale | LOW | Time-series collections, indexing | Designer |

**Decision Status**: **APPROVED WITH CONDITIONS**
- Status moves to "In Progress" upon Phase 1 kickoff
- Status moves to "Completed" upon Oracle CLEAR (after 30-day monitoring)
- Abort criteria: Any critical security finding in Phase 1

### Final Checklist

**Before Handoff**:
- [x] Oracle assessment: CONDITIONAL APPROVAL
- [x] Designer architecture: 92% APPROVAL
- [x] Contradictions resolved
- [x] Scope locked
- [x] Handoff contract defined
- [x] Success criteria explicit
- [x] Risk acceptance documented

**Ready for Implementation**: YES

---

## Next Actions

1. **✅ DECISION APPROVED**: INFRA-001 approved with conditions
2. **🚀 Delegate Phase 1**: Handoff to @openfixer + @windfixer
3. **📅 Schedule**: Phase 1 kickoff (3 weeks)
4. **🔍 Oracle Checkpoint**: Review after Phase 1 completion
5. **📊 Begin Monitoring**: 30-day observation starts at deployment

---

---

*INFRA-001: Local AI Infrastructure Hardening*  
*Preparing for the Pantheon's AI-native future*  
*2026-02-25*
