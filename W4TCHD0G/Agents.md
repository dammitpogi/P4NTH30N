# W4TCHD0G

## Responsibility

W4TCHD0G is a vision system for OBS (Open Broadcaster Software) integration. Provides computer vision capabilities for game state detection and monitoring via WebSocket-based OBS control and local ML model inference.

**Current Status**: Partial implementation - OBS client and model routing implemented, vision processing is placeholder.

## Core Components

### W4TCHD0G.cs
Placeholder class (literal placeholder):
```csharp
public class W4TCHD0G { }
```

### OBSClient.cs
OBS WebSocket client implementation:
- `ConnectAsync()` - Connect to OBS WebSocket
- `DisconnectAsync()` - Graceful disconnect
- `IsStreamActiveAsync()` - Check if stream is running
- `GetLatencyAsync()` - Measure OBS response latency
- `CaptureFrameAsync(sourceName)` - Capture screenshot from source (1280x720 PNG)
- Implements `IOBSClient` and `IDisposable`

### IOBSClient.cs
Interface for OBS client:
```csharp
public interface IOBSClient
{
    Task ConnectAsync();
    Task DisconnectAsync();
    bool IsConnected { get; }
    Task<bool> IsStreamActiveAsync();
    Task<long> GetLatencyAsync();
    Task<VisionFrame?> CaptureFrameAsync(string sourceName);
}
```

### LMStudioClient.cs
Local ML model inference client (exists but content not verified)

### ILMStudioClient.cs
Interface for LM Studio client

### ModelRouter.cs
Routes vision tasks to appropriate ML models:
- Default models registered:
  - `frame_analysis` → `llava-v1.6-mistral-7b` (max 5000ms latency)
  - `ocr_extraction` → `llava-phi-3-mini` (max 2000ms latency)
  - `state_detection` → `moondream2` (max 1000ms latency)
- Performance tracking via `ModelPerformance`
- Selects best model based on accuracy and latency

### OBSVisionBridge.cs
Bridge between OBS and vision processing (exists, not fully verified)

## Configuration

### OBSConfig.cs
OBS connection settings

### VisionConfig.cs
Vision processing parameters

## Models

### VisionFrame.cs
Single frame processing data:
- `Data` - Raw image bytes
- `Width`, `Height` - Frame dimensions
- `SourceName` - OBS source name
- `FrameNumber` - Sequential counter
- `Timestamp` - UTC capture time

### VisionAnalysis.cs
Analysis results container

### ModelPerformance.cs
Vision model metrics:
- Tracks accuracy and latency per model
- `RecordInference(success, latencyMs)`

### ModelAssignment.cs
Task-to-model routing configuration:
- `TaskName`, `ModelId`, `Provider`
- `MaxLatencyMs`, `Device`

### AnimationState.cs
UI animation detection states

## Key Patterns

1. **Frame Processing**: Capture → Analyze → Detect → Report
2. **Model Routing**: Direct tasks to appropriate vision models
3. **WebSocket Communication**: OBS control via WebSocket protocol
4. **Performance Tracking**: Latency and accuracy metrics per model

## OBS WebSocket Protocol

```csharp
// Capture frame at 1280x720 PNG
CaptureFrameAsync("sourceName")
// Returns VisionFrame with base64-decoded image data

// Get stream status
IsStreamActiveAsync() // Returns bool

// Measure latency
GetLatencyAsync() // Returns milliseconds
```

## Future Capabilities

- Real-time jackpot detection from video
- Automated game state recognition
- Anomaly detection via visual patterns
- Integration with H4ND for vision-based automation

## Recent Updates (2026-02-19)

### FourEyes Integration
- **FourEyesAgent.cs**: Vision decision engine with confidence scoring
- **IFourEyesAgent.cs**: Interface for vision-based decision making
- **DecisionEngine.cs**: Multi-factor decision analysis
- Integration with H4ND VisionCommand processing

### Enhanced Vision Pipeline
- ModelAssignment for dynamic model routing
- AnimationState detection for UI transitions
- FrameTimestamp for precise timing analysis
- Improved OBS WebSocket error handling

### H4ND Vision Commands
- VisionCommand entity for FourEyes-H4ND coordination
- VisionCommandType enum (Spin, Stop, SwitchGame, etc.)
- VisionCommandStatus tracking (Pending, InProgress, Completed, Failed)

## Dependencies

- OBS WebSocket library
- System.Net.WebSockets
- C0MMON for data integration
- LMStudio for local inference

## Entry Point

`W4TCHD0G/W4TCHD0G.cs` - Placeholder class

## Integration Points

- HealthCheckService.CheckVisionStreamHealth() - Reports "W4TCHD0G pending"
- C0MMON/Monitoring - Vision stream health check
