# WINDFIXER EXECUTION PROMPT
## Batch: 11 Decisions | P4NTH30N Codebase | Opus 4.6 Thinking

**Execution Date**: 2026-02-18  
**Assigned Agent**: WindFixer (WindSurf)  
**Model**: Opus 4.6 Thinking (preferred)  
**Target**: P4NTH30N repository (C:\P4NTH30N)  
**Billing**: Per-prompt (cost-effective for bulk execution)

---

## YOUR MISSION

Execute 11 decisions in the P4NTH30N codebase. You have full access to the P4NTH30N directory. Work systematically through each decision, implementing with comprehensive unit tests and C# best practices.

**CRITICAL**: If you encounter any constraints or blockers that prevent completion, document them immediately using the CONSTRAINT REPORT format at the end of this prompt. These constraints will be passed to OpenFixer for resolution.

---

## DECISION EXECUTION ORDER

### PHASE 1: VALIDATION & FOUNDATION (Execute First)

#### 1. DEPLOY-002: ARCH-003 Pre-Validation
**Priority**: HIGH | **Status**: Ready | **Dependencies**: None (DEPLOY-001 completed)

**Objective**: Download and validate Maincoder-1B model for ARCH-003 implementation

**Steps**:
1. Download Maincoder-1B GGUF from Hugging Face
   - URL: https://huggingface.co/Maincode/Maincoder-1B
   - File: maincoder-1b-q4_k.gguf (Q4_K quantization, ~0.8GB)
   - Target: C:\P4NTH30N\models\

2. Set up LM Studio (if not already running)
   - Load maincoder-1b-q4_k.gguf
   - Verify server at localhost:1234
   - Document any setup issues

3. Create 5 test configurations:
   - Test 1: Valid config with all fields
   - Test 2: Missing required field
   - Test 3: Invalid threshold order
   - Test 4: Edge case - empty strings
   - Test 5: Edge case - special characters

4. Run validation via API:
   ```
   POST http://localhost:1234/v1/chat/completions
   Body: {
     model: "maincoder-1b",
     messages: [
       {role: "system", content: "Validate config"},
       {role: "user", content: config_json}
     ]
   }
   ```

5. Expected output format:
   ```json
   {"valid": true/false, "confidence": 0.0-1.0, "failures": []}
   ```

6. Measure and record:
   - Accuracy: Must be ≥80%
   - Latency: Must be <2s per request
   - JSON format validity

**Deliverables**:
- C:\P4NTH30N\models\maincoder-1b-q4_k.gguf (or documentation of download failure)
- C:\P4NTH30N\tests\pre-validation\results.json (test results)
- C:\P4NTH30N\tests\pre-validation\test-configs\ (5 test configurations)

**Success Criteria**:
- [ ] Model file exists (~0.8GB) OR documented download failure
- [ ] LM Studio responds at localhost:1234 OR documented setup failure
- [ ] 5 tests executed
- [ ] JSON output format valid
- [ ] Accuracy >= 80%
- [ ] Latency < 2s average

**Constraints to Report**:
- If model download fails → OpenFixer will implement API-based validation fallback
- If accuracy <80% → OpenFixer will evaluate alternative models (Qwen2.5-0.5B)
- If LM Studio unavailable → OpenFixer will set up Docker-based LLM container

---

### PHASE 2: ARCHITECTURE (Execute After DEPLOY-002)

#### 2. ARCH-003: LLM-Powered Intelligent Deployment Analysis
**Priority**: HIGH | **Status**: Blocked until DEPLOY-002 completes | **Oracle Approval**: 82% Conditional

**Objective**: Implement LLM-powered deployment analysis with 95% accuracy requirement

**Components to Implement**:

1. **LmStudioClient.cs** - LM Studio integration client
   - Methods: Connect(), ValidateConfig(), GetConfidence()
   - Error handling for connection failures
   - Retry logic with exponential backoff

