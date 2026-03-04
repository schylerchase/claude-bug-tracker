---
name: bug-tracking
description: Use when debugging recurring issues, reviewing code in areas with prior fix history, or before modifying files that have been fixed multiple times
---

# Bug Regression Tracking

## Overview

Repeated fixes in the same code area signal fragile code. This skill helps identify fragile areas from git history and prevent regressions.

**Core principle:** Before modifying code, check if the area has a fix history. High fix-frequency areas need extra care and regression tests.

## When to Use

- Debugging a bug that feels familiar or recurring
- About to modify a file that has been fixed before
- Reviewing code changes that touch multiple previously-fixed areas
- Starting a session in a project with a bugs.md file

## Quick Reference

| Action | How |
|--------|-----|
| Scan for fragile areas | `/bug-track scan` |
| Check current bugs | `/bug-track list` |
| Log a new bug | `/bug-track add <description>` |
| Mark bug resolved | `/bug-track resolve <id>` |
| Commit convention | `fix(scope): description` |

## Fragile Area Detection

A file is "fragile" when it accumulates `fix(` commits disproportionately. The scan-commits script counts fix commits per file over the last 100 commits and flags files with 3+ fixes.

## Commit Convention

Use `fix(scope): description` for all bug fixes. This makes fix history searchable.

Scope maps to directory structure:
- `src/gui/` -> `fix(gui):`
- `src/core/` -> `fix(core):`
- `src/web/` -> `fix(web):`
- `tests/` -> `fix(tests):`

See @commit-conventions.md for full mapping rules.

## Integration with bugs.md

Each project maintains a `bugs.md` at root with:
- **Active** bugs being tracked
- **Fragile Areas** auto-generated from git history
- **Watch on Refactor** patterns that break when modified
- **Resolved** bugs moved from Active

The SessionStart hook auto-scans and updates this file.
