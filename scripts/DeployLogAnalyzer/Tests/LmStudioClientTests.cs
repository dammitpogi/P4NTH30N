using Xunit;

namespace P4NTH30N.DeployLogAnalyzer.Tests;

public class LmStudioClientTests
{
	[Fact]
	public void Constructor_SetsProperties()
	{
		using LmStudioClient client = new(baseUrl: "http://localhost:5000", modelId: "test-model", apiKey: "test-key");

		Assert.Equal("test-model", client.ModelId);
		Assert.False(client.IsConnected);
	}

	[Fact]
	public async Task ConnectAsync_InvalidEndpoint_ReturnsFalse()
	{
		using LmStudioClient client = new(baseUrl: "http://localhost:59999", timeoutSeconds: 2);

		bool connected = await client.ConnectAsync();

		Assert.False(connected);
		Assert.False(client.IsConnected);
	}

	[Fact]
	public void ExtractJson_ValidJsonInText_ExtractsCorrectly()
	{
		string input = "Here is the result: {\"valid\": true, \"confidence\": 0.95} and more text";
		string json = LmStudioClient.ExtractJson(input);

		Assert.Equal("{\"valid\": true, \"confidence\": 0.95}", json);
	}

	[Fact]
	public void ExtractJson_NoJson_ReturnsOriginal()
	{
		string input = "No JSON here at all";
		string json = LmStudioClient.ExtractJson(input);

		Assert.Equal(input, json);
	}

	[Fact]
	public void ExtractJson_NestedJson_ExtractsOuter()
	{
		string input = "{\"outer\": {\"inner\": true}, \"value\": 1}";
		string json = LmStudioClient.ExtractJson(input);

		Assert.Equal(input, json);
	}

	[Fact]
	public void ExtractJson_PureJson_ReturnsSame()
	{
		string input = "{\"valid\": false, \"failures\": [\"missing_field\"]}";
		string json = LmStudioClient.ExtractJson(input);

		Assert.Equal(input, json);
	}

	[Fact]
	public void Dispose_MultipleCalls_DoesNotThrow()
	{
		LmStudioClient client = new();
		client.Dispose();
		client.Dispose();
	}

	[Fact]
	public async Task ValidateConfigAsync_AfterDispose_ThrowsObjectDisposed()
	{
		LmStudioClient client = new();
		client.Dispose();

		await Assert.ThrowsAsync<ObjectDisposedException>(() => client.ValidateConfigAsync("{}"));
	}
}
