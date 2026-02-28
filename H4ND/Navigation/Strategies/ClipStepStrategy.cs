using System.Text.Json;

namespace P4NTHE0N.H4ND.Navigation.Strategies;

public sealed class ClipStepStrategy : IStepStrategy
{
	public string ActionType => "clip";

	public async Task ExecuteAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct)
	{
		string text = ResolveText(step, context);
		if (string.IsNullOrEmpty(text))
		{
			throw new InvalidOperationException(
				$"Step {step.StepId}: Clip action has empty input after credential resolution. " +
				$"Phase={step.Phase}, Comment={step.Comment}");
		}

		bool isPassword = IsPasswordStep(step);
		string masked = isPassword ? new string('*', text.Length) : text;
		Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Clip '{masked}' — step {step.StepId}: {step.Comment}");

		string escaped = text.Replace("\\", "\\\\").Replace("'", "\\'");

		string? origin = await context.CdpClient.EvaluateAsync<string>("window.location.origin", ct);
		if (!string.IsNullOrWhiteSpace(origin))
		{
			await context.CdpClient.SendCommandAsync(
				"Browser.grantPermissions",
				new
				{
					origin,
					permissions = new[] { "clipboardReadWrite", "clipboardSanitizedWrite" },
				},
				ct);
		}

		string expression =
			$"(async () => {{ try {{ await navigator.clipboard.writeText('{escaped}'); return true; }} catch {{ return false; }} }})()";

		JsonElement result = await context.CdpClient.SendCommandAsync(
			"Runtime.evaluate",
			new
			{
				expression,
				returnByValue = true,
				awaitPromise = true,
			},
			ct);

		bool success = TryReadRuntimeBoolean(result);
		if (!success)
		{
			throw new InvalidOperationException($"Step {step.StepId}: Clipboard write failed for action 'clip'.");
		}
	}

	private static bool TryReadRuntimeBoolean(JsonElement response)
	{
		if (response.TryGetProperty("result", out JsonElement result)
			&& result.TryGetProperty("result", out JsonElement inner)
			&& inner.TryGetProperty("value", out JsonElement value))
		{
			if (value.ValueKind == JsonValueKind.True) return true;
			if (value.ValueKind == JsonValueKind.False) return false;
		}

		if (response.TryGetProperty("result", out JsonElement flat)
			&& flat.TryGetProperty("value", out JsonElement flatValue))
		{
			if (flatValue.ValueKind == JsonValueKind.True) return true;
			if (flatValue.ValueKind == JsonValueKind.False) return false;
		}

		return false;
	}

	private static bool IsPasswordStep(NavigationStep step) =>
		step.Phase.Equals("Login", StringComparison.OrdinalIgnoreCase)
		&& (step.Comment.Contains("password", StringComparison.OrdinalIgnoreCase)
			|| step.Verification.EntryGate.Contains("Password", StringComparison.OrdinalIgnoreCase));

	private static string ResolveText(NavigationStep step, StepExecutionContext context)
	{
		if (step.Phase.Equals("Login", StringComparison.OrdinalIgnoreCase))
		{
			if (IsPasswordStep(step) && !string.IsNullOrEmpty(context.Password))
			{
				return context.Password;
			}

			bool isUsernameStep = step.Comment.Contains("username", StringComparison.OrdinalIgnoreCase)
				|| step.Comment.Contains("account", StringComparison.OrdinalIgnoreCase)
				|| step.Verification.EntryGate.Contains("Account", StringComparison.OrdinalIgnoreCase);

			if (isUsernameStep && !string.IsNullOrEmpty(context.Username))
			{
				return context.Username;
			}
		}

		if (context.Variables.TryGetValue("username", out string? u) && step.Input == u)
		{
			return context.Username;
		}

		if (context.Variables.TryGetValue("password", out string? p) && step.Input == p)
		{
			return context.Password;
		}

		return step.Input ?? string.Empty;
	}
}
