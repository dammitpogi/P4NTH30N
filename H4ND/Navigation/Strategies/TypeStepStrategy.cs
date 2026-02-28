using P4NTHE0N.H4ND.Infrastructure;

namespace P4NTHE0N.H4ND.Navigation.Strategies;

/// <summary>
/// ARCH-098: Executes a type action using CdpGameActions.TypeIntoCanvasAsync (6-strategy fallback).
/// Resolves input text from context variables (username/password substitution).
/// </summary>
public sealed class TypeStepStrategy : IStepStrategy
{
	public string ActionType => "type";

	public async Task ExecuteAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct)
	{
		string text = ResolveText(step, context);
		if (string.IsNullOrEmpty(text))
		{
			throw new InvalidOperationException(
				$"Step {step.StepId}: Type action has empty input after credential resolution. " +
				$"Check that step configuration includes valid input or context has username/password. " +
				$"Phase={step.Phase}, Comment={step.Comment}");
		}

		// Mask password in logs
		bool isPassword = step.Phase.Equals("Login", StringComparison.OrdinalIgnoreCase)
			&& (step.Comment.Contains("password", StringComparison.OrdinalIgnoreCase)
				|| step.Verification.EntryGate.Contains("Password", StringComparison.OrdinalIgnoreCase));
		string masked = isPassword ? new string('*', text.Length) : text;

		Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Type '{masked}' — step {step.StepId}: {step.Comment}");

		// Use the proven 6-strategy Canvas typing from CdpGameActions (ARCH-081)
		foreach (char c in text)
		{
			await context.CdpClient.SendCommandAsync("Input.dispatchKeyEvent",
				new { type = "char", text = c.ToString() }, ct);
			await Task.Delay(80, ct);
		}
	}

	/// <summary>
	/// Resolve the text to type: use credential from context if the step's input matches a template credential.
	/// Steps in step-config.json contain hardcoded test credentials — we replace with the actual credential at runtime.
	/// </summary>
	private static string ResolveText(NavigationStep step, StepExecutionContext context)
	{
		// If context has username/password, use them based on step position in Login phase
		if (step.Phase.Equals("Login", StringComparison.OrdinalIgnoreCase))
		{
			bool isPasswordStep = step.Comment.Contains("password", StringComparison.OrdinalIgnoreCase)
				|| step.Verification.EntryGate.Contains("Password", StringComparison.OrdinalIgnoreCase);

			if (isPasswordStep && !string.IsNullOrEmpty(context.Password))
				return context.Password;

			bool isUsernameStep = step.Comment.Contains("username", StringComparison.OrdinalIgnoreCase)
				|| step.Comment.Contains("account", StringComparison.OrdinalIgnoreCase)
				|| step.Comment.Contains("Username", StringComparison.OrdinalIgnoreCase)
				|| step.Verification.EntryGate.Contains("Account", StringComparison.OrdinalIgnoreCase);

			if (isUsernameStep && !string.IsNullOrEmpty(context.Username))
				return context.Username;
		}

		// Check explicit variables
		if (context.Variables.TryGetValue("username", out string? u) && step.Input == u)
			return context.Username;
		if (context.Variables.TryGetValue("password", out string? p) && step.Input == p)
			return context.Password;

		return step.Input ?? string.Empty;
	}
}
