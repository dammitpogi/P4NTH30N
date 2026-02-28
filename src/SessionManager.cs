using System.Text.Json;
using System.Text.Json.Serialization;

namespace P4NTHE0N.SWE;

/// <summary>
/// Manages SWE-1.5 session lifecycle including turn counting, context tracking,
/// boundary detection, and handoff state serialization.
/// </summary>
public sealed class SessionManager
{
	private readonly SessionConfig _config;
	private readonly List<string> _modifiedFiles = new();
	private readonly List<string> _completedTasks = new();
	private readonly List<string> _pendingTasks = new();
	private readonly Dictionary<string, object> _state = new();
	private int _errorCount;
	private int _consecutiveErrors;

	/// <summary>
	/// Unique identifier for this session.
	/// </summary>
	public string SessionId { get; }

	/// <summary>
	/// Current turn number (1-indexed).
	/// </summary>
	public int CurrentTurn { get; private set; }

	/// <summary>
	/// Estimated context size in tokens.
	/// </summary>
	public long EstimatedTokens { get; private set; }

	/// <summary>
	/// Agent name running this session.
	/// </summary>
	public string AgentName { get; }

	/// <summary>
	/// Session start time.
	/// </summary>
	public DateTime StartedAt { get; }

	public SessionManager(string agentName = "WindFixer", SessionConfig? config = null)
	{
		SessionId = Guid.NewGuid().ToString("N")[..12];
		AgentName = agentName;
		StartedAt = DateTime.UtcNow;
		CurrentTurn = 0;
		_config = config ?? new SessionConfig();
	}

	/// <summary>
	/// Advances the turn counter and returns the session status.
	/// </summary>
	public SessionStatus AdvanceTurn(long estimatedNewTokens = 0)
	{
		CurrentTurn++;
		EstimatedTokens += estimatedNewTokens;
		_consecutiveErrors = 0;

		return EvaluateStatus();
	}

	/// <summary>
	/// Records a turn that resulted in an error.
	/// </summary>
	public SessionStatus RecordError()
	{
		CurrentTurn++;
		_errorCount++;
		_consecutiveErrors++;

		return EvaluateStatus();
	}

	/// <summary>
	/// Evaluates current session status based on turn count, context size, and errors.
	/// </summary>
	public SessionStatus EvaluateStatus()
	{
		if (_consecutiveErrors >= _config.MaxConsecutiveErrors)
		{
			return SessionStatus.ErrorThreshold;
		}

		if (_errorCount >= _config.MaxTotalErrors)
		{
			return SessionStatus.ErrorThreshold;
		}

		if (CurrentTurn >= _config.HardTurnLimit)
		{
			return SessionStatus.MustReset;
		}

		double contextUsage = _config.MaxContextTokens > 0 ? (double)EstimatedTokens / _config.MaxContextTokens : 0.0;

		if (contextUsage >= 0.9)
		{
			return SessionStatus.MustReset;
		}

		if (CurrentTurn >= _config.SoftTurnLimit || contextUsage >= 0.8)
		{
			return SessionStatus.CompressNeeded;
		}

		if (CurrentTurn >= _config.WarningThreshold || contextUsage >= 0.7)
		{
			return SessionStatus.Warning;
		}

		return SessionStatus.Normal;
	}

	/// <summary>
	/// Records a file modification.
	/// </summary>
	public void TrackFileModification(string filePath)
	{
		if (!_modifiedFiles.Contains(filePath))
		{
			_modifiedFiles.Add(filePath);
		}
	}

	/// <summary>
	/// Marks a task as completed.
	/// </summary>
	public void CompleteTask(string taskId)
	{
		_completedTasks.Add(taskId);
		_pendingTasks.Remove(taskId);
	}

	/// <summary>
	/// Adds a pending task.
	/// </summary>
	public void AddPendingTask(string taskId)
	{
		if (!_pendingTasks.Contains(taskId) && !_completedTasks.Contains(taskId))
		{
			_pendingTasks.Add(taskId);
		}
	}

	/// <summary>
	/// Sets a state value for handoff.
	/// </summary>
	public void SetState(string key, object value)
	{
		_state[key] = value;
	}

	/// <summary>
	/// Gets a state value.
	/// </summary>
	public T? GetState<T>(string key)
	{
		if (_state.TryGetValue(key, out object? value) && value is T typed)
		{
			return typed;
		}
		return default;
	}

