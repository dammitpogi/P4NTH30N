namespace C0MMON.Interfaces
{
    public interface ISignalRepository
    {
        // Stage interface for signal persistence. Keep compatibility with legacy and migration flows.
        object GetNextSignal(string gameId);
        void CreateSignal(object signalRecord);
        void MarkAcknowledged(string signalId);
    }
}
