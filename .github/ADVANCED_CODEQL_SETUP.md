# CodeQL Configuration Note

This repository no longer uses an advanced CodeQL job in `.github/workflows/security.yml`.

## Current state

- `.github/workflows/security.yml` runs dependency, secret, and license scans.
- CodeQL is provided by GitHub repository **Default setup** in the Security tab.

## Migration context

This file is kept as a pointer so contributors do not reintroduce stale "advanced setup" instructions that conflict with Default setup.
