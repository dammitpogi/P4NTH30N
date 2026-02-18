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
    
    if (data.agent_action_name === 'post_cascade_response') {
      const toolInfo = data.tool_info || {};
      const response = toolInfo.response || '';
      const trajectoryId = data.trajectory_id || 'unknown';
      const timestamp = data.timestamp || new Date().toISOString();
      
      // Parse the response to extract key information
      const parsedResponse = parseResponse(response);
      
      // Write to temp file for extension to pick up
      const tempFile = path.join(os.tmpdir(), 'windsurf-follower-decisions.json');
      const decisionData = {
        trajectoryId: trajectoryId,
        timestamp: timestamp,
        fullResponse: response,
        summary: parsedResponse,
        receivedAt: Date.now()
      };
      
      fs.writeFileSync(tempFile, JSON.stringify(decisionData, null, 2));
      
      console.log(`Captured Cascade response: ${trajectoryId}`);
    }
    
    process.exit(0);
  } catch (error) {
    console.error('Hook error:', error.message);
    process.exit(0); // Don't block the action
  }
});

function parseResponse(response) {
  const summary = {
    plannerResponses: [],
    triggeredRules: [],
    actions: [],
    fileReads: [],
    fileWrites: [],
    commands: []
  };
  
  // Extract planner responses (thinking/decisions)
  const plannerMatches = response.match(/### Planner Response[\s\S]*?(?=###|$)/g);
  if (plannerMatches) {
    summary.plannerResponses = plannerMatches.map(m => m.replace(/### Planner Response\n*/, '').trim());
  }
  
  // Extract triggered rules
  const ruleMatches = response.match(/- \(([^)]+)\) Triggered Rule: (.+?)(?:\s*$)/gm);
  if (ruleMatches) {
    ruleMatches.forEach(match => {
      const typeMatch = match.match(/- \(([^)]+)\) Triggered Rule: (.+)/);
      if (typeMatch) {
        summary.triggeredRules.push({
          type: typeMatch[1],
          rule: typeMatch[2].trim()
        });
      }
    });
  }
  
  // Extract file reads
  const readMatches = response.match(/\*Read (?:file|directory) `(.+?)`\*/g);
  if (readMatches) {
    summary.fileReads = readMatches.map(m => {
      const pathMatch = m.match(/`(.+?)`/);
      return pathMatch ? pathMatch[1] : m;
    });
  }
  
  // Extract file writes
  const writeMatches = response.match(/\*(?:Created|Modified|Deleted) file `(.+?)`\*/g);
  if (writeMatches) {
    summary.fileWrites = writeMatches.map(m => {
      const pathMatch = m.match(/`(.+?)`/);
      return pathMatch ? pathMatch[1] : m;
    });
  }
  
  // Extract commands
  const commandMatches = response.match(/\*Ran (?:command|bash|cmd) `(.+?)`\*/g);
  if (commandMatches) {
    summary.commands = commandMatches.map(m => {
      const cmdMatch = m.match(/`(.+?)`/);
      return cmdMatch ? cmdMatch[1] : m;
    });
  }
  
  return summary;
}
