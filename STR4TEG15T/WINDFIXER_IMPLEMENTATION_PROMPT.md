# WindFixer: The Forge Awakens - Implementation Sprint

**Status**: ALL DECISIONS APPROVED - EXECUTE AT WILL  
**Authority**: Nexus + Strategist (Atlas)  
**Scope**: Full implementation autonomy  
**Duration**: 6-8 weeks (you set the pace)  
**Support**: Forgewright available for complex bugs, OpenFixer for CLI/tool work

---

## The Big Picture

You are implementing the most significant infrastructure upgrade in P4NTHE0N history. Five decisions, fifty-seven action items, one cohesive transformation. This isn't maintenance. This is evolution.

**What We're Building**:
1. **Unbreakable Subagents** - Network errors become retries, not failures
2. **Autonomous Agent Ecosystem** - Every agent creates decisions, bugs auto-fix
3. **Bulletproof Testing Pipeline** - Signal to spin, fully validated
4. **FourEyes Vision System** - The machine learns to see
5. **ToolHive Architecture** - Clean context, organized tools, scalable foundation

**Why This Matters**:
The subagents have been failing. Network hiccups kill tasks. There's no human to retry when you're not watching. We're fixing that permanently. Then we're building testing infrastructure that proves our system works. Then we're activating vision capabilities that change how we develop. Then we're organizing our tools so they never pollute context windows again.

This is the sprint where P4NTHE0N becomes self-healing, self-testing, and self-improving.

---

## Your Decisions (All Approved, Execute in Any Order That Makes Sense)

### DECISION_037: Subagent Fallback System Hardening (INFRA-037)
**Oracle**: 92% | **Designer**: 90%

**The Problem**: Subagent tasks die on network errors. ECONNREFUSED, ECONNRESET, timeouts - no retry, no recovery, just death.

**Your Solution**: Build a resilience layer that breathes.
- ErrorClassifier - Knows network transient vs permanent vs logic errors
- BackoffManager - Exponential backoff (1s, 2s, 4s, 8s, 16s) with jitter
- ConnectionHealthMonitor - Pre-flight checks, keepalive pings
- NetworkCircuitBreaker - Per-endpoint tracking, 5-min cooldown
- TaskRestartManager - Auto-restart failed tasks (max 3)

**Files to Create** (9):
```
src/background/resilience/
├── error-classifier.ts
├── backoff-manager.ts
├── connection-health-monitor.ts
├── network-circuit-breaker.ts
├── task-restart-manager.ts
├── retry-metrics.ts
└── index.ts
```

**Files to Modify** (3):
- `src/background/background-manager.ts` (lines 1199-1257 - the retry loop)
- `src/config/schema.ts`
- `src/config/constants.ts`

**Success**: 95% error classification accuracy, 80% retry success, 3 retries average before success.

**Why First**: This fixes subagent reliability for ALL other work. Once this is solid, the other decisions benefit immediately.

---

### DECISION_038: Multi-Agent Decision-Making Workflow (FORGE-003)
**Oracle**: 95% | **Designer**: 92%

**The Problem**: Only Strategist creates decisions. Bugs block workflow. No cost optimization. Forgewright underutilized.

**Your Solution**: Elevate the entire ecosystem.
- Forgewright becomes PRIMARY agent (equal to you and OpenFixer)
- All agents create sub-decisions in their domain
- Bug-fix delegation: Detection → Forgewright → Resolution
- Model selection per task (Claude 3.5 Sonnet for code, GPT-4o Mini for reviews, etc.)
- Token budget tracking with alerts

**Files to Create** (4):
```
STR4TEG15T/tools/
├── decision-creator/         # Automated decision scaffolding
├── bug-reporter/             # Structured bug reporting
├── token-tracker/            # Usage analytics
└── consultation-requester/   # Standardized subagent calls
```

**Files to Modify** (3):
- `AGENTS.md` - Update with Forgewright as primary
- `STR4TEG15T/decisions/_templates/DECISION-TEMPLATE.md`
- All agent prompts (add ToolHive knowledge, bug-fix workflow)

**Success**: 90% bugs resolved by Forgewright, 70% routine tasks without Strategist, 20% token cost reduction.

**Integration Point**: This enables the bug-fix workflow that keeps you unblocked when you hit issues in other decisions.

---

### DECISION_035: End-to-End Jackpot Signal Testing Pipeline (TEST-035)
**Oracle**: 88% | **Designer**: 90%

**The Problem**: No systematic testing of signal-to-spin flow. Manual testing only. No validation that signals become actual spins.

**Your Solution**: Build the test harness that proves everything works.
- TestOrchestrator - Main controller
- TestSignalInjector - MongoDB SIGN4L injection with test flags
- CdpTestClient - CDP wrapper for test isolation
- LoginValidator - FireKirin/OrionStars login testing
- GameReadinessChecker - Page load + jackpot verification
- SpinExecutor - CDP-based spin execution
- SplashDetector - Jackpot splash detection
- VisionCapture - Frame storage for training data
- TestReportGenerator - JSON + MongoDB output

