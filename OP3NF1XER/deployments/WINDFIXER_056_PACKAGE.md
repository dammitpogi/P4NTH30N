WINDFIXER DEPLOYMENT PACKAGE - DECISION_056
=============================================

MISSION: Automatic Chrome CDP Lifecycle Management
STATUS: Critical Priority - Blocks 24-hour burn-in
DECISION: c:\P4NTH30N\STR4TEG15T\decisions\active\DECISION_056.md

CONTEXT SYNTHESIS
-----------------
The burn-in failed because Chrome CDP was not running. Manual Chrome startup is the last human bottleneck preventing true autonomous operation. You are building the final piece that enables 24-hour unattended burn-in.

WHAT WAS BUILT BEFORE YOU:
- DECISION_047: Parallel H4ND with 5 workers, atomic signal claiming, shadow validated
- DECISION_041: SessionRenewalService with 403/401 auto-recovery, 12 tests passing
- DECISION_046: GameSelectorConfig with fallback chains for jackpot selectors
- DECISION_055: Unified Game Execution Engine by Opus - 206/206 tests, 7 subcommands
  * SignalGenerator populates SIGN4L from 310 credentials
  * SessionRenewalService wired into ParallelSpinWorker
  * GameSelectorConfig injected into workers
  * BurnInController ready for 24-hour validation

THE FAILURE:
Running: P4NTH30N.exe burn-in
Error: "No connection could be made because the target machine actively refused it. (192.168.56.1:9222)"
Result: Burn-in halted before starting

YOUR SOLUTION:
CdpLifecycleManager that auto-starts Chrome, monitors health, restarts on crash, graceful shutdown.

FILES YOU MUST READ FIRST
-------------------------
1. DECISION_056.md - Complete specification (c:\P4NTH30N\STR4TEG15T\decisions\active\DECISION_056.md)
2. BurnInController.cs - Where you integrate EnsureAvailableAsync (c:\P4NTH30N\H4ND\Services\BurnInController.cs)
3. ParallelH4NDEngine.cs - Where you integrate EnsureAvailableAsync (c:\P4NTH30N\H4ND\Parallel\ParallelH4NDEngine.cs)
4. appsettings.json - Where you add CdpLifecycle config (c:\P4NTH30N\H4ND\appsettings.json)
5. H4ND.cs Program.Main - Where you add shutdown handler (c:\P4NTH30N\H4ND\H4ND.cs)

CRITICAL IMPLEMENTATION DETAILS
--------------------------------

Chrome Startup Arguments:
--remote-debugging-port=9222
--remote-debugging-address=0.0.0.0
--headless (configurable)
--no-sandbox
--disable-gpu

CDP Health Check:
HTTP GET to http://{host}:{port}/json/version
Success = returns JSON with "Browser" field
Timeout = 5 seconds

Auto-Restart Backoff:
Attempt 1: 5 seconds
Attempt 2: 10 seconds
Attempt 3: 30 seconds
Max attempts: 3

Graceful Shutdown:
1. Send Process.CloseMainWindow() or Process.Kill()
2. Wait up to 10 seconds
3. Check Process.HasExited
4. Force kill if still running
5. Log cleanup actions

EXISTING CODE PATTERNS TO FOLLOW
---------------------------------

From DECISION_055 implementation (Opus style):
- Use async/await throughout
- Inject ILogger<T> for logging
- Use CancellationToken for cancellation
- Return Task<bool> for success/failure
- Throw only on unrecoverable errors

From SessionRenewalService (DECISION_041):
- Exponential backoff pattern
- Max retry attempts
- Clear error messages
- Platform probing logic

From ParallelH4NDEngine (DECISION_047):
- Pre-flight check pattern
- Dependency injection
- Graceful shutdown with CancellationToken

CONFIGURATION SCHEMA
--------------------
{
  "P4NTH30N": {
    "H4ND": {
      "CdpLifecycle": {
        "AutoStart": true,
        "ChromePath": "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
        "Headless": false,
        "DebugPort": 9222,
        "DebugHost": "0.0.0.0",
        "StartupTimeoutSeconds": 30,
        "HealthCheckIntervalSeconds": 30,
        "MaxAutoRestarts": 3,
        "RestartBackoffSeconds": [5, 10, 30],
        "GracefulShutdownTimeoutSeconds": 10,
        "AdditionalArgs": ["--no-sandbox", "--disable-gpu"]
      }
    }
  }
}

INTERFACE DEFINITION
--------------------
public interface ICdpLifecycleManager
{
    Task<bool> IsAvailableAsync(CancellationToken ct = default);
    Task<bool> EnsureAvailableAsync(CancellationToken ct = default);
    Task StartChromeAsync(CancellationToken ct = default);
    Task StopChromeAsync(CancellationToken ct = default);
    Task RestartChromeAsync(CancellationToken ct = default);
    CdpHealthStatus GetHealthStatus();
}

public enum CdpHealthStatus
{
    Healthy,
    Unhealthy,
    Starting,
    Stopped,
    Error
}

IMPLEMENTATION PHASES
---------------------

PHASE 1: Configuration + DTOs (1 hour)
- Create CdpLifecycleConfig.cs
- Create CdpHealthStatus.cs
- Update appsettings.json
- TEST: Config binds correctly

PHASE 2: Core Lifecycle Manager (2-3 hours)
- Create CdpLifecycleManager.cs
- Implement IsAvailableAsync() - HTTP probe
- Implement StartChromeAsync() - Process.Start
- Implement StopChromeAsync() - graceful shutdown
- Implement health monitoring - Timer
- Implement auto-restart - Exited event
- TEST: Chrome starts, stops, restarts

PHASE 3: Integration (1-2 hours)
- Modify BurnInController.cs - add EnsureAvailableAsync call
- Modify ParallelH4NDEngine.cs - add EnsureAvailableAsync call
- Modify H4ND.cs - add shutdown handler
- TEST: Build succeeds

PHASE 4: Testing (1 hour)
- Create CdpLifecycleManagerTests.cs
- Test: Chrome not installed → clear error
- Test: Chrome starts with correct args
- Test: Graceful shutdown works
- INTEGRATION TEST: Run burn-in WITHOUT manually starting Chrome

SUCCESS CRITERIA
----------------
✅ Burn-in starts Chrome automatically
✅ Chrome runs with --remote-debugging-port=9222
✅ Burn-in proceeds after Chrome available
✅ Chrome closes when H4ND exits
✅ Auto-restart works if Chrome killed during burn-in
✅ 206+ tests still passing
✅ Build: 0 errors

STOP CONDITIONS
---------------
- Blocked >30 minutes → escalate to Forgewright
- Token budget >45K → report for audit
- Test failures >5 → escalate
- Chrome startup fails after 3 attempts → clear error message, halt

REPORT BACK
-----------
When complete, report:
1. Files created/modified
2. Tests passing count
3. Build error count
4. Integration test result: Does burn-in auto-start Chrome?
5. Token usage estimate

URGENCY
-------
Critical. The 24-hour burn-in is blocked. DECISION_047 cannot complete until this works. The infrastructure phase cannot end until burn-in validates parallel execution.

EXECUTE WITHOUT STOPPING.
The final piece awaits your hands.
