using System.CommandLine;
using System.CommandLine.Invocation;
using System.Text.Json;
using ConsoleTables;
using Figgle;
using P4NTH30N.C0MMON;
using P4NTH30N.Services;

namespace VPN_CLI;

public class Program
{
    private static readonly HttpClient _httpClient = new();
    public static bool _jsonOutput = false;
    public static bool _verboseOutput = false;

    public static async Task<int> Main(string[] args)
    {
        var rootCommand = new RootCommand("VPN Control CLI - Command-line interface for CyberGhost VPN status and control")
        {
            Name = "vpn"
        };

        // Global options
        var jsonOption = new Option<bool>(
            aliases: ["--json", "-j"],
            description: "Output results in JSON format");

        var verboseOption = new Option<bool>(
            aliases: ["--verbose", "-v"],
            description: "Enable verbose output");

        var quietOption = new Option<bool>(
            aliases: ["--quiet", "-q"],
            description: "Suppress non-essential output");

        rootCommand.AddGlobalOption(jsonOption);
        rootCommand.AddGlobalOption(verboseOption);
        rootCommand.AddGlobalOption(quietOption);

        // Status commands
        var statusCommand = new Command("status", "Check VPN connection status and location information");
        statusCommand.AddAlias("st");
        
        var statusCurrentCommand = new Command("current", "Show current IP and location");
        statusCurrentCommand.AddAlias("curr");
        statusCurrentCommand.SetHandler(async (json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await CommandHandlers.HandleCurrentStatus();
        }, jsonOption, verboseOption, quietOption);

        var statusComplianceCommand = new Command("compliance", "Check location compliance with configured rules");
        statusComplianceCommand.AddAlias("comp");
        statusComplianceCommand.SetHandler(async (json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await CommandHandlers.HandleComplianceCheck();
        }, jsonOption, verboseOption, quietOption);

        var statusProcessCommand = new Command("process", "Check if CyberGhost process is running");
        statusProcessCommand.AddAlias("proc");
        statusProcessCommand.SetHandler(async (json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await CommandHandlers.HandleProcessStatus();
        }, jsonOption, verboseOption, quietOption);

        statusCommand.AddCommand(statusCurrentCommand);
        statusCommand.AddCommand(statusComplianceCommand);
        statusCommand.AddCommand(statusProcessCommand);

        // Control commands
        var controlCommand = new Command("control", "Control VPN connection state");
        controlCommand.AddAlias("ctrl");

        var connectCommand = new Command("connect", "Establish VPN connection and ensure compliance");
        connectCommand.AddAlias("start");
        connectCommand.SetHandler(async (json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await CommandHandlers.HandleConnect();
        }, jsonOption, verboseOption, quietOption);

        var disconnectCommand = new Command("disconnect", "Disconnect VPN connection");
        disconnectCommand.AddAlias("stop");
        disconnectCommand.SetHandler(async (json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await CommandHandlers.HandleDisconnect();
        }, jsonOption, verboseOption, quietOption);

        var resetCommand = new Command("reset", "Reset VPN connection");
        resetCommand.AddAlias("restart");
        resetCommand.SetHandler(async (json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await CommandHandlers.HandleReset();
        }, jsonOption, verboseOption, quietOption);

        var changeLocationCommand = new Command("change-location", "Change VPN server location");
        changeLocationCommand.AddAlias("chng-loc");
        changeLocationCommand.SetHandler(async (json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await CommandHandlers.HandleChangeLocation();
        }, jsonOption, verboseOption, quietOption);

        controlCommand.AddCommand(connectCommand);
        controlCommand.AddCommand(disconnectCommand);
        controlCommand.AddCommand(resetCommand);
        controlCommand.AddCommand(changeLocationCommand);

        // Info commands
        var infoCommand = new Command("info", "Display system and VPN information");

        var installCommand = new Command("install-status", "Check CyberGhost installation status");
        installCommand.AddAlias("install");
        installCommand.SetHandler(async (json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await CommandHandlers.HandleInstallStatus();
        }, jsonOption, verboseOption, quietOption);

        var versionsCommand = new Command("version", "Show version information");
        versionsCommand.AddAlias("ver");
        versionsCommand.SetHandler((json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            CommandHandlers.HandleVersion();
        }, jsonOption, verboseOption, quietOption);

        infoCommand.AddCommand(installCommand);
        infoCommand.AddCommand(versionsCommand);

        // Watch command (continuous monitoring)
        var watchCommand = new Command("watch", "Continuously monitor VPN status");
        
        var intervalOption = new Option<int>(
            aliases: ["--interval", "-i"],
            description: "Refresh interval in seconds",
            getDefaultValue: () => 5);

        var maxIterationsOption = new Option<int>(
            aliases: ["--max-iterations", "-n"],
            description: "Maximum number of iterations (0 = infinite)",
            getDefaultValue: () => 0);

        watchCommand.AddOption(intervalOption);
        watchCommand.AddOption(maxIterationsOption);
        watchCommand.SetHandler(async (json, verbose, quiet, interval, maxIterations) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await CommandHandlers.HandleWatch(interval, maxIterations);
        }, jsonOption, verboseOption, quietOption, intervalOption, maxIterationsOption);

