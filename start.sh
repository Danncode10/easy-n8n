#!/bin/bash

# N8N Start Script for Mac
# This script starts the N8N server in the background

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}╭─────────────────────────────────────╮${NC}"
echo -e "${BLUE}│ N8N Local Server Starter             │${NC}"
echo -e "${BLUE}╰─────────────────────────────────────╯${NC}"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠️  Node.js is not installed${NC}"
    echo "Install it with: brew install node"
    exit 1
fi

# Check if n8n is installed globally
if ! command -v n8n &> /dev/null; then
    echo -e "${YELLOW}ℹ️  n8n not found globally. Attempting to install...${NC}"
    npm install -g n8n
fi

# Load environment variables from .env if it exists
if [ -f .env ]; then
    echo -e "${BLUE}📋 Loading environment variables from .env${NC}"
    set -a
    source .env
    set +a
else
    echo -e "${YELLOW}ℹ️  No .env file found. Using default settings${NC}"
fi

# Get the port (default to 5678)
PORT=${N8N_PORT:-5678}

# Check if the port is already in use
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
    echo -e "${YELLOW}⚠️  Port $PORT is already in use${NC}"
    echo "Check what's running: lsof -i :$PORT"
    echo "Kill the process and try again, or change the N8N_PORT in .env"
    exit 1
fi

# Start N8N in the background
echo -e "${GREEN}✓ Starting N8N server on port $PORT...${NC}"
n8n start > /tmp/n8n.log 2>&1 &
N8N_PID=$!

# Save PID to file for use by stop.sh
echo $N8N_PID > .n8n.pid

# Wait a moment for the server to start
sleep 3

# Check if the process is still running
if ! kill -0 $N8N_PID 2>/dev/null; then
    echo -e "${YELLOW}⚠️  N8N failed to start. Check the logs:${NC}"
    cat /tmp/n8n.log
    exit 1
fi

echo -e "${GREEN}✓ N8N server started successfully!${NC}"
echo ""
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Access N8N at:${NC} ${BLUE}http://localhost:$PORT${NC}"
echo -e "${GREEN}✓ Server PID:${NC} ${BLUE}$N8N_PID${NC}"
echo -e "${GREEN}✓ Logs:${NC} ${BLUE}/tmp/n8n.log${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""
echo "To stop the server, run: ./stop.sh"
echo "Or press Ctrl+C in the N8N terminal"
echo ""
echo -e "${YELLOW}💡 Tip: View logs with: tail -f /tmp/n8n.log${NC}"
