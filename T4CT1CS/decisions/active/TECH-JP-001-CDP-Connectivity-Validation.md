# TECH-JP-001: CDP Connectivity Validation

**Decision ID**: TECH-JP-001  
**Category**: Technical Implementation  
**Status**: Proposed  
**Priority**: Critical  
**Date**: 2026-02-20  

---

## Executive Summary

Validate that the CDP bridge between VM H4ND and Host Chrome is functional before enabling autonomous jackpot processing. This is a pre-flight check that confirms the entire CDP infrastructure is operational.

**Current State**:
- CDP client code deployed in H4ND
- Chrome launch scripts deployed on host
- Network configuration deployed

**Target State**:
- Automated connectivity test passes
- Latency < 100ms for CDP commands
- Automatic failover to fallback mode if connection fails

---

## Validation Tests

### Test 1: Host Chrome Accessibility

From VM, verify Chrome CDP port is reachable:

```powershell
$response = Invoke-WebRequest "http://192.168.56.1:9222/json/version" -TimeoutSec 5
if ($response.StatusCode -eq 200) { Write-Host "Chrome accessible" }
```

### Test 2: CDP Protocol Handshake

From VM, verify WebSocket connection to Chrome:

```csharp
var cdp = new CdpClient(config);
bool connected = await cdp.ConnectAsync();
if (!connected) throw new Exception("CDP handshake failed");
```

### Test 3: Round-Trip Latency

Measure time for a simple CDP command:

```csharp
var sw = Stopwatch.StartNew();
await cdp.EvaluateAsync("1+1");
sw.Stop();
if (sw.ElapsedMilliseconds > 100) throw new Exception("CDP latency too high");
```

### Test 4: Login Flow Simulation

Test full login sequence without executing spins:

```csharp
await cdp.LoginFireKirinAsync(testCredential);
// Verify login succeeded via DOM
bool loggedIn = await cdp.EvaluateAsync<bool>(
    "document.querySelector('.user-info, .balance-display') !== null");
```

---

## Implementation

### Phase 1: Manual Validation

1. Run `Start-Chrome-CDP.ps1` on host
2. Run `Validate-CDPConnectivity.ps1` from VM
3. Verify all 4 tests pass

### Phase 2: Automated Validation

Create `H4ND/Infrastructure/CdpHealthCheck.cs`:

```csharp
public sealed class CdpHealthCheck
{
    public async Task<CdpHealthStatus> CheckHealthAsync()
    {
        var status = new CdpHealthStatus();
        
        // Test 1: HTTP accessibility
        status.HttpReachable = await TestHttpAccessAsync();
        
        // Test 2: WebSocket handshake
        status.WebSocketConnected = await TestWebSocketAsync();
        
        // Test 3: Latency
        status.LatencyMs = await MeasureLatencyAsync();
        
        // Test 4: Login simulation
        status.LoginWorks = await TestLoginFlowAsync();
        
        status.IsHealthy = status.HttpReachable 
            && status.WebSocketConnected 
            && status.LatencyMs < 100;
        
        return status;
    }
}
```

### Phase 3: Integration with H4ND Startup

In H4ND.cs, add health check before entering main loop:

```csharp
var healthCheck = new CdpHealthCheck();
var status = await healthCheck.CheckHealthAsync();

if (!status.IsHealthy)
{
    Console.WriteLine($"[H4ND] CDP unhealthy: {status.ErrorMessage}");
    // Fall back to Selenium or halt
}
```

---

## Success Criteria

- [ ] Manual validation passes all 4 tests
- [ ] Automated health check returns healthy status
- [ ] H4ND startup includes health check
- [ ] Fallback mode works if CDP unavailable

---

## Risks

| Risk | Mitigation |
|------|------------|
| Firewall blocks CDP port | Ensure firewall rule created by OpenFixer script |
| Chrome not running | Launch script must run before H4ND |
| Network change | Use hostname instead of IP, or config-driven |

---

*TECH-JP-001: CDP Connectivity Validation*  
*Status: Proposed*  
*2026-02-20*
