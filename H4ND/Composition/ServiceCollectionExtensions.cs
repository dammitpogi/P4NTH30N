using Microsoft.Extensions.Configuration;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;
using P4NTHE0N.H4ND.Infrastructure.Persistence;

namespace P4NTHE0N.H4ND.Composition;

/// <summary>
/// DECISION_113: Runtime composition helpers for shared singleton services.
/// </summary>
public static class ServiceCollectionExtensions
{
	private static readonly object Sync = new();
	private static IErrorEvidence _currentErrorEvidence = NoopErrorEvidence.Instance;
	private static bool _initialized;

	public static IErrorEvidence CurrentErrorEvidence => _currentErrorEvidence;

	public static void InitializeErrorEvidence(IConfigurationRoot configuration)
	{
		ArgumentNullException.ThrowIfNull(configuration);

		if (_initialized)
		{
			return;
		}

		lock (Sync)
		{
			if (_initialized)
			{
				return;
			}

			ErrorEvidenceOptions options = ErrorEvidenceOptions.FromConfiguration(
				configuration.GetSection("P4NTHE0N:H4ND:ErrorEvidence"));

			if (!options.Enabled)
			{
				_currentErrorEvidence = NoopErrorEvidence.Instance;
				_initialized = true;
				return;
			}

			try
			{
				MongoDatabaseProvider provider = MongoDatabaseProvider.FromEnvironment();
				MongoDbContext dbContext = new(provider.Database);
				dbContext.EnsureDebugEvidenceIndexes(options.Collection);

				IErrorEvidenceRepository repository = new MongoDebugEvidenceRepository(provider, options);
				IErrorEvidenceFactory factory = new ErrorEvidenceFactory(options);
				_currentErrorEvidence = new ErrorEvidenceService(repository, factory, options, msg => Console.WriteLine(msg));
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[ErrorEvidence] Initialization failed — continuing without evidence sink: {ex.Message}");
				_currentErrorEvidence = NoopErrorEvidence.Instance;
			}

			_initialized = true;
		}
	}
}
