# Decisions-Server Container Fix Summary

## Issue
The decisions-server container in Rancher Desktop was refusing to start, stuck in a restart loop with the following symptoms:
- Container would start and immediately exit with code 0
- Logs showed: "Decisions MCP server v1.1.0 running on stdio"
- Container status showed "Restarting" repeatedly

## Root Cause
MCP servers using `stdio` transport are designed to communicate via standard input/output with a parent process (MCP client). When run as a detached Docker container (`docker run -d` or `docker-compose up -d`), the container has no stdin attached, causing the MCP server to receive EOF immediately and exit.

## Solution Applied

### 1. Fixed Docker Compose Configuration
**File**: `c:\P4NTH30N\T00L5ET\decisions-server-config\docker-compose.yml`

Added the following directives to keep stdin open:
```yaml
services:
  decisions-server:
    image: decisions-server:v1.2.0
    container_name: decisions-server
    restart: unless-stopped
    # MCP servers with stdio transport need interactive terminal
    stdin_open: true
    tty: true
    environment:
      - MONGODB_URI=mongodb://host.docker.internal:27017/P4NTH30N
      - MCP_TRANSPORT=stdio
      - NODE_OPTIONS=--dns-result-order=ipv4first
    network_mode: host
```

### 2. Rebuilt Docker Image with Schema Fix
The container was also missing the OpenAI schema fix for array parameters. Rebuilt the image with:
```bash
cd /c/Users/paulc/.config/opencode/tools/mcp-development/servers/decisions-server
docker build --no-cache -t decisions-server:v1.2.0 \
  -f /c/Users/paulc/.config/opencode/tools/deployment/docker/Dockerfile.decisions .
```

### 3. Schema Fix Details
Fixed 6 array schema definitions in `src/index.ts` by adding `items: { type: 'string' }` to:
- `findById.fields`
- `findByCategory.fields`
- `findByStatus.fields`
- `search.fields`
- `createDecision.dependencies`
- `addActionItem.files`

## Verification
Container is now running stable:
```
CONTAINER ID   IMAGE                     STATUS
a75d11134532   decisions-server:v1.2.0   Up 7 seconds (healthy)
```

## Key Takeaways
1. MCP servers with stdio transport require `stdin_open: true` and `tty: true` in docker-compose
2. Without these flags, the container exits immediately because there's no stdin to read from
3. The healthcheck in docker-compose.yml properly validates MongoDB connectivity
4. Always use `--no-cache` when rebuilding Docker images after source code changes

## Commands for Management
```bash
# Start container
cd c:\P4NTH30N\T00L5ET\decisions-server-config
docker-compose up -d

# Check status
docker ps | grep decision

# View logs
docker logs decisions-server

# Restart
docker-compose down && docker-compose up -d
```
