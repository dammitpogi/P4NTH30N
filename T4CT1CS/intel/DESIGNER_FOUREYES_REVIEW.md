# Designer Architectural Review: FourEyes Streaming System

**Date**: 2026-02-18  
**Reviewer**: Designer  
**Architecture**: FourEyes VM Streaming Automation  
**Status**: Conditional Approval (72%) - Critical gaps identified

---

## Executive Summary

The FourEyes streaming architecture is technically sound but has three critical gaps that must be addressed before implementation: frame sampling strategy, latency compensation model, and failure recovery. The RTMP protocol choice is appropriate for the use case, but encoding load on the 2C VM is a concern.

---

## Detailed Assessment

### 1. Streaming Protocol: APPROVED with Recommendation

**RTMP vs WebRTC vs SRT Analysis**:

| Protocol | Latency | Complexity | Reliability | Recommendation |
|----------|---------|-----------|-------------|----------------|
| **RTMP** | 1-3s | Low | High | ✓ ACCEPTABLE |
| **WebRTC** | <100ms | High | Medium | Overkill |
| **SRT** | 100-500ms | Medium | High | Alternative |

**Designer's Verdict**: RTMP is the right choice for casino automation.

**Rationale**:
- Casino games don't require <100ms latency (unlike FPS gaming)
- 1-3 second delay is acceptable for jackpot detection and spin execution
- RTMP is mature, stable, and well-supported in OBS/FFmpeg
- WebRTC adds unnecessary complexity for this use case

**Recommendation**: Stick with RTMP on port 1935.

---

### 2. VM Encoding Load: CRITICAL GAP ⚠️

**Problem**: 2C/4GB VM with OBS x264 encoding will likely choke.

**Analysis**:
```
VM Resources:
- 2 CPU cores
- 4 GB RAM
- Chrome (casino browser): ~500MB RAM, 10-20% CPU
- OBS x264 encoding: ~1-2 CPU cores, 1-2GB RAM
- Windows overhead: ~1GB RAM

Total: Marginal at best, likely overloaded
```

**Critical Issue**: x264 encoding at 720p30 requires significant CPU. With only 2 cores shared between Chrome, OBS, and Windows, the VM will struggle.

**Recommended Solutions** (in order of preference):

**Option A: Increase VM Resources** (Recommended)
```
Change: 2C/4GB → 4C/8GB
Rationale: Gives OBS dedicated cores for encoding
Impact: Host still has 8C/120GB available
Trade-off: More host resources used
```

**Option B: Reduce Stream Quality**
```
Change: 720p30 → 720p15 or 480p30
Rationale: Reduces encoding load
Impact: Lower visual quality for OCR
Trade-off: May reduce jackpot detection accuracy
```

**Option C: Use Hardware Encoding** (If GPU available)
```
Change: x264 → NVENC/QuickSync
Rationale: Offloads encoding to GPU
Impact: Minimal CPU usage
Requirement: VM must have GPU passthrough (complex)
```

**Designer's Recommendation**: **Option A - Increase VM to 4C/8GB**

Rationale: Your host has abundant resources (12C/128GB). Using 4C/8GB for VM still leaves 8C/120GB for FourEyes, MongoDB, and LM Studio - more than sufficient.

---

### 3. Frame Sampling Strategy: CRITICAL GAP ⚠️

**Problem**: Analyzing 30 FPS is wasteful; analyzing too few risks missing state changes.

**Analysis**:
```
Casino Game State Changes:
- Jackpot updates: Every 5-30 seconds
- Game state (idle/spinning): Changes every 3-10 seconds  
- Button availability: Changes with game state

Required Analysis Rate: 2-5 FPS sufficient
Incoming Stream Rate: 30 FPS
Overhead: 6-15x wasted analysis
```

**Recommended Strategy**: Adaptive Frame Sampling

