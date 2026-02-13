namespace P4NTH30N.HUN7ER.Domain.ValueObjects;

/// <summary>
/// DPD history snapshot
/// </summary>
public class DpdHistory
{
    public double Average { get; set; }
    public List<DpdDataPoint> Data { get; set; }
    public DateTime Timestamp { get; set; }

    public DpdHistory(double average, List<DpdDataPoint> data)
    {
        Average = average;
        Data = data;
        Timestamp = DateTime.UtcNow;
    }

    public DpdHistory(double average, IEnumerable<DpdDataPoint> data)
    {
        Average = average;
        Data = data.ToList();
        Timestamp = DateTime.UtcNow;
    }
}
