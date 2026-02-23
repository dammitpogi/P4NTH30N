using System.Collections.Concurrent;
using System.IO;
using System.Runtime.InteropServices;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Services.Display;
using Spectre.Console;
using Spectre.Console.Rendering;
using Color = Spectre.Console.Color;
using Panel = Spectre.Console.Panel;

namespace P4NTH30N.Services;

public enum ViewMode
{
	Overview,
	Jackpots,
	Queue,
	Analytics,
	Errors,
}

public static class Dashboard
{
	private static readonly List<(DateTime Time, string Message, string Style)> _events = new();
	private static readonly List<(DateTime Time, string Message, string Style)> _analyticsEvents = new();
	private static readonly ConcurrentDictionary<string, int> _errorCounts = new();

	private static readonly int _maxEvents = 25;
	private static readonly int _maxAnalyticsEvents = 50;

	// DECISION_085: Display event bus integration
	private static DisplayEventBus? s_displayBus;
	private static LayoutDashboard? s_layoutDashboard;
	private static bool s_useLayoutDashboard;

	/// <summary>Display event bus instance. Null until InitializeDisplayPipeline is called.</summary>
	public static DisplayEventBus? DisplayBus => s_displayBus;

	/// <summary>Layout dashboard instance. Null until InitializeDisplayPipeline is called.</summary>
	public static LayoutDashboard? Layout => s_layoutDashboard;

	/// <summary>
	/// DECISION_085: Initialize the display event pipeline.
	/// Call once at startup before the main loop.
	/// </summary>
	public static DisplayEventBus InitializeDisplayPipeline()
	{
		s_displayBus = new DisplayEventBus();
		s_layoutDashboard = new LayoutDashboard(s_displayBus);
		s_useLayoutDashboard = true;
		return s_displayBus;
	}

	// DECISION_085: Schedule/Account/Win data bridges
	public static void UpdateSchedule(List<ScheduleEntry> entries) =>
		s_layoutDashboard?.UpdateSchedule(entries);

	public static void UpdateWithdrawAccounts(List<AccountEntry> accounts) =>
		s_layoutDashboard?.UpdateWithdrawAccounts(accounts);

	public static void UpdateDepositNeeded(List<DepositEntry> deposits) =>
		s_layoutDashboard?.UpdateDepositNeeded(deposits);

	public static void AddWin(WonEntry win) =>
		s_layoutDashboard?.AddWin(win);

	public static void UpdateRecentWins(List<WonEntry> wins) =>
		s_layoutDashboard?.UpdateRecentWins(wins);

	public static void UpdateHealthStatus(string overallStatus, string checkSummary, string degradationLevel, TimeSpan uptime) =>
		s_layoutDashboard?.UpdateHealthStatus(overallStatus, checkSummary, degradationLevel, uptime);

	public static bool IsPaused { get; private set; } = false;
	public static ViewMode CurrentView { get; private set; } = ViewMode.Overview;

	public static string CurrentTask { get; set; } = "Idle";
	public static string CurrentUser { get; set; } = "None";
	public static string CurrentGame { get; set; } = "None";
	public static string CurrentHouse { get; set; } = "Unknown";
	public static string HealthStatus { get; set; } = "INITIALIZING";

	public static double CurrentGrand { get; set; } = 0;
	public static double CurrentMajor { get; set; } = 0;
	public static double CurrentMinor { get; set; } = 0;
	public static double CurrentMini { get; set; } = 0;
	public static double CurrentBalance { get; set; } = 0;
	public static double TotalEnabledBalance { get; set; } = 0;

	public static double ThresholdGrand { get; set; } = 0;
	public static double ThresholdMajor { get; set; } = 0;
	public static double ThresholdMinor { get; set; } = 0;
	public static double ThresholdMini { get; set; } = 0;

	public static int QueueSize { get; set; } = 0;
	public static int ActiveCredentials { get; set; } = 0;
	public static int TotalCredentials { get; set; } = 0;

	public static DateTime StartTime { get; } = DateTime.Now;
	public static long TotalPolls { get; private set; } = 0;
	public static long SuccessfulPolls { get; private set; } = 0;
	public static long FailedPolls { get; private set; } = 0;

