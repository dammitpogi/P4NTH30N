using P4NTH30N.H4ND.Domains.Common;
using P4NTH30N.H4ND.Domains.Execution.Events;
using P4NTH30N.H4ND.Domains.Execution.ValueObjects;

namespace P4NTH30N.H4ND.Domains.Execution.Aggregates;

public sealed class SpinSession : AggregateRoot
{
	public SpinId SpinId { get; private set; }
	public string CredentialId { get; private set; }
	public DateTime StartedAtUtc { get; private set; }
	public DateTime? CompletedAtUtc { get; private set; }
	public SpinResult? Result { get; private set; }

	public override string Id => SpinId.Value;

	public SpinSession(SpinId spinId, string credentialId, DateTime startedAtUtc, SpinResult? result = null, DateTime? completedAtUtc = null, int version = 0)
	{
		SpinId = spinId;
		CredentialId = Guard.MaxLength(credentialId, 128);
		StartedAtUtc = Guard.NotMinValue(startedAtUtc);
		Result = result;
		CompletedAtUtc = completedAtUtc;
		Version = Guard.NonNegative(version);
	}

	public void Complete(SpinResult result, DateTime completedAtUtc)
	{
		if (Result is not null)
		{
			throw new DomainException(
				$"Spin session '{SpinId}' is already completed.",
				"SpinSession.Complete",
				aggregateId: SpinId.Value);
		}

		RaiseEvent(new SpinExecutedEvent(
			SpinId.Value,
			CredentialId,
			result.Success,
			result.BalanceBefore,
			result.BalanceAfter)
		{
			OccurredAt = completedAtUtc,
		});
	}

	protected override void Apply(IDomainEvent @event)
	{
		if (@event is SpinExecutedEvent spinExecuted)
		{
			CompletedAtUtc = spinExecuted.OccurredAt;
			Result = new SpinResult(
				spinExecuted.Success,
				spinExecuted.BalanceBefore,
				spinExecuted.BalanceAfter,
				0m);
		}
	}
}
