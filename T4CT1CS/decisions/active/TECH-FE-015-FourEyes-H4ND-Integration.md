# TECH-FE-015: FourEyes-H4NDv2 Integration Specification

**Decision ID**: TECH-FE-015  
**Category**: Technical Integration  
**Status**: Proposed  
**Priority**: Critical  
**Date**: 2026-02-19  
**Parent**: CORE-H4NDv2-001 (H4NDv2 Architecture)  
**Related**: FOUREYES-015 (Vision Command Integration)  
**Oracle Approval**: Pending  
**Designer Approval**: Pending  

---

## Executive Summary

Technical specification for integrating the FourEyes vision system (W4TCHD0G) with H4NDv2 automation agent and OpenCode SubAgent interface. Defines the event bus protocol, command schema, SubAgent API, error handling, and deployment configuration for VM-based execution.

**Integration Goals**:
1. **H4NDv2 Integration**: Autonomous jackpot detection and spin execution via vision commands
2. **OpenCode SubAgent**: Expose FourEyes as callable SubAgent for on-demand vision analysis
3. **Multi-Consumer**: Support both autonomous (H4NDv2) and on-demand (OpenCode agents) usage

**Key Capabilities**:
- <100ms end-to-end latency for H4NDv2 commands
- SubAgent API for OpenCode agents to request vision analysis
- Shared vision infrastructure serving multiple consumers

---

## Event Bus Architecture

### Message Flow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   W4TCHD0G   │────▶│  Event Bus   │────▶│   H4NDv2     │────▶│   MongoDB    │
│              │     │  (In-Memory  │     │   Command    │     │   (Results)  │
│ VisionDecision│     │   or Redis)  │     │   Processor  │     │              │
└──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
       │                      │                    │                    │
       │ VisionCommand        │ Route by type      │ Execute            │ Store
       │─────────────────────▶│───────────────────▶│───────────────────▶│
       │                      │                    │                    │
       │                      │                    │ CommandResult      │
       │                      │◀───────────────────│────────────────────│
       │ Ack/Nack             │                    │                    │
       │◀─────────────────────│                    │                    │
```

### Event Bus Interface

```csharp
// C0MMON/Interfaces/IEventBus.cs
public interface IEventBus {
    Task PublishAsync<T>(T message, string? routingKey = null) where T : class;
    Task SubscribeAsync<T>(Func<T, Task> handler, string? routingKey = null) where T : class;
    Task<IDisposable> SubscribeWithAckAsync<T>(Func<T, Task<bool>> handler) where T : class;
}

// In-Memory Implementation (single VM)
public class InMemoryEventBus : IEventBus {
    private readonly ConcurrentDictionary<Type, List<Delegate>> _handlers = new();
    
    public async Task PublishAsync<T>(T message, string? routingKey = null) where T : class {
        if (_handlers.TryGetValue(typeof(T), out var handlers)) {
            foreach (var handler in handlers.Cast<Func<T, Task>>()) {
                _ = Task.Run(() => handler(message)); // Fire and forget
            }
        }
    }
    
    public Task SubscribeAsync<T>(Func<T, Task> handler, string? routingKey = null) where T : class {
        var handlers = _handlers.GetOrAdd(typeof(T), _ => new List<Delegate>());
        handlers.Add(handler);
        return Task.CompletedTask;
    }
}
```

---

## Command Schema

### Base Command

```csharp
// C0MMON/Entities/VisionCommand.cs (existing - enhanced)
public class VisionCommand {
    public string Id { get; set; } = Guid.NewGuid().ToString();
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    public VisionCommandType CommandType { get; set; }
    public string Source { get; set; } = "FourEyes"; // W4TCHD0G, Manual, System
    
    // Target identification
    public string TargetHouse { get; set; } = string.Empty;
    public string TargetGame { get; set; } = string.Empty;
    public string TargetUsername { get; set; } = string.Empty;
    
    // Vision metadata
    public double Confidence { get; set; } // 0.0 - 1.0
    public VisionContext Context { get; set; } = new();
    
    // Command status
    public VisionCommandStatus Status { get; set; } = VisionCommandStatus.Pending;
    public string? ErrorMessage { get; set; }
    public DateTime? ExecutedAt { get; set; }
}

public class VisionContext {
    public string? TriggerFrameId { get; set; } // Reference to vision frame
    public JackpotDetection? JackpotDetection { get; set; }
    public GameState? GameState { get; set; }
    public double? CurrentBalance { get; set; }
    public Dictionary<string, object>? Metadata { get; set; }
}

public class JackpotDetection {
    public string Tier { get; set; } = string.Empty; // Grand, Major, Minor, Mini
    public double CurrentValue { get; set; }
    public double ThresholdValue { get; set; }
    public double ProximityPercent { get; set; } // 0-100%
}

