# Designer Consultation: DECISION_036

**Decision ID**: FEAT-036  
**Agent**: Designer (Aegis)  
**Task ID**: ses_385587db5ffejm20z8JM7ol122  
**Date**: 2026-02-20  
**Status**: Complete

---

## Original Response

Now I have comprehensive context. Let me provide my implementation strategy as the Designer.

---

# FourEyes Development Assistant Activation - Designer Implementation Strategy

**Decision**: FEAT-036  
**Designer**: Aegis  
**Date**: 2026-02-20  

---

## Implementation Strategy: Phased Activation Approach

### Phase 1: Foundation & Safety (Week 1) — CRITICAL PATH
**Goal**: Establish development mode infrastructure with mandatory safety gates

1. **Complete EventBuffer** — The existing implementation is actually complete (79 lines), just needs interface hookup
2. **Create FourEyesDevMode Configuration** — Central safety configuration
3. **Implement VisionCommandHandler in H4ND** — Connect EventBus to CDP actions
4. **Create ConfirmationGate** — Mandatory developer approval for all spins
5. **Create DevelopmentSafetyMonitor** — Enforce limits, log all actions

### Phase 2: Vision Pipeline Stubs (Week 1-2) — CRITICAL PATH
**Goal**: Activate pipeline with stub detectors for rapid validation

1. **Create StubJackpotDetector** — Returns mock OCR results for pipeline testing
2. **Create StubButtonDetector** — Returns predefined button positions
3. **Create StubStateClassifier** — Rules-based classification from existing data
4. **Integrate with VisionProcessor** — Validate full pipeline flow
5. **Create CDPScreenshotReceiver** — Alternative to OBS for development

### Phase 3: H4ND Integration (Week 2) — CRITICAL PATH
**Goal**: Connect FourEyes to H4ND execution via EventBus

1. **Create VisionCommandPublisher in W4TCHD0G** — Publishes to EventBus
2. **Subscribe VisionCommandListener in H4ND** — Receives and queues commands
3. **Map commands to CDP actions** — Spin, Stop, SwitchGame implementations
4. **Create execution status reporting** — Feedback loop to FourEyes

### Phase 4: Developer Dashboard (Week 2-3) — NICE TO HAVE
**Goal**: Real-time observation and control interface

1. **Create FourEyesDashboard** — Console-based or simple HTTP
2. **Display current frame with overlays** — Jackpots, buttons, state
3. **Action queue visualization** — Pending, executing, completed
4. **Manual control panel** — Pause, resume, single-step, emergency stop

### Phase 5: Real Vision Models (Week 3-4) — NICE TO HAVE
**Goal**: Replace stubs with actual vision detection

1. **Implement TesseractJackpotDetector** — OCR for jackpot values
2. **Implement TemplateButtonDetector** — Image matching for buttons
3. **Train/integrate game state classifier** — ML-based state detection
4. **Model performance tracking** — Accuracy, latency metrics

### Phase 6: Training Data Capture (Week 4) — NICE TO HAVE
**Goal**: Enable model improvement through data collection

1. **Create FrameCaptureService** — Save frames during operation
2. **Auto-labeling from detections** — Jackpot values, button positions
3. **Manual correction interface** — Fix incorrect auto-labels
4. **Export to LM Studio format** — JSONL training data

---

## Critical Path Components (MVP Requirements)

### Must-Have for Development Mode Activation:

| Component | Status | Priority | Effort |
|-----------|--------|----------|--------|
| EventBuffer | ✅ Complete | P0 | 0h |
| FourEyesDevMode Config | 🔄 New | P0 | 4h |
| VisionCommandHandler | 🔄 New | P0 | 8h |
| ConfirmationGate | 🔄 New | P0 | 6h |
| SafetyMonitor | 🔄 New | P0 | 6h |
| Stub Detectors (3x) | 🔄 New | P0 | 8h |
| CDPScreenshotReceiver | 🔄 New | P0 | 6h |
| VisionCommandPublisher | 🔄 New | P0 | 4h |
| H4ND EventBus Subscribe | 🔄 Modify | P0 | 4h |

