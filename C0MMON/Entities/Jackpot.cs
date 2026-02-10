using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using P4NTH30N.C0MMON.SanityCheck;

namespace P4NTH30N.C0MMON;

public class Jackpot {
	public ObjectId _id { get; set; }
	public double DPM { get; set; }
	public DateTime LastUpdated { get; set; }
	public DateTime EstimatedDate { get; set; }
	public required string House { get; set; }
	public required string Game { get; set; }
	public required string Category { get; set; }
	public double Current { get; set; }
	public double Threshold { get; set; }
	public int Priority { get; set; }

	[method: SetsRequiredMembers]
	public Jackpot(
		Credential credential,
		string category,
		double current,
		double threshold,
		int priority,
		DateTime eta
	) {
		Category = category;
		House = credential.House;
		Game = credential.Game;
		Priority = priority;
		DPM = credential.DPD.Average / TimeSpan.FromDays(1).TotalMinutes;
		Current = current;
		Threshold = threshold;
		_id = ObjectId.GenerateNewId();
		LastUpdated = DateTime.UtcNow;
		EstimatedDate = eta;
		double estimatedGrowth = DateTime.UtcNow.Subtract(credential.LastUpdated).TotalMinutes * DPM;

		List<DPD_Data> dataZoom = credential
			.DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddDays(-1))
			.OrderBy(x => x.Timestamp)
			.ToList();
		if (eta < DateTime.UtcNow.AddDays(3) && dataZoom.Count >= 2) {
			double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
			double dollars = dataZoom[^1].Grand - dataZoom[0].Grand;
			DPM = dollars / minutes;

			estimatedGrowth = DateTime.UtcNow.Subtract(credential.LastUpdated).TotalMinutes * DPM;
			double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / DPM, 0);
			EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
		}

		dataZoom = credential
			.DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddHours(-8))
			.OrderBy(x => x.Timestamp)
			.ToList();
		if (eta < DateTime.UtcNow.AddHours(4) && dataZoom.Count >= 2) {
			double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
			double dollars = dataZoom[^1].Grand - dataZoom[0].Grand;
			DPM = dollars / minutes;

			estimatedGrowth = DateTime.UtcNow.Subtract(credential.LastUpdated).TotalMinutes * DPM;
			double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / DPM, 0);
			EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
		}

		Current = current + estimatedGrowth;
	}
}
