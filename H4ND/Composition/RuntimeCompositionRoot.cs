using Microsoft.Extensions.Configuration;
using P4NTHE0N.H4ND.Services;

namespace P4NTHE0N.H4ND.Composition;

public sealed class RuntimeCompositionRoot
{
	private readonly IConfigurationRoot _configuration;

	public RuntimeCompositionRoot(IConfigurationRoot configuration)
	{
		_configuration = configuration ?? throw new ArgumentNullException(nameof(configuration));
		ServiceCollectionExtensions.InitializeErrorEvidence(_configuration);
		FeatureFlags = new RuntimeFeatureFlags();
		_configuration.GetSection("P4NTHE0N:H4ND:FeatureFlags").Bind(FeatureFlags);
	}

	public RuntimeFeatureFlags FeatureFlags { get; }

	public IRuntimeHost BuildRuntimeHost()
	{
		var legacy = new LegacyRuntimeHost();
		if (FeatureFlags.UseLegacyRuntimePath)
		{
			return legacy;
		}

		return new RefactoredRuntimeHost(legacy, FeatureFlags);
	}
}
