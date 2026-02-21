# WINDFIXER DEPLOYMENT PROMPT
## Comprehensive Execution - All Ready Decisions

**Model**: Opus 4.6 Thinking  
**Environment**: WindSurf on C:\P4NTH30N  
**Mission**: Execute all decisions ready for P4NTH30N codebase implementation

---

## CURRENT STATE (As of 2026-02-18 22:00)

**Total Decisions**: 146  
**Completed**: 136  
**In Progress**: 1 (ARCH-003-PIVOT - nearly complete)  
**Proposed**: 8 (Ready for activation)  
**Rejected**: 1

---

## DECISION BATCH FOR EXECUTION

### PRIORITY 1: Complete In-Progress

#### ARCH-003-PIVOT: Rule-Based Validation (Complete Decision Gate)
**Status**: InProgress - 98/98 tests passing, awaiting decision gate  
**Remaining Work**:
1. Ensure LM Studio running with SmolLM2-1.7B loaded
2. Run ModelTestHarness with temp=0.0
3. Execute 5 validation tests
4. Document results in tests/pre-validation/phase0-results.json
5. Apply decision gate: ≥70% = keep LLM, <70% = pure rule-based

**Files Ready**:
- tests/ModelTestingPlatform/ModelTestHarness.cs
- tests/ModelTestingPlatform/PromptConsistencyTester.cs  
- tests/ModelTestingPlatform/TemperatureSweep.cs
- scripts/DeployLogAnalyzer/JsonSchemaValidator.cs (12 tests passing)
- scripts/DeployLogAnalyzer/BusinessRulesValidator.cs (15 tests passing)
- scripts/DeployLogAnalyzer/ValidationPipeline.cs (12 tests passing)

**Command to Complete**:
```powershell
cd C:\P4NTH30N\tests\ModelTestingPlatform
dotnet test --filter "FullyQualifiedName~TemperatureSweep"
# Or manual execution via ModelTestHarness
```

---

### PRIORITY 2: RAG Layer (RAG-001)

**Status**: Proposed → Approved (Designer 90/100, Oracle 82/100)  
**Timeline**: 15 days (3 weeks)  
**Architecture**: MCP-Exposed RAG

**WEEK 1: Phase 1 - MCP Server Foundation + Security**

**Day 1-2: Core Components**
- [ ] src/RAG/McpServer.cs - MCP server with 6 tools
- [ ] src/RAG/EmbeddingService.cs - ONNX Runtime + fallback
- [ ] src/RAG/FaissVectorStore.cs - IndexFlatL2
- [ ] Register tools: rag_query, rag_ingest, rag_ingest_file, rag_status, rag_rebuild_index, rag_search_similar

**Day 3-5: Security (Oracle Conditions - MANDATORY)**
- [ ] Metadata filter security (server-side validation)
- [ ] Audit logging to EV3NT collection
- [ ] Query whitelist for filterable fields
- [ ] ERR0R sanitization pipeline (pre-ingestion)

**Reference**: 
- T4CT1CS/intel/RAG-001_IMPLEMENTATION_GUIDE.md
- T4CT1CS/intel/MCP_EXPOSED_RAG_ARCHITECTURE.md
- T4CT1CS/intel/RAG-001_FINAL_DECISION.md

**Oracle Blocking Conditions** (Must complete in Phase 1):
1. Server-side filter validation + audit logging
2. ERR0R sanitization: file paths→relative, line numbers→hash, credentials→REJECT
3. Python bridge integration (process pool + health checks)
4. Health monitoring integration

**WEEK 2: Phase 2 - Core Pipeline**
- [ ] QueryPipeline.cs (embed → search → join → format)
- [ ] IngestionPipeline.cs (chunk → embed → store)
- [ ] FileSystemWatcher for docs/
- [ ] MongoDB change streams for ERR0R
- [ ] 4-hour incremental rebuilds

**WEEK 3: Phase 3 - Production Hardening**
- [ ] Performance optimization (caching, batching)
- [ ] Nightly rebuild scheduler (3 AM)
- [ ] Error handling, logging, health checks
- [ ] Degraded mode for partial results
- [ ] Accuracy metrics tracking

