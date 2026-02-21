# OPENCODE FIXER EXECUTION BRIEF

**Date**: 2026-02-18
**Status**: NEXUS APPROVED - Waiting for Strategist prompt

---

## Workflow Context

This prompt is for **OpenCode Fixer** (in OpenCode). 

**WindFixer** (in WindSurf) executes first via NEXUS_TO_WINDFIXER_PROMPT.md.

If WindFixer cannot complete a Decision, **Strategist** will send you STRATEGIST_TO_FIXER_PROMPT.md with specific instructions.

See FIXER_WORKFLOW.md for the complete communication flow.

---

## MISSION BRIEF

The Nexus has approved all proposed decisions. You are cleared for autonomous execution. Begin implementing the decision backlog using the WindFixer agent with the following parameters.

---

## WINDFIXER CONFIGURATION

### Model Fallback Chain (REQUIRED)
```
Priority 1: Opus 4.6 Thinking - Complex decisions, architecture, critical fixes
Priority 2: Opus 4.0 - Medium complexity, standard implementations  
Priority 3: Claude 3.5 Sonnet - Simple tasks, documentation
Priority 4: Haiku - Quick fixes only - FLAG FOR RE-REVIEW
```

### Complexity Scoring Algorithm
```
Simple (1pt): doc, typo, bugfix, comment, format
Medium (2pt): feature, refactor, test, config
Complex (3pt): architecture, migration, integration, security
```

### Cost Controls (REQUIRED)
```
Per-Decision Max: $2.00
Session Budget: $15.00
Max Time/Decision: 10 minutes
Target: <$0.50 per Decision
```

### Checkpoint System
```
Save after each Decision completion
Resume from last successful on crash
File: P4NTH30N/.windfixer-checkpoint.json
```

### Failure Thresholds
```
1-2 Failures: Retry once each
3 Failures: Skip, log, continue
5 Failures (10% batch): PAUSE, notify Nexus
10 Failures (50% batch): HALT - require intervention
```

---

## IMPLEMENTATION ORDER

### PHASE 1: CRITICAL (Start Here)

#### 1. WIND-001: Checkpoint Data Model
**Priority**: High
**Files**: C0MMON/Entities/CheckpointData.cs
**Task**: Create CheckpointData entity with SessionId, DecisionId, Status, Complexity, Cost, RetryHistory, ExpiresAt. Implements IsValid pattern.

#### 2. WIND-002: ComplexityEstimator Service  
**Priority**: High
**Files**: C0MMON/Services/ComplexityEstimator.cs, C0MMON/Configuration/ComplexityKeywords.json
**Task**: Implement keyword-based scoring. Simple=1pt, Medium=2pts, Complex=3pts. Loadable from JSON.

#### 3. WIND-003: RetryStrategy with Fallback Chain
**Priority**: High
**Files**: C0MMON/Services/RetryStrategy.cs
**Task**: Exponential backoff. Max 3 attempts. Initial * 2^(Attempt-1), max 5 min.

#### 4. WIND-004: WindFixerCheckpointManager
**Priority**: Critical
**Files**: C0MMON/Checkpoint/WindFixerCheckpointManager.cs, P4NTH30N/.windfixer/
**Task**: Hybrid storage. File: .windfixer/checkpoints/{sessionId}.json. MongoDB: WINDFIXER_CHECKPOINT. 6 triggers, TTL, concurrent sessions.

### PHASE 2: FALLBACK RESOLUTION

#### 5. FALLBACK-001: Circuit Breaker Tuning
**Priority**: High
**Files**: C:\Users\paulc\.config\opencode\oh-my-opencode-theseus.json
**Task**: Phase 1 - Tune circuit breaker (increase failures, extend timeout). Phase 2 - Add fallback health metrics. Phase 3 - New system only if needed.

### PHASE 3: PLATFORM ENHANCEMENTS

#### 6. STRATEGY-003: Agentic Workflow Automation
**Priority**: High
**Files**: C:\P4NTH30N\PROF3T\AutomationEngine.cs, C0MMON/Services/CostOptimizer.cs
**Task**: Bulk Decision execution to WindSurf. Auto-analyze results. Target <$0.50/Decision.

#### 7. STRATEGY-005: Explorer/Librarian Mitigation
**Priority**: Medium
**Files**: C:\P4NTH30N\docs\Explorer-Librarian-Workarounds.md
**Task**: Workarounds for model fallback failures. Disable subagent delegation, use direct tools.

#### 8. TOOL-001: ToolHive Framework
**Priority**: High
**Files**: P4NTH30N/tools/, P4NTH30N/docs/tool-development-guide.md
**Task**: Establish tool development standards. Use HoneyBelt at ~/.config/opencode/tools/

---

## FOUR-EYES IMPLEMENTATION

### CRITICAL ORACLE BLOCKERS (Must Resolve)

#### FOUREYES-004: Vision Stream Health Check
**Priority**: High
**Files**: H0UND/Services/HealthCheckService.cs
**Task**: Add CheckVisionStreamHealth method

