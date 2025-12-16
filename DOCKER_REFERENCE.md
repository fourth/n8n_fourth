# Docker Reference - Fourth Intelligence Studio

## Quick Overview

You have **two separate n8n instances** running in Docker:

| Instance | Purpose | Port | Data Persistence |
|----------|---------|------|------------------|
| **Vanilla n8n** | Original n8n branding | 5679 | `vanilla-n8n-data` |
| **Fourth Intelligence Studio** | White-labeled branding | 5680 | `fourth-intelligence-studio-data` |

## Docker Desktop Layout

### Containers (4)
```
• n8n                          (vanilla - main app)
• n8n-python-runner            (vanilla - Python task runner)
• fourth-intelligence-studio   (Fourth - main app)
• fourth-studio-python-runner  (Fourth - Python task runner)
```

### Images (4)
```
• n8nio/n8n:local              (vanilla main image)
• n8nio/runners:local          (vanilla runners)
• fourth/intelligence-studio:local (Fourth main image)
• fourth/studio-runners:local  (Fourth runners)
```

### Volumes (2)
```
• vanilla-n8n-data             (vanilla user data, workflows, credentials)
• fourth-intelligence-studio-data (Fourth user data, workflows, credentials)
```

### Networks (2)
```
• vanilla-n8n-network          (vanilla internal communication)
• fourth-studio-network        (Fourth internal communication)
```

## Access URLs

- **Vanilla n8n**: http://localhost:5679
- **Fourth Intelligence Studio**: http://localhost:5680

## Management Commands

### Start/Stop Vanilla n8n
```bash
cd /Users/boyan.asenov/Projects/Cursor/n8n_fourth

# Start
docker-compose up -d

# Stop
docker-compose down

# View logs
docker-compose logs -f
```

### Start/Stop Fourth Intelligence Studio
```bash
cd /Users/boyan.asenov/Projects/Cursor/n8n_fourth

# Start
docker-compose -f docker-compose.fourth.yml up -d

# Stop
docker-compose -f docker-compose.fourth.yml down

# View logs
docker-compose -f docker-compose.fourth.yml logs -f
```

### Rebuild Images
```bash
# Rebuild both (after code changes)
pnpm build:docker

# Re-tag Fourth branding
./scripts/tag-fourth-images.sh

# Restart with new images
docker-compose down && docker-compose up -d
docker-compose -f docker-compose.fourth.yml down && docker-compose -f docker-compose.fourth.yml up -d
```

## Data Persistence

- Both instances have **completely separate databases**
- Different users, workflows, credentials, executions
- Stored in Docker volumes (survives container restarts)
- Located at: `/var/lib/docker/volumes/`

### Backup Data
```bash
# Backup vanilla
docker run --rm -v vanilla-n8n-data:/data -v $(pwd):/backup alpine tar czf /backup/vanilla-n8n-backup.tar.gz -C /data .

# Backup Fourth
docker run --rm -v fourth-intelligence-studio-data:/data -v $(pwd):/backup alpine tar czf /backup/fourth-backup.tar.gz -C /data .
```

### Restore Data
```bash
# Restore vanilla
docker run --rm -v vanilla-n8n-data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/vanilla-n8n-backup.tar.gz"

# Restore Fourth
docker run --rm -v fourth-intelligence-studio-data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/fourth-backup.tar.gz"
```

## Troubleshooting

### Port Already in Use
```bash
# Check what's using the ports
lsof -i :5679
lsof -i :5680

# Stop conflicting processes or change ports in docker-compose files
```

### Container Won't Start
```bash
# Check logs
docker-compose logs n8n
docker-compose -f docker-compose.fourth.yml logs fourth-intelligence-studio

# Check container status
docker ps -a
```

### Reset Everything
```bash
# WARNING: This deletes all data!

# Stop and remove containers
docker-compose down -v
docker-compose -f docker-compose.fourth.yml down -v

# Remove volumes
docker volume rm vanilla-n8n-data fourth-intelligence-studio-data

# Remove images
docker rmi n8nio/n8n:local n8nio/runners:local fourth/intelligence-studio:local fourth/studio-runners:local

# Rebuild from scratch
pnpm build:docker
./scripts/tag-fourth-images.sh
docker-compose up -d
docker-compose -f docker-compose.fourth.yml up -d
```

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Host (macOS)                      │
│                                                             │
│  ┌──────────────────────┐    ┌──────────────────────────┐ │
│  │  Vanilla n8n         │    │  Fourth Intelligence      │ │
│  │  Port: 5679          │    │  Studio                   │ │
│  │                      │    │  Port: 5680               │ │
│  │  ┌────────────────┐ │    │  ┌────────────────────┐  │ │
│  │  │ n8n            │ │    │  │ fourth-            │  │ │
│  │  │                │ │    │  │ intelligence-      │  │ │
│  │  │                │ │    │  │ studio             │  │ │
│  │  └────────┬───────┘ │    │  └────────┬───────────┘  │ │
│  │           │          │    │           │              │ │
│  │  ┌────────▼───────┐ │    │  ┌────────▼───────────┐ │ │
│  │  │ n8n-python-    │ │    │  │ fourth-studio-     │ │ │
│  │  │ runner         │ │    │  │ python-runner      │ │ │
│  │  └────────────────┘ │    │  └────────────────────┘ │ │
│  │                      │    │                          │ │
│  │  Volume:             │    │  Volume:                 │ │
│  │  vanilla-n8n-data    │    │  fourth-intelligence-    │ │
│  │                      │    │  studio-data             │ │
│  └──────────────────────┘    └──────────────────────────┘ │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Notes

- **Vanilla n8n**: Original branding, used for comparison or stable production
- **Fourth Intelligence Studio**: White-labeled version with Fourth branding
- Both can run simultaneously without conflicts (different ports, volumes, networks)
- Data is completely isolated between the two instances

