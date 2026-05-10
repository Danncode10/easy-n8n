#!/bin/bash

# N8N Stop Script (Docker)

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╭─────────────────────────────────────╮${NC}"
echo -e "${BLUE}│ N8N Local Server Stopper (Docker)    │${NC}"
echo -e "${BLUE}╰─────────────────────────────────────╯${NC}"

# Check Docker is available
if ! command -v docker &> /dev/null || ! docker info &> /dev/null; then
    echo -e "${RED}✗ Docker is not running${NC}"
    exit 1
fi

# Check if container exists
if ! docker ps -a --format '{{.Names}}' | grep -q "^n8n$"; then
    echo -e "${YELLOW}ℹ️  No n8n container found${NC}"
    exit 0
fi

# Check if it's already stopped
if ! docker ps --format '{{.Names}}' | grep -q "^n8n$"; then
    echo -e "${YELLOW}ℹ️  n8n is already stopped${NC}"
    exit 0
fi

echo -e "${BLUE}Stopping n8n...${NC}"
docker stop n8n > /dev/null

echo -e "${GREEN}✓ N8N stopped${NC}"
echo ""
echo "  Start again: ./start.sh"
echo "  Remove container + data: docker rm n8n && docker volume rm n8n_data"
echo ""
