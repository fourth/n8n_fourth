# Remaining n8n References & Branding Issues

This document tracks remaining references to "n8n" brand, n8n.io links, or other branding elements that appear in the Fourth Intelligence Studio UI.

## Purpose
- Identify all user-facing n8n references
- Analyze feasibility of replacement
- Track remediation status

## Status Legend
- 🔴 **Not addressed** - Needs investigation
- 🟡 **In progress** - Being worked on
- 🟢 **Resolved** - Fixed or determined not feasible/necessary

---

## References Found

### 1. Sidebar Logo Display Issue
**Location**: Left sidebar (collapsed and expanded states)  
**Status**: 🔴 Not addressed  
**Issue**: Logo appears as "logo + small logo + text" where small logo and text are not readable  
**Context**: After replacing logo-icon.svg and logo-text.svg with PNG-embedded SVG files  
**Affected Files**:
- `packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-icon.svg`
- `packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-text.svg`

**Possible Causes**:
- SVG viewBox or dimensions incorrect
- PNG data URI embedding causing scaling issues
- Logo components being stacked incorrectly
- Fourth logo images may need dimension adjustments

**Next Steps**: Investigate SVG rendering and potentially convert to proper vector format or adjust dimensions

---

### 2. "See more templates" Link to n8n.io
**Location**: Overview tab → "Start with a template" section  
**Status**: 🔴 Not addressed  
**Issue**: "See more templates" link points to n8n.io workflow template library  
**URL**: `https://n8n.io/workflows/?utm_source=n8n_app&utm_medium=template_library&utm_instance=http%3A%2F%2Flocalhost%3A5680%2F&utm_n8n_version=2.0.0&utm_awc=0&utm_user_role=engineering`

**Analysis**:
- This is a deep link to n8n's public template library
- Options:
  1. Remove the link entirely
  2. Point to a Fourth-branded template library (if hosting one)
  3. Point to internal/self-hosted template collection
  4. Disable template library feature if not applicable

**Next Steps**: Determine if Fourth needs a template library, or if this feature should be disabled/removed

---

### 3. Workflow Template Details - Node/App Documentation Links
**Location**: Template detail pages → "Apps in this workflow" section  
**Status**: 🔴 Not addressed  
**Issue**: Individual node/app icons link to n8n.io documentation for each integration  
**Example**: Clicking on Google Docs, YouTube, or other app icons leads to `https://docs.n8n.io/integrations/builtin/app-nodes/...`

**Additional Issue**: Category tags (e.g., "Content Creation", "Multimodal AI") likely link to n8n.io template library with category filters

**Analysis**:
- These are deep links to n8n's integration documentation
- Categories link to n8n's template library with filters
- Options:
  1. Remove all links to make them non-clickable
  2. Host own documentation for integrations (significant effort)
  3. Disable template library feature entirely
  4. Keep template metadata but remove external links

**Next Steps**: Decide on template library strategy - disable, fork documentation, or remove external links

---

### 4. "Upgrade" Buttons and License Tier Prompts
**Location**: Multiple locations (Insights page, Settings, feature-gated areas)  
**Status**: 🔴 Not addressed  
**Issue**: "Upgrade" buttons and premium feature prompts link to n8n.io pricing/purchase pages  
**Example**: Insights page → "Upgrade to access more detailed insights" button

**Analysis**:
- These buttons appear throughout the UI wherever premium features are gated
- They direct users to n8n.io for license upgrades
- With an **Enterprise license**, these prompts likely don't appear (all features unlocked)
- Options:
  1. **If using Enterprise license**: These may auto-hide, no action needed
  2. **If using Community/lower tier**: Need to either:
     - Remove/hide upgrade prompts via configuration
     - Point to Fourth's own licensing/contact page
     - Disable premium feature gates if self-hosting

**Next Steps**: 
- Verify behavior with Enterprise license
- If prompts remain visible, identify all upgrade buttons and determine removal/replacement strategy
- Consider environment variable or config to suppress upgrade prompts for self-hosted/white-labeled instances

---

### 5. Help Menu - All Links Point to n8n Resources
**Location**: Sidebar → Help menu (expandable)  
**Status**: 🔴 Not addressed  
**Issue**: All help menu items link to n8n-branded resources

