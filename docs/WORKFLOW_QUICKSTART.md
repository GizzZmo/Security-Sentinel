# Workflow Quick Start Guide

## 🚀 Getting Started with Security Sentinel Workflows

This guide helps you understand and work with the GitHub Actions workflows in Security Sentinel.

## For New Contributors

### First Time Setup

1. **Fork the Repository**
   ```bash
   # Fork on GitHub, then clone
   git clone https://github.com/YOUR_USERNAME/Security-Sentinel.git
   cd Security-Sentinel
   ```

2. **Understand the CI/CD Pipeline**
   - Every push triggers automated builds
   - PRs require passing CI before merge
   - All platforms are tested automatically

3. **Check Workflow Status**
   - Visit the "Actions" tab on GitHub
   - Green checkmarks = passing
   - Red X = failing (needs attention)

### Making Your First Contribution

```bash
# Create a branch
git checkout -b feature/my-awesome-feature

# Make your changes
# ... edit files ...

# Commit your changes
git add .
git commit -m "feat: Add my awesome feature"

# Push to your fork
git push origin feature/my-awesome-feature
```

When you create a PR, these workflows automatically run:
- ✅ **CI/CD Pipeline** - Full build and test
- ✅ **Build Matrix** - Multi-platform verification
- ✅ **Security Scanning** - Security vulnerability check
- ✅ **Code Quality** - Linting and style checks
- ✅ **PR Validation** - PR-specific checks

## For Developers

### Local Development Workflow

Before pushing code, test locally:

```bash
# Install dependencies
npm ci

# Type check
npx tsc --noEmit

# Build web interface
npm run build

# Build C++ (Windows)
mkdir build && cd build
cmake .. -G "Visual Studio 17 2022"
cmake --build . --config Release

# Build C++ (Linux/macOS)
mkdir build && cd build
cmake ..
make -j$(nproc)

# Build Go modules
cd core-go
go build ./...
go test ./...
```

### Understanding Build Results

After pushing, check:

1. **Build Matrix Results**
   - Windows: Check for MSVC compilation
   - Linux: Check GCC/Clang compatibility
   - macOS: Verify cross-platform build

2. **Artifact Outputs**
   - Download artifacts from workflow runs
   - Test executables locally
   - Verify package contents

### Working with Artifacts

```yaml
# Artifacts are available for 14-90 days
# Download from workflow run page

# Example: Download Windows build
1. Go to Actions → Build Matrix → Latest run
2. Scroll to "Artifacts" section
3. Click "cpp-windows-latest-Release"
4. Extract and test locally
```

## For Maintainers

### Release Process

```bash
# 1. Update version in files
# - CMakeLists.txt: project(SecuritySentinel VERSION X.Y.Z)
# - package.json: "version": "X.Y.Z"

# 2. Create and push tag
git tag -a v1.2.0 -m "Release v1.2.0"
git push origin v1.2.0

# 3. Workflows automatically:
#    - Build all platforms
#    - Generate checksums
#    - Create release assets
#    - Publish GitHub release
```

### Managing Workflows

#### Enable/Disable Workflows

```yaml
# To disable a workflow, add to .github/workflows/FILE.yml:
on:
  workflow_dispatch:  # Only manual triggers

# To enable again, restore original triggers
```

#### Update Workflow Actions

```bash
# Check for outdated actions
gh workflow list

# Update action versions in .github/workflows/*.yml
# Example: actions/checkout@v3 → actions/checkout@v4
```

#### Monitor Workflow Performance

```bash
# View workflow runs
gh run list --limit 20

# Check specific workflow
gh run view RUN_ID

# Download logs
gh run download RUN_ID
```

### Artifact Management

#### View Artifact Usage

```bash
# List all artifacts
gh api repos/GizzZmo/Security-Sentinel/actions/artifacts

# Check storage usage
gh api repos/GizzZmo/Security-Sentinel/actions/artifacts \
  --jq '.artifacts | map(.size_in_bytes) | add'
```

#### Manual Cleanup

```bash
# Delete specific artifact
gh api -X DELETE repos/GizzZmo/Security-Sentinel/actions/artifacts/ARTIFACT_ID

# Or use the Artifact Cleanup workflow
# Actions → Artifact Cleanup → Run workflow
```

### Badge Management

#### Update Badge Configuration

Badges are automatically generated weekly. To trigger manually:

```bash
# Go to Actions → Badge Generation → Run workflow
```

#### Add Custom Badges

Edit `.github/workflows/badge-generation.yml`:

```yaml
- name: Create custom badge
  run: |
    cat > badges/custom.json << EOF
    {
      "schemaVersion": 1,
      "label": "custom",
      "message": "value",
      "color": "blue"
    }
    EOF
```

Then use in README:
```markdown
![Custom](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/GizzZmo/Security-Sentinel/main/badges/custom.json)
```

## Common Tasks

### Manually Trigger a Workflow

```bash
# Via GitHub CLI
gh workflow run "Build Matrix"

# Via Web UI
# Actions → Select workflow → Run workflow
```

### Re-run Failed Jobs

```bash
# Via GitHub CLI
gh run rerun RUN_ID

# Via Web UI
# Actions → Select run → Re-run all jobs
```

