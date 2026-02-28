using System;
using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.UNI7T35T.H4ND.Decision110;

/// <summary>
/// DECISION_110: Unit tests for Guard fail-fast invariants.
/// </summary>
public static class GuardTests
{
	public static (int passed, int failed) RunAll()
	{
		int passed = 0, failed = 0;

		void Run(string name, Func<bool> test)
		{
			try
			{
				if (test()) { passed++; Console.WriteLine($"  ✅ {name}"); }
				else { failed++; Console.WriteLine($"  ❌ {name} — returned false"); }
			}
			catch (Exception ex) { failed++; Console.WriteLine($"  ❌ {name} — {ex.GetType().Name}: {ex.Message}"); }
		}

		// GRD-001: NotNullOrWhiteSpace rejects null
		Run("GRD-001 NotNullOrWhiteSpace_Null", () =>
		{
			try { Guard.NotNullOrWhiteSpace(null); return false; }
			catch (ArgumentException) { return true; }
		});

		// GRD-002: NotNullOrWhiteSpace rejects empty
		Run("GRD-002 NotNullOrWhiteSpace_Empty", () =>
		{
			try { Guard.NotNullOrWhiteSpace(""); return false; }
			catch (ArgumentException) { return true; }
		});

		// GRD-003: NotNullOrWhiteSpace rejects whitespace
		Run("GRD-003 NotNullOrWhiteSpace_Whitespace", () =>
		{
			try { Guard.NotNullOrWhiteSpace("   "); return false; }
			catch (ArgumentException) { return true; }
		});

		// GRD-004: NotNullOrWhiteSpace passes valid string
		Run("GRD-004 NotNullOrWhiteSpace_Valid", () =>
		{
			return Guard.NotNullOrWhiteSpace("hello") == "hello";
		});

		// GRD-005: NotNull rejects null
		Run("GRD-005 NotNull_Null", () =>
		{
			try { Guard.NotNull<string>(null); return false; }
			catch (ArgumentNullException) { return true; }
		});

		// GRD-006: NotNull passes non-null
		Run("GRD-006 NotNull_Valid", () =>
		{
			var obj = new object();
			return Guard.NotNull(obj) == obj;
		});

		// GRD-007: NotDefault rejects default Guid
		Run("GRD-007 NotDefault_DefaultGuid", () =>
		{
			try { Guard.NotDefault(Guid.Empty); return false; }
			catch (ArgumentException) { return true; }
		});

		// GRD-008: NotDefault passes non-default
		Run("GRD-008 NotDefault_ValidGuid", () =>
		{
			var g = Guid.NewGuid();
			return Guard.NotDefault(g).Equals(g);
		});

		// GRD-009: Positive rejects zero
		Run("GRD-009 Positive_Zero", () =>
		{
			try { Guard.Positive(0); return false; }
			catch (ArgumentOutOfRangeException) { return true; }
		});

		// GRD-010: Positive rejects negative
		Run("GRD-010 Positive_Negative", () =>
		{
			try { Guard.Positive(-5); return false; }
			catch (ArgumentOutOfRangeException) { return true; }
		});

		// GRD-011: Positive passes valid
		Run("GRD-011 Positive_Valid", () =>
		{
			return Guard.Positive(42) == 42;
		});

		// GRD-012: NonNegative rejects negative
		Run("GRD-012 NonNegative_Negative", () =>
		{
			try { Guard.NonNegative(-1); return false; }
			catch (ArgumentOutOfRangeException) { return true; }
		});

		// GRD-013: NonNegative passes zero
		Run("GRD-013 NonNegative_Zero", () =>
		{
			return Guard.NonNegative(0) == 0;
		});

		// GRD-014: InRange rejects below min
		Run("GRD-014 InRange_BelowMin", () =>
		{
			try { Guard.InRange(-1.0, 0.0, 100.0); return false; }
			catch (ArgumentOutOfRangeException) { return true; }
		});

		// GRD-015: InRange rejects above max
		Run("GRD-015 InRange_AboveMax", () =>
		{
			try { Guard.InRange(101.0, 0.0, 100.0); return false; }
			catch (ArgumentOutOfRangeException) { return true; }
		});

		// GRD-016: InRange passes valid
		Run("GRD-016 InRange_Valid", () =>
		{
			return Guard.InRange(50.0, 0.0, 100.0) == 50.0;
		});

		// GRD-017: NotMinValue rejects DateTime.MinValue
		Run("GRD-017 NotMinValue_MinValue", () =>
		{
			try { Guard.NotMinValue(DateTime.MinValue); return false; }
			catch (ArgumentException) { return true; }
		});

		// GRD-018: NotEmpty rejects Guid.Empty
		Run("GRD-018 NotEmpty_GuidEmpty", () =>
		{
			try { Guard.NotEmpty(Guid.Empty); return false; }
			catch (ArgumentException) { return true; }
		});

		// GRD-019: MaxLength rejects too long
		Run("GRD-019 MaxLength_TooLong", () =>
		{
			try { Guard.MaxLength(new string('x', 200), 100); return false; }
			catch (ArgumentException) { return true; }
		});

		// GRD-020: MaxLength passes valid
		Run("GRD-020 MaxLength_Valid", () =>
		{
			return Guard.MaxLength("short", 100) == "short";
		});

		return (passed, failed);
	}
}