**Total MVP Effort**: ~46 hours (~1 week with parallel work)

### Nice-to-Have (Post-MVP):

| Component | Value | Effort |
|-----------|-------|--------|
| Developer Dashboard | High | 16h |
| Tesseract OCR Detector | High | 12h |
| Template Button Detector | Medium | 10h |
| Training Data Capture | Medium | 12h |
| Real State Classifier | High | 20h |

---

## Files to Create

### W4TCHD0G/Development/ (New Directory)
```
FourEyesDevMode.cs          # Development mode configuration & safety
DeveloperDashboard.cs       # Real-time observation interface
TrainingDataCapture.cs      # Frame capture and labeling
ConfirmationGate.cs         # Mandatory approval system
```

### W4TCHD0G/Vision/Stubs/ (New Directory)
```
StubJackpotDetector.cs      # Mock OCR for pipeline testing
StubButtonDetector.cs       # Predefined button positions
StubStateClassifier.cs      # Rules-based state detection
```

### W4TCHD0G/Vision/Implementations/ (New Directory)
```
TesseractJackpotDetector.cs    # Real OCR implementation
TemplateButtonDetector.cs      # Image template matching
HeuristicStateClassifier.cs    # Combined heuristic classifier
```

### W4TCHD0G/Stream/Alternatives/
```
CDPScreenshotReceiver.cs    # CDP-based frame capture (no OBS needed)
```

### H4ND/Vision/ (New Directory)
```
VisionCommandHandler.cs     # Execute commands via CDP
VisionCommandPublisher.cs   # Publish to EventBus from W4TCHD0G
VisionExecutionTracker.cs   # Track command execution status
```

### C0MMON/Configuration/
```
FourEyesDevConfig.cs        # Strongly-typed configuration
```

---

## Files to Modify

### C0MMON/Infrastructure/EventBuffer.cs
**Changes**: Already complete — verify IEventBuffer<T> interface implementation

### C0MMON/Monitoring/HealthCheckService.cs
**Changes**: 
- Line 106-132: `CheckVisionStreamHealth()` needs OBS client integration
- Add CDP screenshot health check as fallback

### H4ND/VisionCommandListener.cs
**Changes**:
- Lines 90-140: Replace stub switch statement with actual command dispatch
- Integrate with CommandPipeline for middleware support
- Add EventBus subscription in constructor

### H4ND/H4ND.cs
**Changes**:
- Add VisionCommandListener subscription to EventBus
- Wire up VisionCommandHandler to CDP client

### W4TCHD0G/Agent/FourEyesAgent.cs
**Changes**:
- Inject FourEyesDevMode configuration
- Add ConfirmationGate check before ExecuteQueueAsync
- Add TrainingDataCapture hook in cycle completion

### W4TCHD0G/Agent/DecisionEngine.cs
**Changes**:
- Integrate with SafetyMonitor for limit enforcement
- Add development mode confirmation prompts

---