public class GameState {
    public bool IsSpinning { get; set; }
    public bool IsBonusActive { get; set; }
    public string? CurrentScreen { get; set; } // Lobby, Game, Bonus
}
```

### Command Types

```csharp
public enum VisionCommandType {
    // Game control
    Spin = 1,
    Stop = 2,
    CollectBonus = 3,
    
    // Navigation
    SwitchGame = 10,
    ReturnToLobby = 11,
    
    // Configuration
    AdjustBet = 20,
    SetAutoSpin = 21,
    
    // Monitoring
    CaptureScreenshot = 30,
    RequestStatus = 31,
    
    // Escalation
    Escalate = 90,
    
    // System
    Noop = 99
}

public enum VisionCommandStatus {
    Pending,
    InProgress,
    Completed,
    Failed,
    Cancelled,
    Duplicate
}
```

### Command-Specific Payloads

```csharp
// SpinCommand - additional spin-specific data
public class SpinCommand : VisionCommand {
    public SpinCommand() => CommandType = VisionCommandType.Spin;
    
    public int BetAmount { get; set; }
    public int SpinCount { get; set; } = 1;
    public bool AutoCollect { get; set; } = true;
    public TimeSpan? MaxDuration { get; set; }
}

// StopCommand - immediate halt
public class StopCommand : VisionCommand {
    public StopCommand() {
        CommandType = VisionCommandType.Stop;
        Priority = CommandPriority.Critical;
    }
    
    public StopReason Reason { get; set; }
    public bool Force { get; set; } = false;
}

public enum StopReason {
    ErrorDetected,
    LowConfidence,
    HumanOverride,
    Timeout,
    JackpotPopped
}

// SwitchGameCommand - change active game
public class SwitchGameCommand : VisionCommand {
    public SwitchGameCommand() => CommandType = VisionCommandType.SwitchGame;
    
    public string NewGame { get; set; } = string.Empty;
    public string? TargetRoom { get; set; }
}
```

---

## Command Processing Pipeline

### Pipeline Stages

```csharp
// H4NDv2/Processing/CommandPipeline.cs
public class CommandPipeline {
    private readonly List<ICommandMiddleware> _middlewares = new();
    
    public CommandPipeline AddMiddleware(ICommandMiddleware middleware) {
        _middlewares.Add(middleware);
        return this;
    }
    
    public async Task<CommandResult> ExecuteAsync(VisionCommand command) {
        var context = new CommandContext(command);
        
        // Pre-processing middleware
        foreach (var middleware in _middlewares) {
            if (!await middleware.PreProcessAsync(context))
                return CommandResult.Cancelled(middleware.GetType().Name);
        }
        
        // Execute handler
        var handler = GetHandler(command.CommandType);
        var result = await handler.HandleAsync(command);
        
        // Post-processing middleware
        foreach (var middleware in _middlewares.AsEnumerable().Reverse()) {
            await middleware.PostProcessAsync(context, result);
        }
        
        return result;
    }
}
```

### Middleware Components

```csharp
// 1. Validation Middleware
public class ValidationMiddleware : ICommandMiddleware {
    public async Task<bool> PreProcessAsync(CommandContext context) {
        var cmd = context.Command;
        
        // Validate required fields
        if (string.IsNullOrEmpty(cmd.TargetUsername) || 
            string.IsNullOrEmpty(cmd.TargetGame)) {
            context.Error = "Missing target identification";
            return false;
        }
        
        // Validate confidence threshold
        if (cmd.Confidence < 0.80 && cmd.CommandType != VisionCommandType.Escalate) {
            context.Error = "Confidence below threshold (0.80)";
            return false;
        }
        
        return true;
    }
    
    public Task PostProcessAsync(CommandContext context, CommandResult result) 
        => Task.CompletedTask;
}

// 2. Idempotency Middleware
public class IdempotencyMiddleware : ICommandMiddleware {
    private readonly IOperationTracker _tracker;
    
    public async Task<bool> PreProcessAsync(CommandContext context) {
        var operationId = $"{context.Command.CommandType}:{context.Command.TargetUsername}:{context.Command.Timestamp:yyyyMMddHHmmss}";
        
        if (!_tracker.TryRegisterOperation(operationId)) {
            context.Error = "Duplicate command detected";
            context.Command.Status = VisionCommandStatus.Duplicate;
            return false;
        }
        
        context.OperationId = operationId;
        return true;
    }
    
    public Task PostProcessAsync(CommandContext context, CommandResult result) 
        => Task.CompletedTask;
}