**Links Include**:
- **Quickstart** → Likely docs.n8n.io/quickstart
- **Documentation** → docs.n8n.io
- **Forum** → community.n8n.io
- **Course** → n8n.io/courses or YouTube
- **Report a bug** → github.com/n8n-io/n8n/issues
- **About** → Information about n8n
- **What's new** section:
  - Instance-level MCP
  - Guardrails node
  - New ways to authenticate in MCP Client tool
  - **Full changelog** → github.com/n8n-io/n8n/releases or n8n.io/changelog
  - **Update (1 version behind)** → Possibly links to n8n.io or GitHub releases

**Analysis**:
- Every help resource is n8n-branded (website, GitHub, forum, YouTube)
- Options:
  1. **Remove help menu entirely** (cleanest for white-labeling)
  2. **Replace with Fourth resources**:
     - Host own documentation
     - Create own community forum
     - Point bug reports to Fourth's issue tracker
     - Create Fourth training courses
  3. **Selectively disable items**:
     - Keep essential items (About, Changelog)
     - Remove external links (Forum, Course)
  4. **Customize via environment variables** (if n8n supports this)

**Next Steps**: Decide on help menu strategy - likely need to remove or heavily customize all links

---

### 6. Settings → Usage and Plan Page - License Activation Links
**Location**: Settings → Usage and plan  
**Status**: 🔴 Not addressed  
**Issue**: Multiple licensing-related elements link to n8n subscription/activation services

**Specific Elements**:
1. **"View plans" button** → `https://subscription.n8n.io/?instanceId=...&version=2.0.0&callback=...&source=usage_page`
2. **"Unlock selected paid features for free (forever)" banner** → Opens modal
3. **Modal "More info" link** → Likely links to n8n.io licensing information
4. **"Send me a free license key" button** → Submits email to n8n's licensing service
5. **"Enter activation key" button** → May connect to n8n validation service

**Analysis**:
- This entire page is tied to n8n's licensing infrastructure
- The license key generation/validation likely requires n8n's backend services
- Options:
  1. **With Enterprise license**: This page may show different content (no upgrade prompts)
  2. **Self-hosted licensing**: Need to implement own license key system or disable
  3. **Remove entirely**: Hide "Usage and plan" page for white-labeled instances
  4. **Configuration flag**: Use environment variable to suppress licensing UI

**Next Steps**: 
- Test with Enterprise license to see if page changes
- Investigate if n8n supports disabling license activation UI for self-hosted instances
- May need to fork license validation logic or remove page entirely

---

### 7. Settings → Personal → Two-Factor Authentication "Learn more" Link
**Location**: Settings → Personal → Security section → Two-factor authentication (2FA)  
**Status**: 🔴 Not addressed  
**Issue**: "Learn more" link points to n8n documentation  
**URL**: `https://docs.n8n.io/user-management/two-factor-auth/`

**Analysis**:
- Small contextual help link to n8n docs
- Options:
  1. **Remove link entirely** - 2FA is self-explanatory for most users
  2. **Create own documentation** - Host Fourth-branded 2FA guide
  3. **Remove all "Learn more" style links** - Part of broader doc link removal strategy

**Next Steps**: Likely remove or replace as part of comprehensive documentation link cleanup

---

### 8. Settings → n8n API → "n8n API" Documentation Link
**Location**: Settings → n8n API → Page description  
**Status**: 🔴 Not addressed  
**Issue**: "n8n API" link in description text points to n8n documentation  
**Text**: "Control n8n programmatically using the **n8n API**" (linked)  
**URL**: `https://docs.n8n.io/api`

**Analysis**:
- Links to n8n's REST API documentation
- Options:
  1. **Remove link** - Keep text but make it non-clickable
  2. **Host own API docs** - Fork and rebrand n8n's API documentation
  3. **Change text** - Update to "Control Fourth programmatically using the Fourth API" (unlinked)

**Next Steps**: Remove link or create Fourth-branded API documentation

---

### 9. Settings → Community Nodes → Package Name Example and "More info" Links
**Location**: Settings → Community nodes → "Install community nodes" modal  
**Status**: 🔴 Not addressed  
**Issue**: Multiple n8n references in community node installation interface

