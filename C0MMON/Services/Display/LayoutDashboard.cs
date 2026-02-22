using System.Collections.Concurrent;
using Spectre.Console;
using Spectre.Console.Rendering;
using Color = Spectre.Console.Color;
using Panel = Spectre.Console.Panel;

namespace P4NTH30N.C0MMON.Services.Display;

/// <summary>
/// Two-column operational dashboard answering key questions:
/// - Which jackpots are coming up? (Schedule, left column)
/// - Which accounts need deposits? (Deposit Needed, right column)
/// - Which accounts have balance to withdraw? (Withdraw, right column)
/// - Which jackpots have won? (Won Recently, left column)
/// - What's happening now? (Activity, right column)
/// Debug panel toggled with 'D' key.
/// </summary>
public sealed class LayoutDashboard
{
	private readonly IDisplayEventBus _bus;
	private readonly List<DisplayEvent> _mainEvents = new();
	private readonly List<DisplayEvent> _debugEvents = new();
	private readonly object _eventLock = new();

	private const int MaxMainEvents = 8;
	private const int MaxDebugEvents = 50;
	private const int MaxScheduleRows = 15;
	private const int MaxWonRows = 5;
	private const int MaxWithdrawRows = 10;
	private const int MaxDepositRows = 8;

	private bool _debugVisible;
	private DateTime _startTime = DateTime.Now;

	// Dashboard state (set by caller via SyncToLayoutDashboard)
	public string CurrentTask { get; set; } = "Idle";
	public string CurrentUser { get; set; } = "None";
	public string CurrentGame { get; set; } = "None";
	public string CurrentHouse { get; set; } = "Unknown";
	public string HealthStatus { get; set; } = "INITIALIZING";

	public double CurrentGrand { get; set; }
	public double CurrentMajor { get; set; }
	public double CurrentMinor { get; set; }
	public double CurrentMini { get; set; }
	public double CurrentBalance { get; set; }

	public double ThresholdGrand { get; set; }
	public double ThresholdMajor { get; set; }
	public double ThresholdMinor { get; set; }
	public double ThresholdMini { get; set; }

	public long TotalPolls { get; set; }
	public long SuccessfulPolls { get; set; }
	public long FailedPolls { get; set; }
	public int TotalCredentials { get; set; }
	public bool IsPaused { get; set; }

	public bool DebugVisible => _debugVisible;

	// === SCHEDULE DATA (populated by H0UND via Dashboard.UpdateSchedule) ===
	private readonly List<ScheduleEntry> _schedule = new();
	private readonly List<AccountEntry> _withdrawAccounts = new();
	private readonly List<DepositEntry> _depositNeeded = new();
	private readonly List<WonEntry> _recentWins = new();
	private readonly object _dataLock = new();

	public LayoutDashboard(IDisplayEventBus bus)
	{
		_bus = bus;

		// Subscribe: Detail+ goes to activity panel
		bus.Subscribe(DisplayLogLevel.Detail, evt =>
		{
			lock (_eventLock)
			{
				_mainEvents.Add(evt);
				if (_mainEvents.Count > MaxMainEvents)
					_mainEvents.RemoveAt(0);
			}
		});

		// Subscribe: Debug+ goes to debug panel
		bus.Subscribe(DisplayLogLevel.Debug, evt =>
		{
			lock (_eventLock)
			{
				_debugEvents.Add(evt);
				if (_debugEvents.Count > MaxDebugEvents)
					_debugEvents.RemoveAt(0);
			}
		});
	}

	// === DATA UPDATE METHODS (called from H0UND via Dashboard bridge) ===

	public void UpdateSchedule(List<ScheduleEntry> entries)
	{
		lock (_dataLock)
		{
			_schedule.Clear();
			_schedule.AddRange(entries.Take(MaxScheduleRows));
		}
	}

	public void UpdateWithdrawAccounts(List<AccountEntry> accounts)
	{
		lock (_dataLock)
		{
			_withdrawAccounts.Clear();
			_withdrawAccounts.AddRange(accounts.Take(MaxWithdrawRows));
		}
	}

