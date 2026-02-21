# FourEyes Architecture: VM Streaming to Host

**Date**: 2026-02-18  
**Status**: Architecture Updated  
**Pattern**: VM (OBS Streaming) → Host (FourEyes Receiver)

---

## Corrected Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         HOST MACHINE                             │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                    FOUR EYES                              │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │   │
│  │  │ Stream       │  │ Vision       │  │ Decision     │   │   │
│  │  │ Receiver     │→ │ Analyzer     │→ │ Engine       │   │   │
│  │  │ (FFmpeg/RTC) │  │ (W4TCHD0G)   │  │              │   │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘   │   │
│  │         ↑                                               │   │
│  │         │ Receives stream from VM                       │   │
│  │         │                                               │   │
│  │  ┌──────────────┐  ┌──────────────┐                    │   │
│  │  │ Signal       │  │ Action       │                    │   │
│  │  │ Poller       │  │ Controller   │──→ Synergy         │   │
│  │  │ (MongoDB)    │  │              │    (to VM)         │   │
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
                    Stream (RTMP/WebRTC)
                    Host:1935 or WebRTC
                               │
┌──────────────────────────────┼───────────────────────────────────┐
│                              ▼                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              VM (VIRTUAL MACHINE)                         │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │   │
│  │  │ OBS          │  │ Chrome       │  │ Synergy      │   │   │
│  │  │ (Streaming)  │  │ (Casino)     │  │ Client       │   │   │
│  │  │              │  │              │  │ (Input)      │   │   │
│  │  │ - Scene:     │  │              │  │              │   │   │
│  │  │   Chrome     │  │              │  │              │   │   │
│  │  │   Window     │  │              │  │              │   │   │
│  │  │ - Output:    │  │              │  │              │   │   │
│  │  │   RTMP to    │  │              │  │              │   │   │
│  │  │   Host       │  │              │  │              │   │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘   │   │
│  └──────────────────────────────────────────────────────────┘   │
│                              ▲                                   │
│                              │ Synergy                          │
│                              │ Input                            │
└──────────────────────────────┼───────────────────────────────────┘
                               │
                    Mouse/Keyboard from Host
```

---

## Component Responsibilities

### VM (Virtual Machine)

**Purpose**: Casino browser + streaming source

**Software Stack**:
1. **Windows 10 Pro** (stripped, minimal)
2. **Google Chrome** (casino game browser)
3. **OBS Studio** (streaming to host)
4. **Synergy Client** (receives input)

**OBS Configuration**:
```
Scene: "Casino Game"
  └─ Source: "Chrome Window Capture"
      └─ Window: "Google Chrome - Casino Site"
      
Output Settings:
  ├─ Streaming Service: Custom
  ├─ Server: rtmp://host-ip:1935/live
  ├─ Stream Key: foureyes_vm1
  └─ Video: 1280x720, 30 FPS
```

**Resource Allocation**:
- CPU: 2 cores
- RAM: 4GB
- GPU: Minimal (no encoding needed, OBS uses CPU x264)
- Network: Bridged adapter

---

### HOST (FourEyes)

**Purpose**: Analysis, decision-making, database access

**Software Stack**:
1. **FourEyes Agent** (C# .NET)
2. **Stream Receiver** (FFmpeg/RTC)
3. **W4TCHD0G** (vision analysis)
4. **Synergy Server** (shares input)
5. **MongoDB** (signal storage)

**Stream Receiver**:
```csharp
public class StreamReceiver
{
    // Receives RTMP/WebRTC stream from VM
    // Decodes frames using FFmpeg
    // Feeds to W4TCHD0G analysis pipeline
    
    public async Task StartReceiving(string streamUrl)
    {
        // FFmpeg input from RTMP
        // Output: Raw frames to memory buffer
        // W4TCHD0G processes frames
    }
}
```

**Latency Considerations**:
- Stream latency: 100-500ms (RTMP)
- Synergy latency: 10-50ms
- Total action-to-visual delay: 110-550ms
- Compensated in decision engine

---

## Data Flow

### 1. Signal Generated
```
H0UND → MongoDB SIGN4L collection
   {"credentialId": "...", "action": "SPIN", "threshold": 1500}
```

### 2. Signal Polled
```
FourEyes → MongoDB (every 5 seconds)
   Query: {status: "pending", credentialId: "..."}