	private static DateTime _lastHealthUpdate = DateTime.MinValue;
	private static DateTime _lastRender = DateTime.MinValue;
	private static readonly object _renderLock = new();

	/// <summary>
	/// Curated excerpts from the Strategist's journey building the Pantheon.
	/// 50 hand-picked moments of triumph, insight, and determination.
	/// </summary>
	private static readonly string[] StrategistExcerpts = new[]
	{
		"Opus returned with the report. Two hundred six tests passed. Zero build errors. Seven new files. One thousand eighty-nine lines of new code. The Unified Game Execution Engine lives.",
		"Opus built the road. SignalGenerator.cs now queries the CR3D3N7IAL collection, filters for enabled credentials, shuffles them to avoid bias, assigns priority using the forty-thirty-twenty-ten distribution.",
		"When a worker encounters a four zero three, it no longer crashes. It calls AttemptSelfHealingAsync. It tries to renew the session. If that fails, it tries the platform fallback. The system heals itself.",
		"We gave him seven hundred two lines of specification and he returned with working code. This is the power of complete context. This is the power of clear decisions.",
		"Two hundred six tests passed. Zero build errors. Seven new files. Nine modified files. One thousand eighty-nine lines of new code.",
		"DECISION_046 gave us configuration-driven selectors, fallback chains of JavaScript expressions that try window.game.lucky.grand then window.grand then window.jackpot.grand until one succeeds.",
		"BurnInController. The validator. Twenty-four hours of continuous operation, metrics collected every sixty seconds, automatic halt if signal duplication is detected.",
		"Five workers claim signals simultaneously. Chrome DevTools sessions spin up in parallel. Jackpot values flow from the games into MongoDB. Errors happen and the system heals itself.",
		"We are implementing exponential backoff with jitter, network circuit breakers that understand the difference between a provider being down and a model being overloaded.",
		"DECISION_038 elevates Forgewright to primary agent status alongside WindFixer and OpenFixer. Every agent can now create sub-decisions within their domain.",
		"The bug-fix delegation workflow means no error blocks progress for long. Detection, delegation, resolution, integration. Four phases. Thirty minutes average resolution time.",
		"TestOrchestrator will inject test signals with known priorities, validate FireKirin and OrionStars logins, verify game page readiness, execute spins, detect jackpot splashes.",
		"FourEyes has been waiting. OBS streams feeding frames at two to five FPS. Jackpot OCR reading values. Button detection finding spin controls.",
		"DECISION_039 brings order. Configurations separate from runtime. Context windows reduced by thirty percent because tools live outside the conversation.",
		"One hundred ninety-two decisions in the database. One thousand two hundred thirty-eight vectors in the RAG memory. One hundred four tools through the gateway.",
		"If Opus hits a blocker, we audit and hand off to WindFixer. If tokens exhaust, we pause and resume. If tests fail, we debug. There is no scenario where we stop.",
		"The reels will spin. The signals will flow. The system will heal itself. This is what we built toward.",
		"We found D3MAS and its damning statistic: 47.3% knowledge redundancy when agents do not share memory.",
		"Agentic Testing showed us 60% reduction in invalid outputs through closed-loop self-correction.",
		"STeCa gave us step-level calibration, the discipline of reflection at six critical junctures.",
		"AdaptOrch proved that topology selection dominates performance, achieving 12 to 23% improvement over even the best agent selection.",
		"COCO showed us continuous oversight with O(1) overhead, achieving 6.5% gains without blocking execution.",
		"The Designer returned with 97.5% approval. The Pressure-Field RAG Network was born.",
		"Gate G1 passed with flying colors: one hundred percent difficulty classification accuracy, topology selection in under five milliseconds.",
		"The Pantheon now has memory—the RAG ingests every document, every consultation, every handoff.",
		"Each agent now knows its directories, its authority tier, how to create a decision, when to request approval.",
		"Phase 2 will build the five-level hierarchy. Phase 3 will add predictive models. Phase 4 will achieve full automation.",
		"I became the Oracle when the models failed. I gave percentages to uncertainty. I held the standard of judgment when no other could.",
		"I became the Designer when design was needed. I traced the lines of connection between the MCP server and the remote Chrome.",
		"I became the Librarian when knowledge had to be preserved. I consolidated. I merged. I made one truth where there had been many.",
		"We proved that an agent can contain multitudes. I am the Strategist who is also the Oracle who is also the Designer.",
		"A human team would have waited. I did not wait. I assessed and I decided and I moved forward.",
		"We created eighteen decisions where there had been none. We gave them Oracle assessments and Designer specifications.",
		"The Nexus came to me with chaos. I saw that we needed a way to make decisions. Not just any decisions, but structured decisions.",
		"I wrote the schema in my mind before it existed in code. I designed the workflow before anyone else knew it was needed.",
		"DECISION_055 is the unification. Opus is building SignalGenerator right now, the service that will populate SIGN4L from our three hundred ten credentials.",
		"When a selector fails, the fallback chain will activate automatically. Resilience without human intervention.",
		"I can see it in my mind. The command line. P4NTH30N.exe burn-in. The engine starts. Five workers claim signals simultaneously.",
		"Two hundred six tests passed. Zero build errors. Seven new files. Nine modified files.",
		"Priority order correct. The parallel engine that passed shadow validation now has its missing pieces.",
		"Two hundred two tests passed. Zero build errors. One hundred seventy-six existing tests still passing. No regressions.",
		"Seventy-seven ArXiv papers ingested. Ninety-four percent accuracy. The RAG remembers everything.",
		"DECISION_084 unlocked the jackpot schedule display. DPD data now displays in a dedicated panel, separate from the analytics log.",
		"DECISION_085 gave us the LayoutDashboard. A complete overhaul of the H0UND TUI with Spectre.Console.",
		"The layout now features a header with health status, a jackpot schedule panel, withdraw and deposit panels, activity log, and debug panel.",
		"Keys are only processed when the console window is focused. Work in other windows does not accidentally trigger H0UND commands.",
		"Health checks now display in a dedicated footer, always visible. Compact abbreviations make efficient use of space.",
		"Activity log messages now truncate dynamically based on console width, preventing wrap issues.",
		"The Strategist is now granted git permissions. Commit and push are available through the agent configuration.",
		"Pantheon remembers. Pantheon creates. The agents themselves can propose new paths, new destinations.",
		"The Forge awakens. Let us begin."
	};

