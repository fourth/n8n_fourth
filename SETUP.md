# n8n Local Development & Docker Setup

## Prerequisites

- Node.js 22+
- pnpm 10.22.0+
- Docker & Docker Compose

## Quick Start

### 1. Install Dependencies

```bash
# Install pnpm globally
npm install -g pnpm@10.22.0

# Install project dependencies
pnpm install
```

### 2. Build n8n

```bash
# Build entire project (takes ~2 minutes)
pnpm build > build.log 2>&1

# Check for errors
tail -n 50 build.log
```

### 3. Run Locally (Development)

```bash
# Start n8n
pnpm start

# Access at http://localhost:5678
```

## Docker Setup

### Build Docker Images

```bash
# Build n8n and runner images (takes ~7 minutes)
pnpm build:docker

# Verify images created
docker images | grep n8nio
# Should show:
#   n8nio/n8n:local
#   n8nio/runners:local
```

### Run with Docker Compose

```bash
# Start containers
docker-compose up -d

# View logs
docker-compose logs -f

# Access at http://localhost:5679

# Stop containers (data persists)
docker-compose stop

# Start again
docker-compose start

# Stop and remove containers (data persists)
docker-compose down

# Stop and remove everything including data ⚠️
docker-compose down -v
```

### Rebuild After Changes

```bash
# Rebuild n8n
pnpm build

# Rebuild Docker images
pnpm build:docker

# Restart containers
docker-compose down
docker-compose up -d
```

## Data Locations

- **Local dev**: `~/.n8n/database.sqlite`
- **Docker**: `n8n_data` volume (managed by Docker)

Each environment has separate databases - owner accounts and data are NOT shared.

## Git Workflow

### Working with Branches

```bash
# Create a new feature branch
git checkout -b feat/your-feature-name

# Make your changes and commit
git add .
git commit -m "feat: description of changes"

# View branch status
git branch -v
```

### Merging to Your Fork's Master

Since this is your personal fork, merge directly instead of creating PRs:

```bash
# Switch to master
git checkout master

# Merge your feature branch
git merge feat/your-feature-name

# Push to your fork
git push origin master

# Optional: Delete merged feature branch
git branch -d feat/your-feature-name
```

### Checking Remote Configuration

```bash
# Verify remotes
git remote -v

# Should show:
# origin    https://github.com/YOUR-USERNAME/n8n_fourth.git (your fork)
# upstream  https://github.com/n8n-io/n8n.git (original repo)
```

**Note:** Always push to `origin` (your fork), not `upstream` (original n8n repo).

## Useful Commands

```bash
# Check running containers
docker ps

# View specific logs
docker logs n8n -f

# Access container shell
docker exec -it n8n sh

# Backup Docker volume
docker run --rm -v n8n_fourth_n8n_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/n8n-backup.tar.gz -C /data .
```

