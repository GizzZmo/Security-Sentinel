# Workflow Architecture Diagram

## System Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     Security Sentinel Workflow System                       │
└─────────────────────────────────────────────────────────────────────────────┘

┌───────────────────┐  ┌───────────────────┐  ┌───────────────────┐
│   📝 Code Push    │  │   🔀 Pull Request │  │   🏷️  Git Tag    │
│   (main/develop)  │  │   (any → main)    │  │   (v*.*.*)        │
└─────────┬─────────┘  └─────────┬─────────┘  └─────────┬─────────┘
          │                       │                       │
          ▼                       ▼                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          Workflow Triggers                                   │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────── Build & Test ────────────────────┐
│                                                       │
│  ┌─────────────────┐      ┌──────────────────┐      │
│  │ 🏗️ Build Matrix  │      │ 🔨 C++ Build CI  │      │
│  │ • Multi-platform │      │ • Windows MSVC   │      │
│  │ • Parallel jobs  │      │ • Linux GCC      │      │
│  │ • Matrix build   │      │ • Static analysis│      │
│  └────────┬─────────┘      └────────┬─────────┘      │
│           │                         │                │
│           │    ┌──────────────────┐ │                │
│           └────│ 🌐 Web Build CI  │─┘                │
│                │ • React build    │                  │
│                │ • Type checking  │                  │
│                │ • Multi-version  │                  │
│                └──────────────────┘                  │
└───────────────────────────────────────────────────────┘

┌──────────────────── Security & Quality ─────────────────┐
│                                                          │
│  ┌───────────────┐     ┌──────────────────┐            │
│  │ 🔐 Security   │     │ 🧹 Code Quality  │            │
│  │ • CodeQL      │────▶│ • Linting        │            │
│  │ • Dependency  │     │ • Type checking  │            │
│  │ • Secret scan │     │ • Style check    │            │
│  └───────────────┘     └──────────────────┘            │
│                                                          │
└──────────────────────────────────────────────────────────┘

┌──────────────────── Documentation ──────────────────────┐
│                                                          │
│  ┌──────────────────┐       ┌───────────────────┐      │
│  │ 📚 Docs Generate │       │ 📝 Markdown Docs  │      │
│  │ • C++ (Doxygen)  │──────▶│ • Link checking   │      │
│  │ • TypeScript     │       │ • Spell check     │      │
│  │ • Go (godoc)     │       │ • Format check    │      │
│  │ • Dep graphs     │       └───────────────────┘      │
│  └──────────────────┘                                   │
│           │                                              │
│           ▼                                              │
│  ┌──────────────────┐                                   │
│  │ 🌐 Deploy Pages  │                                   │
│  │ • GitHub Pages   │                                   │
│  │ • Documentation  │                                   │
│  └──────────────────┘                                   │
└──────────────────────────────────────────────────────────┘

┌──────────────────── Release & Assets ───────────────────┐
│                                                          │
│  ┌──────────────────┐                                   │
│  │ 🏷️ Release        │                                   │
│  │ • Windows build  │                                   │
│  │ • Linux build    │                                   │
│  │ • Web package    │                                   │
│  └────────┬─────────┘                                   │
│           │                                              │
│           ▼                                              │
│  ┌──────────────────┐       ┌───────────────────┐      │
│  │ 📦 Asset Mgmt    │       │ 🏅 Badge Gen      │      │
│  │ • Checksums      │       │ • Version badge   │      │
│  │ • Metadata       │       │ • LOC badge       │      │
│  │ • Install guide  │       │ • Build status    │      │
│  │ • Catalog        │       │ • Metrics         │      │
│  └──────────────────┘       └───────────────────┘      │
└──────────────────────────────────────────────────────────┘

┌──────────────────── Maintenance ────────────────────────┐
│                                                          │
│  ┌──────────────────┐       ┌───────────────────┐      │
│  │ 🧹 Artifact      │       │ 📊 PR Automation  │      │
│  │    Cleanup       │       │ • Auto-label      │      │
│  │ • Storage mgmt   │       │ • Size check      │      │
│  │ • Health check   │       │ • Validation      │      │
│  │ • Auto-cleanup   │       │ • Comments        │      │
│  └──────────────────┘       └───────────────────┘      │
└──────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              Outputs & Artifacts                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│   Binaries   │  │     Docs     │  │    Badges    │  │   Reports    │
│              │  │              │  │              │  │              │
│ • Windows    │  │ • C++ API    │  │ • Version    │  │ • Coverage   │
│ • Linux      │  │ • TS API     │  │ • Build      │  │ • Security   │
│ • macOS      │  │ • Go API     │  │ • Quality    │  │ • Quality    │
│ • Web dist   │  │ • Dep Graph  │  │ • Metrics    │  │ • Artifacts  │
└──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘
```

## Workflow Relationships

### Parallel Execution (Independent)

```
Push Event
    ├─── Build Matrix (15-25 min)
    ├─── CI Pipeline (8-12 min)
    ├─── Security Scan (10-15 min)
    └─── Documentation (5-7 min)
