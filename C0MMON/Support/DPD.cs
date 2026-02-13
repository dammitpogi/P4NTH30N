using System;
using MongoDB.Bson.Serialization.Attributes;
using P4NTH30N.C0MMON.Persistence;

namespace P4NTH30N.C0MMON;

[BsonIgnoreExtraElements]
public class DPD {
	public double Average { get; set; } = 0;
	public List<DPD_Data> Data { get; set; } = [];
	public List<DPD_History> History { get; set; } = [];
	public DPD_Toggles Toggles { get; set; } = new();

	/// <summary>
	/// Validates DPD - returns true if valid. Logs to ERR0R if invalid and errorLogger provided.
	/// </summary>
	public bool IsValid(IStoreErrors? errorLogger = null) {
		if (double.IsNaN(Average) || double.IsInfinity(Average)) {
			errorLogger?.Insert(ErrorLog.Create(
				ErrorType.ValidationError,
				"DPD",
				$"Invalid DPD average: {Average}",
				ErrorSeverity.High
			));
			return false;
		}
		if (Average < 0) {
			errorLogger?.Insert(ErrorLog.Create(
				ErrorType.ValidationError,
				"DPD",
				$"Negative DPD average: {Average}",
				ErrorSeverity.High
			));
			return false;
		}
		return true;
	}
}

[BsonIgnoreExtraElements]
public class DPD_Toggles {
	public bool GrandPopped { get; set; } = false;
	public bool MajorPopped { get; set; } = false;
	public bool MinorPopped { get; set; } = false;
	public bool MiniPopped { get; set; } = false;
}

[BsonIgnoreExtraElements]
public class DPD_Data {
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public double Grand { get; set; }
	public double Major { get; set; }
	public double Minor { get; set; }
	public double Mini { get; set; }

	public DPD_Data() { }

	public DPD_Data(double grand, double major, double minor, double mini) {
		Grand = grand;
		Major = major;
		Minor = minor;
		Mini = mini;
	}
}

[BsonIgnoreExtraElements]
public class DPD_History(double average, List<DPD_Data> data) {
	public double Average { get; set; } = average;
	public List<DPD_Data> Data { get; set; } = data;
}
