using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G;

public class LMStudioClient : ILMStudioClient
{
	private readonly HttpClient _http;
	private readonly string _baseUrl;

	public LMStudioClient(string baseUrl = "http://localhost:1234")
	{
		_baseUrl = baseUrl.TrimEnd('/');
		_http = new HttpClient { Timeout = TimeSpan.FromSeconds(30) };
	}

	public async Task<VisionAnalysis> AnalyzeFrameAsync(VisionFrame frame, string modelId)
	{
		Stopwatch sw = Stopwatch.StartNew();
		string base64Image = Convert.ToBase64String(frame.Data);

		object payload = new
		{
			model = modelId,
			messages = new[]
			{
				new
				{
					role = "user",
					content = new object[]
					{
						new
						{
							type = "text",
							text = "Analyze this game screenshot. Extract: jackpot values (Grand, Major, Minor, Mini), player balance, and current game state (idle/spinning/bonus/error). Respond in JSON format.",
						},
						new { type = "image_url", image_url = new { url = $"data:image/png;base64,{base64Image}" } },
					},
				},
			},
			max_tokens = 500,
			temperature = 0.1,
		};

		string json = JsonSerializer.Serialize(payload);
		HttpResponseMessage response = await _http.PostAsync($"{_baseUrl}/v1/chat/completions", new StringContent(json, Encoding.UTF8, "application/json"));

		sw.Stop();
		string responseBody = await response.Content.ReadAsStringAsync();

		VisionAnalysis analysis = new VisionAnalysis
		{
			ModelUsed = modelId,
			InferenceTimeMs = sw.ElapsedMilliseconds,
			Timestamp = DateTime.UtcNow,
		};

		try
		{
			using JsonDocument doc = JsonDocument.Parse(responseBody);
			JsonElement choices = doc.RootElement.GetProperty("choices");
			string? content = choices[0].GetProperty("message").GetProperty("content").GetString();

			if (content != null)
			{
				analysis = ParseAnalysisResponse(content, analysis);
			}
		}
		catch (Exception ex)
		{
			analysis.ErrorDetected = true;
			analysis.ErrorMessage = $"Parse error: {ex.Message}";
		}

		return analysis;
	}

	public async Task<bool> IsAvailableAsync()
	{
		try
		{
			HttpResponseMessage response = await _http.GetAsync($"{_baseUrl}/v1/models");
			return response.IsSuccessStatusCode;
		}
		catch
		{
			return false;
		}
	}

	public async Task<List<string>> GetLoadedModelsAsync()
	{
		List<string> models = new List<string>();
		try
		{
			HttpResponseMessage response = await _http.GetAsync($"{_baseUrl}/v1/models");
			string body = await response.Content.ReadAsStringAsync();
			using JsonDocument doc = JsonDocument.Parse(body);
			foreach (JsonElement model in doc.RootElement.GetProperty("data").EnumerateArray())
			{
				string? id = model.GetProperty("id").GetString();
				if (id != null)
					models.Add(id);
			}
		}
		catch { }
		return models;
	}

	private static VisionAnalysis ParseAnalysisResponse(string content, VisionAnalysis analysis)
	{
		try
		{
			int jsonStart = content.IndexOf('{');
			int jsonEnd = content.LastIndexOf('}');
			if (jsonStart >= 0 && jsonEnd > jsonStart)
			{
				string jsonStr = content.Substring(jsonStart, jsonEnd - jsonStart + 1);
				using JsonDocument parsed = JsonDocument.Parse(jsonStr);
				JsonElement root = parsed.RootElement;

				if (root.TryGetProperty("grand", out JsonElement grand))
					analysis.ExtractedJackpots["Grand"] = grand.GetDouble();
				if (root.TryGetProperty("major", out JsonElement major))
					analysis.ExtractedJackpots["Major"] = major.GetDouble();
				if (root.TryGetProperty("minor", out JsonElement minor))
					analysis.ExtractedJackpots["Minor"] = minor.GetDouble();
				if (root.TryGetProperty("mini", out JsonElement mini))
					analysis.ExtractedJackpots["Mini"] = mini.GetDouble();
				if (root.TryGetProperty("balance", out JsonElement balance))
					analysis.ExtractedBalance = balance.GetDouble();
				if (root.TryGetProperty("state", out JsonElement state))
				{
					string? stateStr = state.GetString();
					analysis.GameState = stateStr?.ToLowerInvariant() switch
					{
						"spinning" => AnimationState.Spinning,
						"bonus" => AnimationState.Bonus,
						"error" => AnimationState.Error,
						_ => AnimationState.Idle,
					};
				}

				analysis.Confidence = 0.85;
			}
		}
		catch
		{
			analysis.ErrorDetected = true;
			analysis.ErrorMessage = "Failed to parse model JSON response";
		}

		return analysis;
	}
}
