using Microsoft.Extensions.Configuration;

namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public sealed class ErrorEvidenceOptions
{
	public bool Enabled { get; init; } = true;
	public string Collection { get; init; } = "_debug";
	public int RetentionDays { get; init; } = 14;
	public int MaxEvidenceBytes { get; init; } = 32768;
	public int QueueCapacity { get; init; } = 10000;
	public int BatchSize { get; init; } = 100;
	public int FlushIntervalMs { get; init; } = 100;
	public int SummaryIntervalSeconds { get; init; } = 30;
	public bool CaptureStack { get; init; } = true;
	public bool CaptureBeforeAfter { get; init; } = true;
	public double WarningSamplingRate { get; init; } = 0.25;
	public double InfoSamplingRate { get; init; } = 0.10;
	public double DebugSamplingRate { get; init; } = 0.05;
	public Dictionary<string, double> ComponentSampling { get; init; } = new(StringComparer.OrdinalIgnoreCase);
	public string[] SecretKeyPatterns { get; init; } =
	[
		"password",
		"passwd",
		"pwd",
		"token",
		"cookie",
		"sessionsecret",
		"session_secret",
		"authorization",
		"auth",
		"apikey",
		"api_key",
		"secret",
	];

	public double GetSamplingRate(string component, ErrorSeverity severity)
	{
		if (severity is ErrorSeverity.Critical or ErrorSeverity.Error)
		{
			return 1.0;
		}

		if (ComponentSampling.TryGetValue(component, out double componentRate))
		{
			return NormalizeRate(componentRate);
		}

		return severity switch
		{
			ErrorSeverity.Warning => NormalizeRate(WarningSamplingRate),
			ErrorSeverity.Info => NormalizeRate(InfoSamplingRate),
			ErrorSeverity.Debug => NormalizeRate(DebugSamplingRate),
			_ => 1.0,
		};
	}

	public static ErrorEvidenceOptions FromConfiguration(IConfiguration? section)
	{
		if (section == null)
		{
			return new ErrorEvidenceOptions();
		}

		var options = new ErrorEvidenceOptions
		{
			Enabled = section.GetValue("Enabled", true),
			Collection = section.GetValue("Collection", "_debug") ?? "_debug",
			RetentionDays = section.GetValue("RetentionDays", 14),
			MaxEvidenceBytes = section.GetValue("MaxEvidenceBytes", 32768),
			QueueCapacity = section.GetValue("QueueCapacity", 10000),
			BatchSize = section.GetValue("BatchSize", 100),
			FlushIntervalMs = section.GetValue("FlushIntervalMs", 100),
			SummaryIntervalSeconds = section.GetValue("SummaryIntervalSeconds", 30),
			CaptureStack = section.GetValue("CaptureStack", true),
			CaptureBeforeAfter = section.GetValue("CaptureBeforeAfter", true),
			WarningSamplingRate = section.GetValue("Sampling:Warning", 0.25),
			InfoSamplingRate = section.GetValue("Sampling:Info", 0.10),
			DebugSamplingRate = section.GetValue("Sampling:Debug", 0.05),
		};

		foreach (IConfigurationSection child in section.GetSection("Sampling:Components").GetChildren())
		{
			if (double.TryParse(child.Value, out double rate))
			{
				options.ComponentSampling[child.Key] = NormalizeRate(rate);
			}
		}

		return options;
	}

	private static double NormalizeRate(double rate)
	{
		if (rate < 0) return 0;
		if (rate > 1) return 1;
		return rate;
	}
}
