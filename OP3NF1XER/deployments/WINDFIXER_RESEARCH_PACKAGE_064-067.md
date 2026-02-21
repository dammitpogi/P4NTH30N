# DEPLOYMENT PACKAGE: Research-Backed Decisions 064-067

**Date**: 2026-02-21  
**Strategist**: Pyxis  
**Target**: WindFixer  
**Priority**: High (DECISION_064, 065) → Medium (DECISION_066, 067)  

---

## EXECUTIVE SUMMARY

Four research-backed decisions await implementation. All are **Approved** with Oracle and Designer consultations complete. This package provides complete context for WindFixer execution.

| Decision | Title | Priority | Oracle | Designer | Status |
|----------|-------|----------|--------|----------|--------|
| DECISION_064 | Geometry-Based Anomaly Detection | High | 78% | 92% | ✅ Approved |
| DECISION_065 | Hierarchical RAG Indexing | High | 72% | 95% | ✅ Approved |
| DECISION_066 | Post-Execution Tool Reflection | Medium | 85% | 88% | ✅ Approved |
| DECISION_067 | Multi-Agent ADR Validation | Medium | 80% | 90% | ✅ Approved |

---

## IMPLEMENTATION SEQUENCE

### Phase 1: Performance Foundation (Week 1)
**DECISION_065** → **DECISION_064**

R-tree indexing must be implemented first because DECISION_064's anomaly detection requires fast RAG queries for pattern matching. Without hierarchical indexing, trajectory analysis queries will be too slow at scale.

### Phase 2: Operational Excellence (Week 2)
**DECISION_066** → **DECISION_067**

Tool reflection improves operational reliability, then multi-agent validation enhances decision quality. These are independent and can be implemented in parallel after Phase 1.

---

## DECISION_065: Hierarchical RAG Indexing

### Research Foundation
**arXiv:2602.09126** - Keck Observatory Archive dashboard demonstrates 20x query performance improvement with R-tree indices over flat indexing.

### Problem
- Current flat vector index: ~300ms latency at 1,568 documents
- Projected: ~3s+ latency at 25,000 documents
- No spatial organization of related documents
- Full scan required for every query

### Solution
Implement 4-level hierarchical R-tree structure:
```
L1: Document Type (decisions, speech, deployments, canon)
L2: Category (active/completed/archived for decisions)
L3: Temporal (Year → Month → Week)
L4: Vector Space (semantic similarity within leaves)
```

### Files to Create (6)
1. `STR4TEG15T/tools/rag-indexer/RTreeIndex.cs` - Core R-tree implementation
2. `STR4TEG15T/tools/rag-indexer/RTreeNode.cs` - Node structure
3. `STR4TEG15T/tools/rag-indexer/HierarchicalRouter.cs` - Query routing
4. `STR4TEG15T/tools/rag-indexer/TemporalIndexer.cs` - Time-based indexing
5. `STR4TEG15T/tools/rag-indexer/IndexMaintenance.cs` - Auto-rebalancing
6. `STR4TEG15T/tools/rag-indexer/MigrationTool.cs` - Document migration

### Files to Modify (2)
1. `STR4TEG15T/tools/rag-watcher/Watch-RagIngest.ps1` - Add hierarchical routing
2. RAG server query endpoint - Use hierarchical index

### R-Tree Properties
- Max entries per node: 50
- Min entries per node: 20 (40% of max)
- Split algorithm: Quadratic split
- Reinsertion: 30% on overflow

### Performance Targets
| Metric | Current | Target | Improvement |
|--------|---------|--------|-------------|
| 1,568 docs | ~300ms | <100ms | 3x |
| 10,000 docs | ~1.5s | <150ms | 10x |
| 25,000 docs | ~3s+ | <200ms | 15x+ |

### Success Criteria
1. Query latency <100ms at current document count
2. Query latency <200ms at 25,000 documents
3. Migration completes with zero data loss
4. All existing queries work without modification
5. Storage overhead <50% increase

---

