using System.Diagnostics;
using System.Net.Sockets;
using System.Text;

namespace P4NTH30N.W4TCHD0G.Input;

/// <summary>
/// Minimal Synergy protocol client for programmatic VM input control.
/// Connects to a Synergy/Barrier/InputLeap server and sends mouse/keyboard events.
/// </summary>
/// <remarks>
/// SYNERGY PROTOCOL (simplified):
/// - TCP connection on port 24800
/// - Binary packet format: [4-byte length][packet data]
/// - Handshake: Server sends "Synergy" banner → Client responds with client name
/// - Input events: Mouse move (DMMV), mouse click (DMDN/DMUP), key press (DKDN/DKUP)
///
/// DECISION: Minimal protocol implementation (Option B per FOUR-004).
/// Only implements the subset needed for input control:
/// - Connection handshake
/// - Mouse move/click events
/// - Keyboard press/release events
/// - Keepalive/heartbeat
///
/// TIMEOUT: 2 seconds per action (Oracle requirement).
/// RECONNECT: Automatic with exponential backoff.
/// </remarks>
public sealed class SynergyClient : ISynergyClient
{
	/// <summary>
	/// Synergy protocol version string.
	/// </summary>
	private const string ProtocolVersion = "Synergy 1 6";

	/// <summary>
	/// Maximum reconnection attempts before giving up.
	/// </summary>
	private const int MaxReconnectAttempts = 5;

	/// <summary>
	/// Base reconnection delay in milliseconds (doubles each attempt).
	/// </summary>
	private const int BaseReconnectDelayMs = 1000;

	/// <summary>
	/// TCP client for the Synergy connection.
	/// </summary>
	private TcpClient? _tcpClient;

	/// <summary>
	/// Network stream for reading/writing Synergy packets.
	/// </summary>
	private NetworkStream? _stream;

	/// <summary>
	/// Action queue for sequential execution.
	/// </summary>
	private readonly ActionQueue _actionQueue = new();

	/// <summary>
	/// Screen coordinate mapper.
	/// </summary>
	private readonly ScreenMapper _screenMapper;

	/// <summary>
	/// Keepalive timer.
	/// </summary>
	private Timer? _keepaliveTimer;

	/// <summary>
	/// Lock for serializing network writes.
	/// </summary>
	private readonly SemaphoreSlim _writeLock = new(1, 1);

	/// <summary>
	/// Connection state tracking.
	/// </summary>
	private volatile bool _isConnected;

	/// <summary>
	/// Connection details for reconnection.
	/// </summary>
	private string _hostIp = string.Empty;
	private int _port;
	private string _clientName = "P4NTH30N";

	/// <summary>
	/// Whether this instance has been disposed.
	/// </summary>
	private bool _disposed;

	/// <inheritdoc />
	public bool IsConnected => _isConnected && _tcpClient?.Connected == true;

	/// <inheritdoc />
	public event Action<string>? OnDisconnected;

	/// <inheritdoc />
	public event Action? OnReconnected;

	/// <summary>
	/// Creates a SynergyClient with the specified screen mapper.
	/// </summary>
	/// <param name="screenMapper">Coordinate mapper for frame → VM translation. If null, 1:1 mapping is used.</param>
	public SynergyClient(ScreenMapper? screenMapper = null)
	{
		_screenMapper = screenMapper ?? new ScreenMapper(1920, 1080, 1920, 1080);
	}

	/// <inheritdoc />
	public async Task ConnectAsync(
		string hostIp,
		int port = 24800,
		string clientName = "P4NTH30N",
		CancellationToken cancellationToken = default)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		_hostIp = hostIp;
		_port = port;
		_clientName = clientName;