```

### Sequential Execution (Dependent)

```
Release Tag
    │
    ├─── Build Release (20-30 min)
    │        │
    │        └─── Asset Management (3-5 min)
    │                 │
    │                 └─── Create GitHub Release (1-2 min)
    │
    └─── Badge Generation (1-2 min)
```

### Scheduled Execution

```
Weekly Schedule (Sunday 2 AM UTC)
    ├─── Security Scanning
    ├─── Artifact Cleanup
    └─── Badge Generation
```

## Data Flow

```
┌──────────────┐
│ Source Code  │
└──────┬───────┘
       │
       ├───────────────┐
       │               │
       ▼               ▼
┌──────────────┐  ┌──────────────┐
│ Build System │  │ Analysis     │
└──────┬───────┘  └──────┬───────┘
       │                  │
       │                  ▼
       │          ┌──────────────┐
       │          │ Reports      │
       │          │ • SARIF      │
       │          │ • Coverage   │
       │          └──────────────┘
       │
       ▼
┌──────────────┐
│ Artifacts    │
│ • Binaries   │
│ • Packages   │
│ • Docs       │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Distribution │
│ • GitHub     │
│ • Pages      │
│ • Releases   │
└──────────────┘
```

## Artifact Lifecycle

```
┌─────────────────────────────────────────────────────────┐
│                    Artifact Timeline                     │
└─────────────────────────────────────────────────────────┘

Day 0        Day 14       Day 30         Day 90      Day 365
  │            │            │              │            │
  │◄──────────►│◄──────────►│◄────────────►│◄──────────►│
  │  CI Builds │   Cleanup  │   Release    │   Badges   │
  │  (active)  │ (evaluated)│   Assets     │  (persist) │
  │            │            │  (archived)  │            │
  │            │            │              │            │
  └────────────┴────────────┴──────────────┴────────────┘
```

## Cache Strategy

```
┌─────────────────────────────────────────────────────────┐
│                      Cache Layers                        │
└─────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ Level 1: Package Managers                                │
│ • NPM: ~/.npm (keyed by package-lock.json)              │
│ • Go: ~/go/pkg/mod (keyed by go.sum)                    │
│ • CMake: build/ (keyed by CMakeLists.txt)               │
└──────────────────────────────────────────────────────────┘
                            ▼
┌──────────────────────────────────────────────────────────┐
│ Level 2: Build Outputs                                   │
│ • Compiled objects                                       │
│ • Intermediate files                                     │
│ • Generated code                                         │
└──────────────────────────────────────────────────────────┘
                            ▼
┌──────────────────────────────────────────────────────────┐
│ Level 3: Artifacts (Temporary Storage)                   │
│ • 14-90 day retention                                    │
│ • Auto-cleanup on expiry                                 │
│ • Download on-demand                                     │
└──────────────────────────────────────────────────────────┘
```

## Security Workflow

```
┌─────────────────────────────────────────────────────────┐
│              Security Scanning Pipeline                  │
└─────────────────────────────────────────────────────────┘

Source Code
    │
    ├──────────────────────────────────────┐
    │                                      │
    ▼                                      ▼
┌─────────────┐                    ┌─────────────┐
│ SAST        │                    │ SCA         │
│ • CodeQL    │                    │ • npm audit │
│ • Semgrep   │                    │ • Snyk      │
└─────┬───────┘                    └─────┬───────┘
      │                                  │
      │         ┌─────────────┐          │
      └────────▶│ Secret Scan │◀─────────┘
                │ • GitLeaks  │
                │ • TruffleHog│
                └─────┬───────┘
                      │
                      ▼
              ┌─────────────┐
              │ SARIF Report│
              │ Upload to   │
              │ GitHub      │
              └─────────────┘
```

---

**Legend:**
- 🏗️ Build workflows
- 🔐 Security workflows
- 📚 Documentation workflows
- 📦 Release workflows
- 🧹 Maintenance workflows
- ⏱️ Duration estimates shown in parentheses
