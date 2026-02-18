using System;

namespace P4NTH30N.W4TCHD0G.Models;

public class VisionFrame
{
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public byte[] Data { get; set; } = Array.Empty<byte>();
	public int Width { get; set; }
	public int Height { get; set; }
	public string SourceName { get; set; } = string.Empty;
	public int FrameNumber { get; set; }
}
