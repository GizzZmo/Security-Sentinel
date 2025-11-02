# Frequently Asked Questions (FAQ)

Common questions and answers about Security Sentinel for Windows 11 & Linux.

## 📚 Table of Contents

- [General Questions](#general-questions)
- [Installation & Setup](#installation--setup)
- [Configuration](#configuration)
- [Features & Functionality](#features--functionality)
- [Troubleshooting](#troubleshooting)
- [AI Assistant](#ai-assistant)
- [Performance](#performance)
- [Security & Privacy](#security--privacy)
- [Development](#development)

---

## General Questions

### What is Security Sentinel?

Security Sentinel is a comprehensive, cross-platform security monitoring application that combines real-time system monitoring with AI-powered threat analysis. It's available as both a native C++ application (Windows/Linux) and a modern web interface (React/TypeScript).

### Is Security Sentinel free?

Yes! Security Sentinel is completely free and open source under the MIT License. You can use, modify, and distribute it freely.

### What platforms are supported?

Currently:
- **C++ Application**: Windows 11 (primary), Linux (beta support)
- **Web Interface**: Any modern browser (Chrome, Firefox, Safari, Edge)

### Do I need an API key?

Yes, you need a Google Gemini API key to use the AI assistant features. The key is free and can be obtained from [Google AI Studio](https://makersuite.google.com/app/apikey). Without it, basic monitoring features still work, but AI analysis won't be available.

### Is administrator access required?

**For C++ Application**: Yes, administrator/root privileges are required for full system monitoring capabilities (process listing, network connections, etc.).

**For Web Interface**: No admin rights needed, but functionality is limited to what the browser permits.

---

## Installation & Setup

### How do I install Security Sentinel?

**Quick Method**:
1. Download the latest release from [GitHub Releases](https://github.com/GizzZmo/Security-Sentinel/releases)
2. Extract to any folder
3. Create `config.ini` with your Gemini API key
4. Run as administrator

**Build from Source**: See [Building from Source](Building-from-Source.md)

**Web Interface**: See [Installation Guide](Installation-Guide.md)

### Where do I get a Gemini API key?

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy and save the key
5. Add it to your `config.ini` or `.env.local` file

### What are the minimum system requirements?

- **Windows**: Windows 11 (22H2 or later) or Windows 10 (21H2 or later)
- **Linux**: Ubuntu 20.04+, Fedora 35+, or equivalent
- **CPU**: 2+ cores recommended
- **RAM**: 4GB minimum, 8GB recommended
- **Disk**: 500MB free space
- **Network**: Internet connection for AI features

See [System Requirements](System-Requirements.md) for details.

### Why won't the application start?

**Common causes**:
1. **No administrator rights**: Right-click → "Run as administrator"
2. **Missing API key**: Check `config.ini` has valid Gemini API key
3. **Missing dependencies**: Install Visual C++ Redistributable (Windows)
4. **Antivirus blocking**: Add exception for SecuritySentinel.exe

See [Common Issues](Common-Issues.md) for more solutions.

---

## Configuration

### Where is the configuration file?

**C++ Application**: `config.ini` in the same folder as the executable

**Web Interface**: `.env.local` in the project root directory

### What settings can I customize?

Key configuration options:
- **API Settings**: Gemini API key, model selection, response parameters
- **Monitoring**: Update intervals, log levels, event retention
- **Network**: IP whitelisting, detection thresholds, auto-blocking
- **UI**: Color schemes, refresh rates, display options

See [Configuration](Configuration.md) for complete reference.

### How do I change the monitoring interval?

Edit `config.ini`:
```ini
[monitoring]
update_interval=5  # Seconds between updates (1-60)
```

Lower values = more frequent updates but higher CPU usage.

### Can I whitelist certain IPs?

Yes! In `config.ini`:
```ini
[network]
whitelist_ips=192.168.1.0/24,10.0.0.0/8
```

Whitelisted IPs won't be blocked even if flagged as suspicious.

---

## Features & Functionality

### What can Security Sentinel monitor?

- **Processes**: All running processes with resource usage
- **Network**: TCP/UDP connections, traffic patterns
- **System Resources**: CPU, memory, disk usage
- **Security Events**: Suspicious activities, threats, anomalies
- **File Integrity**: SHA-256 hashing with tamper detection (v1.1+)

### Does it detect all types of threats?

Security Sentinel focuses on:
- ✅ Network-based threats (port scans, DDoS)
- ✅ Suspicious processes and behaviors
- ✅ Anomalous resource usage
- ✅ Known malicious IPs and patterns
- ⚠️ **Not** a replacement for full antivirus software

Use Security Sentinel alongside traditional antivirus for comprehensive protection.

### How does the AI assistant work?

The AI assistant uses Google's Gemini AI to:
- Analyze security events and provide insights
- Answer security-related questions
- Explain network connections and processes
- Recommend security best practices
- Guide incident response

It has context about your system's security state and provides tailored advice.

### Can I export monitoring data?

**Yes!** Version 1.1+ includes JSON reporting:
```cpp
// Machine-readable security reports
CheckResult result = CreateCheckResult("scan", Status::PASS);
std::string json = CheckResultToJson(result);
```

Perfect for SIEM integration, automation, and analysis.

### Does it work offline?

**Monitoring**: Yes, all monitoring features work offline
**AI Assistant**: No, requires internet connection to Google's Gemini API
**Updates**: Internet needed for software updates only

---

## Troubleshooting

### High CPU usage - is this normal?

Normal usage:
- **Idle**: <1% CPU
- **Active monitoring**: 2-5% CPU
- **AI queries**: 3-7% CPU

High usage (>10%) may indicate:
- Monitoring interval set too low
- Too many processes/connections
- Debug logging enabled

See [Performance Optimization](Performance-Optimization.md) for tuning.

### Network monitoring shows no connections?

**Causes**:
1. Not running as administrator
2. Windows Firewall blocking the application
3. Network drivers not compatible
4. Using web interface (limited browser access)

**Solution**: Run C++ application as administrator.

### AI assistant not responding?

**Check**:
1. Valid API key in configuration
2. Internet connection active
3. No firewall blocking HTTPS traffic
4. API quota not exceeded (check Google AI Studio)

**Error messages**:
- "Authentication failed" → Invalid API key
- "Timeout" → Network/firewall issue
- "Rate limit" → Too many requests, wait and retry

### "Access denied" errors?

Most common cause: not running with administrator privileges.

**Fix**:
- Right-click application → "Run as administrator"
- Or permanently: Right-click → Properties → Compatibility → "Run as administrator"

---

## AI Assistant

### What AI model does it use?

**Default**: Gemini 2.5 Flash (fast, efficient)
**Alternative**: Gemini Pro (more detailed, slower)

Change in `config.ini`:
```ini
[gemini]
model=gemini-2.5-flash  # or gemini-pro
```

### How much does the AI cost?

Gemini API pricing:
- **Free tier**: 60 requests/minute
- **Paid**: Very low cost per request

Most users stay within free tier limits. Monitor usage at [Google AI Studio](https://makersuite.google.com/).

### Can I use it without the AI?

Yes! All core monitoring features work without an API key. You'll lose:
- AI-powered threat analysis
- Interactive security assistant
- Intelligent recommendations

Basic monitoring, network analysis, and threat detection still function.

### Is my data sent to Google?

**What's sent**:
- Security queries and questions
- System metrics when explicitly requested
- Network connection summaries for analysis

**What's NOT sent**:
- Continuous monitoring data
- Personal files or documents
- Passwords or sensitive data
- Monitoring history (stays local)

See [Privacy Policy](Privacy-Policy.md) for details.

---

## Performance

### How much RAM does it use?

**C++ Application**: 15-30 MB typical
**Web Interface**: 50-100 MB (browser dependent)
**Combined**: ~150-200 MB total

Memory usage scales with:
- Number of monitored processes
- Network connection count
- Event history size

### Does it slow down my computer?

No significant impact:
- **CPU**: <1% idle, 2-5% active
- **Disk**: Minimal (logs only)
- **Network**: Only for AI queries

Designed to be lightweight and non-intrusive.

### Can I reduce resource usage?

Yes! Optimization tips:
1. Increase monitoring interval: `update_interval=10`
2. Reduce event history: `max_events=5000`
3. Disable unused features
4. Lower AI query frequency

See [Performance Optimization](Performance-Optimization.md).

### How many connections can it monitor?

**Tested limits**:
- 1000+ simultaneous connections
- 500+ processes
- 10,000+ security events

Performance depends on your hardware, but typical systems handle this easily.

---

## Security & Privacy

### Is my monitoring data secure?

**Yes!** All data stays local:
- Monitoring data: Stored locally only
- Configuration: Local `config.ini` file
- Logs: Local file system
- Only AI queries sent to external servers

### Can others see my monitoring data?

No, unless:
- You explicitly share your logs or reports
- Someone gains access to your computer
- You export and share JSON reports

**Recommendation**: Treat monitoring data as sensitive and protect accordingly.

### Does it collect telemetry?

**No!** Security Sentinel does not:
- Send usage statistics
- Phone home
- Track user behavior
- Collect personal information

100% of your data stays on your machine.

### Is the source code auditable?

**Yes!** Completely open source:
- MIT License
- Full source on GitHub
- Community reviewed
- No hidden functionality

Audit it yourself or review community audits.

---

## Development

### How do I build from source?

**C++ Application**:
```bash
mkdir build && cd build
cmake ..
cmake --build . --config Release
```

**Web Interface**:
```bash
npm install
npm run dev
```

See [Development Setup](Development-Setup.md) for detailed instructions.

### Can I contribute?

**Absolutely!** We welcome:
- Bug fixes
- New features
- Documentation improvements
- UI/UX enhancements
- Performance optimizations
- Security research

See [Contributing Guidelines](Contributing-Guidelines.md).

### What programming languages are used?

- **C++ (17)**: Native application
- **Go (1.24+)**: Performance-critical core operations
- **TypeScript/React (19)**: Web interface
- **CMake**: Build system

### How do I report a bug?

1. Check [Common Issues](Common-Issues.md) first
2. Search existing [GitHub Issues](https://github.com/GizzZmo/Security-Sentinel/issues)
3. Create new issue with:
   - OS version and environment
   - Steps to reproduce
   - Expected vs actual behavior
   - Error messages/logs
   - Screenshots if applicable

### Where can I get help?

**Resources**:
- 📚 [WIKI Documentation](Home.md)
- 🐛 [GitHub Issues](https://github.com/GizzZmo/Security-Sentinel/issues)
- 💬 [Discussions](https://github.com/GizzZmo/Security-Sentinel/discussions)
- 📧 [Support](Support.md)

---

## Still Have Questions?

If your question isn't answered here:

1. **Search the documentation**: [WIKI Home](Home.md)
2. **Check existing issues**: [GitHub Issues](https://github.com/GizzZmo/Security-Sentinel/issues)
3. **Ask the community**: [GitHub Discussions](https://github.com/GizzZmo/Security-Sentinel/discussions)
4. **Contact support**: [Support Page](Support.md)

---

**Last Updated**: January 2025  
**Version**: 1.1+

[🏠 Back to Home](Home.md) | [📖 Full Documentation](Home.md)
