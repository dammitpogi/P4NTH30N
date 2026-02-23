# UNI7T35T/
UpdateOn: 2026-02-23T12:02 AM

## Responsibility

UNI7T35T is the comprehensive testing platform for P4NTH30N. It provides unit tests, integration tests, and mock infrastructure to validate builds, simulate bugs, and ensure system reliability across all components. Contains 27 passing tests including 16 integration tests for W4TCHD0G vision pipeline, safety monitoring, and win detection.

**Current Status**: All 27 tests passing (Build clean)

## Design

**Architecture Pattern**: Test project with mock infrastructure and integration test suite

### Test Categories
1. **Unit Tests**: Individual component testing
2. **Integration Tests**: End-to-end pipeline validation
3. **Mock Infrastructure**: Reusable mocks for testing

### Key Components

#### Integration Tests (WIN-001)
- **PipelineIntegrationTests.cs**: 16 comprehensive integration tests
  - FrameBuffer tests: Circular buffer operations, frame storage
  - ScreenMapper tests: Coordinate mapping accuracy
  - ActionQueue tests: Input action queuing and execution
  - DecisionEngine tests: Rule-based decision validation
  - SafetyMonitor tests: Spend limit enforcement, circuit breaker
  - WinDetector tests: Balance + OCR detection logic
  - InputAction tests: Input action creation and validation

#### Unit Tests
- **EncryptionServiceTests.cs**: AES-256 encryption/decryption validation
- **ForecastingServiceTests.cs**: DPD calculation and forecasting logic

#### Mock Infrastructure (FORGE-2024-002)
- **MockFactory.cs**: Reusable test data factories for all entity types
- **MockUnitOfWork.cs**: In-memory Unit of Work for isolated tests
- **MockRepoCredentials.cs**: Mock credential repository
- **MockRepoSignals.cs**: Mock signal repository
- **MockRepoJackpots.cs**: Mock jackpot repository
- **MockRepoHouses.cs**: Mock house repository
- **MockReceiveSignals.cs**: Mock signal receiver
- **MockStoreEvents.cs**: Mock event store
- **MockStoreErrors.cs**: Mock error store

## Flow

### Test Execution Flow
```
dotnet test UNI7T35T/UNI7T35T.csproj
    ↓
Test Discovery
    ↓
[Parallel Test Execution]
    ├── PipelineIntegrationTests (16 tests)
    │   ├── FrameBuffer_StoresFrames_Correctly
    │   ├── ScreenMapper_MapsCoordinates_Accurately
    │   ├── ActionQueue_ProcessesActions_InOrder
    │   ├── DecisionEngine_EvaluatesRules_Correctly
    │   ├── SafetyMonitor_EnforcesSpendLimits
    │   ├── SafetyMonitor_TriggersCircuitBreaker
    │   ├── WinDetector_DetectsViaBalance
    │   ├── WinDetector_DetectsViaOCR
    │   └── ... (8 more)
    ├── EncryptionServiceTests (N tests)
    │   ├── EncryptDecrypt_Roundtrip_Succeeds
    │   └── Encrypt_WithInvalidKey_Fails
    └── ForecastingServiceTests (N tests)
        ├── CalculateDPD_WithSufficientData_Succeeds
        └── CalculateDPD_WithInsufficientData_ReturnsNull
    ↓
Test Results: 27 Passed, 0 Failed
```

### Mock Usage Flow
```
Test Method
    ↓
Arrange: MockFactory.CreateCredential()
    ↓
MockUnitOfWork with MockRepoCredentials
    ↓
Act: Execute tested operation
    ↓
Assert: Verify mock interactions
```

## Integration

### Dependencies
- **C0MMON**: All entities, interfaces, and services under test
- **W4TCHD0G**: Vision components tested via integration tests
- **H0UND**: Forecasting service tested
- **xUnit/MSTest**: Test framework

### Mock Pattern
```csharp
// Example mock usage
var mockCredential = MockFactory.CreateCredential(
    username: "testuser",
    platform: "FireKirin"
);

var mockUow = new MockUnitOfWork();
mockUow.Credentials.Add(mockCredential);

// Test service that uses IUnitOfWork
var service = new TestedService(mockUow);
var result = service.DoWork();

Assert.True(result);
```

## Test Coverage