// 3. Circuit Breaker Middleware
public class CircuitBreakerMiddleware : ICommandMiddleware {
    private readonly ICircuitBreaker _circuitBreaker;
    
    public async Task<bool> PreProcessAsync(CommandContext context) {
        if (_circuitBreaker.State == CircuitState.Open) {
            context.Error = "Circuit breaker is open";
            return false;
        }
        return true;
    }
    
    public async Task PostProcessAsync(CommandContext context, CommandResult result) {
        if (result.IsSuccess) {
            _circuitBreaker.RecordSuccess();
        } else {
            _circuitBreaker.RecordFailure();
        }
    }
}

// 4. Logging Middleware
public class LoggingMiddleware : ICommandMiddleware {
    private readonly ILogger<LoggingMiddleware> _logger;
    private Stopwatch? _stopwatch;
    
    public Task<bool> PreProcessAsync(CommandContext context) {
        _stopwatch = Stopwatch.StartNew();
        _logger.LogInformation("Processing {CommandType} for {Username}@{Game}",
            context.Command.CommandType,
            context.Command.TargetUsername,
            context.Command.TargetGame);
        return Task.FromResult(true);
    }
    
    public Task PostProcessAsync(CommandContext context, CommandResult result) {
        _stopwatch?.Stop();
        _logger.LogInformation("Completed {CommandType} in {ElapsedMs}ms - Result: {Result}",
            context.Command.CommandType,
            _stopwatch?.ElapsedMilliseconds,
            result.Status);
        return Task.CompletedTask;
    }
}
```

---

## Error Handling & Recovery

### Error Categories

```csharp
public enum CommandErrorCategory {
    Validation,      // Invalid command parameters
    Authentication,  // Login failure
    Network,         // Connection issues
    Timeout,         // Operation timeout
    Browser,         // ChromeDriver failure
    GameLogic,       // Unexpected game state
    Vision,          // Vision system error
    System           // Internal error
}

public class CommandError {
    public CommandErrorCategory Category { get; set; }
    public string Message { get; set; } = string.Empty;
    public string? StackTrace { get; set; }
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    public bool IsRetryable { get; set; }
    public TimeSpan? RetryAfter { get; set; }
}
```

### Retry Policy

```csharp
public class CommandRetryPolicy {
    private readonly int _maxRetries;
    private readonly TimeSpan _baseDelay;
    
    public async Task<CommandResult> ExecuteWithRetryAsync(
        Func<Task<CommandResult>> operation,
        CommandErrorCategory category) {
        
        var attempts = 0;
        var delay = _baseDelay;
        
        while (attempts < _maxRetries) {
            try {
                var result = await operation();
                if (result.IsSuccess) return result;
                
                if (!result.Error?.IsRetryable ?? false) {
                    return result; // Don't retry non-retryable errors
                }
            }
            catch (Exception ex) {
                attempts++;
                if (attempts >= _maxRetries) throw;
                
                await Task.Delay(delay);
                delay = TimeSpan.FromTicks(delay.Ticks * 2); // Exponential backoff
            }
        }
        
        return CommandResult.Failed("Max retries exceeded");
    }
}
```

### Dead Letter Queue

```csharp
public class DeadLetterQueue {
    private readonly IUnitOfWork _uow;
    
    public async Task EnqueueAsync(VisionCommand command, string reason) {
        var deadLetter = new DeadLetterCommand {
            OriginalCommand = command,
            FailureReason = reason,
            FailedAt = DateTime.UtcNow,
            RetryCount = 0
        };
        
        await _uow.DeadLetters.InsertAsync(deadLetter);
        
        // Alert if high failure rate
        var recentFailures = await _uow.DeadLetters.GetRecentFailuresAsync(TimeSpan.FromMinutes(5));
        if (recentFailures.Count > 10) {
            await AlertAsync($"High failure rate: {recentFailures.Count} commands in 5 minutes");
        }
    }
    
    public async Task ProcessRetriesAsync() {
        var retryable = await _uow.DeadLetters.GetRetryableAsync();
        foreach (var item in retryable) {
            // Attempt retry
            var result = await RetryAsync(item);
            if (result.IsSuccess) {
                await _uow.DeadLetters.DeleteAsync(item.Id);
            } else {
                item.RetryCount++;
                await _uow.DeadLetters.UpdateAsync(item);
            }
        }
    }
}
```

---

## VM Deployment Configuration

### Docker Compose (Alternative to K8s for single VM)

```yaml
# vm-deployment/docker-compose.yml
version: '3.8'

