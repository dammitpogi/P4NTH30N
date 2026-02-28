namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public readonly struct ErrorScope : IDisposable
{
	private readonly Action? _onDispose;

	internal ErrorScope(
		string correlationId,
		string sessionId,
		string component,
		string operation,
		string operationId,
		Action? onDispose)
	{
		CorrelationId = correlationId;
		SessionId = sessionId;
		Component = component;
		Operation = operation;
		OperationId = operationId;
		_onDispose = onDispose;
	}

	public static ErrorScope Empty => new(
		correlationId: string.Empty,
		sessionId: string.Empty,
		component: string.Empty,
		operation: string.Empty,
		operationId: string.Empty,
		onDispose: null);

	public string CorrelationId { get; }
	public string SessionId { get; }
	public string Component { get; }
	public string Operation { get; }
	public string OperationId { get; }

	public void Dispose() => _onDispose?.Invoke();
}
