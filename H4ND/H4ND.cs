using Microsoft.Extensions.Configuration;
using P4NTHE0N.H4ND.Composition;

namespace P4NTHE0N;

internal static class Program
{
	private static async Task<int> Main(string[] args)
	{
		var configuration = BuildConfiguration();
		var compositionRoot = new RuntimeCompositionRoot(configuration);
		var runtimeHost = compositionRoot.BuildRuntimeHost();

		try
		{
			return await runtimeHost.RunAsync(args);
		}
		catch (Exception ex)
		{
			Console.Error.WriteLine($"[H4ND] Fatal startup error: {ex.Message}");
			Console.Error.WriteLine(ex);
			return 1;
		}
	}

	private static IConfigurationRoot BuildConfiguration()
	{
		return new ConfigurationBuilder()
			.SetBasePath(AppContext.BaseDirectory)
			.AddJsonFile("appsettings.json", optional: true, reloadOnChange: false)
			.Build();
	}
}
