using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Interfaces;
using P4NTH30N.H4ND.Infrastructure;

namespace P4NTH30N.H4ND.Agents;

/// <summary>
/// DECISION_027: H4ND executor agent — receives execution requests
/// and processes them through the spin pipeline (CDP + credential lifecycle).
/// </summary>
public sealed class ExecutorAgent : IExecutor
{
	private readonly IUnitOfWork _uow;
	private readonly SpinMetrics _metrics;
	private bool _active = true;

	public string AgentId => "h4nd-executor";
	public string Name => "H4ND Executor";
	public AgentRole Role => AgentRole.Executor;
	public IReadOnlyList<string> Capabilities => ["spin_execution", "cdp_automation", "credential_management", "balance_query"];
	public bool IsActive => _active;
	public int Priority => 1;

	public ExecutorAgent(IUnitOfWork uow, SpinMetrics metrics)
	{
		_uow = uow;
		_metrics = metrics;
	}

	public Task HandleMessageAsync(AgentMessage message, CancellationToken ct = default)
	{
		switch (message.MessageType)
		{
			case "execute_request":
				Console.WriteLine($"[ExecutorAgent] Received execution request from {message.FromAgent}");
				break;
			case "status_query":
				Console.WriteLine($"[ExecutorAgent] Status: Active, Capabilities: {string.Join(", ", Capabilities)}");
				break;
			default:
				Console.WriteLine($"[ExecutorAgent] Unhandled message type: {message.MessageType}");
				break;
		}
		return Task.CompletedTask;
	}

	public Task<ExecutionResult> ExecuteAsync(ExecutionRequest request, CancellationToken ct = default)
	{
		try
		{
			switch (request.ActionType)
			{
				case "query_balance":
					return ExecuteBalanceQueryAsync(request);

				case "spin":
					Console.WriteLine($"[ExecutorAgent] Spin request for {request.Username}@{request.Game} in {request.House}");
					return Task.FromResult(new ExecutionResult
					{
						Success = true,
						Data = new Dictionary<string, string>
						{
							["action"] = "spin",
							["username"] = request.Username,
							["game"] = request.Game,
							["status"] = "queued_via_signal",
						},
					});

				default:
					return Task.FromResult(new ExecutionResult
					{
						Success = false,
						ErrorMessage = $"Unknown action type: {request.ActionType}",
					});
			}
		}
		catch (Exception ex)
		{
			return Task.FromResult(new ExecutionResult
			{
				Success = false,
				ErrorMessage = ex.Message,
			});
		}
	}

	private Task<ExecutionResult> ExecuteBalanceQueryAsync(ExecutionRequest request)
	{
		var credential = _uow.Credentials.GetBy(request.House, request.Game, request.Username);
		if (credential == null)
		{
			return Task.FromResult(new ExecutionResult
			{
				Success = false,
				ErrorMessage = $"Credential not found: {request.Username}@{request.Game}/{request.House}",
			});
		}

		try
		{
			dynamic balances = request.Game switch
			{
				"FireKirin" => FireKirin.QueryBalances(credential.Username, credential.Password),
				"OrionStars" => OrionStars.QueryBalances(credential.Username, credential.Password),
				_ => throw new Exception($"Unknown game: {request.Game}"),
			};

			return Task.FromResult(new ExecutionResult
			{
				Success = true,
				Data = new Dictionary<string, string>
				{
					["balance"] = ((double)balances.Balance).ToString("F2"),
					["grand"] = ((double)balances.Grand).ToString("F2"),
					["major"] = ((double)balances.Major).ToString("F2"),
					["minor"] = ((double)balances.Minor).ToString("F2"),
					["mini"] = ((double)balances.Mini).ToString("F2"),
				},
			});
		}
		catch (Exception ex)
		{
			return Task.FromResult(new ExecutionResult
			{
				Success = false,
				ErrorMessage = ex.Message,
			});
		}
	}

	public void Activate() => _active = true;
	public void Deactivate() => _active = false;
}
