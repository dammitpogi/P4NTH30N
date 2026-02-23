using P4NTH30N.H4ND.Domains.Automation.Events;
using P4NTH30N.H4ND.Domains.Automation.ValueObjects;
using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.H4ND.Domains.Automation.Aggregates;

public sealed class SignalQueue : AggregateRoot
{
	private readonly Queue<QueuedSignal> _signals;

	public string QueueId { get; }
	public override string Id => QueueId;

	public int Count => _signals.Count;

	public SignalQueue(string queueId, IEnumerable<QueuedSignal>? existing = null, int version = 0)
	{
		QueueId = Guard.MaxLength(queueId, 128);
		_signals = new Queue<QueuedSignal>(existing ?? Enumerable.Empty<QueuedSignal>());
		Version = Guard.NonNegative(version);
	}

	public void Enqueue(QueuedSignal signal)
	{
		Guard.NotNull(signal);
		_signals.Enqueue(signal);
		RaiseEvent(new SignalReceivedEvent(
			signal.SignalId,
			new CredentialId(signal.CredentialId),
			new Username(signal.Username),
			signal.House,
			signal.Game,
			signal.Priority));
	}

	public QueuedSignal Dequeue()
	{
		if (_signals.Count == 0)
		{
			throw new DomainException("Cannot dequeue from empty signal queue.", "SignalQueue.Dequeue", aggregateId: QueueId);
		}

		return _signals.Dequeue();
	}

	public IReadOnlyCollection<QueuedSignal> Snapshot() => _signals.ToArray();

	protected override void Apply(IDomainEvent @event)
	{
		_ = @event;
	}
}

public sealed record QueuedSignal(
	string SignalId,
	string CredentialId,
	string Username,
	string House,
	string Game,
	int Priority);
