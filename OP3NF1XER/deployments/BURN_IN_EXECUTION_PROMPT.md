# OPENFIXER DEPLOYMENT: 24-HOUR BURN-IN EXECUTION

**Decision**: DECISION_047 - Parallel H4ND Execution  
**Status**: Ready for Burn-In  
**Priority**: CRITICAL  
**Command**: `H4ND.exe BURN-IN`

---

## CONTEXT

The infrastructure phase is COMPLETE. 252/252 tests passing. All monitoring, alerting, and automation in place. We are executing the 24-hour burn-in validation to prove the system works.

**This is the moment we transition from building to proving.**

---

## YOUR MISSION

Execute the 24-hour burn-in and monitor it for the first 30 minutes to ensure stable operation. Report back critical metrics and confirmation that the system is running.

---

## EXECUTION STEPS

### Step 1: Pre-Flight Checks (5 minutes)

Verify system readiness:

```bash
# Check 1: Chrome CDP accessible
curl -s http://192.168.56.1:9222/json/version | head -5

# Check 2: MongoDB connected  
mongo mongodb://192.168.56.1:27017/P4NTH30N --eval "db.runCommand({ping: 1})" --quiet

# Check 3: Dashboard server ready
curl -s http://localhost:5002/health

# Check 4: Signal count in SIGN4L
mongo mongodb://192.168.56.1:27017/P4NTH30N --eval "db.SIGN4L.countDocuments()" --quiet
```

**If any check fails**: STOP and report immediately. Do not proceed.

### Step 2: Launch Burn-In

```bash
cd C:\P4NTH30N\H4ND
H4ND.exe BURN-IN
```

**Expected output**:
- Pre-flight checks pass
- Chrome auto-starts (if not running)
- Signals generate (if SIGN4L empty)
- 5 workers initialize
- Burn-in begins with timestamp

### Step 3: Monitor First 30 Minutes

**Terminal 1**: Let H4ND.exe BURN-IN run (don't interrupt)

**Terminal 2**: Monitor dashboard every 60 seconds:

```bash
# Watch command (runs every 60 seconds)
watch -n 60 'curl -s http://localhost:5002/monitor/burnin | jq .'
```

**Or manual checks**:
```bash
# Check 1: Overall status
curl -s http://localhost:5002/monitor/burnin | jq '.status, .progress.percentComplete, .metrics.throughput'

# Check 2: Worker health
curl -s http://localhost:5002/monitor/burnin | jq '.workers[] | {id, status, signalsProcessed}'

# Check 3: Alert status
curl -s http://localhost:5002/monitor/burnin | jq '.alerts.active[]'
```

### Step 4: Verify Critical Metrics (at 5, 15, 30 minute marks)

**At 5 minutes**:
- Workers running: 5
- Signals processing: >0
- Error rate: <2%
- Chrome status: healthy

**At 15 minutes**:
- Throughput: >5x sequential baseline
- Memory: stable (growth <20MB)
- No CRITICAL alerts

**At 30 minutes**:
- System stable
- All workers healthy
- Ready for 24-hour unattended run

---

## SUCCESS CRITERIA

**For this deployment (first 30 minutes)**:
- [ ] Pre-flight checks pass
- [ ] Burn-in launches without errors
- [ ] 5 workers initialize and start processing
- [ ] Dashboard responds with valid JSON
- [ ] Throughput >5x sequential
- [ ] Error rate <2%
- [ ] Memory growth <50MB
- [ ] No CRITICAL alerts
- [ ] Chrome stable (0-1 restarts)

**If all criteria met**: Report "BURN-IN STABLE - Ready for 24-hour run"

**If any criteria fail**: Report immediately with details

---

## WHAT TO REPORT BACK

After 30 minutes of monitoring, report:

```
BURN-IN STATUS: [STABLE/UNSTABLE/FAILED]

Metrics at 30 minutes:
- Workers running: [N]
- Signals processed: [N]
- Throughput: [N]x sequential
- Error rate: [N]%
- Memory usage: [N]MB
- Chrome restarts: [N]
- Active alerts: [list or NONE]

Issues encountered: [list or NONE]

Recommendation: [CONTINUE 24HR / STOP AND FIX]
```

---

## CRITICAL: DO NOT

- Do NOT stop the burn-in once started (unless CRITICAL alert)
- Do NOT modify code during burn-in
- Do NOT restart services unless absolutely necessary
- Do NOT leave without reporting status

## CRITICAL: DO

- DO monitor dashboard every 60 seconds
- DO report any CRITICAL alerts immediately
- DO verify metrics at 5, 15, 30 minute marks
- DO confirm stable operation before reporting success

---

## FALLBACKS

**If Chrome fails to start**:
- Check CDP port: `netstat -an | findstr 9222`
- Manual start: `chrome.exe --remote-debugging-port=9222`
- Re-run burn-in

**If MongoDB connection fails**:
- Verify MongoDB service: `sc query MongoDB`
- Check connection string: `mongodb://192.168.56.1:27017/P4NTH30N`
- Report failure - cannot proceed without database

**If dashboard unavailable**:
- Check port 5002: `netstat -an | findstr 5002`
- Verify BurnInDashboardServer is running
- Report issue but continue if burn-in output shows progress

---

## CONTEXT FOR SUCCESS

This burn-in validates:
1. Parallel execution works (DECISION_047)
2. Chrome automation is stable (DECISION_056)
3. Monitoring captures metrics (DECISION_057)
4. Alerts protect the system (DECISION_058)
5. Post-burn-in automation will work (DECISION_059)

**If this 30-minute check passes, the system is ready for 24-hour unattended operation.**

---

**Execute now. Report in 30 minutes.**

**Strategist Pyxis**  
**Round R020 - Burn-In Execution**
