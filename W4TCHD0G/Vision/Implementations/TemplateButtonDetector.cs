using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using P4NTHE0N.W4TCHD0G.Models;

namespace P4NTHE0N.W4TCHD0G.Vision.Implementations;

/// <summary>
/// FEAT-036: Template-matching button detector.
/// Detects game buttons by comparing ROIs against pre-captured button templates.
/// Uses normalized cross-correlation on grayscale patches.
/// </summary>
public sealed class TemplateButtonDetector : IButtonDetector
{
	private readonly Dictionary<ButtonType, List<ButtonTemplate>> _templates = new();
	private readonly double _matchThreshold;

	/// <summary>
	/// Creates a template-based button detector.
	/// </summary>
	/// <param name="matchThreshold">Minimum correlation score to consider a match (0.0-1.0).</param>
	public TemplateButtonDetector(double matchThreshold = 0.75)
	{
		_matchThreshold = matchThreshold;
	}

	public async Task<List<DetectedButton>> DetectAsync(VisionFrame frame)
	{
		List<DetectedButton> detected = new();

		if (frame.Data == null || frame.Data.Length == 0 || _templates.Count == 0)
			return detected;

		// Convert frame to grayscale for matching
		byte[] gray = ToGrayscale(frame.Data, frame.Width, frame.Height);

		foreach (KeyValuePair<ButtonType, List<ButtonTemplate>> kv in _templates)
		{
			foreach (ButtonTemplate template in kv.Value)
			{
				// Scan the frame for the template
				(int x, int y, double score) = await ScanForTemplateAsync(gray, frame.Width, frame.Height, template);

				if (score >= _matchThreshold)
				{
					detected.Add(new DetectedButton
					{
						Type = kv.Key,
						CenterX = x + template.Width / 2,
						CenterY = y + template.Height / 2,
						Width = template.Width,
						Height = template.Height,
						Confidence = score,
						IsEnabled = true, // Would need color analysis for enabled/disabled
						Label = template.Label,
					});
				}
			}
		}

		return detected;
	}

	public void LoadTemplates(string templateDirectory)
	{
		if (!Directory.Exists(templateDirectory))
		{
			Console.WriteLine($"[TemplateButtonDetector] Template directory not found: {templateDirectory}");
			return;
		}

		// Load template images organized by button type subdirectories
		foreach (string typeDir in Directory.GetDirectories(templateDirectory))
		{
			string typeName = Path.GetFileName(typeDir);
			if (!Enum.TryParse<ButtonType>(typeName, ignoreCase: true, out ButtonType buttonType))
				continue;

			if (!_templates.ContainsKey(buttonType))
				_templates[buttonType] = new List<ButtonTemplate>();

			foreach (string file in Directory.GetFiles(typeDir, "*.raw"))
			{
				try
				{
					byte[] data = File.ReadAllBytes(file);
					// Assume filename encodes dimensions: spin_100x100.raw
					string name = Path.GetFileNameWithoutExtension(file);
					(int w, int h) = ParseDimensions(name);

					if (w > 0 && h > 0)
					{
						_templates[buttonType].Add(new ButtonTemplate
						{
							Data = ToGrayscale(data, w, h),
							Width = w,
							Height = h,
							Label = typeName,
						});
					}
				}
				catch (Exception ex)
				{
					Console.WriteLine($"[TemplateButtonDetector] Failed to load template {file}: {ex.Message}");
				}
			}
		}

		int total = 0;
		foreach (var kv in _templates) total += kv.Value.Count;
		Console.WriteLine($"[TemplateButtonDetector] Loaded {total} templates across {_templates.Count} button types");
	}

	/// <summary>
	/// Scans the grayscale frame for a template using simplified cross-correlation.
	/// Returns (bestX, bestY, bestScore).
	/// </summary>
	private static Task<(int x, int y, double score)> ScanForTemplateAsync(byte[] gray, int frameW, int frameH, ButtonTemplate template)
	{
		int bestX = 0, bestY = 0;
		double bestScore = 0;

		int stepSize = 4; // Downsample scan for performance

		for (int y = 0; y <= frameH - template.Height; y += stepSize)
		{
			for (int x = 0; x <= frameW - template.Width; x += stepSize)
			{
				double score = ComputeNCC(gray, frameW, x, y, template.Data, template.Width, template.Height);
				if (score > bestScore)
				{
					bestScore = score;
					bestX = x;
					bestY = y;
				}
			}
		}

		return Task.FromResult((bestX, bestY, bestScore));
	}

	/// <summary>
	/// Computes normalized cross-correlation between a frame patch and a template.
	/// </summary>
	private static double ComputeNCC(byte[] frame, int frameW, int patchX, int patchY, byte[] template, int tW, int tH)
	{
		double sumF = 0, sumT = 0, sumFT = 0, sumFF = 0, sumTT = 0;
		int n = tW * tH;

		for (int ty = 0; ty < tH; ty++)
		{
			for (int tx = 0; tx < tW; tx++)
			{
				int fi = (patchY + ty) * frameW + (patchX + tx);
				int ti = ty * tW + tx;

				if (fi >= frame.Length || ti >= template.Length) continue;

				double fv = frame[fi];
				double tv = template[ti];
				sumF += fv;
				sumT += tv;
				sumFT += fv * tv;
				sumFF += fv * fv;
				sumTT += tv * tv;
			}
		}

		double meanF = sumF / n;
		double meanT = sumT / n;
		double num = sumFT - n * meanF * meanT;
		double den = Math.Sqrt((sumFF - n * meanF * meanF) * (sumTT - n * meanT * meanT));

		return den > 0 ? num / den : 0;
	}

	/// <summary>
	/// Converts BGR24 data to grayscale.
	/// </summary>
	private static byte[] ToGrayscale(byte[] bgr, int width, int height)
	{
		int pixels = width * height;
		byte[] gray = new byte[pixels];

		for (int i = 0; i < pixels && i * 3 + 2 < bgr.Length; i++)
		{
			int b = bgr[i * 3];
			int g = bgr[i * 3 + 1];
			int r = bgr[i * 3 + 2];
			gray[i] = (byte)((r * 77 + g * 150 + b * 29) >> 8);
		}

		return gray;
	}

	/// <summary>
	/// Parses "name_WxH" dimensions from a filename.
	/// </summary>
	private static (int w, int h) ParseDimensions(string filename)
	{
		int idx = filename.LastIndexOf('_');
		if (idx < 0) return (0, 0);

		string dims = filename[(idx + 1)..];
		string[] parts = dims.Split('x');
		if (parts.Length == 2 && int.TryParse(parts[0], out int w) && int.TryParse(parts[1], out int h))
			return (w, h);

		return (0, 0);
	}
}

/// <summary>
/// A button template for matching.
/// </summary>
internal sealed class ButtonTemplate
{
	public byte[] Data { get; set; } = Array.Empty<byte>();
	public int Width { get; set; }
	public int Height { get; set; }
	public string Label { get; set; } = string.Empty;
}