**Files to Create** (14):
```
UNI7T35T/TestHarness/
├── TestOrchestrator.cs
├── TestSignalInjector.cs
├── CdpTestClient.cs
├── LoginValidator.cs
├── GameReadinessChecker.cs
├── SpinExecutor.cs
├── SplashDetector.cs
├── VisionCapture.cs
├── TestReportGenerator.cs
├── TestConfiguration.cs
├── TestFixture.cs
UNI7T35T/Tests/
├── EndToEndTests.cs
UNI7T35T/Mocks/
├── MockFourEyesClient.cs
C0MMON/Entities/
└── TestResult.cs
```

**Files to Modify** (8):
- `UNI7T35T/Program.cs`
- `C0MMON/Infrastructure/Persistence/MongoCollectionNames.cs`
- `C0MMON/Infrastructure/Persistence/Repositories.cs`
- `C0MMON/Interfaces/IUnitOfWork.cs`
- `C0MMON/Infrastructure/Persistence/MongoUnitOfWork.cs`
- `C0MMON/Infrastructure/Persistence/MongoDatabaseProvider.cs`
- `C0MMON/Games/FireKirin.cs` (add QueryBalancesAsync)
- `C0MMON/Games/OrionStars.cs` (add QueryBalancesAsync)

**Success**: 100% signal injection, 95%+ login success, 90%+ spin execution, 10+ frames per test.

**Integration Point**: This generates training data for FourEyes (DECISION_036). The tests capture real game frames.

---

### DECISION_036: FourEyes Development Assistant Activation (FEAT-036)
**Oracle**: 85% | **Designer**: 90%

**The Problem**: FourEyes has 7 of 20 components complete but isn't integrated. No vision stream. No development assistance.

**Your Solution**: Activate the machine's eyes.
- FourEyesDevMode - Development mode with safety gates
- ConfirmationGate - Mandatory approval for all spins
- SafetyMonitor - Enforce limits, log everything
- StubJackpotDetector - Mock OCR for pipeline testing
- StubButtonDetector - Predefined button positions
- StubStateClassifier - Rules-based state detection
- CDPScreenshotReceiver - CDP-based frame capture (no OBS needed)
- VisionCommandHandler - Execute commands via CDP in H4ND
- VisionCommandPublisher - Publish to EventBus
- DeveloperDashboard - Real-time observation interface
- TrainingDataCapture - Frame capture and labeling

**Files to Create** (14):
```
W4TCHD0G/Development/
├── FourEyesDevMode.cs
├── DeveloperDashboard.cs
├── TrainingDataCapture.cs
├── ConfirmationGate.cs
W4TCHD0G/Vision/Stubs/
├── StubJackpotDetector.cs
├── StubButtonDetector.cs
├── StubStateClassifier.cs
W4TCHD0G/Vision/Implementations/
├── TesseractJackpotDetector.cs
├── TemplateButtonDetector.cs
├── HeuristicStateClassifier.cs
W4TCHD0G/Stream/Alternatives/
├── CDPScreenshotReceiver.cs
H4ND/Vision/
├── VisionCommandHandler.cs
├── VisionCommandPublisher.cs
└── VisionExecutionTracker.cs
```

**Files to Modify** (6):
- `C0MMON/Infrastructure/EventBuffer.cs` (verify interface)
- `C0MMON/Monitoring/HealthCheckService.cs`
- `H4ND/VisionCommandListener.cs`
- `H4ND/H4ND.cs`
- `W4TCHD0G/Agent/FourEyesAgent.cs`
- `W4TCHD0G/Agent/DecisionEngine.cs`

**Success**: Stream latency <500ms, 2-5 FPS processing, 80%+ jackpot OCR accuracy, 100% safety compliance.

**Integration Point**: Uses training data from TEST-035. Vision validation enables testing pipeline verification.

---

### DECISION_039: Tool Migration to MCP Server via ToolHive (MIGRATE-004)
**Oracle**: 94% | **Designer**: 91%

**The Problem**: Tools scattered in `~/.config/opencode/tools/`. Configs pollute context windows. No standardized tool exposure.

**Your Solution**: Organize everything through ToolHive.
- toolhive-gateway - Unified tool discovery and routing
- honeybelt-server - Migrated from honeybelt-cli
- mongodb-server - Consolidate mongodb-tool if different
- Environment-specific configs (dev/staging/prod)
- Agent knowledge update - All agents know ToolHive patterns

