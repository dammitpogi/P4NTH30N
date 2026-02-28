using System.Diagnostics;
using System.Net.Http.Json;
using System.Text.Json;

namespace P4NTHE0N.C0MMON;

public class CountryMetadata
{
	public string? calling_code { get; set; }
	public string? tld { get; set; }
	public List<string>? languages { get; set; }
}

public class Currency
{
	public string? code { get; set; }
	public string? name { get; set; }
	public string? symbol { get; set; }
}

public class Location
{
	public string? continent_code { get; set; }
	public string? continent_name { get; set; }
	public string? country_code2 { get; set; }
	public string? country_code3 { get; set; }
	public string? country_name { get; set; }
	public string? country_name_official { get; set; }
	public string? country_capital { get; set; }
	public string? state_prov { get; set; }
	public string? state_code { get; set; }
	public string? district { get; set; }
	public string? city { get; set; }
	public string? zipcode { get; set; }
	public string? latitude { get; set; }
	public string? longitude { get; set; }
	public bool? is_eu { get; set; }
	public string? country_flag { get; set; }
	public string? geoname_id { get; set; }
	public string? country_emoji { get; set; }
}

public class NetworkAddress
{
	public string? ip { get; set; }
	public Location? location { get; set; }
	public CountryMetadata? country_metadata { get; set; }
	public Currency? currency { get; set; }

	public static async Task<NetworkAddress> Get(HttpClient client)
	{
		try
		{
			// Enhanced location detection with multiple fallback services
			var locationServices = new[]
			{
				("https://api.ipgeolocation.io/v2/ipgeo?apiKey=b4d1fe0cfaac4fd2adde2fa732c472e3", "ipgeolocation"),
				("https://ipapi.co/json/", "ipapi"),
				("https://ipinfo.io/json", "ipinfo"),
				("https://api.ipify.org?format=json", "ipify"),
			};

			var errors = new List<string>();

			foreach (var (url, serviceName) in locationServices)
			{
				try
				{
					Console.WriteLine($"Attempting location detection via {serviceName}...");
					var response = await client.GetAsync(url);
					if (response.IsSuccessStatusCode)
					{
						var data = await response.Content.ReadAsStringAsync();
						if (!string.IsNullOrWhiteSpace(data))
						{
							errors.Add($"{serviceName}: Empty response");
							continue;
						}

						// Try to deserialize as NetworkAddress
						var result = JsonSerializer.Deserialize<NetworkAddress>(data);
						if (result?.ip != null)
						{
							Console.WriteLine($"Location detection successful via {serviceName}: {result.ip}, {result.location?.city}, {result.location?.country_name}");
							return result;
						}
					}
					else
					{
						errors.Add($"{serviceName}: HTTP {response.StatusCode}");
					}
				}
				catch (HttpRequestException ex)
				{
					errors.Add($"{serviceName}: {ex.Message}");
				}
				catch (JsonException ex)
				{
					errors.Add($"{serviceName}: JSON parsing failed - {ex.Message}");
				}
				catch (Exception ex)
				{
					errors.Add($"{serviceName}: {ex.Message}");
				}
			}

			// If all services failed, create minimal response
			Console.WriteLine($"All location services failed. Errors: {string.Join("; ", errors)}");
			return new NetworkAddress { ip = "Unknown" };
		}
		catch (Exception ex)
		{
			Console.WriteLine($"Critical location detection failure: {ex.Message}");
			return new NetworkAddress { ip = "Error" };
		}
	}

	public static async Task<string> MyIP(HttpClient client)
	{
		// Enhanced IP detection with consensus-based verification
		var ipServices = new[]
		{
			"https://api.ipify.org",
			"https://ipinfo.io/ip",
			"https://icanhazip.com/",
			"https://api.my-ip.io/ip",
			"https://checkip.amazonaws.com",
			"https://ident.me",
			"https://ifconfig.me/ip",
		};

		var ipResults = new Dictionary<string, int>();
		var errors = new List<string>();

		foreach (var service in ipServices)
		{
			try
			{
				var response = await client.GetAsync(service);
				if (response.IsSuccessStatusCode)
				{
					var ip = (await response.Content.ReadAsStringAsync()).Trim();
					if (IsValidIP(ip))
					{
						Console.WriteLine($"IP detection via {service.Split('/')[2]}: {ip}");
						if (ipResults.ContainsKey(ip))
						{
							ipResults[ip]++;
						}
						else
						{
							ipResults[ip] = 1;
						}
					}
				}
				else
				{
					errors.Add($"{service}: HTTP {response.StatusCode}");
				}
			}
			catch (Exception ex)
			{
				errors.Add($"{service}: {ex.Message}");
			}
		}

		// Return consensus IP or most common result
		if (ipResults.Any())
		{
			var consensusIP = ipResults.OrderByDescending(kvp => kvp.Value).First().Key;
			var voteCount = ipResults.Values.Max();
			Console.WriteLine($"IP consensus reached: {consensusIP} ({voteCount} votes)");
			return consensusIP;
		}

		Console.WriteLine($"IP detection failed. Errors: {string.Join("; ", errors)}");
		return "";
	}