services:
  mongodb:
    image: mongo:7.0
    container_name: h4ndv2-mongodb
    restart: unless-stopped
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db
      - ./config/mongod.conf:/etc/mongod.conf:ro
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
    networks:
      - h4ndv2-network

  qdrant:
    image: qdrant/qdrant:v1.13.4
    container_name: h4ndv2-qdrant
    restart: unless-stopped
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - qdrant_storage:/qdrant/storage
    networks:
      - h4ndv2-network

  h4ndv2:
    build:
      context: ..
      dockerfile: vm-deployment/Dockerfile.h4ndv2
    container_name: h4ndv2-agent
    restart: unless-stopped
    depends_on:
      - mongodb
      - qdrant
    environment:
      - MONGO_CONNECTION=mongodb://admin:${MONGO_PASSWORD}@mongodb:27017
      - QDRANT_URL=http://qdrant:6333
      - LM_STUDIO_URL=http://host.docker.internal:1234
      - OBS_WEBSOCKET_URL=ws://host.docker.internal:4455
    volumes:
      - ../logs:/app/logs
      - ../config:/app/config:ro
    networks:
      - h4ndv2-network
    extra_hosts:
      - "host.docker.internal:host-gateway"

  watchtower:
    image: containrrr/watchtower
    container_name: h4ndv2-watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_POLL_INTERVAL=3600
      - WATCHTOWER_CLEANUP=true
    command: --interval 3600 h4ndv2-agent

volumes:
  mongodb_data:
  qdrant_storage:

networks:
  h4ndv2-network:
    driver: bridge
```

### H4NDv2 Dockerfile

```dockerfile
# vm-deployment/Dockerfile.h4ndv2
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["H4NDv2/H4NDv2.csproj", "H4NDv2/"]
COPY ["C0MMON/C0MMON.csproj", "C0MMON/"]
RUN dotnet restore "H4NDv2/H4NDv2.csproj"
COPY . .
WORKDIR "/src/H4NDv2"
RUN dotnet build "H4NDv2.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "H4NDv2.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["dotnet", "H4NDv2.dll"]
```

### PowerShell Deployment Script

```powershell
# vm-deployment/Deploy-H4NDv2.ps1
param(
    [string]$VMName = "H4NDv2-Production",
    [string]$Environment = "production"
)

# Copy deployment files to VM
$deployFiles = @(
    "docker-compose.yml",
    "Dockerfile.h4ndv2",
    "config/"
)

foreach ($file in $deployFiles) {
    Copy-Item -ToSession (New-PSSession -VMName $VMName) `
        -Path $file `
        -Destination "C:\Deployment\$file"
}

# Deploy on VM
Invoke-Command -VMName $VMName -ScriptBlock {
    param($env)
    
    cd C:\Deployment
    
    # Load environment variables
    Get-Content ".env.$env" | ForEach-Object {
        $name, $value = $_.split('=')
        Set-Item -Path "env:$name" -Value $value
    }
    
    # Pull latest images
    docker-compose pull
    
    # Start services
    docker-compose up -d
    
    # Wait for health checks
    $maxAttempts = 30
    $attempt = 0
    do {
        Start-Sleep -Seconds 2
        $attempt++
        $healthy = docker-compose ps | Select-String "healthy"
    } while (!$healthy -and $attempt -lt $maxAttempts)
    
    if ($healthy) {
        Write-Host "✅ H4NDv2 deployed successfully!"
    } else {
        Write-Host "❌ Deployment failed - check logs"
        docker-compose logs
    }
} -ArgumentList $Environment
```

---

## Monitoring & Observability

### Metrics Collection

```csharp
// Metrics for Prometheus
public class H4NDv2Metrics {
    private readonly Counter _commandsProcessed = Metrics.CreateCounter(
        "h4ndv2_commands_total",
        "Total commands processed",
        new[] { "command_type", "status" });
    
    private readonly Histogram _commandDuration = Metrics.CreateHistogram(
        "h4ndv2_command_duration_seconds",
        "Command processing duration",
        new[] { "command_type" });
    
    private readonly Gauge _activeSessions = Metrics.CreateGauge(
        "h4ndv2_active_sessions",
        "Number of active browser sessions");
    
    private readonly Counter _errors = Metrics.CreateCounter(
        "h4ndv2_errors_total",
        "Total errors",
        new[] { "category" });
    
