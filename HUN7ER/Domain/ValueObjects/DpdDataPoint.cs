namespace P4NTH30N.HUN7ER.Domain.ValueObjects;

/// <summary>
/// Single DPD data point
/// </summary>
public class DpdDataPoint
{
    public DateTime Timestamp { get; set; }
    public double Grand { get; set; }
    public double Major { get; set; }
    public double Minor { get; set; }
    public double Mini { get; set; }

    public DpdDataPoint(double grand = 0, double major = 0, double minor = 0, double mini = 0)
    {
        Timestamp = DateTime.UtcNow;
        Grand = grand;
        Major = major;
        Minor = minor;
        Mini = mini;
    }

    public DpdDataPoint(DateTime timestamp, double grand, double major, double minor, double mini)
    {
        Timestamp = timestamp;
        Grand = grand;
        Major = major;
        Minor = minor;
        Mini = mini;
    }
}
