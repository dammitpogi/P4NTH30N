using MongoDB.Bson;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.T00L5ET.Mocks;

/// <summary>
/// Factory for creating test data and mock instances for triage and testing.
/// Eliminates the need to recreate mocks from scratch for each triage operation.
/// </summary>
/// <remarks>
/// FORGE-2024-002: Standardized Mock Infrastructure.
/// Reduces triage setup time by 50%+ by providing reusable mock objects.
/// </remarks>
public static class MockFactory
{
	// ── Credential Factories ─────────────────────────────────────────

	/// <summary>
	/// Creates a valid test credential with sensible defaults.
	/// </summary>
	public static Credential CreateCredential(
		string username = "test_user",
		string password = "encrypted_pass",
		double balance = 100.00,
		bool enabled = true,
		string house = "test_casino",
		string game = "test_game"
	)
	{
		return new Credential(game)
		{
			Username = username,
			Password = password,
			Balance = balance,
			Enabled = enabled,
			Banned = false,
			House = house,
			LastUpdated = DateTime.UtcNow,
		};
	}

	/// <summary>
	/// Creates a batch of test credentials with sequential usernames.
	/// </summary>
	public static List<Credential> CreateCredentials(int count, double startingBalance = 100.00)
	{
		List<Credential> credentials = new();
		for (int i = 0; i < count; i++)
		{
			credentials.Add(CreateCredential(username: $"user_{i:D3}", balance: startingBalance + (i * 10)));
		}
		return credentials;
	}

	/// <summary>
	/// Creates a credential with low balance (for safety limit testing).
	/// </summary>
	public static Credential CreateLowBalanceCredential(double balance = 5.00)
	{
		return CreateCredential(username: "low_balance_user", balance: balance);
	}

	/// <summary>
	/// Creates a banned credential.
	/// </summary>
	public static Credential CreateBannedCredential()
	{
		Credential cred = CreateCredential(username: "banned_user", enabled: false);
		cred.Banned = true;
		return cred;
	}

	// ── Mock Repository Helpers ──────────────────────────────────────

	/// <summary>
	/// Creates a MockStoreErrors that collects all logged errors.
	/// </summary>
	public static CollectingErrorStore CreateErrorStore()
	{
		return new CollectingErrorStore();
	}
}

/// <summary>
/// IStoreErrors implementation that collects errors in a list for assertion.
/// </summary>
public class CollectingErrorStore : IStoreErrors
{
	public List<ErrorLog> Errors { get; } = new();

	public void Insert(ErrorLog error)
	{
		Errors.Add(error);
	}

	public List<ErrorLog> GetAll() => Errors;

	public List<ErrorLog> GetBySource(string source) => Errors.Where(e => e.Source == source).ToList();

	public List<ErrorLog> GetUnresolved() => Errors.Where(e => !e.Resolved).ToList();

	public void MarkResolved(ObjectId id)
	{
		ErrorLog? error = Errors.FirstOrDefault(e => e._id == id);
		if (error is not null)
			error.Resolved = true;
	}
}