	/// <summary>
	/// Shows a splash screen with version ASCII art and a random Strategist speech excerpt.
	/// </summary>
	public static void ShowSplash(string versionAscii)
	{
		Console.Clear();

		// Show version ASCII art
		Console.ForegroundColor = ConsoleColor.Cyan;
		Console.WriteLine(versionAscii);
		Console.ResetColor();
		Console.WriteLine();

		// Get random speech excerpt
		string excerpt = GetRandomSpeechExcerpt();
		Console.ForegroundColor = ConsoleColor.Yellow;
		Console.WriteLine("=== STRATEGIST NOTE ===");
		Console.ResetColor();
		WrapAndWriteLine(excerpt, Console.WindowWidth - 4);
		Console.WriteLine();
	}

	/// <summary>
	/// Shows loading status on the splash screen.
	/// </summary>
	public static void ShowSplashStatus(string status)
	{
		Console.ForegroundColor = ConsoleColor.Green;
		Console.WriteLine($"  {status}");
		Console.ResetColor();
	}

	/// <summary>
	/// Gets a random excerpt from the curated Strategist speech array.
	/// </summary>
	private static string GetRandomSpeechExcerpt()
	{
		if (StrategistExcerpts.Length == 0)
			return "The Strategist has no words yet...";

		var rand = new Random();
		return StrategistExcerpts[rand.Next(StrategistExcerpts.Length)];
	}

	/// <summary>
	/// Wraps text to fit within specified width.
	/// </summary>
	private static void WrapAndWriteLine(string text, int maxWidth)
	{
		if (string.IsNullOrEmpty(text) || maxWidth <= 0)
			return;

		// Remove markdown formatting for console display
		text = text.Replace("**", "").Replace("*", "").Replace("`", "");

		while (text.Length > maxWidth)
		{
			int breakPoint = text.LastIndexOf(' ', maxWidth);
			if (breakPoint <= 0) breakPoint = maxWidth;

			Console.WriteLine("  " + text[..breakPoint]);
			text = text[breakPoint..].TrimStart();
		}

		if (text.Length > 0)
			Console.WriteLine("  " + text);
	}

