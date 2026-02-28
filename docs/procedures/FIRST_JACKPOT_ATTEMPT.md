# First Jackpot Attempt Procedures (WIN-007)

## Pre-Flight Checklist

Complete ALL items before starting the first attempt. Any unchecked item = NO GO.

### Systems
- [ ] MongoDB running and accessible
- [ ] H0UND agent running (verify with `--dry-run`)
- [ ] FourEyes agent initialized (stream receiving, vision processing)
- [ ] Synergy connection to VM verified (test mouse move)
- [ ] OBS streaming from VM to host (RTMP on port 1935)
- [ ] Safety monitor active with configured limits
- [ ] Win detector active and alert service configured

### Configuration
- [ ] Jackpot thresholds calibrated (WIN-006)
- [ ] Daily loss limit set (recommend $50 for first attempt)
- [ ] Consecutive loss limit set (recommend 10)
- [ ] Kill switch override code documented
- [ ] Correct casino credentials loaded and verified

### Environment
- [ ] VM Chrome logged into casino account
- [ ] Casino game loaded and visible in OBS capture
- [ ] Account balance confirmed (minimum $50 recommended)
- [ ] No pending casino promotions/popups blocking game
- [ ] Stable internet connection on both host and VM

### Monitoring
- [ ] Console output visible on host
- [ ] Win event log file path confirmed
- [ ] Webhook alerts configured (if using Slack/Discord)
- [ ] Screenshot directory has write permission

## Execution Procedures

### T-10 Minutes: Final Preparation
1. Open terminal on host, navigate to P4NTHE0N directory
2. Verify all pre-flight checks are GREEN
3. Note starting balance: $___________
4. Note start time: ___________
5. Notify stakeholders: "First attempt starting in 10 minutes"

### T-0: Start Automation
```powershell
# Start H0UND (if not already running)
dotnet run --project H0UND\H0UND.csproj

# Start FourEyes agent
# (starts RTMP receiver, vision processing, signal polling, Synergy actions)
```

### During Execution: Monitoring Protocol

**Every 1 minute:**
- Check console for errors
- Verify frame reception (no "Stream disconnected" messages)
- Check safety status (no alerts)

**Every 5 minutes:**
- Record current balance
- Check daily spend vs limit
- Verify game is still loaded (not timed out)

**Immediately on any alert:**
- Read the alert severity and metric
- If EMERGENCY → Follow Emergency Response below
- If CRITICAL → Prepare to stop, assess situation
- If WARNING → Note and continue monitoring

### Decision Tree

```
Is game loading/error screen?
  YES → Wait 30 seconds, if persists → STOP
  NO  → Continue

Is balance below minimum?
  YES → STOP (safety monitor should catch this)
  NO  → Continue

Is FourEyes clicking correctly?
  YES → Continue monitoring
  NO  → Check Synergy connection, restart if needed

Has a win been detected?
  YES → Follow Post-Win procedures
  NO  → Continue monitoring
```

## Emergency Response

### Kill Switch Activation (Automatic)
The safety monitor will automatically activate the kill switch when:
- Daily loss limit exceeded
- Consecutive loss limit exceeded
- Daily spend limit exceeded

**When kill switch activates:**
1. FourEyes immediately stops all actions
2. Note the reason from console output
3. Record current balance
4. Assess whether to resume or end session

### Manual Emergency Stop
```
# In the running terminal, press Ctrl+C
# Or from another terminal:
# The FourEyes agent handles graceful shutdown on cancellation
```

### Kill Switch Deactivation (Resume)
Only deactivate after understanding and addressing the trigger:
```csharp
// Override code: CONFIRM-RESUME-P4NTHE0N
safetyMonitor.DeactivateKillSwitch("CONFIRM-RESUME-P4NTHE0N");
```

## Post-Attempt Analysis

### Immediate (within 5 minutes of stopping)
1. Record final balance: $___________
2. Record end time: ___________
3. Calculate net result: Final - Starting = $___________
4. Check win event log: `win-events.log`
5. Check screenshots directory for win captures

### Detailed (within 1 hour)
1. Review total spins executed
2. Review total signals received
3. Calculate cost per spin
4. Review any errors or anomalies
5. Assess threshold accuracy (did signals fire at right times?)

### Report Template
```
First Jackpot Attempt Report
============================
Date: ___________
Duration: ___________ minutes
Starting Balance: $___________
Final Balance: $___________
Net Result: $___________
Total Spins: ___________
Signals Received: ___________
Actions Executed: ___________
Wins Detected: ___________
Jackpot Wins: ___________
Errors: ___________
Kill Switch Activated: YES/NO (reason: ___________)
```

## Lessons Learned

After each attempt, document:
1. What worked well
2. What needs improvement
3. Threshold adjustments needed
4. System reliability observations
5. Recommendations for next attempt
