using System.Diagnostics;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.H4ND.Domains.Automation.ValueObjects;
using P4NTHE0N.H4ND.Domains.Common;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;
using P4NTHE0N.H4ND.Services;

namespace P4NTHE0N.UNI7T35T.H4ND.Decision113;

public static class MongoOutageDegradationTests
{
	private const string MongoConnectionString = "mongodb://localhost:27017";
	private const string DatabaseName = "P4NTHE0N";
	private const string CollectionName = "_debug";
	private static readonly TimeSpan MongoTimeout = TimeSpan.FromSeconds(2);

	public static (int passed, int failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		Run("D113-MONGO-OUTAGE-DEGRADATION", ExecuteOutageValidation, ref passed, ref failed);
		return (passed, failed);
	}

	private static bool ExecuteOutageValidation()
	{
		MongoClient client = CreateMongoClient();
		IMongoDatabase db = client.GetDatabase(DatabaseName);
		db.RunCommand<BsonDocument>(new BsonDocument("ping", 1));
		IMongoCollection<ErrorEvidenceDocument> col = db.GetCollection<ErrorEvidenceDocument>(CollectionName);

		DateTime baselineStart = DateTime.UtcNow;
		string baselineSession = CreateSessionId("baseline");
		long baselineWrites = EmitWithRealRepository(db, col, baselineSession, 8);
		DateTime baselineEnd = DateTime.UtcNow;

		DateTime outageStart = DateTime.UtcNow;
		string outageSession = CreateSessionId("outage");
		OutageResult outage = EmitWithOutageRepository(db, outageSession, 150);
		DateTime outageEnd = DateTime.UtcNow;

		DateTime recoveryStart = DateTime.UtcNow;
		string recoverySession = CreateSessionId("recovery");
		long recoveryWrites = EmitWithRealRepository(db, col, recoverySession, 12);
		DateTime recoveryEnd = DateTime.UtcNow;

		bool baselinePass = baselineWrites >= 3;
		bool outagePass = outage.StableNoCrash && outage.StableNonBlocking && outage.Stats.DroppedSinkFailure > 0;
		bool recoveryPass = recoveryWrites >= 3;

		Console.WriteLine("  Timeline (UTC)");
		Console.WriteLine($"    baseline: {baselineStart:O} -> {baselineEnd:O}");
		Console.WriteLine($"    outage:   {outageStart:O} -> {outageEnd:O}");
		Console.WriteLine($"    recovery: {recoveryStart:O} -> {recoveryEnd:O}");

		Console.WriteLine("  Counter Evidence");
		Console.WriteLine($"    enqueued={outage.Stats.Enqueued}");
		Console.WriteLine($"    written={outage.Stats.Written}");
		Console.WriteLine($"    droppedQueue={outage.Stats.DroppedQueueFull}");
		Console.WriteLine($"    droppedSink={outage.Stats.DroppedSinkFailure}");
		Console.WriteLine($"    enabled={outage.Stats.Enabled}");
		Console.WriteLine($"    outageSinkFailureLogs={outage.SinkFailureLogLines}");
		Console.WriteLine($"    outageSummaryLogs={outage.SummaryLogLines}");
		Console.WriteLine("    circuitIndicator=n/a (no circuit breaker in ErrorEvidenceService)");

		Console.WriteLine("  Pass/Fail");
		Console.WriteLine($"    baseline={(baselinePass ? "PASS" : "FAIL")} (writes={baselineWrites})");
		Console.WriteLine($"    outage={(outagePass ? "PASS" : "FAIL")} (stable={outage.StableNoCrash}, nonBlocking={outage.StableNonBlocking})");
		Console.WriteLine($"    recovery={(recoveryPass ? "PASS" : "FAIL")} (writes={recoveryWrites})");

		return baselinePass && outagePass && recoveryPass;
	}

	private static long EmitWithRealRepository(
		IMongoDatabase db,
		IMongoCollection<ErrorEvidenceDocument> col,
		string sessionId,
		int iterations)
	{
		ErrorEvidenceOptions options = CreateOptions();
		IErrorEvidenceRepository repo = new MongoDebugEvidenceRepository(db, options);
		IErrorEvidenceFactory factory = new ErrorEvidenceFactory(options);

		ErrorEvidenceService service = new(repo, factory, options);
		try
		{
			EmitRuntimeEvents(service, sessionId, iterations);
		}
		finally
		{
			Task disposeTask = service.DisposeAsync().AsTask();
			Task.WhenAny(disposeTask, Task.Delay(2000)).GetAwaiter().GetResult();
			CorrelationContext.Clear();
		}

		DateTime deadline = DateTime.UtcNow.AddSeconds(5);
		long writes = 0;
		while (DateTime.UtcNow < deadline)
		{
			writes = col
				.CountDocuments(Builders<ErrorEvidenceDocument>.Filter.Eq(x => x.SessionId, sessionId));

			if (writes >= 3)
			{
				break;
			}

			Thread.Sleep(100);
		}

		return writes;
	}

