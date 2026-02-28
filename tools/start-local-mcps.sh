#!/bin/bash
# Start local MCP servers and expose them via ToolHive

echo "Starting P4NTHE0N Local MCP Servers..."

# Function to start an MCP server via ToolHive stdio bridge
start_mcp() {
    local name=$1
    local command=$2
    local port=$3
    
    echo "Starting $name on port $port..."
    
    # Use thv proxy stdio to bridge stdio to HTTP
    thv proxy stdio "$name" --target-port "$port" &
}

# Start the three local MCPs
cd /c/P4NTHE0N/tools/mcp-foureyes
start_mcp "foureyes-mcp" "node server.js" 5302

cd /c/P4NTHE0N/tools/mcp-development/servers/honeybelt-server  
start_mcp "honeybelt-server" "node dist/index.js" 5303

cd /c/Users/paulc/AppData/Local/json-query-mcp
start_mcp "json-query-mcp" "node dist/index.js" 5304

echo "All local MCPs started via ToolHive stdio bridge"
