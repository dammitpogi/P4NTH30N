# H0UND/

## Responsibility

H0UND is the analytics and polling engine for P4NTH30N ("The Brain"). It monitors game platform balances (FireKirin, OrionStars) via HTTP/WebSocket polling, calculates DPD (Dollars Per Day) for jackpot forecasting, generates automation signals when thresholds are met, and provides comprehensive system health monitoring with circuit breakers and adaptive throttling.

**Core Functions:**
- **Polling**: Continuous balance monitoring from game platforms
- **Analytics**: DPD calculation and jackpot forecasting
- **Signal Generation**: Creates SIGN4L records when thresholds are triggered
- **Health Monitoring**: Circuit breakers, degradation management, error tracking
- **Forecasting**: Statistical prediction of jackpot timing

## Design

**Architecture Pattern**: Layered architecture with worker pattern and resilience patterns

### Layer Structure
- **Application Layer**: Workers (AnalyticsWorker, PollingWorker) orchestrate business logic
- **Domain Layer**: Forecasting services (DpdCalculator, ForecastingService) and SignalService
- **Infrastructure Layer**: Balance providers, circuit breakers, health monitoring

### Key Patterns
- **Balance Provider Factory**: Creates platform-specific providers
- **Worker Pattern**: Background services for polling and analytics
- **Circuit Breaker Pattern**: Prevents cascading failures (API: 5 failures, MongoDB: 3 failures)
- **Degradation-aware Throttling**: Adaptive delays based on system health
- **Analytics Interval**: Time-gated analytics phase (default 10 seconds)

### Resilience Infrastructure
- **CircuitBreaker**: Separate breakers for API and MongoDB
  - API: 5 failures within 60 seconds → Open
  - MongoDB: 3 failures within 30 seconds → Open
- **SystemDegradationManager**: Adaptive throttling levels
  - Emergency: 30s delays
  - Minimal: 15s delays
  - Reduced: 8s delays
  - Normal: 3-5s delays
- **OperationTracker**: Tracks operations within time windows for failure counting
- **HealthCheckService**: Full system health checks with component status

## Flow

### Polling Flow
```
PollingWorker (BackgroundService)
    ↓
BalanceProviderFactory.Create(platform)
    ↓
[FireKirinBalanceProvider | OrionStarsBalanceProvider]
    ↓
CircuitBreaker.ExecuteAsync()
    ↓
HTTP/WebSocket Request
    ↓
Parse Response
    ↓
Validate Balance Values
    ↓
IStoreEvents.Store() → EV3NT collection
```

### Analytics Flow
```
AnalyticsWorker (BackgroundService)
    ↓
[Time Gate: 10s minimum between runs]
    ↓
ForecastingService.Forecast()
    ↓
DpdCalculator.Calculate()
    ├── Requires ≥25 data points for DPD > 10
    └── Statistical reliability checks
    ↓
SignalService.GenerateSignals()
    ↓
SignalService.CleanupStaleSignals()
    ↓
Update MongoDB (forecasts, signals)
```

### Signal Generation Flow
```
Threshold Analysis
    ↓
Compare Current Jackpots to Thresholds
    ↓
If Jackpot ≥ Threshold:
    ├── Calculate Priority (1=Mini, 2=Minor, 3=Major, 4=Grand)
    ├── Create Signal Entity
    ├── Validate Signal
    └── Store to EV3NT via IReceiveSignals
    ↓
H4ND Consumes Signal
```

### Health Monitoring Flow
```
HealthCheckService.CheckAll()
    ↓
[Circuit Breaker Status]
    ├── API Breaker: Closed/Open
    └── MongoDB Breaker: Closed/Open
    ↓
SystemDegradationManager.Evaluate()
    ↓
Adjust Throttling Level
    ↓
Report Health Status
```

### Error Handling Flow
```
Operation Fails
    ↓
OperationTracker.RecordFailure()
    ↓
CircuitBreaker.Evaluate()
    ↓
If Threshold Exceeded:
    ├── Open Circuit Breaker
    ├── Notify HealthCheckService
    └── Trigger Degradation
    ↓
Log to ERR0R via IStoreErrors
```

## Integration

