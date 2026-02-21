namespace P4NTH30N.C0MMON.Infrastructure.EventBus;

/// <summary>
/// TECH-FE-015: Phase 1 event bus interface for FourEyes-H4ND integration.
/// Supports publish/subscribe for vision commands and automation events.
/// </summary>
public interface IEventBus
{
	/// <summary>
	/// Publish a message to all subscribers of type T.
	/// </summary>
	Task PublishAsync<T>(T message, string? routingKey = null)
		where T : class;

	/// <summary>
	/// Subscribe to messages of type T.
	/// </summary>
	Task SubscribeAsync<T>(Func<T, Task> handler, string? routingKey = null)
		where T : class;

	/// <summary>
	/// Subscribe with acknowledgment — handler returns true to ack, false to nack.
	/// </summary>
	Task<IDisposable> SubscribeWithAckAsync<T>(Func<T, Task<bool>> handler, string? routingKey = null)
		where T : class;
}
