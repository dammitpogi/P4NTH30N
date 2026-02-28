using P4NTHE0N.C0MMON;

namespace P4NTHE0N.H4ND.Parallel;

/// <summary>
/// ARCH-047: Result of an atomic signal claim operation.
/// </summary>
public sealed class SignalClaimResult
{
	public bool Success { get; init; }
	public Signal? Signal { get; init; }
	public string? ErrorMessage { get; init; }
	public string WorkerId { get; init; } = string.Empty;
	public DateTime ClaimedAt { get; init; } = DateTime.UtcNow;

	public static SignalClaimResult Claimed(Signal signal, string workerId) => new()
	{
		Success = true,
		Signal = signal,
		WorkerId = workerId,
		ClaimedAt = DateTime.UtcNow,
	};

	public static SignalClaimResult NoneAvailable(string workerId) => new()
	{
		Success = false,
		Signal = null,
		WorkerId = workerId,
		ErrorMessage = "No unclaimed signals available",
	};

	public static SignalClaimResult Failed(string workerId, string error) => new()
	{
		Success = false,
		Signal = null,
		WorkerId = workerId,
		ErrorMessage = error,
	};

	public override string ToString() =>
		Success
			? $"[Claim OK] Signal={Signal?._id} Worker={WorkerId}"
			: $"[Claim FAIL] Worker={WorkerId} Error={ErrorMessage}";
}
