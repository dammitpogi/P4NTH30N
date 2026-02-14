using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Infrastructure.Persistence;
using P4NTH30N.HUN7ER.Domain.Entities;
using P4NTH30N.HUN7ER.Domain.ValueObjects;

namespace P4NTH30N.HUN7ER.Infrastructure.Repositories;

/// <summary>
/// Repository for managing jackpot predictions
/// </summary>
public class JackpotRepository
{
	private readonly IMongoUnitOfWork _uow;

	public JackpotRepository(IMongoUnitOfWork uow)
	{
		_uow = uow;
	}

	public List<JackpotPrediction> GetAll()
	{
		var mongoJackpots = _uow.Jackpots.GetAll();
		return mongoJackpots.Select(MapToDomain).ToList();
	}

	public List<JackpotPrediction> GetUpcoming(DateTime beforeDate)
	{
		var mongoJackpots = _uow.Jackpots.GetAll().Where(j => j.EstimatedDate < beforeDate).ToList();
		return mongoJackpots.Select(MapToDomain).ToList();
	}

	public void Upsert(JackpotPrediction prediction)
	{
		var mongo = MapToMongo(prediction);
		_uow.Jackpots.Upsert(mongo);
	}

	private static JackpotPrediction MapToDomain(Jackpot jackpot)
	{
		return new JackpotPrediction
		{
			Id = jackpot._id.ToString(),
			House = jackpot.House,
			Game = jackpot.Game,
			Category = jackpot.Category,
			Current = jackpot.Current,
			Threshold = jackpot.Threshold,
			Priority = jackpot.Priority,
			EstimatedDate = jackpot.EstimatedDate,
			LastUpdated = jackpot.LastUpdated,
		};
	}

	private static Jackpot MapToMongo(JackpotPrediction domain)
	{
		Credential credential = new(domain.Game)
		{
			Username = string.Empty,
			Password = string.Empty,
			House = domain.House,
			Game = domain.Game,
		};

		return new Jackpot(credential, domain.Category, domain.Current, domain.Threshold, domain.Priority, domain.EstimatedDate)
		{
			House = domain.House,
			Game = domain.Game,
			Category = domain.Category,
			Current = domain.Current,
			Threshold = domain.Threshold,
			Priority = domain.Priority,
			EstimatedDate = domain.EstimatedDate,
			LastUpdated = domain.LastUpdated,
		};
	}
}