2. **HealthChecker.cs** - System health validation
   - Check MongoDB connectivity
   - Check disk space
   - Check memory usage
   - Return health score 0.0-1.0

3. **FewShotPrompt.cs** - Prompt templates with examples
   - Include 3-5 examples per validation type
   - Structured JSON output schema
   - Confidence scoring

4. **LogClassifier.cs** - Deployment log analysis
   - Parse build logs
   - Classify errors (critical/warning/info)
   - Extract error patterns

5. **DecisionTracker.cs** - Go/no-go tracking
   - Track consecutive NO-GO count
   - Implement 2/3 threshold for rollback
   - Store decision history

6. **ValidationPipeline.cs** - 95% accuracy validation
   - Run 50-sample test set
   - Calculate accuracy, precision, recall
   - Block deployment if <95%

**Target Directory**: C:\P4NTH30N\scripts\DeployLogAnalyzer\

**Deliverables**:
- scripts/DeployLogAnalyzer/LmStudioClient.cs
- scripts/DeployLogAnalyzer/HealthChecker.cs
- scripts/DeployLogAnalyzer/FewShotPrompt.cs
- scripts/DeployLogAnalyzer/LogClassifier.cs
- scripts/DeployLogAnalyzer/DecisionTracker.cs
- scripts/DeployLogAnalyzer/ValidationPipeline.cs
- scripts/DeployLogAnalyzer/Tests/ (unit tests for each component)

**Success Criteria**:
- [ ] All 6 components implemented
- [ ] 95% accuracy achieved on validation set
- [ ] <2s latency per validation
- [ ] 2/3 consecutive NO-GO triggers rollback
- [ ] Unit tests pass (>90% coverage)

**Constraints to Report**:
- If Qwen2.5-0.5B insufficient → OpenFixer will evaluate alternatives
- If 95% accuracy unachievable → OpenFixer will adjust threshold with Oracle re-consultation
- If integration fails → OpenFixer will create PowerShell-based wrapper

---

### PHASE 3: SWE-1.5 FOUNDATION (Execute in Sequence)

#### 3. SWE-001: SWE-1.5 Context Management Strategy
**Priority**: CRITICAL | **Status**: Ready | **Dependencies**: PROD-001

**Objective**: Establish context management protocols for SWE-1.5 (128K input, 8K output)

**Deliverables**:
1. **docs/SWE1.5_CONTEXT_GUIDELINES.md**
   - Session chunking at 30-turn intervals
   - File limits: 50-75 files per session
   - Code generation caps: 2,000-3,000 lines/response
   - Context handoff procedures

2. **src/SessionManager.cs**
   - Turn counter implementation
   - Session boundary detection
   - Context compression logic
   - Handoff state serialization

3. **.windsurfrules** (update existing)
   - Add SWE-1.5 specific rules
   - File size limits
   - Complexity thresholds

**Success Criteria**:
- [ ] Guidelines documented
- [ ] SessionManager implemented with tests
- [ ] Turn counting accurate
- [ ] Context handoff works across sessions

---

#### 4. SWE-002: Multi-File Agentic Workflow Design
**Priority**: HIGH | **Status**: Ready | **Dependencies**: SWE-001, PROD-002

**Objective**: Design parallel tool execution and multi-file coordination

**Deliverables**:
1. **src/workflows/ParallelExecution.cs**
   - Execute up to 10 tool calls per turn
   - Dependency resolver
   - Retry logic with circuit breaker
   - Result aggregation

2. **src/workflows/MultiFileCoordinator.cs**
   - Coordinate 5-7 file edits per turn
   - Cross-reference validation
   - Consistency checking
   - File locking mechanism

3. **src/workflows/AgentIntegration.cs**
   - H0UND/H4ND integration patterns
   - Agent coordination protocols
   - Performance benchmarks

**Success Criteria**:
- [ ] Parallel execution works (10 calls/turn)
- [ ] Multi-file coordination stable
- [ ] No race conditions
- [ ] Unit tests pass

