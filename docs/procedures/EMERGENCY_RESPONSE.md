# Emergency Response Procedures

## Severity Levels

| Level | Trigger | Response Time | Action |
|-------|---------|---------------|--------|
| **P1 - Critical** | Kill switch activated, credential compromised | Immediate | Stop all automation |
| **P2 - High** | Balance depleted, repeated errors | < 5 minutes | Investigate and decide |
| **P3 - Medium** | High latency, drop rate elevated | < 15 minutes | Monitor closely |
| **P4 - Low** | Warning alerts, threshold approaching | < 1 hour | Note and review |

## P1: Critical Emergency

### Kill Switch Activated
1. **DO NOT** panic — the system has safely stopped
2. Read the kill switch reason from console
3. Record current balance immediately
4. Assess whether the trigger was correct or false positive
5. If correct: End session, review in detail
6. If false positive: Document and consider override (with approval)

### Credential Compromised
1. **Immediately** change password on casino website
2. Disable the credential in MongoDB: `Enabled: false`
3. Rotate the master encryption key if needed
4. Review access logs
5. Re-encrypt with new credentials after securing

### System Crash
1. Check if casino game is still running in VM
2. If game is mid-spin, wait for completion
3. Record current balance from VM
4. Restart automation only after root cause identified

## P2: High Severity

### Balance Depleted Below Minimum
1. Safety monitor should have caught this — verify kill switch is active
2. Record final balance
3. End session
4. Review spending pattern for anomalies

### Repeated Errors in Console
1. Check RTMP stream connectivity
2. Check Synergy connection
3. Check OBS status in VM
4. If errors persist > 2 minutes: Stop automation
5. Restart subsystems one at a time

## Contact Chain

| Role | Action |
|------|--------|
| **Operator** | First response, monitoring, kill switch |
| **Developer** | System issues, code problems |
| **Stakeholder** | Financial decisions, session approval |

## Kill Switch Override Procedure

**ONLY** override the kill switch when:
1. Root cause of trigger is understood
2. The trigger was a false positive, OR
3. Stakeholder explicitly approves resumption

```
Override code: CONFIRM-RESUME-P4NTH30N
```

**Document every override** with:
- Date/time
- Original trigger reason
- Why override was approved
- Who approved it
