namespace H0UND.Infrastructure.BootTime;

public sealed class DependencyChainResolver
{
    public IReadOnlyList<string> GetStartupOrder()
    {
        return
        [
            "MongoDB",
            "LM Studio",
            "RAG Server",
            "MongoDB MCP",
            "ToolHive Gateway",
        ];
    }
}
