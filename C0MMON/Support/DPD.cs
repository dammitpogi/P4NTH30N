using System;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.C0MMON;

[BsonIgnoreExtraElements]
public class DPD {
	public double Average { get; set; } = 0;
	public List<DPD_Data> Data { get; set; } = [];
	public List<DPD_History> History { get; set; } = [];
	public DPD_Toggles Toggles { get; set; } = new();
}

[BsonIgnoreExtraElements]
public class DPD_Toggles {
	public bool GrandPopped { get; set; } = false;
	public bool MajorPopped { get; set; } = false;
	public bool MinorPopped { get; set; } = false;
	public bool MiniPopped { get; set; } = false;
}

[BsonIgnoreExtraElements]
public class DPD_Data(double grand) {
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public double Grand { get; set; } = grand;
}

[BsonIgnoreExtraElements]
public class DPD_History(double average, List<DPD_Data> data) {
	public double Average { get; set; } = average;
	public List<DPD_Data> Data { get; set; } = data;
}