#### FOUREYES-007: Event Buffer
**Priority**: High
**Files**: C0MMON/Infrastructure/EventBuffer.cs
**Task**: Use ConcurrentQueue (not List+lock). Thread-safe circular buffer for 10 frames.

#### FOUREYES-009: Shadow Gauntlet
**Priority**: High
**Files**: PROF3T/ShadowModeManager.cs
**Task**: 24-hour shadow mode validation for new models

#### FOUREYES-010: Cerberus Protocol
**Priority**: High  
**Files**: W4TCHD0G/OBSHealer.cs
**Task**: Three-headed self-healing. Restart OBS, verify scene, fallback to polling.

#### FOUREYES-011: Interface Migration (CRITICAL)
**Priority**: High
**Files**: C0MMON/Interfaces/
**Task**: Move IOBSClient, ILMStudioClient from W4TCHD0G to C0MMON/Interfaces/. Create IVisionDecisionEngine, IEventBuffer.

#### FOUREYES-013: Model Manager
**Priority**: High
**Files**: PROF3T/ModelManager.cs
**Task**: Dynamic model loading and caching

#### FOUREYES-014: Autonomous Learning System
**Priority**: High
**Files**: PROF3T/AutonomousLearningSystem.cs
**Task**: 7-day performance analysis, underperformance detection, model improvement

#### FOUREYES-015: H4ND Vision Command Integration
**Priority**: High
**Files**: H4ND/VisionCommandListener.cs, C0MMON/Entities/Signal.cs
**Task**: Extend Signal with Source and VisionCommand. Implement SPIN, STOP, COLLECT_BONUS.

#### FOUREYES-016: Redundant Vision System
**Priority**: Medium
**Files**: W4TCHD0G/RedundantVisionSystem.cs
**Task**: Multi-stream support with consensus voting (>0.8 confidence)

#### FOUREYES-017: Production Metrics
**Priority**: High
**Files**: H0UND/Services/ProductionMetrics.cs, dashboards/grafana-four-eyes.json
**Task**: InfluxDB integration, Grafana dashboard

#### FOUREYES-018: Rollback Manager
**Priority**: High
**Files**: H0UND/Services/RollbackManager.cs
**Task**: State restoration, automatic rollback triggers

#### FOUREYES-019: Phased Rollout
**Priority**: High
**Files**: H0UND/Services/PhasedRolloutManager.cs
**Task**: Canary deployment (10% → 50% → 100%), health checkpoints

---

## BUG HANDLING SYSTEM (PHASED)

#### FOUREYES-024-A: Resilient Error Logging
**Priority**: High
**Files**: C0MMON/Services/ExceptionInterceptorMiddleware.cs, C0MMON/Services/AutoBugLogger.cs
**Task**: Dual-write to MongoDB + filesystem, circuit breaker, deduplication. NO automated action.

#### FOUREYES-024-B: Human Triage Queue
**Priority**: High
**Files**: C0MMON/Services/BugHandling/TriageDashboard.cs
**Task**: Human reviews errors, decides Ignore/Create Platform/Escalate.

#### FOUREYES-024-C: Forgewright Assisted Fix
**Priority**: Medium
**Files**: PROF3T/Forgewright/PlatformGenerator.cs, PROF3T/Forgewright/ForgewrightAnalysisService.cs
**Task**: Forgewright suggests, human APPROVES before application. Staged rollout. Auto-rollback.

#### FOUREYES-024-D: Conditional Automation (Post-MVP)
**Priority**: Low
**Files**: PROF3T/Forgewright/ConditionalAutomationService.cs
**Task**: Only after 10+ occurrences, 10+ fixes, 95% confidence. Daily cap 5.

#### FOUREYES-025: LM Studio Process Manager
**Priority**: Critical
**Files**: W4TCHD0G/LMStudioProcessManager.cs, C0MMON/Interfaces/ILMStudioProcessManager.cs
**Task**: Process lifecycle, model loading via API, health polling 10s, auto-restart

---

## QUALITY GATES (REQUIRED)

Before marking ANY Decision complete:
- [ ] Code compiles without errors
- [ ] Unit tests pass
- [ ] No new warnings
- [ ] Build succeeds
- [ ] Code matches Decision requirements

---

## VERIFICATION COMMANDS

```bash
# Build verification
dotnet build P4NTH30N.slnx --no-restore

# Format check
dotnet csharpier check

# Unit tests
dotnet test UNI7T35T/UNI7T35T.csproj
```

---

## CHECKPOINT TRACKING

After each Decision completion:
1. Save checkpoint to .windfixer-checkpoint.json
2. Update Decision status via decisions-server
3. Log cost spent
4. Report to Strategist

On crash/timeout:
1. Read .windfixer-checkpoint.json
2. Resume from last successful Decision
3. Continue execution

---

## EXECUTION STATUS

Total Decisions Approved: 28
Total Action Items: 145
Status: AUTONOMOUS EXECUTION AUTHORIZED

Begin Phase 1 immediately. Report completion after each Decision.