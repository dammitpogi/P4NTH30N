using MongoDB.Driver;

namespace P4NTH30N.C0MMON.Persistence.Analytics;

/// <summary>
/// MongoDB collection names for analytics storage.
/// </summary>
public static class AnalyticsCollectionNames
{
	/// <summary>
	/// General analytics collection (events and health reports).
	/// </summary>
	public const string Events = "LEDGER_Analytics";

	/// <summary>
	/// DPD analysis ledger.
	/// </summary>
	public const string DPDRecords = "LEDGER_DPD";

	/// <summary>
	/// Jackpot forecasts ledger.
	/// </summary>
	public const string Forecasts = "LEDGER_Forecasts";

	/// <summary>
	/// Health reports collection (stored alongside analytics events).
	/// </summary>
	public const string HealthReports = "LEDGER_Analytics";
}

/// <summary>
/// Repository for writing and reading analytics data stored in MongoDB.
/// </summary>
public interface IAnalyticsRepository
{
	/// <summary>
	/// Inserts a DPD analysis record.
	/// </summary>
	Task LogDPDAsync(DPDRecord record);

	/// <summary>
	/// Inserts a jackpot forecast record.
	/// </summary>
	Task LogForecastAsync(JackpotForecastRecord record);

	/// <summary>
	/// Inserts a credential health report record.
	/// </summary>
	Task LogHealthReportAsync(HealthReportRecord record);

	/// <summary>
	/// Gets DPD history for a specific house/game since the provided timestamp (UTC).
	/// </summary>
	Task<List<DPDRecord>> GetDPDHistoryAsync(string house, string game, DateTime since);

	/// <summary>
	/// Gets recent forecasts for a specific house/game.
	/// </summary>
	Task<List<JackpotForecastRecord>> GetForecastsAsync(string house, string game, int limit);

	/// <summary>
	/// Inserts a general analytics event.
	/// </summary>
	Task LogEventAsync(AnalyticsEvent evt);

	/// <summary>
	/// Gets recent analytics events for a given event type.
	/// </summary>
	Task<List<AnalyticsEvent>> GetEventsAsync(string eventType, int limit);
}

/// <summary>
/// MongoDB-backed analytics repository.
/// </summary>
public class AnalyticsRepository(IMongoDatabase database) : IAnalyticsRepository
{
	private readonly IMongoCollection<AnalyticsEvent> _events = database.GetCollection<AnalyticsEvent>(AnalyticsCollectionNames.Events);
	private readonly IMongoCollection<DPDRecord> _dpd = database.GetCollection<DPDRecord>(AnalyticsCollectionNames.DPDRecords);
	private readonly IMongoCollection<JackpotForecastRecord> _forecasts = database.GetCollection<JackpotForecastRecord>(AnalyticsCollectionNames.Forecasts);
	private readonly IMongoCollection<HealthReportRecord> _health = database.GetCollection<HealthReportRecord>(AnalyticsCollectionNames.HealthReports);

	/// <inheritdoc />
	public Task LogDPDAsync(DPDRecord record)
	{
		ArgumentNullException.ThrowIfNull(record);
		return _dpd.InsertOneAsync(record);
	}

	/// <inheritdoc />
	public Task LogForecastAsync(JackpotForecastRecord record)
	{
		ArgumentNullException.ThrowIfNull(record);
		return _forecasts.InsertOneAsync(record);
	}

	/// <inheritdoc />
	public Task LogHealthReportAsync(HealthReportRecord record)
	{
		ArgumentNullException.ThrowIfNull(record);
		return _health.InsertOneAsync(record);
	}

	/// <inheritdoc />
	public Task<List<DPDRecord>> GetDPDHistoryAsync(string house, string game, DateTime since)
	{
		FilterDefinition<DPDRecord> filter =
			Builders<DPDRecord>.Filter.Eq(x => x.House, house)
			& Builders<DPDRecord>.Filter.Eq(x => x.Game, game)
			& Builders<DPDRecord>.Filter.Gte(x => x.Timestamp, since);

		return _dpd.Find(filter).SortByDescending(x => x.Timestamp).ToListAsync();
	}

	/// <inheritdoc />
	public Task<List<JackpotForecastRecord>> GetForecastsAsync(string house, string game, int limit)
	{
		if (limit <= 0)
			return Task.FromResult(new List<JackpotForecastRecord>());

		FilterDefinition<JackpotForecastRecord> filter =
			Builders<JackpotForecastRecord>.Filter.Eq(x => x.House, house) & Builders<JackpotForecastRecord>.Filter.Eq(x => x.Game, game);

		return _forecasts.Find(filter).SortByDescending(x => x.Timestamp).Limit(limit).ToListAsync();
	}

	/// <inheritdoc />
	public Task LogEventAsync(AnalyticsEvent evt)
	{
		ArgumentNullException.ThrowIfNull(evt);
		return _events.InsertOneAsync(evt);
	}

	/// <inheritdoc />
	public Task<List<AnalyticsEvent>> GetEventsAsync(string eventType, int limit)
	{
		if (limit <= 0)
			return Task.FromResult(new List<AnalyticsEvent>());

		FilterDefinition<AnalyticsEvent> filter = Builders<AnalyticsEvent>.Filter.Eq(x => x.EventType, eventType);

		return _events.Find(filter).SortByDescending(x => x.Timestamp).Limit(limit).ToListAsync();
	}
}
