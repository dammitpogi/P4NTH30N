using System.Net;
using System.Text;

namespace P4NTHE0N.H4ND.Monitoring;

/// <summary>
/// MON-057-002: Lightweight HTTP server for burn-in dashboard.
/// Serves JSON status at GET /monitor/burnin on port 5002.
/// Uses HttpListener — no ASP.NET dependency required.
/// </summary>
public sealed class BurnInDashboardServer : IDisposable
{
	private readonly BurnInMonitor _monitor;
	private readonly int _port;
	private HttpListener? _listener;
	private Task? _listenTask;
	private CancellationTokenSource? _cts;
	private bool _disposed;

	public bool IsRunning => _listener?.IsListening ?? false;

	public BurnInDashboardServer(BurnInMonitor monitor, int port = 5002)
	{
		_monitor = monitor;
		_port = port;
	}

	/// <summary>
	/// Starts the HTTP dashboard server.
	/// </summary>
	public void Start()
	{
		if (_listener != null) return;

		_cts = new CancellationTokenSource();

		try
		{
			_listener = new HttpListener();
			_listener.Prefixes.Add($"http://+:{_port}/");
			_listener.Start();
			_listenTask = Task.Run(() => ListenLoopAsync(_cts.Token));
			Console.WriteLine($"[BurnInDashboard] HTTP server started on port {_port}");
		}
		catch (HttpListenerException ex)
		{
			// Fallback to localhost-only if + prefix fails (no admin rights)
			Console.WriteLine($"[BurnInDashboard] Global prefix failed ({ex.Message}), falling back to localhost");
			_listener = new HttpListener();
			_listener.Prefixes.Add($"http://localhost:{_port}/");
			_listener.Start();
			_listenTask = Task.Run(() => ListenLoopAsync(_cts.Token));
			Console.WriteLine($"[BurnInDashboard] HTTP server started on http://localhost:{_port}");
		}
	}

	/// <summary>
	/// Stops the HTTP server.
	/// </summary>
	public void Stop()
	{
		_cts?.Cancel();
		_listener?.Stop();
	}

	private async Task ListenLoopAsync(CancellationToken ct)
	{
		while (!ct.IsCancellationRequested && _listener != null && _listener.IsListening)
		{
			try
			{
				var context = await _listener.GetContextAsync().WaitAsync(ct);
				_ = Task.Run(() => HandleRequestAsync(context), ct);
			}
			catch (OperationCanceledException) { break; }
			catch (HttpListenerException) { break; }
			catch (Exception ex)
			{
				Console.WriteLine($"[BurnInDashboard] Listener error: {ex.Message}");
			}
		}
	}

	private async Task HandleRequestAsync(HttpListenerContext context)
	{
		try
		{
			string path = context.Request.Url?.AbsolutePath ?? "/";
			string method = context.Request.HttpMethod;

			if (method == "GET" && (path == "/monitor/burnin" || path == "/monitor/burnin/"))
			{
				string json = _monitor.GetStatusJson();
				byte[] buffer = Encoding.UTF8.GetBytes(json);
				context.Response.ContentType = "application/json";
				context.Response.ContentLength64 = buffer.Length;
				context.Response.StatusCode = 200;
				AddCorsHeaders(context.Response);
				await context.Response.OutputStream.WriteAsync(buffer);
			}
			else if (method == "GET" && path == "/monitor/burnin/snapshots")
			{
				var snapshots = _monitor.Snapshots;
				string json = System.Text.Json.JsonSerializer.Serialize(snapshots,
					new System.Text.Json.JsonSerializerOptions { WriteIndented = true });
				byte[] buffer = Encoding.UTF8.GetBytes(json);
				context.Response.ContentType = "application/json";
				context.Response.ContentLength64 = buffer.Length;
				context.Response.StatusCode = 200;
				AddCorsHeaders(context.Response);
				await context.Response.OutputStream.WriteAsync(buffer);
			}
			else if (method == "GET" && path == "/health")
			{
				byte[] buffer = "{\"status\":\"ok\"}"u8.ToArray();
				context.Response.ContentType = "application/json";
				context.Response.ContentLength64 = buffer.Length;
				context.Response.StatusCode = 200;
				await context.Response.OutputStream.WriteAsync(buffer);
			}
			else
			{
				context.Response.StatusCode = 404;
				byte[] buffer = "{\"error\":\"Not found\"}"u8.ToArray();
				context.Response.ContentType = "application/json";
				context.Response.ContentLength64 = buffer.Length;
				await context.Response.OutputStream.WriteAsync(buffer);
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[BurnInDashboard] Request error: {ex.Message}");
			try { context.Response.StatusCode = 500; }
			catch { /* response may already be closed */ }
		}
		finally
		{
			try { context.Response.Close(); }
			catch { /* ignore */ }
		}
	}

	private static void AddCorsHeaders(HttpListenerResponse response)
	{
		response.Headers.Add("Access-Control-Allow-Origin", "*");
		response.Headers.Add("Access-Control-Allow-Methods", "GET, OPTIONS");
	}

	public void Dispose()
	{
		if (_disposed) return;
		_disposed = true;
		Stop();
		_listener?.Close();
		_cts?.Dispose();
	}
}
