namespace P4NTH30N.HUN7ER.Domain.ValueObjects;

/// <summary>
/// Tracks which jackpots have popped in current cycle
/// </summary>
public class DpdToggles
{
    public bool GrandPopped { get; set; }
    public bool MajorPopped { get; set; }
    public bool MinorPopped { get; set; }
    public bool MiniPopped { get; set; }

    public void Reset()
    {
        GrandPopped = false;
        MajorPopped = false;
        MinorPopped = false;
        MiniPopped = false;
    }

    public void MarkPopped(JackpotTier tier)
    {
        switch (tier)
        {
            case JackpotTier.Grand: GrandPopped = true; break;
            case JackpotTier.Major: MajorPopped = true; break;
            case JackpotTier.Minor: MinorPopped = true; break;
            case JackpotTier.Mini: MiniPopped = true; break;
        }
    }

    public void MarkResolved(JackpotTier tier)
    {
        switch (tier)
        {
            case JackpotTier.Grand: GrandPopped = false; break;
            case JackpotTier.Major: MajorPopped = false; break;
            case JackpotTier.Minor: MinorPopped = false; break;
            case JackpotTier.Mini: MiniPopped = false; break;
        }
    }

    public bool IsPopped(JackpotTier tier) => tier switch
    {
        JackpotTier.Grand => GrandPopped,
        JackpotTier.Major => MajorPopped,
        JackpotTier.Minor => MinorPopped,
        JackpotTier.Mini => MiniPopped,
        _ => false
    };
}
