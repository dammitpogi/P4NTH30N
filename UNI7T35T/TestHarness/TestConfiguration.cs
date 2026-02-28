using System;
using System.Collections.Generic;

namespace P4NTHE0N.UNI7T35T.TestHarness;

/// <summary>
/// TEST-035: Configuration for E2E test execution.
/// Controls which tests run, against which platforms, and with what parameters.
/// </summary>
public sealed class TestConfiguration
{
	/// <summary>
	/// MongoDB connection string for test signal injection and result storage.
	/// </summary>
	public string MongoConnectionString { get; set; } = "mongodb://192.168.56.1:27017";

	/// <summary>
	/// MongoDB database name.
	/// </summary>
	public string MongoDatabaseName { get; set; } = "P4NTHE0N";

	/// <summary>
	/// CDP host for Chrome browser automation.
	/// </summary>
	public string CdpHost { get; set; } = "192.168.56.1";

	/// <summary>
	/// CDP port.
	/// </summary>
	public int CdpPort { get; set; } = 9222;

	/// <summary>
	/// Test accounts to use, keyed by game platform.
	/// </summary>
	public Dictionary<string, TestAccount> TestAccounts { get; set; } = new();

	/// <summary>
	/// Games to include in testing.
	/// </summary>
	public List<string> TargetGames { get; set; } = new() { "FireKirin", "OrionStars" };

	/// <summary>
	/// Maximum time for a single test in seconds.
	/// </summary>
	public int TestTimeoutSeconds { get; set; } = 120;

	/// <summary>
	/// Number of spin executions per test run.
	/// </summary>
	public int SpinsPerTest { get; set; } = 1;

	/// <summary>
	/// Whether to capture frames for vision training data.
	/// </summary>
	public bool CaptureFrames { get; set; } = true;

	/// <summary>
	/// Number of frames to capture per test.
	/// </summary>
	public int FramesPerTest { get; set; } = 10;

	/// <summary>
	/// Directory for captured frame storage.
	/// </summary>
	public string FrameOutputDirectory { get; set; } = @"C:\P4NTHE0N\training-data\frames";

	/// <summary>
	/// Whether to store test results in MongoDB.
	/// </summary>
	public bool PersistResults { get; set; } = true;

	/// <summary>
	/// Whether to clean up test signals after execution.
	/// </summary>
	public bool CleanupTestSignals { get; set; } = true;

	/// <summary>
	/// Signal priority to use for test signals (4=Grand, 3=Major, 2=Minor, 1=Mini).
	/// </summary>
	public int TestSignalPriority { get; set; } = 1;

	/// <summary>
	/// Creates a default test configuration for local development.
	/// </summary>
	public static TestConfiguration Default => new()
	{
		TestAccounts = new Dictionary<string, TestAccount>
		{
			["FireKirin"] = new TestAccount { Username = "test_fk", Password = "test123", House = "TestHouse", Game = "FireKirin" },
			["OrionStars"] = new TestAccount { Username = "test_os", Password = "test123", House = "TestHouse", Game = "OrionStars" },
		},
	};
}

/// <summary>
/// A test account with credentials for a specific game platform.
/// </summary>
public sealed class TestAccount
{
	public string Username { get; set; } = string.Empty;
	public string Password { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
}
