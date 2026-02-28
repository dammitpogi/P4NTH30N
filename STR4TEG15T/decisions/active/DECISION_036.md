# DECISION_036: FourEyes Development Assistant Activation

**Decision ID**: FEAT-036  
**Category**: FEAT  
**Status**: Implemented  
**Priority**: Critical  
**Date**: 2026-02-20  
**Oracle Approval**: 85% (Strategist Assimilated)  
**Designer Approval**: 90% (Completed)

---

## Executive Summary

FourEyes is a multi-modal vision-based automation system that can assist in P4NTHE0N development by providing visual feedback, automated testing, and intelligent decision-making. Currently, 7 of 20 FourEyes components are complete, but the system needs activation for development assistance. This decision establishes the infrastructure to get FourEyes operational as a development subagent that can observe, analyze, and interact with the game platforms through vision.

**Current Problem**:
- FourEyes components exist but are not integrated for development use
- No active vision stream for observing game states
- Developers cannot leverage FourEyes for automated testing assistance
- Vision-based button detection and game state classification are not operational
- Missing integration between FourEyes and H4ND for vision-command execution

**Proposed Solution**:
- Activate FourEyes in "development assistant" mode with reduced autonomy
- Establish OBS/CDP stream for vision input
- Configure Synergy client for VM input control
- Integrate FourEyes with H4ND for vision-command processing
- Create developer interface for FourEyes observation and control
- Enable frame capture and analysis for training data generation

---

## Background

### Current State

**FourEyes Implementation Status** (from FOUREYES_CODEBASE_REFERENCE.md):

✅ **Completed (7)**:
- CircuitBreaker (C0MMON)
- SystemDegradationManager (C0MMON)
- OperationTracker (C0MMON)
- OBSVisionBridge (W4TCHD0G)
- LMStudioClient + ModelRouter (W4TCHD0G)
- VisionDecisionEngine (H0UND)
- FourEyesAgent (W4TCHD0G)

🔄 **Partially Implemented (4)**:
- HealthCheckService (needs OBS integration)
- EventBuffer (placeholder only)
- ModelManager (needs Hugging Face download)
- Unbreakable Contract (needs interface migration)

📋 **Not Implemented (9)**:
- ShadowGauntlet, CerberusProtocol, StreamHealthMonitor
- AutonomousLearningSystem, H4ND VisionCommandListener
- RedundantVisionSystem, ProductionMetrics
- RollbackManager, PhasedRolloutManager

**Architecture**:
```
VM OBS (RTMP) → RTMPStreamReceiver → FrameBuffer → VisionProcessor
                                                       ↓
MongoDB SIGN4L ←──────────────────── DecisionEngine ←──┘
                                          ↓
                                     SynergyClient → VM Input
```

### Desired State

FourEyes operational as a development assistant with:
1. **Observation Mode**: Continuously analyze game state via OBS/CDP stream
2. **Testing Mode**: Execute vision-based tests and report results
3. **Training Mode**: Capture and label frames for model improvement
4. **Assistance Mode**: Provide visual feedback to developers via dashboard
5. **Integration Mode**: Work with H4ND to execute vision-guided spins

---

## Specification

### Requirements

#### FEAT-036-001: Stream Input Configuration
**Priority**: Must  
**Acceptance Criteria**:
- Configure OBS WebSocket connection (localhost:4455)
- Set up RTMP stream receiver for frame ingestion
- Support CDP screenshot as alternative stream source
- Configure frame rate (2-5 FPS for development)
- Validate stream health with automatic reconnection

#### FEAT-036-002: Vision Processing Pipeline
**Priority**: Must  
**Acceptance Criteria**:
- Activate VisionProcessor with jackpot detection (OCR)
- Enable button detection (template matching)
- Configure game state classifier (Idle, Spinning, Bonus, Error)
- Process frames within 500ms latency target
- Generate VisionAnalysis for each frame