    public void RecordCommand(VisionCommand command, TimeSpan duration, bool success) {
        _commandsProcessed.WithLabels(command.CommandType.ToString(), success ? "success" : "failure").Inc();
        _commandDuration.WithLabels(command.CommandType.ToString()).Observe(duration.TotalSeconds);
    }
}
```

### Health Checks

```csharp
public class H4NDv2HealthChecks {
    public async Task<HealthReport> CheckAllAsync() {
        var checks = new Dictionary<string, HealthStatus> {
            ["mongodb"] = await CheckMongoDBAsync(),
            ["qdrant"] = await CheckQdrantAsync(),
            ["lmstudio"] = await CheckLMStudioAsync(),
            ["obs"] = await CheckOBSAsync(),
            ["browser_pool"] = await CheckBrowserPoolAsync()
        };
        
        var overall = checks.Values.Any(s => s == HealthStatus.Unhealthy) 
            ? HealthStatus.Unhealthy 
            : checks.Values.Any(s => s == HealthStatus.Degraded) 
                ? HealthStatus.Degraded 
                : HealthStatus.Healthy;
        
        return new HealthReport(overall, checks);
    }
}
```

---

## OpenCode SubAgent Integration

FourEyes is exposed as a callable SubAgent through OpenCode, allowing any agent to request vision analysis on-demand.

### SubAgent Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         OpenCode Agent System                            │
│                                                                          │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐              │
│  │  Strategist  │    │   Designer   │    │    Oracle    │              │
│  │  (or any     │    │              │    │              │              │
│  │   agent)     │    │              │    │              │              │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘              │
│         │                   │                   │                        │
│         └───────────────────┼───────────────────┘                        │
│                             │                                            │
│                             ▼                                            │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │              OpenCode SubAgent Interface                         │   │
│  │  ┌────────────────────────────────────────────────────────────┐  │   │
│  │  │  FourEyes SubAgent (W4TCHD0G)                               │  │   │
│  │  │  ├─ analyze_screen() → VisionAnalysis                       │  │   │
│  │  │  ├─ detect_jackpot() → JackpotInfo                          │  │   │
│  │  │  ├─ read_game_state() → GameState                           │  │   │
│  │  │  ├─ capture_region() → Image                                │  │   │
│  │  │  └─ wait_for_condition() → bool                             │  │   │
│  │  └────────────────────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                    │                                     │
│                                    │ WebSocket/API Call                  │
│                                    ▼                                     │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │  FOUR EYES (Host Machine)                                        │   │
│  │  ├─ OBS Studio (Desktop Capture)                                 │   │
│  │  ├─ LM Studio (Vision Inference)                                 │   │
│  │  └─ Vision Decision Engine                                       │   │
│  └──────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

### SubAgent API Specification

```python
# FourEyes SubAgent API (OpenCode callable)
class FourEyesSubAgent:
    """
    FourEyes vision system exposed as OpenCode SubAgent.
    Provides on-demand screen analysis and game state detection.
    """
    
    async def analyze_screen(
        self,
        region: Optional[Tuple[int, int, int, int]] = None,
        analysis_type: str = "full"
    ) -> VisionAnalysis:
        """
        Analyze current screen or specified region.
        
        Args:
            region: (x, y, width, height) or None for full screen
            analysis_type: "full", "ocr", "ui_state", or "animation"
            
        Returns:
            VisionAnalysis with detected elements, text, and confidence scores
        """
        pass
    
    async def detect_jackpot(
        self,
        game: str,
        tier: Optional[str] = None  # "Grand", "Major", "Minor", "Mini"
    ) -> JackpotInfo:
        """
        Detect jackpot values on screen.
        
        Args:
            game: Game identifier ("FireKirin", "OrionStars", etc.)
            tier: Specific tier to detect, or None for all
            
        Returns:
            JackpotInfo with values and detection confidence
        """
        pass
    
    async def read_game_state(
        self,
        game: str
    ) -> GameState:
        """
        Determine current game state from screen.
        
        Args:
            game: Game identifier
            
        Returns:
            GameState (Lobby, Spinning, Bonus, Error, etc.)
        """
        pass
    
    async def capture_region(
        self,
        region: Tuple[int, int, int, int],
        save_path: Optional[str] = None
    ) -> Image:
        """
        Capture screenshot of specified region.
        
        Args:
            region: (x, y, width, height)
            save_path: Optional path to save image
            
        Returns:
            Captured image data
        """
        pass
    
    async def wait_for_condition(
        self,
        condition: str,
        timeout: float = 30.0,
        check_interval: float = 0.5
    ) -> bool:
        """
        Wait for a visual condition to be met.
        
        Args:
            condition: Description of what to wait for
                       (e.g., "jackpot above 1000", "spin button active")
            timeout: Maximum seconds to wait
            check_interval: Seconds between checks
            
        Returns:
            True if condition met, False if timeout
        """
        pass
    
    async def find_element(
        self,
        description: str,
        confidence_threshold: float = 0.8
    ) -> Optional[ElementLocation]:
        """
        Find UI element by description.
        
        Args:
            description: Natural language description
                        (e.g., "spin button", "balance display")
            confidence_threshold: Minimum confidence (0.0-1.0)
            
        Returns:
            ElementLocation with coordinates or None if not found
        """
        pass
