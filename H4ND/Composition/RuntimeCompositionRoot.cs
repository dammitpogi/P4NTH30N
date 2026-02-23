using Microsoft.Extensions.Configuration;
using P4NTH30N.H4ND.Services;

namespace P4NTH30N.H4ND.Composition;

public sealed class RuntimeCompositionRoot
{
	private readonly IConfigurationRoot _configuration;

	public RuntimeCompositionRoot(IConfigurationRoot configuration)
	{
		_configuration = configuration ?? throw new ArgumentNullException(nameof(configuration));
		FeatureFlags = new RuntimeFeatureFlags();
		_configuration.GetSection("P4NTH30N:H4ND:FeatureFlags").Bind(FeatureFlags);
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
