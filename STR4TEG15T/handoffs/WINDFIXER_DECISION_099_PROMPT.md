WindFixer, implement DECISION_099: FireKirin Login Smoke Test.

**Context**: We need a pre-burn-in validation gate for DECISION_047. This smoke test validates FireKirin login works BEFORE we commit to 24-hour burn-in.

**Decision File**: `C:\P4NTH30N\STR4TEG15T\decisions\active\DECISION_099.md`

**Your Mission**: Create standalone smoke test executable that validates:
1. Chrome Profile-W0 launches on port 9222
2. FireKirin page loads
3. Login executes via NavigationMap with 6-strategy Canvas typing
4. Balance verification succeeds (> 0)

**Files to Create** (13 total):

```
H4ND/SmokeTest/
├── SmokeTest.csproj              # New project file
├── Program.cs                    # CLI entry with args parsing
├── SmokeTestEngine.cs            # Main orchestrator with circuit breaker
├── SmokeTestResult.cs            # Result data model (Pass/Fail/Fatal)
├── SmokeTestConfig.cs            # Configuration class
├── Phases/
│   ├── ISmokeTestPhase.cs        # Interface: Name, ExecuteAsync
│   ├── BootstrapPhase.cs         # Launch Chrome W0, connect CDP
│   ├── NavigationPhase.cs        # Navigate to FireKirin, wait load
│   ├── LoginPhase.cs             # Execute Login phase from NavigationMap
│   └── VerificationPhase.cs      # Query balance, verify > 0
└── Reporting/
    ├── ISmokeTestReporter.cs     # Interface for output
    ├── ConsoleReporter.cs        # Human-readable progress
    └── JsonReporter.cs           # Machine-readable JSON
```

**Key Implementation Details**:

1. **SmokeTestEngine** - Circuit breaker pattern:
```csharp
public async Task<SmokeTestResult> ExecuteAsync(CancellationToken ct)
{
    var bootstrap = await ExecutePhaseAsync(new BootstrapPhase(...), ct);
    if (!bootstrap.Success) return Halt(bootstrap);
    
    var navigation = await ExecutePhaseAsync(new NavigationPhase(...), ct);
    if (!navigation.Success) return Halt(navigation);
    
    var login = await ExecutePhaseAsync(new LoginPhase(...), ct);
    if (!login.Success) return Halt(login);
    
    var verification = await ExecutePhaseAsync(new VerificationPhase(...), ct);
    if (!verification.Success) return Halt(verification);
    
    return SmokeTestResult.Pass(...);
}
```

2. **BootstrapPhase** - Use ChromeProfileManager:
```csharp
var cdpConfig = await _profileManager.LaunchWithProfileAsync(0, ct); // Worker 0 = Profile-W0
var cdpClient = new CdpClient(cdpConfig);
await cdpClient.ConnectAsync(ct);
// Verify: await CdpGameActions.GetCanvasBoundsAsync(cdpClient, ct)
```

3. **LoginPhase** - Use NavigationMap:
```csharp
var map = _mapLoader.Load("firekirin");
var context = new StepExecutionContext 
{ 
    CdpClient = cdpClient,
    Platform = "firekirin",
    WorkerId = "smoke-test",
    Variables = new() { ["username"] = config.Username, ["password"] = config.Password }
};
var result = await _stepExecutor.ExecutePhaseAsync(map, "Login", context, ct);
```

4. **VerificationPhase** - Query balance:
```csharp
await Task.Delay(2000, ct); // Wait for WebSocket
var balance = await cdpClient.EvaluateAsync<double>("Number(window.parent.Balance) || 0", ct);
if (balance <= 0) return PhaseResult.Failed("Verification", $"Balance = {balance}");
```

5. **CLI Arguments**:
```csharp
--platform firekirin    # Platform to test (default: firekirin)
--profile W0            # Chrome profile (default: W0)
--port 9222             # CDP port (default: 9222)
--output console|json   # Output format (default: console)
--username <user>       # Override username
--password <pass>       # Override password
```

6. **Exit Codes**:
- 0 = PASS
- 1 = Chrome launch failed
- 2 = Page load timeout
- 3 = Canvas bounds invalid
- 4 = Login step failed
- 5 = Balance = 0 (auth failed)
- 99 = Unhandled exception

**Project References**:
```xml
<ProjectReference Include="..\H4ND\H4ND.csproj" />
<ProjectReference Include="..\C0MMON\C0MMON.csproj" />
```

**Build Configuration**:
```xml
<OutputType>Exe</OutputType>
<TargetFramework>net10.0-windows</TargetFramework>
<AssemblyName>H4ND.SmokeTest</AssemblyName>
<PublishSingleFile>true</PublishSingleFile>
```

**Console Output Format**:
```
═══════════════════════════════════════════════════════════════════
  P4NTH30N SMOKE TEST - FireKirin Login Validation
═══════════════════════════════════════════════════════════════════

[14:32:15] TEST STARTED
[14:32:15] Target: FireKirin
[14:32:15] Profile: Profile-W0 on port 9222

[14:32:15] Phase 1/4: Bootstrap ................................. RUNNING
[14:32:18] Phase 1/4: Bootstrap ................................. PASS (2.8s)
           Chrome W0 on port 9222, bounds: 930x865

[14:32:18] Phase 2/4: Navigation ................................ RUNNING
[14:32:22] Phase 2/4: Navigation ................................ PASS (3.9s)
           Page loaded, canvas: 930x865

[14:32:22] Phase 3/4: Login ..................................... RUNNING
[14:32:31] Phase 3/4: Login ..................................... PASS (9.2s)
           Login sequence completed (7 steps)

[14:32:31] Phase 4/4: Verification .............................. RUNNING
[14:32:33] Phase 4/4: Verification .............................. PASS (2.1s)
           Login verified, balance: $47.32

═══════════════════════════════════════════════════════════════════
  RESULT: PASS
  Duration: 18.1 seconds
  Gate: OPEN - Burn-in approved
═══════════════════════════════════════════════════════════════════
```

**Resources**:
- ChromeProfileManager: `C:\P4NTH30N\H4ND\Parallel\ChromeProfileManager.cs`
- NavigationMapLoader: `C:\P4NTH30N\H4ND\Navigation\NavigationMapLoader.cs`
- StepExecutor: `C:\P4NTH30N\H4ND\Navigation\StepExecutor.cs`
- CdpGameActions: `C:\P4NTH30N\C0MMON\Infrastructure\Cdp\CdpGameActions.cs`
- step-config.json: `C:\P4NTH30N\H4ND\tools\recorder\step-config.json`

**Credentials**: Read from MongoDB at 192.168.56.1:27017, database P4NTH30N, collection CR3D3N7IAL

**Success Criteria**:
1. ✅ Project builds with 0 errors
2. ✅ All 4 phases execute sequentially
3. ✅ Chrome Profile-W0 launches on port 9222
4. ✅ FireKirin login succeeds with 6-strategy typing
5. ✅ Balance verification returns value > 0
6. ✅ Exit code 0 on success, non-zero on failure
7. ✅ Console output matches specification
8. ✅ JSON output valid (for --output json)

**Validation Commands**:
```powershell
# Build
dotnet build H4ND/SmokeTest/SmokeTest.csproj

# Test help
.\H4ND\bin\Debug\net10.0\H4ND.SmokeTest.exe --help

# Run smoke test
.\H4ND\bin\Debug\net10.0\H4ND.SmokeTest.exe --platform firekirin

# Check exit code
echo $LASTEXITCODE  # Should be 0 if PASS
```

Execute immediately. Report build status, test results, and any issues encountered.
