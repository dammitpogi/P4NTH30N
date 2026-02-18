# FOUR EYES: COMPREHENSIVE FIXER BRIEF

**Date**: 2026-02-18  
**Oracle Approval**: 87% (up from 44%)  
**Status**: Ready for Implementation  
**Total Decisions**: 45  
**Total Action Items**: 71  

---

## EXECUTIVE SUMMARY

Four Eyes is a vision-based automation system using VM streaming architecture. Oracle has reassessed and approved at 87% after all blockers were addressed with detailed implementation specifications.

**Architecture Pattern**: VM (OBS Streaming) → Host (FourEyes Analysis) → VM (Synergy Actions)

---

## SYSTEM ARCHITECTURE

```
┌─────────────────────────────────────────────────────────────────┐
│                         HOST MACHINE                             │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                    FOUR EYES                              │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │   │
│  │  │ RTMP Stream  │  │ W4TCHD0G     │  │ Decision     │   │   │
│  │  │ Receiver     │→ │ Vision       │→ │ Engine       │   │   │
│  │  │ (FFmpeg)     │  │ (OCR/Detect) │  │              │   │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘   │   │
│  │         ↑                                               │   │
│  │         │ Receives stream from VM                       │   │
│  │         │                                               │   │
│  │  ┌──────────────┐  ┌──────────────┐                    │   │
│  │  │ Signal       │  │ Synergy      │                    │   │
│  │  │ Poller       │  │ Client       │──→ Synergy         │   │
│  │  │ (MongoDB)    │  │ (Input)      │    (to VM)         │   │
│  │  └──────────────┘  └──────────────┘                    │   │
│  └──────────────────────────────────────────────────────────┘   │
│                              │                                   │
│  ┌───────────────────────────┼──────────────────────────────┐   │
│  │         MongoDB           │                              │   │
│  │    (SIGN4L, N3XT, etc.)   │                              │   │
│  └───────────────────────────┼──────────────────────────────┘   │
│                              │                                   │
└──────────────────────────────┼───────────────────────────────────┘
                               │
                    Stream (RTMP)
                    Port 1935
                               │
┌──────────────────────────────┼───────────────────────────────────┐
│                              ▼                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              VM (4C/8GB - Executor)                       │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │   │
│  │  │ OBS          │  │ Chrome       │  │ Synergy      │   │   │
│  │  │ (Streaming)  │  │ (Casino)     │  │ Client       │   │   │
│  │  │              │  │              │  │ (Input)      │   │   │
│  │  │ - RTMP Out   │  │              │  │              │   │   │
│  │  │ - 1280x720   │  │              │  │              │   │   │
│  │  │ - 30 FPS     │  │              │  │              │   │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘   │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## DECISIONS BY PRIORITY

### CRITICAL (P10) - Implement First

#### FOUR-001: FourEyes Vision-Based Automation Agent
**Purpose**: Main controller agent on host  
**Status**: Proposed  
**Tasks** (10 action items):
1. ✅ ARCHITECTURE UPDATE: Stream receiver (FFmpeg/RTC)
2. ✅ IMPLEMENT: Stream receiver service using FFmpeg.NET
3. ✅ IMPLEMENT: Adaptive frame sampling (2-5 FPS)
4. ✅ IMPLEMENT: Async action confirmation pattern
5. ✅ CRITICAL: Implement SynergyClient with action queue
6. ✅ CRITICAL: Build RTMP receiver component
7. ✅ CRITICAL: Implement W4TCHD0G vision processing
8. ✅ CRITICAL: Add OBS WebSocket resilience
9. ✅ Add frame timestamp correlation
10. ✅ IMPLEMENT: Create PromptTemplates

**Key Files**:
- FourEyes/Stream/RTMPStreamReceiver.cs
- FourEyes/Vision/AdaptiveFrameSampler.cs
- FourEyes/Actions/AsyncActionController.cs
- FourEyes/Input/SynergyClient.cs

#### VM-002: VM Executor Configuration (Lightweight)
**Purpose**: VM as casino browser executor  
**Status**: Proposed  
**Tasks** (6 action items):
1. ✅ ARCHITECTURE UPDATE: VM runs OBS streaming to host
2. ✅ SETUP: Install OBS, configure streaming
3. ✅ UPDATE: Increase VM to 4C/8GB
4. ✅ CRITICAL: Implement W4TCHD0G vision processing
5. ✅ CRITICAL: Add OBS WebSocket resilience
6. ✅ VM resource test: Verify 8GB RAM sufficient

**Key Files**:
- scripts/vm/setup-obs-streaming.ps1
- docs/vm/VM_RESOURCES.md

#### FOUR-004: Synergy Integration for VM Input Control
**Purpose**: Host→VM mouse/keyboard control  
**Status**: Proposed  
**Implementation**:
```csharp
public class SynergyClient : ISynergyClient
{
    private readonly SynergyConnection _connection;
    private readonly ActionQueue _actionQueue;
    
