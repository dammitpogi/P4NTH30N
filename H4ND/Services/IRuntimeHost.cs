namespace P4NTHE0N.H4ND.Services;

public interface IRuntimeHost
{
	Task<int> RunAsync(string[] args, CancellationToken ct = default);
}
