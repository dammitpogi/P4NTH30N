using System.Text.Json;

namespace P4NTH30N.H4ND.Monitoring;

/// <summary>
/// MON-058: Dispatches burn-in alerts through configured notification channels.
/// Supports Console, WebSocket (via BurnInMonitor.PushAlert), and File logging.
/// </summary>
public sealed class AlertNotificationDispatcher
{
	private readonly BurnInAlertConfig _config;
	private readonly BurnInMonitor? _monitor;
	private readonly string _alertLogPath;

	public AlertNotificationDispatcher(BurnInAlertConfig config, BurnInMonitor? monitor = null, string? alertLogDir = null)
	{
		_config = config;
		_monitor = monitor;
		string logDir = alertLogDir ?? Path.Combine(AppContext.BaseDirectory, "logs");
		Directory.CreateDirectory(logDir);
		_alertLogPath = Path.Combine(logDir, $"burnin-alerts-{DateTime.UtcNow:yyyyMMdd-HHmmss}.log");
	}

	/// <summary>
	/// Dispatches a list of alerts through all configured channels.
	/// Only dispatches WARN and CRITICAL (INFO is logged at debug level only).
	/// </summary>
	public void Dispatch(List<BurnInAlert> alerts)
	{
		foreach (var alert in alerts)
		{
			if (alert.Severity == AlertSeverity.Info) continue;

			foreach (string channel in _config.NotificationChannels)
			{
				switch (channel)
				{
					case "Console":
						DispatchConsole(alert);
						break;
					case "WebSocket":
						DispatchWebSocket(alert);
						break;
					case "File":
						DispatchFile(alert);
						break;
				}
			}
		}
	}

	/// <summary>
	/// Dispatches a single alert.
	/// </summary>
	public void DispatchSingle(BurnInAlert alert)
	{
		Dispatch([alert]);
	}

	private void DispatchConsole(BurnInAlert alert)
	{
		string prefix = alert.Severity switch
		{
			AlertSeverity.Warn => "[WARN]",
			AlertSeverity.Critical => "[CRITICAL]",
			_ => "[INFO]",
		};
		Console.WriteLine($"[BurnInAlert] {prefix} {alert.Category}: {alert.Message}");
	}

	private void DispatchWebSocket(BurnInAlert alert)
	{
		_monitor?.PushAlert(JsonSerializer.Serialize(new
		{
			severity = alert.Severity.ToString(),
			category = alert.Category,
			message = alert.Message,
			timestamp = alert.Timestamp,
			metricValue = alert.MetricValue,
			thresholdValue = alert.ThresholdValue,
		}));
	}

	private void DispatchFile(BurnInAlert alert)
	{
		try
		{
			string line = $"{alert.Timestamp:O}\t{alert.Severity}\t{alert.Category}\t{alert.Message}" +
				(alert.MetricValue.HasValue ? $"\tvalue={alert.MetricValue:F4}\tthreshold={alert.ThresholdValue:F4}" : "") +
				Environment.NewLine;
			File.AppendAllText(_alertLogPath, line);
		}
		catch { /* File write error is non-fatal */ }
	}
}