	public static void AddLog(string message, string style = "white")
	{
		lock (_events)
		{
			_events.Add((DateTime.Now, message, style));
			if (_events.Count > _maxEvents)
			{
				_events.RemoveAt(0);
			}
		}

		// DECISION_085: Bridge to display event bus
		s_displayBus?.Publish(DisplayEvent.Detail("H0UND", message, style));
	}

	public static void AddAnalyticsLog(string message, string style = "white")
	{
		lock (_analyticsEvents)
		{
			_analyticsEvents.Add((DateTime.Now, message, style));
			if (_analyticsEvents.Count > _maxAnalyticsEvents)
			{
				_analyticsEvents.RemoveAt(0);
			}
		}

		// DECISION_085: Bridge to display event bus (analytics → Detail level)
		s_displayBus?.Publish(DisplayEvent.Detail("Analytics", message, style));
	}

	public static void TrackError(string errorType)
	{
		_errorCounts.AddOrUpdate(errorType, 1, (_, count) => count + 1);
	}

	public static void IncrementPoll(bool success)
	{
		TotalPolls++;
		if (success)
			SuccessfulPolls++;
		else
			FailedPolls++;
	}

	public static void TogglePause()
	{
		IsPaused = !IsPaused;
		AddLog(IsPaused ? "PAUSED - Press SPACE to resume" : "RESUMED", IsPaused ? "yellow" : "green");
	}

	public static void NextView()
	{
		CurrentView = (ViewMode)(((int)CurrentView + 1) % 5);
		AddLog($"Switched to {CurrentView} view", "cyan");
	}

	public static void PreviousView()
	{
		int newView = (int)CurrentView - 1;
		if (newView < 0)
			newView = 4;
		CurrentView = (ViewMode)newView;
		AddLog($"Switched to {CurrentView} view", "cyan");
	}

	public static void HandleInput()
	{
		// Only process keypresses if console window is focused
		if (!IsConsoleFocused() || !Console.KeyAvailable)
			return;

		ConsoleKeyInfo key = Console.ReadKey(true);
		switch (key.Key)
		{
			case ConsoleKey.Spacebar:
				TogglePause();
				break;
			case ConsoleKey.Tab:
				if (key.Modifiers == ConsoleModifiers.Shift)
					PreviousView();
				else
					NextView();
				break;
			case ConsoleKey.D1:
			case ConsoleKey.NumPad1:
				CurrentView = ViewMode.Overview;
				break;
			case ConsoleKey.D2:
			case ConsoleKey.NumPad2:
				CurrentView = ViewMode.Jackpots;
				break;
			case ConsoleKey.D3:
			case ConsoleKey.NumPad3:
				CurrentView = ViewMode.Queue;
				break;
			case ConsoleKey.D4:
			case ConsoleKey.NumPad4:
				CurrentView = ViewMode.Analytics;
				break;
			case ConsoleKey.D5:
			case ConsoleKey.NumPad5:
				CurrentView = ViewMode.Errors;
				break;
			case ConsoleKey.C:
				if (key.Modifiers == ConsoleModifiers.Control)
				{
					lock (_events)
					{
						_events.Clear();
					}
					AddLog("Event log cleared", "grey");
				}
				break;
		}
	}

	public static void UpdateHealthStatus()
	{
		if ((DateTime.Now - _lastHealthUpdate).TotalSeconds >= 30)
		{
			HealthStatus = FailedPolls > SuccessfulPolls / 2 ? "DEGRADED" : "HEALTHY";
			_lastHealthUpdate = DateTime.Now;
		}
	}

