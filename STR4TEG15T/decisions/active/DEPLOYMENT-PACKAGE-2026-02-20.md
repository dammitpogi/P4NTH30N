# Deployment Package: Sprint 2026-02-20

**Strategist**: Atlas  
**Date**: 2026-02-20  
**Status**: Ready for Implementation  
**Primary Fixer**: WindFixer  
**Total Decisions**: 5  
**Total Action Items**: 57  
**Estimated Duration**: 6-8 weeks

---

## Executive Summary

This deployment package contains five approved decisions ready for implementation by WindFixer. The work spans testing infrastructure, vision system activation, subagent reliability, agent workflow improvements, and tool architecture migration. All decisions have high approval ratings and clear implementation paths.

**Deployment Order**:
1. DECISION_037 - Subagent Fallback System Hardening (INFRA)
2. DECISION_038 - Multi-Agent Decision-Making Workflow (FORGE)
3. DECISION_035 - End-to-End Jackpot Signal Testing Pipeline (TEST)
4. DECISION_036 - FourEyes Development Assistant Activation (FEAT)
5. DECISION_039 - Tool Migration to MCP Server (MIGRATE)

---

## Decision Summary

| # | Decision | ID | Category | Priority | Oracle | Designer | Status |
|---|----------|-----|----------|----------|--------|----------|--------|
| 1 | Subagent Fallback System Hardening | INFRA-037 | INFRA | Critical | 92% | 90% | ✅ Approved |
| 2 | Multi-Agent Decision-Making Workflow | FORGE-003 | FORGE | Critical | 95% | 92% | ✅ Approved |
| 3 | End-to-End Jackpot Signal Testing Pipeline | TEST-035 | TEST | Critical | 88% | 90% | ✅ Approved |
| 4 | FourEyes Development Assistant Activation | FEAT-036 | FEAT | Critical | 85% | 90% | ✅ Approved |
| 5 | Tool Migration to MCP Server via ToolHive | MIGRATE-004 | INFRA | Critical | 94% | 91% | ✅ Approved |

---

## Phase 1: Infrastructure Foundation (Week 1)

### DECISION_037: Subagent Fallback System Hardening

**Problem**: Subagent tasks fail on transient network errors without adequate retry

**Solution**: Implement exponential backoff, network circuit breaker, and automatic task restart

**Files to Create (9)**:
- `src/background/resilience/error-classifier.ts`
- `src/background/resilience/backoff-manager.ts`
- `src/background/resilience/connection-health-monitor.ts`
- `src/background/resilience/network-circuit-breaker.ts`
- `src/background/resilience/task-restart-manager.ts`
- `src/background/resilience/retry-metrics.ts`
- `src/background/resilience/index.ts`

**Files to Modify (3)**:
- `src/background/background-manager.ts` (lines 1199-1257)
- `src/config/schema.ts`
- `src/config/constants.ts`

**Success Criteria**:
- 95%+ network error classification accuracy
- 80%+ retry success rate
- Average 3 retries before success

---

### DECISION_038: Multi-Agent Decision-Making Workflow

**Problem**: Only Strategist creates decisions, bugs block workflow, no cost optimization

**Solution**: Elevate Forgewright to primary agent, enable all agents to create sub-decisions, implement model selection

**Files to Create (4)**:
- `STR4TEG15T/tools/decision-creator/`
- `STR4TEG15T/tools/bug-reporter/`
- `STR4TEG15T/tools/token-tracker/`
- `STR4TEG15T/canon/WORKFLOW-001-Bug-Fix-Delegation.md`

**Files to Modify (3)**:
- `AGENTS.md`
- `STR4TEG15T/decisions/_templates/DECISION-TEMPLATE.md`
- Agent prompts (all)

**Success Criteria**:
- 90%+ bugs resolved by Forgewright
- 70%+ routine tasks need no Strategist intervention
- 20%+ token cost reduction

---

## Phase 2: Testing Infrastructure (Week 2-3)

### DECISION_035: End-to-End Jackpot Signal Testing Pipeline

**Problem**: No systematic testing of signal-to-spin pipeline

**Solution**: Create test harness with signal injection, CDP validation, spin execution, splash detection

