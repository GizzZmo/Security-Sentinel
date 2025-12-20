# Advanced GitHub Workflow System Documentation

## Overview

Security Sentinel now features a comprehensive GitHub Actions workflow system providing automated build, testing, documentation generation, asset management, and artifact handling across all platforms.

## Workflow Architecture

### 🏗️ Build System

#### 1. Advanced Build Matrix (`build-matrix.yml`)
Multi-platform build system with intelligent caching and parallel execution.

**Features:**
- **Multi-Platform Builds**: Windows, Linux, and macOS support
- **Build Configurations**: Debug and Release builds
- **Advanced Caching**: CMake, Go, and NPM dependency caching
- **Performance Metrics**: Build time and size tracking
- **Parallel Execution**: Up to 4 parallel build jobs

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Manual workflow dispatch

**Artifacts Produced:**
- `cpp-{os}-{config}` - C++ binaries for each platform/configuration
- `go-{os}` - Go module builds with coverage reports
- `web-build` - Optimized web interface bundle

**Build Matrix:**
```
Windows: VS 2022, x64, Debug/Release
Linux:   GCC, x64, Debug/Release  
macOS:   Clang, x64, Debug/Release
```

### 📦 Asset Management System

#### 2. Asset Management (`asset-management.yml`)
Comprehensive asset packaging with checksums and metadata.

**Features:**
- **Checksum Generation**: SHA-256 for all assets
- **Metadata Creation**: JSON metadata for each release
- **Installation Guides**: Platform-specific instructions
- **Asset Catalog**: Comprehensive download directory

**Triggers:**
- Release creation/publication
- Manual workflow dispatch with version input

**Artifacts Produced:**
- `checksums` - SHA256SUMS.txt and CHECKSUMS.md
- `asset-metadata` - METADATA.json and INSTALL.md
- `asset-catalog` - ASSET_CATALOG.md
- `security-sentinel-source-*.tar.gz` - Source code archives

**Generated Files:**
- `METADATA.json` - Release metadata with platform requirements
- `INSTALL.md` - Installation instructions for all platforms
- `ASSET_CATALOG.md` - Complete asset listing
- `SHA256SUMS.txt` - Machine-readable checksums
- `CHECKSUMS.md` - Human-readable checksum documentation

### 🏅 Badge System

#### 3. Badge Generation (`badge-generation.yml`)
Dynamic badge generation for project metrics and status.

**Features:**
- **Dynamic Metrics**: Real-time LOC, file counts, version info
- **Shields.io Integration**: JSON endpoint format for shields.io
- **Workflow Status**: Badges for all GitHub Actions workflows
- **Multi-Language Support**: Separate badges for C++, Go, and TypeScript

**Triggers:**
- Push to `main` branch
- Release publication
- Weekly schedule (Sunday midnight)
- Manual workflow dispatch

**Badges Generated:**
- `version.json` - Current version badge
- `loc.json` - Total lines of code
- `cpp.json` - C++ file count
- `go.json` - Go file count
- `typescript.json` - TypeScript file count

**Usage Example:**
```markdown
![Version](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/GizzZmo/Security-Sentinel/main/badges/version.json)
![LOC](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/GizzZmo/Security-Sentinel/main/badges/loc.json)
```

### 📚 Documentation System

#### 4. Documentation Generation (`documentation-generation.yml`)
Automated API documentation for all codebase languages.

**Features:**
- **C++ Documentation**: Doxygen-generated API docs with call graphs
- **TypeScript Documentation**: TypeDoc for React components and services
- **Go Documentation**: godoc-style documentation
- **Dependency Graphs**: Visual dependency trees
- **Documentation Hub**: Centralized documentation portal

**Triggers:**
- Push to `main` branch with relevant file changes
- Manual workflow dispatch

**Documentation Outputs:**

##### C++ API Documentation
- Generated with **Doxygen 1.9+**
- Call graphs and caller graphs
- Class hierarchy diagrams
- File dependency graphs
- Full API reference

##### TypeScript API Documentation  
- Generated with **TypeDoc**
- Component documentation
- Service layer documentation
- Type definitions
- Interface documentation

##### Go Documentation
- Package documentation
- Function references
- Type documentation
- Example code

##### Dependency Graph
- NPM dependency tree
- Production vs dev dependencies
- Dependency count statistics
- Interactive HTML visualization

**Documentation Hub:**
Beautiful HTML portal at `docs/index.html` providing:
- Links to all API documentation
- Quick navigation between languages
- Modern, responsive design
- Direct links to source code

### 🧹 Artifact Management

#### 5. Artifact Cleanup (`artifact-cleanup.yml`)
Automated artifact lifecycle management and storage optimization.

**Features:**
- **Artifact Listing**: Comprehensive artifact inventory
- **Automated Cleanup**: Remove artifacts older than N days
- **Health Monitoring**: Storage usage tracking
- **Size Optimization**: Identify oversized artifacts

