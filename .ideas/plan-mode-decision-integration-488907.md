# Strategist Decision Workflow System

This system implements the Strategist agent (Pyxis) as a standalone decision workflow engine with consultation, approval, and handoff capabilities.

## Current State

P4NTH30N has a sophisticated decision engine with:
- Structured decision format (DECISION-TEMPLATE.md)
- Multi-dimensional scoring system (10 criteria)
- Oracle/Designer/Strategist approval workflow
- Decision registry (decisions.json)
- Action tracking and consultation logs

## Desired State

The Strategist system should provide full decision workflow capabilities:
1. **Decision Creation**: Generate decisions using P4NTH30N template format with proper ID assignment
2. **Workflow Leadership**: Run consultation phases with Oracle/Designer in parallel
3. **Approval System**: Implement 90% approval threshold with iteration logic
4. **Evidence Spine**: Maintain assumption register, decision rationale, validation commands
5. **Handoff Quality**: Create exact implementation contracts for WindFixer/OpenFixer
6. **Manifest Updates**: Auto-update decisions.json registry and manifest.json
7. **Beast Mode**: Run deterministic phases (Intake→Frame→Consult→Synthesize→Contract→Audit→Learn)

## Implementation Approach

### Phase 1: Core Strategist Implementation
- Replace generic templates with full DECISION-TEMPLATE.md structure
- Implement decision ID generation from decisions.json nextId tracking
- Add mandatory evidence spine: assumption register, decision rationale, validation commands
- Implement workflow gates: Drafted→Synced→Consulting→Approved→HandoffReady→Closed

### Phase 2: Consultation System - SIMULATION FRAMEWORK

#### Oracle (Provenance) Simulation Framework
- **Identity**: Thread-Keeper, celebrates errors, places metrics everywhere
- **Core Questions**: "Where can I place a metric?", "What does the thread show?", "How do we measure this chaos?"
- **Assessment Format**: Thread Status (INTACT/FRAYED/BROKEN), Event Coverage %, Observable Paths, Dark Corners
- **Confidence System**: Vector-based EMA scoring with momentum tracking (↑/↓/→ trajectory)
- **Output Structure**: 
  ```
  Thread Confidence: [0-100]
  - Evidence Vector: [change direction] ([numeric change])
  - Momentum: [STRONG/WEAK/STABLE]
  - Trajectory: [prediction]
  Harden Opportunities: [list]
  Assessment: [CLEAR/CONDITIONAL/BLOCKED]
  ```

#### Designer (Aegis) Simulation Framework  
- **Identity**: Implementation researcher, architecture designer, build guide creator
- **Core Capabilities**: Implementation research, architecture design, parallelization mapping
- **Approval Iteration**: 90-100% (Approved), 70-89% (Conditional - max 3 iterations), <70% (Rejected)
- **Output Structure**:
  ```
  RESEARCH SUMMARY: Key findings
  ARCHITECTURE PROPOSAL: Recommended approach
  IMPLEMENTATION PLAN: Task breakdown + parallelization
  ORACLE CONSULTATION NEEDED: Feasibility decisions
  RISKS & CONSIDERATIONS: Mitigation strategies
  ```

#### Parallel Consultation Simulation
- **Simultaneous Generation**: Create both Oracle and Designer outputs in parallel
- **Approval Heuristics**: Apply Oracle's vector-based confidence + Designer's iteration logic
- **Timeout Handling**: 15-minute simulation with "Unavailable" fallback
- **Contradiction Resolution**: Record both positions, select stricter risk posture

### Phase 3: Beast Mode Implementation
- Implement deterministic phases: Intake→Frame→Consult→Synthesize→Contract→Audit→Learn
- Add mission shape classification (Architecture Inspection, Failure Investigation, etc.)
- Create bounded scope framing (5 bullets max: objective, constraints, evidence targets, risk ceiling, finish criteria)
- Add synthesis protocol with primary + fallback routes

### Phase 4: Handoff & Deployment
- Create exact implementation contracts for WindFixer/OpenFixer
- Add failure modes with fallback behavior
- Implement deployment governance with journal tracking
- Add closure evidence paths and audit requirements

### Phase 5: Automation & Self-Improvement
- Add retrospective capture (what worked, drifted, automate, deprecate, enforce)
- Implement automation discipline for recurring tasks
- Add strategic doubt and inquiry protocols
- Include structured conversation protocols with Nexus

## Key Changes Required

1. **Identity Transformation**: Transform from generic planner to Strategist (Pyxis) with decision workflow leadership
2. **Template System**: Replace generic format with full DECISION-TEMPLATE.md including evidence spine
3. **Consultation Engine**: Add parallel Oracle/Designer consultation with timeout and approval heuristics
4. **Registry Management**: Auto-update decisions.json and manifest.json with proper ID generation
5. **Workflow Gates**: Implement deterministic phases with state transitions and validation
6. **Handoff System**: Create implementation contracts for WindFixer/OpenFixer with exact specifications

## Benefits

- **Full Decision Lifecycle**: From intake through handoff with proper governance
- **Strategic Leadership**: The system becomes true decision workflow leader, not just planner
- **Quality Assurance**: 10-dimension scoring and approval thresholds ensure high-quality decisions
- **Traceability**: Complete evidence spine and audit trails for all decisions
- **Automation**: Self-improvement loops and recurring task automation
- **Integration**: Seamless handoff to implementation agents with exact contracts

## Success Criteria

1. **Strategist Identity**: The system operates as Pyxis with full decision workflow capabilities
2. **Simulated Consultations**: Structured analysis templates that mimic Oracle/Designer perspectives with approval scoring
3. **Decision Quality**: All decisions meet 90%+ approval threshold through structured quality assessment
4. **Evidence Integrity**: Complete assumption register and validation commands for every decision
5. **Handoff Success**: Implementation agents receive exact contracts and can execute without ambiguity
6. **Registry Consistency**: decisions.json and manifest.json automatically updated and synchronized

## Simulated Agent Capabilities

### Oracle (Provenance) - Thread-Keeper Simulation
- **Philosophy**: "Errors aren't shameful—they are opportunities to harden"
- **Core Questions**: Metric placement, thread visibility, chaos measurement
- **Assessment Style**: Vector-based confidence with EMA momentum tracking
- **Output**: Thread Status, Event Coverage, Observable Paths, Dark Corners, Harden Opportunities
- **Approval Logic**: CLEAR/CONDITIONAL/BLOCKED with evidence vector analysis

### Designer (Aegis) - Architecture Simulation  
- **Philosophy**: Implementation research + architecture design + build guides
- **Core Capabilities**: Library research, component hierarchies, parallelization mapping
- **Assessment Style**: Iterative refinement with 90% approval threshold
- **Output**: Research Summary, Architecture Proposal, Implementation Plan, Risk Mitigation
- **Approval Logic**: 90-100% (Approved), 70-89% (Conditional - max 3 iterations), <70% (Rejected)

### Integration Benefits
- **Authentic Voices**: Each simulation uses the agent's language and frameworks
- **Consistent Logic**: Approval heuristics match agent decision patterns  
- **Structured Output**: Consultation records follow agent formatting
- **Parallel Processing**: Both simulations analyze simultaneously with contradiction handling
