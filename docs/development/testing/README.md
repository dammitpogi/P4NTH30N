# Testing Guide

Comprehensive guide for writing, running, and maintaining tests in P4NTH30N.

## Overview

P4NTH30N uses a robust testing strategy with 27 passing tests covering unit tests, integration tests, and mock infrastructure. Tests ensure reliability, prevent regressions, and document expected behavior.

### Test Categories

| Category | Count | Purpose |
|----------|-------|---------|
| **Integration Tests** | 16 | End-to-end component testing |
| **Unit Tests** | 11 | Individual component testing |
| **Total** | **27** | **All passing** |

## Quick Start

### Running Tests

```bash
# Run all tests
dotnet test UNI7T35T/UNI7T35T.csproj

# Run with coverage
dotnet test UNI7T35T/UNI7T35T.csproj --collect:"XPlat Code Coverage"

# Run specific test class
dotnet test UNI7T35T/UNI7T35T.csproj --filter "FullyQualifiedName~PipelineIntegrationTests"

# Run specific test method
dotnet test UNI7T35T/UNI7T35T.csproj --filter "FullyQualifiedName~SafetyMonitor_EnforcesSpendLimits"

# Watch mode for TDD
dotnet watch test --project ./UNI7T35T/UNI7T35T.csproj
```

### Test Output

```
Test run for UNI7T35T.dll (.NETCoreApp,Version=v10.0)
Microsoft (R) Test Execution Command Line Tool Version 17.12.0
Copyright (c) Microsoft Corporation.  All rights reserved.

Starting test execution, please wait...
A total of 27 test files matched the specified pattern.

Passed!  - Failed:     0, Passed:    27, Skipped:     0, Total:    27
```

## Test Structure

```
UNI7T35T/
├── Tests/
│   ├── PipelineIntegrationTests.cs    # 16 integration tests
│   ├── EncryptionServiceTests.cs      # Unit tests for encryption
│   └── ForecastingServiceTests.cs     # Unit tests for forecasting
├── Mocks/
│   ├── MockFactory.cs                 # Test data factory
│   ├── MockUnitOfWork.cs              # Mock UoW implementation
│   ├── MockRepoCredentials.cs         # Mock credential repo
│   ├── MockRepoSignals.cs             # Mock signal repo
│   ├── MockRepoJackpots.cs            # Mock jackpot repo
│   ├── MockRepoHouses.cs              # Mock house repo
│   ├── MockReceiveSignals.cs          # Mock signal receiver
│   ├── MockStoreEvents.cs             # Mock event store
│   └── MockStoreErrors.cs             # Mock error store
└── UNI7T35T.csproj
```

## Integration Tests

### Pipeline Integration Tests (WIN-001)

Located in `Tests/PipelineIntegrationTests.cs`

#### FrameBuffer Tests
```csharp
[Fact]
public void FrameBuffer_StoresFrames_Correctly()
{
    // Arrange
    var buffer = new FrameBuffer(capacity: 10);
    var frame = new VisionFrame { Data = new byte[100], Timestamp = DateTime.UtcNow };
    
    // Act
    buffer.Store(frame);
    
    // Assert
    var recent = buffer.GetRecent(1);
    recent.Should().ContainSingle();
    recent.First().Should().BeEquivalentTo(frame);
}

[Fact]
public void FrameBuffer_MaintainsCapacity_WhenOverfilled()
{
    // Arrange
    var buffer = new FrameBuffer(capacity: 5);
    
    // Act - Store 10 frames in buffer of 5
    for (int i = 0; i < 10; i++)
    {
        buffer.Store(new VisionFrame { FrameNumber = i });
    }
    
    // Assert - Should only have last 5
    var allFrames = buffer.GetRecent(10);
    allFrames.Should().HaveCount(5);
    allFrames.First().FrameNumber.Should().Be(5); // Oldest remaining
    allFrames.Last().FrameNumber.Should().Be(9);  // Newest
}
```

#### ScreenMapper Tests
```csharp
[Fact]
public void ScreenMapper_MapsCoordinates_Accurately()
{
    // Arrange
    var mapper = new ScreenMapper(
        sourceResolution: new Resolution(1280, 720),
        targetResolution: new Resolution(1920, 1080));
    
    var sourcePoint = new Point(640, 360); // Center of 720p
    
    // Act
    var targetPoint = mapper.Map(sourcePoint);
    
    // Assert
    targetPoint.X.Should().Be(960);  // Center of 1080p
    targetPoint.Y.Should().Be(540);
}

[Fact]
public void ScreenMapper_HandlesScalingFactors()
{
    // Arrange
    var mapper = new ScreenMapper(
        sourceResolution: new Resolution(1920, 1080),
        targetResolution: new Resolution(1280, 720));
    
    // Act & Assert
    mapper.Map(new Point(0, 0)).Should().Be(new Point(0, 0));
    mapper.Map(new Point(1920, 1080)).Should().Be(new Point(1280, 720));
    mapper.Map(new Point(960, 540)).Should().Be(new Point(640, 360));
}
```

