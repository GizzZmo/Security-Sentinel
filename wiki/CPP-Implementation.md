# C++ Implementation Guide

Detailed guide to the native C++ implementation of Security Sentinel.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Core Components](#core-components)
- [Windows API Integration](#windows-api-integration)
- [Linux System Integration](#linux-system-integration)
- [Go Core Integration](#go-core-integration)
- [Build System](#build-system)
- [Threading Model](#threading-model)
- [Performance Considerations](#performance-considerations)

---

## Architecture Overview

### Component Hierarchy

```
SecurityApp (Main Controller)
├── GeminiClient (AI Integration)
├── SecurityMonitor (System Monitoring)
│   ├── Process Tracking
│   ├── Resource Monitoring
│   └── Event Correlation
├── NetworkMonitor (Network Analysis)
│   ├── Connection Tracking
│   ├── Threat Detection
│   └── IP Blocking
├── ThreatProtection (Response System)
│   ├── Auto-blocking
│   ├── Quarantine
│   └── Alert Management
├── GoCore (Performance Bridge)
│   ├── File Integrity
│   ├── System Analysis
│   └── Configuration Validation
└── ViewManager (User Interface)
    ├── Console Rendering
    ├── Input Handling
    └── Screen Management
```

### Design Patterns

**Singleton Pattern** - Configuration:
```cpp
class Config {
public:
    static Config& Instance() {
        static Config instance;
        return instance;
    }
    
private:
    Config() = default;
    Config(const Config&) = delete;
    Config& operator=(const Config&) = delete;
};
```

**Observer Pattern** - Event System:
```cpp
class EventListener {
public:
    virtual void onSecurityEvent(const SecurityEvent& event) = 0;
};

class SecurityMonitor {
    std::vector<EventListener*> listeners_;
    
    void notifyListeners(const SecurityEvent& event) {
        for (auto* listener : listeners_) {
            listener->onSecurityEvent(event);
        }
    }
};
```

**Factory Pattern** - Component Creation:
```cpp
class MonitorFactory {
public:
    static std::unique_ptr<Monitor> createMonitor(MonitorType type) {
        switch (type) {
            case MonitorType::PROCESS:
                return std::make_unique<ProcessMonitor>();
            case MonitorType::NETWORK:
                return std::make_unique<NetworkMonitor>();
            default:
                throw std::runtime_error("Unknown monitor type");
        }
    }
};
```

---

## Core Components

### SecurityApp

**Main Application Controller**

```cpp
class SecurityApp {
public:
    SecurityApp();
    ~SecurityApp();
    
    // Lifecycle
    bool initialize();
    void run();
    void shutdown();
    
private:
    // Components
    std::unique_ptr<GeminiClient> geminiClient_;
    std::unique_ptr<SecurityMonitor> securityMonitor_;
    std::unique_ptr<NetworkMonitor> networkMonitor_;
    std::unique_ptr<ViewManager> viewManager_;
    std::unique_ptr<GoCore> goCore_;
    
    // State
    bool isRunning_;
    std::mutex stateMutex_;
    
    // Methods
    bool loadConfiguration();
    void initializeComponents();
    void startMonitoring();
    void processEvents();
};
```

**Key Responsibilities**:
- Component lifecycle management
- Configuration loading and validation
- Event coordination between components
- Graceful shutdown handling

### GeminiClient

**AI Integration Layer**

```cpp
class GeminiClient {
public:
    explicit GeminiClient(const std::string& apiKey);
    
    // Streaming API
    void sendMessage(const std::string& message, 
                    std::function<void(const std::string&)> callback);
    
    // Synchronous API
    std::string sendMessageSync(const std::string& message);
    
private:
    std::string apiKey_;
    HINTERNET session_;
    HINTERNET connection_;
    
    void initializeWinINet();
    bool sendHttpRequest(const std::string& json);
    std::string readStreamingResponse();
};
```

**Implementation Details**:
- Uses WinINet for HTTP communication
- Supports streaming responses for real-time AI interaction
- JSON request/response formatting
- Error handling and retry logic
- Rate limiting to stay within API quotas

### SecurityMonitor

**System Monitoring Component**

```cpp
class SecurityMonitor {
public:
    SecurityMonitor();
    
    void startMonitoring();
    void stopMonitoring();
    
    // Process Monitoring
    std::vector<ProcessInfo> getRunningProcesses();
    double getCpuUsage();
    double getMemoryUsage();
    
    // Event Detection
    std::vector<SecurityEvent> getRecentEvents();
    ThreatLevel assessThreatLevel();
    
private:
    std::atomic<bool> isMonitoring_;
    std::thread monitorThread_;
    std::mutex dataMutex_;
    
    std::vector<ProcessInfo> processes_;
    std::deque<SecurityEvent> events_;
    
    void monitorLoop();
    void scanProcesses();
    void analyzeProcessBehavior(const ProcessInfo& process);
    void detectAnomalies();
};
```

**Monitoring Features**:
- **Process Enumeration**: `EnumProcesses`, `CreateToolhelp32Snapshot`
- **CPU Usage**: `GetSystemTimes`, performance counters
- **Memory Usage**: `GlobalMemoryStatusEx`
- **Process Details**: `GetModuleBaseName`, `GetProcessImageFileName`

### NetworkMonitor

**Network Traffic Analysis**

```cpp
class NetworkMonitor {
public:
    NetworkMonitor();
    
    void startMonitoring();
    void stopMonitoring();
    
    // Connection Tracking
    std::vector<ConnectionInfo> getActiveConnections();
    std::vector<std::string> getBlockedIps();
    
    // Threat Detection
    bool detectPortScan(const std::string& ip);
    bool detectDDoS(const std::string& ip);
    
    // Response
    void blockIp(const std::string& ip);
    void unblockIp(const std::string& ip);
    
private:
    std::atomic<bool> isMonitoring_;
    std::thread scanThread_;
    std::mutex connectionMutex_;
    
    std::vector<ConnectionInfo> connections_;
    std::set<std::string> blockedIps_;
    std::map<std::string, ConnectionStats> connectionStats_;
    
    void scanLoop();
    void scanTcpConnections();
    void scanUdpConnections();
    void analyzeConnectionPattern(const std::string& ip);
};
```

**Detection Algorithms**:

**Port Scan Detection**:
```cpp
bool NetworkMonitor::detectPortScan(const std::string& ip) {
    auto& stats = connectionStats_[ip];
    
    // Count unique ports within time window
    const auto now = std::chrono::steady_clock::now();
    const auto window = std::chrono::seconds(60);
    
    int uniquePorts = 0;
    for (const auto& conn : connections_) {
        if (conn.remoteIp == ip && 
            (now - conn.timestamp) < window) {
            uniquePorts++;
        }
    }
    
    // Threshold: 5+ different ports in 60 seconds
    return uniquePorts >= SCAN_DETECTION_THRESHOLD;
}
```

**DDoS Detection**:
```cpp
bool NetworkMonitor::detectDDoS(const std::string& ip) {
    auto& stats = connectionStats_[ip];
    
    // Count connection rate
    const auto now = std::chrono::steady_clock::now();
    const auto window = std::chrono::seconds(10);
    
    int connectionCount = 0;
    for (const auto& conn : connections_) {
        if (conn.remoteIp == ip && 
            (now - conn.timestamp) < window) {
            connectionCount++;
        }
    }
    
    // Threshold: 100+ connections in 10 seconds
    return connectionCount >= DDOS_DETECTION_THRESHOLD;
}
```

---

## Windows API Integration

### Required Headers

```cpp
// Windows base
#include <windows.h>
#include <wininet.h>

// Process and system info
#include <psapi.h>
#include <tlhelp32.h>

// Network
#include <iphlpapi.h>
#include <ws2tcpip.h>

// Security
#include <wincrypt.h>
#include <softpub.h>

// Link libraries
#pragma comment(lib, "wininet.lib")
#pragma comment(lib, "psapi.lib")
#pragma comment(lib, "iphlpapi.lib")
#pragma comment(lib, "ws2_32.lib")
#pragma comment(lib, "wintrust.lib")
```

### Process Enumeration

```cpp
std::vector<ProcessInfo> SecurityMonitor::getRunningProcesses() {
    std::vector<ProcessInfo> processes;
    
    // Method 1: EnumProcesses (requires psapi.lib)
    DWORD processIds[1024];
    DWORD bytesReturned;
    
    if (EnumProcesses(processIds, sizeof(processIds), &bytesReturned)) {
        DWORD processCount = bytesReturned / sizeof(DWORD);
        
        for (DWORD i = 0; i < processCount; i++) {
            HANDLE hProcess = OpenProcess(
                PROCESS_QUERY_INFORMATION | PROCESS_VM_READ,
                FALSE, processIds[i]);
            
            if (hProcess) {
                ProcessInfo info;
                info.pid = processIds[i];
                
                // Get process name
                TCHAR processName[MAX_PATH];
                if (GetModuleBaseName(hProcess, NULL, processName, MAX_PATH)) {
                    info.name = processName;
                }
                
                // Get memory usage
                PROCESS_MEMORY_COUNTERS pmc;
                if (GetProcessMemoryInfo(hProcess, &pmc, sizeof(pmc))) {
                    info.memoryUsage = pmc.WorkingSetSize;
                }
                
                processes.push_back(info);
                CloseHandle(hProcess);
            }
        }
    }
    
    return processes;
}
```

### Network Connection Tracking

```cpp
std::vector<ConnectionInfo> NetworkMonitor::getActiveConnections() {
    std::vector<ConnectionInfo> connections;
    
    // Get TCP table
    DWORD size = 0;
    GetTcpTable(NULL, &size, FALSE);
    
    std::vector<BYTE> buffer(size);
    MIB_TCPTABLE* tcpTable = reinterpret_cast<MIB_TCPTABLE*>(buffer.data());
    
    if (GetTcpTable(tcpTable, &size, FALSE) == NO_ERROR) {
        for (DWORD i = 0; i < tcpTable->dwNumEntries; i++) {
            ConnectionInfo info;
            
            // Remote IP
            struct in_addr addr;
            addr.S_un.S_addr = tcpTable->table[i].dwRemoteAddr;
            char* ipStr = inet_ntoa(addr);
            info.remoteIp = ipStr ? ipStr : "0.0.0.0";
            
            // Remote port
            info.remotePort = ntohs((u_short)tcpTable->table[i].dwRemotePort);
            
            // Local port
            info.localPort = ntohs((u_short)tcpTable->table[i].dwLocalPort);
            
            // State
            info.state = getConnectionState(tcpTable->table[i].dwState);
            info.protocol = "TCP";
            
            connections.push_back(info);
        }
    }
    
    // Similar for UDP connections with GetUdpTable
    
    return connections;
}
```

### Administrator Privilege Check

```cpp
bool SecurityApp::checkAdministratorPrivileges() {
    BOOL isAdmin = FALSE;
    SID_IDENTIFIER_AUTHORITY ntAuthority = SECURITY_NT_AUTHORITY;
    PSID administratorsGroup;
    
    if (AllocateAndInitializeSid(&ntAuthority, 2,
                                  SECURITY_BUILTIN_DOMAIN_RID,
                                  DOMAIN_ALIAS_RID_ADMINS,
                                  0, 0, 0, 0, 0, 0,
                                  &administratorsGroup)) {
        CheckTokenMembership(NULL, administratorsGroup, &isAdmin);
        FreeSid(administratorsGroup);
    }
    
    return isAdmin == TRUE;
}
```

---

## Linux System Integration

### Process Monitoring (/proc)

```cpp
std::vector<ProcessInfo> SecurityMonitor::getRunningProcesses() {
    std::vector<ProcessInfo> processes;
    DIR* procDir = opendir("/proc");
    
    if (!procDir) return processes;
    
    struct dirent* entry;
    while ((entry = readdir(procDir)) != nullptr) {
        // Check if directory name is numeric (PID)
        if (entry->d_type == DT_DIR) {
            int pid = atoi(entry->d_name);
            if (pid > 0) {
                ProcessInfo info;
                info.pid = pid;
                
                // Read /proc/[pid]/stat for process info
                std::string statPath = "/proc/" + std::to_string(pid) + "/stat";
                std::ifstream statFile(statPath);
                
                if (statFile) {
                    std::string line;
                    std::getline(statFile, line);
                    // Parse stat file for CPU, memory, etc.
                    parseProcessStat(line, info);
                }
                
                // Read /proc/[pid]/cmdline for command
                std::string cmdPath = "/proc/" + std::to_string(pid) + "/cmdline";
                std::ifstream cmdFile(cmdPath);
                if (cmdFile) {
                    std::getline(cmdFile, info.commandLine, '\0');
                }
                
                processes.push_back(info);
            }
        }
    }
    
    closedir(procDir);
    return processes;
}
```

### Network Monitoring (/proc/net)

```cpp
std::vector<ConnectionInfo> NetworkMonitor::getTcpConnections() {
    std::vector<ConnectionInfo> connections;
    std::ifstream tcpFile("/proc/net/tcp");
    
    if (!tcpFile) return connections;
    
    std::string line;
    std::getline(tcpFile, line);  // Skip header
    
    while (std::getline(tcpFile, line)) {
        ConnectionInfo info;
        
        // Parse line: sl local_address rem_address st ...
        std::istringstream iss(line);
        std::string sl, localAddr, remAddr, st;
        
        iss >> sl >> localAddr >> remAddr >> st;
        
        // Parse addresses (hex format)
        parseHexAddress(localAddr, info.localIp, info.localPort);
        parseHexAddress(remAddr, info.remoteIp, info.remotePort);
        
        // Convert state
        info.state = convertTcpState(std::stoi(st, nullptr, 16));
        info.protocol = "TCP";
        
        connections.push_back(info);
    }
    
    return connections;
}
```

---

## Go Core Integration

### C++ to Go Bridge

```cpp
// GoCore.h
#ifndef GOCORE_H
#define GOCORE_H

#include <string>

namespace GoCore {
    // Initialize Go runtime
    int Initialize();
    
    // File integrity check using Go
    std::string PerformFileIntegrityCheck(const std::string& filePath);
    
    // System analysis
    std::string AnalyzeSystemConfiguration();
    
    // Cleanup
    void Shutdown();
}

#endif
```

```cpp
// GoCore.cpp
#include "GoCore.h"
#include "core.h"  // Go-generated header

namespace GoCore {

int Initialize() {
    // Initialize Go runtime if needed
    return 0;
}

std::string PerformFileIntegrityCheck(const std::string& filePath) {
    // Call Go function
    GoString goPath = {filePath.c_str(), static_cast<ptrdiff_t>(filePath.length())};
    GoString result = GoFileIntegrityCheck(goPath);
    
    // Convert Go string to C++ string
    return std::string(result.p, result.n);
}

void Shutdown() {
    // Cleanup Go runtime if needed
}

}
```

### Go Implementation

```go
// core.go
package main

import "C"
import (
    "crypto/sha256"
    "encoding/hex"
    "io"
    "os"
)

//export GoFileIntegrityCheck
func GoFileIntegrityCheck(path string) string {
    file, err := os.Open(path)
    if err != nil {
        return ""
    }
    defer file.Close()
    
    hash := sha256.New()
    if _, err := io.Copy(hash, file); err != nil {
        return ""
    }
    
    return hex.EncodeToString(hash.Sum(nil))
}

func main() {}
```

---

## Build System

### CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.16)
project(SecuritySentinel VERSION 1.1.0)

# C++ Standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Platform detection
if(WIN32)
    add_definitions(-DWINDOWS)
elseif(UNIX)
    add_definitions(-DLINUX)
endif()

# Source files
set(SOURCES
    src/main.cpp
    src/SecurityApp.cpp
    src/GeminiClient.cpp
    src/SecurityMonitor.cpp
    src/NetworkMonitor.cpp
    src/ViewManager.cpp
    src/GoCore.cpp
    src/Utils.cpp
)

# Include directories
include_directories(include)
include_directories(core-go)

# Link Go static library
add_library(gocore STATIC IMPORTED)
set_target_properties(gocore PROPERTIES
    IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/core-go/core.a
)

# Executable
add_executable(SecuritySentinel ${SOURCES})

# Link libraries
if(WIN32)
    target_link_libraries(SecuritySentinel 
        wininet
        psapi
        iphlpapi
        ws2_32
        wintrust
        gocore
    )
elseif(UNIX)
    target_link_libraries(SecuritySentinel
        pthread
        gocore
    )
endif()

# Install
install(TARGETS SecuritySentinel DESTINATION bin)
```

---

## Threading Model

### Monitoring Threads

```cpp
class SecurityMonitor {
    std::thread monitorThread_;
    std::atomic<bool> isRunning_;
    
    void startMonitoring() {
        isRunning_ = true;
        monitorThread_ = std::thread(&SecurityMonitor::monitorLoop, this);
    }
    
    void monitorLoop() {
        while (isRunning_) {
            {
                std::lock_guard<std::mutex> lock(dataMutex_);
                scanProcesses();
                analyzeEvents();
            }
            
            std::this_thread::sleep_for(std::chrono::seconds(5));
        }
    }
    
    void stopMonitoring() {
        isRunning_ = false;
        if (monitorThread_.joinable()) {
            monitorThread_.join();
        }
    }
};
```

---

## Performance Considerations

### Memory Management
- Use smart pointers to prevent leaks
- Limit event history size
- Clear old connection data
- Pool allocations for frequent objects

### CPU Optimization
- Configurable monitoring intervals
- Lazy evaluation where possible
- Cache frequently accessed data
- Use Go for CPU-intensive operations

### I/O Optimization
- Asynchronous network requests
- Buffered file reading
- Batch database operations
- Minimize system calls

---

[🏠 Back to Home](Home.md) | [🏗️ Architecture](Architecture-Overview.md) | [📚 API Reference](API-Reference.md)
