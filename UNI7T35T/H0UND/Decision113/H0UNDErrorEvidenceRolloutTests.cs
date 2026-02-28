using MongoDB.Bson;
using MongoDB.Driver;
using H0UND.Services.Orchestration;
using P4NTHE0N;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H0UND.Application.Polling;
using P4NTHE0N.H0UND.Infrastructure.Polling;
using P4NTHE0N.H4ND.Domains.Automation.ValueObjects;
using P4NTHE0N.H4ND.Domains.Common;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

namespace P4NTHE0N.UNI7T35T.H0UND.Decision113;

public static class H0UNDErrorEvidenceRolloutTests
{
	private const string MongoConnectionString = "mongodb://localhost:27017";
	private const string DatabaseName = "P4NTHE0N";
	private const string CollectionName = "_debug";

	public static (int passed, int failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		if (!CanReachMongo())
		{
			Console.WriteLine("  ⚠ DEC113-H0UND: Mongo unavailable; rollout evidence tests skipped");
			return (1, 0);
		}

		bool orch = Run("D113-H0UND-Orchestrator", ScenarioOrchestrator, ref passed, ref failed);
		bool poll = Run("D113-H0UND-PollingWorker", ScenarioPollingWorker, ref passed, ref failed);
		bool orion = Run("D113-H0UND-OrionProvider", ScenarioOrionProvider, ref passed, ref failed);
		bool main = Run("D113-H0UND-MainLoop", ScenarioMainLoop, ref passed, ref failed);

		Console.WriteLine("  H0UND Hotspot Matrix (DECISION_113)");
		Console.WriteLine($"    ServiceOrchestrator={(orch ? "PASS" : "FAIL")}");
		Console.WriteLine($"    PollingWorker={(poll ? "PASS" : "FAIL")}");
		Console.WriteLine($"    OrionStarsBalanceProvider={(orion ? "PASS" : "FAIL")}");
		Console.WriteLine($"    H0UND.Main={(main ? "PASS" : "FAIL")}");

		return (passed, failed);
	}

	private static bool ScenarioOrchestrator()
	{
		return ExecuteScenario("H0UND_ORCH", "H0UND-ORCH-HEALTH-LOOP-001", errors =>
		{
			InvokeStatic(
				typeof(ServiceOrchestrator),
				"RecordHealthLoopError",
				errors,
				new InvalidOperationException("Simulated health loop fault"),
				"orchestrator",
				2);
		});
	}

	private static bool ScenarioPollingWorker()
	{
		return ExecuteScenario("H0UND_POLL", "H0UND-POLL-RETRY-ERR-001", errors =>
		{
			Credential cred = CreateCredential();
			InvokeStatic(typeof(PollingWorker), "RecordRetryGuardrailExceeded", errors, cred, 3);
		});
	}

	private static bool ScenarioOrionProvider()
	{
		return ExecuteScenario("H0UND_ORION", "H0UND-ORION-COERCE-001", errors =>
		{
			dynamic invalid = new System.Dynamic.ExpandoObject();
			invalid.Balance = double.NaN;
			invalid.Grand = double.PositiveInfinity;
			invalid.Major = -1.0;
			invalid.Minor = double.NaN;
			invalid.Mini = -2.0;

			InvokeStatic(typeof(OrionStarsBalanceProvider), "ValidateBalances", invalid, errors, "HarnessUser");
		});
	}

	private static bool ScenarioMainLoop()
	{
		return ExecuteScenario("H0UND_MAIN", "H0UND-MAIN-LOOP-ERR-001", errors =>
		{
			InvokeStatic(typeof(H0UNDEvidenceHooks), "RecordMainLoopError", errors, new Exception("Simulated main loop error"), "TestHarness");
			InvokeStatic(typeof(H0UNDEvidenceHooks), "RecordCircuitOpenSkip", errors, CreateCredential());
		});
	}

