using System.Runtime.CompilerServices;

namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public interface IErrorEvidence : IAsyncDisposable
{
	ErrorScope BeginScope(
		string component,
		string operation,
		Dictionary<string, object>? tags = null,
		[CallerFilePath] string filePath = "",
		[CallerMemberName] string memberName = "",
		[CallerLineNumber] int lineNumber = 0);

	void Capture(
		Exception ex,
		string code,
		string message,
		Dictionary<string, object>? context = null,
		object? evidence = null,
		ErrorSeverity severity = ErrorSeverity.Error,
		[CallerFilePath] string filePath = "",
		[CallerMemberName] string memberName = "",
		[CallerLineNumber] int lineNumber = 0);

	void CaptureWarning(
		string code,
		string message,
		Dictionary<string, object>? context = null,
		object? evidence = null,
		[CallerFilePath] string filePath = "",
		[CallerMemberName] string memberName = "",
		[CallerLineNumber] int lineNumber = 0);

	void CaptureInvariantFailure(
		string code,
		string message,
		object? expected,
		object? actual,
		Dictionary<string, object>? context = null,
		[CallerFilePath] string filePath = "",
		[CallerMemberName] string memberName = "",
		[CallerLineNumber] int lineNumber = 0);

	ErrorEvidenceStats GetStats();
}

public readonly record struct ErrorEvidenceStats(
	long Enqueued,
	long Written,
	long DroppedQueueFull,
	long DroppedSinkFailure,
	bool Enabled);
