---
type: decision
id: DECISION_058
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.693Z'
last_reviewed: '2026-02-23T01:31:15.693Z'
keywords:
  - decision058
  - burnin
  - alert
  - thresholds
  - and
  - escalation
  - executive
  - summary
  - specification
  - severity
  - levels
  - threshold
  - configuration
  - halt
  - behavior
  - posthalt
  - diagnostic
  - data
  - action
  - items
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: MON-058 **Category**: MON (Monitoring) **Priority**: Critical
  **Status**: Completed **Oracle Approval**: 93% (Assimilated) **Designer
  Approval**: 94% (Assimilated)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_058.md
---
# DECISION_058: Burn-In Alert Thresholds and Escalation

**Decision ID**: MON-058  
**Category**: MON (Monitoring)  
**Priority**: Critical  
**Status**: Completed  
**Oracle Approval**: 93% (Assimilated)  
**Designer Approval**: 94% (Assimilated)

---

## Executive Summary

The 24-hour burn-in must halt on critical failures, but not all anomalies require stopping. This decision defines alert severity levels, automatic halt conditions, and escalation procedures to ensure the burn-in runs unattended while protecting against data corruption or runaway errors.

**Current Problem**:
- Burn-in halts only on duplication detection or error rate >10%
- No early warning system for degrading conditions
- No distinction between recoverable errors and critical failures
- Operator not notified when burn-in halts
- No escalation path for investigation

**Proposed Solution**:
- Three-tier alert system: INFO (log only), WARN (notify, continue), CRITICAL (halt, alert)
- Configurable thresholds for each metric
- Automatic halt on: signal duplication, error rate >10%, memory >500MB, Chrome restart count >5
- Notification channels: console, WebSocket, file log, optional SMS/email
- Post-halt diagnostic dump for root cause analysis

---

## Specification

### Alert Severity Levels

**INFO (Green)** - Log only, no action
- Single worker restart
- Selector fallback used
- Session renewal success
- Signal claimed and processed

**WARN (Yellow)** - Notify operator, continue burn-in
- Error rate 5-10% (3 consecutive checks)
- Memory growth >50MB/hour
- Chrome restarted 2-3 times
- Platform response time >500ms
- Signal backlog >20 (processing slower than generating)

**CRITICAL (Red)** - Halt burn-in immediately, alert operator
- Signal duplication detected
- Error rate >10%
- Memory usage >500MB
- Chrome restarted >5 times
- Both platforms unreachable
- Worker deadlock detected

### Threshold Configuration

```json
{
  "P4NTHE0N": {
    "H4ND": {
      "BurnInAlerts": {
        "ErrorRateWarnThreshold": 0.05,
        "ErrorRateWarnConsecutiveChecks": 3,
        "ErrorRateCriticalThreshold": 0.10,
        "MemoryGrowthWarnMBPerHour": 50,
        "MemoryCriticalThresholdMB": 500,
        "ChromeRestartWarnCount": 2,
        "ChromeRestartCriticalCount": 5,
        "PlatformResponseWarnMs": 500,
        "SignalBacklogWarnCount": 20,
        "NotificationChannels": ["Console", "WebSocket", "File"]
      }
    }
  }
}
```

### Halt Behavior

1. **Immediate Stop**: Workers finish current spin, no new claims
2. **Diagnostic Dump**: Save full state to BURN_IN_HALT_DIAGNOSTICS collection
3. **Notification**: Send CRITICAL alert through all channels
4. **Unlock Credentials**: Release all locked credentials
5. **Release Claims**: Unclaim all pending signals
6. **Final Report**: Generate summary with halt reason and recommendations

### Post-Halt Diagnostic Data

```json
{
  "sessionId": "burnin-20260221-080000",
  "haltTime": "2026-02-21T14:30:00Z",
  "haltReason": "ErrorRateCritical",
  "haltTrigger": "Error rate 12.5% exceeded threshold 10%",
  "durationHours": 6.5,
  "signalsProcessed": 127,
  "finalMetrics": { /* full metrics snapshot */ },
  "recentErrors": [ /* last 20 errors */ ],
  "workerStates": [ /* state of each worker */ ],
  "chromeLogs": [ /* Chrome stdout/stderr */ ],
  "recommendations": [
    "Investigate FireKirin platform stability",
    "Consider reducing worker count from 5 to 3",
    "Check credential validity for houses: HouseA, HouseC"
  ]
}
```

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-058-001 | Create BurnInAlertThresholds config | @windfixer | Pending | Critical |
| ACT-058-002 | Create AlertSeverity enum and Alert class | @windfixer | Pending | Critical |
| ACT-058-003 | Create BurnInAlertEvaluator service | @windfixer | Pending | Critical |
| ACT-058-004 | Create notification dispatcher | @windfixer | Pending | Critical |
| ACT-058-005 | Implement halt logic with diagnostic dump | @windfixer | Pending | Critical |
| ACT-058-006 | Create recommendation engine | @windfixer | Pending | High |

---

## Success Criteria

1. Burn-in halts within 10 seconds of critical condition detection
2. WARN alerts notify without stopping execution
3. Diagnostic dump contains sufficient data for root cause analysis
4. Recommendations generated based on halt pattern
5. All notifications delivered through configured channels

---

## Research Foundation

### ArXiv Papers Referenced

This decision incorporates findings from peer-reviewed research on alert systems and anomaly detection:

**[arXiv:2405.15135] Neural Surveillance: Live-Update Visualization of Latent Training Dynamics**  
*Xianglin Yang, Jin Song Dong* - Demonstrates geometry-based alerting (anomaly detection) outperforms threshold-based alerting. Successfully identified impending failure up to 7 epochs earlier than validation loss. Critical insight: monitoring internal state enables proactive intervention before threshold breaches.

**[arXiv:2602.09126] An Interactive Metrics Dashboard for the Keck Observatory Archive**  
*G. Bruce Berriman, Min Phone Myat Zaw* - Shows importance of configurable thresholds for different operational contexts. Near-real-time alerting with multiple severity levels prevents alert fatigue while ensuring critical issues are escalated.

**[arXiv:2105.10326] NetGraf: A Collaborative Network Monitoring Stack**  
*Divneet Kaur et al.* - Alert aggregation across multiple sources with unified notification channels. Addresses alert fatigue through severity classification and routing rules.

### Research-Backed Alert Design

Based on these papers, the alert system implements:

1. **Three-Tier Severity** - INFO/WARN/CRITICAL classification prevents alert fatigue while ensuring critical issues surface
2. **Internal State Monitoring** - Track Chrome restarts, memory growth patterns (leading indicators) not just error rates (lagging indicators)
3. **Consecutive Check Thresholds** - Require 3 consecutive WARN checks before alerting (reduces false positives)
4. **Diagnostic Dump on Halt** - Capture full state for root cause analysis (research shows post-hoc investigation requires rich context)
5. **Recommendation Engine** - Generate actionable guidance based on halt patterns

### Future Enhancement: Geometry-Based Anomaly Detection

Per [arXiv:2405.15135], threshold-based alerting can be enhanced with geometry-based anomaly detection:
- Monitor metric trajectories, not just point-in-time values
- Detect divergence from normal operational "shape"
- Alert on impending failure before threshold breach
- Implementation: Track error rate slope, memory growth acceleration

---

## Token Budget

- **Estimated**: 25,000 tokens
- **Model**: Claude 3.5 Sonnet
- **Budget Category**: Critical

---

*Decision MON-058*  
*Burn-In Alert Thresholds and Escalation*  
*2026-02-21*
