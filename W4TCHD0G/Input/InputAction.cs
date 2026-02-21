namespace P4NTH30N.W4TCHD0G.Input;

/// <summary>
/// Represents a queued input action for sequential execution on the VM.
/// Actions are immutable and executed in FIFO order by the ActionQueue.
/// </summary>
public sealed class InputAction
{
	/// <summary>
	/// Type of input action to perform.
	/// </summary>
	public InputActionType Type { get; init; }

	/// <summary>
	/// X coordinate for mouse actions (VM screen space).
	/// </summary>
	public int X { get; init; }

	/// <summary>
	/// Y coordinate for mouse actions (VM screen space).
	/// </summary>
	public int Y { get; init; }

	/// <summary>
	/// Mouse button for click actions.
	/// </summary>
	public MouseButton Button { get; init; } = MouseButton.Left;

	/// <summary>
	/// Key code for keyboard actions.
	/// </summary>
	public SynergyKey Key { get; init; } = SynergyKey.None;

	/// <summary>
	/// Key modifiers for keyboard actions.
	/// </summary>
	public KeyModifiers Modifiers { get; init; } = KeyModifiers.None;

	/// <summary>
	/// Text string for SendKeys actions.
	/// </summary>
	public string? Text { get; init; }

	/// <summary>
	/// Delay in milliseconds to wait after executing this action.
	/// </summary>
	public int DelayAfterMs { get; init; } = 100;

	/// <summary>
	/// Timeout in milliseconds for this action. Default: 2000ms per Oracle requirement.
	/// </summary>
	public int TimeoutMs { get; init; } = 2000;

	/// <summary>
	/// Creates a mouse click action.
	/// </summary>
	public static InputAction Click(int x, int y, MouseButton button = MouseButton.Left, int delayAfterMs = 100)
	{
		return new InputAction
		{
			Type = InputActionType.Click,
			X = x,
			Y = y,
			Button = button,
			DelayAfterMs = delayAfterMs,
		};
	}

	/// <summary>
	/// Creates a double-click action.
	/// </summary>
	public static InputAction DoubleClick(int x, int y, MouseButton button = MouseButton.Left, int delayAfterMs = 100)
	{
		return new InputAction
		{
			Type = InputActionType.DoubleClick,
			X = x,
			Y = y,
			Button = button,
			DelayAfterMs = delayAfterMs,
		};
	}

	/// <summary>
	/// Creates a mouse move action.
	/// </summary>
	public static InputAction MoveMouse(int x, int y, int delayAfterMs = 50)
	{
		return new InputAction
		{
			Type = InputActionType.MouseMove,
			X = x,
			Y = y,
			DelayAfterMs = delayAfterMs,
		};
	}

	/// <summary>
	/// Creates a key press action.
	/// </summary>
	public static InputAction KeyPress(SynergyKey key, KeyModifiers modifiers = KeyModifiers.None, int delayAfterMs = 50)
	{
		return new InputAction
		{
			Type = InputActionType.KeyPress,
			Key = key,
			Modifiers = modifiers,
			DelayAfterMs = delayAfterMs,
		};
	}

	/// <summary>
	/// Creates a text typing action.
	/// </summary>
	public static InputAction TypeText(string text, int delayAfterMs = 100)
	{
		return new InputAction
		{
			Type = InputActionType.SendKeys,
			Text = text,
			DelayAfterMs = delayAfterMs,
		};
	}

	/// <summary>
	/// Creates a delay-only action (no input, just wait).
	/// </summary>
	public static InputAction Delay(int delayMs)
	{
		return new InputAction { Type = InputActionType.Delay, DelayAfterMs = delayMs };
	}
}

/// <summary>
/// Types of input actions supported by the Synergy client.
/// </summary>
public enum InputActionType
{
	/// <summary>Mouse move to coordinates.</summary>
	MouseMove,

	/// <summary>Single mouse click at coordinates.</summary>
	Click,

	/// <summary>Double mouse click at coordinates.</summary>
	DoubleClick,

	/// <summary>Single key press and release.</summary>
	KeyPress,

	/// <summary>Type a string of characters.</summary>
	SendKeys,

	/// <summary>Wait without performing any input.</summary>
	Delay,
}
