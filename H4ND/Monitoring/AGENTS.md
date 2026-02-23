# Monitoring

## Responsibility

Monitoring provides comprehensive system oversight including burn-in analysis, alerting, dashboard servers, and decision promotion. It ensures operational reliability, tracks system health, and automates decision-making processes based on performance metrics and alert thresholds.

## When Working Here

- **Burn-in monitoring**: Session stability testing and performance validation
- **Alert evaluation**: Real-time alert detection and severity assessment
- **Dashboard servers**: HTTP-based monitoring dashboards and status reporting
- **Decision promotion**: Automated decision making based on operational metrics
- **Completion analysis**: Burn-in completion detection and reporting
- **Halt diagnostics**: Burn-in failure diagnosis and troubleshooting

## Core Functions

- **Burn-in monitoring**: Continuous session stability testing and performance tracking
- **Alert evaluation**: Multi-severity alert detection and notification dispatch
- **Dashboard serving**: Real-time monitoring dashboards via HTTP endpoints
- **Decision promotion**: Automated decision logic based on performance thresholds
- **Progress calculation**: Burn-in progress tracking and completion analysis
- **Diagnostics**: Burn-in failure analysis and diagnostic reporting

## Main Processing Loop

```
Initialize Monitoring System
├── Load Configuration (Alerts, Dashboard, Burn-in)
├── Connect to MongoDB (Events, Errors, Metrics)
├── Initialize Burn-in Monitor
├── Start Alert Evaluator
├── Launch Dashboard Servers
├── Setup Decision Promoter
└── Monitoring Operations Loop
    ├── Burn-in Monitoring
    │   ├── Monitor session stability
    │   ├── Track performance metrics
    │   ├── Calculate burn-in progress
    │   └── Detect completion or failure
    ├── Alert Evaluation
    │   ├── Monitor predefined conditions
    │   ├── Evaluate alert severity (Critical, High, Medium, Low)
    │   ├── Trigger alerts based on thresholds
    │   └── Dispatch notifications
    ├── Dashboard Updates
    │   ├── Collect system metrics
    │   ├── Update HTTP endpoints
    │   ├── Generate status reports
    │   └── Serve dashboard content
    ├── Decision Promotion
    │   ├── Analyze performance data
    │   ├── Apply decision criteria
    │   ├── Promote decisions automatically
    │   └── Log decision outcomes
    └── Diagnostics Collection
        ├── Analyze burn-in failures
        ├── Generate diagnostic reports
        ├── Identify root causes
        └── Suggest corrective actions
```

## Key Patterns

1. **Alert Severity Hierarchy**: Critical → High → Medium → Low priority system
2. **Burn-in Progress Tracking**: Multi-dimensional progress calculation (time, success rate, stability)
3. **Dashboard Real-time Updates**: HTTP-based status reporting with WebSocket updates
4. **Decision Automation**: Threshold-based decision promotion with logging
5. **Multi-source Diagnostics**: Cross-component failure analysis
6. **Configuration-Driven**: Alert rules and thresholds defined in configuration
7. **Event-Driven Architecture**: Alert triggering and decision promotion events

## Dependencies

**From C0MMON:**
- `MongoUnitOfWork`: Data access for events, errors, and metrics
- `Event` entity: Event logging and monitoring data
- `ErrorLog` entity: Error tracking and analysis
- `Infrastructure/HealthCheck`: Base health monitoring infrastructure
- `Services/SystemHealthReport`: System health data collection

**Monitoring Infrastructure:**
- `BurnInMonitor`: Burn-in session monitoring and stability testing
- `BurnInAlertEvaluator`: Alert condition evaluation and severity assessment
- `BurnInAlertConfig`: Alert configuration management
- `AlertNotificationDispatcher`: Alert notification dispatching
- `BurnInDashboardServer`: HTTP dashboard server implementation
- `DecisionPromoter`: Automated decision promotion logic
- `BurnInCompletionAnalyzer`: Burn-in completion detection
- `BurnInHaltDiagnostics`: Burn-in failure diagnosis
- `BurnInProgressCalculator`: Burn-in progress calculation
- `AlertSeverity`: Alert severity levels and management
- `OperationalConfig`: Operational configuration management

**External:**
- Microsoft.AspNetCore.Server.Kestrel: HTTP server for dashboards
- System.Text.Json: JSON serialization for dashboard content
- Microsoft.Extensions.Configuration: Configuration management
- Microsoft.Extensions.Logging: Structured logging

## Data Collections

- **EV3NT**: Monitoring events and system metrics
- **ERR0R**: Burn-in failures and diagnostic data
- **METR1CS**: Performance metrics and progress tracking
- **AL3RT**: Alert history and notification records
- **DECISION**: Decision promotion history and outcomes

## Platform Support

- **Windows**: Primary deployment with IIS/Kestrel support
- **Cross-platform**: Dashboard servers support Linux containers
- **HTTP/HTTPS**: Standard web protocol for dashboard access
- **MongoDB**: Multi-platform database support

## Recent Updates (2026-02-23)

### Monitoring Architecture Enhancement
- Burn-in monitoring with real-time progress tracking
- Multi-severity alert evaluation system
- HTTP dashboard servers with real-time updates
- Automated decision promotion based on performance metrics

### New Monitoring Components (2026-02-20)
- **BurnInMonitor.cs**: Burn-in session stability monitoring
- **BurnInAlertEvaluator.cs**: Multi-severity alert evaluation
- **AlertNotificationDispatcher.cs**: Alert notification dispatching
- **BurnInDashboardServer.cs**: HTTP dashboard server implementation
- **DecisionPromoter.cs**: Automated decision promotion logic
- **BurnInCompletionAnalyzer.cs**: Burn-in completion detection
- **BurnInHaltDiagnostics.cs**: Burn-in failure diagnosis
- **BurnInProgressCalculator.cs**: Burn-in progress calculation
- **AlertSeverity.cs**: Alert severity levels and management
- **OperationalConfig.cs**: Operational configuration management

### Recent Modifications (2026-02-23)
- **BurnInMonitor.cs**: Enhanced stability metrics collection
- **BurnInAlertEvaluator.cs**: Improved alert condition evaluation
- **BurnInDashboardServer.cs**: Extended dashboard endpoints and real-time updates
- **DecisionPromoter.cs**: Refined decision criteria and threshold logic

---

*Template Usage:*
- Replace `{{PLACEHOLDER}}` values with directory-specific content
- Maintain consistent 2-space indentation
- Use ASCII diagrams where appropriate
- Follow existing documentation style