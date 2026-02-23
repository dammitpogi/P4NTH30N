namespace P4NTH30N.H4ND.Navigation.Verification;

/// <summary>
/// ARCH-098: Verification gate strategy for pre/post-condition checks.
/// Entry gates verify preconditions, exit gates verify postconditions.
/// </summary>
public interface IVerificationStrategy
{
	Task<bool> VerifyAsync(string gate, StepExecutionContext context, CancellationToken ct);
}
