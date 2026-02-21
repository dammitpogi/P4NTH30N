# Designer Consultation: DECISION_035

**Decision ID**: TEST-035  
**Agent**: Designer (Aegis)  
**Task ID**: ses_38558a3aeffe7DmkhcPvJjP6Gz  
**Date**: 2026-02-20  
**Status**: Complete

---

## Original Response

Now I have a comprehensive understanding of the codebase. Let me provide my Designer implementation strategy.

---

## Designer Implementation Strategy: DECISION_035

### Implementation Strategy: 4-Phase Incremental Rollout

**Phase 1: Foundation (Week 1)**
- Core test harness infrastructure
- Signal injection and basic reporting
- Mock-based unit testing framework

**Phase 2: CDP Integration (Week 1-2)**
- Login flow validation harness
- Game readiness verification
- Screenshot/CDP frame capture

**Phase 3: Execution (Week 2)**
- Spin execution testing
- Splash detection framework
- Full end-to-end pipeline

**Phase 4: Vision & Reporting (Week 3)**
- FourEyes vision data capture
- Comprehensive test reporting
- CI/CD integration

---

### Files to Create

| File | Purpose | Location |
|------|---------|----------|
| `TestOrchestrator.cs` | Main test controller; orchestrates full pipeline execution | `UNI7T35T/TestHarness/` |
| `TestSignalInjector.cs` | MongoDB SIGN4L injection with test flag and cleanup | `UNI7T35T/TestHarness/` |
| `CdpTestClient.cs` | H4ND CDP wrapper for test isolation; wraps CdpClient | `UNI7T35T/TestHarness/` |
| `LoginValidator.cs` | FireKirin/OrionStars login flow testing with screenshot capture | `UNI7T35T/TestHarness/` |
| `GameReadinessChecker.cs` | Page load + jackpot value verification with retry logic | `UNI7T35T/TestHarness/` |
| `SpinExecutor.cs` | CDP-based spin testing with balance validation | `UNI7T35T/TestHarness/` |
| `SplashDetector.cs` | Jackpot splash screen detection and capture | `UNI7T35T/TestHarness/` |
| `VisionCapture.cs` | Frame storage for FourEyes training data | `UNI7T35T/TestHarness/` |
| `TestReportGenerator.cs` | JSON + MongoDB TEST collection output | `UNI7T35T/TestHarness/` |
| `TestConfiguration.cs` | Test settings, thresholds, timeouts | `UNI7T35T/TestHarness/` |
| `TestResult.cs` | Test result entity for MongoDB TEST collection | `C0MMON/Entities/TestResult.cs` |
| `TestFixture.cs` | Test lifecycle management (setup/teardown) | `UNI7T35T/TestHarness/` |
| `EndToEndTests.cs` | Integration test suite entry point | `UNI7T35T/Tests/` |
| `MockFourEyesClient.cs` | Stub FourEyes for Phase 1-3 testing | `UNI7T35T/Mocks/` |

---

### Files to Modify

| File | Changes |
|------|---------|
| `UNI7T35T/Program.cs` | Add `EndToEndTests.RunAll()` to test runner |
| `C0MMON/Infrastructure/Persistence/MongoCollectionNames.cs` | Add `TEST` collection constant |
| `C0MMON/Infrastructure/Persistence/Repositories.cs` | Add `RepoTestResults` class implementing `IRepoTestResults` |
| `C0MMON/Interfaces/IUnitOfWork.cs` | Add `TestResults` property |
| `C0MMON/Infrastructure/Persistence/MongoUnitOfWork.cs` | Initialize `RepoTestResults` |
| `C0MMON/Infrastructure/Persistence/MongoDatabaseProvider.cs` | Ensure TEST collection exists on init |
| `C0MMON/Games/FireKirin.cs` | Add `QueryBalancesAsync()` async variant for test compatibility |
| `C0MMON/Games/OrionStars.cs` | Add `QueryBalancesAsync()` async variant for test compatibility |

---

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         TEST HARNESS ARCHITECTURE                           │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐     ┌─────────────────────────────────────────────────┐
│  TestOrchestrator│────▶│              Test Phases                        │
│  (Controller)    │     │  1. Signal Injection → MongoDB SIGN4L          │
└────────┬─────────┘     │  2. CDP Connect → CdpTestClient                │
         │               │  3. Login → LoginValidator (FireKirin/Orion)   │
         │               │  4. Readiness → GameReadinessChecker           │
         │               │  5. Spin → SpinExecutor (CDP/Vision)           │
         │               │  6. Splash → SplashDetector (Vision/OCR)       │
         │               │  7. Capture → VisionCapture (Frames)           │
         │               │  8. Report → TestReportGenerator               │
         │               └─────────────────────────────────────────────────┘
         │
         ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                            COMPONENT LAYER                                  │
