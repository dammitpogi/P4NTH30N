# H0UND

## Responsibility

H0UND is the analytics and polling engine for P4NTH30N. It monitors game platform balances (FireKirin, OrionStars) via polling, calculates DPD (Dollars Per Day) for forecasting, and processes signals through the SignalService.

## When Working Here

- **Layer separation**: Keep Application, Domain, and Infrastructure concerns separated
- **Worker pattern**: PollingWorker and AnalyticsWorker are background services
- **Balance provider abstraction**: Use IBalanceProvider for platform-specific implementations
- **Forecasting logic**: DpdCalculator and ForecastingService handle prediction logic
- **Signal processing**: SignalService manages incoming signals from H4ND

## Architecture

**Application Layer:**
- `AnalyticsWorker`: Orchestrates business logic for analytics
- `PollingWorker`: Manages polling operations with retry logic

**Domain Layer:**
- `DpdCalculator`: Calculates Days Past Due for forecasting
- `ForecastingService`: Handles prediction and forecasting logic
- `SignalService`: Processes incoming signals, generates signals, cleans up stale signals

**Infrastructure Layer:**
- `BalanceProviderFactory`: Creates platform-specific providers
- `FireKirinBalanceProvider`: FireKirin-specific balance fetching
- `OrionStarsBalanceProvider`: OrionStars-specific balance fetching
- `IBalanceProvider`: Interface for platform-agnostic balance fetching

**Resilience Infrastructure:**
- `CircuitBreaker`: API and MongoDB circuit breakers (5 failures/60s for API, 3 failures/30s for MongoDB)
- `SystemDegradationManager`: Adaptive throttling (Emergency/Minimal/Reduced/Normal levels)
- `OperationTracker`: Tracks operations within time windows
- `HealthCheckService`: Full system health checks with component status

## Key Patterns

- **Balance Provider Factory**: Creates platform-specific balance providers
- **Worker Pattern**: Background services for polling and analytics
- **Interface-based design**: IBalanceProvider for loose coupling
- **Circuit Breaker Pattern**: Prevents cascading failures (API: 5 failures, MongoDB: 3 failures)
- **Degradation-aware Throttling**: Adaptive delays based on system health (30s/15s/8s/3-5s)
- **Analytics Interval**: Time-gated analytics phase (default 10 seconds between runs)
- **Cashed-out Detection**: Automatically marks accounts as cashed-out based on balance thresholds

## Data Flows

1. **Polling Flow**: PollingWorker → BalanceProviderFactory → [FireKirinBalanceProvider | OrionStarsBalanceProvider] → CircuitBreaker → MongoDB (EV3NT collection)
2. **Analytics Flow**: AnalyticsWorker → ForecastingService → DpdCalculator → SignalService.GenerateSignals → SignalService.CleanupStaleSignals → MongoDB
3. **Signal Flow**: SignalService processes incoming signals from H4ND, generates new signals based on forecasting, cleans up stale signals
4. **Health Monitoring Flow**: HealthCheckService → CircuitBreaker status → SystemDegradationManager → Adaptive throttling

## Dependencies

- **MongoDB**: Reads/writes to EV3NT, CR3D3N7IAL collections via C0MMON infrastructure
- **C0MMON**: Uses IBalanceProvider, IStoreEvents, IStoreErrors interfaces
- **H4ND**: Receives signal events from H4ND agent
- **Balance Providers**: Platform-specific implementations for FireKirin and OrionStars

## Integration Points

- Consumes credential and signal data from MongoDB
- Produces analytics and forecasting results
- Receives signals from H4ND for processing
- Uses C0MMON interfaces for all data access
