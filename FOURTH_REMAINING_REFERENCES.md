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