## Integration Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            FOUR EYES SYSTEM                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────────┐  │
│  │  Stream Source  │───▶│  FrameBuffer    │───▶│   VisionProcessor       │  │
│  │  (OBS/CDP)      │    │  (EventBuffer)  │    │  ┌─────────────────┐    │  │
│  └─────────────────┘    └─────────────────┘    │  │ JackpotDetector │    │  │
│                                                │  │ ButtonDetector  │    │  │
│  ┌─────────────────┐                           │  │ StateClassifier │    │  │
│  │ FourEyesDevMode │◄──────────────────────────┘  └─────────────────┘    │  │
│  │  - Safety limits│                                                      │  │
│  │  - Confirmation │    ┌─────────────────┐                               │  │
│  │  - Dev controls │◄───│ DecisionEngine  │◄──────────────────────────────┘  │
│  └─────────────────┘    │  - Evaluate     │                                  │
│         │               │  - Safety check │    ┌─────────────────────────┐   │
│         │               └─────────────────┘    │   MongoDB (SIGN4L)      │   │
│         │                      │               │   - Pending signals     │   │
│         ▼                      ▼               │   - Balance queries     │   │
│  ┌──────────────────────────────────────┐      └─────────────────────────┘   │
│  │      ConfirmationGate                │                                    │
│  │  [REQUIRE DEVELOPER APPROVAL]        │    ┌─────────────────────────┐     │
│  │  • Visual frame preview              │    │   TrainingDataCapture   │     │
│  │  • Detected state summary            │    │   - Auto-label frames   │     │
│  │  • [Approve] [Reject] [Modify]       │    │   - Export training data│     │
│  └──────────────────────────────────────┘    └─────────────────────────┘     │
│                        │                                                    │
│                        ▼                                                    │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                      InMemoryEventBus (C0MMON)                          │ │
│  │  VisionCommandPublisher ──────▶────── VisionCommandListener (H4ND)      │ │
│  │  • CommandType: Spin                                                 │ │
│  │  • Target: username@game                                               │ │
│  │  • Confidence, Parameters                                              │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                         │
└────────────────────────────────────┼─────────────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            H4ND EXECUTION                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────────────┐    ┌─────────────────────────────────────────┐  │
│  │  VisionCommandListener  │───▶│         CommandPipeline                 │  │
│  │  (EventBus subscriber)  │    │  ┌─────────┐ ┌─────────┐ ┌───────────┐ │  │
│  └─────────────────────────┘    │  │LoggingMW│ │ValidMW  │ │CircuitMW  │ │  │
│                                 │  └────┬────┘ └────┬────┘ └─────┬─────┘ │  │
│  ┌─────────────────────────┐    │       └───────────┴────────────┘        │  │
│  │   Command Handlers      │◄───┘                   │                      │  │
│  │  ┌─────────────────┐   │               ┌─────────▼──────────┐           │  │
│  │  │ SpinHandler     │   │               │  VisionCommand     │           │  │
│  │  │ StopHandler     │   │               │     Handler        │           │  │
│  │  │ SwitchHandler   │   │               └─────────┬──────────┘           │  │
│  │  └─────────────────┘   │                         │                      │  │
│  └─────────────────────────┘                         ▼                      │  │
│  ┌─────────────────────────┐               ┌─────────────────────┐         │  │
│  │   Execution Status      │◄──────────────│    CdpGameActions   │         │  │
│  │   (feedback to FE)      │               │  - ClickSpin()      │         │  │
│  └─────────────────────────┘               │  - ClickStop()      │         │  │
│                                            │  - NavigateGame()   │         │  │
│                                            └──────────┬──────────┘         │  │
│                                                       │                     │  │
│                                            ┌──────────▼──────────┐         │  │
│                                            │     CdpClient       │         │  │
│                                            │  (Chrome Protocol)  │         │  │
│                                            └──────────┬──────────┘         │  │
│                                                       │                     │  │
│                                            ┌──────────▼──────────┐         │  │
│                                            │    Chrome Browser   │         │  │
│                                            │  (on Host via CDP)  │         │  │
│                                            └─────────────────────┘         │  │
│                                                                            │  │
└────────────────────────────────────────────────────────────────────────────┘  │
                                                                                │