**Specific Elements**:
1. **Package name placeholder text**: `"e.g. n8n-nodes-chatwork"`
   - Should be changed to Fourth naming convention: `"e.g. fourth-nodes-chatwork"`
2. **"More info" link #1**: "Find community nodes to add on the npm public registry. **More info**"
   - Likely links to n8n docs about community nodes
3. **"More info" link #2**: "I understand the risks of installing unverified code from a public source. **More info**"
   - Likely links to n8n security documentation
4. **"Browse" button**: Opens npm registry search - may have n8n-specific filters

**Analysis**:
- Package naming convention (`n8n-nodes-*`) is baked into npm ecosystem
- Community nodes are published with `n8n-nodes-` prefix by third parties
- Options:
  1. **Change placeholder text only** - Use `fourth-nodes-*` as example (but actual packages still use `n8n-nodes-*`)
  2. **Remove "More info" links** - Part of doc link cleanup
  3. **Accept limitation** - Community nodes will always reference n8n in package names (external ecosystem)

**Next Steps**: Update placeholder text to Fourth branding; remove or replace "More info" links; acknowledge npm package naming limitation

---

### 10. Settings → Migration Report → Instance Issues - Documentation Links and n8n Text References
**Location**: Settings → Migration Report → Instance issues tab  
**Status**: 🔴 Not addressed  
**Issue**: Multiple "Documentation" links and text references to "n8n" in breaking change descriptions

**Specific Elements**:
1. **Page header link**: "Learn more about all breaking changes in our **documentation**" → Links to n8n docs
2. **Per-issue Documentation links**: Each issue has a "Documentation ↗" link pointing to specific n8n changelog/docs
3. **Text references to n8n**:
   - "Remove task runner from **n8nio/n8n** docker image" - Docker image name
   - "n8nio/n8n docker image" and "n8nio/runners image" - Docker image names in description
   - "OAuth callbacks now enforce **n8n** user authentication"
   - "Remove **n8n** --tunnel option"
   - "**n8n** now enforces stricter permissions on configuration files"

**Analysis**:
- Migration report is auto-generated from n8n's changelog/release notes
- Text contains both Docker image references and generic "n8n" mentions
- Options:
  1. **Remove all Documentation links** - Keep migration report but no external links
  2. **Replace text references** - Use find/replace for "n8n" → "Fourth" in migration report content
  3. **Fork changelog content** - Host own migration documentation
  4. **Docker image names**: These are technical references that may need to stay as-is if they refer to actual images

**Next Steps**: Remove documentation links; evaluate whether to replace text references or keep technical Docker image names

---

### 11. Help → About Dialog - Multiple n8n References
**Location**: Help menu → About  
**Status**: 🔴 Not addressed  
**Issue**: About dialog contains multiple n8n references in various fields

**Specific Elements**:
1. **Source Code**: `https://github.com/n8n-io/n8n`
   - Links to upstream n8n GitHub repository
   - Should point to Fourth's fork if public, or be removed
2. **License**: "Sustainable Use License + n8n Enterprise License"
   - Text contains "n8n Enterprise License"
   - Should be updated to "Fourth Enterprise License" or generic text
3. **Third-Party Licenses**: "View all third-party licenses" link
   - Opens `/static/license-sdk/index.html` (local file)
   - Document header: "This file lists third-party software components included in **n8n**"
   - Body text: "The **n8n** software includes open source packages..."
   - Need to update this generated file
4. **Debug Information**: "Copy debug information"
   - Contains fields like:
     - `n8nVersion: "2.0.0"`
     - Possibly other n8n-prefixed fields
   - Used for bug reporting, may need field name changes

**Analysis**:
- This is a highly visible dialog with multiple layers of n8n branding
- Options per element:
  1. **Source Code**: Point to Fourth's GitHub fork or remove link
  2. **License text**: Replace "n8n Enterprise" with "Fourth Enterprise" or generic terms
  3. **Third-party licenses**: Regenerate file with Fourth branding or edit header text
  4. **Debug info**: Either keep technical field names (internal use) or rename to `fourthVersion`, etc.

**Next Steps**: 
- Update license text wording
- Point source code to Fourth's repository or remove
- Regenerate or edit third-party licenses document
- Decide on debug information field naming (technical vs. user-facing consideration)

---

