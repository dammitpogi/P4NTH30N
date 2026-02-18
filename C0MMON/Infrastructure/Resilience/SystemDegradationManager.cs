using System;

namespace P4NTH30N.C0MMON.Infrastructure.Resilience;

public interface IDegradationManager
{
	DegradationLevel CurrentLevel { get; }
	void CheckDegradation(SystemMetrics metrics);
	event Action<DegradationLevel> OnDegradationChanged;
}

public class SystemDegradationManager : IDegradationManager
{
	private DegradationLevel _currentLevel = DegradationLevel.Normal;
	private readonly Action<string>? _logger;

	public DegradationLevel CurrentLevel => _currentLevel;

	public event Action<DegradationLevel> OnDegradationChanged = delegate { };

	public SystemDegradationManager(Action<string>? logger = null)
	{
		_logger = logger;
	}

	public void CheckDegradation(SystemMetrics metrics)
	{
		var newLevel = (metrics, _currentLevel) switch
		{
			({ APILatency: > 2000, WorkerUtilization: > 90 }, _) => DegradationLevel.Emergency,
			({ APILatency: > 1000, WorkerUtilization: > 80 }, _) => DegradationLevel.Minimal,
			({ APILatency: > 500, WorkerUtilization: > 60 }, _) => DegradationLevel.Reduced,
			_ => DegradationLevel.Normal,
		};

		if (newLevel != _currentLevel)
		{
			_logger?.Invoke($"[DegradationManager] Transitioning from {_currentLevel} to {newLevel}");
			_currentLevel = newLevel;
			OnDegradationChanged?.Invoke(_currentLevel);
		}
	}
}
