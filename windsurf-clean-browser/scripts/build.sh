#!/bin/bash
# Build script for Windsurf Clean Browser
# Builds the Docker container

set -e

IMAGE_NAME="windsurf-clean-browser"

echo "============================================"
echo "  Building Windsurf Clean Browser"
echo "============================================"
echo ""

# Get directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Build the image
echo "Building Docker image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" .

echo ""
echo "============================================"
echo -e "  ${GREEN}Build complete!${NC}"
echo "============================================"
echo ""
echo "To launch the browser:"
echo "  ./launch-clean-browser.sh"
echo ""
echo "Or directly with Docker:"
echo "  docker run --rm -p 5900:5900 -p 6080:6080 $IMAGE_NAME"
echo ""
