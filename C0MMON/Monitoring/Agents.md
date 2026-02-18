# C0MMON/Monitoring

## Responsibility

Health monitoring, diagnostics, and system observability for P4NTH30N. Tracks system health, detects anomalies, and provides diagnostic capabilities.

## When Working Here

- **Proactive monitoring**: Detect issues before they become critical
- **Health checks**: Validate component functionality
- **Metrics collection**: Gather performance data
- **Alerting**: Notify on threshold breaches
- **Diagnostics**: Provide troubleshooting information

## Core Components

### HealthCheckService.cs
Main health monitoring service implementing `IHealthCheckService`:
- `GetSystemHealthAsync()` - Aggregates all health checks
- `CheckMongoDBHealth()` - MongoDB ping with latency tracking (>100ms = degraded)
- `CheckExternalAPIHealth()` - Circuit breaker state monitoring
- `CheckWorkerPoolHealth()` - Signal queue depth monitoring (depth >50 = degraded, >100 = unhealthy)
- `CheckVisionStreamHealth()` - W4TCHD0G integration status (currently placeholder)
- Uses `ICircuitBreaker` for external API resilience
- Tracks system uptime via Stopwatch

### IHealthCheckService.cs
Interface defining health check contracts:
```csharp
public interface IHealthCheckService
{
    Task<SystemHealth> GetSystemHealthAsync();
    Task<HealthCheck> CheckMongoDBHealth();
    Task<HealthCheck> CheckExternalAPIHealth();
    Task<HealthCheck> CheckWorkerPoolHealth();
    Task<HealthCheck> CheckVisionStreamHealth();
}
```

### HealthStatus.cs
Simple enum for health states:
```csharp
public enum HealthStatus { Healthy, Degraded, Unhealthy }
```

### SystemHealth.cs
Container for aggregated health status:
```csharp
public record SystemHealth(HealthStatus OverallStatus, IEnumerable<HealthCheck> Checks, DateTime LastUpdated, TimeSpan Uptime);
```

### HealthCheck.cs
Individual check result record:
```csharp
public record HealthCheck(string Component, HealthStatus Status, string Message, long ResponseTimeMs = 0);
```

### DataCorruptionMonitor.cs
Real-time data corruption detection service:
- **Monitoring interval**: Every 2 minutes
- **Alert cooldown**: 5 minutes between alerts
- **Checks performed**:
  - `CheckCredentialExtremes()` - Extreme jackpot values (>10k Grand, >1k Major, >200 Minor, >50 Mini, >50k Balance)
  - `CheckDPDDataCorruption()` - Corrupted DPD data (>10k or <0 Grand)
  - `CheckJackpotExtremes()` - Extreme J4CKP0T entries (>10k Current, >2k Threshold, negative DPM)
- Logs alerts to EV3NT collection
- Has `TriggerImmediateCheck()` for manual execution

## Health Check Results

### MongoDB
- Healthy: Ping <100ms
- Degraded: Ping >100ms
- Unhealthy: Ping failed

### External API
- Healthy: Circuit closed
- Degraded: Circuit half-open (testing recovery)
- Unhealthy: Circuit open

### Signal Queue (Worker Pool)
- Healthy: Depth ≤50
- Degraded: Depth 51-100
- Unhealthy: Depth >100

### Vision Stream
- Healthy: "Not yet configured (W4TCHD0G pending)"

## Key Patterns

1. **Health Check Pattern**: Standardized component validation
2. **Circuit Breaker**: Prevent cascade failures via `ICircuitBreaker`
3. **Uptime Tracking**: Stopwatch-based system uptime
4. **Alert Cooldown**: Prevent alert spam with time-based throttling

## Usage

```csharp
// Create health check service
var healthService = new HealthCheckService(dbProvider, apiCircuit, mongoCircuit, uow);

// Get system health
var systemHealth = await healthService.GetSystemHealthAsync();
Console.WriteLine($"Overall: {systemHealth.OverallStatus}");
Console.WriteLine($"Uptime: {systemHealth.Uptime}");

foreach (var check in systemHealth.Checks)
{
    Console.WriteLine($"{check.Component}: {check.Status} - {check.Message}");
}

// Manual data corruption check
var monitor = new DataCorruptionMonitor(database);
monitor.TriggerImmediateCheck();
```

## Dependencies

- C0MMON/Infrastructure: IMongoDatabaseProvider, ICircuitBreaker
- C0MMON/Interfaces: IUnitOfWork
- C0MMON/Entities: Signal entity

## Integration

- Logs to EV3NT collection (DataCorruptionMonitor)
- Updates dashboard status via SystemHealth
- Circuit breaker prevents cascade failures
- Signal queue health impacts overall system status
