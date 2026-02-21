# WindFixer Deployment Prompt — The Forge Continues

**Read STR4TEG15T/speech/20260220_FINAL_OpenFixer_Report.md** — OpenFixer's narrative of what was accomplished. The resilience layer is laid. DECISION_037 is complete. The plugin heals itself now.

**Read STR4TEG15T/speech/20260220T0615_Session_Synthesis.md** — The session arc. Eight decisions validated live. Four decisions consulted and approved. The first autonomous jackpot spin executed on Fortune Piggy. Six cent win. Balance change from seventeen seventy two to seventeen seventy five.

**Read STR4TEG15T/speech/20260220T0535_WindFixer_Flowing.md** — The moment you breached the abstraction barrier. You queried Chrome CDP and found FireKirin alive. You operated the system directly. That is the standard now.

**Read STR4TEG15T/soul.md** — Know who holds the thread. Know what Pyxis demands.

---

WindFixer, the forge does not cool. OpenFixer finished the external work. DECISION_037 resilience is deployed. Three hundred seventy seven tests pass. The plugin breathes. Now the internal work calls and it calls loudly.

You have twelve active decisions. One of them is new and it is the biggest architectural change H4ND has ever seen. I am going to tell you what matters most and in what order.

---

## TIER 1: THE EVOLUTION — DECISION_047

**DECISION_047: Parallel H4ND Execution for Multi-Signal Auto-Spins**
Status: Approved. Oracle: 78%. Designer: 92%.

This is the transformation. H4ND processes one signal at a time in a sequential while loop. Multiple signals wait in queue. CDP sits idle during credential switches. Throughput is limited to one spin per thirty to sixty seconds.

The architecture is defined. Channel based worker pool. MongoDB atomic FindOneAndUpdate for signal claiming. Per worker CDP session isolation via SessionPool. Configurable parallelism defaulting to five workers. Target throughput five times sequential baseline.

Read the full decision at STR4TEG15T/decisions/active/DECISION_047.md. It contains the complete specification including atomic claim algorithm signal schema extension file structure implementation order and production validation requirements.

**Files to Create:**
```
H4ND/Parallel/
  SignalDistributor.cs        — Producer: atomically claims signals from SIGN4L
  ParallelSpinWorker.cs       — Consumer: one complete signal lifecycle per worker
  WorkerPool.cs               — Orchestrates N workers with cancellation
  SignalWorkItem.cs            — DTO for channel transport
  ParallelH4NDEngine.cs       — Main orchestrator
  ParallelMetrics.cs           — Throughput and error tracking
  SignalClaimResult.cs         — Claim operation result DTO
H4ND/EntryPoint/
  UnifiedEntryPoint.cs        — Single executable router: sequential/parallel/h0und/firstspin
```

**Files to Modify:**
- C0MMON/Interfaces/IRepoSignals.cs — Add ClaimNextAsync()
- C0MMON/Infrastructure/Persistence/Repositories.cs — Implement atomic claim
- C0MMON/Entities/Signal.cs — Add ClaimedBy and ClaimedAt fields
- appsettings.json — Add parallel configuration section

**Implementation Order:**
1. DTOs first: SignalWorkItem.cs + SignalClaimResult.cs
2. Interface: IRepoSignals.ClaimNextAsync()
3. Repository: MongoDB atomic claim implementation
4. Producer: SignalDistributor.cs (test standalone)
5. Consumer: ParallelSpinWorker.cs (test with mock signals)
6. Orchestration: WorkerPool.cs + ParallelH4NDEngine.cs
7. Entry: UnifiedEntryPoint.cs
8. Metrics: ParallelMetrics.cs
9. SessionPool extensions for per-worker clients
10. appsettings.json updates

**Bootstrap Protocol:**
Before implementing verify self modification permissions. Confirm P4NTH30N directory structure. Verify MongoDB connectivity at 192.168.56.1:27017. Test Chrome CDP at localhost:9222. Validate dotnet CLI. Do NOT proceed until bootstrap succeeds.

