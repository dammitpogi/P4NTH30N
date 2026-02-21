using System.Collections.Concurrent;

namespace P4NTH30N.C0MMON.Infrastructure.EventBus;

/// <summary>
/// TECH-FE-015: In-memory event bus for single-VM deployment.
/// Thread-safe publish/subscribe with fire-and-forget delivery.
/// </summary>
public sealed class InMemoryEventBus : IEventBus
{
	private readonly ConcurrentDictionary<Type, List<Delegate>> _handlers = new();
	private readonly object _lock = new();

	public Task PublishAsync<T>(T message, string? routingKey = null)
		where T : class
	{
		if (_handlers.TryGetValue(typeof(T), out List<Delegate>? handlers))
		{
			List<Delegate> snapshot;
			lock (_lock)
			{
				snapshot = new List<Delegate>(handlers);
			}

			foreach (Delegate handler in snapshot)
			{
				if (handler is Func<T, Task> asyncHandler)
				{
					_ = Task.Run(async () =>
					{
						try
						{
							await asyncHandler(message);
						}
						catch (Exception ex)
						{
							Console.WriteLine($"[EventBus] Handler error for {typeof(T).Name}: {ex.Message}");
						}
					});
				}
			}
		}
		return Task.CompletedTask;
	}

	public Task SubscribeAsync<T>(Func<T, Task> handler, string? routingKey = null)
		where T : class
	{
		lock (_lock)
		{
			List<Delegate> handlers = _handlers.GetOrAdd(typeof(T), _ => new List<Delegate>());
			handlers.Add(handler);
		}
		return Task.CompletedTask;
	}

	public Task<IDisposable> SubscribeWithAckAsync<T>(Func<T, Task<bool>> handler, string? routingKey = null)
		where T : class
	{
		Func<T, Task> wrapper = async (T message) =>
		{
			bool acked = await handler(message);
			if (!acked)
			{
				Console.WriteLine($"[EventBus] Message of type {typeof(T).Name} was nacked");
			}
		};

		lock (_lock)
		{
			List<Delegate> handlers = _handlers.GetOrAdd(typeof(T), _ => new List<Delegate>());
			handlers.Add(wrapper);
		}

		IDisposable subscription = new EventBusSubscription(() =>
		{
			lock (_lock)
			{
				if (_handlers.TryGetValue(typeof(T), out List<Delegate>? handlers))
				{
					handlers.Remove(wrapper);
				}
			}
		});
		return Task.FromResult(subscription);
	}

	private sealed class EventBusSubscription(Action onDispose) : IDisposable
	{
		private readonly Action _onDispose = onDispose;
		private int _disposed;

		public void Dispose()
		{
			if (Interlocked.CompareExchange(ref _disposed, 1, 0) == 0)
			{
				_onDispose();
			}
		}
	}
}
