namespace P4NTHE0N.W4TCHD0G.Monitoring;

/// <summary>
/// Delivers jackpot win alerts through multiple channels: console, file log,
/// and webhook (for future Slack/Discord/email integration).
/// </summary>
/// <remarks>
/// ALERT CHANNELS:
/// 1. Console output (always active)
/// 2. File log (win-events.log)
/// 3. Webhook POST (configurable URL for Slack/Discord/custom)
///
/// All channels fire in parallel. Failure in one channel doesn't block others.
/// </remarks>
public sealed class JackpotAlertService : IDisposable
{
	/// <summary>
	/// Path to the win events log file.
	/// </summary>
	private readonly string _logFilePath;

	/// <summary>
	/// Optional webhook URL for external alerts.
	/// </summary>
	private readonly string? _webhookUrl;

	/// <summary>
	/// HTTP client for webhook delivery.
	/// </summary>
	private readonly HttpClient? _httpClient;

	/// <summary>
	/// Directory for storing win screenshots.
	/// </summary>
	private readonly string _screenshotDirectory;

	/// <summary>
	/// Whether this instance has been disposed.
	/// </summary>
	private bool _disposed;

	/// <summary>
	/// Creates a JackpotAlertService.
	/// </summary>
	/// <param name="logFilePath">Path for win event log. Default: win-events.log in app directory.</param>
	/// <param name="webhookUrl">Optional webhook URL for external alerts (Slack, Discord, etc.).</param>
	/// <param name="screenshotDirectory">Directory for win screenshots. Default: screenshots/ in app directory.</param>
	public JackpotAlertService(string? logFilePath = null, string? webhookUrl = null, string? screenshotDirectory = null)
	{
		_logFilePath = logFilePath ?? Path.Combine(AppContext.BaseDirectory, "win-events.log");
		_webhookUrl = webhookUrl;
		_screenshotDirectory = screenshotDirectory ?? Path.Combine(AppContext.BaseDirectory, "screenshots");

		if (!string.IsNullOrWhiteSpace(_webhookUrl))
		{
			_httpClient = new HttpClient();
			_httpClient.Timeout = TimeSpan.FromSeconds(10);
		}

		// Ensure screenshot directory exists
		if (!Directory.Exists(_screenshotDirectory))
			Directory.CreateDirectory(_screenshotDirectory);
	}

	/// <summary>
	/// Sends alerts for a detected win event through all configured channels.
	/// </summary>
	/// <param name="winEvent">The win event to alert on.</param>
	public async Task AlertAsync(WinEvent winEvent)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		// Fire all channels in parallel — one failure doesn't block others
		List<Task> alertTasks = new() { Task.Run(() => AlertConsole(winEvent)), Task.Run(() => AlertFileLog(winEvent)) };

		if (_httpClient is not null && !string.IsNullOrWhiteSpace(_webhookUrl))
		{
			alertTasks.Add(AlertWebhookAsync(winEvent));
		}

		// Save screenshot if available
		if (winEvent.FrameSnapshot is not null && winEvent.FrameSnapshot.Length > 0)
		{
			alertTasks.Add(Task.Run(() => SaveScreenshot(winEvent)));
		}

