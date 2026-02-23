# Infrastructure

## Responsibility

Infrastructure provides the foundational runtime components for H4ND, including Chrome DevTools Protocol management, session persistence, logging, and health monitoring. It serves as the backbone for reliable browser automation and operational resilience.

## When Working Here

- **CDP connectivity**: WebSocket-based browser communication with retry logic
- **Session management**: Persistent Chrome sessions with connection pooling
- **Health monitoring**: Pre-flight validation and periodic health checks
- **Resource coordination**: VM resource monitoring and CDP session lifecycle
- **Persistence**: MongoDB connection management and data persistence
- **Command pipeline**: Middleware-based request processing with validation

## Core Functions

- **CDP client management**: WebSocket communication, session reuse, connection pooling
- **Health validation**: Pre-flight checks, latency testing, connectivity monitoring
- **Session lifecycle**: Connection establishment, authentication, cleanup
- **Resource monitoring**: VM health, CPU, memory, network bandwidth tracking
- **Command processing**: Middleware pipeline with logging, validation, idempotency, circuit breaker
- **Persistence management**: MongoDB connection options, unit of work integration

## Main Processing Loop

```
Initialize Infrastructure Components
├── Load Configuration (appsettings.json)
├── Initialize MongoDB Connection Options
├── Setup CDP Client Pool
├── Initialize Health Monitoring
└── Runtime Operations
    ├── CDP Health Check (pre-flight validation)
    │   ├── HTTP /json/version endpoint check
    │   ├── WebSocket handshake validation
    │   ├── Round-trip latency test (1+1 eval)
    │   └── Connection quality assessment
    ├── Monitor VM Health (CPU, Memory, Network)
    ├── Process Command Pipeline Requests
    │   ├── Logging Middleware
    │   ├── Validation Middleware
    │   ├── Idempotency Middleware
    │   └── Circuit Breaker Middleware
    └── Periodic Health Report Generation
```

## Key Patterns

1. **CDP Connection Pooling**: Reuse Chrome DevTools Protocol sessions across operations
2. **Health-First Architecture**: Pre-flight validation before any CDP operations
3. **Middleware Pipeline**: Chain-based request processing with cross-cutting concerns
4. **Session Lifecycle Management**: Automatic reconnection and session renewal
5. **Resource Monitoring**: VM health metrics collection and threshold-based alerts
6. **Resilience Pattern**: Circuit breaker pattern for fault tolerance
7. **Configuration Management**: Centralized settings with environment variable override

## Dependencies

**From C0MMON:**
- `MongoUnitOfWork`: MongoDB operations and connection management
- `Credential` entity: User session data and CDP connection state
- `Infrastructure/MongoConnectionOptions`: MongoDB connection configuration
- `Infrastructure/HealthCheck`: Base health monitoring infrastructure
- `Infrastructure/Logging`: Structured logging and error reporting

**Infrastructure Components:**
- `CdpClient`: Chrome DevTools Protocol client implementation
- `CdpConfig`: CDP client configuration management
- `CdpHealthCheck`: Pre-flight connectivity validation
- `CdpGameActions`: CDP-based game operations (login, spin, logout)
- `ChromeSessionManager`: Chrome session lifecycle management
- `VmHealthMonitor`: VM resource monitoring and health reporting
- `SpinExecution`: Signal-to-spin execution pipeline
- `SpinMetrics`: Operational metrics collection and reporting
- `SpinHealthEndpoint`: HTTP health endpoint (port 9280)
- `CommandPipeline`: Middleware-based command processing
- `CommandMiddleware`: Request processing middleware components

**External:**
- Chrome DevTools Protocol: Browser automation via WebSocket
- System.Text.Json: Configuration serialization and deserialization
- Microsoft.Extensions.Configuration: Configuration management
- Microsoft.Extensions.Logging: Structured logging framework

## Data Collections

- **EV3NT**: Infrastructure events and health monitoring data
- **CR3D3N7IAL**: CDP session state and connection management data
- **ERR0R**: Infrastructure validation and connection errors
- **INFRA_HEALTH**: VM resource metrics and CDP connection status

## Platform Support

- **Windows**: Primary deployment platform with Hyper-V VM architecture
- **Linux**: Development and testing support (Ubuntu 20.04+)
- **Chrome**: Remote debugging via CDP (localhost and remote connections)

## Recent Updates (2026-02-23)

### Infrastructure Modernization
- CDP migration complete: Replaced Selenium with Chrome DevTools Protocol
- Session pooling implementation for improved performance
- Enhanced health monitoring with pre-flight validation
- Command pipeline architecture with middleware support

### VM Architecture Integration
- Remote CDP connections via port proxy (localhost → 192.168.56.1)
- MongoDB direct connection optimization (`?directConnection=true`)
- Chrome session management across VM-host boundary
- Resource monitoring for CPU, memory, and network bandwidth

### New Infrastructure Components (2026-02-20)
- **ChromeSessionManager.cs**: Chrome session lifecycle and connection management
- **VmHealthMonitor.cs**: Virtual machine health monitoring and reporting
- **CdpLifecycleConfig.cs**: CDP lifecycle configuration management
- **CdpLifecycleManager.cs**: CDP session pooling and reuse management
- **CommandPipeline.cs**: Middleware-based command processing pipeline
- **CommandMiddleware.cs**: Request processing middleware components

### Recent Modifications (2026-02-23)
- **CdpHealthCheck.cs**: Enhanced validation with WebSocket handshake testing
- **CdpClient.cs**: Remote connection URL rewriting for VM-host architecture
- **SpinExecution.cs**: Integrated with new CDP health checks
- **SpinHealthEndpoint.cs**: Extended health monitoring endpoints

---

*Template Usage:*
- Replace `{{PLACEHOLDER}}` values with directory-specific content
- Maintain consistent 2-space indentation
- Use ASCII diagrams where appropriate
- Follow existing documentation style