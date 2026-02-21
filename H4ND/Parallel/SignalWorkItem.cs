using P4NTH30N.C0MMON;

namespace P4NTH30N.H4ND.Parallel;

/// <summary>
/// ARCH-047: DTO for channel-based signal distribution.
/// Wraps a claimed Signal with worker metadata for the producer-consumer pipeline.
/// </summary>
public sealed class SignalWorkItem
{
	public required Signal Signal { get; init; }
	public required Credential Credential { get; init; }
	public required string WorkerId { get; init; }
	public DateTime ClaimedAt { get; init; } = DateTime.UtcNow;
	public int RetryCount { get; set; }

	/// <summary>
	/// Maximum retries before the work item is abandoned.
	/// </summary>
	public const int MaxRetries = 3;

	public bool CanRetry => RetryCount < MaxRetries;

	public override string ToString() =>
		$"[WorkItem] Signal={Signal._id} Cred={Credential.Username}@{Credential.Game} Worker={WorkerId} Retry={RetryCount}";
}