		await ConnectInternalAsync(cancellationToken);
	}

	/// <summary>
	/// Internal connection logic, shared by Connect and Reconnect.
	/// </summary>
	private async Task ConnectInternalAsync(CancellationToken cancellationToken)
	{
		_tcpClient?.Dispose();
		_tcpClient = new TcpClient();

		try
		{
			// Connect with timeout
			using CancellationTokenSource timeoutCts = new(5000);
			using CancellationTokenSource linkedCts = CancellationTokenSource.CreateLinkedTokenSource(
				cancellationToken, timeoutCts.Token);

			await _tcpClient.ConnectAsync(_hostIp, _port, linkedCts.Token);
			_stream = _tcpClient.GetStream();

			// Perform Synergy handshake
			await PerformHandshakeAsync(cancellationToken);

			_isConnected = true;

			// Start keepalive timer (every 5 seconds)
			_keepaliveTimer?.Dispose();
			_keepaliveTimer = new Timer(
				callback: _ => SendKeepaliveAsync().ConfigureAwait(false),
				state: null,
				dueTime: 5000,
				period: 5000
			);

			Console.WriteLine($"[SynergyClient] Connected to {_hostIp}:{_port} as '{_clientName}'");
		}
		catch (Exception ex)
		{
			_isConnected = false;
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			Console.WriteLine($"[{line}] [SynergyClient] Connection failed: {ex.Message}");
			throw;
		}
	}

	/// <summary>
	/// Performs the Synergy protocol handshake.
	/// Server sends protocol banner → Client responds with name.
	/// </summary>
	private async Task PerformHandshakeAsync(CancellationToken cancellationToken)
	{
		if (_stream is null)
			throw new InvalidOperationException("Network stream not initialized.");

		// Read server banner (e.g., "Synergy 1 6")
		byte[] bannerBuffer = new byte[256];
		int bytesRead = await _stream.ReadAsync(bannerBuffer, cancellationToken);
		if (bytesRead == 0)
			throw new InvalidOperationException("Server closed connection during handshake.");

		// Parse banner — first 4 bytes are length, rest is the banner string
		string banner = bytesRead > 4
			? Encoding.ASCII.GetString(bannerBuffer, 4, bytesRead - 4)
			: Encoding.ASCII.GetString(bannerBuffer, 0, bytesRead);

		Console.WriteLine($"[SynergyClient] Server banner: {banner.Trim('\0')}");

		// Send client hello with name
		// Packet: "HELO" + [4-byte name length] + [client name bytes]
		byte[] nameBytes = Encoding.ASCII.GetBytes(_clientName);
		byte[] helloPacket = new byte[4 + 4 + nameBytes.Length];
		Encoding.ASCII.GetBytes("HELO").CopyTo(helloPacket, 0);
		WriteInt32BigEndian(helloPacket, 4, nameBytes.Length);
		nameBytes.CopyTo(helloPacket, 8);

		await SendPacketAsync(helloPacket, cancellationToken);
	}

	/// <inheritdoc />
	public async Task DisconnectAsync()
	{
		_isConnected = false;
		_keepaliveTimer?.Dispose();
		_keepaliveTimer = null;

		try
		{
			// Send goodbye packet: "BYE\0"
			if (_stream is not null)
			{
				byte[] bye = Encoding.ASCII.GetBytes("BYE\0");
				await SendPacketAsync(bye, CancellationToken.None);
			}
		}
		catch
		{
			// Best-effort goodbye
		}

		_stream?.Dispose();
		_tcpClient?.Dispose();
		_stream = null;
		_tcpClient = null;

		Console.WriteLine("[SynergyClient] Disconnected.");
	}

	/// <inheritdoc />
	public async Task MoveMouseAsync(int x, int y)
	{
		EnsureConnected();

		// DMMV packet: "DMMV" + [2-byte X] + [2-byte Y]
		byte[] packet = new byte[8];
		Encoding.ASCII.GetBytes("DMMV").CopyTo(packet, 0);
		WriteInt16BigEndian(packet, 4, (short)x);
		WriteInt16BigEndian(packet, 6, (short)y);

		await SendPacketAsync(packet, CancellationToken.None);
	}

	/// <inheritdoc />
	public async Task ClickAsync(int x, int y, MouseButton button = MouseButton.Left)
	{
		EnsureConnected();

		// Move mouse to position first
		await MoveMouseAsync(x, y);
		await Task.Delay(20); // Brief settling delay

		// Mouse down: "DMDN" + [1-byte button ID]
		byte[] downPacket = new byte[5];
		Encoding.ASCII.GetBytes("DMDN").CopyTo(downPacket, 0);
		downPacket[4] = (byte)button;
		await SendPacketAsync(downPacket, CancellationToken.None);

		await Task.Delay(50); // Hold duration

		// Mouse up: "DMUP" + [1-byte button ID]
		byte[] upPacket = new byte[5];
		Encoding.ASCII.GetBytes("DMUP").CopyTo(upPacket, 0);
		upPacket[4] = (byte)button;
		await SendPacketAsync(upPacket, CancellationToken.None);
	}

	/// <inheritdoc />
	public async Task DoubleClickAsync(int x, int y, MouseButton button = MouseButton.Left)
	{
		await ClickAsync(x, y, button);
		await Task.Delay(80); // Inter-click delay
		await ClickAsync(x, y, button);
	}

	/// <inheritdoc />
	public async Task SendKeysAsync(string keys)
	{
		EnsureConnected();

		if (string.IsNullOrEmpty(keys))
			return;

		foreach (char c in keys)
		{
			// Key down: "DKDN" + [2-byte key ID] + [2-byte modifier mask] + [2-byte key button]
			int keyCode = c;
			byte[] downPacket = new byte[10];
			Encoding.ASCII.GetBytes("DKDN").CopyTo(downPacket, 0);
			WriteInt16BigEndian(downPacket, 4, (short)keyCode);
			WriteInt16BigEndian(downPacket, 6, 0); // No modifiers
			WriteInt16BigEndian(downPacket, 8, (short)keyCode);
			await SendPacketAsync(downPacket, CancellationToken.None);

			// Key up: "DKUP" + [2-byte key ID] + [2-byte modifier mask] + [2-byte key button]
			byte[] upPacket = new byte[10];
			Encoding.ASCII.GetBytes("DKUP").CopyTo(upPacket, 0);
			WriteInt16BigEndian(upPacket, 4, (short)keyCode);
			WriteInt16BigEndian(upPacket, 6, 0);
			WriteInt16BigEndian(upPacket, 8, (short)keyCode);
			await SendPacketAsync(upPacket, CancellationToken.None);

			await Task.Delay(15); // Inter-key delay for human-like pacing
		}
	}

	/// <inheritdoc />
	public async Task SendKeyAsync(SynergyKey key, KeyModifiers modifiers = KeyModifiers.None)
	{
		EnsureConnected();

		short keyCode = (short)key;
		short modMask = (short)modifiers;

		// Key down
		byte[] downPacket = new byte[10];
		Encoding.ASCII.GetBytes("DKDN").CopyTo(downPacket, 0);
		WriteInt16BigEndian(downPacket, 4, keyCode);
		WriteInt16BigEndian(downPacket, 6, modMask);
		WriteInt16BigEndian(downPacket, 8, keyCode);
		await SendPacketAsync(downPacket, CancellationToken.None);

		await Task.Delay(30);

		// Key up
		byte[] upPacket = new byte[10];
		Encoding.ASCII.GetBytes("DKUP").CopyTo(upPacket, 0);
		WriteInt16BigEndian(upPacket, 4, keyCode);
		WriteInt16BigEndian(upPacket, 6, modMask);
		WriteInt16BigEndian(upPacket, 8, keyCode);
		await SendPacketAsync(upPacket, CancellationToken.None);
	}

	/// <inheritdoc />
	public void QueueAction(InputAction action)
	{
		_actionQueue.Enqueue(action);
	}

	/// <inheritdoc />
	public async Task<int> ExecuteQueueAsync(CancellationToken cancellationToken = default)
	{
		return await _actionQueue.ExecuteAllAsync(ExecuteActionAsync, cancellationToken);
	}

	/// <summary>
	/// Executes a single InputAction via the Synergy protocol.
	/// </summary>
	private async Task ExecuteActionAsync(InputAction action, CancellationToken cancellationToken)
	{
		switch (action.Type)
		{
			case InputActionType.MouseMove:
				(int mvX, int mvY) = _screenMapper.FrameToVm(action.X, action.Y);
				await MoveMouseAsync(mvX, mvY);
				break;

			case InputActionType.Click:
				(int clkX, int clkY) = _screenMapper.FrameToVm(action.X, action.Y);
				await ClickAsync(clkX, clkY, action.Button);
				break;

			case InputActionType.DoubleClick:
				(int dclkX, int dclkY) = _screenMapper.FrameToVm(action.X, action.Y);
				await DoubleClickAsync(dclkX, dclkY, action.Button);
				break;

			case InputActionType.KeyPress:
				await SendKeyAsync(action.Key, action.Modifiers);
				break;

			case InputActionType.SendKeys:
				if (!string.IsNullOrEmpty(action.Text))
					await SendKeysAsync(action.Text);
				break;

			case InputActionType.Delay:
				await Task.Delay(action.DelayAfterMs, cancellationToken);
				break;
		}
	}

	/// <summary>
	/// Sends a Synergy packet with length prefix over the network.
	/// </summary>
	private async Task SendPacketAsync(byte[] data, CancellationToken cancellationToken)
	{
		if (_stream is null || !IsConnected)
			throw new InvalidOperationException("Not connected to Synergy server.");

		// Synergy packet format: [4-byte big-endian length][data]
		byte[] lengthPrefix = new byte[4];
		WriteInt32BigEndian(lengthPrefix, 0, data.Length);

		await _writeLock.WaitAsync(cancellationToken);
		try
		{
			await _stream.WriteAsync(lengthPrefix, cancellationToken);
			await _stream.WriteAsync(data, cancellationToken);
			await _stream.FlushAsync(cancellationToken);
		}
		catch (Exception ex) when (ex is IOException or SocketException)
		{
			_isConnected = false;
			OnDisconnected?.Invoke($"Write failed: {ex.Message}");
			_ = Task.Run(() => AttemptReconnectAsync());
			throw;
		}
		finally
		{
			_writeLock.Release();
		}
	}

	/// <summary>
	/// Sends a keepalive packet to maintain the Synergy connection.
	/// </summary>
	private async Task SendKeepaliveAsync()
	{
		if (!IsConnected)
			return;

		try
		{
			// CALV = Client Alive (keepalive)
			byte[] keepalive = Encoding.ASCII.GetBytes("CALV");
			await SendPacketAsync(keepalive, CancellationToken.None);
		}
		catch
		{
			// Keepalive failure handled by SendPacketAsync disconnect logic
		}
	}

	/// <summary>
	/// Attempts automatic reconnection with exponential backoff.
	/// </summary>
	private async Task AttemptReconnectAsync()
	{
		for (int attempt = 1; attempt <= MaxReconnectAttempts; attempt++)
		{
			int delayMs = BaseReconnectDelayMs * (1 << (attempt - 1));
			Console.WriteLine($"[SynergyClient] Reconnect attempt {attempt}/{MaxReconnectAttempts} in {delayMs}ms...");

			await Task.Delay(delayMs);

			try
			{
				await ConnectInternalAsync(CancellationToken.None);
				Console.WriteLine("[SynergyClient] Reconnected successfully.");
				OnReconnected?.Invoke();
				return;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[SynergyClient] Reconnect attempt {attempt} failed: {ex.Message}");
			}
		}

		Console.WriteLine("[SynergyClient] All reconnection attempts exhausted.");
		OnDisconnected?.Invoke("Reconnection failed after maximum attempts.");
	}

	/// <summary>
	/// Ensures the client is connected before sending commands.
	/// </summary>
	private void EnsureConnected()
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		if (!IsConnected)
			throw new InvalidOperationException("Not connected to Synergy server. Call ConnectAsync() first.");
	}

	/// <summary>
	/// Writes a 32-bit integer in big-endian format to a byte array.
	/// </summary>
	private static void WriteInt32BigEndian(byte[] buffer, int offset, int value)
	{
		buffer[offset] = (byte)(value >> 24);
		buffer[offset + 1] = (byte)(value >> 16);
		buffer[offset + 2] = (byte)(value >> 8);
		buffer[offset + 3] = (byte)value;
	}

	/// <summary>
	/// Writes a 16-bit integer in big-endian format to a byte array.
	/// </summary>
	private static void WriteInt16BigEndian(byte[] buffer, int offset, short value)
	{
		buffer[offset] = (byte)(value >> 8);
		buffer[offset + 1] = (byte)value;
	}

	/// <inheritdoc />
	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_isConnected = false;
			_keepaliveTimer?.Dispose();
			_writeLock.Dispose();
			_stream?.Dispose();
			_tcpClient?.Dispose();
		}
	}
}
