using P4NTHE0N.H4ND.Domains.Automation.Aggregates;
using P4NTHE0N.H4ND.Domains.Automation.ValueObjects;
using P4NTHE0N.H4ND.Domains.Execution.Events;

namespace P4NTHE0N.UNI7T35T.H4ND.Decision110;

public static class DomainAggregateTests
{
	public static (int passed, int failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		void Run(string name, Func<bool> test)
		{
			try
			{
				if (test())
				{
					passed++;
					Console.WriteLine($"  ✅ {name}");
				}
				else
				{
					failed++;
					Console.WriteLine($"  ❌ {name} — returned false");
				}
			}
			catch (Exception ex)
			{
				failed++;
				Console.WriteLine($"  ❌ {name} — {ex.GetType().Name}: {ex.Message}");
			}
		}

		Run("DOM-001 DPD_FirstDrop_SetsToggleNoPop", () =>
		{
			var credential = CreateCredential(1000m);
			credential.ApplyJackpotReading(new JackpotBalance(new Money(999.8m), new Money(1000m), new Money(1000m), new Money(1000m)));

			return credential.DpdState.GrandPopped
				&& !credential.UncommittedEvents.Any(e => e is JackpotPoppedEvent);
		});

		Run("DOM-002 DPD_SecondDrop_RaisesJackpotPopped", () =>
		{
			var credential = CreateCredential(1000m);
			credential.ApplyJackpotReading(new JackpotBalance(new Money(999.8m), new Money(1000m), new Money(1000m), new Money(1000m)));
			credential.ClearUncommittedEvents();
			credential.ApplyJackpotReading(new JackpotBalance(new Money(999.5m), new Money(1000m), new Money(1000m), new Money(1000m)));

			var popEvent = credential.UncommittedEvents.OfType<JackpotPoppedEvent>().FirstOrDefault();
			return popEvent is not null
				&& popEvent.Tier == P4NTHE0N.H4ND.Domains.Execution.ValueObjects.JackpotTier.Grand
				&& !credential.DpdState.GrandPopped;
		});

		Run("DOM-003 LockUnlock_Transitions", () =>
		{
			var credential = CreateCredential(200m);
			credential.Lock(TimeSpan.FromMinutes(5), "worker-a", DateTime.UtcNow);
			if (!credential.IsLocked)
			{
				return false;
			}

			credential.Unlock("worker-a", "done");
			return !credential.IsLocked;
		});

		Run("DOM-004 SignalQueue_EnqueueDequeue", () =>
		{
			var queue = new SignalQueue("q-1");
			queue.Enqueue(new QueuedSignal("s-1", "cred-1", "u1", "h1", "g1", 4));
			queue.Enqueue(new QueuedSignal("s-2", "cred-1", "u1", "h1", "g1", 3));

			var first = queue.Dequeue();
			var second = queue.Dequeue();
			return first.SignalId == "s-1" && second.SignalId == "s-2" && queue.Count == 0;
		});

		return (passed, failed);
	}

	private static Credential CreateCredential(decimal grand)
	{
		return new Credential(
			new CredentialId("cred-1"),
			new Username("user-1"),
			GamePlatform.FireKirin,
			"house-1",
			"game-1",
			new JackpotBalance(new Money(grand), new Money(1000m), new Money(1000m), new Money(1000m)),
			new Threshold(new Money(grand), new Money(1000m), new Money(1000m), new Money(1000m)));
	}
}
