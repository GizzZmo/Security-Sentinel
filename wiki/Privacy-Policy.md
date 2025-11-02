# Privacy Policy

Security Sentinel's approach to privacy and data handling.

## 📋 Overview

Security Sentinel is designed with **privacy-first principles**. This document explains what data is collected, how it's used, and your rights.

## TL;DR (Summary)

- ✅ **All monitoring data stays on your computer**
- ✅ **No telemetry or tracking**
- ✅ **No data sent to developers**
- ✅ **Only AI queries sent to Google Gemini (optional)**
- ✅ **Open source - verify yourself**

---

## Data Collection

### What We DON'T Collect

Security Sentinel **DOES NOT** collect, store, or transmit:

- ❌ Personal information
- ❌ System monitoring data
- ❌ Network connection details
- ❌ Process information
- ❌ Configuration files
- ❌ Log files
- ❌ Usage statistics
- ❌ Crash reports
- ❌ Telemetry data
- ❌ Analytics data

**Zero data leaves your computer** except as described below.

### What is Sent to External Services

**Google Gemini AI** (Optional - only if you use AI features):

When you use the AI assistant:
- ✅ Your security questions and messages
- ✅ System metrics you explicitly request analysis for
- ⚠️ **NOT** continuous monitoring data
- ⚠️ **NOT** your configuration or API keys
- ⚠️ **NOT** file contents or personal data

**Example of what IS sent**:
```
User: "What does this network activity mean?"
[Your message is sent to Gemini AI]
```

**Example of what is NOT sent**:
```
[Continuous monitoring data - stays local]
[Process list - stays local]
[Network connections - stays local]
[Configuration - stays local]
```

---

## Data Storage

### Local Storage Only

All data is stored **exclusively on your local system**:

**Configuration Files**:
- Location: Same directory as application
- Contains: API key, settings, preferences
- Security: File permissions restrict access
- Recommendation: Encrypt disk, protect API keys

**Log Files** (if enabled):
- Location: Application directory or specified location
- Contains: Security events, errors, debug information
- Retention: Configurable (default: 7 days)
- Access: Administrator only

**Monitoring Data**:
- Location: Memory only (not persisted)
- Retention: Current session only
- Storage: No disk storage unless explicitly exported

### No Cloud Storage

Security Sentinel **does not**:
- Upload data to cloud services
- Sync data across devices
- Backup data to remote servers
- Use cloud-based databases

---

## Third-Party Services

### Google Gemini AI

**Service Used**: Google Gemini AI API

**Purpose**: AI-powered security analysis and assistance

**Data Sent**:
- User messages to AI assistant
- Security questions
- System metrics requested for analysis

**Data NOT Sent**:
- Continuous monitoring data
- Automatic background data
- Personal files or documents
- Authentication credentials

**Google's Privacy Policy**: [https://policies.google.com/privacy](https://policies.google.com/privacy)

**Your Control**:
- AI features are optional
- Can be disabled by not configuring API key
- All core monitoring works without AI

### No Other Third Parties

Security Sentinel does **not** use:
- Analytics services (no Google Analytics, etc.)
- Crash reporting services
- CDNs for assets
- Ad networks
- Social media tracking

---

## API Key Security

### Your Responsibility

**API Keys** (Google Gemini):
- Stored in local configuration file
- Your responsibility to protect
- Treated as sensitive credentials
- Never transmitted except for authentication

**Best Practices**:
```ini
# config.ini should be protected
# Windows:
icacls config.ini /inheritance:r /grant:r "Administrators:F"

# Linux:
chmod 600 config.ini
chown root:root config.ini
```

### Our Commitment

We **never**:
- Store your API keys on our servers
- Log API keys
- Share API keys with third parties
- Include API keys in error reports
- Transmit API keys except to Google for authentication

---

## User Rights

### Your Data, Your Control

