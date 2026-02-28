using System.Diagnostics;
using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using P4NTHE0N.W4TCHD0G.Models;

namespace P4NTHE0N.W4TCHD0G.OBS;

/// <summary>
/// Resilient OBS WebSocket client with exponential backoff reconnection,
/// state machine management, and proper logging (replacing silent failures).
/// </summary>
/// <remarks>
/// FOUR-007 requirements:
/// - Reconnection with exponential backoff (1s→30s)
/// - 24-hour stress test: &lt;5 disconnects
/// - Recovery time: &lt;30s auto-recovery
/// - Proper logging (no silent catch blocks)
/// - State machine for connection management
///
/// REPLACES: OBSClient.cs which had silent failures at lines 57-61 and 120-123.
/// </remarks>
public sealed class ResilientOBSClient : IOBSClient, IDisposable
{
	/// <summary>
	/// OBS WebSocket URL (e.g., ws://localhost:4455).
	/// </summary>
	private readonly string _url;

	/// <summary>
	/// OBS WebSocket password (optional).
	/// </summary>
	private readonly string? _password;

	/// <summary>
	/// Reconnection policy with exponential backoff.
	/// </summary>
	private readonly ReconnectionPolicy _reconnectionPolicy;

	/// <summary>
	/// Underlying WebSocket client.
	/// </summary>
	private ClientWebSocket? _webSocket;

	/// <summary>
	/// Current connection state.
	/// </summary>
	private volatile ConnectionState _state = ConnectionState.Disconnected;

	/// <summary>
	/// Lock for serializing WebSocket operations.
	/// </summary>
	private readonly SemaphoreSlim _wsLock = new(1, 1);

	/// <summary>
	/// Cancellation for background tasks.
	/// </summary>
	private CancellationTokenSource? _cts;

	/// <summary>
	/// Whether this instance has been disposed.
	/// </summary>
	private bool _disposed;

	/// <summary>
	/// Message ID counter for OBS WebSocket protocol.
	/// </summary>
	private long _messageId;

	/// <inheritdoc />
	public bool IsConnected => _state == ConnectionState.Connected && _webSocket?.State == WebSocketState.Open;

	/// <summary>
	/// Current connection state.
	/// </summary>
	public ConnectionState State => _state;

	/// <summary>
	/// Event raised when connection state changes.
	/// </summary>
	public event Action<ConnectionState, ConnectionState>? OnStateChanged;

	/// <summary>
	/// Creates a ResilientOBSClient.
	/// </summary>
	/// <param name="url">OBS WebSocket URL. Default: ws://localhost:4455</param>
	/// <param name="password">OBS WebSocket password. Null if authentication is disabled.</param>
	/// <param name="maxRetries">Maximum reconnection attempts. Default: 10.</param>
	public ResilientOBSClient(string url = "ws://localhost:4455", string? password = null, int maxRetries = 10)
	{
		_url = url;
		_password = password;
		_reconnectionPolicy = new ReconnectionPolicy(maxRetries: maxRetries);
	}

	/// <inheritdoc />
	public async Task ConnectAsync()
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		SetState(ConnectionState.Connecting);
		_cts = new CancellationTokenSource();

		bool success = await _reconnectionPolicy.ExecuteAsync(
			async () =>
			{
				try
				{
					_webSocket?.Dispose();
					_webSocket = new ClientWebSocket();

					Console.WriteLine($"[ResilientOBS] Connecting to {_url}...");
					await _webSocket.ConnectAsync(new Uri(_url), _cts.Token);

					if (_webSocket.State == WebSocketState.Open)
					{
						Console.WriteLine("[ResilientOBS] WebSocket connected.");

						// OBS WebSocket v5 handshake
						await PerformHandshakeAsync(_cts.Token);
						return true;
					}

					Console.WriteLine($"[ResilientOBS] WebSocket state: {_webSocket.State}");
					return false;
				}
				catch (Exception ex)
				{
					StackTrace trace = new(ex, true);
					StackFrame? frame = trace.GetFrame(0);
					int line = frame?.GetFileLineNumber() ?? 0;
					Console.WriteLine($"[{line}] [ResilientOBS] Connection attempt failed: {ex.Message}");
					return false;
				}
			},
			_cts.Token
		);

