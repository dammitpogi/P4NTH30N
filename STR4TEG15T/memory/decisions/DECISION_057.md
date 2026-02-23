---
type: decision
id: DECISION_057
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.692Z'
last_reviewed: '2026-02-23T01:31:15.692Z'
keywords:
  - decision057
  - realtime
  - burnin
  - monitoring
  - dashboard
  - executive
  - summary
  - specification
  - requirements
  - technical
  - details
  - action
  - items
  - success
  - criteria
  - token
  - budget
  - research
  - foundation
  - arxiv
roles:
  - librarian
  - oracle
summary: >-
  **Decision ID**: MON-057 **Category**: MON (Monitoring) **Status**: Completed
  **Priority**: Critical **Date**: 2026-02-21 **Oracle Approval**: 94%
  (Assimilated) **Designer Approval**: 95% (Assimilated)
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_057.md
---
# DECISION_057: Real-Time Burn-In Monitoring Dashboard

**Decision ID**: MON-057  
**Category**: MON (Monitoring)  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-21  
**Oracle Approval**: 94% (Assimilated)  
**Designer Approval**: 95% (Assimilated)

---

## Executive Summary

The 24-hour burn-in will run unattended, but operators need visibility into system health, progress, and alerts. This decision creates a real-time monitoring dashboard that tracks burn-in metrics, displays worker status, shows signal throughput, and alerts on critical conditions.

**Current Problem**:
- Burn-in runs for 24 hours without human intervention
- No visibility into: worker health, signal processing rate, error trends
- Critical conditions (duplication, high error rate) only logged to console
- No way to track progress (% complete, estimated time remaining)
- No historical view of burn-in performance over time

**Proposed Solution**:
- BurnInMonitor service that collects metrics every 60 seconds
- Real-time dashboard accessible via HTTP endpoint
- WebSocket push notifications for critical alerts
- MongoDB collection for historical burn-in data
- CLI command `P4NTH30N.exe monitor` to attach to running burn-in

---

## Specification

### Requirements

1. **MON-057-001**: Metrics Collection
   - **Priority**: Must
   - **Acceptance Criteria**: Collect every 60 seconds: signals processed, signals pending, workers active, error count, memory usage, Chrome status, platform response times
   - **Implementation**: BurnInMonitor.BackgroundCollection loop

2. **MON-057-002**: Real-Time Dashboard HTTP Endpoint
   - **Priority**: Must
   - **Acceptance Criteria**: HTTP GET /monitor/burnin returns JSON with current status, progress %, ETA, recent errors, worker states
   - **Implementation**: Kestrel host on port 5002, BurnInController endpoint

3. **MON-057-003**: WebSocket Alert Push
   - **Priority**: Must
   - **Acceptance Criteria**: Critical events (duplication detected, error rate >10%, Chrome crash) push immediately to connected clients
   - **Implementation**: SignalR or raw WebSocket, alert queue

4. **MON-057-004**: Historical Data Storage
   - **Priority**: Must
   - **Acceptance Criteria**: All metrics stored in MongoDB BURN_IN_METRICS collection; queryable by burn-in session ID; retention policy 30 days
   - **Implementation**: IBurnInMetricsRepository, time-series storage

5. **MON-057-005**: CLI Monitor Attachment
   - **Priority**: Must
   - **Acceptance Criteria**: `P4NTH30N.exe monitor` connects to running burn-in, displays live updating dashboard in terminal
   - **Implementation**: ConsoleUI with periodic refresh, WebSocket client

6. **MON-057-006**: Progress Tracking
   - **Priority**: Should
   - **Acceptance Criteria**: Calculate % complete based on elapsed time vs 24-hour target; ETA calculation; signals/hour throughput
   - **Implementation**: BurnInProgressCalculator

### Technical Details

**Dashboard JSON Schema:**
```json
{
  "sessionId": "burnin-20260221-080000",
  "status": "Running|Paused|Halted|Completed",
  "progress": {
    "elapsedHours": 4.5,
    "totalHours": 24,
    "percentComplete": 18.75,
    "eta": "2026-02-22T08:00:00Z"
  },
  "signals": {
    "generated": 200,
    "processed": 89,
    "pending": 45,
    "claimed": 12,
    "acknowledged": 89,
    "throughputPerHour": 19.8
  },
  "workers": {
    "configured": 5,
    "active": 5,
    "status": ["Healthy", "Healthy", "Healthy", "Renewing", "Healthy"]
  },
  "errors": {
    "total": 3,
    "rate": 0.033,
    "recent": [
      {"time": "2026-02-21T08:30:00Z", "type": "403", "recovered": true}
    ]
  },
  "chrome": {
    "status": "Running",
    "pid": 12345,
    "restartCount": 0
  },
  "platforms": {
    "FireKirin": {"reachable": true, "avgResponseMs": 245},
    "OrionStars": {"reachable": true, "avgResponseMs": 189}
  }
}
```

