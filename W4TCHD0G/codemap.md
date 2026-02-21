# W4TCHD0G/

## Responsibility

W4TCHD0G is the comprehensive vision, safety, and monitoring system for P4NTH30N. It provides OBS (Open Broadcaster Software) integration for video stream capture, computer vision for game state detection, safety monitoring with spend/loss limits and kill switch, win detection with dual confirmation (balance + OCR), and health monitoring for all system components.

**Core Capabilities:**
- **Vision System**: OBS WebSocket integration, frame capture, vision processing
- **Safety Monitoring**: Daily spend/loss limits, consecutive loss circuit breaker, kill switch with override
- **Win Detection**: Balance monitoring + OCR-based jackpot detection with multi-channel alerting
- **Health Monitoring**: Stream health, process health, error rate monitoring
- **Intelligent Agent**: FourEyesAgent with DecisionEngine for autonomous monitoring
- **Input Coordination**: ActionQueue and ScreenMapper for synchronized automation

## Design

**Architecture Pattern**: Multi-layered async system with resilient connections
- **OBS Layer**: WebSocket client with automatic reconnection
- **Vision Layer**: Frame capture, ML model routing, computer vision
- **Safety Layer**: Real-time spend tracking, limit enforcement, kill switch
- **Detection Layer**: Win detection with dual confirmation (balance + OCR)
- **Agent Layer**: FourEyesAgent with DecisionEngine for intelligent decisions
- **Input Layer**: ActionQueue, ScreenMapper for coordinated input

### Key Components

#### OBS Integration
- **ResilientOBSClient.cs**: OBS WebSocket client with automatic reconnection
- **ReconnectionPolicy.cs**: Exponential backoff reconnection strategy
- **ConnectionState.cs**: Connection state tracking (Disconnected, Connecting, Connected)
- **IOBSClient.cs**: Interface for OBS operations

#### Vision Processing
- **VisionProcessor.cs**: Main vision processing pipeline
- **IJackpotDetector.cs**: Interface for jackpot detection from frames
- **IStateClassifier.cs**: ML-based game state classification
- **IButtonDetector.cs**: UI button detection for automation
- **RegionOfInterest.cs**: Defines screen regions for focused detection

#### Safety Monitoring (WIN-004)
- **ISafetyMonitor.cs**: Safety monitoring interface
- **SafetyMonitor.cs**: Implementation with:
  - Daily spend limits (configurable per-credential)
  - Consecutive loss circuit breaker (halts after N losses)
  - Kill switch with override code for emergency stops
  - Real-time spend tracking integration with H4ND

#### Win Detection (WIN-003)
- **WinDetector.cs**: Dual detection system:
  - Balance detection: Monitors account balance changes
  - OCR detection: Vision-based jackpot recognition
- **JackpotAlertService.cs**: Multi-channel alerting:
  - Console notifications
  - File logging
  - Webhook notifications

#### Streaming Infrastructure
- **FrameBuffer.cs**: Circular buffer for frame storage and correlation
- **IStreamReceiver.cs**: Interface for stream receivers
- **RTMPStreamReceiver.cs**: RTMP stream ingestion
- **StreamHealthMonitor.cs**: Stream quality and health tracking
- **FrameTimestamp.cs**: Timestamp correlation and latency metrics (FOUR-008)

#### Intelligent Agent
- **FourEyesAgent.cs**: Autonomous monitoring agent
- **IFourEyesAgent.cs**: Agent interface
- **DecisionEngine.cs**: Rule-based decision making for automation
- **SignalPoller.cs**: Polls for signals and triggers actions (ACT-001)

#### Input Coordination
- **ActionQueue.cs**: Queued input action management
- **InputAction.cs**: Individual input action definition
- **ScreenMapper.cs**: Screen coordinate mapping for automation
- **ISynergyClient.cs / SynergyClient.cs**: Client for input coordination

#### Health Monitoring
- **HealthMonitor.cs**: System-wide health checks (FOUR-003)
- **JackpotAlertService.cs**: Alerting and notification service

### Model Routing
- **LMStudioClient.cs**: Local ML model inference client
- **ILMStudioClient.cs**: Interface for LM Studio operations
- **ModelRouter.cs**: Routes vision tasks to appropriate models:
  - `frame_analysis` → `llava-v1.6-mistral-7b` (max 5000ms)
  - `ocr_extraction` → `llava-phi-3-mini` (max 2000ms)
  - `state_detection` → `moondream2` (max 1000ms)

### Vision Models
- **VisionFrame.cs**: Frame data with metadata (Data, Width, Height, SourceName, FrameNumber, Timestamp)
- **VisionAnalysis.cs**: Analysis results container
- **ModelPerformance.cs**: Tracks accuracy and latency per model
- **ModelAssignment.cs**: Task-to-model routing configuration
- **AnimationState.cs**: UI animation detection states

## Flow

### Vision Processing Flow
```
OBS Source
    ↓
ResilientOBSClient.CaptureFrameAsync()
    ↓
FrameBuffer.Store()
    ↓
VisionProcessor.Process()
    ↓
[Parallel Detection]
    ├── IJackpotDetector.Detect()
    ├── IStateClassifier.Classify()
    └── IButtonDetector.Detect()
    ↓
DecisionEngine.Evaluate()
    ↓
ActionQueue.Enqueue() / Alert
```

### Win Detection Flow (WIN-003)
```
Balance Query (from H4ND)
    ↓
WinDetector.CheckBalanceChange()
    ↓
Vision Frame Capture
    ↓
OCR Jackpot Recognition
    ↓
Dual Confirmation (Balance + OCR)
    ↓
JackpotAlertService.Notify()
    ├── Console Alert
    ├── File Log
    └── Webhook
```

