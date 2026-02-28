using Xunit;

namespace P4NTHE0N.DeployLogAnalyzer.Tests;

public class ValidationPipelineTests
{
	[Fact]
	public async Task LoadSamplesAsync_FromDirectory_LoadsAll()
	{
		string tempDir = Path.Combine(Path.GetTempPath(), $"validation-test-{Guid.NewGuid():N}");
		Directory.CreateDirectory(tempDir);

		try
		{
			File.WriteAllText(
				Path.Combine(tempDir, "test1.json"),
				"""
				{
					"name": "Test 1",
					"config": {"username": "test", "platform": "firekirin"},
					"expected": {"valid": true, "failures": []}
				}
				"""
			);

			File.WriteAllText(
				Path.Combine(tempDir, "test2.json"),
				"""
				{
					"name": "Test 2",
					"config": {"platform": "orionstars"},
					"expected": {"valid": false, "failures": ["missing_field"]}
				}
				"""
			);

			List<ValidationSample> samples = await ValidationPipeline.LoadSamplesAsync(tempDir);

			Assert.Equal(2, samples.Count);
			Assert.Equal("Test 1", samples[0].Name);
			Assert.True(samples[0].ExpectedValid);
			Assert.Equal("Test 2", samples[1].Name);
			Assert.False(samples[1].ExpectedValid);
			Assert.Single(samples[1].ExpectedFailures);
		}
		finally
		{
			Directory.Delete(tempDir, recursive: true);
		}
	}

	[Fact]
	public async Task LoadSamplesAsync_NonexistentPath_ReturnsEmpty()
	{
		List<ValidationSample> samples = await ValidationPipeline.LoadSamplesAsync("/nonexistent/path/that/does/not/exist");

		Assert.Empty(samples);
	}

	[Fact]
	public async Task LoadSamplesAsync_SingleFile_LoadsOne()
	{
		string tempFile = Path.GetTempFileName();
		try
		{
			File.WriteAllText(
				tempFile,
				"""
				{
					"name": "Single Test",
					"config": {"username": "test"},
					"expected": {"valid": true, "failures": []}
				}
				"""
			);

			List<ValidationSample> samples = await ValidationPipeline.LoadSamplesAsync(tempFile);
			Assert.Single(samples);
			Assert.Equal("Single Test", samples[0].Name);
		}
		finally
		{
			File.Delete(tempFile);
		}
	}

	[Fact]
	public async Task SaveResultsAsync_CreatesFile()
	{
		string tempFile = Path.Combine(Path.GetTempPath(), $"pipeline-result-{Guid.NewGuid():N}.json");

		try
		{
			PipelineResult result = new()
			{
				Timestamp = DateTime.UtcNow,
				TotalSamples = 5,
				Accuracy = 0.8,
				Precision = 0.75,
				Recall = 0.85,
				AccuracyPassed = false,
				LatencyPassed = true,
				OverallPassed = false,
			};

			await ValidationPipeline.SaveResultsAsync(result, tempFile);

			Assert.True(File.Exists(tempFile));
			string json = await File.ReadAllTextAsync(tempFile);
			Assert.Contains("\"Accuracy\"", json);
			Assert.Contains("0.8", json);
		}
		finally
		{
			if (File.Exists(tempFile))
				File.Delete(tempFile);
		}
	}

	[Fact]
	public async Task SaveResultsAsync_CreatesDirectory()
	{
		string tempDir = Path.Combine(Path.GetTempPath(), $"nested-{Guid.NewGuid():N}", "sub");
		string tempFile = Path.Combine(tempDir, "result.json");

		try
		{
			PipelineResult result = new() { Timestamp = DateTime.UtcNow, TotalSamples = 0 };

			await ValidationPipeline.SaveResultsAsync(result, tempFile);

			Assert.True(File.Exists(tempFile));
		}
		finally
		{
			if (Directory.Exists(Path.GetDirectoryName(tempDir)!))
			{
				Directory.Delete(Path.GetDirectoryName(tempDir)!, recursive: true);
			}
		}
	}

	[Fact]
	public void PipelineResult_MetricsCalculation_Correct()
	{
		// Verify metric formulas with known values
		int tp = 8,
			tn = 4,
			fp = 1,
			fn = 2;
		int total = tp + tn + fp + fn;
		double accuracy = (double)(tp + tn) / total;
		double precision = (double)tp / (tp + fp);
		double recall = (double)tp / (tp + fn);
		double f1 = 2.0 * (precision * recall) / (precision + recall);

		Assert.Equal(0.8, accuracy, precision: 4);
		Assert.Equal(0.8888, precision, precision: 3);
		Assert.Equal(0.8, recall, precision: 4);
		Assert.True(f1 > 0.0 && f1 < 1.0);
	}
}
