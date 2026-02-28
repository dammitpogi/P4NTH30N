using System.Threading.Channels;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.H4ND.Parallel;

/// <summary>
/// ARCH-047: Producer — polls SIGN4L collection and atomically claims signals,
/// writing them into a bounded Channel for consumption by ParallelSpinWorkers.
/// </summary>
public sealed class SignalDistributor
{
	private readonly IRepoSignals _signals;
	private readonly IRepoCredentials _credentials;
	private readonly ChannelWriter<SignalWorkItem> _writer;
	private readonly string _distributorId;
	private readonly TimeSpan _pollInterval;
	private readonly ParallelMetrics _metrics;

	public SignalDistributor(
		IRepoSignals signals,
		IRepoCredentials credentials,
		ChannelWriter<SignalWorkItem> writer,
		ParallelMetrics metrics,
		string distributorId = "distributor-0",
		TimeSpan? pollInterval = null)
	{
		_signals = signals;
		_credentials = credentials;
		_writer = writer;
		_metrics = metrics;
		_distributorId = distributorId;
		_pollInterval = pollInterval ?? TimeSpan.FromSeconds(1);
	}

	/// <summary>
	/// Continuously polls for unclaimed signals and writes them to the channel.
	/// Runs until cancellation is requested.
	/// </summary>
	public async Task RunAsync(CancellationToken ct)
	{
		Console.WriteLine($"[SignalDistributor] Started ({_distributorId}), polling every {_pollInterval.TotalSeconds}s");

		while (!ct.IsCancellationRequested)
		{
			try
			{
				// ARCH-055-007: Reclaim stale signals (claimed > 3 min ago, not acknowledged)
				// DECISION_075: Increased from 2min to 3min; respects per-signal Timeout field
				try
				{
					var allSignals = _signals.GetAll();
					const double defaultReclaimMinutes = 3.0;
					foreach (var stale in allSignals.Where(s =>
						s.ClaimedBy != null &&
						!s.Acknowledged &&
						s.ClaimedAt.HasValue &&
						(DateTime.UtcNow - s.ClaimedAt.Value).TotalMinutes >
							(s.Timeout > DateTime.MinValue && s.ClaimedAt.HasValue
								? (s.Timeout - s.ClaimedAt.Value).TotalMinutes
								: defaultReclaimMinutes)))
					{
						Console.WriteLine($"[SignalDistributor] Reclaiming stale signal {stale._id} (claimed by {stale.ClaimedBy} at {stale.ClaimedAt})");
						_signals.ReleaseClaim(stale);
						_metrics.IncrementStaleClaims();
					}
				}
				catch (Exception reclaimEx)
				{
					Console.WriteLine($"[SignalDistributor] Stale claim check error (non-fatal): {reclaimEx.Message}");
				}

				var claimed = _signals.ClaimNext(_distributorId);
				if (claimed != null)
				{
					var credential = _credentials.GetBy(claimed.House, claimed.Game, claimed.Username);
					if (credential == null)
					{
						Console.WriteLine($"[SignalDistributor] No credential for signal {claimed._id} ({claimed.Username}@{claimed.Game}) — releasing claim");
						_signals.ReleaseClaim(claimed);
						_metrics.RecordClaimFailure("no_credential");
						continue;
					}

					var workItem = new SignalWorkItem
					{
						Signal = claimed,
						Credential = credential,
						WorkerId = _distributorId,
						ClaimedAt = DateTime.UtcNow,
					};

					// Bounded channel — this will wait if the channel is full (backpressure)
					await _writer.WriteAsync(workItem, ct);
					_metrics.RecordClaimSuccess();
					Console.WriteLine($"[SignalDistributor] Queued {workItem}");
				}
				else
				{
					// No signals available — wait before polling again
					await Task.Delay(_pollInterval, ct);
				}
			}
			catch (OperationCanceledException)
			{
				break;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[SignalDistributor] Error: {ex.Message}");
				_metrics.RecordDistributorError(ex.Message);
				await Task.Delay(TimeSpan.FromSeconds(5), ct);
			}
		}

		_writer.Complete();
		Console.WriteLine($"[SignalDistributor] Stopped ({_distributorId})");
	}
}