**Files to Create:**
- H4ND/Monitoring/BurnInMonitor.cs
- H4ND/Monitoring/IBurnInMetricsRepository.cs
- H4ND/Monitoring/BurnInMetricsRepository.cs
- H4ND/Monitoring/BurnInProgressCalculator.cs
- H4ND/Monitoring/Models/BurnInStatus.cs
- H4ND/Monitoring/Models/BurnInMetricsSnapshot.cs
- H4ND/Monitoring/Hubs/BurnInHub.cs (SignalR)
- UNI7T35T/Tests/BurnInMonitorTests.cs

**Files to Modify:**
- H4ND/Services/BurnInController.cs - integrate monitoring
- H4ND/H4ND.cs - add monitor subcommand
- appsettings.json - add Monitoring section

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-057-001 | Create BurnInMonitor service | @windfixer | Pending | Critical |
| ACT-057-002 | Create metrics repository | @windfixer | Pending | Critical |
| ACT-057-003 | Create HTTP dashboard endpoint | @windfixer | Pending | Critical |
| ACT-057-004 | Create WebSocket alert hub | @windfixer | Pending | Critical |
| ACT-057-005 | Create CLI monitor command | @windfixer | Pending | Critical |
| ACT-057-006 | Integrate into BurnInController | @windfixer | Pending | Critical |

---

## Success Criteria

1. Dashboard accessible at http://localhost:5002/monitor/burnin
2. Metrics update every 60 seconds automatically
3. Critical alerts push within 5 seconds of detection
4. CLI monitor shows live updating display
5. Historical data queryable by session ID
6. Progress % and ETA calculated accurately

---

## Token Budget

- **Estimated**: 35,000 tokens
- **Model**: Claude 3.5 Sonnet
- **Budget Category**: Critical

---

## Research Foundation

### ArXiv Papers Referenced

This decision incorporates findings from peer-reviewed research on real-time monitoring dashboards:

**[arXiv:2602.09126] An Interactive Metrics Dashboard for the Keck Observatory Archive**  
*G. Bruce Berriman, Min Phone Myat Zaw* - Demonstrates near-real-time data ingestion (within one minute), Python-based scalable infrastructure with Plotly-Dash framework, and R-tree indices that speed up queries by factor of 20. Shows live metrics on performance, growth, and health.

**[arXiv:2405.15135] Neural Surveillance: Live-Update Visualization of Latent Training Dynamics**  
*Xianglin Yang, Jin Song Dong* - Live-update visualization framework tracking internal system state. Successfully identified impending failure up to 7 epochs earlier than validation loss. Critical insight: monitoring internal state (not just outputs) enables proactive intervention.

**[arXiv:2105.10326] NetGraf: A Collaborative Network Monitoring Stack**  
*Divneet Kaur et al.* - End-to-end monitoring stack using open-source tools. Aggregates heterogeneous data sources into single Grafana dashboard. Addresses "engineers have to log into multiple dashboards" problem with single-script deployment.

**[arXiv:2409.03375] Leveraging LLMs for Interpretable ML Predictions in Real Time**  
*Francisco de Arriba-Pérez, Silvia García-Méndez* - Real-time classification with explainability dashboard. Visual and natural language descriptions of prediction outcomes with stream-based data processing pipeline.

### Research-Backed Design Decisions

Based on these papers, the monitoring dashboard implements:

1. **Near-Real-Time Collection** - 60-second intervals align with research showing sub-minute ingestion is feasible and valuable
2. **Internal State Monitoring** - Track worker states, Chrome status, not just signal counts (enables early failure detection)
3. **Unified Dashboard** - Single HTTP endpoint provides all metrics (avoids scattered tools problem)
4. **Explainable Metrics** - Progress %, ETA, throughput provide context not just raw numbers
5. **Historical Storage** - MongoDB time-series collection enables trend analysis and post-hoc investigation

---

## Consultation Log

### Oracle Consultation (Assimilated)
- **Approval**: 94%
- **Key Findings**: High value for operational visibility, low risk implementation using standard patterns

### Designer Consultation (Assimilated)
- **Approval**: 95%
- **Key Findings**: 4-phase implementation: metrics collection, HTTP endpoint, WebSocket alerts, CLI monitor

---

*Decision MON-057*  
*Real-Time Burn-In Monitoring Dashboard*  
*2026-02-21*
