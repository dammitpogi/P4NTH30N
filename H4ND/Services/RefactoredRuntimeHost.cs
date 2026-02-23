using P4NTH30N.H4ND.Composition;

namespace P4NTH30N.H4ND.Services;

public sealed class RefactoredRuntimeHost : IRuntimeHost
{
	private readonly LegacyRuntimeHost _legacyRuntimeHost;
	private readonly RuntimeFeatureFlags _featureFlags;

	public RefactoredRuntimeHost(LegacyRuntimeHost legacyRuntimeHost, RuntimeFeatureFlags featureFlags)
	{
		_legacyRuntimeHost = legacyRuntimeHost ?? throw new ArgumentNullException(nameof(legacyRuntimeHost));
		_featureFlags = featureFlags ?? throw new ArgumentNullException(nameof(featureFlags));
	}

	public Task<int> RunAsync(string[] args, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();

		// Phase 5/6 bridge: refactored host exists, but sequential orchestration
		// remains behind legacy flag until parity suite confirms stability.
		if (_featureFlags.UseLegacySequentialPath)
		{
			return _legacyRuntimeHost.RunAsync(args, ct);
		}

		return _legacyRuntimeHost.RunAsync(args, ct);
	}
}
