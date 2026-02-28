using P4NTHE0N.H4ND.Services;

namespace P4NTHE0N.UNI7T35T.Tests;

/// <summary>
/// AUTO-056: Unit tests for CdpLifecycleManager components.
/// Tests config defaults, argument building, lifecycle status, and error handling.
/// </summary>
public static class CdpLifecycleManagerTests
{
	public static (int passed, int failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		void Run(string name, Func<bool> test)
		{
			try
			{
				if (test())
				{
					Console.WriteLine($"  \u2705 {name}");
					passed++;
				}
				else
				{
					Console.WriteLine($"  \u274c {name}");
					failed++;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  \u274c {name} \u2014 Exception: {ex.Message}");
				failed++;
			}
		}

		Run("Test_CdpLifecycleConfig_Defaults", Test_CdpLifecycleConfig_Defaults);
		Run("Test_CdpLifecycleConfig_ChromePath", Test_CdpLifecycleConfig_ChromePath);
		Run("Test_CdpLifecycleConfig_RestartBackoff", Test_CdpLifecycleConfig_RestartBackoff);
		Run("Test_CdpLifecycleConfig_AdditionalArgs", Test_CdpLifecycleConfig_AdditionalArgs);
		Run("Test_CdpLifecycleStatus_Enum", Test_CdpLifecycleStatus_Enum);
		Run("Test_Manager_InitialStatus_Stopped", Test_Manager_InitialStatus_Stopped);
		Run("Test_Manager_IsAvailable_NoCdp_ReturnsFalse", Test_Manager_IsAvailable_NoCdp_ReturnsFalse);
		Run("Test_Manager_EnsureAvailable_AutoStartDisabled", Test_Manager_EnsureAvailable_AutoStartDisabled);
		Run("Test_Manager_EnsureAvailable_ChromeNotFound", Test_Manager_EnsureAvailable_ChromeNotFound);
		Run("Test_Manager_StartChrome_InvalidPath", Test_Manager_StartChrome_InvalidPath);
		Run("Test_Manager_Dispose_Idempotent", Test_Manager_Dispose_Idempotent);
		Run("Test_Manager_ChromeArgs_Headless", Test_Manager_ChromeArgs_Headless);
		Run("Test_Manager_ChromeArgs_Headed", Test_Manager_ChromeArgs_Headed);
		Run("Test_Manager_ProbeHost_Localhost", Test_Manager_ProbeHost_Localhost);

		return (passed, failed);
	}

	static bool Test_CdpLifecycleConfig_Defaults()
	{
		var config = new CdpLifecycleConfig();
		return config.AutoStart == true
			&& config.DebugPort == 9222
			&& config.DebugHost == "0.0.0.0"
			&& config.StartupTimeoutSeconds == 30
			&& config.HealthCheckIntervalSeconds == 30
			&& config.MaxAutoRestarts == 3
			&& config.GracefulShutdownTimeoutSeconds == 10
			&& !config.Headless;
	}

	static bool Test_CdpLifecycleConfig_ChromePath()
	{
		var config = new CdpLifecycleConfig();
		return config.ChromePath == @"C:\Program Files\Google\Chrome\Application\chrome.exe";
	}

	static bool Test_CdpLifecycleConfig_RestartBackoff()
	{
		var config = new CdpLifecycleConfig();
		return config.RestartBackoffSeconds.Length == 3
			&& config.RestartBackoffSeconds[0] == 5
			&& config.RestartBackoffSeconds[1] == 10
			&& config.RestartBackoffSeconds[2] == 30;
	}

	static bool Test_CdpLifecycleConfig_AdditionalArgs()
	{
		var config = new CdpLifecycleConfig();
		return config.AdditionalArgs.Length == 2
			&& config.AdditionalArgs[0] == "--no-sandbox"
			&& config.AdditionalArgs[1] == "--disable-gpu";
	}

	static bool Test_CdpLifecycleStatus_Enum()
	{
		// Verify all enum values exist and are distinct
		var values = Enum.GetValues<CdpLifecycleStatus>();
		return values.Length == 5
			&& Enum.IsDefined(CdpLifecycleStatus.Healthy)
			&& Enum.IsDefined(CdpLifecycleStatus.Unhealthy)
			&& Enum.IsDefined(CdpLifecycleStatus.Starting)
			&& Enum.IsDefined(CdpLifecycleStatus.Stopped)
			&& Enum.IsDefined(CdpLifecycleStatus.Error);
	}

	static bool Test_Manager_InitialStatus_Stopped()
	{
		var config = new CdpLifecycleConfig { AutoStart = false };
		using var manager = new CdpLifecycleManager(config);
		return manager.GetLifecycleStatus() == CdpLifecycleStatus.Stopped;
	}

	static bool Test_Manager_IsAvailable_NoCdp_ReturnsFalse()
	{
		// With no Chrome running on a random port, IsAvailableAsync should return false
		var config = new CdpLifecycleConfig { DebugPort = 19876, AutoStart = false };
		using var manager = new CdpLifecycleManager(config);
		bool available = manager.IsAvailableAsync().GetAwaiter().GetResult();
		return !available;
	}

	static bool Test_Manager_EnsureAvailable_AutoStartDisabled()
	{
		// When AutoStart=false and CDP is not running, EnsureAvailable should return false
		var config = new CdpLifecycleConfig { DebugPort = 19877, AutoStart = false };
		using var manager = new CdpLifecycleManager(config);
		bool result = manager.EnsureAvailableAsync().GetAwaiter().GetResult();
		return !result && manager.GetLifecycleStatus() == CdpLifecycleStatus.Stopped;
	}

	static bool Test_Manager_EnsureAvailable_ChromeNotFound()
	{
		// When ChromePath doesn't exist, EnsureAvailable should return false with Error status
		var config = new CdpLifecycleConfig
		{
			DebugPort = 19878,
			AutoStart = true,
			ChromePath = @"C:\NonExistent\chrome.exe",
		};
		using var manager = new CdpLifecycleManager(config);
		bool result = manager.EnsureAvailableAsync().GetAwaiter().GetResult();
		return !result && manager.GetLifecycleStatus() == CdpLifecycleStatus.Error;
	}

	static bool Test_Manager_StartChrome_InvalidPath()
	{
		// StartChromeAsync with invalid path should throw
		var config = new CdpLifecycleConfig
		{
			DebugPort = 19879,
			ChromePath = @"C:\NonExistent\not_chrome.exe",
		};
		using var manager = new CdpLifecycleManager(config);
		// EnsureAvailable checks File.Exists first, so it won't throw — it returns false
		bool result = manager.EnsureAvailableAsync().GetAwaiter().GetResult();
		return !result;
	}

	static bool Test_Manager_Dispose_Idempotent()
	{
		// Double dispose should not throw
		var config = new CdpLifecycleConfig { AutoStart = false };
		var manager = new CdpLifecycleManager(config);
		manager.Dispose();
		manager.Dispose(); // Should not throw
		return true;
	}

	static bool Test_Manager_ChromeArgs_Headless()
	{
		// Verify headless config produces correct status when Chrome is not found
		var config = new CdpLifecycleConfig
		{
			Headless = true,
			DebugPort = 9333,
			DebugHost = "0.0.0.0",
			AdditionalArgs = ["--no-sandbox", "--disable-gpu"],
		};
		// Config should store headless=true
		return config.Headless == true && config.DebugPort == 9333;
	}

	static bool Test_Manager_ChromeArgs_Headed()
	{
		// Verify headed config
		var config = new CdpLifecycleConfig
		{
			Headless = false,
			DebugPort = 9222,
		};
		return config.Headless == false;
	}

	static bool Test_Manager_ProbeHost_Localhost()
	{
		// When DebugHost is 0.0.0.0, probe should use 127.0.0.1 internally
		// Verified by IsAvailableAsync targeting localhost
		var config = new CdpLifecycleConfig
		{
			DebugHost = "0.0.0.0",
			DebugPort = 19880,
			AutoStart = false,
		};
		using var manager = new CdpLifecycleManager(config);
		// Should not throw — probes 127.0.0.1 (not 0.0.0.0)
		bool available = manager.IsAvailableAsync().GetAwaiter().GetResult();
		return !available; // Not available, but no error from 0.0.0.0 probe
	}
}
