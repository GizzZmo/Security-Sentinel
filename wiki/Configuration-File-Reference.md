# Configuration File Reference

Complete reference for Security Sentinel configuration files.

## 📋 Configuration Formats

Security Sentinel supports two configuration formats:
- **INI Format** (`config.ini`) - Simple, human-readable
- **JSON Format** (`config.json`) - Advanced features, type-safe (v1.1+)

---

## INI Configuration (config.ini)

### Basic Structure

```ini
[section]
key=value
# Comments start with #
```

### Complete Example

```ini
# Security Sentinel Configuration

[gemini]
# Google Gemini API key (required for AI features)
api_key=YOUR_API_KEY_HERE
# AI model selection
model=gemini-2.5-flash
# Maximum tokens per response
max_tokens=1000
# Temperature (0.0-1.0, higher = more creative)
temperature=0.7

[monitoring]
# Enable system monitoring
enabled=true
# Update interval in seconds (1-60)
update_interval=5
# Log level: DEBUG, INFO, WARN, ERROR
log_level=INFO
# Maximum events to store
max_events=10000
# Enable file logging
enable_file_logging=true
# Log file path
log_file=security-sentinel.log

[network]
# Enable network monitoring
monitor_enabled=true
# Auto-block suspicious IPs
block_suspicious=true
# Whitelisted IP ranges (comma-separated)
whitelist_ips=192.168.1.0/24,10.0.0.0/8
# Port scan detection threshold
scan_detection_threshold=5
# DDoS detection threshold
ddos_detection_threshold=100
# Connection timeout (seconds)
connection_timeout=30

[security]
# Enable file integrity monitoring
enable_integrity_check=true
# Auto-block threats
auto_block_threats=true
# Alert on suspicious activity
alert_on_suspicious=true
# Quarantine malicious files
quarantine_malicious=false

[ui]
# Color scheme: dark, light
color_scheme=dark
# Console refresh rate (milliseconds)
refresh_rate=1000
# Show advanced features
show_advanced=false
# Enable sound alerts
enable_sound=false
```

---

## JSON Configuration (config.json)

### Basic Structure

```json
{
  "section": {
    "key": "value"
  }
}
```

### Complete Example

```json
{
  "gemini": {
    "api_key": "${GEMINI_API_KEY}",
    "model": "gemini-2.5-flash",
    "max_tokens": 1000,
    "temperature": 0.7,
    "timeout": 30,
    "retry_attempts": 3
  },
  "monitoring": {
    "enabled": true,
    "update_interval": 5,
    "log_level": "INFO",
    "max_events": 10000,
    "enable_file_logging": true,
    "log_file": "security-sentinel.log",
    "event_retention_days": 7
  },
  "network": {
    "monitor_enabled": true,
    "block_suspicious": true,
    "whitelist_ips": [
      "192.168.1.0/24",
      "10.0.0.0/8",
      "172.16.0.0/12"
    ],
    "blacklist_ips": [],
    "scan_detection_threshold": 5,
    "ddos_detection_threshold": 100,
    "connection_timeout": 30,
    "max_connections_tracked": 1000
  },
  "security": {
    "enable_integrity_check": true,
    "integrity_check_interval": 300,
    "auto_block_threats": true,
    "alert_on_suspicious": true,
    "quarantine_malicious": false,
    "verify_signatures": true,
    "protected_files": [
      "SecuritySentinel.exe",
      "config.ini",
      "config.json"
    ]
  },
  "ui": {
    "color_scheme": "dark",
    "refresh_rate": 1000,
    "show_advanced": false,
    "enable_sound": false,
    "dashboard_layout": "standard"
  },
  "performance": {
    "max_cpu_usage": 10.0,
    "max_memory_mb": 100,
    "thread_pool_size": 4,
    "cache_size_mb": 50
  }
}
```

---

## Configuration Sections

### [gemini] - AI Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `api_key` | string | **required** | Google Gemini API key |
| `model` | string | `gemini-2.5-flash` | AI model to use |
| `max_tokens` | int | 1000 | Max response length |
| `temperature` | float | 0.7 | Response creativity (0.0-1.0) |
| `timeout` | int | 30 | Request timeout (seconds) |
| `retry_attempts` | int | 3 | Number of retries on failure |

**Models**:
- `gemini-2.5-flash` - Fast, efficient (recommended)
- `gemini-pro` - More detailed, slower

### [monitoring] - System Monitoring

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `enabled` | bool | true | Enable system monitoring |
| `update_interval` | int | 5 | Scan interval (1-60 seconds) |
| `log_level` | string | INFO | Logging verbosity |
| `max_events` | int | 10000 | Event history size |
| `enable_file_logging` | bool | true | Write logs to file |
| `log_file` | string | `security-sentinel.log` | Log file path |

