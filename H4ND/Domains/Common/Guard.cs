using System;
using System.Diagnostics.CodeAnalysis;
using System.Runtime.CompilerServices;

namespace P4NTH30N.H4ND.Domains.Common;

/// <summary>
/// DECISION_110 Phase 1: Fail-fast invariant guard.
/// All domain primitives pass through Guard before construction.
/// </summary>
public static class Guard
{
	public static string NotNullOrWhiteSpace(
		[NotNull] string? value,
		[CallerArgumentExpression(nameof(value))] string? paramName = null)
	{
		if (string.IsNullOrWhiteSpace(value))
			throw new ArgumentException($"Value cannot be null or whitespace.", paramName);
		return value;
	}

	public static T NotNull<T>(
		[NotNull] T? value,
		[CallerArgumentExpression(nameof(value))] string? paramName = null) where T : class
	{
		if (value is null)
			throw new ArgumentNullException(paramName);
		return value;
	}

	public static T NotDefault<T>(
		T value,
		[CallerArgumentExpression(nameof(value))] string? paramName = null) where T : struct, IEquatable<T>
	{
		if (value.Equals(default))
			throw new ArgumentException($"Value cannot be default.", paramName);
		return value;
	}

	public static int Positive(
		int value,
		[CallerArgumentExpression(nameof(value))] string? paramName = null)
	{
		if (value <= 0)
			throw new ArgumentOutOfRangeException(paramName, value, "Value must be positive.");
		return value;
	}

	public static int NonNegative(
		int value,
		[CallerArgumentExpression(nameof(value))] string? paramName = null)
	{
		if (value < 0)
			throw new ArgumentOutOfRangeException(paramName, value, "Value must be non-negative.");
		return value;
	}

	public static double InRange(
		double value,
		double min,
		double max,
		[CallerArgumentExpression(nameof(value))] string? paramName = null)
	{
		if (value < min || value > max)
			throw new ArgumentOutOfRangeException(paramName, value, $"Value must be between {min} and {max}.");
		return value;
	}

	public static DateTime NotMinValue(
		DateTime value,
		[CallerArgumentExpression(nameof(value))] string? paramName = null)
	{
		if (value == DateTime.MinValue)
			throw new ArgumentException("DateTime cannot be MinValue.", paramName);
		return value;
	}

	public static Guid NotEmpty(
		Guid value,
		[CallerArgumentExpression(nameof(value))] string? paramName = null)
	{
		if (value == Guid.Empty)
			throw new ArgumentException("Guid cannot be empty.", paramName);
		return value;
	}

	public static string MaxLength(
		string value,
		int maxLength,
		[CallerArgumentExpression(nameof(value))] string? paramName = null)
	{
		NotNullOrWhiteSpace(value, paramName);
		if (value.Length > maxLength)
			throw new ArgumentException($"Value length {value.Length} exceeds maximum {maxLength}.", paramName);
		return value;
	}
}