**You Have the Right To**:
- ✅ Know what data is collected (this policy)
- ✅ Access your local data (it's on your computer)
- ✅ Delete your data (delete application files)
- ✅ Export your data (use JSON reporting features)
- ✅ Opt-out of AI features (don't configure API key)

### Data Deletion

**To Delete All Data**:
```bash
# Windows
del config.ini
del /s /q logs\*

# Linux
rm config.ini
rm -rf logs/*
```

**After Uninstallation**:
- All data is removed with the application
- No residual data on remote servers
- No cloud backups to delete

---

## Security Measures

### Data Protection

**In Transit**:
- AI queries: HTTPS encryption to Google
- Local data: Never leaves your system
- No network transmission of monitoring data

**At Rest**:
- Configuration: Protected by file permissions
- Logs: Administrator access only
- Memory: Process isolation

**Access Control**:
- Administrator privileges required for full features
- File permissions protect sensitive data
- No remote access capabilities

### Security Recommendations

**For Maximum Privacy**:
1. Use disk encryption (BitLocker, LUKS)
2. Protect configuration files with strict permissions
3. Use environment variables for API keys
4. Review exported data before sharing
5. Use firewall to restrict network access
6. Regular security audits

---

## Transparency

### Open Source Verification

**Verify Our Claims**:
- 📂 All source code on [GitHub](https://github.com/GizzZmo/Security-Sentinel)
- 🔍 Review data collection code yourself
- 🔐 No hidden functionality
- 🤝 Community-reviewed

**Key Files to Review**:
- `src/GeminiClient.cpp` - AI integration (only user messages sent)
- `src/SecurityMonitor.cpp` - Monitoring (local only)
- `src/NetworkMonitor.cpp` - Network analysis (local only)
- `src/Utils.cpp` - Configuration handling (local only)

### No Backdoors

We guarantee:
- No hidden data collection
- No backdoors for remote access
- No obfuscated code
- All code is open for inspection

---

## Children's Privacy

Security Sentinel is not intended for use by children under 13. We do not knowingly collect information from children.

---

## Changes to This Policy

### Notification

If we change this privacy policy:
- Changes will be documented in CHANGELOG
- Major changes will be announced in release notes
- You can review history on GitHub

### Your Rights

You're not bound by policy changes:
- Continue using current version
- Switch to alternative software
- Fork the project under MIT license

---

## Compliance

### GDPR Compliance

**For EU Users**:
- ✅ Data minimization (we collect nothing)
- ✅ Purpose limitation (only AI queries sent)
- ✅ Storage limitation (local only, you control retention)
- ✅ Transparency (this policy)
- ✅ User rights (full control)

### CCPA Compliance

**For California Users**:
- ✅ Right to know: Documented here
- ✅ Right to delete: Delete application files
- ✅ Right to opt-out: Don't use AI features
- ✅ No sale of data: We don't collect data to sell

### Other Jurisdictions

Security Sentinel's **local-first design** ensures compliance with most privacy regulations worldwide:
- No data collection = no compliance issues
- User controls all data
- Transparent about AI usage

---

## Contact & Questions

### Privacy Questions

**Where to Ask**:
- 📧 GitHub Issues (for public questions)
- 💬 GitHub Discussions
- 📖 Documentation

**What We Can Answer**:
- How the application works
- What data is sent to AI services
- Technical implementation questions

**What We DON'T Have**:
- Your monitoring data (it's local)
- Your configuration (it's local)
- Your API keys (it's local)

### Security Concerns

**For Security Issues**:
- See [SECURITY.md](../SECURITY.md)
- Responsible disclosure appreciated
- Security advisories published on GitHub

---

## Summary

### Core Principles

1. **Privacy by Default**: No data collection
2. **Local First**: Everything stays on your computer
3. **Transparency**: Open source, auditable
4. **User Control**: You own and control all data
5. **Optional AI**: AI features are opt-in only

### What You Should Know

- ✅ Security Sentinel is safe to use
- ✅ Your data stays private
- ✅ You control everything
- ✅ Open source = verifiable
- ✅ No hidden surprises

### What You Should Do

1. Protect your API keys
2. Secure configuration files
3. Review exported data before sharing
4. Use disk encryption for sensitive systems
5. Read the source code if you want verification

---

## License

This privacy policy is part of the Security Sentinel project, licensed under CC0 1.0 Universal.

---

**Last Updated**: January 2025  
**Version**: 1.1  
**Effective Date**: January 1, 2025

[🏠 Back to Home](Home.md) | [📋 About](../ABOUT.md) | [🔒 Security Model](Security-Model.md)
