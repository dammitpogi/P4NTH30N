using System.Diagnostics;

namespace P4NTHE0N.W4TCHD0G.Safety;

/// <summary>
/// Production safety monitor that tracks spending, losses, and anomalies
/// in real-time. Triggers circuit breakers and kill switch when limits are breached.
/// </summary>
/// <remarks>
/// SAFETY PHILOSOPHY:
/// - Fail-safe: Any ambiguity → stop automation
/// - Defense-in-depth: Multiple independent limits
/// - Kill switch: Instant halt, requires manual override to resume
/// - Logging: Every safety event is logged with timestamps
///
/// LIMITS:
/// - Daily spend cap
/// - Daily net loss cap
/// - Consecutive loss streak cap
/// - Balance depletion threshold
/// - Kill switch (manual or automatic)
/// </remarks>
public sealed class SafetyMonitor : ISafetyMonitor
{
	/// <summary>
	/// Override code required to deactivate the kill switch.
	/// Changed via configuration; default is a memorable string.
	/// </summary>
	private const string DefaultOverrideCode = "CONFIRM-RESUME-P4NTHE0N";

	private readonly decimal _dailySpendLimit;
	private readonly decimal _dailyLossLimit;
	private readonly int _maxConsecutiveLosses;
	private readonly decimal _balanceAlertThreshold;
	private readonly string _overrideCode;

	private decimal _dailySpend;
	private decimal _dailyNetLoss;
	private int _consecutiveLosses;
	private decimal _currentBalance;
	private decimal _startingBalance;
	private int _totalSpinsToday;
	private volatile bool _killSwitchActive;
	private string _killSwitchReason = string.Empty;
	private bool _disposed;

	private readonly object _lock = new();

	/// <inheritdoc />
	public event Action<SafetyAlert>? OnAlert;

	/// <inheritdoc />
	public event Action<string>? OnKillSwitchActivated;

	/// <summary>
	/// Creates a SafetyMonitor with configurable limits.
	/// </summary>
	/// <param name="dailySpendLimit">Maximum total spend per day. Default: $100.</param>
	/// <param name="dailyLossLimit">Maximum net loss per day. Default: $100.</param>
	/// <param name="maxConsecutiveLosses">Max consecutive losses before circuit break. Default: 10.</param>
	/// <param name="balanceAlertThreshold">Fraction of starting balance that triggers alert (0.0–1.0). Default: 0.20.</param>
	/// <param name="overrideCode">Code required to deactivate kill switch.</param>
	public SafetyMonitor(
		decimal dailySpendLimit = 100m,
		decimal dailyLossLimit = 100m,
		int maxConsecutiveLosses = 10,
		decimal balanceAlertThreshold = 0.20m,
		string? overrideCode = null
	)
	{
		_dailySpendLimit = dailySpendLimit;
		_dailyLossLimit = dailyLossLimit;
		_maxConsecutiveLosses = maxConsecutiveLosses;
		_balanceAlertThreshold = balanceAlertThreshold;
		_overrideCode = overrideCode ?? DefaultOverrideCode;
	}