**Triggers:**
- Weekly schedule (Sunday 2 AM UTC)
- Manual workflow dispatch with retention configuration

**Cleanup Policy:**
- Default retention: 30 days
- Configurable via workflow input
- Respects artifact expiration settings
- Reports freed storage space

**Health Checks:**
- Total storage usage monitoring
- Large artifact detection (>500MB)
- Expired artifact cleanup
- Storage limit warnings (approaching 10GB)

## Artifact Retention Policies

| Artifact Type | Retention | Notes |
|--------------|-----------|-------|
| Build artifacts | 14 days | Regular CI builds |
| Release artifacts | 90 days | Release builds and assets |
| Documentation | 90 days | API docs and guides |
| Badges | 365 days | Badge JSON files |
| Checksums | 90 days | Release checksums |
| Test coverage | 14 days | Coverage reports |

## Integration with Existing Workflows

The advanced workflow system integrates seamlessly with existing workflows:

### CI/CD Integration
- **ci.yml**: Main CI pipeline continues to run
- **ci-web.yml**: Web builds supplemented by build-matrix
- **ci-cpp.yml**: C++ builds enhanced with matrix builds
- **release.yml**: Now uses asset management system

### Documentation Integration
- **docs.yml**: Basic docs continue running
- **documentation-generation.yml**: Adds comprehensive API docs
- **deploy-pages.yml**: Can deploy generated documentation

### Security Integration
- **security.yml**: Continues security scanning
- Asset checksums provide integrity verification
- Badge system shows security scan status

## Best Practices

### For Developers

1. **Check Build Status**: Monitor build-matrix before merging PRs
2. **Review Artifacts**: Download and test artifacts from PR builds
3. **Update Documentation**: Docs auto-generate but review for accuracy
4. **Verify Badges**: Ensure badges reflect current project state

### For Maintainers

1. **Release Process**:
   - Tag release with `v*.*.*` format
   - Asset management auto-generates packages
   - Verify checksums before publishing
   - Update release notes with asset catalog

2. **Artifact Management**:
   - Monitor storage usage weekly
   - Adjust retention policies as needed
   - Clean up large artifacts manually if needed

3. **Documentation Updates**:
   - Review generated docs after major changes
   - Update doc hub index if needed
   - Keep wiki synchronized with generated docs

## Troubleshooting

### Build Matrix Issues

**Problem**: Build fails on specific platform
```yaml
Solution: Check platform-specific logs in workflow output
Look for: Configure CMake step errors
```

**Problem**: Caching not working
```yaml
Solution: Clear cache by changing cache key
Modify: hashFiles pattern in cache action
```

### Documentation Generation Issues

**Problem**: Doxygen fails to generate docs
```yaml
Solution: Check Doxyfile configuration
Verify: Source file paths are correct
```

**Problem**: TypeDoc fails
```yaml
Solution: Check tsconfig.json configuration
Verify: Node modules are installed
```

### Badge Generation Issues

**Problem**: Badges show old data
```yaml
Solution: Re-run badge-generation workflow
Check: Badge JSON files are committed to main
```

### Artifact Cleanup Issues

**Problem**: Artifacts not being deleted
```yaml
Solution: Check retention_days input
Verify: Workflow has proper permissions
```

## Performance Metrics

### Build Performance
- **C++ Build**: ~5-10 minutes per platform
- **Go Build**: ~2-3 minutes per platform
- **Web Build**: ~3-5 minutes
- **Total Matrix**: ~15-25 minutes parallel

### Documentation Generation
- **C++ Doxygen**: ~2-3 minutes
- **TypeScript TypeDoc**: ~1-2 minutes
- **Go Documentation**: ~1 minute
- **Total Documentation**: ~5-7 minutes

### Storage Usage
- **Per Build**: ~100-500 MB
- **Documentation**: ~50-100 MB
- **Badges**: <1 MB
- **Total Active**: ~2-5 GB (varies with retention)

## Future Enhancements

Planned improvements for the workflow system:

1. **Coverage Reporting**: Code coverage badges and reports
2. **Performance Benchmarks**: Automated performance testing
3. **Cross-Platform Testing**: Integration tests on all platforms
4. **Release Automation**: Fully automated release process
5. **Artifact Signing**: GPG signatures for all releases
6. **Container Builds**: Docker image generation
7. **Benchmark History**: Performance trend tracking

## Support

For issues with workflows:

1. Check workflow logs in GitHub Actions tab
2. Review this documentation
3. Check existing GitHub Issues
4. Create new issue with `workflow` label

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Doxygen Documentation](https://www.doxygen.nl/manual/)
- [TypeDoc Documentation](https://typedoc.org/)
- [Shields.io Badge Service](https://shields.io/)
- [CMake Documentation](https://cmake.org/documentation/)

---

**Last Updated**: December 2024  
**Version**: 1.1.0  
**Maintainer**: GizzZmo
