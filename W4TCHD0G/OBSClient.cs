using System;
using System.Diagnostics;
using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.W4TCHD0G.Configuration;
using P4NTHE0N.W4TCHD0G.Models;

namespace P4NTHE0N.W4TCHD0G;

public class OBSClient : IOBSClient, IDisposable
{
	private readonly OBSConfig _config;
	private ClientWebSocket? _ws;
	private bool _disposed;
	private int _frameCounter;

	public bool IsConnected => _ws?.State == WebSocketState.Open;

	public OBSClient(OBSConfig? config = null)
	{
		_config = config ?? new OBSConfig();
	}

	public async Task ConnectAsync()
	{
		_ws?.Dispose();
		_ws = new ClientWebSocket();
		await _ws.ConnectAsync(new Uri(_config.WebSocketUrl), CancellationToken.None);
	}

	public async Task DisconnectAsync()
	{
		if (_ws != null && _ws.State == WebSocketState.Open)
		{
			await _ws.CloseAsync(WebSocketCloseStatus.NormalClosure, "Shutdown", CancellationToken.None);
		}
	}

	public async Task<bool> IsStreamActiveAsync()
	{
		if (!IsConnected)
			return false;

		try
		{
			string response = await SendRequestAsync("GetStreamStatus");
			using JsonDocument doc = JsonDocument.Parse(response);
			if (doc.RootElement.TryGetProperty("d", out JsonElement d) && d.TryGetProperty("responseData", out JsonElement data))
			{
				return data.TryGetProperty("outputActive", out JsonElement active) && active.GetBoolean();
			}
			return false;
		}
		catch
		{
			return false;
		}
	}

	public async Task<long> GetLatencyAsync()
	{
		Stopwatch sw = Stopwatch.StartNew();
		await SendRequestAsync("GetVersion");
		sw.Stop();
		return sw.ElapsedMilliseconds;
	}

	public async Task<VisionFrame?> CaptureFrameAsync(string sourceName)
	{
		if (!IsConnected)
			return null;

		try
		{
			string request = JsonSerializer.Serialize(
				new
				{
					op = 6,
					d = new
					{
						requestType = "GetSourceScreenshot",
						requestId = Guid.NewGuid().ToString(),
						requestData = new
						{
							sourceName = sourceName,
							imageFormat = "png",
							imageWidth = 1280,
							imageHeight = 720,
						},
					},
				}
			);

			string response = await SendRawAsync(request);
			using JsonDocument doc = JsonDocument.Parse(response);

			if (doc.RootElement.TryGetProperty("d", out JsonElement d) && d.TryGetProperty("responseData", out JsonElement data))
			{
				string? imageData = data.GetProperty("imageData").GetString();
				if (imageData != null)
				{
					string base64 = imageData.Contains(",") ? imageData.Split(',')[1] : imageData;
					byte[] bytes = Convert.FromBase64String(base64);
					return new VisionFrame
					{
						Data = bytes,
						Width = 1280,
						Height = 720,
						SourceName = sourceName,
						FrameNumber = Interlocked.Increment(ref _frameCounter),
						Timestamp = DateTime.UtcNow,
					};
				}
			}
			return null;
		}
		catch
		{
			return null;
		}
	}

	private async Task<string> SendRequestAsync(string requestType)
	{
		string request = JsonSerializer.Serialize(new { op = 6, d = new { requestType = requestType, requestId = Guid.NewGuid().ToString() } });
		return await SendRawAsync(request);
	}

	private async Task<string> SendRawAsync(string json)
	{
		if (_ws == null || _ws.State != WebSocketState.Open)
			throw new InvalidOperationException("WebSocket not connected");

		byte[] sendBuffer = Encoding.UTF8.GetBytes(json);
		await _ws.SendAsync(new ArraySegment<byte>(sendBuffer), WebSocketMessageType.Text, true, CancellationToken.None);

		byte[] receiveBuffer = new byte[65536];
		WebSocketReceiveResult result = await _ws.ReceiveAsync(new ArraySegment<byte>(receiveBuffer), CancellationToken.None);
		return Encoding.UTF8.GetString(receiveBuffer, 0, result.Count);
	}

	public void Dispose()
	{
		if (!_disposed)
		{
			_ws?.Dispose();
			_disposed = true;
		}
	}
}