├─────────────────┬─────────────────┬─────────────────┬──────────────────────┤
│ SignalInjector  │ CdpTestClient   │ LoginValidator  │ GameReadinessChecker │
│  - MongoDB      │  - Wraps Cdp    │  - FireKirin    │  - Page load check   │
│  - Test flags   │  - Isolation    │  - OrionStars   │  - Jackpot query     │
│  - Cleanup      │  - Health check │  - Screenshots  │  - Timeout/retry     │
└─────────────────┴─────────────────┴─────────────────┴──────────────────────┘
┌─────────────────┬─────────────────┬─────────────────┬──────────────────────┐
│ SpinExecutor    │ SplashDetector  │ VisionCapture   │ ReportGenerator      │
│  - CDP clicks   │  - Vision/OCR   │  - Frame store  │  - JSON output       │
│  - Balance diff │  - Timeout      │  - Metadata     │  - MongoDB TEST      │
│  - Completion   │  - Recovery     │  - Training fmt │  - Metrics           │
└─────────────────┴─────────────────┴─────────────────┴──────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                         EXTERNAL DEPENDENCIES                               │
├────────────────────────┬─────────────────────┬─────────────────────────────┤
│   MongoDB (SIGN4L)     │   Chrome CDP        │   W4TCHD0G/FourEyes         │
│   - Signal CRUD        │   - WebSocket       │   - Frame capture           │
│   - TEST collection    │   - JS evaluate     │   - Splash detection        │
│   - Cleanup            │   - Screenshots     │   - Training data           │
└────────────────────────┴─────────────────────┴─────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                         EXISTING H4ND REUSE                                 │
├────────────────────────────────────────────────────────────────────────────┤
│  CdpClient.cs ──────▶ wrapped by CdpTestClient (isolation)                 │
│  CdpGameActions.cs ─▶ reused directly (login, spin, verify)                 │
│  CircuitBreaker.cs ─▶ integrated into retry logic                           │
│  OperationTracker.cs ▶ duplicate test prevention                            │
└────────────────────────────────────────────────────────────────────────────┘
```

---

### Configuration Structure

```json
{
  "TestHarness": {
    "MongoDB": {
      "ConnectionString": "mongodb://192.168.56.1:27017/?directConnection=true",
      "DatabaseName": "P4NTH30N",
      "TestCollection": "TEST"
    },
    "CDP": {
      "HostIp": "192.168.56.1",
      "Port": 9222,
      "CommandTimeoutMs": 10000,
      "SelectorTimeoutMs": 10000
    },
    "TestAccounts": {
      "FireKirin": [
        {
          "username": "test_fk_001",
          "password": "testpass123",
          "house": "TestHouse",
          "balanceMin": 5.00,
          "balanceMax": 20.00
        }
      ],
      "OrionStars": [
        {
          "username": "test_os_001", 
          "password": "testpass123",
          "house": "TestHouse",
          "balanceMin": 5.00,
          "balanceMax": 20.00
        }
      ]
    },
    "Timeouts": {
      "LoginTimeoutSec": 30,
      "PageReadinessTimeoutSec": 10,
      "SpinTimeoutSec": 10,
      "SplashDetectionTimeoutSec": 5,
      "JackpotRetryAttempts": 40,
      "JackpotRetryIntervalMs": 500
    },
    "SpinLimits": {
      "MaxBetAmount": 0.50,
      "MaxSpinsPerTest": 3,
      "RequireManualConfirmation": true
    },
    "Vision": {
      "CaptureFrames": true,
      "FrameCaptureIntervalMs": 500,
      "MinFramesPerTest": 10,
      "OutputDirectory": "./test_frames",
      "TrainingDataFormat": "lmstudio"
    },
    "Reporting": {
      "OutputFormat": ["json", "mongodb"],
      "IncludeScreenshots": true,
      "ScreenshotOnFailure": true,
      "RetainTestDataHours": 24
    }
  }
}
```

---

### Validation Strategy

**1. Pre-Flight Validation**
```csharp
// CDP health check (reuse H4ND CdpHealthCheck pattern)
- HTTP /json/version reachable
- WebSocket handshake successful
- Round-trip latency < 1000ms
- Browser responsive to evaluate("1+1")
```

**2. Signal Injection Validation**
```csharp
- Signal inserted with test flag (IsTest = true)
- Verify retrieval via GetNext()
- Confirm timeout properly set
- Cleanup on test completion
```

**3. Login Validation**
```csharp
- CDP navigation completes
- Balance query returns valid decimal
- No NaN/Infinity/negative values
- Screenshot captured for manual verification
- Timeout enforced (30s)
```

**4. Game Readiness Validation**
```csharp
// Primary: WebSocket QueryBalances
FireKirinBalances balances = FireKirin.QueryBalances(user, pass);
Assert(balances.Grand > 0, "Grand jackpot must be readable");
Assert(!double.IsNaN(balances.Grand), "Grand cannot be NaN");

