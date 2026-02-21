using System.Text.Json;
using Microsoft.Extensions.Configuration;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.C0MMON.Infrastructure.Persistence;
using P4NTH30N.H4ND.Infrastructure;
using P4NTH30N.H4ND.Parallel;
using P4NTH30N.H4ND.Services;

namespace P4NTH30N.H4ND.EntryPoint;

/// <summary>
/// ARCH-055: Unified entry point routing to all P4NTH30N execution modes.
/// Single executable routes to sequential/parallel/h0und/firstspin/generate-signals/health/burn-in modes.
/// </summary>
public static class UnifiedEntryPoint
{
	public static readonly string[] ValidModes = ["H4ND", "SPIN", "H0UND", "FIRSTSPIN", "PARALLEL", "GENERATE-SIGNALS", "GEN", "HEALTH", "BURN-IN", "BURNIN", "MONITOR"];

	/// <summary>
	/// Parses the run mode from CLI arguments.
	/// </summary>
	public static RunMode ParseMode(string[] args)
	{
		string mode = args.Length > 0 ? args[0].ToUpperInvariant() : "H4ND";
		return mode switch
		{
			"H4ND" or "SPIN" => RunMode.Sequential,
			"H0UND" => RunMode.Hound,
			"FIRSTSPIN" => RunMode.FirstSpin,
			"PARALLEL" => RunMode.Parallel,
			"GENERATE-SIGNALS" or "GEN" => RunMode.GenerateSignals,
			"HEALTH" => RunMode.Health,
			"BURN-IN" or "BURNIN" => RunMode.BurnIn,
			"MONITOR" => RunMode.Monitor,
			_ => RunMode.Unknown,
		};
	}

