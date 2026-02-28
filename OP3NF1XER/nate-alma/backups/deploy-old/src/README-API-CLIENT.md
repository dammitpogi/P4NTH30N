# OpenClaw API Client Tool

A comprehensive command-line tool for interacting with OpenClaw Railway deployment API endpoints. Features full schema validation, interactive wizards, and verbose documentation.

## 🚀 Installation

```bash
# Install dependencies
npm install commander inquirer chalk ora

# Or use the provided package.json
cp package-api-client.json package.json
npm install

# Make executable (Unix/Linux/macOS)
chmod +x openclaw-api-client.js
```

## 🔧 Configuration

The tool requires your OpenClaw deployment URL and credentials:

```bash
# Environment variables (optional)
export OPENCLAW_URL="https://your-app.railway.app"
export OPENCLAW_PASSWORD="your-setup-password"
export OPENCLAW_TOKEN="your-gateway-token"
```

## 📖 Usage Examples

### Basic Health Check

```bash
# Public health (no auth required)
node openclaw-api-client.js -u https://your-app.railway.app health --public

# Full system health (requires setup password)
node openclaw-api-client.js -u https://your-app.railway.app -p your-password health
```

### Configuration Management

```bash
# Get current configuration
node openclaw-api-client.js -u https://your-app.railway.app -p your-password config get

# Save configuration from file
node openclaw-api-client.js -u https://your-app.railway.app -p your-password config set -f config.json

# Reset configuration
node openclaw-api-client.js -u https://your-app.railway.app -p your-password config reset
```

### Interactive Onboarding

```bash
# Run interactive onboarding wizard
node openclaw-api-client.js -u https://your-app.railway.app -p your-password onboard -i
```

### Debug Console Commands

```bash
# Check OpenClaw status
node openclaw-api-client.js -u https://your-app.railway.app -p your-password console openclaw.status

# Get last 100 log lines
node openclaw-api-client.js -u https://your-app.railway.app -p your-password console "openclaw.logs" "100"

# Run diagnostics
node openclaw-api-client.js -u https://your-app.railway.app -p your-password console openclaw.doctor

# Restart gateway
node openclaw-api-client.js -u https://your-app.railway.app -p your-password console gateway.restart
```

### Device Management

```bash
# List pending devices
node openclaw-api-client.js -u https://your-app.railway.app -p your-password devices list

# Approve a device
node openclaw-api-client.js -u https://your-app.railway.app -p your-password devices approve "req_123456"
```

### Backup Operations

```bash
# Export backup (auto-generated filename)
node openclaw-api-client.js -u https://your-app.railway.app -p your-password backup export

# Export backup to specific path
node openclaw-api-client.js -u https://your-app.railway.app -p your-password backup export ./my-backup.tar.gz

# Import backup
node openclaw-api-client.js -u https://your-app.railway.app -p your-password backup import ./my-backup.tar.gz
```

### Documentation

```bash
# Show all endpoint documentation
node openclaw-api-client.js docs

# Show specific endpoint documentation
node openclaw-api-client.js docs health
node openclaw-api-client.js docs onboard
node openclaw-api-client.js docs console
```

## 📋 API Endpoint Reference

### Health & Status Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/healthz` | GET | None | Public health check with gateway status |
| `/setup/healthz` | GET | None | Minimal health check for Railway |
| `/setup/api/status` | GET | Basic | Detailed system status and version |

### Configuration Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/setup/api/config/raw` | GET | Basic | Get raw configuration file |
| `/setup/api/config/raw` | POST | Basic | Save configuration (creates backup) |
| `/setup/api/reset` | POST | Basic | Reset/delete configuration |

### Onboarding Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/setup/api/run` | POST | Basic | Run OpenClaw onboarding |
| `/setup/api/auth-groups` | GET | Basic | Get auth providers |

### Debug & Console Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/setup/api/debug` | GET | Basic | Get debug information |
| `/setup/api/console/run` | POST | Basic | Execute debug commands |

### Device Management Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/setup/api/devices/pending` | GET | Basic | List pending devices |
| `/setup/api/devices/approve` | POST | Basic | Approve device |
| `/setup/api/pairing/approve` | POST | Basic | Approve pairing |

### Backup Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/setup/export` | GET | Basic | Download backup (.tar.gz) |
| `/setup/import` | POST | Basic | Import backup file |

### Proxy Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/openclaw/*` | ALL | Bearer | Proxy to OpenClaw gateway |

## 🔐 Authentication

### Setup Authentication
- **Type**: Basic Authentication
- **Username**: Any value (ignored)
- **Password**: Your `SETUP_PASSWORD` environment variable
- **Header**: `Authorization: Basic <base64(:password)>`

### Gateway Authentication
- **Type**: Bearer Token
- **Token**: Your `OPENCLAW_GATEWAY_TOKEN` environment variable
- **Header**: `Authorization: Bearer <token>`

## 📝 Onboarding Schema

### Required Fields
```json
{
  "authGroup": "openai|anthropic|google|openrouter|ai-gateway|moonshot|zai|minimax|qwen|copilot|synthetic|opencode-zen",
  "authChoice": "provider-specific-method",
  "flow": "quickstart|advanced|manual"
}
```

### Optional Fields
```json
{
  "authSecret": "api-key-or-token",
  "telegramToken": "bot-token",
  "discordToken": "bot-token", 
  "slackBotToken": "bot-token",
  "slackAppToken": "app-token",
  "customProviderId": "provider-id",
  "customProviderBaseUrl": "https://host:port/v1",
  "customProviderApi": "openai-completions|openai-responses",
  "customProviderApiKeyEnv": "ENV_VAR_NAME",
  "customProviderModelId": "model-id"
}
```