// Secondary: CDP page verification
bool pageLoaded = await CdpGameActions.VerifyGamePageLoadedAsync(cdp, "FireKirin");
Assert(pageLoaded, "Page DOM must indicate loaded state");
```

**5. Spin Execution Validation**
```csharp
decimal preSpinBalance = balances.Balance;
await SpinExecutor.ExecuteAsync(cdp, "FireKirin");
decimal postSpinBalance = await QueryBalancesAsync();

Assert(postSpinBalance != preSpinBalance, "Balance must change after spin");
Assert(Math.Abs(postSpinBalance - preSpinBalance) <= MaxBetAmount, "Balance change within bet limits");
```

**6. Jackpot Splash Detection Validation**
```csharp
// Vision-based detection with OCR
SplashResult result = await SplashDetector.DetectAsync(frame, timeoutMs: 5000);
if (result.Detected) {
    Assert(result.Tier != null, "Splash must indicate jackpot tier");
    Assert(result.Amount > 0, "Splash must show jackpot amount");
    Assert(result.Confidence >= 0.8, "Vision confidence >= 80%");
}
```

---

### Fallback Mechanisms

**1. Circuit Breaker Pattern** (reuse existing)
```csharp
private readonly CircuitBreaker _cdpCircuitBreaker = new(
    failureThreshold: 3,
    recoveryTimeout: TimeSpan.FromMinutes(5),
    logger: Console.WriteLine
);

