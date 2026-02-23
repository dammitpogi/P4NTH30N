using System;

namespace P4NTH30N.H4ND.Domains.Common;

/// <summary>
/// DECISION_110 Phase 3: Base exception for domain rule violations.
/// Provides contextual information for fail-fast diagnostics.
/// </summary>
public class DomainException : Exception
{
	public string Operation { get; }
	public string? AggregateId { get; }
	public string? Context { get; }

	public DomainException(string message, string operation, string? aggregateId = null, string? context = null)
		: base(message)
	{
		Operation = Guard.NotNullOrWhiteSpace(operation);
		AggregateId = aggregateId;
		Context = context;
	}

	public DomainException(string message, string operation, Exception innerException, string? aggregateId = null, string? context = null)
		: base(message, innerException)
	{
		Operation = Guard.NotNullOrWhiteSpace(operation);
		AggregateId = aggregateId;
		Context = context;
	}

	public override string ToString() =>
		$"[{Operation}] {Message} (AggregateId={AggregateId ?? "N/A"}, Context={Context ?? "N/A"})";
}
