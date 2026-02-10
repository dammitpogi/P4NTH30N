using System;

namespace P4NTH30N.C0MMON.Persistence;

public sealed class MongoConnectionOptions {
	public string ConnectionString { get; init; } = "mongodb://localhost:27017/";
	public string DatabaseName { get; init; } = "P4NTH30N";

	public static MongoConnectionOptions FromEnvironment() {
		string? uri = Environment.GetEnvironmentVariable("P4NTH30N_MONGODB_URI");
		string? db = Environment.GetEnvironmentVariable("P4NTH30N_MONGODB_DB");

		return new MongoConnectionOptions {
			ConnectionString = string.IsNullOrWhiteSpace(uri) ? "mongodb://localhost:27017/" : uri,
			DatabaseName = string.IsNullOrWhiteSpace(db) ? "P4NTH30N" : db,
		};
	}
}
