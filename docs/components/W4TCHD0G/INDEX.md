# W4TCHD0G Component Guide

Vision, safety, and monitoring agent — "The Watchdog" of P4NTHE0N.

## Overview

W4TCHD0G provides comprehensive vision capabilities through OBS integration, safety monitoring with spend limits and kill switches, and win detection using both balance monitoring and OCR. It acts as a guardian ensuring safe automated gameplay.

### Responsibilities

- **Vision System**: Capture and process video frames from OBS
- **Win Detection**: Detect jackpot wins via balance changes and OCR
- **Safety Monitoring**: Enforce spend limits, loss circuit breakers, kill switches
- **Health Monitoring**: Track system health and alert on issues
- **Input Coordination**: Manage action queues and screen mapping

## Architecture

```
W4TCHD0G/
├── Agent/
│   ├── FourEyesAgent.cs          # Main autonomous agent
│   ├── DecisionEngine.cs         # Rule-based decision making
│   └── SignalPoller.cs           # Signal polling and processing
├── Safety/
│   ├── ISafetyMonitor.cs         # Safety monitoring interface
│   └── SafetyMonitor.cs          # Implementation with limits
├── Monitoring/
│   ├── WinDetector.cs            # Win detection logic
│   ├── JackpotAlertService.cs    # Alert management
│   └── HealthMonitor.cs          # System health tracking
├── Vision/
│   ├── VisionProcessor.cs        # Frame processing pipeline
│   ├── IJackpotDetector.cs       # Jackpot detection interface
│   ├── IStateClassifier.cs       # Game state classification
│   └── IButtonDetector.cs        # UI button detection
├── Stream/
│   ├── FrameBuffer.cs            # Circular frame buffer
│   ├── RTMPStreamReceiver.cs     # Stream ingestion
│   └── StreamHealthMonitor.cs    # Stream quality
├── Input/
│   ├── ActionQueue.cs            # Input action queue
│   ├── ScreenMapper.cs           # Coordinate mapping
│   └── InputAction.cs            # Action definition
└── OBS/
    ├── ResilientOBSClient.cs     # OBS WebSocket client
    ├── ReconnectionPolicy.cs     # Reconnection strategy
    └── ConnectionState.cs        # Connection state tracking
```

## Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                        W4TCHD0G                              │
│                                                               │
│  ┌──────────────┐                                            │
│  │ OBS Studio   │                                            │
│  │   (in VM)    │                                            │
│  └──────┬───────┘                                            │
│         │ RTMP Stream                                         │
│         ▼                                                     │
│  ┌──────────────┐      ┌──────────────┐      ┌────────────┐ │
│  │RTMPReceiver  │──────▶│ FrameBuffer  │──────▶│  Vision    │ │
│  │              │      │ (circular)   │      │ Processor  │ │
│  └──────────────┘      └──────────────┘      └─────┬──────┘ │
│                                                    │         │
│         ┌──────────────────────────────────────────┤         │
│         │                    │                     │         │
│         ▼                    ▼                     ▼         │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐    │
│  │ WinDetector  │   │  Decision    │   │   Health     │    │
│  │              │   │   Engine     │   │   Monitor    │    │
│  └──────┬───────┘   └──────┬───────┘   └──────┬───────┘    │
│         │                   │                    │            │
│         ▼                   ▼                    ▼            │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐    │
│  │   Alert      │   │   Action     │   │   Safety     │    │
│  │   Service    │   │    Queue     │   │   Monitor    │    │
│  └──────┬───────┘   └──────┬───────┘   └──────┬───────┘    │
│         │                   │                    │            │
│         │                   ▼                    │            │
│         │            ┌──────────────┐           │            │
│         │            │   Synergy    │           │            │
│         │            │   Client     │           │            │
│         │            └──────┬───────┘           │            │
│         │                   │                    │            │
│         └───────────────────┼────────────────────┘            │
│                             ▼                                 │
│                      ┌──────────────┐                        │
│                      │   MongoDB    │                        │
│                      │   (EV3NT)    │                        │
│                      └──────────────┘                        │
└─────────────────────────────────────────────────────────────┘
```

## Main Components

### 1. Vision System

#### Frame Capture Flow
```csharp
public class VisionPipeline
{
    public async Task ProcessFrameAsync(VisionFrame frame)
    {
        // 1. Store in buffer for temporal analysis
        frameBuffer.Store(frame);
        
        // 2. Extract timestamp for latency tracking
        var timestamp = FrameTimestamp.Create(frame);
        
        // 3. Parallel processing
        var tasks = new[]
        {
            Task.Run(() => jackpotDetector.Detect(frame)),
            Task.Run(() => stateClassifier.Classify(frame)),
            Task.Run(() => buttonDetector.Detect(frame))
        };
        
        await Task.WhenAll(tasks);
        
        // 4. Aggregate results
        var context = new VisionContext
        {
            JackpotDetected = tasks[0].Result,
            GameState = tasks[1].Result,
            Buttons = tasks[2].Result,
            Timestamp = timestamp
        };
        
        // 5. Send to decision engine
        await decisionEngine.EvaluateAsync(context);
    }
}
```

#### OBS Integration
```csharp
public class ResilientOBSClient : IOBSClient
{
    private readonly ReconnectionPolicy _reconnectionPolicy;
    private ConnectionState _state;
    
