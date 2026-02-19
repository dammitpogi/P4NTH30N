
# Explorer & Librarian Sub-Agent Workarounds

**Last Updated:** 2026-02-18

## 1. Current Status

**STATUS: DEGRADED**

Due to ongoing model provider instability, the standard fallback mechanism for the `@explorer` and `@librarian` sub-agents is currently impaired. As of the last update, **6 models** in the primary and secondary fallback chains are intermittently failing.

This can result in tasks delegated to these agents failing or timing out. The proactive circuit breaker (FALLBACK-003) has been implemented to prevent cascading failures, but this means these agents may be temporarily unavailable.

## 2. Manual Workaround Procedures

When `@explorer` or `@librarian` tasks fail, do not abandon the workflow. Instead, perform their discovery and research functions manually using direct tool execution.

### Explorer Workaround: Manual File & Content Discovery

Instead of `background_task(agent='explorer', ...)` use a combination of `glob`, `grep`, and `read`.

**Example: Find all references to `IModelTriageRepository`**

1.  **Find relevant files (`glob`)**

    ```
    glob(pattern='**/*.cs')
    ```

2.  **Search content within those files (`grep`)**

    ```
    grep(pattern='IModelTriageRepository', include='**/*.cs')
    ```

3.  **Read the specific files of interest (`read`)**

    ```
    read(filePath='C0MMON/Infrastructure/Resilience/ProactiveCircuitBreaker.cs')
    ```

### Librarian Workaround: Manual Research

Instead of `background_task(agent='librarian', ...)` for documentation or web searches, use the `toolhive` and `webfetch` tools directly.

**Example: Research .NET `System.Threading.Timer`**

1.  **Find a suitable web search tool (`toolhive_mcp_optimizer_find_tool`)**

    ```
    toolhive_mcp_optimizer_find_tool(tool_keywords='web search')
    ```

2.  **Call the web search tool (`toolhive_mcp_optimizer_call_tool`)**

    ```
    toolhive_mcp_optimizer_call_tool(
        server_name='web_search_server',
        tool_name='search',
        parameters={'query': 'C# System.Threading.Timer class'}
    )
    ```

3.  **Fetch content from a promising URL (`webfetch`)**

    ```
    webfetch(url='https://learn.microsoft.com/en-us/dotnet/api/system.threading.timer')
    ```

## 3. Re-Enabling Criteria

Full sub-agent functionality will be restored when the following conditions are met:

1.  The root cause of the model provider instability is resolved.
2.  The models in the `oh-my-opencode-theseus.json` triage list have had their `failureCount` reduced to zero by the `TriageCleanupService` (FALLBACK-002).
3.  Manual verification confirms that `background_task` delegations to `@explorer` and `@librarian` complete successfully for 5 consecutive, non-trivial tasks.

Until then, follow the manual workarounds outlined above.
