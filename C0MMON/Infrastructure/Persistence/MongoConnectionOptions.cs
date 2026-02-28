using System;

namespace P4NTHE0N.C0MMON.Infrastructure.Persistence;

public sealed class MongoConnectionOptions
{
	public string ConnectionString { get; init; } = "mongodb://localhost:27017/";
	public string DatabaseName { get; init; } = "P4NTHE0N";

	public static MongoConnectionOptions FromEnvironment()
	{
		string? uri = Environment.GetEnvironmentVariable("P4NTHE0N_MONGODB_URI");
		string? db = Environment.GetEnvironmentVariable("P4NTHE0N_MONGODB_DB");

		// VM deployment: check config file overrides in multiple locations
		if (string.IsNullOrWhiteSpace(uri))
		{
			string[] searchPaths =
			[
				System.IO.Path.Combine(AppContext.BaseDirectory, "mongodb.uri"),
				System.IO.Path.Combine(Environment.CurrentDirectory, "mongodb.uri"),
				System.IO.Path.Combine(System.IO.Path.GetDirectoryName(Environment.ProcessPath) ?? "", "mongodb.uri"),
			];

			foreach (string candidate in searchPaths)
			{
				if (System.IO.File.Exists(candidate))
				{
					uri = System.IO.File.ReadAllText(candidate).Trim();
					Console.WriteLine($"[MongoConnectionOptions] Loaded URI from: {candidate}");
					break;
				}
			}
		}

		MongoConnectionOptions options = new()
		{
			ConnectionString = string.IsNullOrWhiteSpace(uri) ? "mongodb://localhost:27017/" : uri,
			DatabaseName = string.IsNullOrWhiteSpace(db) ? "P4NTHE0N" : db,
		};

		Console.WriteLine($"[MongoConnectionOptions] Using: {options.ConnectionString} / {options.DatabaseName}");
		return options;
	}
}
