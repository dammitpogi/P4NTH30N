using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Interfaces;
using P4NTH30N.H4ND.Vision;

namespace P4NTH30N.H4ND;

/// <summary>
/// FOUREYES-015: H4ND vision command listener implementation.
/// Receives commands from the vision system and queues them for H4ND execution.
/// </summary>
public class VisionCommandListener : IVisionCommandListener
{
	private readonly ConcurrentQueue<VisionCommand> _commandQueue = new();
	private readonly ConcurrentDictionary<string, VisionCommand> _processingCommands = new();
	private readonly List<VisionCommand> _completedCommands = new();
	private readonly object _completedLock = new();
	private VisionCommandHandler? _commandHandler;
	private CancellationTokenSource? _cts;
	private Task? _listenTask;

	/// <summary>
	/// FEAT-036: Sets the VisionCommandHandler for dispatching commands via CDP.
	/// </summary>
	public void SetCommandHandler(VisionCommandHandler handler) => _commandHandler = handler;

	public bool IsListening { get; private set; }
	public event Action<VisionCommand>? OnCommandReceived;

	public Task StartAsync(CancellationToken cancellationToken = default)
	{
		if (IsListening)
			return Task.CompletedTask;

		_cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
		IsListening = true;

		_listenTask = Task.Run(
			async () =>
			{
				Console.WriteLine("[VisionCommandListener] Started listening for vision commands");
				while (!_cts.Token.IsCancellationRequested)
				{
					while (_commandQueue.TryDequeue(out VisionCommand? command))
					{
						try
						{
							await ProcessCommandAsync(command, _cts.Token);
						}
						catch (Exception ex)
						{
							StackTrace trace = new(ex, true);
							StackFrame? frame = trace.GetFrame(0);
							int line = frame?.GetFileLineNumber() ?? 0;
							Console.WriteLine($"[{line}] [VisionCommandListener] Error processing command {command.Id}: {ex.Message}");
							command.Status = VisionCommandStatus.Failed;
							command.ErrorMessage = ex.Message;
						}
					}
					await Task.Delay(100, _cts.Token);
				}
			},
			_cts.Token
		);

		return Task.CompletedTask;
	}

	public async Task StopAsync()
	{
		if (!IsListening)
			return;

		IsListening = false;
		_cts?.Cancel();

		if (_listenTask != null)
		{
			try
			{
				await _listenTask;
			}
			catch (OperationCanceledException) { }
		}

		_cts?.Dispose();
		_cts = null;
		Console.WriteLine("[VisionCommandListener] Stopped");
	}

	public async Task<bool> ProcessCommandAsync(VisionCommand command, CancellationToken cancellationToken = default)
	{
		command.Status = VisionCommandStatus.InProgress;
		_processingCommands[command.Id] = command;

		try
		{
			Console.WriteLine(
				$"[VisionCommandListener] Processing {command.CommandType} for {command.TargetUsername}@{command.TargetGame} (confidence: {command.Confidence:F2})"
			);

			switch (command.CommandType)
			{
				case VisionCommandType.Spin:
				case VisionCommandType.Stop:
				case VisionCommandType.SwitchGame:
				case VisionCommandType.AdjustBet:
				case VisionCommandType.CaptureScreenshot:
					// FEAT-036: Dispatch through VisionCommandHandler when available
					if (_commandHandler != null)
					{
						await _commandHandler.ExecuteAsync(command, cancellationToken);
					}
					else
					{
						command.Status = VisionCommandStatus.Completed;
						command.ExecutedAt = DateTime.UtcNow;
					}
					break;

				case VisionCommandType.Escalate:
					Console.WriteLine($"[VisionCommandListener] ESCALATION: {command.Reason}");
					command.Status = VisionCommandStatus.Completed;
					command.ExecutedAt = DateTime.UtcNow;
					break;

				case VisionCommandType.Noop:
					command.Status = VisionCommandStatus.Completed;
					command.ExecutedAt = DateTime.UtcNow;
					break;
			}

			lock (_completedLock)
			{
				_completedCommands.Add(command);
			}

			_processingCommands.TryRemove(command.Id, out _);
			return true;
		}
		catch (Exception ex)
		{
			command.Status = VisionCommandStatus.Failed;
			command.ErrorMessage = ex.Message;
			_processingCommands.TryRemove(command.Id, out _);
			return false;
		}
	}

	/// <summary>
	/// Enqueues a vision command for processing.
	/// </summary>
	public void EnqueueCommand(VisionCommand command)
	{
		_commandQueue.Enqueue(command);
		OnCommandReceived?.Invoke(command);
	}

	public Task<IReadOnlyList<VisionCommand>> GetPendingCommandsAsync(string? username = null, CancellationToken cancellationToken = default)
	{
		IEnumerable<VisionCommand> pending = _commandQueue.AsEnumerable();
		if (!string.IsNullOrEmpty(username))
			pending = pending.Where(c => c.TargetUsername.Equals(username, StringComparison.OrdinalIgnoreCase));

		return Task.FromResult<IReadOnlyList<VisionCommand>>(pending.ToList());
	}
}
