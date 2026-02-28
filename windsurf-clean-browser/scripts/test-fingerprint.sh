#!/bin/bash
# Fingerprint verification script
# Tests if browser fingerprint differs from host
# Usage: ./test-fingerprint.sh

set -e

CONTAINER_NAME="windsurf-fingerprint-test-$$"
IMAGE_NAME="windsurf-clean-browser"

echo "============================================"
echo "  Fingerprint Test - Windsurf Clean Browser"
echo "============================================"
echo ""

# Check if container is running
RUNNING=$(docker ps -q -f name=windsurf-browser)
if [ -z "$RUNNING" ]; then
    echo -e "${YELLOW}No clean browser container is running.${NC}"
    echo "Start one first with: ./launch-clean-browser.sh"
    exit 1
fi

echo "Container is running. Testing fingerprint..."
echo ""
echo "To verify fingerprint evasion:"
echo "  1. Open http://localhost:6080/vnc.html in your browser"
echo "  2. In the container Chrome, navigate to:"
echo "     - https://amiunique.org/fingerprint"
echo "     - https://coveryourtracks.eff.org/"
echo "     - https://www.whatismybrowser.com/"
echo ""
echo "Expected results:"
echo "  - Canvas fingerprint should be randomized"
echo "  - Screen resolution: 1280x720"
echo "  - User Agent should show Linux/Chrome"
echo "  - WebRTC should be disabled (no local IP leak)"
echo "  - Timezone should differ from host"
echo ""
echo "To get a new fingerprint:"
echo "  1. Stop this container (Ctrl+C)"
echo "  2. Run ./launch-clean-browser.sh again"
echo "  3. New container = new fingerprint"
echo ""
