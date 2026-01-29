using System.Reflection;

namespace P4NTH30N.C0MMON.Versioning;

public static class AppVersion {
	public static string GetInformationalVersion(Assembly? assembly = null) {
		assembly ??= Assembly.GetEntryAssembly() ?? Assembly.GetExecutingAssembly();
		string? informationalVersion = assembly
			.GetCustomAttribute<AssemblyInformationalVersionAttribute>()
			?.InformationalVersion;
		return string.IsNullOrWhiteSpace(informationalVersion)
			? assembly.GetName().Version?.ToString() ?? "unknown"
			: informationalVersion;
	}

	public static string GetDisplayVersion(Assembly? assembly = null) {
		string informationalVersion = GetInformationalVersion(assembly);
		int metadataIndex = informationalVersion.IndexOf('+');
		return metadataIndex >= 0
			? informationalVersion[..metadataIndex]
			: informationalVersion;
	}
}
