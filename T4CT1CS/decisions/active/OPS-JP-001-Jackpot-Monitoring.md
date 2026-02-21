# OPS-JP-001: Jackpot Operational Monitoring

**Decision ID**: OPS-JP-001  
**Category**: Operations  
**Status**: Proposed  
**Priority**: High  
**Date**: 2026-02-20  

---

## Executive Summary

Define monitoring and alerting for the jackpot automation system. Track key metrics: spins executed, wins detected, balance changes, CDP health, and system errors.

**Current State**:
- ERR0R collection captures validation failures
- Dashboard displays current jackpots

**Target State**:
- Real-time monitoring of spin activity
- Alerts for failures and anomalies
- Daily/weekly performance reports

---

## Metrics to Track

### Spin Activity

| Metric | Description | Target |
|--------|-------------|--------|
| SpinsPerHour | Number of spins executed per hour | > 0 when signals present |
| SpinSuccessRate | Percentage of successful spins | > 95% |
| AvgSpinLatency | Time from signal to spin completion | < 5 seconds |
| DuplicateSpinRejections | Spins blocked by idempotency | Track but minimize |

### Financial

| Metric | Description | Target |
|--------|-------------|--------|
| BalanceChange | Net change in account balance | > 0 (profitable) |
| SpinCost | Estimated cost per spin (time/credits) | Track |
| WinRate | Percentage of spins resulting in wins | Track for optimization |

### System Health

| Metric | Description | Target |
|--------|-------------|--------|
| CdpUpTime | Percentage of time CDP is connected | > 99% |
| CdpReconnects | Number of CDP reconnection events | < 5 per hour |
| ErrorRate | Commands resulting in error | < 1% |
| SignalQueueDepth | Number of unprocessed signals | Near 0 |

---

## Implementation

### Metrics Collection

Create `H4ND/Infrastructure/SpinMetrics.cs`:

```csharp
public sealed class SpinMetrics
{
    private readonly ConcurrentQueue<SpinRecord> _spins = new();
    
    public void RecordSpin(SpinRecord record)
    {
        _spins.Enqueue(record);
        
        // Keep last 1000 spins
        while (_spins.Count > 1000)
            _spins.TryDequeue(out _);
    }
    
    public SpinMetricsSummary GetSummary(TimeSpan window)
    {
        var cutoff = DateTime.UtcNow - window;
        var recent = _spins.Where(s => s.Timestamp > cutoff).ToList();
        
        return new SpinMetricsSummary
        {
            TotalSpins = recent.Count,
            SuccessfulSpins = recent.Count(s => s.Success),
            AvgLatencyMs = recent.Average(s => s.LatencyMs),
            NetBalanceChange = recent.Sum(s => s.BalanceChange)
        };
    }
}

public record SpinRecord
{
    public DateTime Timestamp { get; init; }
    public string Username { get; init; }
    public string Game { get; init; }
    public bool Success { get; init; }
    public int LatencyMs { get; init; }
    public double BalanceChange { get; init; }
    public string? ErrorMessage { get; init; }
}
```

### Health Endpoint

Expose metrics via HTTP for monitoring:

```csharp
// Simple HTTP endpoint for Prometheus scraping
app.MapGet("/metrics", () =>
{
    var summary = _metrics.GetSummary(TimeSpan.FromHours(1));
    return Results.Ok(new
    {
        spins_total = summary.TotalSpins,
        spins_success_rate = summary.SuccessfulSpins / summary.TotalSpins,
        avg_latency_ms = summary.AvgLatencyMs,
        net_balance_change = summary.NetBalanceChange
    });
});
```

### Alerting Rules

| Condition | Severity | Action |
|-----------|----------|--------|
| CdpUpTime < 95% | Warning | Log to console |
| CdpUpTime < 90% | Critical | Alert operator, fallback to Selenium |
| ErrorRate > 5% | Warning | Log to ERR0R |
| SignalQueueDepth > 10 | Warning | Log, investigate H0UND |
| BalanceNegative | Critical | Pause spins, alert immediately |

---

## Dashboard Updates

Update existing Dashboard to include:

```
╔══════════════════════════════════════════════════════════════╗
║                    JACKPOT OPS MONITOR                     ║
╠══════════════════════════════════════════════════════════════╣
║  Spins (1h): 47 | Success: 95.7% | Latency: 3.2s          ║
║  Balance: +$127.50 (net) | WinRate: 12.8%                  ║
║  CDP: CONNECTED | Reconnects: 2 | Errors: 1                ║
║  Queue: 0 signals                                          ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Success Criteria

- [ ] Spin metrics collected and stored
- [ ] Dashboard shows real-time metrics
- [ ] Alerts trigger on threshold violations
- [ ] Daily report generated

---

*OPS-JP-001: Jackpot Operational Monitoring*  
*Status: Proposed*  
*2026-02-20*
