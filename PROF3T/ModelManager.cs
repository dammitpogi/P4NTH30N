using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using P4NTHE0N.PROF3T.Configuration;

namespace P4NTHE0N.PROF3T;

public class ModelManager : IModelManager, IModelRegistry
{
	private readonly ConcurrentDictionary<string, ModelInstance> _models = new();
	private readonly ModelCacheConfig _cacheConfig;
	private readonly HttpClient _http;

	public ModelManager(ModelCacheConfig? cacheConfig = null)
	{
		_cacheConfig = cacheConfig ?? new ModelCacheConfig();
		_http = new HttpClient { Timeout = TimeSpan.FromSeconds(10) };
	}

	public Task<ModelInstance?> GetModelAsync(string modelId)
	{
		ModelInstance? instance = _models.TryGetValue(modelId, out ModelInstance? m) ? m : null;
		if (instance != null)
			instance.LastUsed = DateTime.UtcNow;
		return Task.FromResult(instance);
	}

	public async Task<bool> LoadModelAsync(string modelId, string endpointUrl)
	{
		if (_models.ContainsKey(modelId))
			return true;

		ModelInstance instance = new ModelInstance
		{
			ModelId = modelId,
			EndpointUrl = endpointUrl,
			State = ModelState.Loading,
			LoadedAt = DateTime.UtcNow,
			LastUsed = DateTime.UtcNow,
		};

		_models[modelId] = instance;

		try
		{
			HttpResponseMessage response = await _http.GetAsync($"{endpointUrl}/v1/models");
			if (response.IsSuccessStatusCode)
			{
				string body = await response.Content.ReadAsStringAsync();
				if (body.Contains(modelId))
				{
					instance.State = ModelState.Ready;
					return true;
				}
			}

			instance.State = ModelState.Error;
			return false;
		}
		catch
		{
			instance.State = ModelState.Error;
			return false;
		}
	}

	public Task UnloadModelAsync(string modelId)
	{
		if (_models.TryRemove(modelId, out _))
		{
			Console.WriteLine($"[ModelManager] Unloaded model: {modelId}");
		}
		return Task.CompletedTask;
	}

	public IReadOnlyList<ModelInstance> GetLoadedModels()
	{
		return _models.Values.Where(m => m.State == ModelState.Ready).ToList();
	}

	public async Task<bool> IsHealthyAsync()
	{
		List<ModelInstance> readyModels = _models.Values.Where(m => m.State == ModelState.Ready).ToList();
		if (readyModels.Count == 0)
			return true;

		foreach (ModelInstance model in readyModels)
		{
			try
			{
				HttpResponseMessage response = await _http.GetAsync($"{model.EndpointUrl}/v1/models");
				if (!response.IsSuccessStatusCode)
					return false;
			}
			catch
			{
				return false;
			}
		}
		return true;
	}

	public void Register(string modelId, ModelInstance instance)
	{
		_models[modelId] = instance;
	}

	public void Unregister(string modelId)
	{
		_models.TryRemove(modelId, out _);
	}

	public ModelInstance? Get(string modelId)
	{
		return _models.TryGetValue(modelId, out ModelInstance? m) ? m : null;
	}

	IReadOnlyList<ModelInstance> IModelRegistry.GetAll()
	{
		return _models.Values.ToList();
	}

	public bool Contains(string modelId)
	{
		return _models.ContainsKey(modelId);
	}

	public void EvictLeastRecentlyUsed()
	{
		ModelInstance? lru = _models.Values.Where(m => m.State == ModelState.Ready && m.ActiveRequests == 0).OrderBy(m => m.LastUsed).FirstOrDefault();

		if (lru != null)
		{
			_models.TryRemove(lru.ModelId, out _);
			Console.WriteLine($"[ModelManager] Evicted LRU model: {lru.ModelId}");
		}
	}
}