┌─────────────────────────────────────────────────────────────────────────────┐
│                         DEVELOPER DASHBOARD                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  FRAME PREVIEW                    │  ANALYSIS PANEL                  │   │
│  │  ┌───────────────────────────┐    │  • Game State: Idle              │   │
│  │  │                           │    │  • Grand: $1,234.56 (95%)        │   │
│  │  │   [Live game frame]       │    │  • Major: $456.78 (82%)          │   │
│  │  │   [Jackpot overlays]      │    │  • Spin Button: (640, 720)       │   │
│  │  │   [Button highlights]     │    │  • Confidence: 0.87              │   │
│  │  └───────────────────────────┘    │                                  │   │
│  │                                   │  ACTION QUEUE                    │   │
│  └───────────────────────────────────┤  1. [PENDING] Spin @ user1/game1 │   │
│                                      │  2. [EXECUTING] Click (640,720)  │   │
│  ┌─────────────────────────────────┐ │  3. [COMPLETED] Delay 500ms      │   │
│  │  CONTROLS                       │ │                                  │   │
│  │  [▶ Resume] [⏸ Pause] [⏹ Stop] │ │  SAFETY STATUS                   │   │
│  │  [👁 Single Step] [🚨 E-Stop]   │ │  • Daily Loss: $0 / $100         │   │
│  │  [💾 Capture Frame]              │ │  • Balance: $50.00 (OK)          │   │
│  └─────────────────────────────────┘ │  • Confirmation: REQUIRED        │   │
│                                      └──────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Safety Architecture: Multi-Layer Confirmation System

### Layer 1: Configuration Limits (Hard Stops)
```csharp
public class FourEyesDevConfig
{
    // Hard limits that cannot be exceeded
    public decimal AbsoluteMaxDailyLoss { get; set; } = 100.0m;
    public decimal AbsoluteMaxBetAmount { get; set; } = 5.0m;
    public decimal MinimumBalance { get; set; } = 5.0m;
    public int MaxActionsPerMinute { get; set; } = 10;
    
    // Development mode enforcement
    public bool RequireExplicitConfirmation { get; set; } = true;
    public bool AllowAutonomousSpin { get; set; } = false; // Always false in dev
}
```

### Layer 2: DecisionEngine Safety Checks
```csharp
// In DecisionEngine.Evaluate():
if (IsLossLimitReached) 
    return DecisionResult.Pause("Daily loss limit reached");
    
if (currentBalance < _minBalance)
    return DecisionResult.Pause("Balance below minimum");
    
if (analysis.GameState != AnimationState.Idle)
    return DecisionResult.NoAction("Game not ready");
```

### Layer 3: ConfirmationGate (Developer Approval)
```csharp
public class ConfirmationGate
{
    public async Task<bool> RequestConfirmationAsync(
        VisionFrame frame,           // Visual proof
        VisionAnalysis analysis,     // What we detected
        List<InputAction> actions,   // What we plan to do
        decimal currentBalance       // Financial context
    )
    {
        // DEVELOPMENT MODE: Always require approval
        if (_config.RequireExplicitConfirmation)
        {
            DisplayPreview(frame, analysis);
            return await WaitForDeveloperApprovalAsync(
                timeout: TimeSpan.FromMinutes(2)
            );
        }
        return true; // Production only (not used in dev)
    }
}
```

### Layer 4: Execution Monitor (Real-time)
```csharp
public class SafetyMonitor
{
    // Track every action
    public void RecordAction(InputAction action, decimal balanceBefore)
    {
        _actionLog.Add(new ActionRecord
        {
            Timestamp = DateTime.UtcNow,
            Action = action,
            BalanceBefore = balanceBefore,
            Context = CaptureContext()
        });
    }
    
    // Emergency stop detection
    public void CheckForAnomalies()
    {
        if (RapidActionSequenceDetected()) TriggerSlowdown();
        if (UnexpectedBalanceChange()) TriggerInvestigation();
        if (RepeatedFailures()) TriggerPause();
    }
}
```

### Layer 5: Emergency Stop
```csharp
// Global emergency stop - any component can trigger
public class EmergencyStop
{
    public static void Activate(string reason)
    {
        _cts.Cancel();           // Stop all loops
        _synergy.Disconnect();   // Cut input
        _obs.StopStream();       // Cut vision
        
        LogEmergency(reason);
        NotifyDeveloper();
    }
}
```

---

## Dashboard Design: FourEyes Developer Console

