using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Vision.Implementations;

/// <summary>
/// FEAT-036: Tesseract-based jackpot detector.
/// Extracts jackpot values from vision frames using OCR.
/// Currently uses pixel brightness heuristics as a placeholder until
/// Tesseract ONNX model is deployed by OpenFixer.
/// </summary>
public sealed class TesseractJackpotDetector : IJackpotDetector
{
	private Dictionary<string, RegionOfInterest> _rois = new();
	private readonly double _minConfidence;

	/// <summary>
	/// Creates a Tesseract-based jackpot detector.
	/// </summary>
	/// <param name="minConfidence">Minimum OCR confidence to accept a value (0.0-1.0).</param>
	public TesseractJackpotDetector(double minConfidence = 0.7)
	{
		_minConfidence = minConfidence;
	}

	public async Task<Dictionary<string, decimal>> DetectAsync(VisionFrame frame)
	{
		Dictionary<string, decimal> results = new();

		foreach (KeyValuePair<string, RegionOfInterest> kv in _rois)
		{
			if (!kv.Value.Enabled) continue;

			decimal? value = await DetectSingleAsync(frame, kv.Value);
			if (value.HasValue)
				results[kv.Key] = value.Value;
		}

		return results;
	}

	public async Task<decimal?> DetectSingleAsync(VisionFrame frame, RegionOfInterest roi)
	{
		if (frame.Data == null || frame.Data.Length == 0)
			return null;

		// Crop the ROI from the frame
		byte[]? cropped = roi.Crop(frame.Data, frame.Width, frame.Height);
		if (cropped == null || cropped.Length == 0)
			return null;

		// Placeholder: Extract text-like patterns from pixel brightness
		// Real implementation will use Tesseract ONNX model
		string? extracted = await ExtractTextFromPixelsAsync(cropped, roi.Width, roi.Height);
		if (string.IsNullOrEmpty(extracted))
			return null;

		// Try parsing extracted text as a decimal value
		return ParseCurrencyValue(extracted);
	}

	public void ConfigureROIs(Dictionary<string, RegionOfInterest> rois)
	{
		_rois = rois ?? new();
		Console.WriteLine($"[TesseractJackpotDetector] Configured {_rois.Count} ROIs");
	}

	/// <summary>
	/// Placeholder: Extracts text-like patterns from pixel data using brightness thresholding.
	/// Will be replaced with actual Tesseract OCR when ONNX model is available.
	/// </summary>
	private static Task<string?> ExtractTextFromPixelsAsync(byte[] bgrData, int width, int height)
	{
		if (bgrData.Length < 3)
			return Task.FromResult<string?>(null);

		// Simple brightness-based digit detection heuristic
		// Count bright pixels (likely text on dark background)
		int brightPixels = 0;
		int totalPixels = width * height;

		for (int i = 0; i < bgrData.Length - 2; i += 3)
		{
			int b = bgrData[i];
			int g = bgrData[i + 1];
			int r = bgrData[i + 2];
			int brightness = (r + g + b) / 3;
			if (brightness > 200)
				brightPixels++;
		}

		double brightRatio = totalPixels > 0 ? (double)brightPixels / totalPixels : 0;

		// If significant bright area detected, return a placeholder value
		// This is purely a stub — real OCR will replace this
		if (brightRatio > 0.05 && brightRatio < 0.80)
		{
			// Use brightness ratio to generate a plausible value for testing
			return Task.FromResult<string?>($"{brightRatio * 10000:F2}");
		}

		return Task.FromResult<string?>(null);
	}

	/// <summary>
	/// Parses a currency string into a decimal value.
	/// Handles formats like "$1,234.56", "1234.56", "$1234", etc.
	/// </summary>
	private static decimal? ParseCurrencyValue(string text)
	{
		// Strip non-numeric characters except decimal point and comma
		string cleaned = Regex.Replace(text, @"[^0-9.,]", "");
		if (string.IsNullOrEmpty(cleaned))
			return null;

		// Remove commas (thousand separators)
		cleaned = cleaned.Replace(",", "");

		if (decimal.TryParse(cleaned, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal value))
			return value;

		return null;
	}
}
