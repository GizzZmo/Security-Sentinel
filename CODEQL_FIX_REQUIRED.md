# ⚠️ MANUAL ACTION REQUIRED: CodeQL Configuration Conflict

## 🚨 Critical Information

**Issue**: CodeQL workflow is failing with error:  
> "CodeQL analyses from advanced configurations cannot be processed when the default setup is enabled"

**Root Cause**: This is a **repository settings conflict**, NOT a code bug.

**Solution Required**: Manual repository settings change (cannot be automated)

## ✅ Quick Fix (2 Minutes)

### Step-by-Step Instructions

1. **Navigate to repository settings**  
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

5. **Re-run the workflow**  
   - Go to: https://github.com/GizzZmo/Security-Sentinel/actions
   - Find the failed "🔐 Security Scanning" workflow
   - Click **"Re-run all jobs"**

## 🎯 Why This Error Occurs

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
GitHub repository security settings can only be modified through the web UI. No API or automation tool can disable the default Code Scanning setup.

### Who can make this change?
Anyone with **Admin** or **Write** access to the repository.

### Will I lose my security scan results?
No! Existing CodeQL results will remain. The advanced configuration will continue providing even better scanning.

### Why not use the default setup instead?
The advanced configuration in this repository is superior because it:
- ✅ Analyzes both JavaScript AND C++ code
- ✅ Uses custom CMake build for accurate C++ analysis  
- ✅ Provides matrix strategy for comprehensive coverage
- ✅ Integrates with other security tools in the workflow

### Is this a one-time fix?
Yes! Once disabled, the default setup won't re-enable automatically.

### What if I don't have permissions?
Contact the repository owner (@GizzZmo) and share this document.

## ✅ Verification Steps

After making the changes, verify success:

1. ✅ Default setup shows as "Disabled" in repository settings
2. ✅ Security workflow runs without "configuration conflict" error
3. ✅ Both JavaScript and C++ CodeQL analyses complete
4. ✅ SARIF results upload to GitHub Security tab
5. ✅ No dynamic CodeQL workflows appear in Actions tab

## 🆘 Still Having Issues?

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

### Error still appears?

1. Verify default setup is actually disabled (not just reconfigured)
2. Check if organization policies are enforcing default setup
3. Re-run the entire workflow (don't just retry failed jobs)
4. Wait 5 minutes and try again

## 📞 Support

- **Repository Owner**: @GizzZmo
- **Issues**: https://github.com/GizzZmo/Security-Sentinel/issues
- **Discussions**: https://github.com/GizzZmo/Security-Sentinel/discussions
- **GitHub Docs**: https://docs.github.com/en/code-security/code-scanning

---

## 🎯 Action Summary

**What you need to do:**
1. Go to repository settings (link above)
2. Disable "Default setup" for Code scanning
3. Re-run the workflow

**Estimated time:** 2-3 minutes  
**Complexity:** Low (simple setting change)  
**Impact:** Resolves workflow failures, maintains advanced security scanning

---

**📌 Remember**: The code and workflows are correct. This is purely a repository settings issue that requires a simple manual change through GitHub's web interface.
