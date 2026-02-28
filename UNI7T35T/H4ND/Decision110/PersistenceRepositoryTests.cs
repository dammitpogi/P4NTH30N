using System.Diagnostics;
using MongoDB.Driver;
using P4NTHE0N.H4ND.Domains.Common;
using P4NTHE0N.H4ND.Infrastructure.Persistence;

namespace P4NTHE0N.UNI7T35T.H4ND.Decision110;

public static class PersistenceRepositoryTests
{
	private const string MongoConnectionString = "mongodb://192.168.56.1:27017";
	private const string DatabaseName = "P4NTHE0N";

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

		bool skip = false;

		Run("REP-001 Mongo_Connection_And_IndexSetup", () =>
		{
			if (!TryGetContext(out var context))
			{
				skip = true;
				Console.WriteLine("    (MongoDB not available - skipping Phase 4 persistence tests)");
				return true;
			}

			if (context is null)
			{
				skip = true;
				return true;
			}

			context.EnsurePhase4Indexes();
			return true;
		});

		Run("REP-002 DomainEvent_Idempotency_ByEventId", () =>
		{
			if (skip)
			{
				return true;
			}

			TryGetContext(out var context);
			var repository = new MongoDomainEventRepository(context!);
			var correlationId = $"rep-corr-{Guid.NewGuid():N}";
			var eventId = $"rep-event-{Guid.NewGuid():N}";

			var envelope = new DomainEventEnvelope
			{
				EventId = eventId,
				CorrelationId = correlationId,
				SessionId = "rep-session",
				EventType = "RepositoryIdempotencyTest",
				Source = "PersistenceRepositoryTests",
				AggregateId = "agg-1",
				AggregateVersion = 1,
				EventVersion = 1,
			};

			var first = repository.AppendIfNotExistsAsync(envelope).GetAwaiter().GetResult();
			var second = repository.AppendIfNotExistsAsync(envelope).GetAwaiter().GetResult();
			var fetched = repository.GetByCorrelationIdAsync(correlationId).GetAwaiter().GetResult();

			return first && !second && fetched.Count == 1;
		});

		Run("REP-003 CorrelationQuery_Performance", () =>
		{
			if (skip)
			{
				return true;
			}

			TryGetContext(out var context);
			var repository = new MongoDomainEventRepository(context!);
			var correlationId = $"rep-perf-{Guid.NewGuid():N}";

			for (var i = 0; i < 25; i++)
			{
				repository.AppendIfNotExistsAsync(new DomainEventEnvelope
				{
					EventId = $"rep-perf-event-{Guid.NewGuid():N}",
					CorrelationId = correlationId,
					SessionId = "rep-perf-session",
					EventType = "RepositoryPerfTest",
					Source = "PersistenceRepositoryTests",
					AggregateId = "agg-perf",
					AggregateVersion = i + 1,
					EventVersion = 1,
				}).GetAwaiter().GetResult();
			}

			var stopwatch = Stopwatch.StartNew();
			var rows = repository.GetByCorrelationIdAsync(correlationId).GetAwaiter().GetResult();
			stopwatch.Stop();

			return rows.Count >= 25 && stopwatch.ElapsedMilliseconds < 200;
		});

		return (passed, failed);
	}

	private static bool TryGetContext(out MongoDbContext? context)
	{
		try
		{
			var client = new MongoClient(MongoConnectionString);
			var database = client.GetDatabase(DatabaseName);
			_ = database.RunCommand((Command<MongoDB.Bson.BsonDocument>)"{ ping: 1 }");
			context = new MongoDbContext(database);
			return true;
		}
		catch
		{
			context = null;
			return false;
		}
	}
}
