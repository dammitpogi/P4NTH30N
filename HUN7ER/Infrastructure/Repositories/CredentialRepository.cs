using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Infrastructure.Persistence;
using P4NTH30N.HUN7ER.Domain.Entities;
using P4NTH30N.HUN7ER.Domain.ValueObjects;
using DomainDPD = P4NTH30N.HUN7ER.Domain.ValueObjects.DollarsPerDay;
using DomainThresholds = P4NTH30N.HUN7ER.Domain.ValueObjects.Thresholds;

namespace P4NTH30N.HUN7ER.Infrastructure.Repositories;

/// <summary>
/// Repository for managing credentials - maps between MongoDB and Domain entities
/// </summary>
public class CredentialRepository
{
	private readonly IMongoUnitOfWork _uow;

	public CredentialRepository(IMongoUnitOfWork uow)
	{
		_uow = uow;
	}

	public List<GameCredential> GetAll()
	{
		var mongoCredentials = _uow.Credentials.GetAll();
		return mongoCredentials.Select(MapToDomain).ToList();
	}

	public List<GameCredential> GetByGame(string house, string game)
	{
		var mongoCredentials = _uow.Credentials.GetBy(house, game);
		return mongoCredentials.Select(MapToDomain).ToList();
	}

	public GameCredential? GetNext(bool usePriority)
	{
		var mongoCred = _uow.Credentials.GetNext(usePriority);
		return mongoCred != null ? MapToDomain(mongoCred) : null;
	}

	public void Upsert(GameCredential credential)
	{
		var mongoCred = MapToMongo(credential);
		_uow.Credentials.Upsert(mongoCred);
	}

	public void Lock(GameCredential credential)
	{
		var mongoCred = _uow.Credentials.GetBy(credential.House, credential.Game, credential.Username);
		if (mongoCred != null)
			_uow.Credentials.Lock(mongoCred);
	}

	public void Unlock(GameCredential credential)
	{
		var mongoCred = _uow.Credentials.GetBy(credential.House, credential.Game, credential.Username);
		if (mongoCred != null)
			_uow.Credentials.Unlock(mongoCred);
	}

	private static GameCredential MapToDomain(Credential mongo)
	{
		return new GameCredential
		{
			Id = mongo._id.ToString(),
			Username = mongo.Username,
			Password = mongo.Password,
			House = mongo.House,
			Game = mongo.Game,
			Balance = mongo.Balance,
			Jackpots = new JackpotValues(mongo.Jackpots.Grand, mongo.Jackpots.Major, mongo.Jackpots.Minor, mongo.Jackpots.Mini),
			Thresholds = new DomainThresholds
			{
				Grand = mongo.Thresholds.Grand,
				Major = mongo.Thresholds.Major,
				Minor = mongo.Thresholds.Minor,
				Mini = mongo.Thresholds.Mini,
			},
			DPD = new DomainDPD
			{
				Average = mongo.DPD.Average,
				Data = mongo.DPD.Data.Select(d => new DpdDataPoint(d.Timestamp, d.Grand, d.Major, d.Minor, d.Mini)).ToList(),
				History = mongo
					.DPD.History.Select(h => new DpdHistory(h.Average, h.Data.Select(d => new DpdDataPoint(d.Timestamp, d.Grand, d.Major, d.Minor, d.Mini))))
					.ToList(),
				Toggles = new DpdToggles
				{
					GrandPopped = mongo.DPD.Toggles.GrandPopped,
					MajorPopped = mongo.DPD.Toggles.MajorPopped,
					MinorPopped = mongo.DPD.Toggles.MinorPopped,
					MiniPopped = mongo.DPD.Toggles.MiniPopped,
				},
			},
			Enabled = mongo.Enabled,
			Banned = mongo.Banned,
			Unlocked = mongo.Unlocked,
			CashedOut = mongo.CashedOut,
			LastDepositDate = mongo.LastDepositDate,
			LastUpdated = mongo.LastUpdated,
			UnlockTimeout = mongo.UnlockTimeout,
			SpinGrand = mongo.Settings?.SpinGrand ?? true,
			SpinMajor = mongo.Settings?.SpinMajor ?? true,
			SpinMinor = mongo.Settings?.SpinMinor ?? true,
			SpinMini = mongo.Settings?.SpinMini ?? true,
			Hidden = mongo.Settings?.Hidden ?? false,
		};
	}

	private static Credential MapToMongo(GameCredential domain)
	{
		var mongo = new Credential(domain.Game)
		{
			Username = domain.Username,
			Password = domain.Password,
			House = domain.House,
			Game = domain.Game,
			Balance = domain.Balance,
			Jackpots = new Jackpots
			{
				Grand = domain.Jackpots.Grand,
				Major = domain.Jackpots.Major,
				Minor = domain.Jackpots.Minor,
				Mini = domain.Jackpots.Mini,
			},
			Thresholds = new P4NTH30N.C0MMON.Thresholds
			{
				Grand = domain.Thresholds.Grand,
				Major = domain.Thresholds.Major,
				Minor = domain.Thresholds.Minor,
				Mini = domain.Thresholds.Mini,
			},
			DPD = new DPD
			{
				Average = domain.DPD.Average,
				Data = domain.DPD.Data.Select(d => new DPD_Data(d.Grand, d.Major, d.Minor, d.Mini)).ToList(),
				History = domain
					.DPD.History.Select(h => new DPD_History(h.Average, h.Data.Select(d => new DPD_Data(d.Grand, d.Major, d.Minor, d.Mini)).ToList()))
					.ToList(),
				Toggles = new DPD_Toggles
				{
					GrandPopped = domain.DPD.Toggles.GrandPopped,
					MajorPopped = domain.DPD.Toggles.MajorPopped,
					MinorPopped = domain.DPD.Toggles.MinorPopped,
					MiniPopped = domain.DPD.Toggles.MiniPopped,
				},
			},
			Enabled = domain.Enabled,
			Banned = domain.Banned,
			Unlocked = domain.Unlocked,
			CashedOut = domain.CashedOut,
			LastDepositDate = domain.LastDepositDate,
			LastUpdated = domain.LastUpdated,
			UnlockTimeout = domain.UnlockTimeout,
		};

		mongo.Settings = new GameSettings(domain.Game)
		{
			SpinGrand = domain.SpinGrand,
			SpinMajor = domain.SpinMajor,
			SpinMinor = domain.SpinMinor,
			SpinMini = domain.SpinMini,
			Hidden = domain.Hidden,
		};

		return mongo;
	}
}