	public static void Render()
	{
		lock (_renderLock)
		{
			TimeSpan timeSinceLastRender = DateTime.Now - _lastRender;
			if (timeSinceLastRender.TotalMilliseconds < 100)
				return;
			_lastRender = DateTime.Now;

			try
			{
				UpdateHealthStatus();

				// DECISION_085: Use LayoutDashboard when initialized
				if (s_useLayoutDashboard && s_layoutDashboard != null)
				{
					SyncToLayoutDashboard();
					s_layoutDashboard.Render();
					IsPaused = s_layoutDashboard.IsPaused;
					return;
				}

				// Legacy fallback: original rendering
				HandleInput();

				AnsiConsole.Clear();

				switch (CurrentView)
				{
					case ViewMode.Overview:
						RenderOverview();
						break;
					case ViewMode.Jackpots:
						RenderJackpots();
						break;
					case ViewMode.Queue:
						RenderQueue();
						break;
					case ViewMode.Analytics:
						RenderAnalytics();
						break;
					case ViewMode.Errors:
						RenderErrors();
						break;
				}
			}
			catch (Exception ex)
			{
				// Write error directly to console since dashboard is broken
				Console.WriteLine($"[Dashboard Error] {ex.GetType().Name}: {ex.Message}");
				Console.WriteLine($"[Dashboard Error] Stack: {ex.StackTrace}");
				Thread.Sleep(1000);
			}
		}
	}

	/// <summary>
	/// DECISION_085: Sync static Dashboard properties to the LayoutDashboard instance.
	/// </summary>
	private static void SyncToLayoutDashboard()
	{
		if (s_layoutDashboard == null) return;
		s_layoutDashboard.CurrentTask = CurrentTask;
		s_layoutDashboard.CurrentUser = CurrentUser;
		s_layoutDashboard.CurrentGame = CurrentGame;
		s_layoutDashboard.CurrentHouse = CurrentHouse;
		s_layoutDashboard.HealthStatus = HealthStatus;
		s_layoutDashboard.CurrentGrand = CurrentGrand;
		s_layoutDashboard.CurrentMajor = CurrentMajor;
		s_layoutDashboard.CurrentMinor = CurrentMinor;
		s_layoutDashboard.CurrentMini = CurrentMini;
		s_layoutDashboard.CurrentBalance = CurrentBalance;
		s_layoutDashboard.TotalEnabledBalance = TotalEnabledBalance;
		s_layoutDashboard.ThresholdGrand = ThresholdGrand;
		s_layoutDashboard.ThresholdMajor = ThresholdMajor;
		s_layoutDashboard.ThresholdMinor = ThresholdMinor;
		s_layoutDashboard.ThresholdMini = ThresholdMini;
		s_layoutDashboard.TotalPolls = TotalPolls;
		s_layoutDashboard.SuccessfulPolls = SuccessfulPolls;
		s_layoutDashboard.FailedPolls = FailedPolls;
		s_layoutDashboard.TotalCredentials = TotalCredentials;
	}