    public async Task<VisionFrame> CaptureFrameAsync(string sourceName)
    {
        try
        {
            // Connect if not connected
            if (_state != ConnectionState.Connected)
            {
                await ConnectWithRetryAsync();
            }
            
            // Capture frame at 1280x720
            var frameData = await _webSocket.SendAsync(new
            {
                RequestType = "GetSourceScreenshot",
                SourceName = sourceName,
                ImageFormat = "png",
                ImageWidth = 1280,
                ImageHeight = 720
            });
            
            return new VisionFrame
            {
                Data = Convert.FromBase64String(frameData.ImageData),
                Width = 1280,
                Height = 720,
                SourceName = sourceName,
                FrameNumber = Interlocked.Increment(ref _frameCounter),
                Timestamp = DateTime.UtcNow
            };
        }
        catch (Exception ex)
        {
            _state = ConnectionState.Disconnected;
            throw new VisionException("Frame capture failed", ex);
        }
    }
    
    private async Task ConnectWithRetryAsync()
    {
        var retryCount = 0;
        while (retryCount < _reconnectionPolicy.MaxRetries)
        {
            try
            {
                await _webSocket.ConnectAsync(_obsWebSocketUrl);
                _state = ConnectionState.Connected;
                return;
            }
            catch
            {
                retryCount++;
                await Task.Delay(_reconnectionPolicy.GetDelay(retryCount));
            }
        }
        throw new ConnectionException("Failed to connect to OBS");
    }
}
```

### 2. Win Detection

#### Dual Detection Strategy
```csharp
public class WinDetector
{
    private readonly IJackpotDetector _visionDetector;
    private readonly IBalanceMonitor _balanceMonitor;
    
    public async Task<WinResult> DetectWinAsync(Credential credential)
    {
        // Method 1: Balance change detection
        var balanceResult = await _balanceMonitor.CheckAsync(credential);
        
        // Method 2: Vision/OCR detection
        var frame = await _obsClient.CaptureFrameAsync("game-source");
        var visionResult = await _visionDetector.DetectAsync(frame);
        
        // Dual confirmation
        if (balanceResult.HasWin && visionResult.HasWin)
        {
            return new WinResult
            {
                Confirmed = true,
                Confidence = WinConfidence.High,
                Amount = balanceResult.Amount,
                Tier = visionResult.Tier,
                Timestamp = DateTime.UtcNow
            };
        }
        else if (balanceResult.HasWin || visionResult.HasWin)
        {
            return new WinResult
            {
                Confirmed = true,
                Confidence = WinConfidence.Medium,
                Amount = balanceResult.Amount ?? visionResult.Amount,
                Tier = visionResult.Tier,
                Timestamp = DateTime.UtcNow
            };
        }
        
        return new WinResult { Confirmed = false };
    }
}
```

#### OCR-Based Detection
```csharp
public class OCRJackpotDetector : IJackpotDetector
{
    private readonly ILlmClient _llmClient;
    