### Safety Monitoring Flow (WIN-004)
```
H4ND Gameplay Loop
    ↓
SafetyMonitor.TrackSpend(amount)
    ↓
[Checks]
    ├── Daily Spend > Limit? → Kill Switch
    ├── Consecutive Losses > Threshold? → Circuit Breaker
    └── Manual Kill Switch Triggered? → Immediate Halt
    ↓
Action: Continue / Halt / Alert
```

### Frame Correlation Flow (FOUR-008)
```
Frame Capture
    ↓
FrameTimestamp.Create()
    ↓
Timestamp Recording (UTC)
    ↓
Latency Calculation
    ↓
Correlation with Actions
    ↓
Metrics Aggregation
```

### Health Monitoring Flow (FOUR-003)
```
HealthMonitor.CheckAll()
    ↓
[Health Checks]
    ├── Stream Health (FrameBuffer status)
    ├── OBS Connection (ResilientOBSClient status)
    ├── Vision Pipeline (processing latency)
    └── Error Rate (ERR0R collection queries)
    ↓
Metrics Aggregation
    ↓
Health Report
```

## Integration

### Dependencies
- **C0MMON**: All infrastructure via IMongoUnitOfWork, IRepo interfaces
- **H4ND**: Safety monitoring tracks H4ND gameplay spends
- **H0UND**: Receives analytics data for vision correlation
- **OBS Studio**: External WebSocket server for frame capture
- **LM Studio**: Local ML inference server

### External Systems
- **OBS WebSocket**: Real-time video capture (ws://localhost:4455)
- **LM Studio**: Local model inference (vision models)
- **MongoDB**: Event logging, metrics storage
- **Webhook Endpoints**: For jackpot alerts

### Data Collections (via C0MMON)
- `EV3NT`: Vision events, detection results
- `ERR0R`: Vision processing errors
- Custom metrics storage for latency tracking

### Interface Contracts
```
ISafetyMonitor        : Spend tracking, limits, kill switch
IJackpotDetector      : Vision-based jackpot detection
IStateClassifier      : ML game state classification
IButtonDetector       : UI element detection
IStreamReceiver       : Stream ingestion abstraction
IOBSClient            : OBS WebSocket operations
IFourEyesAgent        : Autonomous monitoring agent
```

## Configuration

### OBS Configuration
```json
{
  "obsWebSocketUrl": "ws://localhost:4455",
  "obsPassword": "optional",
  "sourceName": "Game Capture"
}
```

### Safety Limits (HunterConfig.json)
```json
{
  "dailySpendLimit": 1000.00,
  "consecutiveLossLimit": 10,
  "killSwitchCode": "EMERGENCY123"
}
```

### Model Routing
- Frame Analysis: llava-v1.6-mistral-7b (5s timeout)
- OCR: llava-phi-3-mini (2s timeout)
- State Detection: moondream2 (1s timeout)

## Key Patterns

1. **Resilient Connections**: Automatic reconnection with exponential backoff
2. **Frame Buffering**: Circular buffer for temporal analysis
3. **Dual Detection**: Balance + OCR confirmation for reliability
4. **Circuit Breaker**: Consecutive loss detection stops runaway losses
5. **Kill Switch**: Emergency halt with override capability
6. **Model Routing**: Automatic task-to-model assignment based on performance
7. **Timestamp Correlation**: Frame-to-action latency tracking

## Testing

Integration tests in UNI7T35T:
- FrameBuffer tests
- ScreenMapper tests
- ActionQueue tests
- DecisionEngine tests
- SafetyMonitor tests (WIN-004)
- WinDetector tests (WIN-003)
- InputAction tests

All 16 W4TCHD0G integration tests passing (27/27 total).

## Recent Additions (This Session)

**WIN-004: Safety System**
- ISafetyMonitor interface
- SafetyMonitor implementation with limits and kill switch

**WIN-003: Win Detection**
- WinDetector with dual detection
- JackpotAlertService with multi-channel alerts

**FOUR-003: Health Monitoring**
- HealthMonitor for system-wide checks

**FOUR-008: Frame Correlation**
- FrameTimestamp for latency metrics

**ACT-001: Signal Polling**
- SignalPoller for autonomous action triggers

**Vision Infrastructure**
- VisionProcessor, detectors, classifiers
- FrameBuffer, StreamHealthMonitor
- ResilientOBSClient with reconnection

**Intelligent Agent**
- FourEyesAgent, DecisionEngine
- ActionQueue, ScreenMapper

### New Components (2026-02-20)
- **Development/ConfirmationGate.cs**: Confirmation gate for development mode
- **Development/DeveloperDashboard.cs**: Developer dashboard UI
- **Development/FourEyesDevMode.cs**: FourEyes development mode
- **Development/TrainingDataCapture.cs**: Training data capture utilities
- **Stream/Alternatives/CDPScreenshotReceiver.cs**: CDP-based screenshot receiver
- **Vision/Implementations/HeuristicStateClassifier.cs**: Heuristic-based state classifier
- **Vision/Implementations/TemplateButtonDetector.cs**: Template matching button detector
- **Vision/Implementations/TesseractJackpotDetector.cs**: Tesseract OCR jackpot detector
- **Vision/Stubs/StubButtonDetector.cs**: Stub for button detection
- **Vision/Stubs/StubJackpotDetector.cs**: Stub for jackpot detection
- **Vision/Stubs/StubStateClassifier.cs**: Stub for state classification

(End of file)