# Testing Guide

Comprehensive guide to testing Security Sentinel components.

## 📋 Table of Contents

- [Testing Philosophy](#testing-philosophy)
- [C++ Testing](#c-testing)
- [Go Testing](#go-testing)
- [Web Interface Testing](#web-interface-testing)
- [Integration Testing](#integration-testing)
- [Performance Testing](#performance-testing)
- [Security Testing](#security-testing)
- [Test Automation](#test-automation)

---

## Testing Philosophy

### Testing Pyramid

```
        /\
       /  \      E2E Tests (Few)
      /____\
     /      \    Integration Tests (Some)
    /________\
   /          \  Unit Tests (Many)
  /____________\
```

**Our Approach**:
- **Unit Tests**: 70% - Test individual functions and classes
- **Integration Tests**: 20% - Test component interactions
- **E2E Tests**: 10% - Test complete workflows

### Test Coverage Goals

- **Critical Code**: 90%+ coverage
- **Core Functionality**: 80%+ coverage
- **UI Components**: 70%+ coverage
- **Overall Target**: 75%+ coverage

---

## C++ Testing

### Test Framework

We use a simple custom test framework for C++ testing.

**test_enhancements.cpp**:
```cpp
#include <iostream>
#include <cassert>
#include <vector>
#include "JsonReporting.h"
#include "GoCore.h"

// Test result tracking
struct TestResult {
    std::string name;
    bool passed;
    std::string message;
};

std::vector<TestResult> results;

// Test macros
#define TEST_CASE(name) \
    void test_##name(); \
    struct TestRegistrar_##name { \
        TestRegistrar_##name() { runTest(#name, test_##name); } \
    } registrar_##name; \
    void test_##name()

#define ASSERT_TRUE(condition) \
    if (!(condition)) { \
        throw std::runtime_error("Assertion failed: " #condition); \
    }

#define ASSERT_EQUAL(expected, actual) \
    if ((expected) != (actual)) { \
        throw std::runtime_error("Expected: " + std::to_string(expected) + \
                                ", Actual: " + std::to_string(actual)); \
    }

// Test runner
void runTest(const std::string& name, void(*testFunc)()) {
    try {
        testFunc();
        results.push_back({name, true, "Passed"});
        std::cout << "✓ " << name << " passed\n";
    } catch (const std::exception& e) {
        results.push_back({name, false, e.what()});
        std::cerr << "✗ " << name << " failed: " << e.what() << "\n";
    }
}

// Example tests
TEST_CASE(JsonReporting_CreateCheckResult) {
    using namespace JsonReporting;
    
    auto result = CreateCheckResult("test_check", Status::PASS, Severity::INFO);
    ASSERT_TRUE(result.checkName == "test_check");
    ASSERT_TRUE(result.status == Status::PASS);
    ASSERT_TRUE(result.severity == Severity::INFO);
}

TEST_CASE(JsonReporting_StatusToString) {
    using namespace JsonReporting;
    
    ASSERT_TRUE(StatusToString(Status::PASS) == "PASS");
    ASSERT_TRUE(StatusToString(Status::FAIL) == "FAIL");
    ASSERT_TRUE(StatusToString(Status::SKIP) == "SKIP");
}

TEST_CASE(GoCore_FileIntegrityCheck) {
    GoCore::Initialize();
    
    std::string hash = GoCore::PerformFileIntegrityCheck("test_file.txt");
    ASSERT_TRUE(!hash.empty());
    ASSERT_TRUE(hash.length() == 64);  // SHA-256 hex length
    
    GoCore::Shutdown();
}

int main() {
    std::cout << "Running Security Sentinel Tests...\n\n";
    
    // Tests run automatically via static registration
    
    std::cout << "\n====================\n";
    std::cout << "Test Summary:\n";
    
    int passed = 0;
    int failed = 0;
    
    for (const auto& result : results) {
        if (result.passed) passed++;
        else failed++;
    }
    
    std::cout << "Passed: " << passed << "/" << results.size() << "\n";
    std::cout << "Failed: " << failed << "/" << results.size() << "\n";
    
    return failed > 0 ? 1 : 0;
}
```

### Running C++ Tests

```bash
# Build tests
cd build
cmake --build . --target test_enhancements

# Run tests
./test_enhancements

# Expected output:
# ✓ JsonReporting_CreateCheckResult passed
# ✓ JsonReporting_StatusToString passed
# ✓ GoCore_FileIntegrityCheck passed
# 
# Test Summary:
# Passed: 3/3
# Failed: 0/3
```

### Unit Test Examples

**Testing GeminiClient**:
```cpp
TEST_CASE(GeminiClient_InitializeWithValidKey) {
    GeminiClient client("test_api_key");
    ASSERT_TRUE(client.isInitialized());
}

TEST_CASE(GeminiClient_RejectEmptyKey) {
    try {
        GeminiClient client("");
        ASSERT_TRUE(false);  // Should not reach here
    } catch (const std::invalid_argument&) {
        ASSERT_TRUE(true);  // Expected exception
    }
}
```

**Testing SecurityMonitor**:
```cpp
TEST_CASE(SecurityMonitor_GetProcesses) {
    SecurityMonitor monitor;
    auto processes = monitor.getRunningProcesses();
    ASSERT_TRUE(processes.size() > 0);
}

TEST_CASE(SecurityMonitor_CpuUsage) {
    SecurityMonitor monitor;
    double cpu = monitor.getCpuUsage();
    ASSERT_TRUE(cpu >= 0.0 && cpu <= 100.0);
}
```

### Mock Objects

```cpp
class MockGeminiClient : public GeminiClient {
public:
    std::string lastMessage;
    std::string responseToReturn;
    
    std::string sendMessageSync(const std::string& message) override {
        lastMessage = message;
        return responseToReturn;
    }
};

TEST_CASE(SecurityApp_AiIntegration) {
    MockGeminiClient mockClient;
    mockClient.responseToReturn = "Mock AI response";
    
    SecurityApp app;
    app.setGeminiClient(&mockClient);
    
    std::string response = app.askAI("Test question");
    ASSERT_EQUAL("Test question", mockClient.lastMessage);
    ASSERT_EQUAL("Mock AI response", response);
}
```

---

## Go Testing

### Test Files

Go tests use the built-in testing framework.

**core_test.go**:
```go
package main

import (
    "os"
    "testing"
)

func TestFileIntegrityCheck(t *testing.T) {
    // Create test file
    testFile := "test_temp.txt"
    content := []byte("test content")
    err := os.WriteFile(testFile, content, 0644)
    if err != nil {
        t.Fatalf("Failed to create test file: %v", err)
    }
    defer os.Remove(testFile)
    
    // Test hash calculation
    hash := GoFileIntegrityCheck(testFile)
    
    // Verify
    if hash == "" {
        t.Error("Hash should not be empty")
    }
    
    if len(hash) != 64 {
        t.Errorf("Expected hash length 64, got %d", len(hash))
    }
    
    // Test same file produces same hash
    hash2 := GoFileIntegrityCheck(testFile)
    if hash != hash2 {
        t.Error("Same file should produce same hash")
    }
}

func TestFileIntegrityCheck_NonExistent(t *testing.T) {
    hash := GoFileIntegrityCheck("nonexistent_file.txt")
    if hash != "" {
        t.Error("Hash should be empty for non-existent file")
    }
}

func BenchmarkFileIntegrityCheck(b *testing.B) {
    // Create test file
    testFile := "bench_test.txt"
    content := make([]byte, 1024*1024)  // 1MB
    os.WriteFile(testFile, content, 0644)
    defer os.Remove(testFile)
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        GoFileIntegrityCheck(testFile)
    }
}
```

### Running Go Tests

```bash
cd core-go

# Run all tests
go test -v

# Run with coverage
go test -v -cover

# Run benchmarks
go test -bench=.

# Race detection
go test -race

# Expected output:
# === RUN   TestFileIntegrityCheck
# --- PASS: TestFileIntegrityCheck (0.00s)
# === RUN   TestFileIntegrityCheck_NonExistent
# --- PASS: TestFileIntegrityCheck_NonExistent (0.00s)
# PASS
# coverage: 85.7% of statements
```

---

## Web Interface Testing

### Test Setup

**Install Testing Libraries**:
```bash
npm install --save-dev \
  vitest \
  @testing-library/react \
  @testing-library/jest-dom \
  @testing-library/user-event
```

**vitest.config.ts**:
```typescript
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: './src/test/setup.ts',
  },
});
```

### Component Tests

**Dashboard.test.tsx**:
```typescript
import { describe, it, expect, vi } from 'vitest';
import { render, screen, waitFor } from '@testing-library/react';
import { Dashboard } from './Dashboard';

describe('Dashboard', () => {
  it('renders dashboard title', () => {
    render(<Dashboard />);
    expect(screen.getByText('Security Dashboard')).toBeInTheDocument();
  });
  
  it('displays system metrics', async () => {
    render(<Dashboard />);
    
    await waitFor(() => {
      expect(screen.getByText('CPU Usage')).toBeInTheDocument();
      expect(screen.getByText('Memory')).toBeInTheDocument();
      expect(screen.getByText('Connections')).toBeInTheDocument();
    });
  });
  
  it('updates metrics periodically', async () => {
    vi.useFakeTimers();
    
    const { rerender } = render(<Dashboard refreshInterval={1000} />);
    
    // Fast-forward time
    vi.advanceTimersByTime(1000);
    
    await waitFor(() => {
      // Verify metrics updated
      expect(screen.getByText(/\d+%/)).toBeInTheDocument();
    });
    
    vi.useRealTimers();
  });
});
```

**AIAssistant.test.tsx**:
```typescript
import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { AIAssistant } from './AIAssistant';
import { geminiService } from '../services/geminiService';

vi.mock('../services/geminiService');

describe('AIAssistant', () => {
  it('sends message on button click', async () => {
    const mockResponse = 'AI response';
    vi.mocked(geminiService.sendMessage).mockResolvedValue(mockResponse);
    
    render(<AIAssistant />);
    
    const input = screen.getByPlaceholderText(/Ask about security/i);
    const sendButton = screen.getByRole('button');
    
    await userEvent.type(input, 'Test question');
    fireEvent.click(sendButton);
    
    await waitFor(() => {
      expect(screen.getByText('Test question')).toBeInTheDocument();
      expect(screen.getByText(mockResponse)).toBeInTheDocument();
    });
  });
  
  it('handles API errors gracefully', async () => {
    vi.mocked(geminiService.sendMessage).mockRejectedValue(new Error('API error'));
    
    render(<AIAssistant />);
    
    const input = screen.getByPlaceholderText(/Ask about security/i);
    const sendButton = screen.getByRole('button');
    
    await userEvent.type(input, 'Test question');
    fireEvent.click(sendButton);
    
    await waitFor(() => {
      expect(screen.getByText(/encountered an error/i)).toBeInTheDocument();
    });
  });
});
```

### Running Web Tests

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Watch mode
npm test -- --watch

# UI mode
npm test -- --ui
```

---

## Integration Testing

### C++ Integration Tests

```cpp
TEST_CASE(Integration_FullWorkflow) {
    // Initialize application
    SecurityApp app;
    ASSERT_TRUE(app.initialize());
    
    // Start monitoring
    app.startMonitoring();
    std::this_thread::sleep_for(std::chrono::seconds(2));
    
    // Verify monitoring is active
    auto processes = app.getProcesses();
    ASSERT_TRUE(processes.size() > 0);
    
    auto connections = app.getConnections();
    ASSERT_TRUE(connections.size() >= 0);
    
    // Test AI integration
    std::string response = app.askAI("What is my system status?");
    ASSERT_TRUE(!response.empty());
    
    // Cleanup
    app.shutdown();
}
```

### End-to-End Testing

**Playwright E2E Tests**:
```typescript
import { test, expect } from '@playwright/test';

test('complete security monitoring workflow', async ({ page }) => {
  await page.goto('http://localhost:5173');
  
  // Navigate to dashboard
  await expect(page.getByText('Security Dashboard')).toBeVisible();
  
  // Verify metrics displayed
  await expect(page.getByText('CPU Usage')).toBeVisible();
  await expect(page.getByText('Memory')).toBeVisible();
  
  // Navigate to AI assistant
  await page.click('text=AI Assistant');
  await expect(page.getByText('AI Security Assistant')).toBeVisible();
  
  // Send message
  await page.fill('input[placeholder*="Ask about"]', 'What is my threat level?');
  await page.click('button:has-text("Send")');
  
  // Wait for response
  await expect(page.getByText(/threat level/i)).toBeVisible({ timeout: 10000 });
});
```

---

## Performance Testing

### Load Testing

```cpp
TEST_CASE(Performance_ManyConnections) {
    NetworkMonitor monitor;
    monitor.startMonitoring();
    
    // Simulate 1000 connections
    auto start = std::chrono::high_resolution_clock::now();
    
    for (int i = 0; i < 1000; i++) {
        monitor.addConnection({
            "192.168.1." + std::to_string(i % 255),
            8080 + i,
            "TCP"
        });
    }
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
    
    // Should handle 1000 connections in < 100ms
    ASSERT_TRUE(duration.count() < 100);
}
```

### Benchmark Tests

```go
func BenchmarkLargeFileIntegrity(b *testing.B) {
    // Create 10MB test file
    testFile := "large_test.txt"
    content := make([]byte, 10*1024*1024)
    os.WriteFile(testFile, content, 0644)
    defer os.Remove(testFile)
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        GoFileIntegrityCheck(testFile)
    }
}
```

---

## Security Testing

### Input Validation Tests

```cpp
TEST_CASE(Security_SqlInjectionPrevention) {
    GeminiClient client("test_key");
    
    // Test SQL injection attempt
    std::string malicious = "'; DROP TABLE users; --";
    std::string sanitized = client.sanitizeInput(malicious);
    
    ASSERT_TRUE(sanitized.find("DROP") == std::string::npos);
}

TEST_CASE(Security_PathTraversal) {
    std::string malicious = "../../../etc/passwd";
    ASSERT_TRUE(!isValidFilePath(malicious));
}
```

### Penetration Testing Checklist

- [ ] SQL Injection attempts blocked
- [ ] XSS prevention in web interface
- [ ] CSRF protection enabled
- [ ] Path traversal prevented
- [ ] API rate limiting works
- [ ] Authentication bypass attempts fail
- [ ] Input validation on all endpoints

---

## Test Automation

### CI/CD Integration

**.github/workflows/test.yml**:
```yaml
name: Tests

on: [push, pull_request]

jobs:
  cpp-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install dependencies
        run: sudo apt-get install -y build-essential cmake golang-go
      - name: Build
        run: |
          mkdir build && cd build
          cmake ..
          cmake --build .
      - name: Run tests
        run: cd build && ./test_enhancements
  
  go-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-go@v2
        with:
          go-version: 1.24
      - name: Run tests
        run: cd core-go && go test -v -cover
  
  web-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: 20
      - name: Install dependencies
        run: npm install
      - name: Run tests
        run: npm test -- --coverage
```

---

## Best Practices

### Writing Good Tests

**DO**:
- ✅ Test one thing per test
- ✅ Use descriptive test names
- ✅ Clean up resources (files, connections)
- ✅ Test edge cases and errors
- ✅ Keep tests independent

**DON'T**:
- ❌ Test implementation details
- ❌ Have tests depend on each other
- ❌ Leave hard-coded test data
- ❌ Skip cleanup in tests
- ❌ Test external services directly

### Test Naming

```cpp
// Good names
TEST_CASE(NetworkMonitor_DetectsPortScan_WhenMultiplePortsAccessed)
TEST_CASE(GeminiClient_ThrowsException_WhenApiKeyEmpty)

// Bad names
TEST_CASE(Test1)
TEST_CASE(CheckStuff)
```

---

[🏠 Back to Home](Home.md) | [🔨 Development Setup](Development-Setup.md) | [🤝 Contributing](Contributing-Guidelines.md)
