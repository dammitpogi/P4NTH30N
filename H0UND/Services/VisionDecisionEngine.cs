using System;
using System.Collections.Generic;
using P4NTH30N.H0UND.Domain;
using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.H0UND.Services;

public class VisionDecisionEngine
{
	public Decision Evaluate(DecisionContext context, VisionAnalysis? visionAnalysis)
	{
		List<string> factors = new List<string>();

		if (context.Credential == null || context.Jackpot == null)
		{
			return new Decision
			{
				Type = DecisionType.Skip,
				Confidence = 1.0,
				Rationale = new DecisionRationale { Summary = "Missing context data", TriggeredBy = "VisionDecisionEngine" },
			};
		}

		double proximity = context.Jackpot.Threshold > 0 ? context.Jackpot.Current / context.Jackpot.Threshold : 0;
		factors.Add($"Threshold proximity: {proximity:P0}");

		if (visionAnalysis != null)
		{
			factors.Add($"Vision state: {visionAnalysis.GameState} (confidence: {visionAnalysis.Confidence:F2})");

			if (visionAnalysis.ErrorDetected)
			{
				return new Decision
				{
					Type = DecisionType.Escalate,
					TargetHouse = context.Credential.House ?? string.Empty,
					TargetGame = context.Credential.Game,
					TargetUsername = context.Credential.Username ?? string.Empty,
					Confidence = 0.9,
					Rationale = new DecisionRationale
					{
						Summary = $"Vision error: {visionAnalysis.ErrorMessage}",
						Factors = factors,
						ThresholdProximity = proximity,
						TriggeredBy = "VisionDecisionEngine",
					},
				};
			}
		}

		if (context.ActiveSignal != null)
		{
			factors.Add("Active signal present");
			return new Decision
			{
				Type = DecisionType.Spin,
				TargetHouse = context.Credential.House ?? string.Empty,
				TargetGame = context.Credential.Game,
				TargetUsername = context.Credential.Username ?? string.Empty,
				Confidence = 0.85,
				Rationale = new DecisionRationale
				{
					Summary = "Signal active - recommend spin",
					Factors = factors,
					ThresholdProximity = proximity,
					DPDAverage = context.Jackpot.DPD.Average,
					TriggeredBy = "VisionDecisionEngine",
				},
			};
		}

		if (proximity >= 0.95 && context.CurrentBalance >= 4)
		{
			factors.Add($"Balance sufficient: ${context.CurrentBalance:F2}");
			return new Decision
			{
				Type = DecisionType.Signal,
				TargetHouse = context.Credential.House ?? string.Empty,
				TargetGame = context.Credential.Game,
				TargetUsername = context.Credential.Username ?? string.Empty,
				Confidence = proximity * 0.9,
				Rationale = new DecisionRationale
				{
					Summary = $"Jackpot at {proximity:P0} of threshold",
					Factors = factors,
					ThresholdProximity = proximity,
					DPDAverage = context.Jackpot.DPD.Average,
					TriggeredBy = "VisionDecisionEngine",
				},
			};
		}

		return new Decision
		{
			Type = DecisionType.Skip,
			Confidence = 1.0 - proximity,
			Rationale = new DecisionRationale
			{
				Summary = $"Not yet ready ({proximity:P0} of threshold)",
				Factors = factors,
				ThresholdProximity = proximity,
				DPDAverage = context.Jackpot.DPD.Average,
				TriggeredBy = "VisionDecisionEngine",
			},
		};
	}
}
