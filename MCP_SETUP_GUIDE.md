# MCP AI Server Configuration for P4NTHE0N

## Overview
This configuration sets up the MCP AI Server by Ladislav Sopko to work with the P4NTHE0N solution in both Visual Studio Community and WindSurf.

## Configuration Files Created

### 1. Visual Studio Community MCP Configuration
**File**: `c:\P4NTH30N\.mcp\mcp.json`

This file configures MCP servers for Visual Studio Community with:
- **p4ntheon-rag**: RAG (Retrieval-Augmented Generation) server for P4NTHE0N knowledge
- **chrome-devtools**: Chrome DevTools MCP server for browser automation
- **p4ntheon-tools**: P4NTHE0N tools server
- **Microsoft Learn**: Microsoft Learn integration

### 2. WindSurf MCP Configuration  
**File**: `c:\P4NTH30N\.windsurf\mcp_config.json`

This file configures the same MCP servers for WindSurf compatibility.

## MCP Servers Configured

### p4ntheon-rag
- **Purpose**: Provides RAG capabilities for P4NTHE0N documentation and decisions
- **Binary**: `C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe`
- **Port**: 5100
- **Model**: all-MiniLM-L6-v2.onnx (86MB)
- **MongoDB**: 192.168.56.1:27017
- **Workspace**: C:\P4NTH30N

### chrome-devtools
- **Purpose**: Chrome DevTools Protocol integration for browser automation
- **Server**: Node.js server at `c:\P4NTH30N\chrome-devtools-mcp\server.js`
- **Port**: 5301 (HTTP)
- **CDP Target**: 192.168.56.1:9222

### p4ntheon-tools
- **Purpose**: P4NTHE0N specific tools and utilities
- **Binary**: `C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe`
- **MongoDB**: 192.168.56.1:27017
- **Chrome CDP**: Port 9222

## Setup Instructions

### For Visual Studio Community
1. Open Visual Studio Community
2. Load the P4NTHE0N solution (`c:\P4NTH30N\P4NTHE0N.slnx`)
3. The MCP configuration will be automatically detected from `.mcp/mcp.json`
4. MCP servers will start when you use AI features

### For WindSurf
1. Open WindSurf
2. Load the P4NTHE0N workspace
3. The MCP configuration will be automatically detected from `.windsurf/mcp_config.json`
4. MCP servers will start when you use AI features

## Prerequisites

### Required Software
- Visual Studio Community 2022 (17.8+ with MCP support)
- Node.js (for chrome-devtools MCP server)
- MongoDB (accessible at 192.168.56.1:27017)
- Chrome with remote debugging enabled on port 9222

### Chrome Launch Command
```bash
chrome.exe --remote-debugging-port=9222 --remote-debugging-address=127.0.0.1 --incognito --no-first-run --ignore-certificate-errors --disable-web-security --allow-running-insecure-content --disable-features=SafeBrowsing --user-data-dir="C:\Users\paulc\AppData\Local\Temp\chrome_debug_9222"
```

### RAG Model
- ONNX model should be at: `C:\ProgramData\P4NTH30N\rag\models\all-MiniLM-L6-v2.onnx`
- If not present, download from: https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2

## Verification

### Test MCP Server Status
```powershell
# Test Chrome DevTools MCP
Invoke-RestMethod -Uri "http://localhost:5301/health" -Method GET

# Test RAG MCP (if running)
Invoke-RestMethod -Uri "http://localhost:5100/health" -Method GET
```

### Test in Visual Studio
1. Open any C# file in the P4NTHE0N solution
2. Use Ctrl+I to open AI chat
3. Ask: "What MCP servers are available?"
4. The AI should respond with the configured servers

### Test in WindSurf
1. Open any C# file in the P4NTHE0N workspace  
2. Use the AI chat feature
3. Ask: "List available MCP tools"
4. The AI should show tools from all configured servers

## Troubleshooting

### MCP Servers Not Starting
1. Check binary paths exist:
   - `Test-Path "C:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish\RAG.McpHost.exe"`
   - `Test-Path "C:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish\T00L5ET.exe"`

2. Check Chrome DevTools server:
   - `Get-Process -Name "node"` - should show server running
   - `Invoke-RestMethod -Uri "http://localhost:5301/health"` - should return status

3. Check MongoDB connectivity:
   - Test connection: `Test-NetConnection -ComputerName 192.168.56.1 -Port 27017`

### Binary Not Found
If MCP binaries don't exist, rebuild:
```powershell
dotnet publish "c:\P4NTH30N\src\RAG.McpHost\RAG.McpHost.csproj" -c Release -r win-x64 --self-contained -o "c:\P4NTH30N\src\RAG.McpHost\bin\Release\net8.0\win-x64\publish"
dotnet publish "c:\P4NTH30N\T00L5ET\T00L5ET.csproj" -c Release -r win-x64 --self-contained -o "c:\P4NTH30N\T00L5ET\bin\Release\net8.0\win-x64\publish"
```

### Chrome CDP Not Connected
1. Start Chrome with the correct launch flags
2. Verify CDP is accessible: `Invoke-RestMethod -Uri "http://localhost:9222/json/version"` -Method GET
3. Check Chrome DevTools MCP server status: `Invoke-RestMethod -Uri "http://localhost:5301/health"` -Method GET

## Architecture

The MCP configuration provides:
- **Knowledge Retrieval**: RAG server provides access to P4NTHE0N documentation, decisions, and code context
- **Browser Automation**: Chrome DevTools server enables CDP commands for game automation
- **P4NTHE0N Tools**: Custom tools for credential management, signal processing, and game interaction
- **Microsoft Integration**: Built-in Microsoft Learn access for documentation

This setup enables AI assistants to have full context of the P4NTHE0N codebase and provide intelligent assistance for development, debugging, and automation tasks.
