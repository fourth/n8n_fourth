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

## ✅ Complete White-labeling Tasks (100% Done)

### Branding & Design
- ✅ Branding decisions documented
- ✅ Theme color customization (#0C4A7D - HSL: 204, 64%, 27%)
- ✅ Logo conversion from PNG to SVG (embedded data URIs)
- ✅ Logo replacement in design-system (logo-icon.svg, logo-text.svg)
- ✅ Favicon generation and replacement

### Text & Localization
- ✅ Brand text updates (i18n localization with `_brand.name` key - initial 5 keys)
- ✅ **Comprehensive i18n replacement** (~94 user-facing "n8n" → "Fourth" replacements)
- ✅ **Final cleanup** (11 remaining instances in SSO/LDAP/polling nodes)
- ✅ Window title updates (index.html, useDocumentTitle.ts)
- ✅ **Result**: Zero user-facing "n8n" text remains in UI

### Build & Test
- ✅ Rebuild and test (39 packages built successfully)
- ✅ Local testing at http://localhost:5678
- ✅ Docker images rebuilt with Fourth branding

### Docker Configuration
- ✅ `docker-compose.fourth.yml` created with Fourth branding
- ✅ Build contexts added for Fourth-branded images
- ✅ Tagging script created: `scripts/tag-fourth-images.sh`
- ✅ Clean volume/network names (no confusing prefixes)
  - Vanilla: `vanilla-n8n-data`, `vanilla-n8n-network`
  - Fourth: `fourth-intelligence-studio-data`, `fourth-studio-network`

## Using Fourth Intelligence Studio

### Quick Start - Tag & Run Docker Images

```bash
# 1. Tag existing images with Fourth branding
./scripts/tag-fourth-images.sh

# 2. Launch Fourth Intelligence Studio
docker-compose -f docker-compose.fourth.yml up -d

# 3. Access at http://localhost:5680
```

### Alternative: Build from Scratch

```bash
# Build with Fourth branding directly
docker-compose -f docker-compose.fourth.yml up --build -d
```

### Production Deployment (Future)
- Push images to container registry
- Configure Kubernetes manifests
- Set up PostgreSQL database
- Configure ingress/load balancer

---

## 2024-12-16 - White-labeling Research & Planning

### User Testing & Discovery Phase
- Tested Fourth-branded Docker instance alongside vanilla n8n
- User identified 15 categories of remaining n8n references in UI:
  1. Sidebar logo display issues (PNG→SVG conversion problem)
  2. "See more templates" links to n8n.io
  3. Template detail pages with n8n documentation links
  4. "Upgrade" buttons linking to n8n pricing
  5. Help menu with all external links to n8n resources
  6. Settings → Usage and Plan page with n8n subscription links
  7. Settings pages with "Learn more" links to n8n docs
  8. n8n API documentation link
  9. Community Nodes installation with n8n references
  10. Migration Report with n8n text and doc links
  11. About dialog with GitHub, license, and debug info
  12. Universal node "Docs" and "I wish..." feedback links
  13. Built-in nodes with "n8n" in names (n8n Form, etc.)
  14. Demo workflow names mentioning n8n
  15. GitHub star badge in header

### Technical Research Completed
- Mapped all 15 reference categories to specific source files
- Identified configuration options vs. hardcoded values
- Documented control mechanisms:
  - GitHub badge: Controlled by telemetry setting (`N8N_DIAGNOSTICS_ENABLED`)
  - Node docs/feedback links: Currently hardcoded
  - Help menu: Defined in MainSidebar component
  - Upgrade buttons: Auto-hide with Enterprise license
- Located all affected files with line numbers
- Determined implementation complexity and priority

### Documentation Created
- **`FOURTH_WHITELABELING_PLAN.md`**: Complete implementation plan
  - 15 items organized by priority (P0-P3)
  - Estimated effort: 20-25 hours total
  - Phase-based implementation strategy
  - Testing checklist
  - Environment variable recommendations
- **`FOURTH_REMAINING_REFERENCES.md`**: Updated with detailed technical findings
  - File locations and code snippets
  - Configuration options analysis
  - GitHub repository renaming guidance
  - Questions to ask n8n before implementation
  - Priority matrix and recommendations

### Key Findings
1. **Logo Issue**: PNG embedded as data URI in SVG - needs proper vector conversion
2. **Configuration Options**: GitHub badge can be hidden via `N8N_DIAGNOSTICS_ENABLED=false`
3. **Node Renaming**: Affects 6+ nodes in `packages/nodes-base/nodes/`
4. **Help Resources**: All external links hardcoded in `MainSidebar.vue`
5. **Template Library**: May be able to self-host or disable entirely

### Decision Points
- **Before implementation**: Consult with n8n on white-labeling policy
- **Configuration vs. Hardcoding**: Prefer env variables for upgrade-friendliness
- **Template Library**: Keep for now, revisit after n8n consultation
- **License Verification**: Test Enterprise license behavior on upgrade prompts

### Implementation Status
- ✅ Research completed
- ✅ Documentation created
- ✅ Plan reviewed with user
- ⏸️ **On hold**: Awaiting n8n consultation before making code changes

