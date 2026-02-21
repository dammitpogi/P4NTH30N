namespace T4CT1CS;

public class Program
{
	public static void Main(string[] args)
	{
		var serviceProvider = ConfigureServices();
		var application = serviceProvider.GetService<IApplicationService>();
		application.Run(args);
	}

	private static IServiceProvider ConfigureServices()
	{
		var serviceProvider = new SimpleServiceProvider();

		serviceProvider.RegisterSingleton<ILogger>(new ConsoleLogger());
		serviceProvider.RegisterTransient<IApplicationService, ApplicationService>();

		return serviceProvider;
	}
}

public class ApplicationService : IApplicationService
{
	private readonly ILogger _logger;

	public ApplicationService(ILogger logger)
	{
		_logger = logger;
	}

	public void Run(string[] args)
	{
		var app = new Application("T4CT1CS", 1, _logger);
		app.Run(args);
	}
}

public class Application(string name, int version, ILogger logger)
{
	public string Name { get; } = name;
	public int Version { get; } = version;

	public void Run(string[] args)
	{
		logger.LogInfo($"Starting {Name} v{Version}");

		if (args is not null && args.Length > 0)
		{
			ProcessArguments(args);
		}
		else
		{
			logger.LogInfo("Hello, World!");
		}

		logger.LogInfo($"{Name} completed successfully.");
	}

	private void ProcessArguments(string[] arguments)
	{
		logger.LogDebug($"Processing {arguments.Length} arguments");

		foreach (var arg in arguments)
		{
			if (arg is not null)
			{
				logger.LogInfo($"Processing argument: {arg}");
			}
			else
			{
				logger.LogError("Encountered null argument");
			}
		}
	}
}
