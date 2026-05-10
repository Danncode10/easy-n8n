#!/bin/bash

# N8N Start Script (Docker)

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╭─────────────────────────────────────╮${NC}"
echo -e "${BLUE}│ N8N Local Server Starter (Docker)    │${NC}"
echo -e "${BLUE}╰─────────────────────────────────────╯${NC}"

# Check Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker not found${NC}"
    echo "Install Docker Desktop from: https://www.docker.com/products/docker-desktop/"
    exit 1
fi

# Check Docker daemon is running (timeout after 5s so it doesn't hang)
if ! docker info --format '{{.ID}}' &> /dev/null; then
    echo -e "${RED}✗ Docker Engine is not running${NC}"
    echo ""
    echo "  1. Open Docker Desktop from your Applications folder"
    echo "  2. Click the play button next to 'Engine stopped' in the bottom-left"
    echo "  3. Wait for 'Engine running', then re-run ./start.sh"
    exit 1
fi

# Load .env file if it exists
if [ -f .env ]; then
    echo -e "${BLUE}📋 Loading .env${NC}"
    set -a; source .env; set +a
fi

PORT=${N8N_PORT:-5678}

# Check if port is in use
if lsof -Pi :$PORT -sTCP:LISTEN -t &>/dev/null; then
    echo -e "${YELLOW}⚠️  Port $PORT is already in use${NC}"
    echo "Set a different N8N_PORT in .env or free the port first."
    exit 1
fi

# If container already exists, just start it
if docker ps -a --format '{{.Names}}' | grep -q "^n8n$"; then
    echo -e "${BLUE}Starting existing n8n container...${NC}"
    docker start n8n > /dev/null
else
    echo -e "${BLUE}Creating and starting n8n container...${NC}"
    echo -e "${YELLOW}ℹ️  First run will download the N8N image (~500 MB). Please wait...${NC}"

    # Build environment variable flags from .env
    ENV_FLAGS=""
    [ -n "$N8N_BASIC_AUTH_ACTIVE" ]   && ENV_FLAGS="$ENV_FLAGS -e N8N_BASIC_AUTH_ACTIVE=$N8N_BASIC_AUTH_ACTIVE"
    [ -n "$N8N_BASIC_AUTH_USER" ]     && ENV_FLAGS="$ENV_FLAGS -e N8N_BASIC_AUTH_USER=$N8N_BASIC_AUTH_USER"
    [ -n "$N8N_BASIC_AUTH_PASSWORD" ] && ENV_FLAGS="$ENV_FLAGS -e N8N_BASIC_AUTH_PASSWORD=$N8N_BASIC_AUTH_PASSWORD"
    [ -n "$N8N_ENCRYPTION_KEY" ]      && ENV_FLAGS="$ENV_FLAGS -e N8N_ENCRYPTION_KEY=$N8N_ENCRYPTION_KEY"

    docker run -d \
        --name n8n \
        -p ${PORT}:5678 \
        -v n8n_data:/home/node/.n8n \
        $ENV_FLAGS \
        docker.n8n.io/n8nio/n8n > /dev/null
fi

# Wait briefly for container to be ready
sleep 2

if ! docker ps --format '{{.Names}}' | grep -q "^n8n$"; then
    echo -e "${RED}✗ N8N failed to start. Check logs:${NC}"
    docker logs n8n
    exit 1
fi

echo ""
echo -e "${GREEN}✓ N8N is running!${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${GREEN}  Open:${NC} ${BLUE}http://localhost:${PORT}${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""
echo "  Stop:  ./stop.sh"
echo "  Logs:  docker logs -f n8n"
echo ""
