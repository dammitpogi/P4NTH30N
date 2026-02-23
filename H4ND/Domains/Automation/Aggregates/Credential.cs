using P4NTH30N.H4ND.Domains.Automation.Events;
using P4NTH30N.H4ND.Domains.Automation.ValueObjects;
using P4NTH30N.H4ND.Domains.Common;
using P4NTH30N.H4ND.Domains.Execution.Events;
using P4NTH30N.H4ND.Domains.Execution.ValueObjects;

namespace P4NTH30N.H4ND.Domains.Automation.Aggregates;

public sealed class Credential : AggregateRoot
{
	private static readonly Money s_dropThreshold = new(0.1m);

	public CredentialId CredentialId { get; private set; }
	public Username Username { get; private set; }
	public GamePlatform Platform { get; private set; }
	public string House { get; private set; }
	public string Game { get; private set; }
	public JackpotBalance Jackpots { get; private set; }
	public Threshold Thresholds { get; private set; }
	public DpdToggleState DpdState { get; private set; }
	public bool IsLocked { get; private set; }
	public DateTime? LockExpiresAtUtc { get; private set; }

	public override string Id => CredentialId.Value;

	public Credential(
		CredentialId credentialId,
		Username username,
		GamePlatform platform,
		string house,
		string game,
		JackpotBalance initialJackpots,
		Threshold initialThresholds,
		DpdToggleState? initialDpdState = null,
		bool isLocked = false,
		DateTime? lockExpiresAtUtc = null,
		int version = 0)
	{
		CredentialId = credentialId;
		Username = username;
		Platform = platform;
		House = Guard.MaxLength(house, 64);
		Game = Guard.MaxLength(game, 64);
		Jackpots = initialJackpots;
		Thresholds = initialThresholds;
		DpdState = initialDpdState ?? new DpdToggleState();
		IsLocked = isLocked;
		LockExpiresAtUtc = lockExpiresAtUtc;
		Version = Guard.NonNegative(version);
	}

	public void Lock(TimeSpan duration, string lockedBy, DateTime utcNow)
	{
		if (IsLocked)
		{
			throw new DomainException(
				$"Credential '{CredentialId}' is already locked.",
				"Credential.Lock",
				aggregateId: CredentialId.Value);
		}

		if (duration <= TimeSpan.Zero)
		{
			throw new DomainException(
				$"Lock duration must be positive. Duration={duration}",
				"Credential.Lock",
				aggregateId: CredentialId.Value);
		}

		RaiseEvent(new CredentialLockedEvent(CredentialId, utcNow.Add(duration), lockedBy));
	}

	public void Unlock(string unlockedBy, string reason)
	{
		if (!IsLocked)
		{
			throw new DomainException(
				$"Credential '{CredentialId}' is not locked.",
				"Credential.Unlock",
				aggregateId: CredentialId.Value);
		}

		RaiseEvent(new CredentialUnlockedEvent(CredentialId, unlockedBy, reason));
	}

	public void RecordSignal(string signalId, int priority)
	{
		if (priority < 1 || priority > 4)
		{
			throw new DomainException(
				$"Signal priority must be in [1,4]. Priority={priority}",
				"Credential.RecordSignal",
				aggregateId: CredentialId.Value,
				context: $"signalId={signalId}");
		}

		RaiseEvent(new SignalReceivedEvent(signalId, CredentialId, Username, House, Game, priority));
	}

	public void RecordBalance(Money previousBalance, Money currentBalance)
	{
		RaiseEvent(new BalanceUpdatedEvent(CredentialId, previousBalance, currentBalance));
	}

	public void ApplyJackpotReading(JackpotBalance reading)
	{
		Guard.NotNull(reading);

		EvaluateTier(JackpotTier.Grand, reading.Grand);
		EvaluateTier(JackpotTier.Major, reading.Major);
		EvaluateTier(JackpotTier.Minor, reading.Minor);
		EvaluateTier(JackpotTier.Mini, reading.Mini);

		Jackpots = reading;
	}

	private void EvaluateTier(JackpotTier tier, Money currentValue)
	{
		var previousValue = Jackpots.GetByTier(tier);

		if (previousValue > currentValue && (previousValue - currentValue) > s_dropThreshold)
		{
			var priorToggle = DpdState.GetByTier(tier);
			if (priorToggle)
			{
				RaiseEvent(new JackpotPoppedEvent(CredentialId.Value, tier, previousValue.Amount, currentValue.Amount));
				RaiseEvent(new ThresholdResetEvent(CredentialId.Value, tier, currentValue.Amount));
				DpdState = DpdState.WithTier(tier, false);
				Thresholds = Thresholds.WithTier(tier, currentValue);
			}
			else
			{
				DpdState = DpdState.WithTier(tier, true);
			}
		}
	}

	protected override void Apply(IDomainEvent @event)
	{
		switch (@event)
		{
			case CredentialLockedEvent e:
				IsLocked = true;
				LockExpiresAtUtc = e.LockedUntilUtc;
				break;
			case CredentialUnlockedEvent:
				IsLocked = false;
				LockExpiresAtUtc = null;
				break;
			case ThresholdResetEvent e:
				Thresholds = Thresholds.WithTier(e.Tier, new Money(e.NewThreshold));
				break;
		}
	}
}