#### FEAT-036-003: Decision Engine Integration
**Priority**: Must  
**Acceptance Criteria**:
- Connect DecisionEngine to VisionProcessor output
- Query MongoDB for pending signals
- Evaluate game state + signal + balance
- Generate InputAction sequences
- Support safety limits (min balance, daily loss limit)

#### FEAT-036-004: Synergy Input Control
**Priority**: Must  
**Acceptance Criteria**:
- Configure SynergyClient for VM input (port 24800)
- Implement mouse move, click, double-click
- Support keyboard input for text entry
- Queue and execute action sequences
- Handle connection failures with retry

#### FEAT-036-005: H4ND Vision Command Integration
**Priority**: Must  
**Acceptance Criteria**:
- Create VisionCommandListener in H4ND
- Subscribe to InMemoryEventBus for VisionCommands
- Map VisionCommand to CDP actions
- Support command types: Spin, Stop, SwitchGame, CollectBonus
- Report command execution status

#### FEAT-036-006: Developer Dashboard
**Priority**: Should  
**Acceptance Criteria**:
- Display current frame with analysis overlay
- Show detected jackpots, buttons, game state
- Log decision engine outputs
- Display action queue and execution status
- Provide manual controls (pause, resume, single-step)

#### FEAT-036-007: Training Data Capture
**Priority**: Should  
**Acceptance Criteria**:
- Capture frames during operation
- Label frames with detected state and actions
- Export data in LM Studio training format
- Support manual labeling for incorrect detections
- Store training data in organized directory structure

#### FEAT-036-008: Development Mode Safety
**Priority**: Must  
**Acceptance Criteria**:
- Require explicit developer confirmation for spins
- Limit maximum bet amounts during testing
- Enable immediate pause/stop controls
- Log all actions with full context
- Never exceed daily loss limits

### Technical Details

**Component Activation Plan**:

1. **W4TCHD0G Activation**:
   ```csharp
   // FourEyesAgent initialization
   var streamReceiver = new RTMPStreamReceiver(config);
   var visionProcessor = new VisionProcessor(
       new JackpotOCRDetector(),
       new ButtonTemplateDetector(),
       new GameStateClassifier()
   );
   var decisionEngine = new DecisionEngine(
       minBalance: 5.0m,
       dailyLossLimit: 100.0m
   );
   var synergyClient = new SynergyClient();
   
   var fourEyes = new FourEyesAgent(
       streamReceiver,
       visionProcessor,
       decisionEngine,
       synergyClient,
       checkForSignal: () => uow.Signals.HasPending(),
       getBalance: () => uow.Credentials.GetBalance(username)
   );
   ```

2. **H4ND Integration**:
   ```csharp
   // VisionCommandListener
   public class VisionCommandListener
   {
       private readonly IEventBus _eventBus;
       private readonly ICdpClient _cdpClient;
       
       public async Task HandleVisionCommand(VisionCommand cmd)
       {
           switch (cmd.CommandType)
           {
               case VisionCommandType.Spin:
                   await ExecuteSpinAsync(cmd);
                   break;
               case VisionCommandType.Stop:
                   await StopSpinAsync(cmd);
                   break;
               // ... etc
           }
       }
   }
   ```

3. **Configuration**:
   ```json
   {
     "FourEyes": {
       "Mode": "DevelopmentAssistant",
       "Stream": {
         "Source": "OBS",
         "ObsWebSocketUrl": "ws://localhost:4455",
         "FrameRate": 3,
         "BufferSize": 10
       },
       "Vision": {
         "TargetFps": 3,
         "JackpotOCR": { "Enabled": true, "ConfidenceThreshold": 0.8 },
         "ButtonDetection": { "Enabled": true, "ConfidenceThreshold": 0.75 },
         "StateClassification": { "Enabled": true }
       },
       "Safety": {
         "MinBalance": 5.0,
         "DailyLossLimit": 100.0,
         "RequireConfirmation": true,
         "MaxBetAmount": 1.0
       },
       "Synergy": {
         "HostIp": "192.168.56.1",
         "Port": 24800,
         "ClientName": "FourEyes-Dev"
       }
     }
   }
   ```

