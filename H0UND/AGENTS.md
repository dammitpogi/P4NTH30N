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
- `PollingWorker`: Manages polling operations

**Domain Layer:**
- `DpdCalculator`: Calculates Days Past Due for forecasting
- `ForecastingService`: Handles prediction and forecasting logic
- `SignalService`: Processes incoming signals

**Infrastructure Layer:**
- `BalanceProviderFactory`: Creates platform-specific providers
- `FireKirinBalanceProvider`: FireKirin-specific balance fetching
- `OrionStarsBalanceProvider`: OrionStars-specific balance fetching

## Key Patterns

- **Balance Provider Factory**: Creates platform-specific balance providers
- **Worker Pattern**: Background services for polling and analytics
- **Interface-based design**: IBalanceProvider for loose coupling

## Data Flows

1. **Polling Flow**: PollingWorker → BalanceProviderFactory → [FireKirinBalanceProvider | OrionStarsBalanceProvider] → MongoDB (EV3NT collection)
2. **Analytics Flow**: AnalyticsWorker → ForecastingService → DpdCalculator → Update forecasts in database
3. **Signal Flow**: SignalService processes incoming signals from H4ND

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