### Layout: Three-Panel Terminal UI

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  FOUR EYES DEV CONSOLE v0.1.0                                    [STATUS]   │
├──────────────────────────────┬────────────────────────┬─────────────────────┤
│                              │                        │                     │
│  PANEL 1: FRAME PREVIEW      │  PANEL 2: ANALYSIS     │  PANEL 3: LOGS      │
│  ─────────────────────       │  ─────────────────     │  ─────────────      │
│                              │                        │                     │
│  ┌────────────────────┐      │  GAME STATE            │  [14:32:01] Frame   │
│  │                    │      │  ━━━━━━━━━━━━          │       #1243 received│
│  │  [Live Frame]      │      │  Status: 🟡 IDLE       │  [14:32:01] Grand:  │
│  │                    │      │  Confidence: 87%       │       $1,234.56     │
│  │  Grand: [══════]   │      │                        │  [14:32:02] Spin    │
│  │  Major: [══════]   │      │  DETECTED JACKPOTS     │       button found  │
│  │  [SPIN BUTTON]     │      │  ━━━━━━━━━━━━━━━━      │       @ (640,720)   │
│  │                    │      │  🏆 Grand:  $1,234.56  │  [14:32:03] Decision│
│  │  Overlays:         │      │     (95% confidence)   │       engine: SPIN  │
│  │  • Red = Jackpot   │      │  🥇 Major:  $456.78    │  [14:32:03] AWAITING│
│  │    regions         │      │     (82% confidence)   │       CONFIRMATION  │
│  │  • Green = Button  │      │  🥈 Minor:  $89.12     │                     │
│  │    locations       │      │     (79% confidence)   │  ━━━━━━━━━━━━━━━    │
│  │  • Blue = State    │      │  🥉 Mini:   $12.34     │                     │
│  │    indicators      │      │     (88% confidence)   │  [14:31:55] Spin    │
│  │                    │      │                        │       completed     │
│  │                    │      │  DETECTED BUTTONS      │  [14:31:54] Balance │
│  │                    │      │  ━━━━━━━━━━━━━━━━      │       changed: -$0.20│
│  │                    │      │  🎰 Spin   (640,720)   │                     │
│  └────────────────────┘      │     [ENABLED] 92%      │                     │
│                              │  ➕ Bet+   (720,680)   │                     │
│  ┌────────────────────┐      │     [ENABLED] 89%      │                     │
│  │ CONTROLS           │      │  ➖ Bet-   (560,680)   │                     │
│  │ ━━━━━━━━━━         │      │     [ENABLED] 91%      │                     │
│  │                    │      │                        │                     │
│  │ [▶] Resume         │      │  SAFETY STATUS         │                     │
│  │ [⏸] Pause          │      │  ━━━━━━━━━━━━━━        │                     │
│  │ [👁] Single Step    │      │  Daily Loss: $0.00     │                     │
│  │ [💾] Capture Frame   │      │  Limit: $100.00 ✓      │                     │
│  │ [🚨] EMERGENCY STOP  │      │                        │                     │
│  │                    │      │  Balance: $50.00 ✓     │                     │
│  │ Mode: DEVELOPMENT    │      │  (Above $5.00 min)     │                     │
│  │ Confirm: REQUIRED    │      │                        │                     │
│  └────────────────────┘      │  PENDING CONFIRMATION  │                     │
│                              │  ━━━━━━━━━━━━━━━━━━━━  │                     │
│                              │                        │                     │
│                              │  Action: SPIN          │                     │
│                              │  Target: user1@game1   │                     │
│                              │  Cost:  ~$0.20         │                     │
│                              │                        │                     │
│                              │  [✅ APPROVE] [❌ DENY]  │                     │
│                              │  [✏️ Modify]            │                     │
│                              │                        │                     │
│                              │  Auto-confirm in: 1:45 │                     │
│                              │                        │                     │
└──────────────────────────────┴────────────────────────┴─────────────────────┘
```

### Key Features:

1. **Frame Preview Panel**
   - Live frame display with detection overlays
   - Color-coded regions (red=jackpots, green=buttons, blue=state)
   - Zoom/pan for detail inspection

2. **Analysis Panel**
   - Current game state with confidence
   - Detected jackpot values with OCR confidence %
   - Button positions and enabled/disabled status
   - Safety status (limits, balance checks)
   - Confirmation dialog for pending actions

3. **Log Panel**
   - Timestamped event stream
   - Frame processing results
   - Decision engine outputs
   - Action execution status
   - Error messages with context

4. **Control Bar**
   - Resume/Pause/Single-step controls
   - Frame capture for training data
   - Emergency stop (always visible)
   - Mode indicator (Development/Production)

### Implementation: Terminal.Gui or Spectre.Console
```csharp
// Using Spectre.Console for rich terminal UI
public class DeveloperDashboard
{
    public async Task RunAsync(CancellationToken ct)
    {
        await AnsiConsole.Live(new Layout("Root"))
            .StartAsync(async ctx =>
            {
                while (!ct.IsCancellationRequested)
                {
                    UpdateFramePanel();
                    UpdateAnalysisPanel();
                    UpdateLogPanel();
                    
                    ctx.Refresh();
                    await Task.Delay(100, ct);
                }
            });
    }
}
```

---

## Model Implementations: Vision Detection

### Jackpot OCR: Tesseract-based Implementation

```csharp
public class TesseractJackpotDetector : IJackpotDetector
{
    private readonly TesseractEngine _engine;
    private readonly Dictionary<string, RegionOfInterest> _rois = new();
    
