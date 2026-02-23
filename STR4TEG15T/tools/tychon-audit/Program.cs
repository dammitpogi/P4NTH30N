using System.Text.RegularExpressions;

internal static class Program
{
    private static readonly RegexOptions R =
        RegexOptions.Compiled | RegexOptions.Multiline | RegexOptions.Singleline;

    private static readonly Regex EmptyCatchRegex = new(
        @"catch\s*\(\s*Exception(?:\s+\w+)?\s*\)\s*\{(?<body>.*?)\}",
        R
    );

    private static readonly Regex ThrowRegex = new(@"\bthrow\b", R);

    private static readonly Regex DefaultSuccessRegex = new(
        @"catch\s*\([^\)]*\)\s*\{(?<body>.*?)\breturn\s+true\s*;(?<tail>.*?)\}",
        R
    );

    private static readonly Regex AsyncVoidRegex = new(
        @"\basync\s+void\s+\w+\s*\(",
        RegexOptions.Compiled | RegexOptions.Multiline
    );

    private static readonly Regex LogThenReturnRegex = new(
        @"\bLog(?:Warning|Error)\s*\(.*?\)\s*;(?:(?!\bthrow\b).)*?\breturn\s+[^;]+;",
        R
    );

    private static readonly Regex SkippedActionRegex = new(
        @"if\s*\([^\)]*\)\s*\{(?<body>.*?)\bLog(?:Warning|Error)\s*\(.*?\)\s*;(?<tail>.*?)\breturn\s+(?:true|[A-Za-z0-9_\.]*Success[A-Za-z0-9_\.]*)\s*;(?<end>.*?)\}",
        R
    );

    private const int SampleLimit = 3;

    private sealed record Violation(string FilePath, int Line);

    private sealed class Bucket
    {
        public List<Violation> Items { get; } = new();
        public int Count => Items.Count;
    }

    public static int Main(string[] args)
    {
        var root = args.Length > 0
            ? Path.GetFullPath(args[0])
            : FindRepositoryRoot(Directory.GetCurrentDirectory());

        var files = Directory
            .EnumerateFiles(root, "*.cs", SearchOption.AllDirectories)
            .Where(IsProjectCodeFile)
            .ToList();

        var emptyCatch = new Bucket();
        var defaultSuccess = new Bucket();
        var asyncVoid = new Bucket();
        var logWithoutFail = new Bucket();
        var skippedAction = new Bucket();

        foreach (var file in files)
        {
            var content = File.ReadAllText(file);

            foreach (Match match in EmptyCatchRegex.Matches(content))
            {
                var body = match.Groups["body"].Value;
                if (!ThrowRegex.IsMatch(body))
                {
                    emptyCatch.Items.Add(new Violation(file, GetLine(content, match.Index)));
                }
            }

            foreach (Match match in DefaultSuccessRegex.Matches(content))
            {
                defaultSuccess.Items.Add(new Violation(file, GetLine(content, match.Index)));
            }

            foreach (Match match in AsyncVoidRegex.Matches(content))
            {
                asyncVoid.Items.Add(new Violation(file, GetLine(content, match.Index)));
            }

            foreach (Match match in LogThenReturnRegex.Matches(content))
            {
                logWithoutFail.Items.Add(new Violation(file, GetLine(content, match.Index)));
            }

            foreach (Match match in SkippedActionRegex.Matches(content))
            {
                skippedAction.Items.Add(new Violation(file, GetLine(content, match.Index)));
            }
        }

        var totalViolations =
            emptyCatch.Count
            + defaultSuccess.Count
            + asyncVoid.Count
            + logWithoutFail.Count
            + skippedAction.Count;

        var truthScore = Math.Max(0, 100 - (int)Math.Ceiling(totalViolations * 0.62));

        Console.WriteLine("TYCHON AUDIT REPORT");
        Console.WriteLine("===================");
        Console.WriteLine($"Files Scanned: {files.Count}");
        Console.WriteLine("Patterns Found:");
        Console.WriteLine($"  - Empty catches: {emptyCatch.Count} {FormatSamples(root, emptyCatch)}");
        Console.WriteLine($"  - Default-success returns: {defaultSuccess.Count} {FormatSamples(root, defaultSuccess)}");
        Console.WriteLine($"  - Async void: {asyncVoid.Count} {FormatSamples(root, asyncVoid)}");
        Console.WriteLine($"  - Logging without failing: {logWithoutFail.Count} {FormatSamples(root, logWithoutFail)}");
        Console.WriteLine($"  - Skipped actions: {skippedAction.Count} {FormatSamples(root, skippedAction)}");
        Console.WriteLine();
        Console.WriteLine($"Truth Score: {truthScore}/100");

        if (totalViolations > 0)
        {
            Console.WriteLine($"Recommendation: Fix {totalViolations} violations to reach 100/100");
        }
        else
        {
            Console.WriteLine("Recommendation: Canon achieved. No silent-failure violations found.");
        }

        return totalViolations == 0 ? 0 : 1;
    }

    private static bool IsProjectCodeFile(string path)
    {
        var normalized = path.Replace('\\', '/');
        if (normalized.Contains("/.git/", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        if (normalized.Contains("/bin/", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        if (normalized.Contains("/obj/", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        if (normalized.Contains("/node_modules/", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        return true;
    }

    private static int GetLine(string content, int index)
    {
        var line = 1;
        for (var i = 0; i < index && i < content.Length; i++)
        {
            if (content[i] == '\n')
            {
                line++;
            }
        }

        return line;
    }

    private static string FormatSamples(string root, Bucket bucket)
    {
        if (bucket.Count == 0)
        {
            return string.Empty;
        }

        var samples = bucket.Items
            .Take(SampleLimit)
            .Select(v => $"{Path.GetRelativePath(root, v.FilePath).Replace('\\', '/')}:{v.Line}")
            .ToArray();

        return $"({string.Join(", ", samples)}{(bucket.Count > SampleLimit ? ", ..." : string.Empty)})";
    }

    private static string FindRepositoryRoot(string start)
    {
        var current = new DirectoryInfo(start);
        while (current is not null)
        {
            if (Directory.Exists(Path.Combine(current.FullName, ".git")))
            {
                return current.FullName;
            }

            current = current.Parent;
        }

        return start;
    }
}
