namespace P4NTH30N.C0MMON.Infrastructure.Cdp;

/// <summary>
/// Configuration for Chrome DevTools Protocol client.
/// Bound from appsettings.json P4NTH30N:H4ND:Cdp section.
/// </summary>
public sealed class CdpConfig
{
	public string HostIp { get; set; } = "192.168.56.1";
	public int Port { get; set; } = 9222;
	public int ReconnectRetries { get; set; } = 3;
	public int ReconnectBaseDelayMs { get; set; } = 1000;
	public int CommandTimeoutMs { get; set; } = 10000;
	public int SelectorTimeoutMs { get; set; } = 10000;
}
