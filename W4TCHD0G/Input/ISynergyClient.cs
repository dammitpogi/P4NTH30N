namespace P4NTH30N.W4TCHD0G.Input;

/// <summary>
/// Contract for programmatic input control on a remote VM via Synergy protocol.
/// Enables mouse clicks, keyboard input, and coordinate-mapped interactions.
/// </summary>
public interface ISynergyClient : IDisposable
{
	/// <summary>
	/// Connects to the Synergy server on the host machine.
	/// </summary>
	/// <param name="hostIp">IP address of the Synergy server.</param>
	/// <param name="port">Synergy port. Default: 24800.</param>
	/// <param name="clientName">Client screen name registered in Synergy config.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	Task ConnectAsync(string hostIp, int port = 24800, string clientName = "P4NTH30N", CancellationToken cancellationToken = default);

	/// <summary>
	/// Disconnects from the Synergy server gracefully.
	/// </summary>
	Task DisconnectAsync();

	/// <summary>
	/// Whether the client is currently connected to the Synergy server.
	/// </summary>
	bool IsConnected { get; }

	/// <summary>
	/// Moves the mouse to absolute screen coordinates on the VM.
	/// </summary>
	/// <param name="x">X coordinate in VM screen space.</param>
	/// <param name="y">Y coordinate in VM screen space.</param>
	Task MoveMouseAsync(int x, int y);

	/// <summary>
	/// Clicks at the specified coordinates on the VM.
	/// </summary>
	/// <param name="x">X coordinate in VM screen space.</param>
	/// <param name="y">Y coordinate in VM screen space.</param>
	/// <param name="button">Mouse button to click. Default: Left.</param>
	Task ClickAsync(int x, int y, MouseButton button = MouseButton.Left);

	/// <summary>
	/// Double-clicks at the specified coordinates.
	/// </summary>
	Task DoubleClickAsync(int x, int y, MouseButton button = MouseButton.Left);

	/// <summary>
	/// Sends a sequence of keystrokes to the VM.
	/// </summary>
	/// <param name="keys">Key sequence string (supports special keys like {ENTER}, {TAB}).</param>
	Task SendKeysAsync(string keys);

	/// <summary>
	/// Sends a single key press and release.
	/// </summary>
	/// <param name="key">The key to press.</param>
	/// <param name="modifiers">Optional modifier keys (Shift, Ctrl, Alt).</param>
	Task SendKeyAsync(SynergyKey key, KeyModifiers modifiers = KeyModifiers.None);

	/// <summary>
	/// Queues an input action for sequential execution.
	/// </summary>
	/// <param name="action">The action to queue.</param>
	void QueueAction(InputAction action);

	/// <summary>
	/// Executes all queued actions sequentially with configured delays.
	/// </summary>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>Number of actions successfully executed.</returns>
	Task<int> ExecuteQueueAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Event raised when the connection to Synergy is lost.
	/// </summary>
	event Action<string>? OnDisconnected;

	/// <summary>
	/// Event raised when reconnection succeeds after a disconnect.
	/// </summary>
	event Action? OnReconnected;
}

/// <summary>
/// Mouse button identifiers.
/// </summary>
public enum MouseButton
{
	Left = 1,
	Middle = 2,
	Right = 3,
}

/// <summary>
/// Keyboard modifier flags (combinable).
/// </summary>
[Flags]
public enum KeyModifiers
{
	None = 0,
	Shift = 1,
	Ctrl = 2,
	Alt = 4,
	Super = 8,
}

/// <summary>
/// Common Synergy key codes for special keys.
/// </summary>
public enum SynergyKey
{
	None = 0,
	Enter = 0xFF0D,
	Tab = 0xFF09,
	Escape = 0xFF1B,
	Backspace = 0xFF08,
	Delete = 0xFFFF,
	Home = 0xFF50,
	End = 0xFF57,
	PageUp = 0xFF55,
	PageDown = 0xFF56,
	Left = 0xFF51,
	Up = 0xFF52,
	Right = 0xFF53,
	Down = 0xFF54,
	F1 = 0xFFBE,
	F2 = 0xFFBF,
	F3 = 0xFFC0,
	F4 = 0xFFC1,
	F5 = 0xFFC2,
	F6 = 0xFFC3,
	F7 = 0xFFC4,
	F8 = 0xFFC5,
	F9 = 0xFFC6,
	F10 = 0xFFC7,
	F11 = 0xFFC8,
	F12 = 0xFFC9,
}
