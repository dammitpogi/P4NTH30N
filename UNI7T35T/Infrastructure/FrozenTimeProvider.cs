using System;

namespace P4NTHE0N.UNI7T35T.Infrastructure;

// DECISION_086: Deterministic time provider for reproducible testing
// Based on Klee & Xia (2025) recommendation for deterministic testing
public class FrozenTimeProvider
{
	private DateTime _frozenTime;

	public DateTime UtcNow => _frozenTime;

	public FrozenTimeProvider(DateTime frozenTime)
	{
		_frozenTime = frozenTime;
	}

	public void Advance(TimeSpan duration) =>
		_frozenTime = _frozenTime.Add(duration);

	public void Set(DateTime time) =>
		_frozenTime = time;

	// Factory for common test scenarios
	public static FrozenTimeProvider AtNow() =>
		new FrozenTimeProvider(DateTime.UtcNow);

	public static FrozenTimeProvider At(int year, int month, int day, int hour = 0, int minute = 0) =>
		new FrozenTimeProvider(new DateTime(year, month, day, hour, minute, 0, DateTimeKind.Utc));
}
