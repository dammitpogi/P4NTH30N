using System;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.H4ND.Infrastructure;

namespace P4NTHE0N.UNI7T35T.TestHarness;

/// <summary>
/// TEST-035: Validates login flow for FireKirin and OrionStars platforms.
/// Uses CdpGameActions for actual login, then verifies success state.
/// </summary>
public sealed class LoginValidator
{
	private readonly CdpTestClient _cdpTest;

	public LoginValidator(CdpTestClient cdpTest)
	{
		_cdpTest = cdpTest ?? throw new ArgumentNullException(nameof(cdpTest));
	}

	/// <summary>
	/// Validates the full login flow for a test account.
	/// </summary>
	/// <returns>Login success and any diagnostic info.</returns>
	public async Task<LoginValidationResult> ValidateLoginAsync(TestAccount account, CancellationToken ct = default)
	{
		LoginValidationResult result = new() { Game = account.Game, Username = account.Username };

		try
		{
			ICdpClient cdp = _cdpTest.GetInnerClient();

			bool loginSuccess = account.Game switch
			{
				"FireKirin" => await CdpGameActions.LoginFireKirinAsync(cdp, account.Username, account.Password, ct),
				"OrionStars" => await CdpGameActions.LoginOrionStarsAsync(cdp, account.Username, account.Password, ct),
				_ => throw new NotSupportedException($"Game '{account.Game}' not supported for login validation"),
			};

			result.LoginSuccess = loginSuccess;

			if (loginSuccess)
			{
				// Verify page readiness after login
				result.PageReady = await CdpGameActions.VerifyGamePageLoadedAsync(cdp, account.Game, ct: ct);

				// Capture post-login screenshot
				result.ScreenshotBase64 = await _cdpTest.CaptureScreenshotAsync(ct);
			}
		}
		catch (Exception ex)
		{
			result.LoginSuccess = false;
			result.ErrorMessage = ex.Message;
			Console.WriteLine($"[LoginValidator] {account.Game} login failed for {account.Username}: {ex.Message}");
		}

		return result;
	}

	/// <summary>
	/// Validates logout flow for a test account.
	/// </summary>
	public async Task<bool> ValidateLogoutAsync(string game, CancellationToken ct = default)
	{
		try
		{
			ICdpClient cdp = _cdpTest.GetInnerClient();

			switch (game)
			{
				case "FireKirin":
					await CdpGameActions.LogoutFireKirinAsync(cdp, ct);
					break;
				case "OrionStars":
					await CdpGameActions.LogoutOrionStarsAsync(cdp, ct);
					break;
				default:
					Console.WriteLine($"[LoginValidator] Unknown game for logout: {game}");
					return false;
			}

			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[LoginValidator] Logout failed for {game}: {ex.Message}");
			return false;
		}
	}
}

/// <summary>
/// Result of a login validation.
/// </summary>
public sealed class LoginValidationResult
{
	public string Game { get; set; } = string.Empty;
	public string Username { get; set; } = string.Empty;
	public bool LoginSuccess { get; set; }
	public bool PageReady { get; set; }
	public string? ScreenshotBase64 { get; set; }
	public string? ErrorMessage { get; set; }
}