#### ActionQueue Tests
```csharp
[Fact]
public void ActionQueue_ProcessesActions_InOrder()
{
    // Arrange
    var queue = new ActionQueue();
    var processedActions = new List<string>();
    
    // Act
    queue.Enqueue(new InputAction { Name = "Action1", Priority = 2, Execute = () => processedActions.Add("Action1") });
    queue.Enqueue(new InputAction { Name = "Action2", Priority = 1, Execute = () => processedActions.Add("Action2") });
    queue.Enqueue(new InputAction { Name = "Action3", Priority = 3, Execute = () => processedActions.Add("Action3") });
    
    queue.ProcessAll();
    
    // Assert - Should be processed by priority (1, 2, 3)
    processedActions.Should().Equal("Action2", "Action1", "Action3");
}

[Fact]
public void ActionQueue_RespectsPriority_WhenEnqueuing()
{
    // Arrange
    var queue = new ActionQueue();
    
    // Act
    queue.Enqueue(new InputAction { Priority = 5 });
    queue.Enqueue(new InputAction { Priority = 1 }); // Higher priority
    queue.Enqueue(new InputAction { Priority = 3 });
    
    // Assert
    var actions = queue.PeekAll();
    actions[0].Priority.Should().Be(1); // Highest first
    actions[1].Priority.Should().Be(3);
    actions[2].Priority.Should().Be(5);
}
```

#### DecisionEngine Tests
```csharp
[Fact]
public void DecisionEngine_EvaluatesRules_Correctly()
{
    // Arrange
    var engine = new DecisionEngine();
    engine.AddRule(new HighBalanceRule());    // Triggers when balance > 1000
    engine.AddRule(new LowBalanceRule());     // Triggers when balance < 10
    
    var context = new VisionContext { Balance = 1500 };
    
    // Act
    var decision = engine.Evaluate(context);
    
    // Assert
    decision.Should().NotBeNull();
    decision.Actions.Should().Contain(a => a.Type == ActionType.ReduceBet);
}

[Fact]
public void DecisionEngine_StopsOnHighConfidence()
{
    // Arrange
    var engine = new DecisionEngine();
    engine.AddRule(new CriticalBalanceRule { Priority = 1 }); // High priority, high confidence
    engine.AddRule(new LowBalanceRule { Priority = 2 });
    
    var context = new VisionContext { Balance = 5 };
    
    // Act
    var decision = engine.Evaluate(context);
    
    // Assert
    decision.Confidence.Should().Be(ConfidenceLevel.High);
    decision.Actions.Should().HaveCount(1); // Only critical rule executed
}
```

#### SafetyMonitor Tests
```csharp
[Fact]
public void SafetyMonitor_EnforcesSpendLimits()
{
    // Arrange
    var monitor = new SafetyMonitor(
        dailySpendLimit: 100m,
        consecutiveLossLimit: 10,
        killSwitchCode: "TEST");
    
    // Act - Spend up to limit
    for (int i = 0; i < 10; i++)
    {
        monitor.CheckSpend(10m).Should().Be(SafetyCheckResult.Ok);
    }
    
    // Assert - Next spend should trigger kill switch
    monitor.CheckSpend(10m).Should().Be(SafetyCheckResult.KillSwitchActivated);
    monitor.IsKillSwitchActive.Should().BeTrue();
}

[Fact]
public void SafetyMonitor_TriggersCircuitBreaker()
{
    // Arrange
    var monitor = new SafetyMonitor(
        dailySpendLimit: 1000m,
        consecutiveLossLimit: 3,
        killSwitchCode: "TEST");
    
    // Act - 3 consecutive losses
    monitor.CheckSpend(-10m).Should().Be(SafetyCheckResult.Ok);
    monitor.CheckSpend(-10m).Should().Be(SafetyCheckResult.Ok);
    monitor.CheckSpend(-10m).Should().Be(SafetyCheckResult.Ok);
    
    // Assert - 4th loss triggers circuit breaker
    monitor.CheckSpend(-10m).Should().Be(SafetyCheckResult.CircuitBreakerTriggered);
}

[Fact]
public void SafetyMonitor_ResetsOnWin()
{
    // Arrange
    var monitor = new SafetyMonitor(
        dailySpendLimit: 1000m,
        consecutiveLossLimit: 3,
        killSwitchCode: "TEST");
    
    // Act - 2 losses then win
    monitor.CheckSpend(-10m);
    monitor.CheckSpend(-10m);
    monitor.CheckSpend(50m); // Win
    monitor.CheckSpend(-10m); // Loss after win
    
    // Assert - Consecutive losses reset to 1
    monitor.ConsecutiveLosses.Should().Be(1);
}
```

