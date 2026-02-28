namespace P4NTHE0N.W4TCHD0G.Vision;

/// <summary>
/// Defines a rectangular region of interest (ROI) within a vision frame.
/// Used to crop specific areas for targeted analysis (jackpot display, buttons, balance).
/// Coordinates are in vision frame pixel space.
/// </summary>
public sealed class RegionOfInterest
{
	/// <summary>
	/// Descriptive name for this ROI (e.g., "GrandJackpot", "SpinButton", "Balance").
	/// </summary>
	public string Name { get; init; } = string.Empty;

	/// <summary>
	/// Left edge X coordinate in frame pixels.
	/// </summary>
	public int X { get; init; }

	/// <summary>
	/// Top edge Y coordinate in frame pixels.
	/// </summary>
	public int Y { get; init; }

	/// <summary>
	/// Width of the ROI in pixels.
	/// </summary>
	public int Width { get; init; }

	/// <summary>
	/// Height of the ROI in pixels.
	/// </summary>
	public int Height { get; init; }

	/// <summary>
	/// Whether this ROI is active for detection.
	/// </summary>
	public bool Enabled { get; set; } = true;

	/// <summary>
	/// Creates a ROI from coordinates and dimensions.
	/// </summary>
	public RegionOfInterest(string name, int x, int y, int width, int height)
	{
		Name = name;
		X = x;
		Y = y;
		Width = width;
		Height = height;
	}

	/// <summary>
	/// Default constructor for deserialization.
	/// </summary>
	public RegionOfInterest() { }

	/// <summary>
	/// Crops raw BGR24 frame data to this ROI.
	/// Returns a new byte array containing only the ROI pixels.
	/// </summary>
	/// <param name="frameData">Raw BGR24 frame data.</param>
	/// <param name="frameWidth">Full frame width.</param>
	/// <param name="frameHeight">Full frame height.</param>
	/// <returns>Cropped BGR24 data for this ROI, or null if ROI is out of bounds.</returns>
	public byte[]? Crop(byte[] frameData, int frameWidth, int frameHeight)
	{
		if (frameData is null || frameData.Length == 0)
			return null;

		// Validate bounds
		int clampedX = Math.Max(0, Math.Min(X, frameWidth - 1));
		int clampedY = Math.Max(0, Math.Min(Y, frameHeight - 1));
		int clampedW = Math.Min(Width, frameWidth - clampedX);
		int clampedH = Math.Min(Height, frameHeight - clampedY);

		if (clampedW <= 0 || clampedH <= 0)
			return null;

		int bytesPerPixel = 3; // BGR24
		int srcStride = frameWidth * bytesPerPixel;
		int dstStride = clampedW * bytesPerPixel;
		byte[] cropped = new byte[clampedH * dstStride];

		for (int row = 0; row < clampedH; row++)
		{
			int srcOffset = (clampedY + row) * srcStride + clampedX * bytesPerPixel;
			int dstOffset = row * dstStride;
			Buffer.BlockCopy(frameData, srcOffset, cropped, dstOffset, dstStride);
		}

		return cropped;
	}

	/// <summary>
	/// Returns true if the given point is inside this ROI.
	/// </summary>
	public bool Contains(int px, int py)
	{
		return px >= X && px < X + Width && py >= Y && py < Y + Height;
	}
}
