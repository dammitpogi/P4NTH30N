using System.Diagnostics;
using System.Security.Cryptography;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;
using CommonErrorSeverity = P4NTHE0N.C0MMON.ErrorSeverity;

namespace P4NTHE0N.H4ND.Infrastructure;

/// <summary>
/// TECH-JP-002: Executes spins via CDP and tracks metrics.
/// Bridges VisionCommand → CdpClient spin → balance update → signal acknowledgment.
/// </summary>
public sealed class SpinExecution
{
	private readonly IUnitOfWork _uow;
	private readonly SpinMetrics _metrics;
	private readonly IErrorEvidence _errors;

	public SpinExecution(IUnitOfWork uow, SpinMetrics metrics, IErrorEvidence? errors = null)
	{
		_uow = uow;
		_metrics = metrics;
		_errors = errors ?? NoopErrorEvidence.Instance;
	}

	/// <summary>
	/// Executes a spin for the given VisionCommand using the active CDP client.
	/// Updates balances, acknowledges the signal, and records metrics.
	/// </summary>
	public async Task<bool> ExecuteSpinAsync(VisionCommand command, ICdpClient cdp, Signal signal, Credential credential, CancellationToken cancellationToken = default)
	{
		using ErrorScope scope = _errors.BeginScope(
			"SpinExecution",
			"ExecuteSpinAsync",
			new Dictionary<string, object>
			{
				["signalId"] = signal._id.ToString(),
				["credentialId"] = credential._id.ToString(),
				["house"] = credential.House,
				["game"] = credential.Game,
				["priority"] = signal.Priority,
				["workerCommandType"] = command.CommandType.ToString(),
			});

		Stopwatch sw = Stopwatch.StartNew();
		double balanceBefore = credential.Balance;
		bool success = false;
		string? errorMessage = null;

		try
		{
			if (signal.Acknowledged)
			{
				_errors.CaptureWarning(
					"H4ND-ACK-OBS-010",
					"Signal was already acknowledged before authoritative SpinExecution ack",
					context: BuildContext(command, signal, credential),
					evidence: new
					{
						signalId = signal._id.ToString(),
						acknowledged = signal.Acknowledged,
					});
			}

			// Execute the spin via CdpClient based on the game type.
			bool spinExecuted = credential.Game switch
			{
				"FireKirin" => await CdpGameActions.SpinFireKirinAsync(cdp, cancellationToken),
				"OrionStars" => await CdpGameActions.SpinOrionStarsAsync(cdp, cancellationToken),
				_ => throw new Exception($"Unrecognized Game for spin: '{credential.Game}'"),
			};

			if (!spinExecuted)
			{
				throw new InvalidOperationException($"CDP spin action returned false for {credential.Game}");
			}

			Console.WriteLine($"({DateTime.Now}) {credential.House} - Completed Reel Spins via SpinExecution...");

			// DECISION_113: authoritative ACK ownership is here.
			_uow.Signals.Acknowledge(signal);

			if (!signal.Acknowledged)
			{
				_errors.CaptureInvariantFailure(
					"H4ND-ACK-INV-001",
					"Signal remained unacknowledged after authoritative ack call",
					expected: true,
					actual: signal.Acknowledged,
					context: BuildContext(command, signal, credential));
			}

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

			_errors.Capture(
				ex,
				"H4ND-SPINEXEC-001",
				$"Spin failed for {credential.Game}",
				context: BuildContext(command, signal, credential),
				evidence: new
				{
					signalId = signal._id.ToString(),
					signalAcknowledged = signal.Acknowledged,
					credentialId = credential._id.ToString(),
					usernameHash = HashForEvidence(credential.Username),
					commandReason = command.Reason,
					line,
				});

			_uow.Errors.Insert(
				ErrorLog.Create(ErrorType.SystemError, "SpinExecution", $"Spin failed for {credential.Username}@{credential.Game}: {ex.Message}", CommonErrorSeverity.High)
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

	private static Dictionary<string, object> BuildContext(VisionCommand command, Signal signal, Credential credential)
	{
		return new Dictionary<string, object>
		{
			["signalId"] = signal._id.ToString(),
			["credentialId"] = credential._id.ToString(),
			["house"] = credential.House,
			["game"] = credential.Game,
			["priority"] = signal.Priority,
			["commandType"] = command.CommandType.ToString(),
		};
	}

	private static string HashForEvidence(string input)
	{
		if (string.IsNullOrWhiteSpace(input))
		{
			return string.Empty;
		}

		byte[] bytes = SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(input));
		return Convert.ToHexString(bytes).Substring(0, 16);
	}
}