	/// <summary>
	/// Whether the session should be reset based on current status.
	/// </summary>
	public bool ShouldReset()
	{
		SessionStatus status = EvaluateStatus();
		return status == SessionStatus.MustReset || status == SessionStatus.ErrorThreshold;
	}

	/// <summary>
	/// Whether context compression should begin.
	/// </summary>
	public bool ShouldCompress()
	{
		SessionStatus status = EvaluateStatus();
		return status == SessionStatus.CompressNeeded || status == SessionStatus.MustReset;
	}

	/// <summary>
	/// Serializes current session state for handoff to next session.
	/// </summary>
	public SessionHandoff CreateHandoff(string summary = "")
	{
		return new SessionHandoff
		{
			SessionId = SessionId,
			Agent = AgentName,
			TurnsCompleted = CurrentTurn,
			EstimatedTokensUsed = EstimatedTokens,
			CompletedTasks = new List<string>(_completedTasks),
			PendingTasks = new List<string>(_pendingTasks),
			ModifiedFiles = new List<string>(_modifiedFiles),
			State = new Dictionary<string, object>(_state),
			Summary = summary,
			Timestamp = DateTime.UtcNow,
			ErrorCount = _errorCount,
		};
	}

	/// <summary>
	/// Serializes handoff to JSON string.
	/// </summary>
	public string SerializeHandoff(string summary = "")
	{
		SessionHandoff handoff = CreateHandoff(summary);

		JsonSerializerOptions options = new() { WriteIndented = true, Converters = { new JsonStringEnumConverter() } };

		return JsonSerializer.Serialize(handoff, options);
	}

	/// <summary>
	/// Saves handoff state to a file.
	/// </summary>
	public async Task SaveHandoffAsync(string filePath, string summary = "", CancellationToken cancellationToken = default)
	{
		string json = SerializeHandoff(summary);
		string? dir = Path.GetDirectoryName(filePath);
		if (dir != null && !Directory.Exists(dir))
		{
			Directory.CreateDirectory(dir);
		}
		await File.WriteAllTextAsync(filePath, json, cancellationToken);
	}

	/// <summary>
	/// Loads handoff state from a previous session.
	/// </summary>
	public static SessionHandoff? LoadHandoff(string filePath)
	{
		if (!File.Exists(filePath))
			return null;

		string json = File.ReadAllText(filePath);
		JsonSerializerOptions options = new() { Converters = { new JsonStringEnumConverter() } };

		return JsonSerializer.Deserialize<SessionHandoff>(json, options);
	}

	/// <summary>
	/// Restores session state from a handoff.
	/// </summary>
	public void RestoreFromHandoff(SessionHandoff handoff)
	{
		_completedTasks.Clear();
		_completedTasks.AddRange(handoff.CompletedTasks);
		_pendingTasks.Clear();
		_pendingTasks.AddRange(handoff.PendingTasks);
		_modifiedFiles.Clear();
		_modifiedFiles.AddRange(handoff.ModifiedFiles);
		_state.Clear();
		foreach (KeyValuePair<string, object> kvp in handoff.State)
		{
			_state[kvp.Key] = kvp.Value;
		}
		_errorCount = handoff.ErrorCount;
	}
}

/// <summary>
/// Session configuration parameters.
/// </summary>
public sealed class SessionConfig
{
	public int SoftTurnLimit { get; init; } = 30;
	public int HardTurnLimit { get; init; } = 50;
	public int WarningThreshold { get; init; } = 25;
	public long MaxContextTokens { get; init; } = 128_000;
	public int MaxConsecutiveErrors { get; init; } = 3;
	public int MaxTotalErrors { get; init; } = 5;
}

/// <summary>
/// Session status levels.
/// </summary>
public enum SessionStatus
{
	Normal,
	Warning,
	CompressNeeded,
	MustReset,
	ErrorThreshold,
}

/// <summary>
/// Serializable handoff state for session transitions.
/// </summary>
public sealed class SessionHandoff
{
	public string SessionId { get; init; } = string.Empty;
	public string Agent { get; init; } = string.Empty;
	public int TurnsCompleted { get; init; }
	public long EstimatedTokensUsed { get; init; }
	public List<string> CompletedTasks { get; init; } = new();
	public List<string> PendingTasks { get; init; } = new();
	public List<string> ModifiedFiles { get; init; } = new();
	public Dictionary<string, object> State { get; init; } = new();
	public string Summary { get; init; } = string.Empty;
	public DateTime Timestamp { get; init; }
	public int ErrorCount { get; init; }
}