    public async Task ConnectAsync(string hostIp, int port = 24800)
    {
        // Synergy protocol handshake
        // Authenticate with client name
        // Start input forwarding
    }
    
    public async Task ClickAsync(int x, int y, MouseButton button = MouseButton.Left)
    {
        // Convert to VM screen coordinates
        // Send via Synergy protocol
        // Wait for acknowledgment (2s timeout)
    }
}
```

**Key Files**:
- FourEyes/Input/SynergyClient.cs
- FourEyes/Input/ActionQueue.cs
- FourEyes/Input/InputSimulator.cs

#### FOUR-005: RTMP Stream Receiver
**Purpose**: Ingest VM video stream  
**Status**: Proposed  
**Implementation**:
```csharp
public class RTMPStreamReceiver : IStreamReceiver
{
    public async Task StartAsync(string rtmpUrl = "rtmp://localhost:1935/live")
    {
        // FFmpeg: ffmpeg -i rtmp://localhost:1935/live 
        //              -f rawvideo -pix_fmt bgr24 pipe:1
        _ffmpeg = FFmpegContext.Create()
            .WithInput(rtmpUrl)
            .WithVideoCodec("h264")
            .WithOutputFormat("rawvideo")
            .WithFrameRate(30)
            .WithOutputPipe();
    }
}
```

**Performance Targets**:
- Latency: <300ms (Oracle requirement)
- Frame drop: <1%
- Resolution: 1280x720

**Key Files**:
- FourEyes/Stream/RTMPStreamReceiver.cs
- FourEyes/Stream/FrameBuffer.cs
- FourEyes/Stream/FFmpegContext.cs

#### FOUR-006: W4TCHD0G Vision Processing
**Purpose**: OCR, button detection, state classification  
**Status**: Proposed  
**Components**:
1. **JackpotDetector**: Tesseract OCR (95% accuracy)
2. **ButtonDetector**: Template matching
3. **StateClassifier**: Rules-based (Idle, Spinning, Win, Bonus)
4. **EmbeddingService**: For RAG integration

**Performance**: <500ms per frame

**Key Files**:
- W4TCHD0G/W4TCHD0G.cs (replace placeholder)
- W4TCHD0G/Vision/JackpotDetector.cs
- W4TCHD0G/Vision/ButtonDetector.cs
- W4TCHD0G/Vision/StateClassifier.cs

#### FOUR-007: OBS WebSocket Resilience
**Purpose**: Reconnection with exponential backoff  
**Status**: Proposed  
**Implementation**:
```csharp
public class ResilientOBSClient : IOBSClient
{
    private readonly ReconnectionPolicy _policy = new(
        maxRetries: 10,
        baseDelayMs: 1000,  // 1s, 2s, 4s, 8s, 16s, 30s (cap)
        maxDelayMs: 30000
    );
    
