namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// DECISION_027: Base agent interface for AgentNet decentralized coordination.
/// All agents in the system implement this interface for capability discovery
/// and event-driven messaging.
/// </summary>
public interface IAgent
{
	/// <summary>
	/// Unique agent identifier.
	/// </summary>
	string AgentId { get; }

	/// <summary>
	/// Human-readable agent name.
	/// </summary>
	string Name { get; }

	/// <summary>
	/// Agent role: Predictor, Optimizer, Executor, Monitor.
	/// </summary>
	AgentRole Role { get; }

	/// <summary>
	/// Capabilities this agent provides.
	/// </summary>
	IReadOnlyList<string> Capabilities { get; }

	/// <summary>
	/// Whether the agent is currently active and processing.
	/// </summary>
	bool IsActive { get; }

	/// <summary>
	/// Priority for message routing (lower = higher priority).
	/// </summary>
	int Priority { get; }

	/// <summary>
	/// Handles an incoming message from the coordination bus.
	/// </summary>
	Task HandleMessageAsync(AgentMessage message, CancellationToken ct = default);
}

/// <summary>
/// DECISION_027: Specialized predictor agent interface (H0UND).
/// Generates predictions and signals from data analysis.
/// </summary>
public interface IPredictor : IAgent
{
	Task<PredictionResult> PredictAsync(PredictionRequest request, CancellationToken ct = default);
}

/// <summary>
/// DECISION_027: Specialized optimizer agent interface.
/// Optimizes parameters based on historical outcomes.
/// </summary>
public interface IOptimizer : IAgent
{
	Task<OptimizationResult> OptimizeAsync(OptimizationRequest request, CancellationToken ct = default);
}

/// <summary>
/// DECISION_027: Specialized executor agent interface (H4ND).
/// Executes actions via CDP or other automation.
/// </summary>
public interface IExecutor : IAgent
{
	Task<ExecutionResult> ExecuteAsync(ExecutionRequest request, CancellationToken ct = default);
}

/// <summary>
/// DECISION_027: Specialized monitor agent interface.
/// Monitors system health and raises alerts.
/// </summary>
public interface IMonitorAgent : IAgent
{
	Task<MonitorReport> ReportAsync(CancellationToken ct = default);
}

/// <summary>
/// Agent roles in the AgentNet coordination protocol.
/// </summary>
public enum AgentRole
{
	Predictor,
	Optimizer,
	Executor,
	Monitor,
}

/// <summary>
/// Message passed between agents via the coordination bus.
/// </summary>
public class AgentMessage
{
	public string MessageId { get; set; } = Guid.NewGuid().ToString("N");
	public string FromAgent { get; set; } = string.Empty;
	public string? ToAgent { get; set; }
	public AgentRole? TargetRole { get; set; }
	public string MessageType { get; set; } = string.Empty;
	public string Payload { get; set; } = string.Empty;
	public int Priority { get; set; } = 5;
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
}

/// <summary>
/// Result from a prediction request.
/// </summary>
public class PredictionResult
{
	public bool ShouldAct { get; set; }
	public double Confidence { get; set; }
	public string Reason { get; set; } = string.Empty;
	public Dictionary<string, double> Values { get; set; } = new();
}

/// <summary>
/// Request for a prediction.
/// </summary>
public class PredictionRequest
{
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public string Tier { get; set; } = string.Empty;
	public double CurrentValue { get; set; }
	public double Threshold { get; set; }
}

/// <summary>
/// Result from an optimization request.
/// </summary>
public class OptimizationResult
{
	public Dictionary<string, double> Parameters { get; set; } = new();
	public double ExpectedImprovement { get; set; }
}

/// <summary>
/// Request for optimization.
/// </summary>
public class OptimizationRequest
{
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public Dictionary<string, double> CurrentParameters { get; set; } = new();
	public List<double> HistoricalOutcomes { get; set; } = new();
}

/// <summary>
/// Result from an execution request.
/// </summary>
public class ExecutionResult
{
	public bool Success { get; set; }
	public string? ErrorMessage { get; set; }
	public Dictionary<string, string> Data { get; set; } = new();
}

/// <summary>
/// Request for execution.
/// </summary>
public class ExecutionRequest
{
	public string ActionType { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public string Username { get; set; } = string.Empty;
	public Dictionary<string, string> Parameters { get; set; } = new();
}

/// <summary>
/// Report from a monitor agent.
/// </summary>
public class MonitorReport
{
	public string AgentId { get; set; } = string.Empty;
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public string OverallStatus { get; set; } = "Healthy";
	public Dictionary<string, string> Metrics { get; set; } = new();
	public List<string> Alerts { get; set; } = new();
}
