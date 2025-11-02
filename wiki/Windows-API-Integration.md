# Windows API Integration

Deep dive into how Security Sentinel integrates with Windows APIs for system monitoring.

## 📋 Overview

Security Sentinel leverages native Windows APIs for deep system integration and real-time monitoring capabilities.

## Required Libraries

```cpp
// Link these libraries
#pragma comment(lib, "wininet.lib")   // Internet/HTTP
#pragma comment(lib, "psapi.lib")     // Process APIs
#pragma comment(lib, "iphlpapi.lib")  // Network APIs
#pragma comment(lib, "ws2_32.lib")    // Winsock
#pragma comment(lib, "wintrust.lib")  // Code signing
```

## Process Management APIs

### EnumProcesses

```cpp
#include <psapi.h>

std::vector<DWORD> getProcessIds() {
    DWORD processIds[1024];
    DWORD bytesReturned;
    
    if (EnumProcesses(processIds, sizeof(processIds), &bytesReturned)) {
        DWORD count = bytesReturned / sizeof(DWORD);
        return std::vector<DWORD>(processIds, processIds + count);
    }
    
    return {};
}
```

### GetModuleBaseName

```cpp
std::string getProcessName(DWORD pid) {
    HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, pid);
    
    if (hProcess) {
        TCHAR processName[MAX_PATH];
        if (GetModuleBaseName(hProcess, NULL, processName, MAX_PATH)) {
            CloseHandle(hProcess);
            return processName;
        }
        CloseHandle(hProcess);
    }
    
    return "";
}
```

## Network APIs

### GetTcpTable

```cpp
#include <iphlpapi.h>

std::vector<ConnectionInfo> getTcpConnections() {
    std::vector<ConnectionInfo> connections;
    DWORD size = 0;
    
    // Get required buffer size
    GetTcpTable(NULL, &size, FALSE);
    
    std::vector<BYTE> buffer(size);
    MIB_TCPTABLE* tcpTable = reinterpret_cast<MIB_TCPTABLE*>(buffer.data());
    
    if (GetTcpTable(tcpTable, &size, FALSE) == NO_ERROR) {
        for (DWORD i = 0; i < tcpTable->dwNumEntries; i++) {
            ConnectionInfo info;
            
            // Extract connection details
            struct in_addr addr;
            addr.S_un.S_addr = tcpTable->table[i].dwRemoteAddr;
            info.remoteIp = inet_ntoa(addr);
            info.remotePort = ntohs((u_short)tcpTable->table[i].dwRemotePort);
            
            connections.push_back(info);
        }
    }
    
    return connections;
}
```

## WinINet for HTTP

### HTTPS Requests

```cpp
#include <wininet.h>

class HttpClient {
    HINTERNET session_;
    HINTERNET connection_;
    
public:
    bool initialize() {
        session_ = InternetOpen("SecuritySentinel/1.0",
                                INTERNET_OPEN_TYPE_DIRECT,
                                NULL, NULL, 0);
        return session_ != NULL;
    }
    
    std::string sendRequest(const std::string& url, const std::string& data) {
        // Parse URL
        URL_COMPONENTS urlComp = {};
        urlComp.dwStructSize = sizeof(urlComp);
        
        // Connect
        connection_ = InternetConnect(session_, "generativelanguage.googleapis.com",
                                     INTERNET_DEFAULT_HTTPS_PORT,
                                     NULL, NULL, INTERNET_SERVICE_HTTP, 0, 0);
        
        // Send request
        HINTERNET request = HttpOpenRequest(connection_, "POST", "/v1/models/...",
                                           NULL, NULL, NULL,
                                           INTERNET_FLAG_SECURE, 0);
        
        HttpSendRequest(request, headers, headersLen, 
                       (LPVOID)data.c_str(), data.length());
        
        // Read response
        char buffer[4096];
        DWORD bytesRead;
        std::string response;
        
        while (InternetReadFile(request, buffer, sizeof(buffer), &bytesRead) && bytesRead > 0) {
            response.append(buffer, bytesRead);
        }
        
        InternetCloseHandle(request);
        return response;
    }
};
```

## Administrator Privilege Detection

```cpp
#include <windows.h>

bool isRunningAsAdmin() {
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

## Digital Signature Verification

```cpp
#include <wintrust.h>
#include <softpub.h>

bool verifySignature(const std::wstring& filePath) {
    WINTRUST_FILE_INFO fileInfo = {};
    fileInfo.cbStruct = sizeof(WINTRUST_FILE_INFO);
    fileInfo.pcwszFilePath = filePath.c_str();
    
    WINTRUST_DATA trustData = {};
    trustData.cbStruct = sizeof(WINTRUST_DATA);
    trustData.dwUIChoice = WTD_UI_NONE;
    trustData.fdwRevocationChecks = WTD_REVOKE_WHOLECHAIN;
    trustData.dwUnionChoice = WTD_CHOICE_FILE;
    trustData.pFile = &fileInfo;
    
    GUID policyGUID = WINTRUST_ACTION_GENERIC_VERIFY_V2;
    
    LONG status = WinVerifyTrust(NULL, &policyGUID, &trustData);
    
    return (status == ERROR_SUCCESS);
}
```

---

[🏠 Back to Home](Home.md) | [🔧 C++ Implementation](CPP-Implementation.md) | [🏗️ Architecture](Architecture-Overview.md)