### W4TCHD0G Integration Tests (16 tests)
| Component | Tests | Description |
|-----------|-------|-------------|
| FrameBuffer | 2 | Frame storage, circular buffer, overflow handling |
| ScreenMapper | 2 | Coordinate mapping, resolution scaling |
| ActionQueue | 2 | Action queuing, priority handling, execution order |
| DecisionEngine | 2 | Rule evaluation, decision outcomes |
| SafetyMonitor | 4 | Spend limits, loss circuit breaker, kill switch |
| WinDetector | 3 | Balance detection, OCR detection, dual confirmation |
| InputAction | 1 | Input creation, serialization |

### Service Tests
- **EncryptionServiceTests**: Encryption/decryption roundtrip, key validation, error handling
- **ForecastingServiceTests**: DPD calculation, statistical validation, edge cases

## Key Components

### Test Files
- **PipelineIntegrationTests.cs**: Main integration test suite (WIN-001)
- **EncryptionServiceTests.cs**: Security service tests
- **ForecastingServiceTests.cs**: Analytics service tests

### Mock Files
- **MockFactory.cs**: Test data factory with sensible defaults (FORGE-2024-002)
- **MockUnitOfWork.cs**: In-memory UoW implementation
- **MockRepo*.cs**: Repository mocks for all entity types
- **MockStore*.cs**: Store interface mocks

### Configuration
- **UNI7T35T.csproj**: Test project configuration
- **Program.cs**: Test runner entry point

## Build Integration

### Test Commands
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

### CI/CD Integration
- PR Validation workflow runs tests on every PR
- Release build workflow validates tests before deployment
- All 27 tests must pass for build approval

## Critical Notes

### Test Reliability
- All tests are deterministic (no random failures)
- Mocks provide isolated test environments
- No external dependencies (MongoDB mocked)

### Test Data
- MockFactory creates consistent test data
- Edge cases covered (null values, empty collections, boundary values)
- Realistic data patterns for integration tests

### Performance
- Tests run in parallel for speed
- Mock implementations are fast (no I/O)
- Full suite runs in < 30 seconds

## Recent Additions (This Session)

**WIN-001: Pipeline Integration Tests**
- PipelineIntegrationTests.cs with 16 comprehensive tests
- Covers all W4TCHD0G pipeline components

**FORGE-2024-002: MockFactory**
- Reusable test data factory
- Supports all entity types

**Complete Mock Infrastructure**
- MockUnitOfWork for isolated testing
- Repository mocks for all entity types
- Store mocks for IReceiveSignals, IStoreEvents, IStoreErrors

**Service Tests**
- EncryptionServiceTests for security validation
- ForecastingServiceTests for analytics validation

## Build Status

**Current State**: 27/27 tests passing
- Build: Clean (no errors)
- Formatting: Passes csharpier check
- Test Suite: All green

### New Test Components (2026-02-20)
- **TestHarness/CdpTestClient.cs**: CDP test client for testing
- **TestHarness/GameReadinessChecker.cs**: Game readiness validation
- **TestHarness/LoginValidator.cs**: Login validation testing
- **TestHarness/SpinExecutor.cs**: Spin execution testing
- **TestHarness/SplashDetector.cs**: Splash screen detection
- **TestHarness/TestConfiguration.cs**: Test configuration
- **TestHarness/TestFixture.cs**: Test fixture setup
- **TestHarness/TestOrchestrator.cs**: Test orchestration
- **TestHarness/TestReportGenerator.cs**: Test report generation
- **TestHarness/TestSignalInjector.cs**: Signal injection for testing
- **TestHarness/VisionCapture.cs**: Vision capture for testing
- **Mocks/MockCdpClient.cs**: Mock CDP client
- **Mocks/MockFourEyesClient.cs**: Mock FourEyes client
- **Mocks/MockRepoTestResults.cs**: Mock test results repository
- **Tests/FourEyesVisionTest.cs**: FourEyes vision tests
- **Tests/LiveJackpotReaderTest.cs**: Live jackpot reader tests
- **Tests/AnomalyDetectorTests.cs**: Anomaly detector tests
- **Tests/CdpGameActionsTests.cs**: CDP game actions tests
- **Tests/EndToEndTests.cs**: End-to-end integration tests
- **Tests/FirstSpinControllerTests.cs**: First spin controller tests
- **Tests/ParallelExecutionTests.cs**: Parallel execution tests
- **Tests/SessionRenewalTests.cs**: Session renewal tests
- **Tests/SignalGeneratorTests.cs**: Signal generator tests
- **Tests/SystemHealthReportTests.cs**: System health report tests
- **Tests/CdpLifecycleManagerTests.cs**: CDP lifecycle manager tests
- **Tests/BurnInMonitorTests.cs**: Burn-in monitor tests

(End of file)
