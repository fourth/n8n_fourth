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

## 2024-12-15 - White-labeling Configuration

### Branding Decisions
- **Brand Name**: Fourth Intelligence Studio
- **Short Name**: Fourth (for UI where space is limited)
- **Primary Color**: #0C4A7D (Dark Blue)
- **Logo Strategy**: White logos for dark UI theme
  - Collapsed sidebar icon: `Fourth_white_icon.png` (484x434px)
  - Expanded sidebar logo: `Fourth_White_logo.png` (1742x434px)
  - Favicon: `Fourth_icon.png` (484x434px)
- **Tagline**: Keep as "Workflow Automation" (no changes for now)

### Docker Naming Convention
- **Image names**: `fourth/intelligence-studio:local`, `fourth/studio-runners:local`
- **Container names**: `fourth-intelligence-studio`, `fourth-studio-python-runner`
- **Volume name**: `fourth_intelligence_studio_data`
- **Network name**: `fourth-studio-network`
- **Compose file**: `docker-compose.fourth.yml`

### Files to Modify
- Theme colors: `packages/frontend/@n8n/design-system/src/css/_tokens.scss`
- Dark theme: `packages/frontend/@n8n/design-system/src/css/_tokens.dark.scss`
- Logo icon: `packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-icon.svg`
- Logo text: `packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-text.svg`
- Favicon: `packages/frontend/editor-ui/public/favicon.ico`
- Window title: `packages/frontend/editor-ui/index.html`
- Document title: `packages/frontend/editor-ui/src/app/composables/useDocumentTitle.ts`
- Localization: `packages/frontend/@n8n/i18n/src/locales/en.json`

### Documentation Changes
- Renamed `CHANGES.md` → `FOURTH_CHANGES.md`
- Renamed `SETUP.md` → `FOURTH_SETUP.md`

## Completed White-labeling Tasks
- ✅ Branding decisions documented
- ✅ Theme color customization (#0C4A7D - HSL: 204, 64%, 27%)
- ✅ Logo conversion from PNG to SVG (embedded data URIs)
- ✅ Logo replacement in design-system (logo-icon.svg, logo-text.svg)
- ✅ Favicon generation and replacement
- ✅ Brand text updates (i18n localization with `_brand.name` key - initial 5 keys)
- ✅ **Comprehensive i18n replacement** (~94 user-facing "n8n" → "Fourth" replacements)
- ✅ Window title updates (index.html, useDocumentTitle.ts)
- ✅ Rebuild and test (39 packages built successfully)
- ✅ Local testing at http://localhost:5678
- ✅ Docker images rebuilt with Fourth branding (n8nio/n8n:local, n8nio/runners:local)

## Next Steps

### Tag Docker Images with Fourth Branding
```bash
docker tag n8nio/n8n:local fourth/intelligence-studio:local
docker tag n8nio/runners:local fourth/studio-runners:local
```

### Test Fourth Intelligence Studio in Docker
```bash
docker-compose -f docker-compose.fourth.yml up -d
# Access at http://localhost:5680
```

### Production Deployment (Future)
- Push images to container registry
- Configure Kubernetes manifests
- Set up PostgreSQL database
- Configure ingress/load balancer

