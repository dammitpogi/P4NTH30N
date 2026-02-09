using Spectre.Console;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.SanityCheck;

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
        if ((DateTime.Now - _lastHealthUpdate).TotalSeconds >= 30) {
            var health = P4NTH30NSanityChecker.GetSystemHealth();
            HealthStatus = $"{health.Status} | E:{health.ErrorCount} R:{health.RepairCount}";
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
        AnsiConsole.Write(new Spectre.Console.Panel(headerGrid).Border(BoxBorder.Double).Header("Instance Status"));

        // Events Table
        var table = new Table().Expand();
        table.AddColumn("Time");
        table.AddColumn("Message");
        table.Border(TableBorder.Rounded);

        foreach (var evt in _events.AsEnumerable().Reverse()) {
            table.AddRow(
                $"[grey]{evt.Time:HH:mm:ss}[/]",
                $"[{evt.Style}]{evt.Message.Replace("[", "[[").Replace("]", "]]")}[/]"
            );
        }

        AnsiConsole.Write(new Spectre.Console.Panel(table).Header("Event Log"));
        
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
