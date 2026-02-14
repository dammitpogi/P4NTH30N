using P4NTH30N.HUN7ER.Domain.Entities;
using P4NTH30N.HUN7ER.Domain.ValueObjects;

namespace P4NTH30N.HUN7ER.Application.UseCases;

/// <summary>
/// Use case for generating play signals based on predictions
/// </summary>
public class CreateSignalsUseCase
{
	/// <summary>
	/// Creates signals for due jackpots
	/// </summary>
	public List<CreateSignalResult> Execute(IEnumerable<JackpotPrediction> predictions, IEnumerable<GameCredential> credentials, IEnumerable<PlaySignal> existingSignals)
	{
		var results = new List<CreateSignalResult>();
		var existingSignalLookup = existingSignals.ToLookup(s => (s.House, s.Game, s.Username));
		var credentialLookup = credentials.ToLookup(c => (c.House, c.Game));

		foreach (var prediction in predictions)
		{
			var result = new CreateSignalResult
			{
				PredictionId = prediction.Id,
				House = prediction.House,
				Game = prediction.Game,
				Category = prediction.Category,
				Priority = prediction.Priority,
			};

			try
			{
				// Get credentials for this game
				var gameCredentials = credentialLookup[(prediction.House, prediction.Game)].ToList();
				if (!gameCredentials.Any())
				{
					result.Skipped = true;
					result.SkipReason = "No credentials found";
					results.Add(result);
					continue;
				}

				// Check if signals are due
				double avgBalance = gameCredentials.Where(c => c.Enabled && !c.Banned && !c.CashedOut).Average(c => c.Balance);
				if (!prediction.IsDue(DateTime.UtcNow, 0, avgBalance))
				{
					result.Skipped = true;
					result.SkipReason = "Not yet due";
					results.Add(result);
					continue;
				}

				// Create signals for eligible credentials
				foreach (var credential in gameCredentials.Where(c => c.Enabled && !c.Banned && !c.CashedOut))
				{
					var existingForCred = existingSignalLookup[(credential.House, credential.Game, credential.Username)].FirstOrDefault();

					var signal = new PlaySignal(prediction.Priority, credential.House, credential.Game, credential.Username)
					{
						Timeout = DateTime.UtcNow.AddSeconds(30),
						Acknowledged = true,
					};

					if (existingForCred == null)
					{
						result.NewSignals.Add(signal);
					}
					else if (signal.Priority > existingForCred.Priority)
					{
						signal.Acknowledged = existingForCred.Acknowledged;
						result.UpdatedSignals.Add(signal);
					}
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
	/// Cleans up stale signals that are no longer valid
	/// </summary>
	public List<PlaySignal> CleanupStaleSignals(IEnumerable<PlaySignal> signals, IEnumerable<JackpotPrediction> validPredictions)
	{
		var toDelete = new List<PlaySignal>();

		var validLookup = validPredictions.ToLookup(p => (p.House, p.Game, p.Priority));

		foreach (var signal in signals)
		{
			var hasValidPrediction = validLookup[(signal.House, signal.Game, signal.Priority)].Any();
			if (!hasValidPrediction)
			{
				toDelete.Add(signal);
			}
			else if (signal.Acknowledged && signal.IsExpired)
			{
				signal.Acknowledged = false;
			}
		}

		return toDelete;
	}
}

public class CreateSignalResult
{
	public string PredictionId { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public string Category { get; set; } = string.Empty;
	public int Priority { get; set; }
	public bool Success { get; set; }
	public bool Skipped { get; set; }
	public string SkipReason { get; set; } = string.Empty;
	public string ErrorMessage { get; set; } = string.Empty;
	public List<PlaySignal> NewSignals { get; set; } = new();
	public List<PlaySignal> UpdatedSignals { get; set; } = new();
}