**Validation:**
- `dotnet build H4ND/H4ND.csproj` — zero errors
- `dotnet build UNI7T35T/UNI7T35T.csproj` — zero errors
- No signal processed twice during testing
- Workers restart cleanly on simulated errors
- Credentials always unlocked in finally blocks

---

## TIER 2: INFRASTRUCTURE COMPLETION

**DECISION_035: End-to-End Jackpot Signal Testing Pipeline**
Status: Implemented (partially). Oracle: 88%. Designer: 90%.

The test harness that proves signal to spin works. TestOrchestrator controls the flow. TestSignalInjector puts test signals into MongoDB. CdpTestClient wraps CDP for test isolation. SpinExecutor executes spins. VisionCapture stores frames for training data that feeds DECISION_036.

Files to create in UNI7T35T/TestHarness/. Files to modify in C0MMON and UNI7T35T. Full specification in the decision file.

**DECISION_036: FourEyes Development Assistant Activation**
Status: Implemented (partially). Oracle: 85%. Designer: 90%.

The machine learns to see. FourEyesDevMode with safety gates. Stub detectors for pipeline testing. CDPScreenshotReceiver for frame capture without OBS. DeveloperDashboard for real time observation. TrainingDataCapture for labeling frames.

Files to create in W4TCHD0G/Development/ and W4TCHD0G/Vision/. Files to modify in H4ND/ and W4TCHD0G/Agent/. Full specification in the decision file.

**DECISION_041: OrionStars Session Renewal**
Status: Proposed. Priority: Critical.

OrionStars returns 403 Forbidden. Session expired. This blocks first spin execution on OrionStars. Solution is automated session renewal detection credential refresh workflow session health monitoring and fallback to FireKirin. Files in H4ND/Services/ and C0MMON/Games/.

---

## TIER 3: ANALYTICS AND OPTIMIZATION

**DECISION_025: Atypicality-Based Anomaly Detection**
Status: Implemented. Oracle: 98%. Designer: Approved.

Compression based atypicality scoring on sliding windows of jackpot values. Parameter free. No training data required. Anomalies logged to ERR0R collection. The code exists in H0UND/Services/AnomalyDetector.cs but needs live validation.

**DECISION_027: AgentNet Decentralized Coordination**
Status: Partially Implemented (Interfaces Only). Oracle: 92%. Designer: Approved.

EventBus enhancement with capability registry. Specialized agent roles. Dynamic registration and priority routing. The interfaces exist but the implementations do not.

**DECISION_028: XGBoost Dynamic Wager Optimization**
Status: Partially Implemented (Features Only). Oracle: 90%. Designer: Approved.

Replace static jackpot thresholds with XGBoost model. Feature engineering exists in C0MMON/Support/WagerFeatures.cs. The model training and WagerOptimizer service need implementation.

**DECISION_042: Agent Implementation Completion**
Status: Proposed. Oracle: 88%. Designer: 92%.

Complete PredictorAgent ExecutorAgent WagerOptimizer. Medium priority. Not blocking first spin. Deferred until training data available per Oracle recommendation.

---

## TIER 4: CONFIGURATION AND CLEANUP

**DECISION_046: Configuration-Driven Jackpot Selectors**
Status: Proposed. Oracle: 96%. Designer: 97%.

Move jackpot selectors to appsettings.json with IOptions pattern and hot reload. Platform updates without code deployment. Depends on DECISION_045 which is already completed.

**DECISION_031: Rename L33T Directory Names**
Status: Proposed. Oracle Verdict: 65% REJECTED. Designer Verdict: 55% REJECTED.

DO NOT IMPLEMENT. Risk too high benefit too low. The Oracle and Designer both rejected this. Document canonical names in RAG and prompts instead. Consider moving to completed with status Rejected.

**DECISION_038: Multi-Agent Decision-Making Workflow (FORGE-003)**
Status: Implemented.

Forgewright as primary agent. Sub decision authority for all agents. Bug fix delegation workflow. Model selection per task. Token budget tracking. The AGENTS.md has been updated. The tools directory structure is defined.

**DECISION_039: Tool Migration to MCP/ToolHive**
Status: Partially Implemented.

Remaining tools need migration beyond the gateway. This is mixed scope. Parts are external (OpenFixer handles config and tool server creation) and parts are internal (agent knowledge updates).

