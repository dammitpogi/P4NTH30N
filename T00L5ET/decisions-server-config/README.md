# Decisions Server Configuration Manager

This directory contains configuration and management scripts for the decisions-server MCP server.

## Problem

The decisions-server:v1.2.0 container has a bug where it doesn't properly read the MONGODB_URI environment variable, defaulting to localhost:27017 instead.

## Solution

Use the `host-gateway` Docker feature to map host.docker.internal properly, or use the MongoDB MCP server as a proxy.

## Files

- `docker-compose.yml` - Docker Compose configuration for proper networking
- `config.env` - Environment variables configuration
- `start-server.ps1` - PowerShell script to start the server with proper config
- `start-server.sh` - Bash script for Linux/Mac

## Quick Start

### Option 1: Using Docker Compose (Recommended)

```powershell
cd C:\P4NTH30N\T00L5ET\decisions-server-config
docker-compose up -d
```

### Option 2: Using PowerShell Script

```powershell
.\start-server.ps1
```

### Option 3: Using ToolHive with Fixed Config

The ToolHive run config has been updated to use the correct MongoDB connection string.

## MongoDB Connection

The decisions-server connects to MongoDB at:
- Host: `host.docker.internal` (Windows) or `172.18.0.1` (Linux bridge)
- Port: `27017`
- Database: `P4NTH30N`

## Verification

Test the server:
```bash
curl -s http://localhost:<PORT>/mcp -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"listCategories","arguments":{}}}'
```

## Troubleshooting

1. **Connection Refused**: Ensure MongoDB is running on the host and accessible from Docker
2. **Timeout**: Check firewall rules for port 27017
3. **Environment Variable Not Read**: This is a known bug - use the provided workarounds

## Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   decisions-    │────▶│  host.docker.    │────▶│  MongoDB on     │
│   server        │     │  internal:27017  │     │  Host           │
│   (Docker)      │     │                  │     │  (127.0.0.1)    │
└─────────────────┘     └──────────────────┘     └─────────────────┘
```