	public void UpdateDepositNeeded(List<DepositEntry> deposits)
	{
		lock (_dataLock)
		{
			_depositNeeded.Clear();
			_depositNeeded.AddRange(deposits.Take(MaxDepositRows));
		}
	}

	public void AddWin(WonEntry win)
	{
		lock (_dataLock)
		{
			_recentWins.Insert(0, win);
			if (_recentWins.Count > MaxWonRows)
				_recentWins.RemoveAt(_recentWins.Count - 1);
		}
	}

	public void UpdateRecentWins(List<WonEntry> wins)
	{
		lock (_dataLock)
		{
			_recentWins.Clear();
			_recentWins.AddRange(wins.Take(MaxWonRows));
		}
	}

	public bool HandleInput()
	{
		if (!Console.KeyAvailable)
			return false;

		ConsoleKeyInfo key = Console.ReadKey(true);
		switch (key.Key)
		{
			case ConsoleKey.D when key.Modifiers == 0:
				_debugVisible = !_debugVisible;
				return true;

			case ConsoleKey.Spacebar:
				IsPaused = !IsPaused;
				return true;

			case ConsoleKey.Q:
				return false;
		}
		return false;
	}

	public void Render()
	{
		try
		{
			HandleInput();
			AnsiConsole.Cursor.SetPosition(0, 0);
			AnsiConsole.Write(BuildLayout());
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[LayoutDashboard Error] {ex.GetType().Name}: {ex.Message}");
		}
	}

	public void RenderFull()
	{
		try
		{
			AnsiConsole.Clear();
			AnsiConsole.Write(BuildLayout());
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[LayoutDashboard Error] {ex.GetType().Name}: {ex.Message}");
		}
	}

	private IRenderable BuildLayout()
	{
		TimeSpan uptime = DateTime.Now - _startTime;
		IReadOnlyDictionary<DisplayLogLevel, long> counts = _bus.GetCounts();

		// ═══════════════════════════════════════════════════════════════════
		// HEADER — compact status bar
		// ═══════════════════════════════════════════════════════════════════
		string healthMk = HealthStatus switch
		{
			"HEALTHY" => "[bold green]●[/]",
			"DEGRADED" => "[bold yellow]●[/]",
			"CRITICAL" => "[bold red]●[/]",
			_ => "[cyan]○[/]",
		};
		string pauseTag = IsPaused ? " [bold yellow]PAUSED[/]" : "";
		string headerText =
			$"{healthMk} [bold teal]H0UND[/]{pauseTag}  |  {uptime:hh\\:mm\\:ss}  |  "
			+ $"Polls [green]{SuccessfulPolls}[/]/[red]{FailedPolls}[/]/[white]{TotalPolls}[/]  |  "
			+ $"{TotalCredentials} creds  |  Bal [white]{CurrentBalance:C2}[/]  |  "
			+ $"[cyan]{Markup.Escape(CurrentUser)}[/] @ [white]{Markup.Escape(CurrentGame)}[/] ({Markup.Escape(CurrentHouse)})  |  "
			+ $"{GetColoredTask()}  |  Suppressed: [grey]{counts.GetValueOrDefault(DisplayLogLevel.Silent) + counts.GetValueOrDefault(DisplayLogLevel.Debug)}[/]";

		var header = new Panel(new Markup(headerText))
			.Border(BoxBorder.Heavy)
			.BorderColor(Color.Teal)
			.Expand();

		// ═══════════════════════════════════════════════════════════════════
		// SINGLE-COLUMN VERTICAL STACK
		// ═══════════════════════════════════════════════════════════════════
		var root = new Grid();
		root.AddColumn();
		root.AddRow(header);

		// ── JACKPOT SCHEDULE (primary, full width) ──
		root.AddRow(BuildSchedulePanel());

		// ── WITHDRAW (conditional) ──
		lock (_dataLock)
		{
			if (_withdrawAccounts.Count > 0)
				root.AddRow(BuildWithdrawPanel());
		}

		// ── DEPOSIT NEEDED (conditional) ──
		lock (_dataLock)
		{
			if (_depositNeeded.Count > 0)
				root.AddRow(BuildDepositPanel());
		}

		// ── WON RECENTLY (conditional) ──
		lock (_dataLock)
		{
			if (_recentWins.Count > 0)
				root.AddRow(BuildWonPanel());
		}

		// ── ACTIVITY LOG ──
		root.AddRow(BuildActivityPanel());

		// ── DEBUG PANEL (conditional) ──
		if (_debugVisible)
			root.AddRow(BuildDebugPanel());

		// ── FOOTER ──
		string debugInd = _debugVisible ? "[green]ON[/]" : "[grey]OFF[/]";
		var footer = new Markup(
			$" [grey]SPACE[/]=Pause  [grey]D[/]=Debug({debugInd})  [grey]Q[/]=Quit");
		root.AddRow(footer);

		return root;
	}

