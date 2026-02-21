using System.Diagnostics;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.C0MMON.Infrastructure.Persistence;

namespace P4NTH30N.H4ND.Infrastructure;

/// <summary>
/// TECH-JP-002: Executes spins via CDP and tracks metrics.
/// Bridges VisionCommand → CdpClient spin → balance update → signal acknowledgment.
/// </summary>
public sealed class SpinExecution
{
	private readonly IUnitOfWork _uow;
	private readonly SpinMetrics _metrics;

	public SpinExecution(IUnitOfWork uow, SpinMetrics metrics)
	{
		_uow = uow;
		_metrics = metrics;
	}

	/// <summary>
	/// Executes a spin for the given VisionCommand using the active CDP client.
	/// Updates balances, acknowledges the signal, and records metrics.
	/// </summary>
	public async Task<bool> ExecuteSpinAsync(VisionCommand command, ICdpClient cdp, Signal signal, Credential credential, CancellationToken cancellationToken = default)
	{
		Stopwatch sw = Stopwatch.StartNew();
		double balanceBefore = credential.Balance;
		bool success = false;
		string? errorMessage = null;

		try
		{
			// Execute the spin via CdpClient based on the game type
			switch (credential.Game)
			{
				case "FireKirin":
					await CdpGameActions.SpinFireKirinAsync(cdp, cancellationToken);
					break;
				case "OrionStars":
					await CdpGameActions.SpinOrionStarsAsync(cdp, cancellationToken);
					break;
				default:
					throw new Exception($"Unrecognized Game for spin: '{credential.Game}'");
			}

			Console.WriteLine($"({DateTime.Now}) {credential.House} - Completed Reel Spins via SpinExecution...");

			// Acknowledge the signal after successful spin
			_uow.Signals.Acknowledge(signal);

			success = true;
			return true;
		}
		catch (Exception ex)
		{
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			errorMessage = ex.Message;
			Console.WriteLine($"[{line}] [SpinExecution] Spin failed for {credential.Username}@{credential.Game}: {ex.Message}");

			_uow.Errors.Insert(
				ErrorLog.Create(ErrorType.SystemError, "SpinExecution", $"Spin failed for {credential.Username}@{credential.Game}: {ex.Message}", ErrorSeverity.High)
			);

			return false;
		}
		finally
		{
			sw.Stop();

			// OPS-JP-001: Record metrics for every spin attempt
			_metrics.RecordSpin(
				new SpinRecord
				{
					Success = success,
					LatencyMs = sw.Elapsed.TotalMilliseconds,
					Game = credential.Game,
					House = credential.House,
					Username = credential.Username,
					BalanceBefore = balanceBefore,
					BalanceAfter = credential.Balance,
					SignalPriority = (int)signal.Priority,
					ErrorMessage = errorMessage,
				}
			);
		}
	}
}
