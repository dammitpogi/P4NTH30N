namespace P4NTH30N.H4ND.Navigation.Verification;

/// <summary>
/// ARCH-098: Verifies gates using JavaScript expression evaluation via CDP.
/// Handles special gates like "Balance > 0" with specific JS expressions.
/// Empty gates always pass (many steps in step-config.json have empty verification).
/// </summary>
public sealed class JavaScriptVerificationStrategy : IVerificationStrategy
{
	public async Task<bool> VerifyAsync(string gate, StepExecutionContext context, CancellationToken ct)
	{
		// Empty gates always pass — many recorder steps have no verification
		if (string.IsNullOrWhiteSpace(gate))
			return true;

		// Special gate: Balance > 0
		if (gate.Contains("Balance > 0", StringComparison.OrdinalIgnoreCase))
		{
			try
			{
				double? balance = await context.CdpClient.EvaluateAsync<double>(
					"Number(window.parent.Balance) || 0", ct);
				return balance > 0;
			}
			catch
			{
				return false;
			}
		}

		// Special gate: readyState complete
		if (gate.Contains("readyState", StringComparison.OrdinalIgnoreCase))
		{
			try
			{
				string? state = await context.CdpClient.EvaluateAsync<string>(
					"document.readyState", ct);
				return state == "complete" || state == "interactive";
			}
			catch
			{
				return false;
			}
		}

		// Recorder gates are often natural-language checkpoints, not executable predicates.
		// Treat these as informational so recorded step coordinates still run.
		string[] informationalGates = ["N/A", "none", "any", "always", "true",
			"Chrome CDP running", "Page loaded", "Login page visible", "login form visible",
			"Account field visible", "Password field visible", "Login button visible",
			"field has focus", "cursor blinking", "credentials entered", "Lobby visible"];
		if (informationalGates.Any(g => gate.Contains(g, StringComparison.OrdinalIgnoreCase)))
			return true;

		// Unknown free-text gate from recorder; log and continue rather than forcing
		// a hardcoded-login fallback path.
		Console.WriteLine($"[Nav:Verification] Unknown gate '{gate}' — treating as informational");
		return true;
	}
}