	// ═══════════════════════════════════════════════════════════════════════
	// JACKPOT SCHEDULE — primary panel, full width, full names
	// ═══════════════════════════════════════════════════════════════════════
	private IRenderable BuildSchedulePanel()
	{
		var schedTable = new Table().Border(TableBorder.Rounded).Expand();
		schedTable.AddColumn(new TableColumn("[bold]House[/]"));
		schedTable.AddColumn(new TableColumn("[bold]Game[/]"));
		schedTable.AddColumn(new TableColumn("[bold]Tier[/]"));
		schedTable.AddColumn(new TableColumn("[bold]ETA[/]").RightAligned());
		schedTable.AddColumn(new TableColumn("[bold]Current[/]").RightAligned());
		schedTable.AddColumn(new TableColumn("[bold]Target[/]").RightAligned());
		schedTable.AddColumn(new TableColumn("[bold]%[/]").RightAligned());

		lock (_dataLock)
		{
			if (_schedule.Count == 0)
			{
				schedTable.AddRow("[grey]--[/]", "[grey]Loading schedule...[/]", "[grey]--[/]", "[grey]--[/]", "[grey]--[/]", "[grey]--[/]", "[grey]--[/]");
			}
			else
			{
				foreach (ScheduleEntry e in _schedule)
				{
					string houseMk = e.House switch
					{
						"FireKirin" => "[yellow]FireKirin[/]",
						"OrionStars" => "[blue]OrionStars[/]",
						_ => $"[white]{Markup.Escape(e.House)}[/]",
					};
					string tierMk = e.Tier switch
					{
						"Grand" => "[green]Grand[/]",
						"Major" => "[blue]Major[/]",
						"Minor" => "[purple]Minor[/]",
						"Mini" => "[yellow]Mini[/]",
						_ => $"[white]{Markup.Escape(e.Tier)}[/]",
					};
					string style = e.UrgencyStyle;
					string pct = e.PercentComplete >= 99 ? "[bold red]99+[/]" : $"[grey]{e.PercentComplete:F0}[/]";

					schedTable.AddRow(
						houseMk,
						$"[{style}]{Markup.Escape(e.Game)}[/]",
						tierMk,
						$"[{style}]{e.ETADisplay}[/]",
						$"[white]{e.Current:N0}[/]",
						$"[grey]{e.Threshold:N0}[/]",
						pct
					);
				}
			}
		}

		return new Panel(schedTable)
			.Border(BoxBorder.Double)
			.BorderColor(Color.Teal)
			.Header("[bold teal]JACKPOT SCHEDULE[/] (by ETA)", Justify.Left)
			.Expand();
	}

	// ═══════════════════════════════════════════════════════════════════════
	// WITHDRAW — accounts with balance (conditional)
	// ═══════════════════════════════════════════════════════════════════════
	private IRenderable BuildWithdrawPanel()
	{
		var wdTable = new Table().Border(TableBorder.Rounded).Expand();
		wdTable.AddColumn(new TableColumn("[bold]User[/]"));
		wdTable.AddColumn(new TableColumn("[bold]House[/]"));
		wdTable.AddColumn(new TableColumn("[bold]Game[/]"));
		wdTable.AddColumn(new TableColumn("[bold]Balance[/]").RightAligned());

		lock (_dataLock)
		{
			foreach (AccountEntry a in _withdrawAccounts)
			{
				string houseMk = a.House switch
				{
					"FireKirin" => "[yellow]FireKirin[/]",
					"OrionStars" => "[blue]OrionStars[/]",
					_ => $"[white]{Markup.Escape(a.House)}[/]",
				};
				string balColor = a.Balance >= 1.0 ? "green" : "white";
				wdTable.AddRow(
					$"[cyan]{Markup.Escape(a.Username)}[/]",
					houseMk,
					$"[white]{Markup.Escape(a.Game)}[/]",
					$"[{balColor}]{a.Balance:C2}[/]"
				);
			}
		}

		return new Panel(wdTable)
			.Border(BoxBorder.Rounded)
			.BorderColor(Color.Green)
			.Header("[bold green]WITHDRAW[/]", Justify.Left)
			.Expand();
	}

