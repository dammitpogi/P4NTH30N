# WindFixer Deployment Report — DECISION_056

**Date**: 2026-02-21  
**Decision**: AUTO-056 — Automatic Chrome CDP Lifecycle Management  
**Status**: IMPLEMENTED  
**Build**: 0 errors  
**Tests**: 220/220 passed (14 new CDP lifecycle tests)

---

## Files Created (3)

1. **H4ND/Services/CdpLifecycleConfig.cs** (~55 lines)
   - `CdpLifecycleConfig` — config POCO bound from appsettings.json
   - `CdpLifecycleStatus` enum — Healthy/Unhealthy/Starting/Stopped/Error
   - `ICdpLifecycleManager` interface — IsAvailable, EnsureAvailable, Start, Stop, Restart

2. **H4ND/Services/CdpLifecycleManager.cs** (~310 lines)
   - `IsAvailableAsync()` — HTTP probe to /json/version, 5s timeout
   - `EnsureAvailableAsync()` — Check → auto-start → wait with timeout
   - `StartChromeAsync()` — Process.Start with debugging flags, Exited event handler
   - `StopChromeAsync()` — CloseMainWindow → wait 10s → force Kill
   - `RestartChromeAsync()` — Stop then start
   - `OnChromeExited()` — Auto-restart with exponential backoff (5s, 10s, 30s), max 3 attempts
   - Health monitoring timer (30s interval)
   - Graceful Dispose with Chrome cleanup

3. **UNI7T35T/Tests/CdpLifecycleManagerTests.cs** (~200 lines)
   - 14 tests: config defaults, chrome path, restart backoff, additional args, enum values,
     initial status, unavailable CDP, auto-start disabled, chrome not found, invalid path,
     idempotent dispose, headless config, headed config, probe host localhost

## Files Modified (5)

1. **appsettings.json** — Added `CdpLifecycle` section with all config properties
2. **H4ND/Services/BurnInController.cs** — Added `ICdpLifecycleManager?` dependency, calls `EnsureAvailableAsync` before CDP health check in pre-flight
3. **H4ND/Parallel/ParallelH4NDEngine.cs** — Added `ICdpLifecycleManager?` dependency, calls `EnsureAvailableAsync` before starting worker pool
4. **H4ND/EntryPoint/UnifiedEntryPoint.cs** — Creates `CdpLifecycleManager` in RunBurnIn/RunParallel, passes to controllers, adds ProcessExit shutdown handler
5. **H4ND/H4ND.cs** — Creates `CdpLifecycleManager` before CDP pre-flight, auto-starts Chrome for all modes (sequential, firstspin), adds ProcessExit handler
6. **UNI7T35T/Program.cs** — Wired CdpLifecycleManagerTests into test runner
7. **STR4TEG15T/decisions/active/DECISION_056.md** — Status → Implemented

## Success Criteria

- ✅ Burn-in starts Chrome automatically (EnsureAvailableAsync in BurnInController pre-flight)
- ✅ Chrome runs with --remote-debugging-port=9222 --remote-debugging-address=0.0.0.0
- ✅ Burn-in proceeds after Chrome available (WaitForCdpAsync with 30s timeout)
- ✅ Chrome closes when H4ND exits (ProcessExit handler + Dispose)
- ✅ Auto-restart works if Chrome killed during burn-in (Exited event + backoff)
- ✅ 220/220 tests passing (14 new)
- ✅ Build: 0 errors
- ✅ Backward compatible: AutoStart=false preserves existing behavior

## Integration Test Flow

```
P4NTHE0N.exe burn-in
  → UnifiedEntryPoint.RunBurnIn()
    → CdpLifecycleManager created from appsettings.json
    → BurnInController receives ICdpLifecycleManager
    → RunPreflightChecksAsync()
      → cdpLifecycle.EnsureAvailableAsync()
        → IsAvailableAsync() → false (Chrome not running)
        → File.Exists(ChromePath) → true
        → StartChromeAsync() → Process.Start with debugging flags
        → WaitForCdpAsync(30s) → polls /json/version → true
      → CdpHealthCheck.CheckHealthAsync() → Healthy
    → Pre-flight: PASS
    → Parallel engine starts with 5 workers
    → Chrome crash → OnChromeExited → auto-restart in 5s
    → Ctrl+C → CancellationToken → cdpLifecycle.Dispose() → Chrome stopped
```

## Architecture

- CdpLifecycleManager is injected into BurnInController and ParallelH4NDEngine as optional dependency
- All existing callers continue to work (backward compatible with null lifecycle manager)
- Chrome process managed via System.Diagnostics.Process with EnableRaisingEvents
- Health monitoring via System.Threading.Timer (non-blocking)
- Probe host automatically resolves 0.0.0.0 → 127.0.0.1 for local health checks
- User-data-dir isolated per port to avoid conflicts with existing Chrome instances

---

*The final piece is built. The burn-in can now run without human hands.*
