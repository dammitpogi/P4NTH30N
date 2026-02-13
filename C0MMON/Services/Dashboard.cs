using Spectre.Console;
using P4NTH30N.C0MMON;

namespace P4NTH30N.Services;

public static class Dashboard {
    private static readonly List<(DateTime Time, string Message, string Style)> _events = new();
    private static readonly int _maxEvents = 15;
    public static string CurrentTask { get; set; } = "Idle";
    public static string CurrentUser { get; set; } = "None";
    public static string CurrentGame { get; set; } = "None";
    public static string HealthStatus { get; set; } = "INITIALIZING";
    private static DateTime _lastHealthUpdate = DateTime.MinValue;

    public static void AddLog(string message, string style = "white") {
        _events.Add((DateTime.Now, message, style));
        if (_events.Count > _maxEvents) {
            _events.RemoveAt(0);
        }
    }

    public static void UpdateHealthStatus() {
        // Health status is now updated by individual services using ERR0R collection
        // This is a placeholder that can be called periodically
        if ((DateTime.Now - _lastHealthUpdate).TotalSeconds >= 30) {
            HealthStatus = "RUNNING";
            _lastHealthUpdate = DateTime.Now;
        }
    }

    public static void Render() {
        // Update health status before rendering
        UpdateHealthStatus();
        
        AnsiConsole.Clear();

        // Header
        var headerGrid = new Grid();
        headerGrid.AddColumn();
        headerGrid.AddColumn();
        headerGrid.AddRow(
            new FigletText("P4NTH30N").Color(Spectre.Console.Color.Teal),
            new Markup($"[bold]Task:[/] {CurrentTask}\n[bold]User:[/] {CurrentUser}\n[bold]Game:[/] {CurrentGame}\n[bold]Health:[/] {GetHealthStatusColor()}")
        );
        AnsiConsole.Write(new Spectre.Console.Panel(headerGrid).Border(BoxBorder.Double).Header("Instance Status").Expand());

		// Events Table
		var table = new Table().Expand();
		table.AddColumn(new TableColumn("Time").Width(10).NoWrap());
		table.AddColumn(new TableColumn("Message"));
		table.Border(TableBorder.None);

        foreach (var evt in _events.AsEnumerable().Reverse()) {
            table.AddRow(
                $"[grey]{evt.Time:HH:mm:ss}[/]",
                $"[{evt.Style}]{evt.Message.Replace("[", "[[").Replace("]", "]]")}[/]"
            );
        }

		AnsiConsole.Write(new Spectre.Console.Panel(table)
			.Border(BoxBorder.Double)
			.Header("Event Log")
			.Expand()
		);
        
        // Footer hint
        AnsiConsole.MarkupLine("[grey]Press Ctrl+C to exit[/]");
    }

    private static string GetHealthStatusColor() {
        return HealthStatus.Contains("HEALTHY") ? $"[green]{HealthStatus}[/]" :
               HealthStatus.Contains("CRITICAL") ? $"[red]{HealthStatus}[/]" :
               HealthStatus.Contains("WARNING") ? $"[yellow]{HealthStatus}[/]" :
               $"[cyan]{HealthStatus}[/]";
    }
}