	// ═══════════════════════════════════════════════════════════════════════
	// DEPOSIT NEEDED — cashed-out accounts linked to upcoming jackpots
	// ═══════════════════════════════════════════════════════════════════════
	private IRenderable BuildDepositPanel()
	{
		var depTable = new Table().Border(TableBorder.Rounded).Expand();
		depTable.AddColumn(new TableColumn("[bold]User[/]"));
		depTable.AddColumn(new TableColumn("[bold]House[/]"));
		depTable.AddColumn(new TableColumn("[bold]Game[/]"));
		depTable.AddColumn(new TableColumn("[bold]Tier[/]"));
		depTable.AddColumn(new TableColumn("[bold]Deadline[/]").RightAligned());

		lock (_dataLock)
		{
			foreach (DepositEntry d in _depositNeeded)
			{
				string houseMk = d.House switch
				{
					"FireKirin" => "[yellow]FireKirin[/]",
					"OrionStars" => "[blue]OrionStars[/]",
					_ => $"[white]{Markup.Escape(d.House)}[/]",
				};
				string tierMk = d.Tier switch
				{
					"Grand" => "[green]Grand[/]",
					"Major" => "[blue]Major[/]",
					"Minor" => "[purple]Minor[/]",
					"Mini" => "[yellow]Mini[/]",
					_ => $"[white]{Markup.Escape(d.Tier)}[/]",
				};
				string urgency = d.TimeUntilJackpot.TotalHours < 3 ? "bold red" :
					d.TimeUntilJackpot.TotalHours < 12 ? "yellow" : "grey";
				depTable.AddRow(
					$"[cyan]{Markup.Escape(d.Username)}[/]",
					houseMk,
					$"[white]{Markup.Escape(d.Game)}[/]",
					tierMk,
					$"[{urgency}]{d.Deadline}[/]"
				);
			}
		}

		return new Panel(depTable)
			.Border(BoxBorder.Rounded)
			.BorderColor(Color.Yellow)
			.Header("[bold yellow]DEPOSIT NEEDED[/]", Justify.Left)
			.Expand();
	}

	// ═══════════════════════════════════════════════════════════════════════
	// WON RECENTLY — recent jackpot pops
	// ═══════════════════════════════════════════════════════════════════════
	private IRenderable BuildWonPanel()
	{
		var wonTable = new Table().Border(TableBorder.Rounded).Expand();
		wonTable.AddColumn(new TableColumn("[bold]House[/]"));
		wonTable.AddColumn(new TableColumn("[bold]Game[/]"));
		wonTable.AddColumn(new TableColumn("[bold]Tier[/]"));
		wonTable.AddColumn(new TableColumn("[bold]Value[/]").RightAligned());
		wonTable.AddColumn(new TableColumn("[bold]When[/]").RightAligned());

		lock (_dataLock)
		{
			foreach (WonEntry w in _recentWins)
			{
				string houseMk = w.House switch
				{
					"FireKirin" => "[yellow]FireKirin[/]",
					"OrionStars" => "[blue]OrionStars[/]",
					_ => $"[white]{Markup.Escape(w.House)}[/]",
				};
				string tierMk = w.Tier switch
				{
					"Grand" => "[green]Grand[/]",
					"Major" => "[blue]Major[/]",
					"Minor" => "[purple]Minor[/]",
					"Mini" => "[yellow]Mini[/]",
					_ => $"[white]{Markup.Escape(w.Tier)}[/]",
				};
				wonTable.AddRow(
					houseMk,
					$"[green]{Markup.Escape(w.Game)}[/]",
					tierMk,
					$"[green]{w.PreviousValue:C2}[/]",
					$"[grey]{w.WonAt.ToLocalTime():MM/dd HH:mm}[/]"
				);
			}
		}

		return new Panel(wonTable)
			.Border(BoxBorder.Rounded)
			.BorderColor(Color.Green)
			.Header("[bold green]WON RECENTLY[/]", Justify.Left)
			.Expand();
	}

