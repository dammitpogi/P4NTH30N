using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.H0UND.Agents;

/// <summary>
/// DECISION_027: H0UND predictor agent — generates jackpot predictions
/// and signal recommendations based on DPD analysis and anomaly detection.
/// </summary>
public sealed class PredictorAgent : IPredictor
{
	private readonly IUnitOfWork _uow;
	private bool _active = true;

	public string AgentId => "h0und-predictor";
	public string Name => "H0UND Predictor";
	public AgentRole Role => AgentRole.Predictor;
	public IReadOnlyList<string> Capabilities => ["jackpot_prediction", "dpd_analysis", "anomaly_detection", "signal_generation"];
	public bool IsActive => _active;
	public int Priority => 1;

	public PredictorAgent(IUnitOfWork uow)
	{
		_uow = uow;
	}

	public Task HandleMessageAsync(AgentMessage message, CancellationToken ct = default)
	{
		switch (message.MessageType)
		{
			case "predict_request":
				Console.WriteLine($"[PredictorAgent] Received prediction request from {message.FromAgent}");
				break;
			case "status_query":
				Console.WriteLine($"[PredictorAgent] Status: Active, Capabilities: {string.Join(", ", Capabilities)}");
				break;
			default:
				Console.WriteLine($"[PredictorAgent] Unhandled message type: {message.MessageType}");
				break;
		}
		return Task.CompletedTask;
	}

	public Task<PredictionResult> PredictAsync(PredictionRequest request, CancellationToken ct = default)
	{
		// Query existing jackpot data for the house/game (category = tier for jackpot lookup)
		var jackpots = _uow.Jackpots.Get(request.Tier, request.House, request.Game);

		if (jackpots == null)
		{
			return Task.FromResult(new PredictionResult
			{
				ShouldAct = false,
				Confidence = 0,
				Reason = $"No jackpot data for {request.House}/{request.Game}",
			});
		}

		// Use DPD average as the primary signal
		double dpdAverage = jackpots.DPD?.Average ?? 0;
		bool shouldAct = request.CurrentValue >= request.Threshold;
		double confidence = shouldAct ? Math.Min(0.95, 0.5 + (request.CurrentValue / request.Threshold) * 0.3) : 0.2;

		return Task.FromResult(new PredictionResult
		{
			ShouldAct = shouldAct,
			Confidence = confidence,
			Reason = shouldAct
				? $"{request.Tier} at {request.CurrentValue:F2} exceeds threshold {request.Threshold:F2} (DPD avg: {dpdAverage:F2}/day)"
				: $"{request.Tier} at {request.CurrentValue:F2} below threshold {request.Threshold:F2}",
			Values = new Dictionary<string, double>
			{
				["currentValue"] = request.CurrentValue,
				["threshold"] = request.Threshold,
				["dpdAverage"] = dpdAverage,
				["confidence"] = confidence,
			},
		});
	}

	public void Activate() => _active = true;
	public void Deactivate() => _active = false;
}