**MCP Tools to Implement**:
```csharp
// rag_query - Search RAG for context
// Parameters: query (string), topK (int), filter (object)
// Returns: results array with content, source, score, metadata

// rag_ingest - Ingest content directly
// Parameters: content (string), source (string), metadata (object)

// rag_ingest_file - Ingest file
// Parameters: filePath (string), metadata (object)

// rag_status - Get system status
// Returns: vectorStore, ingestion, performance metrics

// rag_rebuild_index - Schedule rebuild
// Parameters: fullRebuild (bool), sources (array)

// rag_search_similar - Find similar documents
// Parameters: documentId (string), topK (int)
```

**Success Metrics**:
- Query latency: <100ms (p95)
- Embedding: 50-75ms single, batch >100/sec
- Index size: <500MB (target), <10GB (max)
- Accuracy: >90% (top-5)
- Query success rate: >99.5%

---

### PRIORITY 3: Model Testing Platform (TEST-001)

**Status**: Proposed → Ready  
**Priority**: Critical  
**Timeline**: 3-5 days

**Purpose**: Address ARCH-003 finding that smollm2-1.7b should have worked but only achieved 40%

**Components**:

**Day 1-2: Core Framework**
- [ ] tests/ModelTestingPlatform/ModelTestHarness.cs
  - ILlmBackend interface
  - LmStudioBackend implementation
  - MockLlmBackend for testing
  - Batch test execution
  
- [ ] tests/ModelTestingPlatform/TestCase.cs
  - Standardized test definition
  - Metadata support
  - Expected results tracking

- [ ] tests/ModelTestingPlatform/PromptTemplate.cs
  - Prompt versioning
  - Template management
  - A/B testing support

- [ ] tests/ModelTestingPlatform/ResultsDatabase.cs
  - MongoDB storage for test results
  - Historical comparison
  - Regression detection

**Day 2-3: Testing Tools**
- [ ] PromptConsistencyTester.cs
  - n=10 runs per prompt
  - Variance measurement (standard error)
  - Production readiness check (<5% variance)
  
- [ ] ContextWindowDiscovery.cs
  - Binary search for token limits
  - Input-only limit testing
  - Output-only limit testing
  - Total context testing

- [ ] TemperatureSweep.cs
  - Test temps: 0.0, 0.1, 0.3, 0.5, 0.7, 1.0
  - Measure accuracy, variance, latency per temp
  - Find optimal for deterministic tasks

**Day 3-4: Task Benchmarks**
- [ ] ConfigValidationBenchmark.cs (ARCH-003 task)
  - 20 test configs: 10 valid, 10 invalid
  - Metrics: precision, recall, F1, accuracy
  
- [ ] CodeGenerationBenchmark.cs (SWE-003 task)
  - Generate C# class from spec
  - Metrics: compile success, test pass, style compliance
  
- [ ] SemanticAnalysisBenchmark.cs
  - "Does this threshold make business sense?"
  - Metrics: human agreement score
  
- [ ] SummarizationBenchmark.cs
  - Context compression tasks
  - Metrics: ROUGE score, key info retention

**Day 4-5: Model Selection Matrix**
- [ ] ModelSelectionMatrix.json
  - Task→model mappings
  - Performance scores per task
  - Confidence intervals
  
- [ ] RecommendationEngine.cs
  - Suggest model for task
  - Cost-performance optimization
  - Fallback recommendations
  
- [ ] RegressionTestSuite.cs
  - Automated model validation
  - Detect performance degradation
  - Alert on regression

- [ ] Dashboard UI (optional)
  - Grafana visualization
  - Test results over time
  - Model comparison charts

**Deliverables**:
- tests/ModelTestingPlatform/
- tests/benchmarks/
- docs/MODEL_SELECTION_MATRIX.md
- scripts/run-model-tests.ps1

---

### PRIORITY 4: Workflow Optimization (Verify/Complete)

#### SWE-002: Multi-File Agentic Workflow
**Status**: Verify if already completed by WindFixer
**Components**:
- src/workflows/ParallelExecution.cs (10 calls/turn)
- src/workflows/MultiFileCoordinator.cs (5-7 files/turn)
- src/workflows/AgentIntegration.cs

**If not complete**:
- [ ] Parallel tool execution engine
- [ ] Dependency resolver
- [ ] Retry logic with circuit breaker
- [ ] Cross-reference validator
- [ ] Consistency checker

