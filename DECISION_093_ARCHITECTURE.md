# DECISION_093: Service Orchestration Architecture

## Scope

This architecture defines how `P4NTH30N.exe` (H0UND build output) manages always-on platform services with health checks, restart policy, and tray-controlled lifecycle.

## Managed Services

1. `RAG Server` (`RAG.McpHost.exe`)
   - Launch mode: process child
   - Health check: `GET http://127.0.0.1:5001/health`
2. `MongoDB MCP` (`node C:/P4NTH30N/tools/mcp-p4nthon/dist/index.js`)
   - Launch mode: stdio child process
   - Health check: process liveness

## Orchestrator Components

- `IManagedService` and `ManagedService`: common lifecycle contract
- `HttpManagedService`: HTTP-aware service implementation
- `StdioManagedService`: stdio process implementation
- `ServiceOrchestrator`: registry, startup/shutdown ordering, periodic health checks
- `ExponentialBackoffRetryPolicy`: bounded retry policy for transient failures

## Runtime Flow

1. `Program.Main` initializes tray host and orchestrator.
2. Orchestrator registers RAG + MongoDB MCP services.
3. Orchestrator starts all services.
4. A timer runs health checks every 30 seconds.
5. Tray exit command sets shutdown flag and app stops services gracefully.

## File Map

- `H0UND/Services/Orchestration/IManagedService.cs`
- `H0UND/Services/Orchestration/IServiceOrchestrator.cs`
- `H0UND/Services/Orchestration/ManagedService.cs`
- `H0UND/Services/Orchestration/HttpManagedService.cs`
- `H0UND/Services/Orchestration/StdioManagedService.cs`
- `H0UND/Services/Orchestration/ServiceOrchestrator.cs`
- `H0UND/Services/Orchestration/ExponentialBackoffRetryPolicy.cs`
