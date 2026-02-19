# CI Sync Validation & Health Metrics

> **Staleness**: 30 days (runbook-tier)
> **Last Reviewed**: 2026-02-18
> **Owner**: Oracle

---

## 1. CI/CD Pipeline Validation

### Build Gate

```yaml
# .github/workflows/pr-validation.yml gates
steps:
  - dotnet restore P4NTH30N.slnx
  - dotnet build P4NTH30N.slnx --no-restore
  - dotnet test UNI7T35T/UNI7T35T.csproj --no-build
  - dotnet csharpier check
```

**Pass Criteria**:
| Step | Expected | Failure Action |
|------|----------|---------------|
| Restore | Exit 0, all packages resolved | Check NuGet sources, package versions |
| Build | Exit 0, 0 errors | Fix compilation errors before merge |
| Test | Exit 0, all tests pass | Fix failing tests, do NOT delete tests |
| Format | Exit 0, no diff | Run `dotnet csharpier .` locally |

### Test Coverage Baseline

| Suite | Test Count | Category |
|-------|-----------|----------|
| ForecastingService | 2 | H0UND core |
| EncryptionService | 9 | Security / INFRA-009 |
| IdempotentSignal | 29 | H0UND signals / ADR-002 |
| PipelineIntegration | 16 | W4TCHD0G pipeline / WIN-001 |
| **CircuitBreaker** | **4** | **H0UND resilience / PROD-003** |
| **DpdCalculator** | **15** | **H0UND forecasting / PROD-003** |
| **SignalService** | **13** | **H0UND signals / PROD-003** |
| **Total** | **88** | |

### Sync Validation Checks

Run after any code change that affects test infrastructure:

```powershell
# 1. Verify all test files compile
dotnet build UNI7T35T/UNI7T35T.csproj --no-restore

# 2. Verify all tests are wired into Program.cs
# Each test class with RunAll() must be called in Program.cs
dotnet run --project UNI7T35T/UNI7T35T.csproj 2>&1 | Select-String "TEST SUMMARY"
# Expected: TEST SUMMARY: N/N tests passed (N = total count)

# 3. Verify no test regressions
dotnet run --project UNI7T35T/UNI7T35T.csproj 2>&1 | Select-String "FAIL"
# Expected: No FAIL lines
```

---

## 2. Health Metrics Dashboard

### H0UND Metrics

| Metric | Source | Healthy | Warning | Critical |
|--------|--------|---------|---------|----------|
| Poll success rate | Dashboard counters | >95% | 80–95% | <80% |
| API circuit state | `s_apiCircuit.State` | Closed | HalfOpen | Open |
| Mongo circuit state | `s_mongoCircuit.State` | Closed | HalfOpen | Open |
| Signal gen latency | `SignalMetrics` | <100ms | 100–500ms | >500ms |
| Lock contention rate | `SignalMetrics.LockContentions` | <5% | 5–20% | >20% |
| Dead-lettered signals | `SignalMetrics.DeadLettered` | 0 | 1–3 | >3 |
| DPD validation errors | `ERR0R` collection | 0/hr | 1–5/hr | >5/hr |

### H4ND Metrics

| Metric | Source | Healthy | Warning | Critical |
|--------|--------|---------|---------|----------|
| Signal ack latency | Timestamp diff | <1s | 1–5s | >5s |
| Login success rate | Console log analysis | >90% | 70–90% | <70% |
| Balance read validity | `IsValid()` pass rate | >99% | 95–99% | <95% |
| Browser restarts | Counter per hour | 0 | 1–2 | >2 |
| Spin execution rate | Spins per hour | >0 (if signals) | 0 (signals exist) | Stuck |

### MongoDB Health

| Metric | Query | Healthy | Critical |
|--------|-------|---------|----------|
| Stale credentials | `CRED3N7IAL.find({Enabled:true, LastUpdated:{$lt: -24h}})` | 0 | >0 |
| Pending signals | `SIGN4L.countDocuments({Acknowledged:false})` | <10 | >50 |
| Error rate | `ERR0R.countDocuments({Timestamp:{$gt: -1h}})` | 0 | >5 |
| Collection sizes | `db.stats()` | Stable | Sudden spike |

---

## 3. Alerting Thresholds

### Automated Checks (future implementation)

```
IF api_circuit.State == Open FOR > 5 minutes
  → Log P1 alert, restart H0UND

IF signal_queue.count > 50 AND h4nd.running == false
  → Log P0 alert, investigate H4ND

IF error_rate > 10/hour
  → Log P1 alert, check data quality

IF test_count < 88 (current baseline)
  → Block PR merge, tests may have been deleted
```

### Manual Health Check Cadence

| Check | Frequency | Command |
|-------|-----------|---------|
| Test suite passes | Every PR | `dotnet test UNI7T35T/UNI7T35T.csproj` |
| Format compliance | Every PR | `dotnet csharpier check` |
| ERR0R collection review | Daily | MongoDB query (see Monitoring section) |
| Credential staleness | Daily | MongoDB query |
| Signal queue depth | Hourly (during operations) | MongoDB query |
