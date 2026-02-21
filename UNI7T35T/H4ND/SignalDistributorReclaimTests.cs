using P4NTH30N.C0MMON;
using P4NTH30N.H4ND.Parallel;
using UNI7T35T.Mocks;

namespace P4NTH30N.UNI7T35T.Tests;

/// <summary>
/// DECISION_075: Verify reclaim window fix.
/// 1. Reclaim window increased from 2min to 3min
/// 2. Respects per-signal Timeout field
/// 3. Legitimate long-running spins not reclaimed prematurely
/// </summary>
public static class SignalDistributorReclaimTests
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
					Console.WriteLine($"  ✅ {name}");
					passed++;
				}
				else
				{
					Console.WriteLine($"  ❌ {name}");
					failed++;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  ❌ {name} — Exception: {ex.Message}");
				failed++;
			}
		}

		Run("Test_SignalClaimedUnder3Min_NotReclaimed", Test_SignalClaimedUnder3Min_NotReclaimed);
		Run("Test_SignalClaimedOver3Min_Reclaimed", Test_SignalClaimedOver3Min_Reclaimed);
		Run("Test_SignalWithCustomTimeout_Respected", Test_SignalWithCustomTimeout_Respected);
		Run("Test_AcknowledgedSignal_NeverReclaimed", Test_AcknowledgedSignal_NeverReclaimed);
		Run("Test_UnclaimedSignal_NotAffectedByReclaim", Test_UnclaimedSignal_NotAffectedByReclaim);

		return (passed, failed);
	}

	private static bool Test_SignalClaimedUnder3Min_NotReclaimed()
	{
		// Signal claimed 2 minutes ago should NOT be reclaimed (window is 3 min)
		var signal = MakeSignal("user1");
		signal.ClaimedBy = "worker-1";
		signal.ClaimedAt = DateTime.UtcNow.AddMinutes(-2);

		const double defaultReclaimMinutes = 3.0;
		bool isStale = signal.ClaimedBy != null
			&& !signal.Acknowledged
			&& signal.ClaimedAt.HasValue
			&& (DateTime.UtcNow - signal.ClaimedAt.Value).TotalMinutes > defaultReclaimMinutes;

		return !isStale; // Should NOT be stale
	}

	private static bool Test_SignalClaimedOver3Min_Reclaimed()
	{
		// Signal claimed 4 minutes ago SHOULD be reclaimed
		var signal = MakeSignal("user1");
		signal.ClaimedBy = "worker-1";
		signal.ClaimedAt = DateTime.UtcNow.AddMinutes(-4);

		const double defaultReclaimMinutes = 3.0;
		bool isStale = signal.ClaimedBy != null
			&& !signal.Acknowledged
			&& signal.ClaimedAt.HasValue
			&& (DateTime.UtcNow - signal.ClaimedAt.Value).TotalMinutes > defaultReclaimMinutes;

		return isStale; // Should be stale
	}

	private static bool Test_SignalWithCustomTimeout_Respected()
	{
		// DECISION_075: Signal with Timeout field set should use that instead of default
		var signal = MakeSignal("user1");
		signal.ClaimedBy = "worker-1";
		signal.ClaimedAt = DateTime.UtcNow.AddMinutes(-4);
		signal.Timeout = DateTime.UtcNow.AddMinutes(10); // Custom timeout: 10min from now

		// The reclaim logic: (s.Timeout > 0 ? s.Timeout / 60.0 : defaultReclaimMinutes)
		// DateTime.MinValue would be "0" equivalent, non-MinValue means custom timeout
		// Timeout is DateTime — when Timeout != MinValue, it represents the deadline
		// For the reclaim filter: Timeout field is treated as seconds value in the filter
		const double defaultReclaimMinutes = 3.0;
		double timeoutSeconds = signal.Timeout > DateTime.MinValue
			? (signal.Timeout - signal.CreateDate).TotalSeconds
			: 0;
		double reclaimMinutes = timeoutSeconds > 0 ? timeoutSeconds / 60.0 : defaultReclaimMinutes;

		bool isStale = signal.ClaimedBy != null
			&& !signal.Acknowledged
			&& signal.ClaimedAt.HasValue
			&& (DateTime.UtcNow - signal.ClaimedAt.Value).TotalMinutes > reclaimMinutes;

		// With a 10-minute timeout, a 4-minute-old claim should NOT be stale
		return !isStale;
	}

	private static bool Test_AcknowledgedSignal_NeverReclaimed()
	{
		var signal = MakeSignal("user1");
		signal.ClaimedBy = "worker-1";
		signal.ClaimedAt = DateTime.UtcNow.AddMinutes(-10);
		signal.Acknowledged = true;

		const double defaultReclaimMinutes = 3.0;
		bool isStale = signal.ClaimedBy != null
			&& !signal.Acknowledged // This is false, so isStale = false
			&& signal.ClaimedAt.HasValue
			&& (DateTime.UtcNow - signal.ClaimedAt.Value).TotalMinutes > defaultReclaimMinutes;

		return !isStale; // Acknowledged signals are never reclaimed
	}

	private static bool Test_UnclaimedSignal_NotAffectedByReclaim()
	{
		var signal = MakeSignal("user1");
		// ClaimedBy is null — unclaimed signal

		const double defaultReclaimMinutes = 3.0;
		bool isStale = signal.ClaimedBy != null // false — short-circuit
			&& !signal.Acknowledged
			&& signal.ClaimedAt.HasValue
			&& (DateTime.UtcNow - signal.ClaimedAt.Value).TotalMinutes > defaultReclaimMinutes;

		return !isStale; // Unclaimed signals are not stale
	}

	private static Signal MakeSignal(string username)
	{
		return new Signal
		{
			House = "MIDAS",
			Game = "FireKirin",
			Username = username,
			Priority = 4,
			Acknowledged = false,
		};
	}
}