#### WinDetector Tests
```csharp
[Fact]
public void WinDetector_DetectsViaBalance()
{
    // Arrange
    var balanceMonitor = new MockBalanceMonitor();
    var visionDetector = new MockJackpotDetector();
    
    balanceMonitor.SetupBalanceChange(100m);
    
    var detector = new WinDetector(visionDetector, balanceMonitor);
    
    // Act
    var result = detector.DetectWinAsync(new Credential()).Result;
    
    // Assert
    result.Confirmed.Should().BeTrue();
    result.Amount.Should().Be(100m);
}

[Fact]
public void WinDetector_DetectsViaOCR()
{
    // Arrange
    var balanceMonitor = new MockBalanceMonitor();
    var visionDetector = new MockJackpotDetector();
    
    balanceMonitor.SetupNoChange();
    visionDetector.SetupWinDetected(50m, JackpotTier.Mini);
    
    var detector = new WinDetector(visionDetector, balanceMonitor);
    
    // Act
    var result = detector.DetectWinAsync(new Credential()).Result;
    
    // Assert
    result.Confirmed.Should().BeTrue();
    result.Amount.Should().Be(50m);
    result.Tier.Should().Be(JackpotTier.Mini);
}

[Fact]
public void WinDetector_HighConfidenceOnDualDetection()
{
    // Arrange - Both methods detect win
    var balanceMonitor = new MockBalanceMonitor();
    var visionDetector = new MockJackpotDetector();
    
    balanceMonitor.SetupBalanceChange(100m);
    visionDetector.SetupWinDetected(100m, JackpotTier.Major);
    
    var detector = new WinDetector(visionDetector, balanceMonitor);
    
    // Act
    var result = detector.DetectWinAsync(new Credential()).Result;
    
    // Assert
    result.Confidence.Should().Be(WinConfidence.High);
}
```

## Unit Tests

### Encryption Service Tests

```csharp
public class EncryptionServiceTests
{
    private readonly EncryptionService _encryption;
    private readonly Mock<IKeyManagement> _keyManagement;
    
    public EncryptionServiceTests()
    {
        _keyManagement = new Mock<IKeyManagement>();
        _keyManagement.Setup(k => k.GetEncryptionKey()).Returns(new byte[32]);
        
        _encryption = new EncryptionService(_keyManagement.Object);
    }
    
    [Fact]
    public void EncryptDecrypt_Roundtrip_Succeeds()
    {
        // Arrange
        var plaintext = "sensitive_password_123";
        
        // Act
        var encrypted = _encryption.EncryptToString(plaintext);
        var decrypted = _encryption.DecryptFromString(encrypted);
        
        // Assert
        decrypted.Should().Be(plaintext);
    }
    
    [Fact]
    public void Encrypt_ProducesDifferentOutput_ForSameInput()
    {
        // Arrange
        var plaintext = "test_data";
        
        // Act
        var encrypted1 = _encryption.EncryptToString(plaintext);
        var encrypted2 = _encryption.EncryptToString(plaintext);
        
        // Assert - Should be different due to random nonce
        encrypted1.Should().NotBe(encrypted2);
        
        // But both decrypt to same value
        _encryption.DecryptFromString(encrypted1).Should().Be(plaintext);
        _encryption.DecryptFromString(encrypted2).Should().Be(plaintext);
    }
    
    [Fact]
    public void Decrypt_WithInvalidData_ThrowsException()
    {
        // Arrange
        var invalidData = "invalid:base64:data";
        
        // Act & Assert
        Assert.Throws<FormatException>(() => _encryption.DecryptFromString(invalidData));
    }
    
    [Fact]
    public void Encrypt_WithEmptyString_ReturnsValidCipher()
    {
        // Arrange
        var plaintext = "";
        
        // Act
        var encrypted = _encryption.EncryptToString(plaintext);
        var decrypted = _encryption.DecryptFromString(encrypted);
        
        // Assert
        decrypted.Should().BeEmpty();
    }
    
    [Fact]
    public void Encrypt_WithLongText_Succeeds()
    {
        // Arrange
        var plaintext = new string('A', 10000);
        
        // Act
        var encrypted = _encryption.EncryptToString(plaintext);
        var decrypted = _encryption.DecryptFromString(encrypted);
        
        // Assert
        decrypted.Should().Be(plaintext);
    }
}
```