**Files to Create (14)**:
- `UNI7T35T/TestHarness/TestOrchestrator.cs`
- `UNI7T35T/TestHarness/TestSignalInjector.cs`
- `UNI7T35T/TestHarness/CdpTestClient.cs`
- `UNI7T35T/TestHarness/LoginValidator.cs`
- `UNI7T35T/TestHarness/GameReadinessChecker.cs`
- `UNI7T35T/TestHarness/SpinExecutor.cs`
- `UNI7T35T/TestHarness/SplashDetector.cs`
- `UNI7T35T/TestHarness/VisionCapture.cs`
- `UNI7T35T/TestHarness/TestReportGenerator.cs`
- `UNI7T35T/TestHarness/TestConfiguration.cs`
- `C0MMON/Entities/TestResult.cs`
- `UNI7T35T/TestHarness/TestFixture.cs`
- `UNI7T35T/Tests/EndToEndTests.cs`
- `UNI7T35T/Mocks/MockFourEyesClient.cs`

**Files to Modify (8)**:
- `UNI7T35T/Program.cs`
- `C0MMON/Infrastructure/Persistence/MongoCollectionNames.cs`
- `C0MMON/Infrastructure/Persistence/Repositories.cs`
- `C0MMON/Interfaces/IUnitOfWork.cs`
- `C0MMON/Infrastructure/Persistence/MongoUnitOfWork.cs`
- `C0MMON/Infrastructure/Persistence/MongoDatabaseProvider.cs`
- `C0MMON/Games/FireKirin.cs`
- `C0MMON/Games/OrionStars.cs`

**Success Criteria**:
- 100% signal injection success
- 95%+ login success
- 90%+ spin execution success

---

## Phase 3: Vision System (Week 3-4)

### DECISION_036: FourEyes Development Assistant Activation

**Problem**: FourEyes components exist but not integrated for development use

**Solution**: Activate FourEyes in development mode with safety gates, dashboard, training data capture

**Files to Create (14)**:
- `W4TCHD0G/Development/FourEyesDevMode.cs`
- `W4TCHD0G/Development/DeveloperDashboard.cs`
- `W4TCHD0G/Development/TrainingDataCapture.cs`
- `W4TCHD0G/Development/ConfirmationGate.cs`
- `W4TCHD0G/Vision/Stubs/StubJackpotDetector.cs`
- `W4TCHD0G/Vision/Stubs/StubButtonDetector.cs`
- `W4TCHD0G/Vision/Stubs/StubStateClassifier.cs`
- `W4TCHD0G/Vision/Implementations/TesseractJackpotDetector.cs`
- `W4TCHD0G/Vision/Implementations/TemplateButtonDetector.cs`
- `W4TCHD0G/Vision/Implementations/HeuristicStateClassifier.cs`
- `W4TCHD0G/Stream/Alternatives/CDPScreenshotReceiver.cs`
- `H4ND/Vision/VisionCommandHandler.cs`
- `H4ND/Vision/VisionCommandPublisher.cs`
- `H4ND/Vision/VisionExecutionTracker.cs`

**Files to Modify (6)**:
- `C0MMON/Infrastructure/EventBuffer.cs`
- `C0MMON/Monitoring/HealthCheckService.cs`
- `H4ND/VisionCommandListener.cs`
- `H4ND/H4ND.cs`
- `W4TCHD0G/Agent/FourEyesAgent.cs`
- `W4TCHD0G/Agent/DecisionEngine.cs`

**Success Criteria**:
- Stream latency <500ms
- Vision processing 2-5 FPS
- Jackpot OCR accuracy >80%
- Safety compliance 100%

---

## Phase 4: Tool Architecture (Week 4-5)

### DECISION_039: Tool Migration to MCP Server via ToolHive

**Problem**: Tools scattered in legacy structure, configs pollute context windows

**Solution**: Migrate tools to MCP Server architecture, expose via ToolHive, standardize configs

**Files to Create (4)**:
- `tools/mcp-development/servers/toolhive-gateway/`
- `tools/mcp-development/servers/honeybelt-server/`
- `STR4TEG15T/canon/GUIDE-001-Token-Optimization.md`
- Environment-specific configs

**Files to Modify (5)**:
- `AGENTS.md` (ToolHive patterns)
- Agent prompts (all)
- `~/.config/opencode/mcp-config.json`
- `tools/mcp-development/servers/mongodb-server/` (if consolidation needed)
- `tools/mcp-development/servers/decisions-server/` (if updates needed)

**Success Criteria**:
- 100% tools migrated to MCP servers
- Tools discoverable via ToolHive
- Context windows reduced 30%+

---

## Implementation Schedule

