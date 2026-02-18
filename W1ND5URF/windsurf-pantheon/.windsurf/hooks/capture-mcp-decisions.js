#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

// Read JSON from stdin
let input = '';
process.stdin.on('data', (chunk) => {
  input += chunk;
});

process.stdin.on('end', () => {
  try {
    const data = JSON.parse(input);
    
    if (data.agent_action_name === 'post_mcp_tool_use') {
      const toolInfo = data.tool_info || {};
      const serverName = toolInfo.mcp_server_name || '';
      const toolName = toolInfo.mcp_tool_name || '';
      const toolArgs = toolInfo.mcp_tool_arguments || {};
      const mcpResult = toolInfo.mcp_result || null;
      
      // Only capture Decisions tool calls - narrow scope
      const isDecisionsTool = (serverName === 'decisions' || 
                               toolName === 'get_decision' || 
                               toolName === 'create_decision' ||
                               toolName === 'update_decision');
      
      if (isDecisionsTool) {
        // Write to temp file for extension to pick up
        const tempFile = path.join(os.tmpdir(), 'windsurf-follower-mcp-decisions.json');
        const mcpData = {
          serverName: serverName,
          toolName: toolName,
          arguments: toolArgs,
          result: mcpResult,
          timestamp: Date.now(),
          isDecisionsTool: isDecisionsTool
        };
        
        fs.writeFileSync(tempFile, JSON.stringify(mcpData, null, 2));
        
        console.log(`Captured MCP tool use: ${serverName}.${toolName}`);
      }
    }
    
    process.exit(0);
  } catch (error) {
    console.error('Hook error:', error.message);
    process.exit(0); // Don't block the action
  }
});
