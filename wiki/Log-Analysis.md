# Log Analysis

Guide to analyzing Security Sentinel logs for security insights.

## 📋 Log Files

### Log Locations

**Default**:
- Windows: Same directory as executable
- Linux: `/var/log/security-sentinel/` (if installed system-wide)

**Custom**: Specified in `config.ini`:
```ini
[monitoring]
log_file=/path/to/custom.log
```

## Log Format

### Standard Format

```
[TIMESTAMP] [LEVEL] [COMPONENT] Message
```

**Example**:
```
[2025-01-15 14:23:45] [INFO] [SecurityMonitor] System scan completed
[2025-01-15 14:23:50] [WARN] [NetworkMonitor] Port scan detected from 203.0.113.45
[2025-01-15 14:23:51] [INFO] [ThreatProtection] IP 203.0.113.45 blocked
```

## Log Levels

- **DEBUG**: Detailed diagnostic information
- **INFO**: Normal operational messages
- **WARN**: Warning conditions
- **ERROR**: Error conditions

## Common Log Patterns

### Threat Detection

```
[WARN] [NetworkMonitor] Port scan detected from <IP>
[WARN] [NetworkMonitor] DDoS attempt from <IP>
[INFO] [ThreatProtection] IP <IP> blocked
```

### System Events

```
[INFO] [SecurityMonitor] System scan completed
[INFO] [SecurityMonitor] <N> processes monitored
[INFO] [NetworkMonitor] <N> active connections
```

### Errors

```
[ERROR] [GeminiClient] API request failed: <reason>
[ERROR] [SecurityMonitor] Process enumeration failed
[ERROR] [GoCore] File integrity check failed for <file>
```

## Analysis Commands

### Linux/Mac

```bash
# View logs in real-time
tail -f security-sentinel.log

# Count warnings and errors
grep -c "WARN\|ERROR" security-sentinel.log

# Extract threats detected
grep "Port scan\|DDoS" security-sentinel.log

# Most blocked IPs
grep "IP.*blocked" security-sentinel.log | awk '{print $NF}' | sort | uniq -c | sort -nr
```

### Windows PowerShell

```powershell
# View last 50 lines
Get-Content security-sentinel.log -Tail 50

# Count errors
(Select-String -Path security-sentinel.log -Pattern "ERROR").Count

# Find all blocked IPs
Select-String -Path security-sentinel.log -Pattern "IP.*blocked"
```

## Security Insights

### Identifying Attacks

**Port Scan Pattern**:
```
[WARN] Port scan detected from 203.0.113.45
[WARN] Port scan detected from 203.0.113.46
[WARN] Port scan detected from 203.0.113.47
```
→ Coordinated attack from subnet

**DDoS Pattern**:
```
[WARN] DDoS attempt from 198.51.100.23
[WARN] DDoS attempt from 198.51.100.24
[WARN] High connection rate detected
```
→ Distributed attack

### Performance Issues

**High Resource Usage**:
```
[WARN] CPU usage above 80%
[WARN] Memory usage above 90%
```
→ Investigate cause

## Best Practices

1. **Regular Review**: Check logs daily
2. **Retention**: Keep 30 days minimum
3. **Rotation**: Rotate logs weekly
4. **Backup**: Backup important security events
5. **Analysis**: Use log analysis tools

---

[🏠 Back to Home](Home.md) | [🔧 Debugging](Debugging-Guide.md)
