---
name: Fourth White-labeling - Remaining References
overview: Remove or replace all remaining n8n references from the Fourth Intelligence Studio UI, including logos, links, documentation, help resources, and node names. This plan addresses 15 categories of references found during user testing, prioritized by visibility and implementation complexity.
todos:
  - id: fix-sidebar-logo
    content: Fix sidebar logo display - convert PNGs to proper SVG vectors
    status: pending
  - id: remove-github-badge
    content: Remove GitHub star badge from header
    status: pending
  - id: rename-core-nodes
    content: Rename n8n nodes to Fourth (n8n Form, etc.)
    status: pending
  - id: remove-help-menu-links
    content: Remove external links from Help menu
    status: pending
  - id: hide-node-docs-links
    content: Hide Docs and feedback links on all nodes
    status: pending
  - id: customize-about-dialog
    content: Update About dialog with Fourth branding
    status: pending
  - id: disable-template-library
    content: Remove or disable template library external links
    status: pending
  - id: update-community-nodes
    content: Update community nodes placeholder text and remove doc links
    status: pending
  - id: clean-migration-report
    content: Clean up migration report text and remove doc links
    status: pending
  - id: update-demo-workflows
    content: Update demo workflow names to use Fourth
    status: pending
  - id: hide-upgrade-buttons
    content: Verify upgrade buttons hide with Enterprise license
    status: pending
  - id: update-settings-links
    content: Remove documentation links from settings pages
    status: pending
  - id: final-testing
    content: Complete testing checklist and verify all changes
    status: pending
    dependencies:
      - fix-sidebar-logo
      - remove-github-badge
      - rename-core-nodes
      - remove-help-menu-links
      - hide-node-docs-links
      - customize-about-dialog
      - disable-template-library
      - update-community-nodes
      - clean-migration-report
      - update-demo-workflows
      - hide-upgrade-buttons
      - update-settings-links
---

# Fourth Intelligence Studio - Complete White-labeling Plan

## Overview

After initial white-labeling (colors, basic text, logos), 15 categories of n8n references remain in the UI. This plan addresses each systematically, organized by priority and feasibility.

## Priority Classification

- **P0 (Critical)**: Highly visible, user-facing, significant brand impact  
- **P1 (High)**: Visible to users, moderate brand impact
- **P2 (Medium)**: Less visible or technical, minor brand impact
- **P3 (Low)**: Internal/debug, or requires external resources we don't control

---

## P0: Critical - Immediate Visual Impact

### 1. Fix Sidebar Logo Display (Reference #1)

**Status**: Logo rendering broken after PNG→SVG conversion

**Files**:

- [`packages/frontend/@n8n/design-system/src/components/N8nLogo/Logo.vue`](packages/frontend/@n8n/design-system/src/components/N8nLogo/Logo.vue) - Logo component  
- [`packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-icon.svg`](packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-icon.svg) - Current broken SVG  
- [`packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-text.svg`](packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-text.svg) - Current broken SVG

**Root Cause**: PNG embedded as data URI in SVG causes scaling/rendering issues

**Solution**:

1. Convert PNG logos to proper SVG format using design tool (Figma/Illustrator)
2. Replace embedded data URI SVGs with clean vector SVGs
3. Adjust viewBox dimensions to match Fourth logo aspect ratio
4. Test collapsed and expanded sidebar states

**Estimated Effort**: 2-3 hours (mostly logo vectorization)

---

### 2. Remove GitHub Star Badge (Reference #15)

**Status**: Prominent banner linking to n8n repository

**File**: [`packages/frontend/editor-ui/src/app/components/MainHeader/MainHeader.vue`](packages/frontend/editor-ui/src/app/components/MainHeader/MainHeader.vue:85-91)

**Code Location**: Lines 85-91 (`showGitHubButton` computed), Lines 288-306 (template)

**Solution**: Set `showGitHubButton` to always return `false` or remove the entire button section

```typescript
const showGitHubButton = computed(() => false); // Force hide for white-labeled instance
```

**Estimated Effort**: 15 minutes

---

### 3. Rename Core Nodes (Reference #13)

**Status**: Built-in nodes with "n8n" in names visible in node selector

**Affected Nodes**:

- `n8n` node → `Fourth` 
- `n8n Form` → `Fourth Form`
- `Execute Sub-workflow` (description mentions "n8n")
- Training example nodes (remove "(n8n training)" suffix)

**Files**:

- [`packages/nodes-base/nodes/N8n/N8n.node.ts`](packages/nodes-base/nodes/N8n/N8n.node.ts:16-22) - Lines 16, 22, 24
- [`packages/nodes-base/nodes/Form/Form.node.ts`](packages/nodes-base/nodes/Form/Form.node.ts:266-273) - Lines 266, 273, 303
- [`packages/nodes-base/nodes/Form/FormTrigger.node.ts`](packages/nodes-base/nodes/Form/FormTrigger.node.ts)  
- Search for other nodes: `grep -r "n8n" packages/nodes-base/nodes/*/**.node.ts`