### Download Workflow Artifacts

```bash
# Via GitHub CLI
gh run download RUN_ID

# Or download specific artifact
gh run download RUN_ID -n artifact-name
```

### View Workflow Logs

```bash
# Via GitHub CLI
gh run view RUN_ID --log

# Or view failed jobs only
gh run view RUN_ID --log-failed
```

## Workflow Debugging

### Build Failures

**Step 1: Identify the failing step**
```bash
gh run view RUN_ID --log
```

**Step 2: Reproduce locally**
```bash
# Copy the failing command from logs
# Run it locally to debug
```

**Step 3: Fix and test**
```bash
# Fix the issue
# Test locally
# Push and verify CI passes
```

### Artifact Issues

**Problem: Artifact not found**
```yaml
# Check artifact name matches
- uses: actions/download-artifact@v4
  with:
    name: exact-artifact-name  # Must match upload
```

**Problem: Artifact too large**
```yaml
# Reduce artifact size
# Split into multiple artifacts
# Use compression
```

### Permission Issues

**Problem: Workflow can't write/read**
```yaml
# Add appropriate permissions
permissions:
  contents: write
  actions: read
```

## Advanced Usage

### Matrix Strategy

Create platform-specific builds:

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
    config: [Debug, Release]
```

### Conditional Execution

Run steps based on conditions:

```yaml
- name: Windows only
  if: runner.os == 'Windows'
  run: echo "Windows step"

- name: On main branch only
  if: github.ref == 'refs/heads/main'
  run: echo "Main branch step"
```

### Workflow Reuse

Reference workflows from other repos:

```yaml
jobs:
  call-workflow:
    uses: owner/repo/.github/workflows/workflow.yml@main
```

## Monitoring & Alerts

### GitHub CLI Monitoring

```bash
# Watch workflow runs
gh run watch

# List recent failures
gh run list --status failure --limit 10

# Get workflow statistics
gh api repos/GizzZmo/Security-Sentinel/actions/runs \
  --jq '.workflow_runs[] | {name: .name, status: .status, conclusion: .conclusion}'
```

### Email Notifications

Configure in GitHub Settings:
1. Settings → Notifications
2. Enable "Actions" notifications
3. Choose email or web notifications

## Performance Optimization

### Reduce Build Times

1. **Use Caching Aggressively**
   ```yaml
   - uses: actions/cache@v4
     with:
       path: ~/.cache
       key: ${{ runner.os }}-${{ hashFiles('**/*.lock') }}
   ```

2. **Parallelize When Possible**
   ```yaml
   strategy:
     matrix:
       node: [18, 20, 22]
   ```

3. **Skip Unnecessary Steps**
   ```yaml
   - name: Skip on docs-only changes
     if: "!contains(github.event.head_commit.message, '[docs]')"
   ```

### Reduce Artifact Storage

1. **Set Shorter Retention**
   ```yaml
   - uses: actions/upload-artifact@v4
     with:
       retention-days: 7  # Instead of 90
   ```

2. **Compress Artifacts**
   ```yaml
   - name: Compress before upload
     run: tar -czf artifact.tar.gz files/
   ```

## Security Best Practices

### Secrets Management

```yaml
# Never hardcode secrets
# Use GitHub Secrets instead
- name: Use secret
  env:
    API_KEY: ${{ secrets.API_KEY }}
  run: ./script.sh
```

### Dependency Pinning

```yaml
# Pin action versions by SHA
uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1
```

### Minimal Permissions

```yaml
# Grant only required permissions
permissions:
  contents: read
  pull-requests: write
```

## Troubleshooting Checklist

- [ ] Check workflow syntax with yamllint
- [ ] Verify all required secrets are set
- [ ] Confirm branch protection rules
- [ ] Check for rate limiting issues
- [ ] Review recent GitHub Actions status
- [ ] Verify artifact names match exactly
- [ ] Check file paths are correct
- [ ] Ensure permissions are sufficient
- [ ] Review conditional logic in workflows
- [ ] Check for outdated action versions

## Resources

### Documentation
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [Security Sentinel Workflows](ADVANCED_WORKFLOWS.md)

### Tools
- [GitHub CLI](https://cli.github.com/)
- [Act - Local Testing](https://github.com/nektos/act)
- [Workflow Visualizer](https://github.com/actions/workflow-visualizer)

### Support
- [GitHub Actions Community](https://github.community/c/actions)
- [Security Sentinel Issues](https://github.com/GizzZmo/Security-Sentinel/issues)

## Getting Help

1. **Check Documentation**: Start with this guide and [ADVANCED_WORKFLOWS.md](ADVANCED_WORKFLOWS.md)
2. **Search Issues**: Look for similar problems in GitHub Issues
3. **Ask the Community**: Create a discussion or issue
4. **Check Status**: Visit [GitHub Status](https://www.githubstatus.com/)

---

**Quick Links:**
- [All Workflows](WORKFLOW_SUMMARY.md)
- [Advanced Guide](ADVANCED_WORKFLOWS.md)
- [Contributing](../CONTRIBUTING.md)

**Need Help?** Create an issue with the `workflow` label.
