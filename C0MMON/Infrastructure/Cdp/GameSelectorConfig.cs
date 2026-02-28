namespace P4NTHE0N.C0MMON.Infrastructure.Cdp;

/// <summary>
/// OPS_012: Configuration-driven jackpot selectors per game.
/// Bound from appsettings.json P4NTHE0N:H4ND:GameSelectors section.
/// Supports per-game page readiness checks and jackpot tier probe expressions.
/// </summary>
public sealed class GameSelectorConfig
{
	/// <summary>
	/// Per-game selector configurations keyed by game name (e.g. "FireKirin", "OrionStars").
	/// </summary>
	public Dictionary<string, GameSelectors> Games { get; set; } = new();

	/// <summary>
	/// Gets selectors for a game, falling back to defaults if not configured.
	/// </summary>
	public GameSelectors GetSelectors(string game)
	{
		if (Games.TryGetValue(game, out GameSelectors? selectors))
		{
			return selectors;
		}
		return GameSelectors.Default;
	}
}

/// <summary>
/// Selector configuration for a single game platform.
/// </summary>
public sealed class GameSelectors
{
	/// <summary>
	/// JavaScript expressions to check if the game page is loaded.
	/// Evaluated in order; first truthy result means page is ready.
	/// </summary>
	public List<string> PageReadyChecks { get; set; } =
	[
		"document.querySelector('canvas') !== null",
		"document.querySelector('.hall-container, .game-list, .home-container, .home-page, [class*=\"hall\"]') !== null",
		"document.querySelectorAll('iframe').length > 0",
	];

	/// <summary>
	/// JavaScript expressions that indicate the user is still on the login page.
	/// If any returns true after PageReadyChecks pass, page is NOT ready.
	/// </summary>
	public List<string> LoginPageIndicators { get; set; } = ["document.querySelector('.login-btn, .play-btn, input[type=\"password\"], [class*=\"guest\"]') !== null"];

	/// <summary>
	/// Fallback chain of JS expressions per jackpot tier.
	/// Each expression should return a numeric value (raw, divide by 100 for dollars).
	/// Evaluated in order; first non-zero result wins.
	/// Use {tier} placeholder which gets replaced with Grand/Major/Minor/Mini.
	/// </summary>
	public List<string> JackpotTierExpressions { get; set; } =
	[
		"Number(window.parent.{tier}) || 0",
		"Number(window.{tier}) || 0",
		"(() => {{ try {{ var f = document.querySelector('iframe'); return f ? Number(f.contentWindow.{tier}) || 0 : 0; }} catch(e) {{ return 0; }} }})()",
	];

	/// <summary>
	/// Maximum page readiness check attempts before proceeding anyway.
	/// </summary>
	public int PageReadyMaxAttempts { get; set; } = 20;

	/// <summary>
	/// Delay in milliseconds between page readiness check attempts.
	/// </summary>
	public int PageReadyDelayMs { get; set; } = 500;

	/// <summary>
	/// Default selector configuration for unknown games.
	/// </summary>
	public static GameSelectors Default { get; } = new();
}
