---
agent: Forgewright
type: bugfix
decision: CRIT-103
created: 2026-02-22
status: resolved
tags: [chrome, cdp, lifecycle, infinite-loop, race-condition]
---

# CRITICAL BUG FIX: Infinite Chrome Window Spawning

## Summary
Fixed a critical bug in `CdpLifecycleManager.cs` where H4ND was spawning infinite Chrome windows due to a race condition between `StartChromeAsync()` and `OnChromeExited()`.

## Root Cause
When `StartChromeAsync()` killed Chrome for failing the `IsRenderingAsync()` health check, it did NOT set `_intentionalStop = true`. This caused the `OnChromeExited` event handler to fire and interpret the kill as an unexpected crash, triggering an additional `StartChromeAsync()` call. The result was parallel Chrome spawns that compounded infinitely.

### The Loop
1. `StartChromeAsync` kills unhealthy Chrome (without setting `_intentionalStop = true`)
2. `OnChromeExited` fires (thinks it's a crash)
3. `OnChromeExited` queues another `StartChromeAsync`
4. Both spawn Chrome windows
5. DOM check fails on blank new profiles
6. Loop repeats infinitely

## Fix Applied

### File: `H4ND/Services/CdpLifecycleManager.cs`

#### Change 1: Set `_intentionalStop = true` before killing Chrome
```csharp
// Line ~185
Console.WriteLine("[CdpLifecycle] Chrome renderer UNHEALTHY — killing and restarting");
_intentionalStop = true; // BUGFIX: Prevent OnChromeExited from triggering parallel restart
try
{
    existingProcess.Kill(entireProcessTree: true);
    await existingProcess.WaitForExitAsync(CancellationToken.None);
}
```

#### Change 2: Reset `_intentionalStop = false` after new Chrome starts
```csharp
// Line ~258-262
Console.WriteLine($"[CdpLifecycle] Chrome started (PID {_chromeProcess.Id})");

// BUGFIX: Reset _intentionalStop AFTER new Chrome starts
// This prevents race condition where OnChromeExited fires during startup
_intentionalStop = false;

_chromeProcess.EnableRaisingEvents = true;
```

#### Change 3: Added `_restartInProgress` guard flag
```csharp
// Line ~22
private bool _disposed;
private bool _intentionalStop;
private bool _restartInProgress; // BUGFIX: Prevents parallel restart attempts
private readonly object _lock = new();
```

#### Change 4: Check `_restartInProgress` in `OnChromeExited`
```csharp
private void OnChromeExited(object? sender, EventArgs e)
{
    if (_intentionalStop || _disposed)
        return;

    // BUGFIX: Prevent parallel restart attempts
    lock (_lock)
    {
        if (_restartInProgress)
        {
            Console.WriteLine("[CdpLifecycle] Restart already in progress — skipping duplicate");
            return;
        }
        _restartInProgress = true;
    }
    
    // ... rest of method with proper cleanup in finally block
    finally
    {
        // BUGFIX: Always reset _restartInProgress when restart completes or fails
        _restartInProgress = false;
    }
}
```

## Verification
- [x] Build successful: `dotnet build H4ND/H4ND.csproj` passes with 0 warnings, 0 errors
- [x] Logic verified: `_intentionalStop` is now set before Kill() and reset after new process starts
- [x] Race condition mitigated: `_restartInProgress` flag prevents parallel restarts

## Prevention
This bug class can be prevented by:
1. Always setting `_intentionalStop = true` before programmatically killing Chrome
2. Always resetting `_intentionalStop = false` AFTER the new process is confirmed started
3. Using a `_restartInProgress` guard flag for any fire-and-forget restart logic
4. Ensuring proper cleanup (finally blocks) for all restart flags

## Impact
- **Severity**: Critical - blocked Nexus from using H4ND
- **Scope**: Affected all H4ND operations requiring Chrome CDP
- **Resolution**: Prevents infinite Chrome spawns, ensures single Chrome instance

---
*Fixed by: Stability Forgewright (Forge Ops — Diagnostics & Triage)*
*Date: 2026-02-22*
