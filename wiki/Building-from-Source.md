# Building from Source

Complete guide to building Security Sentinel from source code for both C++ and web interfaces.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [C++ Application Build](#c-application-build)
- [Go Core Module Build](#go-core-module-build)
- [Web Interface Build](#web-interface-build)
- [Platform-Specific Instructions](#platform-specific-instructions)
- [Build Configurations](#build-configurations)
- [Troubleshooting](#troubleshooting)
- [Verification](#verification)

---

## Prerequisites

### All Platforms

**Version Control**:
```bash
git --version  # Git 2.30+
```

**Download Source**:
```bash
git clone https://github.com/GizzZmo/Security-Sentinel.git
cd Security-Sentinel
```

---

## C++ Application Build

### Windows Build

**Requirements**:
- Visual Studio 2019/2022 with C++ development tools
- CMake 3.16 or later
- Windows SDK 10.0.19041.0 or later
- Go 1.24+ (for Go core module)

**Step 1: Install Visual Studio**
```powershell
# Download from: https://visualstudio.microsoft.com/downloads/
# Select "Desktop development with C++"
# Include: MSVC v142/v143, Windows SDK, CMake tools
```

**Step 2: Install CMake**
```powershell
# Download from: https://cmake.org/download/
# Or use chocolatey:
choco install cmake

# Verify installation
cmake --version  # Should be 3.16+
```

**Step 3: Install Go**
```powershell
# Download from: https://go.dev/dl/
# Or use chocolatey:
choco install golang

# Verify installation
go version  # Should be 1.24+
```

**Step 4: Build Go Core Module**
```powershell
cd core-go
go build -buildmode=c-archive -o core.a
cd ..
```

**Step 5: Configure CMake**
```powershell
mkdir build
cd build
cmake .. -G "Visual Studio 17 2022" -A x64
# Or for Visual Studio 2019:
# cmake .. -G "Visual Studio 16 2019" -A x64
```

**Step 6: Build**
```powershell
# Debug build
cmake --build . --config Debug

# Release build (recommended)
cmake --build . --config Release

# Executable location:
# build\Debug\SecuritySentinel.exe
# build\Release\SecuritySentinel.exe
```

**Step 7: Run**
```powershell
# Create config.ini in build directory
cd Release
echo [gemini] > config.ini
echo api_key=YOUR_API_KEY_HERE >> config.ini

# Run as administrator
.\SecuritySentinel.exe
```

### Linux Build

**Requirements**:
- GCC 9+ or Clang 10+
- CMake 3.16+
- Development libraries (see below)
- Go 1.24+

**Step 1: Install Dependencies (Ubuntu/Debian)**
```bash
# Update package list
sudo apt-get update

# Install build tools
sudo apt-get install -y \
  build-essential \
  cmake \
  git \
  libcurl4-openssl-dev \
  nlohmann-json3-dev \
  golang-go

# Verify installations
gcc --version     # GCC 9+
cmake --version   # CMake 3.16+
go version        # Go 1.24+
```

**Step 1 (Alternative): Fedora/RHEL**
```bash
sudo dnf install -y \
  gcc \
  gcc-c++ \
  cmake \
  git \
  libcurl-devel \
  json-devel \
  golang

# Verify installations
gcc --version
cmake --version
go version
```

**Step 2: Build Go Core Module**
```bash
cd core-go
go build -buildmode=c-archive -o core.a
cd ..
```

**Step 3: Configure CMake**
```bash
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
# Or for debug:
# cmake .. -DCMAKE_BUILD_TYPE=Debug
```

**Step 4: Build**
```bash
# Use all available cores
cmake --build . -j$(nproc)

# Or specify core count
# cmake --build . -j4

# Executable location: build/SecuritySentinel
```

**Step 5: Install (Optional)**
```bash
# Install to /usr/local/bin
sudo cmake --install .

# Or create symlink
sudo ln -s $(pwd)/SecuritySentinel /usr/local/bin/security-sentinel
```

**Step 6: Run**
```bash
# Create config.ini
cat > config.ini << EOF
[gemini]
api_key=YOUR_API_KEY_HERE
EOF

# Set permissions
chmod 600 config.ini

# Run with sudo (required for system monitoring)
sudo ./SecuritySentinel
```

---

## Go Core Module Build

The Go core module provides performance-critical operations.

### Standalone Build

```bash
cd core-go

# Build as static library (for C++ integration)
go build -buildmode=c-archive -o core.a

# Build as shared library (alternative)
go build -buildmode=c-shared -o core.so

# Verify build
ls -lh core.a core.so
```

### Build with Tests

```bash
cd core-go

# Run Go tests
go test -v ./...

# Run with coverage
go test -v -cover ./...

# Benchmarks
go test -bench=. ./...
```

### Cross-Compilation (Advanced)

```bash
# Build for Windows from Linux
GOOS=windows GOARCH=amd64 go build -buildmode=c-archive -o core_windows.a

# Build for Linux from Windows
$env:GOOS="linux"; $env:GOARCH="amd64"
go build -buildmode=c-archive -o core_linux.a
```

---

## Web Interface Build

### Requirements

- Node.js 20.19+ (required for Vite 7)
- npm 10+ or yarn 1.22+

### Installation

**Step 1: Install Node.js**
```bash
# Download from: https://nodejs.org/
# Or use nvm (recommended):
nvm install 20.19.0
nvm use 20.19.0

# Verify
node --version  # v20.19.0+
npm --version   # 10.0.0+
```

**Step 2: Install Dependencies**
```bash
# Using npm
npm install

# Or using yarn
yarn install

# Verify installation
npm list --depth=0
```

### Development Build

```bash
# Start development server
npm run dev

# Server starts on http://localhost:5173
# Hot-reload enabled - changes reflect immediately
```

### Production Build

```bash
# Create optimized production build
npm run build

# Output directory: dist/
# Contains optimized HTML, CSS, JS, and assets
```

### Preview Production Build

```bash
# Build first
npm run build

# Preview the production build
npm run preview

# Opens on http://localhost:4173
```

### Build Options

**Environment Variables**:
```bash
# .env.local for development
GEMINI_API_KEY=your_api_key_here
VITE_API_ENDPOINT=https://api.example.com

# .env.production for production builds
GEMINI_API_KEY=production_key_here
```

**Custom Build**:
```bash
# Build with source maps (debugging)
npm run build -- --sourcemap

# Build with analysis
npm run build -- --mode analyze
```

---

## Platform-Specific Instructions

### Windows-Specific

**Using vcpkg (Package Manager)**:
```powershell
# Install vcpkg
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat

# Install dependencies
.\vcpkg install nlohmann-json:x64-windows

# Integrate with Visual Studio
.\vcpkg integrate install

# Build with vcpkg toolchain
cmake .. -G "Visual Studio 17 2022" -A x64 `
  -DCMAKE_TOOLCHAIN_FILE="C:\path\to\vcpkg\scripts\buildsystems\vcpkg.cmake"
```

**Using MSBuild Directly**:
```powershell
# Generate Visual Studio solution
cmake .. -G "Visual Studio 17 2022"

# Build with MSBuild
msbuild SecuritySentinel.sln /p:Configuration=Release /p:Platform=x64
```

### Linux-Specific

**Using Make Instead of CMake**:
```bash
# Generate Makefiles
cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release

# Build
make -j$(nproc)

# Install
sudo make install
```

**Custom Install Directory**:
```bash
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/security-sentinel
make -j$(nproc)
sudo make install
```

**Creating .deb Package (Debian/Ubuntu)**:
```bash
# Install packaging tools
sudo apt-get install checkinstall

# Build and create package
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo checkinstall --pkgname=security-sentinel \
  --pkgversion=1.1 \
  --pakdir=..
```

**Creating .rpm Package (Fedora/RHEL)**:
```bash
# Install packaging tools
sudo dnf install rpm-build

# Create package structure
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Create spec file and build
rpmbuild -ba security-sentinel.spec
```

---

## Build Configurations

### Debug Configuration

**C++ Debug Build**:
```bash
cmake .. -DCMAKE_BUILD_TYPE=Debug
cmake --build . --config Debug
```

Features:
- Debug symbols included
- No optimization (-O0)
- Assertions enabled
- Verbose logging
- Larger executable size

Use for:
- Development
- Debugging crashes
- Analyzing performance issues

### Release Configuration

**C++ Release Build**:
```bash
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release
```

Features:
- Optimizations enabled (-O3)
- Debug symbols stripped
- Assertions disabled
- Minimal logging
- Smaller executable size

Use for:
- Production deployment
- Performance testing
- Distribution

### RelWithDebInfo Configuration

**Optimized with Debug Info**:
```bash
cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build .
```

Features:
- Optimizations enabled (-O2)
- Debug symbols included
- Good performance
- Still debuggable

Use for:
- Profiling
- Performance analysis
- Production debugging

---

## Troubleshooting

### Common Build Errors

**CMake Error: "Could not find CMakeLists.txt"**
```bash
# Make sure you're in the correct directory
cd /path/to/Security-Sentinel
mkdir build && cd build
cmake ..
```

**CMake Error: "CMake 3.16 or higher is required"**
```bash
# Update CMake
# Windows:
choco upgrade cmake
# Linux:
sudo apt-get install cmake
```

**Go Build Error: "cannot find package"**
```bash
# Update Go modules
cd core-go
go mod tidy
go mod download
```

**Linker Error: "undefined reference to..."**
```bash
# Rebuild Go core module
cd core-go
go build -buildmode=c-archive -o core.a
cd ..

# Clean and rebuild
rm -rf build
mkdir build && cd build
cmake ..
cmake --build .
```

**Node.js Error: "Module not found"**
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

**Windows: "LINK : fatal error LNK1181: cannot open input file"**
```powershell
# Ensure Go core is built
cd core-go
go build -buildmode=c-archive -o core.a
cd ..\build
cmake .. -G "Visual Studio 17 2022"
```

### Build Performance Issues

**Slow CMake Configuration**:
```bash
# Use Ninja generator (faster)
cmake .. -G Ninja
ninja
```

**Slow Compilation**:
```bash
# Use parallel builds
cmake --build . -j$(nproc)  # Linux
cmake --build . -j8          # Windows
```

**Large Build Directory**:
```bash
# Clean old builds
cmake --build . --target clean

# Or remove entirely
cd ..
rm -rf build
mkdir build && cd build
```

---

## Verification

### Post-Build Checks

**C++ Application**:
```bash
# Check executable exists
ls -lh SecuritySentinel  # Linux
dir SecuritySentinel.exe  # Windows

# Check dependencies (Linux)
ldd SecuritySentinel

# Check dependencies (Windows)
dumpbin /dependents SecuritySentinel.exe

# Verify version
./SecuritySentinel --version
```

**Go Core Module**:
```bash
cd core-go

# Run tests
go test -v ./...

# Check built artifacts
ls -lh core.a core.so
```

**Web Interface**:
```bash
# Verify build output
ls -lh dist/

# Check bundle size
du -sh dist/
```

### Running Tests

**C++ Tests**:
```bash
# Build test executable
cd build
cmake --build . --target test_enhancements

# Run tests
./test_enhancements
```

**Go Tests**:
```bash
cd core-go
go test -v ./...
go test -race ./...  # Check for race conditions
```

**Web Tests**:
```bash
npm test              # Run test suite
npm run test:ui       # Interactive test UI
npm run test:coverage # Generate coverage report
```

### Performance Verification

**Startup Time**:
```bash
time ./SecuritySentinel  # Linux
Measure-Command { .\SecuritySentinel.exe }  # Windows PowerShell
```

**Memory Usage**:
```bash
# Monitor during runtime
top -p $(pgrep SecuritySentinel)  # Linux
tasklist /fi "imagename eq SecuritySentinel.exe"  # Windows
```

**Binary Size**:
```bash
ls -lh SecuritySentinel  # Should be ~1-2 MB
```

---

## Next Steps

After successful build:

1. **Configuration**: Create `config.ini` with your API key
2. **Testing**: Run the application and verify functionality
3. **Documentation**: Review [Quick Start](Quick-Start.md) guide
4. **Development**: See [Development Setup](Development-Setup.md) for IDE configuration

---

## Additional Resources

- [Development Setup](Development-Setup.md) - IDE and tools configuration
- [Contributing Guidelines](Contributing-Guidelines.md) - Code contribution guide
- [Architecture Overview](Architecture-Overview.md) - System design
- [Debugging Guide](Debugging-Guide.md) - Troubleshooting techniques

---

**Last Updated**: January 2025  
**Version**: 1.1+

[🏠 Back to Home](Home.md) | [📖 Full Documentation](Home.md)
