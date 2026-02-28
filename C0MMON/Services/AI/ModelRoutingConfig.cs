using System.Collections.Generic;

namespace P4NTHE0N.C0MMON.Services.AI;

public class ModelRoutingConfig
{
	public string DefaultEndpoint { get; set; } = "http://localhost:1234";
	public int TimeoutSeconds { get; set; } = 30;
	public int MaxRetries { get; set; } = 2;
	public Dictionary<string, ModelEndpoint> Endpoints { get; set; } =
		new()
		{
			["lmstudio"] = new ModelEndpoint { Url = "http://localhost:1234/v1", Provider = "LMStudio" },
			["ollama"] = new ModelEndpoint { Url = "http://localhost:11434/api", Provider = "Ollama" },
		};
	public Dictionary<string, string[]> FallbackChains { get; set; } =
		new()
		{
			["vision"] = new[] { "llava-v1.6-mistral-7b", "llava-phi-3-mini", "moondream2" },
			["analysis"] = new[] { "mistral-7b-instruct", "phi-3-mini" },
			["ocr"] = new[] { "llava-phi-3-mini", "moondream2" },
		};
}

public class ModelEndpoint
{
	public string Url { get; set; } = string.Empty;
	public string Provider { get; set; } = string.Empty;
	public string? ApiKey { get; set; }
	public bool Enabled { get; set; } = true;
}