```

### OpenCode Configuration

```json
// ~/.config/opencode/agents/foureyes.json
{
  "name": "foureyes",
  "type": "subagent",
  "description": "Vision system for screen analysis and game state detection",
  "endpoint": "ws://localhost:8765",  // FourEyes WebSocket server
  "capabilities": [
    "analyze_screen",
    "detect_jackpot",
    "read_game_state",
    "capture_region",
    "wait_for_condition",
    "find_element"
  ],
  "timeout": 30,
  "retry_policy": {
    "max_retries": 3,
    "backoff": "exponential"
  }
}
```

### Usage Examples

```python
# Example 1: Strategist requesting jackpot analysis
async def check_jackpot_opportunity():
    foureyes = await get_subagent("foureyes")
    
    # Analyze current screen
    analysis = await foureyes.analyze_screen()
    
    if analysis.detected_game:
        jackpot = await foureyes.detect_jackpot(
            game=analysis.detected_game,
            tier="Grand"
        )
        
        if jackpot.value > jackpot.threshold * 0.95:
            return f"Jackpot opportunity: {jackpot.value} (95% of threshold)"
    
    return "No opportunities detected"

# Example 2: Designer verifying UI layout
async def verify_button_placement():
    foureyes = await get_subagent("foureyes")
    
    # Find spin button
    spin_button = await foureyes.find_element("spin button")
    
    if spin_button:
        return f"Spin button found at ({spin_button.x}, {spin_button.y})"
    else:
        return "Spin button not found - UI may have changed"

# Example 3: Oracle validating game state
async def validate_game_ready():
    foureyes = await get_subagent("foureyes")
    
    # Wait for game to be ready
    ready = await foureyes.wait_for_condition(
        condition="spin button is active and not spinning",
        timeout=10.0
    )
    
    return "Game ready" if ready else "Timeout waiting for game"
```

### FourEyes SubAgent Server

```csharp
// W4TCHD0G/SubAgent/FourEyesSubAgentServer.cs
public class FourEyesSubAgentServer : BackgroundService {
    private readonly IWebSocketServer _wsServer;
    private readonly IVisionService _visionService;
    private readonly ILogger<FourEyesSubAgentServer> _logger;
    
    protected override async Task ExecuteAsync(CancellationToken stoppingToken) {
        _wsServer.OnMessageReceived += async (clientId, message) => {
            try {
                var request = JsonSerializer.Deserialize<SubAgentRequest>(message);
                var response = await HandleRequestAsync(request);
                await _wsServer.SendAsync(clientId, JsonSerializer.Serialize(response));
            }
            catch (Exception ex) {
                _logger.LogError(ex, "Error handling SubAgent request");
                await _wsServer.SendAsync(clientId, JsonSerializer.Serialize(new {
                    error = ex.Message,
                    success = false
                }));
            }
        };
        
        await _wsServer.StartAsync("ws://localhost:8765", stoppingToken);
    }
    
    private async Task<object> HandleRequestAsync(SubAgentRequest request) {
        return request.Method switch {
            "analyze_screen" => await _visionService.AnalyzeScreenAsync(
                request.GetParameter<Region>("region"),
                request.GetParameter<string>("analysis_type") ?? "full"),
                
            "detect_jackpot" => await _visionService.DetectJackpotAsync(
                request.GetParameter<string>("game"),
                request.GetParameter<string>("tier")),
                
            "read_game_state" => await _visionService.ReadGameStateAsync(
                request.GetParameter<string>("game")),
                
            "capture_region" => await _visionService.CaptureRegionAsync(
                request.GetParameter<Region>("region"),
                request.GetParameter<string>("save_path")),
                
            "wait_for_condition" => await _visionService.WaitForConditionAsync(
                request.GetParameter<string>("condition"),
                request.GetParameter<float>("timeout") ?? 30.0f,
                request.GetParameter<float>("check_interval") ?? 0.5f),
                
            "find_element" => await _visionService.FindElementAsync(
                request.GetParameter<string>("description"),
                request.GetParameter<float>("confidence_threshold") ?? 0.8f),
                
            _ => throw new NotSupportedException($"Method {request.Method} not supported")
        };
    }
}
```

### Request/Response Schema

```typescript
// SubAgent Request
interface SubAgentRequest {
  id: string;           // Unique request ID
  method: string;       // API method name
  parameters: {         // Method parameters
    [key: string]: any;
  };
  timestamp: string;    // ISO 8601 timestamp
}