### 12. Node Editor - Universal "Docs" and Feedback Links (All Nodes)
**Location**: Every node configuration panel in workflow editor  
**Status**: 🔴 Not addressed  
**Issue**: Two persistent UI elements on every node that link to n8n resources

**Specific Elements**:
1. **"Docs" link** (Upper right corner)
   - Appears on every node's settings panel
   - Links to specific node documentation: `https://docs.n8n.io/integrations/builtin/.../`
   - Examples: Schedule Trigger → docs about Schedule node, HTTP Request → docs about HTTP node
   - Each of 400+ nodes has this link

2. **"I wish this node would..." link** (Lower left corner)
   - Feedback/feature request mechanism
   - Likely links to n8n community forum or feedback system
   - Appears on every node

**Analysis**:
- These are universal UI patterns embedded in the node rendering system
- Affect **every single node** (400+ nodes)
- Options:
  1. **Remove both links entirely** - Cleanest for white-labeling, but loses help/feedback functionality
  2. **Replace Docs link**: Point to Fourth-hosted documentation (requires maintaining docs for 400+ nodes)
  3. **Replace feedback link**: Point to Fourth's feedback system (GitHub issues, custom form, etc.)
  4. **Conditional display**: Use environment variable to hide these links for white-labeled instances
  5. **Keep for internal use**: If Fourth team needs documentation, keep but accept n8n branding

**Next Steps**: 
- Identify code that renders these universal node UI elements
- Decide strategy: remove, replace with Fourth resources, or make conditionally visible
- Consider feasibility of hosting own node documentation vs. removing links entirely

---

### 13. Node Selector - Built-in Nodes with "n8n" in Names and Descriptions
**Location**: Workflow editor → Add node panel → Search results  
**Status**: 🔴 Not addressed  
**Issue**: Multiple built-in nodes have "n8n" in their display names and descriptions

**Specific Nodes Found**:
1. **"n8n" node**
   - Name: "n8n"
   - Description: "Handle events and perform actions on your **n8n** instance"
2. **"n8n Form" node**
   - Name: "n8n Form"
   - Description: "Generate webforms in **n8n** and pass their responses to the workflow"
3. **"Execute Sub-workflow" node**
   - Description: "Helpers for calling other **n8n** workflows. Used for designing modular, microservice-like workflows."
4. **"Customer Messenger (n8n training)" node**
   - Name contains "(n8n training)"
5. **"Customer Datastore (n8n training)" node**
   - Name contains "(n8n training)"
6. **"Call n8n Workflow Tool" node**
   - Name: "Call **n8n** Workflow Tool"

**Analysis**:
- These are core n8n nodes for platform-specific functionality
- Node names and descriptions are defined in node metadata files
- Options:
  1. **Rename nodes**: "n8n" → "Fourth", "n8n Form" → "Fourth Form"
  2. **Update descriptions**: Replace "n8n" mentions with "Fourth" or generic terms
  3. **Training nodes**: Remove "(n8n training)" suffix or rename to "(Fourth training)"
  4. **Technical consideration**: Some node names may be referenced in documentation or community content

**Files to Update**:
- `packages/nodes-base/nodes/N8n/*` - Core n8n node
- `packages/nodes-base/nodes/Form/*` - n8n Form node
- Other node definition files with n8n references

**Next Steps**: 
- Search codebase for node display names and descriptions containing "n8n"
- Update node metadata to use Fourth branding
- Verify node functionality isn't broken by name changes

---

### 14. Demo Workflow Names - "Demo: My first AI Agent in n8n"
**Location**: Workflow editor → Demo workflows (pre-populated examples)  
**Status**: 🔴 Not addressed  
**Issue**: Demo/example workflows contain "n8n" in their titles

**Specific Examples**:
- "Demo: My first AI Agent in **n8n**"
- Likely other demo workflows with n8n mentions

**Analysis**:
- Demo workflows are either:
  1. Seeded/created during onboarding
  2. Imported from template library
  3. Pre-populated by the system
- Options:
  1. **Update demo workflow titles**: "Demo: My first AI Agent in Fourth"
  2. **Disable demo workflow seeding**: Don't auto-create demo workflows
  3. **Create Fourth-branded demos**: Replace with custom onboarding workflows

**Next Steps**: 
- Identify where demo workflows are created/seeded
- Update workflow titles to use Fourth branding
- Consider creating custom Fourth-specific demo workflows