public async Task<bool> ExecuteWithFallback(Func<Task<bool>> operation)
{
    try {
        return await _cdpCircuitBreaker.ExecuteAsync(operation);
    }
    catch (CircuitBreakerOpenException) {
        // Fallback: Log failure, skip to cleanup
        _reportGenerator.LogCircuitOpen();
        return false;
    }
}
```

**2. Retry Strategies**
```csharp
// Exponential backoff for transient failures
public async Task<T> RetryWithBackoff<T>(Func<Task<T>> operation, int maxRetries = 3)
{
    int delayMs = 1000;
    for (int i = 0; i < maxRetries; i++) {
        try {
            return await operation();
        }
        catch (Exception ex) when (i < maxRetries - 1) {
            await Task.Delay(delayMs);
            delayMs *= 2;
        }
    }
    throw;
}
```

**3. Graceful Degradation**
```csharp
public async Task<TestResult> RunTestWithDegradation(TestConfiguration config)
{
    TestResult result = new();
    
    // Phase 1: Signal injection (critical - no fallback)
    result.SignalPhase = await SignalInjector.InjectAsync(config);
    if (!result.SignalPhase.Success) return result; // Hard stop
    
    // Phase 2: CDP connection (critical - no fallback)
    result.CdpPhase = await CdpTestClient.ConnectAsync(config);
    if (!result.CdpPhase.Success) return result; // Hard stop
    
    // Phase 3: Login (with screenshot fallback)
    result.LoginPhase = await LoginValidator.ValidateAsync(config);
    if (!result.LoginPhase.Success) {
        result.LoginPhase.Screenshot = await CdpTestClient.CaptureScreenshotAsync();
        // Continue to cleanup - login is critical for downstream
        return result;
    }
    
    // Phase 4: Game readiness (with retry fallback)
    result.ReadinessPhase = await RetryWithBackoff(
        () => GameReadinessChecker.ValidateAsync(config)
    );
    
    // Phase 5: Spin execution (with vision fallback to CDP)
    if (config.UseVisionSpin) {
        result.SpinPhase = await VisionSpinExecutor.ExecuteAsync(config);
        if (!result.SpinPhase.Success) {
            // Fallback to CDP spin
            result.SpinPhase = await CdpSpinExecutor.ExecuteAsync(config);
            result.SpinPhase.UsedFallback = true;
        }
    } else {
        result.SpinPhase = await CdpSpinExecutor.ExecuteAsync(config);
    }
    
    // Phase 6: Splash detection (optional - don't fail test)
    result.SplashPhase = await SplashDetector.DetectAsync(config);
    // Note: SplashPhase failure doesn't fail overall test
    
    // Phase 7: Vision capture (optional)
    if (config.CaptureFrames) {
        result.VisionPhase = await VisionCapture.CaptureAsync(config);
    }
    
    return result;
}
```

**4. Cleanup Guarantee**
```csharp
public async Task<TestResult> RunTestSafely(TestConfiguration config)
{
    TestResult result = new();
    try {
        result = await RunTestWithDegradation(config);
    }
    finally {
        // Always cleanup test signals
        await SignalInjector.CleanupAsync(config.TestId);
        
        // Always logout
        await CdpTestClient.LogoutAsync(config.Platform);
        
        // Always close CDP
        await CdpTestClient.DisposeAsync();
        
        // Always save report
        await ReportGenerator.SaveAsync(result);
    }
    return result;
}
```

---

### Integration with H4ND (No Duplication Strategy)

| H4ND Component | Test Harness Usage | Avoid Duplication By |
|----------------|-------------------|---------------------|
| `CdpClient` | Wrap in `CdpTestClient` for isolation | Composition, not inheritance |
| `CdpGameActions` | Call directly | Static methods, no wrapping |
| `CircuitBreaker` | Inject into test harness | Reuse existing instance |
| `OperationTracker` | Use for duplicate test prevention | Shared via IOperationTracker |
| `FireKirin/OrionStars` | Call `QueryBalances()` directly | Static methods, no wrapping |
| `MongoUnitOfWork` | Inject for TEST collection | Extend IUnitOfWork interface |

---

### Success Criteria Mapping

| Decision Criteria | Implementation Validation |
|-------------------|---------------------------|
| 100% signal injection success | `SignalInjector` unit tests |
| 95%+ login success | `LoginValidator` retry + fallback |
| 95% page verification in 10s | `GameReadinessChecker` timeout |
| 90%+ spin success | `SpinExecutor` CDP + vision fallback |
| Splash detection in 5s | `SplashDetector` timeout config |
| 10+ frames per test | `VisionCapture` frame count assertion |
| JSON reports for all tests | `ReportGenerator` mandatory output |
| <2 minute end-to-end | Parallel phases + timeout enforcement |

---

### Designer Approval

**Approval Status**: ✅ **Approved for Implementation**

**Key Design Decisions**:
1. **4-phase rollout** enables incremental validation and early feedback
2. **H4ND component reuse** via wrapping/composition prevents duplication
3. **Circuit breaker integration** provides resilience without new code
4. **MongoDB TEST collection** enables historical analysis and trend tracking
5. **Vision fallback to CDP** ensures tests run even if FourEyes unavailable

**Risk Mitigations**:
- Manual confirmation required for spins (safety)
- $0.50 max bet limit enforced in config
- Cleanup guarantee via `finally` blocks
- Screenshot capture on all failures

**Next Steps**: Proceed to Fixer for implementation of Phase 1 (ACT-035-001 through ACT-035-004).

---

## Metadata

- **Input Prompt**: Request for implementation strategy for end-to-end jackpot signal testing pipeline
- **Response Length**: ~8000 characters
- **Key Findings**: 
  - 4-phase implementation strategy
  - 14 files to create, 8 files to modify
  - Architecture: TestOrchestrator → Component Layer → External Dependencies
  - Configuration: JSON with MongoDB, CDP, TestAccounts, Timeouts, SpinLimits, Vision, Reporting
  - Validation: Pre-flight, signal injection, login, readiness, spin, splash detection
  - Fallback: Circuit breaker, exponential backoff, graceful degradation, cleanup guarantee
- **Approval Rating**: 90%
- **Files Referenced**: UNI7T35T/TestHarness/, C0MMON/Entities/, C0MMON/Games/, H4ND/Infrastructure/