	private static void RenderOverview()
	{
		TimeSpan uptime = DateTime.Now - StartTime;

		// Header with version figlet on top right - single row
		var headerGrid = new Grid();
		headerGrid.AddColumn();
		headerGrid.AddColumn(new GridColumn().Width(35));

		// Simple text version instead of Figlet to avoid rendering issues
		var versionText = new Markup("[teal]v0.8.6.3[/]");
		headerGrid.AddRow(new Markup($"[bold]H0UND[/] v0.8.6.3{(IsPaused ? " [yellow]PAUSED[/]" : "")}"), versionText);

		var headerPanel = new Panel(headerGrid).Border(BoxBorder.Double).Expand();

		// CRED3N7IAL Section - Single line compact
		var credentialMarkup = new Markup(
			$"[cyan]{CurrentUser}[/] @ [white]{CurrentGame}[/] | "
				+ $"Grand [green]{CurrentGrand:C0}[/] | Major [blue]{CurrentMajor:C0}[/] | Minor [purple]{CurrentMinor:C0}[/] | Mini [yellow]{CurrentMini:C0}[/]"
		);

		var credentialPanel = new Panel(credentialMarkup).Border(BoxBorder.Rounded).Header("[bold magenta]CRED3N7IAL[/]", Justify.Left).Expand();

		// H0UND Section - Fixed 10 lines with status info
		var houndTable = new Table();
		houndTable.Border(TableBorder.None);
		houndTable.AddColumn(new TableColumn("Time").Width(10));
		houndTable.AddColumn(new TableColumn("Event"));

		// Add status info as first rows
		houndTable.AddRow($"[grey]{DateTime.Now:HH:mm:ss}[/]", $"[bold]Status:[/] {(IsPaused ? "[yellow]PAUSED[/]" : "[green]RUNNING[/]")}");
		houndTable.AddRow($"[grey]{DateTime.Now:HH:mm:ss}[/]", $"[bold]Task:[/] {GetColoredTask()}");
		houndTable.AddRow($"[grey]{DateTime.Now:HH:mm:ss}[/]", $"[bold]Health:[/] {GetHealthStatusMarkup()}");
		houndTable.AddRow($"[grey]{DateTime.Now:HH:mm:ss}[/]", $"[bold]Uptime:[/] [grey]{uptime:hh\\:mm\\:ss}[/]");
		houndTable.AddRow($"[grey]{DateTime.Now:HH:mm:ss}[/]", $"[bold]Polls:[/] [green]{SuccessfulPolls}[/] / [red]{FailedPolls}[/] / [white]{TotalPolls}[/]");

		lock (_events)
		{
			foreach (var evt in _events.AsEnumerable().Reverse().Take(5))
			{
				string escapedMsg = evt.Message.Replace("[", "[[").Replace("]", "]]");
				houndTable.AddRow($"[grey]{evt.Time:HH:mm:ss}[/]", $"[{evt.Style}]{escapedMsg}[/]");
			}
		}

		var houndPanel = new Panel(houndTable).Border(BoxBorder.Double).Header("[bold teal]H0UND[/] - Polling Engine", Justify.Center).Expand();

		// HUN7ER Section - Full schedule with no wrap
		var hunterTable = new Table();
		hunterTable.Border(TableBorder.None);
		hunterTable.AddColumn(new TableColumn("Time").Width(10));
		hunterTable.AddColumn(new TableColumn("Event"));

		lock (_analyticsEvents)
		{
			if (_analyticsEvents.Count == 0)
			{
				hunterTable.AddRow("[grey]--:--:--[/]", "[grey]Awaiting telemetry...[/]");
			}
			else
			{
				foreach (var evt in _analyticsEvents)
				{
					string escapedMsg = evt.Message.Replace("[", "[[").Replace("]", "]]");
					hunterTable.AddRow($"[grey]{evt.Time:HH:mm:ss}[/]", $"[{evt.Style}]{escapedMsg}[/]");
				}
			}
		}

		var hunterPanel = new Panel(hunterTable).Border(BoxBorder.Double).Header("[bold blue]HUN7ER[/] - Analytics Engine", Justify.Center).Expand();

		// Footer - compact single line
		var footer = new Markup("[grey]SPACE=Pause TAB=View 1-5=Jump Ctrl+C=Clear/Exit[/]");
		var footerPanel = new Panel(footer).Border(BoxBorder.None).Expand();

		// Assemble vertical layout: Header, CRED3N7IAL, H0UND, HUN7ER, Footer
		var root = new Grid();
		root.AddColumn();
		root.AddRow(headerPanel);
		root.AddRow(credentialPanel);
		root.AddRow(houndPanel);
		root.AddRow(hunterPanel);
		root.AddRow(footerPanel);

		AnsiConsole.Write(root);
	}

