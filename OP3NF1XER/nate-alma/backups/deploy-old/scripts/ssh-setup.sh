#!/usr/bin/env bash
# OP3NF1XER SSH Preconfiguration Script
# Configures SSH for remote management in Railway deployment with auto-accept

set -euo pipefail

echo "[ssh-setup] Configuring SSH environment with auto-accept..."

# Create SSH directory in persistent volume
SSH_DIR="${SSH_DIR:-/data/.ssh}"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# OP3NF1XER: Create SSH config with auto-accept for host keys
# This allows immediate SSH connections without manual host key verification
cat > "$SSH_DIR/config" << 'EOF'
# OP3NF1XER SSH Configuration - Auto-accept host keys
# WARNING: This configuration accepts all host keys automatically
# Only use in controlled Railway deployment environments

Host *
    # Auto-accept host keys without prompting
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    # Security: Log host key changes but don't block
    LogLevel ERROR
    # Connection settings
    ServerAliveInterval 60
    ServerAliveCountMax 3
    # Authentication
    IdentitiesOnly yes
    # Use our deployed key
    IdentityFile ~/.ssh/id_ed25519
    IdentityFile ~/.ssh/id_rsa
    # Batch mode for automated connections
    BatchMode yes
    # Disable agent forwarding for security
    ForwardAgent no
EOF
chmod 600 "$SSH_DIR/config"
echo "[ssh-setup] SSH config created with StrictHostKeyChecking=no"

# Configure known_hosts if provided via environment (optional override)
if [ -n "${SSH_KNOWN_HOSTS:-}" ]; then
    echo "[ssh-setup] Configuring known_hosts from environment..."
    echo "$SSH_KNOWN_HOSTS" | base64 -d > "$SSH_DIR/known_hosts" 2>/dev/null || echo "$SSH_KNOWN_HOSTS" > "$SSH_DIR/known_hosts"
    chmod 644 "$SSH_DIR/known_hosts"
    # Update config to use actual known_hosts instead of /dev/null
    sed -i 's|UserKnownHostsFile /dev/null|UserKnownHostsFile '"$SSH_DIR/known_hosts"'|' "$SSH_DIR/config"
fi

# Setup ED25519 private key from environment or deployed key file
if [ -n "${SSH_PRIVATE_KEY_ED25519:-}" ]; then
    echo "[ssh-setup] Configuring ED25519 private key from environment..."
    echo "$SSH_PRIVATE_KEY_ED25519" | base64 -d > "$SSH_DIR/id_ed25519" 2>/dev/null || echo "$SSH_PRIVATE_KEY_ED25519" > "$SSH_DIR/id_ed25519"
    chmod 600 "$SSH_DIR/id_ed25519"
elif [ -f "/app/ssh_key" ]; then
    echo "[ssh-setup] Installing deployed ED25519 key..."
    cp /app/ssh_key "$SSH_DIR/id_ed25519"
    chmod 600 "$SSH_DIR/id_ed25519"
fi

# Setup additional keys from environment
for key_var in SSH_PRIVATE_KEY_RSA SSH_PRIVATE_KEY_ECDSA; do
    if [ -n "${!key_var:-}" ]; then
        key_type="${key_var#SSH_PRIVATE_KEY_}"
        key_file="$SSH_DIR/id_${key_type,,}"
        echo "[ssh-setup] Configuring $key_type private key..."
        echo "${!key_var}" | base64 -d > "$key_file" 2>/dev/null || echo "${!key_var}" > "$key_file"
        chmod 600 "$key_file"
    fi
done

# Copy public key if available
if [ -f "/app/ssh_key.pub" ]; then
    cp /app/ssh_key.pub "$SSH_DIR/id_ed25519.pub"
    chmod 644 "$SSH_DIR/id_ed25519.pub"
fi

# Ensure proper ownership (if running as non-root)
if [ -n "${USER_ID:-}" ] && [ -n "${GROUP_ID:-}" ]; then
    chown -R "$USER_ID:$GROUP_ID" "$SSH_DIR" 2>/dev/null || true
fi

# Create wrapper script for SSH with auto-accept
mkdir -p /data/bin
cat > /data/bin/ssh-auto << 'EOF'
#!/usr/bin/env bash
# OP3NF1XER SSH wrapper with auto-accept configuration
exec /usr/bin/ssh -F "${SSH_DIR:-/data/.ssh}/config" "$@"
EOF
chmod +x /data/bin/ssh-auto

# Create convenience symlink
ln -sf /data/bin/ssh-auto /usr/local/bin/ssh-auto 2>/dev/null || true

echo "[ssh-setup] SSH configuration complete"
echo "[ssh-setup] SSH directory: $SSH_DIR"
echo "[ssh-setup] SSH version: $(ssh -V 2>&1)"
echo "[ssh-setup] Auto-accept enabled: StrictHostKeyChecking=no"
echo "[ssh-setup] Usage: ssh-auto user@host or /data/bin/ssh-auto user@host"
