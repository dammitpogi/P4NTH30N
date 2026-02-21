# Register RAG Server with ToolHive MCP

## Problem
The mcp.json configuration file was missing. RAG server was deployed but not registered with ToolHive.

## Solution
Created: `C:\Users\paulc\.config\opencode\mcp.json`

## Configuration
```json
{
  "mcpServers": {
    "rag-server": {
      "command": "C:/ProgramData/P4NTH30N/bin/RAG.McpHost.exe",
      "args": [
        "--port", "5001",
        "--index", "C:/ProgramData/P4NTH30N/rag-index",
        "--model", "C:/ProgramData/P4NTH30N/models/all-MiniLM-L6-v2.onnx",
        "--bridge", "http://127.0.0.1:5000",
        "--mongo", "mongodb://localhost:27017/P4NTH30N"
      ],
      "env": {
        "DOTNET_ENVIRONMENT": "Production"
      }
    }
  }
}
```

## Next Steps
1. **Restart VS Code / OpenCode** (required to load new MCP configuration)
2. **Verify RAG.McpHost.exe is running** before restart:
   ```powershell
   Get-Process | Where-Object { $_.ProcessName -like "*RAG*" }
   ```
   If not running, start it:
   ```powershell
   Start-Process "C:\ProgramData\P4NTH30N\bin\RAG.McpHost.exe"
   ```
3. **After restart, verify tools appear**:
   ```bash
   toolhive list-tools | findstr rag_
   ```

## Expected Result
After restart, you should see 6 new tools:
- rag_query
- rag_ingest
- rag_ingest_file
- rag_status
- rag_rebuild_index
- rag_search_similar

## Note
The mcp.json file MUST exist before OpenCode starts. Changes to this file require a full restart to take effect.
