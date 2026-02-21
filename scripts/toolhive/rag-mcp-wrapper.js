// RAG MCP Server Wrapper
// This wraps the .NET RAG.McpHost.exe for ToolHive
// Usage: node rag-mcp-wrapper.js

const { spawn } = require('child_process');
const path = require('path');

const RAG_EXE = 'C:/ProgramData/P4NTH30N/bin/RAG.McpHost.exe';
const RAG_ARGS = [
  '--port', '5001',
  '--index', 'C:/ProgramData/P4NTH30N/rag-index',
  '--model', 'C:/ProgramData/P4NTH30N/models/all-MiniLM-L6-v2.onnx',
  '--bridge', 'http://127.0.0.1:5000',
  '--mongo', 'mongodb://localhost:27017/P4NTH30N'
];

console.error('Starting RAG MCP Host...');
const ragProcess = spawn(RAG_EXE, RAG_ARGS, {
  stdio: ['pipe', 'pipe', 'pipe']
});

ragProcess.stdout.on('data', (data) => {
  process.stdout.write(data);
});

ragProcess.stderr.on('data', (data) => {
  process.stderr.write(data);
});

ragProcess.on('close', (code) => {
  console.error(`RAG MCP Host exited with code ${code}`);
  process.exit(code);
});

process.on('SIGINT', () => {
  ragProcess.kill();
  process.exit(0);
});