### Authentication Providers

| Provider | Auth Methods | Requires Secret |
|----------|--------------|-----------------|
| OpenAI | openai-codex, openai-api-key | Yes (API key) |
| Anthropic | claude-cli, token, apiKey | Yes (token/key) |
| Google | gemini-api-key, google-antigravity, google-gemini-cli | Yes (API key) |
| OpenRouter | openrouter-api-key | Yes |
| Vercel AI Gateway | ai-gateway-api-key | Yes |
| Moonshot AI | moonshot-api-key, kimi-code-api-key | Yes |
| Z.AI (GLM 4.7) | zai-api-key | Yes |
| MiniMax | minimax-api, minimax-api-lightning | Yes |
| Qwen | qwen-portal | No (OAuth) |
| GitHub Copilot | github-copilot, copilot-proxy | No (OAuth) |
| Synthetic | synthetic-api-key | Yes |
| OpenCode Zen | opencode-zen | Yes |

## 🛠️ Debug Console Commands

### Gateway Management
```bash
gateway.restart    # Restart gateway process
gateway.start      # Start gateway process  
gateway.stop       # Stop gateway process
```

### OpenClaw Status
```bash
openclaw.status    # Show OpenClaw status
openclaw.health    # Show OpenClaw health
openclaw.doctor    # Run diagnostics
```

### Logs & Configuration
```bash
openclaw.logs --tail N    # Show last N log lines (default: 200)
openclaw.config get <path> # Get configuration value
```

### Device & Plugin Management
```bash
openclaw.devices list           # List devices
openclaw.devices approve <id>   # Approve device
openclaw.plugins list           # List plugins
openclaw.plugins enable <name>  # Enable plugin
```

## 💾 Backup & Restore

### Export Features
- **Format**: tar.gz archive
- **Contents**: `.openclaw/` directory and `workspace/`
- **Location**: Configurable output path
- **Auto-naming**: Date-stamped filenames

### Import Features
- **Format**: tar.gz archive (from export)
- **Target**: `/data` directory (Railway volume)
- **Action**: Restores state and restarts gateway
- **Validation**: Path safety checks and size limits (250MB)

### Example Workflow
```bash
# Create backup before major changes
node openclaw-api-client.js -u $URL -p $PASS backup export ./before-update.tar.gz

# Make configuration changes
node openclaw-api-client.js -u $URL -p $PASS config set -f new-config.json

# Test changes
node openclaw-api-client.js -u $URL -p $PASS console openclaw.status

# Rollback if needed
node openclaw-api-client.js -u $URL -p $PASS backup import ./before-update.tar.gz
```

## 🚨 Error Handling

The tool provides comprehensive error handling:

- **Network Errors**: Connection timeouts, DNS failures
- **Authentication Errors**: Invalid credentials, expired tokens
- **API Errors**: Invalid requests, server errors
- **File Errors**: Missing files, permission issues
- **Validation Errors**: Invalid schemas, malformed data

### Common Error Messages

```bash
# Authentication failed
✗ Request failed: HTTP 401: Unauthorized

# Network issues  
✗ Request failed: fetch failed

# Invalid command
✗ Console command failed: Command not allowed: invalid-command

# File not found
✗ Config operation failed: ENOENT: no such file or directory
```

## 🔧 Advanced Usage

### Programmatic API

```javascript
import { OpenClawAPIClient } from './openclaw-api-client.js';

const client = new OpenClawAPIClient(
  'https://your-app.railway.app',
  'your-setup-password',
  'your-gateway-token'
);

// Get system status
const status = await client.getSystemStatus();
console.log('OpenClaw version:', status.openclawVersion);

// Run onboarding
const result = await client.runOnboarding({
  authGroup: 'openai',
  authChoice: 'openai-api-key',
  authSecret: 'sk-...',
  flow: 'quickstart'
});

// Export backup
const backupPath = await client.exportBackup('./backup.tar.gz');
```

### Batch Operations

```bash
# Script for health monitoring
#!/bin/bash
URL="https://your-app.railway.app"
PASS="your-password"

while true; do
  if node openclaw-api-client.js -u $URL -p $PASS health --public > /dev/null 2>&1; then
    echo "$(date): System healthy"
  else
    echo "$(date): System unhealthy - checking details"
    node openclaw-api-client.js -u $URL -p $PASS console openclaw.doctor
  fi
  sleep 300  # Check every 5 minutes
done
```

### Configuration Templates

Create templates for different environments:

```json
# production-config.json
{
  "authGroup": "anthropic",
  "authChoice": "apiKey", 
  "authSecret": "${ANTHROPIC_API_KEY}",
  "flow": "advanced",
  "telegramToken": "${TELEGRAM_BOT_TOKEN}"
}

# development-config.json
{
  "authGroup": "openai",
  "authChoice": "openai-api-key",
  "authSecret": "${OPENAI_API_KEY}",
  "flow": "quickstart"
}
```

## 📚 Additional Resources

- [OpenClaw Documentation](https://github.com/openclaw/openclaw)
- [Railway Deployment Guide](https://docs.railway.app/)
- [API Endpoint Reference](#api-endpoint-reference)
- [Troubleshooting Guide](#error-handling)

## 🤝 Contributing

This tool is part of the OP3NF1XER governance suite for P4NTHE0N. Contributions welcome!

## 📄 License

MIT License - see LICENSE file for details.
