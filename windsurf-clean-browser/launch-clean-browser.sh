#!/bin/bash
# Windsurf Clean Browser - Launch Script
# One-command launch for isolated browser environment

set -e

IMAGE_NAME="windsurf-clean-browser"
CONTAINER_NAME="windsurf-browser-$$"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "============================================"
echo "  Windsurf Clean Browser Launcher"
echo "============================================"
echo ""

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed or not in PATH${NC}"
    echo "Please install Docker and try again."
    exit 1
fi

# Check if image exists, build if not
if ! docker image inspect "$IMAGE_NAME:latest" > /dev/null 2>&1; then
    echo -e "${YELLOW}Docker image not found. Building...${NC}"
    echo ""
    docker build -t "$IMAGE_NAME" .
    echo ""
    echo -e "${GREEN}Build complete!${NC}"
    echo ""
fi

# Check if container is already running
RUNNING=$(docker ps -q -f name=windsurf-browser)
if [ -n "$RUNNING" ]; then
    echo -e "${YELLOW}A clean browser container is already running.${NC}"
    echo "Stopping existing container..."
    docker stop $RUNNING
    sleep 2
fi

echo "Starting Windsurf Clean Browser..."
echo ""
echo "Access options:"
echo "  1. VNC client:  localhost:5900 (password: windsurf)"
echo "  2. Web browser: http://localhost:6080/vnc.html"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop and destroy container${NC}"
echo ""

# Run container with --rm (auto-destroy on stop)
docker run --rm \
    -p 5900:5900 \
    -p 6080:6080 \
    --name "$CONTAINER_NAME" \
    --hostname clean-browser \
    -e DISPLAY=:1 \
    --shm-size=2g \
    "$IMAGE_NAME"

echo ""
echo -e "${GREEN}Container stopped and cleaned up.${NC}"
