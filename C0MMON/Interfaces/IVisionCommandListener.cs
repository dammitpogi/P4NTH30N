using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Entities;

namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-015: Contract for H4ND vision command listener.
/// Receives and processes vision commands from W4TCHD0G/H0UND.
/// </summary>
public interface IVisionCommandListener
{
	/// <summary>
	/// Starts listening for vision commands.
	/// </summary>
	Task StartAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Stops listening for vision commands.
	/// </summary>
	Task StopAsync();

	/// <summary>
	/// Processes a single vision command.
	/// </summary>
	Task<bool> ProcessCommandAsync(VisionCommand command, CancellationToken cancellationToken = default);

	/// <summary>
	/// Gets pending commands for a specific username/game.
	/// </summary>
	Task<IReadOnlyList<VisionCommand>> GetPendingCommandsAsync(string? username = null, CancellationToken cancellationToken = default);

	/// <summary>
	/// Whether the listener is currently active.
	/// </summary>
	bool IsListening { get; }

	/// <summary>
	/// Event raised when a command is received.
	/// </summary>
	event Action<VisionCommand>? OnCommandReceived;
}