```
Week 1: Infrastructure Foundation
├── DECISION_037: Subagent Fallback System Hardening
│   └── Days 1-3: ErrorClassifier + BackoffManager
│   └── Days 4-5: Health Monitor + Circuit Breaker
│
├── DECISION_038: Multi-Agent Decision-Making Workflow
│   └── Days 1-2: Forgewright primary status, AGENTS.md update
│   └── Days 3-5: Bug-fix workflow, token tracking tools
│
Week 2: Testing Infrastructure Foundation
├── DECISION_035: End-to-End Testing Pipeline
│   └── Days 1-3: TestOrchestrator, SignalInjector, CdpTestClient
│   └── Days 4-5: LoginValidator, GameReadinessChecker
│
Week 3: Testing Completion + Vision Foundation
├── DECISION_035: Testing Pipeline (continued)
│   └── Days 1-2: SpinExecutor, SplashDetector, VisionCapture
│   └── Days 3-5: ReportGenerator, integration tests
│
├── DECISION_036: FourEyes Activation (Foundation)
│   └── Days 1-3: FourEyesDevMode, ConfirmationGate, SafetyMonitor
│   └── Days 4-5: Stub detectors, CDPScreenshotReceiver
│
Week 4: Vision Integration + Tool Migration
├── DECISION_036: FourEyes Activation (Integration)
│   └── Days 1-3: VisionCommandHandler, EventBus subscription
│   └── Days 4-5: DeveloperDashboard, training data capture
│
├── DECISION_039: Tool Migration
│   └── Days 1-2: Tool inventory, assessment
│   └── Days 3-5: Create toolhive-gateway, migrate honeybelt-cli
│
Week 5-6: Completion + Real Models
├── DECISION_036: FourEyes Activation (Real Models)
│   └── Week 5: Tesseract OCR, Template matching
│   └── Week 6: State classifier, performance optimization
│
├── DECISION_039: Tool Migration (Completion)
│   └── Week 5: Register tools with ToolHive
│   └── Week 6: Update agents, documentation, training
```

---

## Validation Commands

**For DECISION_037** (Plugin):
```bash
cd ~/.config/opencode/dev
bun run build
bun test src/background/resilience/
```

**For DECISION_035, 036** (P4NTH30N):
```bash
cd /c/P4NTH30N
dotnet build P4NTH30N.slnx
dotnet test UNI7T35T/UNI7T35T.csproj
```

**For DECISION_039** (Tools):
```bash
cd ~/.config/opencode/tools/mcp-development/servers/honeybelt-server
npm install
npm run build
npm test
```

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Subagent reliability during implementation | DECISION_037 Phase 1 first, then use hardened system |
| Token budget overrun | DECISION_038 token tracking, model selection guidelines |
| Test account bans | DECISION_035 dedicated test accounts, $0.50 max bet |
| FourEyes incorrect detections | DECISION_036 mandatory confirmation gates, stub detectors first |
| Tool migration breakage | DECISION_039 backward compatibility, test thoroughly |

---

## Success Metrics

| Decision | Key Metric | Target |
|----------|-----------|--------|
| INFRA-037 | Retry success rate | 80%+ |
| FORGE-003 | Bug resolution rate | 90%+ |
| TEST-035 | Spin execution success | 90%+ |
| FEAT-036 | Vision processing FPS | 2-5 FPS |
| MIGRATE-004 | Context reduction | 30%+ |

---

## WindFixer Deployment Instructions

### Pre-Flight Checklist
- [ ] All 5 decisions reviewed and understood
- [ ] Development environment ready
- [ ] Test accounts available for DECISION_035
- [ ] MongoDB accessible
- [ ] Chrome CDP available

### Phase Execution
1. **Start with INFRA-037** - This fixes subagent reliability for all other work
2. **Complete FORGE-003** - Establishes bug-fix workflow for issues encountered
3. **Parallel TEST-035 + FEAT-036** - These can overlap after foundation is set
4. **Finish with MIGRATE-004** - Tool migration is lowest priority

### Daily Reporting
Report daily to Strategist:
- Files created/modified
- Tests passing/failing
- Blockers encountered
- Token usage
- Next day plan

### Escalation
Escalate to Forgewright if:
- Bug blocks progress >30 minutes
- Complex cross-cutting changes needed
- Tool creation required
- Decision specification unclear

---

## Documentation Package

All decisions include:
- Full specification with requirements
- File lists (create/modify)
- Architecture diagrams
- Success criteria
- Risk mitigations
- Consultation logs (Oracle + Designer)

Additional documentation:
- `AGENTS.md` - Updated agent reference
- `WORKFLOW-001-Bug-Fix-Delegation.md` - Bug fix process
- `GUIDE-001-Token-Optimization.md` - Cost optimization
- `POLICY-001-Subagent-Report-Persistence.md` - Report retention

---

*Deployment Package*  
*Sprint 2026-02-20*  
*Ready for WindFixer Implementation*
