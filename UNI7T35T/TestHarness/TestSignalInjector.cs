using System;
using System.Threading;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;

namespace P4NTHE0N.UNI7T35T.TestHarness;

/// <summary>
/// TEST-035: Injects test signals into MongoDB SIGN4L collection.
/// Signals are flagged with IsTestSignal for cleanup after test execution.
/// </summary>
public sealed class TestSignalInjector
{
	private readonly IMongoCollection<BsonDocument> _signalCollection;
	private readonly string _testRunId;

	public TestSignalInjector(IMongoDatabase database, string testRunId)
	{
		_signalCollection = database.GetCollection<BsonDocument>(MongoCollectionNames.Signals);
		_testRunId = testRunId;
	}

	/// <summary>
	/// Injects a test signal for a specific game/house/user with the given priority.
	/// </summary>
	/// <param name="account">Test account to create the signal for.</param>
	/// <param name="priority">Signal priority (4=Grand, 3=Major, 2=Minor, 1=Mini).</param>
	/// <param name="ct">Cancellation token.</param>
	/// <returns>The injected signal's ObjectId.</returns>
	public async Task<ObjectId> InjectSignalAsync(TestAccount account, int priority, CancellationToken ct = default)
	{
		ObjectId signalId = ObjectId.GenerateNewId();

		BsonDocument signalDoc = new()
		{
			["_id"] = signalId,
			["House"] = account.House,
			["Username"] = account.Username,
			["Password"] = account.Password,
			["Game"] = account.Game,
			["Priority"] = (float)priority,
			["Acknowledged"] = false,
			["CreateDate"] = DateTime.UtcNow,
			["Timeout"] = DateTime.MinValue,
			// Test markers for cleanup
			["_testRunId"] = _testRunId,
			["_isTestSignal"] = true,
		};

		await _signalCollection.InsertOneAsync(signalDoc, cancellationToken: ct);
		Console.WriteLine($"[TestSignalInjector] Injected signal {signalId} for {account.Username}@{account.Game} P{priority} (run: {_testRunId})");
		return signalId;
	}

	/// <summary>
	/// Verifies a signal was acknowledged (picked up by H4ND).
	/// Polls with timeout.
	/// </summary>
	public async Task<bool> WaitForAcknowledgementAsync(ObjectId signalId, int timeoutMs = 30000, CancellationToken ct = default)
	{
		DateTime deadline = DateTime.UtcNow.AddMilliseconds(timeoutMs);

		while (DateTime.UtcNow < deadline && !ct.IsCancellationRequested)
		{
			FilterDefinition<BsonDocument> filter = Builders<BsonDocument>.Filter.Eq("_id", signalId);
			BsonDocument? doc = await _signalCollection.Find(filter).FirstOrDefaultAsync(ct);

			if (doc == null)
			{
				// Signal was consumed and deleted
				Console.WriteLine($"[TestSignalInjector] Signal {signalId} consumed (deleted from collection)");
				return true;
			}

			if (doc.Contains("Acknowledged") && doc["Acknowledged"].AsBoolean)
			{
				Console.WriteLine($"[TestSignalInjector] Signal {signalId} acknowledged");
				return true;
			}

			await Task.Delay(500, ct);
		}

		Console.WriteLine($"[TestSignalInjector] Signal {signalId} NOT acknowledged within {timeoutMs}ms");
		return false;
	}

	/// <summary>
	/// Cleans up all test signals for this test run.
	/// </summary>
	public async Task<long> CleanupAsync(CancellationToken ct = default)
	{
		FilterDefinition<BsonDocument> filter = Builders<BsonDocument>.Filter.Eq("_testRunId", _testRunId);
		DeleteResult result = await _signalCollection.DeleteManyAsync(filter, ct);
		Console.WriteLine($"[TestSignalInjector] Cleaned up {result.DeletedCount} test signals for run {_testRunId}");
		return result.DeletedCount;
	}
}