    public async Task<DetectionResult> DetectAsync(VisionFrame frame)
    {
        // Convert frame to format for OCR
        var imageBase64 = Convert.ToBase64String(frame.Data);
        
        // Use TROCR for text extraction
        var prompt = @"Extract all jackpot values from this image. 
                       Format: 'Grand: $X.XX, Major: $X.XX, Minor: $X.XX, Mini: $X.XX'
                       If no values found, return 'NONE'";
        
        var response = await _llmClient.CompleteAsync(new LlmRequest
        {
            Model = "microsoft/trocr-base-handwritten",
            Image = imageBase64,
            Prompt = prompt,
            MaxTokens = 100,
            TimeoutMs = 2000
        });
        
        // Parse response
        var values = ParseJackpotValues(response.Text);
        
        return new DetectionResult
        {
            HasWin = values.Current > values.Previous,
            Amount = values.Current - values.Previous,
            Tier = DetermineTier(values),
            Confidence = response.Confidence
        };
    }
}
```

### 3. Safety Monitoring

#### Safety Monitor Implementation
```csharp
public class SafetyMonitor : ISafetyMonitor
{
    private readonly decimal _dailySpendLimit;
    private readonly int _consecutiveLossLimit;
    private readonly string _killSwitchCode;
    
    private decimal _dailySpent;
    private int _consecutiveLosses;
    private bool _killSwitchActive;
    
    public SafetyMonitor(
        decimal dailySpendLimit,
        int consecutiveLossLimit,
        string killSwitchCode)
    {
        _dailySpendLimit = dailySpendLimit;
        _consecutiveLossLimit = consecutiveLossLimit;
        _killSwitchCode = killSwitchCode;
    }
    
    public SafetyCheckResult CheckSpend(decimal amount)
    {
        // Track spend
        _dailySpent += amount;
        
        // Check daily limit
        if (_dailySpent >= _dailySpendLimit)
        {
            ActivateKillSwitch("Daily spend limit exceeded");
            return SafetyCheckResult.KillSwitchActivated;
        }
        
        // Check if loss
        if (amount < 0)
        {
            _consecutiveLosses++;
            
            if (_consecutiveLosses >= _consecutiveLossLimit)
            {
                ActivateKillSwitch($"Consecutive loss limit reached: {_consecutiveLosses}");
                return SafetyCheckResult.CircuitBreakerTriggered;
            }
        }
        else
        {
            // Win - reset consecutive losses
            _consecutiveLosses = 0;
        }
        
        return SafetyCheckResult.Ok;
    }
    
    public void ActivateKillSwitch(string reason)
    {
        _killSwitchActive = true;
        
        // Log to console
        Console.WriteLine($"🚨 KILL SWITCH ACTIVATED: {reason}");
        
        // Log to file
        File.AppendAllText("safety-alerts.log", 
            $"[{DateTime.UtcNow}] KILL SWITCH: {reason}\n");
        
        // Send webhook alert
        SendWebhookAlert(new AlertMessage
        {
            Severity = AlertSeverity.Critical,
            Message = $"Kill switch activated: {reason}",
            Timestamp = DateTime.UtcNow
        });
    }
    
    public bool DeactivateKillSwitch(string code)
    {
        if (code != _killSwitchCode)
        {
            return false;
        }
        
        _killSwitchActive = false;
        _dailySpent = 0;
        _consecutiveLosses = 0;
        
        Console.WriteLine("✅ Kill switch deactivated");
        return true;
    }
    
    public bool IsKillSwitchActive => _killSwitchActive;
}
```

### 4. Decision Engine

#### Rule-Based Decision Making
```csharp
public class DecisionEngine
{
    private readonly List<IDecisionRule> _rules;
    private readonly ActionQueue _actionQueue;
    
    public async Task EvaluateAsync(VisionContext context)
    {
        var decision = new Decision();
        
        // Evaluate all rules in priority order
        foreach (var rule in _rules.OrderBy(r => r.Priority))
        {
            var result = await rule.EvaluateAsync(context);
            
            if (result.ShouldAct)
            {
                decision.Actions.Add(result.Action);
                decision.Confidence = result.Confidence;
                decision.Reasoning = result.Reasoning;
                
                // Stop on first high-confidence decision
                if (result.Confidence >= ConfidenceLevel.High)
                {
                    break;
                }
            }
        }
        
        // Execute or queue decision
        if (decision.Actions.Any())
        {
            await ExecuteDecisionAsync(decision);
        }
    }
    
