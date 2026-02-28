using System.Diagnostics;
using System.Security.Cryptography;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

namespace P4NTHE0N.H4ND.Services;

/// <summary>
/// ARCH-055-002: Generates signals from enabled, unlocked, non-banned credentials.
/// Populates the SIGN4L collection to feed the parallel engine.
/// Priority distribution: 40% P1 (Mini), 30% P2 (Minor), 20% P3 (Major), 10% P4 (Grand).
/// </summary>
public sealed class SignalGenerator
{
	private readonly IUnitOfWork _uow;
	private readonly IErrorEvidence _errors;

	/// <summary>
	/// Priority distribution weights (cumulative): 40% Mini, 30% Minor, 20% Major, 10% Grand.
	/// </summary>
	private static readonly (float priority, double cumulativeWeight)[] PriorityDistribution =
	[
		(1, 0.40),  // Mini — 40%
		(2, 0.70),  // Minor — 30%
		(3, 0.90),  // Major — 20%
		(4, 1.00),  // Grand — 10%
	];

	public SignalGenerator(IUnitOfWork uow, IErrorEvidence? errors = null)
	{
		_uow = uow;
		_errors = errors ?? NoopErrorEvidence.Instance;
	}

	/// <summary>
	/// Generates N signals from eligible credentials in CR3D3N7IAL.
	/// </summary>
	/// <param name="count">Number of signals to generate.</param>
	/// <param name="filterGame">Optional: only credentials for this game (e.g. "FireKirin").</param>
	/// <param name="filterHouse">Optional: only credentials for this house.</param>
	/// <param name="fixedPriority">Optional: override priority distribution with a fixed priority (1-4).</param>
	public SignalGenerationResult Generate(int count, string? filterGame = null, string? filterHouse = null, int? fixedPriority = null)
	{
		using ErrorScope scope = _errors.BeginScope(
			"SignalGenerator",
			"Generate",
			new Dictionary<string, object>
			{
				["requestedCount"] = count,
				["filterGame"] = filterGame ?? "(all)",
				["filterHouse"] = filterHouse ?? "(all)",
				["fixedPriority"] = fixedPriority?.ToString() ?? "(distribution)",
			});

		Stopwatch sw = Stopwatch.StartNew();
		SignalGenerationResult result = new() { Requested = count };

		try
		{
			// 1. Query eligible credentials: enabled, not banned, unlocked
			List<Credential> eligible = _uow.Credentials.GetAll()
				.Where(c => c.Enabled && !c.Banned && c.Unlocked)
				.Where(c => filterGame == null || c.Game.Equals(filterGame, StringComparison.OrdinalIgnoreCase))
				.Where(c => filterHouse == null || c.House.Equals(filterHouse, StringComparison.OrdinalIgnoreCase))
				.ToList();

			if (eligible.Count == 0)
			{
				result.Errors.Add("No eligible credentials found (enabled, unlocked, not banned)");
				Console.WriteLine("[SignalGenerator] No eligible credentials found");
				_errors.CaptureWarning(
					"H4ND-SIGGEN-001",
					"No eligible credentials for signal generation",
					context: new Dictionary<string, object>
					{
						["filterGame"] = filterGame ?? "(all)",
						["filterHouse"] = filterHouse ?? "(all)",
					});
				sw.Stop();
				result.Elapsed = sw.Elapsed;
				return result;
			}

			Console.WriteLine($"[SignalGenerator] Found {eligible.Count} eligible credentials");

			// 2. Exclude credentials that already have an active signal
			List<Credential> available = [];
			foreach (Credential cred in eligible)
			{
				bool exists = _uow.Signals.Exists(new Signal
				{
					House = cred.House,
					Game = cred.Game,
					Username = cred.Username,
				});

				if (!exists)
				{
					available.Add(cred);
				}
			}

			if (available.Count == 0)
			{
				result.Skipped = count;
				result.Errors.Add("All eligible credentials already have active signals");
				Console.WriteLine("[SignalGenerator] No available credentials without active signals");
				sw.Stop();
				result.Elapsed = sw.Elapsed;
				return result;
			}

			int targetCount = Math.Min(count, available.Count);
			result.Skipped = count - targetCount;
			if (targetCount < count)
			{
				result.Errors.Add($"Requested {count} signals but only {targetCount} unique credentials were available");
				Console.WriteLine($"[SignalGenerator] Underfill prevented: requested={count}, available={targetCount}");
			}

			// 3. Shuffle to avoid bias, then emit up to target count
			Random rng = new();
			List<Credential> shuffled = available.OrderBy(_ => rng.Next()).ToList();

			for (int i = 0; i < targetCount; i++)
			{
				Credential cred = shuffled[i];

				// 4. Assign priority
				float priority;
				if (fixedPriority.HasValue && fixedPriority.Value >= 1 && fixedPriority.Value <= 4)
				{
					priority = fixedPriority.Value;
				}
				else
				{
					priority = AssignPriority(rng);
				}

				// 5. Create and insert signal
				try
				{
					Signal signal = new(priority, cred);
					_uow.Signals.Upsert(signal);
					result.Inserted++;
					Console.WriteLine($"[SignalGenerator] Created P{(int)priority} signal: {cred.Username}@{cred.Game} ({cred.House})");
				}
				catch (Exception ex)
				{
					result.Failed++;
					result.Errors.Add($"Failed to insert signal for {cred.Username}@{cred.Game}: {ex.Message}");
					Console.WriteLine($"[SignalGenerator] Insert failed: {ex.Message}");
					_errors.Capture(
						ex,
						"H4ND-SIGGEN-002",
						"Signal insert failed",
						context: new Dictionary<string, object>
						{
							["usernameHash"] = HashForEvidence(cred.Username),
							["game"] = cred.Game,
							["house"] = cred.House,
							["priority"] = priority,
						},
						severity: Infrastructure.Logging.ErrorEvidence.ErrorSeverity.Warning);
				}
			}
		}
		catch (Exception ex)
		{
			result.Failed++;
			result.Errors.Add($"Signal generation error: {ex.Message}");
			Console.WriteLine($"[SignalGenerator] Error: {ex.Message}");
			_errors.Capture(
				ex,
				"H4ND-SIGGEN-003",
				"Signal generation pipeline failed",
				context: new Dictionary<string, object>
				{
					["requestedCount"] = count,
					["insertedSoFar"] = result.Inserted,
					["failedSoFar"] = result.Failed,
				});
		}

		sw.Stop();
		result.Elapsed = sw.Elapsed;
		Console.WriteLine(result.ToString());
		return result;
	}

	/// <summary>
	/// Assigns a priority based on the configured distribution weights.
	/// </summary>
	private static float AssignPriority(Random rng)
	{
		double roll = rng.NextDouble();
		foreach (var (priority, cumulativeWeight) in PriorityDistribution)
		{
			if (roll <= cumulativeWeight)
				return priority;
		}
		return 1; // Fallback to Mini
	}

	private static string HashForEvidence(string input)
	{
		if (string.IsNullOrWhiteSpace(input))
			return string.Empty;
		byte[] bytes = SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(input));
		return Convert.ToHexString(bytes).Substring(0, 16);
	}
}