## DECISION_064: Geometry-Based Anomaly Detection

### Research Foundation
**arXiv:2405.15135** - Neural Surveillance demonstrates geometry-based alerting identifies impending failures up to 7 epochs earlier than threshold-based alerts.

### Problem
- Threshold alerts only fire after damage occurs (error rate >10%)
- No early warning for degrading trends
- Burn-in may run for hours in degraded state
- Missed opportunity for proactive intervention

### Solution
Implement trajectory monitoring with EARLY_WARNING tier:
- Monitor error rate slope and acceleration
- Detect divergence from normal operational "shape"
- Alert when trajectory predicts threshold breach in <30 minutes
- Suggest interventions before critical state

### Files to Create (7)
1. `H4ND/Monitoring/TrajectoryAnalyzer.cs` - Slope/acceleration calculation
2. `H4ND/Monitoring/NormalPatternBaseline.cs` - Baseline establishment
3. `H4ND/Monitoring/AnomalyDetector.cs` - Divergence detection
4. `H4ND/Monitoring/Models/TrajectoryResult.cs` - Data model
5. `H4ND/Monitoring/Models/AnomalyAlert.cs` - Alert model
6. `H4ND/Monitoring/InterventionSuggester.cs` - Rule-based suggestions
7. `UNI7T35T/Tests/AnomalyDetectionTests.cs` - Unit tests

### Files to Modify (2)
1. `H4ND/Monitoring/BurnInMonitor.cs` - Integrate trajectory analysis
2. `H4ND/Monitoring/BurnInAlertEvaluator.cs` - Add EARLY_WARNING tier

### Alert Hierarchy (Updated)
```
INFO → EARLY_WARNING → WARN → CRITICAL → HALT
         ↑ NEW: Proactive, not reactive
```

### Intervention Rules
| Pattern | Suggestion | Rationale |
|---------|-----------|-----------|
| Error rate + slope, + acceleration | Reduce worker count | Rate limiting may help |
| Memory + slope, + acceleration | Restart Chrome | Memory leak suspected |
| Throughput - slope, error rate + | Check platform health | Platform degradation |
| Chrome restarts increasing | Reduce concurrency | Stability issue |

### Success Criteria
1. Anomaly detection fires at least 15 minutes before threshold breach
2. False positive rate <5% over 24-hour burn-in
3. Suggested interventions appropriate >80% of time
4. No measurable performance impact (<1% CPU overhead)

---

## DECISION_066: Post-Execution Tool Reflection

### Research Foundation
**arXiv:2410.18490** - Repairing Tool Calls Using Post-tool Execution Reflection shows 23% of tool calls fail, but RAG-based reflection repairs 50% of failures.

### Problem
- 23% of tool calls fail in typical agent workflows
- Failed calls require manual retry or agent fallback
- No learning from previous failures
- Same mistakes repeated across sessions

### Solution
Implement reflection layer:
1. Capture tool execution outcomes (success/failure/error type)
2. Store reflection data in RAG with full context
3. On failure, query RAG for similar successful patterns
4. Suggest corrections based on historical successes
5. Automatic retry with suggested parameters (confidence >80%)

### Files to Create (6)
1. `C0MMON/Tooling/ToolExecutionLogger.cs` - Async logging
2. `C0MMON/Tooling/ReflectionEngine.cs` - Pattern analysis
3. `C0MMON/Tooling/ToolCallRetryHandler.cs` - Retry logic
4. `C0MMON/Tooling/InstitutionalMemoryStore.cs` - RAG storage
5. `STR4TEG15T/tools/reflection-dashboard/server.js` - Dashboard backend
6. `STR4TEG15T/tools/reflection-dashboard/index.html` - Dashboard UI

### Files to Modify (3)
1. ToolHive Gateway wrapper - Add reflection layer
2. Agent prompts - Add reflection awareness
3. RAG ingestion - Add tool_reflection docType