    private async Task ExecuteDecisionAsync(Decision decision)
    {
        foreach (var action in decision.Actions)
        {
            await _actionQueue.EnqueueAsync(new InputAction
            {
                Type = action.Type,
                Coordinates = action.Coordinates,
                Delay = action.Delay,
                Priority = decision.Confidence == ConfidenceLevel.High ? 1 : 2
            });
        }
    }
}

// Example rules
public class JackpotDetectedRule : IDecisionRule
{
    public int Priority => 1; // Highest
    
    public async Task<RuleResult> EvaluateAsync(VisionContext context)
    {
        if (context.JackpotDetected)
        {
            return new RuleResult
            {
                ShouldAct = true,
                Action = new Action { Type = ActionType.CaptureScreenshot },
                Confidence = ConfidenceLevel.High,
                Reasoning = $"Jackpot detected: {context.JackpotAmount}"
            };
        }
        
        return new RuleResult { ShouldAct = false };
    }
}

public class LowBalanceRule : IDecisionRule
{
    public int Priority => 2;
    
    public async Task<RuleResult> EvaluateAsync(VisionContext context)
    {
        if (context.Balance < MinimumBalance)
        {
            return new RuleResult
            {
                ShouldAct = true,
                Action = new Action { Type = ActionType.StopAutomation },
                Confidence = ConfidenceLevel.Critical,
                Reasoning = "Balance below minimum threshold"
            };
        }
        
        return new RuleResult { ShouldAct = false };
    }
}
```

### 5. Frame Buffer

#### Circular Buffer for Temporal Analysis
```csharp
public class FrameBuffer
{
    private readonly ConcurrentQueue<VisionFrame> _buffer;
    private readonly int _capacity;
    private readonly object _lock = new();
    
    public FrameBuffer(int capacity = 10) // 5 seconds at 2 FPS
    {
        _capacity = capacity;
        _buffer = new ConcurrentQueue<VisionFrame>();
    }
    
    public void Store(VisionFrame frame)
    {
        lock (_lock)
        {
            _buffer.Enqueue(frame);
            
            // Remove oldest if at capacity
            while (_buffer.Count > _capacity)
            {
                _buffer.TryDequeue(out _);
            }
        }
    }
    
    public IEnumerable<VisionFrame> GetRecent(int count)
    {
        lock (_lock)
        {
            return _buffer.TakeLast(count).ToList();
        }
    }
    
    public IEnumerable<VisionFrame> GetFramesBetween(DateTime start, DateTime end)
    {
        lock (_lock)
        {
            return _buffer
                .Where(f => f.Timestamp >= start && f.Timestamp <= end)
                .ToList();
        }
    }
    
    // Calculate latency metrics
    public LatencyMetrics CalculateLatency()
    {
        var frames = _buffer.ToList();
        if (frames.Count < 2) return new LatencyMetrics();
        
        var latencies = new List<TimeSpan>();
        for (int i = 1; i < frames.Count; i++)
        {
            latencies.Add(frames[i].Timestamp - frames[i-1].Timestamp);
        }
        
        return new LatencyMetrics
        {
            Average = TimeSpan.FromMilliseconds(latencies.Average(l => l.TotalMilliseconds)),
            Max = latencies.Max(),
            Min = latencies.Min(),
            P95 = TimeSpan.FromMilliseconds(latencies
                .Select(l => l.TotalMilliseconds)
                .OrderBy(x => x)
                .ElementAt((int)(latencies.Count * 0.95)))
        };
    }
}
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `W4TCHD0G_OBS_URL` | `ws://localhost:4455` | OBS WebSocket URL |
| `W4TCHD0G_FRAME_RATE` | 2 | Frames per second |
| `W4TCHD0G_BUFFER_SIZE` | 10 | Frame buffer capacity |
| `W4TCHD0G_RTMPSERVER` | `rtmp://localhost:1935/live` | RTMP server URL |
| `SAFETY_DAILY_SPEND_LIMIT` | 1000 | Daily spend limit (USD) |
| `SAFETY_CONSECUTIVE_LOSS_LIMIT` | 10 | Max consecutive losses |
| `SAFETY_KILL_SWITCH_CODE` | — | Override code (required) |

