namespace P4NTH30N.HUN7ER.Domain.ValueObjects;

/// <summary>
/// Represents current jackpot values
/// </summary>
public class JackpotValues
{
    public double Grand { get; set; }
    public double Major { get; set; }
    public double Minor { get; set; }
    public double Mini { get; set; }

    public JackpotValues(double grand = 0, double major = 0, double minor = 0, double mini = 0)
    {
        Grand = grand;
        Major = major;
        Minor = minor;
        Mini = mini;
    }

    public bool IsValid =>
        !double.IsNaN(Grand) && !double.IsInfinity(Grand) && Grand >= 0 &&
        !double.IsNaN(Major) && !double.IsInfinity(Major) && Major >= 0 &&
        !double.IsNaN(Minor) && !double.IsInfinity(Minor) && Minor >= 0 &&
        !double.IsNaN(Mini) && !double.IsInfinity(Mini) && Mini >= 0;

    public void ClampToValid()
    {
        if (double.IsNaN(Grand) || double.IsInfinity(Grand) || Grand < 0) Grand = 0;
        if (double.IsNaN(Major) || double.IsInfinity(Major) || Major < 0) Major = 0;
        if (double.IsNaN(Minor) || double.IsInfinity(Minor) || Minor < 0) Minor = 0;
        if (double.IsNaN(Mini) || double.IsInfinity(Mini) || Mini < 0) Mini = 0;
    }

    public JackpotValues Cloned() => new(Grand, Major, Minor, Mini);
}
