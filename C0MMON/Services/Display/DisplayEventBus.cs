using System.Collections.Concurrent;

namespace P4NTHE0N.C0MMON.Services.Display;

/// <summary>
/// Thread-safe display event bus with level-filtered subscriptions and ring buffers.
/// </summary>
public sealed class DisplayEventBus : IDisplayEventBus
{
	private readonly List<(DisplayLogLevel MinLevel, Action<DisplayEvent> Handler)> _subscribers = new();
	private readonly object _subscriberLock = new();

	private readonly ConcurrentDictionary<DisplayLogLevel, long> _counts = new();

	// Ring buffers per level for late subscribers / dashboard refresh
	private readonly ConcurrentDictionary<DisplayLogLevel, RingBuffer> _buffers = new();
	private const int BufferSize = 100;

	public DisplayEventBus()
	{
		foreach (DisplayLogLevel level in Enum.GetValues<DisplayLogLevel>())
		{
			_counts[level] = 0;
			_buffers[level] = new RingBuffer(BufferSize);
		}
	}

	public void Publish(DisplayEvent evt)
	{
		_counts.AddOrUpdate(evt.Level, 1, (_, c) => c + 1);
		_buffers[evt.Level].Add(evt);

		List<(DisplayLogLevel MinLevel, Action<DisplayEvent> Handler)> snapshot;
		lock (_subscriberLock)
		{
			snapshot = new(_subscribers);
		}

		foreach (var (minLevel, handler) in snapshot)
		{
			if (evt.Level >= minLevel)
			{
				try
				{
					handler(evt);
				}
				catch
				{
					// Never let a subscriber break the pipeline
				}
			}
		}
	}

	public void Subscribe(Action<DisplayEvent> handler)
	{
		Subscribe(DisplayLogLevel.Silent, handler);
	}

	public void Subscribe(DisplayLogLevel minimumLevel, Action<DisplayEvent> handler)
	{
		lock (_subscriberLock)
		{
			_subscribers.Add((minimumLevel, handler));
		}
	}

	public IReadOnlyList<DisplayEvent> GetRecent(DisplayLogLevel minimumLevel, int count = 25)
	{
		List<DisplayEvent> result = new();

		foreach (DisplayLogLevel level in Enum.GetValues<DisplayLogLevel>())
		{
			if (level >= minimumLevel)
			{
				result.AddRange(_buffers[level].GetAll());
			}
		}

		return result
			.OrderByDescending(e => e.Timestamp)
			.Take(count)
			.Reverse()
			.ToList();
	}

	public IReadOnlyDictionary<DisplayLogLevel, long> GetCounts()
	{
		return new Dictionary<DisplayLogLevel, long>(_counts);
	}

	/// <summary>
	/// Creates a logger Action{string} that routes messages to a specific level and source.
	/// </summary>
	public Action<string> CreateLogger(string source, DisplayLogLevel level, string style = "grey")
	{
		return msg => Publish(new DisplayEvent(DateTime.UtcNow, level, source, msg, style));
	}

	/// <summary>
	/// Creates a smart logger that classifies messages by content.
	/// [ERROR] → Error, [WARN] → Warning, [DEBUG] → Debug, default → specified level.
	/// </summary>
	public Action<string> CreateSmartLogger(string source, DisplayLogLevel defaultLevel = DisplayLogLevel.Debug)
	{
		return msg =>
		{
			DisplayLogLevel level = defaultLevel;
			string style = "grey";

			if (msg.Contains("[ERROR]", StringComparison.OrdinalIgnoreCase))
			{
				level = DisplayLogLevel.Error;
				style = "red";
			}
			else if (msg.Contains("[WARN]", StringComparison.OrdinalIgnoreCase) || msg.Contains("failed", StringComparison.OrdinalIgnoreCase))
			{
				level = DisplayLogLevel.Warning;
				style = "yellow";
			}
			else if (msg.Contains("[SignalMetrics]", StringComparison.OrdinalIgnoreCase))
			{
				level = DisplayLogLevel.Detail;
				style = "cyan";
			}

			Publish(new DisplayEvent(DateTime.UtcNow, level, source, msg, style));
		};
	}

	private sealed class RingBuffer
	{
		private readonly DisplayEvent?[] _items;
		private int _head;
		private int _count;
		private readonly object _lock = new();

		public RingBuffer(int capacity)
		{
			_items = new DisplayEvent?[capacity];
		}

		public void Add(DisplayEvent item)
		{
			lock (_lock)
			{
				_items[_head] = item;
				_head = (_head + 1) % _items.Length;
				if (_count < _items.Length)
					_count++;
			}
		}

		public List<DisplayEvent> GetAll()
		{
			lock (_lock)
			{
				List<DisplayEvent> result = new(_count);
				int start = _count < _items.Length ? 0 : _head;
				for (int i = 0; i < _count; i++)
				{
					int idx = (start + i) % _items.Length;
					if (_items[idx] != null)
						result.Add(_items[idx]!);
				}
				return result;
			}
		}
	}
}
