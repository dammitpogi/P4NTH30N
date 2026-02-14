using P4NTH30N.HUN7ER.Domain.Entities;
using P4NTH30N.HUN7ER.Domain.Services;
using P4NTH30N.HUN7ER.Domain.ValueObjects;

namespace P4NTH30N.HUN7ER.Application.UseCases;

/// <summary>
/// Use case for generating jackpot predictions
/// </summary>
public class GeneratePredictionsUseCase
{
	private readonly PredictionService _predictionService = new();

	/// <summary>
	/// Generates predictions for all enabled credentials
	/// </summary>
	public List<GeneratePredictionResult> Execute(IEnumerable<GameCredential> credentials, DateTime dateLimit)
	{
		var results = new List<GeneratePredictionResult>();

		foreach (var credential in credentials)
		{
			var result = new GeneratePredictionResult
			{
				CredentialId = credential.Id,
				House = credential.House,
				Game = credential.Game,
			};

			try
			{
				// Check statistical reliability
				if (!credential.IsStatisticallyReliable())
				{
					result.Excluded = true;
					result.ExclusionReason = "Insufficient data points for high DPD";
					results.Add(result);
					continue;
				}

				// Check if DPD is sufficient for predictions
				if (credential.DPD.Average <= 0.01)
				{
					result.Excluded = true;
					result.ExclusionReason = "DPD too low";
					results.Add(result);
					continue;
				}

				// Generate base predictions
				var predictions = _predictionService.GeneratePredictions(credential, dateLimit);

				// Generate projected predictions for each
				foreach (var prediction in predictions)
				{
					var projections = _predictionService.ProjectPredictions(prediction, credential.DPD.Average, dateLimit);
					result.Predictions.Add(prediction);
					result.Predictions.AddRange(projections);
				}

				result.Success = true;
			}
			catch (Exception ex)
			{
				result.Success = false;
				result.ErrorMessage = ex.Message;
			}

			results.Add(result);
		}

		return results;
	}

	/// <summary>
	/// Filters out predictions for disabled games
	/// </summary>
	public List<JackpotPrediction> FilterBySettings(IEnumerable<JackpotPrediction> predictions, GameCredential credential)
	{
		return predictions
			.Where(p =>
			{
				var tier = p.Tier;
				return tier switch
				{
					JackpotTier.Grand => credential.SpinGrand,
					JackpotTier.Major => credential.SpinMajor,
					JackpotTier.Minor => credential.SpinMinor,
					JackpotTier.Mini => credential.SpinMini,
					_ => false,
				};
			})
			.ToList();
	}
}

public class GeneratePredictionResult
{
	public string CredentialId { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public bool Success { get; set; }
	public bool Excluded { get; set; }
	public string ExclusionReason { get; set; } = string.Empty;
	public string ErrorMessage { get; set; } = string.Empty;
	public List<JackpotPrediction> Predictions { get; set; } = new();
}
