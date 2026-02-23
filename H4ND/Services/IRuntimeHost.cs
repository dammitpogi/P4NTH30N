namespace P4NTH30N.H4ND.Services;

public interface IRuntimeHost
{
	Task<int> RunAsync(string[] args, CancellationToken ct = default);
}