**Solution**: Update `displayName` and `description` fields in node type descriptions

```typescript
displayName: 'Fourth Form',
description: 'Generate webforms in Fourth and pass their responses to the workflow',
```

**Estimated Effort**: 1-2 hours (search all nodes, update, test)

---

## P1: High Priority - User-Facing Links

### 4. Remove/Replace Help Menu Links (Reference #5)

**Status**: All help menu items link to n8n resources

**Files**:

- [`packages/frontend/editor-ui/src/app/components/MainSidebar.vue`](packages/frontend/editor-ui/src/app/components/MainSidebar.vue:185-243) - Menu definition (lines 185-243)
- [`packages/frontend/editor-ui/src/app/constants/externalLinks.ts`](packages/frontend/editor-ui/src/app/constants/externalLinks.ts:1-6) - URL constants

**Links to Address**:

- Quickstart → YouTube video
- Documentation → docs.n8n.io
- Forum → community.n8n.io
- Course → docs.n8n.io/courses
- Report a bug → GitHub issues
- About → Keep but customize (see Reference #11)

**Solution Options**:

1. **Simple**: Remove all external links except "About"
2. **Advanced**: Point to Fourth's own resources (requires hosting docs/forum)

**Recommended**: Option 1 - Remove external links, keep "About" modal

```typescript
// In mainMenuItems, modify help menu children to remove external links
children: [
  {
    id: 'about',
    icon: 'info',
    label: i18n.baseText('mainSidebar.aboutN8n'), // Update this i18n key too
  },
]
```

**Estimated Effort**: 1 hour

---

### 5. Remove Node Documentation Links (Reference #12)

**Status**: "Docs" link appears on every node configuration panel (400+ nodes)

**Files**:

- [`packages/frontend/editor-ui/src/features/ndv/settings/components/NodeSettingsTabs.vue`](packages/frontend/editor-ui/src/features/ndv/settings/components/NodeSettingsTabs.vue:117-126) - Docs tab rendering
- [`packages/frontend/editor-ui/src/app/composables/useNodeDocsUrl.ts`](packages/frontend/editor-ui/src/app/composables/useNodeDocsUrl.ts:18-46) - URL generation
- [`packages/frontend/editor-ui/src/app/constants/urls.ts`](packages/frontend/editor-ui/src/app/constants/urls.ts:1-2) - Docs domain constant

**Solution**: Hide docs tab by returning empty `documentationUrl`

```typescript
// In NodeSettingsTabs.vue
const documentationUrl = computed(() => {
  return ''; // Force hide for white-labeled instance
});
```

**Estimated Effort**: 30 minutes

---

### 6. Remove "I wish this node would" Feedback Link (Reference #12)

**Status**: Feedback link on every node (bottom left)

**Files**:

- [`packages/frontend/editor-ui/src/features/ndv/shared/views/NodeDetailsView.vue`](packages/frontend/editor-ui/src/features/ndv/shared/views/NodeDetailsView.vue:307-393) - Lines 307, 825
- [`packages/frontend/editor-ui/src/app/constants/urls.ts`](packages/frontend/editor-ui/src/app/constants/urls.ts:17) - `BASE_NODE_SURVEY_URL`

**Solution**: Remove by setting `featureRequestUrl` to empty

```typescript
const featureRequestUrl = computed(() => ''); // Hide feedback link
```

**Estimated Effort**: 15 minutes

---

### 7. Customize About Dialog (Reference #11)

**Status**: Multiple n8n references in About modal

**File**: [`packages/frontend/editor-ui/src/app/components/AboutModal.vue`](packages/frontend/editor-ui/src/app/components/AboutModal.vue:73-87)

**Changes Needed**:

- Source Code link (line 76): Remove or point to Fourth's repo
- License text (lines 84-86): Change "n8n Enterprise License" → "Fourth Enterprise License"
- Third-party licenses: Update generated file header
- Debug info field names: Consider keeping technical names (`n8nVersion`) for compatibility

**Solution**:

```vue
<!-- Remove GitHub link or update -->
<N8nLink v-if="false" to="https://github.com/n8n-io/n8n">...</N8nLink>

<!-- Update license text via i18n -->
<!-- en.json: "about.n8nLicense": "Sustainable Use License + Fourth Enterprise License" -->
```

**Estimated Effort**: 1 hour

---

## P2: Medium Priority - Less Visible

### 8. Remove Template Library Links (Reference #2, #3)

**Status**: "See more templates" and app documentation links → n8n.io

**Files**:

- [`packages/frontend/editor-ui/src/app/components/MainSidebar.vue`](packages/frontend/editor-ui/src/app/components/MainSidebar.vue:138-172) - Template menu items
- [`packages/frontend/editor-ui/src/app/constants/urls.ts`](packages/frontend/editor-ui/src/app/constants/urls.ts:28-35) - Template URLs
- Multiple template modal components

**Solution**:

- Option 1: Hide template library feature entirely
- Option 2: Disable external links, keep internal templates only

**Recommended**: Option 1 (simplest)

```typescript
// In mainMenuItems, set template item to unavailable
available: false, // Hide templates menu
```

**Estimated Effort**: 1-2 hours (test template removal doesn't break workflows)

---

### 9. Update Community Nodes Text (Reference #9)

**Status**: Placeholder shows "n8n-nodes-chatwork", links to n8n docs

**Files**: Search for community node installation modal components

**Solution**: Update placeholder text only (actual packages will always use `n8n-nodes-` prefix in npm)

```typescript
placeholder: 'e.g. fourth-nodes-chatwork' // Updated example only
```

Remove "More info" documentation links.

**Estimated Effort**: 1 hour

---

### 10. Clean Up Migration Report (Reference #10)

**Status**: Breaking change text mentions "n8n" and Docker image names

**Files**: Search for migration report/compatibility components

**Solution**:

- Remove documentation links to n8n changelog
- Keep technical Docker image names (`n8nio/n8n`) as factual references
- Replace generic "n8n" mentions with "Fourth" where contextual

**Estimated Effort**: 1-2 hours

---

### 11. Update Demo Workflow Names (Reference #14)

**Status**: "Demo: My first AI Agent in n8n"

**File**: [`packages/frontend/editor-ui/src/features/workflows/templates/utils/samples/easy_ai_starter.json`](packages/frontend/editor-ui/src/features/workflows/templates/utils/samples/easy_ai_starter.json:2)

**Solution**: Simple find/replace in demo workflow JSON files

```json
"name": "Demo: My first AI Agent in Fourth",
```

**Estimated Effort**: 30 minutes

---

## P3: Low Priority - Technical/Conditional

### 12. Hide Upgrade Buttons (Reference #4, #6)

**Status**: Upgrade prompts throughout UI → n8n.io pricing

**Analysis**: With Enterprise license, these should auto-hide

**Solution**:

- **If using Enterprise license**: No action needed (verify after license activation)
- **If not**: Add environment variable check to hide upgrade CTAs

**Estimated Effort**: 1 hour (if needed)

---

### 13. Update Settings Page Links (Reference #7, #8)

**Status**: Various "Learn more" links in settings → docs.n8n.io

**Files**: Settings components (2FA, API, etc.)

**Solution**: Remove `href` attributes or set to empty on contextual help links

```vue
<N8nLink v-if="false" :href="learnMoreUrl">Learn more</N8nLink>
```

**Estimated Effort**: 2 hours (find all settings pages with doc links)

---

## Implementation Strategy

### Phase 1: Quick Wins (P0 items 2-3, 4 hours)

1. Remove GitHub star badge
2. Rename core nodes
3. Remove node docs/feedback links

### Phase 2: Visual Fixes (P0 item 1, 3 hours)

4. Fix sidebar logo rendering

### Phase 3: Deep Links (P1 items, 6 hours)

5. Remove help menu links
6. Customize About dialog
7. Clean up templates

### Phase 4: Polish (P2 + P3, 8 hours)

8. Update all remaining text references
9. Remove documentation links throughout
10. Test with Enterprise license

**Total Estimated Effort**: 20-25 hours

---

## Testing Checklist

After implementation:

- [ ] Logo displays correctly in sidebar (collapsed and expanded)
- [ ] No GitHub badge visible
- [ ] Node selector shows "Fourth" nodes, not "n8n" nodes
- [ ] No "Docs" or "I wish..." links on node panels
- [ ] Help menu has no external links (or only Fourth links)
- [ ] About dialog shows Fourth branding
- [ ] No "See more templates" links to n8n.io
- [ ] Settings pages have no doc links
- [ ] Workflow examples say "Fourth" not "n8n"
- [ ] Test with both Community and Enterprise licenses

---

## Environment Variables (Future Enhancement)

Consider adding to support white-labeling:

```bash
N8N_WHITELABEL_MODE=true
N8N_BRAND_NAME="Fourth"
N8N_HIDE_EXTERNAL_LINKS=true
N8N_DOCS_BASE_URL=""  # Empty to hide docs
N8N_SUPPORT_URL=""     # Custom support URL
```

This would make white-labeling configuration-based rather than code changes.