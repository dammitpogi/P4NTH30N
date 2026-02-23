# Parallel

## Responsibility

Parallel provides the parallel execution engine for H4ND, managing worker pools, signal distribution, and parallel metrics collection. It enables high-throughput signal processing by distributing work across multiple workers while maintaining coordination and performance monitoring.

## When Working Here

- **Worker pools**: Dynamic worker pool management and scaling
- **Signal distribution**: Efficient signal distribution across workers
- **Parallel metrics**: Performance tracking and monitoring for parallel operations
- **Resource coordination**: Chrome DevTools Protocol resource sharing
- **Claim coordination**: Signal claiming and result aggregation
- **Performance monitoring**: Real-time performance metrics collection

## Core Functions

- **Worker Pool Management**: Dynamic worker creation, scaling, and lifecycle management
- **Signal Distribution**: Efficient signal distribution and load balancing across workers
- **Parallel Execution**: Concurrent signal processing with CDP operations
- **Resource Coordination**: Chrome DevTools Protocol session sharing and resource allocation
- **Claim Coordination**: Atomic signal claiming and result aggregation
- **Performance Tracking**: Real-time metrics collection and parallel operation monitoring

## Main Processing Loop

```
Initialize Parallel Engine
├── Load Configuration (Parallel, Workers, Resources)
├── Connect to MongoDB (Signals, Events, Metrics)
├── Initialize Worker Pool
├── Setup Signal Distribution
├── Initialize Metrics Tracking
├── Setup Resource Coordination
└── Parallel Operations Loop
    ├── Worker Pool Management
    │   ├── Monitor worker health
    │   ├── Scale pool based on load
    │   ├── Handle worker failures
    │   └── Balance workload distribution
    ├── Signal Distribution
    │   ├── Claim signals from queue
    │   ├── Distribute to available workers
    │   ├── Track signal progress
    │   └── Aggregate results
    ├── Parallel Execution
    │   ├── Process signals concurrently
    │   ├── Execute spins via CDP
    │   ├── Handle execution failures
    │   └── Report completion
    ├── Resource Coordination
    │   ├── Manage CDP sessions
    │   ├── Allocate Chrome profiles
    │   ├── Handle resource conflicts
    │   └── Optimize resource usage
    └── Performance Tracking
        ├── Collect parallel metrics
        ├── Monitor throughput
        ├── Track success rates
        └── Generate performance reports
```

## Key Patterns

1. **Worker Pool Architecture**: Dynamic worker pool with scaling and health monitoring
2. **Signal Distribution Pattern**: Round-robin and priority-based signal distribution
3. **Resource Sharing**: Chrome DevTools Protocol session pooling and sharing
4. **Parallel Metrics**: Real-time performance tracking and bottleneck identification
5. **Claim Coordination**: Atomic signal claiming with result aggregation
6. **Load Balancing**: Adaptive load distribution across available workers
7. **Failure Isolation**: Worker-level error handling to prevent system-wide failures

## Dependencies

**From C0MMON:**
- `MongoUnitOfWork`: Database operations for signals, events, and metrics
- `Signal` entity: Signal queue management and processing
- `Infrastructure/Cdp`: CDP client for parallel execution operations
- `Infrastructure/EventBus`: Inter-worker communication via event bus
- `Infrastructure/Resilience`: Circuit breaker for fault tolerance

**Parallel Infrastructure:**
- `ParallelH4NDEngine`: Main parallel execution engine
- `WorkerPool`: Worker pool management and scaling
- `SignalDistributor`: Signal distribution across workers
- `SignalWorkItem`: Work item packaging for signal processing
- `SignalClaimResult`: Result container for claimed signals
- `ParallelMetrics`: Metrics tracking for parallel operations
- `CdpResourceCoordinator`: CDP resource coordination
- `ChromeProfileManager`: Chrome profile management for parallel workers

**External:**
- System.Threading.Tasks: Parallel execution and task management
- System.Collections.Concurrent: Thread-safe collections for worker management
- Microsoft.Extensions.Logging: Parallel-specific logging
- Chrome DevTools Protocol: CDP operations for parallel execution

## Data Collections

- **PAR4L3L**: Parallel execution events and metrics
- **WORK3R**: Worker status and performance data
- **S1GN4L**: Signal distribution and processing data
- **METR1CS**: Performance metrics and throughput tracking
- **R3S0URC3**: CDP resource allocation and coordination data

## Platform Support

- **Windows**: Primary deployment with Hyper-V VM architecture
- **Multi-threading**: Parallel execution across CPU cores
- **Chrome DevTools Protocol**: Remote CDP connections for parallel execution
- **MongoDB**: Database support for parallel operations

## Recent Updates (2026-02-23)

### Parallel Architecture Enhancement
- High-throughput signal processing with worker pool management
- Efficient signal distribution and load balancing
- Chrome DevTools Protocol resource sharing and coordination
- Real-time performance metrics collection and monitoring

### New Parallel Components (2026-02-20)
- **ParallelH4NDEngine.cs**: Main parallel execution engine
- **WorkerPool.cs**: Worker pool management and scaling
- **SignalDistributor.cs**: Signal distribution across workers
- **SignalWorkItem.cs**: Work item packaging for signal processing
- **SignalClaimResult.cs**: Result container for claimed signals
- **ParallelMetrics.cs**: Metrics tracking for parallel operations
- **CdpResourceCoordinator.cs**: CDP resource coordination
- **ChromeProfileManager.cs**: Chrome profile management

### Recent Modifications (2026-02-23)
- **ParallelH4NDEngine.cs**: Enhanced signal distribution and worker coordination
- **WorkerPool.cs**: Improved worker scaling and failure recovery
- **SignalDistributor.cs**: Refined load balancing and priority handling
- **CdpResourceCoordinator.cs**: Enhanced resource allocation and conflict resolution

---

*Template Usage:*
- Replace `{{PLACEHOLDER}}` values with directory-specific content
- Maintain consistent 2-space indentation
- Use ASCII diagrams where appropriate
- Follow existing documentation style