	/// <summary>
	/// ARCH-055-002: Executes signal generation from CLI arguments.
	/// Usage: P4NTH30N.exe generate-signals [count] [--game X] [--house Y] [--priority N]
	/// </summary>
	public static void RunGenerateSignals(IUnitOfWork uow, string[] args)
	{
		// Parse CLI arguments
		int count = 10; // default
		string? filterGame = null;
		string? filterHouse = null;
		int? fixedPriority = null;

		for (int i = 1; i < args.Length; i++)
		{
			string arg = args[i];

			if (arg.Equals("--game", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
			{
				filterGame = args[++i];
			}
			else if (arg.Equals("--house", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
			{
				filterHouse = args[++i];
			}
			else if (arg.Equals("--priority", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
			{
				if (int.TryParse(args[++i], out int p) && p >= 1 && p <= 4)
					fixedPriority = p;
			}
			else if (int.TryParse(arg, out int parsedCount) && parsedCount > 0)
			{
				count = parsedCount;
			}
		}

		Console.WriteLine($"[UnifiedEntryPoint] GENERATE-SIGNALS mode — count={count}" +
			(filterGame != null ? $" game={filterGame}" : "") +
			(filterHouse != null ? $" house={filterHouse}" : "") +
			(fixedPriority.HasValue ? $" priority={fixedPriority}" : " (auto distribution)"));

		SignalGenerator generator = new(uow);
		SignalGenerationResult result = generator.Generate(count, filterGame, filterHouse, fixedPriority);

		Console.WriteLine($"\n{result}");

		if (result.Errors.Count > 0)
		{
			Console.WriteLine("Errors:");
			foreach (string error in result.Errors)
				Console.WriteLine($"  - {error}");
		}
	}

	/// <summary>
	/// ARCH-055-005: Executes system health check and outputs JSON report.
	/// </summary>
	public static void RunHealth(IUnitOfWork uow, CdpConfig cdpConfig, IConfigurationRoot config)
	{
		Console.WriteLine("[UnifiedEntryPoint] HEALTH mode — collecting system status...\n");

		SessionRenewalConfig renewalConfig = new();
		config.GetSection("P4NTH30N:H4ND:SessionRenewal").Bind(renewalConfig);

		SessionRenewalService renewalService = new(uow, renewalConfig);

		SystemHealthReport healthReport = new(uow, cdpConfig, renewalService);
		var report = healthReport.CollectAsync().GetAwaiter().GetResult();

		string json = JsonSerializer.Serialize(report, new JsonSerializerOptions { WriteIndented = true });
		Console.WriteLine(json);
	}

	/// <summary>
	/// ARCH-055-006: Executes burn-in validation mode.
	/// </summary>
	public static void RunBurnIn(IUnitOfWork uow, CdpConfig cdpConfig, IConfigurationRoot config)
	{
		Console.WriteLine("[UnifiedEntryPoint] BURN-IN mode — starting automated validation...\n");

		BurnInConfig burnInConfig = new();
		config.GetSection("P4NTH30N:H4ND:BurnIn").Bind(burnInConfig);

		ParallelConfig parallelConfig = new();
		config.GetSection("P4NTH30N:H4ND:Parallel").Bind(parallelConfig);

		SessionRenewalConfig renewalConfig = new();
		config.GetSection("P4NTH30N:H4ND:SessionRenewal").Bind(renewalConfig);

		SessionRenewalService renewalService = new(uow, renewalConfig);

		GameSelectorConfig selectorConfig = new();
		config.GetSection("P4NTH30N:H4ND:GameSelectors").Bind(selectorConfig);

		// AUTO-056: Chrome CDP lifecycle management — auto-start + graceful shutdown
		CdpLifecycleConfig lifecycleConfig = new();
		config.GetSection("P4NTH30N:H4ND:CdpLifecycle").Bind(lifecycleConfig);
		using var cdpLifecycle = new CdpLifecycleManager(lifecycleConfig);

		using var cts = new CancellationTokenSource();

		Console.CancelKeyPress += (_, e) =>
		{
			e.Cancel = true;
			Console.WriteLine("[BurnIn] Ctrl+C received — initiating graceful shutdown...");
			cts.Cancel();
		};

		// AUTO-056-007: Graceful Chrome shutdown on process exit
		AppDomain.CurrentDomain.ProcessExit += (_, _) =>
		{
			Console.WriteLine("[BurnIn] Process exit — stopping Chrome CDP...");
			cdpLifecycle.Dispose();
		};

		// MON-058: Alert thresholds configuration
		Monitoring.BurnInAlertConfig alertConfig = new();
		config.GetSection("P4NTH30N:H4ND:BurnInAlerts").Bind(alertConfig);

		BurnInController controller = new(uow, cdpConfig, parallelConfig, burnInConfig, renewalService, selectorConfig, cdpLifecycle, alertConfig);

		try
		{
			controller.RunAsync(cts.Token).GetAwaiter().GetResult();
		}
		catch (OperationCanceledException)
		{
			Console.WriteLine("[UnifiedEntryPoint] Burn-in stopped by user");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[UnifiedEntryPoint] Burn-in fatal error: {ex.Message}");
			Console.WriteLine(ex);
		}
	}

	/// <summary>
	/// MON-057-005: CLI monitor that connects to a running burn-in and displays live status.
	/// </summary>
	public static void RunMonitor(IUnitOfWork uow, IConfigurationRoot config)
	{
		Console.WriteLine("[UnifiedEntryPoint] MONITOR mode — attaching to running burn-in...\n");

		BurnInConfig burnInConfig = new();
		config.GetSection("P4NTH30N:H4ND:BurnIn").Bind(burnInConfig);

		var monitor = new Monitoring.BurnInMonitor(uow, burnInConfig);

		Console.WriteLine("[Monitor] Polling burn-in status (Ctrl+C to exit)...\n");

		using var cts = new CancellationTokenSource();
		Console.CancelKeyPress += (_, e) => { e.Cancel = true; cts.Cancel(); };

		while (!cts.Token.IsCancellationRequested)
		{
			try
			{
				monitor.RenderConsole();
				Task.Delay(TimeSpan.FromSeconds(5), cts.Token).GetAwaiter().GetResult();
			}
			catch (OperationCanceledException) { break; }
			catch (Exception ex)
			{
				Console.WriteLine($"[Monitor] Error: {ex.Message}");
				Task.Delay(TimeSpan.FromSeconds(5), cts.Token).GetAwaiter().GetResult();
			}
		}

		Console.WriteLine("\n[Monitor] Detached.");
	}

	/// <summary>
	/// Executes parallel mode with full lifecycle management.
	/// ARCH-055: Now injects SessionRenewalService + GameSelectorConfig for self-healing.
	/// </summary>
	public static void RunParallel(IUnitOfWork uow, CdpConfig cdpConfig, IConfigurationRoot config)
	{
		ParallelConfig parallelConfig = new();
		config.GetSection("P4NTH30N:H4ND:Parallel").Bind(parallelConfig);

		SessionRenewalConfig renewalConfig = new();
		config.GetSection("P4NTH30N:H4ND:SessionRenewal").Bind(renewalConfig);

		SessionRenewalService renewalService = new(uow, renewalConfig);

		GameSelectorConfig selectorConfig = new();
		config.GetSection("P4NTH30N:H4ND:GameSelectors").Bind(selectorConfig);

		// AUTO-056: Chrome CDP lifecycle management — auto-start + graceful shutdown
		CdpLifecycleConfig lifecycleConfig = new();
		config.GetSection("P4NTH30N:H4ND:CdpLifecycle").Bind(lifecycleConfig);
		using var cdpLifecycle = new CdpLifecycleManager(lifecycleConfig);

		Console.WriteLine($"[UnifiedEntryPoint] PARALLEL mode — {parallelConfig.WorkerCount} workers, capacity {parallelConfig.ChannelCapacity}");
		Console.WriteLine($"[UnifiedEntryPoint] Self-healing: SessionRenewalService + GameSelectorConfig + CdpLifecycle injected");

		if (parallelConfig.ShadowMode)
		{
			Console.WriteLine("[UnifiedEntryPoint] SHADOW MODE — logging only, no actual spins");
		}

		using var cts = new CancellationTokenSource();

		// Handle Ctrl+C for graceful shutdown
		Console.CancelKeyPress += (_, e) =>
		{
			e.Cancel = true;
			Console.WriteLine("[UnifiedEntryPoint] Ctrl+C received — initiating graceful shutdown...");
			cts.Cancel();
		};

		// AUTO-056-007: Graceful Chrome shutdown on process exit
		AppDomain.CurrentDomain.ProcessExit += (_, _) =>
		{
			Console.WriteLine("[Parallel] Process exit — stopping Chrome CDP...");
			cdpLifecycle.Dispose();
		};

		using var engine = new ParallelH4NDEngine(uow, cdpConfig, parallelConfig, renewalService, selectorConfig, cdpLifecycle);

		try
		{
			engine.RunAsync(cts.Token).GetAwaiter().GetResult();
		}
		catch (OperationCanceledException)
		{
			Console.WriteLine("[UnifiedEntryPoint] Parallel engine stopped gracefully");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[UnifiedEntryPoint] Parallel engine fatal error: {ex.Message}");
			Console.WriteLine(ex);
		}

		Console.WriteLine($"[UnifiedEntryPoint] Final: {engine.Metrics.GetSummary()}");
	}
}

/// <summary>
/// ARCH-055: All supported execution modes.
/// Extended from ARCH-047 with GenerateSignals, Health, and BurnIn.
/// </summary>
public enum RunMode
{
	Sequential,      // "H4ND" or "SPIN" — existing sequential mode
	Hound,           // "H0UND" — existing analytics mode
	FirstSpin,       // "FIRSTSPIN" — existing first spin (DECISION_044)
	Parallel,        // "PARALLEL" — parallel engine (DECISION_047)
	GenerateSignals, // "GENERATE-SIGNALS" or "GEN" — signal population
	Health,          // "HEALTH" — system health check
	BurnIn,          // "BURN-IN" or "BURNIN" — 24-hour validation
	Monitor,         // "MONITOR" — attach to running burn-in (MON-057)
	Unknown,
}
