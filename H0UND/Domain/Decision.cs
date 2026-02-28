using System;
using System.Collections.Generic;

namespace P4NTHE0N.H0UND.Domain;

public enum DecisionType
{
	Signal,
	Spin,
	CashOut,
	Skip,
	Escalate,
}

public class Decision
{
	public string Id { get; set; } = Guid.NewGuid().ToString();
	public DecisionType Type { get; set; }
	public string TargetHouse { get; set; } = string.Empty;
	public string TargetGame { get; set; } = string.Empty;
	public string TargetUsername { get; set; } = string.Empty;
	public double Confidence { get; set; }
	public DecisionRationale Rationale { get; set; } = new();
	public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
	public bool Executed { get; set; }
	public DateTime? ExecutedAt { get; set; }
}
