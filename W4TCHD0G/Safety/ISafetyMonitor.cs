namespace P4NTH30N.W4TCHD0G.Safety;

/// <summary>
/// Contract for monitoring safety limits and triggering circuit breakers.
/// Prevents catastrophic financial loss by tracking spending, losses,
/// and anomalous behavior in real-time.
/// </summary>
public interface ISafetyMonitor : IDisposable
{
	/// <summary>
	/// Records a spin attempt with its cost.
	/// </summary>
	/// <param name="betAmount">Amount wagered on this spin.</param>
	void RecordSpin(decimal betAmount);

	/// <summary>
	/// Records a balance change (positive = win, negative = loss).
	/// </summary>
	/// <param name="previousBalance">Balance before the action.</param>
	/// <param name="currentBalance">Balance after the action.</param>
	void RecordBalanceChange(decimal previousBalance, decimal currentBalance);

	/// <summary>
	/// Checks whether any safety limit has been breached.
	/// </summary>
	/// <returns>True if safe to continue, false if a limit was hit.</returns>
	bool IsSafeToContinue();

	/// <summary>
	/// Returns the current safety status with all metric details.
	/// </summary>
	SafetyStatus GetStatus();

	/// <summary>
	/// Activates the kill switch — immediately halts all automation.
	/// </summary>
	/// <param name="reason">Reason for emergency stop.</param>
	void ActivateKillSwitch(string reason);

	/// <summary>
	/// Deactivates the kill switch (requires explicit manual override).
	/// </summary>
	/// <param name="overrideCode">Manual override confirmation code.</param>
	/// <returns>True if successfully deactivated.</returns>
	bool DeactivateKillSwitch(string overrideCode);

	/// <summary>
	/// Resets daily counters (call at midnight or manual reset).
	/// </summary>
	void ResetDaily();

	/// <summary>
	/// Event raised when a safety limit is breached.
	/// </summary>
	event Action<SafetyAlert>? OnAlert;

	/// <summary>
	/// Event raised when the kill switch is activated.
	/// </summary>
	event Action<string>? OnKillSwitchActivated;
}

/// <summary>
/// Current safety status snapshot.
/// </summary>
public sealed class SafetyStatus
{
	/// <summary>Whether it's safe to continue automation.</summary>
	public bool Safe { get; init; }

	/// <summary>Whether the kill switch is active.</summary>
	public bool KillSwitchActive { get; init; }

	/// <summary>Total amount spent today.</summary>
	public decimal DailySpend { get; init; }

	/// <summary>Daily spend limit.</summary>
	public decimal DailySpendLimit { get; init; }

	/// <summary>Net loss today (positive = loss amount).</summary>
	public decimal DailyNetLoss { get; init; }

	/// <summary>Daily loss limit.</summary>
	public decimal DailyLossLimit { get; init; }

	/// <summary>Current consecutive loss streak.</summary>
	public int ConsecutiveLosses { get; init; }

	/// <summary>Max consecutive losses before circuit break.</summary>
	public int MaxConsecutiveLosses { get; init; }

	/// <summary>Total spins today.</summary>
	public int TotalSpinsToday { get; init; }

	/// <summary>Current balance.</summary>
	public decimal CurrentBalance { get; init; }

	/// <summary>Balance alert threshold (fraction of starting balance).</summary>
	public decimal BalanceAlertThreshold { get; init; }

	/// <summary>List of active alerts.</summary>
	public List<string> ActiveAlerts { get; init; } = new();
}

/// <summary>
/// Safety alert raised when a metric approaches or exceeds its limit.
/// </summary>
public sealed class SafetyAlert
{
	/// <summary>Alert severity level.</summary>
	public AlertSeverity Severity { get; init; }

	/// <summary>Which metric triggered the alert.</summary>
	public string Metric { get; init; } = string.Empty;

	/// <summary>Current value of the metric.</summary>
	public decimal CurrentValue { get; init; }

	/// <summary>Limit value that was approached/exceeded.</summary>
	public decimal LimitValue { get; init; }

	/// <summary>Human-readable alert message.</summary>
	public string Message { get; init; } = string.Empty;

	/// <summary>When the alert was raised.</summary>
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;
}

/// <summary>
/// Alert severity levels.
/// </summary>
public enum AlertSeverity
{
	/// <summary>Informational — metric approaching limit (>75%).</summary>
	Warning,

	/// <summary>Critical — metric at or near limit (>90%).</summary>
	Critical,

	/// <summary>Emergency — limit breached, automation halted.</summary>
	Emergency,
}
