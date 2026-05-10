# N8N Local Setup Guide

N8N is a powerful open-source workflow automation platform. This guide will help you set up and run N8N locally on your Mac for testing and exploration.

## Prerequisites

Before you start, ensure you have the following installed:

- **Node.js** (v18 or higher) - [Download here](https://nodejs.org/)
- **npm** (comes with Node.js)
- **Mac OS** (this guide is specifically for Mac)

### Check Your Installation

```bash
node --version
npm --version
```

Both commands should return version numbers.

### Install Node.js on Mac

If you don't have Node.js installed, you can use Homebrew:

```bash
brew install node
```

## Quick Start

### 1. Install N8N

Navigate to your n8n folder and install n8n globally or locally:

```bash
# Install globally (recommended for easy access)
npm install -g n8n

# OR install locally in this folder
npm install n8n
```

### 2. Start the N8N Server

```bash
# If installed globally
n8n start

# If installed locally
npx n8n start
```

You should see output similar to:

```
╭─────────────────────────────────────────────────────────────╮
│ N8N - Workflow Automation Tool                              │
├─────────────────────────────────────────────────────────────┤
│ Start time: May 10, 2026                                    │
│ Node version: 18.x.x                                        │
│ N8N version: x.x.x                                          │
│ Database: SQLite                                            │
│ Server running on: http://localhost:5678                    │
╰─────────────────────────────────────────────────────────────╯
```

### 3. Access N8N

Open your browser and navigate to:

```
http://localhost:5678
```

You should see the N8N editor interface.

## Stopping the N8N Server

### Method 1: Keyboard Interrupt (Easiest)

Press `Ctrl+C` in the terminal where n8n is running.

### Method 2: Using the Convenience Script

From a new terminal tab in your n8n folder:

```bash
./stop.sh
```

### Method 3: Manually Kill the Process

Find and kill the Node.js process:

```bash
# Find the PID (process ID) running on port 5678
lsof -i :5678

# Kill the process (replace <PID> with the actual PID)
kill -9 <PID>
```

### Method 4: Using the Start Script

If you used `./start.sh` to start n8n, you can stop it by killing the background process.

## Environment Variables

N8N can be customized using environment variables. Create a `.env` file in this folder with the following variables:

### Common Configuration

```bash
# Port where N8N will run (default: 5678)
N8N_PORT=5678

# Host binding (0.0.0.0 allows local access)
N8N_HOST=0.0.0.0

# Enable/disable basic authentication
N8N_BASIC_AUTH_ACTIVE=false
# N8N_BASIC_AUTH_USER=admin
# N8N_BASIC_AUTH_PASSWORD=password

# Database encryption key (auto-generated if not set)
# N8N_ENCRYPTION_KEY=your-secret-key-here

# Data folder location (default: ~/.n8n)
# N8N_USER_FOLDER=/path/to/custom/folder

# Log level (default: info)
# N8N_LOG_LEVEL=info
```

### Setting Environment Variables

Option 1: Create a `.env` file and N8N will automatically load it:

```bash
cp .env.example .env
# Edit .env with your preferred editor
nano .env
```

Option 2: Export variables before running n8n:

```bash
export N8N_PORT=5679
export N8N_BASIC_AUTH_ACTIVE=true
export N8N_BASIC_AUTH_USER=myuser
export N8N_BASIC_AUTH_PASSWORD=mypassword
n8n start
```

## Data Persistence

By default, N8N stores data in:

```
~/.n8n/
```

This folder contains:
- SQLite database (default)
- Credentials and secrets
- Workflow definitions
- User data

To change the storage location, modify the `N8N_USER_FOLDER` environment variable.

### Backup Your Data

Before updates or experiments, back up your `.n8n` folder:

```bash
cp -r ~/.n8n ~/.n8n.backup
```

## Convenience Scripts

This folder includes optional shell scripts for managing N8N:

### Start Script

```bash
./start.sh
```

Starts N8N in the background and displays the URL to access it.

### Stop Script

```bash
./stop.sh
```

Stops the N8N server running in the background.

## First Steps in N8N

1. **Create a Workflow**: Click the "New" button to create your first workflow
2. **Add Nodes**: Click in the canvas to add nodes (triggers, actions, etc.)
3. **Connect Nodes**: Drag from one node's output to another node's input
4. **Test**: Use the "Test" button to run your workflow
5. **Deploy**: Click "Save & Activate" to run your workflow

Visit the [N8N documentation](https://docs.n8n.io/) for more information.

## Troubleshooting

### Port Already in Use

If you see "Address already in use" error:

```bash
# Find what's using port 5678
lsof -i :5678

# Change the port in .env or use:
export N8N_PORT=5679
n8n start
```

### Node.js Version Issues

N8N requires Node.js v18 or higher. Update Node.js:

```bash
brew upgrade node
```

### Slow Startup

First start can take a minute. Subsequent starts are faster.

### Cannot Access from Other Devices

Ensure `N8N_HOST=0.0.0.0` is set. Then use your Mac's IP address:

```bash
# Find your Mac's IP
ifconfig | grep inet

# Access from another device
http://<your-mac-ip>:5678
```

### Database Lock Error

If you see database lock errors, ensure only one N8N instance is running:

```bash
lsof -i :5678
# Kill any existing processes and restart
```

### Help and Support

- [N8N Documentation](https://docs.n8n.io/)
- [N8N Community](https://community.n8n.io/)
- [N8N GitHub Issues](https://github.com/n8n-io/n8n/issues)

## Next Steps

1. Explore existing workflows and integrations
2. Experiment with different node types
3. Test API integrations with your services
4. Create your first automated workflow
5. Join the N8N community for tips and examples

Happy automating! 🚀