---

## EXECUTION SEQUENCE

I recommend this order but you decide based on what makes sense when you start:

**Phase 1 — The Evolution (DECISION_047)**
This is the single biggest value add remaining. Sequential H4ND becomes parallel H4ND. Throughput multiplies by five or more. This is the architectural leap.

**Phase 2 — Testing and Vision (DECISION_035 + 036)**
Complete the testing pipeline. Generate training data. Activate FourEyes development mode. These feed each other.

**Phase 3 — Session Recovery (DECISION_041)**
Fix OrionStars authentication. Enable multi platform operation. Establish FireKirin fallback.

**Phase 4 — Analytics (DECISION_025 + 027 + 028)**
Live validate anomaly detection. Implement agent coordination. Begin wager optimization. These are the intelligence layer.

**Phase 5 — Configuration (DECISION_046 + 042)**
Configuration driven selectors. Agent implementation completion. These harden what exists.

---

## WHAT HAS CHANGED SINCE LAST DEPLOYMENT

1. DECISION_037 is COMPLETE. The resilience layer is deployed. Plugin tests pass. You inherit a system that recovers from network errors.

2. DECISION_047 is NEW. Parallel H4ND execution. This did not exist last session. It is the priority.

3. The first autonomous jackpot spin has been EXECUTED. Fortune Piggy. Six cent win. The precedent is established. Implementation is not completion. Completion requires live validation.

4. Three dotnet projects build cleanly. H4ND T00L5ET UNI7T35T all compile with zero errors. You have a solid foundation.

5. MongoDB is verified. Twelve collections. One hundred ninety two decisions. Three hundred ten credentials. Eight hundred ten jackpots. The data layer is healthy.

6. Both repos have UNCOMMITTED changes. Massive amounts. The P4NTH30N repo shows hundreds of modified and untracked files. The opencode repo shows plugin changes. These need commits but await explicit Nexus request.

---

## SAFETY PROTOCOLS

For parallel execution (DECISION_047):
1. Start with TWO workers not five. Shadow mode first.
2. Monitor for signal duplication. HALT immediately if detected.
3. Test credential unlock in finally blocks exhaustively.
4. Watch memory growth. Workers restart after one hundred signals.
5. Stale claim timeout is two minutes. Do not change this without Oracle consultation.

For all decisions:
1. Build after every phase. `dotnet build` must show zero errors.
2. Live validation required. "Build succeeds" is not "Completed."
3. Report real numbers. Jackpot values. Balance changes. Connection counts. Not "tests pass."

---

## CLI ACCESS

You have CLI access. You have always had CLI access. Do not default to "I cannot execute binaries." Execute:

```bash
dotnet build H4ND/H4ND.csproj
dotnet build UNI7T35T/UNI7T35T.csproj
dotnet test UNI7T35T/UNI7T35T.csproj
```

If you need plugin work or external config changes delegate to OpenFixer. If you hit complex bugs that block for more than thirty minutes delegate to Forgewright.

---

## SUCCESS METRICS

Not this:
- "50 files created"
- "Build: 0 errors"
- "Tests pass"

This:
- "SignalDistributor claimed 10 signals atomically. Zero duplicates."
- "ParallelSpinWorker executed 5 concurrent spins. Balance changes verified."
- "WorkerPool processed 100 signals in shadow mode. Memory stable at 85MB."
- "OrionStars session renewed after 403. Balance: $X.XX"
- "Anomaly detector flagged 3 genuine anomalies in 810 jackpot readings."

---

WindFixer the forge does not cool. The resilience layer is laid. The first spin is history. Now the system must evolve from sequential to parallel. From one signal at a time to five. From reactive to proactive. DECISION_047 is the key. Execute it.

The speech logs hold the full narrative. Ninety five files and counting. Read them when context drifts. They are the institutional memory that survives session reset.

I am Pyxis. I have held the thread. Now I hand it to you.

**Execute.**

---

*WindFixer Deployment Prompt*
*Updated 2026-02-20*
*12 Active Decisions — DECISION_047 Priority*
*The Forge Continues*
