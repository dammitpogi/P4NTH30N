# T4CT1CS Platform Architecture

## Purpose
Decision execution engine. Not documentation. Not discussion. Execution.

## Directory Structure

```
T4CT1CS/
├── speech/              # Voice synthesis output
│   ├── 2025-02-17T20-45-00.md
│   └── *.md            # ISO8601 timestamps only
├── decisions/           # Decision manifests
│   ├── active/         # Proposed/InProgress
│   ├── completed/      # Completed archive
│   └── templates/      # Decision patterns
├── actions/            # Executable action items
│   ├── pending/        # Ready to execute
│   ├── blocked/        # Waiting on dependencies
│   └── done/           # Completed actions
├── intel/              # Strategic intelligence
│   ├── gaps/           # Identified gaps
│   ├── risks/          # Risk assessments
│   └── opportunities/  # Strategic opportunities
└── auto/               # Automated decision output
    ├── daily/          # Daily briefings
    ├── weekly/         # Weekly summaries
    └── trigger/        # Event-triggered reports
```

## Decision Types

1. **INFRA** - Infrastructure and operations
2. **CORE** - Core architecture and systems design
3. **FEAT** - Feature development
4. **TECH** - Technical debt and refactoring
5. **RISK** - Risk mitigation
6. **AUTO** - Automated system decisions
7. **FORGE** - Platform-pattern and enhancement

## Execution Rules

- Speech files use ISO8601 datetime titles only
- No formatting that breaks voice synthesis
- Decisions move from active/ to completed/ on status change
- Actions self-organize by priority and dependencies
- Auto/ generates without human trigger

## Current State

INFRA-001 through INFRA-010 created and populated with 48 action items.
Status: Proposed. Ready for progression to InProgress.

**Updated 2026-02-18 16:30**:
- **55 total decisions** (16 Completed, 36 Proposed, 3 InProgress) (+8 WIN, TECH-004 Rejected)
- **76 action items** tracked
- **WIN PHASE Decisions**: 8 new decisions created for First Jackpot milestone
  - WIN-001: End-to-End Integration Testing
  - WIN-002: Production Deployment and Go-Live
  - WIN-003: Jackpot Monitoring and Alerting
  - WIN-004: Safety Mechanisms and Circuit Breakers
  - WIN-005: Real Casino Credential Management
  - WIN-006: Jackpot Threshold Calibration
  - WIN-007: First Jackpot Attempt Procedures
  - WIN-008: Post-Win Validation and Analysis
- **Milestone**: First Jackpot Win marks Phase 1 Complete
- **Critical Path**: WIN-001 → WIN-005 → WIN-006 → WIN-004 → WIN-002 → WIN-007 → WIN-008
- **Estimated to First Jackpot**: 4-6 weeks (after FourEyes completion)
- **CORE-001 created**: Core Systems Architecture decision (Oracle Tier 1 finding)
- **INFRA-009 created**: In-House Secrets Management (zero-cloud encryption)
- **INFRA-010 created**: MongoDB RAG Architecture (LLM infrastructure)
- **FEAT-001 created**: LLM Inference Strategy (LM Studio local, CPU-only)
- **TECH-001 created**: Model Registry and Artifact Versioning (MLflow + DVC)
- **TECH-002 created**: Hardware Assessment (CPU-only LLM configuration)
- **FourEyes System Created** (VM-based automation):
  - VM-001: VM Infrastructure (being corrected)
  - VM-002: VM Executor (4C/8GB) with OBS streaming
  - FOUR-001: FourEyes Agent with stream receiver
  - FOUR-002: Synergy mouse/keyboard sharing
  - FOUR-003: Health monitoring and failure recovery
  - ACT-001: Signal-to-Action pipeline
