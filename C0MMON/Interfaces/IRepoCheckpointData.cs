using System.Collections.Generic;
using P4NTH30N.C0MMON.Entities;

namespace P4NTH30N.C0MMON.Interfaces
{
	public interface IRepoCheckpointData
	{
		CheckpointDataEntry GetCheckpoint(string decisionId);
		void SaveCheckpoint(CheckpointDataEntry checkpoint);
		IEnumerable<CheckpointDataEntry> GetCheckpointsBySession(string sessionId);
	}
}
