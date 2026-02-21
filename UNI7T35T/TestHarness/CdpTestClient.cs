using System;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.UNI7T35T.TestHarness;

/// <summary>
/// TEST-035: CDP wrapper for test isolation.
/// Provides CDP functionality with test-specific error handling, timeouts, and screenshot capture.
/// </summary>
public sealed class CdpTestClient : IDisposable
{
	private readonly ICdpClient _cdp;
	private readonly int _defaultTimeoutMs;
	private bool _disposed;

	/// <summary>
	/// Whether the underlying CDP client is connected.
	/// </summary>
	public bool IsConnected => _cdp.IsConnected;

	public CdpTestClient(ICdpClient cdpClient, int defaultTimeoutMs = 10000)
	{
		_cdp = cdpClient ?? throw new ArgumentNullException(nameof(cdpClient));
		_defaultTimeoutMs = defaultTimeoutMs;
	}

	/// <summary>
	/// Connects to Chrome CDP endpoint.
	/// </summary>
	public async Task<bool> ConnectAsync(CancellationToken ct = default)
	{
		try
		{
			bool connected = await _cdp.ConnectAsync(ct);
			Console.WriteLine($"[CdpTestClient] Connect: {(connected ? "OK" : "FAILED")}");
			return connected;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CdpTestClient] Connect error: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Navigates to a URL with timeout.
	/// </summary>
	public async Task<bool> NavigateAsync(string url, CancellationToken ct = default)
	{
		try
		{
			await _cdp.NavigateAsync(url, ct);
			Console.WriteLine($"[CdpTestClient] Navigated to {url}");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CdpTestClient] Navigate failed: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Evaluates JavaScript and returns the result.
	/// </summary>
	public async Task<T?> EvaluateAsync<T>(string expression, CancellationToken ct = default)
	{
		return await _cdp.EvaluateAsync<T>(expression, ct);
	}

	/// <summary>
	/// Captures a screenshot via CDP Page.captureScreenshot.
	/// Returns base64-encoded PNG data.
	/// </summary>
	public async Task<string?> CaptureScreenshotAsync(CancellationToken ct = default)
	{
		try
		{
			JsonElement response = await _cdp.SendCommandAsync("Page.captureScreenshot", new { format = "png" }, ct);
			if (response.TryGetProperty("data", out JsonElement dataElement))
			{
				return dataElement.GetString();
			}
			return null;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CdpTestClient] Screenshot failed: {ex.Message}");
			return null;
		}
	}

	/// <summary>
	/// Waits for a selector and clicks it.
	/// </summary>
	public async Task<bool> ClickSelectorAsync(string selector, int? timeoutMs = null, CancellationToken ct = default)
	{
		try
		{
			await _cdp.WaitForSelectorAndClickAsync(selector, timeoutMs ?? _defaultTimeoutMs, ct);
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CdpTestClient] Click '{selector}' failed: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Gets the underlying CDP client for advanced operations.
	/// </summary>
	public ICdpClient GetInnerClient() => _cdp;

	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_cdp.Dispose();
		}
	}
}