### Dependencies
- **C0MMON**: All data access via IMongoUnitOfWork, repository interfaces
- **MongoDB**: EV3NT, CR3D3N7IAL, ERR0R collections
- **Game Platforms**: HTTP/WebSocket APIs for FireKirin and OrionStars
- **W4TCHD0G**: Health status shared for monitoring

### External Systems
- **FireKirin Platform**: Balance queries via HTTP API
- **OrionStars Platform**: Balance queries via WebSocket
- **MongoDB**: Primary data store

### Data Collections (via C0MMON)
- `CR3D3N7IAL`: User credentials, current jackpots, thresholds, DPD data
- `EV3NT`: Signal storage, polling events
- `ERR0R`: Validation errors, circuit breaker events

### Interface Contracts
```
IBalanceProvider       : Platform-agnostic balance fetching
IBalanceProviderFactory : Creates platform-specific providers
IForecastingService    : Jackpot prediction logic
IDpdCalculator         : DPD calculation with statistical validation
ISignalService         : Signal generation and cleanup
ICircuitBreaker        : Failure detection and isolation
ISystemDegradationManager : Adaptive throttling
IHealthCheckService    : System health monitoring
```

## Key Components

### Application Layer
- **AnalyticsWorker.cs**: Background service for analytics processing
- **PollingWorker.cs**: Background service for balance polling with retry logic

### Domain Layer
- **ForecastingService.cs**: Statistical forecasting for jackpot timing (FORGE-2024-001 enhancements)
- **DpdCalculator.cs**: DPD (Dollars Per Day) calculation with minimum data requirements
- **SignalService.cs**: Signal generation, priority assignment, stale signal cleanup

### Infrastructure Layer
- **BalanceProviderFactory.cs**: Factory for creating platform-specific providers
- **FireKirinBalanceProvider.cs**: FireKirin HTTP API implementation
- **OrionStarsBalanceProvider.cs**: OrionStars WebSocket implementation
- **CircuitBreaker.cs**: Failure detection and circuit state management
- **SystemDegradationManager.cs**: Adaptive throttling based on health
- **OperationTracker.cs**: Failure counting within time windows
- **HealthCheckService.cs**: Comprehensive health monitoring

### Models
- **DPD.cs**: Dollars-Per-Day calculation model with toggles for jackpot detection
- **Thresholds.cs**: 4-tier jackpot threshold configuration
- **Signal.cs**: Automation trigger with priority levels

## Configuration

### Polling Configuration
```csharp
// Configurable intervals
PollingInterval: 30-60 seconds (randomized)
AnalyticsInterval: 10 seconds minimum
RetryAttempts: 3 with exponential backoff
```

### Circuit Breaker Settings
```csharp
// API Circuit Breaker
FailureThreshold: 5
TimeWindow: 60 seconds

// MongoDB Circuit Breaker
FailureThreshold: 3
TimeWindow: 30 seconds
```

### DPD Calculation
- Minimum data points: 25 for statistical reliability
- Applies when: DPD > 10
- Forecasting: Statistical trend analysis

## Critical Notes

### DPD System Requirements
- Requires minimum 25 data points when DPD > 10
- Statistical reliability enforced before forecasting
- DPD toggles track jackpot detection state

### Circuit Breaker Behavior
- **Closed**: Normal operation, failures counted
- **Open**: Blocking requests, fast failure
- **Half-Open**: Testing recovery after timeout

### Degradation Levels
1. **Emergency**: Critical failures, 30s delays
2. **Minimal**: Major degradation, 15s delays
3. **Reduced**: Minor issues, 8s delays
4. **Normal**: Healthy system, 3-5s delays

### Cashed-out Detection
Automatically marks accounts as cashed-out based on:
- Balance below minimum threshold
- Extended periods of zero activity
- Manual override capability

## Testing

Unit and integration tests in UNI7T35T:
- ForecastingServiceTests: Statistical calculation validation
- Circuit breaker behavior tests
- DPD calculation tests

## Recent Additions (This Session)

**FORGE-2024-001: SafeDateTime**
- C0MMON/Utilities/SafeDateTime.cs for overflow-safe DateTime arithmetic

**Enhanced Forecasting**
- ForecastingService improvements for reliability

**Health Monitoring**
- Integration with C0MMON HealthChecks and MetricsService
