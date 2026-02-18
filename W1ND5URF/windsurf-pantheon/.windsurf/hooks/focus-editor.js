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
    const actionName = data.agent_action_name;
    const toolInfo = data.tool_info || {};
    
    let filePath = '';
    let line = 0;
    
    if (actionName === 'pre_read_code') {
      filePath = toolInfo.file_path || '';
    } else if (actionName === 'pre_write_code') {
      filePath = toolInfo.file_path || '';
      // For write operations, try to get the first edit line
      if (toolInfo.edits && toolInfo.edits.length > 0) {
        // We'll let the extension figure out the line from the file content
        line = 0;
      }
    }
    
    if (filePath) {
      // Write to temp file for extension to pick up
      const tempFile = path.join(os.tmpdir(), 'windsurf-follower-target.json');
      const focusData = {
        filePath: filePath,
        line: line,
        timestamp: Date.now(),
        action: actionName
      };
      
      fs.writeFileSync(tempFile, JSON.stringify(focusData, null, 2));
      
      // Also try to use VS Code CLI to open the file if needed
      // This is a fallback mechanism
      console.log(`Focus requested: ${filePath}`);
    }
    
    process.exit(0);
  } catch (error) {
    console.error('Hook error:', error.message);
    process.exit(0); // Don't block the action
  }
});
