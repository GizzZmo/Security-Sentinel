# Command-Line Options

Complete reference for Security Sentinel command-line interface.

## 📋 Overview

The C++ native application supports various command-line options for configuration and operation.

## Basic Usage

```bash
# Windows
SecuritySentinel.exe [options]

# Linux
sudo ./SecuritySentinel [options]
```

---

## General Options

### `--help`, `-h`
Display help information and exit.

```bash
SecuritySentinel --help
```

### `--version`, `-v`
Show version information and exit.

```bash
SecuritySentinel --version
# Output: Security Sentinel v1.1.0
```

### `--config <file>`
Specify custom configuration file path.

```bash
SecuritySentinel --config /path/to/custom/config.ini
```

Default: `config.ini` in application directory

---

## Monitoring Options

### `--no-monitor`
Disable automatic monitoring on startup.

```bash
SecuritySentinel --no-monitor
```

### `--interval <seconds>`
Set monitoring update interval (1-60 seconds).

```bash
SecuritySentinel --interval 10
```

Default: 5 seconds

---

## Logging Options

### `--log-level <level>`
Set logging verbosity.

Levels: `DEBUG`, `INFO`, `WARN`, `ERROR`

```bash
SecuritySentinel --log-level DEBUG
```

Default: `INFO`

### `--log-file <file>`
Specify log file path.

```bash
SecuritySentinel --log-file /var/log/security-sentinel.log
```

### `--no-log`
Disable file logging.

```bash
SecuritySentinel --no-log
```

---

## Network Options

### `--whitelist <ips>`
Comma-separated list of whitelisted IP addresses or ranges.

```bash
SecuritySentinel --whitelist "192.168.1.0/24,10.0.0.0/8"
```

### `--no-block`
Disable automatic IP blocking.

```bash
SecuritySentinel --no-block
```

---

## AI Options

### `--no-ai`
Disable AI assistant features.

```bash
SecuritySentinel --no-ai
```

### `--ai-model <model>`
Specify Gemini AI model.

Models: `gemini-2.5-flash`, `gemini-pro`

```bash
SecuritySentinel --ai-model gemini-pro
```

---

## Self-Protection Options

### `--verify-integrity`
Perform integrity check on startup and exit.

```bash
SecuritySentinel --verify-integrity
```

### `--no-self-protect`
Disable self-protection features (not recommended).

```bash
SecuritySentinel --no-self-protect
```

---

## Utility Commands

### `--export-config`
Export current configuration to stdout.

```bash
SecuritySentinel --export-config > backup-config.json
```

### `--test-ai`
Test AI connection and exit.

```bash
SecuritySentinel --test-ai
```

### `--check-privileges`
Check if running with required privileges and exit.

```bash
SecuritySentinel --check-privileges
# Output: Running with administrator privileges: Yes
```

---

## Examples

### Basic Monitoring

```bash
# Start with default settings
SecuritySentinel
```

### Custom Configuration

```bash
# Use custom config and log level
SecuritySentinel --config /etc/security-sentinel/config.ini --log-level DEBUG
```

### High-Frequency Monitoring

```bash
# Monitor every second with detailed logging
SecuritySentinel --interval 1 --log-level DEBUG
```

### Production Server

```bash
# Production settings: low interval, warn logging, specific log file
SecuritySentinel --interval 2 --log-level WARN --log-file /var/log/sentinel.log
```

### Testing Setup

```bash
# Test configuration without monitoring
SecuritySentinel --no-monitor --test-ai
```

---

## Exit Codes

- `0` - Success
- `1` - General error
- `2` - Configuration error
- `3` - Insufficient privileges
- `4` - AI initialization failed
- `5` - Network error

---

[🏠 Back to Home](Home.md) | [⚙️ Configuration](Configuration.md) | [📖 Full Documentation](Home.md)