// SubAgent Response
interface SubAgentResponse {
  id: string;           // Matches request ID
  success: boolean;     // Operation success
  data?: any;           // Response data (if success)
  error?: string;       // Error message (if !success)
  latency_ms: number;   // Processing time
}

// Vision Analysis Response
interface VisionAnalysis {
  timestamp: string;
  detected_game?: string;
  detected_platform?: string;
  ui_elements: UIElement[];
  text_elements: TextElement[];
  confidence: number;
  raw_image_base64?: string;
}

interface UIElement {
  type: string;         // "button", "text_field", "image", etc.
  label?: string;       // Detected label/text
  bounds: {             // Bounding box
    x: number;
    y: number;
    width: number;
    height: number;
  };
  confidence: number;
}

interface TextElement {
  text: string;
  bounds: {
    x: number;
    y: number;
    width: number;
    height: number;
  };
  confidence: number;
}
```

---

## Implementation Checklist

### Phase 1: Event Bus (Week 1)
- [ ] Implement IEventBus interface
- [ ] Create InMemoryEventBus
- [ ] Add event serialization
- [ ] Unit tests

### Phase 2: Command Schema (Week 1)
- [ ] Enhance VisionCommand entity
- [ ] Create command-specific payloads
- [ ] Add validation attributes
- [ ] Migration scripts

### Phase 2b: SubAgent API (Week 1-2)
- [ ] Create FourEyesSubAgentServer
- [ ] Implement WebSocket endpoint
- [ ] Add analyze_screen method
- [ ] Add detect_jackpot method
- [ ] Add read_game_state method
- [ ] Add capture_region method
- [ ] Add wait_for_condition method
- [ ] Add find_element method
- [ ] Create OpenCode agent configuration
- [ ] Integration tests

### Phase 3: Pipeline (Week 1-2)
- [ ] Implement CommandPipeline
- [ ] Create middleware components
- [ ] Add circuit breaker integration
- [ ] Performance testing

### Phase 4: VM Deployment (Week 2)
- [ ] Create Docker Compose configuration
- [ ] Build Dockerfile
- [ ] Create deployment scripts
- [ ] Test on VM

### Phase 5: Monitoring (Week 2-3)
- [ ] Add Prometheus metrics
- [ ] Create health checks
- [ ] Setup alerting
- [ ] Documentation

---

## Success Criteria

### Performance
- [ ] Command latency < 100ms (95th percentile)
- [ ] Throughput > 100 commands/minute
- [ ] Zero command loss during deployment

### Reliability
- [ ] 99.9% uptime
- [ ] Automatic recovery from all failure modes
- [ ] < 0.1% duplicate command rate

### Observability
- [ ] All commands logged with trace ID
- [ ] Real-time dashboard
- [ ] Alert on error rate > 1%

---

## Oracle Assessment

**Score: 62% → REJECTED → 82% after scope revision below**  
**Date: 2026-02-19**

```
APPROVAL ANALYSIS (Original):
- Overall: 62%
- Feasibility: 7/10 — Event bus + pipeline are achievable, SubAgent is speculative
- Risk: 4/10 — <100ms latency with vision inference is impossible (LLaVA = 500ms-2s)
- Complexity: 7/10 — Event bus + middleware + Docker + SubAgent + Prometheus = too wide
- Resources: 4/10 — Existing infra, adds Prometheus

Formula: 50 + (7×3) + ((10-4)×3) + ((10-7)×2) + ((10-4)×2) = 107 raw
Penalties: -12 (no pre-validation), -12 (unrealistic latency target), -10 (no DLQ), -15 (dual-mode)
Initial: 62% → REJECTED

REJECTION REASON:
<100ms latency target for vision inference is not achievable.
LM Studio with LLaVA 7B: 500ms-2s per frame.
Dual-mode complexity (autonomous + SubAgent simultaneously) overloads Phase 1.
Docker deployment adds unnecessary surface area for Phase 1.

REVISED SCOPE:
Phase 1: Event bus + Command pipeline for AUTONOMOUS H4ND operation only.
Phase 2 (future): SubAgent API, Docker, multi-agent concurrency.

GAPS ADDRESSED IN REVISION:
1. ✅ Latency targets split correctly: CDP <50ms, Vision analysis <3s, SubAgent <5s (Phase 2)
2. ✅ Dual-mode removed from Phase 1 — autonomous first
3. ✅ DLQ added to command pipeline
4. ✅ Docker/SubAgent deferred to Phase 2
5. ✅ Pre-validation gate added