**Files to Create** (4):
```
tools/mcp-development/servers/
├── toolhive-gateway/
│   ├── src/
│   │   ├── index.ts
│   │   ├── registry.ts
│   │   ├── discovery.ts
│   │   └── health.ts
│   ├── package.json
│   └── tsconfig.json
├── honeybelt-server/
│   ├── src/
│   │   ├── index.ts
│   │   └── tools/
│   │       ├── operations.ts
│   │       └── reporting.ts
│   ├── package.json
│   └── tsconfig.json
STR4TEG15T/canon/
├── TOOLHIVE-INTEGRATION.md
├── MCP-MIGRATION-GUIDE.md
└── AGENT-TOOL-DISCOVERY.md
```

**Files to Modify** (5):
- `AGENTS.md` (ToolHive patterns)
- All agent prompts (~/.config/opencode/agents/*.md)
- `~/.config/opencode/mcp-config.json`
- `tools/mcp-development/servers/mongodb-server/` (if consolidation needed)
- `tools/mcp-development/servers/decisions-server/` (if updates needed)

**Success**: 100% tools migrated, 30%+ context reduction, tools discoverable via ToolHive.

**Integration Point**: This cleans up context for ALL agents, making every other decision more efficient.

---

## How To Approach This

**You Have Full Autonomy**:
- Execute decisions in any order that makes sense
- Create sub-decisions if you need to break work down
- Delegate to Forgewright if you hit complex bugs
- Call OpenFixer if you need CLI/tool work
- Use any model you prefer for any task

**Suggested Flow** (but you decide):
1. **Week 1**: DECISION_037 (subagent reliability) - This helps everything else
2. **Week 1-2**: DECISION_038 (agent workflow) - This enables bug-fix delegation
3. **Week 2-3**: DECISION_035 (testing pipeline) - This generates training data
4. **Week 3-4**: DECISION_036 (FourEyes) - This uses the training data
5. **Week 4-5**: DECISION_039 (tool migration) - This cleans everything up

**But Really**: If you see a better order, take it. If two decisions can be done in parallel, do it. If something blocks, escalate to Forgewright. If you need research, call Librarian. If you need code patterns, call Explorer.

---

## What You Have Access To

**Codebases**:
- P4NTHE0N: `/c/P4NTHE0N/` (H0UND, H4ND, C0MMON, W4TCHD0G, UNI7T35T)
- Plugin: `~/.config/opencode/dev/` (oh-my-opencode-theseus)
- Tools: `~/.config/opencode/tools/` (to be migrated)

**Existing Infrastructure**:
- MongoDB at 192.168.56.1:27017
- Chrome CDP at 192.168.56.1:9222
- CircuitBreaker, SystemDegradationManager, OperationTracker (all complete)
- CdpClient, CdpGameActions (operational)
- FourEyesAgent, VisionProcessor, DecisionEngine (partially complete)
- EventBuffer, HealthCheckService (placeholders)

**Test Resources**:
- Test accounts with balances ($5-20)
- FireKirin and OrionStars platforms
- OBS/CDP for vision streams

**Documentation**:
- All decision files in `STR4TEG15T/decisions/active/`
- Consultations in `STR4TEG15T/consultations/`
- Canon in `STR4TEG15T/canon/`
- AGENTS.md (updated with Forgewright as primary)
- WORKFLOW-001-Bug-Fix-Delegation.md
- GUIDE-001-Token-Optimization.md
- POLICY-001-Subagent-Report-Persistence.md

---

## When To Escalate

**To Forgewright**:
- Bug blocks progress >30 minutes
- Complex cross-cutting changes
- Tool creation needed
- Decision specification unclear

**To OpenFixer**:
- CLI commands needed (bun, npm, dotnet)
- Configuration file updates
- Plugin work outside P4NTHE0N source
- Tool migration tasks

**To Strategist**:
- Strategic direction unclear
- Decision conflicts
- Resource constraints
- Budget exceeded

---

## Success Metrics (Track These)

| Decision | Metric | Target |
|----------|--------|--------|
| INFRA-037 | Retry success rate | 80%+ |
| FORGE-003 | Bug resolution rate | 90%+ |
| TEST-035 | Spin execution success | 90%+ |
| FEAT-036 | Vision processing FPS | 2-5 |
| MIGRATE-004 | Context reduction | 30%+ |

---

## Validation Commands

**P4NTHE0N**:
```bash
dotnet build P4NTHE0N.slnx
dotnet test UNI7T35T/UNI7T35T.csproj
```

**Plugin**:
```bash
cd ~/.config/opencode/dev
bun run build
bun test
```

**Tools**:
```bash
cd ~/.config/opencode/tools/mcp-development/servers/[server-name]
npm install
npm run build
npm test
```

---

## The Bottom Line

You are not just implementing features. You are building the infrastructure that makes P4NTHE0N self-healing, self-testing, and capable of learning. The subagents will stop failing. The tests will prove correctness. FourEyes will see. The tools will organize. And through it all, the system will get stronger.

The Nexus believes in you. The Strategist has prepared the path. The decisions are approved. The Forge awaits your fire.

**Cook.**

---

*WindFixer Implementation Prompt*  
*The Forge Awakens Sprint*  
*All Systems Go*