    // Recovery time: <30s (Oracle requirement)
}
```

**Key Files**:
- W4TCHD0G/OBS/ResilientOBSClient.cs
- W4TCHD0G/OBS/ReconnectionPolicy.cs

---

### HIGH (P9) - Implement After Critical

#### FOUR-008: Frame Timestamp Correlation
**Purpose**: Action sync verification, latency tracking  
**Key Files**:
- FourEyes/Models/FrameTimestamp.cs
- FourEyes/Actions/ActionCorrelation.cs

#### TECH-003: GT 710 Hardware Benchmark
**Purpose**: Validate GPU encoding performance  
**Tests**: x264, NVENC, concurrent load  
**Pass Criteria**: <1% lag, maintains 5 FPS

#### FOUR-003: Failure Recovery and Health Monitoring
**Purpose**: Auto-recovery from failures  
**Components**:
- StreamHealthMonitor: Detect gaps >5s
- VMHealthMonitor: Detect freeze >30s
- RecoveryService: Exponential backoff, Chrome restart

#### ACT-001: Signal-to-Action Pipeline
**Purpose**: Connect MongoDB signals to actions  
**Flow**: MongoDB → FourEyes → Synergy → VM Action

---

## IMPLEMENTATION SEQUENCE

### Phase 1: Foundation (Week 1)
**Parallel Tracks**:

**Track A: VM Setup** (2 days)
```
Day 1: Create VM (4C/8GB), install Windows, Chrome, OBS
Day 2: Configure OBS streaming (RTMP to host:1935), test stream
```

**Track B: Host Infrastructure** (3 days)
```
Day 1-2: Implement RTMP receiver (FOUR-005)
Day 2-3: Implement Synergy client (FOUR-004)
```

**Track C: Vision System** (4 days)
```
Day 1-2: Implement W4TCHD0G OCR (FOUR-006)
Day 3: Button detection, state classification
Day 4: Integration testing
```

### Phase 2: Integration (Week 2)
```
Day 1: Connect RTMP receiver to W4TCHD0G
Day 2: Implement async action controller
Day 3: Add timestamp correlation
Day 4: Health monitoring and recovery
Day 5: End-to-end testing
```

### Phase 3: Validation (Week 3)
```
Day 1-2: GT 710 benchmark (TECH-003)
Day 3: 24-hour stress test
Day 4: Oracle validation tests
Day 5: Documentation and deployment
```

---

## TESTING CHECKLIST

### Unit Tests
- [ ] RTMP receiver frame decoding
- [ ] Synergy protocol message encoding
- [ ] OCR accuracy (95% target)
- [ ] Button detection precision
- [ ] State classification accuracy
- [ ] Reconnection backoff timing

### Integration Tests
- [ ] VM stream → Host receiver latency <300ms
- [ ] FourEyes → Synergy → VM action <2s
- [ ] Signal → Action → Confirmation pipeline
- [ ] OBS disconnect → auto-reconnect
- [ ] Frame timestamp correlation

### Stress Tests
- [ ] 24-hour continuous operation
- [ ] 1000+ consecutive actions
- [ ] Network interruption recovery
- [ ] VM resource exhaustion handling
- [ ] Multi-casino concurrent operation

### Oracle Validation
- [ ] RTMP latency <300ms average
- [ ] Frame drop rate <1%
- [ ] Synergy response <2s p95
- [ ] OBS stability <5 disconnects/24hrs
- [ ] Vision inference <500ms p95
- [ ] Recovery time <30s

---

## PERFORMANCE TARGETS

| Metric | Target | Measurement |
|--------|--------|-------------|
| Stream Latency | <300ms | Frame capture to analysis |
| Action Latency | <2s | Click sent to confirmation |
| Frame Drop Rate | <1% | Lost frames per 1000 |
| OCR Accuracy | 95%+ | Correct jackpot readings |
| Recovery Time | <30s | Auto-recovery from failure |
| CPU Usage (Host) | <50% | Ryzen 9 3900X headroom |
| VM RAM Usage | <6GB | 8GB allocated - 2GB headroom |

---

## HARDWARE REQUIREMENTS

### Host (Physical)
- CPU: AMD Ryzen 9 3900X (12C/24T)
- RAM: 128GB DDR4-3200
- GPU: GT 710 (2GB) - for display only
- Storage: 500GB NVMe SSD
- OS: Windows 10/11

### VM (Virtual)
- CPU: 4 cores (dedicated)
- RAM: 8GB
- Storage: 60GB dynamic VHDX
- OS: Windows 10 Pro (stripped)
- Network: Bridged adapter

---

## DEPENDENCIES

### NuGet Packages
```xml
<!-- FFmpeg wrapper -->
<PackageReference Include="FFmpeg.NET" Version="1.0.0" />

<!-- OCR -->
<PackageReference Include="Tesseract" Version="4.1.1" />

<!-- Image processing -->
<PackageReference Include="SixLabors.ImageSharp" Version="3.0.0" />

<!-- WebSocket client -->
<PackageReference Include="System.Net.WebSockets.Client" Version="4.3.2" />

<!-- Logging -->
<PackageReference Include="Microsoft.Extensions.Logging" Version="8.0.0" />
```

### External Tools
- FFmpeg (bundled or system)
- OBS Studio 29+
- Synergy 1.14+
- LM Studio 0.4+

---

## RISK MITIGATION

| Risk | Mitigation | Owner |
|------|-----------|-------|
| GT 710 insufficient | Fallback to 960x540 resolution | TECH-003 |
| VM RAM exhaustion | Monitor and alert at 6GB | VM-002 |
| Stream drops | Auto-reconnect with backoff | FOUR-007 |
| Vision accuracy low | Tesseract training data update | FOUR-006 |
| Synergy disconnect | PSExec fallback | FOUR-004 |
| Action timeout | Async confirmation with 2s timeout | FOUR-001 |

---

## DOCUMENTATION

Created for Fixer:
- FOUR-001 through FOUR-008: Detailed decision specs
- VM-002: VM configuration
- TECH-003: Hardware benchmarks
- DESIGNER_BUILD_GUIDE.md: 5-phase build plan
- ORACLE_PLAN_APPROVAL_SNOOP.md: 92% original approval

---

## APPROVAL STATUS

**Oracle Reassessment**: 87% approval (conditional)

**Conditions Met**:
✅ All 6 original blockers addressed with decisions
✅ Detailed implementation specifications
✅ Performance targets defined
✅ Testing criteria established

**Conditions for 95%+ Approval**:
- Complete implementation of FOUR-004 through FOUR-008
- Pass all Oracle validation tests
- 24-hour stress test with no failures

---

**Ready for Fixer Implementation**: YES

**Start With**: FOUR-005 (RTMP Receiver), FOUR-004 (Synergy), VM-002 (VM Setup)

**Estimated Duration**: 3 weeks (1 person) or 1.5 weeks (2 people parallel)