---

### 15. GitHub Star Badge - Top Right Corner
**Location**: Persistent UI element in top right corner of editor  
**Status**: 🔴 Not addressed  
**Issue**: GitHub "Star" badge links to n8n repository with star count

**Details**:
- Shows: "⭐ Star | 162,992" (or similar count)
- Links to: `https://github.com/n8n-io/n8n`
- Visible on most pages in the UI

**Analysis**:
- This is a promotional element for the n8n open source project
- Options:
  1. **Remove entirely** - Cleanest for white-labeling
  2. **Replace with Fourth repository** - If you have a public GitHub repo
  3. **Make conditional** - Hide for production/white-labeled instances via environment variable

**Next Steps**: 
- Locate UI component that renders the GitHub badge
- Either remove completely or add conditional display logic
- If keeping, update to point to Fourth's repository

---

## Notes
- References will be added one by one as discovered
- Each entry will include: location, screenshot reference (if applicable), and analysis
- Some references may be external links or embedded content that cannot be changed

---

## Technical Research Findings (Completed 2024-12-16)

This section contains detailed technical research on how to address each reference, including file locations, configuration options, and implementation approaches. A complete implementation plan is available in `FOURTH_WHITELABELING_PLAN.md`.

### Configuration vs. Hardcoding

Several references can be controlled via configuration rather than code changes:

#### 1. GitHub Star Badge (Reference #15)
**Configuration File**: [`packages/frontend/editor-ui/src/app/components/MainHeader/MainHeader.vue:85-91`](packages/frontend/editor-ui/src/app/components/MainHeader/MainHeader.vue)

**Current Logic**:
```typescript
const showGitHubButton = computed(
	() =>
		!isEnterprise.value &&              // NOT in enterprise/queue mode
		!settingsStore.settings.inE2ETests && // NOT in E2E tests
		!githubButtonHidden.value &&         // NOT hidden by user click
		isTelemetryEnabled.value,            // Telemetry IS enabled
);
```

**Control Options**:
1. **Environment Variable**: Set `N8N_DIAGNOSTICS_ENABLED=false` (disables telemetry → hides button)
2. **Local Storage**: User clicks X button → sets `N8N_HIDE_HIDE_GITHUB_STAR_BUTTON=true`
3. **Queue Mode**: Enable `N8N_EXECUTIONS_MODE=queue` (makes it "enterprise")
4. **Hardcode**: Change computed to always return `false`

**Recommendation**: Use environment variable for clean white-labeling.

---

#### 2. Node Documentation Links (Reference #12)
**Files**:
- [`packages/frontend/editor-ui/src/features/ndv/settings/components/NodeSettingsTabs.vue:117-126`](packages/frontend/editor-ui/src/features/ndv/settings/components/NodeSettingsTabs.vue)
- [`packages/frontend/editor-ui/src/app/composables/useNodeDocsUrl.ts`](packages/frontend/editor-ui/src/app/composables/useNodeDocsUrl.ts)
- [`packages/frontend/editor-ui/src/app/constants/urls.ts:1-2`](packages/frontend/editor-ui/src/app/constants/urls.ts)

**Current Logic**: Docs URL generated per-node from `BUILTIN_NODES_DOCS_URL` constant

**Control Options**:
1. **Hardcode**: Override `documentationUrl` computed to return `''`
2. **Environment Variable**: Add `N8N_DOCS_BASE_URL` check (requires code change)
3. **Conditional**: Check white-label flag before rendering docs tab

**Recommendation**: Hardcode for simplicity, or add env variable for flexibility.

---

#### 3. Feature Request "I wish..." Link (Reference #12)
**Files**:
- [`packages/frontend/editor-ui/src/features/ndv/shared/views/NodeDetailsView.vue:307-312`](packages/frontend/editor-ui/src/features/ndv/shared/views/NodeDetailsView.vue)
- [`packages/frontend/editor-ui/src/app/constants/urls.ts:17`](packages/frontend/editor-ui/src/app/constants/urls.ts) - `BASE_NODE_SURVEY_URL`

**Current Logic**:
```typescript
const featureRequestUrl = computed(() => {
	if (!activeNodeType.value) return '';
	return `${BASE_NODE_SURVEY_URL}${activeNodeType.value.name}`;
});
```