		try
		{
			await Task.WhenAll(alertTasks);
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[JackpotAlert] One or more alert channels failed: {ex.Message}");
		}
	}

	/// <summary>
	/// Console alert with prominent formatting.
	/// </summary>
	private void AlertConsole(WinEvent winEvent)
	{
		string separator = new('=', 60);
		string winTypeLabel = winEvent.Type == WinType.Jackpot ? "JACKPOT WIN" : "WIN DETECTED";

		Console.WriteLine();
		Console.WriteLine(separator);
		Console.WriteLine($"  *** {winTypeLabel} ***");
		Console.WriteLine(separator);
		Console.WriteLine($"  Amount:      ${winEvent.Amount:F2}");
		if (!string.IsNullOrEmpty(winEvent.JackpotTier))
			Console.WriteLine($"  Tier:        {winEvent.JackpotTier}");
		Console.WriteLine($"  Balance:     ${winEvent.PreviousBalance:F2} → ${winEvent.NewBalance:F2}");
		Console.WriteLine($"  Detection:   {winEvent.DetectionMethod}");
		Console.WriteLine($"  Confidence:  {winEvent.Confidence:P0}");
		Console.WriteLine($"  Time:        {winEvent.Timestamp:yyyy-MM-dd HH:mm:ss.fff} UTC");
		Console.WriteLine($"  Our Win:     {(winEvent.IsOurWin ? "YES" : "NO")}");
		Console.WriteLine(separator);
		Console.WriteLine();
	}

	/// <summary>
	/// Appends win event to the log file.
	/// </summary>
	private void AlertFileLog(WinEvent winEvent)
	{
		try
		{
			string logEntry = string.Join(
				"\t",
				winEvent.Timestamp.ToString("o"),
				winEvent.Type,
				$"${winEvent.Amount:F2}",
				winEvent.JackpotTier ?? "-",
				$"${winEvent.PreviousBalance:F2}",
				$"${winEvent.NewBalance:F2}",
				winEvent.DetectionMethod,
				$"{winEvent.Confidence:F2}",
				winEvent.IsOurWin ? "OUR_WIN" : "OTHER_WIN",
				winEvent.GameState
			);

			File.AppendAllText(_logFilePath, logEntry + Environment.NewLine);
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[JackpotAlert] File log failed: {ex.Message}");
		}
	}

	/// <summary>
	/// Sends a webhook POST with win event data.
	/// Compatible with Slack/Discord incoming webhook format.
	/// </summary>
	private async Task AlertWebhookAsync(WinEvent winEvent)
	{
		if (_httpClient is null || string.IsNullOrWhiteSpace(_webhookUrl))
			return;

		try
		{
			string emoji = winEvent.Type == WinType.Jackpot ? ":moneybag:" : ":white_check_mark:";
			string tierInfo = string.IsNullOrEmpty(winEvent.JackpotTier) ? "" : $" ({winEvent.JackpotTier})";

			// Slack/Discord compatible payload
			string payload = System.Text.Json.JsonSerializer.Serialize(
				new
				{
					text = $"{emoji} *{winEvent.Type}{tierInfo}* — ${winEvent.Amount:F2}\n"
						+ $"Balance: ${winEvent.PreviousBalance:F2} → ${winEvent.NewBalance:F2}\n"
						+ $"Detection: {winEvent.DetectionMethod} ({winEvent.Confidence:P0})\n"
						+ $"Time: {winEvent.Timestamp:yyyy-MM-dd HH:mm:ss} UTC",
				}
			);

			using StringContent content = new(payload, System.Text.Encoding.UTF8, "application/json");
			HttpResponseMessage response = await _httpClient.PostAsync(_webhookUrl, content);

			if (!response.IsSuccessStatusCode)
			{
				Console.WriteLine($"[JackpotAlert] Webhook returned {response.StatusCode}");
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[JackpotAlert] Webhook failed: {ex.Message}");
		}
	}

	/// <summary>
	/// Saves the win frame as a screenshot file.
	/// </summary>
	private void SaveScreenshot(WinEvent winEvent)
	{
		try
		{
			string fileName = $"win_{winEvent.Timestamp:yyyyMMdd_HHmmss}_{winEvent.Type}.bin";
			string filePath = Path.Combine(_screenshotDirectory, fileName);
			File.WriteAllBytes(filePath, winEvent.FrameSnapshot!);
			Console.WriteLine($"[JackpotAlert] Screenshot saved: {filePath}");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[JackpotAlert] Screenshot save failed: {ex.Message}");
		}
	}

	/// <inheritdoc />
	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_httpClient?.Dispose();
		}
	}
}