	/// <summary>
	/// Enhanced IP address validation
	/// </summary>
	private static bool IsValidIP(string ip)
	{
		if (string.IsNullOrWhiteSpace(ip))
			return false;

		// Basic IPv4 validation
		var parts = ip.Split('.');
		if (parts.Length != 4)
			return false;

		foreach (var part in parts)
		{
			if (!int.TryParse(part, out var num))
				return false;
			if (num < 0 || num > 255)
				return false;
		}

		return true;
	}

	/// <summary>
	/// Get detailed network diagnostics
	/// </summary>
	public static async Task<NetworkDiagnostics> GetDiagnostics(HttpClient client)
	{
		var diagnostics = new NetworkDiagnostics
		{
			Timestamp = DateTime.UtcNow,
			IpServices = new List<string>(),
			DnsServers = new List<string>(),
			ResponseTimes = new List<double>(),
		};

		try
		{
			// Test multiple IP services
			var ipServices = new[] { "https://api.ipify.org", "https://ipinfo.io/ip", "https://icanhazip.com/" };

			foreach (var service in ipServices)
			{
				var stopwatch = Stopwatch.StartNew();
				try
				{
					var response = await client.GetAsync(service);
					stopwatch.Stop();

					if (response.IsSuccessStatusCode)
					{
						var ip = (await response.Content.ReadAsStringAsync()).Trim();
						diagnostics.IpServices.Add($"{service}: {ip} ({stopwatch.ElapsedMilliseconds}ms)");
						diagnostics.ResponseTimes.Add(stopwatch.ElapsedMilliseconds);
					}
					else
					{
						diagnostics.IpServices.Add($"{service}: HTTP {response.StatusCode}");
					}
				}
				catch (Exception ex)
				{
					stopwatch.Stop();
					diagnostics.IpServices.Add($"{service}: {ex.Message} ({stopwatch.ElapsedMilliseconds}ms)");
				}
			}

			// Get DNS servers (Windows-specific)
			try
			{
				var dnsResult = await RunCommand("nslookup myip.opendns.com");
				if (!string.IsNullOrWhiteSpace(dnsResult))
				{
					diagnostics.DnsServers.Add(dnsResult);
				}
			}
			catch (Exception ex)
			{
				diagnostics.DnsServers.Add($"DNS lookup failed: {ex.Message}");
			}

			diagnostics.AverageResponseTime = diagnostics.ResponseTimes.Any() ? diagnostics.ResponseTimes.Average() : 0;

			diagnostics.NetworkStatus = diagnostics.IpServices.Count > 0 ? "Partially Available" : "Unavailable";
		}
		catch (Exception ex)
		{
			diagnostics.NetworkStatus = $"Error: {ex.Message}";
		}

		return diagnostics;
	}

	/// <summary>
	/// Run system command and get output
	/// </summary>
	private static async Task<string> RunCommand(string command)
	{
		try
		{
			var process = new Process
			{
				StartInfo = new ProcessStartInfo
				{
					FileName = "cmd",
					Arguments = $"/c {command}",
					UseShellExecute = false,
					RedirectStandardOutput = true,
					CreateNoWindow = true,
				},
			};

			process.Start();
			var output = await process.StandardOutput.ReadToEndAsync();
			await process.WaitForExitAsync();
			return output;
		}
		catch
		{
			return "";
		}
	}
}

/// <summary>
/// Network diagnostics information
/// </summary>
public class NetworkDiagnostics
{
	public DateTime Timestamp { get; set; }
	public List<string> IpServices { get; set; } = new();
	public List<string> DnsServers { get; set; } = new();
	public List<double> ResponseTimes { get; set; } = new();
	public double AverageResponseTime { get; set; }
	public string NetworkStatus { get; set; } = "Unknown";
	public bool HasInternet => IpServices.Any(s => s.Contains(':') && !s.Contains("HTTP"));
	public int WorkingServices => IpServices.Count(s => char.IsDigit(s.LastOrDefault('0')));
}
