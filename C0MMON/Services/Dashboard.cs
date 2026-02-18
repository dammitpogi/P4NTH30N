using System.Collections.Concurrent;
using P4NTH30N.C0MMON;
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
		if (!Console.KeyAvailable)
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
}