	private static OutageResult EmitWithOutageRepository(IMongoDatabase db, string sessionId, int iterations)
	{
		ErrorEvidenceOptions options = CreateOptions();
		IErrorEvidenceRepository inner = new MongoDebugEvidenceRepository(db, options);
		List<string> opLog = [];
		bool outageEnabled = true;

		IErrorEvidenceRepository outageRepo = new GatedOutageRepository(
			inner,
			() => outageEnabled,
			new TimeoutException("Simulated Mongo unavailable during outage window"));

		IErrorEvidenceFactory factory = new ErrorEvidenceFactory(options);
		ErrorEvidenceService service = new(outageRepo, factory, options, msg => opLog.Add(msg));

		bool stableNoCrash = true;
		bool stableNonBlocking = true;
		Stopwatch sw = Stopwatch.StartNew();
		try
		{
			EmitRuntimeEvents(service, sessionId, iterations);
		}
		catch
		{
			stableNoCrash = false;
		}
		finally
		{
			sw.Stop();
			Thread.Sleep(1400);
			outageEnabled = false;
		}

		ErrorEvidenceStats stats = service.GetStats();
		stableNonBlocking = sw.Elapsed < TimeSpan.FromSeconds(8);

		Task disposeTask = service.DisposeAsync().AsTask();
		Task.WhenAny(disposeTask, Task.Delay(2000)).GetAwaiter().GetResult();
		CorrelationContext.Clear();

		int sinkFailureLines = opLog.Count(l => l.Contains("sink failure dropped", StringComparison.OrdinalIgnoreCase));
		int summaryLines = opLog.Count(l => l.Contains("summary enqueued", StringComparison.OrdinalIgnoreCase));

		return new OutageResult(
			Stats: stats,
			StableNoCrash: stableNoCrash,
			StableNonBlocking: stableNonBlocking,
			SinkFailureLogLines: sinkFailureLines,
			SummaryLogLines: summaryLines);
	}

	private static void EmitRuntimeEvents(IErrorEvidence errors, string sessionId, int iterations)
	{
		SessionId sid = SessionId.From(sessionId);
		CorrelationId correlationId = CorrelationId.New();
		CorrelationContext.Clear();
		CorrelationContext.Start(sid, correlationId);

		Credential cred = CreateCredential();
		Signal sig = CreateSignal(cred);

		using ErrorScope _ = errors.BeginScope("DEC113OutageHarness", "EmitRuntimeEvents");
		for (int i = 0; i < iterations; i++)
		{
			LegacyRuntimeHost.RecordPreProcessAckObservation(errors, sig, cred);
			errors.CaptureWarning("D113-OUTAGE-PING", "outage-ping", context: new Dictionary<string, object>
			{
				["iteration"] = i,
				["session"] = sessionId,
			});
		}
	}

	private static ErrorEvidenceOptions CreateOptions()
	{
		return new ErrorEvidenceOptions
		{
			Enabled = true,
			Collection = CollectionName,
			WarningSamplingRate = 1.0,
			InfoSamplingRate = 1.0,
			DebugSamplingRate = 1.0,
			BatchSize = 5,
			FlushIntervalMs = 25,
			QueueCapacity = 128,
			SummaryIntervalSeconds = 1,
		};
	}

	private static MongoClient CreateMongoClient()
	{
		MongoClientSettings settings = MongoClientSettings.FromConnectionString(MongoConnectionString);
		settings.ServerSelectionTimeout = MongoTimeout;
		settings.ConnectTimeout = MongoTimeout;
		settings.SocketTimeout = MongoTimeout;
		settings.WaitQueueTimeout = MongoTimeout;
		settings.DirectConnection = true;
		return new MongoClient(settings);
	}

	private static string CreateSessionId(string phase)
	{
		string raw = $"d113-{phase}-{Guid.NewGuid():N}";
		string trimmed = raw.Length > 32 ? raw[..32] : raw;
		return SessionId.From(trimmed).Value;
	}

	private static Credential CreateCredential()
	{
		return new Credential
		{
			House = "OutageHouse",
			Game = "FireKirin",
			Username = "OutageUser",
			Password = "OutagePass",
			Unlocked = true,
		};
	}

	private static Signal CreateSignal(Credential credential)
	{
		return new Signal(4, credential)
		{
			Acknowledged = true,
		};
	}

	private static void Run(string name, Func<bool> test, ref int passed, ref int failed)
	{
		try
		{
			if (test())
			{
				passed++;
				Console.WriteLine($"  PASS {name}");
				return;
			}

			failed++;
			Console.WriteLine($"  FAIL {name} returned false");
		}
		catch (Exception ex)
		{
			failed++;
			Console.WriteLine($"  FAIL {name} {ex.GetType().Name}: {ex.Message}");
		}
	}

	private sealed class GatedOutageRepository : IErrorEvidenceRepository
	{
		private readonly IErrorEvidenceRepository _inner;
		private readonly Func<bool> _isOutage;
		private readonly Exception _outageException;

		public GatedOutageRepository(IErrorEvidenceRepository inner, Func<bool> isOutage, Exception outageException)
		{
			_inner = inner;
			_isOutage = isOutage;
			_outageException = outageException;
		}

		public Task EnsureIndexesAsync(CancellationToken ct = default) => _inner.EnsureIndexesAsync(ct);

		public Task InsertAsync(ErrorEvidenceDocument document, CancellationToken ct = default)
		{
			if (_isOutage())
			{
				throw _outageException;
			}

			return _inner.InsertAsync(document, ct);
		}

		public Task InsertManyAsync(IReadOnlyCollection<ErrorEvidenceDocument> documents, CancellationToken ct = default)
		{
			if (_isOutage())
			{
				throw _outageException;
			}

			return _inner.InsertManyAsync(documents, ct);
		}

		public Task<IReadOnlyList<ErrorEvidenceDocument>> QueryBySessionAsync(string sessionId, int limit, CancellationToken ct = default)
			=> _inner.QueryBySessionAsync(sessionId, limit, ct);

		public Task<IReadOnlyList<ErrorEvidenceDocument>> QueryByCorrelationAsync(string correlationId, int limit, CancellationToken ct = default)
			=> _inner.QueryByCorrelationAsync(correlationId, limit, ct);
	}

	private readonly record struct OutageResult(
		ErrorEvidenceStats Stats,
		bool StableNoCrash,
		bool StableNonBlocking,
		int SinkFailureLogLines,
		int SummaryLogLines);
}
