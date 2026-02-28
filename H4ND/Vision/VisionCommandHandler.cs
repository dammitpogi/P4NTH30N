using System;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.H4ND.Infrastructure;

namespace P4NTHE0N.H4ND.Vision;

/// <summary>
/// FEAT-036: Executes vision commands via CDP in H4ND.
/// Translates VisionCommands into actual CDP browser actions (spin, screenshot, etc.).
/// </summary>
public sealed class VisionCommandHandler
{
	private readonly ICdpClient _cdp;
	private long _commandsExecuted;
	private long _commandsFailed;

	public long CommandsExecuted => Interlocked.Read(ref _commandsExecuted);
	public long CommandsFailed => Interlocked.Read(ref _commandsFailed);

	public VisionCommandHandler(ICdpClient cdpClient)
	{
		_cdp = cdpClient ?? throw new ArgumentNullException(nameof(cdpClient));
	}

	/// <summary>
	/// Executes a vision command via CDP.
	/// </summary>
	/// <param name="command">The vision command to execute.</param>
	/// <param name="ct">Cancellation token.</param>
	/// <returns>True if the command executed successfully.</returns>
	public async Task<bool> ExecuteAsync(VisionCommand command, CancellationToken ct = default)
	{
		try
		{
			bool result = command.CommandType switch
			{
				VisionCommandType.Spin => await ExecuteSpinAsync(command, ct),
				VisionCommandType.CaptureScreenshot => await ExecuteScreenshotAsync(command, ct),
				VisionCommandType.Stop => await ExecuteStopAsync(command, ct),
				VisionCommandType.Noop => true,
				VisionCommandType.Escalate => ExecuteEscalate(command),
				_ => false,
			};

			if (result)
			{
				Interlocked.Increment(ref _commandsExecuted);
				command.Status = VisionCommandStatus.Completed;
				command.ExecutedAt = DateTime.UtcNow;
			}
			else
			{
				Interlocked.Increment(ref _commandsFailed);
				command.Status = VisionCommandStatus.Failed;
			}

			return result;
		}
		catch (Exception ex)
		{
			Interlocked.Increment(ref _commandsFailed);
			command.Status = VisionCommandStatus.Failed;
			command.ErrorMessage = ex.Message;
			Console.WriteLine($"[VisionCommandHandler] Command {command.CommandType} failed: {ex.Message}");
			return false;
		}
	}

	private async Task<bool> ExecuteSpinAsync(VisionCommand command, CancellationToken ct)
	{
		string game = command.TargetGame;
		Console.WriteLine($"[VisionCommandHandler] Executing spin for {command.TargetUsername}@{game}");

		return game switch
		{
			"FireKirin" => await CdpGameActions.SpinFireKirinAsync(_cdp, ct),
			"OrionStars" => await CdpGameActions.SpinOrionStarsAsync(_cdp, ct),
			_ => throw new InvalidOperationException($"Unknown game for spin: {game}"),
		};
	}

	private async Task<bool> ExecuteScreenshotAsync(VisionCommand command, CancellationToken ct)
	{
		try
		{
			var response = await _cdp.SendCommandAsync("Page.captureScreenshot", new { format = "png" }, ct);
			// Store screenshot path in command parameters for retrieval
			command.Parameters["screenshotCaptured"] = "true";
			Console.WriteLine("[VisionCommandHandler] Screenshot captured");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[VisionCommandHandler] Screenshot failed: {ex.Message}");
			return false;
		}
	}

	private async Task<bool> ExecuteStopAsync(VisionCommand command, CancellationToken ct)
	{
		Console.WriteLine($"[VisionCommandHandler] Stop command received: {command.Reason}");
		await Task.CompletedTask;
		return true;
	}

	private static bool ExecuteEscalate(VisionCommand command)
	{
		Console.WriteLine($"[VisionCommandHandler] ESCALATION: {command.Reason}");
		return true;
	}
}
