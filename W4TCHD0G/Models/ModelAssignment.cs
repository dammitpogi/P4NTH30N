namespace P4NTH30N.W4TCHD0G.Models;

public class ModelAssignment
{
	public string TaskName { get; set; } = string.Empty;
	public string ModelId { get; set; } = string.Empty;
	public string Provider { get; set; } = "HuggingFace";
	public long ModelSizeBytes { get; set; }
	public int MaxLatencyMs { get; set; }
	public string Device { get; set; } = "cpu";
}
