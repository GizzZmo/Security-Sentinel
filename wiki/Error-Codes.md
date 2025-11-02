# Error Codes

Reference guide for Security Sentinel error codes and their meanings.

## 📋 Error Code Categories

- **1xx**: Configuration Errors
- **2xx**: Network Errors
- **3xx**: System Errors
- **4xx**: AI/API Errors
- **5xx**: Security Errors

---

## Configuration Errors (1xx)

### 101 - Configuration File Not Found
**Cause**: `config.ini` or specified config file doesn't exist.

**Solution**:
```bash
# Create config.ini with minimum settings
echo [gemini] > config.ini
echo api_key=YOUR_KEY >> config.ini
```

### 102 - Invalid Configuration Format
**Cause**: Syntax error in configuration file.

**Solution**: Check INI syntax, ensure `[section]` and `key=value` format.

### 103 - Missing Required Configuration
**Cause**: Required setting (e.g., API key) not specified.

**Solution**: Add missing configuration values.

### 104 - Invalid Configuration Value
**Cause**: Configuration value out of valid range.

**Example**: `update_interval=-1` (must be 1-60)

---

## Network Errors (2xx)

### 201 - Network Connection Failed
**Cause**: Cannot establish network connection.

**Solution**: Check internet connectivity and firewall settings.

### 202 - DNS Resolution Failed
**Cause**: Cannot resolve API hostname.

**Solution**: Check DNS settings or use alternative DNS server.

### 203 - Connection Timeout
**Cause**: Request timed out.

**Solution**: Increase timeout value or check network speed.

### 204 - IP Blocking Failed
**Cause**: Unable to block IP address.

**Solution**: Ensure administrator privileges.

---

## System Errors (3xx)

### 301 - Insufficient Privileges
**Cause**: Not running with administrator/root privileges.

**Solution**:
```bash
# Windows
# Right-click → Run as administrator

# Linux
sudo ./SecuritySentinel
```

### 302 - Process Enumeration Failed
**Cause**: Cannot list running processes.

**Solution**: Check administrator privileges and Windows API availability.

### 303 - Memory Allocation Failed
**Cause**: Insufficient system memory.

**Solution**: Close other applications or add more RAM.

### 304 - File Access Denied
**Cause**: Cannot read/write required file.

**Solution**: Check file permissions.

---

## AI/API Errors (4xx)

### 401 - Invalid API Key
**Cause**: Gemini API key is invalid or expired.

**Solution**: Verify API key at [Google AI Studio](https://makersuite.google.com/app/apikey).

### 402 - API Authentication Failed
**Cause**: Authentication with AI service failed.

**Solution**: Check API key and network connectivity.

### 403 - API Rate Limit Exceeded
**Cause**: Too many API requests.

**Solution**: Wait before retrying or upgrade API quota.

### 404 - AI Service Unavailable
**Cause**: Google Gemini API is down or unreachable.

**Solution**: Check [Google Cloud Status](https://status.cloud.google.com/).

### 405 - Invalid AI Response
**Cause**: Unexpected response format from AI.

**Solution**: Report issue if persistent.

---

## Security Errors (5xx)

### 501 - Integrity Check Failed
**Cause**: File integrity verification failed (possible tampering).

**Solution**:
```bash
# Reinstall from official source
# Verify download integrity
```

### 502 - Signature Verification Failed
**Cause**: Digital signature invalid.

**Solution**: Download from official GitHub releases only.

### 503 - Threat Detected
**Cause**: Security threat identified.

**Action**: Review threat details and take appropriate action.

### 504 - Self-Protection Triggered
**Cause**: Tampering attempt detected.

**Action**: Investigate and reinstall if necessary.

---

## Go Core Errors (6xx)

### 601 - Go Runtime Initialization Failed
**Cause**: Cannot initialize Go core module.

**Solution**: Ensure Go core library is properly built.

### 602 - File Hash Calculation Failed
**Cause**: Error computing file hash.

**Solution**: Check file exists and is readable.

---

## Troubleshooting by Error Code

### Quick Reference

| Code | Severity | Common Fix |
|------|----------|-----------|
| 101 | Low | Create config file |
| 301 | Medium | Run as administrator |
| 401 | Medium | Check API key |
| 403 | Low | Wait and retry |
| 501 | High | Reinstall application |

### Getting Help

If error persists:
1. Check [Common Issues](Common-Issues.md)
2. Search [GitHub Issues](https://github.com/GizzZmo/Security-Sentinel/issues)
3. Create new issue with error code and logs

---

[🏠 Back to Home](Home.md) | [❓ FAQ](FAQ.md) | [🔧 Troubleshooting](Common-Issues.md)