**File Structure**:
```
W4TCHD0G/
├── Agent/
│   ├── FourEyesAgent.cs (✅ exists)
│   ├── DecisionEngine.cs (✅ exists)
│   └── IFourEyesAgent.cs (✅ exists)
├── Vision/
│   ├── VisionProcessor.cs (✅ exists)
│   ├── IJackpotDetector.cs (✅ exists)
│   ├── IButtonDetector.cs (✅ exists)
│   └── IStateClassifier.cs (✅ exists)
├── Input/
│   ├── SynergyClient.cs (✅ exists)
│   ├── ISynergyClient.cs (✅ exists)
│   └── InputAction.cs (✅ exists)
├── Stream/
│   ├── RTMPStreamReceiver.cs (✅ exists)
│   ├── IStreamReceiver.cs (✅ exists)
│   └── StreamHealthMonitor.cs (✅ exists)
└── Development/
    ├── FourEyesDevMode.cs (NEW)
    ├── DeveloperDashboard.cs (NEW)
    └── TrainingDataCapture.cs (NEW)

H4ND/
├── Vision/
│   ├── VisionCommandListener.cs (NEW)
│   ├── VisionCommandHandler.cs (NEW)
│   └── VisionCommandTypes.cs (NEW)
└── Infrastructure/
    └── VisionCommandPipeline.cs (NEW)
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-036-001 | Create FourEyesDevMode configuration | Fixer | Pending | Critical |
| ACT-036-002 | Implement VisionCommandListener in H4ND | Fixer | Pending | Critical |
| ACT-036-003 | Create VisionCommandHandler for CDP actions | Fixer | Pending | Critical |
| ACT-036-004 | Implement DeveloperDashboard UI | Fixer | Pending | High |
| ACT-036-005 | Create TrainingDataCapture service | Fixer | Pending | High |
| ACT-036-006 | Implement EventBuffer (complete placeholder) | Fixer | Pending | Critical |
| ACT-036-007 | Connect HealthCheckService to OBS | Fixer | Pending | High |
| ACT-036-008 | Create jackpot OCR detector implementation | Fixer | Pending | Critical |
| ACT-036-009 | Create button template detector | Fixer | Pending | Critical |
| ACT-036-010 | Implement game state classifier | Fixer | Pending | Critical |
| ACT-036-011 | Write integration tests | Fixer | Pending | High |
| ACT-036-012 | Create development mode documentation | Fixer | Pending | Medium |

---

## Dependencies

- **Blocks**: DECISION_035 (FourEyes needs test data from testing pipeline)
- **Blocked By**: None - can proceed in parallel with testing pipeline
- **Related**: FOUREYES-015 (H4ND Vision Command Integration), FOUREYES-007 (Event Buffer)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| OBS stream instability | High | Medium | Implement Cerberus Protocol (restart/verify/fallback); use CDP screenshot backup |
| Vision processing latency >500ms | Medium | Medium | Reduce FPS; optimize models; use lighter-weight detection |
| Synergy connection failures | High | Low | Auto-reconnect with exponential backoff; local input fallback |
| Incorrect button detection | High | Medium | Require developer confirmation; confidence thresholds; manual override |
| Model hallucination | Medium | Medium | Confidence scoring; human-in-the-loop for critical actions |
| Training data quality issues | Low | Medium | Manual labeling workflow; quality validation; iterative improvement |
| Integration complexity with H4ND | Medium | Medium | Clear interfaces; event bus decoupling; incremental integration |

---

## Success Criteria

1. **Stream Activation**: OBS/CDP stream connects and provides frames within 5 seconds
2. **Vision Processing**: Frames processed at 2-5 FPS with <500ms latency
3. **Jackpot Detection**: OCR accuracy >80% for visible jackpot values
4. **Button Detection**: Spin button detected with >75% confidence
5. **Game State**: Correctly classifies Idle/Spinning/Bonus states >90% of time
6. **Command Integration**: Vision commands successfully execute via H4ND
7. **Developer Dashboard**: Real-time display of frames, analysis, and logs
8. **Training Data**: Can capture and export labeled frames for model training
9. **Safety**: No unintended spins; all actions logged; limits enforced

---

## Consultation Log

### Oracle Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 85%
  - Feasibility Score: 7/10 - 7/20 components complete provides solid foundation
  - Risk Score: 5/10 - Vision model accuracy and integration complexity are concerns
  - Complexity Score: 7/10 - Multi-modal integration (OBS, Synergy, CDP, MongoDB)
  - Top Risks: (1) OBS stream instability, (2) Incorrect button detection leading to wrong actions, (3) Model hallucination
  - Critical Success Factor: Development mode safety wrapper with mandatory confirmation gates
  - Recommendation: Start with stub detectors for rapid pipeline validation; replace with real models incrementally
  - Component Priority: VisionCommandListener > EventBuffer > HealthCheck integration > Real models
- **File**: consultations/oracle/DECISION_036_oracle.md

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: 90%
- **Key Findings**:
  - Implementation Strategy: 6-phase approach over 4 weeks
  - Phase 1 (Week 1): Foundation & Safety - EventBuffer, FourEyesDevMode, VisionCommandHandler, ConfirmationGate, SafetyMonitor
  - Phase 2 (Week 1-2): Vision Pipeline Stubs - StubJackpotDetector, StubButtonDetector, StubStateClassifier, CDPScreenshotReceiver
  - Phase 3 (Week 2): H4ND Integration - VisionCommandPublisher, EventBus subscription, command mapping
  - Phase 4 (Week 2-3): Developer Dashboard - real-time observation interface
  - Phase 5 (Week 3-4): Real Vision Models - Tesseract OCR, Template matching
  - Phase 6 (Week 4): Training Data Capture - FrameCaptureService, auto-labeling
  - MVP Components: 9 critical components, ~46 hours effort
  - Files to Create: 14 new files across W4TCHD0G/Development/, W4TCHD0G/Vision/, H4ND/Vision/, C0MMON/Configuration/
  - Files to Modify: 6 files including H4ND.cs, FourEyesAgent.cs, DecisionEngine.cs, HealthCheckService.cs
  - Safety Architecture: 5-layer confirmation system (Config limits → DecisionEngine checks → ConfirmationGate → SafetyMonitor → EmergencyStop)
  - Dashboard Design: 3-panel terminal UI (Frame Preview, Analysis, Logs) with Spectre.Console
  - Model Implementations: TesseractJackpotDetector, TemplateButtonDetector, HeuristicStateClassifier
- **File**: consultations/designer/DECISION_036_designer.md

---

## Notes

**Development Mode vs Production Mode**:
- Development mode requires explicit confirmation for spins
- Production mode (future) will be fully autonomous
- Development mode focuses on observation, testing, and training
- All development actions are logged with full context

**SubAgent Integration**:
- FourEyes can act as a subagent during development
- Receives commands from main development agent
- Reports observations and analysis back
- Executes actions with safety constraints
- Provides visual feedback for debugging

**Training Data Value**:
- Real game frames are invaluable for model training
- Jackpot splash screens need diverse examples
- Button positions vary by game and resolution
- Game state transitions need temporal sequences
- Development mode captures all of this automatically

**Integration with DECISION_035**:
- Testing pipeline generates training data for FourEyes
- FourEyes provides vision validation for testing pipeline
- Both decisions enable comprehensive end-to-end validation
- Combined: automated testing with visual verification

---

*Decision FEAT-036*  
*FourEyes Development Assistant Activation*  
*2026-02-20*