        // Auto command (automated management)
        var autoCommand = new Command("auto", "Automated VPN management with compliance monitoring");
        
        var autoCheckIntervalOption = new Option<int>(
            aliases: ["--check-interval"],
            description: "Compliance check interval in seconds",
            getDefaultValue: () => 30);

        var autoRetryLimitOption = new Option<int>(
            aliases: ["--retry-limit"],
            description: "Maximum retry attempts for failed operations",
            getDefaultValue: () => 3);

        autoCommand.AddOption(autoCheckIntervalOption);
        autoCommand.AddOption(autoRetryLimitOption);
        autoCommand.SetHandler(async (json, verbose, quiet, checkInterval, retryLimit) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await CommandHandlers.HandleAutoManagement(checkInterval, retryLimit);
        }, jsonOption, verboseOption, quietOption, autoCheckIntervalOption, autoRetryLimitOption);

        // Test injection methods command
        var testCommand = new Command("test-injection", "Test VPN injection methods with complete shutdown and restart");
        testCommand.SetHandler(async (json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await CommandHandlers.HandleTestInjection();
        }, jsonOption, verboseOption, quietOption);

        // Comprehensive test suite command
        var testSuiteCommand = new Command("test-suite", "Run comprehensive VPN CLI test suite");
        testSuiteCommand.SetHandler(async (json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await VpnTestSuite.RunFullTestSuite();
        }, jsonOption, verboseOption, quietOption);

        // Add all commands to root
        rootCommand.AddCommand(statusCommand);
        rootCommand.AddCommand(controlCommand);
        rootCommand.AddCommand(infoCommand);
        rootCommand.AddCommand(watchCommand);
        rootCommand.AddCommand(autoCommand);
        rootCommand.AddCommand(testCommand);
        rootCommand.AddCommand(testSuiteCommand);

        // Default action when no subcommand is provided
        rootCommand.SetHandler(async (json, verbose, quiet) =>
        {
            _jsonOutput = json;
            _verboseOutput = verbose;
            if (!quiet) ShowHeader();
            await HandleDefaultAction();
        }, jsonOption, verboseOption, quietOption);

        return await rootCommand.InvokeAsync(args);
    }

    private static void ShowHeader()
    {
        if (_jsonOutput) return;
        
        Console.WriteLine(FiggleFonts.Small.Render("VPN CLI"));
        Console.WriteLine("CyberGhost VPN Control Interface");
        Console.WriteLine("═══════════════════════════════════════");
        Console.WriteLine();
    }

    private static async Task HandleDefaultAction()
    {
        await CommandHandlers.HandleCurrentStatus();
        Console.WriteLine();
        Console.WriteLine("Use 'vpn --help' for available commands");
        Console.WriteLine("Quick commands:");
        Console.WriteLine("  vpn status current    - Show current IP and location");
        Console.WriteLine("  vpn control connect   - Connect to VPN");
        Console.WriteLine("  vpn watch            - Monitor status continuously");
    }
}