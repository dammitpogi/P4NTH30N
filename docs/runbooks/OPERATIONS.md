# P4NTHE0N Operations Runbook

> **Staleness**: 30 days (runbook-tier)
> **Last Reviewed**: 2026-02-18
> **Owner**: Oracle

---

## 1. Daily Operations

### 1.1 Pre-flight Check

**Success Criteria**: All checks pass, agents ready to start.

```powershell
# 1. Verify MongoDB connection
mongosh --eval "db.adminCommand('ping')"
# Expected: { ok: 1 }

# 2. Build verification
dotnet build P4NTHE0N.slnx --no-restore
# Expected: Build succeeded, 0 errors

# 3. Test gate
dotnet test UNI7T35T/UNI7T35T.csproj
# Expected: All tests pass (exit code 0)

# 4. Credential health
# Check CRED3N7IAL collection for enabled, non-banned accounts with balance > 0
```

### 1.2 Start H0UND

```powershell
dotnet run --project H0UND/H0UND.csproj
```

**Success Criteria**:
- Dashboard renders without errors
- First credential polled within 30 seconds
- Circuit breakers remain Closed
- No ERR0R entries in first 5 minutes

### 1.3 Start H4ND

```powershell
dotnet run --project H4ND/H4ND.csproj
```

**Success Criteria**:
- Browser driver initializes
- First signal acknowledged within 60 seconds (if signals exist)
- Login succeeds on first attempt
- Balance reads validate successfully

---

## 2. Troubleshooting Decision Trees

### 2.1 H0UND Not Polling

```
H0UND not polling credentials
├─ Is MongoDB reachable?
│  ├─ NO → Check mongod service, connection string in appsettings.json
│  └─ YES
│     ├─ Is circuit breaker Open?
│     │  ├─ YES → Check API endpoint health, wait for recovery timeout
│     │  └─ NO
│     │     ├─ Are credentials Enabled=true and Unlocked=true?
│     │     │  ├─ NO → Check UnlockTimeout, run credential unlock script
│     │     │  └─ YES
│     │     │     └─ Check console for exception messages
│     │     │        └─ Log line numbers to identify failure point
│     │     └─ Is credential locked by another instance?
│     │        └─ Check Unlocked field + UnlockTimeout
│     └─ Check ERR0R collection for recent validation failures
```

### 2.2 Signals Not Generating

```
Signals not being generated
├─ Are jackpots being predicted?
│  ├─ NO → Check ForecastingService, DPD data quality
│  └─ YES
│     ├─ Is any jackpot isDue?
│     │  ├─ NO → Check ETA vs current time, threshold proximity, balance
│     │  │  ├─ ETA too far → DPD too low or jackpot far from threshold
│     │  │  ├─ Threshold not met → Current < Threshold - 0.1
│     │  │  └─ Balance too low → avgBalance < required for time window
│     │  └─ YES
│     │     ├─ Is distributed lock acquired?
│     │     │  ├─ NO → Another H0UND instance holds lock, check contention metrics
│     │     │  └─ YES → Check dedup cache (signal already processed?)
│     │     └─ Is circuit breaker tripping?
│     │        └─ Check CircuitBreakerTrips metric
│     └─ Check SIGN4L collection directly in MongoDB
```

### 2.3 H4ND Login Failures

```
H4ND cannot log in
├─ Is the portal URL reachable?
│  ├─ NO → Portal may be down, check URL in CRED3N7IAL
│  └─ YES
│     ├─ Are credentials correct?
│     │  ├─ NO → Update CRED3N7IAL with correct username/password
│     │  └─ YES
│     │     ├─ Is ChromeDriver version compatible?
│     │     │  ├─ NO → Update chromedriver.exe in PROF3T/drivers/
│     │     │  └─ YES
│     │     │     ├─ Is RUL3S extension loaded?
│     │     │     │  └─ Check resource_override_rules.json
│     │     │     └─ Is the portal blocking automation?
│     │     │        └─ Check for CAPTCHAs, IP blocks, session limits
│     │     └─ Check browser console for JavaScript errors
│     └─ Is the account banned?
│        └─ Check CRED3N7IAL.Banned field
```

### 2.4 Invalid Balance/Jackpot Reads

```
Balance or jackpot values invalid (NaN, negative, zero)
├─ Is the JavaScript selector correct?
│  ├─ NO → Portal DOM may have changed, update selectors in RUL3S
│  └─ YES
│     ├─ Is the page fully loaded?
│     │  ├─ NO → Increase wait timeout before reads
│     │  └─ YES
│     │     ├─ Did the Credential.Balance setter reject the value?
│     │     │  └─ Check console for "Invalid balance rejected" or "Negative balance rejected"
│     │     └─ Check ERR0R collection for ValidationError entries
│     └─ Is the portal displaying maintenance page?
│        └─ Check page title/content before reading values
```

---

## 3. Recovery Procedures

### 3.1 Circuit Breaker Stuck Open

1. Identify which circuit (`s_apiCircuit` or `s_mongoCircuit`)
2. Check underlying service health
3. If service is healthy, restart H0UND to reset circuit breakers
4. Monitor for recurring trips — if persistent, escalate to P1

### 3.2 Credential Lock Deadlock

1. Query `CRED3N7IAL` for `Unlocked=false` with `UnlockTimeout` in the past
2. Force unlock via MongoDB: `db.CRED3N7IAL.updateMany({Unlocked: false, UnlockTimeout: {$lt: new Date()}}, {$set: {Unlocked: true}})`
3. Investigate which process failed to release lock (check ERR0R collection)

### 3.3 Signal Queue Backup

1. Check `SIGN4L` collection count
2. If signals accumulating: verify H4ND is running and acknowledging
3. Cleanup stale signals: `SignalService.CleanupStaleSignals()`
4. If H4ND is crashed, restart and verify browser initialization

### 3.4 MongoDB Connection Lost

1. Verify `mongod` service: `Get-Service mongod`
2. Check connection string in `appsettings.json`
3. Restart agents after MongoDB is restored
4. Verify data integrity: check ERR0R collection for corruption entries

---

## 4. Monitoring Queries

```javascript
// Recent errors (last hour)
db.ERR0R.find({ Timestamp: { $gt: new Date(Date.now() - 3600000) } }).sort({ Timestamp: -1 })

// Stale credentials (not updated in 24h)
db.CRED3N7IAL.find({ Enabled: true, LastUpdated: { $lt: new Date(Date.now() - 86400000) } })

// Pending signals
db.SIGN4L.find({ Acknowledged: false }).sort({ Priority: -1 })

// Jackpot ETAs within 2 hours
db.J4CKP0T.find({ EstimatedDate: { $lt: new Date(Date.now() + 7200000) } }).sort({ EstimatedDate: 1 })
```
