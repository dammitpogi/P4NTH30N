using System.Collections.Concurrent;
using P4NTH30N.C0MMON.Services.Display;

namespace P4NTH30N.UNI7T35T.C0MMON;

/// <summary>
/// DECISION_085: Display Event Pipeline Tests
/// Verifies event bus filtering, level routing, and progressive disclosure.
/// </summary>
public static class DisplayPipelineTests
{
	public static (int Passed, int Failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		// DP-001: DisplayLogLevel ordering
		try
		{
			TestDisplayLogLevelOrdering();
			Console.WriteLine("✓ DP-001: DisplayLogLevel ordering");
			passed++;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"✗ DP-001: {ex.Message}");
			failed++;
		}

		// DP-002: DisplayEvent factory methods
		try
		{
			TestDisplayEventFactories();
			Console.WriteLine("✓ DP-002: DisplayEvent factory methods");
			passed++;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"✗ DP-002: {ex.Message}");
			failed++;
		}

		// DP-003: DisplayEventBus publish/subscribe with level filtering
		try
		{
			TestEventBusLevelFiltering();
			Console.WriteLine("✓ DP-003: DisplayEventBus level filtering");
			passed++;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"✗ DP-003: {ex.Message}");
			failed++;
		}

		// DP-004: DisplayEventBus GetRecent respects minimum level
		try
		{
			TestGetRecentMinimumLevel();
			Console.WriteLine("✓ DP-004: GetRecent minimum level");
			passed++;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"✗ DP-004: {ex.Message}");
			failed++;
		}

		// DP-005: DisplayEventBus counts aggregate correctly
		try
		{
			TestEventCounts();
			Console.WriteLine("✓ DP-005: Event counts aggregation");
			passed++;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"✗ DP-005: {ex.Message}");
			failed++;
		}

		// DP-006: CreateLogger routes to specified level
		try
		{
			TestCreateLogger();
			Console.WriteLine("✓ DP-006: CreateLogger routing");
			passed++;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"✗ DP-006: {ex.Message}");
			failed++;
		}

		// DP-007: CreateSmartLogger classifies messages
		try
		{
			TestCreateSmartLogger();
			Console.WriteLine("✓ DP-007: CreateSmartLogger classification");
			passed++;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"✗ DP-007: {ex.Message}");
			failed++;
		}

		// DP-008: Ring buffer overflow behavior
		try
		{
			TestRingBufferOverflow();
			Console.WriteLine("✓ DP-008: Ring buffer overflow");
			passed++;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"✗ DP-008: {ex.Message}");
			failed++;
		}

		// DP-009: Concurrent publish/subscribe thread safety
		try
		{
			TestConcurrentPublishSubscribe();
			Console.WriteLine("✓ DP-009: Concurrent publish/subscribe");
			passed++;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"✗ DP-009: {ex.Message}");
			failed++;
		}

		// DP-010: Silent events are counted but not routed to Detail+
		try
		{
			TestSilentEventRouting();
			Console.WriteLine("✓ DP-010: Silent event routing");
			passed++;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"✗ DP-010: {ex.Message}");
			failed++;
		}

		return (passed, failed);
	}

	private static void TestDisplayLogLevelOrdering()
	{
		// Verify enum ordering: Silent < Debug < Detail < Status < Warning < Error
		Assert(DisplayLogLevel.Silent < DisplayLogLevel.Debug, "Silent < Debug");
		Assert(DisplayLogLevel.Debug < DisplayLogLevel.Detail, "Debug < Detail");
		Assert(DisplayLogLevel.Detail < DisplayLogLevel.Status, "Detail < Status");
		Assert(DisplayLogLevel.Status < DisplayLogLevel.Warning, "Status < Warning");
		Assert(DisplayLogLevel.Warning < DisplayLogLevel.Error, "Warning < Error");
	}

	private static void TestDisplayEventFactories()
	{
		var silent = DisplayEvent.Silent("Test", "msg");
		Assert(silent.Level == DisplayLogLevel.Silent, "Silent factory level");
		Assert(silent.Source == "Test", "Silent factory source");

		var debug = DisplayEvent.Debug("Test", "msg");
		Assert(debug.Level == DisplayLogLevel.Debug, "Debug factory level");

		var detail = DisplayEvent.Detail("Test", "msg", "cyan");
		Assert(detail.Level == DisplayLogLevel.Detail, "Detail factory level");
		Assert(detail.Style == "cyan", "Detail factory style");

		var status = DisplayEvent.Status("Test", "msg");
		Assert(status.Level == DisplayLogLevel.Status, "Status factory level");

		var warn = DisplayEvent.Warn("Test", "msg");
		Assert(warn.Level == DisplayLogLevel.Warning, "Warn factory level");

		var error = DisplayEvent.Error("Test", "msg");
		Assert(error.Level == DisplayLogLevel.Error, "Error factory level");
	}

	private static void TestEventBusLevelFiltering()
	{
		var bus = new DisplayEventBus();
		var received = new List<DisplayEvent>();

		// Subscribe to Detail+ (should receive Detail, Status, Warning, Error)
		bus.Subscribe(DisplayLogLevel.Detail, evt => received.Add(evt));

		bus.Publish(DisplayEvent.Silent("Src", "silent"));
		bus.Publish(DisplayEvent.Debug("Src", "debug"));
		bus.Publish(DisplayEvent.Detail("Src", "detail"));
		bus.Publish(DisplayEvent.Status("Src", "status"));
		bus.Publish(DisplayEvent.Warn("Src", "warn"));
		bus.Publish(DisplayEvent.Error("Src", "error"));

		Assert(received.Count == 4, "Should receive 4 events (Detail+)");
		Assert(received.All(e => e.Level >= DisplayLogLevel.Detail), "All events should be Detail+");
		Assert(received.Any(e => e.Level == DisplayLogLevel.Detail), "Should include Detail");
		Assert(received.Any(e => e.Level == DisplayLogLevel.Error), "Should include Error");
	}

	private static void TestGetRecentMinimumLevel()
	{
		var bus = new DisplayEventBus();

		bus.Publish(DisplayEvent.Silent("Src", "silent"));
		bus.Publish(DisplayEvent.Debug("Src", "debug"));
		bus.Publish(DisplayEvent.Detail("Src", "detail"));
		bus.Publish(DisplayEvent.Status("Src", "status"));
		bus.Publish(DisplayEvent.Warn("Src", "warn"));
		bus.Publish(DisplayEvent.Error("Src", "error"));

		var recentDetail = bus.GetRecent(DisplayLogLevel.Detail);
		Assert(recentDetail.Count == 4, "GetRecent Detail should return 4 events");
		Assert(recentDetail.All(e => e.Level >= DisplayLogLevel.Detail), "All should be Detail+");

		var recentError = bus.GetRecent(DisplayLogLevel.Error);
		Assert(recentError.Count == 1, "GetRecent Error should return 1 event");
		Assert(recentError[0].Level == DisplayLogLevel.Error, "Should be Error level");
	}

	private static void TestEventCounts()
	{
		var bus = new DisplayEventBus();

		bus.Publish(DisplayEvent.Silent("Src", "silent"));
		bus.Publish(DisplayEvent.Debug("Src", "debug"));
		bus.Publish(DisplayEvent.Detail("Src", "detail"));
		bus.Publish(DisplayEvent.Status("Src", "status"));
		bus.Publish(DisplayEvent.Warn("Src", "warn"));
		bus.Publish(DisplayEvent.Error("Src", "error"));

		var counts = bus.GetCounts();
		Assert(counts[DisplayLogLevel.Silent] == 1, "Silent count");
		Assert(counts[DisplayLogLevel.Debug] == 1, "Debug count");
		Assert(counts[DisplayLogLevel.Detail] == 1, "Detail count");
		Assert(counts[DisplayLogLevel.Status] == 1, "Status count");
		Assert(counts[DisplayLogLevel.Warning] == 1, "Warning count");
		Assert(counts[DisplayLogLevel.Error] == 1, "Error count");
	}

	private static void TestCreateLogger()
	{
		var bus = new DisplayEventBus();
		var received = new List<DisplayEvent>();

		bus.Subscribe(DisplayLogLevel.Warning, evt => received.Add(evt));

		var warnLogger = bus.CreateLogger("TestSource", DisplayLogLevel.Warning);
		warnLogger("Test warning message");

		Assert(received.Count == 1, "Should receive 1 event");
		Assert(received[0].Level == DisplayLogLevel.Warning, "Should be Warning level");
		Assert(received[0].Source == "TestSource", "Should have correct source");
		Assert(received[0].Message == "Test warning message", "Should have correct message");
	}

	private static void TestCreateSmartLogger()
	{
		var bus = new DisplayEventBus();
		var received = new List<DisplayEvent>();

		bus.Subscribe(DisplayLogLevel.Debug, evt => received.Add(evt));

		var smartLogger = bus.CreateSmartLogger("SmartSource");

		smartLogger("Normal debug message");
		smartLogger("[ERROR] Something went wrong");
		smartLogger("[WARN] Something looks suspicious");
		smartLogger("[SignalMetrics] Generated 42 signals");

		Assert(received.Count == 4, "Should receive all 4 events");
		Assert(received[0].Level == DisplayLogLevel.Debug, "Default level");
		Assert(received[1].Level == DisplayLogLevel.Error, "ERROR parsed");
		Assert(received[2].Level == DisplayLogLevel.Warning, "WARN parsed");
		Assert(received[3].Level == DisplayLogLevel.Detail, "SignalMetrics parsed");
	}

	private static void TestRingBufferOverflow()
	{
		var bus = new DisplayEventBus();

		// Publish more events than buffer size (100)
		for (int i = 0; i < 150; i++)
		{
			bus.Publish(DisplayEvent.Debug("Src", $"msg-{i}"));
		}

		var recent = bus.GetRecent(DisplayLogLevel.Debug, 200);
		Assert(recent.Count <= 100, "Should not exceed buffer size");
		Assert(recent.Count > 90, "Should retain most events");
	}

	private static void TestConcurrentPublishSubscribe()
	{
		var bus = new DisplayEventBus();
		var received = new ConcurrentBag<DisplayEvent>();
		var barrier = new Barrier(3);

		// Subscriber thread
		var subscriberTask = Task.Run(() =>
		{
			barrier.SignalAndWait();
			bus.Subscribe(DisplayLogLevel.Debug, evt => received.Add(evt));
			Thread.Sleep(100);
		});

		// Publisher threads
		var publisher1 = Task.Run(() =>
		{
			barrier.SignalAndWait();
			for (int i = 0; i < 50; i++)
			{
				bus.Publish(DisplayEvent.Debug("Pub1", $"msg-{i}"));
				Thread.Sleep(1);
			}
		});

		var publisher2 = Task.Run(() =>
		{
			barrier.SignalAndWait();
			for (int i = 0; i < 50; i++)
			{
				bus.Publish(DisplayEvent.Debug("Pub2", $"msg-{i}"));
				Thread.Sleep(1);
			}
		});

		Task.WaitAll(subscriberTask, publisher1, publisher2);

		Assert(received.Count > 0, "Should receive some events concurrently");
		Assert(received.Count <= 100, "Should not exceed total published events");
	}

	private static void TestSilentEventRouting()
	{
		var bus = new DisplayEventBus();
		var detailReceived = new List<DisplayEvent>();
		var debugReceived = new List<DisplayEvent>();

		bus.Subscribe(DisplayLogLevel.Detail, evt => detailReceived.Add(evt));
		bus.Subscribe(DisplayLogLevel.Debug, evt => debugReceived.Add(evt));

		bus.Publish(DisplayEvent.Silent("Src", "silent"));
		bus.Publish(DisplayEvent.Debug("Src", "debug"));
		bus.Publish(DisplayEvent.Detail("Src", "detail"));

		Assert(detailReceived.Count == 1, "Detail+ should receive only Detail (not Debug)");
		Assert(debugReceived.Count == 2, "Debug+ should receive Debug and Detail");
		Assert(detailReceived[0].Level == DisplayLogLevel.Detail, "Detail+ received Detail");
		Assert(detailReceived.All(e => e.Level >= DisplayLogLevel.Detail), "Detail+ filtering");
		Assert(debugReceived.All(e => e.Level >= DisplayLogLevel.Debug), "Debug+ filtering");

		// Verify Silent is counted but not routed
		var counts = bus.GetCounts();
		Assert(counts[DisplayLogLevel.Silent] == 1, "Silent should be counted");
	}

	private static void Assert(bool condition, string message)
	{
		if (!condition)
			throw new Exception(message);
	}
}