    public TesseractJackpotDetector()
    {
        // Initialize Tesseract with digits-only config
        _engine = new TesseractEngine(
            @"./tessdata", 
            "eng",
            EngineMode.Default
        );
        _engine.SetVariable("tessedit_char_whitelist", "0123456789.,$");
    }
    
    public async Task<Dictionary<string, decimal>> DetectAsync(VisionFrame frame)
    {
        var results = new Dictionary<string, decimal>();
        
        foreach (var (tier, roi) in _rois)
        {
            // Extract ROI from frame
            byte[] roiData = ExtractROI(frame, roi);
            
            // Run OCR
            using var img = Pix.LoadFromMemory(roiData);
            using var page = _engine.Process(img);
            
            string text = page.GetText().Trim();
            float confidence = page.GetMeanConfidence();
            
            // Parse value
            if (TryParseJackpotValue(text, out decimal value) && confidence > 0.7)
            {
                results[tier] = value;
            }
        }
        
        return results;
    }
}
```

### Button Detection: Template Matching

```csharp
public class TemplateButtonDetector : IButtonDetector
{
    private readonly Dictionary<ButtonType, Mat> _templates = new();
    
    public void LoadTemplates(string directory)
    {
        foreach (var file in Directory.GetFiles(directory, "*.png"))
        {
            var type = ParseButtonType(Path.GetFileNameWithoutExtension(file));
            _templates[type] = Cv2.ImRead(file, ImreadModes.Grayscale);
        }
    }
    