```csharp
public class AdaptiveFrameSampler
{
    private GameState _lastState = GameState.Unknown;
    private DateTime _lastAnalysis = DateTime.MinValue;
    
    public bool ShouldAnalyzeFrame(VisionFrame frame)
    {
        // Always analyze if enough time passed (5 FPS max)
        if (DateTime.UtcNow - _lastAnalysis < TimeSpan.FromMilliseconds(200))
            return false;
            
        // Analyze immediately if state might have changed
        // (detected motion, button area changed, etc.)
        if (DetectPotentialStateChange(frame))
            return true;
            
        // Otherwise, sample every 5th frame (6 FPS)
        return frame.FrameNumber % 5 == 0;
    }
}
```

**Designer's Recommendation**: Implement adaptive sampling targeting 2-5 FPS actual analysis.

---

### 4. Latency Compensation: CRITICAL GAP ⚠️

**Problem**: 100-500ms visual confirmation delay breaks synchronous action models.

**Current Model** (Problematic):
```
1. FourEyes decides to click "spin"
2. Synergy sends click to VM
3. FourEyes immediately checks visual confirmation
4. PROBLEM: Stream hasn't updated yet (100-500ms delay)
5. FourEyes thinks action failed
```

**Recommended Model**: Asynchronous Confirmation with Timeout

```csharp
public class AsyncActionController
{
    private Dictionary<string, PendingAction> _pendingActions = new();
    
    public async Task ExecuteActionAsync(CasinoAction action)
    {
        // 1. Send action
        SendViaSynergy(action);
        
        // 2. Record pending with expected visual change
        var pending = new PendingAction
        {
            Action = action,
            ExpectedChange = PredictVisualChange(action),
            SentAt = DateTime.UtcNow,
            Timeout = TimeSpan.FromSeconds(2) // 2x max latency
        };
        _pendingActions[action.Id] = pending;
        
        // 3. Don't block - let async confirmation handle it
    }
    
    public void OnFrameAnalyzed(VisionFrame frame)
    {
        // Check if any pending action now shows expected change
        foreach (var pending in _pendingActions.Values)
        {
            if (pending.IsExpired) 
            {
                HandleTimeout(pending);
                continue;
            }
            
            if (VerifyVisualChange(frame, pending.ExpectedChange))
            {
                HandleSuccess(pending);
                _pendingActions.Remove(pending.Action.Id);
            }
        }
    }
}
```

**Key Insight**: Don't wait for confirmation; expect it asynchronously within timeout window.

---

### 5. Multi-VM Scaling: APPROVED with Pattern

**Scaling Pattern Recommendation**: One Stream Per VM, Separate Ports

```
VM1: Chrome + OBS → RTMP rtmp://host:1935/vm1
VM2: Chrome + OBS → RTMP rtmp://host:1936/vm2
VM3: Chrome + OBS → RTMP rtmp://host:1937/vm3

Host: FourEyes instances (one per VM) OR multiplexed receiver
```

**Two Approaches**:

**A. Separate FourEyes Instances** (Recommended for MVP)
```
FourEyes-VM1: Receives port 1935, handles VM1
FourEyes-VM2: Receives port 1936, handles VM2
Database: Shared MongoDB (different credential IDs)
```

**B. Multiplexed FourEyes** (Post-MVP optimization)
```
StreamMultiplexer: Listens on 1935-1940
FrameRouter: Routes frames to appropriate analyzer
Single FourEyes with multiple virtual agents
```

**Designer's Recommendation**: Start with separate FourEyes instances (simpler, isolated failures).

---

### 6. Failure Modes: HIGH PRIORITY GAPS ⚠️

**Identified Failure Scenarios Not Addressed**:

#### A. Stream Drop (Network/VM Crash)
```csharp
// Detection: No frames received for >5 seconds
// Recovery:
1. Alert operator (don't auto-restart, might be mid-game)
2. Pause signal processing for this VM
3. Attempt reconnection (exponential backoff)
4. On reconnect: Sync state (might have missed actions)
```

#### B. VM Freeze (Chrome Hang)
```csharp
// Detection: Stream active but visual unchanged for >30 seconds
// Recovery:
1. Attempt graceful Chrome restart via Synergy
2. If unresponsive: VM hard reboot (requires hypervisor API)
3. Restore from last known good state
```