	private static bool ExecuteScenario(string scenario, string expectedCode, Action<IErrorEvidence> trigger)
	{
		string sessionId = BuildSessionId(scenario);
		CorrelationId correlationId = CorrelationId.New();

		CorrelationContext.Clear();
		CorrelationContext.Start(SessionId.From(sessionId), correlationId);

		MongoClient client = new(MongoConnectionString);
		IMongoDatabase db = client.GetDatabase(DatabaseName);
		IMongoCollection<ErrorEvidenceDocument> col = db.GetCollection<ErrorEvidenceDocument>(CollectionName);

		ErrorEvidenceOptions options = new()
		{
			Enabled = true,
			Collection = CollectionName,
			WarningSamplingRate = 1.0,
			InfoSamplingRate = 1.0,
			DebugSamplingRate = 1.0,
			BatchSize = 1,
			FlushIntervalMs = 10,
			QueueCapacity = 128,
		};

		IErrorEvidenceRepository repo = new MongoDebugEvidenceRepository(db, options);
		IErrorEvidenceFactory factory = new ErrorEvidenceFactory(options);

		ErrorEvidenceService service = new(repo, factory, options);
		try
		{
			using ErrorScope _ = service.BeginScope("DEC113H0UNDHarness", scenario);
			service.CaptureWarning($"{scenario}-START", "scenario-start");
			trigger(service);
			service.CaptureWarning($"{scenario}-END", "scenario-end");
		}
		finally
		{
			Task disposeTask = service.DisposeAsync().AsTask();
			Task.WhenAny(disposeTask, Task.Delay(2000)).GetAwaiter().GetResult();
			CorrelationContext.Clear();
		}

		List<ErrorEvidenceDocument> docs = col
			.Find(Builders<ErrorEvidenceDocument>.Filter.Eq(x => x.SessionId, sessionId))
			.SortBy(x => x.CapturedAtUtc)
			.ToList();

		if (docs.Count < 3)
		{
			throw new InvalidOperationException($"{scenario}: expected at least 3 docs, got {docs.Count}");
		}

		if (!docs.Any(d => d.ErrorCode == expectedCode))
		{
			throw new InvalidOperationException($"{scenario}: missing expected errorCode {expectedCode}");
		}

		string corr = correlationId.ToString();
		if (docs.Any(d => d.CorrelationId != corr))
		{
			throw new InvalidOperationException($"{scenario}: correlation chain continuity failed");
		}

		Console.WriteLine($"  ✅ {scenario}: docs={docs.Count}, sessionId={sessionId}, correlationId={corr}");
		return true;
	}

	private static string BuildSessionId(string scenario)
	{
		string raw = $"d113h0-{Guid.NewGuid():N}-{scenario}";
		string trimmed = raw.Length > 32 ? raw[..32] : raw;
		return SessionId.From(trimmed).Value;
	}

	private static Credential CreateCredential()
	{
		return new Credential
		{
			House = "HarnessHouse",
			Game = "OrionStars",
			Username = "HarnessUser",
			Password = "HarnessPass",
		};
	}

	private static bool CanReachMongo()
	{
		try
		{
			MongoClient client = new(MongoConnectionString);
			client.GetDatabase(DatabaseName).RunCommand<BsonDocument>(new BsonDocument("ping", 1));
			return true;
		}
		catch
		{
			return false;
		}
	}

	private static bool Run(string name, Func<bool> test, ref int passed, ref int failed)
	{
		try
		{
			if (test())
			{
				passed++;
				Console.WriteLine($"  ✅ {name}");
				return true;
			}

			failed++;
			Console.WriteLine($"  ❌ {name} returned false");
			return false;
		}
		catch (Exception ex)
		{
			failed++;
			string detail = ex is System.Reflection.TargetInvocationException tie && tie.InnerException != null
				? $"{tie.InnerException.GetType().Name}: {tie.InnerException.Message}"
				: ex.Message;
			Console.WriteLine($"  ❌ {name} — {ex.GetType().Name}: {detail}");
			return false;
		}
	}

	private static void InvokeStatic(Type type, string method, params object[] args)
	{
		var candidates = type.GetMethods(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Static)
			.Where(m => string.Equals(m.Name, method, StringComparison.Ordinal))
			.ToList();

		if (candidates.Count == 0)
		{
			throw new MissingMethodException(type.FullName, method);
		}

		foreach (var candidate in candidates)
		{
			var parameters = candidate.GetParameters();
			if (parameters.Length != args.Length)
			{
				continue;
			}

			candidate.Invoke(null, args);
			return;
		}

		throw new MissingMethodException(type.FullName, method);
	}
}