**Log Levels**:
- `DEBUG` - Verbose, all details
- `INFO` - Normal operations
- `WARN` - Warnings only
- `ERROR` - Errors only

### [network] - Network Monitoring

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `monitor_enabled` | bool | true | Enable network monitoring |
| `block_suspicious` | bool | true | Auto-block suspicious IPs |
| `whitelist_ips` | string/array | - | Trusted IP ranges |
| `blacklist_ips` | string/array | - | Blocked IP ranges |
| `scan_detection_threshold` | int | 5 | Ports for scan detection |
| `ddos_detection_threshold` | int | 100 | Connections for DDoS detection |
| `connection_timeout` | int | 30 | Connection timeout (seconds) |

**IP Format**:
- Single IP: `192.168.1.1`
- CIDR range: `192.168.1.0/24`
- Multiple (INI): `192.168.1.0/24,10.0.0.0/8`
- Multiple (JSON): `["192.168.1.0/24", "10.0.0.0/8"]`

### [security] - Security Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `enable_integrity_check` | bool | true | Monitor file integrity |
| `integrity_check_interval` | int | 300 | Check interval (seconds) |
| `auto_block_threats` | bool | true | Auto-block detected threats |
| `alert_on_suspicious` | bool | true | Alert on suspicious activity |
| `quarantine_malicious` | bool | false | Quarantine malicious files |
| `verify_signatures` | bool | true | Verify digital signatures |

### [ui] - User Interface

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `color_scheme` | string | dark | UI theme (dark/light) |
| `refresh_rate` | int | 1000 | UI refresh (milliseconds) |
| `show_advanced` | bool | false | Show advanced options |
| `enable_sound` | bool | false | Sound alerts |

---

## Environment Variables

### Supported Variables

```bash
# API Key
export GEMINI_API_KEY="your_key_here"

# Custom config location
export SECURITY_SENTINEL_CONFIG="/path/to/config.ini"

# Debug mode
export SECURITY_SENTINEL_DEBUG=1

# Log level override
export SECURITY_SENTINEL_LOG_LEVEL=DEBUG
```

### Variable Substitution (JSON only)

```json
{
  "gemini": {
    "api_key": "${GEMINI_API_KEY}"
  }
}
```

---

## Configuration Validation

### Required Settings

Minimum configuration:
```ini
[gemini]
api_key=YOUR_KEY_HERE
```

Or disable AI:
```ini
[gemini]
api_key=

[monitoring]
enabled=true
```

### Validation Rules

- `update_interval`: 1-60 seconds
- `temperature`: 0.0-1.0
- `max_events`: > 0
- `log_level`: DEBUG, INFO, WARN, ERROR
- `color_scheme`: dark, light

---

## Best Practices

### Security

1. **Protect config files**:
   ```bash
   # Windows
   icacls config.ini /inheritance:r /grant:r "Administrators:F"
   
   # Linux
   chmod 600 config.ini
   ```

2. **Use environment variables** for API keys:
   ```json
   "api_key": "${GEMINI_API_KEY}"
   ```

3. **Backup configuration**:
   ```bash
   cp config.ini config.ini.backup
   ```

### Performance

1. **Adjust update interval**:
   - Higher = less CPU usage
   - Lower = more responsive monitoring
   - Recommended: 5 seconds

2. **Limit event history**:
   - `max_events=10000` for desktops
   - `max_events=50000` for servers

3. **Optimize logging**:
   - Production: `log_level=WARN`
   - Development: `log_level=DEBUG`

---

## Migration

### From v1.0 to v1.1

INI files are fully compatible. To use new features:

```ini
# Add new sections
[security]
enable_integrity_check=true
verify_signatures=true

[performance]
max_cpu_usage=10.0
```

### INI to JSON

Convert manually or use tool:
```bash
# Example conversion
python convert_config.py config.ini > config.json
```

---

## Troubleshooting

### Config Not Loading

1. Check file exists: `ls -la config.ini`
2. Check syntax: No spaces in keys
3. Check encoding: UTF-8 without BOM
4. Check permissions: Readable by application

### Invalid Values

- Check ranges and types
- Use quotes for strings with spaces (JSON)
- Verify boolean format: true/false (JSON), true/false or 1/0 (INI)

---

[🏠 Back to Home](Home.md) | [⚙️ Configuration Guide](Configuration.md) | [🔧 Command-Line Options](Command-Line-Options.md)
