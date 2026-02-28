# P4NTHE0N Operational Runbook

**Decision**: OPS-060  
**Last Updated**: 2026-02-21  
**Status**: Active

---

## Operational Modes

### Mode 1: Continuous Processing (Default)
```bash
H4ND.exe parallel --continuous
```
- Runs indefinitely until manually stopped
- Auto-generates signals when SIGN4L < 10
- Self-healing active (session renewal, Chrome auto-restart)
- Full monitoring enabled on port 5002

### Mode 2: Scheduled Batch
```bash
H4ND.exe parallel --schedule "0 */6 * * *"
```
- Runs for 1 hour every 6 hours
- Processes accumulated signals
- Graceful shutdown between batches

### Mode 3: Event-Driven
```bash
H4ND.exe parallel --trigger-jackpot-threshold 1000
```
- Monitors jackpot values continuously
- Only spins when jackpot > threshold

---

## Daily Operations

| Time | Task |
|------|------|
| 09:00 | Morning check: review overnight metrics via dashboard |
| 13:00 | Midday review: check signal backlog, worker health |
| 18:00 | Evening summary: daily performance report |
| 22:00 | Night handoff: verify all systems green |

### Dashboard Access
- **HTTP**: `http://localhost:5002/monitor/burnin`
- **Snapshots**: `http://localhost:5002/monitor/burnin/snapshots`
- **Health**: `http://localhost:5002/health`

---

## Weekly Operations

| Day | Task |
|-----|------|
| Monday | Credential health check, rotation if needed |
| Wednesday | Performance optimization review |
| Friday | Full system health check, backup verification |
| Sunday | Weekly performance report, trend analysis |

---

## Incident Response

| Severity | Response Time | Action |
|----------|---------------|--------|
| P0 - System Down | 15 minutes | Immediate investigation, manual intervention |
| P1 - Degraded | 1 hour | Analyze metrics, adjust workers, restart if needed |
| P2 - Warning | 4 hours | Review trends, plan optimization |
| P3 - Info | 24 hours | Log for weekly review |

### P0 Procedures

1. **Check dashboard**: `curl http://localhost:5002/monitor/burnin`
2. **Check Chrome**: `curl http://192.168.56.1:9222/json/version`
3. **Check MongoDB**: `mongosh --eval "db.adminCommand('ping')"`
4. **Restart if needed**: `H4ND.exe HEALTH` then restart appropriate mode

### P1 Procedures

1. Review alert logs in `logs/burnin-alerts-*.log`
2. Check worker stats in dashboard JSON
3. Adjust worker count in `appsettings.json` → `P4NTHE0N:H4ND:Parallel:WorkerCount`
4. Restart: `H4ND.exe BURN-IN` or `H4ND.exe PARALLEL`

---

## Success Metrics

| Metric | Target | Alert Threshold |
|--------|--------|-----------------|
| Uptime | 99.5% | <99% |
| Signals Processed/Day | 1000+ | <500 |
| Error Rate | <2% | >5% |
| Avg Spin Time | <45s | >60s |
| Credential Success Rate | >95% | <90% |
| Jackpot Read Accuracy | 100% | <100% |

---

## Credential Management

- **Production collection**: `CR3D3N7IAL_PR0D`
- **Test collection**: `CRED3N7IAL` (keep isolated)
- **Rotation**: Monthly or on ban detection
- **Monitoring**: Banned credential alerts via `BurnInAlertEvaluator`

---

## Backup Strategy

- **MongoDB**: Daily dumps via `scripts/backup/mongodb-backup.ps1`
- **Configuration**: Version controlled in git
- **Logs**: Retained for 30 days in `logs/` directory
- **Metrics**: `BURN_IN_METRICS` collection retained for 30 days

---

## Emergency Procedures

### Full System Stop
```powershell
# Stop all H4ND processes
Get-Process H4ND -ErrorAction SilentlyContinue | Stop-Process -Force
# Unlock all credentials
mongosh P4NTHE0N --eval "db.CRED3N7IAL.updateMany({Unlocked: false}, {\$set: {Unlocked: true}})"
# Release all signal claims
mongosh P4NTHE0N --eval "db.SIGN4L.updateMany({ClaimedBy: {\$ne: null}, Acknowledged: false}, {\$set: {ClaimedBy: null, ClaimedAt: null}})"
```

### Chrome Recovery
```powershell
# Kill stuck Chrome processes
Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force
# Clean temp profile
Remove-Item "C:\Users\paulc\AppData\Local\Temp\chrome_debug_*" -Recurse -Force
# H4ND will auto-restart Chrome via CdpLifecycleManager
```
