namespace P4NTH30N.H4ND.Services;

/// <summary>
/// ARCH-055-002: Result DTO for signal generation operations.
/// Tracks inserted, skipped (duplicates), and failed signal counts.
/// </summary>
public sealed class SignalGenerationResult
{
	public int Requested { get; init; }
	public int Inserted { get; set; }
	public int Skipped { get; set; }
	public int Failed { get; set; }
	public List<string> Errors { get; init; } = [];
	public DateTime GeneratedAt { get; init; } = DateTime.UtcNow;
	public TimeSpan Elapsed { get; set; }

	public bool IsSuccess => Failed == 0 && Inserted == Requested && Requested > 0;

	public override string ToString() =>
		$"[SignalGeneration] Requested={Requested} Inserted={Inserted} Skipped={Skipped} Failed={Failed} Elapsed={Elapsed.TotalMilliseconds:F0}ms";
}