	/// <inheritdoc />
	public void RecordSpin(decimal betAmount)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		lock (_lock)
		{
			_dailySpend += betAmount;
			_totalSpinsToday++;

			// Check daily spend limit
			if (_dailySpend >= _dailySpendLimit)
			{
				RaiseAlert(
					AlertSeverity.Emergency,
					"DailySpend",
					_dailySpend,
					_dailySpendLimit,
					$"Daily spend limit reached: ${_dailySpend:F2} >= ${_dailySpendLimit:F2}"
				);
				ActivateKillSwitch($"Daily spend limit exceeded: ${_dailySpend:F2}");
			}
			else if (_dailySpend >= _dailySpendLimit * 0.90m)
			{
				RaiseAlert(AlertSeverity.Critical, "DailySpend", _dailySpend, _dailySpendLimit, $"Daily spend at 90%: ${_dailySpend:F2} / ${_dailySpendLimit:F2}");
			}
			else if (_dailySpend >= _dailySpendLimit * 0.75m)
			{
				RaiseAlert(AlertSeverity.Warning, "DailySpend", _dailySpend, _dailySpendLimit, $"Daily spend at 75%: ${_dailySpend:F2} / ${_dailySpendLimit:F2}");
			}
		}
	}

	/// <inheritdoc />
	public void RecordBalanceChange(decimal previousBalance, decimal currentBalance)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		lock (_lock)
		{
			// Set starting balance on first observation
			if (_startingBalance == 0 && previousBalance > 0)
				_startingBalance = previousBalance;

			_currentBalance = currentBalance;
			decimal change = currentBalance - previousBalance;

			if (change < 0)
			{
				// Loss
				decimal lossAmount = Math.Abs(change);
				_dailyNetLoss += lossAmount;
				_consecutiveLosses++;

				Console.WriteLine($"[Safety] Loss: ${lossAmount:F2} (streak: {_consecutiveLosses}, daily net: ${_dailyNetLoss:F2})");

				// Check consecutive losses
				if (_consecutiveLosses >= _maxConsecutiveLosses)
				{
					RaiseAlert(
						AlertSeverity.Emergency,
						"ConsecutiveLosses",
						_consecutiveLosses,
						_maxConsecutiveLosses,
						$"Consecutive loss streak: {_consecutiveLosses} >= {_maxConsecutiveLosses}"
					);
					ActivateKillSwitch($"Consecutive loss limit exceeded: {_consecutiveLosses}");
				}

				// Check daily loss limit
				if (_dailyNetLoss >= _dailyLossLimit)
				{
					RaiseAlert(
						AlertSeverity.Emergency,
						"DailyLoss",
						_dailyNetLoss,
						_dailyLossLimit,
						$"Daily loss limit reached: ${_dailyNetLoss:F2} >= ${_dailyLossLimit:F2}"
					);
					ActivateKillSwitch($"Daily loss limit exceeded: ${_dailyNetLoss:F2}");
				}

				// Check balance depletion
				if (_startingBalance > 0)
				{
					decimal remainingFraction = currentBalance / _startingBalance;
					if (remainingFraction <= _balanceAlertThreshold)
					{
						RaiseAlert(
							AlertSeverity.Critical,
							"BalanceDepletion",
							currentBalance,
							_startingBalance * _balanceAlertThreshold,
							$"Balance depleted to {remainingFraction:P0} of starting (${currentBalance:F2} / ${_startingBalance:F2})"
						);
					}
				}
			}
			else if (change > 0)
			{
				// Win — reset consecutive loss counter
				_consecutiveLosses = 0;
				_dailyNetLoss = Math.Max(0, _dailyNetLoss - change);
				Console.WriteLine($"[Safety] Win: +${change:F2} (streak reset, daily net loss: ${_dailyNetLoss:F2})");
			}
		}
	}

	/// <inheritdoc />
	public bool IsSafeToContinue()
	{
		if (_killSwitchActive)
			return false;

		lock (_lock)
		{
			if (_dailySpend >= _dailySpendLimit)
				return false;
			if (_dailyNetLoss >= _dailyLossLimit)
				return false;
			if (_consecutiveLosses >= _maxConsecutiveLosses)
				return false;
		}

		return true;
	}

	/// <inheritdoc />
	public SafetyStatus GetStatus()
	{
		lock (_lock)
		{
			List<string> alerts = new();
			if (_killSwitchActive)
				alerts.Add($"KILL SWITCH: {_killSwitchReason}");
			if (_dailySpend >= _dailySpendLimit * 0.75m)
				alerts.Add($"Spend at {_dailySpend / _dailySpendLimit:P0}");
			if (_dailyNetLoss >= _dailyLossLimit * 0.75m)
				alerts.Add($"Loss at {_dailyNetLoss / _dailyLossLimit:P0}");
			if (_consecutiveLosses >= _maxConsecutiveLosses / 2)
				alerts.Add($"Loss streak: {_consecutiveLosses}");

			return new SafetyStatus
			{
				Safe = IsSafeToContinue(),
				KillSwitchActive = _killSwitchActive,
				DailySpend = _dailySpend,
				DailySpendLimit = _dailySpendLimit,
				DailyNetLoss = _dailyNetLoss,
				DailyLossLimit = _dailyLossLimit,
				ConsecutiveLosses = _consecutiveLosses,
				MaxConsecutiveLosses = _maxConsecutiveLosses,
				TotalSpinsToday = _totalSpinsToday,
				CurrentBalance = _currentBalance,
				BalanceAlertThreshold = _balanceAlertThreshold,
				ActiveAlerts = alerts,
			};
		}
	}

	/// <inheritdoc />
	public void ActivateKillSwitch(string reason)
	{
		if (_killSwitchActive)
			return;

		_killSwitchActive = true;
		_killSwitchReason = reason;

		Console.WriteLine($"[Safety] *** KILL SWITCH ACTIVATED: {reason} ***");
		OnKillSwitchActivated?.Invoke(reason);
	}

	/// <inheritdoc />
	public bool DeactivateKillSwitch(string overrideCode)
	{
		if (!_killSwitchActive)
		{
			Console.WriteLine("[Safety] Kill switch is not active.");
			return true;
		}

		if (overrideCode != _overrideCode)
		{
			Console.WriteLine("[Safety] Invalid override code. Kill switch remains active.");
			return false;
		}

		_killSwitchActive = false;
		_killSwitchReason = string.Empty;
		Console.WriteLine("[Safety] Kill switch deactivated via manual override.");
		return true;
	}

	/// <inheritdoc />
	public void ResetDaily()
	{
		lock (_lock)
		{
			_dailySpend = 0;
			_dailyNetLoss = 0;
			_consecutiveLosses = 0;
			_totalSpinsToday = 0;
			_startingBalance = _currentBalance;
			Console.WriteLine("[Safety] Daily counters reset.");
		}
	}

	/// <summary>
	/// Raises a safety alert and logs it.
	/// </summary>
	private void RaiseAlert(AlertSeverity severity, string metric, decimal current, decimal limit, string message)
	{
		SafetyAlert alert = new()
		{
			Severity = severity,
			Metric = metric,
			CurrentValue = current,
			LimitValue = limit,
			Message = message,
		};

		Console.WriteLine($"[Safety] [{severity}] {message}");
		OnAlert?.Invoke(alert);
	}

	/// <inheritdoc />
	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
		}
	}
}
