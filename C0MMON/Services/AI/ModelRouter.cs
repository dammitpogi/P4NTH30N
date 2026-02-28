using System;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

namespace P4NTHE0N.C0MMON.Services.AI;

public class ModelRouter : IModelRouter
{
	private readonly ModelRoutingConfig _config;
	private readonly HttpClient _http;

	public ModelRouter(ModelRoutingConfig? config = null)
	{
		_config = config ?? new ModelRoutingConfig();
		_http = new HttpClient { Timeout = TimeSpan.FromSeconds(_config.TimeoutSeconds) };
	}

	public string GetModelForTask(string taskName)
	{
		string[] chain = GetFallbackChain(taskName);
		return chain.Length > 0 ? chain[0] : string.Empty;
	}

	public string[] GetFallbackChain(string taskName)
	{
		if (_config.FallbackChains.TryGetValue(taskName, out string[]? chain))
			return chain;
		return Array.Empty<string>();
	}

	public async Task<bool> IsModelAvailableAsync(string modelId)
	{
		foreach (ModelEndpoint endpoint in _config.Endpoints.Values.Where(e => e.Enabled))
		{
			try
			{
				HttpResponseMessage response = await _http.GetAsync($"{endpoint.Url}/models");
				if (response.IsSuccessStatusCode)
				{
					string body = await response.Content.ReadAsStringAsync();
					if (body.Contains(modelId))
						return true;
				}
			}
			catch { }
		}
		return false;
	}

	public ModelEndpoint? GetEndpoint(string endpointName)
	{
		return _config.Endpoints.TryGetValue(endpointName, out ModelEndpoint? ep) ? ep : null;
	}
}
