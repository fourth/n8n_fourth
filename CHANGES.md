# Development Changes Log

This document tracks high-level changes made to the n8n fork.

## 2024-12-15 - Initial Setup

### Environment Setup
- Installed pnpm 10.22.0 (required package manager)
- Installed project dependencies via `pnpm install`
- Successfully built vanilla n8n (1m 33s build time)

### Configuration Changes
- Added `.pnpm-store` to `.gitignore` for local package cache

### Docker Setup
- Built Docker images:
  - `n8nio/n8n:local` (1.8GB) - Main application
  - `n8nio/runners:local` (543MB) - Task runners (JS + Python)
- Created `docker-compose.yml` with:
  - n8n container (port 5679 mapped to 5678)
  - Python runner sidecar (external mode)
  - Persistent volume (`n8n_data`) for data storage
  - Network bridge for inter-container communication
- Verified Docker container functionality

### Testing
- ✅ Local development build successful
- ✅ Local n8n instance running (http://localhost:5678)
- ✅ Docker images built successfully
- ✅ Docker container verified and working
- ✅ Data persistence configured with Docker volumes
- ✅ Python and JS task runners connected successfully

### Account & License Setup
- Created owner account in Docker instance using work email
- Opted in via n8n UI for unlimited access to paid features
- Received and activated license key via email
- Current plan: **Community Edition (Registered)**
  - Status: 0 of unlimited published workflows

### Documentation
- Created `SETUP.md` - Quick start guide for development and Docker
- Created `CHANGES.md` - This file for tracking changes

## Pending Tasks

### White-labeling (Not Started)
- Theme color customization (`_tokens.scss`, `_tokens.dark.scss`)
- Logo replacement (SVG files in design-system)
- Brand text updates (i18n localization)
- Favicon updates

### Production Deployment (Future)
- Push images to container registry
- Configure Kubernetes manifests
- Set up PostgreSQL database
- Configure ingress/load balancer

