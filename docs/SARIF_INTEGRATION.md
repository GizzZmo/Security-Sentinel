# SARIF Integration Guide

## Overview

This repository uses SARIF (Static Analysis Results Interchange Format) to upload security scanning results to GitHub's Code Scanning feature. SARIF is a standard JSON format for representing the output from static analysis tools.

### SARIF Integration Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Actions Workflows                      │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
  ┌──────────┐          ┌──────────┐         ┌──────────┐
  │ ci-web   │          │ ci-cpp   │         │ security │
  │ workflow │          │ workflow │         │ workflow │
  └──────────┘          └──────────┘         └──────────┘
        │                     │                     │
        │                     │                     │
   ┌────┴────┐           ┌────┴────┐          ┌────┴────┐
   │         │           │         │          │         │
   ▼         ▼           ▼         ▼          ▼         ▼
┌─────┐  ┌─────┐    ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐
│ESLint│ │npm  │    │Semgrep│ │Static│  │CodeQL│  │CodeQL│
│     │  │audit│    │       │ │Anlys│  │(JS)  │  │(C++) │
└─────┘  └─────┘    └─────┘   └─────┘   └─────┘   └─────┘
   │         │           │         │         │         │
   └────┬────┘           └────┬────┘         └────┬────┘
        │                     │                    │
        ▼                     ▼                    ▼
   Generate SARIF        Generate SARIF      Generate SARIF
   (formatter/           (native)            (native)
    converter)
        │                     │                    │
        └─────────────────────┼────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │ upload-sarif     │
                    │ GitHub Action    │
                    └──────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │ GitHub Security  │
                    │ Code Scanning    │
                    └──────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
   Security Tab         PR Annotations        API Access
   (Alerts View)       (Inline Comments)    (Programmatic)
```

## What is SARIF?

SARIF is an OASIS standard format that allows security tools to output their findings in a consistent, machine-readable format. GitHub Code Scanning uses SARIF files to display security findings in the Security tab of your repository.

**Benefits of SARIF Integration:**
- ✅ Centralized security findings in GitHub Security tab
- ✅ Pull request annotations for security issues
- ✅ Trend analysis and metrics
- ✅ Integration with GitHub Advanced Security features
- ✅ Standardized format across multiple security tools

## Implemented SARIF Uploads

### 1. CodeQL Analysis (`security.yml`)

**Tool:** GitHub CodeQL  
**Languages:** JavaScript/TypeScript, C++  
**Category:** `/language:javascript`, `/language:cpp`

CodeQL performs semantic code analysis to identify security vulnerabilities and coding errors.

```yaml
- name: 🔍 Perform CodeQL Analysis
  uses: github/codeql-action/analyze@latest
  with:
    category: "/language:${{ matrix.language }}"
    upload: true
```

**Findings Location:** Repository → Security → Code scanning alerts → Filter by "CodeQL"

### 2. ESLint (`ci-web.yml`)

**Tool:** ESLint with @microsoft/eslint-formatter-sarif  
**Category:** `eslint`  
**Scope:** TypeScript/JavaScript files

ESLint checks for code quality and potential security issues in JavaScript/TypeScript code.

```yaml
- name: 🔍 Run ESLint with SARIF output
  run: |
    npm install --save-dev @microsoft/eslint-formatter-sarif
    npx eslint . --ext .ts,.tsx,.js,.jsx \
      --format @microsoft/eslint-formatter-sarif \
      --output-file eslint-results.sarif

- name: 📤 Upload ESLint SARIF results to GitHub
  uses: github/codeql-action/upload-sarif@latest
  with:
    sarif_file: eslint-results.sarif
    category: eslint
```

**Findings Location:** Repository → Security → Code scanning alerts → Filter by "eslint"

### 3. npm audit (`ci-web.yml`)

**Tool:** npm audit converted to SARIF via npm-audit-sarif  
**Category:** `npm-audit`  
**Scope:** Node.js dependencies

Scans npm dependencies for known security vulnerabilities.

```yaml
- name: 🔍 Run npm audit with JSON output
  run: npm audit --json > npm-audit.json

- name: 🔄 Convert npm audit to SARIF
  run: |
    npm install -g npm-audit-sarif
    cat npm-audit.json | npx npm-audit-sarif@latest > npm-audit.sarif

- name: 📤 Upload npm audit SARIF to GitHub
  uses: github/codeql-action/upload-sarif@latest
  with:
    sarif_file: npm-audit.sarif
    category: npm-audit
```

**Findings Location:** Repository → Security → Code scanning alerts → Filter by "npm-audit"

### 4. Semgrep (`ci-cpp.yml`)

**Tool:** Semgrep  
**Category:** `semgrep`  
**Scope:** C++ source files

Semgrep performs pattern-based security scanning for C++ code.

```yaml
- name: 🔍 Run Semgrep security scan
  uses: semgrep/semgrep-action@latest
  with:
    config: >-
      p/security-audit
      p/secrets
      p/cwe-top-25

- name: 📤 Upload SARIF file to GitHub Security
  uses: github/codeql-action/upload-sarif@latest
  with:
    sarif_file: semgrep.sarif
    category: semgrep