**Control Options**:
1. **Hardcode**: Return empty string
2. **Environment Variable**: Add `N8N_FEATURE_REQUEST_URL` (empty = hide)
3. **Point to Fourth feedback**: Set custom URL

**Recommendation**: Hardcode to empty string (no existing config option).

---

### File Locations for Key Changes

#### Logo Rendering Issue (Reference #1)
**Problem**: PNG embedded as data URI in SVG causes display issues

**Files**:
- [`packages/frontend/@n8n/design-system/src/components/N8nLogo/Logo.vue`](packages/frontend/@n8n/design-system/src/components/N8nLogo/Logo.vue) - Logo component
- [`packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-icon.svg`](packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-icon.svg) - Icon (collapsed sidebar)
- [`packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-text.svg`](packages/frontend/@n8n/design-system/src/components/N8nLogo/logo-text.svg) - Logo with text (expanded)

**Solution**: Convert Fourth logo PNGs to proper vector SVG format
- Use design tool (Figma/Illustrator) or online vectorizer
- Replace data URI embedded SVGs with clean vector SVG code
- Adjust viewBox dimensions to match Fourth logo aspect ratio

---

#### Core Node Renaming (Reference #13)
**Nodes to Update**:
1. **n8n node** → **Fourth**
   - File: [`packages/nodes-base/nodes/N8n/N8n.node.ts:16-22`](packages/nodes-base/nodes/N8n/N8n.node.ts)
   - Change: `displayName: 'Fourth'`, `description: '...on your Fourth instance'`

2. **n8n Form** → **Fourth Form**
   - File: [`packages/nodes-base/nodes/Form/Form.node.ts:266-273`](packages/nodes-base/nodes/Form/Form.node.ts)
   - Change: `displayName: 'Fourth Form'`, `description: 'Generate webforms in Fourth...'`

3. **n8n Form Trigger** → **Fourth Form Trigger**
   - File: [`packages/nodes-base/nodes/Form/FormTrigger.node.ts`](packages/nodes-base/nodes/Form/FormTrigger.node.ts)
   - Multiple versions in v1/ and v2/ subdirectories

4. **Form node notices**:
   - File: [`packages/nodes-base/nodes/Form/Form.node.ts:303`](packages/nodes-base/nodes/Form/Form.node.ts)
   - Change: `displayName: 'A Fourth Form Trigger node must be set up...'`

5. **Execute Sub-workflow**:
   - Search: `grep -r "other n8n workflows" packages/nodes-base/nodes/`
   - Change description text

6. **Training nodes**:
   - Search: `grep -r "(n8n training)" packages/nodes-base/nodes/`
   - Remove suffix or replace with "(Fourth training)"

---

#### Help Menu Links (Reference #5)
**File**: [`packages/frontend/editor-ui/src/app/components/MainSidebar.vue:185-243`](packages/frontend/editor-ui/src/app/components/MainSidebar.vue)

**External Links Defined**:
```typescript
// From externalLinks.ts
QUICKSTART_VIDEO: 'https://www.youtube.com/watch?v=4cQWJViybAQ'
DOCUMENTATION: 'https://docs.n8n.io?utm_source=n8n_app...'
FORUM: 'https://community.n8n.io?utm_source=n8n_app...'
COURSES: 'https://docs.n8n.io/courses/'
```

**Options**:
1. Remove all external link children from help menu
2. Keep only "About" submenu item
3. Point to Fourth's own resources (requires hosting docs/forum)

---

#### About Dialog (Reference #11)
**File**: [`packages/frontend/editor-ui/src/app/components/AboutModal.vue`](packages/frontend/editor-ui/src/app/components/AboutModal.vue)

**Changes Needed**:
- **Line 76**: Source Code link to `https://github.com/n8n-io/n8n`
  - Option 1: Hide link (`v-if="false"`)
  - Option 2: Update to Fourth's repo (can be renamed without breaking local work)
  
- **Lines 84-86**: License text via i18n key `about.n8nLicense`
  - Change to: "Sustainable Use License + Fourth Enterprise License"
  
- **Lines 94-96**: Third-party licenses link
  - Downloads from backend API endpoint
  - Header text mentions "n8n" - requires backend changes
  