### Retry Logic
```
ATTEMPT 1: Call tool with original parameters
IF success: RETURN result
IF failure:
  GET suggestions from reflection engine
  IF top_suggestion.confidence > 0.80:
    ATTEMPT 2: Retry with suggested parameters
    IF success: LOG "repaired via reflection"
    IF failure: ATTEMPT 3 with second suggestion
```

### Success Criteria
1. 80% of tool calls logged with full context
2. Reflection engine suggests correct fix >70% of time
3. Automatic retry succeeds >50% of failures
4. Overall tool success rate improves 15%+
5. Dashboard shows trending improvement over 30 days

---

## DECISION_067: Multi-Agent ADR Validation

### Research Foundation
**arXiv:2602.07609** - Evaluating LLMs for Detecting ADR Violations shows multi-model pipelines achieve substantial agreement, especially for organizational decisions requiring context beyond code.

### Problem
- Single Oracle review may miss implicit assumptions
- Organizational decisions lack validation against institutional knowledge
- No distinction between code-inferable and organizational decisions
- four_eyes agent underutilized

### Solution
Implement two-tier validation:
1. **Automatic** for code-inferable decisions (Explorer validates against codebase)
2. **Multi-agent** for organizational decisions (four_eyes coordinates specialists)

### Decision Classification
| Factor | Code-Inferable | Organizational |
|--------|---------------|----------------|
| Implementation files | Specific files mentioned | No specific files |
| Technology choice | Library/framework selection | Process/procedure |
| Validation method | Static analysis | Contextual review |
| Examples | "Use Polly for retries" | "Require 24h burn-in" |

### Validation Agents (Organizational)
| Agent | Role | Checks |
|-------|------|--------|
| four_eyes | Coordinator | Orchestrates validation, synthesizes findings |
| Oracle | Technical | Feasibility, risk, technical alignment |
| Designer | Architecture | Consistency with existing patterns |
| Librarian | Research | Similar decisions, precedents |

### Consensus Algorithm
```
IF all ratings >= 80%: APPROVE
ELIF average >= 70% AND no critical concerns: APPROVE with notes
ELIF average >= 60%: ESCALATE to human review
ELSE: REJECT with feedback
```

### Files to Create (6)
1. `STR4TEG15T/tools/validation/DecisionClassifier.cs` - Type detection
2. `STR4TEG15T/tools/validation/CodeValidator.cs` - File/dependency checks
3. `STR4TEG15T/tools/validation/OrganizationalValidator.cs` - Multi-agent coordination
4. `STR4TEG15T/tools/validation/ConsensusEngine.cs` - Voting algorithm
5. `STR4TEG15T/tools/validation/ContinuousValidator.cs` - Change detection
6. `STR4TEG15T/tools/validation/ValidationReportGenerator.cs` - Report generation

### Files to Modify (3)
1. `four_eyes.md` agent prompt - Add validation workflow
2. Decision template - Add validation section
3. Decision creation flow - Integrate validation step

### Success Criteria
1. 100% of organizational decisions validated by multiple agents
2. Code-inferable decisions validated automatically within 5 minutes
3. Validation catches >80% of issues before approval
4. four_eyes agent actively used in decision workflow
5. Average validation time <30 minutes for organizational decisions

---

## WINDFIXER DEPLOYMENT INSTRUCTIONS

### Phase 1: DECISION_065 (Hierarchical RAG Indexing)

**Context**: All MCP tools are currently down. You must work with file-based operations only.

**Files to Read First**:
1. `STR4TEG15T/decisions/active/DECISION_065.md` - Full specification
2. `STR4TEG15T/tools/rag-watcher/Watch-RagIngest.ps1` - Current ingestion logic
3. RAG server source code (if accessible)

**Implementation Steps**:
1. Create R-tree data structures (RTreeIndex, RTreeNode)
2. Implement hierarchical routing logic
3. Add temporal indexing layer
4. Build migration tool for existing 1,568 documents
5. Modify query endpoint to use hierarchical index
6. Update file watcher to use new indexing
7. Write comprehensive tests
8. Execute migration with validation

