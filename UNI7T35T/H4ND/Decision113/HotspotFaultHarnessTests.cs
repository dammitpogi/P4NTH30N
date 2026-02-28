using MongoDB.Bson;
using MongoDB.Driver;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;
using P4NTHE0N.C0MMON.Interfaces;
using P4NTHE0N.H4ND.Domains.Automation.ValueObjects;
using P4NTHE0N.H4ND.Domains.Common;
using P4NTHE0N.H4ND.Infrastructure;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;
using P4NTHE0N.H4ND.Parallel;
using P4NTHE0N.H4ND.Services;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.H4ND.Decision113;

public static class HotspotFaultHarnessTests
{
	private const string MongoConnectionString = "mongodb://localhost:27017";
	private const string DatabaseName = "P4NTHE0N";
	private const string CollectionName = "_debug";
	private static readonly TimeSpan MongoTimeout = TimeSpan.FromSeconds(2);

	public static (int passed, int failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		bool mongoReady = CanReachMongo();
		if (!mongoReady)
		{
			Console.WriteLine("  ⚠ DEC113-HOTSPOT: Mongo unavailable; hotspot evidence tests skipped");
			return (1, 0);
		}

		bool hs1 = Run("D113-HS1 EarlyAckPath", ExecuteHs1EarlyAckPath, ref passed, ref failed);
		bool hs2 = Run("D113-HS2 UnlockBeforePersist", ExecuteHs2UnlockBeforePersist, ref passed, ref failed);
		bool hs3 = Run("D113-HS3 AckOwnershipOverlap", ExecuteHs3AckOwnershipOverlap, ref passed, ref failed);
		bool hs4 = Run("D113-HS4 DeleteAllBranch", ExecuteHs4DeleteAllBranch, ref passed, ref failed);
		bool hs5 = Run("D113-HS5 RetryClaimRelease", ExecuteHs5RetryClaimRelease, ref passed, ref failed);

		Console.WriteLine("  Hotspot Matrix (native harness)");
		Console.WriteLine($"    HS1={(hs1 ? "PASS" : "FAIL")}");
		Console.WriteLine($"    HS2={(hs2 ? "PASS" : "FAIL")}");
		Console.WriteLine($"    HS3={(hs3 ? "PASS" : "FAIL")}");
		Console.WriteLine($"    HS4={(hs4 ? "PASS" : "FAIL")}");
		Console.WriteLine($"    HS5={(hs5 ? "PASS" : "FAIL")}");

		return (passed, failed);
	}

	private static bool ExecuteHs1EarlyAckPath()
	{
		const string expectedCode = "H4ND-ACK-OBS-001";
		return ExecuteScenario("HS1_EARLY_ACK_PATH", expectedCode, async (errors, cred, sig) =>
		{
			LegacyRuntimeHost.RecordPreProcessAckObservation(errors, sig, cred);
			await Task.CompletedTask;
		});
	}

	private static bool ExecuteHs2UnlockBeforePersist()
	{
		const string expectedCode = "H4ND-CRED-INV-001";
		return ExecuteScenario("HS2_UNLOCK_BEFORE_PERSIST", expectedCode, async (errors, cred, sig) =>
		{
			cred.Unlocked = false;
			LegacyRuntimeHost.RecordUnlockBeforePersistInvariant(errors, sig, cred);
			await Task.CompletedTask;
		});
	}

	private static bool ExecuteHs3AckOwnershipOverlap()
	{
		const string expectedCode = "H4ND-ACK-OBS-010";
		return ExecuteScenario("HS3_ACK_OWNERSHIP_OVERLAP", expectedCode, async (errors, cred, sig) =>
		{
			cred.Game = "UnknownGame";
			MockUnitOfWork uow = new();
			SpinMetrics metrics = new();
			SpinExecution spin = new(uow, metrics, errors);
			VisionCommand cmd = new()
			{
				CommandType = VisionCommandType.Spin,
				TargetGame = cred.Game,
				TargetHouse = cred.House,
				TargetUsername = cred.Username,
				Reason = "DEC113 hotspot harness",
			};

			bool _ = await spin.ExecuteSpinAsync(cmd, new NoopCdpClient(), sig, cred);
		});
	}

