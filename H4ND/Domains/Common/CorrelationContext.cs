using System;
using System.Threading;
using P4NTHE0N.H4ND.Domains.Automation.ValueObjects;

namespace P4NTHE0N.H4ND.Domains.Common;

/// <summary>
/// DECISION_110 Phase 1: Ambient correlation context flowing through async operations.
/// Stored in AsyncLocal so it propagates across awaits within the same logical call chain.
/// </summary>
public sealed class CorrelationContext
{
	private static readonly AsyncLocal<CorrelationContext?> s_current = new();

	public CorrelationId CorrelationId { get; }
	public SessionId SessionId { get; }
	public OperationName? OperationName { get; private set; }
	public string? WorkerId { get; private set; }
	public Timestamp CreatedAt { get; }

	public CorrelationContext(CorrelationId correlationId, SessionId sessionId)
	{
		CorrelationId = correlationId;
		SessionId = sessionId;
		CreatedAt = Timestamp.Now();
	}

	public static CorrelationContext? Current
	{
		get => s_current.Value;
		set => s_current.Value = value;
	}

	public static CorrelationContext EnsureCurrent()
	{
		return Current ?? throw new InvalidOperationException(
			"No CorrelationContext is active. Call CorrelationContext.Start() first.");
	}

	public static CorrelationContext Start(SessionId sessionId)
	{
		var ctx = new CorrelationContext(CorrelationId.New(), sessionId);
		Current = ctx;
		return ctx;
	}

	public static CorrelationContext Start(SessionId sessionId, CorrelationId correlationId)
	{
		var ctx = new CorrelationContext(correlationId, sessionId);
		Current = ctx;
		return ctx;
	}

	public CorrelationContext WithOperation(OperationName operation)
	{
		OperationName = operation;
		return this;
	}

	public CorrelationContext WithWorker(string workerId)
	{
		WorkerId = Guard.NotNullOrWhiteSpace(workerId);
		return this;
	}

	public static void Clear() => Current = null;
}