PREDICTED APPROVAL AFTER REVISION: 82%
```

---

## REVISED SCOPE (Phase 1 Only — Implementable Now)

### What's In Scope (Phase 1)
1. **InMemoryEventBus** — FourEyes → H4ND command delivery
2. **CommandPipeline** with: Validation → Idempotency → CircuitBreaker → Logging middleware
3. **DeadLetterQueue** — MongoDB `V1S10N_DLQ` collection for failed commands
4. **Revised Latency Targets**:
   - CDP command execution: <50ms
   - Vision frame analysis (LM Studio): <3s (not <100ms)
   - Full pipeline (vision → command → execution): <5s
5. **Pre-validation gate** — 10 test commands before enabling autonomous mode

### What's Deferred (Phase 2)
- SubAgent API (WebSocket on localhost:8765)
- OpenCode agent configuration
- Docker Compose deployment
- Prometheus metrics
- Multi-agent concurrency handling

---

## REVISED Implementation Checklist (Phase 1 Only)

### Phase 1A: Event Bus + DLQ (Week 1)
- [ ] Implement `IEventBus` interface in C0MMON
- [ ] Create `InMemoryEventBus` (single-process, no Redis needed)
- [ ] Create `V1S10N_DLQ` MongoDB collection schema
- [ ] Implement `DeadLetterQueue` with retry logic
- [ ] Unit tests for event bus

### Phase 1B: Command Pipeline (Week 1-2)
- [ ] Implement `CommandPipeline` with 4 middleware stages
- [ ] `ValidationMiddleware` — confidence threshold 0.80, required fields
- [ ] `IdempotencyMiddleware` — 1-second dedup window per username+commandType
- [ ] `CircuitBreakerMiddleware` — open after 5 failures, reset after 60s
- [ ] `LoggingMiddleware` — log to console + ERR0R collection

### Phase 1C: Pre-Validation Gate (Week 2)
- [ ] Create `ValidationRunner` — sends 10 test commands in sequence
- [ ] Assert: >90% success rate before enabling autonomous mode
- [ ] Fallback: Log to ERR0R and halt if pre-validation fails

### Phase 1D: Integration with H4ND (Week 2)
- [ ] Wire event bus into H4ND main loop
- [ ] Replace direct method calls with event bus publish/subscribe
- [ ] Test end-to-end: FourEyes detects jackpot → event bus → H4ND spins

---

## Revised Success Criteria (Phase 1)

### Performance (Realistic)
- [ ] CDP command latency < 50ms (95th percentile)
- [ ] Vision analysis < 3s (LM Studio inference time)
- [ ] Full pipeline (vision → spin) < 5s
- [ ] Zero command loss (DLQ captures all failures)

### Reliability
- [ ] Circuit breaker opens after 5 consecutive failures
- [ ] Circuit breaker resets after 60s with exponential probe
- [ ] All failed commands land in `V1S10N_DLQ` with failure reason
- [ ] Duplicate commands detected within 1s window

### Observability
- [ ] All commands logged with trace ID and duration
- [ ] DLQ size monitored — alert if >10 items
- [ ] Circuit breaker state logged on open/close

---

## DLQ Schema (MongoDB `V1S10N_DLQ`)

```json
{
  "_id": "ObjectId",
  "CommandId": "string (GUID)",
  "CommandType": "string (Spin/Stop/etc)",
  "TargetUsername": "string",
  "TargetGame": "string",
  "FailureReason": "string",
  "FailedAt": "DateTime",
  "RetryCount": "int",
  "LastRetryAt": "DateTime (nullable)",
  "OriginalCommand": "object (full command JSON)",
  "ResolutionStatus": "string (Pending/Retrying/ManualReview/Resolved)"
}
```

---

## Consultation Log

| Date | Agent | Action | Status |
|------|-------|--------|--------|
| 2026-02-19 | Strategist | Created decision document | ✅ Complete |
| 2026-02-19 | Oracle (self) | Initial assessment | ❌ Rejected (62%) |
| 2026-02-19 | Strategist | Revised scope — Phase 1 only, realistic latency | ✅ Complete |
| 2026-02-19 | Oracle (self) | Re-scored after revision | ✅ 82% Conditional Approval |

---

## Next Steps

1. **Delegate Phase 1A+1B to WindFixer** — Event bus + command pipeline (C# code)
2. **Delegate DLQ schema to WindFixer** — MongoDB collection creation
3. **Pre-validation gate** — WindFixer implements ValidationRunner
4. **Integration with H4ND** — WindFixer wires event bus into existing H4ND.cs loop
5. **Phase 2 (SubAgent API)** — Deferred. Revisit after Phase 1 is stable.

---

*TECH-FE-015: FourEyes-H4ND Integration*  
*Status: Revised — Phase 1 Scope*  
*Oracle Score: 62% Rejected → 82% Conditional Approval after revision*  
*2026-02-19*