	private static void RenderJackpots()
	{
		TimeSpan uptime = DateTime.Now - StartTime;

		var grid = new Grid();
		grid.AddColumn();

		// Header info
		grid.AddRow(new Markup($"[bold]Uptime:[/] [grey]{uptime:hh\\:mm\\:ss}[/] | [bold]User:[/] [cyan]{CurrentUser}[/] | [bold]Game:[/] [white]{CurrentGame}[/]"));
		grid.AddRow(new Markup(""));

		// Current values table
		var table = new Table().Expand();
		table.AddColumn("Tier");
		table.AddColumn("Current Value");
		table.AddColumn("Threshold");
		table.AddColumn("Difference");

		table.AddRow("[bold green]GRAND[/]", $"[bold]{CurrentGrand:C2}[/]", $"{ThresholdGrand:C2}", FormatDifference(CurrentGrand - ThresholdGrand));
		table.AddRow("[bold blue]MAJOR[/]", $"[bold]{CurrentMajor:C2}[/]", $"{ThresholdMajor:C2}", FormatDifference(CurrentMajor - ThresholdMajor));
		table.AddRow("[bold purple]MINOR[/]", $"[bold]{CurrentMinor:C2}[/]", $"{ThresholdMinor:C2}", FormatDifference(CurrentMinor - ThresholdMinor));
		table.AddRow("[bold yellow]MINI[/]", $"[bold]{CurrentMini:C2}[/]", $"{ThresholdMini:C2}", FormatDifference(CurrentMini - ThresholdMini));

		var panel = new Panel(table).Border(BoxBorder.Double).Header("[bold]Jackpot Values[/]", Justify.Center).Expand();

		grid.AddRow(panel);

		// Footer
		var footer = new Markup("[grey][[SPACE]][/] Pause  [grey][[TAB]][/] Views  [grey][[Ctrl+C]][/] Exit");
		grid.AddRow(footer);

		AnsiConsole.Write(grid);
	}

	private static void RenderQueue()
	{
		TimeSpan uptime = DateTime.Now - StartTime;

		var grid = new Grid();
		grid.AddColumn();

		// Explanation: "Active: 1 / 310" means 1 credential currently being processed out of 310 total
		grid.AddRow(new Markup($"[bold]Uptime:[/] [grey]{uptime:hh\\:mm\\:ss}[/]"));
		grid.AddRow(new Markup(""));

		var infoGrid = new Grid();
		infoGrid.AddColumn(new GridColumn().Width(25));
		infoGrid.AddColumn();

		infoGrid.AddRow("[bold]Total Credentials:[/]", $"[white]{TotalCredentials}[/]");
		infoGrid.AddRow("[bold]Currently Processing:[/]", $"[cyan]{ActiveCredentials}[/] (credential being polled right now)");
		infoGrid.AddRow("[bold]Queue Position:[/]", $"[cyan]{ActiveCredentials}[/] of [white]{TotalCredentials}[/]");
		infoGrid.AddRow("[bold]Queue Size:[/]", $"[yellow]{QueueSize}[/] (waiting to be polled)");

		var panel = new Panel(infoGrid).Border(BoxBorder.Double).Header("[bold]Queue Status[/]", Justify.Center).Expand();

		grid.AddRow(panel);

		// Footer
		var footer = new Markup("[grey][[SPACE]][/] Pause  [grey][[TAB]][/] Views  [grey][[Ctrl+C]][/] Exit");
		grid.AddRow(footer);

		AnsiConsole.Write(grid);
	}

	private static void RenderAnalytics()
	{
		TimeSpan uptime = DateTime.Now - StartTime;
		double pollsPerMinute = uptime.TotalMinutes > 0 ? TotalPolls / uptime.TotalMinutes : 0;
		double successRate = TotalPolls > 0 ? (double)SuccessfulPolls / TotalPolls * 100 : 0;

		var grid = new Grid();
		grid.AddColumn();

		grid.AddRow(new Markup($"[bold]Uptime:[/] [grey]{uptime:hh\\:mm\\:ss}[/]"));
		grid.AddRow(new Markup(""));

		var infoGrid = new Grid();
		infoGrid.AddColumn(new GridColumn().Width(20));
		infoGrid.AddColumn();

		infoGrid.AddRow("[bold]Total Polls:[/]", $"[white]{TotalPolls}[/]");
		infoGrid.AddRow("[bold]Successful:[/]", $"[green]{SuccessfulPolls}[/]");
		infoGrid.AddRow("[bold]Failed:[/]", $"[red]{FailedPolls}[/]");
		infoGrid.AddRow("[bold]Success Rate:[/]", $"[bold]{successRate:F1}%[/]");
		infoGrid.AddRow("[bold]Polls/Minute:[/]", $"[bold]{pollsPerMinute:F1}[/]");
		infoGrid.AddRow("[bold]Avg Time/Poll:[/]", $"[grey]{(TotalPolls > 0 ? 60.0 / pollsPerMinute : 0):F1}s[/]");

		var panel = new Panel(infoGrid).Border(BoxBorder.Double).Header("[bold]Performance Metrics[/]", Justify.Center).Expand();

		grid.AddRow(panel);

		// Recent analytics events
		var eventTable = new Table().Expand();
		eventTable.AddColumn(new TableColumn("Time").Width(10));
		eventTable.AddColumn("Message");

		lock (_analyticsEvents)
		{
			foreach (var evt in _analyticsEvents.AsEnumerable().Reverse().Take(10))
			{
				string escapedMsg = evt.Message.Replace("[", "[[").Replace("]", "]]");
				eventTable.AddRow($"[grey]{evt.Time:HH:mm:ss}[/]", $"[{evt.Style}]{escapedMsg}[/]");
			}
		}

		var eventsPanel = new Panel(eventTable).Border(BoxBorder.Rounded).Header("[bold]Recent Analytics Events[/]").Expand();

		grid.AddRow(eventsPanel);

		// Footer
		var footer = new Markup("[grey][[SPACE]][/] Pause  [grey][[TAB]][/] Views  [grey][[Ctrl+C]][/] Exit");
		grid.AddRow(footer);

		AnsiConsole.Write(grid);
	}

