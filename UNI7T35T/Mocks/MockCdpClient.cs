using System.Text.Json;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;

namespace UNI7T35T.Mocks;

/// <summary>
/// Mock ICdpClient for unit testing CDP-based game actions.
/// Allows configuring evaluate responses per-expression for deterministic testing.
/// </summary>
public class MockCdpClient : ICdpClient
{
	private readonly Dictionary<string, object?> _evaluateResponses = new();
	private readonly List<string> _evaluatedExpressions = [];
	private readonly List<string> _navigatedUrls = [];
	private readonly List<(string method, object? parameters)> _sentCommands = [];

	public bool IsConnected { get; set; } = true;

	/// <summary>
	/// Configure a response for a given expression substring match.
	/// When EvaluateAsync is called with an expression containing the key, the value is returned.
	/// </summary>
	public void SetEvaluateResponse(string expressionContains, object? value)
	{
		_evaluateResponses[expressionContains] = value;
	}

	public List<string> EvaluatedExpressions => _evaluatedExpressions;
	public List<string> NavigatedUrls => _navigatedUrls;
	public List<(string method, object? parameters)> SentCommands => _sentCommands;

	public Task<bool> ConnectAsync(CancellationToken cancellationToken = default)
	{
		IsConnected = true;
		return Task.FromResult(true);
	}

	public Task NavigateAsync(string url, CancellationToken cancellationToken = default)
	{
		_navigatedUrls.Add(url);
		return Task.CompletedTask;
	}

	public Task ClickAtAsync(int x, int y, CancellationToken cancellationToken = default)
	{
		return Task.CompletedTask;
	}

	public Task WaitForSelectorAndClickAsync(string selector, int? timeoutMs = null, CancellationToken cancellationToken = default)
	{
		return Task.CompletedTask;
	}

	public Task FocusSelectorAndClearAsync(string selector, int? timeoutMs = null, CancellationToken cancellationToken = default)
	{
		return Task.CompletedTask;
	}

	public Task TypeTextAsync(string text, CancellationToken cancellationToken = default)
	{
		return Task.CompletedTask;
	}

	public Task<T?> EvaluateAsync<T>(string expression, CancellationToken cancellationToken = default)
	{
		_evaluatedExpressions.Add(expression);

		foreach (KeyValuePair<string, object?> kvp in _evaluateResponses)
		{
			if (expression.Contains(kvp.Key, StringComparison.Ordinal))
			{
				if (kvp.Value is T typed)
				{
					return Task.FromResult<T?>(typed);
				}
				if (kvp.Value == null)
				{
					return Task.FromResult<T?>(default);
				}
				// Try converting via JSON round-trip for numeric type coercion
				try
				{
					string json = JsonSerializer.Serialize(kvp.Value);
					T? converted = JsonSerializer.Deserialize<T>(json);
					return Task.FromResult(converted);
				}
				catch
				{
					return Task.FromResult<T?>(default);
				}
			}
		}

		return Task.FromResult<T?>(default);
	}

	public Task<JsonElement> SendCommandAsync(string method, object? parameters = null, CancellationToken cancellationToken = default)
	{
		_sentCommands.Add((method, parameters));
		JsonElement empty = JsonSerializer.Deserialize<JsonElement>("{}");
		return Task.FromResult(empty);
	}

	public void Dispose()
	{
		IsConnected = false;
	}
}
