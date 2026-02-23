# Agents

## Responsibility

Agents provides execution and monitoring agents for H4ND operations. These agents handle signal processing, execution coordination, and monitoring tasks within a parallel execution environment, ensuring reliable automation operations with proper separation of concerns.

## When Working Here

- **Execution coordination**: Signal processing and spin execution coordination
- **Monitoring oversight**: System health and operation monitoring
- **Parallel execution**: Worker pool management and signal distribution
- **Agent communication**: Inter-agent communication and task delegation
- **Performance tracking**: Operational metrics and performance monitoring
- **Error handling**: Exception recovery and error processing

## Core Functions

- **Executor Agent**: Signal-to-spin execution with CDP operations and metrics
- **Monitor Agent**: System health monitoring and alert generation
- **Signal Processing**: Signal claim, distribution, and execution coordination
- **Worker Management**: Parallel worker pool management and task distribution
- **Performance Tracking**: Execution metrics collection and reporting
- **Error Recovery**: Exception handling and recovery mechanisms

## Main Processing Loop

```
Initialize Agent System
├── Load Configuration (Agents, Parallel, Execution)
├── Connect to MongoDB (Signals, Events, Errors)
├── Initialize Executor Agent
├── Initialize Monitor Agent
├── Setup Signal Distribution
├── Start Worker Pools
└── Agent Operations Loop
    ├── Executor Agent Operations
    │   ├── Claim signals from queue
    │   ├── Map signals to execution commands
    │   ├── Execute spins via CDP
    │   ├── Collect performance metrics
    │   └── Report execution results
    ├── Monitor Agent Operations
    │   ├── Monitor system health
    │   ├── Check worker status
    │   ├── Generate health reports
    │   └── Trigger alerts if needed
    ├── Signal Processing
    │   ├── Distribute signals to workers
    │   ├── Track signal progress
    │   ├── Handle signal failures
    │   └── Report signal completion
    ├── Worker Management
    │   ├── Monitor worker health
    │   ├── Distribute work items
    │   ├── Scale worker pool
    │   └── Handle worker failures
    └── Performance Tracking
        ├── Collect execution metrics
        ├── Calculate success rates
        ├── Monitor latency
        └── Generate performance reports
```

## Key Patterns

1. **Agent-Worker Architecture**: Separate execution agents from worker pool management
2. **Signal Distribution Pattern**: Centralized signal distribution across parallel workers
3. **Performance Monitoring**: Real-time metrics collection and reporting
4. **Health Check Pattern**: Regular health monitoring with automatic recovery
5. **Error Isolation**: Agent-level error handling to prevent system-wide failures
6. **Scalable Architecture**: Dynamic worker pool scaling based on load
7. **Event-Driven Communication**: Agent coordination via event bus messages

## Dependencies

**From C0MMON:**
- `MongoUnitOfWork`: Database operations for signals, events, and credentials
- `Signal` entity: Signal queue management and processing
- `VisionCommand` entity: FourEyes integration commands
- `Infrastructure/Cdp`: CDP client for execution operations
- `Infrastructure/EventBus`: Inter-agent communication via event bus
- `Infrastructure/Resilience`: Circuit breaker and fault tolerance

**Agents Infrastructure:**
- `ExecutorAgent`: Signal-to-spin execution coordinator
- `MonitorAgent`: System health and monitoring agent
- `SignalDistributor`: Signal distribution across worker pools
- `WorkerPool`: Worker pool management and scaling
- `SignalWorkItem`: Work item packaging for signal processing
- `SignalClaimResult`: Result container for claimed signals
- `ParallelMetrics`: Metrics tracking for parallel operations

**External:**
- System.Threading.Tasks: Parallel execution and task management
- System.Collections.Concurrent: Thread-safe collections for worker management
- Microsoft.Extensions.Logging: Agent-specific logging
- Chrome DevTools Protocol: CDP operations for execution

## Data Collections

- **SIGN4L**: Signal processing and execution data
- **EV3NT**: Agent events and operational metrics
- **METR1CS**: Performance metrics and success tracking
- **WORK3R**: Worker status and performance data
- **AG3NT**: Agent health and operational status

## Platform Support

- **Windows**: Primary deployment with .NET runtime support
- **Cross-platform**: Agent logic designed for cross-platform compatibility
- **Multi-threading**: Parallel execution across CPU cores
- **WebSocket**: Event bus communication support

## Recent Updates (2026-02-23)

### Agent Architecture Enhancement
- Separate executor and monitor agent responsibilities
- Parallel execution engine with worker pool management
- Signal distribution system for load balancing
- Performance monitoring and metrics collection

### New Agent Components (2026-02-20)
- **ExecutorAgent.cs**: Signal-to-spin execution coordinator
- **MonitorAgent.cs**: System health and monitoring agent
- **SignalDistributor.cs**: Signal distribution across worker pools
- **WorkerPool.cs**: Worker pool management and scaling
- **SignalWorkItem.cs**: Work item packaging for signal processing
- **SignalClaimResult.cs**: Result container for claimed signals
- **ParallelMetrics.cs**: Metrics tracking for parallel operations

### Recent Modifications (2026-02-23)
- **ExecutorAgent.cs**: Enhanced signal processing and execution coordination
- **MonitorAgent.cs**: Improved health monitoring and alert generation
- **SignalDistributor.cs**: Refined signal distribution and load balancing
- **WorkerPool.cs**: Enhanced worker management and failure recovery

---

*Template Usage:*
- Replace `{{PLACEHOLDER}}` values with directory-specific content
- Maintain consistent 2-space indentation
- Use ASCII diagrams where appropriate
- Follow existing documentation style