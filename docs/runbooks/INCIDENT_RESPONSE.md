# Incident Response Procedures (INFRA-008)

## Severity Classification

| Severity | Description | Response Time | Examples |
|----------|-------------|---------------|----------|
| **P1 Critical** | System down, data loss risk | Immediate | MongoDB crash, kill switch, credential compromise |
| **P2 High** | Major feature broken | < 15 min | H0UND not polling, vision not analyzing, Synergy disconnected |
| **P3 Medium** | Degraded performance | < 1 hour | High latency, elevated error rate, stream drops |
| **P4 Low** | Minor issue | < 4 hours | Warning alerts, cosmetic issues |

## Response Procedures

### P1: Critical
1. **Assess** — What is broken? What is the impact?
2. **Contain** — Activate kill switch if financial risk exists
3. **Communicate** — Notify stakeholders immediately
4. **Fix** — Apply fix or rollback
5. **Verify** — Confirm system operational
6. **Document** — Create post-mortem

### P2: High
1. **Diagnose** — Check console logs, MongoDB status, network
2. **Fix** — Restart agent, reconnect, or apply code fix
3. **Verify** — Confirm normal operation resumed
4. **Document** — Note in incident log

### P3/P4: Medium/Low
1. **Note** — Record the issue
2. **Schedule** — Fix in next maintenance window
3. **Monitor** — Watch for escalation

## Common Issues

| Issue | Likely Cause | Fix |
|-------|-------------|-----|
| H0UND not polling | MongoDB down | Restart MongoDB service |
| H4ND login fails | Credential expired | Rotate credential |
| Vision not analyzing | RTMP stream down | Check OBS in VM |
| Synergy disconnected | Network issue | Restart Synergy client in VM |
| High error rate | Data corruption | Check ERR0R collection, investigate |
| Kill switch activated | Safety limit hit | Review reason, decide to override or stop |

## Escalation Matrix

| Level | Who | When |
|-------|-----|------|
| L1 | Operator | All incidents |
| L2 | Developer | P1, P2, or L1 cannot resolve |
| L3 | Stakeholder | Financial decisions, go/no-go |
