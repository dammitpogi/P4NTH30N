using System;
using MongoDB.Bson;

namespace P4NTHE0N.C0MMON;

public enum ErrorType
{
	DataCorruption,
	SanityCheckFailure,
	SystemError,
	ValidationError,
	Other,
}

public enum ErrorSeverity
{
	Low,
	Medium,
	High,
	Critical,
}

public class ErrorLog
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public ErrorType ErrorType { get; set; } = ErrorType.Other;
	public ErrorSeverity Severity { get; set; } = ErrorSeverity.Medium;
	public required string Source;
	public required string Message;
	public string? StackTrace { get; set; }
	public string? Context { get; set; } // JSON string for additional context
	public bool Resolved { get; set; } = false;
	public DateTime? ResolvedAt { get; set; }

	/// <summary>
	/// Creates a new error log entry.
	/// </summary>
	public static ErrorLog Create(ErrorType errorType, string source, string message, ErrorSeverity severity = ErrorSeverity.Medium)
	{
		return new ErrorLog
		{
			ErrorType = errorType,
			Source = source,
			Message = message,
			Severity = severity,
		};
	}

	/// <summary>
	/// Creates an error with stack trace from an exception.
	/// </summary>
	public static ErrorLog FromException(Exception ex, string source, ErrorType errorType = ErrorType.SystemError)
	{
		return new ErrorLog
		{
			ErrorType = errorType,
			Source = source,
			Message = ex.Message,
			StackTrace = ex.StackTrace,
			Severity = ErrorSeverity.High,
		};
	}
}