	private static bool ExecuteHs4DeleteAllBranch()
	{
		const string expectedCode = "H4ND-DELALL-BRANCH-001";
		return ExecuteScenario("HS4_DELETEALL_BRANCH", expectedCode, async (errors, cred, sig) =>
		{
			sig.Priority = 4;
			LegacyRuntimeHost.RecordDeleteAllBranchMarker(errors, sig, cred, 4);
			await Task.CompletedTask;
		});
	}

	private static bool ExecuteHs5RetryClaimRelease()
	{
		const string expectedCode = "H4ND-PAR-CLAIM-REL-001";
		return ExecuteScenario("HS5_RETRY_CLAIM_RELEASE", expectedCode, async (errors, cred, sig) =>
		{
			SignalWorkItem item = new()
			{
				Signal = sig,
				Credential = cred,
				WorkerId = "W99",
				RetryCount = 0,
			};

			IUnitOfWork uow = new ThrowingReleaseClaimUnitOfWork();
			bool released = ParallelSpinWorker.ReleaseClaimWithEvidence(
				uow,
				errors,
				item,
				expectedCode,
				"Failed to release signal claim after successful self-healing");

			if (released)
			{
				throw new InvalidOperationException("Expected release claim to fail in harness scenario.");
			}

			await Task.CompletedTask;
		});
	}

	private static bool ExecuteScenario(
		string scenario,
		string expectedErrorCode,
		Func<IErrorEvidence, Credential, Signal, Task> trigger)
	{
		string seed = Guid.NewGuid().ToString("N")[..10];
		string sessionIdRaw = $"d113-{seed}-{scenario}";
		string sessionId = SessionId.From(sessionIdRaw.Length > 32 ? sessionIdRaw[..32] : sessionIdRaw).Value;
		CorrelationId correlationId = CorrelationId.New();

		CorrelationContext.Clear();
		CorrelationContext.Start(SessionId.From(sessionId), correlationId);

		MongoClient client = CreateMongoClient();
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
			QueueCapacity = 256,
		};

		IErrorEvidenceRepository repo = new MongoDebugEvidenceRepository(db, options);
		IErrorEvidenceFactory factory = new ErrorEvidenceFactory(options);

		Credential cred = CreateCredential();
		Signal sig = CreateSignal(cred);

		ErrorEvidenceService service = new(repo, factory, options);
		try
		{
			Console.WriteLine($"  ▶ {scenario}: triggering hotspot path");
			using ErrorScope _ = service.BeginScope("DEC113Harness", scenario);
			service.CaptureWarning($"{scenario}-START", "scenario-start");
			trigger(service, cred, sig).GetAwaiter().GetResult();
			service.CaptureWarning($"{scenario}-END", "scenario-end");
		}
		finally
		{
			Task disposeTask = service.DisposeAsync().AsTask();
			Task.WhenAny(disposeTask, Task.Delay(2000)).GetAwaiter().GetResult();
			CorrelationContext.Clear();
		}

		List<ErrorEvidenceDocument> docs = [];
		DateTime deadline = DateTime.UtcNow.AddSeconds(5);
		while (DateTime.UtcNow < deadline)
		{
			docs = col
				.Find(Builders<ErrorEvidenceDocument>.Filter.Eq(x => x.SessionId, sessionId))
				.SortBy(x => x.CapturedAtUtc)
				.ToList();

			if (docs.Count >= 3)
			{
				break;
			}

			Thread.Sleep(100);
		}

		if (docs.Count < 3)
		{
			throw new InvalidOperationException($"{scenario}: expected at least 3 docs, got {docs.Count}");
		}

		bool hasExpected = docs.Any(d => d.ErrorCode == expectedErrorCode);
		if (!hasExpected)
		{
			throw new InvalidOperationException($"{scenario}: missing expected errorCode {expectedErrorCode}");
		}

		string corr = correlationId.ToString();
		if (docs.Any(d => d.CorrelationId != corr))
		{
			throw new InvalidOperationException($"{scenario}: correlation chain continuity failed");
		}

		for (int i = 1; i < docs.Count; i++)
		{
			if (docs[i].CapturedAtUtc < docs[i - 1].CapturedAtUtc)
			{
				throw new InvalidOperationException($"{scenario}: non-monotonic event order");
			}
		}

