using System.Net;
using System.Text;
using System.Text.Json;

namespace P4NTHE0N.H4ND.Infrastructure;

/// <summary>
/// OPS-JP-001: Simple HTTP health endpoint that exposes spin metrics summary.
/// Runs in-process on a background thread. GET /health returns JSON spin summary.
/// </summary>
public sealed class SpinHealthEndpoint : IDisposable
{
	private readonly SpinMetrics _metrics;
	private readonly int _port;
	private HttpListener? _listener;
	private CancellationTokenSource? _cts;
	private Task? _listenTask;

	public SpinHealthEndpoint(SpinMetrics metrics, int port = 9280)
	{
		_metrics = metrics;
		_port = port;
	}

	/// <summary>
	/// Starts the HTTP listener on a background thread.
	/// </summary>
	public void Start()
	{
		try
		{
			_listener = new HttpListener();
			_listener.Prefixes.Add($"http://+:{_port}/");
			_listener.Start();

			_cts = new CancellationTokenSource();
			_listenTask = Task.Run(() => ListenLoop(_cts.Token));

			Console.WriteLine($"[SpinHealthEndpoint] Listening on http://localhost:{_port}/health");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[SpinHealthEndpoint] Failed to start on port {_port}: {ex.Message}");
			Console.WriteLine($"[SpinHealthEndpoint] Falling back to console-only metrics output");
			_listener = null;
		}
	}

	/// <summary>
	/// Logs the current summary to console (fallback when HTTP is unavailable).
	/// </summary>
	public void LogSummaryToConsole()
	{
		SpinSummary summary = _metrics.GetSummary(hours: 1);
		Console.WriteLine(summary.ToString());
	}

	private async Task ListenLoop(CancellationToken cancellationToken)
	{
		while (!cancellationToken.IsCancellationRequested && _listener != null && _listener.IsListening)
		{
			try
			{
				HttpListenerContext context = await _listener.GetContextAsync().WaitAsync(cancellationToken);
				await HandleRequest(context);
			}
			catch (OperationCanceledException)
			{
				break;
			}
			catch (ObjectDisposedException)
			{
				break;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[SpinHealthEndpoint] Request error: {ex.Message}");
			}
		}
	}

	private async Task HandleRequest(HttpListenerContext context)
	{
		HttpListenerResponse response = context.Response;

		try
		{
			string path = context.Request.Url?.AbsolutePath ?? "/";

			if (path == "/health" || path == "/")
			{
				SpinSummary summary = _metrics.GetSummary(hours: 1);
				string json = JsonSerializer.Serialize(summary, new JsonSerializerOptions { WriteIndented = true });
				byte[] buffer = Encoding.UTF8.GetBytes(json);

				response.ContentType = "application/json";
				response.StatusCode = 200;
				response.ContentLength64 = buffer.Length;
				await response.OutputStream.WriteAsync(buffer);
			}
			else
			{
				response.StatusCode = 404;
				byte[] buffer = Encoding.UTF8.GetBytes("{\"error\":\"Not found. Use /health\"}");
				response.ContentType = "application/json";
				response.ContentLength64 = buffer.Length;
				await response.OutputStream.WriteAsync(buffer);
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[SpinHealthEndpoint] Response error: {ex.Message}");
			response.StatusCode = 500;
		}
		finally
		{
			response.Close();
		}
	}

	public void Dispose()
	{
		_cts?.Cancel();

		if (_listener != null)
		{
			try
			{
				_listener.Stop();
				_listener.Close();
			}
			catch { }
		}

		_cts?.Dispose();
	}
}
