# ⚠️ MANUAL ACTION REQUIRED: GitHub Actions Configuration Issues

## 🚨 Critical Information

**Issue 1 - GitHub Actions Policy Restriction**:  
> "Code scanning with GitHub Actions is not available for this repository. GitHub Actions policy is limiting the use of some required actions."

**Issue 2 - CodeQL Default Setup Conflict**:  
> "CodeQL analyses from advanced configurations cannot be processed when the default setup is enabled"

**Root Cause**: These are **repository settings conflicts**, NOT code bugs.

**Solution Required**: Manual repository settings changes (cannot be automated)

## ✅ Quick Fix (5 Minutes)

### Fix 1: Allow Required GitHub Actions (REQUIRED FIRST)

GitHub Actions policy is blocking required actions. You need to allow them:

1. **Navigate to Actions settings**  
   👉 Click here: https://github.com/GizzZmo/Security-Sentinel/settings/actions

2. **Configure Actions permissions**  
   - Scroll to "Actions permissions" section
   - Select **"Allow all actions and reusable workflows"**
   - **OR** select "Allow select actions and reusable workflows" and add:
     - `actions/*`
     - `github/codeql-action/*`
     - `gitleaks/gitleaks-action/*`
     - `trufflesecurity/trufflehog/*`

3. **Save changes**  
   - Click "Save" button at the bottom

### Fix 2: Disable CodeQL Default Setup (IF APPLICABLE)

If you also see the "default setup" error, follow these steps:

1. **Navigate to security settings**  
   👉 Click here: https://github.com/GizzZmo/Security-Sentinel/settings/security_analysis

2. **Locate the conflicting setup**  
   - Find the "Code scanning" section
   - Look for "Default setup" (will show as "Active" or "Enabled")

3. **Disable the default setup**  
   - Click the **"..."** (three dots) menu button
   - Select **"Remove"** or **"Disable"**

4. **Confirm the change**  
   - Click "Yes" or "Confirm" when prompted
   - Status should change to "Disabled" or entry should disappear

### Final Step: Re-run the Workflow

5. **Re-run the workflow**  
   - Go to: https://github.com/GizzZmo/Security-Sentinel/actions
   - Find the failed "🔐 Security Scanning" workflow
   - Click **"Re-run all jobs"**

## 🎯 Why These Errors Occur

### Issue 1: GitHub Actions Policy Restriction

**Current State** (Blocking Workflows):
```
Repository Settings → Actions:
├── ❌ Actions policy is TOO RESTRICTIVE
│   └── Blocking: actions/*, github/codeql-action/*, etc.
└── Result: Security scanning workflows cannot run
```

**Required State** (Working):
```
Repository Settings → Actions:
├── ✅ Allow all actions OR allow specific actions:
│   ├── actions/*
│   ├── github/codeql-action/*
│   ├── gitleaks/gitleaks-action/*
│   └── trufflesecurity/trufflehog/*
└── Result: Security scanning workflows can run
```

### Issue 2: CodeQL Default Setup Conflict (if applicable)

**Current State** (Causing Conflict):
```
Repository Settings:
├── ✅ Advanced CodeQL Configuration (.github/workflows/security.yml)
│   ├── Multi-language support (JavaScript + C++)
│   ├── Custom build steps
│   └── Matrix strategy
└── ❌ Default GitHub Code Scanning (ENABLED) ← Must be disabled!
```

**Required State** (Working):
```
Repository Settings:
├── ✅ Advanced CodeQL Configuration (.github/workflows/security.yml)
│   ├── Multi-language support (JavaScript + C++)
│   ├── Custom build steps
│   └── Matrix strategy
└── ✅ Default GitHub Code Scanning (DISABLED)
```

## 📚 Detailed Documentation

This repository includes comprehensive documentation for this issue:

| Document | Purpose |
|----------|---------|
| [`.github/CODEQL_ERROR_HELP.md`](.github/CODEQL_ERROR_HELP.md) | Ultra-quick 4-step guide |
| [`.github/CODEQL_QUICK_FIX.md`](.github/CODEQL_QUICK_FIX.md) | Comprehensive troubleshooting |
| [`.github/CODEQL_SETUP.md`](.github/CODEQL_SETUP.md) | Complete configuration guide |
| [`.github/CODEQL_RESOLUTION_SUMMARY.md`](.github/CODEQL_RESOLUTION_SUMMARY.md) | Resolution verification |
| [`.github/ADVANCED_CODEQL_SETUP.md`](.github/ADVANCED_CODEQL_SETUP.md) | Advanced setup details |

## ❓ FAQ