#### SWE-004: Decision Clustering Strategy
**Status**: Verify if already completed
**Components**:
- src/DecisionClusterManager.cs
- docs/DECISION_CLUSTERS.md
- T4CT1CS/decisions/clusters/

**If not complete**:
- [ ] Map 122 decisions into 20-24 clusters
- [ ] Priority ordering algorithm
- [ ] Session planner (5-6 decisions per session)
- [ ] Context handoff templates

#### STRATEGY-007: Explorer-Enhanced Workflows (Phase 1)
**Status**: Proposed → Ready (Hybrid)
**WindFixer Portion**:
- [ ] docs/explorer-delegation-guide.md
- [ ] Document pattern matching strategies
- [ ] Codebase discovery templates

**Note**: Phase 2 (agent updates) assigned to OpenFixer

#### STRATEGY-009: Parallel Agent Delegation (Phase 1)
**Status**: Proposed → Ready (Hybrid)
**WindFixer Portion**:
- [ ] docs/parallel-delegation-guide.md
- [ ] context-templates.json
- [ ] Document batch delegation patterns

**Note**: Phase 2 (AGENTS.md update) assigned to OpenFixer

---

### PRIORITY 5: Architecture

#### ARCH-003: Original LLM Deployment
**Status**: Proposed → Blocked by DEPLOY-002
**Note**: DEPLOY-002 should now be complete (LM Studio auth resolved)

**Components** (if unblocked):
- scripts/DeployLogAnalyzer/LmStudioClient.cs
- scripts/DeployLogAnalyzer/HealthChecker.cs
- scripts/DeployLogAnalyzer/FewShotPrompt.cs
- scripts/DeployLogAnalyzer/LogClassifier.cs
- scripts/DeployLogAnalyzer/DecisionTracker.cs
- scripts/DeployLogAnalyzer/ValidationPipeline.cs

**Action**: Verify if DEPLOY-002 completion unblocks this

---

## CONSOLIDATED FILE STRUCTURE

### Source Code
```
src/
├── RAG/                          # NEW: RAG-001
│   ├── McpServer.cs
│   ├── EmbeddingService.cs
│   ├── FaissVectorStore.cs
│   ├── QueryPipeline.cs
│   ├── IngestionPipeline.cs
│   ├── SanitizationPipeline.cs
│   ├── ContextBuilder.cs
│   └── HealthMonitor.cs
│
├── workflows/                    # VERIFY/COMPLETE
│   ├── ParallelExecution.cs      # SWE-002
│   ├── MultiFileCoordinator.cs   # SWE-002
│   ├── AgentIntegration.cs       # SWE-002
│   └── DecisionClusterManager.cs # SWE-004
│
└── ModelTesting/                 # NEW: TEST-001
    ├── ModelTestHarness.cs
    ├── TestCase.cs
    ├── PromptTemplate.cs
    ├── ResultsDatabase.cs
    ├── PromptConsistencyTester.cs
    ├── ContextWindowDiscovery.cs
    ├── TemperatureSweep.cs
    └── benchmarks/
        ├── ConfigValidationBenchmark.cs
        ├── CodeGenerationBenchmark.cs
        ├── SemanticAnalysisBenchmark.cs
        └── SummarizationBenchmark.cs
```

### Documentation
```
docs/
├── explorer-delegation-guide.md      # STRATEGY-007
├── parallel-delegation-guide.md      # STRATEGY-009
├── DECISION_CLUSTERS.md              # SWE-004
└── MODEL_SELECTION_MATRIX.md         # TEST-001
```

### Tests
```
tests/
├── RAG/
│   └── *Tests.cs
├── ModelTestingPlatform/
│   └── *.cs
└── benchmarks/
    └── *.cs
```

### Scripts
```
scripts/
├── rag/
│   └── rebuild-index.ps1
├── run-model-tests.ps1
└── deploy-agents.ps1       # Already exists (ARCH-002)
```

---

## EXECUTION ORDER

### Phase 1: Complete Current (Days 1-2)
1. **ARCH-003-PIVOT Decision Gate**
   - Run SmolLM2-1.7B temp=0.0 test
   - Document results
   - Mark decision Complete or update for pure rule-based

### Phase 2: Foundation (Days 3-7)
2. **TEST-001**: Model Testing Platform
   - Core framework
   - Testing tools
   - Task benchmarks
   
