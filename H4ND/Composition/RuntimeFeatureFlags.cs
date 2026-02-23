namespace P4NTH30N.H4ND.Composition;

public sealed class RuntimeFeatureFlags
{
	public bool UseLegacyRuntimePath { get; set; } = true;
	public bool UseLegacySequentialPath { get; set; } = true;
	public bool EnableRefactoredDispatch { get; set; }
}
