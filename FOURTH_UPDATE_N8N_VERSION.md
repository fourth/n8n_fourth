# Updating Fourth Fork with Upstream n8n Changes

This guide explains how to sync your white-labeled Fourth fork with the latest changes from the upstream n8n repository while preserving your customizations.

## Initial Setup (One-Time)

### 1. Add Upstream Remote

```bash
# Check current remotes
git remote -v

# Add upstream n8n repository if not already added
git remote add upstream https://github.com/n8n-io/n8n.git

# Verify upstream was added
git remote -v
```

You should see:
- `origin` - your fork (Fourth repo)
- `upstream` - original n8n repo

## Regular Update Process

### 2. Prepare Your Branch

```bash
# Ensure you're on master and have a clean working directory
git checkout master
git status

# Commit or stash any local changes
git stash save "WIP before upstream merge"
```

### 3. Fetch Upstream Changes

```bash
# Fetch all branches and tags from upstream
git fetch upstream

# Fetch tags specifically
git fetch upstream --tags

# View available upstream versions
git tag -l | tail -20
```

### 4. Create a Merge Branch

```bash
# Create a branch for the update process
# Use the target version number, e.g., n8n@1.70.0
git checkout -b merge-upstream-1.70.0

# Merge the specific upstream version
git merge upstream/master
# OR merge a specific tag:
# git merge n8n@1.70.0
```

### 5. Handle Merge Conflicts

When conflicts occur (they will, especially in white-labeled files):

```bash
# Check which files have conflicts
git status

# Common conflict areas for white-labeling:
# - packages/editor-ui/src/components/ (branding components)
# - packages/@n8n/i18n/ (translation strings)
# - packages/cli/src/ (API endpoints, configuration)
# - package.json files (dependencies, names, descriptions)
# - README.md, LICENSE files
```

#### Conflict Resolution Strategy

1. **For white-label customizations** - Keep YOUR changes:
   - Brand names, logos, colors
   - Custom UI components
   - Package names and descriptions
   - Custom API endpoints

2. **For upstream improvements** - Accept THEIR changes:
   - Bug fixes
   - New features
   - Security patches
   - Dependency updates

3. **For both** - Merge manually:
   - Configuration files
   - Shared components with white-label modifications

```bash
# Resolve conflicts in your editor, then:
git add <resolved-file>

# Continue after resolving all conflicts
git merge --continue
```

### 6. Test the Merge

```bash
# Install/update dependencies
pnpm install

# Build all packages (redirect output to check later)
pnpm build > build.log 2>&1

# Check build results
tail -n 50 build.log

# Run type checks
pnpm typecheck

# Run linting
pnpm lint

# Run tests for affected packages
pnpm test:affected
```

### 7. Verify White-Label Customizations

After merging, verify your customizations are intact:

- [ ] Brand name appears correctly in UI
- [ ] Custom logos/images are present
- [ ] Color scheme matches your brand
- [ ] Custom API endpoints work
- [ ] Package names reflect your brand
- [ ] Documentation references your brand

```bash
# Quick search for potential issues
grep -r "n8n" packages/editor-ui/src/components/ | grep -v "node_modules"
```

### 8. Finalize the Merge

```bash
# If everything looks good, merge into master
git checkout master
git merge merge-upstream-1.70.0

# Push to your fork
git push origin master

# Push tags if needed
git push origin --tags

# Clean up merge branch
git branch -d merge-upstream-1.70.0
```

## Best Practices for Easier Updates

### Keep Customizations Isolated

1. **Create custom packages** when possible:
   ```
   packages/@fourth/branding
   packages/@fourth/custom-nodes
   ```

2. **Use configuration files** instead of hardcoding:
   ```typescript
   // Use environment variables or config files
   const BRAND_NAME = process.env.BRAND_NAME || 'Fourth';
   ```

3. **Document all customizations** in a `CUSTOMIZATIONS.md` file

### Regular Update Schedule

- **Security updates**: Merge immediately
- **Minor versions**: Monthly or bi-monthly
- **Major versions**: Quarterly, with thorough testing

### Track Customization Points

Maintain a list of files you've customized:

```bash
# Create a list of your modified files
cat > .fourth-customizations << EOF
packages/editor-ui/src/components/Logo.vue
packages/editor-ui/src/styles/variables.scss
packages/@n8n/i18n/locales/en/index.ts
packages/cli/src/config/index.ts
EOF
```

Before each merge, review these files for potential conflicts.

## Troubleshooting

### If the merge goes wrong:

```bash
# Abort the merge
git merge --abort

# Return to previous state
git checkout master
git branch -D merge-upstream-1.70.0
```

### If you've already committed but want to undo:

```bash
# Find the commit before merge
git log --oneline -10

# Reset to before merge (CAREFUL!)
git reset --hard <commit-hash-before-merge>
```

### If you pushed bad changes:

```bash
# Create a revert commit (safer than force push)
git revert <merge-commit-hash>
git push origin master
```

## Alternative: Rebase Strategy (Advanced)

For a cleaner history, you can rebase instead of merge:

```bash
git checkout master
git fetch upstream
git rebase upstream/master

# Handle conflicts as they appear
# After resolving each conflict:
git add <resolved-files>
git rebase --continue

# Force push (only if you haven't shared this branch)
git push origin master --force-with-lease
```

⚠️ **Warning**: Only use rebase if you're the sole developer or have coordinated with your team.

## Automation Ideas

Consider creating a script to automate parts of this process:

```bash
#!/bin/bash
# update-n8n.sh

VERSION=$1
if [ -z "$VERSION" ]; then
    echo "Usage: ./update-n8n.sh <version>"
    exit 1
fi

git fetch upstream
git checkout -b merge-upstream-$VERSION
git merge upstream/master

echo "Merge complete. Check for conflicts and run tests."
```

## Getting Help

- Check n8n's changelog: https://github.com/n8n-io/n8n/releases
- Review breaking changes before merging major versions
- Test thoroughly in a development environment first
- Keep backups before major updates

---

**Remember**: Always test in a development environment before updating production!