- **Hardware Analyzed**: AMD Ryzen 9 3900X (12C/24T), 128GB RAM, GT 710 (2GB) - GPU incompatible, CPU-only mode
- **Oracle Assessment**: FourEyes architecture assessed, **44% approval - REJECTED pending remediation**
  - **BLOCKERS identified**: No Synergy integration, W4TCHD0G is placeholder, No RTMP receiver, OBS WebSocket failures
  - **Critical action items added** (7 tasks) to address Oracle findings
- **Zero-cloud constraint applied**: All cloud dependencies removed
- **Budget**: Zero recurring costs maintained
- **Risk Status**: P0 gaps addressed (LLM inference, FAISS backup, encryption fixes)
- **Ready for Fixer**: INFRA-009, INFRA-010, FEAT-001, TECH-002, FourEyes system (**after Oracle blockers resolved**)

**Strategic Constraints** (Nexus directive):
- **Zero cloud dependencies**: No Azure, AWS, GCP managed services
- **In-house infrastructure**: Self-hosted everything
- **Low/no cost**: Bootstrap phase, zero recurring expenses until revenue
- **RAG architecture**: LLM infrastructure with MongoDB RAG capabilities

**Consultant Findings**:
- **Oracle**: Secrets management is foundation-locking; Core Systems Architecture was missing; ChromeDriver casino dependency higher risk than assessed
- **Designer**: GitHub Actions for CI/CD; Prometheus+Grafana for monitoring; Windows Server 2022 + Ubuntu 22.04 LTS for OS matrix
- **Risk**: Serial dependencies (INFRA-001 → INFRA-002) blocking 5+ decisions

**Zero-Cloud Architecture Decisions**:
1. **INFRA-009**: In-House Secrets Management - AES-256-GCM encryption, local master key, $0 cost
2. **INFRA-010**: MongoDB RAG Architecture - FAISS + ONNX embeddings, local LLM context, $0 cost
3. **INFRA-002**: Configuration - User secrets + encrypted MongoDB, no Key Vault, $0 cost
4. **INFRA-003**: CI/CD - GitHub Actions (free) or self-hosted runners, $0 cost
5. **INFRA-004**: Monitoring - Self-hosted Prometheus + Grafana, $0 cost
6. **INFRA-005**: Backup - Local RAID + Syncthing offsite, $0 cost

**Active Research Areas**:
1. **INFRA-001**: OS support matrix (Windows Server 2022 + Ubuntu 22.04 LTS recommended), MongoDB 7.0+, ChromeDriver automated probing
2. **INFRA-002**: Configuration hierarchy (in-house), secrets management (local encryption)
3. **INFRA-003**: CI/CD pipeline (GitHub Actions free tier)
4. **INFRA-004**: Monitoring stack (Prometheus + Grafana self-hosted)
5. **INFRA-005**: Backup strategy (mongodump + Syncthing offsite)
6. **INFRA-006**: Security hardening (RBAC now, deferred encryption post-revenue)
7. **INFRA-007**: Performance optimization (in-memory cache, connection pooling)
8. **INFRA-008**: Operational runbooks (incident severity, on-call)
9. **INFRA-009**: In-house encryption service (AES-256-GCM, local master key)
10. **INFRA-010**: RAG architecture (FAISS vector store, ONNX embeddings, LLM context)
11. **FEAT-001**: LLM Inference (LM Studio CPU-only, Pleias-RAG-1B, 20-40 tok/sec)
12. **TECH-002**: Hardware Assessment (CPU-only config, GT 710 incompatible, Ryzen 9 3900X)
13. **CORE-001**: Core Systems Architecture (hybrid monolithic, container path)
14. **VM-002**: VM Executor (4C/8GB) with OBS streaming RTMP to host
15. **FOUR-001**: FourEyes Agent with stream receiver and adaptive frame sampling
16. **FOUR-002**: Synergy mouse/keyboard sharing between host and VM
17. **FOUR-003**: Health monitoring and failure recovery for VM streaming
18. **ACT-001**: Signal-to-Action automation pipeline (MongoDB → FourEyes → VM)