### appsettings.json
```json
{
  "W4TCHD0G": {
    "Vision": {
      "FrameRate": 2,
      "FrameWidth": 1280,
      "FrameHeight": 720,
      "BufferSize": 10,
      "SourceName": "Game Capture"
    },
    "OBS": {
      "WebSocketUrl": "ws://localhost:4455",
      "Password": null,
      "ReconnectionPolicy": {
        "MaxRetries": 5,
        "BaseDelayMs": 1000,
        "MaxDelayMs": 30000
      }
    },
    "RTMP": {
      "ServerUrl": "rtmp://localhost:1935/live",
      "StreamKey": "foureyes",
      "BufferTimeMs": 1000
    },
    "Safety": {
      "DailySpendLimit": 1000.00,
      "ConsecutiveLossLimit": 10,
      "KillSwitchCode": "CONFIRM-RESUME-P4NTHE0N"
    },
    "Alerts": {
      "Console": true,
      "File": true,
      "FilePath": "win-events.log",
      "Webhook": {
        "Enabled": false,
        "Url": null
      }
    }
  }
}
```

## Integration Points

### Consumes
- **OBS WebSocket**: Frame capture
- **RTMP Stream**: Video ingestion
- **MongoDB**: Health status, events
- **H4ND**: Safety coordination

### Produces
- **Alerts**: Console, file, webhook
- **EV3NT**: Win detections, safety events
- **Actions**: Via Synergy to VM

### Coordinates With
- **H4ND**: Safety limits, win confirmation
- **H0UND**: Health status

## Health Monitoring

### Health Checks
```csharp
public async Task<SystemHealth> CheckHealthAsync()
{
    var checks = new Dictionary<string, HealthStatus>
    {
        ["OBSConnection"] = await CheckOBSConnection(),
        ["RTMPStream"] = await CheckRTMPStream(),
        ["VisionPipeline"] = await CheckVisionPipeline(),
        ["FrameBuffer"] = CheckFrameBuffer(),
        ["SafetyMonitor"] = CheckSafetyMonitor()
    };
    
    return new SystemHealth
    {
        Overall = checks.Values.All(s => s == HealthStatus.Healthy) 
            ? HealthStatus.Healthy 
            : HealthStatus.Degraded,
        ComponentStatus = checks,
        Timestamp = DateTime.UtcNow
    };
}
```

### Metrics
- Frame capture latency (p50, p95, p99)
- Vision processing time
- Win detection accuracy
- Safety trigger frequency
- Stream quality (dropped frames)

## Troubleshooting

### No Frames Received
1. Check OBS is streaming
2. Verify RTMP URL correct
3. Check firewall (port 1935)
4. Verify stream key matches

### Win Detection Not Working
1. Check frame resolution
2. Verify OCR ROIs configured
3. Review detection confidence
4. Check balance monitoring

### Safety Monitor Triggering
1. Review spend tracking
2. Check consecutive loss count
3. Verify limits configured
4. Review kill switch logs

### OBS Connection Failing
1. Verify OBS running
2. Check WebSocket plugin enabled
3. Verify URL and password
4. Check reconnection logs

## Code Examples

### Custom Vision Rule
```csharp
public class CustomVisionRule : IDecisionRule
{
    public int Priority => 5;
    
    public async Task<RuleResult> EvaluateAsync(VisionContext context)
    {
        // Custom detection logic
        if (context.GameState == GameState.ErrorScreen)
        {
            return new RuleResult
            {
                ShouldAct = true,
                Action = new Action { Type = ActionType.TakeScreenshot },
                Confidence = ConfidenceLevel.High,
                Reasoning = "Error screen detected"
            };
        }
        
        return new RuleResult { ShouldAct = false };
    }
}
```

### Custom Win Detector
```csharp
public class CustomWinDetector : IJackpotDetector
{
    public async Task<DetectionResult> DetectAsync(VisionFrame frame)
    {
        // Custom win detection
        var roi = new RegionOfInterest(100, 200, 300, 400);
        var cropped = frame.Crop(roi);
        
        // Process cropped region
        var hasWin = await _customModel.PredictAsync(cropped);
        
        return new DetectionResult
        {
            HasWin = hasWin,
            Confidence = 0.95,
            Tier = JackpotTier.Unknown
        };
    }
}
```

---

**Related**: [H0UND Component](../H0UND/) | [H4ND Component](../H4ND/) | [Safety Monitor API](../../api-reference/interfaces/isafety-monitor.md)