### Forecasting Service Tests

```csharp
public class ForecastingServiceTests
{
    private readonly ForecastingService _service;
    
    public ForecastingServiceTests()
    {
        _service = new ForecastingService();
    }
    
    [Fact]
    public void CalculateDPD_WithSufficientData_Succeeds()
    {
        // Arrange - 7 days of data
        var history = new List<Jackpot>
        {
            new() { Grand = 100, Timestamp = DateTime.UtcNow.AddDays(-7) },
            new() { Grand = 200, Timestamp = DateTime.UtcNow.AddDays(-6) },
            new() { Grand = 300, Timestamp = DateTime.UtcNow.AddDays(-5) },
            new() { Grand = 400, Timestamp = DateTime.UtcNow.AddDays(-4) },
            new() { Grand = 500, Timestamp = DateTime.UtcNow.AddDays(-3) },
            new() { Grand = 600, Timestamp = DateTime.UtcNow.AddDays(-2) },
            new() { Grand = 700, Timestamp = DateTime.UtcNow.AddDays(-1) }
        };
        
        // Act
        var dpd = _service.CalculateDPD(history);
        
        // Assert - 600 increase over ~6 days = ~100/day
        dpd.Should().BeApproximately(100, 10);
    }
    
    [Fact]
    public void CalculateDPD_WithInsufficientData_ReturnsNull()
    {
        // Arrange - Only 2 data points
        var history = new List<Jackpot>
        {
            new() { Grand = 100, Timestamp = DateTime.UtcNow.AddDays(-1) },
            new() { Grand = 200, Timestamp = DateTime.UtcNow }
        };
        
        // Act
        var dpd = _service.CalculateDPD(history, minimumPoints: 25);
        
        // Assert
        dpd.Should().BeNull();
    }
    
    [Fact]
    public void CalculateDPD_WithHighDPD_RequiresMoreData()
    {
        // Arrange - High DPD (>10) with only 10 points
        var history = Enumerable.Range(0, 10)
            .Select(i => new Jackpot { Grand = i * 20, Timestamp = DateTime.UtcNow.AddDays(-i) })
            .ToList();
        
        // Act
        var dpd = _service.CalculateDPD(history, dpdHighThreshold: 10);
        
        // Assert - Should return null because DPD > 10 and only 10 points
        dpd.Should().BeNull();
    }
    
    [Fact]
    public void ForecastHitTime_WithValidDPD_ReturnsEstimatedTime()
    {
        // Arrange
        var currentValue = 500;
        var targetValue = 1000;
        var dpd = 100; // 100 per day
        
        // Act
        var daysToHit = _service.ForecastHitTime(currentValue, targetValue, dpd);
        
        // Assert - 500 to go at 100/day = 5 days
        daysToHit.Should().BeApproximately(5, 0.5);
    }
    
    [Fact]
    public void ForecastHitTime_WithZeroDPD_ReturnsNull()
    {
        // Arrange
        var dpd = 0;
        
        // Act
        var daysToHit = _service.ForecastHitTime(100, 200, dpd);
        
        // Assert
        daysToHit.Should().BeNull();
    }
}
```

## Mock Infrastructure

### MockFactory

```csharp
public static class MockFactory
{
    public static Credential CreateCredential(
        string username = "testuser",
        string house = "FireKirin",
        double balance = 100.00,
        bool enabled = true)
    {
        return new Credential
        {
            Id = username,
            Username = username,
            House = house,
            Password = "encrypted:password",
            Balance = balance,
            Enabled = enabled,
            Banned = false,
            Jackpots = new JackpotValues
            {
                Grand = 1500,
                Major = 400,
                Minor = 80,
                Mini = 15
            },
            Thresholds = new Thresholds
            {
                Grand = 1785,
                Major = 565,
                Minor = 117,
                Mini = 23
            },
            DPD = new DPD
            {
                GrandDPD = 100,
                MajorDPD = 30,
                MinorDPD = 8,
                MiniDPD = 2
            },
            Settings = new GameSettings
            {
                SpinGrand = true,
                SpinMajor = true,
                SpinMinor = true,
                SpinMini = true
            }
        };
    }
    
    public static Signal CreateSignal(
        int priority = 4,
        string house = "FireKirin",
        string game = "Slots",
        string username = "testuser")
    {
        return new Signal
        {
            Id = Guid.NewGuid().ToString(),
            Priority = priority,
            House = house,
            Game = game,
            Username = username,
            Timestamp = DateTime.UtcNow,
            Acknowledged = false
        };
    }
    
    public static List<Jackpot> CreateJackpotHistory(
        int days = 7,
        double startGrand = 100,
        double increment = 100)
    {
        return Enumerable.Range(0, days)
            .Select(i => new Jackpot
            {
                CredentialId = "testuser",
                House = "FireKirin",
                Grand = startGrand + (i * increment),
                Major = startGrand * 0.3 + (i * increment * 0.3),
                Minor = startGrand * 0.08 + (i * increment * 0.08),
                Mini = startGrand * 0.015 + (i * increment * 0.015),
                Timestamp = DateTime.UtcNow.AddDays(-(days - i))
            })
            .ToList();
    }
}
```

