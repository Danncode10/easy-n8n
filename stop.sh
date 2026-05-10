#!/bin/bash

# N8N Stop Script for Mac
# This script stops the N8N server that was started with start.sh

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╭─────────────────────────────────────╮${NC}"
echo -e "${BLUE}│ N8N Local Server Stopper             │${NC}"
echo -e "${BLUE}╰─────────────────────────────────────╯${NC}"

# Check if PID file exists (from start.sh)
if [ -f .n8n.pid ]; then
    N8N_PID=$(cat .n8n.pid)

    # Check if the process is running
    if kill -0 $N8N_PID 2>/dev/null; then
        echo -e "${BLUE}Stopping N8N (PID: $N8N_PID)...${NC}"
        kill $N8N_PID

        # Wait for graceful shutdown (max 10 seconds)
        counter=0
        while kill -0 $N8N_PID 2>/dev/null && [ $counter -lt 10 ]; do
            sleep 1
            counter=$((counter + 1))
        done

        # Force kill if still running
        if kill -0 $N8N_PID 2>/dev/null; then
            echo -e "${YELLOW}Graceful shutdown timed out. Force killing...${NC}"
            kill -9 $N8N_PID
        fi

        echo -e "${GREEN}✓ N8N server stopped successfully!${NC}"
        rm -f .n8n.pid
    else
        echo -e "${YELLOW}⚠️  Process with PID $N8N_PID is not running${NC}"
        rm -f .n8n.pid

        # Try to find and kill any n8n processes
        echo "Searching for any running N8N processes..."
        PIDS=$(pgrep -f "n8n start" || true)
        if [ -z "$PIDS" ]; then
            echo -e "${GREEN}✓ No N8N processes found${NC}"
        else
            echo -e "${YELLOW}Found N8N processes: $PIDS${NC}"
            for PID in $PIDS; do
                echo "Killing PID: $PID"
                kill -9 $PID 2>/dev/null || true
            done
            echo -e "${GREEN}✓ All N8N processes stopped${NC}"
        fi
    fi
else
    echo -e "${YELLOW}ℹ️  No .n8n.pid file found${NC}"
    echo "N8N may not have been started with ./start.sh"
    echo ""
    echo "Searching for N8N processes on the default port (5678)..."

    # Try to find process using the default port
    PROCESS=$(lsof -i :5678 2>/dev/null || true)

    if [ -z "$PROCESS" ]; then
        echo -e "${GREEN}✓ No N8N processes found on port 5678${NC}"
        exit 0
    fi

    echo "$PROCESS"
    PID=$(echo "$PROCESS" | tail -1 | awk '{print $2}')

    if [ ! -z "$PID" ] && [ "$PID" != "PID" ]; then
        read -p "Kill process $PID? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kill -9 $PID
            echo -e "${GREEN}✓ Process killed${NC}"
        else
            echo -e "${YELLOW}Cancelled${NC}"
        fi
    fi
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo "To start N8N again, run: ./start.sh"
echo -e "${BLUE}════════════════════════════════════════${NC}"
