#!/bin/bash
# Deploy Kimi MCP Server to ToolHive

set -e

echo "Building Kimi MCP Server..."

# Build Docker image
docker build -t kimi-code-mcp:latest .

# Tag for ToolHive (adjust registry as needed)
# docker tag kimi-code-mcp:latest localhost:5000/kimi-code-mcp:latest
# docker push localhost:5000/kimi-code-mcp:latest

echo "Deploying to ToolHive..."

# Deploy using ToolHive CLI
# Note: Ensure 'thv' CLI is installed and configured
# https://docs.stacklok.com/toolhive/tutorials/quickstart-cli

thv deploy \
  --name kimi-code-mcp \
  --file toolhive.yaml \
  --env KIMI_API_KEY="${KIMI_API_KEY:-sk-kimi-CrARTjZkPzkyctrXhcpKrKtUohV2g4PiYDoXm6klvpJkz0MYiVxHM4fnVtjFyfxF}" \
  --env KIMI_BASE_URL="https://api.kimi.com/coding"

echo "Deployment complete!"
echo ""
echo "Next steps:"
echo "1. Verify server is running: thv list"
echo "2. Copy windsurf-mcp-config.json to ~/.codeium/mcp_config.json"
echo "3. Restart Windsurf"
echo "4. Go to Settings > Tools > Windsurf Settings > Add Server"
echo "5. Click 'Refresh' and enable 'kimi-code'"