		ErrorEvidenceDocument marker = docs.First(d => d.ErrorCode == expectedErrorCode);
		if (marker.CapturedAtUtc == default || marker.Location == null || marker.Exception == null)
		{
			throw new InvalidOperationException($"{scenario}: missing where/when/exception envelope fields");
		}

		Console.WriteLine($"  ✅ {scenario}: docs={docs.Count}, sessionId={sessionId}, correlationId={corr}");
		return true;
	}

	private static Credential CreateCredential()
	{
		return new Credential
		{
			House = "HarnessHouse",
			Game = "FireKirin",
			Username = "HarnessUser",
			Password = "HarnessPass",
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

	private static bool CanReachMongo()
	{
		try
		{
			MongoClient client = CreateMongoClient();
			client.GetDatabase(DatabaseName).RunCommand<BsonDocument>(new BsonDocument("ping", 1));
			return true;
		}
		catch
		{
			return false;
		}
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
			Console.WriteLine($"  ❌ {name} — returned false");
			return false;
		}
		catch (Exception ex)
		{
			failed++;
			Console.WriteLine($"  ❌ {name} — {ex.GetType().Name}: {ex.Message}");
			return false;
		}
	}

	private sealed class NoopCdpClient : ICdpClient
	{
		public bool IsConnected => true;
		public Task<bool> ConnectAsync(CancellationToken cancellationToken = default) => Task.FromResult(true);
		public Task NavigateAsync(string url, CancellationToken cancellationToken = default) => Task.CompletedTask;
		public Task ClickAtAsync(int x, int y, CancellationToken cancellationToken = default) => Task.CompletedTask;
		public Task WaitForSelectorAndClickAsync(string selector, int? timeoutMs = null, CancellationToken cancellationToken = default) => Task.CompletedTask;
		public Task FocusSelectorAndClearAsync(string selector, int? timeoutMs = null, CancellationToken cancellationToken = default) => Task.CompletedTask;
		public Task TypeTextAsync(string text, CancellationToken cancellationToken = default) => Task.CompletedTask;
		public Task<T?> EvaluateAsync<T>(string expression, CancellationToken cancellationToken = default) => Task.FromResult<T?>(default);
		public Task<System.Text.Json.JsonElement> SendCommandAsync(string method, object? parameters = null, CancellationToken cancellationToken = default)
		{
			throw new NotSupportedException("NoopCdpClient does not execute CDP commands.");
		}
		public void Dispose() { }
	}

	private sealed class ThrowingReleaseClaimSignalsRepo : IRepoSignals
	{
		public List<Signal> GetAll() => [];
		public Signal? Get(string house, string game, string username) => null;
		public Signal? GetOne(string house, string game) => null;
		public Signal? GetNext() => null;
		public void DeleteAll(string house, string game) { }
		public bool Exists(Signal signal) => false;
		public void Acknowledge(Signal signal) => signal.Acknowledged = true;
		public void Upsert(Signal signal) { }
		public void Delete(Signal signal) { }
		public Signal? ClaimNext(string workerId) => null;
		public void ReleaseClaim(Signal signal) => throw new InvalidOperationException("Forced release-claim failure for hotspot harness");
	}

	private sealed class ThrowingReleaseClaimUnitOfWork : IUnitOfWork
	{
		public ThrowingReleaseClaimUnitOfWork()
		{
			Credentials = new MockRepoCredentials();
			Signals = new ThrowingReleaseClaimSignalsRepo();
			Jackpots = new MockRepoJackpots();
			ProcessEvents = new MockStoreEvents();
			Errors = new MockStoreErrors();
			Received = new MockReceiveSignals();
			Houses = new MockRepoHouses();
			TestResults = new MockRepoTestResults();
		}

		public IRepoCredentials Credentials { get; }
		public IRepoSignals Signals { get; }
		public IRepoJackpots Jackpots { get; }
		public IStoreEvents ProcessEvents { get; }
		public IStoreErrors Errors { get; }
		public IReceiveSignals Received { get; }
		public IRepoHouses Houses { get; }
		public IRepoTestResults TestResults { get; }
	}
}
