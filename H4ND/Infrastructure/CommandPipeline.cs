using P4NTHE0N.C0MMON.Entities;

namespace P4NTHE0N.H4ND.Infrastructure;

/// <summary>
/// TECH-FE-015: Command pipeline result.
/// </summary>
public sealed class CommandResult
{
	public bool IsSuccess { get; init; }
	public VisionCommandStatus Status { get; init; }
	public string? ErrorMessage { get; init; }
	public CommandError? Error { get; init; }
	public DateTime CompletedAt { get; init; } = DateTime.UtcNow;

	public static CommandResult Success() => new() { IsSuccess = true, Status = VisionCommandStatus.Completed };

	public static CommandResult Failed(string message, CommandErrorCategory category = CommandErrorCategory.System) =>
		new()
		{
			IsSuccess = false,
			Status = VisionCommandStatus.Failed,
			ErrorMessage = message,
			Error = new CommandError
			{
				Category = category,
				Message = message,
				IsRetryable = category == CommandErrorCategory.Network || category == CommandErrorCategory.Timeout,
			},
		};

	public static CommandResult Cancelled(string reason) =>
		new()
		{
			IsSuccess = false,
			Status = VisionCommandStatus.Failed,
			ErrorMessage = $"Cancelled by {reason}",
		};
}

/// <summary>
/// TECH-FE-015: Command execution context carried through the pipeline.
/// </summary>
public sealed class CommandContext
{
	public VisionCommand Command { get; }
	public string? OperationId { get; set; }
	public string? Error { get; set; }

	public CommandContext(VisionCommand command)
	{
		Command = command;
	}
}

/// <summary>
/// TECH-FE-015: Error categories for command processing.
/// </summary>
public enum CommandErrorCategory
{
	Validation,
	Authentication,
	Network,
	Timeout,
	Browser,
	GameLogic,
	Vision,
	System,
}

/// <summary>
/// TECH-FE-015: Structured error for command failures.
/// </summary>
public sealed class CommandError
{
	public CommandErrorCategory Category { get; set; }
	public string Message { get; set; } = string.Empty;
	public string? StackTrace { get; set; }
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public bool IsRetryable { get; set; }
}

/// <summary>
/// TECH-FE-015: Middleware interface for the command pipeline.
/// </summary>
public interface ICommandMiddleware
{
	Task<bool> PreProcessAsync(CommandContext context);
	Task PostProcessAsync(CommandContext context, CommandResult result);
}

/// <summary>
/// TECH-FE-015: Command handler interface — one per VisionCommandType.
/// </summary>
public interface ICommandHandler
{
	VisionCommandType CommandType { get; }
	Task<CommandResult> HandleAsync(VisionCommand command, CancellationToken cancellationToken = default);
}

/// <summary>
/// TECH-FE-015: Command pipeline that runs middleware + dispatches to handlers.
/// </summary>
public sealed class CommandPipeline
{
	private readonly List<ICommandMiddleware> _middlewares = new();
	private readonly Dictionary<VisionCommandType, ICommandHandler> _handlers = new();

	public CommandPipeline AddMiddleware(ICommandMiddleware middleware)
	{
		_middlewares.Add(middleware);
		return this;
	}

	public CommandPipeline AddHandler(ICommandHandler handler)
	{
		_handlers[handler.CommandType] = handler;
		return this;
	}

	public async Task<CommandResult> ExecuteAsync(VisionCommand command, CancellationToken cancellationToken = default)
	{
		CommandContext context = new(command);

		// Pre-processing middleware
		foreach (ICommandMiddleware middleware in _middlewares)
		{
			if (!await middleware.PreProcessAsync(context))
			{
				return CommandResult.Cancelled($"{middleware.GetType().Name}: {context.Error ?? "rejected"}");
			}
		}

		// Dispatch to handler
		CommandResult result;
		if (_handlers.TryGetValue(command.CommandType, out ICommandHandler? handler))
		{
			result = await handler.HandleAsync(command, cancellationToken);
		}
		else
		{
			result = CommandResult.Failed($"No handler registered for {command.CommandType}", CommandErrorCategory.System);
		}

		// Post-processing middleware (reverse order)
		for (int i = _middlewares.Count - 1; i >= 0; i--)
		{
			await _middlewares[i].PostProcessAsync(context, result);
		}

		return result;
	}
}