### Why can't this be automated?
GitHub repository security and Actions policy settings can only be modified through the web UI. No API or automation tool can modify these settings programmatically.

### Which issue should I fix first?
**Fix the GitHub Actions policy restriction first.** If actions are blocked, the workflows won't run regardless of other settings.

### Who can make these changes?
Anyone with **Admin** access to the repository. (Write access may not be sufficient for Actions policy changes.)

### What happens if I only fix one issue?
You need to fix **both** issues for the workflows to run:
1. Actions policy must allow required actions
2. Default CodeQL setup must be disabled (if enabled)

### Will I lose my security scan results?
No! Existing security scan results will remain. The advanced configuration will continue providing comprehensive scanning.

### Why not use the default setup instead?
The advanced configuration in this repository is superior because it:
- ✅ Analyzes both JavaScript AND C++ code
- ✅ Uses custom CMake build for accurate C++ analysis  
- ✅ Provides matrix strategy for comprehensive coverage
- ✅ Integrates with other security tools in the workflow

### How do I know which actions to allow?
The security workflow requires these actions:
- `actions/*` - Official GitHub actions (checkout, setup-node, upload-artifact)
- `github/codeql-action/*` - CodeQL security scanning
- `gitleaks/gitleaks-action/*` - Secret scanning with GitLeaks
- `trufflesecurity/trufflehog/*` - Secret scanning with TruffleHog

### Is this a one-time fix?
Yes! Once configured correctly, these settings won't change automatically.

### What if I don't have permissions?
Contact the repository owner (@GizzZmo) and share this document.

## ✅ Verification Steps

After making the changes, verify success:

1. ✅ **Actions policy** allows required actions (Settings → Actions)
2. ✅ **Default setup** shows as "Disabled" in repository settings (if it was enabled)
3. ✅ **Security workflow** runs without "policy" or "configuration conflict" errors
4. ✅ **All jobs complete**: Dependency scan, CodeQL (JavaScript + C++), Secret scan, License scan
5. ✅ **SARIF results** upload to GitHub Security tab successfully

## 🆘 Still Having Issues?

### GitHub Actions policy blocking actions?

**Error message**: "GitHub Actions policy is limiting the use of some required actions"

**Solutions**:
1. Go to Settings → Actions → Actions permissions
2. Choose "Allow all actions and reusable workflows"
3. OR add specific actions to the allow list:
   - `actions/*`
   - `github/codeql-action/*`
   - `gitleaks/gitleaks-action/*`
   - `trufflesecurity/trufflehog/*`
4. Save and re-run the workflow

### Organization policies overriding repository settings?

If your repository is in an organization, organization-level policies may override repository settings:
- Contact your organization administrator
- Request an exception for security scanning actions
- Provide this document as justification

### Can't find the "Default setup" option?

Try these alternatives:
- Method 1: Go to Security tab → Code scanning → Look for setup options
- Method 2: Check Actions tab for workflows named `github-code-scanning/codeql`
- Method 3: Settings → Code security and analysis → Find CodeQL configurations

### Changes don't take effect?

- Wait 2-3 minutes for GitHub to propagate settings
- Clear browser cache (Ctrl+F5 or Cmd+Shift+R)
- Try in an incognito/private browser window
- Verify you're looking at the correct repository

### Error still appears after making changes?

1. **Verify Actions policy** is configured correctly (Settings → Actions)
2. **Verify default setup** is actually disabled (not just reconfigured)
3. **Check organization policies** - they may override repository settings
4. **Re-run the entire workflow** (don't just retry failed jobs)
5. **Wait 5 minutes** and try again - settings may take time to propagate
6. **Check workflow logs** for specific error messages

## 📞 Support

- **Repository Owner**: @GizzZmo
- **Issues**: https://github.com/GizzZmo/Security-Sentinel/issues
- **Discussions**: https://github.com/GizzZmo/Security-Sentinel/discussions
- **GitHub Docs - Actions Permissions**: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository
- **GitHub Docs - Code Scanning**: https://docs.github.com/en/code-security/code-scanning

---

## 🎯 Action Summary

**What you need to do:**
1. **Fix Actions policy** - Allow required actions (Settings → Actions)
2. **Fix CodeQL setup** - Disable "Default setup" for Code scanning (if enabled)
3. **Re-run the workflow** - Verify it completes successfully

**Estimated time:** 5 minutes  
**Complexity:** Low (simple setting changes)  
**Impact:** Resolves workflow failures, enables comprehensive security scanning

---

**📌 Remember**: The code and workflows are correct. These are repository settings issues that require simple manual changes through GitHub's web interface. **Fix the Actions policy first, then address the CodeQL setup if needed.**