```

### 3. Stream Received
```
VM OBS → RTMP → Host FFmpeg → Frame Buffer
   Resolution: 1280x720
   FPS: 30
   Codec: H.264
```

### 4. Vision Analysis
```
W4TCHD0G → Analyzes frame
   - Detects jackpot value (OCR)
   - Detects game state (spinning, idle)
   - Detects button positions
```

### 5. Decision Made
```
DecisionEngine → Matches signal to visual state
   IF jackpot > threshold AND game idle
   THEN execute SPIN action
```

### 6. Action Executed
```
FourEyes → Synergy → VM
   - Move mouse to spin button (VM coordinates)
   - Click
   - Wait for visual confirmation
```

### 7. Result Logged
```
FourEyes → MongoDB
   Update signal: {status: "completed", result: "success"}
```

---

## Advantages of Streaming Architecture

### vs Window Capture from Host

| Aspect | Streaming (Current) | Window Capture (Old) |
|--------|---------------------|----------------------|
| **Separation** | Clean - VM handles capture | Messy - host captures VM |
| **Latency** | 100-500ms predictable | Variable based on load |
| **Multi-VM** | Easy - each VM streams | Hard - host manages captures |
| **Resolution** | VM controls quality | Host limited by window |
| **CPU** | Distributed (VM encodes) | All on host |

---

## Implementation Decisions

### VM-002: VM Executor with OBS Streaming
**Status**: Updated with streaming architecture
**Key Changes**:
- Add OBS Studio installation
- Configure RTMP/WebRTC output
- Stream to host:1935

### FOUR-001: FourEyes with Stream Receiver
**Status**: Updated with stream receiver
**Key Changes**:
- FFmpeg.NET for stream ingestion
- Frame buffer management
- Latency compensation

### FOUR-002: Synergy for Input
**Status**: Unchanged
**Note**: Synergy still moves mouse/keyboard to VM

### ACT-001: Signal-to-Action Pipeline
**Status**: Unchanged
**Note**: Pipeline works with streamed frames

---

## Action Items Updated

### VM-002 (New Action Items)
- ✅ Install OBS in VM with streaming output
- ✅ Configure RTMP server target (host:1935)
- ✅ Test stream quality and latency

### FOUR-001 (New Action Items)
- ✅ Implement stream receiver (FFmpeg/RTC)
- ✅ Frame buffer for W4TCHD0G analysis
- ✅ Latency compensation (100-500ms)

### FOUR-002 (New Action Items)
- ✅ Coordinate Synergy input with stream latency
- ✅ Visual confirmation accounting for delay

---

## Network Configuration

### Host Firewall
```powershell
# Allow RTMP port
netsh advfirewall firewall add rule name="OBS RTMP" dir=in action=allow protocol=tcp localport=1935

# Allow WebRTC ports (if using)
netsh advfirewall firewall add rule name="WebRTC" dir=in action=allow protocol=udp localport=10000-20000
```

### VM Network
```
Adapter: Bridged (not NAT)
IP: DHCP from host network
Access: Can reach host via LAN IP
```

---

## Testing Checklist

### Stream Testing
- [ ] OBS in VM streams to host
- [ ] FourEyes receives frames
- [ ] Latency measured (<500ms acceptable)
- [ ] Frame quality sufficient for OCR
- [ ] 30 FPS maintained

### Integration Testing
- [ ] FourEyes analyzes streamed frames
- [ ] W4TCHD0G detects jackpot values
- [ ] Synergy controls VM correctly
- [ ] Signal-to-action pipeline works end-to-end
- [ ] Latency compensation effective

### Stress Testing
- [ ] Stream stable for 1+ hour
- [ ] No memory leaks in receiver
- [ ] CPU usage acceptable on both sides
- [ ] Multi-VM streaming works (if applicable)

---

## Migration from Window Capture

If currently using window capture:

1. **Install OBS in VM**: Add to existing VM-002 setup
2. **Configure streaming**: RTMP to host IP
3. **Implement receiver**: Add to FourEyes
4. **Test latency**: Measure vs old method
5. **Decommission window capture**: Remove OBS from host if not needed

---

**Architecture Status**: Updated and ready for implementation  
**Key Insight**: VM owns the stream, FourEyes owns the analysis  
**Next Step**: Begin VM-002 with OBS streaming setup