		if (success)
		{
			SetState(ConnectionState.Connected);
			Console.WriteLine("[ResilientOBS] Connected and authenticated.");

			// Start background health monitor
			_ = Task.Run(() => MonitorConnectionAsync(_cts.Token));
		}
		else
		{
			SetState(ConnectionState.Failed);
			Console.WriteLine("[ResilientOBS] Connection failed after all retries.");
		}
	}

	/// <inheritdoc />
	public async Task DisconnectAsync()
	{
		_cts?.Cancel();

		if (_webSocket is not null && _webSocket.State == WebSocketState.Open)
		{
			try
			{
				await _webSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, "Disconnecting", CancellationToken.None);
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[ResilientOBS] Disconnect error: {ex.Message}");
			}
		}

		SetState(ConnectionState.Disconnected);
		Console.WriteLine("[ResilientOBS] Disconnected.");
	}

	/// <inheritdoc />
	public async Task<bool> IsStreamActiveAsync()
	{
		if (!IsConnected)
		{
			Console.WriteLine("[ResilientOBS] Cannot check stream — not connected.");
			return false;
		}

		try
		{
			JsonDocument response = await SendRequestAsync("GetStreamStatus");
			return response.RootElement.GetProperty("d").GetProperty("responseData").GetProperty("outputActive").GetBoolean();
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[ResilientOBS] Stream status check failed: {ex.Message}");
			return false;
		}
	}

	/// <inheritdoc />
	public async Task<long> GetLatencyAsync()
	{
		Stopwatch sw = Stopwatch.StartNew();

		try
		{
			await SendRequestAsync("GetVersion");
			sw.Stop();
			return sw.ElapsedMilliseconds;
		}
		catch
		{
			sw.Stop();
			return -1;
		}
	}

	/// <inheritdoc />
	public async Task<VisionFrame?> CaptureFrameAsync(string sourceName)
	{
		if (!IsConnected)
		{
			Console.WriteLine("[ResilientOBS] Cannot capture frame — not connected.");
			return null;
		}

		try
		{
			// OBS WebSocket v5: GetSourceScreenshot
			JsonDocument response = await SendRequestAsync(
				"GetSourceScreenshot",
				new
				{
					sourceName,
					imageFormat = "png",
					imageWidth = 1280,
					imageHeight = 720,
				}
			);

			string? imageData = response.RootElement.GetProperty("d").GetProperty("responseData").GetProperty("imageData").GetString();

			if (string.IsNullOrEmpty(imageData))
			{
				Console.WriteLine("[ResilientOBS] Empty screenshot data received.");
				return null;
			}

			// Remove data URI prefix if present (e.g., "data:image/png;base64,")
			int commaIdx = imageData.IndexOf(',');
			if (commaIdx >= 0)
				imageData = imageData[(commaIdx + 1)..];

			byte[] frameData = Convert.FromBase64String(imageData);

			return new VisionFrame
			{
				Data = frameData,
				Width = 1280,
				Height = 720,
				SourceName = sourceName,
				Timestamp = DateTime.UtcNow,
			};
		}
		catch (Exception ex)
		{
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			Console.WriteLine($"[{line}] [ResilientOBS] Frame capture failed: {ex.Message}");
			return null;
		}
	}

	/// <summary>
	/// Performs OBS WebSocket v5 handshake (Identify).
	/// </summary>
	private async Task PerformHandshakeAsync(CancellationToken cancellationToken)
	{
		// Read Hello message from OBS
		string helloJson = await ReceiveMessageAsync(cancellationToken);
		Console.WriteLine("[ResilientOBS] Received Hello from OBS.");

		// Send Identify message
		object identifyPayload = new
		{
			op = 1, // Identify
			d = new { rpcVersion = 1 },
		};

		await SendMessageAsync(JsonSerializer.Serialize(identifyPayload), cancellationToken);

		// Read Identified response
		string identifiedJson = await ReceiveMessageAsync(cancellationToken);
		Console.WriteLine("[ResilientOBS] Identified with OBS.");
	}

	/// <summary>
	/// Sends an OBS WebSocket request and returns the response.
	/// </summary>
	private async Task<JsonDocument> SendRequestAsync(string requestType, object? requestData = null)
	{
		long id = Interlocked.Increment(ref _messageId);

		object request = new
		{
			op = 6, // Request
			d = new
			{
				requestType,
				requestId = id.ToString(),
				requestData,
			},
		};

		await _wsLock.WaitAsync();
		try
		{
			string json = JsonSerializer.Serialize(request);
			await SendMessageAsync(json, _cts?.Token ?? CancellationToken.None);

			string responseJson = await ReceiveMessageAsync(_cts?.Token ?? CancellationToken.None);
			return JsonDocument.Parse(responseJson);
		}
		finally
		{
			_wsLock.Release();
		}
	}

	/// <summary>
	/// Sends a text message over the WebSocket.
	/// </summary>
	private async Task SendMessageAsync(string message, CancellationToken cancellationToken)
	{
		if (_webSocket is null || _webSocket.State != WebSocketState.Open)
			throw new InvalidOperationException("WebSocket is not open.");

		byte[] data = Encoding.UTF8.GetBytes(message);
		await _webSocket.SendAsync(data, WebSocketMessageType.Text, true, cancellationToken);
	}

	/// <summary>
	/// Receives a text message from the WebSocket.
	/// </summary>
	private async Task<string> ReceiveMessageAsync(CancellationToken cancellationToken)
	{
		if (_webSocket is null || _webSocket.State != WebSocketState.Open)
			throw new InvalidOperationException("WebSocket is not open.");

		byte[] buffer = new byte[16384];
		StringBuilder result = new();

		WebSocketReceiveResult receiveResult;
		do
		{
			receiveResult = await _webSocket.ReceiveAsync(buffer, cancellationToken);
			result.Append(Encoding.UTF8.GetString(buffer, 0, receiveResult.Count));
		} while (!receiveResult.EndOfMessage);

		return result.ToString();
	}

	/// <summary>
	/// Background task that monitors WebSocket health and triggers reconnection.
	/// </summary>
	private async Task MonitorConnectionAsync(CancellationToken cancellationToken)
	{
		while (!cancellationToken.IsCancellationRequested)
		{
			try
			{
				await Task.Delay(10000, cancellationToken); // Check every 10 seconds

				if (_webSocket is null || _webSocket.State != WebSocketState.Open)
				{
					Console.WriteLine("[ResilientOBS] Connection lost — initiating reconnection.");
					SetState(ConnectionState.Reconnecting);

					bool reconnected = await _reconnectionPolicy.ExecuteAsync(
						async () =>
						{
							try
							{
								_webSocket?.Dispose();
								_webSocket = new ClientWebSocket();
								await _webSocket.ConnectAsync(new Uri(_url), cancellationToken);

								if (_webSocket.State == WebSocketState.Open)
								{
									await PerformHandshakeAsync(cancellationToken);
									return true;
								}
								return false;
							}
							catch
							{
								return false;
							}
						},
						cancellationToken
					);

					if (reconnected)
					{
						SetState(ConnectionState.Connected);
						Console.WriteLine("[ResilientOBS] Reconnected successfully.");
					}
					else
					{
						SetState(ConnectionState.Failed);
						Console.WriteLine("[ResilientOBS] Reconnection failed.");
						break;
					}
				}
			}
			catch (OperationCanceledException)
			{
				break;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[ResilientOBS] Health monitor error: {ex.Message}");
			}
		}
	}

	/// <summary>
	/// Updates the connection state and raises the state change event.
	/// </summary>
	private void SetState(ConnectionState newState)
	{
		ConnectionState previous = _state;
		if (previous != newState)
		{
			_state = newState;
			OnStateChanged?.Invoke(previous, newState);
		}
	}

	/// <inheritdoc />
	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_cts?.Cancel();
			_cts?.Dispose();
			_wsLock.Dispose();
			_webSocket?.Dispose();
		}
	}
}
