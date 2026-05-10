# N8N Local Setup Guide (Docker)

N8N is a powerful open-source workflow automation platform. This guide runs N8N using Docker — no Node.js dependencies, no global installs, and easy to clean up when you're done.

## Prerequisites

**Docker Desktop for Mac** — [Download here](https://www.docker.com/products/docker-desktop/)

> Docker Desktop is the only thing you need to install. It includes everything required to run N8N.

### Verify Docker is Running

```bash
docker --version
docker ps
```

Both should return output without errors.

## Quick Start

### 1. Start N8N

```bash
./start.sh
```

Or run manually:

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
```

### 2. Open N8N in Your Browser

```
http://localhost:5678
```

### 3. Stop N8N

```bash
./stop.sh
```

Or stop manually:

```bash
docker stop n8n
```

## Start & Stop Reference

| Action | Script | Manual Command |
|--------|--------|----------------|
| Start | `./start.sh` | `docker start n8n` (after first run) |
| Stop | `./stop.sh` | `docker stop n8n` |
| Restart | `./stop.sh && ./start.sh` | `docker restart n8n` |
| Remove container | — | `docker rm n8n` |
| View logs | — | `docker logs -f n8n` |

> On first run, Docker will pull the N8N image (~500 MB). Subsequent starts are instant.

## Environment Variables

Create a `.env` file from the example template:

```bash
cp .env.example .env
```

Edit `.env` with your settings. The `start.sh` script automatically loads it.

### Common Variables

```bash
# Port to access N8N (default: 5678)
N8N_PORT=5678

# Enable password protection
N8N_BASIC_AUTH_ACTIVE=false
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your-password

# Encryption key for credentials (auto-generated if not set)
N8N_ENCRYPTION_KEY=your-secret-key
```

See `.env.example` for the full list of available variables.

## Data Persistence

Your workflows and credentials are stored in a Docker volume called `n8n_data`. This persists even when the container is stopped or removed.

```bash
# List volumes
docker volume ls

# Inspect where data is stored
docker volume inspect n8n_data

# Backup your data
docker run --rm -v n8n_data:/data -v $(pwd):/backup alpine \
  tar czf /backup/n8n_backup.tar.gz -C /data .
```

## Cleanup (Reclaim Disk Space)

When you're done exploring and want to free up space:

```bash
# Stop and remove the container
docker stop n8n && docker rm n8n

# Remove the N8N image (~500 MB)
docker rmi docker.n8n.io/n8nio/n8n

# Remove saved data (WARNING: deletes your workflows!)
docker volume rm n8n_data

# Remove all unused Docker resources
docker system prune
```

## Troubleshooting

### Docker not found / not running

Open Docker Desktop from your Applications folder and wait for it to fully start before running `./start.sh`.

### Port 5678 already in use

```bash
# Find what's using the port
lsof -i :5678

# Use a different port in .env
N8N_PORT=5679
```

### Container exits immediately

```bash
# Check the container logs
docker logs n8n
```

### Reset everything and start fresh

```bash
docker stop n8n
docker rm n8n
docker volume rm n8n_data
./start.sh
```

## Resources

- [N8N Documentation](https://docs.n8n.io/)
- [N8N Community](https://community.n8n.io/)
- [N8N Docker Hub](https://hub.docker.com/r/n8nio/n8n)
