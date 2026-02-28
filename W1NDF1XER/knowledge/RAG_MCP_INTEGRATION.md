# RAG MCP Integration Knowledge

## Purpose
Captures learnings from DECISION_079: Direct RAG MCP Connection for OpenCode and WindSurf

## Integration Pattern

### MCP Server Configuration
**OpenCode Configuration**: `~/.config/opencode/oh-my-opencode.json`
```json
{
  "mcpServers": {
    "rag-server": {
      "url": "http://127.0.0.1:5100/mcp",
      "type": "remote"
    }
  }
}
```

**WindSurf Configuration**: `.windsurf/mcp_config.json`
```json
{
  "mcpServers": {
    "p4ntheon-rag": {
      "command": "C:\\P4NTH30N\\src\\RAG.McpHost\\bin\\Release\\net8.0\\win-x64\\publish\\RAG.McpHost.exe",
      "args": ["--port", "5100", "--index", "p4ntheon", "--mongo", "localhost:27017", "--workspace", "C:\\P4NTH30N"],
      "env": {
        "RAG_ENABLED": "true",
        "CHROME_CDP_PORT": "9222"
      }
    }
  }
}
```

### Key Differences
- **OpenCode**: Uses remote HTTP connection to running MCP server
- **WindSurf**: Direct command execution with embedded configuration

## RAG Server Management

### Startup Command
```powershell
Start-Process -FilePath "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe" -ArgumentList "--port","5100","--index","p4ntheon","--mongo","localhost:27017","--workspace","C:\P4NTH30N" -PassThru
```

### Health Check
```powershell
Test-NetConnection -ComputerName localhost -Port 5100
```

### MCP Tool Testing
```powershell
# List tools
Invoke-WebRequest -Uri "http://localhost:5100/mcp" -Method POST -ContentType "application/json" -Body '{"jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": {}}' -UseBasicParsing

# Query RAG
Invoke-WebRequest -Uri "http://localhost:5100/mcp" -Method POST -ContentType "application/json" -Body '{"jsonrpc": "2.0", "id": 2, "method": "tools/call", "params": {"name": "rag_query", "arguments": {"query": "test", "limit": 5}}}' -UseBasicParsing
```

## Available RAG Tools
- **rag_query**: Search knowledge base with metadata filtering
- **rag_ingest**: Ingest content
- **rag_ingest_file**: Ingest files
- **rag_status**: Get system status
- **rag_rebuild_index**: Rebuild index
- **rag_search_similar**: Find similar docs

## Troubleshooting

### Common Issues
1. **Port 5100 not accessible**: Start RAG.McpHost.exe process
2. **JSON syntax errors**: Validate configuration files
3. **Empty results**: Vector index needs population (DECISION_080)

### Validation Commands
```powershell
# Verify JSON syntax
Get-Content "config.json" | ConvertFrom-Json

# Check process status
Get-Process -Name "RAG.McpHost" -ErrorAction SilentlyContinue
```

## Architecture Notes

### Direct Connection Benefits
- Lower latency (no ToolHive gateway hop)
- Simplified troubleshooting
- Direct error visibility
- No additional infrastructure dependencies

### Port Configuration
- RAG.McpHost.exe: Port 5100 (configurable)
- MongoDB: 27017 (default)
- Chrome CDP: 9222 (for vision integration)

## Related Decisions
- DECISION_033: RAG Activation Hub
- DECISION_049: RAG Restore
- DECISION_080: RAG Content Re-ingestion (pending)

---
*Created: 2026-02-28*
*Decision: DECISION_079*
*Agent: WindFixer*