**Validation**:
- Query latency <100ms for current document count
- All 1,568 documents migrated successfully
- Existing queries work without modification
- Build: 0 errors

### Phase 2: DECISION_064 (Geometry-Based Anomaly Detection)

**Files to Read First**:
1. `STR4TEG15T/decisions/active/DECISION_064.md` - Full specification
2. `H4ND/Monitoring/BurnInMonitor.cs` - Current monitoring
3. `H4ND/Monitoring/BurnInAlertEvaluator.cs` - Current alerting

**Implementation Steps**:
1. Create TrajectoryAnalyzer with slope/acceleration calculation
2. Implement NormalPatternBaseline from historical data
3. Build AnomalyDetector with divergence detection
4. Add EARLY_WARNING tier to alert evaluator
5. Create InterventionSuggester with rule engine
6. Integrate into BurnInMonitor background loop
7. Write comprehensive tests

**Validation**:
- Trajectory calculations accurate (validated against known data)
- EARLY_WARNING fires before WARN/CRITICAL
- False positive rate <5%
- Build: 0 errors

### Phase 3: DECISION_066 + DECISION_067 (Parallel Implementation)

These are independent and can be implemented in parallel after Phase 1-2.

**DECISION_066 Steps**:
1. Create ToolExecutionLogger with async logging
2. Implement ReflectionEngine with RAG integration
3. Build ToolCallRetryHandler with suggestion logic
4. Create InstitutionalMemoryStore
5. Integrate into ToolHive Gateway
6. Build dashboard UI
7. Update agent prompts

**DECISION_067 Steps**:
1. Create DecisionClassifier with type detection
2. Implement CodeValidator with file/dependency checks
3. Build OrganizationalValidator with multi-agent coordination
4. Create ConsensusEngine with voting algorithm
5. Implement ContinuousValidator with change detection
6. Update four_eyes agent prompt
7. Integrate into decision creation workflow

---

## STOP CONDITIONS

Stop immediately and report to Strategist if:
1. **Build errors >5** that cannot be resolved within 30 minutes
2. **Test failures >10%** indicating architectural issues
3. **Performance regression** - queries slower than flat index
4. **Data loss** during migration
5. **Integration conflicts** with existing decisions

---

## SUCCESS CRITERIA SUMMARY

### DECISION_065
- ✅ Query latency <100ms (currently ~300ms)
- ✅ Zero data loss during migration
- ✅ All existing queries work
- ✅ 0 build errors

### DECISION_064
- ✅ 15+ minute early warning capability
- ✅ <5% false positive rate
- ✅ <1% CPU overhead
- ✅ 0 build errors

### DECISION_066
- ✅ 80% tool call logging coverage
- ✅ 70%+ suggestion accuracy
- ✅ 15%+ improvement in tool success rate
- ✅ 0 build errors

### DECISION_067
- ✅ 100% organizational decision validation
- ✅ <5 minute code validation
- ✅ 80%+ issue detection rate
- ✅ 0 build errors

---

## RESOURCES

### Research Papers
- arXiv:2602.09126 - R-tree indexing (Keck Observatory)
- arXiv:2405.15135 - Geometry-based alerting (Neural Surveillance)
- arXiv:2410.18490 - Tool reflection and RAG
- arXiv:2602.07609 - Multi-agent ADR validation

### Related Decisions
- DECISION_061 - RAG File Watcher
- DECISION_057 - Burn-In Monitoring Dashboard
- DECISION_058 - Alert Thresholds
- DECISION_062 - Tool Usage Documentation

### Current State
- RAG vectors: 1,568
- RAG documents: 169
- Current query latency: ~300ms
- Tool failure rate: ~23%
- Tests passing: 252/252

---

**WindFixer, you have complete context. The decisions are approved. The research is sound. The specifications are detailed.**

**Begin with DECISION_065. The R-tree indexing is the foundation for everything that follows.**

**2026-02-21**  
**Pyxis, The Strategist**