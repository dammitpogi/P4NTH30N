namespace P4NTHE0N.C0MMON.Services.Display;

/// <summary>
/// Pub/sub interface for the display event pipeline.
/// Thread-safe, synchronous delivery for real-time display.
/// </summary>
public interface IDisplayEventBus
{
	/// <summary>Publish an event to all subscribers whose minimum level is met.</summary>
	void Publish(DisplayEvent evt);

	/// <summary>Subscribe to all events regardless of level.</summary>
	void Subscribe(Action<DisplayEvent> handler);

	/// <summary>Subscribe to events at or above the specified minimum level.</summary>
	void Subscribe(DisplayLogLevel minimumLevel, Action<DisplayEvent> handler);

	/// <summary>Get recent events at or above the specified level.</summary>
	IReadOnlyList<DisplayEvent> GetRecent(DisplayLogLevel minimumLevel, int count = 25);

	/// <summary>Get aggregate counts per level since startup.</summary>
	IReadOnlyDictionary<DisplayLogLevel, long> GetCounts();
}
