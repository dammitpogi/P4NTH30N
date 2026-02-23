# Services

## Responsibility

Services provides operational services including session management, signal generation, jackpot reading, and health reporting. It manages the runtime coordination between signals, credentials, and execution components to ensure smooth automation operations.

## When Working Here

- **Session management**: Credential lifecycle, session renewal, connection pooling
- **Signal generation**: Signal creation, priority management, queue processing
- **Jackpot monitoring**: Real-time jackpot value reading and threshold management
- **Health reporting**: System health monitoring and operational metrics
- **Burn-in coordination**: Session burn-in control and configuration
- **First spin integration**: Initial session management and setup

## Core Functions

- **Session pool management**: Credential locking, validation, renewal, and unlocking
- **Signal generation**: Create signals based on jackpot thresholds and priority rules
- **Jackpot reading**: Read jackpot values via CDP with retry logic
- **Health monitoring**: System health reports and operational status tracking
- **Burn-in control**: Session burn-in simulation and monitoring
- **First spin handling**: Initial session setup and first-time user integration

## Main Processing Loop

```
Initialize Services
├── Load Configuration (Signal Generation, Session Pool, Health)
├── Connect to MongoDB (Credentials, Signals, Events)
├── Initialize Signal Generator
├── Start Session Pool Manager
├── Initialize Jackpot Reader
├── Start Health Reporter
└── Service Operations Loop
    ├── Signal Generation
    │   ├── Monitor jackpot values
    │   ├── Generate signals based on thresholds
    │   ├── Prioritize signals (Grand=4, Major=3, Minor=2, Mini=1)
    │   └── Publish to signal queue
    ├── Session Pool Management
    │   ├── Acquire credentials for signals
    │   ├── Validate credentials (active, valid balance)
    │   ├── Renew sessions if needed
    │   └── Release credentials after processing
    ├── Jackpot Reading
    │   ├── Query jackpot values via CDP
    │   ├── Apply retry logic (3 attempts, exponential backoff)
    │   ├── Validate values (NaN, Infinity, negative)
    │   └── Update thresholds if jackpots pop
    ├── Health Monitoring
    │   ├── Collect system metrics
    │   ├── Generate health reports
    │   └── Publish to operational dashboard
    └── Burn-in Control
        ├── Monitor session burn-in progress
        ├── Apply burn-in configurations
        └── Adjust session parameters
```

## Key Patterns

1. **Session Pool Architecture**: Credential lifecycle management with atomic operations
2. **Signal-Driven Design**: Priority-based signal generation and processing
3. **Exponential Backoff**: Retry logic for network operations with jitter
4. **Jackpot Threshold Management**: Dynamic threshold calculation and reset
5. **Service Coordination**: Inter-service communication via event bus
6. **Health Monitoring Integration**: Real-time metrics collection and reporting
7. **Configuration-Driven**: Service behavior controlled by appsettings.json

## Dependencies

**From C0MMON:**
- `MongoUnitOfWork`: Database operations for credentials, signals, and events
- `Credential` entity: User credentials, jackpots, thresholds, DPD toggles
- `Signal` entity: Priority-based signal queue management
- `Infrastructure/Cdp`: CDP client for jackpot reading and session management
- `Infrastructure/EventBus`: In-memory event bus for service coordination
- `Monitoring/ErrorLog`: Error logging and validation tracking

**Services Infrastructure:**
- `SessionPool`: Credential session management and pooling
- `SignalGenerator`: Signal creation and priority management
- `JackpotReader`: Jackpot value reading via CDP
- `SystemHealthReport`: System health monitoring and reporting
- `SessionRenewalService`: Automatic session renewal logic
- `BurnInController`: Burn-in session management
- `FirstSpinController`: First-time session setup
- `NetworkInterceptor`: HTTP request monitoring and logging

**External:**
- Chrome DevTools Protocol: Jackpot reading via CDP
- System.Text.Json: Configuration serialization
- Microsoft.Extensions.Configuration: Configuration management
- Microsoft.Extensions.Logging: Structured logging

## Data Collections

- **SIGN4L**: Signal requests and priority management data
- **CR3D3N7IAL**: User credentials and session state
- **EV3NT**: Service events and monitoring data
- **HEALTH**: System health metrics and operational status

## Platform Support

- **Windows**: Primary deployment with VM architecture
- **Cross-platform**: Service logic agnostic to platform specifics
- **MongoDB**: Cross-platform database support
- **Chrome**: DevTools Protocol compatibility across platforms

## Recent Updates (2026-02-23)

### Service Architecture Enhancement
- Session pooling implementation for improved performance
- Signal generation with priority-based scheduling
- Enhanced jackp monitoring with CDP integration
- Health monitoring dashboard integration

### New Service Components (2026-02-20)
- **SessionPool.cs**: Credential session management and pooling
- **SignalGenerator.cs**: Priority-based signal generation
- **JackpotReader.cs**: CDP-based jackpot value reading
- **SystemHealthReport.cs**: System health monitoring and reporting
- **SessionRenewalService.cs**: Automatic session renewal
- **BurnInController.cs**: Burn-in session management
- **FirstSpinController.cs**: First-time session setup
- **NetworkInterceptor.cs**: HTTP request monitoring

### Recent Modifications (2026-02-23)
- **SessionPool.cs**: Enhanced credential validation and renewal logic
- **SignalGenerator.cs**: Improved priority management and signal creation
- **JackpotReader.cs**: Integrated with new CDP health checks
- **SystemHealthReport.cs**: Extended metrics collection and reporting

---

*Template Usage:*
- Replace `{{PLACEHOLDER}}` values with directory-specific content
- Maintain consistent 2-space indentation
- Use ASCII diagrams where appropriate
- Follow existing documentation style