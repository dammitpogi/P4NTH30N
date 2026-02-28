#!/bin/bash
# SFTPGo client setup script for OpenClaw deployment
# This script configures the OpenClaw container to connect to SFTPGo

SFTPGO_HOST="sftpgo-alma"
SFTPGO_PORT="2022"
SFTPGO_USER="openclaw"
SFTPGO_PASS="openclaw-transfer-2026"

# Create transfer directory
mkdir -p /data/sftp-transfer

# Install SFTP client if not present
if ! command -v sftp &> /dev/null; then
    apt-get update && apt-get install -y openssh-client
fi

# Create SSH config for easy access
cat > /root/.ssh/config << EOF
Host sftpgo-alma
    HostName ${SFTPGO_HOST}
    Port ${SFTPGO_PORT}
    User ${SFTPGO_USER}
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF

echo "SFTPGo client configured. Host: ${SFTPGO_HOST}:${SFTPGO_PORT}"
echo "Transfer directory: /data/sftp-transfer"
echo ""
echo "To transfer files:"
echo "  sftp sftpgo-alma"
echo "  cd /data/workspace"
echo "  put -r *"
