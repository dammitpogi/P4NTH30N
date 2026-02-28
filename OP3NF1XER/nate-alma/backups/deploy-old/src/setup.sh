#!/bin/bash

# OpenClaw API Client Setup Script
# Sets up the API client tool with dependencies and configuration

set -e

echo "🚀 OpenClaw API Client Setup"
echo "============================"

# Check Node.js version
echo "📋 Checking Node.js version..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18 or later."
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18 or later is required. Current version: $(node -v)"
    exit 1
fi

echo "✅ Node.js $(node -v) detected"

# Create package.json if it doesn't exist
if [ ! -f "package.json" ]; then
    echo "📦 Creating package.json..."
    cp package-api-client.json package.json
    echo "✅ package.json created"
else
    echo "ℹ️  package.json already exists"
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

echo "✅ Dependencies installed"

# Create configuration template
echo "📝 Creating configuration template..."
cat > .env.template << 'EOF'
# OpenClaw API Client Configuration
# Copy this file to .env and update with your values

# OpenClaw deployment URL
OPENCLAW_URL=https://your-app.railway.app

# Setup password (from Railway Variables)
OPENCLAW_PASSWORD=your-setup-password

# Gateway token (auto-generated or from Railway Variables)
OPENCLAW_TOKEN=your-gateway-token

# Optional: Default backup directory
BACKUP_DIR=./backups

# Optional: Log level (debug, info, warn, error)
LOG_LEVEL=info
EOF

echo "✅ Configuration template created: .env.template"

# Create example configuration files
echo "📝 Creating example configurations..."

# Development config
cat > config-development.json << 'EOF'
{
  "authGroup": "openai",
  "authChoice": "openai-api-key",
  "authSecret": "${OPENAI_API_KEY}",
  "flow": "quickstart"
}
EOF

# Production config
cat > config-production.json << 'EOF'
{
  "authGroup": "anthropic",
  "authChoice": "apiKey",
  "authSecret": "${ANTHROPIC_API_KEY}",
  "flow": "advanced",
  "telegramToken": "${TELEGRAM_BOT_TOKEN}",
  "discordToken": "${DISCORD_BOT_TOKEN}",
  "slackBotToken": "${SLACK_BOT_TOKEN}",
  "slackAppToken": "${SLACK_APP_TOKEN}"
}
EOF

echo "✅ Example configurations created"

# Create scripts directory
mkdir -p scripts

# Create monitoring script
cat > scripts/monitor.sh << 'EOF'
#!/bin/bash

# OpenClaw Health Monitoring Script
# Usage: ./scripts/monitor.sh

# Load configuration
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Check if required variables are set
if [ -z "$OPENCLAW_URL" ] || [ -z "$OPENCLAW_PASSWORD" ]; then
    echo "❌ OPENCLAW_URL and OPENCLAW_PASSWORD must be set in .env"
    exit 1
fi

echo "🔍 Monitoring OpenClaw at: $OPENCLAW_URL"

# Check health
if node openclaw-api-client.js -u "$OPENCLAW_URL" -p "$OPENCLAW_PASSWORD" health --public > /dev/null 2>&1; then
    echo "✅ $(date): OpenClaw is healthy"
else
    echo "❌ $(date): OpenClaw is unhealthy - running diagnostics"
    node openclaw-api-client.js -u "$OPENCLAW_URL" -p "$OPENCLAW_PASSWORD" console openclaw.doctor
fi
EOF

chmod +x scripts/monitor.sh

# Create backup script
cat > scripts/backup.sh << 'EOF'
#!/bin/bash

# OpenClaw Backup Script
# Usage: ./scripts/backup.sh [output-path]

# Load configuration
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Check if required variables are set
if [ -z "$OPENCLAW_URL" ] || [ -z "$OPENCLAW_PASSWORD" ]; then
    echo "❌ OPENCLAW_URL and OPENCLAW_PASSWORD must be set in .env"
    exit 1
fi

# Set backup directory
BACKUP_DIR=${BACKUP_DIR:-"./backups"}
OUTPUT_PATH=${1:-"$BACKUP_DIR/openclaw-backup-$(date +%Y-%m-%d).tar.gz"}

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "💾 Creating backup: $OUTPUT_PATH"

# Export backup
node openclaw-api-client.js -u "$OPENCLAW_URL" -p "$OPENCLAW_PASSWORD" backup export "$OUTPUT_PATH"

if [ $? -eq 0 ]; then
    echo "✅ Backup completed: $OUTPUT_PATH"
    
    # Clean up old backups (keep last 7)
    find "$BACKUP_DIR" -name "openclaw-backup-*.tar.gz" -type f -mtime +7 -delete
    echo "🗑️  Cleaned up old backups"
else
    echo "❌ Backup failed"
    exit 1
fi
EOF

chmod +x scripts/backup.sh

echo "✅ Scripts created in scripts/ directory"

# Run tests to verify installation
echo "🧪 Running tests..."
npm test 2>/dev/null || echo "ℹ️  Some tests may fail without live OpenClaw instance"

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📚 Next steps:"
echo "1. Copy .env.template to .env and configure with your values"
echo "2. Test the tool: node openclaw-api-client.js docs"
echo "3. Check health: node openclaw-api-client.js -u \$OPENCLAW_URL -p \$OPENCLAW_PASSWORD health"
echo "4. Run examples: node examples.js"
echo ""
echo "📖 Documentation: README-API-CLIENT.md"
echo "🔧 Scripts: scripts/monitor.sh, scripts/backup.sh"
echo ""
echo "💡 Quick start:"
echo "   cp .env.template .env"
echo "   # Edit .env with your OpenClaw URL and password"
echo "   node openclaw-api-client.js -u \$OPENCLAW_URL -p \$OPENCLAW_PASSWORD health"
