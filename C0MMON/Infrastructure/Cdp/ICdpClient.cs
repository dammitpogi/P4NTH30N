using System.Text.Json;

namespace P4NTH30N.C0MMON.Infrastructure.Cdp;

/// <summary>
/// Chrome DevTools Protocol client interface.
/// Replaces Selenium ChromeDriver for browser UI interaction.
/// </summary>
public interface ICdpClient : IDisposable
{
	bool IsConnected { get; }

	/// <summary>
	/// Connect to Chrome on host via CDP WebSocket.
	/// </summary>
	Task<bool> ConnectAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Navigate to a URL via Page.navigate.
	/// </summary>
	Task NavigateAsync(string url, CancellationToken cancellationToken = default);

	/// <summary>
	/// Click at viewport coordinates via Input.dispatchMouseEvent.
	/// </summary>
	Task ClickAtAsync(int x, int y, CancellationToken cancellationToken = default);

	/// <summary>
	/// Wait for a CSS selector to appear, then click its center.
	/// No hardcoded pixel coordinates — coordinates are resolved from the DOM.
	/// </summary>
	Task WaitForSelectorAndClickAsync(string selector, int? timeoutMs = null, CancellationToken cancellationToken = default);

	/// <summary>
	/// Focus a CSS selector and clear its value before typing.
	/// </summary>
	Task FocusSelectorAndClearAsync(string selector, int? timeoutMs = null, CancellationToken cancellationToken = default);

	/// <summary>
	/// Type text character-by-character via Input.dispatchKeyEvent.
	/// </summary>
	Task TypeTextAsync(string text, CancellationToken cancellationToken = default);

	/// <summary>
	/// Evaluate a JavaScript expression via Runtime.evaluate and return the result.
	/// </summary>
	Task<T?> EvaluateAsync<T>(string expression, CancellationToken cancellationToken = default);

	/// <summary>
	/// Send a raw CDP command and return the JSON response.
	/// </summary>
	Task<JsonElement> SendCommandAsync(string method, object? parameters = null, CancellationToken cancellationToken = default);
}
