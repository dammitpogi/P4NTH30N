namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public sealed class NoopErrorEvidence : IErrorEvidence
{
	public static readonly NoopErrorEvidence Instance = new();

	private NoopErrorEvidence() { }

	public ErrorScope BeginScope(string component, string operation, Dictionary<string, object>? tags = null, string filePath = "", string memberName = "", int lineNumber = 0)
		=> ErrorScope.Empty;

	public void Capture(Exception ex, string code, string message, Dictionary<string, object>? context = null, object? evidence = null, ErrorSeverity severity = ErrorSeverity.Error, string filePath = "", string memberName = "", int lineNumber = 0)
	{
	}

	public void CaptureWarning(string code, string message, Dictionary<string, object>? context = null, object? evidence = null, string filePath = "", string memberName = "", int lineNumber = 0)
	{
	}

	public void CaptureInvariantFailure(string code, string message, object? expected, object? actual, Dictionary<string, object>? context = null, string filePath = "", string memberName = "", int lineNumber = 0)
	{
	}

	public ErrorEvidenceStats GetStats() => new(0, 0, 0, 0, false);

	public ValueTask DisposeAsync() => ValueTask.CompletedTask;
}
