# Production Go-Live Checklist (WIN-002)

## Go/No-Go Decision Matrix

All CRITICAL items must be GREEN. Any RED = NO GO.

| # | Category | Item | Status | Owner |
|---|----------|------|--------|-------|
| 1 | **Infrastructure** | MongoDB production instance running | ⬜ | Ops |
| 2 | **Infrastructure** | VM provisioned and configured (VM-002) | ⬜ | Ops |
| 3 | **Infrastructure** | OBS streaming from VM verified | ⬜ | Ops |
| 4 | **Infrastructure** | Synergy host↔VM connectivity verified | ⬜ | Ops |
| 5 | **Infrastructure** | Master encryption key deployed | ⬜ | Security |
| 6 | **Security** | Credentials encrypted in MongoDB | ⬜ | Security |
| 7 | **Security** | Test login succeeds | ⬜ | QA |
| 8 | **Safety** | Safety monitor configured (WIN-004) | ⬜ | Dev |
| 9 | **Safety** | Kill switch tested and working | ⬜ | QA |
| 10 | **Safety** | Daily loss limit set | ⬜ | Stakeholder |
| 11 | **Testing** | All 27 unit/integration tests passing | ⬜ | Dev |
| 12 | **Testing** | Dry run completed without errors | ⬜ | QA |
| 13 | **Monitoring** | Win detector active | ⬜ | Dev |
| 14 | **Monitoring** | Alert channels configured | ⬜ | Ops |
| 15 | **Config** | Thresholds calibrated (WIN-006) | ⬜ | Analyst |
| 16 | **Config** | Environment validation passing | ⬜ | Ops |
| 17 | **Approval** | Stakeholder sign-off obtained | ⬜ | Stakeholder |

## Deployment Steps

### 1. Environment Preparation (30 minutes)

```powershell
# Validate environment
.\scripts\setup\validate-environment.ps1 -Environment Production -Strict

# Verify build
dotnet build P4NTHE0N.slnx
dotnet run --project UNI7T35T\UNI7T35T.csproj

# Verify MongoDB
mongosh --eval "use P4NTHE0N; db.CRED3N7IAL.countDocuments()"
```

### 2. Agent Deployment (15 minutes)

```powershell
# Start H0UND (monitoring + signal generation)
dotnet run --project H0UND\H0UND.csproj

# Verify H0UND is polling
# Watch console for "[H0UND] Polling cycle complete" messages
```

### 3. FourEyes Activation (15 minutes)

```powershell
# Verify VM is ready
# - Chrome open with casino game loaded
# - OBS streaming to host
# - Synergy connected

# Start FourEyes (in separate terminal)
# FourEyes will connect to RTMP, start vision, begin automation loop
```

### 4. Monitoring Confirmation (5 minutes)

- [ ] Console shows frame reception
- [ ] Vision analysis producing results
- [ ] Safety monitor reporting status
- [ ] No error messages

### 5. Go-Live Authorization

```
GO-LIVE AUTHORIZATION
=====================
Date: ___________
Time: ___________
Authorized by: ___________
Starting balance: $___________
Daily loss limit: $___________
Session duration: ___________ hours
```

## Rollback Procedures

### Immediate Rollback (< 1 minute)
- Press Ctrl+C in FourEyes terminal
- Kill switch activates automatically on process exit

### Full Rollback (< 5 minutes)
1. Stop FourEyes agent
2. Stop H0UND agent
3. Stop VM OBS streaming
4. Document reason for rollback
5. Review logs for root cause

## Post-Deployment Monitoring

### First Hour
- Monitor every 5 minutes
- Record balance at each check
- Watch for anomalies

### First Day
- Hourly balance checks
- Review daily safety metrics
- Check for any credential issues

### First Week
- Daily performance review
- Threshold adjustment if needed
- System stability assessment