**Constraints to Report**:
- If parallel execution fails → OpenFixer will implement sequential fallback
- If file locking issues → OpenFixer will create file queue system

---

#### 5. SWE-003: C# Code Generation Standards
**Priority**: HIGH | **Status**: Ready | **Dependencies**: SWE-001

**Objective**: Establish C# 12 code generation standards

**Deliverables**:
1. **templates/csharp/** (directory)
   - Class template (max 800 lines)
   - Method templates
   - Interface templates
   - Record templates

2. **src/Validation/CodeGenerationValidator.cs**
   - Size checker (line count)
   - Syntax validator
   - Complexity analyzer
   - C# 12 feature detection

3. **.windsurfrules** (update)
   - C# generation standards
   - Size limits
   - Naming conventions

**Success Criteria**:
- [ ] Templates generate valid C# 12 code
- [ ] Size limits enforced
- [ ] Syntax validation passes
- [ ] Unit tests pass

**Constraints to Report**:
- If C# 12 features unsupported → OpenFixer will downgrade to C# 10
- If templates too restrictive → OpenFixer will create tiered template system

---

#### 6. SWE-004: Decision Clustering Strategy
**Priority**: HIGH | **Status**: Ready | **Dependencies**: SWE-001, PROD-004

**Objective**: Implement decision clustering for 122 decisions within 30-turn limits

**Deliverables**:
1. **docs/DECISION_CLUSTERS.md**
   - Decision dependency map
   - 20-24 cluster groupings
   - Priority ordering
   - Session allocation

2. **src/DecisionClusterManager.cs**
   - Cluster tracker
   - Session planner
   - Context handoff templates
   - Dependency resolver

3. **T4CT1CS/decisions/clusters/** (directory)
   - Cluster definition files
   - Session plans
   - Progress tracking

**Success Criteria**:
- [ ] All 122 decisions clustered
   - [ ] Dependencies mapped
   - [ ] Session plans created
   - [ ] Context handoff works

**Constraints to Report**:
- If clustering algorithm inefficient → OpenFixer will implement graph-based optimization
- If session boundaries unclear → OpenFixer will create decision dependency visualizer

---

#### 7. SWE-005: SWE-1.5 Performance Optimization
**Priority**: MEDIUM | **Status**: Ready | **Dependencies**: SWE-001, PROD-005

**Objective**: Implement performance monitoring for SWE-1.5 workflows

**Deliverables**:
1. **src/Monitoring/SWE15PerformanceMonitor.cs**
   - Response time tracker (2-5s analysis, 5-15s generation)
   - Context size monitor (10-15% slower per 25K tokens)
   - Error pattern detection

2. **monitoring/dashboards/swe15-performance.json**
   - Grafana dashboard config
   - Performance metrics
   - Alert thresholds

3. **Alert triggers**:
   - Session reset at 50-60 turns
   - Context warning at 90% capacity
   - Performance degradation alerts

**Success Criteria**:
- [ ] Metrics collection working
   - [ ] Dashboard operational
   - [ ] Alerts trigger correctly
   - [ ] No significant performance impact

**Constraints to Report**:
- If metrics collection impacts performance → OpenFixer will implement sampling
- If alerting too noisy → OpenFixer will tune thresholds

---

### PHASE 4: PRODUCTION HARDENING

#### 8. PROD-001: Production Readiness Verification
**Priority**: CRITICAL | **Status**: Ready | **Dependencies**: All INFRA-001 through INFRA-010

**Objective**: Comprehensive pre-production checklist

**Deliverables**:
1. **T4CT1CS/prod-readiness/checklist.md**
   - Hybrid validation approach (CI/CD + manual)
   - System validation items
   - Security verification
   - Performance baselines

2. **T4CT1CS/audit/production-readiness/**
   - Validation scripts
   - Sign-off documents
   - Test results

**Oracle Requirements**:
- 72% Conditional approval
- Deep verification needed: INFRA-001, INFRA-003, INFRA-004, INFRA-010
- Hybrid validation: CI/CD for build/DB, manual for security

**Success Criteria**:
- [ ] Checklist complete
   - [ ] All INFRA decisions verified
   - [ ] Security sign-off obtained
   - [ ] Performance baselines established

---

#### 9. PROD-002: Workflow Automation Phase 1
**Priority**: HIGH | **Status**: Ready | **Dependencies**: STRATEGY-007, STRATEGY-008, STRATEGY-009

**Objective**: Implement parallel agent delegation workflows

**Deliverables**:
1. **src/workflows/ParallelDelegation.cs**
   - Dynamic research brief templates
   - Context packaging standard
   - Orchestrator parallel handler
   - Result aggregation

2. **docs/AGENTS.md** (update)
   - Parallel delegation patterns
   - 60s timeout (configurable)
   - Circuit breaker logic

**Oracle Requirements**:
- 82% Conditional approval
- Orchestrator-mediated delegation
- Document pattern in AGENTS.md

**Success Criteria**:
- [ ] Parallel delegation working
   - [ ] Timeout handling correct
   - [ ] Results aggregated properly
   - [ ] Circuit breaker functional

**Constraints to Report**:
- If parallel delegation fails → OpenFixer will implement sequential fallback
- If timeout too aggressive → OpenFixer will extend based on task complexity

---

#### 10. PROD-005: Monitoring Dashboard and Alerting
**Priority**: HIGH | **Status**: Ready | **Dependencies**: INFRA-004, INFRA-010, FOUREYES-004

**Objective**: Deploy comprehensive monitoring and alerting

**Deliverables**:
1. **C0MMON/Interfaces/IMetrics.cs** (extend existing)
   - prometheus-net integration
   - /metrics endpoint

2. **monitoring/alerts/alert-rules.yml**
   - P1/P2/P3 alert rules
   - 5-minute sustained thresholds
   - <10% false positive rate

3. **monitoring/config/thresholds.json**
   - Tunable thresholds
   - Environment-specific configs

**Oracle Requirements**:
- 78% Conditional approval
- Extend existing IMetrics (not parallel)
- Reuse MONITOR alerting
- Tunable threshold config file

**Success Criteria**:
- [ ] Metrics endpoint working
   - [ ] Dashboards deployed
   - [ ] Alerts functional
   - [ ] False positive rate <10%

**Constraints to Report**:
- If Prometheus resource intensive → OpenFixer will evaluate alternatives
- If false positive rate >10% → OpenFixer will tune thresholds

---

### PHASE 5: COMPLETION

#### 11. BENCH-002: Model Selection Workflow
**Priority**: HIGH | **Status**: InProgress (Phase 1-2 Complete) | **Dependencies**: BENCH-001

**Objective**: Complete cost tracking dashboard

**Already Complete**:
- Model selection flowchart ✓
- Escalation criteria ✓
- SWE-1.5 prompt templates ✓
- Opus 4.6 escalation triggers ✓
- Quality validation checklist ✓

**Remaining Work**:
1. **Cost tracking dashboard**
   - Track SWE-1.5 vs Opus 4.6 usage
   - Calculate cost savings
   - Display in Grafana

2. **Update docs/MODEL_SELECTION_WORKFLOW.md**
   - Document completed workflow
   - Add cost tracking section

**Success Criteria**:
- [ ] Cost tracking operational
   - [ ] Dashboard shows usage metrics
   - [ ] Documentation updated

**Constraints to Report**:
- If cost tracking API unavailable → OpenFixer will implement manual logging
- If escalation triggers misfire → OpenFixer will tune complexity thresholds

---

## CONSTRAINT REPORT FORMAT

**CRITICAL**: If you encounter ANY of the following, stop and report immediately:

### Hardware/Resource Constraints
```
CONSTRAINT TYPE: [Model Download Failure / Insufficient Disk / Memory Limit]
DECISION: [Decision ID]
STEP: [What you were trying to do]
ERROR: [Exact error message]
ATTEMPTED WORKAROUNDS: [What you tried]
RECOMMENDED OPENFIXER ACTION: [What OpenFixer should do]
```

### Software/Integration Constraints
```
CONSTRAINT TYPE: [API Unavailable / Integration Failure / Dependency Missing]
DECISION: [Decision ID]
COMPONENT: [Which component failed]
ERROR: [Exact error message or behavior]
ATTEMPTED WORKAROUNDS: [What you tried]
RECOMMENDED OPENFIXER ACTION: [What OpenFixer should do]
```

### Performance/Accuracy Constraints
```
CONSTRAINT TYPE: [Low Accuracy / High Latency / Resource Exhaustion]
DECISION: [Decision ID]
METRIC: [What was measured]
TARGET: [Target value]
ACTUAL: [Actual value]
ATTEMPTED WORKAROUNDS: [What you tried]
RECOMMENDED OPENFIXER ACTION: [What OpenFixer should do]
```

### Oracle/Approval Constraints
```
CONSTRAINT TYPE: [Oracle Rejection / Approval Threshold Not Met]
DECISION: [Decision ID]
CURRENT APPROVAL: [Current percentage]
REQUIRED: [Required percentage]
ORACLE CONCERNS: [Specific concerns raised]
RECOMMENDED OPENFIXER ACTION: [Re-consultation needed / Threshold adjustment]
```

---

## EXECUTION CHECKLIST

Before starting:
- [ ] Read C:\P4NTH30N\T4CT1CS\decisions\active\DECISION_ASSIMILATION_REPORT.md
- [ ] Verify P4NTH30N repository structure
- [ ] Confirm Opus 4.6 Thinking model active

During execution:
- [ ] Execute decisions in PHASE order (1→2→3→4→5)
- [ ] Complete all deliverables for each decision
- [ ] Write unit tests (>90% coverage)
- [ ] Document any constraints encountered
- [ ] Update decision progress in comments

After each decision:
- [ ] Verify deliverables exist
- [ ] Run unit tests
- [ ] Update decision status
- [ ] Report constraints (if any)

Final deliverables:
- [ ] All 11 decisions implemented
- [ ] Unit tests passing
- [ ] Constraint report (if applicable)
- [ ] Summary of completion

---

## COMMUNICATION PROTOCOL

### Progress Updates
Report progress after completing each PHASE:
```
PHASE [N] COMPLETE: [Decision IDs completed]
DELIVERABLES: [Files created]
TESTS: [Pass/Fail status]
CONSTRAINTS: [Any constraints to report]
NEXT: [Next phase/decision]
```

### Constraint Escalation
Report constraints immediately when encountered:
```
CONSTRAINT ESCALATION: [Decision ID]
TYPE: [Hardware/Software/Performance/Oracle]
IMPACT: [Blocking/Non-blocking]
DETAILS: [Full constraint report]
```

### Completion Report
Final report after all decisions:
```
WINDFIXER BATCH COMPLETE
DECISIONS: [11/11 completed]
FILES: [Count of files created]
TESTS: [Pass rate]
CONSTRAINTS: [Count and summary]
OPENFIXER HANDOFFS: [List of constraints passed to OpenFixer]
```

---

## QUALITY STANDARDS

### Code Quality
- C# 12 features where appropriate
- Primary constructors
- File-scoped namespaces
- Pattern matching
- Nullable reference types enabled

### Testing
- Unit tests for all components
- >90% code coverage
- Integration tests for workflows
- Performance benchmarks

### Documentation
- XML comments on public APIs
- README for each component
- Architecture decision records
- Usage examples

---

**Begin execution with PHASE 1: DEPLOY-002**

**Remember**: Constraints are not failures. Document them clearly so OpenFixer can resolve them. The goal is maximum progress with clear handoffs.

**Ready? Execute.**
