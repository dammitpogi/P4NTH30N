using System.IO.Compression;

namespace P4NTH30N.C0MMON.Support;

/// <summary>
/// DECISION_025: Compression-based atypicality scoring.
/// Uses GZip compression ratio to detect anomalous patterns in numeric sequences.
/// Based on ArXiv 1709.03189 - Data Discovery and Anomaly Detection Using Atypicality.
/// </summary>
public static class AtypicalityScore
{
	/// <summary>
	/// Calculates the atypicality ratio for a new value against a reference window.
	/// A ratio significantly above 1.0 indicates the new value is atypical relative to the window.
	/// </summary>
	/// <param name="window">Reference window of typical values.</param>
	/// <param name="newValue">New value to test for atypicality.</param>
	/// <returns>Atypicality ratio. Values above threshold (default 1.3) are anomalous.</returns>
	public static double Calculate(IReadOnlyList<double> window, double newValue)
	{
		if (window.Count < 5)
			return 0.0;

		byte[] windowBytes = EncodeSequence(window);
		int windowCompressed = CompressedSize(windowBytes);

		List<double> extended = new(window) { newValue };
		byte[] extendedBytes = EncodeSequence(extended);
		int extendedCompressed = CompressedSize(extendedBytes);

		// Marginal cost of encoding newValue with the window's code
		int marginalCost = extendedCompressed - windowCompressed;

		// Expected marginal cost: average per-element compressed size
		double expectedMarginal = (double)windowCompressed / window.Count;

		if (expectedMarginal <= 0)
			return 0.0;

		return marginalCost / expectedMarginal;
	}

	/// <summary>
	/// Statistical fallback: Z-score based anomaly detection.
	/// Returns the absolute Z-score of newValue relative to the window.
	/// </summary>
	public static double ZScore(IReadOnlyList<double> window, double newValue)
	{
		if (window.Count < 2)
			return 0.0;

		double mean = 0;
		foreach (double v in window) mean += v;
		mean /= window.Count;

		double variance = 0;
		foreach (double v in window) variance += (v - mean) * (v - mean);
		variance /= window.Count;

		double stdDev = Math.Sqrt(variance);
		if (stdDev < 1e-10)
			return Math.Abs(newValue - mean) > 1e-10 ? double.MaxValue : 0.0;

		return Math.Abs(newValue - mean) / stdDev;
	}

	/// <summary>
	/// Combined anomaly check using both compression-based and Z-score methods.
	/// </summary>
	/// <param name="window">Reference window.</param>
	/// <param name="newValue">Value to test.</param>
	/// <param name="compressionThreshold">Atypicality ratio threshold (default 1.3).</param>
	/// <param name="zScoreThreshold">Z-score threshold (default 3.0).</param>
	/// <returns>True if either method flags the value as anomalous.</returns>
	public static bool IsAnomalous(IReadOnlyList<double> window, double newValue, double compressionThreshold = 1.3, double zScoreThreshold = 3.0)
	{
		double atypicality = Calculate(window, newValue);
		double zScore = ZScore(window, newValue);

		return atypicality > compressionThreshold || zScore > zScoreThreshold;
	}

	private static byte[] EncodeSequence(IReadOnlyList<double> values)
	{
		byte[] buffer = new byte[values.Count * 8];
		for (int i = 0; i < values.Count; i++)
			BitConverter.GetBytes(values[i]).CopyTo(buffer, i * 8);
		return buffer;
	}

	private static int CompressedSize(byte[] data)
	{
		using var ms = new MemoryStream();
		using (var gz = new GZipStream(ms, CompressionLevel.Optimal, leaveOpen: true))
		{
			gz.Write(data, 0, data.Length);
		}
		return (int)ms.Length;
	}
}
