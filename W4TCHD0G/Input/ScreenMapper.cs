namespace P4NTHE0N.W4TCHD0G.Input;

/// <summary>
/// Translates coordinates between host screen space, VM screen space,
/// and vision frame pixel space. Handles resolution scaling and offset corrections.
/// </summary>
/// <remarks>
/// COORDINATE SPACES:
/// 1. Vision Frame: Raw pixel coordinates from decoded RTMP frame (e.g., 1280x720)
/// 2. VM Screen: Actual VM desktop resolution (e.g., 1920x1080)
/// 3. Synergy Screen: Synergy's logical coordinate space for the VM client
///
/// The mapper converts vision frame coordinates → VM screen coordinates
/// so that when W4TCHD0G detects a button at (640, 360) in a 1280x720 frame,
/// the Synergy client clicks at (960, 540) on a 1920x1080 VM desktop.
/// </remarks>
public sealed class ScreenMapper
{
	/// <summary>
	/// Vision frame width (from RTMP decoder output).
	/// </summary>
	private readonly int _frameWidth;

	/// <summary>
	/// Vision frame height (from RTMP decoder output).
	/// </summary>
	private readonly int _frameHeight;

	/// <summary>
	/// VM desktop width (actual resolution).
	/// </summary>
	private readonly int _vmWidth;

	/// <summary>
	/// VM desktop height (actual resolution).
	/// </summary>
	private readonly int _vmHeight;

	/// <summary>
	/// Horizontal offset for the VM screen in Synergy's logical space.
	/// Non-zero when the VM is positioned to the right/left of the host screen.
	/// </summary>
	private readonly int _offsetX;

	/// <summary>
	/// Vertical offset for the VM screen in Synergy's logical space.
	/// </summary>
	private readonly int _offsetY;

	/// <summary>
	/// Horizontal scale factor: VM pixels per frame pixel.
	/// </summary>
	public double ScaleX { get; }

	/// <summary>
	/// Vertical scale factor: VM pixels per frame pixel.
	/// </summary>
	public double ScaleY { get; }

	/// <summary>
	/// Creates a ScreenMapper with the specified resolution mapping.
	/// </summary>
	/// <param name="frameWidth">Vision frame width (e.g., 1280).</param>
	/// <param name="frameHeight">Vision frame height (e.g., 720).</param>
	/// <param name="vmWidth">VM desktop width (e.g., 1920).</param>
	/// <param name="vmHeight">VM desktop height (e.g., 1080).</param>
	/// <param name="offsetX">Synergy X offset for VM screen.</param>
	/// <param name="offsetY">Synergy Y offset for VM screen.</param>
	public ScreenMapper(int frameWidth = 1280, int frameHeight = 720, int vmWidth = 1920, int vmHeight = 1080, int offsetX = 0, int offsetY = 0)
	{
		if (frameWidth <= 0)
			throw new ArgumentOutOfRangeException(nameof(frameWidth));
		if (frameHeight <= 0)
			throw new ArgumentOutOfRangeException(nameof(frameHeight));
		if (vmWidth <= 0)
			throw new ArgumentOutOfRangeException(nameof(vmWidth));
		if (vmHeight <= 0)
			throw new ArgumentOutOfRangeException(nameof(vmHeight));

		_frameWidth = frameWidth;
		_frameHeight = frameHeight;
		_vmWidth = vmWidth;
		_vmHeight = vmHeight;
		_offsetX = offsetX;
		_offsetY = offsetY;

		ScaleX = (double)vmWidth / frameWidth;
		ScaleY = (double)vmHeight / frameHeight;
	}

	/// <summary>
	/// Converts vision frame coordinates to VM screen coordinates.
	/// </summary>
	/// <param name="frameX">X coordinate in vision frame space.</param>
	/// <param name="frameY">Y coordinate in vision frame space.</param>
	/// <returns>Tuple of (vmX, vmY) in VM screen coordinates.</returns>
	public (int vmX, int vmY) FrameToVm(int frameX, int frameY)
	{
		int vmX = (int)Math.Round(frameX * ScaleX);
		int vmY = (int)Math.Round(frameY * ScaleY);

		// Clamp to VM bounds
		vmX = Math.Clamp(vmX, 0, _vmWidth - 1);
		vmY = Math.Clamp(vmY, 0, _vmHeight - 1);

		return (vmX, vmY);
	}

	/// <summary>
	/// Converts vision frame coordinates to Synergy logical coordinates
	/// (includes offset for multi-screen Synergy layouts).
	/// </summary>
	/// <param name="frameX">X coordinate in vision frame space.</param>
	/// <param name="frameY">Y coordinate in vision frame space.</param>
	/// <returns>Tuple of (synergyX, synergyY) in Synergy logical space.</returns>
	public (int synergyX, int synergyY) FrameToSynergy(int frameX, int frameY)
	{
		(int vmX, int vmY) = FrameToVm(frameX, frameY);
		return (vmX + _offsetX, vmY + _offsetY);
	}

	/// <summary>
	/// Converts VM screen coordinates back to vision frame coordinates.
	/// Useful for overlaying analysis results on the decoded frame.
	/// </summary>
	/// <param name="vmX">X coordinate in VM screen space.</param>
	/// <param name="vmY">Y coordinate in VM screen space.</param>
	/// <returns>Tuple of (frameX, frameY) in vision frame space.</returns>
	public (int frameX, int frameY) VmToFrame(int vmX, int vmY)
	{
		int frameX = (int)Math.Round(vmX / ScaleX);
		int frameY = (int)Math.Round(vmY / ScaleY);

		// Clamp to frame bounds
		frameX = Math.Clamp(frameX, 0, _frameWidth - 1);
		frameY = Math.Clamp(frameY, 0, _frameHeight - 1);

		return (frameX, frameY);
	}

	/// <summary>
	/// Returns a human-readable description of the mapping configuration.
	/// </summary>
	public override string ToString()
	{
		return $"ScreenMapper: Frame({_frameWidth}x{_frameHeight}) → VM({_vmWidth}x{_vmHeight}) " + $"Scale({ScaleX:F2}x, {ScaleY:F2}y) Offset({_offsetX}, {_offsetY})";
	}
}
