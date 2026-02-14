namespace C0MMON.Interfaces
{
	public interface ICredentialRepository
	{
		// Stage interface for credential persistence. Implementations should capture inputs and outputs for replay.
		object GetById(string credentialId);
		void UpdateBalance(string credentialId, decimal balance);
		void UpdateLockState(string credentialId, bool isLocked);
	}
}
