using System.IO;
using System.Net.WebSockets;
using System.Text;
using System.Text.Json;

namespace P4NTH30N.C0MMON.Infrastructure.Cdp;

/// <summary>
/// Chrome DevTools Protocol client that connects to a remote Chrome instance.
/// Replaces Selenium ChromeDriver for browser UI interaction (navigate, click, type, evaluate).
/// Game-server WebSocket balance queries are NOT handled here — they remain untouched.
/// </summary>
public sealed class CdpClient : ICdpClient
{
	private readonly CdpConfig _config;
	private readonly HttpClient _httpClient;
	private ClientWebSocket? _webSocket;
	private int _commandId;
	private string? _ownedTargetId;

	public bool IsConnected => _webSocket?.State == WebSocketState.Open;

	public CdpClient(CdpConfig config)
	{
		_config = config;
		_httpClient = new HttpClient { Timeout = TimeSpan.FromMilliseconds(_config.CommandTimeoutMs) };
	}

	public async Task<bool> ConnectAsync(CancellationToken cancellationToken = default)
	{
		try
		{
			// Create a dedicated tab for this client to avoid contention with other workers
			string? wsUrl = await CreateOwnedTabAsync(cancellationToken);
			if (wsUrl == null)
			{
				// Fallback: connect to an existing page if tab creation fails
				wsUrl = await FetchDebuggerUrlAsync(cancellationToken);
			}
			if (wsUrl == null)
			{
				Console.WriteLine("[CDP] No debuggable pages found in Chrome");
				return false;
			}

			_webSocket = new ClientWebSocket();
			await _webSocket.ConnectAsync(new Uri(wsUrl), cancellationToken);

			await SendCommandAsync("Runtime.enable", cancellationToken: cancellationToken);
			await SendCommandAsync("DOM.enable", cancellationToken: cancellationToken);
			await SendCommandAsync("Page.enable", cancellationToken: cancellationToken);

			Console.WriteLine($"[CDP] Connected to Chrome at {_config.HostIp}:{_config.Port}" +
				(_ownedTargetId != null ? $" (dedicated tab {_ownedTargetId[..8]}...)" : " (shared page)"));
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] Connect failed: {ex.Message}");
			return false;
		}
	}

	public async Task NavigateAsync(string url, CancellationToken cancellationToken = default)
	{
		await EnsureConnectedAsync(cancellationToken);
		await SendCommandAsync("Page.navigate", new { url }, cancellationToken);

		// Wait for Page.loadEventFired by polling document.readyState
		int waited = 0;
		while (waited < _config.CommandTimeoutMs)
		{
			string? readyState = await EvaluateAsync<string>("document.readyState", cancellationToken);
			if (readyState == "complete" || readyState == "interactive")
				return;
			await Task.Delay(200, cancellationToken);
			waited += 200;
		}
	}

	public async Task ClickAtAsync(int x, int y, CancellationToken cancellationToken = default)
	{
		await EnsureConnectedAsync(cancellationToken);
		await SendCommandAsync(
			"Input.dispatchMouseEvent",
			new
			{
				type = "mouseMoved",
				x,
				y,
			},
			cancellationToken
		);
		await SendCommandAsync(
			"Input.dispatchMouseEvent",
			new
			{
				type = "mousePressed",
				x,
				y,
				button = "left",
				clickCount = 1,
			},
			cancellationToken
		);
		await SendCommandAsync(
			"Input.dispatchMouseEvent",
			new
			{
				type = "mouseReleased",
				x,
				y,
				button = "left",
				clickCount = 1,
			},
			cancellationToken
		);
	}

	public async Task WaitForSelectorAndClickAsync(string selector, int? timeoutMs = null, CancellationToken cancellationToken = default)
	{
		await EnsureConnectedAsync(cancellationToken);
		int timeout = timeoutMs ?? _config.SelectorTimeoutMs;
		DateTime deadline = DateTime.UtcNow.AddMilliseconds(timeout);
		string escapedSelector = selector.Replace("'", "\\'");

		while (DateTime.UtcNow < deadline)
		{
			cancellationToken.ThrowIfCancellationRequested();

			bool? exists = await EvaluateAsync<bool>($"document.querySelector('{escapedSelector}') !== null", cancellationToken);
			if (exists == true)
			{
				// Resolve element center from DOM — no hardcoded coordinates
				string script =
					$@"
					(function() {{
						var el = document.querySelector('{escapedSelector}');
						var r = el.getBoundingClientRect();
						return JSON.stringify({{ x: Math.round(r.left + r.width / 2), y: Math.round(r.top + r.height / 2) }});
					}})()";

				string? json = await EvaluateAsync<string>(script, cancellationToken);
				if (json != null)
				{
					JsonElement pos = JsonSerializer.Deserialize<JsonElement>(json);
					int cx = pos.GetProperty("x").GetInt32();
					int cy = pos.GetProperty("y").GetInt32();
					await ClickAtAsync(cx, cy, cancellationToken);
					return;
				}
			}
			await Task.Delay(200, cancellationToken);
		}
		throw new TimeoutException($"[CDP] Selector '{selector}' not found within {timeout}ms");
	}

	public async Task FocusSelectorAndClearAsync(string selector, int? timeoutMs = null, CancellationToken cancellationToken = default)
	{
		await EnsureConnectedAsync(cancellationToken);
		int timeout = timeoutMs ?? _config.SelectorTimeoutMs;
		DateTime deadline = DateTime.UtcNow.AddMilliseconds(timeout);
		string escapedSelector = selector.Replace("'", "\\'");

		while (DateTime.UtcNow < deadline)
		{
			cancellationToken.ThrowIfCancellationRequested();

			bool? exists = await EvaluateAsync<bool>($"document.querySelector('{escapedSelector}') !== null", cancellationToken);
			if (exists == true)
			{
				await EvaluateAsync<object>(
					$@"
					(function() {{
						var el = document.querySelector('{escapedSelector}');
						el.focus();
						el.value = '';
						el.dispatchEvent(new Event('input', {{ bubbles: true }}));
					}})()",
					cancellationToken
				);
				return;
			}
			await Task.Delay(200, cancellationToken);
		}
		throw new TimeoutException($"[CDP] Selector '{selector}' not found for focus within {timeout}ms");
	}

	public async Task TypeTextAsync(string text, CancellationToken cancellationToken = default)
	{
		await EnsureConnectedAsync(cancellationToken);
		foreach (char c in text)
		{
			cancellationToken.ThrowIfCancellationRequested();
			await SendCommandAsync("Input.dispatchKeyEvent", new { type = "char", text = c.ToString() }, cancellationToken);
			await Task.Delay(50, cancellationToken);
		}
	}

	public async Task<T?> EvaluateAsync<T>(string expression, CancellationToken cancellationToken = default)
	{
		await EnsureConnectedAsync(cancellationToken);
		JsonElement result = await SendCommandAsync("Runtime.evaluate", new { expression, returnByValue = true }, cancellationToken);

		if (
			result.TryGetProperty("result", out JsonElement resultProp)
			&& resultProp.TryGetProperty("result", out JsonElement innerResult)
			&& innerResult.TryGetProperty("value", out JsonElement valueProp)
		)
		{
			return JsonSerializer.Deserialize<T>(valueProp.GetRawText());
		}

		// Fallback: some CDP responses nest differently
		if (result.TryGetProperty("result", out JsonElement flatResult) && flatResult.TryGetProperty("value", out JsonElement flatValue))
		{
			return JsonSerializer.Deserialize<T>(flatValue.GetRawText());
		}

		return default;
	}

	public async Task<JsonElement> SendCommandAsync(string method, object? parameters = null, CancellationToken cancellationToken = default)
	{
		if (_webSocket == null || _webSocket.State != WebSocketState.Open)
			throw new InvalidOperationException("[CDP] WebSocket not connected");

		int commandId = Interlocked.Increment(ref _commandId);
		object command = new
		{
			id = commandId,
			method,
			@params = parameters ?? new { },
		};

		byte[] bytes = Encoding.UTF8.GetBytes(JsonSerializer.Serialize(command));
		await _webSocket.SendAsync(new ArraySegment<byte>(bytes), WebSocketMessageType.Text, true, cancellationToken);

		// Read messages until we get the response matching our command id.
		// CDP sends async event notifications that must be skipped.
		byte[] buffer = new byte[16384];
		while (true)
		{
			cancellationToken.ThrowIfCancellationRequested();
			MemoryStream ms = new();
			WebSocketReceiveResult wsResult;
			do
			{
				wsResult = await _webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), cancellationToken);
				ms.Write(buffer, 0, wsResult.Count);
			} while (!wsResult.EndOfMessage);

			JsonElement message = JsonSerializer.Deserialize<JsonElement>(ms.ToArray());

			// Check if this is the response to our command (has "id" matching ours)
			if (message.TryGetProperty("id", out JsonElement idProp) && idProp.GetInt32() == commandId)
			{
				return message;
			}
			// Otherwise it's an event notification — skip and read next message
		}
	}

	public void Dispose()
	{
		if (_webSocket != null)
		{
			try
			{
				if (_webSocket.State == WebSocketState.Open)
				{
					_webSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, "Done", CancellationToken.None).GetAwaiter().GetResult();
				}
			}
			catch { }
			_webSocket.Dispose();
			_webSocket = null;
		}

		// Close the dedicated tab we created, so Chrome doesn't accumulate orphan tabs
		if (_ownedTargetId != null)
		{
			try
			{
				string closeUrl = $"http://{_config.HostIp}:{_config.Port}/json/close/{_ownedTargetId}";
				_httpClient.GetStringAsync(closeUrl).GetAwaiter().GetResult();
				Console.WriteLine($"[CDP] Closed dedicated tab {_ownedTargetId[..8]}...");
			}
			catch { /* Tab may already be closed */ }
			_ownedTargetId = null;
		}

		_httpClient.Dispose();
	}

	// --- Private helpers ---

	private async Task EnsureConnectedAsync(CancellationToken cancellationToken)
	{
		if (_webSocket?.State == WebSocketState.Open)
			return;

		int delayMs = _config.ReconnectBaseDelayMs;
		for (int attempt = 1; attempt <= _config.ReconnectRetries; attempt++)
		{
			try
			{
				_webSocket?.Dispose();
				_webSocket = new ClientWebSocket();

				// Reconnect to our owned tab if we have one, otherwise find any available page
				string? wsUrl = _ownedTargetId != null
					? await FetchOwnedTabWsUrlAsync(cancellationToken)
					: null;
				wsUrl ??= await FetchDebuggerUrlAsync(cancellationToken);
				if (wsUrl == null)
					throw new InvalidOperationException("No debuggable pages");

				await _webSocket.ConnectAsync(new Uri(wsUrl), cancellationToken);
				await SendCommandInternalAsync("Runtime.enable", cancellationToken);
				Console.WriteLine($"[CDP] Reconnected on attempt {attempt}");
				return;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[CDP] Reconnect attempt {attempt} failed: {ex.Message}");
				await Task.Delay(delayMs, cancellationToken);
				delayMs *= 2;
			}
		}
		throw new InvalidOperationException($"[CDP] Connection failed after {_config.ReconnectRetries} retries");
	}

	/// <summary>
	/// Creates a new dedicated browser tab via CDP /json/new and returns its WebSocket debugger URL.
	/// This ensures each CdpClient has its own isolated target, preventing contention between parallel workers.
	/// </summary>
	private async Task<string?> CreateOwnedTabAsync(CancellationToken cancellationToken)
	{
		try
		{
			string newTabUrl = $"http://{_config.HostIp}:{_config.Port}/json/new?about:blank";
			string response = await _httpClient.GetStringAsync(newTabUrl, cancellationToken);
			JsonElement tab = JsonSerializer.Deserialize<JsonElement>(response);

			if (tab.TryGetProperty("id", out JsonElement idProp))
				_ownedTargetId = idProp.GetString();

			if (tab.TryGetProperty("webSocketDebuggerUrl", out JsonElement wsUrlProp))
			{
				string? wsUrl = wsUrlProp.GetString();
				if (wsUrl != null && _config.HostIp != "localhost" && _config.HostIp != "127.0.0.1")
					wsUrl = wsUrl.Replace("ws://localhost:", $"ws://{_config.HostIp}:");
				return wsUrl;
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] Failed to create dedicated tab: {ex.Message} — falling back to existing page");
		}
		return null;
	}

	/// <summary>
	/// Looks up the WebSocket debugger URL for our owned tab by scanning /json/list for the matching target ID.
	/// Returns null if the tab no longer exists (e.g. Chrome crashed and restarted).
	/// </summary>
	private async Task<string?> FetchOwnedTabWsUrlAsync(CancellationToken cancellationToken)
	{
		if (_ownedTargetId == null) return null;

		try
		{
			string listUrl = $"http://{_config.HostIp}:{_config.Port}/json/list";
			string response = await _httpClient.GetStringAsync(listUrl, cancellationToken);
			JsonElement pages = JsonSerializer.Deserialize<JsonElement>(response);

			foreach (JsonElement page in pages.EnumerateArray())
			{
				if (page.TryGetProperty("id", out JsonElement idProp) && idProp.GetString() == _ownedTargetId
					&& page.TryGetProperty("webSocketDebuggerUrl", out JsonElement wsUrlProp))
				{
					string? wsUrl = wsUrlProp.GetString();
					if (wsUrl != null && _config.HostIp != "localhost" && _config.HostIp != "127.0.0.1")
						wsUrl = wsUrl.Replace("ws://localhost:", $"ws://{_config.HostIp}:");
					return wsUrl;
				}
			}
		}
		catch { /* Tab lookup failure is non-fatal — caller will fall back */ }

		// Owned tab is gone — clear the reference
		_ownedTargetId = null;
		return null;
	}

	private async Task<string?> FetchDebuggerUrlAsync(CancellationToken cancellationToken)
	{
		string listUrl = $"http://{_config.HostIp}:{_config.Port}/json/list";
		string response = await _httpClient.GetStringAsync(listUrl, cancellationToken);
		JsonElement pages = JsonSerializer.Deserialize<JsonElement>(response);

		foreach (JsonElement page in pages.EnumerateArray())
		{
			if (page.TryGetProperty("webSocketDebuggerUrl", out JsonElement wsUrlProp))
			{
				string? wsUrl = wsUrlProp.GetString();
				// CDP returns ws://localhost:PORT/... — replace with actual host IP for VM connectivity
				if (wsUrl != null && _config.HostIp != "localhost" && _config.HostIp != "127.0.0.1")
				{
					wsUrl = wsUrl.Replace("ws://localhost:", $"ws://{_config.HostIp}:");
				}
				return wsUrl;
			}
		}
		return null;
	}

	/// <summary>
	/// Raw send without EnsureConnected — used inside reconnect to avoid infinite recursion.
	/// </summary>
	private async Task SendCommandInternalAsync(string method, CancellationToken cancellationToken)
	{
		if (_webSocket == null || _webSocket.State != WebSocketState.Open)
			return;

		object command = new
		{
			id = Interlocked.Increment(ref _commandId),
			method,
			@params = new { },
		};

		byte[] bytes = Encoding.UTF8.GetBytes(JsonSerializer.Serialize(command));
		await _webSocket.SendAsync(new ArraySegment<byte>(bytes), WebSocketMessageType.Text, true, cancellationToken);

		byte[] buffer = new byte[4096];
		WebSocketReceiveResult wsResult;
		do
		{
			wsResult = await _webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), cancellationToken);
		} while (!wsResult.EndOfMessage);
	}
}