3. **RAG-001 Week 1**: MCP Server + Security
   - Core components
   - Oracle blocking conditions (MANDATORY)
   - Security layer

### Phase 3: Pipeline (Days 8-11)
4. **RAG-001 Week 2**: Core RAG Pipeline
   - Query pipeline
   - Ingestion pipeline
   - File watchers
   - Change streams

5. **Verify SWE-002/SWE-004**
   - Check if already complete
   - Finish if needed

### Phase 4: Documentation (Days 12-14)
6. **STRATEGY-007 Phase 1**: Explorer guide
7. **STRATEGY-009 Phase 1**: Delegation guide
8. **ARCH-003**: If unblocked

### Phase 5: Hardening (Days 15-17)
9. **RAG-001 Week 3**: Production hardening
   - Performance optimization
   - Monitoring
   - Degraded mode

---

## REPORTING PROTOCOL

Per FORGE-003 refined workflow:

### WindFixer → Strategist Report
**Trigger**: Decision complete or blocked
**Location**: T4CT1CS/handoffs/windfixer/
**Format**: Use WINDFIXER_REPORT_TEMPLATE.md

**Required**:
- Decision ID
- Files created/modified
- Build: 0 errors, 0 warnings
- Test results
- Constraints encountered
- Recommended OpenFixer actions (if blocked)

### Blockers to Report
If you encounter ANY of these:
- Cannot access OpenCode directories
- MCP registration requires OpenCode env
- Permission denied on system files
- Cross-platform integration fails

**Action**: Document in report, do NOT wait. Strategist will delegate to OpenFixer.

---

## CONSTRAINTS

### Hardware Reality
- **CPU**: AMD Ryzen 9 3900X (12-core, 24-thread)
- **RAM**: 128GB available
- **GPU**: GT 710 (useless, CPU-only mode)
- **Disk**: Ensure C:\P4NTH30N has 10GB+ free

### Software Environment
- **.NET**: 10.0 (target framework)
- **MongoDB**: Localhost:27017
- **LM Studio**: localhost:1234 (when running)
- **FAISS**: Will be installed via Python bridge

### Must Use
- **Model**: Opus 4.6 Thinking
- **Billing**: Per-prompt (cost-effective)
- **Style**: C# 12, file-scoped namespaces, primary constructors
- **Tests**: >90% coverage, all passing

---

## SUCCESS CRITERIA

Before marking complete, verify:

- [ ] Build: `dotnet build P4NTH30N.slnx` → 0 errors, 0 warnings
- [ ] Tests: `dotnet test UNI7T35T/UNI7T35T.csproj` → All pass
- [ ] Format: `dotnet csharpier check` → Exit code 0
- [ ] Decisions: Status updated in decisions-server
- [ ] Reports: Handoff documents in T4CT1CS/handoffs/

---

## REFERENCE DOCUMENTS

**Must Read Before Starting**:
1. T4CT1CS/intel/RAG-001_IMPLEMENTATION_GUIDE.md
2. T4CT1CS/intel/MCP_EXPOSED_RAG_ARCHITECTURE.md
3. T4CT1CS/intel/RAG-001_FINAL_DECISION.md
4. T4CT1CS/handoffs/WINDFIXER_REPORT_TEMPLATE.md
5. docs/workflows/FIXER_DEPLOYMENT_WORKFLOW.md (FORGE-003)

**For Specific Decisions**:
- SWE-002/SWE-004: Check existing implementation first
- STRATEGY-007/009: Phase 1 only (docs)
- ARCH-003: Verify if DEPLOY-002 unblocked

---

## GETTING STARTED

1. **Verify current state**:
   ```powershell
   cd C:\P4NTH30N
   dotnet build
   dotnet test
   ```

2. **Begin with ARCH-003-PIVOT decision gate**:
   - Ensure LM Studio running
   - Run temperature sweep
   - Document results

3. **Then proceed to RAG-001 Phase 1**:
   - Start with McpServer.cs
   - Implement security layer (Oracle conditions)
   - Report progress

4. **Parallel work**:
   - TEST-001 can proceed alongside RAG-001
   - Documentation (STRATEGY-007/009) can be done in gaps

---

**Begin execution with ARCH-003-PIVOT decision gate.**

**Execute.**