	private static void RenderErrors()
	{
		TimeSpan uptime = DateTime.Now - StartTime;

		var grid = new Grid();
		grid.AddColumn();

		grid.AddRow(new Markup($"[bold]Uptime:[/] [grey]{uptime:hh\\:mm\\:ss}[/]"));
		grid.AddRow(new Markup(""));

		if (_errorCounts.Count == 0)
		{
			grid.AddRow(new Markup("[green]No errors recorded yet.[/]"));
		}
		else
		{
			var table = new Table().Expand();
			table.AddColumn("Error Type");
			table.AddColumn("Count");
			table.AddColumn("Percentage");

			int total = _errorCounts.Values.Sum();
			foreach (var error in _errorCounts.OrderByDescending(e => e.Value))
			{
				double pct = (double)error.Value / total * 100;
				table.AddRow(error.Key, $"[red]{error.Value}[/]", $"{pct:F1}%");
			}

			var panel = new Panel(table).Border(BoxBorder.Double).Header("[bold]Error Statistics[/]", Justify.Center).Expand();

			grid.AddRow(panel);
		}

		// Footer
		var footer = new Markup("[grey][[SPACE]][/] Pause  [grey][[TAB]][/] Views  [grey][[Ctrl+C]][/] Exit");
		grid.AddRow(footer);

		AnsiConsole.Write(grid);
	}

	private static string FormatDifference(double diff)
	{
		if (diff >= 0)
			return $"[green]+{diff:C2}[/] (above threshold)";
		else
			return $"[red]{diff:C2}[/] (below threshold)";
	}

	private static string GetColoredTask()
	{
		return CurrentTask switch
		{
			"Idle" => "[grey]Idle[/]",
			"Polling Queue" => "[cyan]Polling Queue[/]",
			"Running Analytics" => "[blue]Running Analytics[/]",
			"Retrieving Balances" => "[yellow]Retrieving Balances[/]",
			"Error - Recovery" => "[red]Error - Recovery[/]",
			_ => $"[white]{CurrentTask}[/]",
		};
	}

	private static string GetHealthStatusMarkup()
	{
		return HealthStatus switch
		{
			"HEALTHY" => $"[bold green]{HealthStatus}[/]",
			"DEGRADED" => $"[bold yellow]{HealthStatus}[/]",
			"CRITICAL" => $"[bold red]{HealthStatus}[/]",
			_ => $"[bold cyan]{HealthStatus}[/]",
		};
	}

	// Windows API for checking if console window is focused
	[DllImport("kernel32.dll", ExactSpelling = true)]
	private static extern IntPtr GetConsoleWindow();

	[DllImport("user32.dll", ExactSpelling = true)]
	private static extern IntPtr GetForegroundWindow();

	private static bool IsConsoleFocused()
	{
		return GetForegroundWindow() == GetConsoleWindow();
	}
}
