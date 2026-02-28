using System;
using P4NTHE0N.C0MMON;

namespace P4NTHE0N.H0UND.Domain;

public class DecisionContext
{
	public Credential? Credential { get; set; }
	public Jackpot? Jackpot { get; set; }
	public Signal? ActiveSignal { get; set; }
	public double CurrentBalance { get; set; }
	public double CurrentGrand { get; set; }
	public double CurrentMajor { get; set; }
	public double CurrentMinor { get; set; }
	public double CurrentMini { get; set; }
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
}
