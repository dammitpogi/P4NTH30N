using System;
using System.Collections.Generic;
using MongoDB.Bson;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.C0MMON.Entities
{
	public enum DecisionStatus
	{
		Pending,
		InProgress,
		Completed,
		Failed,
		Cancelled,
	}

	public enum ComplexityLevel
	{
		Small,
		Medium,
		Large,
		Critical,
	}

	public class RetryAttempt
	{
		public DateTime Timestamp { get; set; } = DateTime.UtcNow;
		public string Reason { get; set; } = string.Empty;
	}

	public class CheckpointDataEntry
	{
		public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
		public string SessionId { get; set; } = string.Empty;
		public string DecisionId { get; set; } = string.Empty;
		public DecisionStatus Status { get; set; } = DecisionStatus.Pending;
		public ComplexityLevel Complexity { get; set; } = ComplexityLevel.Medium;
		public decimal Cost { get; set; } = 0.0m;
		public List<RetryAttempt> RetryHistory { get; set; } = new List<RetryAttempt>();
		public DateTime ExpiresAt { get; set; } = DateTime.UtcNow.AddDays(7);

		public bool IsValid(IStoreErrors? errorLogger = null)
		{
			bool isValid = true;
			if (string.IsNullOrEmpty(SessionId))
			{
				errorLogger?.Insert(ErrorLog.Create(ErrorType.ValidationError, $"CheckpointDataEntry:{DecisionId}", "SessionId is null or empty", ErrorSeverity.High));
				isValid = false;
			}

			if (string.IsNullOrEmpty(DecisionId))
			{
				errorLogger?.Insert(ErrorLog.Create(ErrorType.ValidationError, $"CheckpointDataEntry:{SessionId}", "DecisionId is null or empty", ErrorSeverity.High));
				isValid = false;
			}

			if (Cost < 0)
			{
				errorLogger?.Insert(
					ErrorLog.Create(ErrorType.ValidationError, $"CheckpointDataEntry:{DecisionId}", $"Cost cannot be negative: {Cost}", ErrorSeverity.Medium)
				);
				isValid = false;
			}

			return isValid;
		}
	}
}
