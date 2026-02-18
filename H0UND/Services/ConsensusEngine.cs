using System;
using System.Collections.Generic;
using System.Linq;
using P4NTH30N.H0UND.Domain;

namespace P4NTH30N.H0UND.Services;

public class ConsensusEngine
{
	private readonly double _confidenceThreshold;

	public ConsensusEngine(double confidenceThreshold = 0.6)
	{
		_confidenceThreshold = confidenceThreshold;
	}

	public Decision? Evaluate(List<Decision> candidates)
	{
		if (candidates.Count == 0)
			return null;

		IGrouping<DecisionType, Decision>? majority = candidates
			.GroupBy(d => d.Type)
			.OrderByDescending(g => g.Count())
			.ThenByDescending(g => g.Average(d => d.Confidence))
			.FirstOrDefault();

		if (majority == null)
			return null;

		double consensusConfidence = (double)majority.Count() / candidates.Count;
		double avgConfidence = majority.Average(d => d.Confidence);

		if (consensusConfidence < _confidenceThreshold)
		{
			return new Decision
			{
				Type = DecisionType.Skip,
				Confidence = consensusConfidence,
				Rationale = new DecisionRationale
				{
					Summary = $"No consensus reached ({consensusConfidence:P0})",
					Factors = candidates.Select(d => $"{d.Type}: {d.Confidence:F2}").ToList(),
					TriggeredBy = "ConsensusEngine",
				},
			};
		}

		Decision best = majority.OrderByDescending(d => d.Confidence).First();
		best.Confidence = avgConfidence * consensusConfidence;
		best.Rationale.TriggeredBy = "ConsensusEngine";
		best.Rationale.Factors.Add($"Consensus: {majority.Count()}/{candidates.Count} agree on {best.Type}");

		return best;
	}
}