    public async Task<List<DetectedButton>> DetectAsync(VisionFrame frame)
    {
        var buttons = new List<DetectedButton>();
        using var frameMat = new Mat(frame.Height, frame.Width, 
            MatType.CV_8UC3, frame.Data);
        using var gray = new Mat();
        Cv2.CvtColor(frameMat, gray, ColorConversionCodes.BGR2GRAY);
        
        foreach (var (type, template) in _templates)
        {
            using var result = new Mat();
            Cv2.MatchTemplate(gray, template, result, TemplateMatchModes.CCoeffNormed);
            
            Cv2.MinMaxLoc(result, out _, out double maxVal, 
                out _, out Point maxLoc);
            
            if (maxVal > 0.75) // Confidence threshold
            {
                buttons.Add(new DetectedButton
                {
                    Type = type,
                    CenterX = maxLoc.X + template.Width / 2,
                    CenterY = maxLoc.Y + template.Height / 2,
                    Width = template.Width,
                    Height = template.Height,
                    Confidence = maxVal,
                    IsEnabled = CheckIfEnabled(gray, maxLoc, template.Size)
                });
            }
        }
        
        return buttons;
    }
}
```

### State Classification: Rules-based with Heuristics

```csharp
public class HeuristicStateClassifier : IStateClassifier
{
    public Task<GameState> ClassifyAsync(VisionFrame frame, 
        List<DetectedButton> buttons, Dictionary<string, decimal> jackpots)
    {
        // Rule 1: If no spin button visible → Spinning or Bonus
        bool hasSpinButton = buttons.Any(b => b.Type == ButtonType.Spin);
        
        // Rule 2: Check for bonus indicators (specific image regions)
        bool bonusIndicators = CheckBonusIndicators(frame);
        
        // Rule 3: Animation detection via frame differencing
        bool hasAnimation = DetectAnimation(frame);
        
        // Rule 4: Win amount display detection
        bool showingWin = DetectWinDisplay(frame);
        
        // Classification logic
        if (bonusIndicators) return Task.FromResult(GameState.BonusGame);
        if (showingWin) return Task.FromResult(GameState.WinAnimation);
        if (hasAnimation && !hasSpinButton) return Task.FromResult(GameState.Spinning);
        if (hasSpinButton && !hasAnimation) return Task.FromResult(GameState.Idle);
        
        return Task.FromResult(GameState.Unknown);
    }
}
```

---

## Recommended Implementation Order

### Week 1: MVP - Development Mode Foundation
1. ✅ Verify EventBuffer is complete (it is)
2. Create `FourEyesDevMode.cs` with safety configuration
3. Create `ConfirmationGate.cs` for mandatory approvals
4. Create stub detectors for pipeline testing
5. Create `VisionCommandHandler.cs` in H4ND
6. Wire up EventBus subscription in H4ND
7. Test end-to-end: Frame → Analysis → Decision → Confirmation → (Mock) Action

### Week 2: Integration & Dashboard
8. Implement `CDPScreenshotReceiver.cs` for OBS-free testing
9. Create basic `DeveloperDashboard.cs` (console-based)
10. Add `TrainingDataCapture.cs` for frame collection
11. Integrate HealthCheckService with OBS/CDP
12. Full integration test with H4ND

### Week 3+: Real Models (Post-MVP)
13. Implement `TesseractJackpotDetector.cs`
14. Create button template library
15. Implement `TemplateButtonDetector.cs`
16. Train/improve state classifier
17. Performance optimization

---

## Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Stream latency | <500ms | Frame timestamp → Analysis complete |
| Vision processing | 2-5 FPS | Frames analyzed per second |
| Jackpot OCR accuracy | >80% | Correct value / Total attempts |
| Button detection | >75% confidence | Detection score threshold |
| State classification | >90% accuracy | Correct state / Total classifications |
| Command latency | <2s | VisionCommand → CDP execution |
| Safety compliance | 100% | Unconfirmed spins / Total spins = 0 |

---

## Metadata

- **Input Prompt**: Request for implementation strategy for FourEyes Development Assistant Activation
- **Response Length**: ~11000 characters
- **Key Findings**:
  - 6-phase implementation strategy over 4 weeks
  - MVP: 9 components, ~46 hours effort
  - Critical path: EventBuffer, FourEyesDevMode, VisionCommandHandler, ConfirmationGate, SafetyMonitor, Stub Detectors
  - 14 files to create across W4TCHD0G/Development/, W4TCHD0G/Vision/, H4ND/Vision/, C0MMON/Configuration/
  - 6 files to modify including H4ND.cs, FourEyesAgent.cs, DecisionEngine.cs
  - Multi-layer safety: Configuration limits → DecisionEngine checks → ConfirmationGate → SafetyMonitor → EmergencyStop
  - Dashboard: 3-panel terminal UI with frame preview, analysis, logs, controls
  - Model implementations: Tesseract OCR, Template matching, Heuristic classification
- **Approval Rating**: 90%
- **Files Referenced**: W4TCHD0G/Agent/, W4TCHD0G/Vision/, W4TCHD0G/Stream/, H4ND/, C0MMON/Infrastructure/, C0MMON/Monitoring/