- **Lines 112-114**: Debug info link
  - Can hide entire row
  - Keep field names like `n8nVersion` for technical compatibility

---

#### Template Library (Reference #2, #3)
**Files**:
- [`packages/frontend/editor-ui/src/app/components/MainSidebar.vue:138-172`](packages/frontend/editor-ui/src/app/components/MainSidebar.vue) - Menu items
- [`packages/frontend/editor-ui/src/app/constants/urls.ts:28-35`](packages/frontend/editor-ui/src/app/constants/urls.ts) - Template URLs
- Multiple modal components for template display

**URLs**:
```typescript
TEMPLATES_URLS = {
	DEFAULT_API_HOST: 'https://api.n8n.io/api/',
	BASE_WEBSITE_URL: 'https://n8n.io/workflows/',
	UTM_QUERY: { utm_source: 'n8n_app', utm_medium: 'template_library' }
}
```

**Decision**: Keep for now, revisit after consulting with n8n about self-hosted template library options.

---

#### Demo Workflows (Reference #14)
**File**: [`packages/frontend/editor-ui/src/features/workflows/templates/utils/samples/easy_ai_starter.json:2`](packages/frontend/editor-ui/src/features/workflows/templates/utils/samples/easy_ai_starter.json)

**Change**: Simple find/replace
```json
"name": "Demo: My first AI Agent in Fourth",
```

---

### GitHub Repository Renaming

**Can rename fork**: Yes, via GitHub Settings → Repository name

**Impact**:
- ✅ GitHub auto-redirects old URLs
- ✅ Local folder name: No impact (stays `n8n_fourth` unless manually renamed)
- ✅ Git remote: Auto-updates, no action needed
- ✅ Existing clones: Continue working (GitHub redirect handles it)

**Optional**: Rename local folder for consistency
```bash
mv /Users/boyan.asenov/Projects/Cursor/n8n_fourth /Users/boyan.asenov/Projects/Cursor/fourth-intelligence-studio
```

---

### Recommendations Before Consulting n8n

**Questions to ask n8n**:

1. **Licensing & Support**:
   - What's the policy on white-labeling the UI?
   - Are there enterprise license implications?
   - Can we remove/replace help/documentation links?

2. **Technical Guidance**:
   - Recommended approach for hiding docs/feedback links?
   - Is there a white-label mode flag we should use?
   - Template library: Can we self-host or point to our own?

3. **Branding**:
   - Node names: Is it problematic to rename "n8n Form" to "Fourth Form"?
   - About dialog: Can we remove GitHub source code links?
   - Third-party licenses: How to update generated file headers?

4. **Long-term Maintenance**:
   - Configuration vs. code changes: Which is more upgrade-friendly?
   - Will future n8n updates break white-labeling changes?
   - Should we use environment variables for all external URLs?

---

### Priority Matrix

| Priority | Item | Complexity | User Visibility | Config Option? |
|----------|------|------------|-----------------|----------------|
| P0 | Fix logo rendering | Medium | Very High | No |
| P0 | Remove GitHub badge | Low | High | **Yes** (telemetry) |
| P0 | Rename core nodes | Medium | High | No |
| P1 | Remove help links | Low | Medium | No |
| P1 | Hide node docs links | Low | High | No |
| P1 | Hide feedback link | Low | Medium | No |
| P1 | Customize About dialog | Medium | Medium | Partial |
| P2 | Template library | High | Medium | **Maybe** (self-host) |
| P2 | Community nodes text | Low | Low | No |
| P2 | Migration report | Medium | Low | No |
| P2 | Demo workflows | Low | Low | No |
| P3 | Upgrade buttons | Low | Conditional | **Yes** (license) |
| P3 | Settings links | Medium | Low | No |

**Total Estimated Effort**: 20-25 hours for full implementation

---

## Next Steps

1. **Consult with n8n** on white-labeling policy and recommendations
2. **Review plan** with Fourth team to prioritize items
3. **Decide on approach**: Configuration-based vs. hardcoded changes
4. **Implement** in phases as outlined in `FOURTH_WHITELABELING_PLAN.md`
5. **Test thoroughly** with both Community and Enterprise licenses

All detailed implementation steps, code snippets, and file locations are documented in the full plan.