#### C. Synergy Disconnect
```csharp
// Detection: Cannot send input (connection lost)
// Recovery:
1. Attempt Synergy reconnection
2. Fallback to PSExec (remote PowerShell) for critical recovery
3. If both fail: VM requires manual intervention
```

#### D. Vision/Signal Mismatch
```csharp
// Detection: Signal says "spin" but vision shows "already spinning"
// Recovery:
1. Log mismatch for analysis
2. Skip action (don't spin twice)
3. Mark signal as "skipped - state mismatch"
4. Alert if mismatch rate >10% (indicates bug)
```

**Designer's Recommendation**: Implement health monitoring with graceful degradation, not hard failures.

---

### 7. Alternative Architectures: CONSIDERED

**Option A: Current (Streaming)** ✓ APPROVED
- Pros: Clean separation, stable, proven
- Cons: Latency, encoding overhead

**Option B: VNC/RDP** ✗ NOT RECOMMENDED
- Pros: Lower latency, built-in input
- Cons: Heavy resource usage, interactive session required, security issues

**Option C: Direct GPU Passthrough** ✗ TOO COMPLEX
- Pros: VM has real GPU, fast encoding
- Cons: Hardware complexity, limited portability

**Option D: Container Instead of VM** ⚠️ PARTIAL
- Pros: Lighter weight, faster startup
- Cons: No Windows GUI for Chrome (unless using Windows containers - complex)

**Designer's Verdict**: Current streaming architecture is optimal for this use case.

---

## Critical Gaps Summary

| Gap | Severity | Impact | Mitigation |
|-----|----------|--------|------------|
| **VM Encoding Load** | Critical | VM will be unresponsive | Increase to 4C/8GB |
| **Frame Sampling** | Critical | Wasted CPU or missed states | Adaptive sampling (2-5 FPS) |
| **Latency Compensation** | Critical | False failure detection | Async confirmation pattern |
| **Failure Recovery** | High | Manual intervention required | Health monitoring + auto-retry |

---

## Revised Recommendations

### Immediate (Before Implementation)
1. ✅ **Increase VM resources**: 2C/4GB → 4C/8GB
2. ✅ **Implement adaptive frame sampling**: Target 2-5 FPS analysis
3. ✅ **Design async confirmation**: Don't block on visual confirmation
4. ✅ **Add health monitoring**: Detect and recover from failures

### Architecture Additions Needed
1. **NEW DECISION**: Failure Recovery and Health Monitoring System
2. **UPDATE VM-002**: Resource allocation (4C/8GB)
3. **UPDATE FOUR-001**: Async action controller pattern
4. **NEW COMPONENT**: AdaptiveFrameSampler in W4TCHD0G

### Post-MVP Optimizations
1. Multiplexed stream receiver for multi-VM
2. Hardware encoding (if GPU passthrough available)
3. Machine learning for state change prediction (reduce analysis rate further)

---

## Approval Status

**Conditional Approval: 72%**

**Conditions for Full Approval**:
- [ ] VM resources increased to 4C/8GB
- [ ] Frame sampling strategy documented
- [ ] Async confirmation pattern implemented
- [ ] Failure recovery system designed

**Risk Assessment**: Medium - The architecture works but the gaps could cause production issues if not addressed.

---

## Designer Final Notes

The FourEyes architecture is solid for the use case. The streaming approach is appropriate, RTMP is the right protocol choice, and the separation of concerns (VM = executor, Host = controller) is clean.

The three critical gaps (encoding load, sampling strategy, latency compensation) are all solvable with the recommendations provided. The failure mode handling is the most important addition needed before production deployment.

**Bottom Line**: Approve with conditions. Address the gaps and this will be a robust automation system.

---

**Next Steps**:
1. Update VM-002 with 4C/8GB specification
2. Add adaptive frame sampling to FOUR-001
3. Create new decision for failure recovery system
4. Re-submit for final approval
