# Code Style Guide

Coding standards and conventions for Security Sentinel development.

## 📋 Table of Contents

- [General Principles](#general-principles)
- [C++ Style Guide](#c-style-guide)
- [Go Style Guide](#go-style-guide)
- [TypeScript/React Style Guide](#typescriptreact-style-guide)
- [Documentation Style](#documentation-style)
- [Git Commit Messages](#git-commit-messages)
- [Code Review Guidelines](#code-review-guidelines)

---

## General Principles

### Core Values

1. **Readability**: Code is read more often than written
2. **Consistency**: Follow existing patterns in the codebase
3. **Simplicity**: Prefer simple, clear solutions over clever ones
4. **Safety**: Write defensive code that handles edge cases
5. **Performance**: Be mindful of performance, but prefer clarity first

### Golden Rules

- ✅ Use self-explanatory names (see [SELF_EXPLAINING_NAMES](../docs/SELF_EXPLAINING_NAMES.md))
- ✅ Keep functions small and focused (single responsibility)
- ✅ Comment why, not what (code should be self-documenting)
- ✅ Write tests for new functionality
- ✅ Handle errors gracefully

---

## C++ Style Guide

### Standard

**C++17** is the minimum standard. Use modern C++ features:
- Smart pointers (`std::unique_ptr`, `std::shared_ptr`)
- RAII (Resource Acquisition Is Initialization)
- Auto type deduction where appropriate
- Range-based for loops
- Lambdas for callbacks

### Naming Conventions

**Classes and Structs**: `PascalCase`
```cpp
class SecurityMonitor { };
struct ConnectionInfo { };
```

**Functions and Methods**: `snake_case`
```cpp
void monitor_network();
bool check_privileges();
```

**Member Variables**: `camelCase_` (trailing underscore for private)
```cpp
class Example {
private:
    std::string apiKey_;
    int connectionCount_;
public:
    std::string name;  // Public: no underscore
};
```

**Constants**: `UPPER_SNAKE_CASE`
```cpp
const int MAX_CONNECTIONS = 1000;
constexpr double DEFAULT_TIMEOUT = 30.0;
```

**Namespaces**: `lowercase` or `PascalCase`
```cpp
namespace utils { }
namespace JsonReporting { }
```

### File Organization

**Header Files** (.h):
```cpp
#ifndef SECURITY_MONITOR_H
#define SECURITY_MONITOR_H

#include <string>
#include <vector>

namespace security {

class SecurityMonitor {
public:
    SecurityMonitor();
    ~SecurityMonitor();
    
    void start_monitoring();
    void stop_monitoring();
    
private:
    bool isRunning_;
    std::vector<Process> processes_;
    
    void scan_processes();
};

}  // namespace security

#endif  // SECURITY_MONITOR_H
```

**Source Files** (.cpp):
```cpp
#include "SecurityMonitor.h"
#include <algorithm>
#include <iostream>

namespace security {

SecurityMonitor::SecurityMonitor() 
    : isRunning_(false) {
    // Initialize
}

void SecurityMonitor::start_monitoring() {
    isRunning_ = true;
    scan_processes();
}

void SecurityMonitor::scan_processes() {
    // Implementation
}

}  // namespace security
```

### Memory Management

**Prefer Smart Pointers**:
```cpp
// ✅ Good
std::unique_ptr<SecurityMonitor> monitor = 
    std::make_unique<SecurityMonitor>();

// ❌ Avoid
SecurityMonitor* monitor = new SecurityMonitor();
// ... easy to forget delete
```

**RAII Pattern**:
```cpp
class FileHandle {
public:
    FileHandle(const std::string& path) 
        : handle_(OpenFile(path)) {
        if (!handle_) throw std::runtime_error("Failed to open file");
    }
    
    ~FileHandle() {
        if (handle_) CloseFile(handle_);
    }
    
private:
    HANDLE handle_;
};
```

### Error Handling

**Exceptions for Initialization**:
```cpp
class GeminiClient {
public:
    GeminiClient(const std::string& apiKey) {
        if (apiKey.empty()) {
            throw std::invalid_argument("API key cannot be empty");
        }
        // Initialize
    }
};
```

**Return Codes for Runtime**:
```cpp
bool SecurityMonitor::check_process(int pid) {
    try {
        // Check process
        return true;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return false;
    }
}
```

### Comments

**File Headers**:
```cpp
/**
 * @file SecurityMonitor.h
 * @brief Real-time system security monitoring
 * @author Security Sentinel Team
 */
```

**Class Documentation**:
```cpp
/**
 * @class SecurityMonitor
 * @brief Monitors system processes and resources for security threats
 * 
 * Provides real-time monitoring of running processes, network connections,
 * and system resources. Detects suspicious activities and alerts users.
 */
class SecurityMonitor { };
```

**Function Documentation**:
```cpp
/**
 * @brief Scans all running processes for suspicious activity
 * @param includeSystem Whether to include system processes
 * @return Number of threats detected
 * @throws std::runtime_error if scanning fails
 */
int scan_processes(bool includeSystem = false);
```

**Inline Comments** (explain why, not what):
```cpp
// ✅ Good - explains reasoning
// Wait for network to stabilize before scanning
std::this_thread::sleep_for(std::chrono::seconds(2));

// ❌ Bad - states the obvious
// Sleep for 2 seconds
std::this_thread::sleep_for(std::chrono::seconds(2));
```

### Formatting

**Indentation**: 4 spaces (no tabs)

**Line Length**: 100 characters maximum

**Braces**: Opening brace on same line
```cpp
if (condition) {
    do_something();
} else {
    do_something_else();
}
```

**Spacing**:
```cpp
// Around operators
int result = a + b;

// After keywords
if (condition) { }
for (int i = 0; i < n; ++i) { }

// No space inside parentheses
function(arg1, arg2);
```

---

## Go Style Guide

### Standard

Follow official [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments) and `gofmt` formatting.

### Naming Conventions

**Exported Functions**: `PascalCase`
```go
func PerformFileIntegrityCheck(path string) string { }
```

**Internal Functions**: `camelCase`
```go
func calculateHash(data []byte) string { }
```

**Constants**: `PascalCase` or `camelCase`
```go
const DefaultTimeout = 30
const maxRetries = 3
```

### Package Structure

```go
// Package documentation
// Package core provides performance-critical security operations.
package core

import (
    "crypto/sha256"
    "fmt"
)

// Exported function with documentation
// PerformFileIntegrityCheck computes SHA-256 hash of file.
// Returns hex-encoded hash string or empty string on error.
func PerformFileIntegrityCheck(path string) string {
    // Implementation
}
```

### Error Handling

**Always Handle Errors**:
```go
// ✅ Good
hash, err := calculateFileHash(path)
if err != nil {
    return "", fmt.Errorf("hash calculation failed: %w", err)
}
return hash, nil

// ❌ Bad
hash, _ := calculateFileHash(path)  // Ignoring error!
return hash, nil
```

### Code Organization

```go
package core

import (
    // Standard library
    "crypto/sha256"
    "fmt"
    "os"
    
    // Third-party
    // (none currently)
    
    // Internal
    // "github.com/GizzZmo/Security-Sentinel/internal/utils"
)

// Constants
const (
    MaxFileSize = 100 * 1024 * 1024  // 100 MB
    BufferSize  = 4096
)

// Types

// FileInfo represents file metadata.
type FileInfo struct {
    Path string
    Hash string
    Size int64
}

// Functions

// NewFileInfo creates a FileInfo instance.
func NewFileInfo(path string) (*FileInfo, error) {
    // Implementation
}
```

---

## TypeScript/React Style Guide

### Standard

Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript) with TypeScript extensions.

### Naming Conventions

**Components**: `PascalCase`
```typescript
export const Dashboard: React.FC = () => { };
export const NetworkMonitor: React.FC<NetworkMonitorProps> = () => { };
```

**Functions/Variables**: `camelCase`
```typescript
const fetchSecurityData = async () => { };
const isAuthenticated = true;
```

**Interfaces/Types**: `PascalCase`
```typescript
interface SecurityEvent {
    timestamp: Date;
    severity: 'low' | 'medium' | 'high';
    message: string;
}

type NetworkConnection = {
    ip: string;
    port: number;
    protocol: 'TCP' | 'UDP';
};
```

**Constants**: `UPPER_SNAKE_CASE`
```typescript
const API_ENDPOINT = 'https://api.example.com';
const MAX_RETRIES = 3;
```

### Component Structure

**Functional Components** (preferred):
```typescript
import React, { useState, useEffect } from 'react';

interface DashboardProps {
    apiKey: string;
    refreshInterval?: number;
}

export const Dashboard: React.FC<DashboardProps> = ({ 
    apiKey, 
    refreshInterval = 5000 
}) => {
    const [data, setData] = useState<SecurityData | null>(null);
    
    useEffect(() => {
        // Effect logic
    }, [apiKey]);
    
    return (
        <div className="dashboard">
            {/* JSX */}
        </div>
    );
};
```

### TypeScript Types

**Always Use Explicit Types**:
```typescript
// ✅ Good
function processData(input: string): number {
    return parseInt(input, 10);
}

// ❌ Avoid
function processData(input) {  // Implicit any
    return parseInt(input, 10);
}
```

**Interfaces for Objects**:
```typescript
interface SecurityConfig {
    apiKey: string;
    monitoring: {
        enabled: boolean;
        interval: number;
    };
    network: {
        whitelistIps: string[];
    };
}
```

### React Hooks

**Naming**: Use `use` prefix
```typescript
function useSecurityMonitor(apiKey: string) {
    const [threats, setThreats] = useState<Threat[]>([]);
    
    useEffect(() => {
        // Monitoring logic
    }, [apiKey]);
    
    return { threats };
}
```

### File Organization

```typescript
// Imports
import React, { useState, useEffect } from 'react';
import { fetchData } from '@/services/api';
import type { SecurityData } from '@/types';

// Types/Interfaces
interface ComponentProps {
    // ...
}

// Constants
const DEFAULT_INTERVAL = 5000;

// Helper functions
const formatTimestamp = (date: Date): string => {
    // ...
};

// Component
export const Component: React.FC<ComponentProps> = (props) => {
    // State
    const [state, setState] = useState();
    
    // Effects
    useEffect(() => { }, []);
    
    // Handlers
    const handleClick = () => { };
    
    // Render
    return <div></div>;
};
```

---

## Documentation Style

### README Files

**Structure**:
1. Title and badges
2. Brief description
3. Features list
4. Quick start
5. Documentation links
6. License

### Code Comments

**When to Comment**:
- ✅ Complex algorithms
- ✅ Non-obvious behavior
- ✅ Performance optimizations
- ✅ Workarounds for bugs
- ❌ Obvious code (let code speak)

### API Documentation

**Use JSDoc/Doxygen Style**:
```typescript
/**
 * Fetches security events from the monitoring service.
 * 
 * @param apiKey - The Gemini API authentication key
 * @param options - Optional configuration for the request
 * @returns Promise resolving to array of security events
 * @throws {Error} If API key is invalid or request fails
 * 
 * @example
 * ```typescript
 * const events = await fetchSecurityEvents('key123', { limit: 10 });
 * ```
 */
async function fetchSecurityEvents(
    apiKey: string,
    options?: FetchOptions
): Promise<SecurityEvent[]> {
    // ...
}
```

---

## Git Commit Messages

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements

### Examples

```
feat(network): add DDoS detection algorithm

Implement adaptive threshold detection for DDoS attacks based on
connection rate and pattern analysis.

Closes #123
```

```
fix(ai): handle timeout errors in Gemini API calls

Add retry logic with exponential backoff when API requests timeout.
Improves reliability for users with slow connections.

Fixes #456
```

```
docs(wiki): add comprehensive FAQ page

Create FAQ covering installation, configuration, troubleshooting,
and common user questions.
```

---

## Code Review Guidelines

### As Author

**Before Submitting**:
- [ ] Code follows style guide
- [ ] All tests pass
- [ ] Added tests for new functionality
- [ ] Documentation updated
- [ ] No debug code or console.logs
- [ ] Self-review completed

**PR Description**:
- Clear title and description
- Link to related issues
- Screenshots for UI changes
- Testing instructions

### As Reviewer

**Focus On**:
- Correctness and logic
- Security implications
- Performance concerns
- Code clarity
- Test coverage
- Documentation

**Be Constructive**:
- ✅ "Consider using X because..."
- ✅ "This might cause Y when..."
- ❌ "This is wrong"
- ❌ "Why did you do it this way?"

---

## Tools

### Linters

**C++**:
```bash
# clang-format
clang-format -i src/*.cpp include/*.h
```

**Go**:
```bash
# gofmt
gofmt -w .

# golangci-lint
golangci-lint run
```

**TypeScript**:
```bash
# ESLint
npm run lint

# Prettier
npm run format
```

### Pre-commit Hooks

```bash
# Install pre-commit hooks
# .git/hooks/pre-commit

#!/bin/bash
# Run linters before commit
npm run lint
gofmt -l .
```

---

## Additional Resources

- [Contributing Guidelines](Contributing-Guidelines.md)
- [Development Setup](Development-Setup.md)
- [Testing Guide](Testing.md)
- [SELF_EXPLAINING_NAMES](../docs/SELF_EXPLAINING_NAMES.md)

---

**Remember**: Consistency is more important than individual preferences. When in doubt, follow existing patterns in the codebase.

[🏠 Back to Home](Home.md) | [🤝 Contributing](Contributing-Guidelines.md)
