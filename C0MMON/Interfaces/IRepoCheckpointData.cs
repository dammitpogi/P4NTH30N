
using P4NTH30N.C0MMON.Entities;
using System.Collections.Generic;

namespace P4NTH30N.C0MMON.Interfaces
{
    public interface IRepoCheckpointData
    {
        CheckpointDataEntry GetCheckpoint(string decisionId);
        void SaveCheckpoint(CheckpointDataEntry checkpoint);
        IEnumerable<CheckpointDataEntry> GetCheckpointsBySession(string sessionId);
    }
}
