# C0MMON/Services

## Responsibility

Provides cross-cutting services and monitoring capabilities that support the entire P4NTHE0N ecosystem. Handles system-wide concerns like health monitoring, dashboard visualization, and coordination between agents.

## When Working Here

- **Service layer architecture**: Stateless service classes with dependency injection
- **Separation of concerns**: Keep business logic separate from presentation
- **Interface-based design**: Use interfaces for testability and flexibility
- **Real-time monitoring**: Dashboard provides live system status visualization
- **Error aggregation**: Centralized error tracking and health metrics

## Core Services

- **Dashboard**: Real-time monitoring and visualization interface (Spectre.Console)
- **Health Monitoring**: CDP health checks, error tracking, and system metrics
- **Coordination Services**: Inter-agent communication via EventBus
- **AI/ModelRouting**: ModelRouter, ModelRoutingConfig for dynamic model selection
- **SpinMetrics**: Operational monitoring for H4ND spin execution

### New Services (2026-02-20)
- **CdpLifecycleConfig**: CDP lifecycle configuration
- **CdpLifecycleManager**: CDP lifecycle management (connection pooling, session reuse)

## Key Patterns

1. **Service Layer Architecture**
   - Stateless service classes
   - Dependency injection for loose coupling
   - Separation of business logic and presentation

2. **Real-time Monitoring**
   - Live system status visualization
   - Error aggregation and health metrics
   - Performance tracking and alerting

3. **Cross-Cutting Concerns**
   - Centralized logging and error handling
   - Configuration management
   - Resource lifecycle management

4. **Event-Driven Architecture**
   - Services respond to system events
   - Asynchronous processing where appropriate
   - Loose coupling between components

## Dashboard Features

- **Real-time Status**: Live agent status and system health
- **Error Analytics**: Error trends, patterns, and root cause analysis
- **Performance Metrics**: Response times, throughput, resource usage
- **Credential Management**: Lock status, balance tracking, jackpot monitoring
- **Alert System**: Threshold-based notifications and escalation
- **Spectre.Console UI**: Rich terminal interface with 5 view modes:
  - **Overview**: Header, CRED3N7IAL panel, H0UND events, HUN7ER analytics
  - **Jackpots**: 4-tier values (Grand/Major/Minor/Mini) with thresholds and differences
  - **Queue**: Total credentials, currently processing, queue size
  - **Analytics**: Total polls, successful/failed, success rate, polls/minute
  - **Errors**: Error type counts and percentages
- **Keyboard Controls**: SPACE=Pause, TAB=Next View, 1-5=Jump to View, Ctrl+C=Clear

## Dependencies

- MongoDB (primary data source for metrics and status)
- C0MMON/Interfaces (IStoreErrors, IStoreEvents for data access)
- C0MMON/Entities (ErrorLog, EventLog for health metrics)
- C0MMON/Infrastructure (database providers and repositories)

## Integration Points

**With H4ND:**
- Monitor automation execution status
- Track credential lock states
- Aggregate jackpot reset events
- Display real-time automation metrics

**With H0UND:**
- Show analytics processing status
- Display forecasting results
- Monitor balance polling health
- Track DPD calculation metrics

## Used By

- System Administrators (monitoring and management interface)
- Development Team (debugging and performance analysis)
- Operations Team (health monitoring and alerting)
- Future Automation (automated responses to health events)