	// ═══════════════════════════════════════════════════════════════════════
	// ACTIVITY LOG — recent events
	// ═══════════════════════════════════════════════════════════════════════
	private IRenderable BuildActivityPanel()
	{
		var actTable = new Table().Border(TableBorder.Rounded).Expand();
		actTable.AddColumn(new TableColumn("[bold]Time[/]"));
		actTable.AddColumn(new TableColumn("[bold]Event[/]"));

		lock (_eventLock)
		{
			if (_mainEvents.Count == 0)
			{
				actTable.AddRow("[grey]--:--:--[/]", "[grey]Waiting for events...[/]");
			}
			else
			{
				foreach (DisplayEvent evt in _mainEvents)
				{
					actTable.AddRow(
						$"[grey]{evt.Timestamp.ToLocalTime():HH:mm:ss}[/]",
						$"[{evt.Style}]{Markup.Escape(evt.Message)}[/]"
					);
				}
			}
		}

		return new Panel(actTable)
			.Border(BoxBorder.Rounded)
			.BorderColor(Color.Grey)
			.Header("[grey]ACTIVITY[/]", Justify.Left)
			.Expand();
	}

	// ═══════════════════════════════════════════════════════════════════════
	// DEBUG PANEL (hidden by default, toggled with 'D')
	// ═══════════════════════════════════════════════════════════════════════
	private IRenderable BuildDebugPanel()
	{
		var debugTable = new Table().Border(TableBorder.None).Expand();
		debugTable.AddColumn(new TableColumn("Time").Width(9));
		debugTable.AddColumn(new TableColumn("Lvl").Width(4));
		debugTable.AddColumn(new TableColumn("Src").Width(18));
		debugTable.AddColumn(new TableColumn("Message"));

		lock (_eventLock)
		{
			var recentDebug = _debugEvents.Skip(Math.Max(0, _debugEvents.Count - 15)).ToList();
			if (recentDebug.Count == 0)
			{
				debugTable.AddRow("[grey]--:--:--[/]", "[grey]-[/]", "[grey]-[/]", "[grey]No debug events[/]");
			}
			else
			{
				foreach (DisplayEvent evt in recentDebug)
				{
					string lvl = evt.Level switch
					{
						DisplayLogLevel.Debug => "[grey]DBG[/]",
						DisplayLogLevel.Detail => "[white]DTL[/]",
						DisplayLogLevel.Warning => "[yellow]WRN[/]",
						DisplayLogLevel.Error => "[red]ERR[/]",
						_ => $"[grey]{evt.Level}[/]",
					};
					debugTable.AddRow(
						$"[grey]{evt.Timestamp.ToLocalTime():HH:mm:ss}[/]",
						lvl,
						$"[grey]{Markup.Escape(evt.Source)}[/]",
						$"[{evt.Style}]{Markup.Escape(evt.Message)}[/]"
					);
				}
			}
		}

		return new Panel(debugTable)
			.Border(BoxBorder.Heavy)
			.BorderColor(Color.Red)
			.Header("[bold red]DEBUG[/] (D to hide)", Justify.Center)
			.Expand();
	}

	// ═══════════════════════════════════════════════════════════════════════
	// HELPERS
	// ═══════════════════════════════════════════════════════════════════════

	private string GetColoredTask()
	{
		return CurrentTask switch
		{
			"Idle" => "[grey]Idle[/]",
			"Polling Queue" => "[cyan]Polling[/]",
			"Running Analytics" => "[blue]Analytics[/]",
			"Retrieving Balances" => "[yellow]Balances[/]",
			"Error - Recovery" => "[bold red]Recovery[/]",
			_ => $"[white]{Markup.Escape(CurrentTask)}[/]",
		};
	}
}