```

The Semgrep Action writes `semgrep.sarif`, which is then uploaded in the next step.

**Findings Location:** Repository → Security → Code scanning alerts → Filter by "semgrep"

## Viewing SARIF Results

### In the GitHub UI

1. Navigate to your repository
2. Click on the **Security** tab
3. Click on **Code scanning alerts** in the left sidebar
4. Filter by tool category using the dropdown menu

### In Pull Requests

Security findings are automatically annotated on PRs:
- Findings appear as comments on the specific lines of code
- Severity levels are color-coded (critical, high, medium, low)
- Each finding includes a description and remediation guidance

### Via API

You can also access SARIF results via the GitHub REST API:

```bash
curl -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/repos/OWNER/REPO/code-scanning/alerts
```

## Required Permissions

All workflows that upload SARIF files must have the following permissions:

```yaml
permissions:
  contents: read          # Required to checkout code
  security-events: write  # Required to upload SARIF files
  actions: read          # Required for some security features
```

These permissions are already configured in all relevant workflows.

## Best Practices

### 1. Use Categories

Always specify a category when uploading SARIF files to distinguish between different tools:

```yaml
with:
  sarif_file: results.sarif
  category: tool-name  # Important for filtering
```

### 2. Handle Failures Gracefully

Use `continue-on-error: true` for non-critical security scans to prevent blocking the pipeline:

```yaml
- name: Security scan
  run: npm audit
  continue-on-error: true
```

### 3. Conditional Uploads

Only upload SARIF files when they exist:

```yaml
if: always() && hashFiles('results.sarif') != ''
```

### 4. Artifact Retention

Upload SARIF files as artifacts for debugging and compliance:

```yaml
- name: 📤 Upload SARIF as artifact
  uses: actions/upload-artifact@latest
  with:
    name: security-results
    path: results.sarif
    retention-days: 30
```

## Troubleshooting

### SARIF File Not Appearing

**Problem:** SARIF file uploaded but no alerts appear in Security tab

**Solutions:**
1. Check that the SARIF file is valid JSON
2. Verify permissions are set correctly
3. Check workflow logs for upload errors
4. Ensure the repository has Code Scanning enabled
5. Wait a few minutes for processing (can take up to 5 minutes)

### Permission Denied Errors

**Problem:** `Resource not accessible by integration` error

**Solution:** Add required permissions to the job:

```yaml
permissions:
  security-events: write
```

### Invalid SARIF Format

**Problem:** SARIF file rejected during upload

**Solution:** Validate SARIF format using the official validator:

```bash
npm install -g @microsoft/sarif-multitool
sarif-multitool validate results.sarif
```

### CodeQL Default Setup Conflict

**Problem:** "CodeQL analyses from advanced configurations cannot be processed when the default setup is enabled"

**Solution:** See [.github/CODEQL_SETUP.md](../.github/CODEQL_SETUP.md) for detailed instructions on disabling default setup.

## Adding New SARIF Scanners

To add a new security scanner with SARIF output:

1. **Find or create a SARIF formatter for your tool**
   - Check if the tool natively supports SARIF output
   - Look for community converters (e.g., `npm-audit-sarif`, `bandit-sarif-formatter`)
   - Write a custom converter if needed

2. **Add to workflow**

```yaml
- name: Run security scanner
  run: |
    security-tool --output results.sarif
  continue-on-error: true

- name: Upload SARIF
  uses: github/codeql-action/upload-sarif@latest
  with:
    sarif_file: results.sarif
    category: tool-name
  if: always() && hashFiles('results.sarif') != ''
```

3. **Test the integration**
   - Run the workflow
   - Check the Security tab for results
   - Verify findings appear correctly

4. **Update documentation**
   - Add the new scanner to this document
   - Update the workflow documentation

## Tools with SARIF Support

### Actively Used in This Project

| Tool | Language | Purpose | SARIF Support |
|------|----------|---------|---------------|
| CodeQL | JS/TS, C++ | Semantic analysis | Native |
| ESLint | JS/TS | Linting | Via formatter |
| npm audit | Dependencies | Vulnerability scan | Via converter |
| Semgrep | C++ | Pattern scanning | Native |

### Additional Tools to Consider

| Tool | Language | Purpose | SARIF Support |
|------|----------|---------|---------------|
| Bandit | Python | Security linting | Via formatter |
| gosec | Go | Security scanning | Native |
| trivy | Containers | Vulnerability scan | Native |
| Checkov | IaC | Policy scanning | Native |
| SonarQube | Multiple | Code quality | Native |

## References

- [GitHub Code Scanning Documentation](https://docs.github.com/en/code-security/code-scanning)
- [Uploading a SARIF file to GitHub](https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/uploading-a-sarif-file-to-github)
- [SARIF Specification](https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html)
- [SARIF Tutorials](https://github.com/microsoft/sarif-tutorials)
- [CodeQL Action Documentation](https://github.com/github/codeql-action)

## Support

For issues with SARIF integration:

1. Check the [Troubleshooting](#troubleshooting) section
2. Review workflow logs in the Actions tab
3. Consult the [GitHub Community Forum](https://github.com/orgs/community/discussions)
4. Create an issue in this repository with the `security` label

---

**Last Updated:** 2025-01-02  
**Maintained By:** Security Sentinel Team
