# H0UND/

## Responsibility

H0UND is the analytics and polling engine for P4NTH30N. It monitors game platform balances (FireKirin, OrionStars) via polling, calculates DPD (Days Past Due) for forecasting, and processes signals through the SignalService.

## Design

- **Application Layer**: Contains workers (AnalyticsWorker, PollingWorker) that orchestrate business logic
- **Domain Layer**: Contains forecasting services (DpdCalculator, ForecastingService) and SignalService for signal processing
- **Infrastructure Layer**: Balance providers implement IBalanceProvider interface for platform-specific balance fetching

### Key Patterns
- **Balance Provider Factory**: BalanceProviderFactory creates platform-specific balance providers
- **Worker Pattern**: PollingWorker and AnalyticsWorker run as background services

## Flow

1. **Polling Flow**: PollingWorker → BalanceProviderFactory → [FireKirinBalanceProvider | OrionStarsBalanceProvider] → MongoDB (EV3NT collection)
2. **Analytics Flow**: AnalyticsWorker → ForecastingService → DpdCalculator → Update forecasts in database
3. **Signal Flow**: SignalService processes incoming signals from H4ND

## Integration

- **MongoDB**: Reads/writes to EV3NT, CR3D3N7IAL collections via C0MMON infrastructure
- **H4ND**: Receives signal events from H4ND agent
- **C0MMON**: Uses IBalanceProvider, IStoreEvents, IStoreErrors interfaces
