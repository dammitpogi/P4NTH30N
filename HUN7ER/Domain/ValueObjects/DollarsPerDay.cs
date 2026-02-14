namespace P4NTH30N.HUN7ER.Domain.ValueObjects;

public class DollarsPerDay
{
	public double Average { get; set; }
	public List<DpdDataPoint> Data { get; set; } = new();
	public List<DpdHistory> History { get; set; } = new();
	public DpdToggles Toggles { get; set; } = new();

	public bool IsHighDpdWithLowData => Average > 1000 && Data.Count < 5;

	public void AddDataPoint(DpdDataPoint dataPoint)
	{
		Data.Add(dataPoint);
		RecalculateAverage();
	}

	public void RecordHistory()
	{
		if (Data.Count == 0)
		{
			return;
		}

		History.Add(new DpdHistory(Average, Data.Select(d => new DpdDataPoint(d.Timestamp, d.Grand, d.Major, d.Minor, d.Mini)).ToList()));
		if (History.Count > 20)
		{
			History.RemoveAt(0);
		}
	}

	public void RestoreFromHistory()
	{
		if (History.Count == 0)
		{
			return;
		}

		DpdHistory latest = History[^1];
		Average = latest.Average;
		Data = latest.Data.Select(d => new DpdDataPoint(d.Timestamp, d.Grand, d.Major, d.Minor, d.Mini)).ToList();
	}

	private void RecalculateAverage()
	{
		if (Data.Count < 2)
		{
			return;
		}

		DpdDataPoint first = Data[0];
		DpdDataPoint last = Data[^1];
		double minutes = (last.Timestamp - first.Timestamp).TotalMinutes;
		if (minutes <= 0)
		{
			return;
		}

		double dollars = last.Grand - first.Grand;
		double days = minutes / TimeSpan.FromDays(1).TotalMinutes;
		double dpd = dollars / days;
		if (!double.IsNaN(dpd) && !double.IsInfinity(dpd) && dpd >= 0)
		{
			Average = dpd;
		}
	}
}