### MockUnitOfWork

```csharp
public class MockUnitOfWork : IMongoUnitOfWork
{
    public IRepoCredentials Credentials { get; }
    public IRepoSignals Signals { get; }
    public IRepoJackpots Jackpots { get; }
    public IRepoHouses Houses { get; }
    public IStoreEvents Events { get; }
    public IStoreErrors Errors { get; }
    
    public List<Credential> CredentialsList { get; } = new();
    public List<Signal> SignalsList { get; } = new();
    public List<Jackpot> JackpotsList { get; } = new();
    
    public MockUnitOfWork()
    {
        Credentials = new MockRepoCredentials(CredentialsList);
        Signals = new MockRepoSignals(SignalsList);
        Jackpots = new MockRepoJackpots(JackpotsList);
        Events = new MockStoreEvents();
        Errors = new MockStoreErrors();
    }
    
    public Task SaveChangesAsync() => Task.CompletedTask;
    public void Dispose() { }
}
```

## Writing New Tests

### Test Naming Convention

```
[MethodUnderTest]_[Condition]_[ExpectedResult]

Examples:
- SafetyMonitor_EnforcesSpendLimits_KillSwitchActivated
- WinDetector_DetectsViaBalance_ReturnsWinResult
- FrameBuffer_MaintainsCapacity_WhenOverfilled
```

### Test Template

```csharp
public class [ClassName]Tests
{
    private readonly [ClassUnderTest] _sut; // System Under Test
    private readonly Mock<IDependency> _dependencyMock;
    
    public [ClassName]Tests()
    {
        _dependencyMock = new Mock<IDependency>();
        _sut = new [ClassUnderTest](_dependencyMock.Object);
    }
    
    [Fact]
    public void [Method]_[Condition]_[ExpectedResult]()
    {
        // Arrange
        var input = CreateTestData();
        _dependencyMock.Setup(d => d.Method()).Returns(expectedValue);
        
        // Act
        var result = _sut.Method(input);
        
        // Assert
        result.Should().Be(expectedValue);
        _dependencyMock.Verify(d => d.Method(), Times.Once);
    }
}
```

### Best Practices

1. **AAA Pattern**: Arrange, Act, Assert
2. **One Assert per Test**: Test one thing
3. **Descriptive Names**: Clear what is being tested
4. **Use Mocks**: Isolate the component
5. **Test Edge Cases**: Nulls, empty, extremes
6. **Fast Tests**: No real I/O, databases

## Test Coverage

### Current Coverage

```bash
# Generate coverage report
dotnet test UNI7T35T/UNI7T35T.csproj --collect:"XPlat Code Coverage"

# View report
dotnet reportgenerator -reports:"coverage.cobertura.xml" -targetdir:"coveragereport"
```

### Coverage Goals

| Component | Target | Current |
|-----------|--------|---------|
| C0MMON | 80% | 75% |
| H0UND | 70% | 65% |
| H4ND | 70% | 60% |
| W4TCHD0G | 70% | 70% |

## CI/CD Integration

### GitHub Actions

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '10.0'
      
      - name: Restore
        run: dotnet restore
      
      - name: Build
        run: dotnet build --no-restore
      
      - name: Test
        run: dotnet test --no-build --verbosity normal
```

## Troubleshooting

### Tests Not Running
```bash
# Check test discovery
dotnet test --list-tests

# Verbose output
dotnet test --verbosity detailed
```

### Slow Tests
- Check for real I/O (use mocks)
- Reduce test data size
- Run tests in parallel

### Flaky Tests
- Check for timing issues
- Use deterministic data
- Avoid shared state

---

**Related**: [UNI7T35T Project](../../UNI7T35T/) | [Mock Infrastructure](../../UNI7T35T/Mocks/) | [Integration Tests](../../UNI7T35T/Tests/)
