namespace P4NTH30N.W4TCHD0G.OBS;

/// <summary>
/// State machine for OBS WebSocket connection lifecycle.
/// Tracks the current connection phase for proper event handling and retry logic.
/// </summary>
public enum ConnectionState
{
	/// <summary>Not connected and not attempting to connect.</summary>
	Disconnected,

	/// <summary>Actively attempting initial connection.</summary>
	Connecting,

	/// <summary>Connected and operational.</summary>
	Connected,

	/// <summary>Connection lost, attempting automatic reconnection.</summary>
	Reconnecting,

	/// <summary>All reconnection attempts exhausted. Manual intervention required.</summary>
	Failed,
}
