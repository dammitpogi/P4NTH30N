namespace P4NTH30N.HUN7ER.Domain.Entities;

/// <summary>
/// Domain entity representing a play signal
/// </summary>
public class PlaySignal
{
	public string Id { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public string Username { get; set; } = string.Empty;
	public int Priority { get; set; }
	public DateTime Created { get; set; }
	public DateTime? Timeout { get; set; }
	public bool Acknowledged { get; set; }

	public PlaySignal() { }

	public PlaySignal(int priority, string house, string game, string username)
	{
		Priority = priority;
		House = house;
		Game = game;
		Username = username;
		Created = DateTime.UtcNow;
	}

	public bool IsExpired => Timeout.HasValue && DateTime.UtcNow > Timeout.Value;

	public bool IsHighPriority => Priority >= 3;

	public bool IsLowPriority => Priority <= 1;
}
